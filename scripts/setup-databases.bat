@echo off
echo Setting up RevHub databases...

echo.
echo === MySQL Database Setup ===
echo Connecting to local MySQL on port 3307...
mysql -h localhost -P 3307 -u root -proot -e "CREATE DATABASE IF NOT EXISTS revhub; USE revhub; SHOW DATABASES;"
if %errorlevel% neq 0 (
    echo Warning: MySQL connection failed. Make sure MySQL is running on port 3307
)

echo.
echo === MongoDB Database Setup ===
docker exec -i revhub-mongo mongosh --username root --password root << EOF
use revhub
db.createCollection("temp")
db.temp.drop()
show dbs
EOF

echo.
echo Database setup complete!
pause