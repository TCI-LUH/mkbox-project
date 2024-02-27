#!/bin/bash

exec 4>&1 # logging stream

conf="/etc/lab-connector.conf"
[ -f "$conf" ] && source "$conf"

timeout=0
name="${name:-$(hostname)}"


function log() 
{
    echo "$@"
} 1>&4

function err()
{
    echo "error: $@"
} 1>&2

function getLabIP()
{
    [ -n "$FORCE_LAB" ] && echo "$FORCE_LAB" && return
    log "request lab-ip for: '$name' in domain '$DNS_DOMAIN'"
    dig  -t txt $name.$DNS_DOMAIN +short | sed  -rn 's/"lab=([^"]+)"/\1/p'
}

function register()
{
    [ -z "$1" ] && return
    
    local lab_ip="$1"
    local endpoint="/api/devices/register"
    local curalias="$(cat /etc/lab-alias 2>/dev/null || echo "$name")"
    local infos="{'name':'$name', 'alias':'$curalias', 'arch':'$(uname -m)', 'kernel-name':'$(uname -s)', 'kernel-release':'$(uname -r)', 'date':'$(date -u +%s)'}"
    echo "send infos: $infos to lab-ip: $lab_ip"
    newalias="$(wget -q -O- --post-data "$infos" "${lab_ip}${endpoint}")" || return 
    [ "$curalias" != "$newalias" ] && echo "$newalias" > /etc/lab-alias
}

function unregister()
{
    [ -z "$1" ] && return

    local lab_ip="$1"
    local endpoint="/api/devices/unregister"
    local infos="{'name':'$name'}"
    log "unregister $name at $lab_ip"
    wget -q -O- --post-data "$infos" "${lab_ip}${endpoint}"
}

last_lab=""

while [ 1 ]; do

    cur_lab="$(getLabIP)";
    echo "cur_lab: '$cur_lab'";

    [ "$cur_lab" != "$last_lab" ] && unregister "$last_lab"
    register "$cur_lab"

    last_lab="$cur_lab"
    sleep 1
done