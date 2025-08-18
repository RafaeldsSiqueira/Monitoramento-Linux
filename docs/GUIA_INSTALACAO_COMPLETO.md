# 🚀 GUIA COMPLETO DE INSTALAÇÃO E CONFIGURAÇÃO

## 📋 PRÉ-REQUISITOS

### **💻 Sistema Operacional:**
- **Linux** (Ubuntu 20.04+ / Debian 11+)
- **4GB RAM** mínimo (8GB recomendado)
- **10GB** espaço em disco
- **Conexão com internet**

### **🔧 Software Necessário:**
- **Docker** (versão 20.10+)
- **Docker Compose** (versão 2.0+)
- **Git** (versão 2.25+)
- **Bash** (versão 4.4+)

---

## 🛠️ INSTALAÇÃO DOS PRÉ-REQUISITOS

### **1️⃣ INSTALAR DOCKER:**
```bash
# Atualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar dependências
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release

# Adicionar chave GPG do Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Adicionar repositório Docker
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Instalar Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Adicionar usuário ao grupo docker
sudo usermod -aG docker $USER

# Iniciar e habilitar Docker
sudo systemctl start docker
sudo systemctl enable docker

# Verificar instalação
docker --version
```

### **2️⃣ INSTALAR DOCKER COMPOSE:**
```bash
# Instalar Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Dar permissão de execução
sudo chmod +x /usr/local/bin/docker-compose

# Verificar instalação
docker-compose --version
```

### **3️⃣ INSTALAR GIT:**
```bash
# Instalar Git
sudo apt install -y git

# Verificar instalação
git --version
```

---

## 📥 DOWNLOAD E CONFIGURAÇÃO DO PROJETO

### **1️⃣ CLONAR O PROJETO:**
```bash
# Clonar repositório
git clone https://github.com/seu-usuario/Monitoramento_Linux.git
cd Monitoramento_Linux

# Verificar estrutura
ls -la
```

### **2️⃣ CONFIGURAR VARIÁVEIS DE AMBIENTE:**
```bash
# Copiar arquivo de exemplo
cp .env.example .env

# Editar configurações
nano .env
```

#### **📝 CONFIGURAÇÕES NECESSÁRIAS:**
```bash
# Email de auditoria (OBRIGATÓRIO)
AUDIT_EMAIL=seu-email@exemplo.com

# API Key do Google Gemini (para AI Agent)
GOOGLE_API_KEY=sua-chave-api-gemini

# Configurações de email (opcional)
EMAIL_ADDRESS=seu-email@gmail.com
EMAIL_PASSWORD=sua-senha-app

# Token do Telegram (opcional)
TELEGRAM_BOT_TOKEN=seu-token-bot
TELEGRAM_CHAT_ID=seu-chat-id
```

### **3️⃣ CONFIGURAR PERMISSÕES:**
```bash
# Dar permissão de execução ao script
chmod +x install_monitoring_system.sh

# Configurar permissões dos diretórios
sudo chown -R $USER:$USER .
chmod -R 755 .
```

### **4️⃣ CONFIGURAR FIREWALL:**
```bash
# UFW (Ubuntu)
sudo ufw allow 9090/tcp comment "Prometheus"
sudo ufw allow 3000/tcp comment "Grafana"
sudo ufw allow 8080/tcp comment "MCP Server"
sudo ufw allow 5000/tcp comment "AI Agent"
sudo ufw allow 9093/tcp comment "Alertmanager"
sudo ufw allow 5678/tcp comment "n8n"
sudo ufw allow 9100/tcp comment "Node Exporter"

# iptables (Linux tradicional)
sudo iptables -A INPUT -p tcp --dport 9090 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 3000 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 5000 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 9093 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 5678 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 9100 -j ACCEPT
sudo iptables-save > /etc/iptables/rules.v4
```

---

## 🚀 EXECUÇÃO DO SISTEMA

