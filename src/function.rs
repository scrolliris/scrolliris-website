use std::collections::HashMap;
use std::fs;
use std::path::Path;

use fluent::{FluentBundle, FluentResource};
use tera::{Function, Value, from_value};

const SUPPORTED_LANGS: [&str; 1] = ["en-GB"];

lazy_static! {
    static ref FTL_TEXTS: HashMap<&'static str, String> = {
        let mut m = HashMap::new();
        let project_dir = Path::new(env!("CARGO_MANIFEST_DIR"));

        for lang in SUPPORTED_LANGS {
            let file = format!("{}.ftl", lang);
            let path = project_dir.join("src").join("text").join(file);
            let txt =
                fs::read_to_string(path).expect("failed to read .ftl file");
            m.insert(lang, txt);
        }
        m
    };
}

fn load_bundle(lang_name: &'static str) -> FluentBundle<FluentResource> {
    let lang_id = lang_name.parse().expect("failed to parse lang_id");
    let mut bundle = FluentBundle::new(vec![lang_id]);

    let txt = FTL_TEXTS.get(lang_name).unwrap();
    let resource = FluentResource::try_new(txt.to_owned())
        .expect("could not parse an FTL string");
    bundle
        .add_resource(resource)
        .expect("failed to add FTL resource to the bundle");
    bundle
}

// tera::Function
pub fn make_t(lang_name: &'static str) -> impl Function {
    Box::new(
        move |args: &HashMap<String, Value>| -> tera::Result<Value> {
            let bundle = load_bundle(lang_name);

            // value needs to be decoded with from_value()
            let msg = match args.get("key") {
                Some(val) => match from_value::<String>(val.clone()) {
                    Ok(v) => bundle.get_message(&v).unwrap(),
                    Err(e) => return Err(e.into()),
                },
                None => return Err(tera::Error::msg("unknown key")),
            };
            let ptn = msg.value().unwrap();

            let mut errors = vec![];
            let value = bundle.format_pattern(ptn, None, &mut errors);
            if !errors.is_empty() {
                let err_msg = format!("failed to format: {:?}", &errors);
                return Err(tera::Error::msg(err_msg));
            }
            Ok(value.into())
        },
    )
}
