const http = require('http');

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('Hello World\nThis is Gong Zhang developed Node JS application!');
});

const port = 3000;
server.listen(port, () => {
  console.log(`Web app service:  http://localhost:${port}/`);
});
