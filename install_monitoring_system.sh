#!/bin/bash

# =============================================================================
# INSTALL_MONITORING_SYSTEM.SH - INSTALAÇÃO COMPLETA DO ZERO
# =============================================================================
# Script para instalar o sistema de monitoramento completo do zero
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
    echo "║            🚀 INSTALAÇÃO COMPLETA DO ZERO                   ║"
    echo "║              SISTEMA DE MONITORAMENTO                       ║"
    echo "║                     LINUX INTELIGENTE                       ║"
    echo "║                                                              ║"
    echo "║  Este script irá instalar todo o sistema do zero:           ║"
    echo "║  • Docker e Docker Compose                                  ║"
    ║  • Sistema de monitoramento completo                              ║"
    echo "║  • Configuração automática                                  ║"
    echo "║  • Inicialização dos serviços                               ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Verificar sistema operacional
check_os() {
    log_step "Verificando sistema operacional..."
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            log_info "Sistema: $NAME $VERSION"
            
            case $ID in
                ubuntu|debian)
                    log_success "Sistema Ubuntu/Debian detectado"
                    ;;
                centos|rhel|fedora)
                    log_success "Sistema CentOS/RHEL/Fedora detectado"
                    ;;
                *)
                    log_warning "Sistema não testado: $ID"
                    ;;
            esac
        else
            log_warning "Não foi possível detectar a distribuição Linux"
        fi
    else
        log_error "Este script é compatível apenas com Linux"
        exit 1
    fi
}

# Instalar dependências do sistema
install_system_dependencies() {
    log_step "Instalando dependências do sistema..."
    
    if command -v apt-get &> /dev/null; then
        # Ubuntu/Debian
        log_info "Atualizando repositórios..."
        sudo apt-get update
        
        log_info "Instalando dependências..."
        sudo apt-get install -y \
            curl \
            wget \
            git \
            unzip \
            software-properties-common \
            apt-transport-https \
            ca-certificates \
            gnupg \
            lsb-release
        
    elif command -v yum &> /dev/null; then
        # CentOS/RHEL/Fedora
        log_info "Instalando dependências..."
        sudo yum install -y \
            curl \
            wget \
            git \
            unzip \
            yum-utils \
            device-mapper-persistent-data \
            lvm2
        
    else
        log_error "Gerenciador de pacotes não suportado"
        exit 1
    fi
    
    log_success "Dependências do sistema instaladas"
}

# Instalar Docker
install_docker() {
    log_step "Instalando Docker..."
    
    if command -v docker &> /dev/null; then
        log_info "Docker já está instalado"
        docker --version
    else
        log_info "Instalando Docker..."
        
        if command -v apt-get &> /dev/null; then
            # Ubuntu/Debian
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
            
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            
            sudo apt-get update
            sudo apt-get install -y docker-ce docker-ce-cli containerd.io
            
        elif command -v yum &> /dev/null; then
            # CentOS/RHEL/Fedora
            sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
            sudo yum install -y docker-ce docker-ce-cli containerd.io
        fi
        
        # Iniciar e habilitar Docker
        sudo systemctl start docker
        sudo systemctl enable docker
        
        # Adicionar usuário ao grupo docker
        sudo usermod -aG docker $USER
        
        log_success "Docker instalado e configurado"
        log_warning "Reinicie o terminal ou execute: newgrp docker"
    fi
}

# Instalar Docker Compose
install_docker_compose() {
    log_step "Instalando Docker Compose..."
    
    if command -v docker-compose &> /dev/null; then
        log_info "Docker Compose já está instalado"
        docker-compose --version
    else
        log_info "Instalando Docker Compose..."
        
        # Baixar versão mais recente
        sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        
        # Tornar executável
        sudo chmod +x /usr/local/bin/docker-compose
        
        # Criar link simbólico
        sudo ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose
        
        log_success "Docker Compose instalado"
    fi
}

