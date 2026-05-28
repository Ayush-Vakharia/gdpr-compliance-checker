#!/bin/bash

read -p "Enter the target website URL (e.g., https://example.com): " TARGET
REPORT="gdpr_compliance_full_report.txt"

if [ -z "$TARGET" ]; then
  echo "No target provided. Exiting."
  exit 1
fi

echo "Running advanced GDPR Compliance Check for $TARGET..."
echo "Generating report: $REPORT"

SCORE=0
MAX_SCORE=10

# Get HTML
HTML=$(curl -sL "$TARGET")
DOMAIN=$(echo "$TARGET" | sed -e 's|https://||' -e 's|http://||' -e 's|/.*||')

# Check 1: HTTPS
if [[ "$TARGET" == https* ]]; then
  HTTPS_CHECK="PASS: Site uses HTTPS."
  ((SCORE++))
else
  HTTPS_CHECK="FAIL: Site does not use HTTPS."
fi

# Check 2: SSL certificate
SSL_INFO=$(echo | openssl s_client -connect "$DOMAIN:443" 2>/dev/null | openssl x509 -noout -dates)
if echo "$SSL_INFO" | grep -q "notAfter"; then
  SSL_CHECK="PASS: SSL certificate is valid."
  ((SCORE++))
else
  SSL_CHECK="FAIL: SSL certificate is missing or invalid."
fi

# Check 3: Privacy Policy
if echo "$HTML" | grep -qi "privacy policy"; then
  PRIVACY_CHECK="PASS: Privacy policy found."
  ((SCORE++))
else
  PRIVACY_CHECK="FAIL: Privacy policy not found."
fi

# Check 4: Cookie Consent
if echo "$HTML" | grep -qiE "cookie(consent|banner)|Accept Cookies"; then
  COOKIE_CHECK="PASS: Cookie consent mechanism detected."
  ((SCORE++))
else
  COOKIE_CHECK="FAIL: Cookie consent mechanism not found."
fi

# Check 5: Contact/DPO
if echo "$HTML" | grep -qiE "contact.*(data protection|privacy)|DPO|data.protection"; then
  CONTACT_CHECK="PASS: Contact or DPO info found."
  ((SCORE++))
else
  CONTACT_CHECK="FAIL: No DPO/contact info found."
fi

# Check 6: Terms of Service
if echo "$HTML" | grep -qi "terms of service\|terms and conditions"; then
  TOS_CHECK="PASS: Terms of Service found."
  ((SCORE++))
else
  TOS_CHECK="FAIL: Terms of Service not found."
fi

# Check 7: Cookie Declaration
if echo "$HTML" | grep -qiE "cookie declaration|cookie list|cookie policy"; then
  DECLARATION_CHECK="PASS: Cookie usage details provided."
  ((SCORE++))
else
  DECLARATION_CHECK="FAIL: No clear cookie usage/declaration found."
fi

# Check 8: Third-party trackers (e.g., GA or FB Pixel)
if echo "$HTML" | grep -qiE "googletagmanager|google-analytics|facebook.net|fbq\("; then
  TRACKERS_CHECK="WARN: Third-party trackers detected. Ensure consent is handled."
else
  TRACKERS_CHECK="PASS: No major third-party trackers found."
  ((SCORE++))
fi

# Check 9: Multilingual support (EU accessibility)
if echo "$HTML" | grep -qiE "lang=\"(en|fr|de|es|it|pt|nl|sv|pl)"; then
  LANGUAGE_CHECK="PASS: EU language(s) supported."
  ((SCORE++))
else
  LANGUAGE_CHECK="FAIL: No EU language localization detected."
fi

# Check 10: Withdrawal of consent
if echo "$HTML" | grep -qiE "withdraw consent|unsubscribe|opt-out"; then
  WITHDRAW_CHECK="PASS: Consent withdrawal/unsubscribe option found."
  ((SCORE++))
else
  WITHDRAW_CHECK="FAIL: No opt-out or consent withdrawal info."
fi

# Verdict
if [ "$SCORE" -ge 9 ]; then
  VERDICT="STRONG COMPLIANCE: Meets most GDPR obligations."
elif [ "$SCORE" -ge 6 ]; then
  VERDICT="PARTIAL COMPLIANCE: Missing some GDPR elements."
else
  VERDICT="LIKELY NON-COMPLIANT: Major gaps in GDPR indicators."
fi

# Generate Report
cat <<EOF > "$REPORT"
GDPR Compliance Report (Extended)
==================================
Target: $TARGET

Checks:
-------
1. HTTPS:
   $HTTPS_CHECK

2. SSL Certificate:
   $SSL_CHECK

3. Privacy Policy:
   $PRIVACY_CHECK

4. Cookie Consent:
   $COOKIE_CHECK

5. Contact / DPO:
   $CONTACT_CHECK

6. Terms of Service:
   $TOS_CHECK

7. Cookie Declaration:
   $DECLARATION_CHECK

8. Third-party Trackers:
   $TRACKERS_CHECK

9. EU Language Support:
   $LANGUAGE_CHECK

10. Withdrawal of Consent / Opt-Out:
   $WITHDRAW_CHECK

Summary:
--------
Score: $SCORE / $MAX_SCORE
Verdict: $VERDICT

Note:
-----
This tool performs heuristic checks using web page content. Actual GDPR compliance also depends on internal practices like data processing agreements, lawful bases, breach handling, and data minimization.

EOF

echo "Done. Detailed report saved to: $REPORT"

