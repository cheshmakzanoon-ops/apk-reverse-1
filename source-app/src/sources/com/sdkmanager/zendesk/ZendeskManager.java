package com.sdkmanager.zendesk;

import android.app.Activity;
import android.util.Log;
import com.google.android.gms.measurement.api.AppMeasurementSdk;
import com.google.firebase.analytics.FirebaseAnalytics;
import com.ishumei.smantifraud.l111l111lIlll;
import com.sdkmanager.SdkManager;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import kotlin.Unit;
import org.json.JSONObject;
import zendesk.android.FailureCallback;
import zendesk.android.SuccessCallback;
import zendesk.android.Zendesk;
import zendesk.android.ZendeskUser;
import zendesk.android.events.ZendeskEvent;
import zendesk.android.events.ZendeskEventListener;
import zendesk.android.events.exception.ZendeskJwtExpiredException;
import zendesk.android.pageviewevents.PageView;
import zendesk.logger.Logger;
import zendesk.messaging.android.DefaultMessagingFactory;

public class ZendeskManager {
    static final String AUTH = "Zendesk_Auth";
    static final String CLEAR_FIELDS = "Zendesk_Clear_Fields";
    static final String CLEAR_TAGS = "Zendesk_Clear_Tags";
    static final String FIELDS = "Zendesk_Fields";
    static final String INIT = "Zendesk_Init";
    static volatile ZendeskManager Instance = null;
    static final String LOGIN = "Zendesk_Login";
    static final String LOGOUT = "Zendesk_Logout";
    static final String SHOW = "Zendesk_Show";
    static final String TAG = "ZendeskManager";
    static final String TAGS = "Zendesk_Tags";
    static final String UNREAD = "Zendesk_Unread";
    ZendeskEventListener listener = null;
    Activity mActivity;

    static void lambda$ZendeskShow$3(Unit unit) {
    }

    static void lambda$ZendeskShow$4(Throwable th) {
    }

    public static ZendeskManager getInstance() {
        ZendeskManager zendeskManager = Instance;
        if (zendeskManager == null) {
            synchronized (SdkManager.class) {
                zendeskManager = Instance;
                if (zendeskManager == null) {
                    zendeskManager = new ZendeskManager();
                    Instance = zendeskManager;
                }
            }
        }
        return zendeskManager;
    }

    public void init(Activity activity) {
        this.mActivity = activity;
    }

    public Activity getCurActivity() {
        return this.mActivity;
    }

    static void Log(String str) {
        Log.d(TAG, str);
    }

    static void LogE(String str) {
        Log.e(TAG, str);
    }

    public void SendDataToNative(String str, String str2) {
        if (str == null || str.isEmpty()) {
            return;
        }
        if (str2 == null || str2.isEmpty()) {
            str2 = "{}";
        }
        try {
            JSONObject jSONObject = new JSONObject(str2);
            switch (str) {
                case "Zendesk_Init":
                    ZendeskInit(jSONObject.getString("channelKey"));
                    break;
                case "Zendesk_Show":
                    ZendeskShow(jSONObject.getString("id"), jSONObject.getString(AppMeasurementSdk.ConditionalUserProperty.NAME));
                    break;
                case "Zendesk_Login":
                    ZendeskLogin(jSONObject.getString("jwt"));
                    break;
                case "Zendesk_Logout":
                    ZendeskLogout();
                    break;
                case "Zendesk_Fields":
                    ZendeskFields(jSONObject.getString("fields"));
                    break;
                case "Zendesk_Tags":
                    ZendeskTags(jSONObject.getString("tags"));
                    break;
                case "Zendesk_Clear_Fields":
                    ZendeskClearFields();
                    break;
                case "Zendesk_Clear_Tags":
                    ZendeskClearTags();
                    break;
                default:
                    Log("No such Method" + str);
                    break;
            }
        } catch (Exception e) {
            LogE("data error : " + e.getLocalizedMessage());
        }
    }

    public void ZendeskInit(String str) {
        try {
            Zendesk.initialize(getCurActivity(), str, new SuccessCallback() {
                public final void onSuccess(Object obj) {
                    this.f$0.m802lambda$ZendeskInit$1$comsdkmanagerzendeskZendeskManager((Zendesk) obj);
                }
            }, new FailureCallback() {
                public final void onFailure(Throwable th) {
                    ZendeskManager.lambda$ZendeskInit$2(th);
                }
            }, new DefaultMessagingFactory());
            Logger.setLoggable(true);
        } catch (Exception e) {
            LogE(e.getLocalizedMessage());
        }
    }

