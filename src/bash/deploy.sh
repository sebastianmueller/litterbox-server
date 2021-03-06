#!/bin/bash




docker build -f src/docker/dockerfile -t litterbox-server .

docker tag litterbox-server gcr.io/katzenklo-176615/litterbox-server:<TAG>

gcloud docker -- push gcr.io/katzenklo-176615/litterbox-server


gcloud beta container --project "katzenklo-176615" clusters create "litterbox" --zone "europe-west1-d" --username="admin" --cluster-version "1.6.7" --machine-type "f1-micro" --image-type "COS" --disk-size "100" --scopes "https://www.googleapis.com/auth/compute","https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring.write","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "3" --network "default" --enable-cloud-logging --no-enable-cloud-monitoring --enable-legacy-authorization


kubectl run litterbox --image=gcr.io/katzenklo-176615/litterbox-server --port=8000

gcloud container clusters get-credentials litterbox --zone europe-west1-d --project katzenklo-176615


kubectl expose deployment litterbox --port=8000 --type="LoadBalancer"

kubectl get service litterbox

kubectl set image deployment/litterbox litterbox=gcr.io/katzenklo-176615/litterbox-server:<TAG>
