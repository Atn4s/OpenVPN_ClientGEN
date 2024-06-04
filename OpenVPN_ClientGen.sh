#!/bin/bash 

# Identifica o nome do usuário digitado apos: ./OpenVPN_ClientGen.sh EXEMPLO
CLIENT_IDENTIFIER=$1

# Verifica se os arquivos estão presentes no Diretório
if [[ ! -f "ca.crt" ]]; then
  echo "ca.crt: Arquivo ou diretório inexistente"
  exit 1
fi

if [[ ! -f "${CLIENT_IDENTIFIER}.crt" ]]; then
  echo "${CLIENT_IDENTIFIER}.crt: Arquivo ou diretório inexistente"
  exit 1
fi

if [[ ! -f "${CLIENT_IDENTIFIER}.key" ]]; then
  echo "${CLIENT_IDENTIFIER}.key: Arquivo ou diretório inexistente"
  exit 1
fi

if [[ ! -f "${CLIENT_IDENTIFIER}.pem" ]]; then
  echo "${CLIENT_IDENTIFIER}.pem: Arquivo ou diretório inexistente"
  exit 1
fi

# Cria o arquivo .ovpn
cat <(echo -e 'client') \
<(echo -e 'proto udp') \
<(echo -e 'dev tun') \
<(echo -e 'remote 127.0.0.1 1194') \
<(echo -e 'resolv-retry infinite') \
<(echo -e 'nobind') \
<(echo -e 'persist-key') \
<(echo -e 'persist-tun') \
<(echo -e 'remote-cert-tls server') \
<(echo -e 'cipher AES-256-GCM') \
<(echo -e '#user nobody') \
<(echo -e '#group nobody') \
<(echo -e 'verb 3') \
<(echo -e '<ca>') \
<(cat ca.crt) \
<(echo -e '</ca>\n<cert>') \
<(cat ${CLIENT_IDENTIFIER}.crt) \
<(echo -e '</cert>\n<key>') \
<(cat ${CLIENT_IDENTIFIER}.key) \
<(echo -e '</key>\n<tls-crypt-v2>') \
<(cat ${CLIENT_IDENTIFIER}.pem) \
<(echo -e '</tls-crypt-v2>') \
> ${CLIENT_IDENTIFIER}.ovpn

echo "${CLIENT_IDENTIFIER}.ovpn Usuário foi criado com exito."