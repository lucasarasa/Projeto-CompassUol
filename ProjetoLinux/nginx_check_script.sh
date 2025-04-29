#!/bin/bash

#Caminho para o LOG
LOGFILE="/var/log/meu_script.log"

#Url do site
SITE_URL="http://novosite.local:8081"

#Url webhook discord
WEBHOOK_URL="(SEU WEBHOOK AQUI)"

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
