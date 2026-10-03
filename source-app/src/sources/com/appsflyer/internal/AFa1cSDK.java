package com.appsflyer.internal;

import android.content.Context;
import com.appsflyer.AFLogger;
import com.appsflyer.AppsFlyerInAppPurchaseValidatorListener;
import com.appsflyer.AppsFlyerLib;
import com.appsflyer.AppsFlyerProperties;
import com.appsflyer.attribution.AppsFlyerRequestListener;
import com.appsflyer.internal.AFe1dSDK.RunnableC08534;
import com.appsflyer.internal.components.network.http.ResponseNetwork;
import java.lang.ref.WeakReference;
import java.util.HashMap;
import java.util.Map;
import org.json.JSONObject;

public final class AFa1cSDK implements Runnable {
    final String AFInAppEventParameterName;
    private final WeakReference<Context> AFInAppEventType;
    final String AFKeystoreWrapper;
    private final String AFLogger;

    private final String f291d;

    private final Map<String, String> f292e;
    private final AFd1rSDK registerClient;
    private final String valueOf;
    final String values;

    AFa1cSDK(Context context, String str, AFd1rSDK aFd1rSDK, String str2, String str3, String str4, String str5, String str6, Map<String, String> map) {
        this.AFInAppEventType = new WeakReference<>(context);
        this.valueOf = str;
        this.AFLogger = str2;
        this.values = str4;
        this.AFKeystoreWrapper = str5;
        this.AFInAppEventParameterName = str6;
        this.f292e = map;
        this.f291d = str3;
        this.registerClient = aFd1rSDK;
    }

    @Override
    public final void run() {
        String str = this.valueOf;
        if (str == null || str.length() == 0 || AppsFlyerLib.getInstance().isStopped()) {
            return;
        }
        try {
            Context context = this.AFInAppEventType.get();
            if (context == null) {
                return;
            }
            HashMap map = new HashMap();
            map.put("public-key", this.AFLogger);
            map.put("sig-data", this.values);
            map.put("signature", this.f291d);
            Object map2 = new HashMap(map);
            Object obj = this.f292e;
            String strValueOf = AFb1vSDK.valueOf().AFInAppEventType().AFKeystoreWrapper().valueOf("referrer", "");
            AFh1oSDK aFh1oSDK = new AFh1oSDK();
            aFh1oSDK.f295e = strValueOf;
            AFb1vSDK aFb1vSDKValueOf = AFb1vSDK.valueOf();
            Map<String, Object> mapAFKeystoreWrapper = aFb1vSDKValueOf.AFKeystoreWrapper(aFh1oSDK);
            mapAFKeystoreWrapper.put("price", this.AFKeystoreWrapper);
            mapAFKeystoreWrapper.put("currency", this.AFInAppEventParameterName);
            mapAFKeystoreWrapper.put("receipt_data", map2);
            if (obj != null) {
                mapAFKeystoreWrapper.put("extra_prms", obj);
            }
            mapAFKeystoreWrapper.putAll(aFb1vSDKValueOf.AFInAppEventType().mo785i().values());
            aFh1oSDK.AFInAppEventType((Map<String, ?>) mapAFKeystoreWrapper);
            aFh1oSDK.AFKeystoreWrapper(new AFi1cSDK(this.registerClient).AFInAppEventParameterName(aFh1oSDK));
            values(context, aFh1oSDK);
            map.put("dev_key", this.valueOf);
            map.put("app_id", context.getPackageName());
            map.put("uid", AppsFlyerLib.getInstance().getAppsFlyerUID(context));
            String string = AppsFlyerProperties.getInstance().getString("advertiserId");
            if (string != null) {
                map.put("advertiserId", string);
            }
            AFh1rSDK aFh1rSDK = (AFh1rSDK) new AFh1rSDK().AFInAppEventType(map);
            aFh1rSDK.AFKeystoreWrapper(new AFi1cSDK(this.registerClient).AFInAppEventParameterName(aFh1rSDK));
            final AFf1pSDK aFf1pSDKValues = values(context, aFh1rSDK);
            aFh1rSDK.valueOf = new AppsFlyerRequestListener() {
                @Override
                public final void onSuccess() {
                    try {
                        JSONObject jSONObject = new JSONObject((String) aFf1pSDKValues.AFLogger.getBody());
                        AFLogger.afInfoLog("Validate response ok: ".concat(String.valueOf(jSONObject)));
                        AFa1cSDK.AFInAppEventType(jSONObject.optBoolean("result"), AFa1cSDK.this.values, AFa1cSDK.this.AFKeystoreWrapper, AFa1cSDK.this.AFInAppEventParameterName, jSONObject.toString());
                    } catch (Exception e) {
                        AFLogger.afErrorLog("Failed Validate request: ".concat(String.valueOf(e)), e);
                        AFa1cSDK.AFInAppEventType(false, AFa1cSDK.this.values, AFa1cSDK.this.AFKeystoreWrapper, AFa1cSDK.this.AFInAppEventParameterName, e.getMessage());
                    }
                }

                @Override
                public final void onError(int i, String str2) {
                    ResponseNetwork responseNetwork;
                    if (i == 50 && (responseNetwork = aFf1pSDKValues.AFLogger) != null) {
                        str2 = responseNetwork.toString();
                    }
                    AFa1cSDK.AFInAppEventType(false, AFa1cSDK.this.values, AFa1cSDK.this.AFKeystoreWrapper, AFa1cSDK.this.AFInAppEventParameterName, str2);
                }
            };
        } catch (Throwable th) {
            if (AFb1vSDK.valueOf != null) {
                AFLogger.afErrorLog("Failed Validate request + ex", th);
                AFInAppEventType(false, this.values, this.AFKeystoreWrapper, this.AFInAppEventParameterName, th.getMessage());
            }
            AFLogger.afErrorLog(th.getMessage(), th);
        }
    }

