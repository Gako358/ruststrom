# Challenge #1: Echo

Our first challenge is more of a "getting started" guide" to get the hang of working with Maelstrom.

## Specification

n this challenge, your node will receive an "echo" message from Maelstrom that looks like this:
```
{
  "src": "c1",
  "dest": "n1",
  "body": {
    "type": "echo",
    "msg_id": 1,
    "echo": "Please echo 35"
  }
}
```
Nodes & clients are sequentially numbered (e.g. n1, n2, etc). Nodes are prefixed with "n" and external clients are prefixed with "c". Message IDs are unique per source node but that is handled automatically.

Your job is to send a message with the same body back to the client but with a message type of "echo_ok". It should also associate itself with the original message by setting the "in_reply_to" field to the original message ID. This reply field is handled automatically if you use the Node.Reply() method.

It should look like this:
```
{
  "src": "n1",
  "dest": "c1",
  "body": {
    "type": "echo_ok",
    "msg_id": 1,
    "in_reply_to": 1,
    "echo": "Please echo 35"
  }
}
```

## Installing Maelstrom

Maelstrom is built in Clojure so you'll need to install OpenJDK. It also provides some plotting and graphing utilities which rely on Graphviz & gnuplot.

Next, you'll need to download Maelstrom itself. These challenges have been tested against the Maelstrom 0.2.3. Download the tarball & unpack it. You can run the maelstrom binary from inside this directory.

## Running Our Node in maelstrom

```
./maelstrom test -w echo --bin ~/go/bin/maelstrom-echo --node-count 1 --time-limit 10
```

This command instructs maelstrom to run the "echo" workload against our binary. It runs a single node and it will send "echo" commands for 10 seconds.

Maelstrom will only inject network failures and it will not intentionally crash your node process so you don't need to worry about persistence. You can use in-memory data structures for these challenges.

If everything ran correctly, you should see a bunch of log messages and stats and then finally a pleasent message from Maelstrom:

```
Everything looks good! ヽ(‘ー`)ノ
```

## Debugging Maelstrom

```
./maelstrom serve
```
