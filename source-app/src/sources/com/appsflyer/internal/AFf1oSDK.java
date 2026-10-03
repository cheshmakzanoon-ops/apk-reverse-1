package com.appsflyer.internal;

import android.content.Context;
import android.net.Uri;
import com.appsflyer.AFLogger;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

public final class AFf1oSDK extends AFe1fSDK<Map<String, Object>> {

    private static final int f359e = (int) TimeUnit.SECONDS.toMillis(2);
    private Map<String, Object> AFLogger;

    private final Uri f360d;
    private final Context registerClient;
    private final AFc1oSDK unregisterClient;

    private final List<String> f361w;

    @Override
    public final long AFKeystoreWrapper() {
        return 60000L;
    }

    @Override
    public final boolean values() {
        return false;
    }

    public AFf1oSDK(Context context, AFc1oSDK aFc1oSDK, Uri uri, List<String> list) {
        super(AFe1bSDK.RESOLVE_ESP, new AFe1bSDK[]{AFe1bSDK.RC_CDN}, "ResolveEsp");
        this.registerClient = context;
        this.unregisterClient = aFc1oSDK;
        this.f360d = uri;
        this.f361w = list;
    }

    @Override
    public final AFe1cSDK AFInAppEventType() throws Exception {
        Integer num = null;
        if (!valueOf(this.f360d.toString())) {
            AFb1vSDK.valueOf().values(this.registerClient, this.unregisterClient, this.f360d, null);
            return AFe1cSDK.SUCCESS;
        }
        long jCurrentTimeMillis = System.currentTimeMillis();
        String string = this.f360d.toString();
        ArrayList arrayList = new ArrayList();
        int i = 0;
        String str = null;
        while (i < 5) {
            Map<String, Object> mapValues = values(Uri.parse(string));
            String str2 = (String) mapValues.get("res");
            Integer num2 = (Integer) mapValues.get("status");
            String str3 = (String) mapValues.get("error");
            if (str2 == null || !valueOf(str2)) {
                str = str3;
                string = str2;
                num = num2;
                break;
            }
            if (i < 4) {
                arrayList.add(str2);
            }
            i++;
            str = str3;
            string = str2;
            num = num2;
        }
        HashMap map = new HashMap();
        map.put("res", string != null ? string : "");
        map.put("status", Integer.valueOf(num != null ? num.intValue() : -1));
        if (str != null) {
            map.put("error", str);
        }
        if (!arrayList.isEmpty()) {
            map.put("redirects", arrayList);
        }
        map.put("latency", Long.valueOf(System.currentTimeMillis() - jCurrentTimeMillis));
        synchronized (this.unregisterClient) {
            this.unregisterClient.AFInAppEventType("af_deeplink_r", map);
            this.unregisterClient.AFInAppEventType("af_deeplink", this.f360d.toString());
        }
        AFb1vSDK.valueOf().values(this.registerClient, this.unregisterClient, string != null ? Uri.parse(string) : this.f360d, this.f360d);
        this.AFLogger = map;
        return AFe1cSDK.SUCCESS;
    }

    private static Map<String, Object> values(Uri uri) {
        HashMap map = new HashMap();
        try {
            StringBuilder sb = new StringBuilder("ESP deeplink resolving is started: ");
            sb.append(uri.toString());
            AFLogger.afDebugLog(sb.toString());
            HttpURLConnection httpURLConnection = (HttpURLConnection) new URL(uri.toString()).openConnection();
            httpURLConnection.setInstanceFollowRedirects(false);
            int i = f359e;
            httpURLConnection.setReadTimeout(i);
            httpURLConnection.setConnectTimeout(i);
            httpURLConnection.setRequestProperty("User-agent", "Dalvik/2.1.0 (Linux; U; Android 6.0.1; Nexus 5 Build/M4B30Z)");
            httpURLConnection.setRequestProperty("af-esp", "6.13.0");
            int responseCode = httpURLConnection.getResponseCode();
            map.put("status", Integer.valueOf(responseCode));
            if (300 <= responseCode && responseCode <= 305) {
                map.put("res", httpURLConnection.getHeaderField("Location"));
            }
            httpURLConnection.disconnect();
            AFLogger.afDebugLog("ESP deeplink resolving is finished");
        } catch (Throwable th) {
            map.put("error", th.getLocalizedMessage());
            AFLogger.afErrorLog(th.getMessage(), th);
        }
        return map;
    }

    private boolean valueOf(String str) {
        if (str.contains("af_tranid=")) {
            return false;
        }
        StringBuilder sb = new StringBuilder("Validate if link ");
        sb.append(str);
        sb.append(" belongs to ESP domains: ");
        sb.append(this.f361w);
        AFLogger.afRDLog(sb.toString());
        try {
            return this.f361w.contains(new URL(str).getHost());
        } catch (MalformedURLException e) {
            AFLogger.afErrorLogForExcManagerOnly("MalformedURLException ESP link", e);
            return false;
        }
    }
}
