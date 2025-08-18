# 🚀 **GUIA DE INSTALAÇÃO - SISTEMA DE MONITORAMENTO LINUX INTELIGENTE**

## 📋 **VISÃO GERAL**

Este guia fornece instruções **passo a passo** para instalar, configurar e testar o sistema de monitoramento inteligente completo.

---

## 🎯 **OPÇÕES DE INSTALAÇÃO**

### **1. 🚀 Instalação Completa do Zero**
- **Para:** Sistemas sem Docker ou dependências
- **Script:** `install_monitoring_system.sh`
- **Inclui:** Docker, Docker Compose, projeto completo

### **2. 🔧 Configuração Rápida**
- **Para:** Sistemas com Docker já instalado
- **Script:** `setup.sh`
- **Inclui:** Configuração e inicialização dos serviços

### **3. 🌐 Instalação em Máquinas Remotas**
- **Para:** Adicionar servidores ao monitoramento
- **Script:** `install_node_exporter.sh`
- **Inclui:** Node Exporter para métricas remotas

---

## 🚀 **OPÇÃO 1: INSTALAÇÃO COMPLETA DO ZERO**

### **📋 Pré-requisitos:**
- Sistema Linux (Ubuntu 20.04+, CentOS 8+, Debian 11+)
- Usuário com privilégios sudo
- Conexão com internet
- Mínimo 4GB RAM, 20GB disco

### **🔧 Execução:**
```bash
# Baixar projeto
git clone <seu-repositorio>
cd Monitoramento_Linux

# Executar instalação completa
chmod +x install_monitoring_system.sh
./install_monitoring_system.sh
```

### **📝 O que o script faz:**
1. **Verifica sistema operacional**
2. **Instala dependências** (curl, wget, git)
3. **Instala Docker** e Docker Compose
4. **Configura permissões** Docker
5. **Baixa projeto** e configura `.env`
6. **Executa setup** automático
7. **Verifica instalação** completa

---

## 🔧 **OPÇÃO 2: CONFIGURAÇÃO RÁPIDA**

### **📋 Pré-requisitos:**
- Docker e Docker Compose instalados
- Projeto baixado
- Usuário no grupo docker

### **🔧 Execução:**
```bash
# Verificar Docker
docker --version
docker-compose --version

# Executar setup
chmod +x setup.sh
./setup.sh
```

### **📝 O que o script faz:**
1. **Verifica pré-requisitos** (Docker, Docker Compose)
2. **Cria arquivo .env** se não existir
3. **Valida configurações** obrigatórias
4. **Cria diretórios** necessários
5. **Configura permissões** (Grafana, Prometheus)
6. **Inicia serviços** via Docker Compose
7. **Verifica status** dos containers
8. **Mostra informações** de acesso

---

## 🌐 **OPÇÃO 3: INSTALAÇÃO EM MÁQUINAS REMOTAS**

### **📋 Pré-requisitos:**
- Sistema Linux remoto
- Acesso SSH com sudo
- Porta 9100 disponível
- Conectividade com servidor central

### **🔧 Execução:**
```bash
# No servidor remoto
chmod +x install_node_exporter.sh
./install_node_exporter.sh
```

### **📝 O que o script faz:**
1. **Verifica sistema operacional**
2. **Instala dependências** (curl, wget, systemd)
3. **Baixa Node Exporter** (versão mais recente)
4. **Cria usuário dedicado** (node_exporter)
5. **Configura serviço systemd**
6. **Configura firewall** (UFW/firewalld)
7. **Inicia e habilita** serviço
8. **Verifica instalação**

---

## ⚙️ **CONFIGURAÇÃO DO ARQUIVO .ENV**

### **📝 Criar arquivo .env:**
```bash
# Copiar exemplo
cp env.example .env

# Editar configurações
nano .env
```

### **🔑 Variáveis obrigatórias:**
```bash
# API Google Gemini (obrigatório)
GOOGLE_API_KEY=sua_chave_api_gemini_aqui

# Email para relatórios (obrigatório)
EMAIL_ADDRESS=seu_email@gmail.com
EMAIL_PASSWORD=sua_senha_do_email

# Email para auditoria (obrigatório)
AUDIT_EMAIL=audit@exemplo.com
```

### **🔧 Variáveis opcionais:**
```bash
# URL do servidor MCP (padrão: http://mcp-server:8080)
MCP_SERVER_URL=http://mcp-server:8080

# Configurações avançadas
LOG_LEVEL=info
REQUEST_TIMEOUT=30
SCRAPE_INTERVAL=15
RETENTION_DAYS=30
```

---

## 🧪 **TESTES E VALIDAÇÃO**

### **🚀 Teste Rápido:**
```bash
# Validação básica do sistema
cd tests/
./quick_test.sh
```

### **🧪 Teste Individual:**
```bash
# Menu interativo de testes
./test_individual.sh
```

### **🧪 Todos os Testes:**
```bash
# Validação completa
./run_all_tests.sh
```

### **🔍 Teste MCP Específico:**
```bash
# Teste do sistema MCP
python3 test_mcp.py
```

---

## 📊 **VERIFICAÇÃO DOS SERVIÇOS**

### **🔍 Status dos Containers:**
```bash
# Verificar todos os serviços
docker-compose ps

# Ver logs específicos
docker-compose logs prometheus
docker-compose logs grafana
docker-compose logs mcp-server
docker-compose logs ai-agent
```

### **🌐 Testes de Conectividade:**
```bash
# Prometheus
curl http://localhost:9090/api/v1/status/targets

# Grafana
curl http://localhost:3000/api/health

# MCP Server
curl http://localhost:8080/health

# AI Agent
curl http://localhost:5000/health
```

---

## 🎯 **ACESSOS DISPONÍVEIS**

