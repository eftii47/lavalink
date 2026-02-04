# Java Music Bot - Complete Setup

## ☕ Everything Runs on Java

This is a **pure Java implementation** - no Node.js required!

### Components:

1. **Lavalink Server** (Java) - `Lavalink.jar`
2. **Discord Bot** (Java) - `target/MusicBot.jar`

Both are Java applications that run together.

## Prerequisites

- **Java 17+** (required for both Lavalink and bot)
- **Maven** (for building the bot)
- Discord bot token

## Quick Start

### 1. Build the Bot

```bash
chmod +x build.sh
./build.sh
```

This compiles the Java source code and creates `target/MusicBot.jar`

### 2. Configure

```bash
cp config.example.yml config.yml
nano config.yml
```

Add your Discord bot token.

### 3. Start Everything

**Terminal 1 - Lavalink Server:**
```bash
./start.sh
```

**Terminal 2 - Discord Bot:**
```bash
./run-bot.sh
```

## Building from Source

The bot uses Maven for dependency management:

```bash
# Clean and build
mvn clean package

# Run tests
mvn test

# Skip tests and build faster
mvn clean package -DskipTests
```

Output: `target/MusicBot.jar` (fat JAR with all dependencies)

## Project Structure

```
lavalink/
├── pom.xml                          # Maven configuration
├── src/main/java/com/lavalink/bot/
│   ├── MusicBot.java               # Main class
│   ├── Config.java                 # Configuration loader
│   ├── LavalinkManager.java        # Lavalink client
│   └── MusicCommandHandler.java    # Command handler
├── target/
│   └── MusicBot.jar                # Built bot (after build)
├── Lavalink.jar                    # Lavalink server
├── application.yml                 # Lavalink config
├── config.yml                      # Bot config
├── plugins/                        # Lavalink plugins
├── build.sh                        # Build script
├── run-bot.sh                      # Run bot script
└── start.sh                        # Start Lavalink script
```

## Dependencies

Managed automatically by Maven:

- **JDA 5.0.0** - Java Discord API
- **Lavalink Client 2.2.0** - Lavalink integration
- **SnakeYAML 2.2** - YAML configuration parsing
- **SLF4J 2.0.9** - Logging

## Bot Commands

All the same commands as before:

```
!play <song>     - Play from YouTube, Spotify, etc.
!skip            - Skip current song
!pause           - Pause/resume
!stop            - Stop playback
!volume <0-200>  - Set volume
!queue           - Show queue
!nowplaying      - Current song info
!disconnect      - Leave voice channel
!help            - Show all commands
```

## Running in Production

### As Background Process

```bash
# Start Lavalink
nohup java -jar Lavalink.jar > lavalink.log 2>&1 &

# Start Bot
nohup java -jar target/MusicBot.jar > bot.log 2>&1 &
```

### Using systemd (Linux)

Create `/etc/systemd/system/lavalink.service`:
```ini
[Unit]
Description=Lavalink Server
After=network.target

[Service]
Type=simple
User=your-user
WorkingDirectory=/path/to/lavalink
ExecStart=/usr/bin/java -jar Lavalink.jar
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

Create `/etc/systemd/system/musicbot.service`:
```ini
[Unit]
Description=Discord Music Bot
After=lavalink.service
Requires=lavalink.service

[Service]
Type=simple
User=your-user
WorkingDirectory=/path/to/lavalink
ExecStart=/usr/bin/java -jar target/MusicBot.jar
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

Enable and start:
```bash
sudo systemctl enable lavalink musicbot
sudo systemctl start lavalink musicbot
sudo systemctl status lavalink musicbot
```

## Development

### Hot Reload (Development)

Maven doesn't have native hot reload, but you can use:

```bash
# Watch for changes and rebuild (requires maven-watch plugin)
mvn fizzed-watcher:run
```

Or manually:
```bash
# In one terminal
watch -n 2 mvn compile

# In another
java -jar target/MusicBot.jar
```

### IDE Setup

**IntelliJ IDEA:**
1. Open folder as Maven project
2. IDEA will auto-import dependencies
3. Set SDK to Java 17+
4. Run `MusicBot.main()`

**Eclipse:**
1. Import as Maven project
2. Right-click project → Maven → Update Project
3. Run as Java Application

**VS Code:**
1. Install Java Extension Pack
2. Open folder
3. VS Code detects Maven automatically

## Troubleshooting

### "Command not found: mvn"
Install Maven:
```bash
# Ubuntu/Debian
sudo apt-get install maven

# macOS
brew install maven

# Windows
choco install maven
```

### "Unsupported class file major version"
You need Java 17 or higher:
```bash
java -version  # Should show 17+
```

### Build fails with dependency errors
```bash
mvn clean install -U  # Force update dependencies
```

### Bot won't connect to Lavalink
1. Ensure Lavalink is running
2. Check passwords match in both YML files
3. Verify port 2333 is correct

## Performance

The Java bot is:
- ✅ **Faster** - Native compilation, no interpreter
- ✅ **More memory efficient** - Better GC
- ✅ **More stable** - Type safety, compile-time checks
- ✅ **Single runtime** - Only Java needed

## Comparison: Java vs Node.js

| Feature | Java Bot | Node.js Bot |
|---------|----------|-------------|
| Runtime | Java 17+ | Node.js 18+ |
| Build | Maven | npm |
| Start | `java -jar` | `node src/index.js` |
| Hot Reload | Manual/Plugin | `--watch` flag |
| Memory | ~100-200MB | ~150-300MB |
| Startup | Faster | Faster |
| Type Safety | ✅ Compile-time | ❌ Runtime |

## License

MIT

---

**Built entirely in Java ☕**
