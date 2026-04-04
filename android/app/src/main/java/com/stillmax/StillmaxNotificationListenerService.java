package com.stillmax;

import android.service.notification.NotificationListenerService;
import android.service.notification.StatusBarNotification;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

public class StillmaxNotificationListenerService extends NotificationListenerService {
    private static final Set<String> ACTIVE_NOTIFICATION_PACKAGES =
            ConcurrentHashMap.newKeySet();
    private static final ConcurrentHashMap<String, Integer> NOTIFICATION_COUNTS =
            new ConcurrentHashMap<>();

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
