# 🔧 **DOCUMENTAÇÃO TÉCNICA - SISTEMA DE MONITORAMENTO LINUX INTELIGENTE**

## 📋 **VISÃO GERAL**

Este documento fornece **detalhes técnicos avançados** sobre a arquitetura, configurações, APIs e funcionalidades do sistema de monitoramento inteligente.

---

## 🏗️ **ARQUITETURA DETALHADA**

### **📊 Camada de Infraestrutura:**
```
┌─────────────────────────────────────────────────────────────────┐
│                    INFRAESTRUTURA DOCKER                       │
├─────────────────┬─────────────────┬───────────────────────────┤
│   Prometheus    │     Grafana     │      Alertmanager         │
│   Container     │    Container    │       Container            │
│   Porta 9090    │   Porta 3000    │      Porta 9093           │
└─────────────────┴─────────────────┴───────────────────────────┘
```

### **🤖 Camada de Inteligência:**
```
┌─────────────────────────────────────────────────────────────────┐
│                    CAMADA DE INTELIGÊNCIA                      │
├─────────────────┬─────────────────┬───────────────────────────┤
│   MCP Server    │   AI Agent      │      Google Gemini        │
│   Container     │   Container     │      API Externa           │
│   Porta 8080    │   Porta 5000    │      HTTPS                 │
└─────────────────┴─────────────────┴───────────────────────────┘
```

### **🔄 Camada de Automação:**
```
┌─────────────────────────────────────────────────────────────────┐
│                    CAMADA DE AUTOMAÇÃO                         │
├─────────────────┬─────────────────┬───────────────────────────┤
│       n8n       │    Webhooks     │      Ações Auto           │
│    Container    │   Endpoints     │      Execução              │
│   Porta 5678    │   HTTP/HTTPS    │      Scripts               │
└─────────────────┴─────────────────┴───────────────────────────┘
```

---

## 🔧 **CONFIGURAÇÕES AVANÇADAS**

### **📊 Prometheus - Configuração Detalhada:**

#### **Arquivo: `Prometheus/prometheus.yml`**
```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

rule_files:
  - "regras.yml"

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'node-exporter'
    static_configs:
      - targets: ['localhost:9100']

  - job_name: 'mcp-server'
    static_configs:
      - targets: ['localhost:8080']
```

#### **Arquivo: `Prometheus/regras.yml`**
```yaml
groups:
  - name: sistema
    rules:
      - alert: CPUAlto
        expr: 100 - (avg by (instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "CPU alto no servidor {{ $labels.instance }}"
          description: "CPU está em {{ $value }}% por mais de 5 minutos"

      - alert: MemoriaAlta
        expr: (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100 > 85
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Memória alta no servidor {{ $labels.instance }}"
          description: "Memória está em {{ $value }}% por mais de 5 minutos"
```

### **📈 Grafana - Configuração Avançada:**

#### **Arquivo: `Grafana/grafana.ini`**
```ini
[server]
http_port = 3000
domain = localhost

[database]
type = sqlite3
path = /var/lib/grafana/grafana.db

[security]
admin_user = admin
admin_password = admin
allow_sign_up = false

[users]
allow_sign_up = false
auto_assign_org_role = Viewer
```

#### **Dashboards Disponíveis:**
- **`node-exporter-full.json`** - Dashboard completo do Node Exporter
- **Dashboards customizados** para Asterisk e aplicações específicas

### **🚨 Alertmanager - Configuração de Notificações:**

#### **Arquivo: `Alertmanager/alertmanager.yml`**
```yaml
global:
  smtp_smarthost: 'smtp.gmail.com:587'
  smtp_from: 'alertmanager@exemplo.com'
  smtp_auth_username: 'seu_email@gmail.com'
  smtp_auth_password: 'sua_senha'

route:
  group_by: ['alertname']
  group_wait: 10s
  group_interval: 10s
  repeat_interval: 1h
  receiver: 'web.hook'

receivers:
  - name: 'web.hook'
    webhook_configs:
      - url: 'http://localhost:5000/webhook'
        send_resolved: true

  - name: 'email'
    email_configs:
      - to: 'admin@exemplo.com'
        send_resolved: true
```

---

## 🚀 **SISTEMA MCP - DETALHES TÉCNICOS**

### **📋 Arquitetura MCP:**

#### **Componentes:**
1. **MCP Server** - Servidor Python Flask
2. **MCP Client** - Cliente Python no AI Agent
3. **Prometheus Integration** - Acesso direto às métricas
4. **Real-time Queries** - Consultas PromQL em tempo real

