#!/bin/bash

var2yaml()
{
	for var in `compgen -A variable`
	do
		[ $var = 'BASH_COMMAND' ] && continue
		[ $var = 'COMP_WORDBREAKS' ] && continue
		[ $var = 'HOMEPATH' ] && continue
		[ $var = 'PERL_MB_OPT' ] && continue
		[ $var = 'PSModulePath' ] && continue
		[ $var = '_cygport_orig_env' ] && continue
		[[ ${!var} =~ ^[A-Za-z]:.* ]] && continue
		
		echo -n :$var:
		if [[ `declare -p $var` =~ "declare -a" ]]
		then
			echo
			x=`printf '${!%s[@]}' $var`
			eval "keys=$x"
			for key in $keys
			do
				x=`printf '${%s[%s]}' $var $key`
				eval "value=$x"
				echo "  -" '"'$value'"'
			done
		else
			echo ' "'`echo "${!var}" | sed -e "s/\\n/ /g"`'"'
		fi
	done
}

source ${CYGPORT:-/usr/bin/cygport} $* var2yaml
