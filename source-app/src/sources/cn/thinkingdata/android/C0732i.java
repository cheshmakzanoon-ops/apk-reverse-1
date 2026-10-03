package cn.thinkingdata.android;

import android.content.Context;
import android.content.Intent;
import cn.thinkingdata.android.utils.C0756g;
import cn.thinkingdata.android.utils.C0766q;
import cn.thinkingdata.android.utils.EnumC0761l;
import java.util.Date;
import java.util.List;
import java.util.TimeZone;
import org.json.JSONException;
import org.json.JSONObject;

class C0732i extends ThinkingAnalyticsSDK {

    Context f198a;

    String f199b;

    private final JSONObject f200c;

    static class a {

        static final int[] f201a;

        static {
            int[] iArr = new int[EnumC0761l.values().length];
            f201a = iArr;
            try {
                iArr[EnumC0761l.TRACK_OVERWRITE.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                f201a[EnumC0761l.TRACK_UPDATE.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                f201a[EnumC0761l.TRACK.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
        }
    }

    public C0732i(TDConfig tDConfig) {
        super(tDConfig, new boolean[0]);
        this.f198a = tDConfig.mContext;
        this.f200c = new JSONObject();
        this.f199b = C0766q.m750b(this.f198a);
    }

    double m528a(String str) {
        C0722d c0722d;
        synchronized (this.mTrackTimer) {
            c0722d = this.mTrackTimer.get(str);
            this.mTrackTimer.remove(str);
        }
        if (c0722d != null) {
            return Double.parseDouble(c0722d.m501b());
        }
        return 0.0d;
    }

    public Intent m529a() {
        String str;
        Intent intent = new Intent();
        String strM755d = C0766q.m755d(this.f198a);
        if (strM755d.length() == 0) {
            str = "cn.thinkingdata.receiver";
        } else {
            str = strM755d + ".cn.thinkingdata.receiver";
        }
        intent.setAction(str);
        intent.putExtra("#app_id", this.mConfig.getName());
        return intent;
    }

    public JSONObject m530a(String str, JSONObject jSONObject) {
        JSONObject dynamicSuperProperties;
        JSONObject jSONObject2 = new JSONObject();
        try {
            if (!TDPresetProperties.disableList.contains("#bundle_id")) {
                jSONObject2.put("#bundle_id", this.f199b);
            }
            double dM528a = m528a(str);
            if (dM528a > 0.0d && !TDPresetProperties.disableList.contains("#duration")) {
                jSONObject2.put("#duration", dM528a);
            }
        } catch (JSONException unused) {
        }
        if (getDynamicSuperPropertiesTracker() != null && (dynamicSuperProperties = getDynamicSuperPropertiesTracker().getDynamicSuperProperties()) != null) {
            try {
                C0766q.m747a(dynamicSuperProperties, jSONObject2, this.mConfig.getDefaultTimeZone());
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
        if (getDynamicSuperPropertiesTrackerListener() != null) {
            try {
                C0766q.m747a(new JSONObject(getDynamicSuperPropertiesTrackerListener().getDynamicSuperPropertiesString()), jSONObject2, this.mConfig.getDefaultTimeZone());
            } catch (JSONException e2) {
                e2.printStackTrace();
            }
        }
        try {
            C0766q.m747a(jSONObject, jSONObject2, this.mConfig.getDefaultTimeZone());
        } catch (JSONException e3) {
            e3.printStackTrace();
        }
        return jSONObject2;
    }

    @Override
    void autoTrack(String str, JSONObject jSONObject) {
        Intent intentM529a = m529a();
        intentM529a.putExtra("#event_name", str);
        if (jSONObject == null) {
            jSONObject = new JSONObject();
        }
        JSONObject jSONObjectM530a = m530a(str, jSONObject);
        try {
            JSONObject jSONObjectOptJSONObject = getAutoTrackProperties().optJSONObject(str);
            if (jSONObjectOptJSONObject != null) {
                C0766q.m747a(jSONObjectOptJSONObject, jSONObjectM530a, this.mConfig.getDefaultTimeZone());
            }
            intentM529a.putExtra("properties", jSONObjectM530a.toString());
            intentM529a.putExtra("TD_ACTION", 1048582);
            this.f198a.sendBroadcast(intentM529a);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void clearSuperProperties() {
        Intent intentM529a = m529a();
        intentM529a.putExtra("TD_ACTION", 2097159);
        this.f198a.sendBroadcast(intentM529a);
    }

    @Override
    public void enableAutoTrack(List<ThinkingAnalyticsSDK.AutoTrackEventType> list, ThinkingAnalyticsSDK.AutoTrackEventListener autoTrackEventListener) {
    }

    @Override
    public void enableTracking(boolean z) {
    }

    @Override
    public void flush() {
        Intent intentM529a = m529a();
        intentM529a.putExtra("TD_ACTION", 2097157);
        this.f198a.sendBroadcast(intentM529a);
    }

    @Override
    public JSONObject getAutoTrackProperties() {
        return this.f200c;
    }

    @Override
    public boolean hasOptOut() {
        return false;
    }

    @Override
    public void identify(String str) {
        Intent intentM529a = m529a();
        intentM529a.putExtra("TD_ACTION", 2097156);
        if (str == null || str.length() <= 0) {
            str = "";
        }
        intentM529a.putExtra("#distinct_id", str);
        this.f198a.sendBroadcast(intentM529a);
    }

    @Override
    public void login(String str) {
        Intent intentM529a = m529a();
        intentM529a.putExtra("TD_ACTION", 2097154);
        if (str == null || str.length() <= 0) {
            str = "";
        }
        intentM529a.putExtra("#account_id", str);
        this.f198a.sendBroadcast(intentM529a);
    }

    @Override
    public void logout() {
        Intent intentM529a = m529a();
        intentM529a.putExtra("TD_ACTION", 2097155);
        this.f198a.sendBroadcast(intentM529a);
    }

    @Override
    public void optInTracking() {
    }

    @Override
    public void optOutTracking() {
    }

    @Override
    public void optOutTrackingAndDeleteUser() {
    }

    @Override
    public void setAutoTrackProperties(List<ThinkingAnalyticsSDK.AutoTrackEventType> list, JSONObject jSONObject) {
        if (hasDisabled()) {
            return;
        }
        if (jSONObject != null) {
            try {
                if (C0756g.m705a(jSONObject)) {
                    JSONObject jSONObject2 = new JSONObject();
                    for (ThinkingAnalyticsSDK.AutoTrackEventType autoTrackEventType : list) {
                        JSONObject jSONObject3 = new JSONObject();
                        C0766q.m747a(jSONObject, jSONObject3, this.mConfig.getDefaultTimeZone());
                        jSONObject2.put(autoTrackEventType.getEventName(), jSONObject3);
                    }
                    synchronized (this.f200c) {
                        C0766q.m752b(jSONObject2, this.f200c, this.mConfig.getDefaultTimeZone());
                    }
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
                return;
            }
        }
        if (this.mConfig.shouldThrowException()) {
            throw new C0736m("Set autoTrackEvent properties failed. Please refer to the SDK debug log for details.");
        }
    }

    @Override
    public void setNetworkType(ThinkingAnalyticsSDK.ThinkingdataNetworkType thinkingdataNetworkType) {
    }

    @Override
    public void setSuperProperties(JSONObject jSONObject) {
        JSONObject jSONObject2 = new JSONObject();
        try {
            C0766q.m747a(jSONObject, jSONObject2, this.mConfig.getDefaultTimeZone());
            Intent intentM529a = m529a();
            intentM529a.putExtra("TD_ACTION", 2097153);
            if (jSONObject != null) {
                intentM529a.putExtra("properties", jSONObject2.toString());
            }
            this.f198a.sendBroadcast(intentM529a);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void setTrackStatus(ThinkingAnalyticsSDK.TATrackStatus tATrackStatus) {
    }

    @Override
    public void track(AbstractC0737n abstractC0737n) {
        int i;
        JSONObject properties;
        Intent intentM529a = m529a();
        int i2 = a.f201a[abstractC0737n.getDataType().ordinal()];
        if (i2 == 1) {
            i = 1048581;
        } else {
            if (i2 != 2) {
                if (i2 == 3) {
                    i = 1048579;
                }
                intentM529a.putExtra("#event_name", abstractC0737n.getEventName());
                if (abstractC0737n.getProperties() == null) {
                    properties = new JSONObject();
                } else {
                    properties = abstractC0737n.getProperties();
                }
                intentM529a.putExtra("properties", m530a(abstractC0737n.getEventName(), properties).toString());
                if (abstractC0737n.getEventTime() != null) {
                    intentM529a.putExtra("TD_DATE", abstractC0737n.getEventTime().getTime());
                }
                if (abstractC0737n.getTimeZone() != null) {
                    intentM529a.putExtra("TD_KEY_TIMEZONE", abstractC0737n.getTimeZone().getID());
                }
                intentM529a.putExtra("TD_KEY_EXTRA_FIELD", abstractC0737n.getExtraValue());
                this.f198a.sendBroadcast(intentM529a);
            }
            i = 1048580;
        }
        intentM529a.putExtra("TD_ACTION", i);
        intentM529a.putExtra("#event_name", abstractC0737n.getEventName());
        if (abstractC0737n.getProperties() == null) {
            properties = new JSONObject();
        } else {
            properties = abstractC0737n.getProperties();
        }
        intentM529a.putExtra("properties", m530a(abstractC0737n.getEventName(), properties).toString());
        if (abstractC0737n.getEventTime() != null) {
            intentM529a.putExtra("TD_DATE", abstractC0737n.getEventTime().getTime());
        }
        if (abstractC0737n.getTimeZone() != null) {
            intentM529a.putExtra("TD_KEY_TIMEZONE", abstractC0737n.getTimeZone().getID());
        }
        intentM529a.putExtra("TD_KEY_EXTRA_FIELD", abstractC0737n.getExtraValue());
        this.f198a.sendBroadcast(intentM529a);
    }

    @Override
    public void track(String str) {
        track(str, (JSONObject) null, (Date) null, (TimeZone) null);
    }

    @Override
    public void track(String str, JSONObject jSONObject) {
        track(str, jSONObject, (Date) null, (TimeZone) null);
    }

    @Override
    public void track(String str, JSONObject jSONObject, Date date) {
        track(str, jSONObject, date, (TimeZone) null);
    }

    @Override
    public void track(String str, JSONObject jSONObject, Date date, TimeZone timeZone) {
        Intent intentM529a = m529a();
        intentM529a.putExtra("TD_ACTION", 1048578);
        intentM529a.putExtra("#event_name", str);
        if (jSONObject == null) {
            jSONObject = new JSONObject();
        }
        intentM529a.putExtra("properties", m530a(str, jSONObject).toString());
        if (date != null) {
            intentM529a.putExtra("TD_DATE", date.getTime());
        }
        if (timeZone != null) {
            intentM529a.putExtra("TD_KEY_TIMEZONE", timeZone.getID());
        }
        this.f198a.sendBroadcast(intentM529a);
    }

    @Override
    public void unsetSuperProperty(String str) {
        Intent intentM529a = m529a();
        intentM529a.putExtra("TD_ACTION", 2097158);
        if (str != null) {
            intentM529a.putExtra("properties", str);
        }
        this.f198a.sendBroadcast(intentM529a);
    }

    @Override
    void user_operations(EnumC0761l enumC0761l, JSONObject jSONObject, Date date) {
        Intent intentM529a = m529a();
        intentM529a.putExtra("TD_ACTION", 2097152);
        intentM529a.putExtra("TD_KEY_USER_PROPERTY_SET_TYPE", enumC0761l.m715a());
        if (jSONObject != null) {
            JSONObject jSONObject2 = new JSONObject();
            try {
                C0766q.m747a(jSONObject, jSONObject2, this.mConfig.getDefaultTimeZone());
            } catch (JSONException e) {
                e.printStackTrace();
            }
            intentM529a.putExtra("properties", jSONObject2.toString());
        }
        if (date != null) {
            intentM529a.putExtra("TD_DATE", date.getTime());
        }
        this.f198a.sendBroadcast(intentM529a);
    }
}
