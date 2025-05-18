FROM python:3.10-slim

# Dossier de travail
WORKDIR /app

# Copier tous les fichiers
COPY . .

# Installer les dépendances Python
RUN pip install --no-cache-dir -r requirements.txt

# Exposer le port utilisé par Uvicorn
EXPOSE 8000

# Commande de démarrage de l'application
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
