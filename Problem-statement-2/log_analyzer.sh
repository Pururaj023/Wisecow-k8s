#!/bin/bash

LOG_FILE="/var/log/nginx/access.log"

echo "===== Log Analysis Report ====="
echo "Log file: $LOG_FILE"
echo

# Number of 404 errors
echo "1. Total 404 Errors:"
grep " 404 " "$LOG_FILE" | wc -l
echo

# Top 10 most requested pages
echo "2. Top 10 Requested Pages:"
awk '{print $7}' "$LOG_FILE" | sort | uniq -c | sort -rn | head -10
echo

# Top 10 IPs by request count
echo "3. Top 10 IPs:"
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -rn | head -10
echo

# Requests per status code
echo "4. Requests by Status Code:"
awk '{print $9}' "$LOG_FILE" | sort | uniq -c | sort -rn
