#!/bin/bash

# =============================================================================
# INSTALL_NODE_EXPORTER.SH - INSTALAÇÃO EM MÁQUINAS REMOTAS
# =============================================================================
# Script para instalar Node Exporter em servidores remotos
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
    echo "║              🌐 INSTALAÇÃO EM MÁQUINAS REMOTAS              ║"
    echo "║                    NODE EXPORTER                            ║"
    echo "║                                                              ║"
    echo "║  Este script instala o Node Exporter para monitoramento     ║"
    echo "║  remoto de métricas do sistema operacional                  ║"
    echo "║                                                              ║"
    echo "║  • Coleta métricas do sistema                               ║"
    echo "║  • Envia para servidor central                              ║"
    echo "║  • Configuração automática                                  ║"
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
                    OS_TYPE="debian"
                    ;;
                centos|rhel|fedora)
                    log_success "Sistema CentOS/RHEL/Fedora detectado"
                    OS_TYPE="rhel"
                    ;;
                *)
                    log_warning "Sistema não testado: $ID"
                    OS_TYPE="unknown"
                    ;;
            esac
        else
            log_warning "Não foi possível detectar a distribuição Linux"
            OS_TYPE="unknown"
        fi
    else
        log_error "Este script é compatível apenas com Linux"
        exit 1
    fi
}

# Instalar dependências
install_dependencies() {
    log_step "Instalando dependências..."
    
    case $OS_TYPE in
        debian)
            log_info "Atualizando repositórios..."
            sudo apt-get update
            
            log_info "Instalando dependências..."
            sudo apt-get install -y \
                curl \
                wget \
                systemd \
                systemd-sysv
            ;;
        rhel)
            log_info "Instalando dependências..."
            sudo yum install -y \
                curl \
                wget \
                systemd \
                systemd-sysv
            ;;
        *)
            log_error "Sistema operacional não suportado"
            exit 1
            ;;
    esac
    
    log_success "Dependências instaladas"
}

# Baixar e instalar Node Exporter
install_node_exporter() {
    log_step "Instalando Node Exporter..."
    
    # Versão do Node Exporter
    NODE_EXPORTER_VERSION="1.6.1"
    NODE_EXPORTER_ARCH="linux-amd64"
    
    # URL de download
    DOWNLOAD_URL="https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.${NODE_EXPORTER_ARCH}.tar.gz"
    
    log_info "Baixando Node Exporter v${NODE_EXPORTER_VERSION}..."
    
    # Criar diretório temporário
    TEMP_DIR=$(mktemp -d)
    cd $TEMP_DIR
    
    # Baixar Node Exporter
    wget -q $DOWNLOAD_URL
    
    if [ ! -f "node_exporter-${NODE_EXPORTER_VERSION}.${NODE_EXPORTER_ARCH}.tar.gz" ]; then
        log_error "Falha ao baixar Node Exporter"
        exit 1
    fi
    
    # Extrair arquivo
    tar -xzf "node_exporter-${NODE_EXPORTER_VERSION}.${NODE_EXPORTER_ARCH}.tar.gz"
    
    # Mover para /usr/local/bin
    sudo cp "node_exporter-${NODE_EXPORTER_VERSION}.${NODE_EXPORTER_ARCH}/node_exporter" /usr/local/bin/
    sudo chmod +x /usr/local/bin/node_exporter
    
    # Limpar arquivos temporários
    cd /
    rm -rf $TEMP_DIR
    
    log_success "Node Exporter instalado"
}

# Criar usuário dedicado
create_user() {
    log_step "Criando usuário dedicado..."
    
    if ! id "node_exporter" &>/dev/null; then
        sudo useradd --system --no-create-home --shell /bin/false node_exporter
        log_success "Usuário node_exporter criado"
    else
        log_info "Usuário node_exporter já existe"
    fi
}

# Criar serviço systemd
create_service() {
    log_step "Criando serviço systemd..."
    
    cat << EOF | sudo tee /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Documentation=https://github.com/prometheus/node_exporter
After=network.target

[Service]
Type=simple
User=node_exporter
Group=node_exporter
ExecStart=/usr/local/bin/node_exporter
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
    
    # Recarregar systemd
    sudo systemctl daemon-reload
    
    # Habilitar serviço
    sudo systemctl enable node_exporter
    
    log_success "Serviço systemd criado"
}

