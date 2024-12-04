const cors = require('cors');
import express, { NextFunction } from 'express';
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
const bathroomRouter = require('./routes/bathroomRouter');
const userRouter = require('./routes/userRouter');
const geocodeRouter = require('./routes/geocodeRouter');
const contactRouter = require('./routes/contactRouter');

const app: Express = express();
const port: number = 5001;

dotenv.config();

const sslOptions = {
    key: fs.readFileSync(path.join(__dirname, '..', '/etc/letsencrypt/live/transphasic.asuscomm.com/privkey.pem')),
    cert: fs.readFileSync(path.join(__dirname, '..', '/etc/letsencrypt/live/transphasic.asuscomm.com/fullchain.pem'))
};

const corsOptions = {
    origin: function (origin: any, callback: any) {
        const allowedOrigins = [
            'http://locaohost:5173',
            'http://transphasic.asuscomm.com',
            'https://transphasic.asuscomm.com',
        ];

        if (allowedOrigins.includes(origin) || !origin) {
            callback(null, true);  // Allow if origin matches or if no origin
        } else {
            callback(new Error('Not allowed by CORS'));  // Reject otherwise
        }
    },
    credentials: true,  // Allow cookies to be sent across origins
};

console.log('*************', process.env.FRONTEND_URL, '************************')

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
        sameSite: 'lax'
    }
}));

app.use(passport.initialize());
app.use(passport.session());

// Serve static files from the Vite build directory (dist)
app.use(express.static(path.join(__dirname, '../client/dist')));

//Test route no auth
app.get('/testRoute', (req: Request, res: Response, next: NextFunction) => {
    console.log('testRoute called', req.isAuthenticated);
    res.send(req.isAuthenticated() ? 'Authenticated' : 'Not Authenticated');
});

declare module 'express-session' {
    interface SessionData {
        views: number;
    }
}

//This is another testing route
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
});

// // Fallback for any other requests, serve the index.html
// app.get('*', (req, res) => {
//     res.sendFile(path.join(__dirname, '../client/dist/index.html'));
// });

app.use('/api', bathroomRouter);
app.use('/user', userRouter);
app.use('/getPlaceID', geocodeRouter);
app.use('/contact', contactRouter);

// Use HTTPS if in production
if (process.env.NODE_ENV === 'production') {
    https.createServer(sslOptions, app).listen(port, () => {
        console.log(`Server running on https://transphasic.asuscomm.com:${port}`);
    });
} else {
    // Otherwise, use HTTP for development
    http.createServer(app).listen(port, () => {
        console.log(`Server running on http://localhost:${port}`);
    });
}