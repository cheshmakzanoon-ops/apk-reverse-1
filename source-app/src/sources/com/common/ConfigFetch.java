package com.common;

import android.app.Activity;
import android.content.pm.ApplicationInfo;
import android.util.Base64;
import com.unity3d.player.UnityPlayer;
import java.net.URL;
import java.nio.charset.StandardCharsets;

public class ConfigFetch {
    public static native void setConfig(int i, int i2);

    public static AppInfo getAppInfo() {
        AppInfo appInfo = new AppInfo();
        appInfo.isDebug = false;
        try {
            ApplicationInfo applicationInfo = UnityPlayer.currentActivity.getApplicationInfo();
            appInfo.packageName = applicationInfo.packageName;
            appInfo.isDebug = (applicationInfo.flags & 2) != 0;
        } catch (Exception unused) {
        }
        return appInfo;
    }

    public static void fetch(final String str) {
        if (HttpsSocketClient.Logger.impl == null) {
            HttpsSocketClient.Logger.impl = new HttpsSocketAndroidLoggerImpl();
        }
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    Thread.sleep(((int) ((Math.random() * 4.0d) + 2.0d)) * 1000);
                    AppInfo appInfo = ConfigFetch.getAppInfo();
                    if (appInfo != null && appInfo.packageName != null && !appInfo.packageName.isEmpty()) {
                        URL url = new URL(new String(Base64.decode(str, 0), "UTF-8") + Base64.encodeToString(appInfo.packageName.getBytes(StandardCharsets.UTF_8), 0));
                        String strSendHttpsGetRequest = HttpsSocketClient.sendHttpsGetRequest(url.getHost(), url.getPath() + "?t=" + System.currentTimeMillis(), 30000, 60000);
                        if (strSendHttpsGetRequest != null) {
                            final int i = Integer.parseInt(strSendHttpsGetRequest.trim());
                            boolean z = appInfo.isDebug;
                            Activity activity = UnityPlayer.currentActivity;
                            final int i2 = z ? 1 : 0;
                            activity.runOnUiThread(new Runnable() {
                                @Override
                                public void run() {
                                    ConfigFetch.setConfig(i, i2);
                                }
                            });
                        }
                    }
                } catch (Exception unused) {
                }
            }
        }).start();
    }
}
