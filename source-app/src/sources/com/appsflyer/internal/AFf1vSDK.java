package com.appsflyer.internal;

import android.net.Uri;
import com.appsflyer.AFLogger;
import com.appsflyer.internal.AFe1dSDK.RunnableC08534;
import com.facebook.internal.ServerProtocol;

public final class AFf1vSDK extends AFe1fSDK<Boolean> {

    private static volatile boolean f372e = false;
    private final AFb1rSDK AFLogger;

    private final AFe1dSDK f373d;
    private final AFd1nSDK registerClient;
    private Boolean unregisterClient;

    @Override
    public final long AFKeystoreWrapper() {
        return 30000L;
    }

    @Override
    public final boolean values() {
        return false;
    }

    public AFf1vSDK(AFd1nSDK aFd1nSDK) {
        super(AFe1bSDK.LOAD_CACHE, new AFe1bSDK[0], "LoadCachedRequests");
        this.AFLogger = aFd1nSDK.afRDLog();
        this.f373d = aFd1nSDK.mo787w();
        this.registerClient = aFd1nSDK;
    }

    public static boolean unregisterClient() {
        return f372e;
    }

    @Override
    public final AFe1cSDK AFInAppEventType() throws Exception {
        for (AFb1kSDK aFb1kSDK : this.AFLogger.valueOf()) {
            AFLogger aFLogger = AFLogger.INSTANCE;
            AFg1hSDK aFg1hSDK = AFg1hSDK.CACHE;
            StringBuilder sb = new StringBuilder("resending request: ");
            sb.append(aFb1kSDK.valueOf);
            aFLogger.m802i(aFg1hSDK, sb.toString());
            try {
                AFh1tSDK aFh1tSDK = new AFh1tSDK(values(aFb1kSDK), aFb1kSDK.AFInAppEventType(), aFb1kSDK.AFInAppEventParameterName, aFb1kSDK.AFKeystoreWrapper);
                AFe1dSDK aFe1dSDK = this.f373d;
                aFe1dSDK.values.execute(aFe1dSDK.new RunnableC08534(new AFf1qSDK(aFh1tSDK, this.registerClient)));
            } catch (Exception e) {
                AFLogger.INSTANCE.m798e(AFg1hSDK.QUEUE, "Failed to resend cached request", e);
            }
        }
        this.unregisterClient = Boolean.TRUE;
        f372e = true;
        return AFe1cSDK.SUCCESS;
    }

    private static String values(AFb1kSDK aFb1kSDK) {
        long jCurrentTimeMillis = System.currentTimeMillis();
        long j = Long.parseLong(aFb1kSDK.AFInAppEventParameterName, 10);
        String str = aFb1kSDK.valueOf;
        try {
            return Uri.parse(str).buildUpon().appendQueryParameter("isCachedRequest", ServerProtocol.DIALOG_RETURN_SCOPES_TRUE).appendQueryParameter("timeincache", String.valueOf((jCurrentTimeMillis - j) / 1000)).toString();
        } catch (Exception e) {
            AFLogger.afErrorLogForExcManagerOnly("Couldn't parse the uri", e);
            return str;
        }
    }
}
