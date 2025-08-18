#!/bin/bash

# =============================================================================
# SETUP.SH - SISTEMA DE MONITORAMENTO LINUX INTELIGENTE
# =============================================================================
# Script de configuração automática do sistema de monitoramento
# Autor: Sistema de Monitoramento Linux
# Data: $(date +%Y-%m-%d)
# =============================================================================

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Funções de log colorido
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo -e "${PURPLE}[STEP]${NC} $1"
}

log_header() {
    echo -e "${CYAN}================================${NC}"
    echo -e "${CYAN} $1${NC}"
    echo -e "${CYAN}================================${NC}"
}

# Banner de boas-vindas
show_banner() {
    clear
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                🚀 SISTEMA DE MONITORAMENTO                  ║"
    echo "║                     LINUX INTELIGENTE                       ║"
    echo "║                                                              ║"
    echo "║  • Prometheus + Grafana + Alertmanager                      ║"
    echo "║  • AI Agent com Google Gemini                               ║"
    echo "║  • MCP Server para acesso em tempo real                     ║"
    echo "║  • n8n para automação                                       ║"
    echo "║  • Monitoramento específico para Asterisk                   ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Verificar pré-requisitos
check_prerequisites() {
    log_step "Verificando pré-requisitos..."
    
    # Verificar se Docker está instalado
    if ! command -v docker &> /dev/null; then
        log_error "Docker não está instalado"
        log_info "Execute: sudo apt update && sudo apt install docker.io docker-compose"
        exit 1
    fi
    
    # Verificar se Docker Compose está instalado
    if ! command -v docker-compose &> /dev/null; then
        log_error "Docker Compose não está instalado"
        log_info "Execute: sudo apt install docker-compose"
        exit 1
    fi
    
    # Verificar se Docker está rodando
    if ! docker ps &> /dev/null; then
        log_error "Docker não está rodando"
        log_info "Execute: sudo systemctl start docker"
        exit 1
    fi
    
    log_success "Pré-requisitos verificados"
}

# Criar arquivo .env
create_env_file() {
    log_step "Configurando arquivo .env..."
    
    if [ ! -f .env ]; then
        log_info "Criando arquivo .env..."
        cp env.example .env
        
        log_warning "Arquivo .env criado com valores padrão"
        log_info "Configure suas credenciais antes de continuar"
        log_info "Especialmente: GOOGLE_API_KEY, EMAIL_ADDRESS, EMAIL_PASSWORD"
        
        read -p "Pressione Enter após configurar o arquivo .env..."
    else
        log_info "Arquivo .env já existe"
    fi
}

# Validar configuração
validate_config() {
    log_step "Validando configuração..."
    
    if [ ! -f .env ]; then
        log_error "Arquivo .env não encontrado"
        exit 1
    fi
    
    # Verificar se as variáveis importantes estão configuradas
    source .env
    
    if [ "$GOOGLE_API_KEY" = "sua_chave_api_gemini_aqui" ]; then
        log_warning "GOOGLE_API_KEY não foi configurada"
        log_info "Edite o arquivo .env com sua chave real"
    fi
    
    if [ "$EMAIL_ADDRESS" = "seu_email@gmail.com" ]; then
        log_warning "EMAIL_ADDRESS não foi configurada"
        log_info "Edite o arquivo .env com seu email real"
    fi
    
    if [ "$EMAIL_PASSWORD" = "sua_senha_do_email" ]; then
        log_warning "EMAIL_PASSWORD não foi configurada"
        log_info "Edite o arquivo .env com sua senha real"
    fi
    
    log_success "Configuração validada"
}

# Criar diretórios necessários
create_directories() {
    log_step "Criando diretórios necessários..."
    
    mkdir -p Grafana/data
    mkdir -p Prometheus/data
    mkdir -p Alertmanager/data
    mkdir -p mcp-server/config
    
    log_success "Diretórios criados"
}

# Configurar permissões
setup_permissions() {
    log_step "Configurando permissões..."
    
    # Permissões para Grafana
    sudo chown -R 472:472 Grafana/data 2>/dev/null || true
    sudo chmod -R 755 Grafana/data 2>/dev/null || true
    
    # Permissões para Prometheus
    sudo chown -R 65534:65534 Prometheus/data 2>/dev/null || true
    sudo chmod -R 755 Prometheus/data 2>/dev/null || true
    
    # Permissões para Alertmanager
    sudo chown -R 65534:65534 Alertmanager/data 2>/dev/null || true
    sudo chmod -R 755 Alertmanager/data 2>/dev/null || true
    
    log_success "Permissões configuradas"
}

# Iniciar serviços
start_services() {
    log_step "Iniciando serviços..."
    
    log_info "Iniciando containers..."
    docker-compose up -d
    
    log_info "Aguardando serviços inicializarem..."
    sleep 30
    
    log_success "Serviços iniciados"
}

# Verificar status dos serviços
check_services() {
    log_step "Verificando status dos serviços..."
    
    echo ""
    docker-compose ps
    
    echo ""
    log_info "Verificando conectividade..."
    
    # Verificar Prometheus
    if curl -s http://localhost:9090/api/v1/status/targets > /dev/null; then
        log_success "Prometheus está respondendo"
    else
        log_warning "Prometheus não está respondendo"
    fi
    
    # Verificar Grafana
    if curl -s http://localhost:3000/api/health > /dev/null; then
        log_success "Grafana está respondendo"
    else
        log_warning "Grafana não está respondendo"
    fi
    
    # Verificar MCP Server
    if curl -s http://localhost:8080/health > /dev/null; then
        log_success "MCP Server está respondendo"
    else
        log_warning "MCP Server não está respondendo"
    fi
}

# Mostrar informações de acesso
show_access_info() {
    log_header "🎯 INFORMAÇÕES DE ACESSO"
    
    echo ""
    echo -e "${GREEN}✅ SERVIÇOS DISPONÍVEIS:${NC}"
    echo "   • Prometheus: http://localhost:9090"
    echo "   • Grafana: http://localhost:3000 (admin/admin)"
    echo "   • Alertmanager: http://localhost:9093"
    echo "   • n8n: http://localhost:5678 (admin/admin123)"
    echo "   • Agente de IA: http://localhost:5000"
    echo "   • MCP Server: http://localhost:8080"
    echo ""
    
    echo -e "${YELLOW}🔧 COMANDOS ÚTEIS:${NC}"
    echo "   • Ver logs: docker-compose logs -f"
    echo "   • Parar serviços: docker-compose down"
    echo "   • Reiniciar: docker-compose restart"
    echo "   • Status: docker-compose ps"
    echo ""
    
    echo -e "${BLUE}🧪 TESTES:${NC}"
    echo "   • Teste rápido: cd tests/ && ./quick_test.sh"
    echo "   • Todos os testes: cd tests/ && ./run_all_tests.sh"
    echo "   • Menu de testes: cd tests/ && ./test_individual.sh"
    echo ""
    
    echo -e "${PURPLE}📚 DOCUMENTAÇÃO:${NC}"
    echo "   • Visão geral: docs/README.md"
    echo "   • Instalação: docs/GUIA_INSTALACAO.md"
    echo "   • Técnica: docs/DOCUMENTACAO_TECNICA.md"
    echo ""
}

# Função principal
main() {
    show_banner
    
    log_header "INICIANDO CONFIGURAÇÃO DO SISTEMA"
    
    # Verificar pré-requisitos
    check_prerequisites
    
    # Criar arquivo .env
    create_env_file
    
    # Validar configuração
    validate_config
    
    # Criar diretórios
    create_directories
    
    # Configurar permissões
    setup_permissions
    
    # Iniciar serviços
    start_services
    
    # Verificar serviços
    check_services
    
    # Mostrar informações
    show_access_info
    
    log_header "🎉 CONFIGURAÇÃO CONCLUÍDA!"
    echo ""
    log_success "Sistema de monitoramento configurado com sucesso!"
    log_info "Configure suas credenciais no arquivo .env antes de usar"
    echo ""
}

# Executar função principal
main "$@"
