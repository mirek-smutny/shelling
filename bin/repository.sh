#!/bin/bash

###################################################################################################
#
# Name: shell_repo
# Purpose: Repository of SHELL functions
#
# Changelog:
#       YYYY-MM-DD              Name                    Change
###################################################################################################

_SPLIT="###################################################################################################"

DATESTART=$(date '+%Y%m%d_%H%M%S')

# Function: Compare 2 variables
# Expected format: comp2var $VARIABLE1 $VARIABLE2
comp2var()
{

VAR1=$1
VAR2=$2

if [ "${VAR1}" == "${VAR2}" ]; then
        return 0
else
        return 1
fi

}

# Function: Read defined config file and set variable
# Expected format: VARIABLE:VALUE
read_cfg()
{

CFG_FILE=$1
for i in $(cat ${CFG_FILE} | egrep -v "^#|^$"); do
	VAR=$(echo ${i} | cut -f1 -d:)
	VAL=$(echo ${i} | cut -f2 -d:)
	eval $VAR=$VAL
done

}

# Function: Get current date and time for logfile name
file_date()
{

FDATE=$(date '+%Y%m%d')

}

# Function: Return current date and time in specified format
log_date()
{

#LDATE=$(date '+%H:%M:%S %d-%m-%Y')
LDATE=$(date '+%Y%m%d_%T:%N')
echo ${LDATE}

}

# Function: Write into log file
# Dependent on "log_date()"
# Expected variable: $LOG_FILE
log()
{

MESSAGE=$1

echo $(log_date) "${MESSAGE}" >> ${LOG_FILE}

}

mk_dir()
{

LOGDIR=$1

umask 0027

if [ ! -d "${LOGDIR}" ]; then
        mkdir -p ${LOGDIR}
        if [ "$?" -ne 0 ]; then
                echo $(log_date) "ERROR - Not created ${LOGDIR}"
        fi
fi

}

# Function: Zip files in directory
zip_dir()
{

ROOT_DIR=$1
DAYS=$2
LOG_ZIP=$3

if [ ")echo $DAYS | grep -E ^[[:digit:]]+$)" = "" ]; then
        err "$0 - zip_dir() - Time not specified"
        exit 1
fi

find ${ROOT_DIR} -maxdepth 1 -type f ! -iname "*.gz" -mtime +${DAYS} -exec gzip -f {} \; >> ${LOG_ZIP}
#find ${ROOT_DIR} -maxdepth 1 -type f -print ! -iname "*.gz" -mtime ${DAYS} -exec gzip -fv {} \; >> ${LOG_ZIP}

}

# Function: Check exit value
# Expected format: check_exit $? "Message"
check_exit()
{

EXIT=$1
MSG=$2

if [ "${EXIT}" -eq 0 ]; then
        log "OK - ${MSG} succesfull"
        return 0
else
        log "ERROR - ${MSG} failed"
        return 1
fi
}

# Function: Clean directory from old logs
# Dependent on "check_exit(), log()"
# Expected variable: $LOG_FILE
# Expected format: clean_dir Directory Days_to_clean
clean_dir()
{

CLEAN_ROOT=$1
DAYS=$2
MSG="${CLEAN_ROOT} - cleaning"

if [ ! -d ${CLEAN_ROOT} ]; then
        err "$0 - clean_dir() - Directory not found"
        exit 1
fi

if [ "$(echo $DAYS | grep -E ^[[:digit:]]+$)" = "" ]; then
        err "$0 - clean_dir() - Time not specified"
        exit 1
fi

# REPORT COUNT OF FILES
CNT=$(find ${CLEAN_ROOT} -type f -mtime +${DAYS} | wc -l)
log "${CNT} - files to delete"
#

find ${CLEAN_ROOT} -type f -mtime +${DAYS} -exec rm -rf {} \; >> ${LOG_FILE}

check_exit $? "${MSG}"

}

# Function: Check running process
# Expected format: check_pid $$
# Expected variable: $_PID (config file)
check_pid()
{

RPID=$1

if [ -f "$_PID" ]; then
        _FPID=$(cat $_PID)
        if [ ! "${RPID}" -eq "$_FPID" ]; then
                echo "${_SCRIPT}: process is running (PID: ${_FPID})"
                exit 1
        fi
else
        echo $$ > $_PID
        return 0
fi

}