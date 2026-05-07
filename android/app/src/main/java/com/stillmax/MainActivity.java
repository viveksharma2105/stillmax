package com.stillmax;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.WallpaperManager;
import android.appwidget.AppWidgetHost;
import android.appwidget.AppWidgetHostView;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProviderInfo;
import android.bluetooth.BluetoothAdapter;
import android.content.ComponentName;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.ApplicationInfo;
import android.content.pm.LauncherActivityInfo;
import android.content.pm.LauncherApps;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.hardware.camera2.CameraAccessException;
import android.hardware.camera2.CameraManager;
import android.location.Address;
import android.location.Geocoder;
import android.location.Location;
import android.location.LocationManager;
import android.net.Uri;
import android.net.wifi.WifiManager;
import android.os.BatteryManager;
import android.os.Build;
import android.os.Looper;
import android.os.Process;
import android.os.UserHandle;
import android.os.UserManager;
import android.provider.Settings;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat;

import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationCallback;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationResult;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.location.Priority;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Locale;
import java.util.Set;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.RejectedExecutionException;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class MainActivity extends FlutterActivity {
    private static final String METHOD_CHANNEL = "com.stillmax/app_service";
    private static final String EVENTS_CHANNEL = "com.stillmax/app_events";
    private static final String WIDGET_VIEW_TYPE = "com.stillmax/widget_view";
    private static final int APP_WIDGET_HOST_ID = 1024;
    private static final int REQUEST_BIND_APPWIDGET = 7101;
    private static final int REQUEST_CONFIGURE_APPWIDGET = 7102;
    private static final int REQUEST_POST_NOTIFICATIONS = 7103;
    private static final int REQUEST_LOCATION_PERMISSION = 7104;
    private static final int INVALID_APP_WIDGET_ID = -1;
    private static final int WALLPAPER_PREVIEW_MAX_DIMENSION = 1440;
    private static final int WALLPAPER_MAX_BYTES = 8 * 1024 * 1024;
    private static final long MAX_LAST_LOCATION_AGE_MS = 2 * 60 * 1000L;
    private static final float MAX_FINE_LOCATION_ACCURACY_METERS = 120f;
    private static final float MAX_COARSE_LOCATION_ACCURACY_METERS = 3000f;

    private EventChannel.EventSink appEventsSink;
    private EventChannel.EventSink homeEventSink;
    private BroadcastReceiver packageBroadcastReceiver;
    private AppWidgetHost appWidgetHost;
    private AppWidgetManager appWidgetManager;
    private MethodChannel.Result pendingBindResult;
    private MethodChannel.Result pendingNotificationPermissionResult;
    private MethodChannel.Result pendingLocationPermissionResult;
    private int pendingWidgetId = INVALID_APP_WIDGET_ID;
    private AppWidgetProviderInfo pendingProviderInfo;
    private boolean widgetViewFactoryRegistered = false;
    private final ExecutorService wallpaperExecutor = Executors.newSingleThreadExecutor();

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), EVENTS_CHANNEL)
                .setStreamHandler(new EventChannel.StreamHandler() {
                    @Override
                    public void onListen(Object arguments, EventChannel.EventSink events) {
                        appEventsSink = events;
                    }

                    @Override
                    public void onCancel(Object arguments) {
                        appEventsSink = null;
                    }
                });

        new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "com.stillmax/home_events")
                .setStreamHandler(new EventChannel.StreamHandler() {
                    @Override
                    public void onListen(Object arguments, EventChannel.EventSink events) {
                        homeEventSink = events;
                    }

                    @Override
                    public void onCancel(Object arguments) {
                        homeEventSink = null;
                    }
                });

        registerPackageChangeReceiver();

        ensureAppWidgetHost();
        if (!widgetViewFactoryRegistered) {
            flutterEngine
                    .getPlatformViewsController()
                    .getRegistry()
                    .registerViewFactory(WIDGET_VIEW_TYPE, new WidgetViewFactory());
            widgetViewFactoryRegistered = true;
        }

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), METHOD_CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    switch (call.method) {
                        case "getInstalledApps":
                            getInstalledApps(result);
                            break;
                        case "launchApp":
                            launchApp(call.arguments, result);
                            break;
                        case "launchAppHidden":
                            launchAppHidden(call.arguments, result);
                            break;
                        case "setWallpaper":
                            setWallpaper(call.argument("imagePath"), result);
                            break;
                        case "getBatteryInfo":
                            getBatteryInfo(result);
                            break;
                        case "setWallpaperFromPath":
                            setWallpaperFromPath(call.argument("path"), result);
                            break;
                        case "openAppInfo":
                            openAppInfo(call.arguments, result);
                            break;
                        case "uninstallApp":
                            uninstallApp(call.arguments, result);
                            break;
                        case "resetWallpaperToDefault":
                            resetWallpaperToDefault(result);
                            break;
                        case "expandStatusBar":
                            expandStatusBar(result);
                            break;
                        case "getWallpaperBytes":
                            getWallpaperBytes(result);
                            break;
                        case "getNotificationPackages":
                            getNotificationPackages(result);
                            break;
                        case "getInstalledIconPacks":
                            getInstalledIconPacks(result);
                            break;
                        case "getIconFromPack":
                            getIconFromPack(
                                call.argument("iconPackPackage"),
                                call.argument("appPackage"),
                                result
                            );
                            break;
                        case "toggleWifi":
                            toggleWifi(call.argument("enable"), result);
                            break;
                        case "toggleBluetooth":
                            toggleBluetooth(call.argument("enable"), result);
                            break;
                        case "toggleFlashlight":
                            toggleFlashlight(call.argument("enable"), result);
                            break;
                        case "setBrightness":
                            setBrightness(call.argument("level"), result);
                            break;
                        case "getQuickSettings":
                            getQuickSettings(result);
                            break;
                        case "getNotificationCounts":
                            getNotificationCounts(result);
                            break;
                        case "getDeviceLocation":
                            getDeviceLocation(result);
                            break;
                        case "getLocationName":
                            getLocationName(call.argument("latitude"), call.argument("longitude"), result);
                            break;
                        case "getAvailableWidgets":
                            getAvailableWidgets(result);
                            break;
                        case "allocateWidgetId":
                            allocateWidgetId(result);
                            break;
                        case "bindWidget":
                            bindWidget(
                                    call.argument("appWidgetId"),
                                    call.argument("packageName"),
                                    call.argument("className"),
                                    result
                            );
                            break;
                        case "deleteWidgetId":
                            deleteWidgetId(call.argument("appWidgetId"), result);
                            break;
                        case "createWidgetView":
                            createWidgetView(call.argument("appWidgetId"), result);
                            break;
                        case "getActiveMediaSession":
                            Map<String, Object> mediaData = StillmaxNotificationListenerService.getActiveMediaSession(this);
                            result.success(mediaData);
                            break;
                        case "sendMediaAction":
                            String action = call.argument("action");
                            StillmaxNotificationListenerService.sendMediaAction(this, action);
                            result.success(null);
                            break;
                        case "openNotificationListenerSettings":
                            Intent intent = new Intent("android.settings.ACTION_NOTIFICATION_LISTENER_SETTINGS");
                            startActivity(intent);
                            result.success(null);
                            break;
                        case "requestNotificationPermission":
                            requestNotificationPermission(result);
                            break;
                        case "requestLocationPermission":
                            requestLocationPermission(result);
                            break;
                        case "isNotificationListenerEnabled":
                            result.success(isNotificationListenerEnabled());
                            break;
                        default:
                            result.notImplemented();
                            break;
                    }
                });
    }

    private void requestNotificationPermission(MethodChannel.Result result) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
            result.success(true);
            return;
        }

        if (ContextCompat.checkSelfPermission(this, Manifest.permission.POST_NOTIFICATIONS)
                == PackageManager.PERMISSION_GRANTED) {
            result.success(true);
            return;
        }

        if (pendingNotificationPermissionResult != null) {
            result.error("PERMISSION_IN_PROGRESS", "Notification permission request already in progress", null);
            return;
        }

        pendingNotificationPermissionResult = result;
        requestPermissions(new String[]{Manifest.permission.POST_NOTIFICATIONS}, REQUEST_POST_NOTIFICATIONS);
    }

    private void requestLocationPermission(MethodChannel.Result result) {
        final boolean hasFine = ContextCompat.checkSelfPermission(
                this,
                Manifest.permission.ACCESS_FINE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED;
        final boolean hasCoarse = ContextCompat.checkSelfPermission(
                this,
                Manifest.permission.ACCESS_COARSE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED;

        if (hasFine) {
            result.success(true);
            return;
        }

        if (pendingLocationPermissionResult != null) {
            result.error("PERMISSION_IN_PROGRESS", "Location permission request already in progress", null);
            return;
        }

        if (hasCoarse) {
            pendingLocationPermissionResult = result;
            requestPermissions(
                    new String[]{Manifest.permission.ACCESS_FINE_LOCATION},
                    REQUEST_LOCATION_PERMISSION
            );
            return;
        }

        pendingLocationPermissionResult = result;
        requestPermissions(
                new String[]{
                        Manifest.permission.ACCESS_FINE_LOCATION,
                        Manifest.permission.ACCESS_COARSE_LOCATION
                },
                REQUEST_LOCATION_PERMISSION
        );
    }

    private boolean isNotificationListenerEnabled() {
        try {
            String enabledListeners = Settings.Secure.getString(
                    getContentResolver(),
                    "enabled_notification_listeners"
            );
            if (enabledListeners == null || enabledListeners.trim().isEmpty()) {
                return false;
            }

            String myPackage = getPackageName();
            String[] listeners = enabledListeners.split(":");
            for (String flattened : listeners) {
                if (TextUtils.isEmpty(flattened)) {
                    continue;
                }

                ComponentName componentName = ComponentName.unflattenFromString(flattened);
                if (componentName != null && myPackage.equals(componentName.getPackageName())) {
                    return true;
                }
            }
        } catch (Exception ignored) {
        }

        return false;
    }

    private void getBatteryInfo(MethodChannel.Result result) {
        IntentFilter filter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
        Intent batteryStatus = registerReceiver(null, filter);
        int level = 100;
        boolean charging = false;
        if (batteryStatus != null) {
            int rawLevel = batteryStatus.getIntExtra(BatteryManager.EXTRA_LEVEL, -1);
            int scale = batteryStatus.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
            int status = batteryStatus.getIntExtra(BatteryManager.EXTRA_STATUS, -1);
            level = (rawLevel >= 0 && scale > 0) ? (rawLevel * 100 / scale) : 100;
            charging = status == BatteryManager.BATTERY_STATUS_CHARGING || status == BatteryManager.BATTERY_STATUS_FULL;
        }
        Map<String, Object> payload = new HashMap<>();
        payload.put("level", level);
        payload.put("charging", charging);
        result.success(payload);
    }

    private void setWallpaperFromPath(String path, MethodChannel.Result result) {
        setWallpaper(path, result);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (packageBroadcastReceiver != null) {
            try {
                unregisterReceiver(packageBroadcastReceiver);
            } catch (IllegalArgumentException ignored) {
            }
            packageBroadcastReceiver = null;
        }
        if (appWidgetHost != null) {
            appWidgetHost.stopListening();
        }
        clearPendingBind("cancelled");
        wallpaperExecutor.shutdown();
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (appWidgetHost != null) {
            appWidgetHost.startListening();
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        if (appWidgetHost != null) {
            appWidgetHost.stopListening();
        }
    }

    @Override
    protected void onStart() {
        super.onStart();
        ensureAppWidgetHost();
    }

    @Override
    protected void onStop() {
        super.onStop();
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        if (intent != null && intent.hasCategory(Intent.CATEGORY_HOME)) {
            if (homeEventSink != null) {
                homeEventSink.success("home_pressed");
            }
        }
    }

    private void registerPackageChangeReceiver() {
        if (packageBroadcastReceiver != null) {
            return;
        }

        packageBroadcastReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                if (appEventsSink == null || intent == null) {
                    return;
                }

                String action = intent.getAction();
                Uri data = intent.getData();
                String packageName = data != null ? data.getSchemeSpecificPart() : "";

                Map<String, Object> payload = new HashMap<>();
                payload.put("type", "packages_changed");
                payload.put("action", action != null ? action : "");
                payload.put("packageName", packageName != null ? packageName : "");

                UserHandle changedUser = extractUserHandleFromIntent(intent);
                if (changedUser != null) {
                    payload.put("userSerial", getUserSerial(changedUser));
                }
                appEventsSink.success(payload);
            }
        };

        IntentFilter filter = new IntentFilter();
        filter.addAction(Intent.ACTION_PACKAGE_ADDED);
        filter.addAction(Intent.ACTION_PACKAGE_REMOVED);
        filter.addAction(Intent.ACTION_PACKAGE_REPLACED);
        filter.addDataScheme("package");

        registerReceiver(packageBroadcastReceiver, filter);
    }

    private void ensureAppWidgetHost() {
        if (appWidgetManager == null) {
            appWidgetManager = AppWidgetManager.getInstance(this);
        }
        if (appWidgetHost == null) {
            appWidgetHost = new StillmaxAppWidgetHost(this, APP_WIDGET_HOST_ID);
        }
    }

    @SuppressLint("MissingPermission")
    private void getDeviceLocation(MethodChannel.Result result) {
        try {
            final boolean hasCoarse = ContextCompat.checkSelfPermission(
                    this,
                    Manifest.permission.ACCESS_COARSE_LOCATION
            ) == PackageManager.PERMISSION_GRANTED;
            final boolean hasFine = ContextCompat.checkSelfPermission(
                    this,
                    Manifest.permission.ACCESS_FINE_LOCATION
            ) == PackageManager.PERMISSION_GRANTED;
            if (!hasCoarse && !hasFine) {
                result.success(null);
                return;
            }

            FusedLocationProviderClient fusedClient = LocationServices.getFusedLocationProviderClient(this);
            
            // First try to get last known location
            fusedClient.getLastLocation().addOnSuccessListener(location -> {
                if (isGoodLocation(location, hasFine)) {
                    result.success(buildLocationPayload(location));
                } else {
                    // Request fresh location with high accuracy
                    requestFreshLocation(fusedClient, hasFine, result);
                }
            }).addOnFailureListener(e -> {
                // Fallback: request fresh location
                requestFreshLocation(fusedClient, hasFine, result);
            });
        } catch (Exception e) {
            result.success(null);
        }
    }

    private boolean isLocationFresh(Location location) {
        if (location == null) {
            return false;
        }
        long ageMs = System.currentTimeMillis() - location.getTime();
        return ageMs >= 0 && ageMs <= MAX_LAST_LOCATION_AGE_MS;
    }

    private boolean isLocationAccurateEnough(Location location, boolean hasFine) {
        if (location == null || !location.hasAccuracy()) {
            return true;
        }

        float threshold = hasFine
                ? MAX_FINE_LOCATION_ACCURACY_METERS
                : MAX_COARSE_LOCATION_ACCURACY_METERS;
        return location.getAccuracy() <= threshold;
    }

    private boolean isGoodLocation(Location location, boolean hasFine) {
        return location != null
                && isLocationFresh(location)
                && isLocationAccurateEnough(location, hasFine);
    }

    private Map<String, Object> buildLocationPayload(Location location) {
        Map<String, Object> payload = new HashMap<>();
        payload.put("latitude", location.getLatitude());
        payload.put("longitude", location.getLongitude());
        return payload;
    }

    @SuppressLint("MissingPermission")
    private void requestFreshLocation(FusedLocationProviderClient client, boolean hasFine, MethodChannel.Result result) {
        try {
            LocationRequest request = new LocationRequest.Builder(
                    hasFine ? Priority.PRIORITY_HIGH_ACCURACY : Priority.PRIORITY_BALANCED_POWER_ACCURACY,
                    800
            ).setMaxUpdates(1).setMaxUpdateDelayMillis(2000).build();

            LocationCallback callback = new LocationCallback() {
                @Override
                public void onLocationResult(LocationResult locationResult) {
                    client.removeLocationUpdates(this);
                    if (locationResult != null && locationResult.getLastLocation() != null) {
                        Location loc = locationResult.getLastLocation();
                        result.success(buildLocationPayload(loc));
                    } else {
                        result.success(null);
                    }
                }
            };

            client.requestLocationUpdates(request, callback, Looper.getMainLooper());
        } catch (Exception e) {
            result.success(null);
        }
    }

    private final Map<String, String> locationNameCache = new HashMap<>();

    private void getLocationName(Double latitude, Double longitude, MethodChannel.Result result) {
        try {
            if (latitude == null || longitude == null) {
                result.success(null);
                return;
            }

            String cacheKey = latitude + "," + longitude;
            if (locationNameCache.containsKey(cacheKey)) {
                result.success(locationNameCache.get(cacheKey));
                return;
            }

            String city = getCityName(latitude, longitude);
            locationNameCache.put(cacheKey, city);
            result.success(city);
        } catch (Exception e) {
            result.success(null);
        }
    }

    private String getCityName(double lat, double lon) {
        try {
            Geocoder geocoder = new Geocoder(this, Locale.getDefault());
            List<Address> addresses = geocoder.getFromLocation(lat, lon, 1);
            if (addresses != null && !addresses.isEmpty()) {
                Address address = addresses.get(0);
                String city = address.getLocality();
                if (city == null) city = address.getSubAdminArea();
                if (city == null) city = address.getAdminArea();
                return city != null ? city : "Unknown";
            }
        } catch (Exception e) {
            android.util.Log.e("MainActivity", "Geocoding failed", e);
        }
        return "Unknown";
    }

    private void getAvailableWidgets(MethodChannel.Result result) {
        try {
            ensureAppWidgetHost();
            PackageManager pm = getPackageManager();
            List<AppWidgetProviderInfo> providers = appWidgetManager.getInstalledProviders();
            List<Map<String, Object>> widgets = new ArrayList<>();

            for (AppWidgetProviderInfo providerInfo : providers) {
                if (providerInfo == null || providerInfo.provider == null) {
                    continue;
                }

                ComponentName provider = providerInfo.provider;
                CharSequence loadedLabel = providerInfo.loadLabel(pm);
                String label = loadedLabel != null && loadedLabel.length() > 0
                        ? loadedLabel.toString()
                        : provider.getClassName();

                Map<String, Object> item = new HashMap<>();
                item.put("label", label);
                item.put("packageName", provider.getPackageName());
                item.put("className", provider.getClassName());
                item.put("minWidth", providerInfo.minWidth);
                item.put("minHeight", providerInfo.minHeight);

                byte[] preview = loadWidgetPreview(providerInfo);
                if (preview != null) {
                    item.put("preview", preview);
                }

                widgets.add(item);
            }

            result.success(widgets);
        } catch (Exception e) {
            result.error("WIDGET_LIST_ERROR", "Failed to get widgets: " + e.getMessage(), null);
        }
    }

    private byte[] loadWidgetPreview(AppWidgetProviderInfo providerInfo) {
        try {
            if (providerInfo.previewImage == 0 || providerInfo.provider == null) {
                return null;
            }

            Resources providerResources = getPackageManager().getResourcesForApplication(
                    providerInfo.provider.getPackageName()
            );
            Drawable previewDrawable;
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                previewDrawable = providerResources.getDrawable(providerInfo.previewImage, null);
            } else {
                previewDrawable = providerResources.getDrawable(providerInfo.previewImage);
            }

            if (previewDrawable == null) {
                return null;
            }

            return drawableToByteArray(previewDrawable);
        } catch (Exception ignored) {
            return null;
        }
    }

    private void allocateWidgetId(MethodChannel.Result result) {
        try {
            ensureAppWidgetHost();
            int appWidgetId = appWidgetHost.allocateAppWidgetId();
            result.success(appWidgetId);
        } catch (Exception e) {
            result.error("WIDGET_ALLOCATE_ERROR", "Failed to allocate widget id: " + e.getMessage(), null);
        }
    }

    private void bindWidget(
            Integer appWidgetId,
            String packageName,
            String className,
            MethodChannel.Result result
    ) {
        if (appWidgetId == null || packageName == null || className == null) {
            result.error("INVALID_ARGUMENT", "appWidgetId, packageName and className are required", null);
            return;
        }

        if (pendingBindResult != null) {
            result.error("BIND_IN_PROGRESS", "Another widget bind is in progress", null);
            return;
        }

        ensureAppWidgetHost();

        ComponentName componentName = new ComponentName(packageName, className);
        AppWidgetProviderInfo providerInfo = findProviderInfo(componentName);
        if (providerInfo == null) {
            result.error("WIDGET_PROVIDER_NOT_FOUND", "No widget provider found for component", null);
            return;
        }

        pendingBindResult = result;
        pendingWidgetId = appWidgetId;
        pendingProviderInfo = providerInfo;

        try {
            boolean allowed = appWidgetManager.bindAppWidgetIdIfAllowed(appWidgetId, componentName);
            if (allowed) {
                if (!launchConfigureIfNeeded(appWidgetId, providerInfo)) {
                    finishPendingBind(true, false);
                }
                return;
            }

            Intent bindIntent = new Intent(AppWidgetManager.ACTION_APPWIDGET_BIND);
            bindIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId);
            bindIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_PROVIDER, componentName);
            startActivityForResult(bindIntent, REQUEST_BIND_APPWIDGET);
        } catch (Exception e) {
            finishPendingBind(false, true);
        }
    }

    private void deleteWidgetId(Integer appWidgetId, MethodChannel.Result result) {
        if (appWidgetId == null) {
            result.success(false);
            return;
        }

        try {
            ensureAppWidgetHost();
            appWidgetHost.deleteAppWidgetId(appWidgetId);
            result.success(true);
        } catch (Exception e) {
            result.error("WIDGET_DELETE_ERROR", "Failed to delete widget id: " + e.getMessage(), null);
        }
    }

    private void createWidgetView(Integer appWidgetId, MethodChannel.Result result) {
        if (appWidgetId == null) {
            result.success(false);
            return;
        }

        try {
            ensureAppWidgetHost();
            AppWidgetProviderInfo providerInfo = appWidgetManager.getAppWidgetInfo(appWidgetId);
            result.success(providerInfo != null);
        } catch (Exception e) {
            result.error("WIDGET_VIEW_ERROR", "Failed to create widget view: " + e.getMessage(), null);
        }
    }

    private AppWidgetProviderInfo findProviderInfo(ComponentName componentName) {
        List<AppWidgetProviderInfo> providers = appWidgetManager.getInstalledProviders();
        for (AppWidgetProviderInfo providerInfo : providers) {
            if (providerInfo == null || providerInfo.provider == null) {
                continue;
            }
            if (providerInfo.provider.equals(componentName)) {
                return providerInfo;
            }
        }
        return null;
    }

    private boolean launchConfigureIfNeeded(int appWidgetId, AppWidgetProviderInfo providerInfo) {
        if (providerInfo == null || providerInfo.configure == null) {
            return false;
        }

        try {
            Intent configureIntent = new Intent(AppWidgetManager.ACTION_APPWIDGET_CONFIGURE);
            configureIntent.setComponent(providerInfo.configure);
            configureIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId);
            startActivityForResult(configureIntent, REQUEST_CONFIGURE_APPWIDGET);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    private void finishPendingBind(boolean success, boolean deleteWidgetIdOnFailure) {
        MethodChannel.Result callback = pendingBindResult;
        int widgetId = pendingWidgetId;

        pendingBindResult = null;
        pendingWidgetId = INVALID_APP_WIDGET_ID;
        pendingProviderInfo = null;

        if (!success && deleteWidgetIdOnFailure && widgetId != INVALID_APP_WIDGET_ID && appWidgetHost != null) {
            try {
                appWidgetHost.deleteAppWidgetId(widgetId);
            } catch (Exception ignored) {
            }
        }

        if (callback != null) {
            callback.success(success);
        }
    }

    private void clearPendingBind(String reason) {
        MethodChannel.Result callback = pendingBindResult;
        int widgetId = pendingWidgetId;

        pendingBindResult = null;
        pendingWidgetId = INVALID_APP_WIDGET_ID;
        pendingProviderInfo = null;

        if (widgetId != INVALID_APP_WIDGET_ID && appWidgetHost != null) {
            try {
                appWidgetHost.deleteAppWidgetId(widgetId);
            } catch (Exception ignored) {
            }
        }

        if (callback != null) {
            callback.error("WIDGET_BIND_CANCELLED", reason, null);
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (requestCode == REQUEST_BIND_APPWIDGET) {
            if (pendingBindResult == null) {
                return;
            }

            if (resultCode == RESULT_OK) {
                if (!launchConfigureIfNeeded(pendingWidgetId, pendingProviderInfo)) {
                    finishPendingBind(true, false);
                }
            } else {
                finishPendingBind(false, true);
            }
            return;
        }

        if (requestCode == REQUEST_CONFIGURE_APPWIDGET) {
            if (pendingBindResult == null) {
                return;
            }

            if (resultCode == RESULT_OK) {
                finishPendingBind(true, false);
            } else {
                finishPendingBind(false, true);
            }
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);

        if (requestCode == REQUEST_POST_NOTIFICATIONS) {
            MethodChannel.Result callback = pendingNotificationPermissionResult;
            pendingNotificationPermissionResult = null;
            if (callback == null) {
                return;
            }

            boolean granted = grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED;
            callback.success(granted);
            return;
        }

        if (requestCode == REQUEST_LOCATION_PERMISSION) {
            MethodChannel.Result callback = pendingLocationPermissionResult;
            pendingLocationPermissionResult = null;
            if (callback == null) {
                return;
            }

            boolean granted = false;
            for (int grantResult : grantResults) {
                if (grantResult == PackageManager.PERMISSION_GRANTED) {
                    granted = true;
                    break;
                }
            }
            callback.success(granted);
        }
    }

    private void getInstalledApps(MethodChannel.Result result) {
        try {
            List<Map<String, Object>> appList = new ArrayList<>();

            LauncherApps launcherApps = (LauncherApps) getSystemService(Context.LAUNCHER_APPS_SERVICE);
            if (launcherApps != null) {
                List<UserHandle> profiles = launcherApps.getProfiles();
                if (profiles == null || profiles.isEmpty()) {
                    profiles = new ArrayList<>();
                    profiles.add(Process.myUserHandle());
                }

                for (UserHandle profile : profiles) {
                    List<LauncherActivityInfo> activities = launcherApps.getActivityList(null, profile);
                    for (LauncherActivityInfo info : activities) {
                        ComponentName componentName = info.getComponentName();
                        String packageName = componentName != null ? componentName.getPackageName() : null;
                        String className = componentName != null ? componentName.getClassName() : null;
                        if (packageName == null || packageName.trim().isEmpty()) {
                            continue;
                        }

                        long userSerial = getUserSerial(info.getUser());
                        long userUid = -1L;
                        ApplicationInfo applicationInfo = info.getApplicationInfo();
                        if (applicationInfo != null) {
                            userUid = applicationInfo.uid;
                        }
                        String appName = info.getLabel() != null ? info.getLabel().toString() : packageName;
                        String instanceId = buildInstanceId(packageName, className, userSerial, userUid);

                        Drawable icon = info.getBadgedIcon(0);
                        byte[] iconBytes = drawableToByteArray(icon);

                        Map<String, Object> appData = new HashMap<>();
                        appData.put("instanceId", instanceId);
                        appData.put("packageName", packageName);
                        appData.put("className", className != null ? className : "");
                        appData.put("userSerial", userSerial);
                        appData.put("userUid", userUid);
                        appData.put("name", appName);
                        appData.put("appName", appName);
                        appData.put("icon", iconBytes);
                        appList.add(appData);
                    }
                }

                result.success(appList);
                return;
            }

            // Fallback for devices where LauncherApps is unavailable.
            PackageManager pm = getPackageManager();
            Intent mainIntent = new Intent(Intent.ACTION_MAIN, null);
            mainIntent.addCategory(Intent.CATEGORY_LAUNCHER);
            List<ResolveInfo> resolveInfos = pm.queryIntentActivities(mainIntent, 0);
            long currentSerial = getUserSerial(Process.myUserHandle());
            for (ResolveInfo resolveInfo : resolveInfos) {
                if (resolveInfo.activityInfo == null || resolveInfo.activityInfo.applicationInfo == null) {
                    continue;
                }
                ApplicationInfo appInfo = resolveInfo.activityInfo.applicationInfo;
                String packageName = appInfo.packageName;
                String className = resolveInfo.activityInfo != null ? resolveInfo.activityInfo.name : "";
                long userUid = appInfo.uid;
                if (packageName == null || packageName.trim().isEmpty()) {
                    continue;
                }

                String appName = resolveInfo.loadLabel(pm).toString();
                if (appName == null || appName.trim().isEmpty()) {
                    appName = appInfo.loadLabel(pm).toString();
                }

                Drawable icon = resolveInfo.loadIcon(pm);
                byte[] iconBytes = drawableToByteArray(icon);

                Map<String, Object> appData = new HashMap<>();
                appData.put("instanceId", buildInstanceId(packageName, className, currentSerial, userUid));
                appData.put("packageName", packageName);
                appData.put("className", className);
                appData.put("userSerial", currentSerial);
                appData.put("userUid", userUid);
                appData.put("name", appName);
                appData.put("appName", appName);
                appData.put("icon", iconBytes);
                appList.add(appData);
            }

            result.success(appList);
        } catch (Exception e) {
            result.error("FETCH_ERROR", "Failed to fetch installed apps: " + e.getMessage(), null);
        }
    }

    private void launchApp(Object arguments, MethodChannel.Result result) {
        launchAppInternal(arguments, false, result);
    }

    private void launchAppHidden(Object arguments, MethodChannel.Result result) {
        launchAppInternal(arguments, true, result);
    }

    private void launchAppInternal(Object arguments, boolean hiddenFlagsForFallback, MethodChannel.Result result) {
        try {
            AppTarget target = parseAppTarget(arguments);
            String packageName = target.packageName;
            if (packageName == null || packageName.trim().isEmpty()) {
                result.error("INVALID_ARGUMENT", "Package name is required", null);
                return;
            }

            UserHandle userHandle = resolveUserHandle(target.userSerial, target.userUid);
            LauncherApps launcherApps = (LauncherApps) getSystemService(Context.LAUNCHER_APPS_SERVICE);

            if (launcherApps != null && userHandle != null) {
                ComponentName componentName = resolveLauncherComponent(launcherApps, target, userHandle);
                if (componentName != null) {
                    launcherApps.startMainActivity(componentName, userHandle, null, null);
                    result.success(true);
                    return;
                }
            }

            // Fallback keeps backward compatibility for package-only payloads.
            PackageManager pm = getPackageManager();
            Intent launchIntent = buildFallbackLaunchIntent(pm, target);
            if (launchIntent == null) {
                result.error("APP_NOT_FOUND", "No launch intent found for package: " + packageName, null);
                return;
            }
            launchIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            if (hiddenFlagsForFallback) {
                launchIntent.addFlags(Intent.FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS);
                launchIntent.addFlags(Intent.FLAG_ACTIVITY_NO_HISTORY);
            }
            startActivity(launchIntent);
            result.success(true);
        } catch (Exception e) {
            result.error("LAUNCH_ERROR", "Failed to launch app: " + e.getMessage(), null);
        }
    }

    private Intent buildFallbackLaunchIntent(PackageManager pm, AppTarget target) {
        if (target.className != null && !target.className.trim().isEmpty()) {
            Intent explicit = new Intent(Intent.ACTION_MAIN);
            explicit.addCategory(Intent.CATEGORY_LAUNCHER);
            explicit.setComponent(new ComponentName(target.packageName, target.className));
            return explicit;
        }
        return pm.getLaunchIntentForPackage(target.packageName);
    }

    private void resetWallpaperToDefault(MethodChannel.Result result) {
        try {
            WallpaperManager wallpaperManager = WallpaperManager.getInstance(getApplicationContext());
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                wallpaperManager.clear(WallpaperManager.FLAG_SYSTEM);
                try {
                    wallpaperManager.clear(WallpaperManager.FLAG_LOCK);
                } catch (Exception ignored) {
                    // Some devices may not support lock wallpaper clear separately.
                }
            } else {
                wallpaperManager.clear();
            }
            safeForgetLoadedWallpaper(wallpaperManager);
            result.success(true);
        } catch (IOException e) {
            result.error("WALLPAPER_RESET_ERROR", "Failed to reset wallpaper: " + e.getMessage(), null);
        }
    }

    private void setWallpaper(String imagePath, MethodChannel.Result result) {
        try {
            if (imagePath == null || imagePath.trim().isEmpty()) {
                result.error("INVALID_ARGUMENT", "Image path is required", null);
                return;
            }
            WallpaperManager wallpaperManager = WallpaperManager.getInstance(getApplicationContext());
            File imageFile = new File(imagePath);

            if (!imageFile.exists()) {
                result.error("FILE_NOT_FOUND", "Image file does not exist: " + imagePath, null);
                return;
            }

            Bitmap bitmap = BitmapFactory.decodeFile(imageFile.getAbsolutePath());
            if (bitmap == null) {
                result.error("DECODE_ERROR", "Failed to decode image file", null);
                return;
            }

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                wallpaperManager.setBitmap(bitmap, null, true, WallpaperManager.FLAG_SYSTEM);
            } else {
                wallpaperManager.setBitmap(bitmap);
            }
            safeForgetLoadedWallpaper(wallpaperManager);
            result.success(true);
        } catch (Exception e) {
            result.error("WALLPAPER_ERROR", "Failed to set wallpaper: " + e.getMessage(), null);
        }
    }

    private void openAppInfo(Object arguments, MethodChannel.Result result) {
        try {
            AppTarget target = parseAppTarget(arguments);
            String packageName = target.packageName;
            if (packageName == null || packageName.trim().isEmpty()) {
                result.error("INVALID_ARGUMENT", "Package name is required", null);
                return;
            }

            UserHandle userHandle = resolveUserHandle(target.userSerial, target.userUid);
            LauncherApps launcherApps = (LauncherApps) getSystemService(Context.LAUNCHER_APPS_SERVICE);
            if (launcherApps != null && userHandle != null) {
                ComponentName componentName = resolveLauncherComponent(launcherApps, target, userHandle);
                if (componentName != null) {
                    launcherApps.startAppDetailsActivity(componentName, userHandle, null, null);
                    result.success(true);
                    return;
                }
            }

            // Fallback opens details for the package in current user context.
            Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
            intent.setData(Uri.parse("package:" + packageName));
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            startActivity(intent);
            result.success(true);
        } catch (Exception e) {
            result.error("APP_INFO_ERROR", "Failed to open app info: " + e.getMessage(), null);
        }
    }

    private void uninstallApp(Object arguments, MethodChannel.Result result) {
        try {
            AppTarget target = parseAppTarget(arguments);
            String packageName = target.packageName;
            if (packageName == null || packageName.trim().isEmpty()) {
                result.error("INVALID_ARGUMENT", "Package name is required", null);
                return;
            }

            Intent intent = new Intent(Intent.ACTION_DELETE);
            intent.setData(Uri.parse("package:" + packageName));
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

            // Best-effort profile hint; may be ignored by OEM/system UI on some devices.
            UserHandle userHandle = resolveUserHandle(target.userSerial, target.userUid);
            if (userHandle != null) {
                intent.putExtra("android.intent.extra.USER", userHandle);
            }

            startActivity(intent);
            result.success(true);
        } catch (Exception e) {
            result.error("UNINSTALL_ERROR", "Failed to uninstall app: " + e.getMessage(), null);
        }
    }

    private ComponentName resolveLauncherComponent(LauncherApps launcherApps, AppTarget target, UserHandle userHandle) {
        if (target.className != null && !target.className.trim().isEmpty()) {
            return new ComponentName(target.packageName, target.className);
        }
        List<LauncherActivityInfo> activities = launcherApps.getActivityList(target.packageName, userHandle);
        if (activities != null && !activities.isEmpty()) {
            return activities.get(0).getComponentName();
        }
        return null;
    }

    private String buildInstanceId(String packageName, String className, long userSerial, long userUid) {
        String safeClass = className != null ? className : "";
        return packageName + "#" + safeClass + "#" + userSerial + "#" + userUid;
    }

    private long getUserSerial(UserHandle userHandle) {
        if (userHandle == null) {
            return -1L;
        }
        UserManager userManager = (UserManager) getSystemService(Context.USER_SERVICE);
        if (userManager == null) {
            return -1L;
        }
        return userManager.getSerialNumberForUser(userHandle);
    }

    private UserHandle resolveUserHandle(Long userSerial, Long userUid) {
        try {
            if (userSerial != null && userSerial >= 0) {
                UserManager userManager = (UserManager) getSystemService(Context.USER_SERVICE);
                if (userManager != null) {
                    List<UserHandle> profiles = userManager.getUserProfiles();
                    for (UserHandle profile : profiles) {
                        if (userManager.getSerialNumberForUser(profile) == userSerial) {
                            return profile;
                        }
                    }
                }
            }

            if (userUid != null
                    && userUid >= 0
                    && userUid <= Integer.MAX_VALUE
                    && Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                try {
                    return UserHandle.getUserHandleForUid(userUid.intValue());
                } catch (Exception ignored) {
                }
            }
        } catch (Throwable ignored) {
        }

        return Process.myUserHandle();
    }

    private UserHandle extractUserHandleFromIntent(Intent intent) {
        if (intent == null) {
            return null;
        }
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                return intent.getParcelableExtra("android.intent.extra.USER", UserHandle.class);
            }
            Object maybeUser = intent.getParcelableExtra("android.intent.extra.USER");
            if (maybeUser instanceof UserHandle) {
                return (UserHandle) maybeUser;
            }
        } catch (Exception ignored) {
        }

        int uid = intent.getIntExtra(Intent.EXTRA_UID, -1);
        if (uid != -1 && Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            try {
                return UserHandle.getUserHandleForUid(uid);
            } catch (Exception ignored) {
            }
        }
        return null;
    }

    private AppTarget parseAppTarget(Object arguments) {
        AppTarget target = new AppTarget();
        if (arguments instanceof String) {
            target.packageName = (String) arguments;
            return target;
        }
        if (!(arguments instanceof Map)) {
            return target;
        }

        Map<?, ?> map = (Map<?, ?>) arguments;
        target.instanceId = stringValue(map.get("instanceId"));
        target.packageName = stringValue(map.get("packageName"));
        target.className = stringValue(map.get("className"));
        target.userSerial = longValue(map.get("userSerial"));
        target.userUid = longValue(map.get("userUid"));

        boolean missingPackage = target.packageName == null || target.packageName.trim().isEmpty();
        boolean missingClass = target.className == null || target.className.trim().isEmpty();
        boolean missingSerial = target.userSerial == null;
        boolean missingUid = target.userUid == null;
        if ((missingPackage || missingClass || missingSerial || missingUid) && target.instanceId != null) {
            String[] parts;
            if (target.instanceId.contains("#")) {
                parts = target.instanceId.split("#", -1);
            } else {
                parts = target.instanceId.split("\\|", -1);
            }

            if (missingPackage && parts.length >= 1 && parts[0] != null && !parts[0].trim().isEmpty()) {
                target.packageName = parts[0];
            }
            if (missingClass && parts.length >= 2) {
                target.className = parts[1];
            }
            if (missingSerial && parts.length >= 3) {
                target.userSerial = longValue(parts[2]);
            }
            if (missingUid && parts.length >= 4) {
                target.userUid = longValue(parts[3]);
            }
        }

        return target;
    }

    private String stringValue(Object value) {
        return value != null ? String.valueOf(value) : null;
    }

    private Long longValue(Object value) {
        if (value == null) {
            return null;
        }
        if (value instanceof Number) {
            return ((Number) value).longValue();
        }
        try {
            return Long.parseLong(String.valueOf(value));
        } catch (Exception ignored) {
            return null;
        }
    }

    private static class AppTarget {
        String instanceId;
        String packageName;
        String className;
        Long userSerial;
        Long userUid;
    }

    private void expandStatusBar(MethodChannel.Result result) {
        try {
            Object service = getSystemService("statusbar");
            if (service == null) {
                result.success(false);
                return;
            }

            try {
                java.lang.reflect.Method expand;
                if (Build.VERSION.SDK_INT <= Build.VERSION_CODES.JELLY_BEAN) {
                    expand = service.getClass().getMethod("expand");
                } else {
                    expand = service.getClass().getMethod("expandNotificationsPanel");
                }
                expand.invoke(service);
                result.success(true);
            } catch (Exception firstError) {
                try {
                    Class<?> statusBarManager = Class.forName("android.app.StatusBarManager");
                    java.lang.reflect.Method expand;
                    if (Build.VERSION.SDK_INT <= Build.VERSION_CODES.JELLY_BEAN) {
                        expand = statusBarManager.getMethod("expand");
                    } else {
                        expand = statusBarManager.getMethod("expandNotificationsPanel");
                    }
                    expand.invoke(service);
                    result.success(true);
                } catch (Exception secondError) {
                    result.success(false);
                }
            }
        } catch (Exception e) {
            result.error("STATUS_BAR_ERROR", "Failed to expand status bar: " + e.getMessage(), null);
        }
    }

    private void getWallpaperBytes(MethodChannel.Result result) {
        if (wallpaperExecutor.isShutdown() || wallpaperExecutor.isTerminated()) {
            result.success(null);
            return;
        }

        try {
            wallpaperExecutor.execute(() -> {
                try {
                    WallpaperManager wallpaperManager = WallpaperManager.getInstance(getApplicationContext());
                    Drawable drawable = Build.VERSION.SDK_INT >= Build.VERSION_CODES.N
                            ? wallpaperManager.getDrawable(WallpaperManager.FLAG_SYSTEM)
                            : wallpaperManager.getDrawable();
                    if (drawable == null) {
                        runOnUiThread(() -> result.success(null));
                        return;
                    }

                    Bitmap bitmap = drawableToBitmap(drawable);
                    Bitmap normalized = normalizeWallpaperBitmap(bitmap);
                    ByteArrayOutputStream stream = new ByteArrayOutputStream();
                    normalized.compress(Bitmap.CompressFormat.JPEG, 80, stream);
                    byte[] bytes = stream.toByteArray();
                    if (bytes == null || bytes.length == 0 || bytes.length > WALLPAPER_MAX_BYTES) {
                        runOnUiThread(() -> result.success(null));
                        return;
                    }
                    runOnUiThread(() -> result.success(bytes));
                } catch (OutOfMemoryError ignored) {
                    runOnUiThread(() -> result.success(null));
                } catch (Throwable ignored) {
                    runOnUiThread(() -> result.success(null));
                }
            });
        } catch (RejectedExecutionException ignored) {
            result.success(null);
        }
    }

    private void safeForgetLoadedWallpaper(WallpaperManager wallpaperManager) {
        try {
            wallpaperManager.forgetLoadedWallpaper();
        } catch (Exception ignored) {
        }
    }

    private Bitmap normalizeWallpaperBitmap(Bitmap bitmap) {
        Bitmap working = bitmap;

        if ((Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && working.getConfig() == Bitmap.Config.HARDWARE)
                || working.getConfig() == null) {
            Bitmap copy = working.copy(Bitmap.Config.ARGB_8888, false);
            if (copy != null) {
                working = copy;
            }
        }

        int width = working.getWidth();
        int height = working.getHeight();
        int longest = Math.max(width, height);

        if (longest <= 0 || longest <= WALLPAPER_PREVIEW_MAX_DIMENSION) {
            return working;
        }

        float scale = (float) WALLPAPER_PREVIEW_MAX_DIMENSION / (float) longest;
        int targetW = Math.max(1, Math.round(width * scale));
        int targetH = Math.max(1, Math.round(height * scale));

        return Bitmap.createScaledBitmap(working, targetW, targetH, true);
    }

    private void getNotificationPackages(MethodChannel.Result result) {
        try {
            Set<String> packages = StillmaxNotificationListenerService.getActiveNotificationPackagesSnapshot();
            result.success(new ArrayList<>(packages));
        } catch (Exception e) {
            result.error("NOTIFICATIONS_ERROR", "Failed to fetch notification packages: " + e.getMessage(), null);
        }
    }

    private Bitmap drawableToBitmap(Drawable drawable) {
        if (drawable instanceof BitmapDrawable) {
            Bitmap bitmap = ((BitmapDrawable) drawable).getBitmap();
            if (bitmap != null) {
                return bitmap;
            }
        }

        int width = drawable.getIntrinsicWidth();
        int height = drawable.getIntrinsicHeight();
        if (width <= 0 || height <= 0) {
            width = 192;
            height = 192;
        }

        if (width > 512) {
            width = 512;
        }
        if (height > 512) {
            height = 512;
        }

        Bitmap bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(bitmap);
        drawable.setBounds(0, 0, canvas.getWidth(), canvas.getHeight());
        drawable.draw(canvas);
        return bitmap;
    }

    private byte[] drawableToByteArray(Drawable drawable) {
        Bitmap bitmap = drawableToBitmap(drawable);
        ByteArrayOutputStream stream = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream);
        return stream.toByteArray();
    }

    private void getInstalledIconPacks(MethodChannel.Result result) {
        try {
            PackageManager pm = getPackageManager();
            List<Map<String, Object>> packs = new ArrayList<>();

            Intent adwIntent = new Intent("org.adw.launcher.THEMES");
            Intent novaIntent = new Intent("com.novalauncher.THEME");

            List<ResolveInfo> adwPacks = pm.queryIntentActivities(adwIntent, 0);
            List<ResolveInfo> novaPacks = pm.queryIntentActivities(novaIntent, 0);

            for (ResolveInfo info : adwPacks) {
                String packageName = info.activityInfo.packageName;
                String label = info.loadLabel(pm).toString();
                Map<String, Object> pack = new HashMap<>();
                pack.put("packageName", packageName);
                pack.put("label", label);
                packs.add(pack);
            }

            for (ResolveInfo info : novaPacks) {
                String packageName = info.activityInfo.packageName;
                String label = info.loadLabel(pm).toString();
                Map<String, Object> pack = new HashMap<>();
                pack.put("packageName", packageName);
                pack.put("label", label);
                packs.add(pack);
            }

            result.success(packs);
        } catch (Exception e) {
            result.error("ICON_PACKS_ERROR", "Failed to get icon packs: " + e.getMessage(), null);
        }
    }

    private void getIconFromPack(String iconPackPackage, String appPackage, MethodChannel.Result result) {
        try {
            if (iconPackPackage == null || appPackage == null) {
                result.success(null);
                return;
            }

            PackageManager pm = getPackageManager();
            Resources packRes = pm.getResourcesForApplication(iconPackPackage);

            String componentName = appPackage.replace(".", "_");
            int drawableId = packRes.getIdentifier(componentName, "drawable", iconPackPackage);

            if (drawableId == 0) {
                result.success(null);
                return;
            }

            Drawable drawable = packRes.getDrawable(drawableId, null);
            if (drawable == null) {
                result.success(null);
                return;
            }

            result.success(drawableToByteArray(drawable));
        } catch (Exception e) {
            result.success(null);
        }
    }

    private void toggleWifi(Boolean enable, MethodChannel.Result result) {
        try {
            WifiManager wifiManager = (WifiManager) getApplicationContext().getSystemService(Context.WIFI_SERVICE);
            if (wifiManager != null) {
                wifiManager.setWifiEnabled(enable);
                result.success(true);
            } else {
                result.success(false);
            }
        } catch (Exception e) {
            result.error("WIFI_ERROR", "Failed to toggle WiFi: " + e.getMessage(), null);
        }
    }

    private void toggleBluetooth(Boolean enable, MethodChannel.Result result) {
        try {
            BluetoothAdapter adapter = BluetoothAdapter.getDefaultAdapter();
            if (adapter != null) {
                if (enable) {
                    adapter.enable();
                } else {
                    adapter.disable();
                }
                result.success(true);
            } else {
                result.success(false);
            }
        } catch (Exception e) {
            result.error("BLUETOOTH_ERROR", "Failed to toggle Bluetooth: " + e.getMessage(), null);
        }
    }

    private String cameraId;
    private CameraManager cameraManager;
    private boolean flashlightOn = false;

    private void toggleFlashlight(Boolean enable, MethodChannel.Result result) {
        try {
            if (cameraManager == null) {
                cameraManager = (CameraManager) getSystemService(Context.CAMERA_SERVICE);
                if (cameraManager != null) {
                    String[] cameraIds = cameraManager.getCameraIdList();
                    if (cameraIds != null && cameraIds.length > 0) {
                        cameraId = cameraIds[0];
                    }
                }
            }
            if (cameraManager != null && cameraId != null) {
                cameraManager.setTorchMode(cameraId, enable);
                flashlightOn = enable;
                result.success(true);
            } else {
                result.success(false);
            }
        } catch (CameraAccessException e) {
            result.error("FLASHLIGHT_ERROR", "Failed to toggle flashlight: " + e.getMessage(), null);
        } catch (SecurityException e) {
            result.error("FLASHLIGHT_ERROR", "Security exception: " + e.getMessage(), null);
        } catch (Exception e) {
            result.error("FLASHLIGHT_ERROR", "Unexpected error: " + e.getMessage(), null);
        }
    }

    private void setBrightness(Integer level, MethodChannel.Result result) {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                if (Settings.System.canWrite(this)) {
                    Settings.System.putInt(
                        getContentResolver(),
                        Settings.System.SCREEN_BRIGHTNESS,
                        level
                    );
                    result.success(true);
                } else {
                    result.success(false);
                }
            } else {
                Settings.System.putInt(
                    getContentResolver(),
                    Settings.System.SCREEN_BRIGHTNESS,
                    level
                );
                result.success(true);
            }
        } catch (Exception e) {
            result.error("BRIGHTNESS_ERROR", "Failed to set brightness: " + e.getMessage(), null);
        }
    }

    private void getQuickSettings(MethodChannel.Result result) {
        try {
            Map<String, Object> settings = new HashMap<>();

            WifiManager wifiManager = (WifiManager) getApplicationContext().getSystemService(Context.WIFI_SERVICE);
            settings.put("wifiEnabled", wifiManager != null && wifiManager.isWifiEnabled());

            BluetoothAdapter adapter = BluetoothAdapter.getDefaultAdapter();
            settings.put("bluetoothEnabled", adapter != null && adapter.isEnabled());

            int brightness = Settings.System.getInt(
                getContentResolver(),
                Settings.System.SCREEN_BRIGHTNESS,
                128
            );
            settings.put("brightness", brightness);

            result.success(settings);
        } catch (Exception e) {
            result.error("QUICK_SETTINGS_ERROR", "Failed to get quick settings: " + e.getMessage(), null);
        }
    }

    private void getNotificationCounts(MethodChannel.Result result) {
        try {
            Map<String, Integer> counts = StillmaxNotificationListenerService.getNotificationCountsSnapshot();
            Map<String, Object> payload = new HashMap<>(counts);
            result.success(payload);
        } catch (Exception e) {
            result.error("NOTIFICATION_COUNTS_ERROR", "Failed to get notification counts: " + e.getMessage(), null);
        }
    }

    private class StillmaxAppWidgetHost extends AppWidgetHost {
        StillmaxAppWidgetHost(Context context, int hostId) {
            super(context, hostId);
        }

        @Override
        protected AppWidgetHostView onCreateView(Context context, int appWidgetId, AppWidgetProviderInfo appWidget) {
            return new WidgetHostView(context);
        }
    }

    private static class WidgetHostView extends AppWidgetHostView {
        WidgetHostView(Context context) {
            super(context);
        }
    }

    private class WidgetViewFactory extends PlatformViewFactory {
        WidgetViewFactory() {
            super(StandardMessageCodec.INSTANCE);
        }

        @Override
        public PlatformView create(Context context, int viewId, Object args) {
            int appWidgetId = INVALID_APP_WIDGET_ID;
            if (args instanceof Map) {
                Object idObj = ((Map<?, ?>) args).get("widgetId");
                if (idObj instanceof Number) {
                    appWidgetId = ((Number) idObj).intValue();
                }
            }
            return new WidgetPlatformView(context, appWidgetId);
        }
    }

    private class WidgetPlatformView implements PlatformView {
        private final View view;

        WidgetPlatformView(Context context, int appWidgetId) {
            ensureAppWidgetHost();

            AppWidgetProviderInfo providerInfo = appWidgetManager.getAppWidgetInfo(appWidgetId);
            if (providerInfo == null) {
                TextView fallback = new TextView(context);
                fallback.setText("Widget unavailable");
                fallback.setGravity(Gravity.CENTER);
                fallback.setTextColor(0xFFE4E1E9);
                view = fallback;
                return;
            }

            AppWidgetHostView hostView = appWidgetHost.createView(context, appWidgetId, providerInfo);
            hostView.setAppWidget(appWidgetId, providerInfo);
            view = hostView;
        }

        @Override
        public View getView() {
            return view;
        }

        @Override
        public void dispose() {
        }
    }
}
