## 0dSSRF: SSRF & Open Redirect Scanner

This script automates the process of finding Server-Side Request Forgery (SSRF) and Open Redirect vulnerabilities in web applications.

**Features:**

* Injects the Burp Collaborator server into various locations to identify potential vulnerabilities.
* Supports targeting specific attack vectors:
    * Host Header Injection
    * Common Header Injection
    * URL Parameter Injection (with automatic URL extraction)
* Customizable delay between requests to control scan speed.

**Requirements:**

* Linux or macOS (may require adjustments for other platforms)
* `curl`
* `gau` (optional, for URL extraction)
* `waybackurls` (optional, for URL extraction)
* `waymore` (optional, for URL extraction)
* `uro` (optional, parameter extraction)

**Installation:**

1. Download the script (0dSSRF.sh)
2. Make the script executable: `chmod +x 0dSSRF.sh`

**Usage:**

```bash
./0dSSRF.sh -hep -l urls_list.txt -c collaborator_id -s requests_per_second
```
OPtions:

* -h: Inject into Host Header
* -e: Inject into common headers (From, User-Agent, Referer, etc.)
* -p: Inject into URL parameters (requires URL list)
* -l: Path to a file containing a list of target URLs
* -c: Burp Collaborator server ID (replace with your collaborator ID)
* -s: Delay between requests in seconds (e.g., -s 0.1 for 10 requests per second)

Example:
```bash
./0dSSRF.sh -hep -l targets.txt -c my-burp-collab-id -s 5
```

**How it work?**
Now you mission is to watch out your Collaborator. if you found any activity notice the time and look back in your terminal and catch the vulnerable event

 ![WhatsApp Image 2024-08-28 at 22 41 42_36613ade](https://github.com/user-attachments/assets/5f7de255-930c-4c3d-b435-2135bc3b665e)

![WhatsApp Image 2024-08-28 at 22 41 42_7f22aa27](https://github.com/user-attachments/assets/0eb10439-7124-464e-9eb3-9e377adfada7)




This command will scan targets listed in "targets.txt" for URL parameter vulnerabilities, using your Burp Collaborator server with a delay of 0.2 seconds between requests.

Disclaimer:

This script is for educational purposes only. Use it responsibly and at your own risk. Testing for vulnerabilities on systems you do not own or have permission to test is illegal.

Additional Notes:

    The script utilizes various tools for URL extraction (gau, waybackurls, waymore). You may need to install these tools separately.
    The script automatically removes common file extensions during parameter extraction to focus on potential vulnerabilities.
    Remember to replace "my-burp-collab-id" with your actual Burp Collaborator server ID.
