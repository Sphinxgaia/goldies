# Goldie Apps

## Les dossiers

Le dossier `src` contient les sources de notre application.

Elle est basée sur l'application podtato-head en version simplifié pour n'afficher qu'une seule image.

Le dossier `deploy' contient les éléments de déploiement dans Kubernetes

## Build de vos applications

> se connecter à votre dépôt d'image OCI

```bash
export REPOSITORY=ghcr.io/sphinxgaia
export PUSH=true

./build/main.sh
```


## Déploiement des applications

> Attention à chaque étapes, cela remplace l'ancienne application

Lancement de l'application témoin

```bash
export WORK_HOME=$(pwd)
export IP=<IP de votre cluster>
export NS=default

kubectl apply -f $WORK_HOME/deploy/_goldies/manifest.yaml -n $NS


open http://$IP:30001

```


# on local host only or if you can't expose a nodePort

```bash

export NS=default

open http://localhost:30001
kubectl port-forward -n $NS svc/goldie-main 30001:9000

```

