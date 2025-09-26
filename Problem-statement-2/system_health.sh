#!/bin/bash

# Thresholds
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80
LOG_FILE="/var/log/system_health.log"

# Function to log alerts
log_alert() {
    local message=$1
    echo "$(date): $message" | tee -a "$LOG_FILE"
}

# CPU usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
CPU_USAGE=${CPU_USAGE%.*} # integer only

if [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ]; then
    log_alert "High CPU Usage: ${CPU_USAGE}%"
fi

# Memory usage
MEM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
MEM_USAGE=${MEM_USAGE%.*}

if [ "$MEM_USAGE" -gt "$MEM_THRESHOLD" ]; then
    log_alert "High Memory Usage: ${MEM_USAGE}%"
fi

# Disk usage
DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')

if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    log_alert "High Disk Usage: ${DISK_USAGE}%"
fi

# Top 5 processes by CPU
log_alert "Top 5 processes by CPU:"
ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -6 >> "$LOG_FILE"
