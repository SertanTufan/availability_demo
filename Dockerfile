# Python 3.11 tabanlı, küçük boyutlu imaj
FROM python:3.11-slim

# Çalışma dizinini ayarla
WORKDIR /app

# Gerekli paketleri yüklemeden önce pip'i güncelle
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Proje dosyalarını kopyala
COPY . .

# Uygulamanın dışarıya açılacağı port
EXPOSE 8080

# Cloud Run için başlatma komutu
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8080"]

