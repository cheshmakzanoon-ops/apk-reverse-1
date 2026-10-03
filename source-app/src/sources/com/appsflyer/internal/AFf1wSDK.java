package com.appsflyer.internal;

import android.os.Build;
import com.appsflyer.AppsFlyerProperties;
import com.appsflyer.PurchaseHandler;
import com.appsflyer.attribution.AppsFlyerRequestListener;
import com.appsflyer.internal.components.network.http.ResponseNetwork;
import java.util.HashMap;
import java.util.Map;
import org.json.JSONObject;

public abstract class AFf1wSDK extends AFf1tSDK<String> {
    private final AFe1bSDK afInfoLog;
    private final String afRDLog;
    private final PurchaseHandler.PurchaseValidationCallback afVerboseLog;
    private final String afWarnLog;
    private final AFd1xSDK force;

    private final Map<String, Object> f374i;
    private final AFd1rSDK registerClient;

    private final AFg1qSDK f375v;

    private final AFg1xSDK f376w;

    @Override
    protected final AppsFlyerRequestListener registerClient() {
        return null;
    }

    @Override
    protected final boolean unregisterClient() {
        return true;
    }

    public AFf1wSDK(AFe1bSDK aFe1bSDK, AFe1bSDK[] aFe1bSDKArr, AFd1nSDK aFd1nSDK, Map<String, Object> map, PurchaseHandler.PurchaseValidationCallback purchaseValidationCallback) {
        super(aFe1bSDK, aFe1bSDKArr, aFd1nSDK, null);
        this.afInfoLog = aFe1bSDK;
        AFd1rSDK aFd1rSDKAFInAppEventType = aFd1nSDK.AFInAppEventType();
        this.registerClient = aFd1rSDKAFInAppEventType;
        AFd1xSDK aFd1xSDKAFKeystoreWrapper = aFd1nSDK.AFKeystoreWrapper();
        this.force = aFd1xSDKAFKeystoreWrapper;
        AFg1qSDK aFg1qSDKMo783d = aFd1nSDK.mo783d();
        this.f375v = aFg1qSDKMo783d;
        AFg1xSDK aFg1xSDKOnInstallConversionDataLoadedNative = aFd1nSDK.onInstallConversionDataLoadedNative();
        this.f376w = aFg1xSDKOnInstallConversionDataLoadedNative;
        String str = map.containsKey("billing_library_version") ? (String) map.remove("billing_library_version") : null;
        this.afRDLog = str;
        String str2 = map.containsKey("connector_version") ? (String) map.remove("connector_version") : null;
        this.afWarnLog = str2;
        HashMap map2 = new HashMap(new HashMap(map));
        map2.put("app_id", aFd1rSDKAFInAppEventType.AFKeystoreWrapper.AFInAppEventParameterName.getPackageName());
        map2.put("event_timestamp", Long.valueOf(aFg1qSDKMo783d.AFKeystoreWrapper()));
        String strAFInAppEventParameterName = AFd1rSDK.AFInAppEventParameterName();
        if (strAFInAppEventParameterName != null) {
            map2.put("cuid", strAFInAppEventParameterName);
        }
        map2.put("app_version_name", AFb1qSDK.AFKeystoreWrapper(aFd1rSDKAFInAppEventType.AFKeystoreWrapper.AFInAppEventParameterName, aFd1rSDKAFInAppEventType.AFKeystoreWrapper.AFInAppEventParameterName.getPackageName()));
        HashMap map3 = new HashMap();
        AFa1aSDK aFa1aSDKValueOf = AFb1tSDK.valueOf(aFd1rSDKAFInAppEventType.AFKeystoreWrapper.AFInAppEventParameterName, new HashMap());
        String str3 = aFa1aSDKValueOf != null ? aFa1aSDKValueOf.valueOf : null;
        if (!AFc1rSDK.AFInAppEventType(str3)) {
            map3.put("advertising_id", str3);
        }
        AFa1aSDK aFa1aSDKAFInAppEventType = AFb1tSDK.AFInAppEventType(aFd1rSDKAFInAppEventType.AFKeystoreWrapper.AFInAppEventParameterName.getContentResolver());
        String str4 = aFa1aSDKAFInAppEventType != null ? aFa1aSDKAFInAppEventType.valueOf : null;
        if (!AFc1rSDK.AFInAppEventType(str4)) {
            map3.put("oaid", str4);
        }
        AFa1aSDK aFa1aSDKAFInAppEventType2 = AFb1tSDK.AFInAppEventType(aFd1rSDKAFInAppEventType.AFKeystoreWrapper.AFInAppEventParameterName.getContentResolver());
        String str5 = aFa1aSDKAFInAppEventType2 != null ? aFa1aSDKAFInAppEventType2.valueOf : null;
        if (!AFc1rSDK.AFInAppEventType(str5)) {
            map3.put("amazon_aid", str5);
        }
        if (!AppsFlyerProperties.getInstance().getBoolean(AppsFlyerProperties.DEVICE_TRACKING_DISABLED, false)) {
            String strValueOf = ((AFf1tSDK) this).unregisterClient.valueOf(aFd1xSDKAFKeystoreWrapper);
            if (!AFc1rSDK.AFInAppEventType(strValueOf)) {
                map3.put("imei", strValueOf);
            }
        }
        map3.put("appsflyer_id", AFb1lSDK.values(aFd1rSDKAFInAppEventType.AFKeystoreWrapper, aFd1rSDKAFInAppEventType.AFInAppEventParameterName));
        StringBuilder sb = new StringBuilder();
        sb.append(Build.VERSION.SDK_INT);
        map3.put("os_version", sb.toString());
        map3.put("sdk_version", "6.13.0");
        if (!AFc1rSDK.AFInAppEventType(str2)) {
            map3.put("sdk_connector_version", str2);
        }
        map2.put("device_data", map3);
        if (!AFc1rSDK.AFInAppEventType(str)) {
            map2.put("billing_lib_version", str);
        }
        aFg1xSDKOnInstallConversionDataLoadedNative.AFKeystoreWrapper(map2, aFe1bSDK);
        this.f374i = map2;
        this.afVerboseLog = purchaseValidationCallback;
    }

    @Override
    public final void valueOf() {
        PurchaseHandler.PurchaseValidationCallback purchaseValidationCallback;
        PurchaseHandler.PurchaseValidationCallback purchaseValidationCallback2;
        super.valueOf();
        Throwable thM790d = m790d();
        if (thM790d != null && (purchaseValidationCallback2 = this.afVerboseLog) != null) {
            purchaseValidationCallback2.onFailure(thM790d);
        }
        ResponseNetwork<String> responseNetwork = this.AFLogger;
        if (responseNetwork == null || (purchaseValidationCallback = this.afVerboseLog) == null) {
            return;
        }
        purchaseValidationCallback.onResponse(responseNetwork);
    }

    public final String m796w() {
        return this.afRDLog;
    }

    protected final Map<String, Object> afInfoLog() {
        return this.f374i;
    }

    protected final void AFKeystoreWrapper(String str) {
        String string = new JSONObject(this.f374i).toString();
        StringBuilder sb = new StringBuilder();
        sb.append(this);
        sb.append(": preparing data: ");
        sb.append(string);
        AFb1bSDK.valueOf(sb.toString());
        ((AFf1tSDK) this).f366d.AFKeystoreWrapper(str, string);
    }

    @Override
    public boolean values() {
        if (this.AFLogger == null || this.AFLogger.getStatusCode() != 503) {
            return super.values();
        }
        return true;
    }
}
