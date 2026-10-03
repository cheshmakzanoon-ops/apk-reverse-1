package com.sdkmanager;

import android.app.NotificationManager;
import android.content.Context;
import android.content.SharedPreferences;
import android.os.Build;
import androidx.core.app.NotificationManagerCompat;
import com.ishumei.smantifraud.l11l11I1111l;
import com.sdkmanager.notify.LocalNotification;
import com.sdkmanager.notify.LocalNotificationManager;
import com.sdkmanager.notify.PushRecordManager;
import com.sdkmanager.utils.Udid$$ExternalSyntheticApiModelOutline0;
import com.unity3d.player.C1087R;
import java.util.Date;
import org.json.JSONException;
import org.json.JSONObject;

public class PushUtilManager {
    private static PushUtilManager _inst;
    private Context _context = null;
    private LocalNotificationManager manager = null;

    public Context getContext() {
        return this._context;
    }

    public void Init(Context context) {
        this._context = context;
    }

    public static PushUtilManager getInstance() {
        if (_inst == null) {
            synchronized (PushUtilManager.class) {
                if (_inst == null) {
                    _inst = new PushUtilManager();
                }
            }
        }
        return _inst;
    }

    public void initNotificationManager() {
        if (Build.VERSION.SDK_INT >= 26) {
            ((NotificationManager) this._context.getSystemService("notification")).createNotificationChannel(Udid$$ExternalSyntheticApiModelOutline0.m404m("lf_notify", "APS", 5));
        }
    }

    public void AddDataToCache(Context context, String str) {
        int iGetDataFromCache = GetDataFromCache(context, str);
        SharedPreferences.Editor editorEdit = context.getSharedPreferences("PUSH_RECORD_CACHE", 0).edit();
        editorEdit.putInt(str, iGetDataFromCache + 1);
        editorEdit.commit();
        SetPushTimeToCache(context, str);
    }

    public int GetDataFromCache(Context context, String str) {
        return context.getSharedPreferences("PUSH_RECORD_CACHE", 0).getInt(str, 0);
    }

    public int GetPushTimeFromCache(Context context, String str) {
        return context.getSharedPreferences("PUSH_RECORD_CACHE_TIME", 0).getInt(str, 0);
    }

    public void SetPushTimeToCache(Context context, String str) {
        SharedPreferences.Editor editorEdit = context.getSharedPreferences("PUSH_RECORD_CACHE_TIME", 0).edit();
        editorEdit.putInt(str, (int) (System.currentTimeMillis() / 1000));
        editorEdit.commit();
    }

    private LocalNotificationManager getManager() {
        if (this.manager == null) {
            this.manager = new LocalNotificationManager(this._context);
        }
        return this.manager;
    }

    public void cancelNotification(String str) {
        cancel(str);
    }

    public void pushNotification(String str, int i, String str2, String str3, String str4, String str5, String str6, String str7) {
        sendNotify(str2, str2, i, str, str3, str4, str5, str6, str7);
    }

    public void sendNotify(String str, String str2, int i, String str3, String str4, String str5, String str6, String str7, String str8) {
        LocalNotification localNotification = new LocalNotification(this._context.getClass().getName());
        localNotification.fireDate = new Date(System.currentTimeMillis() + (((long) i) * 1000));
        localNotification.body = str2;
        localNotification.pushType = str5;
        localNotification.title = this._context.getString(C1087R.string.app_name);
        localNotification.iconResourceId = C1087R.drawable.app_icon;
        localNotification.hasAction = true;
        localNotification.playerMark = str6;
        localNotification.gameUid = str7;
        localNotification.pushId = str8;
        getManager().notify(localNotification);
    }

    public void cancel(String str) {
        if ("-1".equals(str)) {
            getManager().cancelAll();
            getManager().unpersistAllNotifications();
        } else {
            getManager().cancel(str);
            getManager().unpersistNotification(str);
        }
    }

