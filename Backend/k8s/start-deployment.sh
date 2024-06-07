# Start Oracle Database
kubectl apply -f oracle/oracle_volume.yaml
kubectl apply -f oracle/oracle_deployment.yaml
kubectl apply -f oracle/oracle_service.yaml

# Start Redis
kubectl apply -f redis/redis_deployment.yaml
kubectl apply -f redis/redis_service.yaml

# Start Spring
kubectl apply -f spring/backend_deployment.yaml
kubectl apply -f spring/backend_service.yaml

# Create SSL certificates secret
kubectl create secret tls nginx-ssl --cert=nginx/cert/cert.pem --key=nginx/cert/privkey.pem

# Start Nginx
kubectl apply -f nginx/nginx-config.yaml
kubectl apply -f nginx/nginx-deployment.yaml
kubectl apply -f nginx/nginx-service.yaml