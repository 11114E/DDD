#!/bin/bash

LOG_FILE="/root/track_balances.log"

# Navigate to the correct directory
cd /root/ceremonyclient/node || exit 1  # Exit if directory change fails

# Fetch balance and peer ID
PEER_ID=$(./node-1.4.21.1-linux-amd64 -peer-id | grep "Peer ID" | awk '{print $3}')
BALANCE=$(./node-1.4.21.1-linux-amd64 -balance | grep "Unclaimed balance" | awk '{print $3}')
HOSTNAME=$(hostname)

DATE=$(date '+%Y-%m-%d %H:%M:%S')

# Log peer ID, balance, and hostname
echo "[$DATE] Peer ID: $PEER_ID, Balance: $BALANCE, Hostname: $HOSTNAME" >> $LOG_FILE

# Send the data to the Flask server
curl -X POST -H "Content-Type: application/json" \
-d "{\"peer_id\":\"$PEER_ID\", \"balance\":\"$BALANCE\", \"timestamp\":\"$DATE\", \"hostname\":\"$HOSTNAME\"}" \
http://172.16.6.134:5000/update_balance >> $LOG_FILE 2>&1