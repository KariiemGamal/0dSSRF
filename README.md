## 0dSSRF: Your Collaborative SSRF & Open Redirect Scanner

This script automates the process of finding Server-Side Request Forgery (SSRF) and Open Redirect vulnerabilities in web applications.

**For a more in-depth understanding, I recommend reading this comprehensive article on Medium:**

https://medium.com/p/944be6770a02/edit

**Features:**

* Injects the Burp Collaborator server into various locations to identify potential vulnerabilities.
* Supports targeting specific attack vectors:
    * Host Header Injection
    * Common Header Injection
    * URL Parameter Injection (with automatic URL extraction)
    * Absolute URL
* Customizable delay between requests to control scan speed.

**Requirements:**

* Linux or macOS (may require adjustments for other platforms)
* `curl`
* `nc` (optional, for absolute URL detection)
* `gau` (optional, for URL extraction)
* `waymore` (optional, for URL extraction)
* `uro` (optional, parameter extraction)


**Installation:**

1. Download the script (0dSSRF.sh)
2. Make the script executable: `chmod +x 0dSSRF.sh`

**Usage:**

```bash
./0dSSRF.sh -hepa -l urls_list.txt -c collaborator_id -s requests_per_second
```
OPtions:

* -h: Inject into Host Header
* -e: Inject into common headers (From, User-Agent, Referer, etc.)
* -a: Inject into Absolute URL
* -p: Inject into URL parameters (requires URL list)
* -l: Path to a file containing a list of target URLs
* -c: Burp Collaborator server ID (replace with your collaborator ID)
* -s: Delay between requests in seconds (e.g., -s 0.1 for 10 requests per second)

Example:
```bash
./0dSSRF.sh -hepa -l targets.txt -c my-burp-collab-id.oastify.com -s 20
```
This command will scan targets listed in "targets.txt" for URL parameter vulnerabilities, using your Burp Collaborator server with a delay of 0.2 seconds between requests.

**How it work?**

Monitor your Collaborator's activity for potential vulnerabilities. if you found any activity, notice the subdomain in dns lookup or HTTP request 
This section will refer to the vulnerable server: 

*subdomain-vulnerable-com >> subdomain.vulnerable.com*

![WhatsApp Image 2024-09-08 at 14 33 05_e0605079](https://github.com/user-attachments/assets/c633e93c-a6e2-4fe5-bcae-e47c7fb94e78)


while this secion will refer to the injected place: 

![WhatsApp Image 2024-09-08 at 14 33 05_26c2ddbf](https://github.com/user-attachments/assets/ad2536a4-50d0-49de-b925-c85fcdda75aa)


h for Host Header, a for Absolute URL,p for parameter, in common headers you will find the vulnerable header:

![WhatsApp Image 2024-09-08 at 14 33 05_9be21f54](https://github.com/user-attachments/assets/8086c9a0-bc3d-4aee-8b74-51ddc6dfce91)



for the third stage, requests carry information about the vulnerable server & parameter & time:

![image](https://github.com/user-attachments/assets/a753d93a-0194-4229-9a0d-0a3332eb8ae5)

This stage also includes testing for open redirects. It's crucial to verify that the detected requests don't originate from your own IP address. In such cases, a manual check is recommended for confirmation.

**Note:**

For uncompleted or malformed domain name in DNS lookup in your collaborator, it's recommended to look at log files and capture the vulnerable server by coupling time between the activity in collaborator and in log file using command:

"$cat  inject_host_header.log | grep 03:27 " for example

![362429258-5f7de255-930c-4c3d-b435-2135bc3b665e](https://github.com/user-attachments/assets/1a24cd18-ac57-44c6-99dd-f30d3de1294f)
![362429216-0eb10439-7124-464e-9eb3-9e377adfada7](https://github.com/user-attachments/assets/e3ce4230-924d-4dfb-9f34-f54da095ca01)


**Future ideas:**
- Webhook Integration: Working on automating the collection of vulnerable servers from Collaborator using webhook.site.
- Discord Notification: After running the script, receive a Discord message with identified vulnerable domains directly.


Disclaimer:

This script is for Ethical purposes only. Use it responsibly and at your own risk. Testing for vulnerabilities on systems you do not own or have permission to test is illegal.

Additional Notes:
   
    The script utilizes various tools for URL extraction (gau, waymore). You may need to install these tools separately.
    and make sure to add your API keys to config files of these tools to get all possible URLs
    The script automatically removes common file extensions during parameter extraction to focus on potential vulnerabilities.
    Remember to replace "my-burp-collab-id" with your actual Burp Collaborator server ID.
