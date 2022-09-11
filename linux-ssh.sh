#linux-run.sh LINUX_USER_PASSWORD NGROK_AUTH_TOKEN LINUX_USERNAME LINUX_MACHINE_NAME
#!/bin/bash
# /home/runner/.ngrok2/ngrok.yml

sudo useradd -m vps
sudo adduser vps sudo
echo "vps:vps" | sudo chpasswd
sed -i 's/\/bin\/sh/\/bin\/bash/g' /etc/passwd
sudo hostname $vps

#sudo su -l $LINUX_USERNAME
#cd ~

if [[ -z "$NGROK_AUTH_TOKEN" ]]; then
  echo "Please set 'NGROK_AUTH_TOKEN'"
  #exit 2
fi

if [[ -z "$LINUX_USER_PASSWORD" ]]; then
  echo "Please set 'LINUX_USER_PASSWORD' for user: $USER"
  #exit 3
fi

echo "### Install ngrok ###"

wget -q https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.zip
unzip ngrok-stable-linux-386.zip
chmod +x ./ngrok

echo "### Update user: $USER password ###"
echo -e "$LINUX_USER_PASSWORD\n$LINUX_USER_PASSWORD" | sudo passwd "$USER"

echo "### Start ngrok proxy for 22 port ###"


rm -f .ngrok.log
./ngrok authtoken "2DuZe5pHY5MjGMQy6eSTDoUG0ZL_6wJTun5tncFEn7UUqRKLK"
./ngrok tcp 22 --log ".ngrok.log" &

sleep 10
HAS_ERRORS=$(grep "command failed" < .ngrok.log)

if [[ -z "$HAS_ERRORS" ]]; then
  echo ""
  echo "=========================================="
  echo "To connect: $(grep -o -E "tcp://(.+)" < .ngrok.log | sed "s/tcp:\/\//ssh $USER@/" | sed "s/:/ -p /")"
  echo "or conenct with $(grep -o -E "(.+)" < .ngrok.log | sed "s/tcp:\/\//ssh (Your Linux Username)@/" | sed "s/:/ -p /")"
  #curl --silent -o i -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "{\"content\": \"To connect: $(grep -o -E "tcp://(.+)" < .ngrok.log | sed "s/tcp:\/\//ssh $USER@/" | sed "s/:/ -p /")"}" https://ptb.discord.com/api/webhooks/1012830182882685140/coAa8BUhkJJc9EHPAanJ2IECPG9Podh7H3J3cBZPF2_sRqQAOKH-HuKEKuqxr6rBInEC
  ngip="To connect ssh: $(grep -o -E "tcp://(.+)" < .ngrok.log | sed "" | sed "s/:/ -p /")"
  #ngip="To connect: $(grep -o -E "tcp://(.+)" < .ngrok.log | sed "s/tcp:\/\//ssh $USER@/" | sed "s/:/ -p /")"
  echo $ngip
  curl -H "Content-Type: application/json" -d '{"username": "test", "content": "'"$ngip"'"}' "https://ptb.discord.com/api/webhooks/1012830182882685140/coAa8BUhkJJc9EHPAanJ2IECPG9Podh7H3J3cBZPF2_sRqQAOKH-HuKEKuqxr6rBInEC"
  echo "=========================================="
else
  echo "$HAS_ERRORS"
  #curl -H "Content-Type: application/json" -d '{"username": "test", "content": "To connect: $(grep -o -E "tcp://(.+)" < .ngrok.log | sed "s/tcp:\/\//ssh $USER@/" | sed "s/:/ -p /")"}' "https://ptb.discord.com/api/webhooks/1012830182882685140/coAa8BUhkJJc9EHPAanJ2IECPG9Podh7H3J3cBZPF2_sRqQAOKH-HuKEKuqxr6rBInEC"
  exit 4
fi
