#!/usr/bin/env python3
"""
Prometheus MCP Server em Python
Servidor simples para Model Context Protocol
"""

import os
import json
import requests
import time
from datetime import datetime
from flask import Flask, request, jsonify
from typing import Dict, Any, Optional

app = Flask(__name__)

# Configurações
PROMETHEUS_URL = os.getenv('PROMETHEUS_URL', 'http://prometheus:9090')
LOG_LEVEL = os.getenv('LOG_LEVEL', 'info')
PORT = int(os.getenv('PORT', 8080))

class PrometheusMCP:
    """Cliente para comunicação com Prometheus"""

    def __init__(self, prometheus_url: str):
        self.prometheus_url = prometheus_url
        self.session = requests.Session()
        self.session.timeout = 30

    def health_check(self) -> Dict[str, Any]:
        """Verificar saúde do Prometheus"""
        try:
            response = self.session.get(f"{self.prometheus_url}/api/v1/status/targets")
            if response.status_code == 200:
                return {
                    "status": "healthy",
                    "prometheus_url": self.prometheus_url,
                    "response_time": response.elapsed.total_seconds()
                }
            else:
                return {
                    "status": "unhealthy",
                    "prometheus_url": self.prometheus_url,
                    "error": f"HTTP {response.status_code}"
                }
        except Exception as e:
            return {
                "status": "error",
                "prometheus_url": self.prometheus_url,
                "error": str(e)
            }

    def query_metric(self, query: str, time_range: str = "5m") -> Dict[str, Any]:
        """Executar query PromQL"""
        try:
            params = {
                'query': query,
                'time': int(time.time())
            }
            
            response = self.session.get(f"{self.prometheus_url}/api/v1/query", params=params)
            
            if response.status_code == 200:
                data = response.json()
                return {
                    "status": "success",
                    "query": query,
                    "result": data.get('data', {}).get('result', []),
                    "timestamp": datetime.now().isoformat()
                }
            else:
                return {
                    "status": "error",
                    "query": query,
                    "error": f"HTTP {response.status_code}",
                    "details": response.text
                }
        except Exception as e:
            return {
                "status": "error",
                "query": query,
                "error": str(e)
            }

    def list_metrics(self) -> Dict[str, Any]:
        """Listar métricas disponíveis"""
        try:
            response = self.session.get(f"{self.prometheus_url}/api/v1/label/__name__/values")
            
            if response.status_code == 200:
                data = response.json()
                metrics = data.get('data', [])
                
                # Filtrar métricas relevantes
                relevant_metrics = [
                    metric for metric in metrics 
                    if any(keyword in metric.lower() for keyword in [
                        'node_', 'prometheus_', 'alertmanager_', 'asterisk_'
                    ])
                ]
                
                return {
                    "status": "success",
                    "total_metrics": len(metrics),
                    "relevant_metrics": len(relevant_metrics),
                    "metrics": relevant_metrics[:50]  # Primeiras 50 relevantes
                }
            else:
                return {
                    "status": "error",
                    "error": f"HTTP {response.status_code}"
                }
        except Exception as e:
            return {
                "status": "error",
                "error": str(e)
            }

    def get_prometheus_status(self) -> Dict[str, Any]:
        """Obter status do Prometheus"""
        try:
            response = self.session.get(f"{self.prometheus_url}/api/v1/status/targets")
            
            if response.status_code == 200:
                data = response.json()
                targets = data.get('data', {}).get('activeTargets', [])
                
                up_targets = len([t for t in targets if t.get('health') == 'up'])
                total_targets = len(targets)
                
                return {
                    "status": "success",
                    "prometheus_status": "running",
                    "prometheus_url": self.prometheus_url,
                    "targets": {
                        "total": total_targets,
                        "up": up_targets,
                        "down": total_targets - up_targets
                    }
                }
            else:
                return {
                    "status": "error",
                    "prometheus_status": "error",
                    "error": f"HTTP {response.status_code}"
                }
        except Exception as e:
            return {
                "status": "error",
                "prometheus_status": "error",
                "error": str(e)
            }

# Instância global do cliente MCP
mcp_client = PrometheusMCP(PROMETHEUS_URL)

@app.route('/health', methods=['GET'])
def health():
    """Health check endpoint"""
    return jsonify({
        "status": "healthy",
        "service": "Prometheus MCP Server",
        "version": "1.0.0",
        "timestamp": datetime.now().isoformat()
    })

@app.route('/mcp', methods=['GET'])
def mcp_info():
    """Informações do MCP Server"""
    return jsonify({
        "service": "Prometheus MCP Server",
        "version": "1.0.0",
        "prometheus_url": PROMETHEUS_URL,
        "endpoints": {
            "health": "/health",
            "mcp": "/mcp",
            "status": "/mcp/status",
            "metrics": "/mcp/metrics",
            "query": "/mcp/query"
        }
    })

@app.route('/mcp/status', methods=['GET'])
def prometheus_status():
    """Status do Prometheus"""
    return jsonify(mcp_client.get_prometheus_status())

@app.route('/mcp/metrics', methods=['GET'])
def list_metrics():
    """Listar métricas disponíveis"""
    return jsonify(mcp_client.list_metrics())

@app.route('/mcp/query', methods=['POST'])
def query_metric():
    """Executar query PromQL"""
    data = request.get_json()
    
    if not data or 'query' not in data:
        return jsonify({
            "status": "error",
            "error": "Query parameter is required"
        }), 400
    
    query = data['query']
    time_range = data.get('time_range', '5m')
    
    result = mcp_client.query_metric(query, time_range)
    return jsonify(result)

@app.route('/metrics', methods=['GET'])
def server_metrics():
    """Métricas do próprio servidor MCP"""
    return jsonify({
        "mcp_server": {
            "uptime": time.time(),
            "requests_processed": 0,  # Implementar contador
            "status": "running"
        }
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=PORT, debug=False)
