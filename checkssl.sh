#!/bin/bash

GRACE_DAYS=4752000 # 55 days in seconds
RED='\e[31m'
GREEN='\e[92m'
YELLOW='\e[33m'
NC='\e[39m' 


for cert in `ls | grep ".pem"`; do

    # get seconds regards to ssl end date
    date_end=$(/usr/bin/openssl x509 -noout -enddate -in ${cert} | sed "s/.*=\(.*\)/\1/")
    sec_end=$(date -d "${date_end}" +%s)
    
    # get current seconds 
    sec_now=$(date +%s)

    # substract between seconds to get difference
    sec_diff=$(expr $sec_end - $sec_now)
   
    # see if ${sec_diff} > 0, then it is not expired yet;
    # if ${sec_diff} < 0, then it is already expired
    if [[ ${sec_diff} -lt 0 ]]; then
    
        # cert was expired
        echo -e "${RED}Cert ${cert} was already expired!${NC}"
    
    # if it is within 55 days, which is 4752000 seconds
    elif [[ ${sec_diff} -lt ${GRACE_DAYS} ]]; then
        
        # cert needs to be updated
        echo -e "${YELLOW}Cert ${cert} needs to be renewed! It will be expired in $(expr $sec_diff / 86400) days! Please take action soon.${NC}"   
     
    else 
      
       # cert is good
       echo -e "${GREEN} Cert ${cert} is good! It will be expired in $(expr $sec_diff / 86400) days${NC}"

    fi


sleep 1

done
