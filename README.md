# Monitoramento-Linux
Monitoramento de Serviços de servidor LINUX

scrript padrão para monitoramento base para sistemas linux que verifica:

Status de serviços ativos
Uso de CPU, Memoria e Disco
Geração de log em '/var/log/monitoramento.log'

Pasta para execução do script:
o script ficará em '/home/customização/monitoramento.sh'

*********************************************************************************8

Como utilizar

Atribuir permição para execução do script

chmod +x monitoramento.sh

Poderá ser executado de maneira manual:
./monitoramento.sh

Agendada utilizando cron a cada 5 minutos podendo agendar em menos tempo
*/5**** /home/customização/monitoramento.sh