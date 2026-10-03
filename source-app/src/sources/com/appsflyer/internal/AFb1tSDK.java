package com.appsflyer.internal;

import android.content.ContentResolver;
import android.content.Context;
import android.os.Build;
import android.provider.Settings;
import com.appsflyer.AFLogger;
import com.appsflyer.AppsFlyerProperties;
import com.appsflyer.oaid.OaidClient;
import com.google.android.gms.ads.identifier.AdvertisingIdClient;
import com.google.android.gms.common.GoogleApiAvailability;
import java.util.Map;

public final class AFb1tSDK {
    static Boolean AFInAppEventParameterName;
    static String AFKeystoreWrapper;

    public static AFa1aSDK AFInAppEventType(ContentResolver contentResolver) {
        String string;
        if (!AFKeystoreWrapper() || contentResolver == null || AppsFlyerProperties.getInstance().getString("amazon_aid") != null || !"Amazon".equals(Build.MANUFACTURER)) {
            return null;
        }
        int i = Settings.Secure.getInt(contentResolver, "limit_ad_tracking", 2);
        if (i == 0) {
            return new AFa1aSDK(Settings.Secure.getString(contentResolver, "advertising_id"), Boolean.FALSE);
        }
        if (i == 2) {
            return null;
        }
        try {
            string = Settings.Secure.getString(contentResolver, "advertising_id");
        } catch (Throwable th) {
            AFLogger.afErrorLog("Couldn't fetch Amazon Advertising ID (Ad-Tracking is limited!)", th);
            string = "";
        }
        return new AFa1aSDK(string, Boolean.TRUE);
    }

    public static AFa1aSDK AFInAppEventParameterName(Context context) {
        Boolean lat;
        AppsFlyerProperties appsFlyerProperties = AppsFlyerProperties.getInstance();
        String str = AFKeystoreWrapper;
        boolean z = str != null;
        if (z) {
            lat = null;
        } else {
            Boolean bool = AFInAppEventParameterName;
            if ((bool == null || !bool.booleanValue()) && !(AFInAppEventParameterName == null && appsFlyerProperties.getBoolean(AppsFlyerProperties.COLLECT_OAID, true))) {
                lat = null;
                str = null;
            } else {
                try {
                    OaidClient oaidClient = new OaidClient(context);
                    oaidClient.setLogging(appsFlyerProperties.isEnableLog());
                    OaidClient.Info infoFetch = oaidClient.fetch();
                    if (infoFetch != null) {
                        String id = infoFetch.getId();
                        try {
                            lat = infoFetch.getLat();
                            str = id;
                        } catch (Throwable unused) {
                            str = id;
                            AFLogger.afDebugLog("No OAID library");
                            lat = null;
                        }
                    } else {
                        lat = null;
                        str = null;
                    }
                } catch (Throwable unused2) {
                    str = null;
                }
            }
        }
        if (str == null) {
            return null;
        }
        AFa1aSDK aFa1aSDK = new AFa1aSDK(str, lat);
        aFa1aSDK.values = Boolean.valueOf(z);
        return aFa1aSDK;
    }

