use std::{
    env,
    fs::{File, OpenOptions},
    io::{BufRead, BufReader, LineWriter, Write},
    path::{Path, PathBuf},
};

fn main() {
    let args: Vec<String> = env::args().collect();

    let len = args.len();
    if len == 1 || len > 3 || (len == 2 && (args[1] == "--help" || args[1] == "-h")) {
        let message = "linker: flatten the shell import tree. \n\
        Usage: \n\
            1. linker ./path/to/entry_file \n\
            2. linker ./path/to/entry_file ./path/to/output_dir/output_file \n\n\
        Options:\n\
        -h/--help: Print help message and exit.\n";
        println!("{}", message);
        return;
    }

    let entry_file_path = (&args[1]).to_string();
    let output_file_path: String;
    if args.len() == 2 {
        output_file_path = PathBuf::from(&entry_file_path)
            .parent()
            .unwrap()
            .join("output.sh")
            .to_str()
            .unwrap()
            .to_string();
    } else {
        output_file_path = PathBuf::from(&args[2]).to_str().unwrap().to_string();
    }

    let mut linker = Linker::new(entry_file_path, output_file_path);
    linker.start();
    linker.stop();
}

#[cfg(test)]
mod tests {

    use super::*;
    #[test]
    fn run() {
        let mut linker = Linker::new("./aaa/main.sh".to_string(), "./aaa/output.sh".to_string());
        linker.start();
        linker.stop();
    }

    #[test]
    fn run_help() {
        let _args = vec!["app".to_string(), "--help".to_string()];
        let _args = vec![
            "app".to_string(),
            "/path/to/file".to_string(),
            "/path/to/output_dir/file".to_string(),
        ];
        let args = vec!["app".to_string(), "/path/to/dir/file".to_string()];

        let len = args.len();
        if len == 1 || len > 3 || (len == 2 && (args[1] == "--help" || args[1] == "-h")) {
            let message = "linker: flatten the shell import tree. \n\
            Usage: \n\
                1. linker ./path/to/entry_file \n\
                2. linker ./path/to/entry_file ./path/to/output_dir/output_file \n\n\
            Options:\n\
            -h/--help: Print help message and exit.\n";
            println!("{}", message);
            return;
        }

        let entry_file_path = (&args[1]).to_string();
        let output_file_path: String;
        if args.len() == 2 {
            output_file_path = PathBuf::from(&entry_file_path)
                .parent()
                .unwrap()
                .join("output.sh")
                .to_str()
                .unwrap()
                .to_string();
        } else {
            output_file_path = PathBuf::from(&args[2]).to_str().unwrap().to_string();
        }

        println!("{}", output_file_path)
    }
}

struct Linker {
    output_line_writer: Option<LineWriter<File>>,
    entry_file_name: String,
    output: PathBuf,
    root_dir: PathBuf,
}

impl Linker {
    fn new(path: String, output: String) -> Self {
        let path_buf = PathBuf::from(path);
        let entry_file_name = path_buf.file_name().unwrap().to_str().unwrap().to_string();
        let root_dir = path_buf.parent().unwrap().to_path_buf();
        Linker {
            output_line_writer: None,
            entry_file_name,
            root_dir,
            output: PathBuf::from(output),
        }
    }

    fn start(&mut self) {
        let file = OpenOptions::new()
            .write(true)
            .create(true)
            .open(self.output.as_path())
            .unwrap();
        self.output_line_writer = Some(LineWriter::new(file));
        self.write_line("#!/usr/bin/env bash\n".to_string());
        self.read_file(self.root_dir.join(&self.entry_file_name).as_path());
    }

    fn stop(&mut self) {
        self.output_line_writer.as_mut().unwrap().flush().unwrap();
    }

    fn read_file<P: AsRef<Path>>(&mut self, path: P) {
        let file = File::open(path).expect("");
        let lines = BufReader::new(file).lines();
        for result_line in lines {
            if let Ok(line) = result_line {
                self.handle_line(line);
            }
        }
    }

    fn handle_line(&mut self, line: String) {
        // Ignore
        let empty_1 = line.starts_with("#!/usr/bin/env bash");
        let empty_2 = line.starts_with("# shellcheck disable=SC1091");
        if empty_1 || empty_2 {
            return;
        }

        // Unflod
        if line.starts_with("source ") {
            let (_, p) = line.split_at(7);
            return self.read_file(self.root_dir.join(p).as_path()); // check tail call.
        }

        // Write normally
        self.write_line(line);
    }

    fn write_line(&mut self, line: String) {
        if let Some(w) = self.output_line_writer.as_mut() {
            w.write_all(line.as_bytes()).unwrap();
            w.write_all(b"\n").unwrap();
        }
    }
}
