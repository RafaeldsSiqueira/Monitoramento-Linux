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
chmod +x bot_telegram.sh


Poderá ser executado de maneira manual:
./monitoramento.sh

Agendada utilizando cron a cada 10 minutos podendo agendar em menos tempo
*/10**** /home/customização/monitoramento.sh









📊 Monitoramento Linux

Script simples para monitoramento de serviços e recursos de sistema Linux, ideal para servidores e ambientes DevOps. O script verifica:

✅ Status de serviços ativos (como nginx, sshd, etc.)

🔥 Uso de CPU

🧠 Uso de memória

📍 Uso de disco

📋 Geração de log em /var/log/monitor.log

📢 Envio de alertas para Telegram via bot



---

📁 Estrutura do projeto

monitoramento-linux/
├── monitoramento.sh        # Script principal
├── bot_telegram.sh         # Script que envia mensagens para o Telegram
├── .env                    # Arquivo com variáveis TOKEN e CHAT_ID
└── README.md               # Este arquivo


---

⚙️ Pré-requisitos

Sistema Linux com bash, systemd, df, top, free apçicações nativas

Token e ID de chat do bot do Telegram

Permissões de execução nos scripts



---

🚀 Como usar

1. Dê permissão de execução:

chmod +x monitoramento.sh
chmod +x bot_telegram.sh

2. Configure o .env

Crie um arquivo .env com as variáveis:

BOT_TOKEN="seu_token_aqui"
CHAT_ID="seu_chat_id_aqui"

> O script bot_telegram.sh já lê automaticamente o .env usando source.



3. Execução manual

./monitoramento.sh

4. Execução automática com cron

Exemplo para rodar a cada 10 minutos:

*/10 * * * * /home/usuario/customizacao/monitoramento.sh


---

📆 Personalizações

Para alterar os serviços monitorados, edite a variável SERVICOS no monitoramento.sh.

Os limites de CPU, memória e disco estão configurados no próprio script (LIMITE_CPU=80, etc.).

O log de alertas fica registrado em: /home/usuario/logs/monitoramento.log
Os logs podem ser direcionados para a pasta de preferencia


---

📬 Integração com Telegram

O script bot_telegram.sh envia alertas para um grupo ou chat pessoal via bot.

Crie seu bot com @BotFather

Pegue o BOT_TOKEN e CHAT_ID

Salve no .env



---

✨ Exemplo de alerta enviado

[06/06/2025 00:02:01] Inicio monitoramento
[sex 06 jun 2025 00:02:02 -03] ALERTA: uso de CPU alto: 10%
[sex 06 jun 2025 00:02:02 -03] ALERTA: Uso de memoria alto: 49%
[sex 06 jun 2025 00:02:03 -03] ALERTA: uso de disco alto: 85%
[06/06/2025 00:02:04] Fim do monitoramento

OBS: podendo ser mas detalhado de acordo com a necessidade

---

🛠️ Próximos passos (em desenvolvimento)

[ ] Integração com Zabbix ou Grafana

[ ] Painel web básico com histórico

[ ] Instalação automática (install.sh)



---

Feito com 💻 por Rafael – focado em Linux, DevOps e automações.