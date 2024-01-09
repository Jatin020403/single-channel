cd artifacts/channel
./create-artifacts.sh
cd ..
docker-compose up -d
sleep 10
cd ..
./createChannel.sh
sleep 2