# Deploying Java Music Bot

## 📦 Deployable Files

After running `./build-deploy.sh`, you'll have:

1. **`target/MusicBot.jar`** - Standalone executable JAR (~20-30MB)
   - Contains all dependencies
   - Ready to deploy anywhere
   
2. **`config.yml`** - Configuration file
   - Add your Discord token
   - Configure Lavalink connection

## 🚀 Deployment Options

### Option 1: VPS/Dedicated Server (Recommended)

**Platforms:** DigitalOcean, Linode, Vultr, AWS EC2, Google Cloud, Azure

#### Requirements:
- Java 17+ installed
- At least 512MB RAM (1GB recommended)
- Persistent storage

#### Steps:

1. **Upload files to server:**
```bash
scp target/MusicBot.jar user@yourserver.com:/home/bot/
scp config.yml user@yourserver.com:/home/bot/
scp Lavalink.jar user@yourserver.com:/home/bot/
scp application.yml user@yourserver.com:/home/bot/
scp -r plugins/ user@yourserver.com:/home/bot/
```

2. **SSH into server:**
```bash
ssh user@yourserver.com
cd /home/bot
```

3. **Install Java (if needed):**
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install openjdk-17-jdk

# CentOS/RHEL
sudo yum install java-17-openjdk
```

4. **Start Lavalink:**
```bash
nohup java -jar Lavalink.jar > lavalink.log 2>&1 &
```

5. **Start Bot:**
```bash
nohup java -jar MusicBot.jar > bot.log 2>&1 &
```

6. **Check logs:**
```bash
tail -f bot.log
tail -f lavalink.log
```

7. **Stop processes:**
```bash
pkill -f MusicBot.jar
pkill -f Lavalink.jar
```

---

### Option 2: Using systemd (Linux Service)

**Best for:** Long-term deployments on Linux servers

#### Create Lavalink Service:

Create `/etc/systemd/system/lavalink.service`:
```ini
[Unit]
Description=Lavalink Audio Server
After=network.target

[Service]
Type=simple
User=bot
Group=bot
WorkingDirectory=/home/bot
ExecStart=/usr/bin/java -Xmx512M -jar Lavalink.jar
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

#### Create Bot Service:

Create `/etc/systemd/system/musicbot.service`:
```ini
[Unit]
Description=Discord Music Bot
After=network.target lavalink.service
Requires=lavalink.service

[Service]
Type=simple
User=bot
Group=bot
WorkingDirectory=/home/bot
ExecStart=/usr/bin/java -Xmx256M -jar MusicBot.jar
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

#### Enable and Start:
```bash
sudo systemctl daemon-reload
sudo systemctl enable lavalink musicbot
sudo systemctl start lavalink musicbot
sudo systemctl status lavalink musicbot
```

#### Manage Services:
```bash
# View logs
sudo journalctl -u musicbot -f
sudo journalctl -u lavalink -f

# Restart
sudo systemctl restart musicbot
sudo systemctl restart lavalink

# Stop
sudo systemctl stop musicbot lavalink
```

---

### Option 3: Docker Deployment

**Best for:** Containerized environments

#### Using Docker Compose:

Already configured! Just update `config.yml` and:
```bash
docker-compose up -d
```

View logs:
```bash
docker-compose logs -f
```

Stop:
```bash
docker-compose down
```

---

### Option 4: Railway.app

**Platform:** https://railway.app/

#### Setup:

1. **Create `Procfile`:**
```
web: java -jar target/MusicBot.jar
```

2. **Create `railway.toml`:**
```toml
[build]
builder = "NIXPACKS"

[deploy]
startCommand = "java -jar target/MusicBot.jar"
```

3. **Deploy:**
```bash
railway login
railway init
railway up
```

4. **Set environment variables in Railway dashboard:**
   - Or keep config.yml and upload it

---

### Option 5: Heroku

**Platform:** https://heroku.com/

#### Setup:

1. **Create `Procfile`:**
```
worker: java -jar target/MusicBot.jar
```

2. **Create `system.properties`:**
```
java.runtime.version=17
```

3. **Deploy:**
```bash
heroku login
heroku create your-music-bot
git push heroku main
heroku ps:scale worker=1
```

4. **Configure:**
```bash
heroku config:set DISCORD_TOKEN=your_token
```

---

### Option 6: Render.com

**Platform:** https://render.com/

#### Setup:

1. **Connect GitHub repository**

2. **Configure as Background Worker:**
   - **Build Command:** `mvn clean package -DskipTests`
   - **Start Command:** `java -jar target/MusicBot.jar`

3. **Add environment variables** or upload config.yml

---

### Option 7: Oracle Cloud (Free Tier)

**Best for:** Free hosting with generous limits

#### Setup:

1. Create free tier VM (ARM or x86)
2. Install Java 17
3. Upload JAR files
4. Use systemd or nohup to run
5. Configure firewall for port 2333

Free tier includes:
- 2 VMs (1GB RAM each)
- 200GB storage
- Always free

---

## 🔧 Configuration for Remote Lavalink

If Lavalink is hosted separately:

**In `config.yml`:**
```yaml
lavalink:
  host: "lavalink.yourserver.com"  # Your Lavalink server
  port: 2333
  password: "your_secure_password"
  secure: false  # Set true for HTTPS
