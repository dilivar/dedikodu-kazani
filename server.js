const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = 8181;
const BASE_DIR = '/home/ubuntu/.openclaw/workspace/dedikodu-kazani';

const server = http.createServer((req, res) => {
    let filePath = req.url === '/' ? '/web/index.html' : req.url;
    filePath = path.join(BASE_DIR, filePath);
    
    console.log('Requested:', filePath);
    
    const extname = path.extname(filePath);
    let contentType = 'text/html';
    
    switch (extname) {
        case '.js':
            contentType = 'text/javascript';
            break;
        case '.css':
            contentType = 'text/css';
            break;
        case '.json':
            contentType = 'application/json';
            break;
    }
    
    fs.readFile(filePath, (error, content) => {
        if (error) {
            if (error.code === 'ENOENT') {
                res.writeHead(404);
                res.end('404 Not Found: ' + filePath);
            } else {
                res.writeHead(500);
                res.end('Server Error: ' + error.code);
            }
        } else {
            res.writeHead(200, { 'Content-Type': contentType });
            res.end(content, 'utf-8');
        }
    });
});

server.listen(PORT, '0.0.0.0', () => {
    console.log(`
╔══════════════════════════════════════════════════════════════╗
║   🌯 Dedikodu Kazanı - Server                              ║
║   http://localhost:${PORT}                                      ║
╚══════════════════════════════════════════════════════════════╝
    `);
});
