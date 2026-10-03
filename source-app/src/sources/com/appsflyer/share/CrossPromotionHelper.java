package com.appsflyer.share;

import android.content.Context;
import com.appsflyer.AFLogger;
import com.appsflyer.AppsFlyerLib;
import com.appsflyer.AppsFlyerProperties;
import com.appsflyer.internal.AFb1vSDK;
import com.appsflyer.internal.AFd1nSDK;
import com.appsflyer.internal.AFe1dSDK;
import com.appsflyer.internal.AFe1dSDK.RunnableC08534;
import com.appsflyer.internal.AFf1sSDK;
import com.appsflyer.internal.AFg1hSDK;
import com.appsflyer.internal.AFj1ySDK;
import com.appsflyer.internal.AFj1zSDK;
import java.util.HashMap;
import java.util.Map;

public class CrossPromotionHelper {
    private static String AFKeystoreWrapper = "https://%simpression.%s";

    public static void logAndOpenStore(Context context, String str, String str2) {
        logAndOpenStore(context, str, str2, null);
    }

    public static void logAndOpenStore(Context context, String str, String str2, Map<String, String> map) {
        LinkGenerator linkGeneratorValues = values(context, str, str2, map, String.format(AFj1zSDK.AFInAppEventParameterName, AppsFlyerLib.getInstance().getHostPrefix(), AFb1vSDK.valueOf().getHostName()));
        if (AppsFlyerProperties.getInstance().getBoolean(AppsFlyerProperties.AF_WAITFOR_CUSTOMERID, false)) {
            AFLogger.INSTANCE.mo761i(AFg1hSDK.CROSS_PROMOTION, "CustomerUserId not set, track And Open Store is disabled", true);
            return;
        }
        if (AppsFlyerLib.getInstance().isStopped()) {
            AFLogger.INSTANCE.mo761i(AFg1hSDK.CROSS_PROMOTION, "SDK is stopped, track And Open Store is disabled", true);
            return;
        }
        if (map == null) {
            map = new HashMap<>();
        }
        map.put("af_campaign", str2);
        AppsFlyerLib.getInstance().logEvent(context, "af_cross_promotion", map);
        AFKeystoreWrapper(linkGeneratorValues.generateLink(), context, new AFj1ySDK(context));
    }

    public static void logCrossPromoteImpression(Context context, String str, String str2) {
        logCrossPromoteImpression(context, str, str2, null);
    }

    public static void logCrossPromoteImpression(Context context, String str, String str2, Map<String, String> map) {
        if (AppsFlyerProperties.getInstance().getBoolean(AppsFlyerProperties.AF_WAITFOR_CUSTOMERID, false)) {
            AFLogger.INSTANCE.mo761i(AFg1hSDK.CROSS_PROMOTION, "CustomerUserId not set, Promote Impression is disabled", true);
        } else if (AppsFlyerLib.getInstance().isStopped()) {
            AFLogger.INSTANCE.mo761i(AFg1hSDK.CROSS_PROMOTION, "SDK is stopped, Promote Impression is disabled", true);
        } else {
            AFKeystoreWrapper(values(context, str, str2, map, String.format(AFKeystoreWrapper, AppsFlyerLib.getInstance().getHostPrefix(), AFb1vSDK.valueOf().getHostName())).generateLink(), context, null);
        }
    }

    private static void AFKeystoreWrapper(String str, Context context, AFj1ySDK aFj1ySDK) {
        AFb1vSDK aFb1vSDKValueOf = AFb1vSDK.valueOf();
        aFb1vSDKValueOf.AFInAppEventType(context);
        AFd1nSDK aFd1nSDKAFInAppEventType = aFb1vSDKValueOf.AFInAppEventType();
        AFf1sSDK aFf1sSDK = new AFf1sSDK(aFd1nSDKAFInAppEventType, str, aFj1ySDK);
        AFe1dSDK aFe1dSDKMo787w = aFd1nSDKAFInAppEventType.mo787w();
        aFe1dSDKMo787w.values.execute(aFe1dSDKMo787w.new RunnableC08534(aFf1sSDK));
    }

    private static LinkGenerator values(Context context, String str, String str2, Map<String, String> map, String str3) {
        LinkGenerator linkGenerator = new LinkGenerator("af_cross_promotion");
        linkGenerator.AFInAppEventParameterName = str3;
        linkGenerator.AFInAppEventType = str;
        linkGenerator.addParameter("af_siteid", context.getPackageName());
        if (str2 != null) {
            linkGenerator.setCampaign(str2);
        }
        if (map != null) {
            linkGenerator.addParameters(map);
        }
        String string = AppsFlyerProperties.getInstance().getString("advertiserId");
        if (string != null) {
            linkGenerator.addParameter("advertising_id", string);
        }
        return linkGenerator;
    }

    public static void setUrl(Map<String, String> map) {
        byte b;
        for (Map.Entry<String, String> entry : map.entrySet()) {
            String value = entry.getValue();
            String key = entry.getKey();
            int iHashCode = key.hashCode();
            if (iHashCode != 96801) {
                if (iHashCode == 120623625 && key.equals("impression")) {
                    b = 1;
                } else {
                    b = -1;
                }
            } else if (key.equals("app")) {
                b = 0;
            } else {
                b = -1;
            }
            if (b == 0) {
                AFj1zSDK.AFInAppEventParameterName = value;
            } else if (b == 1) {
                AFKeystoreWrapper = value;
            }
        }
    }
}
