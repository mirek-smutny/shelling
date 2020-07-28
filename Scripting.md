Scripting Guide

Global variables:

_SPLIT
_PID
_UID
_GID
LOG_ROOT
DATESTART
FDATE

ADM_BASE
ADM_LOG
ADM_BIN
ADM_CFG
ADM_CFG_LR
ADM_INV
ADM_SQL
ADM_SQL_PG
ADM_SQL_ORA
ADM_SQL_DB2
ADM_TMP
ADM_INV_FILE
ADM_INV_VARS
ADM_INV_ALIAS
ADM_INV_OWNER

Functions

# Expected format: comp2var $VARIABLE1 $VARIABLE2
comp2var()

# Expected format: VARIABLE:VALUE
read_cfg()
file_date()
log_date()

# Expected variable: $LOG_FILE
log()

mk_dir()
zip_dir()

# Expected format: check_exit $? "Message"
check_exit()

# Function: Clean directory from old logs
# Dependent on "check_exit(), log()"
# Expected variable: $LOG_FILE
# Expected format: clean_dir Directory Days_to_clean
clean_dir()

# Function: Check running process
# Expected format: check_pid $$
# Expected variable: $_PID (config file)
check_pid()
