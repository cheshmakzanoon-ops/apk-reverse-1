package com.appsflyer;

import android.app.Activity;
import android.util.Log;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import com.sdkmanager.utils.HttpUtils;
import java.util.HashMap;
import java.util.Map;
import org.json.JSONObject;

public class AppsFlyerController {
    private static final String AF_DEV_KEY = "YwCvTGJaPY6HrnRYd55RtG";
    private static volatile AppsFlyerController Instance;
    private boolean isInit = false;
    private Activity mActivity;

    public static AppsFlyerController getInstance() {
        if (Instance == null) {
            synchronized (AppsFlyerController.class) {
                if (Instance == null) {
                    Instance = new AppsFlyerController();
                }
            }
        }
        return Instance;
    }

    public void init(Activity activity) {
        this.mActivity = activity;
    }

    public Activity getCurActivity() {
        return this.mActivity;
    }

    public String getMapJsonStr(Map<String, Object> map) {
        if (map == null) {
            return "";
        }
        try {
            JSONObject jSONObject = new JSONObject();
            jSONObject.put("afuid", getAppsFlyerUid());
            for (Map.Entry<String, Object> entry : map.entrySet()) {
                jSONObject.put(entry.getKey(), entry.getValue());
            }
            return jSONObject.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    public String getMapJsonStr1(Map<String, String> map) {
        if (map == null) {
            return "";
        }
        try {
            JSONObject jSONObject = new JSONObject();
            jSONObject.put("afuid", getAppsFlyerUid());
            for (Map.Entry<String, String> entry : map.entrySet()) {
                jSONObject.put(entry.getKey(), entry.getValue());
            }
            return jSONObject.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    public void SendRecordToLogServer(final String str, final String str2) {
        this.mActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                HttpUtils.getInstance().init(AppsFlyerController.this.mActivity);
                HttpUtils.getInstance().sendHttpRecord(str, str2);
            }
        });
    }

    public void InitSdk() {
        Log.i("Unity Init Af", "init app flyer");
        AppsFlyerConversionListener appsFlyerConversionListener = new AppsFlyerConversionListener() {
            @Override
            public void onConversionDataSuccess(Map<String, Object> map) {
                String mapJsonStr = AppsFlyerController.getInstance().getMapJsonStr(map);
                AppsFlyerController.this.SendRecordToLogServer("ConverSuccess", mapJsonStr);
                Log.i("AppsFlyer_6.13.0", "onConversionDataSuccess " + mapJsonStr);
            }

            @Override
            public void onConversionDataFail(String str) {
                AppsFlyerController.this.SendRecordToLogServer("ConverFail", str);
                Log.i("AppsFlyer_6.13.0", "onConversionDataFail " + str);
            }

            @Override
            public void onAppOpenAttribution(Map<String, String> map) {
                AppsFlyerController.this.SendRecordToLogServer("OpenAttribution", AppsFlyerController.getInstance().getMapJsonStr1(map));
                Log.i("AppsFlyer_6.13.0", "onAppOpenAttribution");
            }

            @Override
            public void onAttributionFailure(String str) {
                AppsFlyerController.this.SendRecordToLogServer("OpenAttribution", str);
                Log.i("AppsFlyer_6.13.0", "onAttributionFailure");
            }
        };
        SendRecordToLogServer("InitAppsFlyerJava", "");
        AppsFlyerLib.getInstance().init(AF_DEV_KEY, appsFlyerConversionListener, this.mActivity.getApplicationContext());
        AppsFlyerLib.getInstance().waitForCustomerUserId(true);
    }

    public void InitAppsFlyer(String str) {
        if (this.isInit) {
            this.isInit = true;
        } else {
            HttpUtils.getInstance().sendHttpRecord("InitAppsFlyer", str);
            AppsFlyerLib.getInstance().setCustomerIdAndLogSession(str, this.mActivity);
        }
    }

    public void dmaPrivacyAllowed() {
        AppsFlyerLib.getInstance().setConsentData(AppsFlyerConsent.forGDPRUser(true, true));
        Log.i("Appsflyer", "dmaPrivacyAllowed");
        Log.i("Appsflyer", "Appsflyer call start");
        AppsFlyerLib.getInstance().start(this.mActivity);
    }

    public String getAppsFlyerUid() {
        return AppsFlyerLib.getInstance().getAppsFlyerUID(this.mActivity);
    }

    public void TrackPurchase(String str, String str2) {
        try {
            Log.d(">>>> appsflyer: ", String.format("cost: %s, itemId: %s", str, str2));
            HashMap map = new HashMap();
            map.put(AFInAppEventParameterName.CONTENT_ID, str2);
            map.put(AFInAppEventParameterName.CURRENCY, "USD");
            map.put(AFInAppEventParameterName.REVENUE, Float.valueOf(str));
            AppsFlyerLib.getInstance().logEvent(this.mActivity, AFInAppEventType.PURCHASE, map);
        } catch (Exception unused) {
        }
    }

    public void recordAppsflyer(String str, String str2) {
        try {
            HashMap map = new HashMap();
            map.put(AFInAppEventParameterName.CUSTOMER_USER_ID, str);
            AppsFlyerLib.getInstance().logEvent(this.mActivity, str2, map);
        } catch (Exception e) {
            e.printStackTrace();
            Log.e("debug", e.getMessage());
        }
    }

    public void SendDataToNative(String str, String str2) {
        byte b;
        if (str == null || str.equals("") || str2 == null || str2.equals("") || str == null || str.equals("") || str2 == null || str2.equals("")) {
            return;
        }
        try {
            JSONObject jSONObject = new JSONObject(str2);
            int iHashCode = str.hashCode();
            if (iHashCode != -1635929733) {
                if (iHashCode != 1039051023) {
                    if (iHashCode == 1543985937 && str.equals("PM_InitAppFlyer")) {
                        b = 0;
                    } else {
                        b = -1;
                    }
                } else if (str.equals("PM_SetAppsFlyerPurchase")) {
                    b = 1;
                } else {
                    b = -1;
                }
            } else if (str.equals("PM_RecordAppsflyer")) {
                b = 2;
            } else {
                b = -1;
            }
            if (b == 0) {
                getInstance().InitAppsFlyer(jSONObject.getString("uid"));
            } else {
                if (b != 2) {
                    return;
                }
                getInstance().recordAppsflyer(jSONObject.getString("uid"), jSONObject.getString(SDKConstants.PARAM_KEY));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String GetDataFromNative(String str, String str2) {
        if (!str.equals("AF_getAppsFlyerUid")) {
            return "";
        }
        return getAppsFlyerUid();
    }
}
