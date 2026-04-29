FROM public.ecr.aws/docker/library/python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    build-essential \
    libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app ./app

EXPOSE 8000

CMD ["/bin/sh", "-lc", "export POSTGRES_HOST=${POSTGRES_HOST:-${DB_HOST}}; \
export POSTGRES_PORT=${POSTGRES_PORT:-${DB_PORT}}; \
export POSTGRES_DB=${POSTGRES_DB:-${DB_NAME}}; \
export POSTGRES_USER=${POSTGRES_USER:-${DB_USER}}; \
export POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-${DB_PASSWORD}}; \
exec uvicorn app.main:app --host 0.0.0.0 --port 8000"]
