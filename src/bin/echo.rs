use maelstrom::Message;
use std::io::{self, BufRead};

fn main() {
    let stdin = io::stdin();
    for line in stdin.lock().lines() {
        let line = line.unwrap();
        let mut message = Message::from_json(&line).expect("Failed to parse JSON");
        message.process_message();
        let response_json = message.to_json().expect("Failed to serialize JSON");
        println!("{}", response_json);
    }
}