    public static AFa1aSDK valueOf(Context context, Map<String, Object> map) {
        int iIsGooglePlayServicesAvailable;
        boolean z;
        Throwable th;
        Boolean bool;
        String str = null;
        Boolean boolValueOf = null;
        if (!AFKeystoreWrapper()) {
            return null;
        }
        AFLogger.afInfoLog("Trying to fetch GAID..");
        StringBuilder sb = new StringBuilder();
        try {
            iIsGooglePlayServicesAvailable = GoogleApiAvailability.getInstance().isGooglePlayServicesAvailable(context);
        } catch (Throwable th2) {
            AFLogger.afErrorLogForExcManagerOnly("isGooglePlayServicesAvailable error", th2);
            iIsGooglePlayServicesAvailable = -1;
        }
        try {
            Class.forName("com.google.android.gms.ads.identifier.AdvertisingIdClient");
            AdvertisingIdClient.Info advertisingIdInfo = AdvertisingIdClient.getAdvertisingIdInfo(context);
            if (advertisingIdInfo != null) {
                String string = advertisingIdInfo.getId();
                try {
                    boolValueOf = Boolean.valueOf(advertisingIdInfo.isLimitAdTrackingEnabled());
                    if (string != null) {
                        try {
                            if (string.length() == 0) {
                                sb.append("emptyOrNull |");
                            }
                        } catch (Throwable th3) {
                            th = th3;
                            z = true;
                            Throwable th4 = th;
                            bool = boolValueOf;
                            str = string;
                            th = th4;
                            StringBuilder sb2 = new StringBuilder("Google Play Services is missing ");
                            sb2.append(th.getMessage());
                            AFLogger.afErrorLog(sb2.toString(), th, false, false);
                            sb.append(th.getClass().getSimpleName());
                            sb.append(" |");
                            AFLogger.afInfoLog("WARNING: Google Play Services is missing.");
                            if (AppsFlyerProperties.getInstance().getBoolean(AppsFlyerProperties.ENABLE_GPS_FALLBACK, true)) {
                                try {
                                    AFb1ySDK.AFa1ySDK aFa1ySDKAFKeystoreWrapper = AFb1ySDK.AFKeystoreWrapper(context);
                                    String str2 = aFa1ySDKAFKeystoreWrapper.AFInAppEventParameterName;
                                    boolValueOf = Boolean.valueOf(aFa1ySDKAFKeystoreWrapper.AFInAppEventType());
                                    if (str2 == null || str2.length() == 0) {
                                        sb.append("emptyOrNull (bypass) |");
                                    }
                                    string = str2;
                                } catch (Throwable th5) {
                                    AFLogger.afErrorLog(th5.getMessage(), th5, true, false, false);
                                    sb.append(th5.getClass().getSimpleName());
                                    sb.append(" |");
                                    string = AppsFlyerProperties.getInstance().getString("advertiserId");
                                    Boolean boolValueOf2 = Boolean.valueOf(!Boolean.parseBoolean(AppsFlyerProperties.getInstance().getString("advertiserIdEnabled")));
                                    if (th5.getLocalizedMessage() != null) {
                                        AFLogger.afInfoLog(th5.getLocalizedMessage());
                                    } else {
                                        AFLogger.afInfoLog(th5.toString());
                                    }
                                    boolValueOf = boolValueOf2;
                                }
                            } else {
                                string = str;
                                boolValueOf = bool;
                            }
                        }
                    } else {
                        sb.append("emptyOrNull |");
                    }
                    z = true;
                } catch (Throwable th6) {
                    th = th6;
                    z = false;
                }
                if (context.getClass().getName().equals("android.app.ReceiverRestrictedContext")) {
                    string = AppsFlyerProperties.getInstance().getString("advertiserId");
                    boolValueOf = Boolean.valueOf(!Boolean.parseBoolean(AppsFlyerProperties.getInstance().getString("advertiserIdEnabled")));
                    sb.append("context = android.app.ReceiverRestrictedContext |");
                }
                if (sb.length() > 0) {
                    StringBuilder sb3 = new StringBuilder();
                    sb3.append(iIsGooglePlayServicesAvailable);
                    sb3.append(": ");
                    sb3.append((Object) sb);
                    map.put("gaidError", sb3.toString());
                }
                if (string != null && boolValueOf != null) {
                    map.put("advertiserId", string);
                    map.put("advertiserIdEnabled", String.valueOf(!boolValueOf.booleanValue()));
                    AppsFlyerProperties.getInstance().set("advertiserId", string);
                    AppsFlyerProperties.getInstance().set("advertiserIdEnabled", String.valueOf(!boolValueOf.booleanValue()));
                    map.put("isGaidWithGps", String.valueOf(z));
                }
                return new AFa1aSDK(string, boolValueOf);
            }
            sb.append("gpsAdInfo-null |");
            throw new IllegalStateException("GpsAdIndo is null");
        } catch (Throwable th7) {
            z = false;
            th = th7;
            bool = null;
        }
    }

    private static boolean AFKeystoreWrapper() {
        Boolean bool = AFInAppEventParameterName;
        return bool == null || bool.booleanValue();
    }
}
