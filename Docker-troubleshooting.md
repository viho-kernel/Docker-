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
