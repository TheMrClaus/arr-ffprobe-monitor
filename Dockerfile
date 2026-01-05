FROM alpine:latest

# Install required packages
RUN apk add --no-cache \
    bash \
    docker-cli \
    tzdata

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
CMD ["/app/monitor.sh"]
