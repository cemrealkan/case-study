#!/bin/bash
set -e

echo "Setup script baslatiliyor..."

echo "Kubernetes cluster kontrol ediliyor..."
kubectl get nodes

echo "Namespace kontrol ediliyor / olusturuluyor..."
kubectl get namespace linkding >/dev/null 2>&1 || kubectl create namespace linkding

echo "ConfigMap uygulanıyor..."
kubectl apply -f k8s/configmap.yaml

echo "Secret uygulanıyor..."
kubectl apply -f k8s/secret.yaml

echo "Deployment uygulanıyor..."
kubectl apply -f k8s/deployment.yaml

echo "Service uygulanıyor..."
kubectl apply -f k8s/service.yaml

echo "Ingress uygulanıyor..."
kubectl apply -f k8s/ingress.yaml

echo "Podlar hazir olana kadar bekleniyor..."
kubectl rollout status deployment/linkding -n linkding

echo "Kurulum tamamlandi."
echo "Ingress erisimi icin gerekirse 'minikube tunnel' calistirin."