    void m802lambda$ZendeskInit$1$comsdkmanagerzendeskZendeskManager(Zendesk zendesk) {
        Log("ZenDesk Init Success");
        SdkManager.getInstance().SendDataToGame(INIT, ComposeData(FirebaseAnalytics.Param.SUCCESS, 1, "unread", Integer.valueOf(zendesk.getMessaging().getUnreadMessageCount())));
        ZendeskEventListener zendeskEventListener = this.listener;
        if (zendeskEventListener != null) {
            zendesk.removeEventListener(zendeskEventListener);
        }
        ZendeskEventListener zendeskEventListener2 = new ZendeskEventListener() {
            public final void onEvent(ZendeskEvent zendeskEvent) {
                ZendeskManager.lambda$ZendeskInit$0(zendeskEvent);
            }
        };
        this.listener = zendeskEventListener2;
        zendesk.addEventListener(zendeskEventListener2);
    }

    static void lambda$ZendeskInit$0(ZendeskEvent zendeskEvent) {
        if (zendeskEvent instanceof ZendeskEvent.UnreadMessageCountChanged) {
            SdkManager.getInstance().SendDataToGame(UNREAD, ComposeData("unread", Integer.valueOf(((ZendeskEvent.UnreadMessageCountChanged) zendeskEvent).getCurrentUnreadCount())));
        } else if (zendeskEvent instanceof ZendeskEvent.AuthenticationFailed) {
            Throwable error = ((ZendeskEvent.AuthenticationFailed) zendeskEvent).getError();
            SdkManager.getInstance().SendDataToGame(AUTH, ComposeData("code", Integer.valueOf(error instanceof ZendeskJwtExpiredException ? 401 : 1), "info", error.getLocalizedMessage()));
        }
    }

    static void lambda$ZendeskInit$2(Throwable th) {
        Log("ZenDesk Init Failed : " + th.getMessage());
        SdkManager.getInstance().SendDataToGame(INIT, ComposeData(FirebaseAnalytics.Param.SUCCESS, 0, "unread", 0));
    }

    public void ZendeskShow(String str, String str2) {
        try {
            Zendesk.getInstance().sendPageView(new PageView(str, str2), new SuccessCallback() {
                public final void onSuccess(Object obj) {
                    ZendeskManager.lambda$ZendeskShow$3((Unit) obj);
                }
            }, new FailureCallback() {
                public final void onFailure(Throwable th) {
                    ZendeskManager.lambda$ZendeskShow$4(th);
                }
            });
            Zendesk.getInstance().getMessaging().showMessaging(getCurActivity());
        } catch (Exception e) {
            LogE(e.getLocalizedMessage());
        }
    }

    public void ZendeskLogin(String str) {
        try {
            Zendesk.getInstance().loginUser(str, new SuccessCallback() {
                public final void onSuccess(Object obj) {
                    ZendeskManager.lambda$ZendeskLogin$5((ZendeskUser) obj);
                }
            }, new FailureCallback() {
                public final void onFailure(Throwable th) {
                    ZendeskManager.lambda$ZendeskLogin$6(th);
                }
            });
        } catch (Exception e) {
            LogE(e.getLocalizedMessage());
        }
    }

    static void lambda$ZendeskLogin$5(ZendeskUser zendeskUser) {
        Log("ZenDesk Login Success");
        SdkManager.getInstance().SendDataToGame(LOGIN, ComposeData(FirebaseAnalytics.Param.SUCCESS, 1, "info", zendeskUser.getId()));
    }

    static void lambda$ZendeskLogin$6(Throwable th) {
        Log("ZenDesk Login Failed");
        SdkManager.getInstance().SendDataToGame(LOGIN, ComposeData(FirebaseAnalytics.Param.SUCCESS, 0, "info", th.getLocalizedMessage()));
    }

    public void ZendeskLogout() {
        try {
            Zendesk.getInstance().logoutUser(new SuccessCallback() {
                public final void onSuccess(Object obj) {
                    ZendeskManager.lambda$ZendeskLogout$7((Unit) obj);
                }
            }, new FailureCallback() {
                public final void onFailure(Throwable th) {
                    ZendeskManager.lambda$ZendeskLogout$8(th);
                }
            });
        } catch (Exception e) {
            LogE(e.getLocalizedMessage());
        }
    }

    static void lambda$ZendeskLogout$7(Unit unit) {
        Log("ZenDesk Logout Success");
        SdkManager.getInstance().SendDataToGame(LOGOUT, ComposeData(FirebaseAnalytics.Param.SUCCESS, 1, "info", ""));
    }

    static void lambda$ZendeskLogout$8(Throwable th) {
        Log("ZenDesk Logout Failed");
        SdkManager.getInstance().SendDataToGame(LOGOUT, ComposeData(FirebaseAnalytics.Param.SUCCESS, 0, "info", th.getLocalizedMessage()));
    }

