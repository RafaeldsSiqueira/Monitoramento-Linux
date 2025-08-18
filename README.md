# 🚀 Sistema de Monitoramento Linux Inteligente

**Transforme sua infraestrutura em um sistema inteligente e autônomo!**

[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://docker.com)
[![Prometheus](https://img.shields.io/badge/Prometheus-v2.47.0-red.svg)](https://prometheus.io)
[![Grafana](https://img.shields.io/badge/Grafana-v10.2.0-orange.svg)](https://grafana.com)
[![Python](https://img.shields.io/badge/Python-3.11+-green.svg)](https://python.org)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## 🌟 **Visão Geral**

Este é um **sistema de monitoramento enterprise-level** que combina as melhores tecnologias de observabilidade com **inteligência artificial** para criar uma solução de monitoramento **autônoma e inteligente**.

### **🚀 Principais Recursos**

- **📊 Monitoramento Completo**: Prometheus + Grafana + Alertmanager
- **🤖 AI Agent Inteligente**: Integração com Google Gemini para análise avançada
- **🚀 MCP Server**: Model Context Protocol para acesso em tempo real às métricas
- **☎️ Monitoramento Asterisk**: Regras específicas para telefonia IP
- **🔄 Automação n8n**: Workflows inteligentes baseados em alertas
- **📱 Notificações Multi-canal**: Email, Telegram, Slack, Webhooks
- **🐳 Containerizado**: Docker Compose para fácil implantação
- **📈 Escalável**: Suporte a monitoramento distribuído

## 🏗️ **Arquitetura do Sistema**

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Node Exporter │    │    Prometheus   │    │   Alertmanager  │
│   (Métricas)    │───▶│   (TSDB)        │───▶│   (Alertas)     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │                       │
                                ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   MCP Server    │    │     Grafana     │    │      n8n        │
│   (Protocolo)   │◀───│   (Dashboards)  │    │   (Automação)   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │                       │
                                ▼                       ▼
                       ┌─────────────────┐    ┌─────────────────┐
                       │   AI Agent      │    │   Notificações  │
                       │   (Gemini AI)   │    │   (Multi-canal) │
                       └─────────────────┘    └─────────────────┘
```

## 🚀 **Como Executar**

### **📋 Pré-requisitos**

- **Sistema Operacional**: Linux (Ubuntu 20.04+, CentOS 8+, Debian 11+)
- **Docker**: Versão 20.10+
- **Docker Compose**: Versão 2.0+
- **Memória RAM**: Mínimo 4GB (Recomendado 8GB+)
- **Disco**: Mínimo 20GB livre

### **⚡ Instalação Rápida**

#### **Opção 1: Instalação Completa do Zero**
```bash
# Baixar e executar o instalador completo
curl -fsSL https://raw.githubusercontent.com/seu-usuario/Monitoramento_Linux/main/install_monitoring_system.sh | bash
```

#### **Opção 2: Setup Manual (Docker já instalado)**
```bash
# 1. Clonar o repositório
git clone https://github.com/seu-usuario/Monitoramento_Linux.git
cd Monitoramento_Linux

# 2. Configurar variáveis de ambiente
cp env.example .env
# Editar .env com suas configurações

# 3. Executar setup
./setup.sh
```

### **🔧 Configuração**

#### **📝 Arquivo .env (Obrigatório)**
```bash
# API Keys
GOOGLE_API_KEY=sua_chave_api_gemini
EMAIL_USERNAME=seu_email@gmail.com
EMAIL_PASSWORD=sua_senha_do_email

# Emails
DEFAULT_EMAIL=admin@exemplo.com
AUDIT_EMAIL=audit@exemplo.com

# Configurações SMTP
SMTP_SERVER=smtp.gmail.com
SMTP_PORT=587
```

**📖 [Guia Completo de Configuração](docs/GUIA_INSTALACAO.md)**

## 🌐 **Acessos Disponíveis**

| Serviço | Porta | URL | Descrição |
|---------|-------|-----|-----------|
| **Grafana** | 3000 | http://localhost:3000 | Dashboards e visualização |
| **Prometheus** | 9090 | http://localhost:9090 | Métricas e alertas |
| **Alertmanager** | 9093 | http://localhost:9093 | Gerenciamento de alertas |
| **AI Agent** | 5000 | http://localhost:5000 | Interface inteligente |
| **MCP Server** | 8080 | http://localhost:8080 | Protocolo de contexto |
| **n8n** | 5678 | http://localhost:5678 | Automação de workflows |
| **Node Exporter** | 9100 | http://localhost:9100 | Métricas do sistema |

**🔑 Credenciais Padrão:**
- **Grafana**: `admin` / `admin`
- **n8n**: Criar conta no primeiro acesso

## 📊 **Funcionalidades Principais**

### **🤖 AI Agent Inteligente**
- **Análise Automática**: Identifica problemas antes que se tornem críticos
- **Recomendações**: Sugestões baseadas em IA para otimização
- **Interface Web**: Dashboard interativo para controle total
- **Integração Gemini**: Análise avançada com Google AI

### **🚀 MCP Server (Model Context Protocol)**
- **Acesso em Tempo Real**: Métricas instantâneas para o AI Agent
- **Protocolo Padrão**: Interface padronizada para IA
- **Performance**: Resposta em milissegundos
- **Escalabilidade**: Suporte a múltiplas instâncias

### **☎️ Monitoramento Asterisk**
- **Regras Específicas**: Alertas para telefonia IP
- **Métricas VoIP**: Qualidade de chamada, peers, troncos
- **Alertas Inteligentes**: Notificações baseadas em thresholds
- **Integração Completa**: Prometheus + Alertmanager

### **🔄 Automação n8n**
- **Workflows Inteligentes**: Automação baseada em alertas
- **Integração Multi-serviço**: Conecta todos os componentes
- **Templates Prontos**: Workflows para cenários comuns
- **Escalabilidade**: Suporte a múltiplos nós

## 📈 **Dashboards e Visualizações**

### **📊 Grafana Dashboards**
- **Sistema Operacional**: CPU, memória, disco, rede
- **Serviços**: Status de todos os componentes
- **Asterisk**: Métricas específicas de telefonia
- **Customizáveis**: Crie seus próprios dashboards

### **📊 Prometheus Queries**
- **PromQL Avançado**: Consultas complexas e agregações
- **Alertas Inteligentes**: Regras baseadas em thresholds
- **Histórico**: Análise de tendências e padrões
- **Exportação**: Integração com outros sistemas

## 🚨 **Sistema de Alertas**

### **📋 Regras de Alerta**
- **Sistema Operacional**: CPU, memória, disco, rede
- **Serviços**: Prometheus, Grafana, Alertmanager
- **Asterisk**: Chamadas, peers, troncos, qualidade
- **AI Agent**: Performance e saúde do sistema

### **🔔 Notificações**
- **Email**: Alertas detalhados com HTML
- **Telegram**: Notificações instantâneas
- **Slack**: Integração com equipes
- **Webhooks**: Automação personalizada

## 🐳 **Deploy com Docker**

### **📦 Containers Disponíveis**
```yaml
services:
  prometheus:     # Coleta e armazenamento de métricas
  grafana:        # Visualização e dashboards
  alertmanager:   # Gerenciamento de alertas
  node-exporter:  # Métricas do sistema operacional
  mcp-server:     # Protocolo de contexto para IA
  ai-agent:       # Agente de inteligência artificial
  n8n:            # Automação de workflows
```

### **🚀 Comandos Úteis**
```bash
# Iniciar todos os serviços
docker-compose up -d

# Ver logs em tempo real
docker-compose logs -f

# Parar todos os serviços
docker-compose down

# Reconstruir e reiniciar
docker-compose up -d --build

# Ver status dos serviços
docker-compose ps
```

## 🌐 **Monitoramento Distribuído**

### **📡 Instalação em Nós Remotos**
```bash
# Script para instalar Node Exporter em servidores remotos
./install_node_exporter.sh

# Configurar no Prometheus central
# Adicionar IPs dos servidores remotos no prometheus.yml
```

### **🏗️ Arquitetura Distribuída**
- **Servidor Central**: Prometheus + Grafana + Alertmanager
- **Nós Remotos**: Node Exporter para coleta de métricas
- **Escalabilidade**: Suporte a centenas de servidores
- **Redundância**: Configuração de alta disponibilidade

## 🧪 **Testes e Validação**

### **📋 Scripts de Teste**
```bash
# Executar todos os testes
./tests/run_all_tests.sh

# Teste individual
./tests/test_individual.sh

# Validação rápida
./tests/quick_test.sh
```

**📖 [Guia Completo de Testes](docs/GUIA_INSTALACAO.md#testes)**

## 📚 **Documentação Completa**

- **[📖 Visão Geral](docs/README.md)** - Objetivos e vantagens do projeto
- **[🔧 Guia de Instalação](docs/GUIA_INSTALACAO.md)** - Instalação, configuração e testes
- **[⚙️ Documentação Técnica](docs/DOCUMENTACAO_TECNICA.md)** - Arquitetura, APIs e configurações avançadas

## 🚀 **Vantagens do Sistema**

### **💡 Inteligência Artificial**
- **Análise Proativa**: Identifica problemas antes que ocorram
- **Otimização Automática**: Sugestões para melhorar performance
- **Redução de Falsos Positivos**: IA filtra alertas irrelevantes
- **Insights Valiosos**: Análise de padrões e tendências

### **🔧 Tecnologia Enterprise**
- **Prometheus**: Padrão da indústria para monitoramento
- **Grafana**: Visualização profissional e customizável
- **Docker**: Implantação consistente e escalável
- **MCP**: Protocolo padrão para IA

### **📈 Escalabilidade**
- **Monitoramento Distribuído**: Centenas de servidores
- **Arquitetura Modular**: Adicione novos componentes facilmente
- **Performance**: Otimizado para grandes volumes de dados
- **Flexibilidade**: Adapte às suas necessidades

### **🛡️ Segurança e Confiabilidade**
- **Usuários Não-root**: Containers seguros
- **Secrets Management**: Gerenciamento seguro de credenciais
- **Logs Estruturados**: Auditoria completa
- **Backup Automático**: Preservação de dados

## 🤝 **Contribuição**

### **📝 Como Contribuir**
1. **Fork** o projeto
2. **Crie** uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. **Commit** suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. **Push** para a branch (`git push origin feature/AmazingFeature`)
5. **Abra** um Pull Request

### **🐛 Reportar Bugs**
- Use o sistema de [Issues](https://github.com/seu-usuario/Monitoramento_Linux/issues)
- Inclua logs, screenshots e passos para reproduzir
- Descreva o comportamento esperado vs. atual

## 📄 **Licença**

Este projeto está licenciado sob a **Licença MIT** - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 🙏 **Agradecimentos**

- **Prometheus Community** - Sistema de monitoramento
- **Grafana Labs** - Visualização de dados
- **Google Gemini** - Inteligência artificial
- **n8n** - Automação de workflows
- **Docker** - Containerização

## 📞 **Suporte**

- **📧 Email**: suporte@exemplo.com
- **💬 Discord**: [Servidor da Comunidade](https://discord.gg/exemplo)
- **📖 Wiki**: [Documentação Completa](docs/)
- **🐛 Issues**: [GitHub Issues](https://github.com/seu-usuario/Monitoramento_Linux/issues)

---

**🚀 Transforme sua infraestrutura em um sistema inteligente e autônomo!**

**Feito com 💻 por Rafael** - Focado em Linux, DevOps, IA e automações inteligentes.

---

<div align="center">

**⭐ Se este projeto te ajudou, considere dar uma estrela! ⭐**

[![GitHub stars](https://img.shields.io/github/stars/seu-usuario/Monitoramento_Linux?style=social)](https://github.com/seu-usuario/Monitoramento_Linux)
[![GitHub forks](https://img.shields.io/github/forks/seu-usuario/Monitoramento_Linux?style=social)](https://github.com/seu-usuario/Monitoramento_Linux)
[![GitHub issues](https://img.shields.io/github/issues/seu-usuario/Monitoramento_Linux)](https://github.com/seu-usuario/Monitoramento_Linux/issues)

</div>