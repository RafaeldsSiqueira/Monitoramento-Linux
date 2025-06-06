#!/bin/bash

#script do telegram
BOT_SCRIPT="$(dirname "$0")/bot_telegram.sh" #caminho relativo

# Configurações Base
SERVICOS=("nginx" "mysql")
LOG="/home/rafael/monitoramento.log"
LIMITE_CPU=5
LIMITE_MEMORIA=5
LIMITE_DISCO=5

echo "[$(date '+%d/%m/%Y %H:%M:%S')] Inicio monitoramento" >> $LOG

#Confirmando os serviço
for SERVICO in "${SERVICOS[@]}"; do
    STATUS=$(systemctl is-active "$SERVICO" 2>/dev/null)
    if [ "$STATUS" != "active" ];
then
    echo "[$(date)] ALERTA: serviços $SERVICO está $STATUS" >> $LOG
    $BOT_SCRIPT "ALERTA: serviços $SERVICO está $STATUS"
    fi
done

#Uso de CPU
USO_CPU=$(top -bn1 | grep "CPU(s)" | awk '{print 100 -$8}')
if [ -n "$USO_CPU" ] && (($(echo "$USO_CPU > $LIMITE_CPU" | bc -l))); then
    echo "[$(date)] ALERTA: uso de CPU alto: $USO_CPU%" >> $LOG
    $BOT_SCRIPT "ALERTA: Uso de CPU alto: $USO_CPU%"
fi

#Uso da Memoria
USO_MEMORIA=$(free | awk '/Mem/ {printf "%.0f", $3/$2 * 100}')
if [ -n "$USO_MEMORIA" ] && (($(echo "$USO_MEMORIA > $LIMITE_MEMORIA" | bc -l))); then
    echo "[$(date)] ALERTA: Uso de memoria alto: $USO_MEMORIA%" >> $LOG
    $BOT_SCRIPT "ALERTA: Uso de memória alto: $USO_MEMORIA%"
fi

#Uso do Disco
USO_DISCO=$(df / --output=pcent | tail -1 | tr -d '% ')
if [ -n "$USO_DISCO" ] && [ "$USO_DISCO" -gt "$LIMITE_DISCO" ]; then
    echo "[$(date)] ALERTA: uso de disco alto: ${USO_DISCO}%" >> $LOG
    "$BOT_SCRIPT" "ALERTA: Uso de disco $USO_DISCO%"
fi

echo "[$(date '+%d/%m/%Y %H:%M:%S')] Fim do monitoramento" >> $LOG
echo "__________________________" >> $LOG