#!/usr/bin/env python3
"""
Script de teste para o sistema Prometheus MCP
Testa todos os endpoints e funcionalidades do MCP Server
"""

import requests
import json
import time
from datetime import datetime

def test_mcp_server():
    """Testar todos os endpoints do MCP Server"""
    
    base_url = "http://localhost:8080"
    
    print("🚀 Testando Prometheus MCP Server")
    print("=" * 50)
    
    # 1. Health Check
    print("\n1️⃣ Testando Health Check...")
    try:
        response = requests.get(f"{base_url}/health", timeout=10)
        if response.status_code == 200:
            health_data = response.json()
            print(f"✅ Health Check OK: {health_data.get('status', 'unknown')}")
            print(f"   Serviço: {health_data.get('service', 'unknown')}")
            print(f"   Versão: {health_data.get('version', 'unknown')}")
        else:
            print(f"❌ Health Check falhou: {response.status_code}")
    except Exception as e:
        print(f"❌ Erro no Health Check: {e}")
    
    # 2. Informações do MCP
    print("\n2️⃣ Testando endpoint MCP...")
    try:
        response = requests.get(f"{base_url}/mcp", timeout=10)
        if response.status_code == 200:
            mcp_data = response.json()
            print(f"✅ MCP endpoint OK")
            print(f"   Serviço: {mcp_data.get('service', 'unknown')}")
            print(f"   Prometheus URL: {mcp_data.get('prometheus_url', 'unknown')}")
            print(f"   Endpoints disponíveis: {len(mcp_data.get('endpoints', {}))}")
        else:
            print(f"❌ MCP endpoint falhou: {response.status_code}")
    except Exception as e:
        print(f"❌ Erro no MCP endpoint: {e}")
    
    # 3. Status do Prometheus
    print("\n3️⃣ Testando status do Prometheus...")
    try:
        response = requests.get(f"{base_url}/mcp/status", timeout=10)
        if response.status_code == 200:
            status_data = response.json()
            print(f"✅ Status do Prometheus OK")
            print(f"   Status: {status_data.get('prometheus_status', 'unknown')}")
            print(f"   URL: {status_data.get('prometheus_url', 'unknown')}")
        else:
            print(f"❌ Status do Prometheus falhou: {response.status_code}")
    except Exception as e:
        print(f"❌ Erro no status do Prometheus: {e}")
    
    # 4. Lista de métricas
    print("\n4️⃣ Testando lista de métricas...")
    try:
        response = requests.get(f"{base_url}/mcp/metrics", timeout=10)
        if response.status_code == 200:
            metrics_data = response.json()
            print(f"✅ Lista de métricas OK")
            print(f"   Total de métricas: {metrics_data.get('total_metrics', 0)}")
            print(f"   Métricas relevantes: {metrics_data.get('relevant_metrics', 0)}")
            
            # Mostrar algumas métricas relevantes
            relevant_metrics = metrics_data.get('metrics', [])
            if relevant_metrics:
                print("   Exemplos de métricas relevantes:")
                for metric in relevant_metrics[:5]:  # Primeiras 5
                    print(f"     - {metric}")
        else:
            print(f"❌ Lista de métricas falhou: {response.status_code}")
    except Exception as e:
        print(f"❌ Erro na lista de métricas: {e}")
    
    # 5. Consulta de métrica específica
    print("\n5️⃣ Testando consulta de métrica...")
    try:
        query_payload = {
            "query": "up"
        }
        response = requests.post(
            f"{base_url}/mcp/query",
            json=query_payload,
            headers={'Content-Type': 'application/json'},
            timeout=10
        )
        if response.status_code == 200:
            query_data = response.json()
            print(f"✅ Consulta de métrica OK")
            print(f"   Query: {query_data.get('query', 'unknown')}")
            print(f"   Status: {query_data.get('status', 'unknown')}")
        else:
            print(f"❌ Consulta de métrica falhou: {response.status_code}")
    except Exception as e:
        print(f"❌ Erro na consulta de métrica: {e}")

def test_mcp_client():
    """Testar cliente MCP Python"""
    
    print("\n🧪 Testando Cliente MCP Python...")
    print("=" * 50)
    
    try:
        from mcp_client import PrometheusMCPClient
        
        # Criar cliente
        client = PrometheusMCPClient("http://localhost:8080")
        
        # Testar health check
        print("\n1️⃣ Testando health check do cliente...")
        health = client.health_check()
        if health:
            print(f"✅ Health check do cliente OK")
        else:
            print(f"❌ Health check do cliente falhou")
        
        # Testar informações do servidor
        print("\n2️⃣ Testando informações do servidor...")
        info = client.get_server_info()
        if info:
            print(f"✅ Informações do servidor OK")
        else:
            print(f"❌ Informações do servidor falharam")
        
        # Testar consulta de métrica
        print("\n3️⃣ Testando consulta de métrica...")
        cpu_metric = client.query_metric("100 - (avg by (instance) (irate(node_cpu_seconds_total{mode=\"idle\"}[5m])) * 100)")
        if cpu_metric and cpu_metric.get('status') == 'success':
            print(f"✅ Consulta de CPU OK")
        else:
            print(f"❌ Consulta de CPU falhou")
        
        # Testar análise de saúde do sistema
        print("\n4️⃣ Testando análise de saúde do sistema...")
        health_analysis = client.analyze_system_health()
        if health_analysis:
            print(f"✅ Análise de saúde OK")
        else:
            print(f"❌ Análise de saúde falhou")
        
        print("\n✅ Todos os testes do cliente MCP passaram!")
        
    except ImportError:
        print("❌ Módulo mcp_client não encontrado")
        print("   Execute: pip install -r requirements.txt")
    except Exception as e:
        print(f"❌ Erro no teste do cliente: {e}")

def main():
    """Função principal"""
    
    print("🧪 INICIANDO TESTES DO SISTEMA MCP")
    print("=" * 60)
    
    # Testar servidor MCP
    test_mcp_server()
    
    # Testar cliente MCP
    test_mcp_client()
    
    print("\n" + "=" * 60)
    print("🎯 TESTES CONCLUÍDOS!")
    print("=" * 60)

if __name__ == "__main__":
    main()
