import org.yaml.snakeyaml.Yaml;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Map;

public class Config {
    private static final Logger logger = LoggerFactory.getLogger(Config.class);
    
    private String discordToken;
    private String discordClientId;
    private String lavalinkHost;
    private int lavalinkPort;
    private String lavalinkPassword;
    private boolean lavalinkSecure;
    
    public static Config load() {
        Config config = new Config();
        
        try {
            File configFile = new File("config.yml");
            if (!configFile.exists()) {
                logger.error("config.yml not found!");
                logger.error("Please create config.yml from config.example.yml");
                System.exit(1);
            }
            
            Yaml yaml = new Yaml();
            InputStream inputStream = new FileInputStream(configFile);
            Map<String, Object> data = yaml.load(inputStream);
            
            // Parse Discord config
            Map<String, String> discord = (Map<String, String>) data.get("discord");
            if (discord != null) {
                config.discordToken = discord.get("token");
                config.discordClientId = discord.get("clientId");
            }
            
            // Parse Lavalink config
            Map<String, Object> lavalink = (Map<String, Object>) data.get("lavalink");
            if (lavalink != null) {
                config.lavalinkHost = (String) lavalink.getOrDefault("host", "localhost");
                config.lavalinkPort = (Integer) lavalink.getOrDefault("port", 2333);
                config.lavalinkPassword = (String) lavalink.getOrDefault("password", "youshallnotpass");
                config.lavalinkSecure = (Boolean) lavalink.getOrDefault("secure", false);
            }
            
            inputStream.close();
            logger.info("✓ Configuration loaded from config.yml");
            
        } catch (Exception e) {
            logger.error("Failed to load config.yml", e);
            System.exit(1);
        }
        
        return config;
    }
    
    public String getDiscordToken() {
        return discordToken;
    }
    
    public String getDiscordClientId() {
        return discordClientId;
    }
    
    public String getLavalinkHost() {
        return lavalinkHost;
    }
    
    public int getLavalinkPort() {
        return lavalinkPort;
    }
    
    public String getLavalinkPassword() {
        return lavalinkPassword;
    }
    
    public boolean isLavalinkSecure() {
        return lavalinkSecure;
    }
}
