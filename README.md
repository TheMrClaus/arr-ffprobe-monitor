# *arr ffprobe Monitor - Docker Container

A lightweight Docker container that monitors Radarr, Sonarr, and other *arr containers for stuck ffprobe processes and automatically kills them.

## Features

- 🐳 **Docker-based**: Easy to deploy and manage
- 🔄 **Multi-container support**: Monitor multiple *arr containers simultaneously
- ⚙️ **Configurable**: Customize timeouts, check intervals, and container list
- 📝 **Logging**: Optional logging of killed processes
- 🪶 **Lightweight**: Minimal resource usage (64MB RAM limit, 0.1 CPU)
- 💚 **Health checks**: Built-in health monitoring
- 🔒 **Read-only Docker socket**: Secure access to Docker API

## Quick Start

### 1. Build and start the container

```bash
cd /opt/arr-monitor
docker compose up -d
```

### 2. Check logs

```bash
docker logs -f arr-ffprobe-monitor
```

### 3. View kill logs (if LOG_FILE is enabled)

```bash
cat /opt/arr-monitor/logs/ffprobe-kills.log
```

## Configuration

Edit the `compose.yaml` or create a `.env` file to customize:

```bash
# Copy example env file
cp .env.example .env

# Edit configuration
nano .env
```

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `CONTAINERS` | `radarr4k,sonarr4k` | Comma-separated list of containers to monitor |
| `MAX_MINUTES` | `5` | Maximum runtime in minutes before killing ffprobe |
| `CHECK_INTERVAL` | `600` | How often to check (in seconds). 600 = 10 minutes |
| `TZ` | `UTC` | Timezone for log timestamps |
| `LOG_FILE` | _none_ | Optional path to log file inside container |

### Examples

**Monitor only Radarr:**
```yaml
environment:
  - CONTAINERS=radarr4k
```

**More aggressive monitoring (check every 5 minutes, kill after 3 minutes):**
```yaml
environment:
  - MAX_MINUTES=3
  - CHECK_INTERVAL=300
```

**Monitor all *arr containers:**
```yaml
environment:
  - CONTAINERS=radarr4k,sonarr4k,lidarr,readarr,prowlarr
```

## Management Commands

### View logs
```bash
docker logs -f arr-ffprobe-monitor
```

### Restart the monitor
```bash
docker restart arr-ffprobe-monitor
```

### Stop monitoring
```bash
docker compose down
```

### Update configuration
```bash
# Edit compose.yaml
nano compose.yaml

# Restart to apply changes
docker compose up -d
```

### Check health status
```bash
docker inspect arr-ffprobe-monitor --format='{{.State.Health.Status}}'
```

## How It Works

1. **Continuous Loop**: Runs every `CHECK_INTERVAL` seconds (default: 10 minutes)
2. **Process Check**: Scans each monitored container for ffprobe processes
3. **Runtime Detection**: Calculates how long each ffprobe has been running
4. **Automatic Kill**: If runtime exceeds `MAX_MINUTES` (default: 5), kills the process with `kill -9`
5. **Logging**: Logs all kills with timestamp and runtime details

## Troubleshooting

### Container not starting?
```bash
# Check logs
docker logs arr-ffprobe-monitor

# Verify Docker socket access
docker exec arr-ffprobe-monitor docker ps
```

### Monitor not detecting stuck processes?
```bash
# Check if target containers are running
docker ps | grep -E "(radarr|sonarr)"

# Manually check for ffprobe in target container
docker exec radarr4k ps aux | grep ffprobe
```

### No logs appearing?
```bash
# Check if LOG_FILE is set and volume is mounted
docker exec arr-ffprobe-monitor ls -la /logs

# View container stdout instead
docker logs -f arr-ffprobe-monitor
```

## Advantages Over Systemd/Cron

✅ **Portable**: Works on any system with Docker
✅ **Self-contained**: No host system dependencies
✅ **Easy updates**: Just rebuild the container
✅ **Consistent**: Same behavior across all environments
✅ **Resource limits**: Built-in CPU/memory constraints
✅ **Health monitoring**: Automatic restart if monitor fails
✅ **Easy removal**: `docker compose down` and it's gone

## Building from Scratch

If you want to build manually without compose:

```bash
# Build the image
docker build -t arr-ffprobe-monitor /opt/arr-monitor

# Run the container
docker run -d \
  --name arr-ffprobe-monitor \
  --restart unless-stopped \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  -v /opt/arr-monitor/logs:/logs \
  -e CONTAINERS=radarr4k,sonarr4k \
  -e MAX_MINUTES=5 \
  -e CHECK_INTERVAL=600 \
  -e TZ=Europe/Madrid \
  -e LOG_FILE=/logs/ffprobe-kills.log \
  --memory=64m \
  --cpus=0.1 \
  arr-ffprobe-monitor
```

## Security Notes

- Docker socket is mounted as **read-only** (`:ro`)
- Container only needs ability to execute `ps` and `kill` commands in target containers
- Runs with minimal resource limits
- No privileged mode required

## Uninstall

```bash
cd /opt/arr-monitor
docker compose down
docker rmi arr-ffprobe-monitor
cd ..
rm -rf arr-monitor
```

## Alternative: Pre-built Image

If you want to publish this as a pre-built image:

```bash
# Build and tag
docker build -t your-dockerhub/arr-ffprobe-monitor:latest /opt/arr-monitor

# Push to registry
docker push your-dockerhub/arr-ffprobe-monitor:latest

# Then use in compose.yaml:
# image: your-dockerhub/arr-ffprobe-monitor:latest
```