    public void sendDataToNative(String str, String str2) {
        JSONObject jSONObject;
        if (str == null || str.equals("")) {
            return;
        }
        if (str2 != null) {
            try {
                try {
                    if (str2.equals("")) {
                        jSONObject = null;
                    } else {
                        jSONObject = new JSONObject(str2);
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                    return;
                }
            } catch (Exception e2) {
                e2.printStackTrace();
                return;
            }
        } else {
            jSONObject = null;
        }
        if (str.equals("PUSH_PushNotice")) {
            pushNotification(jSONObject.getString(l11l11I1111l.l111l1111l1Il), jSONObject.getInt("time"), jSONObject.getString(LocalNotificationManager.PUSH_MSG), jSONObject.getString("soundKey"), jSONObject.getString("pushType"), jSONObject.getString("playerMark"), jSONObject.getString("gameUid"), jSONObject.getString("pushId"));
            return;
        }
        if (str.equals("PUSH_CancleNotice")) {
            try {
                cancelNotification(jSONObject.getString(l11l11I1111l.l111l1111l1Il));
                return;
            } catch (Exception e3) {
                e3.printStackTrace();
                return;
            }
        }
        if (str.equals("PUSH_ClearAllNotice")) {
            try {
                getManager().clearAllNotifications();
                return;
            } catch (Exception e4) {
                e4.printStackTrace();
                return;
            }
        }
        if (str.equals("PUSH_clearAllCache")) {
            new PushRecordManager(this._context).ClearAllPushData();
            ((NotificationManager) this._context.getSystemService("notification")).cancelAll();
        }
    }

    public String GetDataFromNative(String str, String str2) {
        byte b;
        try {
            try {
                switch (str.hashCode()) {
                    case -2120155390:
                        if (!str.equals("PUSH_isNotifyOpen")) {
                            b = -1;
                        } else {
                            b = 5;
                        }
                        break;
                    case -136804890:
                        if (!str.equals("PUSH_getPushId")) {
                            b = -1;
                        } else {
                            b = 1;
                        }
                        break;
                    case 54026287:
                        if (!str.equals("PUSH_getPushTag")) {
                            b = -1;
                        } else {
                            b = 0;
                        }
                        break;
                    case 408250570:
                        if (!str.equals("PUSH_getPushTimeById")) {
                            b = -1;
                        } else {
                            b = 4;
                        }
                        break;
                    case 1112088150:
                        if (!str.equals("PUSH_getPushCountById")) {
                            b = -1;
                        } else {
                            b = 3;
                        }
                        break;
                    case 1674822872:
                        if (!str.equals("PUSH_getPushTime")) {
                            b = -1;
                        } else {
                            b = 2;
                        }
                        break;
                    default:
                        b = -1;
                        break;
                }
                if (b == 0) {
                    return new PushRecordManager(this._context).getPushTag();
                }
                if (b == 1) {
                    return new PushRecordManager(this._context).getPushIdFromCache();
                }
                if (b == 2) {
                    return new PushRecordManager(this._context).getPushTime();
                }
                if (b == 3) {
                    try {
                        return String.valueOf(GetDataFromCache(getContext(), new JSONObject(str2).getString("pushId")));
                    } catch (Exception e) {
                        e.printStackTrace();
                        return "";
                    }
                }
                if (b == 4) {
                    try {
                        return String.valueOf(GetPushTimeFromCache(C1058IF.getInstance().getContext(), new JSONObject(str2).getString("pushId")));
                    } catch (Exception e2) {
                        e2.printStackTrace();
                        return "";
                    }
                }
                if (b != 5) {
                    return "";
                }
                try {
                    return isNotifyOpen();
                } catch (Exception e3) {
                    e3.printStackTrace();
                    return "";
                }
            } catch (Exception e4) {
                e4.printStackTrace();
                return "";
            }
        } catch (Throwable unused) {
            return "";
        }
    }

    public String isNotifyOpen() {
        boolean zAreNotificationsEnabled;
        try {
            zAreNotificationsEnabled = NotificationManagerCompat.from(getContext()).areNotificationsEnabled();
        } catch (Exception e) {
            e.printStackTrace();
            zAreNotificationsEnabled = false;
        }
        if (zAreNotificationsEnabled) {
            return "true";
        }
        return "false";
    }
}
