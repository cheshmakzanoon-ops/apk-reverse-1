package com.appsflyer.internal;

import android.content.Context;
import androidx.core.app.NotificationCompat;
import com.android.installreferrer.api.InstallReferrerClient;
import com.android.installreferrer.api.InstallReferrerStateListener;
import com.android.installreferrer.api.ReferrerDetails;
import com.appsflyer.AFLogger;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ExecutorService;

public class AFi1pSDK extends AFi1ySDK {
    private final ExecutorService AFKeystoreWrapper;
    public final Map<String, Object> valueOf;

    public AFi1pSDK(Runnable runnable, ExecutorService executorService, AFd1rSDK aFd1rSDK) {
        super("store", "google", aFd1rSDK, runnable);
        this.valueOf = new HashMap();
        this.AFKeystoreWrapper = executorService;
    }

    private boolean AFInAppEventType(Context context) {
        if (!AFInAppEventParameterName()) {
            return false;
        }
        try {
            Class.forName("com.android.installreferrer.api.InstallReferrerClient");
            if (AFb1qSDK.AFInAppEventType(context, "com.google.android.finsky.permission.BIND_GET_INSTALL_REFERRER_SERVICE")) {
                AFLogger.INSTANCE.m797d(AFg1hSDK.REFERRER, "Install referrer is allowed");
                return true;
            }
            AFLogger.INSTANCE.m797d(AFg1hSDK.REFERRER, "Install referrer is not allowed");
            return false;
        } catch (ClassNotFoundException e) {
            AFLogger.afErrorLogForExcManagerOnly("InstallReferrerClient not found", e);
            AFLogger.INSTANCE.m803v(AFg1hSDK.REFERRER, "Class com.android.installreferrer.api.InstallReferrerClient not found");
            return false;
        } catch (Throwable th) {
            AFLogger.INSTANCE.m798e(AFg1hSDK.REFERRER, "An error occurred while trying to verify manifest : ".concat("com.android.installreferrer.api.InstallReferrerClient"), th);
            return false;
        }
    }

    @Override
    public final void values(Context context) {
        if (AFInAppEventType(context)) {
            this.f408d = System.currentTimeMillis();
            this.unregisterClient = AFi1nSDK.AFa1uSDK.STARTED;
            addObserver(new AFi1nSDK.C08753());
            try {
                InstallReferrerClient installReferrerClientBuild = InstallReferrerClient.newBuilder(context).build();
                AFLogger.INSTANCE.m797d(AFg1hSDK.REFERRER, "Connecting to Install Referrer Library...");
                installReferrerClientBuild.startConnection(new C08775(installReferrerClientBuild, context));
            } catch (Throwable th) {
                AFLogger.INSTANCE.m798e(AFg1hSDK.REFERRER, "referrerClient -> startConnection", th);
            }
        }
    }

    final class C08775 implements InstallReferrerStateListener {
        final Context val$context;
        final InstallReferrerClient val$referrerClient;

        C08775(InstallReferrerClient installReferrerClient, Context context) {
            this.val$referrerClient = installReferrerClient;
            this.val$context = context;
        }

        void m823x1bedb526(InstallReferrerClient installReferrerClient, Context context, int i) {
            AFi1pSDK.this.AFInAppEventType(installReferrerClient, context, i);
        }

        @Override
        public final void onInstallReferrerSetupFinished(final int i) {
            ExecutorService executorService = AFi1pSDK.this.AFKeystoreWrapper;
            final InstallReferrerClient installReferrerClient = this.val$referrerClient;
            final Context context = this.val$context;
            executorService.execute(new Runnable() {
                @Override
                public final void run() {
                    this.f$0.m823x1bedb526(installReferrerClient, context, i);
                }
            });
        }

        @Override
        public final void onInstallReferrerServiceDisconnected() {
            AFLogger.INSTANCE.m797d(AFg1hSDK.REFERRER, "Install Referrer service disconnected");
        }
    }

