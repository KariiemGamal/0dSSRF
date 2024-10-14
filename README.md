# 0dSSRF: Your Collaborative SSRF & Open Redirect Scanner

0dSSRF is a powerful tool designed to automate the detection of **Server-Side Request Forgery (SSRF)** and **Open Redirect** vulnerabilities in web applications. Created by **Kariem Gamal (0d.MErCiFul)** from the **0dYSs3y.?** team, it simplifies key attack techniques, saving time and effort for security professionals.

### 🚀 [Read a detailed explanation on Medium](https://medium.com/@kariiem/0dssrf-automate-finding-ssrf-external-service-interactions-open-redirects-944be6770a02)


## Key Features:

- **Multiple Injection Methods**: Automatically inject Burp Collaborator payloads into:
  - Host Headers
  - Common Headers (`User-Agent`, `Referer`, `X-Forwarded-For`, etc.)
  - Absolute URLs
  - URL Parameters (with automatic URL extraction)
- **Flexible Scan Controls**: Adjust the delay between requests for rate-limited environments.
- **Resumable Scanning**: Continue from the last session if the scan is interrupted.
- **Structured Output & Logs**: Save all results in a clean, organized directory structure for easy reference.

---

## Requirements

- **Operating Systems**: Linux or macOS (other platforms may require adjustment).
- **Dependencies**:
  - `curl`
  - `nc` (for absolute URL scans)
  - Optional tools for URL extraction & parameters scanning: 
    - `gau`
    - `waymore`
    - `uro`
  - Optional tools for crawling:
    - `httpx`
    - `katana`
---




## Installation

1. Download the script:
   ```bash
   git clone https://github.com/your-username/0dSSRF.git
   cd 0dSSRF
   chmod +x 0dSSRF.sh
   ```
2. Ensure all dependencies are installed. If you're using gau, waymore, or uro, make sure they're configured with your API keys for optimal URL extraction.

   
---


## Usage:

Run the tool with the following syntax:
```bash
./0dSSRF.sh -h|-e|-p|-a|-k -l <urls_list.txt> -c <collaborator_id> -s <requests_per_second> [-r <log_directory>]
```

## OPtions:

* -h: Perform Host header injection.
* -e: Perform common header injection. (From, User-Agent, Referer, etc.)
* -a: Perform absolute URL injection.
* -p: Perform parameter injection.
* -k: Get more URLs by crawling with katana
* -l: Specify the list of URLs to test.
* -c: Specify your Burp Collaborator ID for callbacks.
* -s: Set the rate of requests. (e.g., -s 10 for 10 requests per second)
* -r: Optional, continue from a previous log. (e.g., ./0dSSRF.sh -hepa -l urls_list.txt -c collaborator_id -s requests_per_second -r log_14-09-24_00:18:38)

Example:
```bash
./0dSSRF.sh -hepak -l targets.txt -c my-collab-id.oastify.com -s 20
```
This command will scan for vulnerabilities across Host header, common headers, parameters, and absolute URL on the URLs listed in targets.txt using your Burp Collaborator server, with 20 requests per second.

---

## How it work?

**Monitoring Collaborator:** Once you start the scan, check Burp Collaborator for DNS lookups or HTTP requests from the tested domains.
 
**Interpreting Results:** Vulnerable subdomains or vectors will appear in the collaborator's log. For example:

**Identifying Vulnerable Subdomains:** 

*subdomain-vulnerable-com >> subdomain.vulnerable.com*

![WhatsApp Image 2024-09-08 at 14 33 05_e0605079](https://github.com/user-attachments/assets/c633e93c-a6e2-4fe5-bcae-e47c7fb94e78)


**Vector Vulnerability Identification:** 

![WhatsApp Image 2024-09-08 at 14 33 05_26c2ddbf](https://github.com/user-attachments/assets/ad2536a4-50d0-49de-b925-c85fcdda75aa)


      h for Host Header, a for Absolute URL,p for parameter, in common headers you will find the vulnerable header:

![WhatsApp Image 2024-09-08 at 14 33 05_9be21f54](https://github.com/user-attachments/assets/8086c9a0-bc3d-4aee-8b74-51ddc6dfce91)



      for the fourth stage, requests carry information about the vulnerable server & parameter & time:

![image](https://github.com/user-attachments/assets/a753d93a-0194-4229-9a0d-0a3332eb8ae5)

This stage also includes testing for open redirects. It's crucial to verify that the detected requests don't originate from your own IP address. In such cases, a manual check is recommended for confirmation.

**Note:**

For uncompleted or malformed domain name in DNS lookup in your collaborator, it's recommended to look at log files and capture the vulnerable server by coupling time between the activity in collaborator and in log file using command:

"$cat  ./log_dir/inject_host_header.log | grep 03:27 " for example

![362429258-5f7de255-930c-4c3d-b435-2135bc3b665e](https://github.com/user-attachments/assets/1a24cd18-ac57-44c6-99dd-f30d3de1294f)
![362429216-0eb10439-7124-464e-9eb3-9e377adfada7](https://github.com/user-attachments/assets/e3ce4230-924d-4dfb-9f34-f54da095ca01)

---

## Output Files:

All logs and results are stored in a unique directory named log_<timestamp>. Here’s what the output contains:

- Request Logs:
  
    - inject_host_header.log
    - inject_common_headers.log
    - inject_absolute_url.log
    - inject_url_parameters.log

- main_Domains.txt: List of main domains extracted.
- Parameter Scanning: A directory is created for each main domain, organizing URLs and parameters separately:

    - all_urls.log: Filtered URLs.
    - all_params: URLs with parameters.
    - filtered_params.txt: Filtered parameters excluding static file types (e.g., jpg, js, css).
    - httpx.output: Contains all live subdomains of the target.
    - katana.output: Contains the output of katana.

---

## Future ideas:

- Webhook Integration: Automatically collect vulnerable server results using webhook.site.
- Discord Notifications: Receive real-time Discord alerts when vulnerable domains are detected.
- Multithreading: Improve performance and reduce system load by implementing multithreading.

---


Disclaimer:

0dSSRF is designed for ethical hacking and security testing only. Unauthorized use on systems without permission is illegal and punishable by law. Always ensure you have explicit permission from the system owner before conducting any tests.

---
Additional Notes:
   
    The script utilizes various tools for URL extraction (gau, waymore). You may need to install these tools separately.
    Make sure to add your API keys to config files of these tools to get all possible URLs
    The script automatically removes common file extensions during parameter extraction to focus on potential vulnerabilities.
    Remember to replace "my-burp-collab-id" with your actual Burp Collaborator server ID.

--------

<div align="center">

0dSSRF is made with ❤️ by the **0dYSs3y.?** team, Join our Discord Server.

<a href="https://discord.gg/nHmzPVE78X"><img src="https://github.com/user-attachments/assets/b6bc53ad-1c2e-4134-af49-29f12da47fef" width="300" alt="Join Discord"></a>

</div>


