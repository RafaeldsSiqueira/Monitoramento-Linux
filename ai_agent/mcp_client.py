#!/usr/bin/env python3
"""
Cliente MCP (Model Context Protocol) para Prometheus
Permite ao AI Agent acessar métricas em tempo real
"""

import requests
import json
import time
from datetime import datetime
from typing import Dict, Any, Optional, List

class PrometheusMCPClient:
    """Cliente para comunicação com o MCP Server"""
    
    def __init__(self, mcp_server_url: str):
        self.mcp_server_url = mcp_server_url
        self.session = requests.Session()
        self.session.timeout = 30
    
    def health_check(self) -> bool:
        """Verificar se o MCP Server está saudável"""
        try:
            response = self.session.get(f"{self.mcp_server_url}/health")
            return response.status_code == 200
        except Exception:
            return False
    
    def get_server_info(self) -> Optional[Dict[str, Any]]:
        """Obter informações do servidor MCP"""
        try:
            response = self.session.get(f"{self.mcp_server_url}/mcp")
            if response.status_code == 200:
                return response.json()
            return None
        except Exception:
            return None
    
    def query_metric(self, query: str, time_range: str = "5m") -> Optional[Dict[str, Any]]:
        """Executar query PromQL"""
        try:
            payload = {
                "query": query,
                "time_range": time_range
            }
            
            response = self.session.post(
                f"{self.mcp_server_url}/mcp/query",
                json=payload,
                headers={'Content-Type': 'application/json'}
            )
            
            if response.status_code == 200:
                return response.json()
            return None
        except Exception:
            return None
    
    def list_metrics(self) -> Optional[Dict[str, Any]]:
        """Listar métricas disponíveis"""
        try:
            response = self.session.get(f"{self.mcp_server_url}/mcp/metrics")
            if response.status_code == 200:
                return response.json()
            return None
        except Exception:
            return None
    
    def get_prometheus_status(self) -> Optional[Dict[str, Any]]:
        """Obter status do Prometheus"""
        try:
            response = self.session.get(f"{self.mcp_server_url}/mcp/status")
            if response.status_code == 200:
                return response.json()
            return None
        except Exception:
            return None
    
    def get_system_metrics(self) -> Dict[str, Any]:
        """Obter métricas básicas do sistema"""
        metrics = {}
        
        # CPU
        cpu_query = '100 - (avg by (instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)'
        cpu_result = self.query_metric(cpu_query)
        if cpu_result and cpu_result.get('status') == 'success':
            cpu_data = cpu_result.get('result', [])
            if cpu_data:
                metrics['cpu_usage'] = float(cpu_data[0].get('value', [0, 0])[1])
        
        # Memória
        memory_query = '(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100'
        memory_result = self.query_metric(memory_query)
        if memory_result and memory_result.get('status') == 'success':
            memory_data = memory_result.get('result', [])
            if memory_data:
                metrics['memory_usage'] = float(memory_data[0].get('value', [0, 0])[1])
        
        # Disco
        disk_query = '(1 - (node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"})) * 100'
        disk_result = self.query_metric(disk_query)
        if disk_result and disk_result.get('status') == 'success':
            disk_data = disk_result.get('result', [])
            if disk_data:
                metrics['disk_usage'] = float(disk_data[0].get('value', [0, 0])[1])
        
        return metrics
    
    def get_asterisk_metrics(self) -> Dict[str, Any]:
        """Obter métricas específicas do Asterisk"""
        metrics = {}
        
        # Chamadas ativas
        calls_query = 'asterisk_calls_active'
        calls_result = self.query_metric(calls_query)
        if calls_result and calls_result.get('status') == 'success':
            calls_data = calls_result.get('result', [])
            if calls_data:
                metrics['active_calls'] = float(calls_data[0].get('value', [0, 0])[1])
        
        # Status dos peers
        peers_query = 'asterisk_peer_status'
        peers_result = self.query_metric(peers_query)
        if peers_result and peers_result.get('status') == 'success':
            peers_data = peers_result.get('result', [])
            if peers_data:
                metrics['peer_status'] = [peer.get('metric', {}) for peer in peers_data]
        
        return metrics
    
    def analyze_system_health(self) -> Dict[str, Any]:
        """Análise inteligente da saúde do sistema"""
        system_metrics = self.get_system_metrics()
        
        analysis = {
            "timestamp": datetime.now().isoformat(),
            "overall_health": "unknown",
            "issues": [],
            "recommendations": []
        }
        
        # Análise de CPU
        if 'cpu_usage' in system_metrics:
            cpu_usage = system_metrics['cpu_usage']
            if cpu_usage > 90:
                analysis["overall_health"] = "critical"
                analysis["issues"].append(f"CPU muito alta: {cpu_usage:.1f}%")
                analysis["recommendations"].append("Verificar processos consumindo CPU")
            elif cpu_usage > 80:
                analysis["overall_health"] = "warning"
                analysis["issues"].append(f"CPU alta: {cpu_usage:.1f}%")
                analysis["recommendations"].append("Monitorar tendência de CPU")
        
        # Análise de Memória
        if 'memory_usage' in system_metrics:
            memory_usage = system_metrics['memory_usage']
            if memory_usage > 95:
                analysis["overall_health"] = "critical"
                analysis["issues"].append(f"Memória crítica: {memory_usage:.1f}%")
                analysis["recommendations"].append("Verificar vazamentos de memória")
            elif memory_usage > 85:
                analysis["overall_health"] = "warning"
                analysis["issues"].append(f"Memória alta: {memory_usage:.1f}%")
                analysis["recommendations"].append("Considerar limpeza de cache")
        
        # Análise de Disco
        if 'disk_usage' in system_metrics:
            disk_usage = system_metrics['disk_usage']
            if disk_usage > 95:
                analysis["overall_health"] = "critical"
                analysis["issues"].append(f"Disco crítico: {disk_usage:.1f}%")
                analysis["recommendations"].append("Limpar arquivos desnecessários imediatamente")
            elif disk_usage > 85:
                analysis["overall_health"] = "warning"
                analysis["issues"].append(f"Disco alto: {disk_usage:.1f}%")
                analysis["recommendations"].append("Planejar limpeza de disco")
        
        # Definir saúde geral
        if analysis["overall_health"] == "unknown":
            if not analysis["issues"]:
                analysis["overall_health"] = "healthy"
            else:
                analysis["overall_health"] = "degraded"
        
        return analysis
    
    def get_metric_history(self, query: str, start_time: str, end_time: str) -> Optional[Dict[str, Any]]:
        """Obter histórico de métricas"""
        try:
            # Implementar query de range para histórico
            range_query = f'{query}[{start_time}:{end_time}]'
            return self.query_metric(range_query)
        except Exception:
            return None
    
    def is_healthy(self) -> bool:
        """Verificar se o cliente está saudável"""
        return self.health_check()

# Exemplo de uso
if __name__ == "__main__":
    client = PrometheusMCPClient("http://localhost:8080")
    
    if client.is_healthy():
        print("✅ MCP Client saudável")
        
        # Obter métricas do sistema
        system_metrics = client.get_system_metrics()
        print(f"📊 Métricas do sistema: {system_metrics}")
        
        # Análise de saúde
        health_analysis = client.analyze_system_health()
        print(f"🏥 Análise de saúde: {health_analysis}")
    else:
        print("❌ MCP Client não está saudável")
