package com.appsflyer.internal;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.content.pm.ProviderInfo;
import android.content.pm.ResolveInfo;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.StrictMode;
import android.text.TextUtils;
import android.view.MotionEvent;
import android.view.View;
import androidx.constraintlayout.core.motion.utils.TypedValues;
import com.android.billingclient.api.BillingClient;
import com.appsflyer.AFInAppEventParameterName;
import com.appsflyer.AFInAppEventType;
import com.appsflyer.AFLogger;
import com.appsflyer.AFVersionDeclaration;
import com.appsflyer.AppsFlyerConsent;
import com.appsflyer.AppsFlyerConversionListener;
import com.appsflyer.AppsFlyerInAppPurchaseValidatorListener;
import com.appsflyer.AppsFlyerLib;
import com.appsflyer.AppsFlyerProperties;
import com.appsflyer.PurchaseHandler;
import com.appsflyer.attribution.AppsFlyerRequestListener;
import com.appsflyer.deeplink.DeepLinkListener;
import com.appsflyer.deeplink.DeepLinkResult;
import com.appsflyer.internal.AFe1dSDK.RunnableC08534;
import com.appsflyer.internal.components.network.http.ResponseNetwork;
import com.appsflyer.internal.platform_extension.PluginInfo;
import com.caverock.androidsvg.SVGParser;
import com.facebook.internal.ServerProtocol;
import j$.util.DesugarTimeZone;
import j$.util.Objects;
import j$.util.concurrent.ConcurrentHashMap;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URI;
import java.nio.ByteBuffer;
import java.nio.charset.Charset;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.TimeUnit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.Intrinsics;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public final class AFb1vSDK extends AppsFlyerLib {
    private static int $10 = 0;
    private static int $11 = 1;
    public static final String AFInAppEventParameterName;
    static final String AFInAppEventType;
    public static final String AFKeystoreWrapper;
    private static int afErrorLog = 1;
    private static int afRDLog;
    private static long afWarnLog;

    private static AFb1vSDK f308d;
    static AppsFlyerInAppPurchaseValidatorListener valueOf;
    private boolean afInfoLog;
    private AFf1iSDK afVerboseLog;
    private final AFd1kSDK force;

    private Application f310i;
    private Map<Long, String> registerClient;

    private SharedPreferences f312w;
    public volatile AppsFlyerConversionListener values = null;
    private long unregisterClient = -1;
    private long AFLogger = -1;

    private long f309e = TimeUnit.SECONDS.toMillis(5);

    private boolean f311v = false;

    static void AFKeystoreWrapper() {
        afWarnLog = -2108165172584900471L;
    }

    static Application AFInAppEventParameterName(AFb1vSDK aFb1vSDK) {
        int i = 2 % 2;
        int i2 = afErrorLog;
        int i3 = i2 + 45;
        afRDLog = i3 % 128;
        int i4 = i3 % 2;
        Application application = aFb1vSDK.f310i;
        int i5 = i2 + 57;
        afRDLog = i5 % 128;
        if (i5 % 2 == 0) {
            return application;
        }
        throw null;
    }

    static void AFInAppEventParameterName(AFb1vSDK aFb1vSDK, AFa1pSDK aFa1pSDK) {
        int i = 2 % 2;
        int i2 = afErrorLog + 7;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        aFb1vSDK.values(aFa1pSDK);
        int i4 = afRDLog + 93;
        afErrorLog = i4 % 128;
        int i5 = i4 % 2;
    }

    static void AFKeystoreWrapper(AFb1vSDK aFb1vSDK) {
        int i = 2 % 2;
        int i2 = afErrorLog + 57;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        aFb1vSDK.m776e();
        int i4 = afErrorLog + 9;
        afRDLog = i4 % 128;
        if (i4 % 2 != 0) {
            int i5 = 64 / 0;
        }
    }

    static long valueOf(AFb1vSDK aFb1vSDK, long j) {
        int i = 2 % 2;
        int i2 = afErrorLog + 71;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        aFb1vSDK.AFLogger = j;
        if (i3 == 0) {
            return j;
        }
        throw null;
    }

    static boolean valueOf(AFb1vSDK aFb1vSDK, boolean z) {
        int i = 2 % 2;
        int i2 = afRDLog + 3;
        int i3 = i2 % 128;
        afErrorLog = i3;
        int i4 = i2 % 2;
        aFb1vSDK.f311v = z;
        if (i4 == 0) {
            int i5 = 41 / 0;
        }
        int i6 = i3 + 41;
        afRDLog = i6 % 128;
        int i7 = i6 % 2;
        return z;
    }

    static AFf1iSDK values(AFb1vSDK aFb1vSDK) {
        int i = 2 % 2;
        int i2 = afRDLog + 105;
        afErrorLog = i2 % 128;
        int i3 = i2 % 2;
        AFf1iSDK aFf1iSDKRegisterClient = aFb1vSDK.registerClient();
        int i4 = afErrorLog + 23;
        afRDLog = i4 % 128;
        if (i4 % 2 == 0) {
            return aFf1iSDKRegisterClient;
        }
        Object obj = null;
        obj.hashCode();
        throw null;
    }

    static {
        AFKeystoreWrapper();
        AFInAppEventType = "281";
        AFInAppEventParameterName = "6.13";
        StringBuilder sb = new StringBuilder();
        sb.append("6.13");
        sb.append("/androidevent?buildnumber=6.13.0&app_id=");
        AFKeystoreWrapper = sb.toString();
        Object obj = null;
        valueOf = null;
        f308d = new AFb1vSDK();
        int i = afRDLog + 107;
        afErrorLog = i % 128;
        if (i % 2 != 0) {
            return;
        }
        obj.hashCode();
        throw null;
    }

    public final AFd1nSDK AFInAppEventType() {
        int i = 2 % 2;
        int i2 = afRDLog + 125;
        afErrorLog = i2 % 128;
        int i3 = i2 % 2;
        AFd1kSDK aFd1kSDK = this.force;
        if (i3 == 0) {
            int i4 = 96 / 0;
        }
        return aFd1kSDK;
    }

    public void AFKeystoreWrapper(AFf1lSDK aFf1lSDK) {
        int i = 2 % 2;
        int i2 = afRDLog + 119;
        afErrorLog = i2 % 128;
        int i3 = i2 % 2;
        AFd1nSDK aFd1nSDKAFInAppEventType = AFInAppEventType();
        if (aFf1lSDK == AFf1lSDK.SUCCESS) {
            int i4 = afRDLog + 47;
            afErrorLog = i4 % 128;
            if (i4 % 2 == 0) {
                aFd1nSDKAFInAppEventType.init().AFKeystoreWrapper();
                int i5 = 87 / 0;
            } else {
                aFd1nSDKAFInAppEventType.init().AFKeystoreWrapper();
            }
        }
        if (aFd1nSDKAFInAppEventType.afInfoLog().AFInAppEventType()) {
            aFd1nSDKAFInAppEventType.AFVersionDeclaration().valueOf();
            return;
        }
        aFd1nSDKAFInAppEventType.AFVersionDeclaration().values();
        int i6 = afErrorLog + 33;
        afRDLog = i6 % 128;
        int i7 = i6 % 2;
    }

    private synchronized AFf1iSDK registerClient() {
        int i = 2 % 2;
        int i2 = afErrorLog;
        int i3 = i2 + 63;
        afRDLog = i3 % 128;
        if (i3 % 2 != 0) {
            throw null;
        }
        if (this.afVerboseLog == null) {
            int i4 = i2 + 55;
            afRDLog = i4 % 128;
            int i5 = i4 % 2;
            this.afVerboseLog = new AFf1iSDK() {
                @Override
                public final void onRemoteConfigUpdateFinished(AFf1lSDK aFf1lSDK) {
                    this.f$0.AFKeystoreWrapper(aFf1lSDK);
                }
            };
            int i6 = afErrorLog + 121;
            afRDLog = i6 % 128;
            if (i6 % 2 != 0) {
                int i7 = 2 / 4;
            } else {
                int i8 = 2 % 2;
            }
        }
        return this.afVerboseLog;
    }

    public AFb1vSDK() {
        AFVersionDeclaration.init();
        this.force = new AFd1kSDK();
        AFInAppEventType().AFVersionDeclaration().valueOf();
        AFInAppEventType().AFVersionDeclaration().AFInAppEventType();
        AFe1dSDK aFe1dSDKMo787w = AFInAppEventType().mo787w();
        aFe1dSDKMo787w.AFKeystoreWrapper.add(new AFa1tSDK(this, (byte) 0));
    }

    public static AFb1vSDK valueOf() {
        int i = 2 % 2;
        int i2 = afErrorLog + 59;
        afRDLog = i2 % 128;
        if (i2 % 2 == 0) {
            return f308d;
        }
        throw null;
    }

    @Override
    @Deprecated
    public final void performOnAppAttribution(Context context, URI uri) {
        int i = 2 % 2;
        int i2 = afErrorLog;
        int i3 = i2 + 47;
        afRDLog = i3 % 128;
        if (i3 % 2 != 0) {
            Object obj = null;
            obj.hashCode();
            throw null;
        }
        if (uri != null) {
            int i4 = i2 + 65;
            afRDLog = i4 % 128;
            int i5 = i4 % 2;
            if (!uri.toString().isEmpty()) {
                if (context != null) {
                    AFInAppEventType(context);
                    AFInAppEventType().afErrorLog().AFInAppEventParameterName(context, AFc1oSDK.values(AFInAppEventType().AppsFlyer2dXConversionCallback()), Uri.parse(uri.toString()));
                    return;
                }
                AFc1jSDK aFc1jSDKAfErrorLog = AFInAppEventType().afErrorLog();
                StringBuilder sb = new StringBuilder("Context is \"");
                sb.append(context);
                sb.append("\"");
                aFc1jSDKAfErrorLog.values(sb.toString(), DeepLinkResult.Error.NETWORK);
                int i6 = afErrorLog + 71;
                afRDLog = i6 % 128;
                int i7 = i6 % 2;
                return;
            }
        }
        AFc1jSDK aFc1jSDKAfErrorLog2 = AFInAppEventType().afErrorLog();
        StringBuilder sb2 = new StringBuilder("Link is \"");
        sb2.append(uri);
        sb2.append("\"");
        aFc1jSDKAfErrorLog2.values(sb2.toString(), DeepLinkResult.Error.NETWORK);
    }

    @Override
    @Deprecated
    public final void setSharingFilter(String... strArr) {
        int i = 2 % 2;
        int i2 = afErrorLog + 119;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        setSharingFilterForPartners(strArr);
        int i4 = afRDLog + 73;
        afErrorLog = i4 % 128;
        int i5 = i4 % 2;
    }

    @Override
    @Deprecated
    public final void setSharingFilterForAllPartners() {
        int i = 2 % 2;
        int i2 = afRDLog + 107;
        afErrorLog = i2 % 128;
        int i3 = i2 % 2;
        setSharingFilterForPartners(SVGParser.XML_STYLESHEET_ATTR_MEDIA_ALL);
        int i4 = afErrorLog + 43;
        afRDLog = i4 % 128;
        int i5 = i4 % 2;
    }

    @Override
    public final void appendParametersToDeepLinkingURL(String str, Map<String, String> map) {
        int i = 2 % 2;
        int i2 = afErrorLog + 89;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        AFc1jSDK aFc1jSDKAfErrorLog = AFInAppEventType().afErrorLog();
        aFc1jSDKAfErrorLog.values = str;
        aFc1jSDKAfErrorLog.AFInAppEventParameterName = map;
        int i4 = afRDLog + 123;
        afErrorLog = i4 % 128;
        int i5 = i4 % 2;
    }

    @Override
    public final void subscribeForDeepLink(DeepLinkListener deepLinkListener) {
        int i = 2 % 2;
        int i2 = afErrorLog + 47;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        subscribeForDeepLink(deepLinkListener, TimeUnit.SECONDS.toMillis(3L));
        int i4 = afRDLog + 65;
        afErrorLog = i4 % 128;
        int i5 = i4 % 2;
    }

    @Override
    public final void performOnDeepLinking(final Intent intent, Context context) {
        int i = 2 % 2;
        int i2 = afRDLog;
        int i3 = i2 + 61;
        afErrorLog = i3 % 128;
        int i4 = i3 % 2;
        if (intent != null) {
            if (context == null) {
                AFInAppEventType().afErrorLog().values("performOnDeepLinking was called with null context", DeepLinkResult.Error.DEVELOPER_ERROR);
                return;
            }
            final Context applicationContext = context.getApplicationContext();
            AFInAppEventType(applicationContext);
            AFInAppEventType().values().execute(new Runnable() {
                @Override
                public final void run() {
                    this.f$0.AFInAppEventType(applicationContext, intent);
                }
            });
            return;
        }
        int i5 = i2 + 47;
        afErrorLog = i5 % 128;
        if (i5 % 2 != 0) {
            AFInAppEventType().afErrorLog().values("performOnDeepLinking was called with null intent", DeepLinkResult.Error.DEVELOPER_ERROR);
        } else {
            AFInAppEventType().afErrorLog().values("performOnDeepLinking was called with null intent", DeepLinkResult.Error.DEVELOPER_ERROR);
            int i6 = 4 / 0;
        }
    }

    @Override
    public final void addPushNotificationDeepLinkPath(String... strArr) {
        int i = 2 % 2;
        int i2 = afRDLog + 59;
        afErrorLog = i2 % 128;
        int i3 = i2 % 2;
        List<String> listAsList = Arrays.asList(strArr);
        List<List<String>> list = AFInAppEventType().afErrorLog().AFInAppEventType;
        if (!(!list.contains(listAsList))) {
            return;
        }
        int i4 = afErrorLog + 105;
        afRDLog = i4 % 128;
        int i5 = i4 % 2;
        list.add(listAsList);
        if (i5 != 0) {
            int i6 = 14 / 0;
        }
    }

    @Override
    public final void setDisableAdvertisingIdentifiers(boolean z) {
        boolean z2;
        int i = 2 % 2;
        int i2 = afErrorLog + 67;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        AFLogger.afDebugLog("setDisableAdvertisingIdentifiers: ".concat(String.valueOf(z)));
        if (z) {
            z2 = false;
        } else {
            int i4 = afRDLog + 49;
            afErrorLog = i4 % 128;
            int i5 = i4 % 2;
            z2 = true;
        }
        AFb1tSDK.AFInAppEventParameterName = Boolean.valueOf(z2);
        AppsFlyerProperties.getInstance().remove("advertiserIdEnabled");
        AppsFlyerProperties.getInstance().remove("advertiserId");
    }

    @Override
    public final void setDisableNetworkData(boolean z) {
        int i = 2 % 2;
        int i2 = afErrorLog + 51;
        afRDLog = i2 % 128;
        if (i2 % 2 == 0) {
            AFLogger.afDebugLog("setDisableNetworkData: ".concat(String.valueOf(z)));
            valueOf(AppsFlyerProperties.DISABLE_NETWORK_DATA, z);
        } else {
            AFLogger.afDebugLog("setDisableNetworkData: ".concat(String.valueOf(z)));
            valueOf(AppsFlyerProperties.DISABLE_NETWORK_DATA, z);
            throw null;
        }
    }

    public final void values(Context context, Intent intent) {
        int i = 2 % 2;
        AFi1jSDK aFi1jSDK = new AFi1jSDK(intent);
        if (aFi1jSDK.AFKeystoreWrapper("appsflyer_preinstall") != null) {
            m777e(aFi1jSDK.AFKeystoreWrapper("appsflyer_preinstall"));
        }
        AFLogger.afInfoLog("****** onReceive called *******");
        AppsFlyerProperties.getInstance();
        String strAFKeystoreWrapper = aFi1jSDK.AFKeystoreWrapper("referrer");
        AFLogger.afInfoLog("Play store referrer: ".concat(String.valueOf(strAFKeystoreWrapper)));
        if (strAFKeystoreWrapper != null) {
            int i2 = afRDLog + 59;
            afErrorLog = i2 % 128;
            Object obj = null;
            if (i2 % 2 == 0) {
                valueOf(context).values("referrer", strAFKeystoreWrapper);
                AppsFlyerProperties appsFlyerProperties = AppsFlyerProperties.getInstance();
                appsFlyerProperties.set("AF_REFERRER", strAFKeystoreWrapper);
                appsFlyerProperties.AFKeystoreWrapper = strAFKeystoreWrapper;
                AppsFlyerProperties.getInstance().AFInAppEventType();
                throw null;
            }
            valueOf(context).values("referrer", strAFKeystoreWrapper);
            AppsFlyerProperties appsFlyerProperties2 = AppsFlyerProperties.getInstance();
            appsFlyerProperties2.set("AF_REFERRER", strAFKeystoreWrapper);
            appsFlyerProperties2.AFKeystoreWrapper = strAFKeystoreWrapper;
            if (AppsFlyerProperties.getInstance().AFInAppEventType()) {
                int i3 = afErrorLog + 115;
                afRDLog = i3 % 128;
                if (i3 % 2 == 0) {
                    AFLogger.afInfoLog("onReceive: isLaunchCalled");
                    AFKeystoreWrapper(context, AFh1ySDK.onReceive);
                    AFInAppEventType(strAFKeystoreWrapper);
                } else {
                    AFLogger.afInfoLog("onReceive: isLaunchCalled");
                    AFKeystoreWrapper(context, AFh1ySDK.onReceive);
                    AFInAppEventType(strAFKeystoreWrapper);
                    obj.hashCode();
                    throw null;
                }
            }
        }
    }

    private static void values(JSONObject jSONObject) {
        String str;
        int i = 2 % 2;
        ArrayList arrayList = new ArrayList();
        Iterator<String> itKeys = jSONObject.keys();
        while (true) {
            if (!itKeys.hasNext()) {
                break;
            }
            try {
                JSONArray jSONArray = new JSONArray((String) jSONObject.get(itKeys.next()));
                int i2 = afErrorLog + 17;
                afRDLog = i2 % 128;
                int i3 = i2 % 2;
                for (int i4 = 0; i4 < jSONArray.length(); i4++) {
                    arrayList.add(Long.valueOf(jSONArray.getLong(i4)));
                }
            } catch (JSONException e) {
                AFLogger.afErrorLogForExcManagerOnly("error at timeStampArr", e);
            }
        }
        Collections.sort(arrayList);
        Iterator<String> itKeys2 = jSONObject.keys();
        loop2: while (true) {
            str = null;
            while (true) {
                if (!itKeys2.hasNext() || str != null) {
                    break loop2;
                }
                String next = itKeys2.next();
                try {
                    JSONArray jSONArray2 = new JSONArray((String) jSONObject.get(next));
                    int i5 = afErrorLog + 111;
                    afRDLog = i5 % 128;
                    int i6 = i5 % 2;
                    int i7 = 0;
                    while (i7 < jSONArray2.length()) {
                        if (jSONArray2.getLong(i7) == ((Long) arrayList.get(0)).longValue()) {
                            break;
                        }
                        int i8 = afErrorLog + 91;
                        afRDLog = i8 % 128;
                        int i9 = i8 % 2;
                        if (jSONArray2.getLong(i7) == ((Long) arrayList.get(1)).longValue()) {
                            break;
                        }
                        int i10 = afRDLog + 103;
                        afErrorLog = i10 % 128;
                        if (i10 % 2 == 0) {
                            if (jSONArray2.getLong(i7) == ((Long) arrayList.get(arrayList.size() + 1)).longValue()) {
                                break;
                            }
                            i7++;
                            str = next;
                        } else {
                            if (jSONArray2.getLong(i7) == ((Long) arrayList.get(arrayList.size() - 1)).longValue()) {
                                break;
                            }
                            i7++;
                            str = next;
                        }
                    }
                } catch (JSONException e2) {
                    AFLogger.afErrorLogForExcManagerOnly("error at manageExtraReferrers", e2);
                }
            }
        }
        if (str != null) {
            int i11 = afErrorLog + 85;
            afRDLog = i11 % 128;
            int i12 = i11 % 2;
            jSONObject.remove(str);
        }
    }

    public final void values(Context context, String str) {
        JSONArray jSONArray;
        JSONObject jSONObject;
        int i = 2 % 2;
        AFLogger.afDebugLog("received a new (extra) referrer: ".concat(String.valueOf(str)));
        try {
            long jCurrentTimeMillis = System.currentTimeMillis();
            Object obj = null;
            String strValueOf = valueOf(context).valueOf("extraReferrers", (String) null);
            if (strValueOf == null) {
                jSONObject = new JSONObject();
                jSONArray = new JSONArray();
            } else {
                JSONObject jSONObject2 = new JSONObject(strValueOf);
                jSONArray = jSONObject2.has(str) ? new JSONArray((String) jSONObject2.get(str)) : new JSONArray();
                jSONObject = jSONObject2;
            }
            if (jSONArray.length() < 5) {
                int i2 = afRDLog + 15;
                afErrorLog = i2 % 128;
                if (i2 % 2 == 0) {
                    jSONArray.put(jCurrentTimeMillis);
                    obj.hashCode();
                    throw null;
                }
                jSONArray.put(jCurrentTimeMillis);
            }
            if (jSONObject.length() >= 4) {
                int i3 = afRDLog + 69;
                afErrorLog = i3 % 128;
                int i4 = i3 % 2;
                values(jSONObject);
            }
            jSONObject.put(str, jSONArray.toString());
            valueOf(context).values("extraReferrers", jSONObject.toString());
        } catch (JSONException e) {
            AFLogger.afErrorLogForExcManagerOnly("error at addReferrer", e);
        } catch (Throwable th) {
            StringBuilder sb = new StringBuilder("Couldn't save referrer - ");
            sb.append(str);
            sb.append(": ");
            AFLogger.afErrorLog(sb.toString(), th);
        }
    }

    public static void AFInAppEventParameterName(AFd1nSDK aFd1nSDK) {
        int i = 2 % 2;
        int i2 = afRDLog + 85;
        afErrorLog = i2 % 128;
        int i3 = i2 % 2;
        aFd1nSDK.afRDLog().AFInAppEventParameterName();
        if (i3 == 0) {
            Object obj = null;
            obj.hashCode();
            throw null;
        }
        int i4 = afRDLog + 71;
        afErrorLog = i4 % 128;
        if (i4 % 2 == 0) {
            int i5 = 51 / 0;
        }
    }

    @Override
    public final void stop(boolean z, Context context) {
        final AFd1nSDK aFd1nSDKAFInAppEventType;
        int i;
        int i2 = 2 % 2;
        int i3 = afRDLog + 41;
        afErrorLog = i3 % 128;
        if (i3 % 2 == 0) {
            AFInAppEventType(context);
            aFd1nSDKAFInAppEventType = AFInAppEventType();
            aFd1nSDKAFInAppEventType.mo785i().f395d = z;
            aFd1nSDKAFInAppEventType.values().submit(new Runnable() {
                @Override
                public final void run() {
                    AFb1vSDK.AFInAppEventParameterName(aFd1nSDKAFInAppEventType);
                }
            });
            int i4 = 21 / 0;
            if (z) {
                int i5 = afErrorLog + 97;
                afRDLog = i5 % 128;
                int i6 = i5 % 2;
                aFd1nSDKAFInAppEventType.AFKeystoreWrapper().AFInAppEventParameterName("is_stop_tracking_used", true);
                i = afErrorLog + 103;
                afRDLog = i % 128;
                if (i % 2 != 0) {
                    int i7 = 2 / 4;
                }
            }
        } else {
            AFInAppEventType(context);
            aFd1nSDKAFInAppEventType = AFInAppEventType();
            aFd1nSDKAFInAppEventType.mo785i().f395d = z;
            aFd1nSDKAFInAppEventType.values().submit(new Runnable() {
                @Override
                public final void run() {
                    AFb1vSDK.AFInAppEventParameterName(aFd1nSDKAFInAppEventType);
                }
            });
            if (z) {
                int i8 = afErrorLog + 97;
                afRDLog = i8 % 128;
                int i9 = i8 % 2;
                aFd1nSDKAFInAppEventType.AFKeystoreWrapper().AFInAppEventParameterName("is_stop_tracking_used", true);
                i = afErrorLog + 103;
                afRDLog = i % 128;
                if (i % 2 != 0) {
                    int i10 = 2 / 4;
                }
            }
        }
        int i11 = afRDLog + 21;
        afErrorLog = i11 % 128;
        if (i11 % 2 == 0) {
            int i12 = 3 / 0;
        }
    }

    @Override
    public final String getSdkVersion() {
        int i = 2 % 2;
        int i2 = afErrorLog + 59;
        afRDLog = i2 % 128;
        if (i2 % 2 != 0) {
            AFInAppEventType().afInfoLog().AFKeystoreWrapper("getSdkVersion", new String[0]);
        } else {
            AFInAppEventType().afInfoLog().AFKeystoreWrapper("getSdkVersion", new String[0]);
        }
        return AFd1rSDK.AFKeystoreWrapper();
    }

    @Override
    public final void enableTCFDataCollection(boolean z) {
        int i = 2 % 2;
        int i2 = afRDLog + 51;
        afErrorLog = i2 % 128;
        int i3 = i2 % 2;
        AFInAppEventType(AppsFlyerProperties.ENABLE_TCF_DATA_COLLECTION, Boolean.toString(z));
        if (i3 == 0) {
            Object obj = null;
            obj.hashCode();
            throw null;
        }
        int i4 = afErrorLog + 65;
        afRDLog = i4 % 128;
        int i5 = i4 % 2;
    }

    @Override
    public final void onPause(Context context) {
        int i = 2 % 2;
        int i2 = afErrorLog + 17;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        AFInAppEventType().afLogForce().AFKeystoreWrapper();
        int i4 = afErrorLog + 1;
        afRDLog = i4 % 128;
        if (i4 % 2 != 0) {
            int i5 = 41 / 0;
        }
    }

    @Override
    public final void updateServerUninstallToken(Context context, String str) {
        AFInAppEventType(context);
        AFg1tSDK aFg1tSDK = new AFg1tSDK(context);
        if (str == null || str.trim().isEmpty()) {
            AFLogger.INSTANCE.m804w(AFg1hSDK.UNINSTALL, "Firebase Token is either empty or null and was not registered.");
            return;
        }
        AFLogger.INSTANCE.m802i(AFg1hSDK.UNINSTALL, "Firebase Refreshed Token = ".concat(String.valueOf(str)));
        AFg1uSDK aFg1uSDKAFInAppEventType = aFg1tSDK.AFInAppEventType();
        if (aFg1uSDKAFInAppEventType == null || !str.equals(aFg1uSDKAFInAppEventType.values)) {
            long jCurrentTimeMillis = System.currentTimeMillis();
            boolean z = aFg1uSDKAFInAppEventType == null || jCurrentTimeMillis - aFg1uSDKAFInAppEventType.valueOf > TimeUnit.SECONDS.toMillis(2L);
            AFg1uSDK aFg1uSDK = new AFg1uSDK(str, jCurrentTimeMillis, !z);
            aFg1tSDK.AFKeystoreWrapper.values("afUninstallToken", aFg1uSDK.values);
            aFg1tSDK.AFKeystoreWrapper.AFInAppEventParameterName("afUninstallToken_received_time", aFg1uSDK.valueOf);
            aFg1tSDK.AFKeystoreWrapper.AFInAppEventParameterName("afUninstallToken_queued", aFg1uSDK.values());
            if (z) {
                AFg1tSDK.valueOf(str);
            }
        }
    }

    @Override
    public final void setDebugLog(boolean z) {
        AFLogger.LogLevel logLevel;
        int i = 2 % 2;
        int i2 = afErrorLog + 79;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        if (z) {
            logLevel = AFLogger.LogLevel.DEBUG;
        } else {
            logLevel = AFLogger.LogLevel.NONE;
            int i4 = afErrorLog + 17;
            afRDLog = i4 % 128;
            int i5 = i4 % 2;
        }
        setLogLevel(logLevel);
    }

    @Override
    public final void setOaidData(String str) {
        int i = 2 % 2;
        int i2 = afErrorLog + 49;
        afRDLog = i2 % 128;
        if (i2 % 2 != 0) {
            AFb1cSDK aFb1cSDKAfInfoLog = AFInAppEventType().afInfoLog();
            String[] strArr = new String[1];
            strArr[1] = str;
            aFb1cSDKAfInfoLog.AFKeystoreWrapper("setOaidData", strArr);
        } else {
            AFInAppEventType().afInfoLog().AFKeystoreWrapper("setOaidData", str);
        }
        AFb1tSDK.AFKeystoreWrapper = str;
    }

    private static void AFInAppEventType(String str, String str2) {
        int i = 2 % 2;
        int i2 = afErrorLog + 113;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        AppsFlyerProperties.getInstance().set(str, str2);
        if (i3 == 0) {
            return;
        }
        Object obj = null;
        obj.hashCode();
        throw null;
    }

    private static void valueOf(String str, boolean z) {
        int i = 2 % 2;
        int i2 = afErrorLog + 97;
        afRDLog = i2 % 128;
        if (i2 % 2 != 0) {
            AppsFlyerProperties.getInstance().set(str, z);
            Object obj = null;
            obj.hashCode();
            throw null;
        }
        AppsFlyerProperties.getInstance().set(str, z);
        int i3 = afErrorLog + 87;
        afRDLog = i3 % 128;
        if (i3 % 2 != 0) {
            int i4 = 28 / 0;
        }
    }

    private static String values(String str) {
        int i = 2 % 2;
        int i2 = afErrorLog + 103;
        afRDLog = i2 % 128;
        if (i2 % 2 != 0) {
            AppsFlyerProperties.getInstance().getString(str);
            throw null;
        }
        String string = AppsFlyerProperties.getInstance().getString(str);
        int i3 = afErrorLog + 55;
        afRDLog = i3 % 128;
        int i4 = i3 % 2;
        return string;
    }

    private static boolean AFInAppEventParameterName(String str) {
        int i = 2 % 2;
        int i2 = afRDLog + 27;
        afErrorLog = i2 % 128;
        int i3 = i2 % 2;
        return AppsFlyerProperties.getInstance().getBoolean(str, false);
    }

    public final boolean values() {
        int i = 2 % 2;
        int i2 = afRDLog + 105;
        afErrorLog = i2 % 128;
        int i3 = i2 % 2;
        if (!AFInAppEventParameterName(AppsFlyerProperties.AF_WAITFOR_CUSTOMERID)) {
            return false;
        }
        int i4 = afRDLog + 111;
        afErrorLog = i4 % 128;
        int i5 = i4 % 2;
        return AFInAppEventParameterName() == null;
    }

    @Override
    public final void waitForCustomerUserId(boolean z) {
        String strConcat;
        int i = 2 % 2;
        boolean z2 = true;
        int i2 = afRDLog + 1;
        afErrorLog = i2 % 128;
        if (i2 % 2 == 0) {
            strConcat = "initAfterCustomerUserID: ".concat(String.valueOf(z));
            z2 = false;
        } else {
            strConcat = "initAfterCustomerUserID: ".concat(String.valueOf(z));
        }
        AFLogger.afInfoLog(strConcat, z2);
        valueOf(AppsFlyerProperties.AF_WAITFOR_CUSTOMERID, z);
    }

    @Override
    public final void setCustomerIdAndLogSession(String str, Context context) {
        int i = 2 % 2;
        if (context != null) {
            int i2 = afErrorLog + 39;
            afRDLog = i2 % 128;
            if (i2 % 2 == 0) {
                if (values()) {
                    setCustomerUserId(str);
                    StringBuilder sb = new StringBuilder("CustomerUserId set: ");
                    sb.append(str);
                    sb.append(" - Initializing AppsFlyer Tacking");
                    AFLogger.afInfoLog(sb.toString(), true);
                    String referrer = AppsFlyerProperties.getInstance().getReferrer(AFInAppEventType().AFKeystoreWrapper());
                    AFKeystoreWrapper(context, AFh1ySDK.setCustomerIdAndLogSession);
                    String str2 = AFInAppEventType().mo785i().registerClient;
                    if (referrer == null) {
                        int i3 = afErrorLog + 115;
                        afRDLog = i3 % 128;
                        int i4 = i3 % 2;
                        referrer = "";
                    }
                    if (context instanceof Activity) {
                        ((Activity) context).getIntent();
                    }
                    valueOf(context, referrer);
                    return;
                }
                setCustomerUserId(str);
                AFLogger.afInfoLog("waitForCustomerUserId is false; setting CustomerUserID: ".concat(String.valueOf(str)), true);
                return;
            }
            values();
            Object obj = null;
            obj.hashCode();
            throw null;
        }
    }

    @Override
    public final String getOutOfStore(Context context) {
        int i = 2 % 2;
        String string = AppsFlyerProperties.getInstance().getString(AppsFlyerProperties.AF_STORE_FROM_API);
        if (string == null) {
            String strAFInAppEventType = AFInAppEventType(context, "AF_STORE");
            Object obj = null;
            if (strAFInAppEventType == null) {
                AFLogger.afInfoLog("No out-of-store value set");
                return null;
            }
            int i2 = afRDLog + 7;
            afErrorLog = i2 % 128;
            if (i2 % 2 != 0) {
                return strAFInAppEventType;
            }
            obj.hashCode();
            throw null;
        }
        int i3 = afRDLog + 21;
        afErrorLog = i3 % 128;
        int i4 = i3 % 2;
        return string;
    }

    @Override
    public final void setOutOfStore(java.lang.String r5) {
        throw new UnsupportedOperationException("Method not decompiled: com.appsflyer.internal.AFb1vSDK.setOutOfStore(java.lang.String):void");
    }

    @Override
    public final void setAppInviteOneLink(String str) {
        int i = 2 % 2;
        AFInAppEventType().afInfoLog().AFKeystoreWrapper("setAppInviteOneLink", str);
        AFLogger.afInfoLog("setAppInviteOneLink = ".concat(String.valueOf(str)));
        if (str != null) {
            int i2 = afRDLog + 109;
            afErrorLog = i2 % 128;
            if (i2 % 2 == 0) {
                str.equals(AppsFlyerProperties.getInstance().getString(AppsFlyerProperties.ONELINK_ID));
                Object obj = null;
                obj.hashCode();
                throw null;
            }
            if (!str.equals(AppsFlyerProperties.getInstance().getString(AppsFlyerProperties.ONELINK_ID))) {
                AppsFlyerProperties.getInstance().remove(AppsFlyerProperties.ONELINK_DOMAIN);
                AppsFlyerProperties.getInstance().remove(AppsFlyerProperties.ONELINK_VERSION);
                AppsFlyerProperties.getInstance().remove(AppsFlyerProperties.ONELINK_SCHEME);
                int i3 = afRDLog + 5;
                afErrorLog = i3 % 128;
                int i4 = i3 % 2;
            }
        } else {
            AppsFlyerProperties.getInstance().remove(AppsFlyerProperties.ONELINK_DOMAIN);
            AppsFlyerProperties.getInstance().remove(AppsFlyerProperties.ONELINK_VERSION);
            AppsFlyerProperties.getInstance().remove(AppsFlyerProperties.ONELINK_SCHEME);
            int i5 = afRDLog + 5;
            afErrorLog = i5 % 128;
            int i6 = i5 % 2;
        }
        AFInAppEventType(AppsFlyerProperties.ONELINK_ID, str);
    }

    @Override
    public final void setAdditionalData(Map<String, Object> map) {
        int i = 2 % 2;
        int i2 = afRDLog + 9;
        afErrorLog = i2 % 128;
        int i3 = i2 % 2;
        if (map != null) {
            AFInAppEventType().afInfoLog().AFKeystoreWrapper("setAdditionalData", map.toString());
            AppsFlyerProperties.getInstance().setCustomData(new JSONObject(map).toString());
        }
        int i4 = afErrorLog + 11;
        afRDLog = i4 % 128;
        if (i4 % 2 == 0) {
            return;
        }
        Object obj = null;
        obj.hashCode();
        throw null;
    }

    @Override
    public final void sendPushNotificationData(Activity activity) {
        long jLongValue;
        int i = 2 % 2;
        if (activity != null && activity.getIntent() != null) {
            AFb1cSDK aFb1cSDKAfInfoLog = AFInAppEventType().afInfoLog();
            String localClassName = activity.getLocalClassName();
            StringBuilder sb = new StringBuilder("activity_intent_");
            sb.append(activity.getIntent().toString());
            aFb1cSDKAfInfoLog.AFKeystoreWrapper("sendPushNotificationData", localClassName, sb.toString());
        } else if (activity != null) {
            AFInAppEventType().afInfoLog().AFKeystoreWrapper("sendPushNotificationData", activity.getLocalClassName(), "activity_intent_null");
        } else {
            AFInAppEventType().afInfoLog().AFKeystoreWrapper("sendPushNotificationData", "activity_null");
        }
        AFd1sSDK level = AFInAppEventType().getLevel();
        level.values = values(activity);
        if (level.values != null) {
            int i2 = afErrorLog + 85;
            afRDLog = i2 % 128;
            if (i2 % 2 != 0) {
                System.currentTimeMillis();
                Object obj = null;
                obj.hashCode();
                throw null;
            }
            long jCurrentTimeMillis = System.currentTimeMillis();
            if (this.registerClient == null) {
                AFLogger.afInfoLog("pushes: initializing pushes history..");
                this.registerClient = new ConcurrentHashMap();
                jLongValue = jCurrentTimeMillis;
            } else {
                try {
                    long j = AppsFlyerProperties.getInstance().getLong("pushPayloadMaxAging", 1800000L);
                    Iterator<Long> it = this.registerClient.keySet().iterator();
                    jLongValue = jCurrentTimeMillis;
                    while (it.hasNext()) {
                        try {
                            Long next = it.next();
                            JSONObject jSONObject = new JSONObject(level.values);
                            JSONObject jSONObject2 = new JSONObject(this.registerClient.get(next));
                            Iterator<Long> it2 = it;
                            if (jSONObject.opt("pid").equals(jSONObject2.opt("pid")) && jSONObject.opt("c").equals(jSONObject2.opt("c"))) {
                                StringBuilder sb2 = new StringBuilder("PushNotificationMeasurement: A previous payload with same PID and campaign was already acknowledged! (old: ");
                                sb2.append(jSONObject2);
                                sb2.append(", new: ");
                                sb2.append(jSONObject);
                                sb2.append(")");
                                AFLogger.afInfoLog(sb2.toString());
                                level.values = null;
                                return;
                            }
                            if (jCurrentTimeMillis - next.longValue() > j) {
                                int i3 = afErrorLog + 35;
                                afRDLog = i3 % 128;
                                int i4 = i3 % 2;
                                this.registerClient.remove(next);
                            }
                            if (next.longValue() <= jLongValue) {
                                int i5 = afRDLog + 103;
                                afErrorLog = i5 % 128;
                                int i6 = i5 % 2;
                                jLongValue = next.longValue();
                            }
                            it = it2;
                        } catch (Throwable th) {
                            th = th;
                            StringBuilder sb3 = new StringBuilder("Error while handling push notification measurement: ");
                            sb3.append(th.getClass().getSimpleName());
                            AFLogger.afErrorLog(sb3.toString(), th);
                        }
                    }
                } catch (Throwable th2) {
                    th = th2;
                    jLongValue = jCurrentTimeMillis;
                }
            }
            if (this.registerClient.size() == AppsFlyerProperties.getInstance().getInt("pushPayloadHistorySize", 2)) {
                StringBuilder sb4 = new StringBuilder("pushes: removing oldest overflowing push (oldest push:");
                sb4.append(jLongValue);
                sb4.append(")");
                AFLogger.afInfoLog(sb4.toString());
                this.registerClient.remove(Long.valueOf(jLongValue));
            }
            this.registerClient.put(Long.valueOf(jCurrentTimeMillis), level.values);
            start(activity);
            int i7 = afRDLog + 43;
            afErrorLog = i7 % 128;
            int i8 = i7 % 2;
        }
    }

    @Override
    public final void setUserEmails(String... strArr) {
        int i = 2 % 2;
        int i2 = afErrorLog + 69;
        afRDLog = i2 % 128;
        if (i2 % 2 == 0) {
            AFInAppEventType().afInfoLog().AFKeystoreWrapper("setUserEmails", strArr);
            setUserEmails(AppsFlyerProperties.EmailsCryptType.NONE, strArr);
            int i3 = afRDLog + 15;
            afErrorLog = i3 % 128;
            int i4 = i3 % 2;
            return;
        }
        AFInAppEventType().afInfoLog().AFKeystoreWrapper("setUserEmails", strArr);
        setUserEmails(AppsFlyerProperties.EmailsCryptType.NONE, strArr);
        throw null;
    }

    static class C08342 {
        static final int[] values;

        static {
            int[] iArr = new int[AppsFlyerProperties.EmailsCryptType.values().length];
            values = iArr;
            try {
                iArr[AppsFlyerProperties.EmailsCryptType.SHA256.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                values[AppsFlyerProperties.EmailsCryptType.NONE.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
        }
    }

    @Override
    public final void setUserEmails(AppsFlyerProperties.EmailsCryptType emailsCryptType, String... strArr) {
        String str;
        int i = 2 % 2;
        ArrayList arrayList = new ArrayList(strArr.length + 1);
        arrayList.add(emailsCryptType.toString());
        arrayList.addAll(Arrays.asList(strArr));
        AFInAppEventType().afInfoLog().AFKeystoreWrapper("setUserEmails", (String[]) arrayList.toArray(new String[strArr.length + 1]));
        AppsFlyerProperties.getInstance().set(AppsFlyerProperties.EMAIL_CRYPT_TYPE, emailsCryptType.getValue());
        HashMap map = new HashMap();
        ArrayList arrayList2 = new ArrayList();
        int length = strArr.length;
        int i2 = afRDLog + 61;
        afErrorLog = i2 % 128;
        int i3 = i2 % 2;
        String str2 = null;
        for (int i4 = 0; i4 < length; i4++) {
            int i5 = afRDLog + 123;
            afErrorLog = i5 % 128;
            if (i5 % 2 == 0) {
                str = strArr[i4];
                int i6 = 55 / 0;
                if (C08342.values[emailsCryptType.ordinal()] != 2) {
                    arrayList2.add(AFb1mSDK.AFInAppEventType(str));
                    str2 = "sha256_el_arr";
                } else {
                    arrayList2.add(str);
                    str2 = "plain_el_arr";
                }
            } else {
                str = strArr[i4];
                if (C08342.values[emailsCryptType.ordinal()] != 2) {
                    arrayList2.add(AFb1mSDK.AFInAppEventType(str));
                    str2 = "sha256_el_arr";
                } else {
                    arrayList2.add(str);
                    str2 = "plain_el_arr";
                }
            }
        }
        map.put(str2, arrayList2);
        AppsFlyerProperties.getInstance().setUserEmails(new JSONObject(map).toString());
    }

    @Override
    public final void setCollectAndroidID(boolean z) {
        int i = 2 % 2;
        int i2 = afRDLog + 43;
        afErrorLog = i2 % 128;
        if (i2 % 2 == 0) {
            AFInAppEventType().afInfoLog().AFKeystoreWrapper("setCollectAndroidID", String.valueOf(z));
        } else {
            AFInAppEventType().afInfoLog().AFKeystoreWrapper("setCollectAndroidID", String.valueOf(z));
        }
        AFInAppEventType(AppsFlyerProperties.COLLECT_ANDROID_ID, Boolean.toString(z));
        AFInAppEventType(AppsFlyerProperties.COLLECT_ANDROID_ID_FORCE_BY_USER, Boolean.toString(z));
        int i3 = afRDLog + 77;
        afErrorLog = i3 % 128;
        if (i3 % 2 == 0) {
            int i4 = 94 / 0;
        }
    }

    @Override
    public final void setCollectIMEI(boolean z) {
        int i = 2 % 2;
        int i2 = afErrorLog + 75;
        afRDLog = i2 % 128;
        if (i2 % 2 != 0) {
            AFb1cSDK aFb1cSDKAfInfoLog = AFInAppEventType().afInfoLog();
            String[] strArr = new String[0];
            strArr[0] = String.valueOf(z);
            aFb1cSDKAfInfoLog.AFKeystoreWrapper("setCollectIMEI", strArr);
        } else {
            AFInAppEventType().afInfoLog().AFKeystoreWrapper("setCollectIMEI", String.valueOf(z));
        }
        AFInAppEventType(AppsFlyerProperties.COLLECT_IMEI, Boolean.toString(z));
        AFInAppEventType(AppsFlyerProperties.COLLECT_IMEI_FORCE_BY_USER, Boolean.toString(z));
        int i3 = afErrorLog + 47;
        afRDLog = i3 % 128;
        if (i3 % 2 != 0) {
            int i4 = 14 / 0;
        }
    }

    @Override
    @Deprecated
    public final void setCollectOaid(boolean z) {
        int i = 2 % 2;
        int i2 = afErrorLog + 53;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        AFInAppEventType().afInfoLog().AFKeystoreWrapper("setCollectOaid", String.valueOf(z));
        AFInAppEventType(AppsFlyerProperties.COLLECT_OAID, Boolean.toString(z));
        int i4 = afErrorLog + 15;
        afRDLog = i4 % 128;
        if (i4 % 2 == 0) {
            return;
        }
        Object obj = null;
        obj.hashCode();
        throw null;
    }

    public void AFKeystoreWrapper(boolean z) {
        int i = 2 % 2;
        int i2 = afRDLog + 45;
        afErrorLog = i2 % 128;
        int i3 = i2 % 2;
        if (z) {
            AFInAppEventType().AFVersionDeclaration().AFInAppEventParameterName();
            return;
        }
        AFInAppEventType().AFVersionDeclaration().AFKeystoreWrapper();
        int i4 = afErrorLog + 35;
        afRDLog = i4 % 128;
        if (i4 % 2 != 0) {
            throw null;
        }
    }

    public void m774d() {
        int i = 2 % 2;
        values(new AFh1wSDK());
        int i2 = afErrorLog + 33;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
    }

    @Override
    public final AppsFlyerLib init(String str, AppsFlyerConversionListener appsFlyerConversionListener, Context context) {
        long j;
        int i = 2 % 2;
        if (!this.afInfoLog) {
            this.afInfoLog = true;
            AFInAppEventType().mo785i().registerClient = str;
            AFb1bSDK.AFInAppEventParameterName(str);
            if (context != null) {
                AFInAppEventType(context);
                Application applicationValues = AFb1qSDK.values(context);
                if (applicationValues == null) {
                    return this;
                }
                int i2 = afErrorLog + 73;
                afRDLog = i2 % 128;
                int i3 = i2 % 2;
                this.f310i = applicationValues;
                AFInAppEventType().afRDLog().values();
                AFInAppEventType().unregisterClient().valueOf = System.currentTimeMillis();
                AFh1gSDK aFh1gSDKAFLogger$LogLevel = AFInAppEventType().AFLogger$LogLevel();
                aFh1gSDKAFLogger$LogLevel.AFKeystoreWrapper = Build.VERSION.SDK_INT >= 31 ? new AFh1bSDK(aFh1gSDKAFLogger$LogLevel.AFInAppEventParameterName) : new AFi1zSDK(aFh1gSDKAFLogger$LogLevel.AFInAppEventParameterName);
                AFInAppEventType().init().valueOf(new AFd1iSDK.AFa1zSDK() {
                    @Override
                    public final void onConfigurationChanged(boolean z) {
                        this.f$0.AFKeystoreWrapper(z);
                    }
                });
                AFInAppEventType().mo784e().values(registerClient());
                AFi1kSDK aFi1kSDKForce = AFInAppEventType().force();
                Runnable runnable = new Runnable() {
                    @Override
                    public final void run() {
                        this.f$0.m774d();
                    }
                };
                AFi1pSDK aFi1pSDKAFInAppEventParameterName = aFi1kSDKForce.AFInAppEventParameterName(runnable);
                Runnable runnableAFInAppEventType = aFi1kSDKForce.AFInAppEventType(aFi1pSDKAFInAppEventParameterName, runnable);
                aFi1kSDKForce.AFKeystoreWrapper(aFi1pSDKAFInAppEventParameterName);
                aFi1kSDKForce.AFKeystoreWrapper(new AFi1lSDK(aFi1kSDKForce.AFKeystoreWrapper.AFInAppEventType(), runnableAFInAppEventType));
                aFi1kSDKForce.AFKeystoreWrapper(new AFi1sSDK(runnableAFInAppEventType, aFi1kSDKForce.AFKeystoreWrapper));
                aFi1kSDKForce.AFKeystoreWrapper(new AFi1oSDK(runnableAFInAppEventType, aFi1kSDKForce.AFKeystoreWrapper));
                aFi1kSDKForce.values(runnableAFInAppEventType);
                if (!aFi1kSDKForce.AFInAppEventParameterName()) {
                    Context context2 = aFi1kSDKForce.AFKeystoreWrapper.mo786v().AFInAppEventParameterName;
                    AFd1nSDK aFd1nSDK = aFi1kSDKForce.AFKeystoreWrapper;
                    List<ResolveInfo> listQueryIntentContentProviders = context2.getPackageManager().queryIntentContentProviders(new Intent("com.appsflyer.referrer.INSTALL_PROVIDER"), 0);
                    if (listQueryIntentContentProviders != null) {
                        int i4 = afErrorLog + 81;
                        afRDLog = i4 % 128;
                        if (i4 % 2 != 0) {
                            listQueryIntentContentProviders.isEmpty();
                            Object obj = null;
                            obj.hashCode();
                            throw null;
                        }
                        if (!listQueryIntentContentProviders.isEmpty()) {
                            ArrayList arrayList = new ArrayList();
                            Iterator<ResolveInfo> it = listQueryIntentContentProviders.iterator();
                            while (it.hasNext()) {
                                ProviderInfo providerInfo = it.next().providerInfo;
                                if (providerInfo != null) {
                                    arrayList.add(new AFi1mSDK(providerInfo, runnableAFInAppEventType, aFd1nSDK));
                                } else {
                                    AFLogger.INSTANCE.m804w(AFg1hSDK.PREINSTALL, "com.appsflyer.referrer.INSTALL_PROVIDER Action is set for non ContentProvider component");
                                }
                            }
                            if (!arrayList.isEmpty()) {
                                aFi1kSDKForce.AFInAppEventType.addAll(arrayList);
                                AFLogger aFLogger = AFLogger.INSTANCE;
                                AFg1hSDK aFg1hSDK = AFg1hSDK.PREINSTALL;
                                StringBuilder sb = new StringBuilder("Detected ");
                                sb.append(arrayList.size());
                                sb.append(" valid preinstall provider(s)");
                                aFLogger.m797d(aFg1hSDK, sb.toString());
                            }
                        }
                    }
                }
                for (AFi1nSDK aFi1nSDK : aFi1kSDKForce.AFInAppEventType()) {
                    int i5 = afRDLog + 57;
                    afErrorLog = i5 % 128;
                    int i6 = i5 % 2;
                    aFi1nSDK.values(aFi1kSDKForce.AFKeystoreWrapper.mo786v().AFInAppEventParameterName);
                }
                final AFg1zSDK aFg1zSDKMo785i = this.force.mo785i();
                AFd1rSDK aFd1rSDKAFInAppEventType = AFInAppEventType().AFInAppEventType();
                aFg1zSDKMo785i.valueOf = System.currentTimeMillis();
                AFf1bSDK aFf1bSDK = aFg1zSDKMo785i.values;
                StringBuilder sb2 = new StringBuilder();
                sb2.append(AFb1lSDK.values(aFd1rSDKAFInAppEventType.AFKeystoreWrapper, aFd1rSDKAFInAppEventType.AFInAppEventParameterName));
                sb2.append(aFg1zSDKMo785i.valueOf);
                byte[] bArrValueOf = AFb1mSDK.valueOf(sb2.toString());
                if (bArrValueOf == null || bArrValueOf.length <= 0) {
                    j = -1;
                } else {
                    int i7 = afErrorLog + 123;
                    afRDLog = i7 % 128;
                    int i8 = i7 % 2;
                    if (bArrValueOf.length > 8) {
                        bArrValueOf = Arrays.copyOfRange(bArrValueOf, 0, 8);
                    }
                    ByteBuffer byteBufferAllocate = ByteBuffer.allocate(8);
                    byteBufferAllocate.put(bArrValueOf);
                    byteBufferAllocate.flip();
                    j = byteBufferAllocate.getLong();
                }
                aFg1zSDKMo785i.AFInAppEventParameterName = aFf1bSDK.AFKeystoreWrapper(j, aFg1zSDKMo785i.AFKeystoreWrapper.AFInAppEventParameterName, new AFf1bSDK.AFa1uSDK() {
                    public C08645() {
                    }

                    @Override
                    public final void AFKeystoreWrapper(String str2, String str3) {
                        AFg1zSDK.this.AFInAppEventType = new ConcurrentHashMap();
                        AFg1zSDK.this.AFInAppEventType.put("signedData", str2);
                        AFg1zSDK.this.AFInAppEventType.put("signature", str3);
                        AFg1zSDK.this.AFInAppEventParameterName();
                        AFLogger.afInfoLog("Successfully retrieved Google LVL data.");
                    }

                    @Override
                    public final void AFInAppEventParameterName(String str2, Exception exc) {
                        AFg1zSDK.this.AFInAppEventType = new ConcurrentHashMap();
                        String message = exc.getMessage();
                        if (message == null) {
                            message = "unknown";
                        }
                        AFg1zSDK.this.AFInAppEventParameterName();
                        AFg1zSDK.this.AFInAppEventType.put("error", message);
                        AFLogger.afErrorLog(str2, exc, true, true, false);
                    }
                });
            } else {
                AFLogger.INSTANCE.m804w(AFg1hSDK.REFERRER, "context is null, Google Install Referrer will be not initialized");
                int i9 = afErrorLog + 41;
                afRDLog = i9 % 128;
                int i10 = i9 % 2;
            }
            AFInAppEventType().afInfoLog().AFKeystoreWrapper("init", str, appsFlyerConversionListener == null ? "null" : "conversionDataListener");
            AFLogger.INSTANCE.force(AFg1hSDK.GENERAL, String.format("Initializing AppsFlyer SDK: (v%s.%s)", "6.13.0", AFInAppEventType));
            this.values = appsFlyerConversionListener;
        }
        return this;
    }

    @Override
    public final void enableFacebookDeferredApplinks(boolean z) {
        int i = 2 % 2;
        int i2 = afRDLog + 89;
        afErrorLog = i2 % 128;
        int i3 = i2 % 2;
        AFInAppEventType().afDebugLog().valueOf(z);
        int i4 = afErrorLog + 55;
        afRDLog = i4 % 128;
        if (i4 % 2 != 0) {
            int i5 = 93 / 0;
        }
    }

    @Override
    public final void start(Context context) {
        int i = 2 % 2;
        int i2 = afRDLog + 77;
        afErrorLog = i2 % 128;
        int i3 = i2 % 2;
        start(context, null);
        int i4 = afErrorLog + 33;
        afRDLog = i4 % 128;
        if (i4 % 2 != 0) {
            throw null;
        }
    }

    @Override
    public final void start(Context context, String str) {
        int i = 2 % 2;
        int i2 = afErrorLog + 11;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        start(context, str, null);
        int i4 = afErrorLog + 125;
        afRDLog = i4 % 128;
        int i5 = i4 % 2;
    }

    @Override
    public final void start(Context context, String str, final AppsFlyerRequestListener appsFlyerRequestListener) {
        Application applicationValues;
        int i = 2 % 2;
        int i2 = afErrorLog + 117;
        afRDLog = i2 % 128;
        if (i2 % 2 != 0) {
            AFInAppEventType().afLogForce().valueOf();
            throw null;
        }
        if (AFInAppEventType().afLogForce().valueOf()) {
            return;
        }
        if (!this.afInfoLog) {
            AFLogger.afWarnLog("ERROR: AppsFlyer SDK is not initialized! The API call 'start()' must be called after the 'init(String, AppsFlyerConversionListener)' API method, which should be called on the Application's onCreate.");
            if (str == null) {
                if (appsFlyerRequestListener != null) {
                    int i3 = afErrorLog + 43;
                    afRDLog = i3 % 128;
                    if (i3 % 2 != 0) {
                        appsFlyerRequestListener.onError(8, "No dev key");
                        return;
                    } else {
                        appsFlyerRequestListener.onError(41, "No dev key");
                        return;
                    }
                }
                return;
            }
        }
        AFInAppEventType(context);
        final AFg1bSDK aFg1bSDKUnregisterClient = AFInAppEventType().unregisterClient();
        aFg1bSDKUnregisterClient.AFInAppEventParameterName(AFa1oSDK.AFKeystoreWrapper(context));
        if (this.f310i == null) {
            int i4 = afErrorLog + 47;
            afRDLog = i4 % 128;
            if (i4 % 2 != 0) {
                applicationValues = AFb1qSDK.values(context);
                int i5 = 68 / 0;
                if (applicationValues == null) {
                    return;
                }
            } else {
                applicationValues = AFb1qSDK.values(context);
                if (applicationValues == null) {
                    return;
                }
            }
            this.f310i = applicationValues;
        }
        AFInAppEventType().afInfoLog().AFKeystoreWrapper("start", str);
        AFLogger aFLogger = AFLogger.INSTANCE;
        AFg1hSDK aFg1hSDK = AFg1hSDK.GENERAL;
        String str2 = AFInAppEventType;
        aFLogger.m802i(aFg1hSDK, String.format("Starting AppsFlyer: (v%s.%s)", "6.13.0", str2));
        AFLogger aFLogger2 = AFLogger.INSTANCE;
        AFg1hSDK aFg1hSDK2 = AFg1hSDK.GENERAL;
        StringBuilder sb = new StringBuilder("Build Number: ");
        sb.append(str2);
        aFLogger2.m802i(aFg1hSDK2, sb.toString());
        AppsFlyerProperties.getInstance().loadProperties(AFInAppEventType().AFKeystoreWrapper());
        if (!TextUtils.isEmpty(str)) {
            int i6 = afErrorLog + 105;
            afRDLog = i6 % 128;
            int i7 = i6 % 2;
            AFInAppEventType().mo785i().registerClient = str;
            AFb1bSDK.AFInAppEventParameterName(str);
        } else if (TextUtils.isEmpty(AFInAppEventType().mo785i().registerClient)) {
            AFLogger.afWarnLog("ERROR: AppsFlyer SDK is not initialized! You must provide AppsFlyer Dev-Key either in the 'init' API method (should be called on Application's onCreate),or in the start() API (should be called on Activity's onCreate).");
            if (appsFlyerRequestListener != null) {
                appsFlyerRequestListener.onError(41, "No dev key");
                return;
            }
            return;
        }
        AFInAppEventType().mo784e().values(registerClient());
        m776e();
        AFKeystoreWrapper(this.f310i.getBaseContext());
        AFInAppEventType().afDebugLog().AFKeystoreWrapper();
        this.force.afLogForce().AFKeystoreWrapper(context, new AFd1ySDK.AFa1ySDK() {
            @Override
            public final void valueOf(AFh1zSDK aFh1zSDK) {
                aFg1bSDKUnregisterClient.AFInAppEventParameterName();
                AFd1nSDK aFd1nSDKAFInAppEventType = AFb1vSDK.this.AFInAppEventType();
                aFd1nSDKAFInAppEventType.mo784e().values(AFb1vSDK.values(AFb1vSDK.this));
                AFb1vSDK.AFKeystoreWrapper(AFb1vSDK.this);
                int iValueOf = aFd1nSDKAFInAppEventType.AFInAppEventType().AFInAppEventParameterName.valueOf("appsFlyerCount", 0);
                AFLogger.afInfoLog("onBecameForeground");
                if (iValueOf < 2) {
                    AFb1vSDK.this.AFInAppEventType().AFLogger().valueOf();
                }
                AFh1sSDK aFh1sSDK = new AFh1sSDK();
                if (aFh1zSDK != null) {
                    AFb1vSDK.this.AFInAppEventType().afErrorLog().AFInAppEventType(AFc1oSDK.valueOf(aFh1sSDK), aFh1zSDK.valueOf, aFd1nSDKAFInAppEventType.mo786v().AFInAppEventParameterName);
                }
                AFb1vSDK aFb1vSDK = AFb1vSDK.this;
                aFh1sSDK.valueOf = appsFlyerRequestListener;
                aFb1vSDK.AFInAppEventType(aFh1sSDK, aFh1zSDK);
            }

            @Override
            public final void AFInAppEventParameterName() {
                Context context2 = AFb1vSDK.this.AFInAppEventType().mo786v().AFInAppEventParameterName;
                AFLogger.afInfoLog("onBecameBackground");
                AFg1bSDK aFg1bSDK = aFg1bSDKUnregisterClient;
                long jCurrentTimeMillis = System.currentTimeMillis();
                if (aFg1bSDK.unregisterClient != 0) {
                    long j = jCurrentTimeMillis - aFg1bSDK.unregisterClient;
                    if (j > 0 && j < 1000) {
                        j = 1000;
                    }
                    aFg1bSDK.f379i = TimeUnit.MILLISECONDS.toSeconds(j);
                    aFg1bSDK.AFKeystoreWrapper.AFInAppEventParameterName("prev_session_dur", aFg1bSDK.f379i);
                } else {
                    AFLogger.afInfoLog("Metrics: fg ts is missing");
                }
                AFLogger.afInfoLog("callStatsBackground background call");
                AFb1vSDK.this.AFInAppEventType().init().values();
                AFb1cSDK aFb1cSDKAfInfoLog = AFb1vSDK.this.AFInAppEventType().afInfoLog();
                if (aFb1cSDKAfInfoLog.mo766e()) {
                    aFb1cSDKAfInfoLog.valueOf();
                    if (context2 != null && !AppsFlyerLib.getInstance().isStopped()) {
                        aFb1cSDKAfInfoLog.AFKeystoreWrapper(context2.getPackageName(), context2.getPackageManager());
                    }
                    aFb1cSDKAfInfoLog.values();
                } else {
                    AFLogger.afDebugLog("RD status is OFF");
                }
                AFb1vSDK.this.AFInAppEventType().AFLogger().AFInAppEventParameterName();
                AFb1vSDK.this.AFInAppEventType().AppsFlyer2dXConversionCallback().AFInAppEventParameterName();
            }
        });
    }

    private static void AFKeystoreWrapper(Context context) {
        int i = 2 % 2;
        int i2 = afRDLog + 65;
        afErrorLog = i2 % 128;
        try {
            if (i2 % 2 == 0) {
                if ((context.getPackageManager().getPackageInfo(context.getPackageName(), 0).applicationInfo.flags & 32768) == 0) {
                    return;
                }
            } else if ((context.getPackageManager().getPackageInfo(context.getPackageName(), 0).applicationInfo.flags & 32768) == 0) {
                return;
            }
            if (context.getResources().getIdentifier("appsflyer_backup_rules", "xml", context.getPackageName()) != 0) {
                AFLogger.INSTANCE.mo761i(AFg1hSDK.GENERAL, "appsflyer_backup_rules.xml detected, using AppsFlyer defined backup rules for AppsFlyer SDK data", true);
                int i3 = afErrorLog + 19;
                afRDLog = i3 % 128;
                int i4 = i3 % 2;
                return;
            }
            AFLogger.INSTANCE.mo763w(AFg1hSDK.GENERAL, "'allowBackup' is set to true; appsflyer_backup_rules.xml not detected.\nAppsFlyer shared preferences should be excluded from auto backup by adding: <exclude domain=\"sharedpref\" path=\"appsflyer-data\"/> to the Application's <full-backup-content> rules", true);
        } catch (Exception e) {
            AFLogger.INSTANCE.m800e(AFg1hSDK.GENERAL, "checkBackupRules Exception", e, false, false);
            AFLogger.INSTANCE.m803v(AFg1hSDK.GENERAL, "checkBackupRules Exception: ".concat(String.valueOf(e)));
        }
    }

    public static String AFInAppEventParameterName() {
        int i = 2 % 2;
        int i2 = afErrorLog + 83;
        afRDLog = i2 % 128;
        Object obj = null;
        if (i2 % 2 != 0) {
            values(AppsFlyerProperties.APP_USER_ID);
            throw null;
        }
        String strValues = values(AppsFlyerProperties.APP_USER_ID);
        int i3 = afRDLog + 111;
        afErrorLog = i3 % 128;
        if (i3 % 2 != 0) {
            return strValues;
        }
        obj.hashCode();
        throw null;
    }

    @Override
    public final void setCustomerUserId(String str) {
        int i = 2 % 2;
        int i2 = afRDLog + 63;
        afErrorLog = i2 % 128;
        int i3 = i2 % 2;
        AFInAppEventType().afInfoLog().AFKeystoreWrapper("setCustomerUserId", str);
        AFLogger.afInfoLog("setCustomerUserId = ".concat(String.valueOf(str)));
        AFInAppEventType(AppsFlyerProperties.APP_USER_ID, str);
        valueOf(AppsFlyerProperties.AF_WAITFOR_CUSTOMERID, false);
        int i4 = afErrorLog + 51;
        afRDLog = i4 % 128;
        if (i4 % 2 != 0) {
            int i5 = 89 / 0;
        }
    }

    @Override
    public final void setAppId(String str) {
        int i = 2 % 2;
        int i2 = afRDLog + 63;
        afErrorLog = i2 % 128;
        if (i2 % 2 == 0) {
            AFb1cSDK aFb1cSDKAfInfoLog = AFInAppEventType().afInfoLog();
            String[] strArr = new String[0];
            strArr[1] = str;
            aFb1cSDKAfInfoLog.AFKeystoreWrapper("setAppId", strArr);
        } else {
            AFInAppEventType().afInfoLog().AFKeystoreWrapper("setAppId", str);
        }
        AFInAppEventType(AppsFlyerProperties.APP_ID, str);
        int i3 = afRDLog + 121;
        afErrorLog = i3 % 128;
        if (i3 % 2 == 0) {
            throw null;
        }
    }

    @Override
    public final void setExtension(String str) {
        int i = 2 % 2;
        int i2 = afErrorLog + 55;
        afRDLog = i2 % 128;
        if (i2 % 2 != 0) {
            AFb1cSDK aFb1cSDKAfInfoLog = AFInAppEventType().afInfoLog();
            String[] strArr = new String[0];
            strArr[0] = str;
            aFb1cSDKAfInfoLog.AFKeystoreWrapper("setExtension", strArr);
        } else {
            AFInAppEventType().afInfoLog().AFKeystoreWrapper("setExtension", str);
        }
        AppsFlyerProperties.getInstance().set(AppsFlyerProperties.EXTENSION, str);
    }

    @Override
    public final void setIsUpdate(boolean z) {
        int i = 2 % 2;
        int i2 = afErrorLog + 91;
        afRDLog = i2 % 128;
        if (i2 % 2 != 0) {
            AFInAppEventType().afInfoLog().AFKeystoreWrapper("setIsUpdate", String.valueOf(z));
        } else {
            AFInAppEventType().afInfoLog().AFKeystoreWrapper("setIsUpdate", String.valueOf(z));
        }
        AppsFlyerProperties.getInstance().set(AppsFlyerProperties.IS_UPDATE, z);
    }

    @Override
    public final void setCurrencyCode(String str) {
        int i = 2 % 2;
        int i2 = afErrorLog + 49;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        AFInAppEventType().afInfoLog().AFKeystoreWrapper("setCurrencyCode", str);
        AppsFlyerProperties.getInstance().set(AppsFlyerProperties.CURRENCY_CODE, str);
        int i4 = afErrorLog + 71;
        afRDLog = i4 % 128;
        int i5 = i4 % 2;
    }

    @Override
    public final void logLocation(Context context, double d, double d2) {
        int i = 2 % 2;
        AFInAppEventType().afInfoLog().AFKeystoreWrapper("logLocation", String.valueOf(d), String.valueOf(d2));
        HashMap map = new HashMap();
        map.put(AFInAppEventParameterName.LONGITUDE, Double.toString(d2));
        map.put(AFInAppEventParameterName.LATITUDE, Double.toString(d));
        values(context, AFInAppEventType.LOCATION_COORDINATES, map);
        int i2 = afRDLog + 89;
        afErrorLog = i2 % 128;
        if (i2 % 2 == 0) {
            throw null;
        }
    }

    @Override
    public final void logSession(Context context) {
        int i = 2 % 2;
        int i2 = afRDLog + 27;
        afErrorLog = i2 % 128;
        int i3 = i2 % 2;
        AFInAppEventType().afInfoLog().AFKeystoreWrapper("logSession", new String[0]);
        AFInAppEventType().afInfoLog().AFInAppEventParameterName();
        AFKeystoreWrapper(context, AFh1ySDK.logSession);
        Object obj = null;
        values(context, null, null);
        int i4 = afErrorLog + 123;
        afRDLog = i4 % 128;
        if (i4 % 2 == 0) {
            return;
        }
        obj.hashCode();
        throw null;
    }

    private void AFKeystoreWrapper(Context context, AFh1ySDK aFh1ySDK) {
        int i = 2 % 2;
        int i2 = afErrorLog + 35;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        AFInAppEventType(context);
        AFg1bSDK aFg1bSDKUnregisterClient = AFInAppEventType().unregisterClient();
        AFg1fSDK aFg1fSDKAFKeystoreWrapper = AFa1oSDK.AFKeystoreWrapper(context);
        if (aFg1bSDKUnregisterClient.values()) {
            int i4 = afErrorLog + 23;
            afRDLog = i4 % 128;
            int i5 = i4 % 2;
            aFg1bSDKUnregisterClient.AFInAppEventParameterName.put("api_name", aFh1ySDK.toString());
            aFg1bSDKUnregisterClient.AFInAppEventParameterName(aFg1fSDKAFKeystoreWrapper);
            int i6 = afRDLog + 107;
            afErrorLog = i6 % 128;
            int i7 = i6 % 2;
        }
        aFg1bSDKUnregisterClient.AFInAppEventParameterName();
    }

    @Override
    public final void sendAdRevenue(Context context, Map<String, Object> map) {
        int i = 2 % 2;
        int iValues = values(valueOf(context));
        HashMap map2 = new HashMap();
        map2.put("ad_network", map);
        map2.put("adrevenue_counter", Integer.valueOf(iValues));
        AFInAppEventType(context, map2, new AFg1aSDK());
        int i2 = afErrorLog + 85;
        afRDLog = i2 % 128;
        if (i2 % 2 == 0) {
            return;
        }
        Object obj = null;
        obj.hashCode();
        throw null;
    }

    @Override
    public final void sendAdImpression(Context context, Map<String, Object> map) {
        int i = 2 % 2;
        int iAFKeystoreWrapper = AFKeystoreWrapper(valueOf(context));
        HashMap map2 = new HashMap();
        map2.put("ad_network", map);
        map2.put("adimpression_counter", Integer.valueOf(iAFKeystoreWrapper));
        AFInAppEventType(context, map2, new AFg1cSDK());
        int i2 = afErrorLog + 43;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
    }

    private void AFInAppEventType(Context context, Map<String, Object> map, AFa1pSDK aFa1pSDK) {
        int i = 2 % 2;
        int i2 = afRDLog + 85;
        afErrorLog = i2 % 128;
        int i3 = i2 % 2;
        AFInAppEventType(context);
        aFa1pSDK.AFInAppEventType((Map<String, ?>) map);
        AFInAppEventType(aFa1pSDK, m775e(context));
        int i4 = afRDLog + 75;
        afErrorLog = i4 % 128;
        int i5 = i4 % 2;
    }

    @Override
    public final void logEvent(Context context, String str, Map<String, Object> map) {
        int i = 2 % 2;
        int i2 = afRDLog + 123;
        afErrorLog = i2 % 128;
        int i3 = i2 % 2;
        logEvent(context, str, map, null);
        if (i3 == 0) {
            int i4 = 92 / 0;
        }
        int i5 = afRDLog + 93;
        afErrorLog = i5 % 128;
        int i6 = i5 % 2;
    }

    private AFh1zSDK m775e(Context context) {
        int i = 2 % 2;
        int i2 = afRDLog;
        int i3 = i2 + 43;
        afErrorLog = i3 % 128;
        Object obj = null;
        if (i3 % 2 != 0) {
            if (context instanceof Activity) {
                return new AFh1zSDK((Activity) context, AFInAppEventType().afErrorLogForExcManagerOnly());
            }
            int i4 = i2 + 47;
            afErrorLog = i4 % 128;
            if (i4 % 2 != 0) {
                return null;
            }
            throw null;
        }
        boolean z = context instanceof Activity;
        obj.hashCode();
        throw null;
    }

    private void values(Context context, String str, Map<String, Object> map) {
        int i = 2 % 2;
        AFh1uSDK aFh1uSDK = new AFh1uSDK();
        aFh1uSDK.AFLogger = str;
        aFh1uSDK.AFInAppEventParameterName = map;
        AFInAppEventType(aFh1uSDK, m775e(context));
        int i2 = afRDLog + 5;
        afErrorLog = i2 % 128;
        if (i2 % 2 == 0) {
            int i3 = 65 / 0;
        }
    }

    final void AFInAppEventType(AFa1pSDK aFa1pSDK, AFh1zSDK aFh1zSDK) {
        int i = 2 % 2;
        int i2 = afErrorLog + 27;
        afRDLog = i2 % 128;
        if (i2 % 2 != 0) {
            AFInAppEventParameterName(aFa1pSDK, aFh1zSDK);
            String str = AFInAppEventType().mo785i().registerClient;
            Object obj = null;
            obj.hashCode();
            throw null;
        }
        AFInAppEventParameterName(aFa1pSDK, aFh1zSDK);
        if (AFInAppEventType().mo785i().registerClient == null) {
            AFLogger.afWarnLog("[LogEvent/Launch] AppsFlyer's SDK cannot send any event without providing DevKey.");
            AppsFlyerRequestListener appsFlyerRequestListener = aFa1pSDK.valueOf;
            if (appsFlyerRequestListener != null) {
                int i3 = afErrorLog + 59;
                afRDLog = i3 % 128;
                appsFlyerRequestListener.onError(i3 % 2 != 0 ? 116 : 41, "No dev key");
                return;
            }
            return;
        }
        String referrer = AppsFlyerProperties.getInstance().getReferrer(AFInAppEventType().AFKeystoreWrapper());
        if (referrer == null) {
            int i4 = afRDLog + 121;
            afErrorLog = i4 % 128;
            int i5 = i4 % 2;
            referrer = "";
        }
        aFa1pSDK.f295e = referrer;
        AFInAppEventType(aFa1pSDK);
    }

    @Override
    public final void anonymizeUser(boolean z) {
        int i = 2 % 2;
        int i2 = afErrorLog + 67;
        afRDLog = i2 % 128;
        if (i2 % 2 != 0) {
            AFb1cSDK aFb1cSDKAfInfoLog = AFInAppEventType().afInfoLog();
            String[] strArr = new String[0];
            strArr[1] = String.valueOf(z);
            aFb1cSDKAfInfoLog.AFKeystoreWrapper("anonymizeUser", strArr);
        } else {
            AFInAppEventType().afInfoLog().AFKeystoreWrapper("anonymizeUser", String.valueOf(z));
        }
        AppsFlyerProperties.getInstance().set(AppsFlyerProperties.DEVICE_TRACKING_DISABLED, z);
        int i3 = afRDLog + 103;
        afErrorLog = i3 % 128;
        int i4 = i3 % 2;
    }

    @Override
    public final void registerConversionListener(Context context, AppsFlyerConversionListener appsFlyerConversionListener) {
        int i = 2 % 2;
        int i2 = afErrorLog + TypedValues.TYPE_TARGET;
        afRDLog = i2 % 128;
        if (i2 % 2 != 0) {
            AFInAppEventType().afInfoLog().AFKeystoreWrapper("registerConversionListener", new String[1]);
        } else {
            AFInAppEventType().afInfoLog().AFKeystoreWrapper("registerConversionListener", new String[0]);
        }
        AFKeystoreWrapper(appsFlyerConversionListener);
    }

    private void AFKeystoreWrapper(AppsFlyerConversionListener appsFlyerConversionListener) {
        int i = 2 % 2;
        int i2 = afErrorLog + 13;
        afRDLog = i2 % 128;
        if (i2 % 2 != 0) {
            throw null;
        }
        if (appsFlyerConversionListener == null) {
            return;
        }
        this.values = appsFlyerConversionListener;
        int i3 = afRDLog + 43;
        afErrorLog = i3 % 128;
        int i4 = i3 % 2;
    }

    @Override
    public final void unregisterConversionListener() {
        int i = 2 % 2;
        int i2 = afErrorLog + 43;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        AFInAppEventType().afInfoLog().AFKeystoreWrapper("unregisterConversionListener", new String[0]);
        this.values = null;
        int i4 = afErrorLog + 81;
        afRDLog = i4 % 128;
        int i5 = i4 % 2;
    }

    @Override
    public final void registerValidatorListener(Context context, AppsFlyerInAppPurchaseValidatorListener appsFlyerInAppPurchaseValidatorListener) {
        int i = 2 % 2;
        AFInAppEventType().afInfoLog().AFKeystoreWrapper("registerValidatorListener", new String[0]);
        AFLogger.afDebugLog("registerValidatorListener called");
        if (appsFlyerInAppPurchaseValidatorListener == null) {
            int i2 = afRDLog + 109;
            afErrorLog = i2 % 128;
            int i3 = i2 % 2;
            AFLogger.afDebugLog("registerValidatorListener null listener");
            return;
        }
        valueOf = appsFlyerInAppPurchaseValidatorListener;
        int i4 = afRDLog + 7;
        afErrorLog = i4 % 128;
        int i5 = i4 % 2;
    }

    public static String valueOf(SimpleDateFormat simpleDateFormat, long j) {
        int i = 2 % 2;
        simpleDateFormat.setTimeZone(DesugarTimeZone.getTimeZone("UTC"));
        String str = simpleDateFormat.format(new Date(j));
        int i2 = afErrorLog + 125;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        return str;
    }

    private void valueOf(Context context, String str) {
        int i = 2 % 2;
        AFh1sSDK aFh1sSDK = new AFh1sSDK();
        AFInAppEventType(context);
        Object obj = null;
        aFh1sSDK.AFLogger = null;
        aFh1sSDK.AFInAppEventParameterName = null;
        aFh1sSDK.f295e = str;
        aFh1sSDK.AFInAppEventType = null;
        AFInAppEventType(aFh1sSDK);
        int i2 = afErrorLog + 97;
        afRDLog = i2 % 128;
        if (i2 % 2 == 0) {
            return;
        }
        obj.hashCode();
        throw null;
    }

    private void AFInAppEventType(AFa1pSDK aFa1pSDK) {
        boolean z;
        int i = 2 % 2;
        byte b = 0;
        if (aFa1pSDK.AFLogger == null) {
            int i2 = afErrorLog;
            int i3 = i2 + TypedValues.TYPE_TARGET;
            afRDLog = i3 % 128;
            z = i3 % 2 == 0;
            int i4 = i2 + 85;
            afRDLog = i4 % 128;
            int i5 = i4 % 2;
        } else {
            z = false;
        }
        if (!(!values())) {
            AFLogger.afInfoLog("CustomerUserId not set, reporting is disabled", true);
            return;
        }
        if (z) {
            if (AppsFlyerProperties.getInstance().getBoolean(AppsFlyerProperties.LAUNCH_PROTECT_ENABLED, true)) {
                int i6 = afRDLog + 57;
                afErrorLog = i6 % 128;
                int i7 = i6 % 2;
                if (AFLogger()) {
                    AppsFlyerRequestListener appsFlyerRequestListener = aFa1pSDK.valueOf;
                    if (appsFlyerRequestListener != null) {
                        appsFlyerRequestListener.onError(10, "Event timeout. Check 'minTimeBetweenSessions' param");
                    }
                    int i8 = afRDLog + 35;
                    afErrorLog = i8 % 128;
                    int i9 = i8 % 2;
                    return;
                }
            } else {
                AFLogger.afInfoLog("Allowing multiple launches within a 5 second time window.");
            }
            this.unregisterClient = System.currentTimeMillis();
        }
        AFi1bSDK.AFInAppEventType(AFInAppEventType().valueOf(), new AFa1uSDK(this, aFa1pSDK, b), 0L, TimeUnit.MILLISECONDS);
    }

    private boolean AFLogger() {
        int i = 2 % 2;
        int i2 = afErrorLog + 91;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        if (this.unregisterClient > 0) {
            long jCurrentTimeMillis = System.currentTimeMillis() - this.unregisterClient;
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss.SSS Z", Locale.US);
            String strValueOf = valueOf(simpleDateFormat, this.unregisterClient);
            String strValueOf2 = valueOf(simpleDateFormat, this.AFLogger);
            if (jCurrentTimeMillis < this.f309e) {
                int i4 = afErrorLog + 95;
                afRDLog = i4 % 128;
                int i5 = i4 % 2;
                if (!isStopped()) {
                    AFLogger.afInfoLog(String.format(Locale.US, "Last Launch attempt: %s;\nLast successful Launch event: %s;\nThis launch is blocked: %s ms < %s ms", strValueOf, strValueOf2, Long.valueOf(jCurrentTimeMillis), Long.valueOf(this.f309e)));
                    return true;
                }
            }
            if (!isStopped()) {
                int i6 = afErrorLog + 109;
                afRDLog = i6 % 128;
                int i7 = i6 % 2;
                AFLogger.afInfoLog(String.format(Locale.US, "Last Launch attempt: %s;\nLast successful Launch event: %s;\nSending launch (+%s ms)", strValueOf, strValueOf2, Long.valueOf(jCurrentTimeMillis)));
            }
        } else if (!isStopped()) {
            int i8 = afRDLog + 107;
            afErrorLog = i8 % 128;
            int i9 = i8 % 2;
            AFLogger.afInfoLog("Sending first launch for this session!");
        }
        int i10 = afRDLog + 75;
        afErrorLog = i10 % 128;
        if (i10 % 2 != 0) {
            return false;
        }
        Object obj = null;
        obj.hashCode();
        throw null;
    }

    private void AFInAppEventType(String str) {
        int i = 2 % 2;
        byte b = 0;
        AFa1pSDK aFa1pSDKAFInAppEventType = new AFh1xSDK().AFInAppEventType(AFInAppEventType().AFInAppEventType().AFInAppEventParameterName.valueOf("appsFlyerCount", 0));
        aFa1pSDKAFInAppEventType.f295e = str;
        if (str != null) {
            int i2 = afErrorLog + 89;
            afRDLog = i2 % 128;
            int i3 = i2 % 2;
            if (str.length() > 5 && AFInAppEventType().force().AFInAppEventParameterName(aFa1pSDKAFInAppEventType)) {
                AFi1bSDK.AFInAppEventType(AFInAppEventType().valueOf(), new AFa1uSDK(this, aFa1pSDKAFInAppEventType, b), 5L, TimeUnit.MILLISECONDS);
                int i4 = afErrorLog + 29;
                afRDLog = i4 % 128;
                int i5 = i4 % 2;
            }
        }
        int i6 = afErrorLog + 111;
        afRDLog = i6 % 128;
        if (i6 % 2 == 0) {
            return;
        }
        Object obj = null;
        obj.hashCode();
        throw null;
    }

    private void values(AFa1pSDK aFa1pSDK) {
        String strAFInAppEventParameterName;
        int i = 2 % 2;
        Context context = AFInAppEventType().mo786v().AFInAppEventParameterName;
        if (context == null) {
            AFLogger.afDebugLog("sendWithEvent - got null context. skipping event/launch.");
            return;
        }
        String str = AFInAppEventType().mo785i().registerClient;
        if (str == null || str.length() == 0) {
            AFLogger.afInfoLog("AppsFlyer dev key is missing!!! Please use  AppsFlyerLib.getInstance().setAppsFlyerKey(...) to set it. ");
            AFLogger.afInfoLog("AppsFlyer will not track this event.");
            return;
        }
        AFd1xSDK aFd1xSDKValueOf = valueOf(context);
        AppsFlyerProperties.getInstance().saveProperties(aFd1xSDKValueOf);
        if (!AFInAppEventType().mo785i().valueOf()) {
            StringBuilder sb = new StringBuilder("sendWithEvent from activity: ");
            sb.append(context.getClass().getName());
            AFLogger.afInfoLog(sb.toString());
        }
        boolean zValueOf = aFa1pSDK.valueOf();
        Map<String, ?> mapAFKeystoreWrapper = AFKeystoreWrapper(aFa1pSDK);
        AppsFlyerRequestListener appsFlyerRequestListener = aFa1pSDK.valueOf;
        String str2 = (String) mapAFKeystoreWrapper.get("appsflyerKey");
        if (str2 == null || str2.length() == 0) {
            AFLogger.afDebugLog("Not sending data yet, waiting for dev key");
            if (appsFlyerRequestListener != null) {
                appsFlyerRequestListener.onError(41, "No dev key");
            }
            int i2 = afRDLog + 117;
            afErrorLog = i2 % 128;
            int i3 = i2 % 2;
            return;
        }
        if (!isStopped()) {
            AFLogger.afInfoLog("AppsFlyerLib.sendWithEvent");
        }
        int i4 = 0;
        int iAFInAppEventType = AFInAppEventType(aFd1xSDKValueOf, false);
        AFi1cSDK aFi1cSDK = new AFi1cSDK(AFInAppEventType().AFInAppEventType());
        Intrinsics.checkNotNullParameter(aFa1pSDK, "");
        boolean zValueOf2 = aFa1pSDK.valueOf();
        boolean z = aFa1pSDK instanceof AFg1aSDK;
        boolean z2 = aFa1pSDK instanceof AFg1cSDK;
        boolean z3 = aFa1pSDK instanceof AFh1xSDK;
        if ((aFa1pSDK instanceof AFh1wSDK) || z3) {
            strAFInAppEventParameterName = aFi1cSDK.values.AFInAppEventParameterName(AFi1cSDK.AFInAppEventParameterName);
        } else if (z2) {
            strAFInAppEventParameterName = aFi1cSDK.values.AFInAppEventParameterName(AFi1cSDK.AFInAppEventType);
        } else if (z) {
            int i5 = afErrorLog + 1;
            afRDLog = i5 % 128;
            if (i5 % 2 != 0) {
                strAFInAppEventParameterName = aFi1cSDK.values.AFInAppEventParameterName(AFi1cSDK.AFKeystoreWrapper);
                int i6 = 92 / 0;
            } else {
                strAFInAppEventParameterName = aFi1cSDK.values.AFInAppEventParameterName(AFi1cSDK.AFKeystoreWrapper);
            }
        } else if (!zValueOf2) {
            strAFInAppEventParameterName = aFi1cSDK.values.AFInAppEventParameterName(AFi1cSDK.registerClient);
        } else if (aFi1cSDK.valueOf.AFInAppEventParameterName.valueOf("appsFlyerCount", 0) < 2) {
            int i7 = afRDLog + 39;
            afErrorLog = i7 % 128;
            int i8 = i7 % 2;
            strAFInAppEventParameterName = aFi1cSDK.values.AFInAppEventParameterName(AFi1cSDK.AFLogger);
        } else {
            strAFInAppEventParameterName = aFi1cSDK.values.AFInAppEventParameterName(AFi1cSDK.f400e);
        }
        StringBuilder sb2 = new StringBuilder();
        sb2.append(strAFInAppEventParameterName);
        sb2.append(aFi1cSDK.valueOf.AFKeystoreWrapper.AFInAppEventParameterName.getPackageName());
        String strValueOf = aFi1cSDK.valueOf(AFi1cSDK.valueOf(sb2.toString(), z));
        AFInAppEventParameterName(mapAFKeystoreWrapper);
        AFc1tSDK aFc1tSDK = new AFc1tSDK(AFInAppEventType(), aFa1pSDK.AFKeystoreWrapper(strValueOf).AFInAppEventType(mapAFKeystoreWrapper).AFInAppEventType(iAFInAppEventType), AFInAppEventType().afDebugLog().valueOf());
        if (zValueOf) {
            int i9 = afRDLog + 19;
            afErrorLog = i9 % 128;
            int i10 = i9 % 2;
            AFi1nSDK[] aFi1nSDKArrUnregisterClient = unregisterClient();
            int length = aFi1nSDKArrUnregisterClient.length;
            int i11 = 0;
            while (i4 < length) {
                int i12 = afErrorLog + 75;
                afRDLog = i12 % 128;
                int i13 = i12 % 2;
                AFi1nSDK aFi1nSDK = aFi1nSDKArrUnregisterClient[i4];
                if (aFi1nSDK.unregisterClient == AFi1nSDK.AFa1uSDK.STARTED) {
                    StringBuilder sb3 = new StringBuilder("Failed to get ");
                    sb3.append(aFi1nSDK.AFInAppEventParameterName);
                    sb3.append(" referrer, wait ...");
                    AFLogger.afDebugLog(sb3.toString());
                    i11 = 1;
                }
                i4++;
            }
            if (AFInAppEventType().afDebugLog().AFInAppEventType()) {
                AFLogger.afDebugLog("fetching Facebook deferred AppLink data, wait ...");
                i4 = 1;
            } else {
                i4 = i11;
            }
            if (AFInAppEventType().mo785i().AFKeystoreWrapper()) {
                i4 = 1;
            }
        }
        AFi1bSDK.AFInAppEventType(AFInAppEventType().valueOf(), aFc1tSDK, i4 != 1 ? 0L : 500L, TimeUnit.MILLISECONDS);
    }

    private void AFInAppEventParameterName(Map<String, Object> map) {
        int i = 2 % 2;
        if (AppsFlyerProperties.getInstance().getBoolean(AppsFlyerProperties.COLLECT_ANDROID_ID_FORCE_BY_USER, false)) {
            return;
        }
        int i2 = afErrorLog + 37;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        if (AppsFlyerProperties.getInstance().getBoolean(AppsFlyerProperties.COLLECT_IMEI_FORCE_BY_USER, false)) {
            return;
        }
        int i4 = afErrorLog + 71;
        afRDLog = i4 % 128;
        if (i4 % 2 != 0) {
            int i5 = 88 / 0;
            if (map.get("advertiserId") == null) {
                return;
            }
        } else if (map.get("advertiserId") == null) {
            return;
        }
        try {
            if (AFc1rSDK.AFInAppEventType(AFInAppEventType().getLevel().valueOf)) {
                int i6 = afErrorLog + 85;
                afRDLog = i6 % 128;
                int i7 = i6 % 2;
                if (map.remove("android_id") != null) {
                    AFLogger.afInfoLog("validateGaidAndIMEI :: removing: android_id");
                }
            }
            if (!AFc1rSDK.AFInAppEventType(AFInAppEventType().mo785i().unregisterClient) || map.remove("imei") == null) {
                return;
            }
            AFLogger.afInfoLog("validateGaidAndIMEI :: removing: imei");
        } catch (Exception e) {
            AFLogger.afErrorLog("failed to remove IMEI or AndroidID key from params; ", e);
        }
    }

    public String m773d(Context context) {
        int i = 2 % 2;
        int i2 = afErrorLog + 125;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        String attributionId = getAttributionId(context);
        int i4 = afRDLog + 83;
        afErrorLog = i4 % 128;
        int i5 = i4 % 2;
        return attributionId;
    }

    final Map<String, Object> AFKeystoreWrapper(AFa1pSDK aFa1pSDK) {
        int i;
        int i2 = 2 % 2;
        int i3 = afRDLog + 43;
        afErrorLog = i3 % 128;
        int i4 = i3 % 2;
        final Context context = AFInAppEventType().mo786v().AFInAppEventParameterName;
        AFd1xSDK aFd1xSDKValueOf = valueOf(context);
        AFg1qSDK aFg1qSDKMo783d = AFInAppEventType().mo783d();
        AFd1sSDK level = AFInAppEventType().getLevel();
        boolean zValueOf = aFa1pSDK.valueOf();
        Map<String, Object> map = aFa1pSDK.AFKeystoreWrapper;
        AFb1tSDK.valueOf(context, map);
        Boolean bool = AFb1tSDK.AFInAppEventParameterName;
        if (bool != null && !bool.booleanValue()) {
            AFInAppEventType(map).put("ad_ids_disabled", Boolean.TRUE);
        }
        long time = new Date().getTime();
        Object[] objArr = new Object[1];
        m772a("咄\ue195哥㢗Ԛ蕨\uf1fe⢿욁\u16ff捐암瀨梇훴埃", View.resolveSizeAndState(0, 0, 0) + 1, objArr);
        map.put(((String) objArr[0]).intern(), Long.toString(time));
        try {
            if (isStopped()) {
                AFLogger.afInfoLog("Reporting has been stopped");
                i = afRDLog + 7;
                afErrorLog = i % 128;
            } else {
                StringBuilder sb = new StringBuilder("******* sendTrackingWithEvent: ");
                sb.append(!zValueOf ? aFa1pSDK.AFLogger : "Launch");
                AFLogger.afInfoLog(sb.toString());
                i = afErrorLog + 51;
                afRDLog = i % 128;
            }
            int i5 = i % 2;
            AFLogger(context);
            aFg1qSDKMo783d.AFInAppEventParameterName(aFa1pSDK);
            aFg1qSDKMo783d.AFKeystoreWrapper(map, isPreInstalledApp(context), new Function0() {
                public final Object invoke() {
                    return this.f$0.m773d(context);
                }
            });
            if (zValueOf) {
                aFg1qSDKMo783d.valueOf(map);
                level.values = null;
            }
            aFg1qSDKMo783d.AFKeystoreWrapper(map);
            int iAFInAppEventType = AFInAppEventType(aFd1xSDKValueOf, zValueOf);
            int iAFInAppEventParameterName = AFInAppEventParameterName(aFd1xSDKValueOf, aFa1pSDK.AFLogger != null);
            if (zValueOf && iAFInAppEventType == 1) {
                int i6 = afRDLog + 89;
                afErrorLog = i6 % 128;
                int i7 = i6 % 2;
                AppsFlyerProperties.getInstance().AFInAppEventType = true;
            }
            aFg1qSDKMo783d.valueOf(map, iAFInAppEventType, iAFInAppEventParameterName);
        } catch (Throwable th) {
            AFLogger.afErrorLog(th.getLocalizedMessage(), th, true);
        }
        return map;
    }

    private static void AFLogger(Context context) {
        int i = 2 % 2;
        try {
            List listAsList = Arrays.asList(context.getPackageManager().getPackageInfo(context.getPackageName(), 4096).requestedPermissions);
            if (!listAsList.contains("android.permission.INTERNET")) {
                AFLogger.INSTANCE.m804w(AFg1hSDK.GENERAL, "Permission android.permission.INTERNET is missing in the AndroidManifest.xml");
            }
            if (!listAsList.contains("android.permission.ACCESS_NETWORK_STATE")) {
                int i2 = afErrorLog + 33;
                afRDLog = i2 % 128;
                if (i2 % 2 != 0) {
                    AFLogger.INSTANCE.m804w(AFg1hSDK.GENERAL, "Permission android.permission.ACCESS_NETWORK_STATE is missing in the AndroidManifest.xml");
                    Object obj = null;
                    try {
                        obj.hashCode();
                        throw null;
                    } catch (Throwable th) {
                        throw th;
                    }
                }
                AFLogger.INSTANCE.m804w(AFg1hSDK.GENERAL, "Permission android.permission.ACCESS_NETWORK_STATE is missing in the AndroidManifest.xml");
            }
            if (Build.VERSION.SDK_INT > 32 && !listAsList.contains("com.google.android.gms.permission.AD_ID")) {
                AFLogger.INSTANCE.m804w(AFg1hSDK.GENERAL, "Permission com.google.android.gms.permission.AD_ID is missing in the AndroidManifest.xml");
                int i3 = afRDLog + 125;
                afErrorLog = i3 % 128;
                int i4 = i3 % 2;
            }
            int i5 = afRDLog + 91;
            afErrorLog = i5 % 128;
            if (i5 % 2 == 0) {
                int i6 = 16 / 0;
            }
        } catch (Exception e) {
            AFLogger.INSTANCE.m798e(AFg1hSDK.GENERAL, "Exception while validation permissions. ", e);
        }
    }

    public static Map<String, Object> AFInAppEventType(Map<String, Object> map) {
        int i = 2 % 2;
        int i2 = afErrorLog + 103;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        if (!map.containsKey("meta")) {
            HashMap map2 = new HashMap();
            map.put("meta", map2);
            int i4 = afErrorLog + 5;
            afRDLog = i4 % 128;
            int i5 = i4 % 2;
            return map2;
        }
        int i6 = afRDLog + 79;
        afErrorLog = i6 % 128;
        int i7 = i6 % 2;
        return (Map) map.get("meta");
    }

    private static String values(Activity activity) {
        Intent intent;
        int i = 2 % 2;
        String string = null;
        if (activity != null && (intent = activity.getIntent()) != null) {
            try {
                Bundle extras = intent.getExtras();
                if (extras != null) {
                    int i2 = afRDLog + 27;
                    afErrorLog = i2 % 128;
                    if (i2 % 2 == 0) {
                        string = extras.getString("af");
                        int i3 = 42 / 0;
                        if (string != null) {
                            AFLogger.INSTANCE.m804w(AFg1hSDK.ENGAGEMENT, "Push Notification received af payload = ".concat(String.valueOf(string)));
                            extras.remove("af");
                            activity.setIntent(intent.putExtras(extras));
                        }
                    } else {
                        string = extras.getString("af");
                        if (string != null) {
                            AFLogger.INSTANCE.m804w(AFg1hSDK.ENGAGEMENT, "Push Notification received af payload = ".concat(String.valueOf(string)));
                            extras.remove("af");
                            activity.setIntent(intent.putExtras(extras));
                        }
                    }
                }
                int i4 = afErrorLog + 81;
                afRDLog = i4 % 128;
                int i5 = i4 % 2;
            } catch (Throwable th) {
                AFLogger.INSTANCE.m798e(AFg1hSDK.ENGAGEMENT, th.getMessage(), th);
            }
        }
        return string;
    }

    private static int values(AFd1xSDK aFd1xSDK) {
        int i = 2 % 2;
        int i2 = afRDLog + 77;
        afErrorLog = i2 % 128;
        int i3 = i2 % 2;
        int iValueOf = valueOf(aFd1xSDK, "appsFlyerAdRevenueCount", true);
        int i4 = afRDLog + 125;
        afErrorLog = i4 % 128;
        int i5 = i4 % 2;
        return iValueOf;
    }

    private static int AFKeystoreWrapper(AFd1xSDK aFd1xSDK) {
        int i = 2 % 2;
        int i2 = afRDLog + 21;
        afErrorLog = i2 % 128;
        int i3 = i2 % 2;
        return valueOf(aFd1xSDK, "appsFlyerAdImpressionCount", true);
    }

    public final void values(Context context, AFc1oSDK aFc1oSDK, Uri uri, Uri uri2) {
        int i = 2 % 2;
        AFInAppEventType(context);
        if (!aFc1oSDK.AFInAppEventParameterName("af_deeplink")) {
            String strValueOf = valueOf(uri.toString());
            AFc1jSDK aFc1jSDKAfErrorLog = AFInAppEventType().afErrorLog();
            if (aFc1jSDKAfErrorLog.values != null && aFc1jSDKAfErrorLog.AFInAppEventParameterName != null && strValueOf.contains(aFc1jSDKAfErrorLog.values)) {
                Uri.Builder builderBuildUpon = Uri.parse(strValueOf).buildUpon();
                Uri.Builder builderBuildUpon2 = Uri.EMPTY.buildUpon();
                for (Map.Entry<String, String> entry : aFc1jSDKAfErrorLog.AFInAppEventParameterName.entrySet()) {
                    int i2 = afErrorLog + 115;
                    afRDLog = i2 % 128;
                    int i3 = i2 % 2;
                    builderBuildUpon.appendQueryParameter(entry.getKey(), entry.getValue());
                    builderBuildUpon2.appendQueryParameter(entry.getKey(), entry.getValue());
                }
                strValueOf = builderBuildUpon.build().toString();
                String encodedQuery = builderBuildUpon2.build().getEncodedQuery();
                Intrinsics.checkNotNullParameter("appended_query_params", "");
                aFc1oSDK.AFKeystoreWrapper.put("appended_query_params", encodedQuery);
                AFc1kSDK aFc1kSDK = aFc1oSDK.values;
                if (aFc1kSDK != null) {
                    aFc1kSDK.valueOf(aFc1oSDK.AFKeystoreWrapper);
                }
            }
            Intrinsics.checkNotNullParameter("af_deeplink", "");
            aFc1oSDK.AFKeystoreWrapper.put("af_deeplink", strValueOf);
            AFc1kSDK aFc1kSDK2 = aFc1oSDK.values;
            if (aFc1kSDK2 != null) {
                aFc1kSDK2.valueOf(aFc1oSDK.AFKeystoreWrapper);
                int i4 = afRDLog + 111;
                afErrorLog = i4 % 128;
                int i5 = i4 % 2;
            }
        }
        HashMap map = new HashMap();
        map.put("link", uri.toString());
        if (uri2 != null) {
            map.put("original_link", uri2.toString());
        }
        AFb1qSDK.AFInAppEventParameterName(context, map, uri);
        AFf1mSDK aFf1mSDK = new AFf1mSDK(AFInAppEventType(), UUID.randomUUID(), uri);
        if (aFf1mSDK.afInfoLog()) {
            int i6 = afRDLog + 53;
            afErrorLog = i6 % 128;
            if (i6 % 2 == 0) {
                Boolean bool = Boolean.TRUE;
                Intrinsics.checkNotNullParameter("isBrandedDomain", "");
                aFc1oSDK.AFKeystoreWrapper.put("isBrandedDomain", bool);
                AFc1kSDK aFc1kSDK3 = aFc1oSDK.values;
                throw null;
            }
            Boolean bool2 = Boolean.TRUE;
            Intrinsics.checkNotNullParameter("isBrandedDomain", "");
            aFc1oSDK.AFKeystoreWrapper.put("isBrandedDomain", bool2);
            AFc1kSDK aFc1kSDK4 = aFc1oSDK.values;
            if (aFc1kSDK4 != null) {
                aFc1kSDK4.valueOf(aFc1oSDK.AFKeystoreWrapper);
            } else {
                int i7 = afErrorLog + 13;
                afRDLog = i7 % 128;
                int i8 = i7 % 2;
            }
        }
        if (!aFf1mSDK.m795w()) {
            AFInAppEventType().afErrorLog().AFKeystoreWrapper(map);
            return;
        }
        aFf1mSDK.registerClient = valueOf(map);
        AFe1dSDK aFe1dSDKMo787w = AFInAppEventType().mo787w();
        aFe1dSDKMo787w.values.execute(aFe1dSDKMo787w.new RunnableC08534(aFf1mSDK));
    }

    private static String valueOf(String str) {
        int i = 2 % 2;
        Object obj = null;
        if (str == null) {
            int i2 = afErrorLog + 67;
            afRDLog = i2 % 128;
            int i3 = i2 % 2;
            return null;
        }
        if (!str.matches("fb\\d*?://authorize.*")) {
            return str;
        }
        int i4 = afRDLog + 67;
        afErrorLog = i4 % 128;
        if (i4 % 2 == 0) {
            int i5 = 39 / 0;
            if (!str.contains("access_token")) {
                return str;
            }
        } else if (!str.contains("access_token")) {
            return str;
        }
        String strAFKeystoreWrapper = AFKeystoreWrapper(str);
        if (strAFKeystoreWrapper.length() == 0) {
            return str;
        }
        ArrayList arrayList = new ArrayList();
        if (strAFKeystoreWrapper.contains("&")) {
            arrayList = new ArrayList(Arrays.asList(strAFKeystoreWrapper.split("&")));
        } else {
            arrayList.add(strAFKeystoreWrapper);
        }
        StringBuilder sb = new StringBuilder();
        Iterator it = arrayList.iterator();
        while (it.hasNext()) {
            int i6 = afErrorLog + 65;
            afRDLog = i6 % 128;
            if (i6 % 2 != 0) {
                ((String) it.next()).contains("access_token");
                obj.hashCode();
                throw null;
            }
            String str2 = (String) it.next();
            if (str2.contains("access_token")) {
                it.remove();
            } else {
                if (sb.length() != 0) {
                    int i7 = afRDLog + 81;
                    afErrorLog = i7 % 128;
                    int i8 = i7 % 2;
                    sb.append("&");
                } else if (!str2.startsWith("?")) {
                    sb.append("?");
                    int i9 = afErrorLog + 81;
                    afRDLog = i9 % 128;
                    int i10 = i9 % 2;
                }
                sb.append(str2);
            }
        }
        return str.replace(strAFKeystoreWrapper, sb.toString());
    }

    private static String AFKeystoreWrapper(String str) {
        int i = 2 % 2;
        int iIndexOf = str.indexOf(63);
        if (iIndexOf != -1) {
            String strSubstring = str.substring(iIndexOf);
            int i2 = afRDLog + 11;
            afErrorLog = i2 % 128;
            if (i2 % 2 != 0) {
                return strSubstring;
            }
            throw null;
        }
        int i3 = afRDLog;
        int i4 = i3 + 91;
        afErrorLog = i4 % 128;
        int i5 = i4 % 2;
        int i6 = i3 + 61;
        afErrorLog = i6 % 128;
        int i7 = i6 % 2;
        return "";
    }

    private AFf1mSDK.AFa1vSDK valueOf(final Map<String, String> map) {
        int i = 2 % 2;
        AFf1mSDK.AFa1vSDK aFa1vSDK = new AFf1mSDK.AFa1vSDK() {
            @Override
            public final void AFInAppEventType(String str) {
                AFb1vSDK.this.AFInAppEventType().afErrorLog().values(str, DeepLinkResult.Error.NETWORK);
            }

            @Override
            public final void AFInAppEventType(Map<String, String> map2) {
                for (String str : map2.keySet()) {
                    map.put(str, map2.get(str));
                }
                AFb1vSDK.this.AFInAppEventType().afErrorLog().AFKeystoreWrapper(map);
            }
        };
        int i2 = afRDLog + 69;
        afErrorLog = i2 % 128;
        int i3 = i2 % 2;
        return aFa1vSDK;
    }

    public static boolean values(android.content.Context r5) {
        throw new UnsupportedOperationException("Method not decompiled: com.appsflyer.internal.AFb1vSDK.values(android.content.Context):boolean");
    }

    private String AFInAppEventType(Context context, String str) {
        int i = 2 % 2;
        if (context == null) {
            int i2 = afErrorLog + 19;
            afRDLog = i2 % 128;
            int i3 = i2 % 2;
            return null;
        }
        AFInAppEventType(context);
        String strValues = AFInAppEventType().AFInAppEventType().values(str);
        int i4 = afErrorLog + 29;
        afRDLog = i4 % 128;
        if (i4 % 2 != 0) {
            int i5 = 57 / 0;
        }
        return strValues;
    }

    @Override
    public final void setPreinstallAttribution(String str, String str2, String str3) {
        int i = 2 % 2;
        AFLogger.afDebugLog("setPreinstallAttribution API called");
        JSONObject jSONObject = new JSONObject();
        if (str != null) {
            try {
                jSONObject.put("pid", str);
                int i2 = afRDLog + 61;
                afErrorLog = i2 % 128;
                int i3 = i2 % 2;
                if (str2 != null) {
                    int i4 = afRDLog + 97;
                    afErrorLog = i4 % 128;
                    int i5 = i4 % 2;
                    jSONObject.put("c", str2);
                }
                if (str3 != null) {
                    jSONObject.put("af_siteid", str3);
                }
            } catch (JSONException e) {
                AFLogger.afErrorLog(e.getMessage(), e);
            }
        } else {
            if (str2 != null) {
                int i6 = afRDLog + 97;
                afErrorLog = i6 % 128;
                int i7 = i6 % 2;
                jSONObject.put("c", str2);
            }
            if (str3 != null) {
                jSONObject.put("af_siteid", str3);
            }
        }
        if (!jSONObject.has("pid")) {
            AFLogger.afWarnLog("Cannot set preinstall attribution data without a media source");
            return;
        }
        int i8 = afErrorLog + 25;
        afRDLog = i8 % 128;
        if (i8 % 2 == 0) {
            AFInAppEventType("preInstallName", jSONObject.toString());
        } else {
            AFInAppEventType("preInstallName", jSONObject.toString());
            int i9 = 6 / 0;
        }
    }

    private static void m777e(String str) {
        int i = 2 % 2;
        try {
            if (!new JSONObject(str).has("pid")) {
                AFLogger.afWarnLog("Cannot set preinstall attribution data without a media source");
                return;
            }
            int i2 = afRDLog + 65;
            afErrorLog = i2 % 128;
            int i3 = i2 % 2;
            AFInAppEventType("preInstallName", str);
            int i4 = afRDLog + 21;
            afErrorLog = i4 % 128;
            if (i4 % 2 == 0) {
                throw null;
            }
        } catch (JSONException e) {
            AFLogger.afErrorLog("Error parsing JSON for preinstall", e);
        }
    }

    @Override
    public final boolean isPreInstalledApp(Context context) {
        int i = 2 % 2;
        try {
            if ((context.getPackageManager().getApplicationInfo(context.getPackageName(), 0).flags & 1) != 0) {
                int i2 = afRDLog + 119;
                afErrorLog = i2 % 128;
                return i2 % 2 != 0;
            }
        } catch (PackageManager.NameNotFoundException e) {
            AFLogger.afErrorLog("Could not check if app is pre installed", e);
        }
        int i3 = afRDLog + 9;
        afErrorLog = i3 % 128;
        if (i3 % 2 != 0) {
            return false;
        }
        Object obj = null;
        obj.hashCode();
        throw null;
    }

    public static String AFInAppEventType(AFd1xSDK aFd1xSDK, String str) {
        int i = 2 % 2;
        Object obj = null;
        String strValueOf = aFd1xSDK.valueOf("CACHED_CHANNEL", (String) null);
        if (strValueOf == null) {
            aFd1xSDK.values("CACHED_CHANNEL", str);
            return str;
        }
        int i2 = afErrorLog + 53;
        int i3 = i2 % 128;
        afRDLog = i3;
        int i4 = i2 % 2;
        int i5 = i3 + 29;
        afErrorLog = i5 % 128;
        if (i5 % 2 != 0) {
            return strValueOf;
        }
        obj.hashCode();
        throw null;
    }

    @Override
    public final String getAttributionId(Context context) {
        int i = 2 % 2;
        Object obj = null;
        try {
            String strAFKeystoreWrapper = new AFb1jSDK(context, AFInAppEventType()).AFKeystoreWrapper();
            int i2 = afRDLog + 89;
            afErrorLog = i2 % 128;
            if (i2 % 2 != 0) {
                return strAFKeystoreWrapper;
            }
            obj.hashCode();
            throw null;
        } catch (Throwable th) {
            AFLogger.afErrorLog("Could not collect facebook attribution id. ", th);
            return null;
        }
    }

    public static synchronized SharedPreferences AFInAppEventParameterName(Context context) {
        SharedPreferences sharedPreferences;
        int i = 2 % 2;
        int i2 = afErrorLog + 111;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        if (valueOf().f312w == null) {
            int i4 = afErrorLog + 25;
            afRDLog = i4 % 128;
            StrictMode.ThreadPolicy threadPolicy = i4 % 2;
            try {
                if (threadPolicy != 0) {
                    StrictMode.ThreadPolicy threadPolicyAllowThreadDiskReads = StrictMode.allowThreadDiskReads();
                    valueOf().f312w = context.getApplicationContext().getSharedPreferences("appsflyer-data", 1);
                    threadPolicy = threadPolicyAllowThreadDiskReads;
                } else {
                    StrictMode.ThreadPolicy threadPolicyAllowThreadDiskReads2 = StrictMode.allowThreadDiskReads();
                    valueOf().f312w = context.getApplicationContext().getSharedPreferences("appsflyer-data", 0);
                    threadPolicy = threadPolicyAllowThreadDiskReads2;
                }
                StrictMode.setThreadPolicy(threadPolicy);
            } catch (Throwable th) {
                StrictMode.setThreadPolicy(threadPolicy);
                throw th;
            }
        }
        sharedPreferences = valueOf().f312w;
        int i5 = afRDLog + 83;
        afErrorLog = i5 % 128;
        int i6 = i5 % 2;
        return sharedPreferences;
    }

    public final AFd1xSDK valueOf(Context context) {
        int i = 2 % 2;
        int i2 = afRDLog + 67;
        afErrorLog = i2 % 128;
        int i3 = i2 % 2;
        AFInAppEventType(context);
        AFd1xSDK aFd1xSDKAFKeystoreWrapper = AFInAppEventType().AFKeystoreWrapper();
        int i4 = afRDLog + 17;
        afErrorLog = i4 % 128;
        if (i4 % 2 == 0) {
            int i5 = 92 / 0;
        }
        return aFd1xSDKAFKeystoreWrapper;
    }

    public static int AFInAppEventType(AFd1xSDK aFd1xSDK, boolean z) {
        int i = 2 % 2;
        int i2 = afErrorLog + 49;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        int iValueOf = valueOf(aFd1xSDK, "appsFlyerCount", z);
        int i4 = afRDLog + 71;
        afErrorLog = i4 % 128;
        int i5 = i4 % 2;
        return iValueOf;
    }

    private static int AFInAppEventParameterName(AFd1xSDK aFd1xSDK, boolean z) {
        int i = 2 % 2;
        int i2 = afErrorLog + 91;
        afRDLog = i2 % 128;
        if (i2 % 2 == 0) {
            return valueOf(aFd1xSDK, "appsFlyerInAppEventCount", z);
        }
        valueOf(aFd1xSDK, "appsFlyerInAppEventCount", z);
        throw null;
    }

    private static int valueOf(AFd1xSDK aFd1xSDK, String str, boolean z) {
        int iValueOf;
        int i = 2 % 2;
        int i2 = afRDLog + 63;
        afErrorLog = i2 % 128;
        if (i2 % 2 == 0) {
            iValueOf = aFd1xSDK.valueOf(str, 0);
            if (z) {
                iValueOf++;
                aFd1xSDK.AFInAppEventParameterName(str, iValueOf);
            }
        } else {
            iValueOf = aFd1xSDK.valueOf(str, 0);
            if (z) {
                iValueOf++;
                aFd1xSDK.AFInAppEventParameterName(str, iValueOf);
            }
        }
        int i3 = afErrorLog + 103;
        afRDLog = i3 % 128;
        if (i3 % 2 == 0) {
            return iValueOf;
        }
        Object obj = null;
        obj.hashCode();
        throw null;
    }

    @Override
    public final void validateAndLogInAppPurchase(Context context, String str, String str2, String str3, String str4, String str5, Map<String, String> map) {
        String string;
        int i = 2 % 2;
        AFb1cSDK aFb1cSDKAfInfoLog = AFInAppEventType().afInfoLog();
        if (map == null) {
            int i2 = afErrorLog + 17;
            afRDLog = i2 % 128;
            if (i2 % 2 != 0) {
                Object obj = null;
                obj.hashCode();
                throw null;
            }
            string = "";
        } else {
            string = map.toString();
        }
        aFb1cSDKAfInfoLog.AFKeystoreWrapper("validateAndTrackInAppPurchase", str, str2, str3, str4, str5, string);
        if (!isStopped()) {
            AFLogger aFLogger = AFLogger.INSTANCE;
            AFg1hSDK aFg1hSDK = AFg1hSDK.PURCHASE_VALIDATION;
            StringBuilder sb = new StringBuilder("Validate in app called with parameters: ");
            sb.append(str3);
            sb.append(" ");
            sb.append(str4);
            sb.append(" ");
            sb.append(str5);
            aFLogger.m802i(aFg1hSDK, sb.toString());
        }
        if (str != null && str4 != null && str2 != null) {
            int i3 = afErrorLog + 35;
            afRDLog = i3 % 128;
            int i4 = i3 % 2;
            if (str5 != null && str3 != null) {
                new Thread(new AFa1cSDK(context.getApplicationContext(), AFInAppEventType().mo785i().registerClient, AFInAppEventType().AFInAppEventType(), str, str2, str3, str4, str5, map)).start();
                return;
            }
        }
        AppsFlyerInAppPurchaseValidatorListener appsFlyerInAppPurchaseValidatorListener = valueOf;
        if (appsFlyerInAppPurchaseValidatorListener != null) {
            appsFlyerInAppPurchaseValidatorListener.onValidateInAppFailure("Please provide purchase parameters");
            int i5 = afRDLog + 117;
            afErrorLog = i5 % 128;
            if (i5 % 2 == 0) {
                int i6 = 57 / 0;
            }
        }
    }

    @Override
    @Deprecated
    public final boolean isStopped() {
        int i = 2 % 2;
        int i2 = afRDLog + 71;
        afErrorLog = i2 % 128;
        int i3 = i2 % 2;
        boolean zValueOf = AFInAppEventType().mo785i().valueOf();
        int i4 = afErrorLog + 49;
        afRDLog = i4 % 128;
        if (i4 % 2 != 0) {
            int i5 = 89 / 0;
        }
        return zValueOf;
    }

    @Deprecated
    public static String AFInAppEventType(HttpURLConnection httpURLConnection) {
        InputStreamReader inputStreamReader;
        int i = 2 % 2;
        StringBuilder sb = new StringBuilder();
        BufferedReader bufferedReader = null;
        try {
            try {
                InputStream errorStream = httpURLConnection.getErrorStream();
                boolean z = false;
                if (errorStream == null) {
                    int i2 = afErrorLog + 75;
                    afRDLog = i2 % 128;
                    if (i2 % 2 != 0) {
                        errorStream = httpURLConnection.getInputStream();
                        int i3 = 29 / 0;
                    } else {
                        errorStream = httpURLConnection.getInputStream();
                    }
                }
                inputStreamReader = new InputStreamReader(errorStream, Charset.defaultCharset());
                try {
                    BufferedReader bufferedReader2 = new BufferedReader(inputStreamReader);
                    while (true) {
                        try {
                            String line = bufferedReader2.readLine();
                            if (line == null) {
                                break;
                            }
                            int i4 = afErrorLog + 71;
                            afRDLog = i4 % 128;
                            int i5 = i4 % 2;
                            sb.append(z ? '\n' : "");
                            sb.append(line);
                            z = true;
                        } catch (Throwable th) {
                            th = th;
                            bufferedReader = bufferedReader2;
                            try {
                                StringBuilder sb2 = new StringBuilder("Could not read connection response from: ");
                                sb2.append(httpURLConnection.getURL().toString());
                                AFLogger.afErrorLog(sb2.toString(), th);
                                if (bufferedReader != null) {
                                    bufferedReader.close();
                                }
                                if (inputStreamReader != null) {
                                    inputStreamReader.close();
                                }
                            } catch (Throwable th2) {
                                if (bufferedReader != null) {
                                    try {
                                        bufferedReader.close();
                                        if (inputStreamReader != null) {
                                            inputStreamReader.close();
                                        }
                                    } catch (Throwable th3) {
                                        AFLogger.afErrorLogForExcManagerOnly("readServerResponse error", th3);
                                        throw th2;
                                    }
                                } else if (inputStreamReader != null) {
                                    inputStreamReader.close();
                                }
                                throw th2;
                            }
                        }
                    }
                    bufferedReader2.close();
                    inputStreamReader.close();
                    int i6 = afRDLog + 17;
                    afErrorLog = i6 % 128;
                    int i7 = i6 % 2;
                } catch (Throwable th4) {
                    th = th4;
                }
            } catch (Throwable th5) {
                th = th5;
                inputStreamReader = null;
            }
        } catch (Throwable th6) {
            AFLogger.afErrorLogForExcManagerOnly("readServerResponse error", th6);
        }
        String string = sb.toString();
        try {
            new JSONObject(string);
            return string;
        } catch (JSONException e) {
            AFLogger.afErrorLogForExcManagerOnly("error while parsing readServerResponse", e);
            JSONObject jSONObject = new JSONObject();
            try {
                jSONObject.put("string_response", string);
                return jSONObject.toString();
            } catch (JSONException e2) {
                AFLogger.afErrorLogForExcManagerOnly("RESPONSE_NOT_JSON error", e2);
                return new JSONObject().toString();
            }
        }
    }

    @Override
    public final void setLogLevel(AFLogger.LogLevel logLevel) {
        boolean z;
        int i = 2 % 2;
        if (logLevel.getLevel() > AFLogger.LogLevel.NONE.getLevel()) {
            z = true;
        } else {
            int i2 = afRDLog + TypedValues.TYPE_TARGET;
            afErrorLog = i2 % 128;
            if (i2 % 2 == 0) {
                int i3 = 5 / 3;
            }
            z = false;
        }
        AFInAppEventType().afInfoLog().AFKeystoreWrapper("log", String.valueOf(z));
        AppsFlyerProperties.getInstance().set("logLevel", logLevel.getLevel());
        if (z) {
            AFInAppEventType().AFVersionDeclaration().AFLogger();
            int i4 = afErrorLog + 59;
            afRDLog = i4 % 128;
            int i5 = i4 % 2;
            return;
        }
        int i6 = afErrorLog + 69;
        afRDLog = i6 % 128;
        int i7 = i6 % 2;
        AFInAppEventType().AFVersionDeclaration().AFInAppEventType();
        int i8 = afRDLog + 97;
        afErrorLog = i8 % 128;
        int i9 = i8 % 2;
    }

    @Override
    public final void setHost(String str, String str2) {
        String strTrim;
        int i = 2 % 2;
        if (!AFc1rSDK.AFKeystoreWrapper(str2)) {
            int i2 = afRDLog + 39;
            int i3 = i2 % 128;
            afErrorLog = i3;
            int i4 = i2 % 2;
            if (str != null) {
                int i5 = i3 + 47;
                afRDLog = i5 % 128;
                int i6 = i5 % 2;
                strTrim = str.trim();
            } else {
                strTrim = "";
            }
            AFe1jSDK.AFInAppEventParameterName(new AFe1gSDK(strTrim, str2.trim()));
            return;
        }
        AFLogger.afWarnLog("hostname was empty or null - call for setHost is skipped");
    }

    @Override
    public final String getHostName() {
        int i = 2 % 2;
        int i2 = afRDLog + 49;
        afErrorLog = i2 % 128;
        int i3 = i2 % 2;
        AFe1jSDK aFe1jSDKAfVerboseLog = AFInAppEventType().afVerboseLog();
        if (i3 != 0) {
            return aFe1jSDKAfVerboseLog.valueOf();
        }
        aFe1jSDKAfVerboseLog.valueOf();
        Object obj = null;
        obj.hashCode();
        throw null;
    }

    @Override
    public final String getHostPrefix() {
        int i = 2 % 2;
        int i2 = afRDLog + 87;
        afErrorLog = i2 % 128;
        int i3 = i2 % 2;
        AFe1jSDK aFe1jSDKAfVerboseLog = AFInAppEventType().afVerboseLog();
        if (i3 != 0) {
            return aFe1jSDKAfVerboseLog.AFInAppEventType();
        }
        aFe1jSDKAfVerboseLog.AFInAppEventType();
        Object obj = null;
        obj.hashCode();
        throw null;
    }

    @Override
    public final void setMinTimeBetweenSessions(int i) {
        int i2 = 2 % 2;
        int i3 = afErrorLog + 95;
        afRDLog = i3 % 128;
        int i4 = i3 % 2;
        this.f309e = TimeUnit.SECONDS.toMillis(i);
        int i5 = afErrorLog + 81;
        afRDLog = i5 % 128;
        int i6 = i5 % 2;
    }

    private AFi1nSDK[] unregisterClient() {
        int i = 2 % 2;
        int i2 = afErrorLog + 1;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        AFi1kSDK aFi1kSDKForce = AFInAppEventType().force();
        if (i3 == 0) {
            return aFi1kSDKForce.AFInAppEventType();
        }
        aFi1kSDKForce.AFInAppEventType();
        throw null;
    }

    class AFa1uSDK implements Runnable {
        private final AFa1pSDK valueOf;

        AFa1uSDK(AFb1vSDK aFb1vSDK, AFa1pSDK aFa1pSDK, byte b) {
            this(aFa1pSDK);
        }

        private AFa1uSDK(AFa1pSDK aFa1pSDK) {
            this.valueOf = aFa1pSDK;
        }

        @Override
        public final void run() {
            AFb1vSDK.AFInAppEventParameterName(AFb1vSDK.this, this.valueOf);
        }
    }

    @Override
    public final void setPluginInfo(PluginInfo pluginInfo) {
        int i = 2 % 2;
        int i2 = afErrorLog + 43;
        afRDLog = i2 % 128;
        Object obj = null;
        if (i2 % 2 == 0) {
            Objects.requireNonNull(pluginInfo);
            AFInAppEventType().afWarnLog().values(pluginInfo);
            int i3 = afErrorLog + 113;
            afRDLog = i3 % 128;
            if (i3 % 2 == 0) {
                return;
            }
            obj.hashCode();
            throw null;
        }
        Objects.requireNonNull(pluginInfo);
        AFInAppEventType().afWarnLog().values(pluginInfo);
        throw null;
    }

    class AFa1tSDK implements AFe1eSDK {
        @Override
        public final void AFKeystoreWrapper(AFe1fSDK<?> aFe1fSDK) {
        }

        private AFa1tSDK() {
        }

        AFa1tSDK(AFb1vSDK aFb1vSDK, byte b) {
            this();
        }

        @Override
        public final void values(AFe1fSDK<?> aFe1fSDK) {
            if (aFe1fSDK instanceof AFf1kSDK) {
                AFb1vSDK.this.AFInAppEventType().unregisterClient().AFInAppEventParameterName(((AFf1pSDK) aFe1fSDK).registerClient.registerClient);
            }
        }

        @Override
        public final void AFKeystoreWrapper(AFe1fSDK<?> aFe1fSDK, AFe1cSDK aFe1cSDK) {
            JSONObject jSONObjectAFInAppEventType;
            AFg1uSDK aFg1uSDKAFInAppEventType;
            if (aFe1fSDK instanceof AFf1pSDK) {
                AFf1pSDK aFf1pSDK = (AFf1pSDK) aFe1fSDK;
                boolean z = aFe1fSDK instanceof AFf1kSDK;
                if (z && values()) {
                    AFf1kSDK aFf1kSDK = (AFf1kSDK) aFe1fSDK;
                    if (aFf1kSDK.AFKeystoreWrapper == AFe1cSDK.SUCCESS || aFf1kSDK.values == 1) {
                        AFg1kSDK aFg1kSDK = new AFg1kSDK(aFf1kSDK, AFb1vSDK.this.AFInAppEventType().AFKeystoreWrapper());
                        AFe1dSDK aFe1dSDKMo787w = AFb1vSDK.this.AFInAppEventType().mo787w();
                        aFe1dSDKMo787w.values.execute(aFe1dSDKMo787w.new RunnableC08534(aFg1kSDK));
                    }
                }
                if (aFe1cSDK == AFe1cSDK.SUCCESS) {
                    AFb1vSDK aFb1vSDK = AFb1vSDK.this;
                    aFb1vSDK.valueOf(AFb1vSDK.AFInAppEventParameterName(aFb1vSDK)).values("sentSuccessfully", ServerProtocol.DIALOG_RETURN_SCOPES_TRUE);
                    if (!(aFe1fSDK instanceof AFf1jSDK) && (aFg1uSDKAFInAppEventType = new AFg1tSDK(AFb1vSDK.AFInAppEventParameterName(AFb1vSDK.this)).AFInAppEventType()) != null && aFg1uSDKAFInAppEventType.values()) {
                        String str = aFg1uSDKAFInAppEventType.values;
                        AFLogger.INSTANCE.m797d(AFg1hSDK.UNINSTALL, "Resending Uninstall token to AF servers: ".concat(String.valueOf(str)));
                        AFg1tSDK.valueOf(str);
                    }
                    ResponseNetwork responseNetwork = aFf1pSDK.AFLogger;
                    if (responseNetwork != null && (jSONObjectAFInAppEventType = AFc1sSDK.AFInAppEventType((String) responseNetwork.getBody())) != null) {
                        AFb1vSDK.valueOf(AFb1vSDK.this, jSONObjectAFInAppEventType.optBoolean("send_background", false));
                    }
                    if (z) {
                        AFb1vSDK.valueOf(AFb1vSDK.this, System.currentTimeMillis());
                        return;
                    }
                    return;
                }
                return;
            }
            if (!(aFe1fSDK instanceof AFg1kSDK) || aFe1cSDK == AFe1cSDK.SUCCESS) {
                return;
            }
            AFg1oSDK aFg1oSDK = new AFg1oSDK(AFb1vSDK.this.AFInAppEventType());
            AFe1dSDK aFe1dSDKMo787w2 = AFb1vSDK.this.AFInAppEventType().mo787w();
            aFe1dSDKMo787w2.values.execute(aFe1dSDKMo787w2.new RunnableC08534(aFg1oSDK));
        }

        private boolean values() {
            return AFb1vSDK.this.values != null;
        }
    }

    public final void AFInAppEventType(Context context) {
        int i = 2 % 2;
        int i2 = afErrorLog + 59;
        afRDLog = i2 % 128;
        if (i2 % 2 != 0) {
            Object obj = null;
            obj.hashCode();
            throw null;
        }
        AFd1kSDK aFd1kSDK = this.force;
        if (context != null) {
            AFd1lSDK aFd1lSDK = aFd1kSDK.AFInAppEventParameterName;
            if (context != null) {
                aFd1lSDK.AFInAppEventParameterName = context.getApplicationContext();
            }
        }
        int i3 = afRDLog + 87;
        afErrorLog = i3 % 128;
        int i4 = i3 % 2;
    }

    @Override
    public final void setSharingFilterForPartners(String... strArr) {
        int i = 2 % 2;
        AFInAppEventType().getLevel().AFKeystoreWrapper = new AFc1aSDK(strArr);
        int i2 = afErrorLog + 73;
        afRDLog = i2 % 128;
        if (i2 % 2 != 0) {
            throw null;
        }
    }

    @Override
    public final void sendPurchaseData(Context context, Map<String, Object> map, PurchaseHandler.PurchaseValidationCallback purchaseValidationCallback) {
        PurchaseHandler purchaseHandlerRegisterClient;
        int i = 2 % 2;
        int i2 = afRDLog + 7;
        afErrorLog = i2 % 128;
        if (i2 % 2 == 0) {
            AFInAppEventType(context);
            purchaseHandlerRegisterClient = AFInAppEventType().registerClient();
            String[] strArr = new String[0];
            strArr[1] = BillingClient.FeatureType.SUBSCRIPTIONS;
            if (purchaseHandlerRegisterClient.valueOf(map, purchaseValidationCallback, strArr)) {
                AFf1xSDK aFf1xSDK = new AFf1xSDK(map, purchaseValidationCallback, purchaseHandlerRegisterClient.valueOf);
                AFe1dSDK aFe1dSDK = purchaseHandlerRegisterClient.AFKeystoreWrapper;
                aFe1dSDK.values.execute(aFe1dSDK.new RunnableC08534(aFf1xSDK));
                int i3 = afRDLog + 81;
                afErrorLog = i3 % 128;
                int i4 = i3 % 2;
            }
        } else {
            AFInAppEventType(context);
            purchaseHandlerRegisterClient = AFInAppEventType().registerClient();
            if (purchaseHandlerRegisterClient.valueOf(map, purchaseValidationCallback, BillingClient.FeatureType.SUBSCRIPTIONS)) {
                AFf1xSDK aFf1xSDK2 = new AFf1xSDK(map, purchaseValidationCallback, purchaseHandlerRegisterClient.valueOf);
                AFe1dSDK aFe1dSDK2 = purchaseHandlerRegisterClient.AFKeystoreWrapper;
                aFe1dSDK2.values.execute(aFe1dSDK2.new RunnableC08534(aFf1xSDK2));
                int i5 = afRDLog + 81;
                afErrorLog = i5 % 128;
                int i6 = i5 % 2;
            }
        }
        int i7 = afErrorLog + 99;
        afRDLog = i7 % 128;
        int i8 = i7 % 2;
    }

    @Override
    public final void sendInAppPurchaseData(Context context, Map<String, Object> map, PurchaseHandler.PurchaseValidationCallback purchaseValidationCallback) {
        int i = 2 % 2;
        int i2 = afErrorLog + 59;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        AFInAppEventType(context);
        PurchaseHandler purchaseHandlerRegisterClient = AFInAppEventType().registerClient();
        if (purchaseHandlerRegisterClient.valueOf(map, purchaseValidationCallback, "purchases")) {
            AFf1rSDK aFf1rSDK = new AFf1rSDK(map, purchaseValidationCallback, purchaseHandlerRegisterClient.valueOf);
            AFe1dSDK aFe1dSDK = purchaseHandlerRegisterClient.AFKeystoreWrapper;
            aFe1dSDK.values.execute(aFe1dSDK.new RunnableC08534(aFf1rSDK));
            int i4 = afErrorLog + 23;
            afRDLog = i4 % 128;
            int i5 = i4 % 2;
        }
        int i6 = afRDLog + 85;
        afErrorLog = i6 % 128;
        if (i6 % 2 == 0) {
            throw null;
        }
    }

    @Override
    public final void subscribeForDeepLink(DeepLinkListener deepLinkListener, long j) {
        int i = 2 % 2;
        int i2 = afErrorLog + 35;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        AFInAppEventType().afErrorLog().valueOf = deepLinkListener;
        AFInAppEventType().afErrorLog().AFLogger = j;
        int i4 = afRDLog + 113;
        afErrorLog = i4 % 128;
        int i5 = i4 % 2;
    }

    @Override
    public final void setPartnerData(String str, Map<String, Object> map) {
        String strConcat;
        int i = 2 % 2;
        int i2 = afRDLog + 25;
        afErrorLog = i2 % 128;
        if (i2 % 2 != 0) {
            AFd1sSDK level = AFInAppEventType().getLevel();
            if (level.AFInAppEventType == null) {
                level.AFInAppEventType = new AFc1bSDK();
            }
            AFc1bSDK aFc1bSDK = level.AFInAppEventType;
            if (str != null) {
                int i3 = afRDLog + 21;
                afErrorLog = i3 % 128;
                int i4 = i3 % 2;
                if (!str.isEmpty()) {
                    if (map == null || map.isEmpty()) {
                        if (aFc1bSDK.values.remove(str) != null) {
                            strConcat = "Cleared partner data for ".concat(String.valueOf(str));
                        } else {
                            int i5 = afErrorLog + TypedValues.TYPE_TARGET;
                            afRDLog = i5 % 128;
                            int i6 = i5 % 2;
                            strConcat = "Partner data is missing or `null`";
                        }
                        AFLogger.afWarnLog(strConcat);
                        return;
                    }
                    StringBuilder sb = new StringBuilder("Setting partner data for ");
                    sb.append(str);
                    sb.append(": ");
                    sb.append(map);
                    AFLogger.afDebugLog(sb.toString());
                    int length = new JSONObject(map).toString().length();
                    if (length > 1000) {
                        AFLogger.afWarnLog("Partner data 1000 characters limit exceeded");
                        HashMap map2 = new HashMap();
                        map2.put("error", "limit exceeded: ".concat(String.valueOf(length)));
                        aFc1bSDK.AFKeystoreWrapper.put(str, map2);
                        return;
                    }
                    aFc1bSDK.values.put(str, map);
                    aFc1bSDK.AFKeystoreWrapper.remove(str);
                    return;
                }
            }
            AFLogger.afWarnLog("Partner ID is missing or `null`");
            return;
        }
        AFc1bSDK aFc1bSDK2 = AFInAppEventType().getLevel().AFInAppEventType;
        Object obj = null;
        obj.hashCode();
        throw null;
    }

    @Override
    public final void setImeiData(String str) {
        int i = 2 % 2;
        int i2 = afRDLog + 47;
        afErrorLog = i2 % 128;
        int i3 = i2 % 2;
        AFInAppEventType().afInfoLog().AFKeystoreWrapper("setImeiData", str);
        AFInAppEventType().mo785i().unregisterClient = str;
        int i4 = afRDLog + 75;
        afErrorLog = i4 % 128;
        int i5 = i4 % 2;
    }

    @Override
    public final void setAndroidIdData(String str) {
        int i = 2 % 2;
        int i2 = afRDLog + 121;
        afErrorLog = i2 % 128;
        int i3 = i2 % 2;
        AFInAppEventType().afInfoLog().AFKeystoreWrapper("setAndroidIdData", str);
        AFInAppEventType().getLevel().valueOf = str;
        int i4 = afErrorLog + 25;
        afRDLog = i4 % 128;
        int i5 = i4 % 2;
    }

    @Override
    public final void setResolveDeepLinkURLs(String... strArr) {
        int i = 2 % 2;
        int i2 = afErrorLog + 9;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        AFLogger.afDebugLog(String.format("setResolveDeepLinkURLs %s", Arrays.toString(strArr)));
        AFc1jSDK aFc1jSDKAfErrorLog = AFInAppEventType().afErrorLog();
        aFc1jSDKAfErrorLog.f313d.clear();
        aFc1jSDKAfErrorLog.f313d.addAll(Arrays.asList(strArr));
        int i4 = afErrorLog + 23;
        afRDLog = i4 % 128;
        int i5 = i4 % 2;
    }

    @Override
    public final void setOneLinkCustomDomain(String... strArr) {
        String str;
        int i = 2 % 2;
        int i2 = afErrorLog + 77;
        afRDLog = i2 % 128;
        if (i2 % 2 != 0) {
            Object[] objArr = new Object[0];
            objArr[0] = Arrays.toString(strArr);
            str = String.format("setOneLinkCustomDomain %s", objArr);
        } else {
            str = String.format("setOneLinkCustomDomain %s", Arrays.toString(strArr));
        }
        AFLogger.afDebugLog(str);
        AFInAppEventType().afErrorLog().unregisterClient = strArr;
        int i3 = afErrorLog + TypedValues.TYPE_TARGET;
        afRDLog = i3 % 128;
        if (i3 % 2 != 0) {
            throw null;
        }
    }

    @Override
    public final void setPhoneNumber(String str) {
        int i = 2 % 2;
        int i2 = afErrorLog + 97;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        AFInAppEventType().getLevel().AFInAppEventParameterName = AFb1mSDK.AFInAppEventType(str);
        int i4 = afErrorLog + 43;
        afRDLog = i4 % 128;
        int i5 = i4 % 2;
    }

    @Override
    public final void logEvent(Context context, String str, Map<String, Object> map, AppsFlyerRequestListener appsFlyerRequestListener) {
        HashMap map2 = map == null ? null : new HashMap(map);
        AFInAppEventType(context);
        AFh1uSDK aFh1uSDK = new AFh1uSDK();
        aFh1uSDK.AFLogger = str;
        aFh1uSDK.valueOf = appsFlyerRequestListener;
        if (map2 != null && map2.containsKey(AFInAppEventParameterName.TOUCH_OBJ)) {
            HashMap map3 = new HashMap();
            Object obj = map2.get(AFInAppEventParameterName.TOUCH_OBJ);
            if (obj instanceof MotionEvent) {
                MotionEvent motionEvent = (MotionEvent) obj;
                HashMap map4 = new HashMap();
                map4.put("x", Float.valueOf(motionEvent.getX()));
                map4.put("y", Float.valueOf(motionEvent.getY()));
                map3.put("loc", map4);
                map3.put("pf", Float.valueOf(motionEvent.getPressure()));
                map3.put("rad", Float.valueOf(motionEvent.getTouchMajor() / 2.0f));
            } else {
                map3.put("error", "Parsing failed due to invalid input in 'af_touch_obj'.");
                AFLogger.INSTANCE.mo763w(AFg1hSDK.PREDICT, "Parsing failed due to invalid input in 'af_touch_obj'.", true);
            }
            Map<String, ?> mapSingletonMap = Collections.singletonMap("tch_data", map3);
            map2.remove(AFInAppEventParameterName.TOUCH_OBJ);
            aFh1uSDK.AFInAppEventType(mapSingletonMap);
        }
        aFh1uSDK.AFInAppEventParameterName = map2;
        AFInAppEventType().afInfoLog().AFKeystoreWrapper("logEvent", str, new JSONObject(aFh1uSDK.AFInAppEventParameterName == null ? new HashMap() : aFh1uSDK.AFInAppEventParameterName).toString());
        if (str == null) {
            AFKeystoreWrapper(context, AFh1ySDK.logEvent);
        }
        AFInAppEventType(aFh1uSDK, m775e(context));
    }

    private static void AFInAppEventParameterName(AFa1pSDK aFa1pSDK, AFh1zSDK aFh1zSDK) {
        int i = 2 % 2;
        int i2 = afRDLog + 35;
        afErrorLog = i2 % 128;
        if (i2 % 2 == 0) {
            throw null;
        }
        if (aFh1zSDK != null) {
            aFa1pSDK.AFInAppEventType = aFh1zSDK.values;
            aFa1pSDK.f294d = aFh1zSDK.AFKeystoreWrapper;
            int i3 = afErrorLog + 5;
            afRDLog = i3 % 128;
            int i4 = i3 % 2;
        }
    }

    private void m776e() {
        int i = 2 % 2;
        int i2 = afRDLog + 3;
        afErrorLog = i2 % 128;
        if (i2 % 2 != 0) {
            if (!AFf1vSDK.unregisterClient()) {
                AFd1nSDK aFd1nSDKAFInAppEventType = AFInAppEventType();
                AFe1dSDK aFe1dSDKMo787w = aFd1nSDKAFInAppEventType.mo787w();
                aFe1dSDKMo787w.values.execute(aFe1dSDKMo787w.new RunnableC08534(new AFf1vSDK(aFd1nSDKAFInAppEventType)));
                return;
            }
            int i3 = afErrorLog + 55;
            afRDLog = i3 % 128;
            if (i3 % 2 != 0) {
                throw null;
            }
            return;
        }
        AFf1vSDK.unregisterClient();
        throw null;
    }

    @Override
    public final String getAppsFlyerUID(Context context) {
        int i = 2 % 2;
        AFInAppEventType().afInfoLog().AFKeystoreWrapper("getAppsFlyerUID", new String[0]);
        if (context != null) {
            AFInAppEventType(context);
            AFd1rSDK aFd1rSDKAFInAppEventType = AFInAppEventType().AFInAppEventType();
            String strValues = AFb1lSDK.values(aFd1rSDKAFInAppEventType.AFKeystoreWrapper, aFd1rSDKAFInAppEventType.AFInAppEventParameterName);
            int i2 = afRDLog + 9;
            afErrorLog = i2 % 128;
            int i3 = i2 % 2;
            return strValues;
        }
        int i4 = afErrorLog + 95;
        afRDLog = i4 % 128;
        if (i4 % 2 != 0) {
            int i5 = 94 / 0;
        }
        return null;
    }

    @Override
    public final void setConsentData(AppsFlyerConsent appsFlyerConsent) {
        int i = 2 % 2;
        int i2 = afRDLog + 9;
        afErrorLog = i2 % 128;
        if (i2 % 2 != 0) {
            Objects.requireNonNull(appsFlyerConsent);
            AFInAppEventType().getLevel().registerClient = appsFlyerConsent;
        } else {
            Objects.requireNonNull(appsFlyerConsent);
            AFInAppEventType().getLevel().registerClient = appsFlyerConsent;
            throw null;
        }
    }

    public void AFInAppEventType(Context context, Intent intent) {
        Uri data;
        int i = 2 % 2;
        int i2 = afErrorLog + 103;
        afRDLog = i2 % 128;
        int i3 = i2 % 2;
        AFInAppEventType(context);
        AFc1jSDK aFc1jSDKAfErrorLog = AFInAppEventType().afErrorLog();
        AFd1xSDK aFd1xSDKAFKeystoreWrapper = AFInAppEventType().AFKeystoreWrapper();
        boolean z = false;
        if (intent != null) {
            int i4 = afRDLog + 7;
            afErrorLog = i4 % 128;
            if (i4 % 2 == 0) {
                int i5 = 97 / 0;
                if ("android.intent.action.VIEW".equals(intent.getAction())) {
                    data = intent.getData();
                    int i6 = afErrorLog + 53;
                    afRDLog = i6 % 128;
                    int i7 = i6 % 2;
                } else {
                    data = null;
                }
            } else if ("android.intent.action.VIEW".equals(intent.getAction())) {
                data = intent.getData();
                int i8 = afErrorLog + 53;
                afRDLog = i8 % 128;
                int i9 = i8 % 2;
            } else {
                data = null;
            }
        } else {
            data = null;
        }
        if (data != null && !data.toString().isEmpty()) {
            int i10 = afRDLog + 11;
            afErrorLog = i10 % 128;
            int i11 = i10 % 2;
            z = true;
        }
        if (aFd1xSDKAFKeystoreWrapper.valueOf("ddl_sent") && !z) {
            aFc1jSDKAfErrorLog.values("No direct deep link", null);
            return;
        }
        aFc1jSDKAfErrorLog.AFInAppEventType(AFc1oSDK.values(aFc1jSDKAfErrorLog.f314e.AppsFlyer2dXConversionCallback()), intent, context);
        int i12 = afErrorLog + 83;
        afRDLog = i12 % 128;
        int i13 = i12 % 2;
    }

    private static void m772a(String str, int i, Object[] objArr) {
        int i2 = 2 % 2;
        Object charArray = str;
        if (str != null) {
            int i3 = $10 + 57;
            $11 = i3 % 128;
            if (i3 % 2 == 0) {
                str.toCharArray();
                throw null;
            }
            charArray = str.toCharArray();
        }
        AFj1oSDK aFj1oSDK = new AFj1oSDK();
        char[] cArrValues = AFj1oSDK.values(afWarnLog ^ 8631014522124598290L, (char[]) charArray, i);
        aFj1oSDK.AFKeystoreWrapper = 4;
        while (aFj1oSDK.AFKeystoreWrapper < cArrValues.length) {
            int i4 = $11 + 109;
            $10 = i4 % 128;
            int i5 = i4 % 2;
            aFj1oSDK.AFInAppEventParameterName = aFj1oSDK.AFKeystoreWrapper - 4;
            cArrValues[aFj1oSDK.AFKeystoreWrapper] = (char) (((long) (cArrValues[aFj1oSDK.AFKeystoreWrapper] ^ cArrValues[aFj1oSDK.AFKeystoreWrapper % 4])) ^ (((long) aFj1oSDK.AFInAppEventParameterName) * (afWarnLog ^ 8631014522124598290L)));
            aFj1oSDK.AFKeystoreWrapper++;
        }
        objArr[0] = new String(cArrValues, 4, cArrValues.length - 4);
    }
}
