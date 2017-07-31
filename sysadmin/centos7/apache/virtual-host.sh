#!/bin/bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd );
#
#AUTOMATES THE CREATION OF VIRTUAL HOSTS
#@author: Lucas Nishimura
#
source ${DIR}/../libs/defs.sh;
source ${DIR}/../libs/functions.sh
APACHE_CONF_DIR=/etc/httpd/conf.d/
VHOST_TEMPLATE=${DIR}/vhost_template.tpl;

usage(){
	echo " ${SYSADMIN_NAME} ${SYSADMIN_VERSION}";
	echo " Please Provide configuration arguments"
	echo " Usage: virtual-host -d <#DOMAINNAME> -u <#USERNAME>" 
	echo " Options"
	echo " 	-d, --domain #DOMAINNAME";
	echo "	      #DOMAINNAME is the domain without 'www' Ex. domain.com";
	echo " 	-u, --username #USERNAME";
	echo "	      #USERNAME is the username under the suPhp will exec scripts"
	echo ""	 	
}


####################
# ARGUMENT PARSING #
####################
while [[ $# -gt 1 ]]
do
ARG_OPTION="$1"
case $ARG_OPTION in
    -d|--domain)
    DOMAINNAME="$2"
    shift # past argument
    ;;
    -u|--username)
    USERNAME="$2"
    shift # past argument
    ;;
    --default)
    DEFAULT=YES
    ;;
    *)
            # unknown ARG_OPTION
    ;;
esac
shift # past argument or value
done

if [[ -z ${DOMAINNAME}  &&  -z ${USERNAME} ]];then
	usage
	exit 0;
fi

if [ -z ${DOMAINNAME} ]; then
	echo " Please provide #DOMAINNAME with -d option";
	usage
	exit 0
fi

if [ -z ${USERNAME} ]; then
    echo " Please provide #USERNAME with -u option";
    usage
    exit 0
fi

echo " Trying to create domain: [${DOMAINNAME}] for user:  [${USERNAME}]"

O=getUserDir ${USERNAME}
echo $O
