#!/bin/bash
. /export/Shell/keepalived/config.sh

ret=`func_alive`
exit $ret
