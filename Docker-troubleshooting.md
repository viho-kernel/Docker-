# Test if the application is down

curl http://localhost:8080

# Test if the application is back up

curl http://localhost:8080

# Access the application in your browser

http://localhost:8090

# for logs

docker logs <<container-id or name>>

# Networking checks

docker network ls
docker network inspect <network_name>
docker exec -it <container_id> curl http://localhost:80

# Restart a container

docker restart <container_id_or_name>
docker rm <container_id_or_name>

docker logs -f <container_id_or_name>

docker top <container_id_or_name>

Connect container to Network
docker network connect <network_name> <container_id_or_name>

