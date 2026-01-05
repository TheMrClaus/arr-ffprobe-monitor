FROM docker:cli

# Create app directory
WORKDIR /app

# Copy monitoring script
COPY monitor.sh /app/monitor.sh
RUN chmod +x /app/monitor.sh

# Environment variables with defaults
ENV CONTAINERS="radarr4k,sonarr4k" \
    MAX_MINUTES="5" \
    CHECK_INTERVAL="600" \
    TZ="UTC"

# Run the monitoring loop
CMD ["/bin/sh", "/app/monitor.sh"]
