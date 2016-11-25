#! /bin/bash

# FUNCTION
# DIG -> Return adr/ip/cidr/error
function get_spf(){
    dig +short txt "$1" |
    tr ' ' '\n' |
    tr -d '\"' |
    while read entry; do 
        # printf '%s\n' "$entry"
        case "$entry" in 
            ip4:*)  echo ${entry#*:} ;; 
            ip6:*) echo ${entry#*:} ;; 
            redirect\=*) get_spf ${entry#*=} ;;
            include:*) get_spf ${entry#*:} ;;
        esac
    done |
    sort -u |
    cat
}

# Call function until we have a list of IP's for all domains provided
function main(){
    echo "cidr_range"
    while read line; do
        # printf '%s\n' "$line"
        get_spf "$line"
    done < "./domains.txt"
}

#Run
main "$@";

exit 0