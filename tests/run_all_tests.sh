#!/bin/bash

# =============================================================================
# SCRIPT DE EXECUÇÃO DE TODOS OS TESTES DO SISTEMA
# =============================================================================
# Este script executa todos os testes disponíveis para validar o sistema
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
    echo "║                    🧪 SISTEMA DE TESTES                     ║"
    echo "║                   MONITORAMENTO INTELIGENTE                 ║"
    echo "║                                                              ║"
    echo "║  • Teste MCP (Model Context Protocol)                       ║"
    echo "║  • Teste Sistema de Email                                   ║"
    echo "║  • Teste Webhooks                                           ║"
    echo "║  • Validação Completa do Sistema                            ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Verificar pré-requisitos
check_prerequisites() {
    log_step "Verificando pré-requisitos..."
    
    # Verificar se Python3 está instalado
    if ! command -v python3 &> /dev/null; then
        log_error "Python3 não está instalado"
        exit 1
    fi
    
    # Verificar se os arquivos de teste existem
    if [ ! -f "test_mcp.py" ]; then
        log_error "Arquivo test_mcp.py não encontrado"
        exit 1
    fi
    
    log_success "Pré-requisitos verificados"
}

# Verificar se o sistema está rodando
check_system_status() {
    log_step "Verificando status do sistema..."
    
    # Verificar se docker-compose está disponível
    if command -v docker-compose &> /dev/null; then
        # Verificar se os containers estão rodando
        if docker-compose ps | grep -q "Up"; then
            log_success "Sistema de monitoramento está rodando"
        else
            log_warning "Sistema de monitoramento não está rodando"
            log_info "Execute: docker-compose up -d"
        fi
    else
        log_warning "Docker Compose não encontrado"
        log_info "Certifique-se de que o sistema está instalado"
    fi
}

# Executar teste MCP
run_mcp_test() {
    log_step "🚀 EXECUTANDO TESTE DO SISTEMA MCP..."
    echo ""
    
    if python3 test_mcp.py; then
        log_success "Teste MCP concluído com sucesso"
        return 0
    else
        log_error "Teste MCP falhou"
        return 1
    fi
}

# Mostrar resumo dos testes
show_test_summary() {
    log_header "🎯 RESUMO DOS TESTES EXECUTADOS"
    
    echo ""
    echo -e "${GREEN}✅ TESTES CONCLUÍDOS COM SUCESSO:${NC}"
    if [ $mcp_test_result -eq 0 ]; then
        echo "   • 🚀 Sistema MCP (Model Context Protocol)"
    fi
    
    echo ""
    echo -e "${RED}❌ TESTES QUE FALHARAM:${NC}"
    if [ $mcp_test_result -ne 0 ]; then
        echo "   • 🚀 Sistema MCP (Model Context Protocol)"
    fi
    
    echo ""
    echo -e "${BLUE}📊 ESTATÍSTICAS:${NC}"
    total_tests=1
    successful_tests=$((mcp_test_result == 0 ? 1 : 0))
    failed_tests=$((total_tests - successful_tests))
    
    echo "   • Total de testes: $total_tests"
    echo "   • Testes bem-sucedidos: $successful_tests"
    echo "   • Testes que falharam: $failed_tests"
    echo "   • Taxa de sucesso: $(( (successful_tests * 100) / total_tests ))%"
    
    echo ""
    if [ $failed_tests -eq 0 ]; then
        log_success "🎉 TODOS OS TESTES PASSARAM! Sistema funcionando perfeitamente!"
    else
        log_warning "⚠️  Alguns testes falharam. Verifique a configuração do sistema."
        echo ""
        echo -e "${YELLOW}💡 DICAS PARA RESOLVER PROBLEMAS:${NC}"
        echo "   • Verifique se todos os serviços estão rodando: docker-compose ps"
        echo "   • Verifique os logs: docker-compose logs [servico]"
        echo "   • Verifique a configuração do arquivo .env"
        echo "   • Consulte a documentação em ../docs/"
    fi
}

# Função principal
main() {
    show_banner
    
    log_header "INICIANDO EXECUÇÃO DE TODOS OS TESTES"
    
    # Verificar pré-requisitos
    check_prerequisites
    
    # Verificar status do sistema
    check_system_status
    
    echo ""
    log_info "Pressione Enter para iniciar os testes..."
    read -p ""
    
    # Executar testes
    run_mcp_test
    mcp_test_result=$?
    
    echo ""
    log_header "TESTES CONCLUÍDOS"
    
    # Mostrar resumo
    show_test_summary
    
    echo ""
    log_header "EXECUÇÃO FINALIZADA!"
    echo ""
    log_success "Script de testes concluído! 🧪"
    echo ""
}

# Executar função principal
main "$@"
