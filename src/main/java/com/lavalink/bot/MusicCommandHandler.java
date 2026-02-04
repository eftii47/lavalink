package com.lavalink.bot;

import dev.arbjerg.lavalink.client.*;
import dev.arbjerg.lavalink.client.player.*;
import net.dv8tion.jda.api.EmbedBuilder;
import net.dv8tion.jda.api.entities.*;
import net.dv8tion.jda.api.entities.channel.concrete.TextChannel;
import net.dv8tion.jda.api.entities.channel.unions.AudioChannelUnion;
import net.dv8tion.jda.api.events.message.MessageReceivedEvent;
import net.dv8tion.jda.api.hooks.ListenerAdapter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.awt.Color;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.TimeUnit;

public class MusicCommandHandler extends ListenerAdapter {
    private static final Logger logger = LoggerFactory.getLogger(MusicCommandHandler.class);
    private static final String PREFIX = "!";
    
    @Override
    public void onMessageReceived(MessageReceivedEvent event) {
        if (event.getAuthor().isBot() || !event.getMessage().getContentRaw().startsWith(PREFIX)) {
            return;
        }
        
        String[] args = event.getMessage().getContentRaw().substring(PREFIX.length()).split("\\s+");
        String command = args[0].toLowerCase();
        
        try {
            switch (command) {
                case "play":
                case "p":
                    handlePlay(event, args);
                    break;
                case "skip":
                case "s":
                    handleSkip(event);
                    break;
                case "stop":
                    handleStop(event);
                    break;
                case "pause":
                    handlePause(event);
                    break;
                case "volume":
                case "vol":
                    handleVolume(event, args);
                    break;
                case "queue":
                case "q":
                    handleQueue(event);
                    break;
                case "nowplaying":
                case "np":
                    handleNowPlaying(event);
                    break;
                case "disconnect":
                case "leave":
                case "dc":
                    handleDisconnect(event);
                    break;
                case "help":
                case "h":
                    handleHelp(event);
                    break;
            }
        } catch (Exception e) {
            logger.error("Error handling command: {}", command, e);
            event.getChannel().sendMessage("❌ An error occurred while executing the command!").queue();
        }
    }
    
    private void handlePlay(MessageReceivedEvent event, String[] args) {
        Member member = event.getMember();
        if (member == null || member.getVoiceState() == null || !member.getVoiceState().inAudioChannel()) {
            event.getChannel().sendMessage("❌ You need to be in a voice channel!").queue();
            return;
        }
        
        if (args.length < 2) {
            event.getChannel().sendMessage("❌ Please provide a song name or URL!\n**Supported sources:** YouTube, Spotify, Apple Music, Deezer, SoundCloud").queue();
            return;
        }
        
        String query = String.join(" ", Arrays.copyOfRange(args, 1, args.length));
        
        // Get or create player
        LavalinkPlayer player = LavalinkManager.getOrCreatePlayer(event.getGuild().getIdLong());
        
        // Connect to voice channel if not connected
        AudioChannelUnion voiceChannel = member.getVoiceState().getChannel();
        if (player.getNode() == null) {
            event.getGuild().getAudioManager().openAudioConnection(voiceChannel);
        }
        
        event.getChannel().sendMessage("🔍 Searching...").queue(msg -> {
            // Search for tracks
            LavalinkManager.getClient().loadItem(query)
                .thenAccept(item -> {
                    if (item instanceof TrackLoaded) {
                        Track track = ((TrackLoaded) item).getTrack();
                        player.playTrack(track);
                        
                        EmbedBuilder embed = new EmbedBuilder()
                            .setColor(Color.GREEN)
                            .setTitle("✓ Added to Queue")
                            .setDescription("**" + track.getInfo().getTitle() + "**")
                            .addField("Artist", track.getInfo().getAuthor(), true)
                            .addField("Duration", formatDuration(track.getInfo().getLength()), true)
                            .setThumbnail(track.getInfo().getArtworkUrl());
                        
                        msg.editMessage("").setEmbeds(embed.build()).queue();
                        
                    } else if (item instanceof PlaylistLoaded) {
                        PlaylistLoaded playlist = (PlaylistLoaded) item;
                        for (Track track : playlist.getTracks()) {
                            player.playTrack(track);
                        }
                        msg.editMessage("✓ Added playlist: **" + playlist.getInfo().getName() + "** (" + playlist.getTracks().size() + " tracks)").queue();
                        
                    } else {
                        msg.editMessage("❌ No results found!").queue();
                    }
                })
                .exceptionally(throwable -> {
                    logger.error("Error loading track", throwable);
                    msg.editMessage("❌ Error while searching!").queue();
                    return null;
                });
        });
    }
    
    private void handleSkip(MessageReceivedEvent event) {
        LavalinkPlayer player = LavalinkManager.getPlayer(event.getGuild().getIdLong());
        if (player == null || player.getTrack() == null) {
            event.getChannel().sendMessage("❌ Nothing is playing!").queue();
            return;
        }
        
        Track current = player.getTrack();
        player.skip();
        event.getChannel().sendMessage("⏭️ Skipped: **" + current.getInfo().getTitle() + "**").queue();
    }
    
