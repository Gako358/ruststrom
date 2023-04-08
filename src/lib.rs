use serde::{Deserialize, Serialize};
use serde_json::Result;

#[derive(Serialize, Deserialize, Debug)]
pub struct Message {
    src: String,
    dest: String,
    body: MessageBody,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct MessageBody {
    #[serde(rename = "type")]
    msg_type: String,
    msg_id: u64,
    echo: String,
    #[serde(skip_serializing_if = "Option::is_none")]
    in_reply_to: Option<u64>,
}

impl Message {
    pub fn from_json(json_str: &str) -> Result<Self> {
        serde_json::from_str(json_str)
    }

    pub fn to_json(&self) -> Result<String> {
        serde_json::to_string(self)
    }

    pub fn process_message(&mut self) {
        if self.body.msg_type == "echo" {
            self.body.msg_type = "echo_ok".to_string();
            self.body.in_reply_to = Some(self.body.msg_id);
            let temp = self.src.clone();
            self.src = self.dest.clone();
            self.dest = temp;
        }
    }
}
