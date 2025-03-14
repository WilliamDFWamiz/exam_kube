#!/bin/bash

echo "💤 Début de la suppression des ressources..."

# Supprimer l'Ingress en premier (pour libérer les certificats)
echo "🔧 Suppression de l'Ingress..."
kubectl delete ingress -n standard --all

# Supprimer les déploiements et services
echo "🗑️ Suppression des déploiements, services et autres ressources..."
kubectl delete deployment,statefulset,service,hpa -n standard --all

# Supprimer les PVC
echo "💾 Suppression des volumes persistants..."
kubectl delete pvc -n standard --all

# Supprimer les secrets
echo "🔐 Suppression des secrets..."
kubectl delete secret -n standard --all

# Vérifier si cert-manager existe
if kubectl get namespace cert-manager &> /dev/null; then
    echo "🔒 Suppression du ClusterIssuer..."
    kubectl delete clusterissuer letsencrypt-prod

    echo "🔒 Suppression des certificats..."
    kubectl delete certificate -n standard --all

    echo "🔒 Suppression de cert-manager..."
    kubectl delete -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.1/cert-manager.yaml
    
    # Attendre que le namespace cert-manager soit supprimé
    echo "⏳ Attente de la suppression de cert-manager..."
    kubectl wait --for=delete namespace/cert-manager --timeout=60s
else
    echo "ℹ️ cert-manager n'est pas installé, passage à l'étape suivante..."
fi

# Supprimer le namespace en dernier
echo "🌍 Suppression du namespace..."
kubectl delete -f namespace.yml

echo "✅ Suppression terminée !" 