const http = require('http');
const app = require('./app')

const PORT = process.env.PORT || 8080;

http.createServer(app).listen(PORT, (err) => {
    if(err) throw err;
    console.log("Server Up and Running!");
})