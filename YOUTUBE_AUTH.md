# YouTube Authentication Setup Guide

YouTube frequently rate limits and blocks Lavalink servers. Using authentication can help avoid these issues.

## Option 1: OAuth2 Device Code Flow (Recommended)

This is the **most secure and modern method** that doesn't require storing your password.

### How It Works:

When you enable OAuth2 and start Lavalink for the first time, it will:
1. Display a URL and a device code in the console
2. You visit the URL in your browser
3. Enter the code shown
4. Authorize the application
5. Lavalink automatically saves the refresh token

### Steps:

1. Open `application.yml`
2. Find the `youtubeConfig` section under `lavalink.server`
3. Enable OAuth2:

```yaml
youtubeConfig:
  oauth2:
    enabled: true
```

4. Start Lavalink:
```bash
./start.sh
```

5. Watch the console output - you'll see something like:
```
┌───────────────────────────────────────────────────┐
│ YouTube OAuth2 Authentication Required           │
│                                                   │
│ Visit: https://www.google.com/device             │
│ Enter code: ABCD-EFGH                            │
│                                                   │
│ Waiting for authorization...                     │
└───────────────────────────────────────────────────┘
```

6. Open the URL in your browser
7. Enter the code displayed
8. Authorize the application
9. The refresh token is saved automatically - you won't need to do this again!

### Important Notes:

- ✅ **No passwords stored** - More secure than email/password
- ✅ **One-time setup** - Refresh token is saved for future use
- ✅ **2FA compatible** - Works seamlessly with 2-Factor Authentication
- ✅ **Easy revocation** - Revoke access anytime from Google Account settings
- ⚠️ Token is stored in Lavalink's data directory - keep it secure

## Verifying Authentication

After authenticating, check the Lavalink logs:

```bash
tail -f logs/lavalink.log
```

You should see:
```
✓ YouTube OAuth2 authentication successful
✓ Refresh token saved
```

## Option 2: IP Rotation

If you have multiple IP addresses available, you can configure rotation:

```yaml
ratelimit:
  ipBlocks: 
    - "203.0.113.0/24"  # Your IP block
  strategy: "RotateOnBan"
  searchTriggersFail: true
  retryLimit: -1
```

**Strategies:**
- `RotateOnBan` - Switch IP when current one is banned
- `LoadBalance` - Distribute requests evenly
- `NanoSwitch` - Fast switching between IPs
- `RotatingNanoSwitch` - Combination of rotating and nano

## Option 3: HTTP Proxy

Route traffic through a proxy server (like Squid):

```yaml
httpConfig:
  proxyHost: "proxy.example.com"
  proxyPort: 3128
  proxyUser: "username"  # Optional
  proxyPassword: "password"  # Optional
```

### Setting up Squid Proxy:

```bash
# Install Squid
sudo apt-get install squid

# Configure Squid
sudo nano /etc/squid/squid.conf

# Add:
http_port 3128
http_access allow all

# Restart Squid
sudo systemctl restart squid
```

## Testing Your Setup

After configuring authentication:

1. Restart Lavalink:
   ```bash
   ./start.sh
   ```

2. Check logs for errors:
   ```bash
   tail -f logs/lavalink.log
   ```

3. Test with bot:
   ```
   !play never gonna give you up
   ```

## Troubleshooting

### OAuth2 authentication not showing
- Ensure `oauth2.enabled: true` in application.yml
- Restart Lavalink completely
- Check that you're using Lavalink v4.1.2 or higher

### "Token expired" error
- Delete the saved token (usually in Lavalink data directory)
- Restart Lavalink to re-authenticate
- Complete the device code flow again

### Device code expired
- Device codes expire after 5-10 minutes
- If you see "Code expired", restart Lavalink to get a new code
- Complete the authorization faster next time

### Still getting rate limited
- Try combining authentication with IP rotation
- Consider using a proxy
- Reduce `youtubePlaylistLoadLimit` in application.yml

### "Login required" errors
- YouTube may have changed their authentication method
- Check Lavalink GitHub for updates
- Consider using OAuth2 (check plugin documentation)

## Security Best Practices

1. **OAuth2 is preferred** - No passwords stored on server
2. **Protect token files** - Keep Lavalink data directory secure
3. **Revoke when needed** - Visit [Google Account Permissions](https://myaccount.google.com/permissions) to revoke
4. **Monitor logs** - Watch for failed authentication attempts
5. **Use dedicated account** - Consider using a separate Google account for bot
6. **Regular audits** - Check authorized applications periodically

## Alternative: YouTube Plugin

The workspace includes `youtube-plugin-1.17.0.jar` which provides enhanced YouTube support with better rate limit handling. It's already loaded and configured!

## Need Help?

- Check Lavalink logs in `/logs/` directory
- Visit [Lavalink GitHub Issues](https://github.com/lavalink-devs/Lavalink/issues)
- Review YouTube plugin documentation

---

**Remember:** After any configuration changes, restart Lavalink for changes to take effect!
