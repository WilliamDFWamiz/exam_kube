#!/bin/bash

# Définir le namespace
echo "🚀 Création du namespace..."
kubectl apply -f namespace.yml
sleep 2

# Vérifier si cert-manager est déjà installé
if ! kubectl get namespace cert-manager &> /dev/null; then
    echo "🔒 Installation de cert-manager..."
    kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.1/cert-manager.yaml
    echo "⏳ Attente du démarrage de cert-manager..."
    kubectl wait --for=condition=Ready pods -n cert-manager --all --timeout=300s
    sleep 10
else
    echo "✅ cert-manager est déjà installé"
fi

# Créer le secret
echo "🔐 Création des secrets..."
kubectl apply -f secret.yaml
sleep 2

# Appliquer le déploiement principal
echo "📦 Déploiement des services..."
kubectl apply -f deployment.yaml
sleep 2

# Vérifier le statut des pods
echo "👀 Vérification du statut des pods..."
kubectl get pods -n standard

# Attendre que tous les pods soient prêts
echo "⏳ Attente du démarrage complet des pods..."
kubectl wait --for=condition=Ready pods --all -n standard --timeout=300s

# Afficher les services et ingress
echo "🌐 Services et Ingress déployés :"
kubectl get services,ingress -n standard

echo "✅ Déploiement terminé !"
echo "📝 Accès aux applications :"
echo "- FastAPI : https://fastapi.willdf.fr"
echo "- PgAdmin : http://fastapi.willdf.fr:30080"