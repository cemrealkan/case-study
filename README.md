# DevOps Engineer Case Study

Bu repository, DevOps Engineer case çalışması kapsamında hazırlanmıştır.  
Çalışmada local bir Kubernetes ortamı üzerinde açık kaynak bir uygulamanın
deploy edilmesi, Ingress ile erişimin sağlanması, rolling update ve rollback
senaryolarının gösterilmesi hedeflenmiştir.

## Kubernetes Ortamı

Bu case kapsamında **Minikube** tercih edilmiştir.  
Minikube, local ortamda hızlı ve izole bir Kubernetes cluster
kurulumu sağladığı için seçilmiştir.

- Minikube versiyonu: v1.35.0
- Kubernetes versiyonu: v1.32.0


## Cluster Durumu

Bu case kapsamında Kubernetes cluster kurulumu için Minikube
kullanılmıştır. Minikube kurulumu daha önceden yapılmış olup,
cluster aşağıdaki komut ile ayağa kaldırılmıştır:

```bash
minikube start
```
![kubectl get nodes](screenshots/kubectl-get-nodes.PNG)


## Namespace Yapılandırması

Uygulama kaynaklarının izole bir şekilde yönetilebilmesi amacıyla
`linkding` isimli bir Kubernetes namespace’i oluşturulmuştur.

Tüm Kubernetes objeleri (Deployment, Service, ConfigMap, Secret ve Ingress)
bu namespace altında deploy edilmiştir.


## Uygulama Deploy Edilmesi 

### ConfigMap

Uygulamaya ait konfigürasyon değerleri ConfigMap üzerinden yönetilmektedir.

```bash
kubectl apply -f k8s/configmap.yaml
kubectl get configmap -n linkding
```
### Secret


### Deployment

Linkding uygulaması bir Kubernetes Deployment objesi olarak tanımlanmıştır.
Uygulama tek replica ile çalışacak şekilde konfigüre edilmiştir.

```bash
kubectl apply -f k8s/deployment.yaml
kubectl get pods -n linkding
```
![kubectl get pods](screenshots/kubectl-get-pods.PNG)

### Service

Uygulama, cluster içi erişim için ClusterIP tipinde bir Service ile yayınlanmıştır.

```bash
kubectl apply -f k8s/service.yaml
kubectl get svc -n linkding
```
![kubectl get svc](screenshots/kubectl-get-svc.PNG)


## Ingress Controller

Minikube ortamında Ingress controller olarak NGINX Ingress Controller kullanılmıştır.

```bash
minikube addons enable ingress
```


## Ingress Erişimi

Uygulamaya dış erişim sağlamak amacıyla Ingress objesi tanımlanmıştır.
Minikube ortamında Ingress erişimi için aşağıdaki komut çalıştırılmıştır:

```bash
minikube tunnel
```
![Ingress access](screenshots/ingress-access.PNG)
![kubectl get ingress](screenshots/kubectl-get-ingress.PNG)

Uygulama aşağıdaki adres üzerinden erişilebilir hale gelmiştir:
http://linkding.local

![Linkding UI](screenshots/linkding-ui.PNG)


## Rolling Update & Rollback

Deployment üzerinde image tag değiştirilerek rolling update işlemi gerçekleştirilmiştir.

### Rolling Update

Başlangıçta çalışan image:

- `sissbruecker/linkding:1.44.1-plus`

Deployment manifesti güncellenerek image aşağıdaki versiyona çekilmiştir:

- `sissbruecker/linkding:1.44.2-plus-alpine`

```bash
kubectl apply -f k8s/deployment.yaml
kubectl rollout status deployment/linkding -n linkding
```
![Rolling update](screenshots/rollout.PNG)

### Rollback

Rolling update sonrasında, uygulama önceki stabil versiyona geri döndürülmüştür.
Rollback işlemi ile deployment, otomatik olarak bir önceki revision’a dönmüştür:

- `sissbruecker/linkding:1.44.1-plus`

```bash
kubectl rollout undo deployment/linkding -n linkding
```
![Rollback](screenshots/rollback.PNG)


## Otomasyon (setup.sh)  

Tüm Kubernetes kaynaklarının tek komutla deploy edilebilmesi amacıyla
setup.sh script’i hazırlanmıştır.

Script aşağıdaki işlemleri otomatik olarak gerçekleştirir:

- Cluster erişimini doğrular
- Namespace oluşturur (gerekirse)
- Kubernetes manifestlerini uygular
- Deployment rollout durumunu kontrol eder

```bash
./setup.sh
```


## Optional CI/CD






