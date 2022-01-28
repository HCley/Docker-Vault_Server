#!/bin/bash

#	Permissions
chmod +x vault_awaken.service
chmod +x vault_unseal.service
chmod +x server_report.sh
chmod +x unseal.sh

#	Links
ln -L vault_awaken.service /etc/systemd/system
ln -L vault_unseal.service /etc/systemd/system

#	Generate systemd service
# awaken service
systemctl start vault_awaken.service
systemctl enable vault_awaken
# unseal service
systemctl start vault_unseal.service
systemctl enable vault_unseal

###	ACTION REQUIRED
##	Add on crontab -e
#	00,30 * * * * /opt/vaultserver/server_report.sh
