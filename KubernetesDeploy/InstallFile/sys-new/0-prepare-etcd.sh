#!/bin/bash
. ./library.sh
. ./public.sh

func_stop_sd_service etcd
func_start_sd_service etcd
