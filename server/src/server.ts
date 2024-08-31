const cors = require('cors');
import express from 'express';
import session from 'express-session';
// import passport from 'passport';
import dotenv from 'dotenv';
import https from 'https';
import http from 'http';
import fs from 'fs';
import path from 'path';

const passport = require('./strategies/passportConfig');


//Types
import { Express } from 'express';
import { Request, Response } from 'express';
import { rejectUnauthenticated } from './strategies/authenticationPassport';

//Routes
const bathroomRouter = require('./Routes/bathroomRouter');
const userRouter = require('./routes/userRouter');

const app: Express = express();
const port: number = 5001;

dotenv.config();

const sslOptions = {
    key: fs.readFileSync(path.join(__dirname, '..', './ssl/server.key')),
    cert: fs.readFileSync(path.join(__dirname, '..', './ssl/server.cert'))
};

const corsOptions = {
    origin: process.env.FRONTEND_URL, // Replace with your frontend origin
    credentials: true, // This allows cookies to be sent across origins
};

app.use(cors(corsOptions));
app.use(express.json());
// app.use(express.urlencoded({ extended: false }));

app.use(session({
    secret: process.env.SERVER_SECRET as string,
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

//Test route no auth
app.get('/testRoute', (req: Request, res: Response) => {
    res.send('This thing is working get route /');
});

declare module 'express-session' {
    interface SessionData {
        views: number;
    }
}

app.get('/viewCount', (req, res) => {
    if (!req.session.views) {
        req.session.views = 1;
    } else {
        req.session.views++;
    }
    res.send(`Number of views: ${req.session.views}`);
});

//Test route with auth
app.get('/auth', rejectUnauthenticated, (req: Request, res: Response) => {
    res.send('Authorization granted');
})

app.use('/api', bathroomRouter);
app.use('/user', userRouter);

// https.createServer(sslOptions, app).listen(5001, () => {
//     console.log('Server is running on https://localhost:5001')
// });

const PORT = process.env.port || 5001;

http.createServer(app).listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
})

// app.listen(port, '0.0.0.0', () => {
//     console.log(`Server Running at http://0.0.0.0:${port}`);
// })
