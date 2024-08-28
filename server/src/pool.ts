import { Pool } from 'pg';
let pool: Pool;

if (process.env.DATABASE_URL) {
    pool = new Pool({
        connectionString: process.env.DATABASE_URL,
        ssl: {
            rejectUnauthorized: false
        }
    });
}

else {
    pool = new Pool({
        host: 'localhost',
        port: 5432,
        database: 'bathrooms',
    });
}
export default pool;