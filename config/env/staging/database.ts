module.exports = ({ env }) => ({
  connection: {
    client: 'postgres',
    connection: {
      // For staging with bundled PostgreSQL in docker-compose
      host: env('DATABASE_HOST', 'strapiDB'), // Docker service name from docker-compose.yml
      port: env.int('DATABASE_PORT', 5432),
      database: env('DATABASE_NAME', 'strapi'),
      user: env('DATABASE_USERNAME', 'strapi'),
      password: env('DATABASE_PASSWORD', 'strapi'),
      // SSL disabled for local Docker PostgreSQL (no need for encryption in same network)
      ssl: env.bool('DATABASE_SSL', false),
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
