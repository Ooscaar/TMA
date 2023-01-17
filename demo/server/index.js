const WebSocket = require('ws');

const WEBSOCKET_PORT = 8080;
const PING_INTERVAL = 1000;

const wss = new WebSocket.Server({ port: WEBSOCKET_PORT });

wss.on('connection', (ws) => {
  ws.pingNumber = 0;

  setInterval(() => {
    ws.send(`${ws.pingNumber}`);
    ws.pingNumber++;
  }, PING_INTERVAL)

});