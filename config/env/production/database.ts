module.exports = ({ env }) => ({
  connection: {
    client: 'postgres',
    connection: {
      // Support connectionString for managed databases (recommended)
      connectionString: env('DATABASE_URL'),
      // Individual parameters (fallback if DATABASE_URL is not set)
      // host: env('DATABASE_HOST'),
      // port: env.int('DATABASE_PORT', 5432),
      // database: env('DATABASE_NAME', 'strapi'),
      // user: env('DATABASE_USERNAME', 'strapi'),
      // password: env('DATABASE_PASSWORD'),
      // SSL enabled by default for production
      ssl: env.bool('DATABASE_SSL', true) && {
        ca:
          env('DATABASE_SSL_CA') || require('fs').readFileSync('/opt/app/certs/ca.crt').toString(),
        rejectUnauthorized: env.bool('DATABASE_SSL_REJECT_UNAUTHORIZED', false),
      },
      schema: env('DATABASE_SCHEMA', 'public'),
    },
    acquireConnectionTimeout: env.int('DATABASE_CONNECTION_TIMEOUT', 60000),
  },
  debug: env.bool('DATABASE_DEBUG', false),
  pool: {
    min: env.int('DATABASE_POOL_MIN', 0),
    max: env.int('DATABASE_POOL_MAX', 10),
    acquireTimeoutMillis: 600000,
    createTimeoutMillis: 30000,
    idleTimeoutMillis: 20000,
    reapIntervalMillis: 20000,
    createRetryIntervalMillis: 200,
  },
});
