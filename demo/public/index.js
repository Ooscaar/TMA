let socket = new WebSocket('ws://localhost:8080');
let info = document.getElementById("info");

// Connection opened
socket.addEventListener('open', (event) => {
    console.log('Server closed open', event);
});

// Listen for messages
socket.addEventListener('message', (event) => {
    console.log('Message from server:', event.data);
    info.innerHTML = event.data;
});

// Connection closed
socket.addEventListener('close', (event) => {
    console.log('Server closed connection', event);
});