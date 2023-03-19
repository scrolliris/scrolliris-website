use std::collections::HashMap;
use std::fs;
use std::path::Path;

use fluent::{FluentArgs, FluentBundle, FluentResource};
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
            let msg = match args.get("_key") {
                Some(val) => match from_value::<String>(val.clone()) {
                    Ok(v) => {
                        bundle.get_message(&v).expect("failed to get a message")
                    }
                    Err(e) => return Err(e.into()),
                },
                None => panic!("invalid args"),
            };
            let ptn = msg.value().unwrap();

            let mut extra = FluentArgs::new();
            for (k, v) in args.iter() {
                if k.starts_with("_") {
                    continue;
                }
                extra.set(k, v.to_string());
            }
            let mut errors = vec![];
            let value = bundle.format_pattern(ptn, Some(&extra), &mut errors);
            if !errors.is_empty() {
                let err_msg = format!("failed to format: {:?}", &errors);
                return Err(tera::Error::msg(err_msg));
            }
            Ok(value.into())
        },
    )
}

#[cfg(test)]
mod test {
    use super::*;

    use tera::to_value;

    #[test]
    #[should_panic]
    fn test_make_t_invalid_lang_name() {
        let f = make_t("invalid");
        let args: HashMap<String, Value> =
            HashMap::from([("_key".to_string(), to_value("title").unwrap())]);
        let _ = f.call(&args);
    }

    #[test]
    #[should_panic]
    fn test_make_t_wrong_args() {
        let f = make_t("en-GB");
        let args: HashMap<String, Value> = HashMap::from([(
            "value".to_string(),
            to_value("get-started-title").unwrap(),
        )]);
        let _ = f.call(&args);
    }

    #[test]
    #[should_panic]
    fn test_make_t_unknown_translation_key() {
        let f = make_t("en-GB");
        let args: HashMap<String, Value> = HashMap::from([(
            "_key".to_string(),
            to_value("unknown-key").unwrap(),
        )]);
        let _ = f.call(&args);
    }

    #[test]
    fn test_make_t() {
        let f = make_t("en-GB");
        let args: HashMap<String, Value> = HashMap::from([(
            "_key".to_string(),
            to_value("get-started-title").unwrap(),
        )]);
        let result = f.call(&args);
        assert!(result.is_ok());

        let value: String =
            from_value(result.ok().unwrap()).expect("failed to get a text");
        assert_eq!(value, "Try Demo");
    }
}
