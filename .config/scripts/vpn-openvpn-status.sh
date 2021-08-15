#!/usr/bin/env bash

IFACE_NAME="tun0"

if (ip addr show "${IFACE_NAME}"|egrep -qi "state.*(UP|UNKNOWN)") &>/dev/null; then

    IFACE=$(ip a s |grep -o "$IFACE_NAME"|head -1)
    IPADDR_IFACE=$(ip -j a s $IFACE_NAME| jq '.[].addr_info[]|.local'|head -1|tr -d '"')

    if (ip addr show "${IFACE_NAME}"|egrep -qi "state.*(UP|UNKNOWN)") &>/dev/null; then
        echo "%{A1:nm-connection-editor &:}%{u#55aa55} $(ip a s|grep -o "${IPADDR_IFACE}"|head -1)%{u-}%{A}"
    else
        echo "%{A1:nm-connection-editor &:}%{F#FF0000} VPN DISCONNECTED%{u#FF0000}%{u-}%{F-}%{A}"
    fi

fi
