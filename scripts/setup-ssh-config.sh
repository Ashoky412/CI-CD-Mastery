#!/bin/bash

# === 1. Define Variables ===
pem_key_path="$HOME/apmumbai.pem"
ssh_pub_key_path="$HOME/.ssh/ashok.pub"
ssh_config_path="$HOME/.ssh/config"
ssh_private_key_path="$HOME/.ssh/ashok"

master_ip="master_public_ip"
worker_ip="worker_public_ip"

# === 2. Setup Passwordless SSH on master and worker ===
for ip in $master_ip $worker_ip; do
  echo "🚀 Setting up passwordless SSH for $ip..."
  ssh -o StrictHostKeyChecking=no -i "$pem_key_path" ubuntu@"$ip" <<EOF
mkdir -p ~/.ssh
echo "$(cat $ssh_pub_key_path)" >> ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
chown ubuntu:ubuntu ~/.ssh/authorized_keys
EOF
done

# === 3. Update SSH config ===
echo "⚙️ Updating SSH config at $ssh_config_path..."
cp "$ssh_config_path" "$ssh_config_path.bak.$(date +%F_%T)" 2>/dev/null

cat > "$ssh_config_path" <<EOF
Host myec2
    HostName 3.6.236.14
    User ubuntu
    IdentityFile ~/.ssh/id_rsa
    IdentitiesOnly yes

Host master
    HostName $master_ip
    User ubuntu
    IdentityFile $ssh_private_key_path
    IdentitiesOnly yes

Host worker
    HostName $worker_ip
    User ubuntu
    IdentityFile $ssh_private_key_path
    IdentitiesOnly yes
EOF

chmod 600 "$ssh_config_path"
echo "✅ SSH config and passwordless auth setup completed."

