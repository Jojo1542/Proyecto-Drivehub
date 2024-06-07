gcloud compute disks create --size=10GB oracle-disk

kubectl apply -f oracle_volume.yaml
kubectl apply -f oracle_deployment.yaml
kubectl apply -f oracle_service.yaml