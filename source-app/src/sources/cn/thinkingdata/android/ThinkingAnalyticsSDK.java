package cn.thinkingdata.android;

import android.app.Activity;
import android.app.Application;
import android.app.Dialog;
import android.app.Fragment;
import android.content.Context;
import android.content.SharedPreferences;
import android.os.Looper;
import android.os.SystemClock;
import android.text.TextUtils;
import android.view.View;
import android.webkit.WebView;
import cn.thinkingdata.android.encrypt.C0728e;
import cn.thinkingdata.android.p004p.C0740b;
import cn.thinkingdata.android.p004p.C0743e;
import cn.thinkingdata.android.p004p.C0744f;
import cn.thinkingdata.android.p004p.C0745g;
import cn.thinkingdata.android.p004p.C0746h;
import cn.thinkingdata.android.p004p.C0748j;
import cn.thinkingdata.android.p004p.C0749k;
import cn.thinkingdata.android.utils.C0756g;
import cn.thinkingdata.android.utils.C0758i;
import cn.thinkingdata.android.utils.C0759j;
import cn.thinkingdata.android.utils.C0760k;
import cn.thinkingdata.android.utils.C0763n;
import cn.thinkingdata.android.utils.C0764o;
import cn.thinkingdata.android.utils.C0765p;
import cn.thinkingdata.android.utils.C0766q;
import cn.thinkingdata.android.utils.EnumC0761l;
import cn.thinkingdata.android.utils.InterfaceC0753d;
import cn.thinkingdata.android.utils.InterfaceC0754e;
import cn.thinkingdata.android.utils.TDLog;
import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.locks.ReentrantReadWriteLock;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class ThinkingAnalyticsSDK implements InterfaceC0723e {
    private static final int APP_CRASH = 16;
    private static final int APP_END = 2;
    private static final int APP_INSTALL = 32;
    private static final int APP_START = 1;
    private static final String PREFERENCE_NAME = "com.thinkingdata.analyse";
    static final String TAG = "ThinkingAnalyticsSDK";
    private static InterfaceC0753d sCalibratedTime;
    private static C0744f sOldLoginId;
    private static C0748j sRandomID;
    private static Future<SharedPreferences> sStoredSharedPrefs;
    private DynamicSuperPropertiesTrackerListener dynamicSuperPropertiesTrackerListener;
    private boolean mAutoTrack;
    private AutoTrackEventListener mAutoTrackEventListener;
    private AutoTrackEventTrackerListener mAutoTrackEventTrackerListener;
    private List<AutoTrackEventType> mAutoTrackEventTypeList;
    private List<Integer> mAutoTrackIgnoredActivities;
    private JSONObject mAutoTrackStartProperties;
    private InterfaceC0754e mAutoTrackStartTime;
    TDConfig mConfig;
    private DynamicSuperPropertiesTracker mDynamicSuperPropertiesTracker;
    private final C0740b mEnableFlag;
    private final boolean mEnableTrackOldData;
    private final C0743e mIdentifyId;
    private String mLastScreenUrl;
    private C0738o mLifecycleCallbacks;
    private final C0744f mLoginId;
    protected final C0720b mMessages;
    private final C0745g mOptOutFlag;
    protected final C0746h mPausePostFlag;
    private final C0749k mSuperProperties;
    private final C0733j mSystemInformation;
    private boolean mTrackCrash;
    private boolean mTrackFragmentAppViewScreen;
    final Map<String, C0722d> mTrackTimer;
    private static final C0731h sPrefsLoader = new C0731h();
    private static final Object sOldLoginIdLock = new Object();
    private static final Object sRandomIDLock = new Object();
    private static final Map<Context, Map<String, ThinkingAnalyticsSDK>> sInstanceMap = new HashMap();
    private static final Map<Context, List<String>> sAppFirstInstallationMap = new HashMap();
    private static final ReentrantReadWriteLock sCalibratedTimeLock = new ReentrantReadWriteLock();
    private boolean isFromSubProcess = false;
    private List<Class> mIgnoredViewTypeList = new ArrayList();
    private final JSONObject mAutoTrackEventProperties = new JSONObject();

    public interface AutoTrackEventListener {
        JSONObject eventCallback(AutoTrackEventType autoTrackEventType, JSONObject jSONObject);
    }

    public interface AutoTrackEventTrackerListener {
        String eventCallback(int i, String str);
    }

    public enum AutoTrackEventType {
        APP_START("ta_app_start"),
        APP_END("ta_app_end"),
        APP_CLICK("ta_app_click"),
        APP_VIEW_SCREEN("ta_app_view"),
        APP_CRASH("ta_app_crash"),
        APP_INSTALL("ta_app_install");

        private final String eventName;

        AutoTrackEventType(String str) {
            this.eventName = str;
        }

        public static AutoTrackEventType autoTrackEventTypeFromEventName(String str) {
            if (TextUtils.isEmpty(str)) {
                return null;
            }
            str.hashCode();
            switch (str) {
                case "ta_app_install":
                    return APP_INSTALL;
                case "ta_app_click":
                    return APP_CLICK;
                case "ta_app_crash":
                    return APP_CRASH;
                case "ta_app_start":
                    return APP_START;
                case "ta_app_end":
                    return APP_END;
                case "ta_app_view":
                    return APP_VIEW_SCREEN;
                default:
                    return null;
            }
        }

        String getEventName() {
            return this.eventName;
        }
    }

    public interface DynamicSuperPropertiesTracker {
        JSONObject getDynamicSuperProperties();
    }

    public interface DynamicSuperPropertiesTrackerListener {
        String getDynamicSuperPropertiesString();
    }

    public enum TATrackStatus {
        PAUSE,
        STOP,
        SAVE_ONLY,
        NORMAL
    }

    public enum ThinkingdataNetworkType {
        NETWORKTYPE_DEFAULT,
        NETWORKTYPE_WIFI,
        NETWORKTYPE_ALL
    }

    static class C0707a {

        static final int[] f121a;

        static {
            int[] iArr = new int[TATrackStatus.values().length];
            f121a = iArr;
            try {
                iArr[TATrackStatus.PAUSE.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                f121a[TATrackStatus.STOP.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                f121a[TATrackStatus.SAVE_ONLY.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            try {
                f121a[TATrackStatus.NORMAL.ordinal()] = 4;
            } catch (NoSuchFieldError unused4) {
            }
        }
    }

    interface InterfaceC0708b {
        void mo435a(ThinkingAnalyticsSDK thinkingAnalyticsSDK);
    }

    ThinkingAnalyticsSDK(TDConfig tDConfig, boolean... zArr) {
        this.mConfig = tDConfig;
        if (!TDPresetProperties.disableList.contains("#fps")) {
            if (Looper.myLooper() == null) {
                Looper.prepare();
            }
            C0766q.m756d();
        }
        if (zArr.length > 0 && zArr[0]) {
            this.mLoginId = null;
            this.mIdentifyId = null;
            this.mSuperProperties = null;
            this.mOptOutFlag = null;
            this.mEnableFlag = null;
            this.mPausePostFlag = null;
            this.mEnableTrackOldData = false;
            this.mTrackTimer = new HashMap();
            this.mSystemInformation = C0733j.m532a(tDConfig.mContext, tDConfig.getDefaultTimeZone());
            this.mMessages = getDataHandleInstance(tDConfig.mContext);
            return;
        }
        if (sStoredSharedPrefs == null) {
            Future<SharedPreferences> futureM527a = sPrefsLoader.m527a(tDConfig.mContext, PREFERENCE_NAME);
            sStoredSharedPrefs = futureM527a;
            sRandomID = new C0748j(futureM527a);
            sOldLoginId = new C0744f(sStoredSharedPrefs);
        }
        boolean z = tDConfig.trackOldData() && !isOldDataTracked();
        this.mEnableTrackOldData = z;
        Future<SharedPreferences> futureM527a2 = sPrefsLoader.m527a(tDConfig.mContext, "com.thinkingdata.analyse_" + tDConfig.getName());
        this.mLoginId = new C0744f(futureM527a2);
        this.mIdentifyId = new C0743e(futureM527a2);
        this.mSuperProperties = new C0749k(futureM527a2);
        this.mOptOutFlag = new C0745g(futureM527a2);
        this.mEnableFlag = new C0740b(futureM527a2);
        C0746h c0746h = new C0746h(futureM527a2);
        this.mPausePostFlag = c0746h;
        this.mSystemInformation = C0733j.m532a(tDConfig.mContext, tDConfig.getDefaultTimeZone());
        C0720b dataHandleInstance = getDataHandleInstance(tDConfig.mContext);
        this.mMessages = dataHandleInstance;
        dataHandleInstance.m451a(getToken(), c0746h.m678b().booleanValue());
        if (tDConfig.mEnableEncrypt) {
            C0728e.m520a(tDConfig.getName(), tDConfig);
        }
        if (z) {
            dataHandleInstance.m455c(tDConfig.getName());
        }
        this.mTrackTimer = new HashMap();
        this.mAutoTrackIgnoredActivities = new ArrayList();
        this.mAutoTrackEventTypeList = new ArrayList();
        this.mLifecycleCallbacks = new C0738o(this, this.mConfig.getMainProcessName());
        ((Application) tDConfig.mContext.getApplicationContext()).registerActivityLifecycleCallbacks(this.mLifecycleCallbacks);
        if (!tDConfig.isNormal() || isLogControlFileExist()) {
            enableTrackLog(true);
        }
        if (tDConfig.isEnableMutiprocess() && C0766q.m758f(tDConfig.mContext)) {
            TDReceiver.m434a(tDConfig.mContext);
        }
        TDLog.m682i(TAG, String.format("Thinking Analytics SDK %s instance initialized successfully with mode: %s, APP ID ends with: %s, server url: %s, device ID: %s", TDConfig.VERSION, tDConfig.getMode().name(), C0766q.m736a(tDConfig.mToken, 4), tDConfig.getServerUrl(), getDeviceId()));
    }

    static void addInstance(ThinkingAnalyticsSDK thinkingAnalyticsSDK, Context context, String str) {
        Map<Context, Map<String, ThinkingAnalyticsSDK>> map = sInstanceMap;
        synchronized (map) {
            Map<String, ThinkingAnalyticsSDK> map2 = map.get(context);
            if (map2 == null) {
                map2 = new HashMap<>();
                map.put(context, map2);
            }
            map2.put(str, thinkingAnalyticsSDK);
        }
    }

    static void allInstances(InterfaceC0708b interfaceC0708b) {
        Map<Context, Map<String, ThinkingAnalyticsSDK>> map = sInstanceMap;
        synchronized (map) {
            Iterator<Map<String, ThinkingAnalyticsSDK>> it = map.values().iterator();
            while (it.hasNext()) {
                Iterator<ThinkingAnalyticsSDK> it2 = it.next().values().iterator();
                while (it2.hasNext()) {
                    interfaceC0708b.mo435a(it2.next());
                }
            }
        }
    }

    public static void calibrateTime(long j) {
        setCalibratedTime(new C0759j(j));
    }

    public static void calibrateTimeWithNtp(String... strArr) {
        if (strArr == null) {
            return;
        }
        setCalibratedTime(new C0760k(strArr));
    }

    public static void calibrateTimeWithNtpForUnity(String str) {
        calibrateTimeWithNtp(str);
    }

    public static void enableTrackLog(boolean z) {
        TDLog.setEnableLog(z);
    }

    public static InterfaceC0753d getCalibratedTime() {
        return sCalibratedTime;
    }

    private String getIdentifyID() {
        String strB;
        synchronized (this.mIdentifyId) {
            strB = this.mIdentifyId.m678b();
        }
        return strB;
    }

    static Map<String, ThinkingAnalyticsSDK> getInstanceMap(Context context) {
        return sInstanceMap.get(context);
    }

    public static String getLocalRegion() {
        return Locale.getDefault().getCountry();
    }

    private InterfaceC0754e getTime() {
        ReentrantReadWriteLock reentrantReadWriteLock = sCalibratedTimeLock;
        reentrantReadWriteLock.readLock().lock();
        InterfaceC0753d interfaceC0753d = sCalibratedTime;
        InterfaceC0754e c0764o = interfaceC0753d != null ? new C0764o(interfaceC0753d, this.mConfig.getDefaultTimeZone()) : new C0763n(new Date(), this.mConfig.getDefaultTimeZone());
        reentrantReadWriteLock.readLock().unlock();
        return c0764o;
    }

    private InterfaceC0754e getTime(String str, Double d) {
        return new C0765p(str, d);
    }

    private InterfaceC0754e getTime(Date date, TimeZone timeZone) {
        if (timeZone != null) {
            return new C0763n(date, timeZone);
        }
        C0763n c0763n = new C0763n(date, this.mConfig.getDefaultTimeZone());
        c0763n.m722c();
        return c0763n;
    }

    private static boolean isLogControlFileExist() {
        return new File("/storage/emulated/0/Download/ta_log_controller").exists();
    }

    private static boolean isOldDataTracked() {
        Map<Context, Map<String, ThinkingAnalyticsSDK>> map = sInstanceMap;
        synchronized (map) {
            if (map.size() > 0) {
                Iterator<Map<String, ThinkingAnalyticsSDK>> it = map.values().iterator();
                while (it.hasNext()) {
                    Iterator<ThinkingAnalyticsSDK> it2 = it.next().values().iterator();
                    while (it2.hasNext()) {
                        if (it2.next().mEnableTrackOldData) {
                            return true;
                        }
                    }
                }
            }
            return false;
        }
    }

    private JSONObject obtainDefaultEventProperties(String str) {
        C0722d c0722d;
        Double dValueOf;
        Double dValueOf2;
        JSONObject dynamicSuperProperties;
        JSONObject jSONObjectOptJSONObject;
        JSONObject jSONObject = new JSONObject();
        try {
            C0766q.m747a(new JSONObject(this.mSystemInformation.m550c()), jSONObject, this.mConfig.getDefaultTimeZone());
            if (!TextUtils.isEmpty(this.mSystemInformation.m548b())) {
                jSONObject.put("#app_version", this.mSystemInformation.m548b());
            }
            if (!TDPresetProperties.disableList.contains("#fps")) {
                jSONObject.put("#fps", C0766q.m726a());
            }
            C0766q.m747a(getSuperProperties(), jSONObject, this.mConfig.getDefaultTimeZone());
            if (!this.isFromSubProcess && (jSONObjectOptJSONObject = getAutoTrackProperties().optJSONObject(str)) != null) {
                C0766q.m747a(jSONObjectOptJSONObject, jSONObject, this.mConfig.getDefaultTimeZone());
            }
            try {
                DynamicSuperPropertiesTracker dynamicSuperPropertiesTracker = this.mDynamicSuperPropertiesTracker;
                if (dynamicSuperPropertiesTracker != null && (dynamicSuperProperties = dynamicSuperPropertiesTracker.getDynamicSuperProperties()) != null && C0756g.m705a(dynamicSuperProperties)) {
                    C0766q.m747a(dynamicSuperProperties, jSONObject, this.mConfig.getDefaultTimeZone());
                }
                if (this.dynamicSuperPropertiesTrackerListener != null) {
                    JSONObject jSONObject2 = new JSONObject(this.dynamicSuperPropertiesTrackerListener.getDynamicSuperPropertiesString());
                    if (C0756g.m705a(jSONObject2)) {
                        C0766q.m747a(jSONObject2, jSONObject, this.mConfig.getDefaultTimeZone());
                        if (!this.isFromSubProcess) {
                            synchronized (this.mTrackTimer) {
                                c0722d = this.mTrackTimer.get(str);
                                this.mTrackTimer.remove(str);
                            }
                            if (c0722d != null) {
                                try {
                                    dValueOf = Double.valueOf(c0722d.m501b());
                                    if (dValueOf.doubleValue() > 0.0d && !TDPresetProperties.disableList.contains("#duration")) {
                                        jSONObject.put("#duration", dValueOf);
                                    }
                                    dValueOf2 = Double.valueOf(c0722d.m499a());
                                    if (dValueOf2.doubleValue() > 0.0d && !str.equals("ta_app_end") && !TDPresetProperties.disableList.contains("#background_duration")) {
                                        jSONObject.put("#background_duration", dValueOf2);
                                    }
                                } catch (JSONException e) {
                                    e.printStackTrace();
                                }
                            }
                        }
                        if (str.equals("device_performance")) {
                            if (!TDPresetProperties.disableList.contains("#network_type")) {
                                jSONObject.put("#network_type", this.mSystemInformation.m551d());
                            }
                            if (!TDPresetProperties.disableList.contains("#disk")) {
                                jSONObject.put("#disk", this.mSystemInformation.m546a(this.mConfig.mContext, false));
                            }
                        }
                        if (!TDPresetProperties.disableList.contains("#device_type")) {
                            jSONObject.put("#device_type", C0766q.m753c(this.mConfig.mContext));
                        }
                    } else {
                        if (!this.isFromSubProcess) {
                            synchronized (this.mTrackTimer) {
                                c0722d = this.mTrackTimer.get(str);
                                this.mTrackTimer.remove(str);
                                if (c0722d != null) {
                                    dValueOf = Double.valueOf(c0722d.m501b());
                                    if (dValueOf.doubleValue() > 0.0d) {
                                        jSONObject.put("#duration", dValueOf);
                                    }
                                    dValueOf2 = Double.valueOf(c0722d.m499a());
                                    if (dValueOf2.doubleValue() > 0.0d) {
                                        jSONObject.put("#background_duration", dValueOf2);
                                    }
                                }
                            }
                        }
                        if (str.equals("device_performance")) {
                            if (!TDPresetProperties.disableList.contains("#network_type")) {
                                jSONObject.put("#network_type", this.mSystemInformation.m551d());
                            }
                            if (!TDPresetProperties.disableList.contains("#disk")) {
                                jSONObject.put("#disk", this.mSystemInformation.m546a(this.mConfig.mContext, false));
                            }
                        }
                        if (!TDPresetProperties.disableList.contains("#device_type")) {
                            jSONObject.put("#device_type", C0766q.m753c(this.mConfig.mContext));
                        }
                    }
                } else {
                    if (!this.isFromSubProcess) {
                        synchronized (this.mTrackTimer) {
                            c0722d = this.mTrackTimer.get(str);
                            this.mTrackTimer.remove(str);
                            if (c0722d != null) {
                                dValueOf = Double.valueOf(c0722d.m501b());
                                if (dValueOf.doubleValue() > 0.0d) {
                                    jSONObject.put("#duration", dValueOf);
                                }
                                dValueOf2 = Double.valueOf(c0722d.m499a());
                                if (dValueOf2.doubleValue() > 0.0d) {
                                    jSONObject.put("#background_duration", dValueOf2);
                                }
                            }
                        }
                    }
                    if (str.equals("device_performance")) {
                        if (!TDPresetProperties.disableList.contains("#network_type")) {
                            jSONObject.put("#network_type", this.mSystemInformation.m551d());
                        }
                        if (!TDPresetProperties.disableList.contains("#disk")) {
                            jSONObject.put("#disk", this.mSystemInformation.m546a(this.mConfig.mContext, false));
                        }
                    }
                    if (!TDPresetProperties.disableList.contains("#device_type")) {
                        jSONObject.put("#device_type", C0766q.m753c(this.mConfig.mContext));
                    }
                }
            } catch (Exception e2) {
                e2.printStackTrace();
            }
        } catch (Exception unused) {
        }
        return jSONObject;
    }

    private static void setCalibratedTime(InterfaceC0753d interfaceC0753d) {
        ReentrantReadWriteLock reentrantReadWriteLock = sCalibratedTimeLock;
        reentrantReadWriteLock.writeLock().lock();
        sCalibratedTime = interfaceC0753d;
        reentrantReadWriteLock.writeLock().unlock();
    }

    public static void setCustomerLibInfo(String str, String str2) {
        C0733j.m534a(str, str2);
    }

    public static ThinkingAnalyticsSDK sharedInstance(Context context, String str) {
        return sharedInstance(context, str, null, false);
    }

    public static ThinkingAnalyticsSDK sharedInstance(Context context, String str, String str2) {
        return sharedInstance(context, str, str2, true);
    }

    public static ThinkingAnalyticsSDK sharedInstance(Context context, String str, String str2, boolean z) {
        String str3;
        if (context == null) {
            str3 = "App context is required to get SDK instance.";
        } else if (TextUtils.isEmpty(str)) {
            str3 = "APP ID is required to get SDK instance.";
        } else {
            try {
                TDConfig tDConfig = TDConfig.getInstance(context, str, str2);
                tDConfig.setTrackOldData(z);
                return sharedInstance(tDConfig);
            } catch (IllegalArgumentException unused) {
                str3 = "Cannot get valid TDConfig instance. Returning null";
            }
        }
        TDLog.m687w(TAG, str3);
        return null;
    }

    public static ThinkingAnalyticsSDK sharedInstance(TDConfig tDConfig) {
        ThinkingAnalyticsSDK thinkingAnalyticsSDK;
        if (tDConfig == null) {
            TDLog.m687w(TAG, "Cannot initial SDK instance with null config instance.");
            return null;
        }
        Map<Context, Map<String, ThinkingAnalyticsSDK>> map = sInstanceMap;
        synchronized (map) {
            Map<String, ThinkingAnalyticsSDK> map2 = map.get(tDConfig.mContext);
            if (map2 == null) {
                map2 = new HashMap<>();
                map.put(tDConfig.mContext, map2);
                if (C0721c.m485a(tDConfig.mContext) && C0733j.m532a(tDConfig.mContext, tDConfig.getDefaultTimeZone()).m552e()) {
                    sAppFirstInstallationMap.put(tDConfig.mContext, new LinkedList());
                }
            }
            thinkingAnalyticsSDK = map2.get(tDConfig.getName());
            if (thinkingAnalyticsSDK == null) {
                if (C0766q.m758f(tDConfig.mContext)) {
                    thinkingAnalyticsSDK = new ThinkingAnalyticsSDK(tDConfig, new boolean[0]);
                    Map<Context, List<String>> map3 = sAppFirstInstallationMap;
                    if (map3.containsKey(tDConfig.mContext)) {
                        map3.get(tDConfig.mContext).add(tDConfig.getName());
                    }
                } else {
                    thinkingAnalyticsSDK = new C0732i(tDConfig);
                }
                map2.put(tDConfig.getName(), thinkingAnalyticsSDK);
            }
        }
        return thinkingAnalyticsSDK;
    }

    private void track(String str, JSONObject jSONObject, InterfaceC0754e interfaceC0754e) {
        track(str, jSONObject, interfaceC0754e, true);
    }

    private void track(String str, JSONObject jSONObject, InterfaceC0754e interfaceC0754e, boolean z) {
        track(str, jSONObject, interfaceC0754e, z, null, null);
    }

    private void track(String str, JSONObject jSONObject, InterfaceC0754e interfaceC0754e, boolean z, Map<String, String> map, EnumC0761l enumC0761l) {
        AutoTrackEventType autoTrackEventTypeAutoTrackEventTypeFromEventName;
        int i;
        if (this.mConfig.isDisabledEvent(str)) {
            TDLog.m679d(TAG, "Ignoring disabled event [" + str + "]");
            return;
        }
        if (z) {
            try {
                if (C0756g.m704a(str)) {
                    TDLog.m687w(TAG, "Event name[" + str + "] is invalid. Event name must be string that starts with English letter, and contains letter, number, and '_'. The max length of the event name is 50.");
                    if (this.mConfig.shouldThrowException()) {
                        throw new C0736m("Invalid event name: " + str);
                    }
                }
            } catch (JSONException e) {
                e.printStackTrace();
                return;
            }
        }
        if (z && !C0756g.m705a(jSONObject)) {
            TDLog.m687w(TAG, "The data contains invalid key or value: " + jSONObject.toString());
            if (this.mConfig.shouldThrowException()) {
                throw new C0736m("Invalid properties. Please refer to SDK debug log for detail reasons.");
            }
        }
        JSONObject jSONObjectObtainDefaultEventProperties = obtainDefaultEventProperties(str);
        if (jSONObject != null) {
            C0766q.m747a(jSONObject, jSONObjectObtainDefaultEventProperties, this.mConfig.getDefaultTimeZone());
        }
        if (!this.isFromSubProcess && (autoTrackEventTypeAutoTrackEventTypeFromEventName = AutoTrackEventType.autoTrackEventTypeFromEventName(str)) != null) {
            AutoTrackEventListener autoTrackEventListener = this.mAutoTrackEventListener;
            if (autoTrackEventListener != null) {
                JSONObject jSONObjectEventCallback = autoTrackEventListener.eventCallback(autoTrackEventTypeAutoTrackEventTypeFromEventName, jSONObjectObtainDefaultEventProperties);
                if (jSONObjectEventCallback != null) {
                    C0766q.m747a(jSONObjectEventCallback, jSONObjectObtainDefaultEventProperties, this.mConfig.getDefaultTimeZone());
                }
            } else {
                TDLog.m682i(TAG, "No mAutoTrackEventListener");
            }
            if (this.mAutoTrackEventTrackerListener != null) {
                if (autoTrackEventTypeAutoTrackEventTypeFromEventName == AutoTrackEventType.APP_START) {
                    i = 1;
                } else if (autoTrackEventTypeAutoTrackEventTypeFromEventName == AutoTrackEventType.APP_INSTALL) {
                    i = 32;
                } else if (autoTrackEventTypeAutoTrackEventTypeFromEventName == AutoTrackEventType.APP_END) {
                    i = 2;
                } else {
                    i = autoTrackEventTypeAutoTrackEventTypeFromEventName == AutoTrackEventType.APP_CRASH ? 16 : 0;
                }
                C0766q.m747a(new JSONObject(this.mAutoTrackEventTrackerListener.eventCallback(i, jSONObjectObtainDefaultEventProperties.toString())), jSONObjectObtainDefaultEventProperties, this.mConfig.getDefaultTimeZone());
            } else {
                TDLog.m682i(TAG, "No mAutoTrackEventTrackerListener");
            }
        }
        if (enumC0761l == null) {
            enumC0761l = EnumC0761l.TRACK;
        }
        C0718a c0718a = new C0718a(this, enumC0761l, jSONObjectObtainDefaultEventProperties, interfaceC0754e);
        c0718a.f144a = str;
        if (map != null) {
            c0718a.m439a(map);
        }
        setFromSubProcess(false);
        trackInternal(c0718a);
    }

    void appBecomeActive() {
        C0722d value;
        synchronized (this.mTrackTimer) {
            try {
                for (Map.Entry<String, C0722d> entry : this.mTrackTimer.entrySet()) {
                    if (entry != null && (value = entry.getValue()) != null) {
                        long jM503c = (value.m503c() + SystemClock.elapsedRealtime()) - value.m507e();
                        value.m506d(SystemClock.elapsedRealtime());
                        value.m502b(jM503c);
                    }
                }
            } catch (Exception e) {
                TDLog.m682i(TAG, "appBecomeActive error:" + e.getMessage());
            } finally {
                flush();
            }
        }
    }

    void appEnterBackground() {
        C0722d value;
        synchronized (this.mTrackTimer) {
            try {
                for (Map.Entry<String, C0722d> entry : this.mTrackTimer.entrySet()) {
                    if (entry != null && !"ta_app_end".equals(entry.getKey().toString()) && (value = entry.getValue()) != null) {
                        value.m504c((value.m505d() + SystemClock.elapsedRealtime()) - value.m507e());
                        value.m506d(SystemClock.elapsedRealtime());
                    }
                }
            } catch (Exception e) {
                TDLog.m682i(TAG, "appEnterBackground error:" + e.getMessage());
            }
        }
    }

    void autoTrack(String str, JSONObject jSONObject) {
        if (hasDisabled()) {
            return;
        }
        track(str, jSONObject, getTime(), false);
    }

    public void clearSuperProperties() {
        if (hasDisabled()) {
            return;
        }
        synchronized (this.mSuperProperties) {
            this.mSuperProperties.m677a(new JSONObject());
        }
    }

    public ThinkingAnalyticsSDK m2253createLightInstance() {
        return new C0729f(this.mConfig);
    }

    public void enableAutoTrack(int i) {
        ArrayList arrayList = new ArrayList();
        if ((i & 1) > 0) {
            arrayList.add(AutoTrackEventType.APP_START);
        }
        if ((i & 2) > 0) {
            arrayList.add(AutoTrackEventType.APP_END);
        }
        if ((i & 32) > 0) {
            arrayList.add(AutoTrackEventType.APP_INSTALL);
        }
        if ((i & 16) > 0) {
            arrayList.add(AutoTrackEventType.APP_CRASH);
        }
        if (arrayList.size() > 0) {
            enableAutoTrack(arrayList);
        }
    }

    public void enableAutoTrack(int i, AutoTrackEventTrackerListener autoTrackEventTrackerListener) {
        this.mAutoTrackEventTrackerListener = autoTrackEventTrackerListener;
        enableAutoTrack(i);
    }

    public void enableAutoTrack(int i, JSONObject jSONObject) {
        ArrayList arrayList = new ArrayList();
        if ((i & 1) > 0) {
            arrayList.add(AutoTrackEventType.APP_START);
        }
        if ((i & 2) > 0) {
            arrayList.add(AutoTrackEventType.APP_END);
        }
        if ((i & 32) > 0) {
            arrayList.add(AutoTrackEventType.APP_INSTALL);
        }
        if ((i & 16) > 0) {
            arrayList.add(AutoTrackEventType.APP_CRASH);
        }
        if (arrayList.size() > 0) {
            setAutoTrackProperties(arrayList, jSONObject);
            enableAutoTrack(arrayList);
        }
    }

    public void enableAutoTrack(List<AutoTrackEventType> list) {
        if (hasDisabled()) {
            return;
        }
        this.mAutoTrack = true;
        if (list == null || list.size() == 0) {
            return;
        }
        if (list.contains(AutoTrackEventType.APP_INSTALL)) {
            synchronized (sInstanceMap) {
                Map<Context, List<String>> map = sAppFirstInstallationMap;
                if (map.containsKey(this.mConfig.mContext) && map.get(this.mConfig.mContext).contains(getToken())) {
                    track("ta_app_install");
                    flush();
                    map.get(this.mConfig.mContext).remove(getToken());
                }
            }
        }
        if (list.contains(AutoTrackEventType.APP_CRASH)) {
            this.mTrackCrash = true;
            C0734k c0734kM652b = C0734k.m652b(this.mConfig.mContext);
            if (c0734kM652b != null) {
                c0734kM652b.m653a();
            }
        }
        if (!this.mAutoTrackEventTypeList.contains(AutoTrackEventType.APP_END) && list.contains(AutoTrackEventType.APP_END)) {
            timeEvent("ta_app_end");
        }
        synchronized (this) {
            this.mAutoTrackStartTime = getTime();
            this.mAutoTrackStartProperties = obtainDefaultEventProperties("ta_app_start");
        }
        this.mAutoTrackEventTypeList.clear();
        this.mAutoTrackEventTypeList.addAll(list);
        if (this.mAutoTrackEventTypeList.contains(AutoTrackEventType.APP_START)) {
            this.mLifecycleCallbacks.m672b();
        }
    }

    public void enableAutoTrack(List<AutoTrackEventType> list, AutoTrackEventListener autoTrackEventListener) {
        this.mAutoTrackEventListener = autoTrackEventListener;
        enableAutoTrack(list);
    }

    public void enableAutoTrack(List<AutoTrackEventType> list, JSONObject jSONObject) {
        setAutoTrackProperties(list, jSONObject);
        enableAutoTrack(list);
    }

    public void enableThirdPartySharing(int i) {
        try {
            C0758i.m710a("cn.thinkingdata.thirdparty.TAThirdPartyManager", "enableThirdPartySharing", new Object[]{Integer.valueOf(i), this, getLoginId()}, (Class<?>[]) new Class[]{Integer.TYPE, ThinkingAnalyticsSDK.class, String.class});
        } catch (Exception unused) {
            TDLog.m680e(TAG, "请引入三方数据同步插件");
        }
    }

    public synchronized void enableThirdPartySharing(int i, Map<String, Object> map) {
        try {
            C0758i.m710a("cn.thinkingdata.thirdparty.TAThirdPartyManager", "enableThirdPartySharing", new Object[]{Integer.valueOf(i), this, getLoginId(), map}, (Class<?>[]) new Class[]{Integer.TYPE, ThinkingAnalyticsSDK.class, String.class, Map.class});
        } catch (Exception unused) {
            TDLog.m680e(TAG, "请引入三方数据同步插件");
        }
    }

    public synchronized void enableThirdPartySharing(int i, JSONObject jSONObject) {
        if (jSONObject == null) {
            return;
        }
        try {
            enableThirdPartySharing(i, C0766q.m740a(jSONObject));
        } catch (Exception unused) {
            TDLog.m680e(TAG, "请引入三方数据同步插件");
        }
    }

    @Deprecated
    public void enableTracking(boolean z) {
        TDLog.m679d(TAG, "enableTracking: " + z);
        if (isEnabled() && !z) {
            flush();
        }
        this.mEnableFlag.m677a(Boolean.valueOf(z));
    }

    public void flush() {
        if (hasDisabled()) {
            return;
        }
        this.mMessages.m453b(getToken());
    }

    public List<AutoTrackEventType> getAutoTrackEventTypeList() {
        return this.mAutoTrackEventTypeList;
    }

    public JSONObject getAutoTrackProperties() {
        return this.mAutoTrackEventProperties;
    }

    synchronized JSONObject getAutoTrackStartProperties() {
        JSONObject jSONObject;
        jSONObject = this.mAutoTrackStartProperties;
        if (jSONObject == null) {
            jSONObject = new JSONObject();
        }
        return jSONObject;
    }

    synchronized InterfaceC0754e getAutoTrackStartTime() {
        return this.mAutoTrackStartTime;
    }

    protected C0720b getDataHandleInstance(Context context) {
        return C0720b.m442b(context);
    }

    public String getDeviceId() {
        if (this.mSystemInformation.m550c().containsKey("#device_id")) {
            return (String) this.mSystemInformation.m550c().get("#device_id");
        }
        return null;
    }

    public String getDistinctId() {
        String identifyID = getIdentifyID();
        return identifyID == null ? getRandomID() : identifyID;
    }

    DynamicSuperPropertiesTracker getDynamicSuperPropertiesTracker() {
        return this.mDynamicSuperPropertiesTracker;
    }

    DynamicSuperPropertiesTrackerListener getDynamicSuperPropertiesTrackerListener() {
        return this.dynamicSuperPropertiesTrackerListener;
    }

    List<Class> getIgnoredViewTypeList() {
        if (this.mIgnoredViewTypeList == null) {
            this.mIgnoredViewTypeList = new ArrayList();
        }
        return this.mIgnoredViewTypeList;
    }

    String getLoginId() {
        String strB;
        String strB2;
        synchronized (this.mLoginId) {
            strB = this.mLoginId.m678b();
            if (TextUtils.isEmpty(strB) && this.mEnableTrackOldData) {
                synchronized (sOldLoginIdLock) {
                    strB2 = sOldLoginId.m678b();
                    if (!TextUtils.isEmpty(strB2)) {
                        this.mLoginId.m677a(strB2);
                        sOldLoginId.m677a((Object) null);
                    }
                }
                strB = strB2;
            }
        }
        return strB;
    }

    public TDPresetProperties getPresetProperties() {
        JSONObject jSONObjectM547a = C0733j.m540e(this.mConfig.mContext).m547a();
        String strM551d = C0733j.m540e(this.mConfig.mContext).m551d();
        double dDoubleValue = getTime().mo698a().doubleValue();
        try {
            if (!TDPresetProperties.disableList.contains("#network_type")) {
                jSONObjectM547a.put("#network_type", strM551d);
            }
            if (!TDPresetProperties.disableList.contains("#zone_offset")) {
                jSONObjectM547a.put("#zone_offset", dDoubleValue);
            }
            if (!TDPresetProperties.disableList.contains("#ram")) {
                jSONObjectM547a.put("#ram", this.mSystemInformation.m549b(this.mConfig.mContext));
            }
            if (!TDPresetProperties.disableList.contains("#disk")) {
                jSONObjectM547a.put("#disk", this.mSystemInformation.m546a(this.mConfig.mContext, false));
            }
            if (!TDPresetProperties.disableList.contains("#fps")) {
                jSONObjectM547a.put("#fps", C0766q.m726a());
            }
            if (!TDPresetProperties.disableList.contains("#device_type")) {
                jSONObjectM547a.put("#device_type", C0766q.m753c(this.mConfig.mContext));
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return new TDPresetProperties(jSONObjectM547a);
    }

    String getRandomID() {
        String strB;
        synchronized (sRandomIDLock) {
            strB = sRandomID.m678b();
        }
        return strB;
    }

    public JSONObject getSuperProperties() {
        JSONObject jSONObjectB;
        synchronized (this.mSuperProperties) {
            jSONObjectB = this.mSuperProperties.m678b();
        }
        return jSONObjectB;
    }

    public String getTimeString(Date date) {
        return getTime(date, this.mConfig.getDefaultTimeZone()).mo699b();
    }

    public String getToken() {
        return this.mConfig.getName();
    }

    boolean hasDisabled() {
        return !isEnabled() || hasOptOut();
    }

    public boolean hasOptOut() {
        return this.mOptOutFlag.m678b().booleanValue();
    }

    public void identify(String str) {
        if (hasDisabled()) {
            return;
        }
        if (TextUtils.isEmpty(str)) {
            TDLog.m687w(TAG, "The identity cannot be empty.");
            if (this.mConfig.shouldThrowException()) {
                throw new C0736m("distinct id cannot be empty");
            }
        } else {
            synchronized (this.mIdentifyId) {
                this.mIdentifyId.m677a(str);
            }
        }
    }

    public void ignoreAutoTrackActivities(List<Class<?>> list) {
        if (hasDisabled() || list == null || list.size() == 0) {
            return;
        }
        if (this.mAutoTrackIgnoredActivities == null) {
            this.mAutoTrackIgnoredActivities = new ArrayList();
        }
        for (Class<?> cls : list) {
            if (cls != null && !this.mAutoTrackIgnoredActivities.contains(Integer.valueOf(cls.hashCode()))) {
                this.mAutoTrackIgnoredActivities.add(Integer.valueOf(cls.hashCode()));
            }
        }
    }

    public void ignoreAutoTrackActivity(Class<?> cls) {
        if (hasDisabled() || cls == null) {
            return;
        }
        if (this.mAutoTrackIgnoredActivities == null) {
            this.mAutoTrackIgnoredActivities = new ArrayList();
        }
        if (this.mAutoTrackIgnoredActivities.contains(Integer.valueOf(cls.hashCode()))) {
            return;
        }
        this.mAutoTrackIgnoredActivities.add(Integer.valueOf(cls.hashCode()));
    }

    public void ignoreView(View view) {
        if (hasDisabled() || view == null) {
            return;
        }
        C0766q.m745a(getToken(), view, C0702R.id.thinking_analytics_tag_view_ignored, "1");
    }

    public void ignoreViewType(Class cls) {
        if (hasDisabled() || cls == null) {
            return;
        }
        if (this.mIgnoredViewTypeList == null) {
            this.mIgnoredViewTypeList = new ArrayList();
        }
        if (this.mIgnoredViewTypeList.contains(cls)) {
            return;
        }
        this.mIgnoredViewTypeList.add(cls);
    }

    boolean isActivityAutoTrackAppClickIgnored(Class<?> cls) {
        if (cls == null) {
            return false;
        }
        List<Integer> list = this.mAutoTrackIgnoredActivities;
        if (list != null && list.contains(Integer.valueOf(cls.hashCode()))) {
            return true;
        }
        ThinkingDataIgnoreTrackAppViewScreenAndAppClick thinkingDataIgnoreTrackAppViewScreenAndAppClick = (ThinkingDataIgnoreTrackAppViewScreenAndAppClick) cls.getAnnotation(ThinkingDataIgnoreTrackAppViewScreenAndAppClick.class);
        if (thinkingDataIgnoreTrackAppViewScreenAndAppClick != null && (TextUtils.isEmpty(thinkingDataIgnoreTrackAppViewScreenAndAppClick.appId()) || getToken().equals(thinkingDataIgnoreTrackAppViewScreenAndAppClick.appId()))) {
            return true;
        }
        ThinkingDataIgnoreTrackAppClick thinkingDataIgnoreTrackAppClick = (ThinkingDataIgnoreTrackAppClick) cls.getAnnotation(ThinkingDataIgnoreTrackAppClick.class);
        if (thinkingDataIgnoreTrackAppClick != null) {
            return TextUtils.isEmpty(thinkingDataIgnoreTrackAppClick.appId()) || getToken().equals(thinkingDataIgnoreTrackAppClick.appId());
        }
        return false;
    }

    boolean isActivityAutoTrackAppViewScreenIgnored(Class<?> cls) {
        if (cls == null) {
            return false;
        }
        List<Integer> list = this.mAutoTrackIgnoredActivities;
        if (list != null && list.contains(Integer.valueOf(cls.hashCode()))) {
            return true;
        }
        ThinkingDataIgnoreTrackAppViewScreenAndAppClick thinkingDataIgnoreTrackAppViewScreenAndAppClick = (ThinkingDataIgnoreTrackAppViewScreenAndAppClick) cls.getAnnotation(ThinkingDataIgnoreTrackAppViewScreenAndAppClick.class);
        if (thinkingDataIgnoreTrackAppViewScreenAndAppClick != null && (TextUtils.isEmpty(thinkingDataIgnoreTrackAppViewScreenAndAppClick.appId()) || getToken().equals(thinkingDataIgnoreTrackAppViewScreenAndAppClick.appId()))) {
            return true;
        }
        ThinkingDataIgnoreTrackAppViewScreen thinkingDataIgnoreTrackAppViewScreen = (ThinkingDataIgnoreTrackAppViewScreen) cls.getAnnotation(ThinkingDataIgnoreTrackAppViewScreen.class);
        return thinkingDataIgnoreTrackAppViewScreen != null && (TextUtils.isEmpty(thinkingDataIgnoreTrackAppViewScreen.appId()) || getToken().equals(thinkingDataIgnoreTrackAppViewScreen.appId()));
    }

    boolean isAutoTrackEnabled() {
        if (hasDisabled()) {
            return false;
        }
        return this.mAutoTrack;
    }

    boolean isAutoTrackEventTypeIgnored(AutoTrackEventType autoTrackEventType) {
        return (autoTrackEventType == null || this.mAutoTrackEventTypeList.contains(autoTrackEventType)) ? false : true;
    }

    public boolean isEnabled() {
        return this.mEnableFlag.m678b().booleanValue();
    }

    boolean isTrackFragmentAppViewScreenEnabled() {
        return this.mTrackFragmentAppViewScreen;
    }

    public void login(String str) {
        if (hasDisabled()) {
            return;
        }
        try {
            if (TextUtils.isEmpty(str)) {
                TDLog.m679d(TAG, "The account id cannot be empty.");
                if (this.mConfig.shouldThrowException()) {
                    throw new C0736m("account id cannot be empty");
                }
            } else {
                synchronized (this.mLoginId) {
                    if (!str.equals(this.mLoginId.m678b())) {
                        this.mLoginId.m677a(str);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void logout() {
        if (hasDisabled()) {
            return;
        }
        try {
            synchronized (this.mLoginId) {
                this.mLoginId.m677a((Object) null);
                if (this.mEnableTrackOldData) {
                    synchronized (sOldLoginIdLock) {
                        if (!TextUtils.isEmpty(sOldLoginId.m678b())) {
                            sOldLoginId.m677a((Object) null);
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Deprecated
    public void optInTracking() {
        TDLog.m679d(TAG, "optInTracking...");
        this.mOptOutFlag.m677a(false);
        this.mMessages.m453b(getToken());
    }

    @Deprecated
    public void optOutTracking() {
        TDLog.m679d(TAG, "optOutTracking...");
        this.mOptOutFlag.m677a(true);
        this.mMessages.m450a(getToken());
        synchronized (this.mTrackTimer) {
            this.mTrackTimer.clear();
        }
        this.mIdentifyId.m677a((Object) null);
        this.mLoginId.m677a((Object) null);
        synchronized (this.mSuperProperties) {
            this.mSuperProperties.m677a(new JSONObject());
        }
    }

    @Deprecated
    public void optOutTrackingAndDeleteUser() {
        C0718a c0718a = new C0718a(this, EnumC0761l.USER_DEL, null, getTime());
        c0718a.m440b();
        trackInternal(c0718a);
        optOutTracking();
    }

    public void setAutoTrackProperties(int i, JSONObject jSONObject) {
        ArrayList arrayList = new ArrayList();
        if ((i & 1) > 0) {
            arrayList.add(AutoTrackEventType.APP_START);
        }
        if ((i & 2) > 0) {
            arrayList.add(AutoTrackEventType.APP_END);
        }
        if ((i & 32) > 0) {
            arrayList.add(AutoTrackEventType.APP_INSTALL);
        }
        if ((i & 16) > 0) {
            arrayList.add(AutoTrackEventType.APP_CRASH);
        }
        if (arrayList.size() > 0) {
            setAutoTrackProperties(arrayList, jSONObject);
        }
    }

    public void setAutoTrackProperties(List<AutoTrackEventType> list, JSONObject jSONObject) {
        if (hasDisabled()) {
            return;
        }
        if (jSONObject != null) {
            try {
                if (C0756g.m705a(jSONObject)) {
                    JSONObject jSONObject2 = new JSONObject();
                    for (AutoTrackEventType autoTrackEventType : list) {
                        JSONObject jSONObject3 = new JSONObject();
                        C0766q.m747a(jSONObject, jSONObject3, this.mConfig.getDefaultTimeZone());
                        jSONObject2.put(autoTrackEventType.getEventName(), jSONObject3);
                    }
                    synchronized (this.mAutoTrackEventProperties) {
                        C0766q.m752b(jSONObject2, this.mAutoTrackEventProperties, this.mConfig.getDefaultTimeZone());
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

    public void setDynamicSuperPropertiesTracker(DynamicSuperPropertiesTracker dynamicSuperPropertiesTracker) {
        if (hasDisabled()) {
            return;
        }
        this.mDynamicSuperPropertiesTracker = dynamicSuperPropertiesTracker;
    }

    public void setDynamicSuperPropertiesTrackerListener(DynamicSuperPropertiesTrackerListener dynamicSuperPropertiesTrackerListener) {
        if (hasDisabled()) {
            return;
        }
        this.dynamicSuperPropertiesTrackerListener = dynamicSuperPropertiesTrackerListener;
    }

    public void setFromSubProcess(boolean z) {
        this.isFromSubProcess = z;
    }

    public void setJsBridge(WebView webView) {
        if (webView != null) {
            webView.getSettings().setJavaScriptEnabled(true);
            webView.addJavascriptInterface(new TDWebAppInterface(this), "ThinkingData_APP_JS_Bridge");
        } else {
            TDLog.m679d(TAG, "SetJsBridge failed due to parameter webView is null");
            if (this.mConfig.shouldThrowException()) {
                throw new C0736m("webView cannot be null for setJsBridge");
            }
        }
    }

    public void setJsBridgeForX5WebView(Object obj) {
        if (obj == null) {
            TDLog.m679d(TAG, "SetJsBridge failed due to parameter webView is null");
            return;
        }
        try {
            obj.getClass().getMethod("addJavascriptInterface", Object.class, String.class).invoke(obj, new TDWebAppInterface(this), "ThinkingData_APP_JS_Bridge");
        } catch (Exception e) {
            TDLog.m687w(TAG, "setJsBridgeForX5WebView failed: " + e.toString());
        }
    }

    public void setNetworkType(int i) {
        ThinkingdataNetworkType thinkingdataNetworkType;
        if (i == 0) {
            thinkingdataNetworkType = ThinkingdataNetworkType.NETWORKTYPE_DEFAULT;
        } else if (i == 1) {
            thinkingdataNetworkType = ThinkingdataNetworkType.NETWORKTYPE_WIFI;
        } else if (i != 2) {
            return;
        } else {
            thinkingdataNetworkType = ThinkingdataNetworkType.NETWORKTYPE_ALL;
        }
        setNetworkType(thinkingdataNetworkType);
    }

    public void setNetworkType(ThinkingdataNetworkType thinkingdataNetworkType) {
        if (hasDisabled()) {
            return;
        }
        this.mConfig.setNetworkType(thinkingdataNetworkType);
    }

    public void setSuperProperties(JSONObject jSONObject) {
        if (hasDisabled()) {
            return;
        }
        if (jSONObject != null) {
            try {
                if (C0756g.m705a(jSONObject)) {
                    synchronized (this.mSuperProperties) {
                        JSONObject jSONObjectB = this.mSuperProperties.m678b();
                        C0766q.m747a(jSONObject, jSONObjectB, this.mConfig.getDefaultTimeZone());
                        this.mSuperProperties.m677a(jSONObjectB);
                    }
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
                return;
            }
        }
        if (this.mConfig.shouldThrowException()) {
            throw new C0736m("Set super properties failed. Please refer to the SDK debug log for details.");
        }
    }

    public void setTrackStatus(TATrackStatus tATrackStatus) {
        int i = C0707a.f121a[tATrackStatus.ordinal()];
        if (i == 1) {
            this.mOptOutFlag.m677a(false);
            this.mPausePostFlag.m677a(false);
            this.mMessages.m451a(getToken(), false);
            enableTracking(false);
            return;
        }
        if (i == 2) {
            this.mEnableFlag.m677a(true);
            this.mPausePostFlag.m677a(false);
            this.mMessages.m451a(getToken(), false);
            optOutTracking();
            return;
        }
        if (i == 3) {
            this.mEnableFlag.m677a(true);
            this.mOptOutFlag.m677a(false);
            this.mPausePostFlag.m677a(true);
            this.mMessages.m451a(getToken(), true);
            return;
        }
        if (i != 4) {
            return;
        }
        this.mEnableFlag.m677a(true);
        this.mOptOutFlag.m677a(false);
        this.mPausePostFlag.m677a(false);
        this.mMessages.m451a(getToken(), false);
        flush();
    }

    public void setViewID(Dialog dialog, String str) {
        if (hasDisabled() || dialog == null) {
            return;
        }
        try {
            if (TextUtils.isEmpty(str) || dialog.getWindow() == null) {
                return;
            }
            C0766q.m745a(getToken(), dialog.getWindow().getDecorView(), C0702R.id.thinking_analytics_tag_view_id, str);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void setViewID(View view, String str) {
        if (hasDisabled() || view == null || TextUtils.isEmpty(str)) {
            return;
        }
        C0766q.m745a(getToken(), view, C0702R.id.thinking_analytics_tag_view_id, str);
    }

    public void setViewProperties(View view, JSONObject jSONObject) {
        if (hasDisabled() || view == null || jSONObject == null) {
            return;
        }
        C0766q.m745a(getToken(), view, C0702R.id.thinking_analytics_tag_view_properties, jSONObject);
    }

    boolean shouldTrackCrash() {
        if (hasDisabled()) {
            return false;
        }
        return this.mTrackCrash;
    }

    public void timeEvent(String str) {
        if (hasDisabled()) {
            return;
        }
        try {
            if (C0756g.m704a(str)) {
                TDLog.m687w(TAG, "timeEvent event name[" + str + "] is not valid");
            }
            synchronized (this.mTrackTimer) {
                this.mTrackTimer.put(str, new C0722d(TimeUnit.SECONDS));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void track(AbstractC0737n abstractC0737n) {
        if (hasDisabled()) {
            return;
        }
        if (abstractC0737n == null) {
            TDLog.m687w(TAG, "Ignoring empty event...");
            return;
        }
        InterfaceC0754e time = abstractC0737n.getEventTime() != null ? getTime(abstractC0737n.getEventTime(), abstractC0737n.getTimeZone()) : getTime();
        HashMap map = new HashMap();
        if (TextUtils.isEmpty(abstractC0737n.getExtraField())) {
            TDLog.m687w(TAG, "Invalid ExtraFields. Ignoring...");
        } else {
            map.put(abstractC0737n.getExtraField(), ((abstractC0737n instanceof TDFirstEvent) && abstractC0737n.getExtraValue() == null) ? getDeviceId() : abstractC0737n.getExtraValue());
        }
        track(abstractC0737n.getEventName(), abstractC0737n.getProperties(), time, true, map, abstractC0737n.getDataType());
    }

    public void track(String str) {
        if (hasDisabled()) {
            return;
        }
        track(str, (JSONObject) null, getTime());
    }

    public void track(String str, JSONObject jSONObject) {
        if (hasDisabled()) {
            return;
        }
        track(str, jSONObject, getTime());
    }

    public void track(String str, JSONObject jSONObject, Date date) {
        if (hasDisabled()) {
            return;
        }
        track(str, jSONObject, getTime(date, (TimeZone) null));
    }

    public void track(String str, JSONObject jSONObject, Date date, TimeZone timeZone) {
        if (hasDisabled()) {
            return;
        }
        track(str, jSONObject, getTime(date, timeZone));
    }

    void trackAppCrashAndEndEvent(JSONObject jSONObject) {
        this.mLifecycleCallbacks.m670a(jSONObject);
    }

    public void trackAppInstall() {
        if (hasDisabled()) {
            return;
        }
        enableAutoTrack(new ArrayList(Collections.singletonList(AutoTrackEventType.APP_INSTALL)));
    }

    public void trackFragmentAppViewScreen() {
        if (hasDisabled()) {
            return;
        }
        this.mTrackFragmentAppViewScreen = true;
    }

    void trackFromH5(String str) {
        if (hasDisabled() || TextUtils.isEmpty(str)) {
            return;
        }
        try {
            JSONArray jSONArray = new JSONObject(str).getJSONArray("data");
            for (int i = 0; i < jSONArray.length(); i++) {
                JSONObject jSONObject = jSONArray.getJSONObject(i);
                InterfaceC0754e time = getTime(jSONObject.getString("#time"), (!jSONObject.has("#zone_offset") || TDPresetProperties.disableList.contains("#zone_offset")) ? null : Double.valueOf(jSONObject.getDouble("#zone_offset")));
                EnumC0761l enumC0761lM714a = EnumC0761l.m714a(jSONObject.getString("#type"));
                if (enumC0761lM714a == null) {
                    TDLog.m687w(TAG, "Unknown data type from H5. ignoring...");
                    return;
                }
                JSONObject jSONObject2 = jSONObject.getJSONObject("properties");
                Iterator<String> itKeys = jSONObject2.keys();
                while (itKeys.hasNext()) {
                    String next = itKeys.next();
                    if (next.equals("#account_id") || next.equals("#distinct_id") || this.mSystemInformation.m550c().containsKey(next)) {
                        itKeys.remove();
                    }
                }
                if (enumC0761lM714a.m716b()) {
                    String string = jSONObject.getString("#event_name");
                    HashMap map = new HashMap();
                    if (jSONObject.has("#first_check_id")) {
                        map.put("#first_check_id", jSONObject.getString("#first_check_id"));
                    }
                    if (jSONObject.has("#event_id")) {
                        map.put("#event_id", jSONObject.getString("#event_id"));
                    }
                    track(string, jSONObject2, time, false, map, enumC0761lM714a);
                } else {
                    trackInternal(new C0718a(this, enumC0761lM714a, jSONObject2, time));
                }
            }
        } catch (Exception e) {
            TDLog.m687w(TAG, "Exception occurred when track data from H5.");
            e.printStackTrace();
        }
    }

    void trackInternal(C0718a c0718a) {
        if (this.mConfig.isDebugOnly() || this.mConfig.isDebug()) {
            this.mMessages.m452b(c0718a);
        } else if (c0718a.f151h) {
            this.mMessages.m454c(c0718a);
        } else {
            this.mMessages.m449a(c0718a);
        }
    }

    public void trackViewScreen(Activity activity) {
        if (hasDisabled() || activity == 0) {
            return;
        }
        try {
            JSONObject jSONObject = new JSONObject();
            if (!TDPresetProperties.disableList.contains("#screen_name")) {
                jSONObject.put("#screen_name", activity.getClass().getCanonicalName());
            }
            C0766q.m746a(jSONObject, activity);
            if (!(activity instanceof ScreenAutoTracker)) {
                autoTrack("ta_app_view", jSONObject);
                return;
            }
            ScreenAutoTracker screenAutoTracker = (ScreenAutoTracker) activity;
            String screenUrl = screenAutoTracker.getScreenUrl();
            JSONObject trackProperties = screenAutoTracker.getTrackProperties();
            if (trackProperties != null) {
                C0766q.m747a(trackProperties, jSONObject, this.mConfig.getDefaultTimeZone());
            }
            trackViewScreenInternal(screenUrl, jSONObject);
        } catch (Exception e) {
            TDLog.m682i(TAG, "trackViewScreen:" + e);
        }
    }

    public void trackViewScreen(Fragment fragment) {
        if (hasDisabled() || fragment == null) {
            return;
        }
        try {
            JSONObject jSONObject = new JSONObject();
            Object canonicalName = fragment.getClass().getCanonicalName();
            String strM735a = C0766q.m735a(fragment, getToken());
            Activity activity = fragment.getActivity();
            if (activity != null) {
                if (TextUtils.isEmpty(strM735a)) {
                    strM735a = C0766q.m732a(activity);
                }
                canonicalName = String.format(Locale.CHINA, "%s|%s", activity.getClass().getCanonicalName(), canonicalName);
            }
            if (!TextUtils.isEmpty(strM735a) && !TDPresetProperties.disableList.contains("#title")) {
                jSONObject.put("#title", strM735a);
            }
            if (!TDPresetProperties.disableList.contains("#screen_name")) {
                jSONObject.put("#screen_name", canonicalName);
            }
            autoTrack("ta_app_view", jSONObject);
        } catch (Exception e) {
            TDLog.m682i(TAG, "trackViewScreen:" + e);
        }
    }

    public void trackViewScreen(Object obj) {
        Class<?> cls;
        Class<?> cls2;
        Class<?> cls3;
        if (hasDisabled() || obj == null) {
            return;
        }
        Activity activity = null;
        try {
            cls = Class.forName("androidx.fragment.app.Fragment");
        } catch (Exception unused) {
            cls = null;
        }
        try {
            cls2 = Class.forName("android.app.Fragment");
        } catch (Exception unused2) {
            cls2 = null;
        }
        try {
            cls3 = Class.forName("androidx.fragment.app.Fragment");
        } catch (Exception unused3) {
            cls3 = null;
        }
        if ((cls == null || !cls.isInstance(obj)) && ((cls2 == null || !cls2.isInstance(obj)) && (cls3 == null || !cls3.isInstance(obj)))) {
            return;
        }
        try {
            JSONObject jSONObject = new JSONObject();
            Object canonicalName = obj.getClass().getCanonicalName();
            String strM735a = C0766q.m735a(obj, getToken());
            try {
                activity = (Activity) obj.getClass().getMethod("getActivity", null).invoke(obj, null);
            } catch (Exception unused4) {
            }
            if (activity != null) {
                if (TextUtils.isEmpty(strM735a)) {
                    strM735a = C0766q.m732a(activity);
                }
                canonicalName = String.format(Locale.CHINA, "%s|%s", activity.getClass().getCanonicalName(), canonicalName);
            }
            if (!TextUtils.isEmpty(strM735a) && !TDPresetProperties.disableList.contains("#title")) {
                jSONObject.put("#title", strM735a);
            }
            if (!TDPresetProperties.disableList.contains("#screen_name")) {
                jSONObject.put("#screen_name", canonicalName);
            }
            autoTrack("ta_app_view", jSONObject);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    void trackViewScreenInternal(String str, JSONObject jSONObject) {
        if (hasDisabled()) {
            return;
        }
        try {
            if (TextUtils.isEmpty(str) && jSONObject == null) {
                return;
            }
            JSONObject jSONObject2 = new JSONObject();
            if (!TextUtils.isEmpty(this.mLastScreenUrl) && !TDPresetProperties.disableList.contains("#referrer")) {
                jSONObject2.put("#referrer", this.mLastScreenUrl);
            }
            if (!TDPresetProperties.disableList.contains("#url")) {
                jSONObject2.put("#url", str);
            }
            this.mLastScreenUrl = str;
            if (jSONObject != null) {
                C0766q.m747a(jSONObject, jSONObject2, this.mConfig.getDefaultTimeZone());
            }
            autoTrack("ta_app_view", jSONObject2);
        } catch (JSONException e) {
            TDLog.m682i(TAG, "trackViewScreen:" + e);
        }
    }

    public void unsetSuperProperty(String str) {
        if (hasDisabled() || str == null) {
            return;
        }
        try {
            synchronized (this.mSuperProperties) {
                JSONObject jSONObjectB = this.mSuperProperties.m678b();
                jSONObjectB.remove(str);
                this.mSuperProperties.m677a(jSONObjectB);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void user_add(String str, Number number) {
        if (hasDisabled()) {
            return;
        }
        try {
            if (number == null) {
                TDLog.m679d(TAG, "user_add value must be Number");
                if (this.mConfig.shouldThrowException()) {
                    throw new C0736m("Invalid property values for user add.");
                }
            } else {
                JSONObject jSONObject = new JSONObject();
                jSONObject.put(str, number);
                user_add(jSONObject);
            }
        } catch (JSONException e) {
            e.printStackTrace();
            if (this.mConfig.shouldThrowException()) {
                throw new C0736m(e);
            }
        }
    }

    public void user_add(JSONObject jSONObject) {
        user_add(jSONObject, (Date) null);
    }

    public void user_add(JSONObject jSONObject, Date date) {
        if (hasDisabled()) {
            return;
        }
        user_operations(EnumC0761l.USER_ADD, jSONObject, date);
    }

    public void user_append(JSONObject jSONObject) {
        user_append(jSONObject, null);
    }

    public void user_append(JSONObject jSONObject, Date date) {
        if (hasDisabled()) {
            return;
        }
        user_operations(EnumC0761l.USER_APPEND, jSONObject, date);
    }

    public void user_delete() {
        user_delete(null);
    }

    public void user_delete(Date date) {
        if (hasDisabled()) {
            return;
        }
        user_operations(EnumC0761l.USER_DEL, null, date);
    }

    void user_operations(EnumC0761l enumC0761l, JSONObject jSONObject, Date date) {
        if (hasDisabled()) {
            return;
        }
        if (!C0756g.m705a(jSONObject)) {
            TDLog.m687w(TAG, "The data contains invalid key or value: " + jSONObject.toString());
            if (this.mConfig.shouldThrowException()) {
                throw new C0736m("Invalid properties. Please refer to SDK debug log for detail reasons.");
            }
        }
        try {
            InterfaceC0754e time = date == null ? getTime() : getTime(date, (TimeZone) null);
            JSONObject jSONObject2 = new JSONObject();
            if (jSONObject != null) {
                C0766q.m747a(jSONObject, jSONObject2, this.mConfig.getDefaultTimeZone());
            }
            trackInternal(new C0718a(this, enumC0761l, jSONObject2, time));
        } catch (Exception e) {
            TDLog.m687w(TAG, e.getMessage());
        }
    }

    public void user_set(JSONObject jSONObject) {
        user_set(jSONObject, null);
    }

    public void user_set(JSONObject jSONObject, Date date) {
        user_operations(EnumC0761l.USER_SET, jSONObject, date);
    }

    public void user_setOnce(JSONObject jSONObject) {
        user_setOnce(jSONObject, null);
    }

    public void user_setOnce(JSONObject jSONObject, Date date) {
        if (hasDisabled()) {
            return;
        }
        user_operations(EnumC0761l.USER_SET_ONCE, jSONObject, date);
    }

    public void user_uniqAppend(JSONObject jSONObject) {
        user_uniqAppend(jSONObject, null);
    }

    public void user_uniqAppend(JSONObject jSONObject, Date date) {
        user_operations(EnumC0761l.USER_UNIQ_APPEND, jSONObject, date);
    }

    public void user_unset(JSONObject jSONObject, Date date) {
        if (hasDisabled()) {
            return;
        }
        user_operations(EnumC0761l.USER_UNSET, jSONObject, date);
    }

    public void user_unset(String... strArr) {
        if (hasDisabled() || strArr == null) {
            return;
        }
        JSONObject jSONObject = new JSONObject();
        for (String str : strArr) {
            try {
                jSONObject.put(str, 0);
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
        if (jSONObject.length() > 0) {
            user_unset(jSONObject, null);
        }
    }
}
