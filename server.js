const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = 8181;

const server = http.createServer((req, res) => {
    let filePath = req.url === '/' ? '/web/index.html' : req.url;
    filePath = path.join(__dirname, 'web', filePath);
    
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
                res.end('404 Not Found');
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

server.listen(PORT, () => {
    console.log(`
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║   🌯 Dedikodu Kazanı - iPhone Preview Server               ║
║                                                              ║
║   Server running at:                                        ║
║   http://localhost:${PORT}                                      ║
║   http://<YOUR_IP>:${PORT}                                    ║
║                                                              ║
║   iPhone 16 Pro Max Simulator:                              ║
║   - Screen: 430 x 932 pixels                                ║
║   - Notch included                                           ║
║   - iOS style frame                                          ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
    `);
});
