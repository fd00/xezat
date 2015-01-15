#!/bin/bash

show_cygport_variables()
{
	for var in `compgen -A variable`
	do
		[ $var = 'BASH_COMMAND' ] && continue
		[ $var = 'COMP_WORDBREAKS' ] && continue
		[ $var = 'HOMEPATH' ] && continue
		[[ ${!var} =~ ^[A-Za-z]:.* ]] && continue
		
		echo -n "!ruby/sym" $var:
		if [[ `declare -p $var` =~ "declare -a" ]]
		then
			echo
			x=`printf '${!%s[@]}' $var`
			eval "keys=$x"
			for key in $keys
			do
				x=`printf '${%s[%s]}' $var $key`
				eval "value=$x"
				echo "  -" $value
			done
		else
			echo ' "'`echo "${!var}" | sed -e "s/\\n/ /g"`'"'
		fi
	done
}

source ${CYGPORT:-/usr/bin/cygport} $* show_cygport_variables
