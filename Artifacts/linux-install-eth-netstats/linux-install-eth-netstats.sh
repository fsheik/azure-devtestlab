# Script to install eth netstats to monitor eth nodes
#
# NOTE: Intended for use by the Azure DevTest Lab artifact system.
#
# Usage: linux-install-eth-netstats.sh

USAGE_STRING="Usage: linux-install-eth-netstats.sh"

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

# Check if node is installed.
nodejs -v
if [ $? -ne 0 ] ; then
  curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
  sudo apt-get install -y nodejs build-essential
fi

git clone https://github.com/cubedro/eth-netstats
cd eth-netstats
npm install
npm install -g grunt-cli

# To build the full version
grunt

## daemonizing the process ##
npm install -g pm2

pm2 

sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup upstart -u root --hp /root