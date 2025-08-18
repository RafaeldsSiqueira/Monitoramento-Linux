# =============================================================================
# PROMETHEUS - DOCKERFILE
# =============================================================================
# Este Dockerfile cria uma imagem para o Prometheus
# Autor: Sistema de Monitoramento Linux
# Data: $(date +%Y-%m-%d)
# =============================================================================

# Usar imagem oficial do Prometheus
FROM prom/prometheus:v2.47.0

# Usuário não-root para segurança
USER 65534

# Expor porta padrão do Prometheus
EXPOSE 9090

# Comando padrão
CMD ["prometheus", "--config.file=/etc/prometheus/prometheus.yml", "--storage.tsdb.path=/prometheus", "--web.console.libraries=/etc/prometheus/console_libraries", "--web.console.templates=/etc/prometheus/consoles"]
