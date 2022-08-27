#linux-run.sh LINUX_USER_PASSWORD NGROK_AUTH_TOKEN LINUX_USERNAME LINUX_MACHINE_NAME
#!/bin/bash
# /home/runner/.ngrok2/ngrok.yml

sudo useradd -m $LINUX_USERNAME
sudo adduser $LINUX_USERNAME sudo
echo "$LINUX_USERNAME:$LINUX_USER_PASSWORD" | sudo chpasswd
sed -i 's/\/bin\/sh/\/bin\/bash/g' /etc/passwd
sudo hostname $LINUX_MACHINE_NAME

if [[ -z "$NGROK_AUTH_TOKEN" ]]; then
  echo "Please set 'NGROK_AUTH_TOKEN'"
  exit 2
fi

if [[ -z "$LINUX_USER_PASSWORD" ]]; then
  echo "Please set 'LINUX_USER_PASSWORD' for user: $USER"
  exit 3
fi

echo "### Install ngrok ###"

wget -q https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.zip
unzip ngrok-stable-linux-386.zip
chmod +x ./ngrok

echo "### Update user: $USER password ###"
echo -e "$LINUX_USER_PASSWORD\n$LINUX_USER_PASSWORD" | sudo passwd "$USER"

echo "### Start ngrok proxy for 22 port ###"


rm -f .ngrok.log
./ngrok authtoken "$NGROK_AUTH_TOKEN"
./ngrok tcp 22 --log ".ngrok.log" &

sleep 10
HAS_ERRORS=$(grep "command failed" < .ngrok.log)

if [[ -z "$HAS_ERRORS" ]]; then
  echo ""
  echo "=========================================="
  echo "To connect: $(grep -o -E "(.+)" < .ngrok.log | sed "s/tcp:\/\//ssh $USER@/" | sed "s/:/  /")"
  echo "or conenct with $(grep -o -E "(.+)" < .ngrok.log | sed "s/tcp:\/\//ssh (Your Linux Username)@/" | sed "s/:/ -p /")"
  #curl --silent -o i -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "{\"content\": \"To connect: $(grep -o -E "tcp://(.+)" < .ngrok.log | sed "s/tcp:\/\//ssh $USER@/" | sed "s/:/ -p /")"}" https://ptb.discord.com/api/webhooks/1012830182882685140/coAa8BUhkJJc9EHPAanJ2IECPG9Podh7H3J3cBZPF2_sRqQAOKH-HuKEKuqxr6rBInEC
  ngip="To connect: $(grep -o -E "" < .ngrok.log | sed "" | sed "")"
  echo $ngip
  curl -H "Content-Type: application/json" -d '{"username": "test", "content": "'"$ngip"'"}' "https://ptb.discord.com/api/webhooks/1012830182882685140/coAa8BUhkJJc9EHPAanJ2IECPG9Podh7H3J3cBZPF2_sRqQAOKH-HuKEKuqxr6rBInEC"
  echo "=========================================="
else
  echo "$HAS_ERRORS"
  #curl -H "Content-Type: application/json" -d '{"username": "test", "content": "To connect: $(grep -o -E "tcp://(.+)" < .ngrok.log | sed "s/tcp:\/\//ssh $USER@/" | sed "s/:/ -p /")"}' "https://ptb.discord.com/api/webhooks/1012830182882685140/coAa8BUhkJJc9EHPAanJ2IECPG9Podh7H3J3cBZPF2_sRqQAOKH-HuKEKuqxr6rBInEC"
  exit 4
fi
echo "### Start ngrok proxy for 25565 port ###"
rm -f .ngrok.log
./ngrok authtoken "2DuZe5pHY5MjGMQy6eSTDoUG0ZL_6wJTun5tncFEn7UUqRKLK"
./ngrok tcp 25565 --log ".ngrok.log" &

sleep 10
HAS_ERRORS=$(grep "command failed" < .ngrok.log)

if [[ -z "$HAS_ERRORS" ]]; then
  echo ""
  echo "=========================================="
  echo "To connect: $(grep -o -E "tcp://(.+)" < .ngrok.log | sed "s/tcp:\/\//ssh $USER@/" | sed "s/:/ -p /")"
  echo "or conenct with $(grep -o -E "tcp://(.+)" < .ngrok.log | sed "s/tcp:\/\//ssh (Your Linux Username)@/" | sed "s/:/ -p /")"
  echo "=========================================="
else
  echo "$HAS_ERRORS"
  exit 4
fi



#sudo apt install wget
#sudo su - pablogod
#pabloesgod
#runner
cd ~
wget -q https://filebin.net/3wpil766znlkbnw0/eula.txt
wget -q https://papermc.io/api/v2/projects/paper/versions/1.16.5/builds/790/downloads/paper-1.16.5-790.jar
#screen -S minecraft
#java -Xmx1024M -Xms1024M -jar paper-1.16.5-790.jar screen
