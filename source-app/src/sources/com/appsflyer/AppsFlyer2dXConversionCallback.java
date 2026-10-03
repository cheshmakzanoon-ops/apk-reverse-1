package com.appsflyer;

import com.appsflyer.deeplink.DeepLinkListener;
import com.appsflyer.deeplink.DeepLinkResult;
import com.appsflyer.share.LinkGenerator;
import com.facebook.login.LoginLogger;
import java.util.Map;
import org.json.JSONException;
import org.json.JSONObject;

public class AppsFlyer2dXConversionCallback implements AppsFlyerConversionListener, DeepLinkListener, LinkGenerator.ResponseListener {
    public native void onAppOpenAttributionNative(Object obj);

    public native void onAttributionFailureNative(Object obj);

    public native void onDeepLinkingNative(DeepLinkResult deepLinkResult);

    public native void onInstallConversionDataLoadedNative(Object obj);

    public native void onInstallConversionFailureNative(Object obj);

    public native void onResponseErrorNative(String str);

    public native void onResponseNative(String str);

    @Override
    public void onConversionDataSuccess(Map<String, Object> map) {
        onInstallConversionDataLoadedNative(map);
    }

    @Override
    public void onConversionDataFail(String str) {
        AFInAppEventParameterName("onAttributionFailure", str);
    }

    @Override
    public void onAppOpenAttribution(Map<String, String> map) {
        onAppOpenAttributionNative(map);
    }

    @Override
    public void onAttributionFailure(String str) {
        AFInAppEventParameterName("onInstallConversionFailure", str);
    }

    @Override
    public void onDeepLinking(DeepLinkResult deepLinkResult) {
        onDeepLinkingNative(deepLinkResult);
    }

    private void AFInAppEventParameterName(String str, String str2) {
        byte b;
        try {
            JSONObject jSONObject = new JSONObject();
            jSONObject.put("status", LoginLogger.EVENT_EXTRAS_FAILURE);
            jSONObject.put("data", str2);
            int iHashCode = str.hashCode();
            if (iHashCode != -1390007222) {
                if (iHashCode == 1050716216 && str.equals("onInstallConversionFailure")) {
                    b = 0;
                } else {
                    b = -1;
                }
            } else if (str.equals("onAttributionFailure")) {
                b = 1;
            } else {
                b = -1;
            }
            if (b == 0) {
                onInstallConversionFailureNative(jSONObject);
            } else {
                if (b != 1) {
                    return;
                }
                onAttributionFailureNative(jSONObject);
            }
        } catch (JSONException e) {
            AFLogger.afErrorLogForExcManagerOnly("2dx error", e);
            e.printStackTrace();
        }
    }

    @Override
    public void onResponse(String str) {
        onResponseNative(str);
    }

    @Override
    public void onResponseError(String str) {
        onResponseErrorNative(str);
    }
}
