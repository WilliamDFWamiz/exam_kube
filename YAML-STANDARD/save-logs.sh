#!/bin/bash

# Création du dossier logs s'il n'existe pas
mkdir -p logs

# Fonction pour horodater les entrées
timestamp() {
    date "+[%Y-%m-%d %H:%M:%S]"
}

echo "📝 Sauvegarde des logs..."

# Logs FastAPI
echo "⚡ Récupération des logs FastAPI..."
echo "=== Logs FastAPI $(timestamp) ===" > logs/fastapi-logs.txt
echo "Status des pods FastAPI :" >> logs/fastapi-logs.txt
kubectl get pods -n standard | grep fastapi-deployment >> logs/fastapi-logs.txt
echo "\nLogs détaillés :" >> logs/fastapi-logs.txt
kubectl get pods -n standard | grep fastapi-deployment | awk '{print $1}' | while read pod; do
    echo "\n=== Logs du pod $pod ===" >> logs/fastapi-logs.txt
    kubectl logs $pod -n standard >> logs/fastapi-logs.txt 2>&1
done

# Logs PostgreSQL
echo "💾 Récupération des logs PostgreSQL..."
echo "=== Logs PostgreSQL $(timestamp) ===" > logs/postgresql-logs.txt
echo "Status du pod PostgreSQL :" >> logs/postgresql-logs.txt
kubectl get pods -n standard | grep postgresql-deployment >> logs/postgresql-logs.txt
echo "\nLogs détaillés :" >> logs/postgresql-logs.txt
kubectl logs postgresql-deployment-0 -n standard >> logs/postgresql-logs.txt 2>&1

# Vérification et affichage des résultats
echo "\n✅ Logs sauvegardés !"
echo "📁 Fichiers créés :"
echo "  - logs/fastapi-logs.txt ($(wc -l < logs/fastapi-logs.txt) lignes)"
echo "  - logs/postgresql-logs.txt ($(wc -l < logs/postgresql-logs.txt) lignes)"

# Option pour voir les dernières lignes
read -p "Voulez-vous voir les 10 dernières lignes de chaque fichier ? (o/n) : " choice
if [ "$choice" = "o" ]; then
    echo "\n📑 Dernières lignes de fastapi-logs.txt :"
    echo "----------------------------------------"
    tail -n 10 logs/fastapi-logs.txt
    echo "\n📑 Dernières lignes de postgresql-logs.txt :"
    echo "----------------------------------------"
    tail -n 10 logs/postgresql-logs.txt
fi 