    private void handleStop(MessageReceivedEvent event) {
        LavalinkPlayer player = LavalinkManager.getPlayer(event.getGuild().getIdLong());
        if (player == null) {
            event.getChannel().sendMessage("❌ Nothing is playing!").queue();
            return;
        }
        
        player.setPaused(true);
        player.stopTrack();
        event.getChannel().sendMessage("⏹️ Stopped playback!").queue();
    }
    
    private void handlePause(MessageReceivedEvent event) {
        LavalinkPlayer player = LavalinkManager.getPlayer(event.getGuild().getIdLong());
        if (player == null) {
            event.getChannel().sendMessage("❌ Nothing is playing!").queue();
            return;
        }
        
        boolean paused = player.getPaused();
        player.setPaused(!paused);
        event.getChannel().sendMessage(paused ? "▶️ Resumed playback!" : "⏸️ Paused playback!").queue();
    }
    
    private void handleVolume(MessageReceivedEvent event, String[] args) {
        LavalinkPlayer player = LavalinkManager.getPlayer(event.getGuild().getIdLong());
        if (player == null) {
            event.getChannel().sendMessage("❌ Nothing is playing!").queue();
            return;
        }
        
        if (args.length < 2) {
            event.getChannel().sendMessage("🔊 Current volume: **" + player.getVolume() + "%**\nUsage: `!volume <0-200>`").queue();
            return;
        }
        
        try {
            int volume = Integer.parseInt(args[1]);
            if (volume < 0 || volume > 200) {
                event.getChannel().sendMessage("❌ Volume must be between 0 and 200!").queue();
                return;
            }
            
            player.setVolume(volume);
            event.getChannel().sendMessage("🔊 Volume set to **" + volume + "%**").queue();
        } catch (NumberFormatException e) {
            event.getChannel().sendMessage("❌ Invalid volume value!").queue();
        }
    }
    
    private void handleQueue(MessageReceivedEvent event) {
        LavalinkPlayer player = LavalinkManager.getPlayer(event.getGuild().getIdLong());
        if (player == null || player.getTrack() == null) {
            event.getChannel().sendMessage("❌ Nothing is playing!").queue();
            return;
        }
        
        Track current = player.getTrack();
        EmbedBuilder embed = new EmbedBuilder()
            .setColor(Color.GREEN)
            .setTitle("🎵 Queue")
            .setDescription("**Now Playing:**\n" + current.getInfo().getTitle() + "\n" + current.getInfo().getAuthor());
        
        event.getChannel().sendMessageEmbeds(embed.build()).queue();
    }
    
    private void handleNowPlaying(MessageReceivedEvent event) {
        LavalinkPlayer player = LavalinkManager.getPlayer(event.getGuild().getIdLong());
        if (player == null || player.getTrack() == null) {
            event.getChannel().sendMessage("❌ Nothing is playing!").queue();
            return;
        }
        
        Track track = player.getTrack();
        long position = player.getPosition();
        long duration = track.getInfo().getLength();
        
        EmbedBuilder embed = new EmbedBuilder()
            .setColor(Color.GREEN)
            .setTitle("♫ Now Playing")
            .setDescription("**" + track.getInfo().getTitle() + "**")
            .addField("Artist", track.getInfo().getAuthor(), true)
            .addField("Duration", formatDuration(position) + " / " + formatDuration(duration), true)
            .addField("Volume", player.getVolume() + "%", true)
            .setThumbnail(track.getInfo().getArtworkUrl());
        
        event.getChannel().sendMessageEmbeds(embed.build()).queue();
    }
    
    private void handleDisconnect(MessageReceivedEvent event) {
        event.getGuild().getAudioManager().closeAudioConnection();
        event.getChannel().sendMessage("👋 Disconnected from voice channel!").queue();
    }
    
    private void handleHelp(MessageReceivedEvent event) {
        EmbedBuilder embed = new EmbedBuilder()
            .setColor(Color.GREEN)
            .setTitle("🎵 Music Bot Commands")
            .setDescription("Powered by Lavalink v4 with Java")
            .addField("▶️ Playback", "`!play <song>` - Play a song\n`!pause` - Pause/Resume\n`!skip` - Skip current song\n`!stop` - Stop playback", false)
            .addField("🎚️ Controls", "`!volume <0-200>` - Set volume", false)
            .addField("📋 Information", "`!queue` - Show queue\n`!nowplaying` - Current song\n`!disconnect` - Leave voice", false)
            .addField("🎵 Supported Sources", "YouTube, Spotify, Apple Music, Deezer, SoundCloud, Bandcamp", false)
            .setFooter("Use ! before each command");
        
        event.getChannel().sendMessageEmbeds(embed.build()).queue();
    }
    
    private String formatDuration(long ms) {
        long seconds = ms / 1000;
        long minutes = seconds / 60;
        long hours = minutes / 60;
        
        if (hours > 0) {
            return String.format("%d:%02d:%02d", hours, minutes % 60, seconds % 60);
        }
        return String.format("%d:%02d", minutes, seconds % 60);
    }
}
