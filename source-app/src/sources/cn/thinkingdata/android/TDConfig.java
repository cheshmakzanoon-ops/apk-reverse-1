package cn.thinkingdata.android;

import android.content.Context;
import android.content.SharedPreferences;
import android.text.TextUtils;
import cn.thinkingdata.android.encrypt.TDSecreteKey;
import cn.thinkingdata.android.p004p.C0741c;
import cn.thinkingdata.android.p004p.C0742d;
import cn.thinkingdata.android.utils.C0766q;
import cn.thinkingdata.android.utils.TDLog;
import com.facebook.appevents.AppEventsConstants;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import com.facebook.internal.ServerProtocol;
import com.facebook.internal.security.CertificateUtil;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.TimeZone;
import java.util.concurrent.Future;
import java.util.concurrent.locks.ReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLSocketFactory;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class TDConfig {
    static final int DEFAULT_FLUSH_BULK_SIZE = 20;
    static final int DEFAULT_FLUSH_INTERVAL = 15000;
    private static final String PREFERENCE_NAME_PREFIX = "cn.thinkingdata.android.config";
    private static final String TAG = "ThinkingAnalytics.TDConfig";
    public static final String VERSION = "2.8.2.3";
    private volatile boolean mAllowedDebug;
    private final String mConfigUrl;
    final Context mContext;
    private final C0735l mContextConfig;
    private final String mDebugUrl;
    private TimeZone mDefaultTimeZone;
    private boolean mEnableMutiprocess;
    private final C0741c mFlushBulkSize;
    private final C0742d mFlushInterval;
    private SSLSocketFactory mSSLSocketFactory;
    private final String mServerUrl;
    final String mToken;
    private volatile String name;
    private static final C0731h sPrefsLoader = new C0731h();
    private static final Map<Context, Map<String, TDConfig>> sInstances = new HashMap();
    private final Set<String> mDisabledEvents = new HashSet();
    private final ReadWriteLock mDisabledEventsLock = new ReentrantReadWriteLock();
    private volatile ModeEnum mMode = ModeEnum.NORMAL;
    private int mNetworkType = 255;
    private volatile boolean mTrackOldData = true;
    private TDSecreteKey secreteKey = null;
    boolean mEnableEncrypt = false;

    public enum ModeEnum {
        NORMAL,
        DEBUG,
        DEBUG_ONLY
    }

    public final class NetworkType {
        public static final int TYPE_2G = 1;
        public static final int TYPE_3G = 2;
        public static final int TYPE_4G = 4;
        public static final int TYPE_5G = 16;
        public static final int TYPE_ALL = 255;
        public static final int TYPE_WIFI = 8;

        public NetworkType() {
        }
    }

    class RunnableC0703a implements Runnable {
        RunnableC0703a() {
        }

        @Override
        public void run() throws Throwable {
            HttpURLConnection httpURLConnection;
            InputStream inputStream = null;
            Object[] objArr = 0;
            InputStream inputStream2 = null;
            Object[] objArr2 = 0;
            Object[] objArr3 = 0;
            Object[] objArr4 = 0;
            try {
                try {
                    httpURLConnection = (HttpURLConnection) new URL(TDConfig.this.mConfigUrl).openConnection();
                    try {
                        try {
                            SSLSocketFactory sSLSocketFactory = TDConfig.this.getSSLSocketFactory();
                            if (sSLSocketFactory != null && (httpURLConnection instanceof HttpsURLConnection)) {
                                ((HttpsURLConnection) httpURLConnection).setSSLSocketFactory(sSLSocketFactory);
                            }
                            httpURLConnection.setRequestMethod("GET");
                            if (200 == httpURLConnection.getResponseCode()) {
                                inputStream2 = httpURLConnection.getInputStream();
                                BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(inputStream2));
                                StringBuffer stringBuffer = new StringBuffer();
                                while (true) {
                                    String line = bufferedReader.readLine();
                                    if (line == null) {
                                        break;
                                    } else {
                                        stringBuffer.append(line);
                                    }
                                }
                                JSONObject jSONObject = new JSONObject(stringBuffer.toString());
                                if (jSONObject.getString("code").equals(AppEventsConstants.EVENT_PARAM_VALUE_NO)) {
                                    int iIntValue = TDConfig.this.mFlushInterval.m678b().intValue();
                                    int iIntValue2 = TDConfig.this.mFlushBulkSize.m678b().intValue();
                                    try {
                                        JSONObject jSONObject2 = jSONObject.getJSONObject("data");
                                        iIntValue = jSONObject2.getInt("sync_interval") * 1000;
                                        iIntValue2 = jSONObject2.getInt("sync_batch_size");
                                        if (jSONObject2.has("secret_key")) {
                                            JSONObject jSONObject3 = jSONObject2.getJSONObject("secret_key");
                                            if (jSONObject3.has(SDKConstants.PARAM_KEY) && jSONObject3.has(ServerProtocol.FALLBACK_DIALOG_PARAM_VERSION) && jSONObject3.has("symmetric") && jSONObject3.has("asymmetric")) {
                                                String string = jSONObject3.getString(SDKConstants.PARAM_KEY);
                                                int i = jSONObject3.getInt(ServerProtocol.FALLBACK_DIALOG_PARAM_VERSION);
                                                String string2 = jSONObject3.getString("symmetric");
                                                String string3 = jSONObject3.getString("asymmetric");
                                                if (!TextUtils.isEmpty(string) && !TextUtils.isEmpty(string2) && !TextUtils.isEmpty(string3)) {
                                                    TDConfig.this.secreteKey = new TDSecreteKey(string, i, string2, string3);
                                                }
                                            }
                                        }
                                        TDLog.m679d(TDConfig.TAG, "Fetched remote config for (" + C0766q.m736a(TDConfig.this.mToken, 4) + "):\n" + jSONObject2.toString(4));
                                        if (jSONObject2.has("disable_event_list")) {
                                            TDConfig.this.mDisabledEventsLock.writeLock().lock();
                                            try {
                                                JSONArray jSONArray = jSONObject2.getJSONArray("disable_event_list");
                                                for (int i2 = 0; i2 < jSONArray.length(); i2++) {
                                                    TDConfig.this.mDisabledEvents.add(jSONArray.getString(i2));
                                                }
                                                TDConfig.this.mDisabledEventsLock.writeLock().unlock();
                                            } catch (Throwable th) {
                                                TDConfig.this.mDisabledEventsLock.writeLock().unlock();
                                                throw th;
                                            }
                                        }
                                    } catch (JSONException e) {
                                        e.printStackTrace();
                                    }
                                    if (TDConfig.this.mFlushBulkSize.m678b().intValue() != iIntValue2) {
                                        TDConfig.this.mFlushBulkSize.m677a(Integer.valueOf(iIntValue2));
                                    }
                                    if (TDConfig.this.mFlushInterval.m678b().intValue() != iIntValue) {
                                        TDConfig.this.mFlushInterval.m677a(Integer.valueOf(iIntValue));
                                    }
                                }
                                inputStream2.close();
                                bufferedReader.close();
                            } else {
                                TDLog.m679d(TDConfig.TAG, "Getting remote config failed, responseCode is " + httpURLConnection.getResponseCode());
                            }
                            if (inputStream2 != null) {
                                try {
                                    inputStream2.close();
                                } catch (IOException e2) {
                                    e2.printStackTrace();
                                }
                            }
                            if (httpURLConnection == null) {
                                return;
                            }
                        } catch (JSONException e3) {
                            e = e3;
                            TDLog.m679d(TDConfig.TAG, "Getting remote config failed due to: " + e.getMessage());
                            if (0 != 0) {
                                try {
                                    (objArr2 == true ? 1 : 0).close();
                                } catch (IOException e4) {
                                    e4.printStackTrace();
                                }
                            }
                            if (httpURLConnection == null) {
                                return;
                            }
                        }
                    } catch (IOException e5) {
                        e = e5;
                        TDLog.m679d(TDConfig.TAG, "Getting remote config failed due to: " + e.getMessage());
                        if (0 != 0) {
                            try {
                                (objArr3 == true ? 1 : 0).close();
                            } catch (IOException e6) {
                                e6.printStackTrace();
                            }
                        }
                        if (httpURLConnection == null) {
                            return;
                        }
                    } catch (Exception e7) {
                        e = e7;
                        TDLog.m679d(TDConfig.TAG, "Getting remote config failed due to: " + e.getMessage());
                        if (0 != 0) {
                            try {
                                (objArr4 == true ? 1 : 0).close();
                            } catch (IOException e8) {
                                e8.printStackTrace();
                            }
                        }
                        if (httpURLConnection == null) {
                            return;
                        }
                    }
                } catch (Throwable th2) {
                    th = th2;
                    if (0 != 0) {
                        try {
                            inputStream.close();
                        } catch (IOException e9) {
                            e9.printStackTrace();
                        }
                    }
                    if (0 != 0) {
                        throw th;
                    }
                    (objArr == true ? 1 : 0).disconnect();
                    throw th;
                }
            } catch (IOException e10) {
                e = e10;
                httpURLConnection = null;
            } catch (JSONException e11) {
                e = e11;
                httpURLConnection = null;
            } catch (Exception e12) {
                e = e12;
                httpURLConnection = null;
            } catch (Throwable th3) {
                th = th3;
                if (0 != 0) {
                    inputStream.close();
                }
                if (0 != 0) {
                    throw th;
                }
                (objArr == true ? 1 : 0).disconnect();
                throw th;
            }
            httpURLConnection.disconnect();
        }
    }

    static class C0704b {

        static final int[] f114a;

        static {
            int[] iArr = new int[ThinkingAnalyticsSDK.ThinkingdataNetworkType.values().length];
            f114a = iArr;
            try {
                iArr[ThinkingAnalyticsSDK.ThinkingdataNetworkType.NETWORKTYPE_WIFI.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                f114a[ThinkingAnalyticsSDK.ThinkingdataNetworkType.NETWORKTYPE_DEFAULT.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                f114a[ThinkingAnalyticsSDK.ThinkingdataNetworkType.NETWORKTYPE_ALL.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
        }
    }

    private TDConfig(Context context, String str, String str2) {
        Context applicationContext = context.getApplicationContext();
        this.mContext = applicationContext;
        this.mContextConfig = C0735l.m656a(applicationContext);
        this.mToken = str;
        this.mServerUrl = str2 + "/sync";
        this.mDebugUrl = str2 + "/data_debug";
        this.mConfigUrl = str2 + "/config?appid=" + str;
        C0731h c0731h = sPrefsLoader;
        StringBuilder sb = new StringBuilder("cn.thinkingdata.android.config_");
        sb.append(str);
        Future<SharedPreferences> futureM527a = c0731h.m527a(applicationContext, sb.toString());
        this.mFlushInterval = new C0742d(futureM527a, DEFAULT_FLUSH_INTERVAL);
        this.mFlushBulkSize = new C0741c(futureM527a, 20);
        this.mEnableMutiprocess = false;
    }

    static TDConfig getInstance(Context context, String str) {
        try {
            return getInstance(context, str, "");
        } catch (IllegalArgumentException unused) {
            return null;
        }
    }

    public static TDConfig getInstance(Context context, String str, String str2) {
        return getInstance(context, str, str2, str);
    }

    public static TDConfig getInstance(Context context, String str, String str2, String str3) {
        TDConfig tDConfig;
        String str4;
        Context applicationContext = context.getApplicationContext();
        Map<Context, Map<String, TDConfig>> map = sInstances;
        synchronized (map) {
            Map<String, TDConfig> map2 = map.get(applicationContext);
            if (map2 == null) {
                map2 = new HashMap<>();
                map.put(applicationContext, map2);
            }
            String strReplace = str.replace(" ", "");
            String strReplace2 = str3.replace(" ", "");
            tDConfig = map2.get(strReplace2);
            if (tDConfig == null) {
                try {
                    URL url = new URL(str2);
                    StringBuilder sb = new StringBuilder();
                    sb.append(url.getProtocol());
                    sb.append("://");
                    sb.append(url.getHost());
                    if (url.getPort() > 0) {
                        str4 = CertificateUtil.DELIMITER + url.getPort();
                    } else {
                        str4 = "";
                    }
                    sb.append(str4);
                    TDConfig tDConfig2 = new TDConfig(applicationContext, strReplace, sb.toString());
                    tDConfig2.setName(strReplace2);
                    map2.put(strReplace2, tDConfig2);
                    tDConfig2.getRemoteConfig();
                    tDConfig = tDConfig2;
                } catch (MalformedURLException e) {
                    TDLog.m680e(TAG, "Invalid server URL: " + str2);
                    throw new IllegalArgumentException(e);
                }
            }
        }
        return tDConfig;
    }

    private void getRemoteConfig() {
        new Thread(new RunnableC0703a()).start();
    }

    private void setName(String str) {
        this.name = str;
    }

    public TDConfig enableEncrypt(boolean z) {
        this.mEnableEncrypt = z;
        return this;
    }

    String getDebugUrl() {
        return this.mDebugUrl;
    }

    public synchronized TimeZone getDefaultTimeZone() {
        TimeZone timeZone;
        timeZone = this.mDefaultTimeZone;
        if (timeZone == null) {
            timeZone = TimeZone.getDefault();
        }
        return timeZone;
    }

    int getFlushBulkSize() {
        return this.mFlushBulkSize.m678b().intValue();
    }

    int getFlushInterval() {
        return this.mFlushInterval.m678b().intValue();
    }

    String getMainProcessName() {
        return this.mContextConfig.m658b();
    }

    public ModeEnum getMode() {
        return this.mMode;
    }

    public int getModeInt() {
        return this.mMode.ordinal();
    }

    public String getName() {
        return this.name;
    }

    public synchronized SSLSocketFactory getSSLSocketFactory() {
        return this.mSSLSocketFactory;
    }

    public TDSecreteKey getSecreteKey() {
        return this.secreteKey;
    }

    String getServerUrl() {
        return this.mServerUrl;
    }

    Map<String, TDConfig> getTDConfigMap() {
        return sInstances.get(this.mContext);
    }

    boolean isDebug() {
        return ModeEnum.DEBUG.equals(this.mMode);
    }

    boolean isDebugOnly() {
        return ModeEnum.DEBUG_ONLY.equals(this.mMode);
    }

    boolean isDisabledEvent(String str) {
        this.mDisabledEventsLock.readLock().lock();
        try {
            return this.mDisabledEvents.contains(str);
        } finally {
            this.mDisabledEventsLock.readLock().unlock();
        }
    }

    public boolean isEnableMutiprocess() {
        return this.mEnableMutiprocess;
    }

    boolean isNormal() {
        return ModeEnum.NORMAL.equals(this.mMode);
    }

    synchronized boolean isShouldFlush(String str) {
        return (C0766q.m728a(str) & this.mNetworkType) != 0;
    }

    void setAllowDebug() {
        this.mAllowedDebug = true;
    }

    public synchronized TDConfig setDefaultTimeZone(TimeZone timeZone) {
        this.mDefaultTimeZone = timeZone;
        return this;
    }

    public TDConfig setMode(ModeEnum modeEnum) {
        this.mMode = modeEnum;
        return this;
    }

    public void setModeInt(int i) {
        if (i < 0 || i > 2) {
            TDLog.m679d(TAG, "Invalid mode value");
        } else {
            this.mMode = ModeEnum.values()[i];
        }
    }

    public TDConfig setMutiprocess(boolean z) {
        this.mEnableMutiprocess = z;
        return this;
    }

    synchronized void setNetworkType(ThinkingAnalyticsSDK.ThinkingdataNetworkType thinkingdataNetworkType) {
        int i = C0704b.f114a[thinkingdataNetworkType.ordinal()];
        if (i == 1) {
            this.mNetworkType = 8;
        } else if (i == 2 || i == 3) {
            this.mNetworkType = 31;
        }
    }

    public synchronized TDConfig setSSLSocketFactory(SSLSocketFactory sSLSocketFactory) {
        if (sSLSocketFactory != null) {
            this.mSSLSocketFactory = sSLSocketFactory;
            getRemoteConfig();
        }
        return this;
    }

    public TDConfig setSecretKey(TDSecreteKey tDSecreteKey) {
        if (this.secreteKey == null) {
            this.secreteKey = tDSecreteKey;
        }
        return this;
    }

    public TDConfig setTrackOldData(boolean z) {
        this.mTrackOldData = z;
        return this;
    }

    boolean shouldThrowException() {
        return false;
    }

    public boolean trackOldData() {
        return this.mTrackOldData;
    }
}
