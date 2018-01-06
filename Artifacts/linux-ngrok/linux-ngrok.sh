# Script to install and setup ngrok Azure DevTest lab Linux VMs.
#
# NOTE: Intended for use by the Azure DevTest Lab artifact system.
#
# Usage: linux-ngrok.sh <YOUR_AUTHKEY_HERE>

USAGE_STRING="Usage: linux-ngrok.sh <YOUR_AUTHKEY_HERE>"

LOGCMD='logger -i -t AZDEVTST_APTPKG --'
which logger
if [ $? -ne 0 ] ; then
    LOGCMD='echo [AZDEVTST_APTPKG] '
fi

$LOGCMD "Setting up ngrok.. Command line given:"
# Cannot use logger here, as the -- are interpreted by that command
$LOGCMD "   $@"

# Check for minimum number of parameters first - must be at minimum 1
if [ $# -lt 1 ] ; then
  $LOGCMD "ERROR: This script needs auth token as an argument."
  $LOGCMD "$USAGE_STRING"
  exit 1
fi  

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
    cp ./ngrok_amd64 /opt/ngrok/ngrok
else
    # 32 Bit
    cp ./ngrok_i386 /opt/ngrok/ngrok
fi

# Check if binary copy was success
if [ $? -eq 0 ]; then
    $LOGCMD "Successfully copied ngrok binary."
    echo "Successfully copied ngrok binary."
else
    $LOGCMD "Here's some debug information.."
    echo "Here's some debug information.."

    $LOGCMD "Current working directory"
    echo "Current working directory"

    $LOGCMD `pwd`
    echo `pwd`

    $LOGCMD "Files in current working directory.."
    echo "Files in current working directory.."

    RESULT=$(ls `pwd`)
    $LOGCMD $RESULT
    echo $RESULT
    ls -al `pwd`
    
    exit 1
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