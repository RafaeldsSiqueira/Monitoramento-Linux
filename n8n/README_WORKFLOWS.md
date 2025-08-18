# 🔄 WORKFLOWS N8N - SISTEMA DE MONITORAMENTO INTELIGENTE

## 📋 VISÃO GERAL

Este diretório contém os workflows do n8n que automatizam todo o sistema de monitoramento inteligente, integrando MCP Server, AI Agent e todos os componentes do projeto.

---

## 🚀 WORKFLOWS DISPONÍVEIS

### **1️⃣ `monitoring_system_workflow.json`**
**Sistema de Monitoramento Inteligente**

#### **🎯 Função:**
Workflow principal que processa alertas do Prometheus e integra com MCP Server e AI Agent.

#### **📊 Triggers:**
- **Webhook - Alertas:** Recebe alertas do Alertmanager
- **Webhook - MCP:** Recebe dados do MCP Server

#### **🔄 Fluxo:**
```
Alertas → Filtros → MCP Analysis → AI Agent → Notificações → Ações
```

#### **🔧 Funcionalidades:**
- **Filtragem de alertas** por severidade e categoria
- **Análise inteligente** via MCP Server
- **Processamento IA** via AI Agent
- **Notificações multi-canal** (Email, Telegram)
- **Ações automáticas** (Backup, Reinicialização)
- **Criação de tickets** para incidentes

#### **📱 Canais de Notificação:**
- **Email crítico** para alertas críticos
- **Telegram** para alertas Asterisk
- **Notificação de equipe** para problemas graves

---

### **2️⃣ `system_health_workflow.json`**
**Monitoramento de Saúde do Sistema**

#### **🎯 Função:**
Workflow agendado que monitora a saúde de todos os serviços do sistema.

#### **⏰ Trigger:**
- **Agendamento:** Executa a cada 5 minutos

#### **🔍 Verificações:**
- **Prometheus** (9090)
- **MCP Server** (8080)
- **AI Agent** (5000)
- **Grafana** (3000)
- **Alertmanager** (9093)
- **Node Exporter** (9100)

#### **🔄 Fluxo:**
```
Agendamento → Health Checks → MCP Analysis → AI Analysis → Ações
```

#### **🔧 Funcionalidades:**
- **Verificação de saúde** de todos os serviços
- **Análise contextual** via MCP Server
- **Análise inteligente** via AI Agent
- **Notificação** de problemas de saúde
- **Backup agendado** automático
- **Limpeza de logs** periódica

---

### **3️⃣ `asterisk_monitoring_workflow.json`**
**Monitoramento Específico Asterisk**

#### **🎯 Função:**
Workflow especializado para monitoramento e automação de alertas Asterisk.

#### **📞 Triggers:**
- **Webhook Asterisk:** Recebe alertas específicos do Asterisk

#### **🚨 Tipos de Alertas:**
- **AsteriskOffline:** Servidor Asterisk offline
- **AsteriskPeerOffline:** Peer SIP offline
- **AsteriskQualidadeBaixa:** Qualidade de chamada baixa

#### **🔄 Fluxo:**
```
Alerta Asterisk → Filtro → AI Analysis → Telegram → Ações Específicas
```

#### **🔧 Funcionalidades:**
- **Análise específica** para problemas Asterisk
- **Notificações Telegram** formatadas
- **Reinicialização automática** do Asterisk
- **Diagnóstico de peers** offline
- **Otimização de qualidade** de chamadas
- **Criação de tickets** Asterisk

---

## 🔧 CONFIGURAÇÃO DOS WORKFLOWS

### **📥 Importação:**
1. Acesse o n8n: `http://localhost:5678`
2. Login: `admin` / `admin123`
3. Clique em **"Import from file"**
4. Selecione os arquivos `.json` dos workflows

### **⚙️ Configuração de Variáveis:**
```bash
# Variáveis de ambiente necessárias:
AUDIT_EMAIL=seu-email@exemplo.com
TELEGRAM_BOT_TOKEN=seu-token-bot
TELEGRAM_CHAT_ID=seu-chat-id
```

### **🔗 Configuração de Webhooks:**
```bash
# URLs dos webhooks:
http://localhost:5678/webhook-alert
http://localhost:5678/webhook-mcp
http://localhost:5678/webhook-asterisk
```

---

## 🎯 INTEGRAÇÃO COM ALERTMANAGER

