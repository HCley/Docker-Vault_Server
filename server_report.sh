#!/bin/bash

NETWORK=$(/bin/bash -c "ifconfig wlan0" | grep broadcast | xargs -n 2)

IP=$(echo "$NETWORK" | grep inet)
IP=${IP//"inet "/""}

TEMP=$(/bin/bash -c "/usr/local/bin/temp")
TEMP=${TEMP//"temp="/""}


TOKEN=$(
	curl \
		-s \
		-L \
		-X POST \
		-H 'Content-Type: application/json' \
		--data-raw '{
			"role_id": "'$VAULT_ROLE_ID'",
    		"secret_id": "'$VAULT_SECRET_ID'"
		}' \
		http://127.0.0.1:8200/v1/auth/approle/login | \
	jq --raw-output '.auth.client_token'
) > /dev/null


RES=$(
	curl \
		-s \
		-X PATCH \
		-H 'X-Vault-Request: true' \
		-H 'content-Type: application/merge-patch+json' \
		-H "Authorization: Bearer $TOKEN" \
		--data-raw '{
			"data":
				{
					"VAULT_SERVER_TEMPERATURE": "'$TEMP'",
					"VAULT_SERVER_NAME": "raspberry",
					"VAULT_SERVER_PORT": "8200",
					"VAULT_SERVER_IP": "'$IP'"
				}
		}' \
		http://127.0.0.1:8200/v1/kv/data/server/info
) > /dev/null
