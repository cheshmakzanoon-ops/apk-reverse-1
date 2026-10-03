package cn.thinkingdata.android.aop.push;

import android.app.Activity;
import android.content.Intent;
import android.text.TextUtils;
import cn.thinkingdata.android.utils.TDLog;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import org.json.JSONObject;

public class TAPushTrackHelper {
    private static final String TAG = "ThinkingAnalytics";

    private static String getTAData(String str) {
        return str;
    }

    public static void onNewIntent(Object obj, Intent intent) {
        try {
            if (obj instanceof Activity) {
                TAPushProcess.getInstance().onNotificationClick((Activity) obj, intent);
            }
        } catch (Exception e) {
            TDLog.m680e("ThinkingAnalytics", e.getMessage());
        }
    }

    public static void trackGeTuiNotification(Object obj) {
        if (obj == null) {
            return;
        }
        try {
            String str = (String) obj.getClass().getMethod("getMessageId", null).invoke(obj, null);
            String str2 = (String) obj.getClass().getMethod("getTitle", null).invoke(obj, null);
            String str3 = (String) obj.getClass().getMethod("getContent", null).invoke(obj, null);
            if (TextUtils.isEmpty(str) || TextUtils.isEmpty(str2) || TextUtils.isEmpty(str3)) {
                return;
            }
            TAPushProcess.getInstance().trackGTDelayed(str, str2, str3);
        } catch (Exception e) {
            TDLog.m680e("ThinkingAnalytics", e.getMessage());
        }
    }

    public static void trackGeTuiNotificationClicked(String str, String str2, String str3, long j) {
        trackNotificationClickedEvent(str3, str, str2, "GeTui", null, j);
        TDLog.m682i("ThinkingAnalytics", String.format("GEITUI is called, title is %s, content is %s, extras is %s", str, str2, str3));
    }

    public static void trackGeTuiReceiveMessageData(Object obj) {
        if (obj == null) {
            return;
        }
        try {
            byte[] bArr = (byte[]) obj.getClass().getMethod("getPayload", null).invoke(obj, null);
            String str = (String) obj.getClass().getMethod("getMessageId", null).invoke(obj, null);
            if (bArr == null || TextUtils.isEmpty(str)) {
                return;
            }
            TAPushProcess.getInstance().trackGeTuiReceiveMessageData(new String(bArr), str);
        } catch (Exception e) {
            TDLog.m680e("ThinkingAnalytics", e.getMessage());
        }
    }

    public static void trackJPushClickNotification(String str, String str2, String str3, String str4) {
        TDLog.m682i("ThinkingAnalytics", "extras:" + str);
        TDLog.m682i("ThinkingAnalytics", "title:" + str2);
        TDLog.m682i("ThinkingAnalytics", "content:" + str3);
        TDLog.m682i("ThinkingAnalytics", "appPushChannel:" + str4);
        trackNotificationClickedEvent(getTAData(str), str2, str3, "JPush", str4);
    }

    public static void trackJPushOpenActivity(Intent intent) {
        if (intent == null) {
            return;
        }
        JSONObject jSONObject = null;
        String string = intent.getData() != null ? intent.getData().toString() : null;
        if (TextUtils.isEmpty(string) && intent.getExtras() != null) {
            string = intent.getExtras().getString("JMessageExtra");
        }
        TDLog.m682i("ThinkingAnalytics", "Intent data :" + string);
        if (TextUtils.isEmpty(string)) {
            return;
        }
        try {
            jSONObject = new JSONObject(string);
        } catch (Exception unused) {
        }
        if (jSONObject != null) {
            try {
                String strOptString = jSONObject.optString("n_title");
                String strOptString2 = jSONObject.optString("n_content");
                String strOptString3 = jSONObject.optString("n_extras");
                String jPushSource = TAPushUtils.getJPushSource(jSONObject.optInt("rom_type"));
                TDLog.m682i("ThinkingAnalytics", String.format("JPush is called, title is %s, content is %s, extras is %s, appPushChannel is %s", strOptString, strOptString2, strOptString3, jPushSource));
                if (!TextUtils.isEmpty(strOptString) && !TextUtils.isEmpty(strOptString2) && !TextUtils.isEmpty(jPushSource)) {
                    trackNotificationClickedEvent(getTAData(strOptString3), strOptString, strOptString2, "JPush", jPushSource);
                }
            } catch (Exception e) {
                TDLog.m680e("ThinkingAnalytics", e.getMessage());
            }
        }
    }

