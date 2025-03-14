#!/bin/bash

# Configuration
TIMESTAMP=$(date +%d-%m-%Y_%H-%M)
HOSTNAME=$(hostname)
BACKUP_DIR="/home/ubuntu/workspace/exam_kube/YAML-STANDARD/backups"
BACKUP_NAME="etcd-backup-${HOSTNAME}-${TIMESTAMP}"

# Création du dossier de backup
mkdir -p $BACKUP_DIR

echo "🔄 Début de la sauvegarde ETCD..."

# Sauvegarde ETCD
echo "📦 Création de la sauvegarde..."
sudo k3s etcd-snapshot save \
    --etcd-snapshot-dir=$BACKUP_DIR \
    --name=$BACKUP_NAME

# Liste des sauvegardes
echo "📋 Liste des sauvegardes disponibles :"
ls -lh $BACKUP_DIR

echo "✅ Sauvegarde ETCD terminée sous le nom : $BACKUP_NAME" 