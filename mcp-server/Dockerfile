# Dockerfile para Prometheus MCP Server (Python)
# /home/rafael/Monitoramento_Linux/mcp-server/Dockerfile

FROM python:3.11-slim

# Instalar dependências do sistema
RUN apt-get update && apt-get install -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Criar usuário não-root
RUN useradd -m -u 1001 mcp

# Definir diretório de trabalho
WORKDIR /app

# Copiar requirements e instalar dependências
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar código do servidor
COPY mcp_server.py .
COPY config/ ./config/

# Definir permissões
RUN chown -R mcp:mcp /app

# Mudar para usuário não-root
USER mcp

# Expor porta
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import requests; requests.get('http://localhost:8080/health')" || exit 1

# Comando de inicialização
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--workers", "1", "--timeout", "30", "mcp_server:app"]
