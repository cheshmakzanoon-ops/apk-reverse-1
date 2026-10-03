package com.appsflyer.internal;

import com.appsflyer.AppsFlyerConsent;
import com.appsflyer.AppsFlyerProperties;
import java.util.LinkedHashMap;
import java.util.Map;
import kotlin.TuplesKt;
import kotlin.collections.MapsKt;
import kotlin.jvm.internal.Intrinsics;

public final class AFg1ySDK implements AFg1xSDK {
    private final AppsFlyerProperties AFInAppEventParameterName;
    private final AFd1sSDK AFInAppEventType;
    private final AFf1aSDK valueOf;

    public AFg1ySDK(AFf1aSDK aFf1aSDK, AFd1sSDK aFd1sSDK, AppsFlyerProperties appsFlyerProperties) {
        Intrinsics.checkNotNullParameter(aFf1aSDK, "");
        Intrinsics.checkNotNullParameter(aFd1sSDK, "");
        Intrinsics.checkNotNullParameter(appsFlyerProperties, "");
        this.valueOf = aFf1aSDK;
        this.AFInAppEventType = aFd1sSDK;
        this.AFInAppEventParameterName = appsFlyerProperties;
    }

    @Override
    public final void AFKeystoreWrapper(Map<String, Object> map, AFe1bSDK aFe1bSDK) {
        Intrinsics.checkNotNullParameter(map, "");
        Intrinsics.checkNotNullParameter(aFe1bSDK, "");
        AFg1vSDK aFg1vSDKAFInAppEventType = this.valueOf.AFInAppEventType();
        AppsFlyerConsent appsFlyerConsent = this.AFInAppEventType.registerClient;
        LinkedHashMap linkedHashMap = new LinkedHashMap();
        if (appsFlyerConsent != null) {
            LinkedHashMap linkedHashMap2 = new LinkedHashMap();
            linkedHashMap2.put("gdpr_applies", Boolean.valueOf(appsFlyerConsent.isUserSubjectToGDPR()));
            Boolean hasConsentForDataUsage = appsFlyerConsent.getHasConsentForDataUsage();
            if (hasConsentForDataUsage != null) {
                hasConsentForDataUsage.booleanValue();
                linkedHashMap2.put("ad_user_data_enabled", hasConsentForDataUsage);
            }
            Boolean hasConsentForAdsPersonalization = appsFlyerConsent.getHasConsentForAdsPersonalization();
            if (hasConsentForAdsPersonalization != null) {
                hasConsentForAdsPersonalization.booleanValue();
                linkedHashMap2.put("ad_personalization_enabled", hasConsentForAdsPersonalization);
            }
            linkedHashMap.put("manual", linkedHashMap2);
        }
        if (aFg1vSDKAFInAppEventType != null) {
            boolean z = appsFlyerConsent != null;
            LinkedHashMap linkedHashMap3 = new LinkedHashMap();
            linkedHashMap3.put("policy_version", Integer.valueOf(aFg1vSDKAFInAppEventType.AFKeystoreWrapper));
            linkedHashMap3.put("cmp_sdk_id", Integer.valueOf(aFg1vSDKAFInAppEventType.AFInAppEventType));
            linkedHashMap3.put("cmp_sdk_version", Integer.valueOf(aFg1vSDKAFInAppEventType.values));
            if (z) {
                linkedHashMap3.put("gdpr_applies", -1);
                linkedHashMap3.put("tcstring", "");
            } else {
                linkedHashMap3.put("gdpr_applies", Integer.valueOf(aFg1vSDKAFInAppEventType.AFInAppEventParameterName));
                linkedHashMap3.put("tcstring", aFg1vSDKAFInAppEventType.valueOf);
            }
            linkedHashMap.put("tcf", linkedHashMap3);
        }
        if (!linkedHashMap.isEmpty()) {
            map.put("consent_data", linkedHashMap);
        }
        if (aFe1bSDK != AFe1bSDK.CONVERSION || this.AFInAppEventParameterName.getString(AppsFlyerProperties.ENABLE_TCF_DATA_COLLECTION) == null) {
            return;
        }
        Map<String, Object> mapAFInAppEventType = AFb1vSDK.AFInAppEventType(map);
        Intrinsics.checkNotNullExpressionValue(mapAFInAppEventType, "");
        mapAFInAppEventType.put("api", MapsKt.mapOf(TuplesKt.to(AppsFlyerProperties.ENABLE_TCF_DATA_COLLECTION, this.AFInAppEventParameterName.getString(AppsFlyerProperties.ENABLE_TCF_DATA_COLLECTION))));
    }
}
