import passport from "passport";
import { Strategy as LocalStrategy } from "passport-local";
import bcrypt from 'bcryptjs';
import pool from '../pool';

interface User {
    id: number,
    username: string,
    password: string,
    is_admin: boolean,
    is_removed: boolean,
}

passport.use(
    new LocalStrategy(async (username, password, done) => {
        try {
            const queryString = `
                SELECT * FROM "user"
                WHERE username = $1
            `;
            const res = await pool.query(queryString, [username]);
            const user: User | undefined = res.rows[0];

            if (!user) {
                console.log('Incorrect username or password');
                return done(null, false, { message: 'Incorrect username or password' });
            }
            const isMatch = await bcrypt.compare(password, user.password);

            if (!isMatch) {
                console.log('Incorrect username or password');
                return done(null, false, { message: 'Incorrect username or password' });
            }

            return done(null, user);
        } catch (error) {
            return done(error);
        }
    })
);

passport.serializeUser((user: any, done) => {
    done(null, user.id);
});

passport.deserializeUser(async (id: number, done) => {
    try {
        const res = await pool.query('SELECT * FROM user WHERE id = $1', [id]);
        const user: User | undefined = res.rows[0];
        done(null, user);
    } catch (err) {
        done(err);
    }
});

module.exports = passport;