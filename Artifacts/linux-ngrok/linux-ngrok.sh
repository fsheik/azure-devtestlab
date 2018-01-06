# Command Line Arguments
## Authentication Token ##
AUTH_TOKEN=$1

if [ -z "$AUTH_TOKEN" ];
then
    raise error "Auth token cannot be empty."
fi

ARCHITECTURE=`uname -m`

## ngrok binary ##
mkdir -p /opt/ngrok

if [ "$ARCHITECTURE"='x86_64' ];
then
    # 64 Bit
    cp ./ngrok-stable-linux-amd64/ngrok /opt/ngrok/ngrok
else
    # 32 Bit
    cp ./ngrok-stable-linux-386/ngrok /opt/ngrok/ngrok
fi

chmod +x /opt/ngrok/ngrok

## ngrok config file ##
sed -i "s/__AUTH_TOKEN_HERE__/$AUTH_TOKEN/g" ngrok.yml

cp ./ngrok.yml /opt/ngrok/ngrok.conf

## Setup ngrok as a service ##
cp ./ngrok.upstart.conf /etc/init/ngrok.conf

start ngrok

# TODO :
# 1. Add logging
# 2. Usage description header