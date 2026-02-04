package com.lavalink.bot;

import dev.arbjerg.lavalink.client.*;
import dev.arbjerg.lavalink.client.player.*;
import net.dv8tion.jda.api.JDA;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.net.URI;

public class LavalinkManager {
    private static final Logger logger = LoggerFactory.getLogger(LavalinkManager.class);
    private static LavalinkClient lavalinkClient;
    
    public static void initialize(JDA jda, Config config) {
        try {
            // Create Lavalink client
            lavalinkClient = new LavalinkClient(
                jda.getSelfUser().getIdLong()
            );
            
            // Add Lavalink node
            lavalinkClient.addNode(
                config.getLavalinkHost(),
                config.getLavalinkPort(),
                config.getLavalinkPassword(),
                config.isLavalinkSecure()
            );
            
            // Add event listeners
            lavalinkClient.on(lavalinkClient.getNodes().get(0))
                .subscribe(event -> {
                    if (event instanceof NodeReadyEvent) {
                        logger.info("✓ Lavalink node connected: {}", config.getLavalinkHost());
                    } else if (event instanceof NodeDisconnectedEvent) {
                        logger.warn("✗ Lavalink node disconnected");
                    }
                });
            
            logger.info("✓ Lavalink client initialized");
            
        } catch (Exception e) {
            logger.error("Failed to initialize Lavalink", e);
        }
    }
    
    public static LavalinkClient getClient() {
        return lavalinkClient;
    }
    
    public static LavalinkPlayer getPlayer(long guildId) {
        return lavalinkClient.getPlayer(guildId);
    }
    
    public static LavalinkPlayer getOrCreatePlayer(long guildId) {
        return lavalinkClient.getOrCreatePlayer(guildId);
    }
}
