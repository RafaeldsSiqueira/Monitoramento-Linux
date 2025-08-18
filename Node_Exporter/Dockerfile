# =============================================================================
# NODE EXPORTER - DOCKERFILE
# =============================================================================
# Este Dockerfile cria uma imagem para o Node Exporter
# Autor: Sistema de Monitoramento Linux
# Data: $(date +%Y-%m-%d)
# =============================================================================

# Usar imagem oficial do Node Exporter
FROM prom/node-exporter:v1.6.1

# Usuário não-root para segurança
USER nobody

# Expor porta padrão do Node Exporter
EXPOSE 9100

# Comando padrão com configurações otimizadas
CMD ["--path.procfs=/host/proc", \
     "--path.sysfs=/host/sys", \
     "--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)", \
     "--collector.filesystem.fs-types-exclude=^(sys|proc|auto)fs$$", \
     "--collector.netdev.device-exclude=^(lo|docker0|veth.*)$$", \
     "--collector.diskstats.device-exclude=^(ram|loop|fd|(h|s|v|xv)d[a-z]|nvme\\d+n\\d+p)\\d+$$", \
     "--collector.cpu.info", \
     "--collector.meminfo", \
     "--collector.loadavg", \
     "--collector.filesystem", \
     "--collector.netdev", \
     "--collector.diskstats", \
     "--collector.uname", \
     "--collector.time", \
     "--web.listen-address=:9100"]

# =============================================================================
# FIM DO DOCKERFILE
# =============================================================================