    protected final void AFInAppEventType(InstallReferrerClient installReferrerClient, Context context, int i) {
        this.valueOf.put("code", String.valueOf(i));
        this.values.put("api_ver", Long.valueOf(AFb1qSDK.AFInAppEventParameterName(context, "com.android.vending")));
        this.values.put("api_ver_name", AFb1qSDK.AFKeystoreWrapper(context, "com.android.vending"));
        if (i == -1) {
            AFLogger.INSTANCE.m804w(AFg1hSDK.REFERRER, "InstallReferrer SERVICE_DISCONNECTED");
            this.values.put("response", "SERVICE_DISCONNECTED");
        } else if (i == 0) {
            this.values.put("response", "OK");
            try {
                AFLogger.INSTANCE.m797d(AFg1hSDK.REFERRER, "InstallReferrer connected");
                if (installReferrerClient.isReady()) {
                    ReferrerDetails installReferrer = installReferrerClient.getInstallReferrer();
                    String installReferrer2 = installReferrer.getInstallReferrer();
                    if (installReferrer2 != null) {
                        this.valueOf.put("val", installReferrer2);
                        this.values.put("referrer", installReferrer2);
                    }
                    long referrerClickTimestampSeconds = installReferrer.getReferrerClickTimestampSeconds();
                    this.valueOf.put("clk", Long.toString(referrerClickTimestampSeconds));
                    this.values.put("click_ts", Long.valueOf(referrerClickTimestampSeconds));
                    long installBeginTimestampSeconds = installReferrer.getInstallBeginTimestampSeconds();
                    this.valueOf.put("install", Long.toString(installBeginTimestampSeconds));
                    this.values.put("install_begin_ts", Long.valueOf(installBeginTimestampSeconds));
                    HashMap map = new HashMap();
                    try {
                        boolean googlePlayInstantParam = installReferrer.getGooglePlayInstantParam();
                        this.valueOf.put("instant", Boolean.valueOf(googlePlayInstantParam));
                        map.put("instant", Boolean.valueOf(googlePlayInstantParam));
                    } catch (NoSuchMethodError e) {
                        AFLogger.afErrorLogForExcManagerOnly("getGooglePlayInstantParam not exist", e);
                    }
                    try {
                        map.put("click_server_ts", Long.valueOf(installReferrer.getReferrerClickTimestampServerSeconds()));
                        map.put("install_begin_server_ts", Long.valueOf(installReferrer.getInstallBeginTimestampServerSeconds()));
                        map.put("install_version", installReferrer.getInstallVersion());
                    } catch (NoSuchMethodError e2) {
                        AFLogger.INSTANCE.m800e(AFg1hSDK.REFERRER, "some method not exist", e2, false, false);
                    }
                    if (!map.isEmpty()) {
                        this.values.put("google_custom", map);
                    }
                    installReferrerClient.endConnection();
                } else {
                    AFLogger.INSTANCE.m804w(AFg1hSDK.REFERRER, "ReferrerClient: InstallReferrer is not ready");
                    this.valueOf.put(NotificationCompat.CATEGORY_ERROR, "ReferrerClient: InstallReferrer is not ready");
                }
            } catch (Throwable th) {
                AFLogger aFLogger = AFLogger.INSTANCE;
                AFg1hSDK aFg1hSDK = AFg1hSDK.REFERRER;
                StringBuilder sb = new StringBuilder("Failed to get install referrer: ");
                sb.append(th.getMessage());
                aFLogger.m804w(aFg1hSDK, sb.toString());
                this.valueOf.put(NotificationCompat.CATEGORY_ERROR, th.getMessage());
                AFLogger.INSTANCE.m800e(AFg1hSDK.REFERRER, "Failed to get install referrer", th, false, false);
            }
        } else if (i == 1) {
            this.values.put("response", "SERVICE_UNAVAILABLE");
            AFLogger.INSTANCE.m804w(AFg1hSDK.REFERRER, "InstallReferrer not supported");
        } else if (i == 2) {
            AFLogger.INSTANCE.m804w(AFg1hSDK.REFERRER, "InstallReferrer FEATURE_NOT_SUPPORTED");
            this.values.put("response", "FEATURE_NOT_SUPPORTED");
        } else if (i == 3) {
            AFLogger.INSTANCE.m804w(AFg1hSDK.REFERRER, "InstallReferrer DEVELOPER_ERROR");
            this.values.put("response", "DEVELOPER_ERROR");
        } else {
            AFLogger.INSTANCE.m804w(AFg1hSDK.REFERRER, "responseCode not found.");
        }
        AFLogger.INSTANCE.m797d(AFg1hSDK.REFERRER, "Install Referrer collected locally");
        AFInAppEventType();
    }
}
