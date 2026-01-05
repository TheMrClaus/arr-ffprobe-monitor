#!/bin/bash
# Docker-based ffprobe monitor for *arr containers

# Parse container list from environment variable
IFS=',' read -ra CONTAINER_LIST <<< "$CONTAINERS"

echo "[$(date)] Starting *arr ffprobe monitor"
echo "Monitoring containers: ${CONTAINER_LIST[*]}"
echo "Max allowed runtime: ${MAX_MINUTES} minutes"
echo "Check interval: ${CHECK_INTERVAL} seconds"
echo "----------------------------------------"

# Main monitoring loop
while true; do
    for CONTAINER in "${CONTAINER_LIST[@]}"; do
        # Trim whitespace
        CONTAINER=$(echo "$CONTAINER" | xargs)

        # Check if container exists and is running
        if ! docker ps --format '{{.Names}}' 2>/dev/null | grep -q "^${CONTAINER}$"; then
            continue
        fi

        # Find ffprobe processes older than MAX_MINUTES
        docker exec "$CONTAINER" ps -eo pid,etime,stat,cmd 2>/dev/null | grep ffprobe | while read -r pid etime stat cmd; do
            # Convert elapsed time to minutes
            if echo "$etime" | grep -q ':.*:'; then
                # Format: HH:MM:SS or DD-HH:MM:SS
                hours=$(echo "$etime" | sed 's/-.*//' | awk -F: '{if (NF==3) print $1; else print 0}')
                minutes=$(echo "$etime" | awk -F: '{if (NF==3) print $2; else print $1}')
            else
                # Format: MM:SS
                hours=0
                minutes=$(echo "$etime" | awk -F: '{print $1}')
            fi

            total_minutes=$((hours * 60 + minutes))

            if [ "$total_minutes" -ge "$MAX_MINUTES" ]; then
                echo "[$(date)] [$CONTAINER] Killing stuck ffprobe process (PID: $pid, Runtime: $etime, State: $stat)"
                docker exec "$CONTAINER" kill -9 "$pid" 2>/dev/null

                # Log to a file if LOG_FILE is set
                if [ -n "$LOG_FILE" ]; then
                    echo "[$(date)] [$CONTAINER] Killed stuck ffprobe PID $pid after $etime" >> "$LOG_FILE"
                fi
            fi
        done
    done

    # Sleep until next check
    sleep "$CHECK_INTERVAL"
done
