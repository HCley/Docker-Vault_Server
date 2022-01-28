#!/bin/bash

curl \
	-s \
	-L \
	-X PUT \
	-H 'Content-Type: application/json' \
	--data-raw '{
    	"key": "'$VAULT_BASE64_KEY'"
	}' \
	http://127.0.0.1:8200/v1/sys/unseal
