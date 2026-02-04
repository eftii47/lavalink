package com.lavalink.bot;

import net.dv8tion.jda.api.JDA;
import net.dv8tion.jda.api.JDABuilder;
import net.dv8tion.jda.api.entities.Activity;
import net.dv8tion.jda.api.requests.GatewayIntent;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.EnumSet;

public class MusicBot {
    private static final Logger logger = LoggerFactory.getLogger(MusicBot.class);
    
    public static void main(String[] args) {
        logger.info("========================================");
        logger.info("  Starting Lavalink Music Bot");
        logger.info("========================================");
        
        // Load configuration
        Config config = Config.load();
        
        if (config.getDiscordToken() == null || config.getDiscordToken().equals("your_discord_bot_token_here")) {
            logger.error("Discord token not configured in config.yml!");
            logger.error("Please edit config.yml and add your bot token.");
            System.exit(1);
        }
        
        try {
            // Build JDA
            JDA jda = JDABuilder.create(
                    config.getDiscordToken(),
                    EnumSet.of(
                        GatewayIntent.GUILD_MESSAGES,
                        GatewayIntent.GUILD_VOICE_STATES,
                        GatewayIntent.MESSAGE_CONTENT
                    )
                )
                .setActivity(Activity.listening("!help"))
                .addEventListeners(new MusicCommandHandler())
                .build();
            
            jda.awaitReady();
            
            logger.info("========================================");
            logger.info("✓ Bot logged in as: {}", jda.getSelfUser().getAsTag());
            logger.info("✓ Connected to {} guilds", jda.getGuilds().size());
            logger.info("✓ Using Lavalink v4 with plugins");
            logger.info("========================================");
            
            // Initialize Lavalink
            LavalinkManager.initialize(jda, config);
            
        } catch (Exception e) {
            logger.error("Failed to start bot", e);
            System.exit(1);
        }
    }
}
