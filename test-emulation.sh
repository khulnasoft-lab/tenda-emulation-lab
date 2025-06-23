#!/bin/bash

echo "[*] Checking if port 80 is open..."

for i in {1..10}; do
    if curl -s http://localhost:80 | grep -q '<html'; then
        echo "[+] Web interface detected on port 80."
        exit 0
    fi
    sleep 2
done

echo "[-] Emulation test failed. No response on port 80."
exit 1
