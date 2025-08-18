# 🧪 **DIRETÓRIO DE TESTES - SISTEMA DE MONITORAMENTO**

## 📋 **VISÃO GERAL**

Este diretório contém todos os **scripts de teste** para validar o funcionamento do sistema de monitoramento inteligente.

---

## 🧪 **ARQUIVOS DE TESTE DISPONÍVEIS**

### **1. 🚀 `test_mcp.py` - Teste do Sistema MCP**
**O que testa:**
- ✅ **MCP Server** (Model Context Protocol)
- ✅ **Cliente MCP** (Python)
- ✅ **Conectividade** com Prometheus
- ✅ **Consultas PromQL** em tempo real
- ✅ **Análise inteligente** de métricas

**Como usar:**
```bash
# Executar teste completo
python3 test_mcp.py
```

### **2. 📧 `test_email_approval.py` - Teste do Sistema de Aprovação**
**O que testa:**
- ✅ **Configuração SMTP**
- ✅ **Envio de emails**
- ✅ **Sistema de aprovação**
- ✅ **Templates HTML**

**Como usar:**
```bash
# Executar teste de email
python3 test_email_approval.py
```

### **3. 🔗 `test_webhook.py` - Teste de Webhooks**
**O que testa:**
- ✅ **Webhooks** do sistema
- ✅ **Integração** com n8n
- ✅ **Endpoints** de automação
- ✅ **Comunicação** entre serviços

**Como usar:**
```bash
# Executar teste de webhooks
python3 test_webhook.py
```

---

## 🚀 **EXECUÇÃO RÁPIDA DE TODOS OS TESTES**

### **Script de Teste Completo**
```bash
#!/bin/bash
# run_all_tests.sh

echo "🧪 EXECUTANDO TODOS OS TESTES DO SISTEMA..."
echo "=============================================="

# Teste MCP
echo ""
echo "🚀 TESTANDO SISTEMA MCP..."
python3 test_mcp.py

# Teste Email
echo ""
echo "📧 TESTANDO SISTEMA DE EMAIL..."
python3 test_email_approval.py

# Teste Webhook
echo ""
echo "🔗 TESTANDO WEBHOOKS..."
python3 test_webhook.py

echo ""
echo "🎯 TODOS OS TESTES CONCLUÍDOS!"
```

### **Executar todos os testes:**
```bash
cd tests/
chmod +x run_all_tests.sh
./run_all_tests.sh
```

---

## 🔧 **REQUISITOS PARA TESTES**

### **Dependências Python:**
```bash
pip install requests flask
```

### **Serviços Necessários:**
- ✅ **MCP Server** rodando na porta 8080
- ✅ **Prometheus** rodando na porta 9090
- ✅ **Sistema de email** configurado
- ✅ **n8n** rodando na porta 5678

---

## 📊 **INTERPRETAÇÃO DOS RESULTADOS**

### **✅ Testes Passando:**
- Sistema funcionando corretamente
- Todas as funcionalidades operacionais
- Comunicação entre serviços OK

### **⚠️ Testes com Avisos:**
- Funcionalidades básicas OK
- Algumas funcionalidades avançadas podem ter problemas
- Verificar logs para detalhes

### **❌ Testes Falhando:**
- Problemas de configuração
- Serviços não rodando
- Problemas de conectividade
- Verificar documentação de troubleshooting

---

## 🔍 **TROUBLESHOOTING COMUM**

### **MCP Server não responde:**
```bash
# Verificar se está rodando
docker-compose ps mcp-server

# Ver logs
docker-compose logs mcp-server

# Verificar porta
netstat -tlnp | grep 8080
```

### **Prometheus não acessível:**
```bash
# Verificar status
docker-compose ps prometheus

# Ver logs
docker-compose logs prometheus

# Testar conectividade
curl http://localhost:9090/api/v1/status/targets
```

### **Problemas de Email:**
```bash
# Verificar configuração .env
cat .env | grep EMAIL

# Ver logs do ai-agent
docker-compose logs ai-agent
```

---

## 📚 **DOCUMENTAÇÃO RELACIONADA**

- **[📖 Visão Geral](../docs/README.md)**
- **[🚀 Guia de Instalação](../docs/GUIA_INSTALACAO.md)**
- **[🔧 Documentação Técnica](../docs/DOCUMENTACAO_TECNICA.md)**

---

## 🎯 **OBJETIVO DOS TESTES**

Os testes garantem que:
1. **Todos os serviços** estão funcionando
2. **Comunicação** entre componentes está OK
3. **Funcionalidades** estão operacionais
4. **Configurações** estão corretas
5. **Sistema** está pronto para produção

---

## 🚀 **EXECUTE OS TESTES AGORA!**

```bash
cd tests/
./run_all_tests.sh
```

**🧪 Teste seu sistema e garanta que tudo está funcionando perfeitamente!**