### **📊 Interfaces Web:**
- **Prometheus:** http://localhost:9090
- **Grafana:** http://localhost:3000 (admin/admin)
- **Alertmanager:** http://localhost:9093
- **n8n:** http://localhost:5678 (admin/admin123)
- **AI Agent:** http://localhost:5000
- **MCP Server:** http://localhost:8080

### **🔧 Comandos Úteis:**
```bash
# Ver logs em tempo real
docker-compose logs -f

# Parar todos os serviços
docker-compose down

# Reiniciar serviços
docker-compose restart

# Reconstruir containers
docker-compose up -d --build
```

---

## 🔧 **CONFIGURAÇÕES AVANÇADAS**

### **📊 Prometheus:**
```bash
# Editar configuração
nano Prometheus/prometheus.yml

# Editar regras de alerta
nano Prometheus/regras.yml

# Recarregar configuração
curl -X POST http://localhost:9090/-/reload
```

### **📈 Grafana:**
```bash
# Configurar fontes de dados
# Acesse: http://localhost:3000
# Usuário: admin
# Senha: admin

# Importar dashboards
# Dashboards disponíveis em: Grafana/dashboards/
```

### **🚨 Alertmanager:**
```bash
# Editar configuração
nano Alertmanager/alertmanager.yml

# Configurar notificações
# Telegram, email, webhooks
```

---

## 🌐 **CONFIGURAÇÃO DISTRIBUÍDA**

### **🏗️ Arquitetura:**
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  Servidor       │    │  Servidor       │    │  Servidor       │
│   Central       │◄───┤   Remoto 1      │◄───┤   Remoto N      │
│                 │    │                 │    │                 │
│ • Prometheus    │    │ • Node Exporter │    │ • Node Exporter │
│ • Grafana       │    │ • Porta 9100    │    │ • Porta 9100    │
│ • Alertmanager  │    │                 │    │                 │
│ • MCP Server    │    └─────────────────┘    └─────────────────┘
│ • AI Agent      │
└─────────────────┘
```

### **🔧 Configuração:**
1. **Instalar Node Exporter** em cada servidor remoto
2. **Adicionar targets** no `prometheus.yml` central
3. **Configurar regras** de alerta específicas
4. **Testar conectividade** entre servidores

---

## 🚨 **TROUBLESHOOTING COMUM**

### **❌ Docker não inicia:**
```bash
# Verificar status
sudo systemctl status docker

# Iniciar serviço
sudo systemctl start docker

# Verificar permissões
sudo usermod -aG docker $USER
newgrp docker
```

### **❌ Containers não sobem:**
```bash
# Ver logs
docker-compose logs

# Verificar portas
netstat -tlnp | grep -E "(3000|5000|8080|9090|9093)"

# Verificar arquivo .env
cat .env
```

### **❌ Grafana não acessa:**
```bash
# Verificar permissões
sudo chown -R 472:472 Grafana/data

# Ver logs
docker-compose logs grafana

# Reiniciar container
docker-compose restart grafana
```

### **❌ MCP Server não responde:**
```bash
# Verificar logs
docker-compose logs mcp-server

# Verificar conectividade Prometheus
curl http://prometheus:9090/api/v1/status/targets

# Verificar configuração
cat mcp-server/config/mcp-server.yml
```

---

## 📚 **PRÓXIMOS PASSOS**

### **1. 🎯 Configuração Básica:**
- ✅ Sistema instalado e funcionando
- ✅ Serviços rodando
- ✅ Interfaces acessíveis
- ✅ Testes passando

### **2. 🔧 Personalização:**
- 📊 Dashboards personalizados
- 🚨 Regras de alerta específicas
- 🤖 Workflows n8n automatizados
- 📧 Notificações configuradas

### **3. 🌐 Expansão:**
- 📡 Adicionar servidores remotos
- 🔍 Monitoramento específico (Asterisk, etc.)
- 📈 Métricas customizadas
- 🚀 Automações avançadas

---

## 🎉 **INSTALAÇÃO CONCLUÍDA!**

### **✅ O que foi instalado:**
- 🐳 **Docker** e **Docker Compose**
- 📊 **Prometheus** para coleta de métricas
- 📈 **Grafana** para visualização
- 🚨 **Alertmanager** para alertas
- 🤖 **AI Agent** com Google Gemini
- 🚀 **MCP Server** para acesso em tempo real
- 🔄 **n8n** para automação
- 📡 **Node Exporter** para métricas do sistema

### **🚀 Próximos passos:**
1. **Configure suas credenciais** no arquivo `.env`
2. **Execute os testes** para validar o sistema
3. **Personalize dashboards** e alertas
4. **Explore as funcionalidades** do AI Agent
5. **Configure automações** com n8n

---

## 🤝 **SUPORTE**

### **📧 Problemas comuns:**
- Consulte este guia
- Verifique os logs dos containers
- Execute os scripts de teste
- Consulte a documentação técnica

### **🔧 Recursos adicionais:**
- **Documentação Técnica:** [DOCUMENTACAO_TECNICA.md](DOCUMENTACAO_TECNICA.md)
- **Visão Geral:** [README.md](README.md)
- **Sistema de Testes:** `tests/` directory

---

## 🎯 **CONCLUSÃO**

Com este guia, você instalou um **sistema de monitoramento inteligente** completo e profissional. O sistema está pronto para:

- 📊 **Monitorar** sua infraestrutura 24/7
- 🤖 **Analisar** dados com inteligência artificial
- 🚨 **Alertar** proativamente sobre problemas
- 🔄 **Automatizar** respostas a incidentes
- 📈 **Otimizar** recursos automaticamente

**🚀 Bem-vindo ao futuro do monitoramento de infraestrutura!**

