#!/usr/bin/env bash

## show user group membership in AzureAD
az-get-member-groups(){
    local _USER="${1:-$USER}"
    az ad user get-member-groups --id $_USER | jq -r '.[]| "\(.objectId)\t\(.displayName)"'
}


az-list-users(){
    az ad user list | jq -r '.[]| "\(.objectId)\t\(.mail)"'
}


az-show-user-info(){
    local _USER_ID="${1}"
    az ad user show --id $_USER_ID | jq -r '"ID:\(.objectId) | Name:\(.displayName) | Mail:\(.mail) | Department:\(.department) | Country:\(.country) | Created:\(.createdDateTime)"'
}

az-show-user-info-extended(){
    local _USER_ID="${1}"
    az ad user show --id $_USER_ID | jq '.'
}


az-is-user-group-member-of(){
    local _GROUP_NAME="${1}"
    local _MEMBER_ID="${1}"
    az ad group member check --group $_GROUP_NAME --member-id $_MEMBER_ID
}


az-list-group-members(){
    local _GROUP_NAME="${1}"
    az ad group member list --group $_GROUP_NAME | jq -r '.[]| "\(.mail) \(.objectId)"'
}
