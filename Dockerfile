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

# 1. Crea todas las tablas con SQLAlchemy (create_all) si no existen
# 2. Marca todas las migraciones como aplicadas (stamp head) para que
#    Alembic no intente correrlas sobre tablas ya creadas
# 3. Arranca el servidor
CMD python -c "import asyncio; from app.db.session import init_db; asyncio.run(init_db())" \
    && alembic stamp head \
    && uvicorn app.main:app --host 0.0.0.0 --port 8000
