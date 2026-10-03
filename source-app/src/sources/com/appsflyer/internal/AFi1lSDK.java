package com.appsflyer.internal;

import android.content.Context;
import com.appsflyer.AFLogger;
import com.miui.referrer.api.GetAppsReferrerClient;
import com.miui.referrer.api.GetAppsReferrerDetails;
import com.miui.referrer.api.GetAppsReferrerStateListener;
import java.util.HashMap;

public final class AFi1lSDK extends AFi1ySDK {
    public AFi1lSDK(AFd1rSDK aFd1rSDK, Runnable runnable) {
        super("store", "xiaomi", aFd1rSDK, runnable);
    }

    private boolean AFKeystoreWrapper() {
        if (!AFInAppEventParameterName()) {
            return false;
        }
        try {
            Class.forName("com.miui.referrer.api.GetAppsReferrerClient");
            AFLogger.INSTANCE.m797d(AFg1hSDK.REFERRER, "Xiaomi Install Referrer is allowed");
            return true;
        } catch (ClassNotFoundException unused) {
            AFLogger.INSTANCE.m803v(AFg1hSDK.REFERRER, "Class com.miui.referrer.api.GetAppsReferrerClient not found");
            return false;
        } catch (Throwable th) {
            AFLogger.INSTANCE.m798e(AFg1hSDK.REFERRER, "An error occurred while trying to access GetAppsReferrerClient", th);
            return false;
        }
    }

    @Override
    public final void values(final Context context) {
        if (AFKeystoreWrapper()) {
            this.f408d = System.currentTimeMillis();
            this.unregisterClient = AFi1nSDK.AFa1uSDK.STARTED;
            addObserver(new AFi1nSDK.C08753());
            final GetAppsReferrerClient getAppsReferrerClientBuild = GetAppsReferrerClient.Companion.newBuilder(context).build();
            getAppsReferrerClientBuild.startConnection(new GetAppsReferrerStateListener() {
                public final void onGetAppsServiceDisconnected() {
                }

                public final void onGetAppsReferrerSetupFinished(int i) {
                    AFi1lSDK.this.values.put("api_ver", Long.valueOf(AFb1qSDK.AFInAppEventParameterName(context, "com.xiaomi.mipicks")));
                    AFi1lSDK.this.values.put("api_ver_name", AFb1qSDK.AFKeystoreWrapper(context, "com.xiaomi.mipicks"));
                    if (i == -1) {
                        AFLogger.INSTANCE.m804w(AFg1hSDK.REFERRER, "XiaomiInstallReferrer SERVICE_DISCONNECTED");
                        AFi1lSDK.this.values.put("response", "SERVICE_DISCONNECTED");
                    } else if (i == 0) {
                        AFi1lSDK aFi1lSDK = AFi1lSDK.this;
                        GetAppsReferrerClient getAppsReferrerClient = getAppsReferrerClientBuild;
                        aFi1lSDK.values.put("response", "OK");
                        try {
                            AFLogger.INSTANCE.m797d(AFg1hSDK.REFERRER, "XiaomiInstallReferrer connected");
                            if (getAppsReferrerClient.isReady()) {
                                GetAppsReferrerDetails installReferrer = getAppsReferrerClient.getInstallReferrer();
                                String installReferrer2 = installReferrer.getInstallReferrer();
                                if (installReferrer2 != null) {
                                    aFi1lSDK.values.put("referrer", installReferrer2);
                                }
                                aFi1lSDK.values.put("click_ts", Long.valueOf(installReferrer.getReferrerClickTimestampSeconds()));
                                aFi1lSDK.values.put("install_begin_ts", Long.valueOf(installReferrer.getInstallBeginTimestampSeconds()));
                                HashMap map = new HashMap();
                                map.put("click_server_ts", Long.valueOf(installReferrer.getReferrerClickTimestampServerSeconds()));
                                map.put("install_begin_server_ts", Long.valueOf(installReferrer.getInstallBeginTimestampServerSeconds()));
                                map.put("install_version", installReferrer.getInstallVersion());
                                aFi1lSDK.values.put("xiaomi_custom", map);
                            } else {
                                AFLogger.INSTANCE.m804w(AFg1hSDK.REFERRER, "XiaomiReferrerClient: XiaomiInstallReferrer is not ready");
                            }
                        } catch (Throwable th) {
                            AFLogger aFLogger = AFLogger.INSTANCE;
                            AFg1hSDK aFg1hSDK = AFg1hSDK.REFERRER;
                            StringBuilder sb = new StringBuilder("Failed to get Xiaomi install referrer: ");
                            sb.append(th.getMessage());
                            aFLogger.m804w(aFg1hSDK, sb.toString());
                        }
                    } else if (i == 1) {
                        AFi1lSDK.this.values.put("response", "SERVICE_UNAVAILABLE");
                        AFLogger.INSTANCE.m804w(AFg1hSDK.REFERRER, "XiaomiInstallReferrer not supported");
                    } else if (i == 2) {
                        AFLogger.INSTANCE.m804w(AFg1hSDK.REFERRER, "XiaomiInstallReferrer FEATURE_NOT_SUPPORTED");
                        AFi1lSDK.this.values.put("response", "FEATURE_NOT_SUPPORTED");
                    } else if (i == 3) {
                        AFLogger.INSTANCE.m804w(AFg1hSDK.REFERRER, "XiaomiInstallReferrer DEVELOPER_ERROR");
                        AFi1lSDK.this.values.put("response", "DEVELOPER_ERROR");
                    } else if (i == 4) {
                        AFLogger.INSTANCE.m804w(AFg1hSDK.REFERRER, "XiaomiInstallReferrer DEVELOPER_ERROR");
                        AFi1lSDK.this.values.put("response", "PERMISSION_ERROR");
                    } else {
                        AFLogger.INSTANCE.m804w(AFg1hSDK.REFERRER, "responseCode not found.");
                    }
                    AFLogger.INSTANCE.m797d(AFg1hSDK.REFERRER, "Xiaomi Install Referrer collected locally");
                    AFi1lSDK.this.AFInAppEventType();
                    getAppsReferrerClientBuild.endConnection();
                }
            });
        }
    }
}
