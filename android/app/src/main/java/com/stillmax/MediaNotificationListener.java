package com.stillmax;

import android.app.Notification;
import android.content.ComponentName;
import android.content.Context;
import android.graphics.Bitmap;
import android.media.MediaMetadata;
import android.media.session.MediaController;
import android.media.session.MediaSession;
import android.media.session.MediaSessionManager;
import android.media.session.PlaybackState;
import android.os.Build;
import android.service.notification.NotificationListenerService;
import android.service.notification.StatusBarNotification;

import java.io.ByteArrayOutputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MediaNotificationListener extends NotificationListenerService {
    
    private static MediaNotificationListener instance;
    private MediaSessionManager mediaSessionManager;
    
    @Override
    public void onCreate() {
        super.onCreate();
        instance = this;
        mediaSessionManager = (MediaSessionManager) getSystemService(Context.MEDIA_SESSION_SERVICE);
    }
    
    @Override
    public void onDestroy() {
        super.onDestroy();
        instance = null;
    }
    
    public static MediaNotificationListener getInstance() {
        return instance;
    }
    
    public static Map<String, Object> getActiveMediaSession(Context context) {
        Map<String, Object> result = new HashMap<>();
        result.put("isPlaying", false);
        
        if (instance == null) {
            return result;
        }
        
        try {
            MediaSessionManager msm = (MediaSessionManager) context.getSystemService(Context.MEDIA_SESSION_SERVICE);
            ComponentName cn = new ComponentName(context, MediaNotificationListener.class);
            List<MediaController> controllers = msm.getActiveSessions(cn);
            
            if (controllers.isEmpty()) {
                return result;
            }
            
            MediaController controller = controllers.get(0);
            MediaMetadata metadata = controller.getMetadata();
            PlaybackState playbackState = controller.getPlaybackState();
            
            if (metadata == null) {
                return result;
            }
            
            String trackName = metadata.getString(MediaMetadata.METADATA_KEY_TITLE);
            String artistName = metadata.getString(MediaMetadata.METADATA_KEY_ARTIST);
            if (artistName == null) {
                artistName = metadata.getString(MediaMetadata.METADATA_KEY_ALBUM_ARTIST);
            }
            Bitmap albumArt = metadata.getBitmap(MediaMetadata.METADATA_KEY_ALBUM_ART);
            if (albumArt == null) {
                albumArt = metadata.getBitmap(MediaMetadata.METADATA_KEY_ART);
            }
            
            boolean isPlaying = playbackState != null && 
                playbackState.getState() == PlaybackState.STATE_PLAYING;
            
            result.put("trackName", trackName != null ? trackName : "Unknown");
            result.put("artistName", artistName != null ? artistName : "Unknown Artist");
            result.put("isPlaying", isPlaying);
            result.put("packageName", controller.getPackageName());
            
            if (albumArt != null) {
                ByteArrayOutputStream stream = new ByteArrayOutputStream();
                albumArt.compress(Bitmap.CompressFormat.PNG, 80, stream);
                result.put("albumArt", stream.toByteArray());
            }
            
        } catch (SecurityException e) {
            // Notification listener not enabled
            result.put("error", "notification_access_required");
        } catch (Exception e) {
            result.put("error", e.getMessage());
        }
        
        return result;
    }
    
    public static void sendMediaAction(Context context, String action) {
        if (instance == null) return;
        
        try {
            MediaSessionManager msm = (MediaSessionManager) context.getSystemService(Context.MEDIA_SESSION_SERVICE);
            ComponentName cn = new ComponentName(context, MediaNotificationListener.class);
            List<MediaController> controllers = msm.getActiveSessions(cn);
            
            if (controllers.isEmpty()) return;
            
            MediaController controller = controllers.get(0);
            MediaController.TransportControls controls = controller.getTransportControls();
            
            switch (action) {
                case "play":
                    controls.play();
                    break;
                case "pause":
                    controls.pause();
                    break;
                case "next":
                    controls.skipToNext();
                    break;
                case "previous":
                    controls.skipToPrevious();
                    break;
                case "playPause":
                    PlaybackState state = controller.getPlaybackState();
                    if (state != null && state.getState() == PlaybackState.STATE_PLAYING) {
                        controls.pause();
                    } else {
                        controls.play();
                    }
                    break;
            }
        } catch (Exception e) {
            // Ignore errors
        }
    }
    
    @Override
    public void onNotificationPosted(StatusBarNotification sbn) {
        // Not needed for our use case
    }
    
    @Override
    public void onNotificationRemoved(StatusBarNotification sbn) {
        // Not needed for our use case
    }
}
