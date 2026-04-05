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
import android.provider.Settings;
import android.view.Gravity;
import android.view.View;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Locale;

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
    private static final int INVALID_APP_WIDGET_ID = -1;

    private EventChannel.EventSink appEventsSink;
    private BroadcastReceiver packageBroadcastReceiver;
    private AppWidgetHost appWidgetHost;
    private AppWidgetManager appWidgetManager;
    private MethodChannel.Result pendingBindResult;
    private int pendingWidgetId = INVALID_APP_WIDGET_ID;
    private AppWidgetProviderInfo pendingProviderInfo;
    private boolean widgetViewFactoryRegistered = false;

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
                            launchApp(call.argument("packageName"), result);
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
                            openAppInfo(call.argument("packageName"), result);
                            break;
                        case "uninstallApp":
                            uninstallApp(call.argument("packageName"), result);
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
                            Map<String, Object> mediaData = MediaNotificationListener.getActiveMediaSession(this);
                            result.success(mediaData);
                            break;
                        case "sendMediaAction":
                            String action = call.argument("action");
                            MediaNotificationListener.sendMediaAction(this, action);
                            result.success(null);
                            break;
                        case "openNotificationListenerSettings":
                            Intent intent = new Intent("android.settings.ACTION_NOTIFICATION_LISTENER_SETTINGS");
                            startActivity(intent);
                            result.success(null);
                            break;
                        default:
                            result.notImplemented();
                            break;
                    }
                });
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
            unregisterReceiver(packageBroadcastReceiver);
            packageBroadcastReceiver = null;
        }
        if (appWidgetHost != null) {
            appWidgetHost.stopListening();
        }
        clearPendingBind("cancelled");
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

            LocationManager locationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
            if (locationManager == null) {
                result.success(null);
                return;
            }

            Location location = locationManager.getLastKnownLocation(LocationManager.NETWORK_PROVIDER);
            if (location == null) {
                result.success(null);
                return;
            }

            Map<String, Object> payload = new HashMap<>();
            payload.put("latitude", location.getLatitude());
            payload.put("longitude", location.getLongitude());
            result.success(payload);
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

    private void getInstalledApps(MethodChannel.Result result) {
        try {
            PackageManager pm = getPackageManager();
            Intent mainIntent = new Intent(Intent.ACTION_MAIN, null);
            mainIntent.addCategory(Intent.CATEGORY_LAUNCHER);

            List<ResolveInfo> resolveInfos = pm.queryIntentActivities(mainIntent, 0);
            List<Map<String, Object>> appList = new ArrayList<>();
            Set<String> seenPackages = new HashSet<>();

            for (ResolveInfo resolveInfo : resolveInfos) {
                ApplicationInfo appInfo = resolveInfo.activityInfo.applicationInfo;
                String packageName = appInfo.packageName;
                if (packageName == null || packageName.trim().isEmpty()) {
                    continue;
                }
                if (seenPackages.contains(packageName)) {
                    continue;
                }
                seenPackages.add(packageName);

                String appName = resolveInfo.loadLabel(pm).toString();
                if (appName == null || appName.trim().isEmpty()) {
                    appName = appInfo.loadLabel(pm).toString();
                }

                Drawable icon = resolveInfo.loadIcon(pm);
                byte[] iconBytes = drawableToByteArray(icon);

                Map<String, Object> appData = new HashMap<>();
                appData.put("name", appName);
                appData.put("appName", appName);
                appData.put("packageName", packageName);
                appData.put("icon", iconBytes);
                appList.add(appData);
            }

            result.success(appList);
        } catch (Exception e) {
            result.error("FETCH_ERROR", "Failed to fetch installed apps: " + e.getMessage(), null);
        }
    }

    private void launchApp(String packageName, MethodChannel.Result result) {
        try {
            if (packageName == null || packageName.trim().isEmpty()) {
                result.error("INVALID_ARGUMENT", "Package name is required", null);
                return;
            }
            PackageManager pm = getPackageManager();
            Intent launchIntent = pm.getLaunchIntentForPackage(packageName);

            if (launchIntent != null) {
                launchIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                startActivity(launchIntent);
                result.success(true);
            } else {
                result.error("APP_NOT_FOUND", "No launch intent found for package: " + packageName, null);
            }
        } catch (Exception e) {
            result.error("LAUNCH_ERROR", "Failed to launch app: " + e.getMessage(), null);
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

            wallpaperManager.setBitmap(bitmap);
            result.success(true);
        } catch (Exception e) {
            result.error("WALLPAPER_ERROR", "Failed to set wallpaper: " + e.getMessage(), null);
        }
    }

    private void openAppInfo(String packageName, MethodChannel.Result result) {
        try {
            if (packageName == null || packageName.trim().isEmpty()) {
                result.error("INVALID_ARGUMENT", "Package name is required", null);
                return;
            }
            Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
            intent.setData(Uri.parse("package:" + packageName));
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            startActivity(intent);
            result.success(true);
        } catch (Exception e) {
            result.error("APP_INFO_ERROR", "Failed to open app info: " + e.getMessage(), null);
        }
    }

    private void uninstallApp(String packageName, MethodChannel.Result result) {
        try {
            if (packageName == null || packageName.trim().isEmpty()) {
                result.error("INVALID_ARGUMENT", "Package name is required", null);
                return;
            }
            Intent intent = new Intent(Intent.ACTION_DELETE);
            intent.setData(Uri.parse("package:" + packageName));
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            startActivity(intent);
            result.success(true);
        } catch (Exception e) {
            result.error("UNINSTALL_ERROR", "Failed to uninstall app: " + e.getMessage(), null);
        }
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
        try {
            WallpaperManager wallpaperManager = WallpaperManager.getInstance(getApplicationContext());
            Drawable drawable = wallpaperManager.getDrawable();
            if (drawable == null) {
                result.success(null);
                return;
            }

            Bitmap bitmap = drawableToBitmap(drawable);
            ByteArrayOutputStream stream = new ByteArrayOutputStream();
            bitmap.compress(Bitmap.CompressFormat.JPEG, 85, stream);
            result.success(stream.toByteArray());
        } catch (Exception e) {
            result.error("WALLPAPER_FETCH_ERROR", "Failed to fetch wallpaper bytes: " + e.getMessage(), null);
        }
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
                    cameraId = cameraManager.getCameraIdList()[0];
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
