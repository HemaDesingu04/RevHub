@echo off
echo ========================================
echo  Creating Kafka Topics
echo ========================================
echo.

echo Creating user-events topic...
docker exec revhub-kafka kafka-topics --create --if-not-exists --topic user-events --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1

echo Creating post-events topic...
docker exec revhub-kafka kafka-topics --create --if-not-exists --topic post-events --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1

echo Creating social-events topic...
docker exec revhub-kafka kafka-topics --create --if-not-exists --topic social-events --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1

echo Creating chat-events topic...
docker exec revhub-kafka kafka-topics --create --if-not-exists --topic chat-events --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1

echo Creating notification-events topic...
docker exec revhub-kafka kafka-topics --create --if-not-exists --topic notification-events --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1

echo Creating feed-events topic...
docker exec revhub-kafka kafka-topics --create --if-not-exists --topic feed-events --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1

echo Creating saga-events topic...
docker exec revhub-kafka kafka-topics --create --if-not-exists --topic saga-events --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1

echo.
echo ========================================
echo Listing all topics...
echo ========================================
docker exec revhub-kafka kafka-topics --list --bootstrap-server localhost:9092

echo.
echo ========================================
echo Kafka Topics Created Successfully!
echo ========================================
pause