#### **Endpoints Disponíveis:**
```bash
# Health Check
GET /health

# Informações do MCP
GET /mcp

# Status do Prometheus
GET /mcp/status

# Lista de métricas
GET /mcp/metrics

# Consulta de métrica
POST /mcp/query
```

#### **Exemplo de Consulta:**
```bash
curl -X POST http://localhost:8080/mcp/query \
  -H "Content-Type: application/json" \
  -d '{"query": "up"}'
```

### **🔧 Configuração MCP:**

#### **Arquivo: `mcp-server/config/mcp-server.yml`**
```yaml
server:
  host: "0.0.0.0"
  port: 8080
  workers: 1
  timeout: 30

endpoints:
  health: "/health"
  mcp: "/mcp"
  status: "/mcp/status"
  metrics: "/mcp/metrics"
  query: "/mcp/query"

relevant_metrics:
  - "node_"
  - "prometheus_"
  - "alertmanager_"
  - "asterisk_"

timeouts:
  prometheus: 30
  request: 30

logging:
  level: "info"
  format: "json"
```

---

## 🤖 **AI AGENT - DETALHES TÉCNICOS**

### **📋 Arquitetura do AI Agent:**

#### **Componentes:**
1. **API Flask** - Interface HTTP REST
2. **MCP Client** - Cliente para MCP Server
3. **Google Gemini Integration** - IA generativa
4. **Email System** - Notificações e relatórios
5. **Webhook Handler** - Integração com n8n

#### **Endpoints Disponíveis:**
```bash
# Página principal
GET /

# Health check
GET /health

# Análise do sistema
GET /analyze

# Consulta de métricas
GET /metrics?metric=up

# Webhook para n8n
POST /webhook

# Interface de aprovação
GET /approval
```

### **🔧 Configuração do AI Agent:**

#### **Arquivo: `ai_agent/requirements.txt`**
```
flask==2.3.3
requests==2.31.0
google-generativeai==0.3.2
python-dotenv==1.0.0
typing-extensions==4.8.0
```

#### **Variáveis de Ambiente:**
```bash
# API Google Gemini
GOOGLE_API_KEY=sua_chave_api_gemini_aqui

# Configurações de email
EMAIL_ADDRESS=seu_email@gmail.com
EMAIL_PASSWORD=sua_senha_do_email
AUDIT_EMAIL=audit@exemplo.com

# URL do MCP Server
MCP_SERVER_URL=http://mcp-server:8080
```

---

## 🔄 **N8N - AUTOMAÇÃO AVANÇADA**

### **📋 Configuração do n8n:**

#### **Variáveis de Ambiente:**
```bash
# Autenticação básica
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=admin123

# URL do webhook
WEBHOOK_URL=http://localhost:5000/webhook

# Email para auditoria
AUDIT_EMAIL=audit@exemplo.com
```

#### **Workflows Disponíveis:**
- **`ai_agent_workflow.json`** - Workflow principal do AI Agent
- **Workflows customizados** para automações específicas

### **🔧 Integração com AI Agent:**

#### **Webhook Endpoint:**
```python
@app.route('/webhook', methods=['POST'])
def webhook():
    """Endpoint para webhooks do n8n"""
    data = request.get_json()
    
    if data.get('trigger_analysis'):
        analysis = mcp_client.analyze_system_health()
        return jsonify({
            "status": "success",
            "analysis": analysis
        })
    
    return jsonify({"status": "success"})
```

---

## 📊 **MÉTRICAS E PROMQL**

### **🔍 Métricas Principais do Sistema:**

#### **CPU:**
```promql
# Uso de CPU
100 - (avg by (instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# CPU por modo
irate(node_cpu_seconds_total{mode="user"}[5m])
irate(node_cpu_seconds_total{mode="system"}[5m])
irate(node_cpu_seconds_total{mode="iowait"}[5m])
```

#### **Memória:**
```promql
# Uso de memória
(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100

# Memória disponível
node_memory_MemAvailable_bytes

# Memória total
node_memory_MemTotal_bytes
```

#### **Disco:**
```promql
# Uso de disco
(1 - (node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"})) * 100

# Espaço disponível
node_filesystem_avail_bytes{mountpoint="/"}

# Espaço total
node_filesystem_size_bytes{mountpoint="/"}
```

