# Create network
sudo docker network create overlay-network

# Start Infrastrcture 
cd "infrastructure-installation"
sudo docker-compose up -d

#wait until everything should be initialized
sleep 30
cd "testdata"

# Initialize data 

sudo docker exec -i seat_database mysql -uroot -proot < seat_init.sql
sudo docker exec -i seat_database_copy mysql -uroot -proot < seat_init.sql
sudo docker exec -i customer_database mysql -uroot -proot < customer_init.sql
sudo docker exec -i cassandra-1 cqlsh < booking_init.cql
sleep 20

# Setup services
cd "../../services-setup"
sudo docker-compose up -d