```

## 📊 Resource Requirements

### Minimum:
- **RAM:** 512MB (bot) + 512MB (Lavalink) = 1GB total
- **CPU:** 1 core
- **Storage:** 200MB

### Recommended:
- **RAM:** 1GB (bot) + 1GB (Lavalink) = 2GB total
- **CPU:** 2 cores
- **Storage:** 500MB

### Heavy Usage:
- **RAM:** 2GB (bot) + 2GB (Lavalink) = 4GB total
- **CPU:** 4 cores
- **Storage:** 1GB

## 🔐 Security Best Practices

1. **Change default password** in application.yml
2. **Don't commit config.yml** with real tokens
3. **Use environment variables** for sensitive data
4. **Enable firewall** - only allow necessary ports
5. **Keep Java updated** for security patches
6. **Regular backups** of configuration files

## 🐛 Troubleshooting

### Bot won't start:
```bash
# Check Java version
java -version

# Test JAR manually
java -jar MusicBot.jar

# Check config
cat config.yml
```

### Can't connect to Lavalink:
```bash
# Test Lavalink connection
curl http://localhost:2333/version

# Check if Lavalink is running
ps aux | grep Lavalink

# Check ports
netstat -tlnp | grep 2333
```

### Out of memory:
```bash
# Increase heap size
java -Xmx512M -jar MusicBot.jar

# For Lavalink
java -Xmx1G -jar Lavalink.jar
```

## 📝 Startup Scripts

### Linux/Mac - `start-all.sh`:
```bash
#!/bin/bash
cd /home/bot
java -Xmx1G -jar Lavalink.jar &
sleep 10
java -Xmx512M -jar MusicBot.jar &
echo "Bot started!"
```

### Windows - `start-all.bat`:
```batch
@echo off
cd C:\bot
start "Lavalink" java -Xmx1G -jar Lavalink.jar
timeout /t 10
start "MusicBot" java -Xmx512M -jar MusicBot.jar
echo Bot started!
```

## 🔄 Auto-Restart on Crash

### Using systemd:
Already configured with `Restart=always`

### Using supervisor (Linux):
```ini
[program:lavalink]
command=java -jar /home/bot/Lavalink.jar
directory=/home/bot
autostart=true
autorestart=true
user=bot

[program:musicbot]
command=java -jar /home/bot/MusicBot.jar
directory=/home/bot
autostart=true
autorestart=true
user=bot
```

### Using PM2 (if available):
```bash
pm2 start "java -jar Lavalink.jar" --name lavalink
pm2 start "java -jar MusicBot.jar" --name musicbot
pm2 save
pm2 startup
```

## 📈 Monitoring

### Check if running:
```bash
ps aux | grep -E "MusicBot|Lavalink"
```

### Memory usage:
```bash
top -p $(pgrep -f MusicBot.jar)
```

### Disk space:
```bash
df -h
```

### Logs:
```bash
tail -f bot.log
grep ERROR bot.log
```

## 🌐 Domain Setup (Optional)

If using custom domain for Lavalink:

1. Point A record to your server IP
2. Install nginx:
```bash
sudo apt install nginx
```

3. Configure nginx (`/etc/nginx/sites-available/lavalink`):
```nginx
server {
    listen 80;
    server_name lavalink.yourdomain.com;
    
    location / {
        proxy_pass http://localhost:2333;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

4. Enable and restart nginx

## 💰 Cost Comparison

| Platform | Free Tier | Paid (Monthly) |
|----------|-----------|----------------|
| Oracle Cloud | ✅ Forever Free | $0 |
| Railway | 500 hours/month | $5-20 |
| Heroku | 550 hours/month | $7+ |
| Render | 750 hours/month | $7+ |
| DigitalOcean | Trial credit | $6+ |
| Contabo | ❌ | €5+ |

## ✅ Deployment Checklist

- [ ] Build JAR: `./build-deploy.sh`
- [ ] Configure `config.yml` with real token
- [ ] Test locally first
- [ ] Upload files to server
- [ ] Install Java 17+ on server
- [ ] Start Lavalink first
- [ ] Start bot second
- [ ] Check logs for errors
- [ ] Test bot in Discord
- [ ] Set up auto-restart
- [ ] Configure monitoring
- [ ] Schedule backups

---

**Your bot is now ready for production hosting!** 🚀
