# Quick Installation Guide

## Option 1: Docker Container (Recommended)

### Quick Start
```bash
cd /opt/arr-monitor
docker compose up -d
```

That's it! Monitor the logs:
```bash
docker logs -f arr-ffprobe-monitor
```

### Advantages
✅ Portable and self-contained
✅ Easy to update (rebuild container)
✅ Built-in resource limits
✅ Automatic health checks
✅ No host dependencies
✅ Works anywhere Docker runs

### Configuration
Edit `/opt/arr-monitor/compose.yaml` to customize:
- Container list
- Check interval
- Max runtime before kill
- Timezone

## Option 2: Systemd Timer

### Quick Start
```bash
/opt/install-arr-monitoring.sh
```
Choose option 1 (Combined monitoring)

### Advantages
✅ Native to Linux
✅ No Docker overhead
✅ Integrated with system logs
✅ Standard systemd management

## Option 3: Cron Job

### Quick Start
```bash
crontab -e
# Add this line:
*/10 * * * * /opt/kill-stuck-ffprobe-all.sh >> /opt/arr-ffprobe-monitor.log 2>&1
```

### Advantages
✅ Simple and familiar
✅ Minimal setup
✅ Works on any Unix system

## Comparison

| Feature | Docker | Systemd | Cron |
|---------|--------|---------|------|
| Portability | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| Ease of setup | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Resource usage | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Management | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| Updates | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |
| Health checks | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐ |

## Recommendation

- **Docker environment?** → Use Docker container (Option 1)
- **Linux with systemd?** → Use systemd timer (Option 2)
- **Minimal setup?** → Use cron (Option 3)

All three options work equally well for monitoring and killing stuck processes!