### **1️⃣ EXECUÇÃO AUTOMÁTICA (RECOMENDADO):**
```bash
# Executar script de instalação
./install_monitoring_system.sh
```

#### **📋 O QUE O SCRIPT FAZ:**
1. **Verifica pré-requisitos** (Docker, Docker Compose)
2. **Cria diretórios** necessários
3. **Configura permissões** dos volumes
4. **Constrói imagens** Docker
5. **Inicia todos os serviços**
6. **Verifica funcionamento**
7. **Exibe URLs de acesso**

### **2️⃣ EXECUÇÃO MANUAL:**
```bash
# Construir imagens
docker-compose build

# Iniciar serviços
docker-compose up -d

# Verificar status
docker-compose ps

# Ver logs
docker-compose logs -f
```

---

## 🔧 CONFIGURAÇÕES ESPECÍFICAS

### **1️⃣ CONFIGURAR GRAFANA:**
```bash
# Acessar Grafana
# URL: http://localhost:3000
# Login: admin
# Senha: admin

# Adicionar Prometheus como Data Source:
# 1. Settings → Data Sources
# 2. Add data source → Prometheus
# 3. URL: http://prometheus:9090
# 4. Access: Server (default)
# 5. Save & Test
```

### **2️⃣ CONFIGURAR ALERTAS:**
```bash
# Verificar regras de alerta
cat Prometheus/regras.yml

# Verificar configuração do Alertmanager
cat Alertmanager/alertmanager.yml

# Testar alertas
curl -X POST http://localhost:9093/api/v1/alerts \
  -H "Content-Type: application/json" \
  -d '[{"labels":{"alertname":"TestAlert","severity":"warning"}}]'
```

### **3️⃣ CONFIGURAR N8N:**
```bash
# Acessar n8n
# URL: http://localhost:5678
# Login: admin
# Senha: admin123

# Criar primeiro workflow:
# 1. Webhook → AI Agent → Email
# 2. Configurar triggers
# 3. Adicionar ações automáticas
```

---

## 🧪 TESTES E VALIDAÇÃO

### **1️⃣ TESTE RÁPIDO:**
```bash
# Verificar todos os serviços
curl -s http://localhost:9090/-/healthy && echo " ✅ Prometheus"
curl -s http://localhost:3000/api/health && echo " ✅ Grafana"
curl -s http://localhost:9093/-/healthy && echo " ✅ Alertmanager"
curl -s http://localhost:5000/ && echo " ✅ AI Agent"
curl -s http://localhost:5678/ && echo " ✅ n8n"
```

### **2️⃣ TESTE DE MÉTRICAS:**
```bash
# Verificar métricas do Node Exporter
curl http://localhost:9100/metrics | grep node_cpu_seconds_total

# Verificar alertas do Prometheus
curl http://localhost:9090/api/v1/alerts

# Testar MCP Server
curl http://localhost:8080/analyze
```

### **3️⃣ TESTE DE ALERTAS:**
```bash
# Simular alerta crítico
curl -X POST http://localhost:9093/api/v1/alerts \
  -H "Content-Type: application/json" \
  -d '[{"labels":{"alertname":"TestAlert","severity":"critical"}}]'
```

---

## 🌐 ACESSO AOS SERVIÇOS

### **📊 INTERFACES WEB:**

| Serviço | URL | Credenciais | Descrição |
|---------|-----|-------------|-----------|
| **📊 Prometheus** | http://localhost:9090 | - | Métricas e alertas |
| **📈 Grafana** | http://localhost:3000 | `admin/admin` | Dashboards |
| **🚨 Alertmanager** | http://localhost:9093 | - | Gerenciamento de alertas |
| **🤖 AI Agent** | http://localhost:5000 | - | Interface inteligente |
| **🔄 n8n** | http://localhost:5678 | `admin/admin123` | Automação |

---

## 🔄 COMANDOS ÚTEIS

