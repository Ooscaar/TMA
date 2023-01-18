const WebSocket = require('ws');

setTimeout(() => {
    let socket = new WebSocket('ws://tma_nginx:8080');

    // Connection opened
    socket.addEventListener('open', (event) => {
        console.log('Server open connection');
    });

    // Listen for messages
    socket.addEventListener('message', (event) => {
        console.log('Message from server:', event.data);
    });

    // Connection closed
    socket.addEventListener('close', (event) => {
        console.log('Server closed connection');
    });
}, 5000);
