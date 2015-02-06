#!/bin/bash

show_cygport_description()
{
	declare | grep '^DESCRIPTION=' | sed -e 's/^DESCRIPTION=\$\?//g' -e 's/\\n/\n/g' -e "s/^'//g" -e "s/'$//" -e "s/\\\//g"
}

source ${CYGPORT:-/usr/bin/cygport} $* show_cygport_description
