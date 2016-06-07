sudo docker stop $(sudo docker ps -aq)
sudo docker rm $(sudo docker ps -aq)
ADVERTISE_ADDRESS=`ifconfig eth0 2>/dev/null|awk '/inet addr:/ {print $2}'|sed 's/addr://'`

sudo docker run -d \
-p 8300:8300 \
-p 8301:8301 \
-p 8302:8302 \
-p 8400:8400 \
-p 8500:8500 \
-p 8600:8600 \
-p 8301:8301/udp \
-p 8302:8302/udp \
-p 8600:8600/udp \
--name consul \
-h $HOSTNAME \
--net="host" \
bachelorproject/consulnodeagent -advertise $ADVERTISE_ADDRESS

sleep 10

sudo docker run -d \
--name=registrator \
--net=host \
--volume=/var/run/docker.sock:/tmp/docker.sock \
gliderlabs/registrator:latest \
consul://localhost:8500

sudo docker-compose up -d
sleep 30
cd "testdata"
sudo docker exec -i seat_database mysql -uroot -proot < seat_init.sql
sudo docker exec -i customer_database mysql -uroot -proot < customer_init.sql
sudo docker exec -i booking_database mysql -uroot -proot < booking_init.sql
