# Docker Container vs Systemd Timer: Which Should You Choose?

## TL;DR

**Use Docker if:**
- ✅ You already use Docker for everything
- ✅ You want the easiest setup and management
- ✅ You value portability
- ✅ You might move to another system

**Use Systemd if:**
- ✅ You prefer native Linux tools
- ✅ You want minimal resource overhead
- ✅ You're not comfortable with Docker

## Detailed Comparison

### 1. Installation

**Docker:**
```bash
cd /opt/arr-monitor
docker compose up -d
```
⏱️ Time: **30 seconds**

**Systemd:**
```bash
/opt/install-arr-monitoring.sh
# Choose option 1
```
⏱️ Time: **1 minute**

**Winner:** Docker (slightly easier)

---

### 2. Configuration Changes

**Docker:**
```bash
nano /opt/arr-monitor/compose.yaml
docker compose up -d
```

**Systemd:**
```bash
nano /opt/kill-stuck-ffprobe-all.sh
sudo systemctl restart arr-ffprobe-monitor.service
```

**Winner:** Tie (both easy)

---

### 3. Viewing Logs

**Docker:**
```bash
docker logs -f arr-ffprobe-monitor
# OR
cat /opt/arr-monitor/logs/ffprobe-kills.log
```

**Systemd:**
```bash
cat /opt/arr-ffprobe-monitor.log
# OR
journalctl -u arr-ffprobe-monitor.service -f
```

**Winner:** Docker (simpler)

---

### 4. Resource Usage

**Docker:**
- Base image: ~8MB (Alpine)
- Runtime memory: ~10-20MB
- CPU: Negligible (only active during checks)
- Total overhead: ~25-35MB

**Systemd:**
- No container overhead
- Runtime memory: ~5-10MB (bash script only)
- CPU: Negligible (only active during checks)
- Total overhead: ~5-10MB

**Winner:** Systemd (lighter)

---

### 5. Portability

**Docker:**
- ✅ Works on any Docker host (Linux, Mac, Windows)
- ✅ Easy to move between systems
- ✅ Consistent behavior everywhere
- ✅ Can be published to Docker Hub

**Systemd:**
- ⚠️ Linux only
- ⚠️ Requires systemd (not on all distros)
- ⚠️ Manual migration to new systems

**Winner:** Docker (much more portable)

---

### 6. Updates

**Docker:**
```bash
cd /opt/arr-monitor
docker compose down
docker compose build --no-cache
docker compose up -d
```

**Systemd:**
```bash
# Edit script
nano /opt/kill-stuck-ffprobe-all.sh
# No restart needed (cron picks up changes)
# OR restart systemd service
sudo systemctl restart arr-ffprobe-monitor.timer
```

**Winner:** Tie (both straightforward)

---

### 7. Monitoring/Health Checks

**Docker:**
- Built-in health checks
- Auto-restart on failure
- Status: `docker ps` or `docker inspect`
- Integration with monitoring tools (Portainer, etc.)

**Systemd:**
- Systemd service status
- Auto-restart on failure (if configured)
- Status: `systemctl status`
- Journal logs

**Winner:** Docker (better tooling)

---

### 8. Removal/Cleanup

**Docker:**
```bash
cd /opt/arr-monitor
docker compose down
docker rmi arr-ffprobe-monitor
```

**Systemd:**
```bash
sudo systemctl stop arr-ffprobe-monitor.timer
sudo systemctl disable arr-ffprobe-monitor.timer
sudo rm /etc/systemd/system/arr-ffprobe-monitor.*
sudo systemctl daemon-reload
```

**Winner:** Docker (cleaner)

---

### 9. Debugging

**Docker:**
- Interactive shell: `docker exec -it arr-ffprobe-monitor sh`
- Live logs: `docker logs -f arr-ffprobe-monitor`
- Inspect: `docker inspect arr-ffprobe-monitor`

**Systemd:**
- Manual script execution: `/opt/kill-stuck-ffprobe-all.sh`
- Journal logs: `journalctl -u arr-ffprobe-monitor.service`
- Standard bash debugging

**Winner:** Tie (different but both good)

---

### 10. Integration with Existing Setup

**Docker:**
- Perfect if you already have Docker stacks
- Can add to existing compose files
- Shares networks with *arr containers
- Can be managed by Portainer/other tools

**Systemd:**
- Perfect if you use native Linux services
- Integrates with system logging
- Standard Linux service management
- No Docker dependency

**Winner:** Depends on your setup

---

## Score Card

| Category | Docker | Systemd |
|----------|--------|---------|
| Installation | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| Configuration | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Logs | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| Resources | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Portability | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| Updates | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| Health Checks | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| Cleanup | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| Debugging | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| Integration | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **TOTAL** | **47/50** | **41/50** |

## Recommendations

### Choose Docker if:
- ✅ Your entire media stack is Docker-based (Radarr, Sonarr, etc. are all containers)
- ✅ You use Docker Compose to manage services
- ✅ You use tools like Portainer or Dockge
- ✅ You might migrate to a different system in the future
- ✅ You want the "set it and forget it" experience

### Choose Systemd if:
- ✅ You prefer native Linux tools and processes
- ✅ You want absolute minimal resource usage
- ✅ You don't use Docker for anything else
- ✅ You're very comfortable with systemd
- ✅ You have strong opinions against Docker 😄

## Can I Use Both?

**No!** Don't run both at the same time - they'll both try to kill the same processes and you'll have duplicate monitoring.

## Can I Switch Later?

**Yes!** Easy to switch:

**Docker → Systemd:**
```bash
docker compose down
/opt/install-arr-monitoring.sh
```

**Systemd → Docker:**
```bash
sudo systemctl stop arr-ffprobe-monitor.timer
sudo systemctl disable arr-ffprobe-monitor.timer
cd /opt/arr-monitor
docker compose up -d
```

## Final Verdict

🏆 **Docker wins** for most users because:
1. Easier management
2. Better portability
3. Cleaner integration with Docker-based setups
4. More modern tooling

But **Systemd is perfectly fine** if you prefer it or don't use Docker!
