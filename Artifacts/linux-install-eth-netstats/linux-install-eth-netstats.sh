# Script to install eth netstats to monitor eth nodes
#
# NOTE: Intended for use by the Azure DevTest Lab artifact system.
#
# Usage: linux-install-eth-netstats.sh

USAGE_STRING="Usage: linux-install-eth-netstats.sh"

# Check if node is installed.
nodejs -v
if [ $? -ne 0 ] ; then
  curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
  sudo apt-get install -y nodejs build-essential git
fi

git clone https://github.com/cubedro/eth-netstats
cd eth-netstats
npm install

# Check if grunt is installed
grunt -V
if [ $? -ne 0 ] ; then
  npm install -g grunt-cli
fi

# To build the full version
grunt

# Check if pm2 is installed
pm2 -v
if [ $? -ne 0 ] ; then
  npm install -g pm2
fi

## daemonizing the process ##
mkdir -p /opt/eth-netstats

cp ./ecosystem.config.js /opt/eth-netstats/ecosystem.config.js

# Daemonize pm2
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup upstart -u root --hp /root

pm2 save

pm2 start ./ecosystem.config.js

pm2 save