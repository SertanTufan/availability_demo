# Python 3.12 slim imajını kullan
FROM python:3.12-slim

# Sistem paketlerini yükle (pydantic-core derlemesi için gerekli)
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

# Çalışma dizinini ayarla
WORKDIR /app

# Gereksinimleri yükle
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Uygulama dosyalarını kopyala
COPY . .

# Uvicorn ile başlat
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8080"]
