# Lavalink v4.1.2 Java Music Bot

**100% Java implementation** - Complete Discord music bot running entirely on Java!

## ☕ Pure Java Stack

- ✅ **Lavalink v4.1.2** - Audio processing server (Java)
- ✅ **Discord Bot** - JDA-based bot (Java)  
- ✅ **11 Pre-installed Plugins**
- ✅ **No Node.js Required** - Everything runs on Java
- ✅ **Maven Build System**
- ✅ **Docker Support**

## 🔌 Included Plugins

Your workspace includes these plugins in `/plugins/`:

1. **LavaSrc v4.8.1** - Spotify, Apple Music, Deezer, Yandex Music support
2. **LavaSearch v1.0.0** - Enhanced search capabilities
3. **SponsorBlock v3.0.1** - Auto-skip sponsored YouTube segments
4. **LavaLyrics v1.6.6** - Fetch song lyrics
5. **YouTube Plugin v1.17.0** - Enhanced YouTube playback
6. **TTS Plugin v1.0.1** - Text-to-speech
7. **SkyBot Plugin v1.7.0** - Additional features
8. **Lava-XM Plugin v0.2.8** - Extended format support

## 📋 Prerequisites

- Node.js 18.x or higher
- Java 17 or higher (already have Lavalink.jar)
- Discord bot token from [Discord Developer Portal](https://discord.com/developers/applications)
- Docker (optional, for containerized deployment)

## 🚀 Quick Start

### 1. Install Node.js Dependencies

```bash
npm install

```bash
npm install
```bash
npm install
```

### 2. Configure Bot

```bash
cp config.example.yml config.yml
```

Edit `config.yml` and add your Discord credentials:
- `discord.token` - Your Discord bot token
- `discord.clientId` - Your Discord application ID

### 3. Configure Plugins (Optional)

Edit [application.yml](application.yml) to configure plugin settings:
- Spotify credentials for LavaSrc
- Apple Music API token
- Deezer master key

### 4. Start Lavalink Server

**Option A - Using start script:**
```bash
chmod +x start.sh
./start.sh
```

**Option B - Direct command:**
```bash
java -jar Lavalink.jar
```

The Lavalink server will start on port 2333.

### 4. Start Discord Bot (in a new terminal)

```bash
chmod +x run-bot.sh
./run-bot.sh
```

Or directly:
```bash
java -jar target/MusicBot.jar
```

## 🎵 Discord Bot Commands

| Command | Aliases | Description |
|---------|---------|-------------|
| `!play <song>` | `!p` | Play a song or playlist from any supported source |
| `!skip` | `!s` | Skip the current song |
| `!pause` | - | Pause or resume playback |
| `!stop` | - | Stop playback and clear queue |
| `!volume <0-200>` | `!vol` | Adjust volume (default: 100) |
| `!queue` | `!q` | Display the current queue |
| `!nowplaying` | `!np` | Show currently playing song with progress |
| `!shuffle` | - | Shuffle the queue |
| `!clear` | - | Clear the entire queue |
| `!disconnect` | `!leave`, `!dc` | Disconnect bot from voice channel |
| `!help` | `!h` | Show all available commands |

## 🎸 Supported Sources

The bot supports playing from multiple sources:

- **YouTube** - `!play never gonna give you up` or direct URL
- **Spotify** - `!play https://open.spotify.com/track/...`
- **Apple Music** - `!play https://music.apple.com/...`
- **Deezer** - `!play https://www.deezer.com/...`
- **SoundCloud** - `!play https://soundcloud.com/...`
- **Bandcamp** - Direct URLs
- **Twitch** - Live streams
- **Vimeo** - Video audio
- **Direct URLs** - MP3, OGG, FLAC, etc.

## ⚙️ Configuration

### Lavalink Settings

Edit [application.yml](application.yml) for:

```yaml
lavalink:
  server:
    password: "youshallnotpass"  # Change this!
    opusEncodingQuality: 10      # 0-10, higher = better
    resamplingQuality: LOW       # LOW, MEDIUM, HIGH
```

### Plugin Configuration

#### Spotify (LavaSrc)
1. Go to [Spotify Developer Dashboard](https://developer.spotify.com/dashboard)
2. Create an app and get Client ID & Secret
3. Add to `application.yml`:
```yaml
plugins:
  lavasrc:
    spotify:
      clientId: "your_client_id"
      clientSecret: "your_client_secret"
```

#### Apple Music (LavaSrc)
Get token from [Apple Developer](https://developer.apple.com/documentation/applemusicapi) and add:
```yaml
plugins:
  lavasrc:
    applemusic:
      mediaAPIToken: "your_token"
```

## 🐳 Docker Deployment

### Using Docker Compose (Recommended)

Start both Lavalink and bot:
```bash
docker-compose up -d
```

View logs:
```bash
docker-compose logs -f
```

Stop services:
```bash
docker-compose down
```

### Lavalink Only
```bash
docker-compose up -d lavalink
```

## 📊 Architecture

```
┌─────────────────────┐
│   Discord Users     │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  Discord Bot (JDA)  │  ← Java
│   MusicBot.jar      │
│  - Commands         │
│  - Queue Management │
└──────────┬──────────┘
           │ WebSocket/REST
           ▼
┌─────────────────────┐
│   Lavalink v4.1.2   │  ← Java
│   Server            │
│  Lavalink.jar       │
├─────────────────────┤
│  🔌 Plugins:        │
│   • LavaSrc         │
│   • LavaSearch      │
│   • SponsorBlock    │
│   • LavaLyrics      │
│   • YouTube         │
│   • TTS             │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  Audio Sources      │
│  YouTube, Spotify,  │
│  Apple Music, etc.  │
└─────────────────────┘

Everything runs on Java ☕
```

## 🔧 Troubleshooting

### Lavalink won't start
- ✓ Check Java version: `java -version` (need 17+)
- ✓ Verify port 2333 is free: `lsof -i :2333`
- ✓ Check logs in `logs/` directory

### Bot can't connect to Lavalink
- ✓ Ensure Lavalink is running: `curl http://localhost:2333/version`
- ✓ Check password matches in `.env` and `application.yml`
- ✓ Verify firewall isn't blocking port 2333

### No audio in Discord
- ✓ Check bot has Connect and Speak permissions
- ✓ Verify bot isn't server-muted
- ✓ Try adjusting volume: `!volume 100`

### Spotify/Apple Music not working
- ✓ Configure API credentials in `application.yml`
- ✓ Check Lavalink logs for plugin errors
- ✓ Restart Lavalink after config changes

### Plugin errors
- ✓ All plugins are in `/plugins/` directory
- ✓ Check plugin compatibility with Lavalink v4.1.2
- ✓ Review Lavalink startup logs for plugin initialization

## 📝 Development

### Project Structure
```
lavalink/
├── pom.xml                          # Maven build configuration
├── src/main/java/com/lavalink/bot/
│   ├── MusicBot.java               # Main entry point
│   ├── Config.java                 # Configuration loader
│   ├── LavalinkManager.java        # Lavalink client manager
│   └── MusicCommandHandler.java    # Discord command handler
├── target/
│   └── MusicBot.jar                # Compiled bot (after build)
├── Lavalink.jar                    # Lavalink v4.1.2 server
├── application.yml                 # Lavalink configuration
├── config.yml                      # Bot configuration (create from example)
├── config.example.yml              # Bot configuration template
├── plugins/                        # Lavalink plugins (11 plugins)
├── build.sh                        # Build the bot script
├── run-bot.sh                      # Run the bot script
└── start.sh                        # Start Lavalink script
```

### Checking Lavalink Version
```bash
java -jar Lavalink.jar --version
```

### Building the Bot
```bash
# Full build
mvn clean package

# Skip tests (faster)
mvn clean package -DskipTests

# Clean only
mvn clean
```

## 🌐 Resources

- [Lavalink Documentation](https://lavalink.dev/)
- [Lavalink GitHub](https://github.com/lavalink-devs/Lavalink)
- [LavaSrc Plugin](https://github.com/topi314/LavaSrc)
- [LavaSearch Plugin](https://github.com/topi314/LavaSearch)
- [SponsorBlock Plugin](https://github.com/topi314/Sponsorblock-Plugin)
- [LavaLyrics Plugin](https://github.com/DRSchlaubi/lyrics.kt)
- [Discord.js Guide](https://discordjs.guide/)
- [Discord.js Documentation](https://discord.js.org/)

## 📄 License

MIT

## 🙋 Support

If you encounter issues:
1. Check the [Troubleshooting](#🔧-troubleshooting) section
2. Review Lavalink logs in `/logs/` directory
3. Check bot console output
4. Visit plugin GitHub repositories for specific issues

---

**Built with ❤️ using Lavalink v4.1.2 and Discord.js**

Copy the example environment file and fill in your credentials:

```bash
cp .env.example .env
```

Edit `.env` with your credentials:
- `DISCORD_TOKEN` - Your Discord bot token
- `CLIENT_ID` - Your Discord application client ID
- Optionally configure Spotify, Apple Music, and Deezer API credentials in `application.yml`

### 3. Configure Lavalink

Edit `application.yml` to configure:
- Lavalink password (default: `youshallnotpass`)
- Plugin settings (Spotify, Apple Music, Deezer credentials)
- Audio sources and filters

## Running Lavalink

### Option 1: Using Docker (Recommended)

```bash
docker-compose up -d
```

To stop:
```bash
docker-compose down
```

To view logs:
```bash
docker-compose logs -f lavalink
```

### Option 2: Direct Java Execution

1. Download Lavalink:
```bash
npm run lavalink:download
```

2. Start Lavalink:
```bash
npm run lavalink:start
```

Or manually:
```bash
java -jar Lavalink.jar
```

## Running the Discord Bot

Once Lavalink is running:

```bash
npm start
```

For development with auto-reload:
```bash
npm run dev
```

## Discord Bot Commands

| Command | Description |
|---------|-------------|
| `!play <song>` | Play a song or playlist |
| `!skip` | Skip the current song |
| `!stop` | Stop playback and clear queue |
| `!pause` | Pause/Resume playback |
| `!volume <0-200>` | Set volume (default: 100) |
| `!queue` | Show the current queue |
| `!nowplaying` or `!np` | Show currently playing song |
| `!disconnect` or `!leave` | Disconnect from voice channel |
| `!help` | Show all commands |

## Supported Search Formats

The bot supports various search queries:

- YouTube: `!play never gonna give you up`
- Direct URL: `!play https://www.youtube.com/watch?v=...`
- Spotify: `!play https://open.spotify.com/track/...`
- Apple Music: `!play https://music.apple.com/...`
- Deezer: `!play https://www.deezer.com/...`
- SoundCloud: `!play https://soundcloud.com/...`

## Configuration

### Lavalink Password

Change the password in both files:
1. `application.yml` - `lavalink.server.password`
2. `config.yml` - `lavalink.password`

### Plugin Configuration

#### Spotify (LavaSrc)

1. Go to [Spotify Developer Dashboard](https://developer.spotify.com/dashboard)
2. Create an application
3. Get your Client ID and Client Secret
4. Add them to `application.yml` under `plugins.lavasrc.spotify`

#### Apple Music (LavaSrc)

1. Get a Media API token from [Apple Developer](https://developer.apple.com/documentation/applemusicapi/getting_keys_and_creating_tokens)
2. Add it to `application.yml` under `plugins.lavasrc.applemusic`

#### Deezer (LavaSrc)

1. Obtain the master decryption key
2. Add it to `application.yml` under `plugins.lavasrc.deezer`

### Audio Quality Settings

In `application.yml`, adjust:

```yaml
lavalink:
  server:
    opusEncodingQuality: 10 # 0-10, higher is better quality
    resamplingQuality: HIGH # LOW, MEDIUM, HIGH
    bufferDurationMs: 400
    frameBufferDurationMs: 5000
```

## Troubleshooting

### Lavalink won't start

- Ensure Java 17+ is installed: `java -version`
- Check port 2333 is not in use: `lsof -i :2333` (Linux/Mac) or `netstat -ano | findstr :2333` (Windows)
- Check `logs/` directory for error messages

### Bot can't connect to Lavalink

- Verify Lavalink is running: `curl http://localhost:2333/version`
- Check password in `.env` matches `application.yml`
- Ensure firewall allows connections on port 2333

### No sound in Discord

- Check bot has permission to connect and speak in voice channels
- Verify bot is not server muted
- Check volume: `!volume 100`

### YouTube playback issues

- YouTube frequently changes their API; update Lavalink to the latest version
- Consider configuring YouTube account in `application.yml` for better rate limits

### Plugin not working

- Verify plugin credentials are correct in `application.yml`
- Check Lavalink logs for plugin initialization errors
- Ensure you're using the correct URL format for each source

## Architecture

```
┌─────────────────┐
│  Discord Bot    │
│   (Node.js)     │
└────────┬────────┘
         │
         │ WebSocket
         │ REST API
         │
┌────────▼────────┐
│   Lavalink v4   │
│   Server        │
├─────────────────┤
│   - LavaSrc     │
│   - LavaSearch  │
│   - SponsorBlock│
└────────┬────────┘
         │
    ┌────┴────┐
    │ Audio   │
    │ Sources │
    └─────────┘
```

## Resources

- [Lavalink Documentation](https://lavalink.dev/)
- [Lavalink GitHub](https://github.com/lavalink-devs/Lavalink)
- [LavaSrc Plugin](https://github.com/topi314/LavaSrc)
- [LavaSearch Plugin](https://github.com/topi314/LavaSearch)
- [SponsorBlock Plugin](https://github.com/topi314/Sponsorblock-Plugin)
- [Discord.js Guide](https://discordjs.guide/)

## License

MIT

## Support

If you encounter any issues, please check:
1. Lavalink logs in `logs/` directory
2. Bot console output
3. GitHub issues for Lavalink and plugins