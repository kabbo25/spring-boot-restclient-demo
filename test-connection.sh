#!/bin/bash
echo "Testing database connectivity..."
docker exec wp_writable php -r "
\$host = getenv('WORDPRESS_DB_HOST') ?: 'wpdb';
\$user = getenv('WORDPRESS_DB_USER') ?: 'ipemis_orcl';
\$pass = getenv('WORDPRESS_DB_PASSWORD') ?: 'secret';
\$db = getenv('WORDPRESS_DB_NAME') ?: 'wordpress';

echo \"Host: \$host\\n\";
echo \"User: \$user\\n\";
echo \"Database: \$db\\n\";

if (function_exists('mysqli_connect')) {
    \$conn = @mysqli_connect(\$host, \$user, \$pass, \$db);
    if (\$conn) {
        echo \"✅ MySQL connection successful!\\n\";
        mysqli_close(\$conn);
    } else {
        echo \"❌ MySQL connection failed: \" . mysqli_connect_error() . \"\\n\";
    }
} elseif (function_exists('pg_connect')) {
    \$conn_string = \"host=\$host port=5432 dbname=\$db user=\$user password=\$pass\";
    \$conn = @pg_connect(\$conn_string);
    if (\$conn) {
        echo \"✅ PostgreSQL connection successful!\\n\";
        pg_close(\$conn);
    } else {
        echo \"❌ PostgreSQL connection failed\\n\";
    }
} else {
    echo \"❌ No database extensions found\\n\";
}
"
