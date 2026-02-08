#!/bin/bash
# zbx_veeam_get_metrics.sh - by databloat

# ID of latest session
SESSION_ID=$(veeamconfig session list | tail -n 2 | head -n 1 | awk '{print $3}')

# DATA
SESSION_INFO=$(veeamconfig session info --id "$SESSION_ID")


# JSON for zbx
JSON=$(cat <<EOF
{
  "ID": "$SESSION_ID",
  "JobName": "$(echo "$SESSION_INFO" | grep 'Job name:' | awk -F': ' '{print $2}')",
  "Status": "$(echo "$SESSION_INFO" | grep 'State:' | awk -F': ' '{print $2}')",
  "Start": "$(echo "$SESSION_INFO" | grep 'Start time:' | awk -F': ' '{print $2":"$3}' | sed 's/:$//')",
  "End": "$(echo "$SESSION_INFO" | grep 'End time:' | awk -F': ' '{print $2":"$3}' | sed 's/:$//')",
  "Processed": "$(echo "$SESSION_INFO" | grep 'Processed:' | awk -F': ' '{print $2}')",
  "Transferred": "$(echo "$SESSION_INFO" | grep 'Transferred:' | awk -F': ' '{print $2}')"
}
EOF
)
echo "$JSON"

# have fun ;)
