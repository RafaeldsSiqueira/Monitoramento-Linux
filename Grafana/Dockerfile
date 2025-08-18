# =============================================================================
# GRAFANA - DOCKERFILE
# =============================================================================
# Este Dockerfile cria uma imagem para o Grafana
# Autor: Sistema de Monitoramento Linux
# Data: $(date +%Y-%m-%d)
# =============================================================================

# Usar imagem oficial do Grafana
FROM grafana/grafana:10.2.0

# Usuário não-root para segurança
USER 472

# Expor porta padrão do Grafana
EXPOSE 3000

# Comando padrão
CMD ["grafana-server"]
