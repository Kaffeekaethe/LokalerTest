sudo docker pull bachelorproject/$1service
sudo docker stop $1service
sudo docker rm $1service
sudo docker run --name $1service -d bachelorproject/$1service 
