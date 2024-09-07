## 0dSSRF: SSRF & Open Redirect Scanner

This script automates the process of finding Server-Side Request Forgery (SSRF) and Open Redirect vulnerabilities in web applications.

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
This subdomain will refer to the vulnerable server:

![WhatsApp Image 2024-09-07 at 23 54 01_1f11028f](https://github.com/user-attachments/assets/5867d272-78d2-4426-aa7b-8ebbc558f2df)

while this subdomain will refer to the injected place: 

![WhatsApp Image 2024-09-07 at 23 54 01_67e694d4](https://github.com/user-attachments/assets/3199be7b-8b23-4af9-ae09-a7376d4655e9)

h for Host Header, a for Absolute URL, in common headers you will find the vulnerable header

for the third stage, requests carry information about the vulnerable server & parameter & time:

![image](https://github.com/user-attachments/assets/a753d93a-0194-4229-9a0d-0a3332eb8ae5)

This stage also includes testing for open redirects. It's crucial to verify that the detected requests don't originate from your own IP address. In such cases, a manual check is recommended for confirmation.


Disclaimer:

This script is for Ethical purposes only. Use it responsibly and at your own risk. Testing for vulnerabilities on systems you do not own or have permission to test is illegal.

Additional Notes:
   
    The script utilizes various tools for URL extraction (gau, waymore). You may need to install these tools separately.
    and make sure to add your API keys to config files of these tools to get all possible URLs
    The script automatically removes common file extensions during parameter extraction to focus on potential vulnerabilities.
    Remember to replace "my-burp-collab-id" with your actual Burp Collaborator server ID.
