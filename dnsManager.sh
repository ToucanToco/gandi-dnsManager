#!/bin/bash


###############################################################################
#
# Init and basic checks part
#
###############################################################################

DNSMANAGER_DIR="`dirname $0`"

cd ${DNSMANAGER_DIR}
[[ $? -ne 0 ]] && echo "Unable to change directory to: ${DNSMANAGER_DIR}" && exit 1

# Load all the env
[[ ! -e "${DNSMANAGER_DIR}/etc/vars" ]] && echo "failed to load vars file" && exit 1
source ${DNSMANAGER_DIR}/etc/vars

[[ ! -e "${DNSMANAGER_DIR}/libs/functions" ]] && echo "Unable to load functions file" && exit 1
source ${DNSMANAGER_DIR}/libs/functions


###############################################################################
#
# Main
#
###############################################################################

DNSMANAGER_ACTION="$1"
DNSMANAGER_DOMAIN="$2"

if [[ ${DNSMANAGER_ACTION} == 'setupAccount' ]]
then
	_printStep "Setup your env"
	_gandi_setupAccount
	_printStep "Setup done"
	exit 0
fi

_check_virtualEnv

source ${DNSMANAGER_VIRTUALENV_ACTIVATE}
[[ $? -ne 0 ]] && _fatal "Problem to load the virtual env"


case ${DNSMANAGER_ACTION} in
	listDomains)
		_printStep "List all registered domains:"
		_gandi_listDomains
		_printStep "List done"
		;;

	updateDomainZone)
		if [[ -z ${DNSMANAGER_DOMAIN} ]]
		then
			_printRed "You forget to specify a domain name"
			_printRed "\tUsage: $0 updateDomainZone domain_name"
			_help
		fi

		_printStep "Update DNS zone ${DNSMANAGER_DOMAIN}"
		_gandi_updateDomainZone  "${DNSMANAGER_DOMAIN}"
		_printStep "Update done, check new file: ${DOMAIN_ZONE_DIR}/${DNSMANAGER_DOMAIN}.txt"

		_gandi_getLastDomainZone "${DNSMANAGER_DOMAIN}"

		_printStep "Please don't forget to commit your changes"
		echo -e "\tsuggestion:"
		echo -e "\t\t\tgit add ${DOMAIN_ZONE_DIR}/${DNSMANAGER_DOMAIN}.txt"
		echo -e "\t\t\tgit commit -m '${DNSMANAGER_DOMAIN} :: update/delete/add entries'"
		;;

	getLastDomainZone)
		if [[ -z ${DNSMANAGER_DOMAIN} ]]
		then
			_printRed "You forget to specify a domain name"
			_printRed "\tUsage: $0 getLastDomainZone domain_name"
			_help
		fi

		_printStep "Dump zone for ${DNSMANAGER_DOMAIN}"
		_gandi_getLastDomainZone "${DNSMANAGER_DOMAIN}"
		if [[ $? -eq 0 ]]
		then
			_printStep "Dump done, check new file: ${DOMAIN_ZONE_DIR}/${DNSMANAGER_DOMAIN}.txt"
			git diff ${DOMAIN_ZONE_DIR}/${DNSMANAGER_DOMAIN}.txt
		else
			_printStep "Dump done, but you already got the latest version"
			exit 1
		fi
		;;

	*)
		_help
		;;
esac

exit 0
