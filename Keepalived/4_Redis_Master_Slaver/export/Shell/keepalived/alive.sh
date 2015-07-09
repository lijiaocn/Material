#!/bin/bash
. /export/Shell/keepalived/config.sh

func_alive
ret=$?
exit $ret
