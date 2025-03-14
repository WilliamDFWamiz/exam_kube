# exam_kube

## Description
Ce projet contient une application FastAPI avec une base de données PostgreSQL déployée sur Kubernetes.

## Scripts disponibles

### `start.sh`
- Démarre l'application et la base de données
- Déploie les ressources Kubernetes nécessaires

### `sleep.sh` 
- Arrête l'application et la base de données
- Supprime les ressources Kubernetes

### `save-logs.sh`
- Sauvegarde les logs de l'application et de la base de données
- Crée des fichiers de logs dans le dossier `/logs`

### `backup-etcd.sh`
- Effectue une sauvegarde de la base de données ETCD
- Stocke le backup dans le dossier `/backups`