    static String ComposeData(Object... objArr) {
        if (objArr == null || objArr.length == 0 || objArr.length % 2 == 1) {
            LogE("ComposeData : Invalid arguments");
            return "";
        }
        JSONObject jSONObject = new JSONObject();
        for (int i = 0; i < objArr.length; i += 2) {
            try {
                jSONObject.put((String) objArr[i], objArr[i + 1]);
            } catch (Exception e) {
                LogE("ComposeData error : " + e.getLocalizedMessage());
            }
        }
        return jSONObject.toString();
    }

    static class Field {
        String key;
        String type;
        String value;

        Field(String str, String str2, String str3) {
            this.key = str;
            this.type = str2;
            this.value = str3;
        }
    }

    static Field parseField(String str) {
        int iIndexOf = str.indexOf(58);
        int i = iIndexOf + 1;
        int iIndexOf2 = str.indexOf(58, i);
        if (iIndexOf == -1 || iIndexOf2 == -1) {
            return null;
        }
        return new Field(str.substring(0, iIndexOf), str.substring(i, iIndexOf2), str.substring(iIndexOf2 + 1));
    }

    static Object createObjectForField(Field field) {
        if (l111l111lIlll.l11l111l1Il.equals(field.type)) {
            return field.value;
        }
        if ("n".equals(field.type)) {
            try {
                return Integer.valueOf(Integer.parseInt(field.value));
            } catch (NumberFormatException unused) {
                LogE("Invalid number format: " + field.value);
                return null;
            }
        }
        if ("b".equals(field.type)) {
            return Boolean.valueOf("1".equals(field.value) || "true".equalsIgnoreCase(field.value));
        }
        return null;
    }

    static String FieldListToString(Map<String, Object> map) {
        String string;
        StringBuilder sb = new StringBuilder();
        for (Map.Entry<String, Object> entry : map.entrySet()) {
            String key = entry.getKey();
            Object value = entry.getValue();
            boolean z = value instanceof String;
            if (z) {
                string = (String) value;
            } else if (value instanceof Integer) {
                string = Integer.toString(((Integer) value).intValue());
            } else {
                string = ((Boolean) value).booleanValue() ? "1" : "0";
            }
            sb.append(key);
            sb.append(':');
            if (z) {
                sb.append('s');
            } else if (value instanceof Integer) {
                sb.append('n');
            } else {
                sb.append('b');
            }
            sb.append(':');
            sb.append(string);
            sb.append(';');
        }
        return sb.toString();
    }

    static Map<String, Object> StringToFieldList(String str) {
        String strSubstring;
        int length;
        HashMap map = new HashMap();
        int i = 0;
        while (i < str.length()) {
            int iIndexOf = str.indexOf(59, i);
            if (iIndexOf != -1) {
                strSubstring = str.substring(i, iIndexOf);
                length = iIndexOf + 1;
            } else {
                strSubstring = str.substring(i);
                length = str.length();
            }
            Field field = parseField(strSubstring);
            if (field != null && field.key != null && field.type != null && field.value != null) {
                Log("Key = " + field.key + ", Type = " + field.type + ", Value = " + field.value);
                Object objCreateObjectForField = createObjectForField(field);
                if (objCreateObjectForField != null) {
                    map.put(field.key, objCreateObjectForField);
                } else {
                    LogE("Failed to generate object for key: " + field.key);
                }
            } else {
                LogE("Invalid field format: " + strSubstring);
            }
            i = length;
        }
        return map;
    }

    public void ZendeskFields(String str) {
        try {
            Zendesk.getInstance().getMessaging().setConversationFields(StringToFieldList(str));
        } catch (Exception e) {
            LogE(e.getLocalizedMessage());
        }
    }

    public void ZendeskClearFields() {
        try {
            Zendesk.getInstance().getMessaging().clearConversationFields();
        } catch (Exception e) {
            LogE(e.getLocalizedMessage());
        }
    }

    public void ZendeskTags(String str) {
        String strSubstring;
        int length;
        try {
            ArrayList arrayList = new ArrayList();
            for (int i = 0; i < str.length(); i = length) {
                int iIndexOf = str.indexOf(59, i);
                if (iIndexOf != -1) {
                    strSubstring = str.substring(i, iIndexOf);
                    length = iIndexOf + 1;
                } else {
                    strSubstring = str.substring(i);
                    length = str.length();
                }
                if (!strSubstring.isEmpty()) {
                    arrayList.add(strSubstring);
                }
            }
            Zendesk.getInstance().getMessaging().setConversationTags(arrayList);
        } catch (Exception e) {
            LogE(e.getLocalizedMessage());
        }
    }

    public void ZendeskClearTags() {
        try {
            Zendesk.getInstance().getMessaging().clearConversationTags();
        } catch (Exception e) {
            LogE(e.getLocalizedMessage());
        }
    }
}
