# =============================================================================
# ALERTMANAGER - DOCKERFILE
# =============================================================================
# Este Dockerfile cria uma imagem para o Alertmanager
# Autor: Sistema de Monitoramento Linux
# Data: $(date +%Y-%m-%d)
# =============================================================================

# Usar imagem oficial do Alertmanager
FROM prom/alertmanager:v0.27.0

# Usuário não-root para segurança
USER 65534

# Expor porta padrão do Alertmanager
EXPOSE 9093

# Comando padrão
CMD ["alertmanager", "--config.file=/etc/alertmanager/alertmanager.yml", "--storage.path=/alertmanager"]
