#!/usr/bin/env python3
"""
API do AI Agent - Sistema de Monitoramento Inteligente
Integração com Google Gemini e MCP Server
"""

import os
import json
import requests
from datetime import datetime
from flask import Flask, request, jsonify, render_template
from dotenv import load_dotenv
from mcp_client import PrometheusMCPClient

# Carregar variáveis de ambiente
load_dotenv()

app = Flask(__name__)

# Configurações
GOOGLE_API_KEY = os.getenv('GOOGLE_API_KEY')
EMAIL_ADDRESS = os.getenv('EMAIL_ADDRESS')
EMAIL_PASSWORD = os.getenv('EMAIL_PASSWORD')
AUDIT_EMAIL = os.getenv('AUDIT_EMAIL')
MCP_SERVER_URL = os.getenv('MCP_SERVER_URL', 'http://localhost:8080')

# Cliente MCP
mcp_client = PrometheusMCPClient(MCP_SERVER_URL)

@app.route('/')
def index():
    """Página principal"""
    return render_template('index.html')

@app.route('/health')
def health():
    """Health check"""
    return jsonify({
        "status": "healthy",
        "service": "AI Agent",
        "timestamp": datetime.now().isoformat()
    })

@app.route('/analyze')
def analyze_system():
    """Análise inteligente do sistema"""
    try:
        # Obter métricas via MCP
        system_metrics = mcp_client.get_system_metrics()
        health_analysis = mcp_client.analyze_system_health()
        
        # Análise com Google Gemini (se configurado)
        if GOOGLE_API_KEY and GOOGLE_API_KEY != "sua_chave_api_gemini_aqui":
            ai_insights = analyze_with_gemini(system_metrics, health_analysis)
        else:
            ai_insights = "Google Gemini não configurado"
        
        return jsonify({
            "status": "success",
            "timestamp": datetime.now().isoformat(),
            "system_metrics": system_metrics,
            "health_analysis": health_analysis,
            "ai_insights": ai_insights
        })
    except Exception as e:
        return jsonify({
            "status": "error",
            "error": str(e)
        }), 500

@app.route('/metrics')
def get_metrics():
    """Obter métricas específicas"""
    try:
        metric_name = request.args.get('metric', 'up')
        result = mcp_client.query_metric(metric_name)
        return jsonify(result)
    except Exception as e:
        return jsonify({
            "status": "error",
            "error": str(e)
        }), 500

@app.route('/webhook', methods=['POST'])
def webhook():
    """Endpoint para webhooks do n8n"""
    try:
        data = request.get_json()
        
        # Processar dados do webhook
        if data:
            # Log da ação
            log_action("webhook_received", data)
            
            # Análise automática se necessário
            if data.get('trigger_analysis'):
                analysis = mcp_client.analyze_system_health()
                return jsonify({
                    "status": "success",
                    "analysis": analysis
                })
        
        return jsonify({"status": "success"})
    except Exception as e:
        return jsonify({
            "status": "error",
            "error": str(e)
        }), 500

@app.route('/approval')
def approval_interface():
    """Interface de aprovação de ações"""
    return render_template('approval.html')

def analyze_with_gemini(metrics, health):
    """Análise usando Google Gemini"""
    try:
        # Implementar integração com Google Gemini
        # Por enquanto, retorna análise básica
        return {
            "ai_analysis": "Análise básica disponível",
            "recommendations": [
                "Configure GOOGLE_API_KEY para análise avançada",
                "Use MCP Server para métricas em tempo real"
            ]
        }
    except Exception as e:
        return f"Erro na análise: {str(e)}"

def log_action(action, data):
    """Log de ações para auditoria"""
    log_entry = {
        "timestamp": datetime.now().isoformat(),
        "action": action,
        "data": data,
        "user": "system"
    }
    
    # Salvar log
    with open("logs/actions.log", "a") as f:
        f.write(json.dumps(log_entry) + "\n")

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
