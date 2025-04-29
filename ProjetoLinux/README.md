
# 🔍 Projeto de Monitoramento de Site com Nginx, Bash Script e Webhook Discord

Este projeto tem como objetivo a configuração de um servidor web com Nginx em ambiente Linux, aliado a um script de monitoramento automático que:

- Faz requisições ao site hospedado localmente (localhost);
- Envia alertas para um canal do Discord via Webhook;
- Armazena logs das verificações realizadas.

---

## 🛠️ 1. Como Configurar o Ambiente

### Atualizando o sistema

```bash
sudo apt update
sudo apt upgrade -y
```

### ⚙️ Instalação do Nginx

```bash
sudo apt install nginx -y
```

### Ativação do serviço

```bash
sudo systemctl start nginx
sudo systemctl enable nginx
```

### Verificação do status

```bash
sudo systemctl status nginx
```

### Configuração padrão

- O Nginx escuta na porta `80` por padrão com a configuração localizada em:

```bash
/etc/nginx/sites-available/default
```

- O conteúdo padrão é servido a partir de:

```bash
/var/www/html
```

Para aplicar alterações de configuração:

```bash
sudo nginx -t
sudo systemctl reload nginx
```

---

## 📜 3. Como Funciona o Script de Monitoramento

### Objetivo do Script

1. O servidor Nginx é iniciado e serve o site na porta 80.  
2. O script de monitoramento realiza requisições HTTP para `localhost`.  
3. A cada execução, ele:  
   - Verifica o status da resposta.  
   - Armazena o resultado em log.  
   - Envia uma notificação para o Discord via Webhook.  
4. O `cron` garante a execução automática em intervalos definidos.

### Caminho recomendado para salvar o script:

```bash
/home/scripts/nginx_check_script.sh
```

### Conteúdo do script

```bash
#!/bin/bash

#Caminho para o LOG
LOGFILE="/var/log/meu_script.log"

#Url do site
SITE_URL="http://localhost"

#Url webhook discord
WEBHOOK_URL="https://discord.com/api/webhooks/SEU_WEBHOOK"

#Hora da verificação
TIME=$(date '+Data: %d-%m-%Y - Hora: %Hh%Mm%Ss')

#Enviar alerta para o discord
func_alerta() {
    curl -H "Content-Type:application/json" -X POST -d "{\"content\": \"$1\"}" "$WEBHOOK_URL";
}

#Script para verificar o status do site
if curl -I "$SITE_URL" | grep -q "200"; then
    echo "$TIME - O site está acessível (Status 200)." | tee -a "$LOGFILE"
    func_alerta "\n**Status do site:**\n$TIME\n\n:green_heart: O site está acessível e retornou o status 200!"
else 
    echo "$TIME - O site não está acessível ou retornou erro!" | tee -a "$LOGFILE"
    func_alerta "\n**Status do site:**\n$TIME\n\n:warning: Atencao: o site não está acessível ou retornou erro!"

fi
```

### Permissões

```bash
chmod +x /home/scripts/nginx_check_script.sh
```

### Execução manual

```bash
sudo /home/scripts/nginx_check_script.sh
```

### Execução automática com crontab

```bash
sudo crontab -e
```

Adicione a linha para executar o script a cada 5 minutos:

```bash
* * * * * /home/scripts/nginx_check_script.sh
```

---

## ✅ 4. Como Testar e Validar a Solução

### Testar a resposta do site

```bash
curl -I http://localhost
```

### Verificar se os alertas chegam ao Discord

- Simule a parada do serviço:
```bash
sudo systemctl stop nginx
```
- Aguarde até o próximo ciclo do cron (ou execute o script manualmente) para receber a notificação no Discord.

- Reinicie o serviço:
```bash
sudo systemctl start nginx
```

### Verificar os logs gerados

```bash
cat /var/log/meu_script.log
```

---

## 🧰 Tecnologias Utilizadas

- **Ubuntu**
- **Nginx**
- **Bash Script**
- **Discord Webhook**
- **HTML**

---

## 👨‍💻 Autor

Lucas Sarasa  
[LinkedIn](https://www.linkedin.com/in/lucassarasa)

---

## 📄 Licença

Este projeto está licenciado sob a [MIT License](LICENSE).