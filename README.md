# Monitor-202314

## Cheatsheet

### Build and push docker images Entrega 1

```bash
docker build --platform=linux/amd64 ./users -t ghcr.io/misw-4301-desarrollo-apps-en-la-nube/entrega1-users:latest
docker build --platform=linux/amd64 ./offers -t ghcr.io/misw-4301-desarrollo-apps-en-la-nube/entrega1-offers:latest
docker build --platform=linux/amd64 ./routes -t ghcr.io/misw-4301-desarrollo-apps-en-la-nube/entrega1-routes:latest
docker build --platform=linux/amd64 ./posts -t ghcr.io/misw-4301-desarrollo-apps-en-la-nube/entrega1-posts:latest

docker push ghcr.io/misw-4301-desarrollo-apps-en-la-nube/entrega1-users:latest
docker push ghcr.io/misw-4301-desarrollo-apps-en-la-nube/entrega1-offers:latest
docker push ghcr.io/misw-4301-desarrollo-apps-en-la-nube/entrega1-routes:latest
docker push ghcr.io/misw-4301-desarrollo-apps-en-la-nube/entrega1-posts:latest
```

### Build and push docker images Entrega 2

```bash
docker build --platform=linux/amd64 ./users -t ghcr.io/misw-4301-desarrollo-apps-en-la-nube/entrega2-users:latest
docker build --platform=linux/amd64 ./offers -t ghcr.io/misw-4301-desarrollo-apps-en-la-nube/entrega2-offers:latest
docker build --platform=linux/amd64 ./routes -t ghcr.io/misw-4301-desarrollo-apps-en-la-nube/entrega2-routes:latest
docker build --platform=linux/amd64 ./posts -t ghcr.io/misw-4301-desarrollo-apps-en-la-nube/entrega2-posts:latest
docker build --platform=linux/amd64 ./scores -t ghcr.io/misw-4301-desarrollo-apps-en-la-nube/entrega2-scores:latest
docker build --platform=linux/amd64 ./public -t ghcr.io/misw-4301-desarrollo-apps-en-la-nube/entrega2-rf003:latest
docker build --platform=linux/amd64 ./public -t ghcr.io/misw-4301-desarrollo-apps-en-la-nube/entrega2-rf004:latest
docker build --platform=linux/amd64 ./public -t ghcr.io/misw-4301-desarrollo-apps-en-la-nube/entrega2-rf005:latest

docker push ghcr.io/misw-4301-desarrollo-apps-en-la-nube/entrega2-users:latest
docker push ghcr.io/misw-4301-desarrollo-apps-en-la-nube/entrega2-offers:latest
docker push ghcr.io/misw-4301-desarrollo-apps-en-la-nube/entrega2-routes:latest
docker push ghcr.io/misw-4301-desarrollo-apps-en-la-nube/entrega2-posts:latest
docker push ghcr.io/misw-4301-desarrollo-apps-en-la-nube/entrega2-scores:latest
docker push ghcr.io/misw-4301-desarrollo-apps-en-la-nube/entrega2-rf003:latest
docker push ghcr.io/misw-4301-desarrollo-apps-en-la-nube/entrega2-rf004:latest
docker push ghcr.io/misw-4301-desarrollo-apps-en-la-nube/entrega2-rf005:latest
```