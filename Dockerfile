FROM python:3.11-slim

WORKDIR /app

# Dependencias del sistema
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq-dev gcc \
    && rm -rf /var/lib/apt/lists/*

# Instalar dependencias Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar código fuente
COPY . .

# Variables de entorno por defecto
ENV PYTHONUNBUFFERED=1

EXPOSE 8000

# Ejecuta migraciones Alembic y luego arranca el servidor
CMD alembic upgrade head && uvicorn app.main:app --host 0.0.0.0 --port 8000