    private static AFf1pSDK values(Context context, AFh1qSDK aFh1qSDK) {
        AFb1vSDK.valueOf().AFInAppEventType(context);
        AFd1nSDK aFd1nSDKAFInAppEventType = AFb1vSDK.valueOf().AFInAppEventType();
        aFh1qSDK.AFInAppEventType(aFd1nSDKAFInAppEventType.AFInAppEventType().AFInAppEventParameterName.valueOf("appsFlyerCount", 0));
        AFf1pSDK aFf1pSDK = new AFf1pSDK(aFh1qSDK, aFd1nSDKAFInAppEventType);
        AFe1dSDK aFe1dSDKMo787w = aFd1nSDKAFInAppEventType.mo787w();
        aFe1dSDKMo787w.values.execute(aFe1dSDKMo787w.new RunnableC08534(aFf1pSDK));
        return aFf1pSDK;
    }

    static void AFInAppEventType(boolean z, String str, String str2, String str3, String str4) {
        if (AFb1vSDK.valueOf != null) {
            StringBuilder sb = new StringBuilder("Validate callback parameters: ");
            sb.append(str);
            sb.append(" ");
            sb.append(str2);
            sb.append(" ");
            sb.append(str3);
            AFLogger.afDebugLog(sb.toString());
            if (z) {
                AFLogger.afDebugLog("Validate in app purchase success: ".concat(String.valueOf(str4)));
                AFb1vSDK.valueOf.onValidateInApp();
                return;
            }
            AFLogger.afDebugLog("Validate in app purchase failed: ".concat(String.valueOf(str4)));
            AppsFlyerInAppPurchaseValidatorListener appsFlyerInAppPurchaseValidatorListener = AFb1vSDK.valueOf;
            if (str4 == null) {
                str4 = "Failed validating";
            }
            appsFlyerInAppPurchaseValidatorListener.onValidateInAppFailure(str4);
        }
    }
}
