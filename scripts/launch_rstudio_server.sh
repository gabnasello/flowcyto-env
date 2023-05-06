GREEN='\033[0;32m'
NC='\033[0m' # No Color

# https://docs.rstudio.com/ide/server-pro/rstudio_server_configuration/rsession_conf.html
echo "session-default-working-dir=$PWD" > /etc/rstudio/rsession.conf
rstudio-server restart


printf "\n${GREEN}[RStudio Server]\n\n"
printf "${NC}      To access the server, open this link in a browser: \n\n"

echo -e " user: rstudio \n password: rstudio \n"
echo -e 'http://'$HOST_NAME':'$RSPORT'\n\n'

