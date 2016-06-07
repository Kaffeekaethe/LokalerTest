docker-compose -H :4000 down

sudo docker stop $(sudo docker ps -aq)
sudo docker rm $(sudo docker ps -aq)

sudo docker run -d -p 4000:4000 swarm manage -H :4000 --replication --advertise 10.43.116.145:4000 consul://10.43.116.189:8501

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

docker-compose -H :4000 scale pricing=2
docker-compose -H :4000 scale seatoverview=5
docker-compose -H :4000 up -d
sleep 30
cd "testdata"
sudo docker -H :4000 exec -i seat_database mysql -uroot -proot < seat_init.sql
sudo docker -H :4000 exec -i customer_database mysql -uroot -proot < customer_init.sql
sudo docker -H :4000 exec -i booking_database mysql -uroot -proot < booking_init.sql