#### **Rede:**
```promql
# Bytes recebidos
rate(node_network_receive_bytes_total[5m])

# Bytes enviados
rate(node_network_transmit_bytes_total[5m])

# Conexões ativas
node_netstat_tcp_established
```

### **🚨 Regras de Alerta Avançadas:**

#### **Alertas de Sistema:**
```yaml
- alert: DiscoCritico
  expr: (1 - (node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"})) * 100 > 95
  for: 2m
  labels:
    severity: critical
  annotations:
    summary: "Disco crítico no servidor {{ $labels.instance }}"
    description: "Disco está em {{ $value }}% - Ação imediata necessária"

- alert: RedeLenta
  expr: rate(node_network_receive_bytes_total[5m]) < 1000
  for: 5m
  labels:
    severity: warning
  annotations:
    summary: "Rede lenta detectada"
    description: "Taxa de recebimento: {{ $value }} bytes/s"
```

---

## 🌐 **CONFIGURAÇÃO DISTRIBUÍDA**

### **📡 Arquitetura de Rede:**

#### **Topologia:**
```
                    INTERNET
                        │
                    ROUTER/FIREWALL
                        │
                ┌───────┴───────┐
                │                │
            SERVIDOR          SERVIDOR
             CENTRAL           REMOTO
                │                │
        ┌───────┴───────┐       │
        │                │       │
    PROMETHEUS      GRAFANA     │
    ALERTMANAGER    MCP SERVER  │
    AI AGENT        N8N         │
        │                │       │
        └───────┬───────┘       │
                │                │
            ┌───┴───┐            │
            │       │            │
        FIREWALL  FIREWALL       │
        PORT 9090  PORT 3000     │
        PORT 8080  PORT 5000     │
        PORT 9093  PORT 5678     │
                │                │
            ┌───┴───┐            │
            │       │            │
        NODE      NODE           │
      EXPORTER   EXPORTER        │
      PORT 9100   PORT 9100      │
```

#### **Configuração de Firewall:**

##### **Servidor Central:**
```bash
# UFW (Ubuntu)
sudo ufw allow 9090/tcp comment "Prometheus"
sudo ufw allow 3000/tcp comment "Grafana"
sudo ufw allow 8080/tcp comment "MCP Server"
sudo ufw allow 5000/tcp comment "AI Agent"
sudo ufw allow 9093/tcp comment "Alertmanager"
sudo ufw allow 5678/tcp comment "n8n"

# iptables (Linux tradicional)
sudo iptables -A INPUT -p tcp --dport 9090 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 3000 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 5000 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 9093 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 5678 -j ACCEPT
sudo iptables-save > /etc/iptables/rules.v4
```

##### **Servidores Remotos:**
```bash
# UFW (Ubuntu)
sudo ufw allow 9100/tcp comment "Node Exporter"

# iptables (Linux tradicional)
sudo iptables -A INPUT -p tcp --dport 9100 -j ACCEPT
sudo iptables-save > /etc/iptables/rules.v4
```

### **🔧 Configuração de Rede:**

#### **Prometheus - Targets Remotos:**
```yaml
scrape_configs:
  - job_name: 'node-exporter-remoto-1'
    static_configs:
      - targets: ['192.168.1.100:9100']
        labels:
          instance: 'servidor-remoto-1'
          environment: 'producao'

  - job_name: 'node-exporter-remoto-2'
    static_configs:
      - targets: ['192.168.1.101:9100']
        labels:
          instance: 'servidor-remoto-2'
          environment: 'producao'
```

---

## 🔍 **MONITORAMENTO ESPECÍFICO**

### **☎️ Asterisk - Configuração:**

#### **Métricas Disponíveis:**
```promql
# Chamadas ativas
asterisk_calls_active

# Status dos peers
asterisk_peer_status

# Qualidade das chamadas
asterisk_call_quality

# Uso de troncos
asterisk_trunk_usage
```

#### **Regras de Alerta:**
```yaml
- alert: AsteriskSemChamadas
  expr: asterisk_calls_active == 0
  for: 5m
  labels:
    severity: warning
  annotations:
    summary: "Asterisk sem chamadas ativas"
    description: "Nenhuma chamada ativa detectada por 5 minutos"

- alert: PeerOffline
  expr: asterisk_peer_status == 0
  for: 2m
  labels:
    severity: critical
  annotations:
    summary: "Peer Asterisk offline"
    description: "Peer {{ $labels.peer }} está offline"
```

