# 🚀 Quick Start Guide

## What You Have

✅ **Lavalink v4.1.2** server (Lavalink.jar)  
✅ **11 Powerful Plugins** pre-installed  
✅ **Full Node.js Discord Music Bot**  
✅ **Docker deployment ready**

## Plugins in Your `/plugins/` Directory

1. **LavaSrc v4.8.1** - Spotify, Apple Music, Deezer
2. **LavaSearch v1.0.0** - Enhanced search
3. **SponsorBlock v3.0.1** - Skip sponsors
4. **LavaLyrics v1.6.6** - Song lyrics
5. **YouTube Plugin v1.17.0** - Enhanced YouTube
6. **TTS Plugin v1.0.1** - Text-to-speech
7. **SkyBot Plugin v1.7.0** - Extra features
8. **Lava-XM Plugin v0.2.8** - Extended formats

## 3-Step Setup

### 1️⃣ Build the Bot
```bash
chmod +x build.sh
./build.sh
```

### 2️⃣ Configure Discord Bot
Create and edit `config.yml` file:
```bash
cp config.example.yml config.yml
nano config.yml
```
Add your Discord bot token from: https://discord.com/developers/applications

### 3️⃣ Start Everything

**Terminal 1 - Start Lavalink:**
```bash
./start.sh
```
Wait for: "Lavalink is ready to accept connections"

**Terminal 2 - Start Discord Bot:**
```bash
./run-bot.sh
```

## 🎵 Using the Bot

Join a voice channel and try:
```
!play never gonna give you up
!play https://open.spotify.com/track/...
!queue
!help
```

## 📋 All Bot Commands

```
!play <song>      - Play from YouTube, Spotify, etc.
!skip             - Skip current song
!pause            - Pause/resume playback
!volume <0-200>   - Adjust volume
!queue            - Show queue
!nowplaying       - Current song info
!shuffle          - Shuffle queue
!clear            - Clear queue
!stop             - Stop and clear
!disconnect       - Leave voice channel
!help             - Show all commands
```

## 🔧 Optional: Configure Plugins

To enable Spotify/Apple Music/Deezer:

1. Edit `application.yml`
2. Add your API credentials under `plugins:` section
3. Restart Lavalink

## 🐳 Docker Alternative

Run everything with Docker:
```bash
docker-compose up -d
```

## ❓ Getting Help

- Check [README.md](README.md) for full documentation
- View logs in `/logs/` directory
- Common issues covered in Troubleshooting section

---

**You're all set! Enjoy your music bot! 🎶**
