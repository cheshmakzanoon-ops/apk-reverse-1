package com.appsflyer.internal;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import com.appsflyer.AFLogger;
import com.appsflyer.AppsFlyerConversionListener;
import com.appsflyer.deeplink.DeepLink;
import com.appsflyer.deeplink.DeepLinkListener;
import com.appsflyer.deeplink.DeepLinkResult;
import com.appsflyer.internal.AFe1dSDK.RunnableC08534;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import kotlin.jvm.internal.Intrinsics;
import org.json.JSONException;
import org.json.JSONObject;

public final class AFc1jSDK {
    public Map<String, String> AFInAppEventParameterName;
    public Intent AFKeystoreWrapper;
    public long AFLogger;

    public final AFd1nSDK f314e;
    public String[] unregisterClient;
    public DeepLinkListener valueOf;
    public String values;
    public List<List<String>> AFInAppEventType = new ArrayList();

    public final List<String> f313d = new ArrayList();

    public AFc1jSDK(AFd1nSDK aFd1nSDK) {
        this.f314e = aFd1nSDK;
    }

    public final void AFInAppEventType(AFc1oSDK aFc1oSDK, Intent intent, Context context) {
        AFd1kSDK aFd1kSDK = (AFd1kSDK) this.f314e;
        if (context != null) {
            AFd1lSDK aFd1lSDK = aFd1kSDK.AFInAppEventParameterName;
            if (context != null) {
                aFd1lSDK.AFInAppEventParameterName = context.getApplicationContext();
            }
        }
        if (!valueOf(intent, context, aFc1oSDK) && this.valueOf != null && this.f314e.AFInAppEventType().AFInAppEventParameterName.valueOf("appsFlyerCount", 0) == 0 && !this.f314e.AFKeystoreWrapper().valueOf("ddl_sent")) {
            AFc1qSDK aFc1qSDK = new AFc1qSDK(this.f314e);
            AFe1dSDK aFe1dSDKMo787w = this.f314e.mo787w();
            aFe1dSDKMo787w.values.execute(aFe1dSDKMo787w.new RunnableC08534(new AFf1nSDK(aFc1qSDK)));
        }
        this.f314e.AFKeystoreWrapper().AFInAppEventParameterName("ddl_sent", true);
    }

    public final void AFInAppEventParameterName(Context context, AFc1oSDK aFc1oSDK, Uri uri) {
        AFf1oSDK aFf1oSDK = new AFf1oSDK(context, aFc1oSDK, uri, this.f313d);
        AFe1dSDK aFe1dSDKMo787w = this.f314e.mo787w();
        aFe1dSDKMo787w.values.execute(aFe1dSDKMo787w.new RunnableC08534(aFf1oSDK));
        this.AFKeystoreWrapper = null;
    }

    private Uri valueOf(Object obj, Iterator<String> it) {
        while (obj != JSONObject.NULL) {
            if (!it.hasNext()) {
                Uri uri = Uri.parse(obj.toString());
                if (uri == null || uri.getScheme() == null || uri.getHost() == null) {
                    return null;
                }
                return uri;
            }
            try {
                obj = new JSONObject(obj.toString()).get(it.next());
            } catch (JSONException e) {
                AFLogger.afErrorLogForExcManagerOnly("recursiveSearch error", e);
                return null;
            }
        }
        return null;
    }

    public final void values(String str, DeepLinkResult.Error error) {
        if (this.valueOf != null) {
            AFLogger.INSTANCE.m797d(AFg1hSDK.DDL, "Error occurred: ".concat(String.valueOf(str)));
            AFInAppEventType(new DeepLinkResult(null, error));
        } else {
            values(str);
        }
    }

    public final void AFKeystoreWrapper(Map<String, String> map) {
        DeepLinkResult deepLinkResult;
        if (this.valueOf != null) {
            try {
                try {
                    DeepLink deepLinkAFKeystoreWrapper = DeepLink.AFKeystoreWrapper(map);
                    deepLinkAFKeystoreWrapper.valueOf.put("is_deferred", false);
                    deepLinkResult = new DeepLinkResult(deepLinkAFKeystoreWrapper, null);
                } catch (JSONException e) {
                    AFLogger.INSTANCE.m799e(AFg1hSDK.DDL, "Error occurred", e, true);
                    deepLinkResult = new DeepLinkResult(null, DeepLinkResult.Error.UNEXPECTED);
                }
                AFInAppEventType(deepLinkResult);
                return;
            } catch (Throwable th) {
                AFInAppEventType(new DeepLinkResult(null, null));
                throw th;
            }
        }
        AFInAppEventType(map);
    }

    public final void AFInAppEventType(DeepLinkResult deepLinkResult) {
        if (this.valueOf != null) {
            AFLogger aFLogger = AFLogger.INSTANCE;
            AFg1hSDK aFg1hSDK = AFg1hSDK.DDL;
            StringBuilder sb = new StringBuilder("Calling onDeepLinking with:\n");
            sb.append(deepLinkResult.toString());
            aFLogger.m797d(aFg1hSDK, sb.toString());
            try {
                this.valueOf.onDeepLinking(deepLinkResult);
                return;
            } catch (Throwable th) {
                AFLogger.afErrorLog(th.getLocalizedMessage(), th);
                return;
            }
        }
        AFLogger.INSTANCE.m797d(AFg1hSDK.DDL, "skipping, no callback registered");
    }

