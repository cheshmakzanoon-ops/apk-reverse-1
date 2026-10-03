package cn.thinkingdata.android;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.Intent;
import android.content.res.Resources;
import android.os.Bundle;
import android.text.TextUtils;
import cn.thinkingdata.android.utils.C0756g;
import cn.thinkingdata.android.utils.C0766q;
import cn.thinkingdata.android.utils.EnumC0761l;
import cn.thinkingdata.android.utils.InterfaceC0754e;
import cn.thinkingdata.android.utils.TDLog;
import java.lang.ref.WeakReference;
import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;
import java.util.concurrent.TimeUnit;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

class C0738o implements Application.ActivityLifecycleCallbacks {

    private final ThinkingAnalyticsSDK f230c;

    private C0722d f232e;

    private WeakReference<Activity> f233f;

    private boolean f228a = false;

    private final Object f229b = new Object();

    private volatile Boolean f231d = true;

    private final List<WeakReference<Activity>> f234g = new ArrayList();

    private boolean f235h = false;

    class a extends TimerTask {
        a() {
        }

        @Override
        public void run() {
            if (C0738o.this.f231d.booleanValue()) {
                C0738o.this.f231d = false;
                JSONObject jSONObject = new JSONObject();
                try {
                    if (!TDPresetProperties.disableList.contains("#resume_from_background")) {
                        jSONObject.put("#resume_from_background", C0738o.this.f228a);
                    }
                    if (!TDPresetProperties.disableList.contains("#start_reason")) {
                        String strM669a = C0738o.this.m669a();
                        if (!strM669a.equals(new JSONObject().toString())) {
                            jSONObject.put("#start_reason", strM669a);
                        }
                    }
                } catch (JSONException unused) {
                } finally {
                    C0738o.this.f230c.autoTrack("ta_app_start", jSONObject);
                    C0738o.this.f230c.flush();
                    C0738o.this.f235h = true;
                }
            }
        }
    }

    C0738o(ThinkingAnalyticsSDK thinkingAnalyticsSDK, String str) {
        this.f230c = thinkingAnalyticsSDK;
    }

    public static JSONArray m662a(Object obj) throws JSONException {
        JSONArray jSONArray = new JSONArray();
        if (!obj.getClass().isArray()) {
            throw new JSONException("Not a primitive array: " + obj.getClass());
        }
        int length = Array.getLength(obj);
        for (int i = 0; i < length; i++) {
            jSONArray.put(m666b(Array.get(obj, i)));
        }
        return jSONArray;
    }

    private void m663a(Activity activity, InterfaceC0754e interfaceC0754e) {
        if (this.f231d.booleanValue() || this.f228a) {
            if (this.f230c.isAutoTrackEnabled()) {
                try {
                    if (!this.f230c.isAutoTrackEventTypeIgnored(ThinkingAnalyticsSDK.AutoTrackEventType.APP_START)) {
                        this.f231d = false;
                        JSONObject jSONObject = new JSONObject();
                        if (!TDPresetProperties.disableList.contains("#resume_from_background")) {
                            jSONObject.put("#resume_from_background", this.f228a);
                        }
                        if (!TDPresetProperties.disableList.contains("#start_reason")) {
                            String strM669a = m669a();
                            if (!strM669a.equals(new JSONObject().toString())) {
                                jSONObject.put("#start_reason", strM669a);
                            }
                        }
                        C0766q.m746a(jSONObject, activity);
                        C0722d c0722d = this.f232e;
                        if (c0722d != null) {
                            double d = Double.parseDouble(c0722d.m501b());
                            if (d > 0.0d && !TDPresetProperties.disableList.contains("#background_duration")) {
                                jSONObject.put("#background_duration", d);
                            }
                        }
                        if (interfaceC0754e == null) {
                            this.f230c.autoTrack("ta_app_start", jSONObject);
                        } else if (!this.f230c.hasDisabled()) {
                            JSONObject autoTrackStartProperties = this.f230c.getAutoTrackStartProperties();
                            C0766q.m747a(jSONObject, autoTrackStartProperties, this.f230c.mConfig.getDefaultTimeZone());
                            C0718a c0718a = new C0718a(this.f230c, EnumC0761l.TRACK, autoTrackStartProperties, interfaceC0754e);
                            c0718a.f144a = "ta_app_start";
                            this.f230c.trackInternal(c0718a);
                        }
                    }
                    if (interfaceC0754e == null && !this.f230c.isAutoTrackEventTypeIgnored(ThinkingAnalyticsSDK.AutoTrackEventType.APP_END)) {
                        this.f230c.timeEvent("ta_app_end");
                        this.f235h = true;
                    }
                } catch (Exception e) {
                    TDLog.m684i("ThinkingAnalytics.ThinkingDataActivityLifecycleCallbacks", e);
                }
            }
            try {
                this.f230c.appBecomeActive();
                this.f232e = null;
            } catch (Exception e2) {
                e2.printStackTrace();
            }
        }
    }

