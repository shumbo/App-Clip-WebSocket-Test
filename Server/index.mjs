import { WebSocketServer } from "ws";

const wss = new WebSocketServer({ port: 8080 });

wss.on("connection", (ws) => {
  console.log("connected");

  ws.on("message", (data) => {
    console.log("received", data);
  });

  const id = setInterval(() => {
    const text = new Date().toString();
    console.log("send message", text);
    ws.send(text);
  }, 2000);
  ws.on("close", () => {
    clearInterval(id);
  });
});