    public static void trackMeizuNotification(String str, String str2, String str3, String str4) {
        JSONObject jSONObject;
        JSONObject jSONObjectOptJSONObject;
        TDLog.m682i("ThinkingAnalytics", String.format("meizu is called, title is %s, content is %s, extras is %s, appPushChannel is %s, appPushServiceName is %s", str2, str3, str, "Meizu", str4));
        try {
            jSONObject = new JSONObject(str);
        } catch (Exception unused) {
            jSONObject = null;
        }
        if (jSONObject != null) {
            try {
                if (jSONObject.has("JMessageExtra")) {
                    JSONObject jSONObjectOptJSONObject2 = jSONObject.optJSONObject("JMessageExtra");
                    if (jSONObjectOptJSONObject2 != null && (jSONObjectOptJSONObject = jSONObjectOptJSONObject2.optJSONObject("m_content")) != null) {
                        str = jSONObjectOptJSONObject.optString("n_extras");
                    }
                    str4 = "JPush";
                }
            } catch (Exception unused2) {
            }
        }
        try {
            trackNotificationClickedEvent(getTAData(str), str2, str3, str4, "Meizu");
        } catch (Exception unused3) {
        }
    }

    public static void trackNotificationClickedEvent(String str, String str2, String str3, String str4, String str5) {
        trackNotificationClickedEvent(str, str2, str3, str4, str5, 0L);
    }

    private static void trackNotificationClickedEvent(String str, String str2, String str3, String str4, String str5, long j) {
    }

    public static void trackUMengActivityNotification(Intent intent) {
        JSONObject jSONObject;
        JSONObject jSONObjectOptJSONObject;
        if (intent == null) {
            return;
        }
        try {
            String stringExtra = intent.getStringExtra(SDKConstants.PARAM_A2U_BODY);
            if (TextUtils.isEmpty(stringExtra) || (jSONObjectOptJSONObject = (jSONObject = new JSONObject(stringExtra)).optJSONObject(SDKConstants.PARAM_A2U_BODY)) == null) {
                return;
            }
            String strOptString = jSONObject.optString("extra");
            String strOptString2 = jSONObjectOptJSONObject.optString("title");
            String strOptString3 = jSONObjectOptJSONObject.optString("text");
            String stringExtra2 = intent.getStringExtra("message_source");
            trackNotificationClickedEvent(getTAData(strOptString), strOptString2, strOptString3, "UMeng", stringExtra2);
            TDLog.m682i("ThinkingAnalytics", String.format("onUMengActivityMessage is called, title is %s, content is %s, extras is %ssource is %s", strOptString2, strOptString3, strOptString, stringExtra2));
        } catch (Exception e) {
            TDLog.m680e("ThinkingAnalytics", e.getMessage());
        }
    }

    public static void trackUmengClickNotification(Object obj) {
        JSONObject jSONObjectOptJSONObject;
        if (obj == null) {
            return;
        }
        try {
            JSONObject jSONObject = (JSONObject) obj.getClass().getDeclaredMethod("getRaw", null).invoke(obj, null);
            if (jSONObject == null || (jSONObjectOptJSONObject = jSONObject.optJSONObject(SDKConstants.PARAM_A2U_BODY)) == null) {
                return;
            }
            String strOptString = jSONObject.optString("extra");
            String strOptString2 = jSONObjectOptJSONObject.optString("title");
            String strOptString3 = jSONObjectOptJSONObject.optString("text");
            trackNotificationClickedEvent(getTAData(strOptString), strOptString2, strOptString3, "UMeng", null);
            TDLog.m682i("ThinkingAnalytics", String.format("UMengClick is called, title is %s, content is %s, extras is %s", strOptString2, strOptString3, strOptString));
        } catch (Exception e) {
            TDLog.m682i("ThinkingAnalytics", e.getMessage());
        }
    }
}
