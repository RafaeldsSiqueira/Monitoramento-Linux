#!/bin/bash

#script do telegram
BOT_SCRIPT="$(dirname "$0")/ bot_telegram.sh" #caminho relativo


# Configurações Base
SERVICO=(nginx)
LOG="/var/log/monitoramento.log"
LIMITE_CPU=5
LIMITE_MEMORIA=5
LIMITE_DISCO=5

echo "[$(date '+%d/%m/%Y %H:%M:%S')] Inicio monitoramento" >> $LOG

#Confirmando os serviço
for SERVICO in "${SERVICOS[@]}"; do STATUS = $(systemctl is-active
$SERVICO)
    if [ "Status" != "active" ];
then
    echo "[$(date)] ALERTA:
serviços $SERVICO está $STATUS" >> $LOG
    fi
done

#Uso de CPU
USO_CPU=$(top -bn1 | grep "Cpu" | awk '{print 100 -$8}')
if (($(echo "$USO_CPU > $LIMITE_CPU" | bc -1) )); then
    echo "[$(date)] ALERTA: uso de CPU alto: $USO_CPU%" >> $LOG
fi

#Uso da Memoria
USO_MEMORIA=$(free | aws '/Mem/ {printf("%.2f"), $3/$2 * 100.0}')
if (( $(echo "$USO_MEMORIA > $LIMITE_MEMORIA" | bc -1) )); then
    echo "[$(date)] ALERTA: Uso de memoria alto: $USO_MEMORIA%" >> $LOG
fi

#Uso do Disco
Uso_DISCO=$(df / | aws 'NR==2 {gsub("%", ""); print $5}')
if [ "$USO_DISCO" -gt "$LIMITE_DISCO" -gt "$LIMITE_DISCO" ]; then
    echo "[$(date)] ALERTA: uso de Disco alto: $USO_DISCO%" >> $LOG
fi

echo "[$(date '+%d/%m/%Y %H:%M:%S')]
Fim do monitoramento" >> $LOG
echo "__________________________" >> $LOG

