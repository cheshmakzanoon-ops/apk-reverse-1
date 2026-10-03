package com.appsflyer;

import com.appsflyer.internal.AFd1xSDK;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import org.json.JSONException;
import org.json.JSONObject;

public class AppsFlyerProperties {
    public static final String ADDITIONAL_CUSTOM_DATA = "additionalCustomData";
    public static final String AF_STORE_FROM_API = "api_store_value";
    public static final String AF_WAITFOR_CUSTOMERID = "waitForCustomerId";
    public static final String APP_ID = "appid";
    public static final String APP_USER_ID = "AppUserId";
    public static final String CHANNEL = "channel";
    public static final String COLLECT_ANDROID_ID = "collectAndroidId";
    public static final String COLLECT_ANDROID_ID_FORCE_BY_USER = "collectAndroidIdForceByUser";
    public static final String COLLECT_FACEBOOK_ATTR_ID = "collectFacebookAttrId";
    public static final String COLLECT_IMEI = "collectIMEI";
    public static final String COLLECT_IMEI_FORCE_BY_USER = "collectIMEIForceByUser";
    public static final String COLLECT_OAID = "collectOAID";
    public static final String CURRENCY_CODE = "currencyCode";
    public static final String DEVICE_TRACKING_DISABLED = "deviceTrackingDisabled";
    public static final String DISABLE_KEYSTORE = "keyPropDisableAFKeystore";
    public static final String DISABLE_LOGS_COMPLETELY = "disableLogs";
    public static final String DISABLE_NETWORK_DATA = "disableCollectNetworkData";
    public static final String DISABLE_OTHER_SDK = "disableOtherSdk";
    public static final String DPM = "disableProxy";
    public static final String EMAIL_CRYPT_TYPE = "userEmailsCryptType";
    public static final String ENABLE_GPS_FALLBACK = "enableGpsFallback";
    public static final String ENABLE_TCF_DATA_COLLECTION = "enableTCFDataCollection";
    public static final String EXTENSION = "sdkExtension";
    public static final String HTTP_CACHE = "http_cache";
    public static final String IS_UPDATE = "IS_UPDATE";
    public static final String LAUNCH_PROTECT_ENABLED = "launchProtectEnabled";
    public static final String NEW_REFERRER_SENT = "newGPReferrerSent";
    public static final String ONELINK_DOMAIN = "onelinkDomain";
    public static final String ONELINK_ID = "oneLinkSlug";
    public static final String ONELINK_SCHEME = "onelinkScheme";
    public static final String ONELINK_VERSION = "onelinkVersion";
    public static final String USER_EMAILS = "userEmails";
    public static AppsFlyerProperties instance;
    public boolean AFInAppEventType;
    public String AFKeystoreWrapper;
    private final Map<String, Object> values = new HashMap();
    private boolean AFInAppEventParameterName = false;

    public static AppsFlyerProperties getInstance() {
        if (instance == null) {
            instance = new AppsFlyerProperties();
        }
        return instance;
    }

    public synchronized void remove(String str) {
        this.values.remove(str);
    }

    public synchronized void set(String str, String str2) {
        this.values.put(str, str2);
    }

    public synchronized void set(String str, String[] strArr) {
        this.values.put(str, strArr);
    }

    public synchronized void set(String str, int i) {
        this.values.put(str, Integer.toString(i));
    }

    public synchronized void set(String str, long j) {
        this.values.put(str, Long.toString(j));
    }

    public synchronized void set(String str, boolean z) {
        this.values.put(str, Boolean.toString(z));
    }

    public synchronized void setCustomData(String str) {
        this.values.put(ADDITIONAL_CUSTOM_DATA, str);
    }

    public synchronized void setUserEmails(String str) {
        this.values.put(USER_EMAILS, str);
    }

    public synchronized String getString(String str) {
        return (String) this.values.get(str);
    }

    public boolean getBoolean(String str, boolean z) {
        String string = getString(str);
        return string == null ? z : Boolean.parseBoolean(string);
    }

    public int getLogLevel() {
        return getInt("logLevel", AFLogger.LogLevel.NONE.getLevel());
    }

    public int getInt(String str, int i) {
        String string = getString(str);
        return string == null ? i : Integer.parseInt(string);
    }

    public long getLong(String str, long j) {
        String string = getString(str);
        return string == null ? j : Long.parseLong(string);
    }

    public final boolean AFInAppEventType() {
        return this.AFInAppEventType;
    }

    public String getReferrer(AFd1xSDK aFd1xSDK) {
        String str = this.AFKeystoreWrapper;
        if (str != null) {
            return str;
        }
        if (getString("AF_REFERRER") != null) {
            return getString("AF_REFERRER");
        }
        return aFd1xSDK.valueOf("referrer", (String) null);
    }

    public boolean isEnableLog() {
        return getLogLevel() > AFLogger.LogLevel.NONE.getLevel();
    }

    public boolean isLogsDisabledCompletely() {
        return getBoolean(DISABLE_LOGS_COMPLETELY, false);
    }

    public boolean isOtherSdkStringDisabled() {
        return getBoolean(DISABLE_OTHER_SDK, false);
    }

    public synchronized void saveProperties(AFd1xSDK aFd1xSDK) {
        this.values.remove("AppsFlyerKey");
        aFd1xSDK.values("savedProperties", new JSONObject(this.values).toString());
    }

    public synchronized void loadProperties(AFd1xSDK aFd1xSDK) {
        if (AFInAppEventParameterName()) {
            return;
        }
        String strValueOf = aFd1xSDK.valueOf("savedProperties", (String) null);
        if (strValueOf != null) {
            AFLogger.afDebugLog("Loading properties..");
            try {
                JSONObject jSONObject = new JSONObject(strValueOf);
                Iterator<String> itKeys = jSONObject.keys();
                while (itKeys.hasNext()) {
                    String next = itKeys.next();
                    if (this.values.get(next) == null) {
                        this.values.put(next, jSONObject.getString(next));
                    }
                }
                String[] strArr = {"AppsFlyerKey", "custom_host", "custom_host_prefix"};
                for (int i = 0; i < 3; i++) {
                    this.values.remove(strArr[i]);
                }
                saveProperties(aFd1xSDK);
                this.AFInAppEventParameterName = true;
            } catch (JSONException e) {
                AFLogger.afErrorLog("Failed loading properties", e);
            }
            StringBuilder sb = new StringBuilder("Done loading properties: ");
            sb.append(this.AFInAppEventParameterName);
            AFLogger.afDebugLog(sb.toString());
        }
    }

    private boolean AFInAppEventParameterName() {
        return this.AFInAppEventParameterName;
    }

    public enum EmailsCryptType {
        NONE(0),
        SHA256(3);

        private final int values;

        EmailsCryptType(int i) {
            this.values = i;
        }

        public final int getValue() {
            return this.values;
        }
    }
}
