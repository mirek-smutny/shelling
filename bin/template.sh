#!/bin/bash

###################################################################################################
#
# Name: 
# Purpose:
#
# Changelog:
#       YYYY-MM-DD                      Name                    Change
#
###################################################################################################

usage()
{

cat << EOF
$_SPLIT
        Usage:
        $_SCRIPT --help - Print this help

        Options:
        $_SCRIPT [OPTION]
                --help                                  Print this help
                --silent, -s                    Silent - only log

$_SPLIT
EOF
}

arg_parse()
{

I_SIL=0

for ARG do
        case "${ARG}" in
                --silent|-s)
                        I_SIL=1
                        ;;
                --help|-h)
                        usage
                        exit 0
                        ;;
                *)
                        echo "Unknown argument"
                        exit 1
                        ;;
        esac
done

}
source ~/.profile

# Main variables
_REPO="${ADM_BASE}/bin/repository.sh"
_GVAR="${ADM_BASE}/inv/vars.inv"
_CFG="${ADM_BASE}/cfg/template.cfg"
ARG1=$0

# Get repository functions
source ${_REPO}

if [ "$?" -ne 0 ]; then
        echo "ERROR - repository source not found"
        exit 1
fi

# Read variable and values
read_cfg ${_GVAR}
read_cfg ${_CFG}


ARG1=$(echo $ARG1 | sed 's/.*\///' | sed -e 's/\.sh//')

comp2var "${ARG1}" "${_SCRIPT}"

if [ "$?" -ne 0 ]; then
    exit 5;
fi

arg_parse $*

# Set log directory
LOG_DIR=${LOG_ROOT}/${_SCRIPT}
mk_dir ${LOG_DIR}

#umask 0027

# Define log file
if [ "$?" -eq 0 ]; then
#       file_date
        LOG_FILE=${LOG_DIR}/${_SCRIPT}.log
else
        echo $(log_date) "ERROR - ${LOG_FILE} - not exists"
fi

# Main

check_pid $$

rm ${_PID}