### **📝 Configuração do Alertmanager:**
```yaml
receivers:
  - name: 'n8n-webhook'
    webhook_configs:
      - url: 'http://n8n:5678/webhook-alert'
        send_resolved: true
```

### **🔗 Configuração do Prometheus:**
```yaml
alerting:
  alertmanagers:
    - static_configs:
        - targets:
          - alertmanager:9093
```

---

## 🤖 INTEGRAÇÃO COM AI AGENT

### **📡 Endpoints Utilizados:**
- `http://ai-agent:5000/analyze` - Análise geral
- `http://ai-agent:5000/asterisk-analyze` - Análise Asterisk
- `http://ai-agent:5000/webhook` - Webhook AI Agent
- `http://ai-agent:5000/notify-team` - Notificação de equipe
- `http://ai-agent:5000/create-ticket` - Criação de tickets
- `http://ai-agent:5000/backup` - Backup automático
- `http://ai-agent:5000/log-action` - Log de ações

---

## 🔍 INTEGRAÇÃO COM MCP SERVER

### **📡 Endpoints Utilizados:**
- `http://mcp-server:8080/analyze` - Análise contextual
- `http://mcp-server:8080/health` - Verificação de saúde
- `http://mcp-server:8080/metrics` - Métricas do MCP

---

## 📊 FLUXO COMPLETO DO SISTEMA

### **🚨 Cenário de Alerta Crítico:**
```
1. Prometheus detecta problema
2. Alertmanager recebe alerta
3. n8n recebe webhook
4. MCP Server analisa contexto
5. AI Agent processa inteligentemente
6. Notificações enviadas (Email/Telegram)
7. Ações automáticas executadas
8. Ticket criado se necessário
```

### **📞 Cenário Asterisk:**
```
1. Asterisk Exporter detecta problema
2. Prometheus avalia regras
3. Alertmanager envia para n8n
4. Workflow Asterisk processa
5. AI Agent analisa especificamente
6. Telegram notifica equipe
7. Ações corretivas executadas
```

---

## 🔧 MANUTENÇÃO DOS WORKFLOWS

### **📊 Monitoramento:**
- **Logs do n8n:** `docker-compose logs n8n`
- **Status dos workflows:** Interface web do n8n
- **Execuções:** Histórico na interface

### **🔄 Atualizações:**
1. **Exportar** workflow atual
2. **Modificar** configurações
3. **Importar** nova versão
4. **Testar** funcionalidade

### **🧪 Testes:**
```bash
# Testar webhook de alertas
curl -X POST http://localhost:5678/webhook-alert \
  -H "Content-Type: application/json" \
  -d '{"labels":{"alertname":"TestAlert","severity":"critical"}}'

# Testar webhook MCP
curl -X POST http://localhost:5678/webhook-mcp \
  -H "Content-Type: application/json" \
  -d '{"type":"test","data":"test"}'
```

---

## 🎯 BENEFÍCIOS DOS WORKFLOWS

### **🤖 Automação Inteligente:**
- **Processamento automático** de alertas
- **Análise contextual** via MCP Server
- **Insights inteligentes** via AI Agent
- **Ações proativas** baseadas em IA

### **📱 Comunicação Multi-canal:**
- **Email** para alertas críticos
- **Telegram** para notificações rápidas
- **Tickets** para rastreamento
- **Logs** para auditoria

### **🔧 Ações Automáticas:**
- **Reinicialização** de serviços
- **Backup** de emergência
- **Diagnóstico** de problemas
- **Otimização** de performance

### **📊 Monitoramento Completo:**
- **Saúde do sistema** a cada 5 minutos
- **Alertas em tempo real**
- **Análise preditiva**
- **Correlação de eventos**

---

## 🚀 PRÓXIMOS PASSOS

### **📈 Melhorias Futuras:**
1. **Dashboards** de status dos workflows
2. **Métricas** de performance
3. **Alertas** de falha nos workflows
4. **Integração** com mais sistemas
5. **Machine Learning** avançado

### **🔗 Integrações Adicionais:**
- **Slack** para notificações
- **Jira** para tickets
- **PagerDuty** para escalação
- **Splunk** para logs
- **Datadog** para métricas

---

## ✅ CONCLUSÃO

Os workflows do n8n fornecem:
- **Automação completa** do sistema de monitoramento
- **Integração inteligente** entre todos os componentes
- **Comunicação eficiente** com a equipe
- **Ações proativas** baseadas em IA
- **Monitoramento 24/7** do sistema

**🎉 Sistema de automação inteligente totalmente operacional!**