### **🌐 Aplicações Web - Monitoramento:**

#### **Métricas HTTP:**
```promql
# Tempo de resposta
http_request_duration_seconds

# Taxa de erro
rate(http_requests_total{status=~"5.."}[5m])

# Requisições por segundo
rate(http_requests_total[5m])
```

---

## 🚨 **TROUBLESHOOTING AVANÇADO**

### **❌ Problemas Comuns e Soluções:**

#### **1. Prometheus não coleta métricas:**
```bash
# Verificar targets
curl http://localhost:9090/api/v1/targets

# Verificar configuração
docker-compose exec prometheus cat /etc/prometheus/prometheus.yml

# Ver logs
docker-compose logs prometheus

# Recarregar configuração
curl -X POST http://localhost:9090/-/reload
```

#### **2. Grafana não acessa Prometheus:**
```bash
# Verificar fonte de dados
# Acesse: http://localhost:3000/datasources

# URL correta: http://prometheus:9090
# (não localhost:9090)

# Testar conectividade
docker-compose exec grafana curl http://prometheus:9090/api/v1/status/targets
```

#### **3. MCP Server não responde:**
```bash
# Verificar logs
docker-compose logs mcp-server

# Verificar conectividade Prometheus
docker-compose exec mcp-server curl http://prometheus:9090/api/v1/status/targets

# Verificar configuração
docker-compose exec mcp-server cat /app/config/mcp-server.yml

# Reiniciar container
docker-compose restart mcp-server
```

#### **4. AI Agent com erro de conexão:**
```bash
# Verificar variáveis de ambiente
docker-compose exec ai-agent env | grep MCP

# Verificar conectividade MCP
docker-compose exec ai-agent curl http://mcp-server:8080/health

# Ver logs
docker-compose logs ai-agent

# Verificar arquivo .env
cat .env
```

### **🔧 Comandos de Diagnóstico:**

#### **Verificar Status Geral:**
```bash
# Status de todos os containers
docker-compose ps

# Logs em tempo real
docker-compose logs -f

# Uso de recursos
docker stats

# Espaço em disco
df -h

# Memória disponível
free -h
```

#### **Verificar Conectividade:**
```bash
# Portas abertas
netstat -tlnp

# Teste de conectividade
curl -v http://localhost:9090/api/v1/status/targets
curl -v http://localhost:3000/api/health
curl -v http://localhost:8080/health
curl -v http://localhost:5000/health
```

---

## 📈 **PERFORMANCE E OTIMIZAÇÃO**

### **🔧 Otimizações do Prometheus:**

#### **Configurações de Performance:**
```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s
  scrape_timeout: 10s

storage:
  tsdb:
    retention.time: 30d
    retention.size: 50GB
    min-block-duration: 2h
    max-block-duration: 24h

scrape_configs:
  - job_name: 'node-exporter'
    scrape_interval: 15s
    scrape_timeout: 10s
    static_configs:
      - targets: ['localhost:9100']
```

#### **Alertas de Performance:**
```yaml
- alert: PrometheusLento
  expr: prometheus_target_scrape_pool_targets < 1
  for: 1m
  labels:
    severity: warning
  annotations:
    summary: "Prometheus com problemas de performance"
    description: "Targets não estão sendo coletados"

- alert: PrometheusAltoUso
  expr: process_cpu_seconds_total > 0.8
  for: 5m
  labels:
    severity: warning
  annotations:
    summary: "Prometheus com alto uso de CPU"
    description: "CPU em {{ $value }}%"
```

### **📊 Otimizações do Grafana:**

#### **Configurações de Cache:**
```ini
[unified_alerting]
enabled = true

[alerting]
enabled = false

[metrics]
enabled = true
interval_seconds = 10

[security]
allow_embedding = true
cookie_secure = false
```

---

## 🔒 **SEGURANÇA E AUDITORIA**

### **🔐 Configurações de Segurança:**

#### **Grafana:**
```ini
[security]
admin_user = admin
admin_password = senha_forte_aqui
allow_sign_up = false
cookie_secure = true
cookie_samesite = strict

[auth.anonymous]
enabled = false

[auth.basic]
enabled = true
```

#### **Prometheus:**
```yaml
# Configurar autenticação se necessário
# Usar reverse proxy com autenticação
# Limitar acesso por IP se necessário
```

### **📝 Sistema de Auditoria:**

