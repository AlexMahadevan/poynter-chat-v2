FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    FASTEMBED_CACHE_PATH=/opt/fastembed

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

# Download the embedding model at build time so a fresh machine doesn't
# fetch it from Hugging Face on the first search
RUN python -c "from fastembed import TextEmbedding; TextEmbedding('sentence-transformers/all-MiniLM-L6-v2', cache_dir='/opt/fastembed')"

COPY . .

EXPOSE 8080
CMD ["streamlit", "run", "app.py", \
     "--server.port=8080", "--server.address=0.0.0.0", \
     "--server.headless=true", "--browser.gatherUsageStats=false"]
