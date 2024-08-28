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

```markdown
./0dSSRF.sh -hep -l urls_list.txt -c collaborator_id -s requests_per_second

