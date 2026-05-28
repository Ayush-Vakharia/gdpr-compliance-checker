# GDPR Compliance Checker

A Bash-based automated compliance auditing tool that scans target websites against 15 key GDPR requirements and produces a structured pass/fail report.

# What It Does

Manual GDPR compliance checks are slow, inconsistent, and easy to get wrong. This tool automates the process — give it a URL and it runs through 15 checks in seconds, producing a clear report showing exactly where the site is compliant and where it falls short.

# Checks Performed

| # | Check | What It Verifies |

| 1 | HTTPS | Site uses HTTPS |

| 2 | SSL Certificate | SSL certificate is valid |

| 3 | Privacy Policy | Privacy policy is accessible |

| 4 | Cookie Consent | Cookie consent mechanism exists |

| 5 | Contact / DPO | Data Protection Officer or contact info is present |

| 6 | Terms of Service | Terms of service page exists |

| 7 | Cookie Declaration | Cookie usage details are provided |

| 8 | Third-party Trackers | No major third-party trackers detected |

| 9 | EU Language Support | EU language(s) supported |

| 10 | Withdrawal of Consent | Opt-out or consent withdrawal option exists |

| 11-15 | Additional checks | Further GDPR requirements |

Each check returns a **PASS** or **FAIL** with a description of what was found or missing.

## Sample Output

```
1. HTTPS:
   PASS: Site uses HTTPS.

2. SSL Certificate:
   PASS: SSL certificate is valid.

3. Privacy Policy:
   FAIL: Privacy policy not found.

4. Cookie Consent:
   FAIL: Cookie consent mechanism not found.

5. Contact / DPO:
   PASS: Contact or DPO info found.
```

## Installation

```bash
# Clone the repository
git clone https://github.com/YOUR-USERNAME/gdpr-compliance-checker.git
cd gdpr-compliance-checker

# Make the script executable
chmod +x gdpr_checker.sh
```

## Usage

```bash
./gdpr_checker.sh <target-url>
```

Example:
```bash
./gdpr_checker.sh https://example.com
```

The tool will run all 15 checks and display results in the terminal. A report file is also generated after the scan.

## Requirements

- Linux / macOS (or WSL on Windows)
- Bash 4.0+
- `curl` (pre-installed on most systems)
- `openssl` (for SSL certificate checks)

## Use Cases

- **Pre-audit assessments** — Quick check before a formal compliance review
- **Security teams** — Identify GDPR gaps during security assessments
- **Compliance officers** — Rapid screening of web properties

## Disclaimer

This tool is designed for authorised compliance assessments only. It performs passive checks against publicly accessible web pages. It is not a substitute for professional legal or compliance advice. Always ensure you have authorisation before scanning any target.

## Author

**Ayush Vakharia**
- LinkedIn: [ayush-vakharia](https://www.linkedin.com/in/ayush-vakharia)

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