# Configurar firewall
configure_firewall() {
    log_step "Configurando firewall..."
    
    # Detectar tipo de firewall
    if command -v ufw &> /dev/null; then
        # UFW (Ubuntu)
        log_info "Configurando UFW..."
        sudo ufw allow 9100/tcp comment "Node Exporter"
        log_success "Porta 9100 liberada no UFW"
        
    elif command -v firewall-cmd &> /dev/null; then
        # firewalld (CentOS/RHEL)
        log_info "Configurando firewalld..."
        sudo firewall-cmd --permanent --add-port=9100/tcp
        sudo firewall-cmd --reload
        log_success "Porta 9100 liberada no firewalld"
        
    else
        log_warning "Firewall não detectado, configure manualmente a porta 9100"
    fi
}

# Iniciar serviço
start_service() {
    log_step "Iniciando serviço..."
    
    sudo systemctl start node_exporter
    
    # Aguardar inicialização
    sleep 5
    
    # Verificar status
    if sudo systemctl is-active --quiet node_exporter; then
        log_success "Node Exporter iniciado com sucesso"
    else
        log_error "Falha ao iniciar Node Exporter"
        sudo systemctl status node_exporter
        exit 1
    fi
}

# Verificar instalação
verify_installation() {
    log_step "Verificando instalação..."
    
    # Verificar se o serviço está rodando
    if sudo systemctl is-active --quiet node_exporter; then
        log_success "✅ Serviço rodando"
    else
        log_error "❌ Serviço não está rodando"
    fi
    
    # Verificar se está respondendo
    if curl -s http://localhost:9100/metrics > /dev/null; then
        log_success "✅ Respondendo na porta 9100"
    else
        log_error "❌ Não está respondendo na porta 9100"
    fi
    
    # Verificar se está habilitado
    if sudo systemctl is-enabled --quiet node_exporter; then
        log_success "✅ Serviço habilitado"
    else
        log_error "❌ Serviço não habilitado"
    fi
}

# Mostrar informações finais
show_final_info() {
    log_header "🎉 INSTALAÇÃO CONCLUÍDA!"
    
    echo ""
    echo -e "${GREEN}✅ O QUE FOI INSTALADO:${NC}"
    echo "   • Node Exporter v1.6.1"
    echo "   • Usuário dedicado node_exporter"
    echo "   • Serviço systemd configurado"
    echo "   • Firewall configurado"
    echo ""
    
    echo -e "${BLUE}🌐 CONFIGURAÇÃO:${NC}"
    echo "   • Porta: 9100"
    echo "   • Usuário: node_exporter"
    echo "   • Serviço: node_exporter.service"
    echo ""
    
    echo -e "${YELLOW}🔧 COMANDOS ÚTEIS:${NC}"
    echo "   • Status: sudo systemctl status node_exporter"
    echo "   • Iniciar: sudo systemctl start node_exporter"
    echo "   • Parar: sudo systemctl stop node_exporter"
    echo "   • Reiniciar: sudo systemctl restart node_exporter"
    echo "   • Logs: sudo journalctl -u node_exporter -f"
    echo ""
    
    echo -e "${PURPLE}📊 MÉTRICAS DISPONÍVEIS:${NC}"
    echo "   • Sistema: http://localhost:9100/metrics"
    echo "   • CPU, Memória, Disco, Rede"
    echo "   • Processos e serviços"
    echo ""
    
    echo -e "${CYAN}🔗 INTEGRAÇÃO COM SERVIDOR CENTRAL:${NC}"
    echo "   • Adicione este servidor ao prometheus.yml central"
    echo "   • Target: http://IP_DESTE_SERVIDOR:9100"
    echo "   • Job name: node-exporter-remoto"
    echo ""
}

# Função principal
main() {
    show_banner
    
    log_header "INICIANDO INSTALAÇÃO DO NODE EXPORTER"
    
    # Verificar sistema
    check_os
    
    # Instalar dependências
    install_dependencies
    
    # Instalar Node Exporter
    install_node_exporter
    
    # Criar usuário
    create_user
    
    # Criar serviço
    create_service
    
    # Configurar firewall
    configure_firewall
    
    # Iniciar serviço
    start_service
    
    # Verificar instalação
    verify_installation
    
    # Mostrar informações finais
    show_final_info
    
    log_header "🚀 INSTALAÇÃO FINALIZADA COM SUCESSO!"
    echo ""
    log_success "Node Exporter instalado e configurado!"
    log_info "Este servidor agora pode ser monitorado pelo sistema central"
    echo ""
}

# Executar função principal
main "$@"