    private boolean m664a(Activity activity, boolean z) {
        synchronized (this.f229b) {
            Iterator<WeakReference<Activity>> it = this.f234g.iterator();
            while (it.hasNext()) {
                if (it.next().get() == activity) {
                    if (z) {
                        it.remove();
                    }
                    return false;
                }
            }
            return true;
        }
    }

    public static Object m666b(Object obj) {
        if (obj == null) {
            return JSONObject.NULL;
        }
        if ((obj instanceof JSONArray) || (obj instanceof JSONObject) || obj.equals(JSONObject.NULL)) {
            return obj;
        }
        try {
            if (obj instanceof Collection) {
                return new JSONArray((Collection) obj);
            }
            if (obj.getClass().isArray()) {
                return m662a(obj);
            }
            if (obj instanceof Map) {
                return new JSONObject((Map) obj);
            }
            if (!(obj instanceof Boolean) && !(obj instanceof Byte) && !(obj instanceof Character) && !(obj instanceof Double) && !(obj instanceof Float) && !(obj instanceof Integer) && !(obj instanceof Long) && !(obj instanceof Short) && !(obj instanceof String)) {
                if (obj.getClass().getPackage().getName().startsWith("java.")) {
                    return obj.toString();
                }
                return null;
            }
            return obj;
        } catch (Exception unused) {
        }
    }

    String m669a() {
        JSONObject jSONObject = new JSONObject();
        JSONObject jSONObject2 = new JSONObject();
        WeakReference<Activity> weakReference = this.f233f;
        if (weakReference != null) {
            try {
                Intent intent = weakReference.get().getIntent();
                if (intent != null) {
                    String dataString = intent.getDataString();
                    if (!TextUtils.isEmpty(dataString)) {
                        jSONObject.put("url", dataString);
                    }
                    Bundle extras = intent.getExtras();
                    if (extras != null) {
                        for (String str : extras.keySet()) {
                            Object obj = extras.get(str);
                            Object objM666b = m666b(obj);
                            if (objM666b != null && objM666b != JSONObject.NULL) {
                                jSONObject2.put(str, m666b(obj));
                            }
                        }
                        jSONObject.put("data", jSONObject2);
                    }
                }
            } catch (Exception unused) {
                return jSONObject.toString();
            }
        }
        return jSONObject.toString();
    }

    void m670a(JSONObject jSONObject) {
        this.f230c.autoTrack("ta_app_crash", jSONObject);
        this.f230c.autoTrack("ta_app_end", new JSONObject());
        this.f235h = false;
        this.f230c.flush();
    }

    boolean m671a(Context context) {
        try {
            Resources resources = context.getResources();
            return resources.getBoolean(resources.getIdentifier("TAEnableBackgroundStartEvent", "bool", context.getPackageName()));
        } catch (Exception unused) {
            return false;
        }
    }

