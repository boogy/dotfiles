#!/usr/bin/env ush


function _list_aws_vault_entries
{
    grep -Eo "profile ([0-9A-Za-z_-]+)" ~/.aws/config|awk '{print $2}'
}


compdef '_arguments "1: :($(_list_aws_vault_entries))"' aws-vault
