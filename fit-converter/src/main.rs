use fitparser;
use fitparser::de::{from_reader_with_options, DecodeOption};
use std::env;
use std::ffi::OsStr;
use std::fs::File;
use std::io;
use std::io::prelude::*;
use std::path::Path;

fn convert_fit_file(input: &Path) -> Result<(), Box<dyn std::error::Error>> {
    let mut fp = File::open(input)?;
    for data in fitparser::from_reader(&mut fp)? {
        // print the data in FIT file
        println!("{:#?}", data);
    }

    Ok(())
}

fn convert_files(input_dir: &Path, output_dir: &Path) -> io::Result<()> {
    for entry in input_dir.read_dir()? {
        let entry = entry?;
        let path = entry.path();
        if path.is_file() && path.extension() == Some(OsStr::new("fit")) {
            convert_fit_file(&path);
        }
    }
    Ok(())
}

fn main() {
    let args: Vec<String> = env::args().collect();
    match &args[..] {
        [_, input_dir, output_dir] => {
            print!("{} {}", input_dir, output_dir);
            convert_files(Path::new(input_dir), Path::new(output_dir));
        }

        _ => {
            println!("Usage: fit-converter <input-directory>");
            return;
        }
    }
}
