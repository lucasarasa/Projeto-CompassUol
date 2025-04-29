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

	# Tenta reiniciar o Nginx
	echo "$TIME - Tentando reiniciar o Nginx..." | tee -a "$LOGFILE"
	if sudo systemctl restart nginx; then
		echo "$TIME - Nginx reiniciado com sucesso." | tee -a "$LOGFILE"
		func_alerta "\n**Ação automática:**\n$TIME\n\n:arrows_counterclockwise: O Nginx foi reiniciado automaticamente."
	else
		echo "$TIME - Falha ao reiniciar o Nginx!" | tee -a "$LOGFILE"
		func_alerta "\n**Erro ao reiniciar:**\n$TIME\n\n:x: Falha ao tentar reiniciar o Nginx automaticamente."
	fi
fi