    private static void AFInAppEventType(Map<String, String> map) {
        AppsFlyerConversionListener appsFlyerConversionListener = AFb1vSDK.valueOf().values;
        if (appsFlyerConversionListener != null) {
            try {
                StringBuilder sb = new StringBuilder("Calling onAppOpenAttribution with:\n");
                sb.append(map.toString());
                AFLogger.afDebugLog(sb.toString());
                appsFlyerConversionListener.onAppOpenAttribution(map);
            } catch (Throwable th) {
                AFLogger.afErrorLog(th.getLocalizedMessage(), th);
            }
        }
    }

    private static void values(String str) {
        AppsFlyerConversionListener appsFlyerConversionListener = AFb1vSDK.valueOf().values;
        if (appsFlyerConversionListener != null) {
            try {
                AFLogger.afDebugLog("Calling onAppOpenAttributionFailure with: ".concat(String.valueOf(str)));
                appsFlyerConversionListener.onAttributionFailure(str);
            } catch (Throwable th) {
                AFLogger.afErrorLog(th.getLocalizedMessage(), th);
            }
        }
    }

    private boolean valueOf(Intent intent, Context context, AFc1oSDK aFc1oSDK) {
        String string;
        Uri uriValueOf;
        Uri uri = null;
        Uri data = (intent == null || !"android.intent.action.VIEW".equals(intent.getAction())) ? null : intent.getData();
        Intent intent2 = this.AFKeystoreWrapper;
        Uri data2 = (intent2 == null || !"android.intent.action.VIEW".equals(intent2.getAction())) ? null : intent2.getData();
        if (intent == null) {
            AFLogger.afDebugLog("Could not extract deeplink from null intent");
        } else {
            Bundle extras = intent.getExtras();
            if (!this.AFInAppEventType.isEmpty() && extras != null) {
                for (List<String> list : this.AFInAppEventType) {
                    if (list == null) {
                        uriValueOf = null;
                    } else {
                        Iterator<String> it = list.iterator();
                        if (it.hasNext() && (string = extras.getString(it.next())) != null) {
                            uriValueOf = valueOf(string, it);
                        } else {
                            uriValueOf = null;
                        }
                    }
                    if (uriValueOf != null) {
                        StringBuilder sb = new StringBuilder("Found deeplink in push payload at ");
                        sb.append(list.toString());
                        AFLogger.afDebugLog(sb.toString());
                        List<List<String>> list2 = this.AFInAppEventType;
                        Intrinsics.checkNotNullParameter("payloadKey", "");
                        Map<String, Object> mapAFInAppEventType = AFb1vSDK.AFInAppEventType(aFc1oSDK.AFKeystoreWrapper);
                        Intrinsics.checkNotNullExpressionValue(mapAFInAppEventType, "");
                        mapAFInAppEventType.put("payloadKey", list2);
                        AFc1kSDK aFc1kSDK = aFc1oSDK.values;
                        if (aFc1kSDK != null) {
                            aFc1kSDK.valueOf(aFc1oSDK.AFKeystoreWrapper);
                        }
                        uri = uriValueOf;
                        break;
                    }
                }
            }
        }
        if (data != null) {
            AFi1jSDK aFi1jSDK = new AFi1jSDK(intent);
            if (!aFi1jSDK.valueOf("af_consumed")) {
                aFi1jSDK.AFInAppEventParameterName("af_consumed", System.currentTimeMillis());
                AFInAppEventParameterName(context, aFc1oSDK, data);
                return true;
            }
            StringBuilder sb2 = new StringBuilder("skipping re-use of previously consumed deep link: ");
            sb2.append(data.toString());
            sb2.append(" w/af_consumed");
            AFLogger.afInfoLog(sb2.toString());
            return false;
        }
        if (data2 != null) {
            AFi1jSDK aFi1jSDK2 = new AFi1jSDK(this.AFKeystoreWrapper);
            if (!aFi1jSDK2.valueOf("af_consumed")) {
                aFi1jSDK2.AFInAppEventParameterName("af_consumed", System.currentTimeMillis());
                AFInAppEventParameterName(context, aFc1oSDK, data2);
                return true;
            }
            StringBuilder sb3 = new StringBuilder("skipping re-use of previously consumed trampoline deep link: ");
            sb3.append(data2.toString());
            sb3.append(" w/af_consumed");
            AFLogger.afInfoLog(sb3.toString());
            return false;
        }
        if (uri != null) {
            AFi1jSDK aFi1jSDK3 = new AFi1jSDK(intent);
            if (!aFi1jSDK3.valueOf("af_consumed")) {
                aFi1jSDK3.AFInAppEventParameterName("af_consumed", System.currentTimeMillis());
                AFInAppEventParameterName(context, aFc1oSDK, uri);
                return true;
            }
            StringBuilder sb4 = new StringBuilder("skipping re-use of previously consumed deep link from push: ");
            sb4.append(uri.toString());
            sb4.append(" w/af_consumed");
            AFLogger.afInfoLog(sb4.toString());
            return false;
        }
        AFLogger.afDebugLog("No deep link detected");
        return false;
    }
}