    void m672b() {
        synchronized (this.f229b) {
            if (this.f231d.booleanValue() && this.f230c.isAutoTrackEnabled()) {
                try {
                    if (!this.f230c.isAutoTrackEventTypeIgnored(ThinkingAnalyticsSDK.AutoTrackEventType.APP_START) && (C0766q.m757e(this.f230c.mConfig.mContext) || m671a(this.f230c.mConfig.mContext))) {
                        new Timer().schedule(new a(), 100L);
                    }
                } catch (Exception e) {
                    TDLog.m684i("ThinkingAnalytics.ThinkingDataActivityLifecycleCallbacks", e);
                }
            }
        }
    }

    @Override
    public void onActivityCreated(Activity activity, Bundle bundle) {
        TDLog.m682i("ThinkingAnalytics.ThinkingDataActivityLifecycleCallbacks", "onActivityCreated");
        this.f233f = new WeakReference<>(activity);
    }

    @Override
    public void onActivityDestroyed(Activity activity) {
    }

    @Override
    public void onActivityPaused(Activity activity) {
        synchronized (this.f229b) {
            if (m664a(activity, false)) {
                TDLog.m682i("ThinkingAnalytics.ThinkingDataActivityLifecycleCallbacks", "onActivityPaused: the SDK was initialized after the onActivityStart of " + activity);
                this.f234g.add(new WeakReference<>(activity));
                if (this.f234g.size() == 1) {
                    m663a(activity, this.f230c.getAutoTrackStartTime());
                    this.f230c.flush();
                    this.f231d = false;
                }
            }
        }
    }

    @Override
    public void onActivityResumed(Activity activity) {
        synchronized (this.f229b) {
            if (m664a(activity, false)) {
                TDLog.m682i("ThinkingAnalytics.ThinkingDataActivityLifecycleCallbacks", "onActivityResumed: the SDK was initialized after the onActivityStart of " + activity);
                this.f234g.add(new WeakReference<>(activity));
                if (this.f234g.size() == 1) {
                    m663a(activity, this.f230c.getAutoTrackStartTime());
                    this.f230c.flush();
                    this.f231d = false;
                }
            }
        }
        try {
            boolean zIsActivityAutoTrackAppViewScreenIgnored = this.f230c.isActivityAutoTrackAppViewScreenIgnored(activity.getClass());
            if (!this.f230c.isAutoTrackEnabled() || zIsActivityAutoTrackAppViewScreenIgnored || this.f230c.isAutoTrackEventTypeIgnored(ThinkingAnalyticsSDK.AutoTrackEventType.APP_VIEW_SCREEN)) {
                return;
            }
            try {
                JSONObject jSONObject = new JSONObject();
                if (!TDPresetProperties.disableList.contains("#screen_name")) {
                    jSONObject.put("#screen_name", activity.getClass().getCanonicalName());
                }
                C0766q.m746a(jSONObject, activity);
                if (activity instanceof ScreenAutoTracker) {
                    ScreenAutoTracker screenAutoTracker = (ScreenAutoTracker) activity;
                    String screenUrl = screenAutoTracker.getScreenUrl();
                    JSONObject trackProperties = screenAutoTracker.getTrackProperties();
                    if (trackProperties == null || !C0756g.m705a(trackProperties)) {
                        TDLog.m679d("ThinkingAnalytics.ThinkingDataActivityLifecycleCallbacks", "invalid properties: " + trackProperties);
                    } else {
                        C0766q.m747a(trackProperties, jSONObject, this.f230c.mConfig.getDefaultTimeZone());
                    }
                    this.f230c.trackViewScreenInternal(screenUrl, jSONObject);
                    return;
                }
                ThinkingDataAutoTrackAppViewScreenUrl thinkingDataAutoTrackAppViewScreenUrl = (ThinkingDataAutoTrackAppViewScreenUrl) activity.getClass().getAnnotation(ThinkingDataAutoTrackAppViewScreenUrl.class);
                if (thinkingDataAutoTrackAppViewScreenUrl == null || !(TextUtils.isEmpty(thinkingDataAutoTrackAppViewScreenUrl.appId()) || this.f230c.getToken().equals(thinkingDataAutoTrackAppViewScreenUrl.appId()))) {
                    this.f230c.autoTrack("ta_app_view", jSONObject);
                    return;
                }
                String strUrl = thinkingDataAutoTrackAppViewScreenUrl.url();
                if (TextUtils.isEmpty(strUrl)) {
                    strUrl = activity.getClass().getCanonicalName();
                }
                this.f230c.trackViewScreenInternal(strUrl, jSONObject);
            } catch (Exception e) {
                TDLog.m684i("ThinkingAnalytics.ThinkingDataActivityLifecycleCallbacks", e);
            }
        } catch (Exception e2) {
            e2.printStackTrace();
        }
    }