# Verificar permissões Docker
check_docker_permissions() {
    log_step "Verificando permissões Docker..."
    
    if docker ps &> /dev/null; then
        log_success "Permissões Docker OK"
    else
        log_warning "Problema de permissões Docker detectado"
        log_info "Aplicando correção..."
        
        # Aplicar permissões
        sudo usermod -aG docker $USER
        sudo systemctl restart docker
        
        log_info "Execute: newgrp docker"
        log_info "Ou reinicie o terminal"
        
        read -p "Pressione Enter após aplicar as permissões..."
        
        if ! docker ps &> /dev/null; then
            log_error "Permissões Docker ainda não estão funcionando"
            exit 1
        fi
    fi
}

# Baixar projeto
download_project() {
    log_step "Baixando projeto..."
    
    if [ -d "Monitoramento_Linux" ]; then
        log_info "Diretório já existe, atualizando..."
        cd Monitoramento_Linux
        git pull origin main 2>/dev/null || true
    else
        log_info "Clonando repositório..."
        git clone https://github.com/RafaeldsSiqueira/Monitoramento-Linux.git
        cd Monitoramento_Linux
    fi
    
    log_success "Projeto baixado"
}

# Configurar arquivo .env
setup_env_file() {
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

# Executar setup
run_setup() {
    log_step "Executando setup do sistema..."
    
    if [ -f "setup.sh" ]; then
        chmod +x setup.sh
        ./setup.sh
    else
        log_error "Arquivo setup.sh não encontrado"
        exit 1
    fi
}

# Verificar instalação
verify_installation() {
    log_step "Verificando instalação..."
    
    # Verificar Docker
    if command -v docker &> /dev/null; then
        log_success "✅ Docker instalado"
    else
        log_error "❌ Docker não instalado"
    fi
    
    # Verificar Docker Compose
    if command -v docker-compose &> /dev/null; then
        log_success "✅ Docker Compose instalado"
    else
        log_error "❌ Docker Compose não instalado"
    fi
    
    # Verificar serviços
    if docker-compose ps | grep -q "Up"; then
        log_success "✅ Serviços rodando"
    else
        log_warning "⚠️ Serviços não estão rodando"
    fi
}

# Mostrar informações finais
show_final_info() {
    log_header "🎉 INSTALAÇÃO CONCLUÍDA!"
    
    echo ""
    echo -e "${GREEN}✅ O QUE FOI INSTALADO:${NC}"
    echo "   • Docker e Docker Compose"
    echo "   • Sistema de monitoramento completo"
    echo "   • Prometheus, Grafana, Alertmanager"
    echo "   • AI Agent com Google Gemini"
    echo "   • MCP Server para acesso em tempo real"
    echo "   • n8n para automação"
    echo ""
    
    echo -e "${BLUE}🌐 ACESSOS DISPONÍVEIS:${NC}"
    echo "   • Prometheus: http://localhost:9090"
    echo "   • Grafana: http://localhost:3000 (admin/admin)"
    echo "   • Alertmanager: http://localhost:9093"
    echo "   • n8n: http://localhost:5678 (admin/admin123)"
    echo "   • MCP Server: http://localhost:8080"
    echo ""
    
    echo -e "${YELLOW}🔧 PRÓXIMOS PASSOS:${NC}"
    echo "   • Configure suas credenciais no arquivo .env"
    echo "   • Execute: cd tests/ && ./quick_test.sh"
    echo "   • Consulte a documentação em docs/"
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
    
    log_header "INICIANDO INSTALAÇÃO COMPLETA DO SISTEMA"
    
    # Verificar sistema
    check_os
    
    # Instalar dependências
    install_system_dependencies
    
    # Instalar Docker
    install_docker
    
    # Instalar Docker Compose
    install_docker_compose
    
    # Verificar permissões
    check_docker_permissions
    
    # Baixar projeto
    download_project
    
    # Configurar .env
    setup_env_file
    
    # Executar setup
    run_setup
    
    # Verificar instalação
    verify_installation
    
    # Mostrar informações finais
    show_final_info
    
    log_header "🚀 INSTALAÇÃO FINALIZADA COM SUCESSO!"
    echo ""
    log_success "Sistema de monitoramento instalado e configurado!"
    echo ""
}

# Executar função principal
main "$@"
