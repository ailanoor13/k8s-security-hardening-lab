#!/bin/bash
set -euxo pipefail

swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

curl -sfL https://get.k3s.io -o /tmp/k3s-install.sh
chmod +x /tmp/k3s-install.sh
INSTALL_K3S_SKIP_START=true /tmp/k3s-install.sh

echo "k3s binary installed (not started). See README for next steps." > /var/log/node-prep-done.log
