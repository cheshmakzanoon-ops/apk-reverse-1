package com.sdkmanager;

import android.app.Activity;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.analytics.FirebaseAnalytics;
import com.google.firebase.messaging.FirebaseMessaging;
import java.util.EnumMap;
import org.json.JSONException;
import org.json.JSONObject;

public class FireBaseController {
    private static volatile FireBaseController Instance;
    private String firebaseAppid = null;
    private String firebaseToken = null;
    private Activity mActivity;

    public void addCustomLog(String str) {
    }

    public void enableReporting(boolean z) {
    }

    public void reportException(Exception exc) {
    }

    public void setCustomValue(String str, String str2) {
    }

    public void setUserIdentifiers(String str) {
    }

    public static FireBaseController getInstance() {
        if (Instance == null) {
            synchronized (FireBaseController.class) {
                if (Instance == null) {
                    Instance = new FireBaseController();
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

    public void getFcmToken() {
        if (!TextUtils.isEmpty(this.firebaseToken)) {
            SendTokenToGame(this.firebaseToken);
        } else {
            FirebaseMessaging.getInstance().getToken().addOnCompleteListener(new OnCompleteListener<String>() {
                @Override
                public void onComplete(Task<String> task) {
                    String result;
                    if (!task.isSuccessful()) {
                        result = "";
                        String string = task.getException() != null ? task.getException().toString() : "";
                        Log.d(">>>>LSZ", "firebase_getFcmToken_error " + string);
                        SdkManager.getInstance().PostEvent("firebase_getFcmToken_error", string);
                    } else {
                        result = task.getResult();
                    }
                    FireBaseController.this.firebaseToken = result;
                    Log.d(">>>>LSZ", ">>> java setGaid " + FireBaseController.this.firebaseToken);
                    FireBaseController.this.SendTokenToGame(result);
                }
            });
        }
    }

    public void SendTokenToGame(final String str) {
        Activity activity = this.mActivity;
        if (activity == null) {
            return;
        }
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                try {
                    JSONObject jSONObject = new JSONObject();
                    jSONObject.put("1", str);
                    jSONObject.put("2", "fcm");
                    Log.d(">>>>LSZ", ">>> java SendTokenToGame " + str);
                    SdkManager.getInstance().SendDataToGame("registerdParseAccount", jSONObject.toString());
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        });
    }

    public void ChangeToken(String str) {
        this.firebaseToken = str;
        SendTokenToGame(str);
    }

    public void TrackPurchase(String str, String str2) {
        try {
            Bundle bundle = new Bundle();
            bundle.putFloat("value", Float.valueOf(str).floatValue());
            bundle.putString(FirebaseAnalytics.Param.CURRENCY, "USD");
            bundle.putString(FirebaseAnalytics.Param.ITEM_ID, str2);
            FirebaseAnalytics.getInstance(this.mActivity).logEvent(FirebaseAnalytics.Event.PURCHASE, bundle);
        } catch (Exception unused) {
        }
    }

    public void initFirebaseAppId() {
        if (this.mActivity == null) {
            return;
        }
        if (!TextUtils.isEmpty(this.firebaseAppid)) {
            SendAppIdToGame(this.firebaseAppid);
        } else {
            FirebaseAnalytics.getInstance(this.mActivity).getAppInstanceId().addOnCompleteListener(new OnCompleteListener<String>() {
                @Override
                public void onComplete(Task<String> task) {
                    String result;
                    if (!task.isSuccessful()) {
                        result = "";
                        String string = task.getException() != null ? task.getException().toString() : "";
                        Log.d(">>>>LSZ", "firebase_getFirebaseAppId_error " + string);
                        SdkManager.getInstance().PostEvent("firebase_getFirebaseAppId_error", string);
                    } else {
                        result = task.getResult();
                    }
                    FireBaseController.this.firebaseAppid = result;
                    FireBaseController.this.SendAppIdToGame(result);
                }
            });
        }
    }

    public void SendAppIdToGame(final String str) {
        Activity activity = this.mActivity;
        if (activity == null) {
            return;
        }
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                try {
                    JSONObject jSONObject = new JSONObject();
                    jSONObject.put("firebaseId", str);
                    SdkManager.getInstance().SendDataToGame("SetFireBaseId", jSONObject.toString());
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
    }

    public String SendDataToNative(String str, String str2) {
        byte b;
        try {
            switch (str.hashCode()) {
                case -332888057:
                    if (!str.equals("FireBase_getFCMToken")) {
                        b = -1;
                    } else {
                        b = 0;
                    }
                    break;
                case 1548746055:
                    if (!str.equals("FireBase_CrashlyticsSetUserId")) {
                        b = -1;
                    } else {
                        b = 3;
                    }
                    break;
                case 1770651155:
                    if (!str.equals("FireBase_CrashlyticsAddCustomLog")) {
                        b = -1;
                    } else {
                        b = 2;
                    }
                    break;
                case 2059337247:
                    if (!str.equals("FireBase_CrashlyticsSetCustomValue")) {
                        b = -1;
                    } else {
                        b = 1;
                    }
                    break;
                default:
                    b = -1;
                    break;
            }
            if (b == 0) {
                getFcmToken();
                initFirebaseAppId();
                return "";
            }
            if (b == 1) {
                JSONObject jSONObject = new JSONObject(str2);
                setCustomValue(jSONObject.getString("key"), jSONObject.getString("value"));
                return "";
            }
            if (b == 2) {
                addCustomLog(str2);
                return "";
            }
            if (b == 3) {
                setUserIdentifiers(str2);
                return "";
            }
            return "";
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    public void dmaPrivacyAllowed() {
        if (this.mActivity == null) {
            return;
        }
        EnumMap enumMap = new EnumMap(FirebaseAnalytics.ConsentType.class);
        enumMap.put(FirebaseAnalytics.ConsentType.ANALYTICS_STORAGE, FirebaseAnalytics.ConsentStatus.GRANTED);
        enumMap.put(FirebaseAnalytics.ConsentType.AD_STORAGE, FirebaseAnalytics.ConsentStatus.GRANTED);
        enumMap.put(FirebaseAnalytics.ConsentType.AD_USER_DATA, FirebaseAnalytics.ConsentStatus.GRANTED);
        enumMap.put(FirebaseAnalytics.ConsentType.AD_PERSONALIZATION, FirebaseAnalytics.ConsentStatus.GRANTED);
        FirebaseAnalytics.getInstance(this.mActivity).setConsent(enumMap);
        initFirebaseAppId();
        getFcmToken();
        Log.i("Lastwar", "dmaPrivacyAllowed");
    }
}
