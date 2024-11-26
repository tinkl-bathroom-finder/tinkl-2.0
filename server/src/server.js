"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var cors = require('cors');
var express_1 = require("express");
var express_session_1 = require("express-session");
// import passport from 'passport';
var dotenv_1 = require("dotenv");
// import https from 'https';
// import http from 'http';
// import fs from 'fs';
var path_1 = require("path");
var passport = require('./strategies/passportConfig');
var authenticationPassport_1 = require("./strategies/authenticationPassport");
//Routes
var bathroomRouter = require('./routes/bathroomRouter');
var feedbackRouter = require('./routes/feedbackRouter')
var userRouter = require('./routes/userRouter');
var geocodeRouter = require('./routes/geocodeRouter');
var app = (0, express_1.default)();
var port = 5001;
dotenv_1.default.config();
// const sslOptions = {
//     key: fs.readFileSync(path.join(__dirname, '..', './ssl/server.key')),
//     cert: fs.readFileSync(path.join(__dirname, '..', './ssl/server.cert'))
// };
var corsOptions = {
    origin: process.env.FRONTEND_URL, // Replace with your frontend origin
    credentials: true, // This allows cookies to be sent across origins
};
console.log('*************', process.env.FRONTEND_URL, '************************');
app.use(cors(corsOptions));
app.use(express_1.default.json());
// app.use(express.urlencoded({ extended: false }));
app.use((0, express_session_1.default)({
    secret: process.env.SERVER_SECRET,
    resave: false,
    saveUninitialized: false,
    proxy: true,
    cookie: {
        secure: false, //Todo: Set to true for production
        httpOnly: true,
        maxAge: 24 * 60 * 60 * 3000,
        sameSite: 'none' //Todo: Set to lax for production
    }
}));
app.use(passport.initialize());
app.use(passport.session());
// Serve static files from the Vite build directory (dist)
app.use(express_1.default.static(path_1.default.join(__dirname, '../client/dist')));
//Test route no auth
app.get('/testRoute', function (req, res) {
    res.send('This thing is working');
});
//This is another testing route
app.get('/viewCount', function (req, res) {
    if (!req.session.views) {
        req.session.views = 1;
    }
    else {
        req.session.views++;
    }
    res.send("Number of views: ".concat(req.session.views));
});
//Test route with auth
app.get('/auth', authenticationPassport_1.rejectUnauthenticated, function (req, res) {
    res.send('Authorization granted');
});
// // Fallback for any other requests, serve the index.html
// app.get('*', (req, res) => {
//     res.sendFile(path.join(__dirname, '../client/dist/index.html'));
// });
app.use('/api', bathroomRouter);
app.use('/feedback', feedbackRouter);
app.use('/user', userRouter);
app.use('/getPlaceID', geocodeRouter);
// const httpsServer = https.createServer(sslOptions, app);
var PORT = process.env.port || 5001;
// const IPADDRESS = '192.168.50.148';
app.listen(PORT, function () {
    console.log("Server running on http://localhost:".concat(PORT));
});
// httpsServer.listen(port, IPADDRESS, () => {
//     console.log(`Server Running at https://${IPADDRESS}:${port}`);
// });
