#!/bin/bash

echo "Waiting for internet connection via NAT Gateway..."
until ping -c 1 archive.ubuntu.com &> /dev/null; do
    sleep 5
done

apt-get update -y
apt-get install -y apache2


systemctl start apache2
systemctl enable apache2

# Fetch IMDSv2 Token
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# Fetch Instance ID and Instance Type using IMDSv2
INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
INSTANCE_TYPE=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-type)


cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Load Balancer Test</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin-top: 100px; background-color: #f4f4f9; }
        .card { background: white; padding: 30px; display: inline-block; border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        h1 { color: #2c3e50; }
        p { font-size: 18px; color: #34495e; }
        .highlight { font-weight: bold; color: #e74c3c; }
    </style>
</head>
<body>
    <div class="card">
        <h1>Response from Web Server</h1>
        <p>Instance ID: <span class="highlight">${INSTANCE_ID}</span></p>
        <p>Instance Type: <span class="highlight">${INSTANCE_TYPE}</span></p>
    </div>
</body>
</html>
EOF