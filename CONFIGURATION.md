# Configuration Summary

## All Configuration in YAML Files ✅

The entire setup now uses YAML configuration files only - no `.env` files needed!

## Configuration Files

### 1. `application.yml` - Lavalink Server Configuration

Controls the Lavalink server (Java):
- Server port and address
- Lavalink password
- Audio sources (YouTube, Spotify, etc.)
- All plugin configurations
- YouTube OAuth2 settings
- Rate limiting and proxy settings

**Location:** `/workspaces/lavalink/application.yml`

### 2. `config.yml` - Discord Bot Configuration

Controls the Discord bot (Node.js):
- Discord bot token
- Discord client ID
- Lavalink connection settings
- Optional plugin API keys

**Location:** `/workspaces/lavalink/config.yml` (create from config.example.yml)

## Setup Instructions

### First Time Setup

1. **Create bot config:**
   ```bash
   cp config.example.yml config.yml
   ```

2. **Edit config.yml:**
   ```bash
   nano config.yml
   ```
   
   Add your values:
   ```yaml
   discord:
     token: "your_actual_bot_token_here"
     clientId: "your_actual_client_id_here"
   
   lavalink:
     password: "youshallnotpass"  # Match application.yml
   ```

3. **Optionally configure plugins in application.yml:**
   ```yaml
   plugins:
     lavasrc:
       spotify:
         clientId: "your_spotify_id"
         clientSecret: "your_spotify_secret"
   ```

### Start the System

**Terminal 1 - Lavalink Server:**
```bash
./start.sh
```
Wait for: "Lavalink is ready to accept connections"

**Terminal 2 - Discord Bot:**
```bash
npm install  # First time only
npm start
```

## File Structure

```
lavalink/
├── application.yml          # Lavalink server config (edit this)
├── config.yml              # Bot config (create from example)
├── config.example.yml      # Bot config template
├── Lavalink.jar           # Lavalink server v4.1.2
├── plugins/               # 11 pre-installed plugins
├── src/
│   └── index.js          # Bot code (reads config.yml)
├── package.json          # Node.js dependencies
└── start.sh              # Lavalink startup script
```

## Important Configuration Points

### Passwords Must Match

The Lavalink password must be identical in both files:
- `application.yml` → `lavalink.server.password`
- `config.yml` → `lavalink.password`

### YouTube Authentication (Optional)

Enable in `application.yml`:
```yaml
lavalink:
  server:
    youtubeConfig:
      oauth2:
        enabled: true  # Set to true
```

On first start, Lavalink will show device code authentication.

### Plugin API Keys

Configure once in `application.yml` for Lavalink plugins:
```yaml
plugins:
  lavasrc:
    spotify:
      clientId: "xxx"
      clientSecret: "xxx"
    applemusic:
      mediaAPIToken: "xxx"
    deezer:
      masterDecryptionKey: "xxx"
```

No need to duplicate in `config.yml` unless bot needs direct access.

## Benefits of YAML-Only Configuration

✅ **Centralized** - All settings in YAML files  
✅ **Type-safe** - YAML validates structure  
✅ **Comments** - Easy to document inline  
✅ **Version control friendly** - Clear diffs  
✅ **No environment variables** - Simpler deployment  

## Security

- `.gitignore` excludes `config.yml` (contains secrets)
- Commit `config.example.yml` (template only)
- Keep `application.yml` if no secrets, or exclude it too
- Never commit actual tokens/passwords

## Troubleshooting

### "Failed to load config.yml"
```bash
cp config.example.yml config.yml
nano config.yml  # Add your tokens
```

### "discord.token is required"
Edit `config.yml` and replace placeholder with actual token

### "Connection refused" to Lavalink
Check that:
1. Lavalink is running (`./start.sh`)
2. Passwords match in both config files
3. Port 2333 is correct in both files

### Bot still looking for .env
Make sure you ran `npm install` after updating package.json
