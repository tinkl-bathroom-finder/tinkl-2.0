"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.rejectUnauthenticated = void 0;
var rejectUnauthenticated = function (req, res, next) {
    if (req.isAuthenticated()) {
        return next();
    }
    else {
        res.status(401).json({ message: 'Unauthorized: Please log in to access this resource' });
    }
};
exports.rejectUnauthenticated = rejectUnauthenticated;
