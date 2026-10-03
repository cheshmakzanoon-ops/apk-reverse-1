package cn.thinkingdata.android;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import cn.thinkingdata.android.utils.C0766q;
import cn.thinkingdata.android.utils.EnumC0761l;
import j$.util.DesugarTimeZone;
import java.util.Date;
import java.util.TimeZone;
import org.json.JSONException;
import org.json.JSONObject;

public class TDReceiver extends BroadcastReceiver {

    private static volatile TDReceiver f116a;

    public static synchronized TDReceiver m433a() {
        if (f116a == null) {
            synchronized (TDReceiver.class) {
                if (f116a == null) {
                    f116a = new TDReceiver();
                }
            }
        }
        return f116a;
    }

    public static void m434a(Context context) {
        String str;
        IntentFilter intentFilter = new IntentFilter();
        String strM755d = C0766q.m755d(context);
        if (strM755d.length() == 0) {
            str = "cn.thinkingdata.receiver";
        } else {
            str = strM755d + ".cn.thinkingdata.receiver";
        }
        intentFilter.addAction(str);
        context.registerReceiver(m433a(), intentFilter);
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        ThinkingAnalyticsSDK thinkingAnalyticsSDKSharedInstance;
        JSONObject jSONObject;
        JSONObject jSONObject2;
        TDFirstEvent tDFirstEvent;
        JSONObject jSONObject3;
        int intExtra = intent.getIntExtra("TD_ACTION", 0);
        String stringExtra = intent.getStringExtra("#app_id");
        if (stringExtra == null || stringExtra.length() <= 0 || (thinkingAnalyticsSDKSharedInstance = ThinkingAnalyticsSDK.sharedInstance(context, stringExtra)) == null) {
            return;
        }
        jSONObject = null;
        JSONObject jSONObject4 = null;
        jSONObject = null;
        JSONObject jSONObject5 = null;
        AbstractC0737n tDUpdatableEvent = null;
        switch (intExtra) {
            case 1048578:
                String stringExtra2 = intent.getStringExtra("properties");
                long longExtra = intent.getLongExtra("TD_DATE", 0L);
                String stringExtra3 = intent.getStringExtra("TD_KEY_TIMEZONE");
                if (stringExtra2 != null) {
                    try {
                        jSONObject = new JSONObject(stringExtra2);
                    } catch (JSONException e) {
                        e.printStackTrace();
                        jSONObject = null;
                    }
                } else {
                    jSONObject = null;
                }
                Date date = longExtra != 0 ? new Date(longExtra) : null;
                TimeZone defaultTimeZone = thinkingAnalyticsSDKSharedInstance.mConfig.getDefaultTimeZone();
                if (stringExtra3 != null) {
                    defaultTimeZone = DesugarTimeZone.getTimeZone(stringExtra3);
                }
                thinkingAnalyticsSDKSharedInstance.track(intent.getStringExtra("#event_name"), jSONObject, date, defaultTimeZone);
                break;
            case 1048579:
            case 1048580:
            case 1048581:
                String stringExtra4 = intent.getStringExtra("#event_name");
                String stringExtra5 = intent.getStringExtra("properties");
                long longExtra2 = intent.getLongExtra("TD_DATE", 0L);
                String stringExtra6 = intent.getStringExtra("TD_KEY_TIMEZONE");
                if (stringExtra5 != null) {
                    try {
                        jSONObject2 = new JSONObject(stringExtra5);
                    } catch (JSONException e2) {
                        e2.printStackTrace();
                        jSONObject2 = null;
                    }
                } else {
                    jSONObject2 = null;
                }
                Date date2 = longExtra2 != 0 ? new Date(longExtra2) : null;
                TimeZone timeZone = stringExtra6 != null ? DesugarTimeZone.getTimeZone(stringExtra6) : null;
                String stringExtra7 = intent.getStringExtra("TD_KEY_EXTRA_FIELD");
                if (intExtra == 1048579) {
                    tDFirstEvent = new TDFirstEvent(stringExtra4, jSONObject2);
                    if (stringExtra7 != null && stringExtra7.length() > 0) {
                        tDUpdatableEvent = tDFirstEvent;
                        tDUpdatableEvent = tDFirstEvent;
                        tDFirstEvent.setFirstCheckId(stringExtra7);
                        tDUpdatableEvent = tDFirstEvent;
                    }
                } else if (intExtra == 1048581) {
                    tDUpdatableEvent = new TDOverWritableEvent(stringExtra4, jSONObject2, stringExtra7);
                } else if (intExtra == 1048580) {
                    tDUpdatableEvent = new TDUpdatableEvent(stringExtra4, jSONObject2, stringExtra7);
                }
                if (tDUpdatableEvent != null) {
                    tDUpdatableEvent.setEventTime(date2, timeZone);
                    thinkingAnalyticsSDKSharedInstance.track(tDUpdatableEvent);
                }
                break;
            case 1048582:
                String stringExtra8 = intent.getStringExtra("properties");
                if (stringExtra8 != null) {
                    try {
                        jSONObject5 = new JSONObject(stringExtra8);
                    } catch (JSONException e3) {
                        e3.printStackTrace();
                    }
                }
                thinkingAnalyticsSDKSharedInstance.setFromSubProcess(true);
                thinkingAnalyticsSDKSharedInstance.autoTrack(intent.getStringExtra("#event_name"), jSONObject5);
                break;
            default:
                switch (intExtra) {
                    case 2097152:
                        String stringExtra9 = intent.getStringExtra("properties");
                        long longExtra3 = intent.getLongExtra("TD_DATE", 0L);
                        if (stringExtra9 != null) {
                            try {
                                jSONObject3 = new JSONObject(stringExtra9);
                            } catch (JSONException e4) {
                                e4.printStackTrace();
                                jSONObject3 = null;
                            }
                        } else {
                            jSONObject3 = null;
                        }
                        thinkingAnalyticsSDKSharedInstance.user_operations(EnumC0761l.m714a(intent.getStringExtra("TD_KEY_USER_PROPERTY_SET_TYPE")), jSONObject3, longExtra3 != 0 ? new Date(longExtra3) : null);
                        break;
                    case 2097153:
                        String stringExtra10 = intent.getStringExtra("properties");
                        if (stringExtra10 != null) {
                            try {
                                jSONObject4 = new JSONObject(stringExtra10);
                            } catch (JSONException e5) {
                                e5.printStackTrace();
                            }
                        }
                        thinkingAnalyticsSDKSharedInstance.setSuperProperties(jSONObject4);
                        break;
                    case 2097154:
                        thinkingAnalyticsSDKSharedInstance.login(intent.getStringExtra("#account_id"));
                        break;
                    case 2097155:
                        thinkingAnalyticsSDKSharedInstance.logout();
                        break;
                    case 2097156:
                        thinkingAnalyticsSDKSharedInstance.identify(intent.getStringExtra("#distinct_id"));
                        break;
                    case 2097157:
                        thinkingAnalyticsSDKSharedInstance.flush();
                        break;
                    case 2097158:
                        thinkingAnalyticsSDKSharedInstance.unsetSuperProperty(intent.getStringExtra("properties"));
                        break;
                    case 2097159:
                        thinkingAnalyticsSDKSharedInstance.clearSuperProperties();
                        break;
                }
                break;
        }
    }
}
