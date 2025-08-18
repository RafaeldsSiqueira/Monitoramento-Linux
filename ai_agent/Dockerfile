# =============================================================================
# AI AGENT - DOCKERFILE
# =============================================================================
# Este Dockerfile cria uma imagem para o AI Agent
# Autor: Sistema de Monitoramento Linux
# Data: $(date +%Y-%m-%d)
# =============================================================================

# Usar Python 3.11 slim
FROM python:3.11-slim

# Definir diretório de trabalho
WORKDIR /app

# Instalar dependências do sistema
RUN apt-get update && apt-get install -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copiar requirements e instalar dependências Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar código da aplicação
COPY . .

# Expor porta
EXPOSE 5000

# Comando para executar a aplicação
CMD ["python", "api.py"]
