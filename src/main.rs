use std::fs;
use std::io;
use std::path;
use std::process;

use tera::{Context, Tera};

#[macro_use]
extern crate lazy_static;

const DST_DIR: &str = "./dst";

const TITLE: &str = "Scrolliris";

lazy_static! {
    pub static ref TEMPLATES: Tera = {
        let mut data = match Tera::new("src/template/*.html") {
            Ok(t) => t,
            Err(e) => {
                eprintln!("err: {}", e);
                process::exit(1);
            }
        };
        data.autoescape_on(vec![".html"]);
        data
    };
}

#[derive(Debug)]
enum Error {
    IoError(io::Error),
    RenderingError(tera::Error),
}

impl From<io::Error> for Error {
    fn from(e: io::Error) -> Self {
        Self::IoError(e)
    }
}

impl From<tera::Error> for Error {
    fn from(e: tera::Error) -> Self {
        Self::RenderingError(e)
    }
}

fn main() -> Result<(), Error> {
    let dst = path::Path::new(&DST_DIR);

    let mut ctx = Context::new();
    ctx.insert("title", TITLE);
    ctx.insert("description", "");
    ctx.insert("keywords", "");
    ctx.insert("author", "");

    let res = TEMPLATES.render("index.html", &ctx)?;
    fs::write(dst.join("index.html"), res)?;
    Ok(())
}
