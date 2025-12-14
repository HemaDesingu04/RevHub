@echo off
echo Creating revhub database...
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -proot -e "CREATE DATABASE IF NOT EXISTS revhub; SHOW DATABASES;"
echo.
echo Database created!
pause