    @Override
    public void onActivitySaveInstanceState(Activity activity, Bundle bundle) {
    }

    @Override
    public void onActivityStarted(Activity activity) {
        TDLog.m682i("ThinkingAnalytics.ThinkingDataActivityLifecycleCallbacks", "onActivityStarted");
        this.f233f = new WeakReference<>(activity);
        try {
            synchronized (this.f229b) {
                try {
                    if (this.f234g.size() == 0) {
                        m663a(activity, (InterfaceC0754e) null);
                    }
                    if (m664a(activity, false)) {
                        this.f234g.add(new WeakReference<>(activity));
                    } else {
                        TDLog.m687w("ThinkingAnalytics.ThinkingDataActivityLifecycleCallbacks", "Unexpected state. The activity might not be stopped correctly: " + activity);
                    }
                } catch (Throwable th) {
                    throw th;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onActivityStopped(Activity activity) {
        ThinkingAnalyticsSDK thinkingAnalyticsSDK;
        String str;
        TDLog.m682i("ThinkingAnalytics.ThinkingDataActivityLifecycleCallbacks", "onActivityStopped");
        try {
            synchronized (this.f229b) {
                if (m664a(activity, true)) {
                    TDLog.m682i("ThinkingAnalytics.ThinkingDataActivityLifecycleCallbacks", "onActivityStopped: the SDK might be initialized after the onActivityStart of " + activity);
                    return;
                }
                if (this.f234g.size() == 0) {
                    this.f233f = null;
                    if (this.f235h) {
                        try {
                            this.f230c.appEnterBackground();
                            this.f228a = true;
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                        if (this.f230c.isAutoTrackEnabled()) {
                            JSONObject jSONObject = new JSONObject();
                            if (!this.f230c.isAutoTrackEventTypeIgnored(ThinkingAnalyticsSDK.AutoTrackEventType.APP_END)) {
                                try {
                                    try {
                                        C0766q.m746a(jSONObject, activity);
                                        thinkingAnalyticsSDK = this.f230c;
                                        str = "ta_app_end";
                                    } catch (Throwable th) {
                                        this.f230c.autoTrack("ta_app_end", jSONObject);
                                        this.f235h = false;
                                        throw th;
                                    }
                                } catch (Exception e2) {
                                    TDLog.m684i("ThinkingAnalytics.ThinkingDataActivityLifecycleCallbacks", e2);
                                    thinkingAnalyticsSDK = this.f230c;
                                    str = "ta_app_end";
                                }
                                thinkingAnalyticsSDK.autoTrack(str, jSONObject);
                                this.f235h = false;
                            }
                        }
                        try {
                            this.f232e = new C0722d(TimeUnit.SECONDS);
                            this.f230c.flush();
                        } catch (Exception e3) {
                            e3.printStackTrace();
                        }
                    }
                }
            }
        } catch (Exception e4) {
            e4.printStackTrace();
        }
    }
}
