package com.stillmax;

import android.content.ComponentName;
import android.content.Context;
import android.graphics.Bitmap;
import android.media.MediaMetadata;
import android.media.session.MediaController;
import android.media.session.MediaSessionManager;
import android.media.session.PlaybackState;
import android.service.notification.NotificationListenerService;
import android.service.notification.StatusBarNotification;

import java.io.ByteArrayOutputStream;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

public class StillmaxNotificationListenerService extends NotificationListenerService {
    private static StillmaxNotificationListenerService instance;
    private static final Set<String> ACTIVE_NOTIFICATION_PACKAGES =
            ConcurrentHashMap.newKeySet();
    private static final ConcurrentHashMap<String, Integer> NOTIFICATION_COUNTS =
            new ConcurrentHashMap<>();
    private static int lastAlbumArtGenerationId = -1;
    private static int lastAlbumArtWidth = -1;
    private static int lastAlbumArtHeight = -1;
    private static String lastAlbumArtMetadataKey = null;
    private static byte[] cachedAlbumArtBytes = null;

    @Override
    public void onCreate() {
        super.onCreate();
        instance = this;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        instance = null;
        getCachedAlbumArtBytes(null, null);
    }

    private static synchronized byte[] getCachedAlbumArtBytes(Bitmap albumArt, String metadataKey) {
        if (albumArt == null) {
            lastAlbumArtGenerationId = -1;
            lastAlbumArtWidth = -1;
            lastAlbumArtHeight = -1;
            lastAlbumArtMetadataKey = null;
            cachedAlbumArtBytes = null;
            return null;
        }

        int generationId = albumArt.getGenerationId();
        int width = albumArt.getWidth();
        int height = albumArt.getHeight();

        if (cachedAlbumArtBytes != null
                && generationId == lastAlbumArtGenerationId
                && width == lastAlbumArtWidth
                && height == lastAlbumArtHeight
                && Objects.equals(metadataKey, lastAlbumArtMetadataKey)) {
            return cachedAlbumArtBytes;
        }

        ByteArrayOutputStream stream = new ByteArrayOutputStream();
        albumArt.compress(Bitmap.CompressFormat.PNG, 80, stream);
        cachedAlbumArtBytes = stream.toByteArray();
        lastAlbumArtGenerationId = generationId;
        lastAlbumArtWidth = width;
        lastAlbumArtHeight = height;
        lastAlbumArtMetadataKey = metadataKey;
        return cachedAlbumArtBytes;
    }

    public static Map<String, Object> getActiveMediaSession(Context context) {
        Map<String, Object> result = new HashMap<>();
        result.put("isPlaying", false);

        if (instance == null) {
            return result;
        }

        try {
            MediaSessionManager mediaSessionManager =
                    (MediaSessionManager) context.getSystemService(Context.MEDIA_SESSION_SERVICE);
            if (mediaSessionManager == null) {
                return result;
            }

            ComponentName componentName = new ComponentName(context, StillmaxNotificationListenerService.class);
            List<MediaController> controllers = mediaSessionManager.getActiveSessions(componentName);

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

            boolean isPlaying = playbackState != null
                    && playbackState.getState() == PlaybackState.STATE_PLAYING;

            result.put("trackName", trackName != null ? trackName : "Unknown");
            result.put("artistName", artistName != null ? artistName : "Unknown Artist");
            result.put("isPlaying", isPlaying);
            result.put("packageName", controller.getPackageName());

            String metadataKey = controller.getPackageName() + "|"
                    + (trackName != null ? trackName : "") + "|"
                    + (artistName != null ? artistName : "");

            if (albumArt != null) {
                byte[] albumArtBytes = getCachedAlbumArtBytes(albumArt, metadataKey);
                if (albumArtBytes != null) {
                    result.put("albumArt", albumArtBytes);
                }
            } else {
                getCachedAlbumArtBytes(null, null);
            }
        } catch (SecurityException e) {
            result.put("error", "notification_access_required");
        } catch (Exception e) {
            result.put("error", e.getMessage());
        }

        return result;
    }

    public static void sendMediaAction(Context context, String action) {
        if (instance == null) {
            return;
        }

        try {
            MediaSessionManager mediaSessionManager =
                    (MediaSessionManager) context.getSystemService(Context.MEDIA_SESSION_SERVICE);
            if (mediaSessionManager == null) {
                return;
            }

            ComponentName componentName = new ComponentName(context, StillmaxNotificationListenerService.class);
            List<MediaController> controllers = mediaSessionManager.getActiveSessions(componentName);

            if (controllers.isEmpty()) {
                return;
            }

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
        } catch (Exception ignored) {
        }
    }

    public static Set<String> getActiveNotificationPackagesSnapshot() {
        return new HashSet<>(ACTIVE_NOTIFICATION_PACKAGES);
    }

    public static Map<String, Integer> getNotificationCountsSnapshot() {
        return new HashMap<>(NOTIFICATION_COUNTS);
    }

    private void updateCounts() {
        NOTIFICATION_COUNTS.clear();
        StatusBarNotification[] active = getActiveNotifications();
        if (active == null) return;
        for (StatusBarNotification notification : active) {
            String pkg = notification.getPackageName();
            if (pkg != null) {
                NOTIFICATION_COUNTS.put(pkg, NOTIFICATION_COUNTS.getOrDefault(pkg, 0) + 1);
            }
        }
    }

    @Override
    public void onListenerConnected() {
        super.onListenerConnected();
        ACTIVE_NOTIFICATION_PACKAGES.clear();
        StatusBarNotification[] active = getActiveNotifications();
        if (active == null) return;
        for (StatusBarNotification notification : active) {
            if (notification.getPackageName() != null) {
                ACTIVE_NOTIFICATION_PACKAGES.add(notification.getPackageName());
            }
        }
        updateCounts();
    }

    @Override
    public void onNotificationPosted(StatusBarNotification sbn) {
        if (sbn.getPackageName() != null) {
            ACTIVE_NOTIFICATION_PACKAGES.add(sbn.getPackageName());
        }
        updateCounts();
    }

    @Override
    public void onNotificationRemoved(StatusBarNotification sbn) {
        if (sbn.getPackageName() != null) {
            ACTIVE_NOTIFICATION_PACKAGES.remove(sbn.getPackageName());
        }
        updateCounts();
    }
}