### **📊 GERENCIAMENTO:**
```bash
# Ver status de todos os serviços
docker-compose ps

# Ver logs de um serviço específico
docker-compose logs prometheus
docker-compose logs grafana
docker-compose logs ai-agent

# Reiniciar um serviço
docker-compose restart prometheus

# Parar todos os serviços
docker-compose down

# Parar e remover volumes
docker-compose down -v
```

### **🔧 MANUTENÇÃO:**
```bash
# Backup dos dados
docker-compose exec prometheus tar -czf /tmp/prometheus-backup.tar.gz /prometheus

# Limpar logs antigos
docker system prune -f

# Atualizar imagens
docker-compose pull
docker-compose up -d
```

---

## 🆘 SOLUÇÃO DE PROBLEMAS

### **🔍 PROBLEMAS COMUNS:**

#### **Porta já em uso:**
```bash
# Verificar portas ocupadas
sudo netstat -tlnp | grep :9090

# Parar serviços conflitantes
sudo systemctl stop prometheus  # se instalado localmente
```

#### **Permissões de volume:**
```bash
# Corrigir permissões
sudo chown -R 472:472 Grafana/data
sudo chown -R 65534:65534 Prometheus/data
```

#### **AI Agent sem API Key:**
```bash
# Verificar variável de ambiente
echo $GOOGLE_API_KEY

# Reiniciar serviço
docker-compose restart ai-agent
```

#### **Container não inicia:**
```bash
# Verificar logs
docker-compose logs [nome-do-serviço]

# Reconstruir container
docker-compose build [nome-do-serviço]
docker-compose up -d [nome-do-serviço]
```

---

## 📈 MONITORAMENTO REMOTO

### **🖥️ ADICIONAR SERVIDORES REMOTOS:**
```bash
# Editar prometheus.yml
nano Prometheus/prometheus.yml

# Adicionar targets:
- job_name: "node-exporter-remoto"
  static_configs:
    - targets: ["192.168.1.100:9100"]
      labels:
        instance: "servidor-remoto-1"
        environment: "producao"

# Recarregar Prometheus
curl -X POST http://localhost:9090/-/reload
```

### **☎️ MONITORAMENTO ASTERISK:**
```bash
# Instalar Asterisk Exporter no servidor remoto
# Configurar AMI (Asterisk Manager Interface)
# Adicionar target no Prometheus
# Configurar alertas específicos
```

---

## 🎯 PRÓXIMOS PASSOS

### **📊 APÓS A INSTALAÇÃO:**
1. **Configurar dashboards** no Grafana
2. **Criar workflows** no n8n
3. **Personalizar alertas** no Prometheus
4. **Integrar com sistemas** existentes
5. **Configurar backup** automático

### **🔧 OTIMIZAÇÃO:**
- Ajustar retenção de dados
- Configurar alertas específicos
- Implementar dashboards customizados
- Integrar com ferramentas de ITSM

---

## 📞 SUPORTE

### **🔗 RECURSOS:**
- **Documentação:** `/docs/`
- **Logs:** `docker-compose logs`
- **Issues:** GitHub Issues
- **Wiki:** Documentação detalhada

### **📧 CONTATO:**
- **Email:** seu-email@exemplo.com
- **Telegram:** @seu-usuario
- **GitHub:** github.com/seu-usuario

---

## ✅ CHECKLIST FINAL

- [ ] Docker instalado e funcionando
- [ ] Docker Compose instalado
- [ ] Projeto clonado
- [ ] Arquivo .env configurado
- [ ] Script executado com sucesso
- [ ] Todos os serviços rodando
- [ ] Grafana configurado
- [ ] Alertas testados
- [ ] n8n configurado
- [ ] AI Agent funcionando
- [ ] MCP Server ativo
- [ ] Monitoramento básico operacional

**🎉 PARABÉNS! Seu sistema de monitoramento inteligente está pronto!**