#### **Logs de Ações:**
```python
def log_action(action, data):
    """Log de ações para auditoria"""
    log_entry = {
        "timestamp": datetime.now().isoformat(),
        "action": action,
        "data": data,
        "user": "system",
        "ip": request.remote_addr
    }
    
    # Salvar log
    with open("logs/actions.log", "a") as f:
        f.write(json.dumps(log_entry) + "\n")
```

#### **Monitoramento de Acesso:**
```yaml
# Alertas de segurança
- alert: AcessoNaoAutorizado
  expr: increase(http_requests_total{status="403"}[5m]) > 10
  for: 1m
  labels:
    severity: critical
  annotations:
    summary: "Muitos acessos não autorizados"
    description: "{{ $value }} tentativas de acesso não autorizado em 5 minutos"
```

---

## 🚀 **ESCALABILIDADE E BACKUP**

### **📈 Estratégias de Escalabilidade:**

#### **Horizontal Scaling:**
```yaml
# Múltiplas instâncias Prometheus
scrape_configs:
  - job_name: 'prometheus-cluster'
    static_configs:
      - targets: ['prometheus-1:9090', 'prometheus-2:9090']

# Load balancer para Grafana
# Múltiplas instâncias n8n
# Cluster de MCP Servers
```

#### **Vertical Scaling:**
```yaml
# Aumentar recursos dos containers
services:
  prometheus:
    deploy:
      resources:
        limits:
          memory: 4G
          cpus: '2.0'
        reservations:
          memory: 2G
          cpus: '1.0'
```

### **💾 Estratégias de Backup:**

#### **Backup Automático:**
```bash
#!/bin/bash
# backup_prometheus_tsdb.sh

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backup/prometheus"
PROMETHEUS_DATA="/prometheus"

# Criar backup
tar -czf "$BACKUP_DIR/prometheus_$DATE.tar.gz" -C "$PROMETHEUS_DATA" .

# Manter apenas últimos 7 backups
find "$BACKUP_DIR" -name "prometheus_*.tar.gz" -mtime +7 -delete

# Log do backup
echo "$(date): Backup criado: prometheus_$DATE.tar.gz" >> /var/log/backup.log
```

#### **Backup do Grafana:**
```bash
#!/bin/bash
# backup_grafana.sh

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backup/grafana"
GRAFANA_DATA="/var/lib/grafana"

# Backup de dashboards
curl -s "http://admin:admin@localhost:3000/api/search" | jq -r '.[].url' | \
while read dashboard; do
    dashboard_id=$(echo $dashboard | cut -d'/' -f2)
    curl -s "http://admin:admin@localhost:3000/api/dashboards/uid/$dashboard_id" > \
    "$BACKUP_DIR/dashboard_$dashboard_id.json"
done

# Backup de dados
tar -czf "$BACKUP_DIR/grafana_$DATE.tar.gz" -C "$GRAFANA_DATA" .

# Limpar backups antigos
find "$BACKUP_DIR" -name "grafana_*.tar.gz" -mtime +7 -delete
```

---

## 📚 **REFERÊNCIAS E RECURSOS**

### **🔗 Documentação Oficial:**
- **Prometheus:** https://prometheus.io/docs/
- **Grafana:** https://grafana.com/docs/
- **Alertmanager:** https://prometheus.io/docs/alerting/latest/alertmanager/
- **Node Exporter:** https://prometheus.io/docs/guides/node-exporter/

### **📖 Recursos Adicionais:**
- **PromQL:** https://prometheus.io/docs/prometheus/latest/querying/
- **Docker Compose:** https://docs.docker.com/compose/
- **Google Gemini:** https://ai.google.dev/
- **n8n:** https://docs.n8n.io/

### **🧪 Exemplos e Casos de Uso:**
- **Dashboards:** Diretório `Grafana/dashboards/`
- **Workflows:** Diretório `n8n/workflows/`
- **Scripts:** Diretório `Script/`
- **Testes:** Diretório `tests/`

---

## 🎯 **CONCLUSÃO**

Esta documentação técnica fornece uma **visão completa e detalhada** do Sistema de Monitoramento Linux Inteligente, permitindo:

- 🔧 **Configuração avançada** de todos os componentes
- 🚀 **Otimização de performance** e escalabilidade
- 🔒 **Implementação de segurança** e auditoria
- 🚨 **Troubleshooting eficiente** de problemas
- 📈 **Expansão e customização** do sistema

**🚀 Use esta documentação para transformar seu sistema em uma solução de monitoramento enterprise-level!**

