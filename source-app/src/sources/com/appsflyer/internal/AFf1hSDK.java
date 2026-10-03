package com.appsflyer.internal;

import android.text.TextUtils;
import android.util.Base64;
import com.appsflyer.AFLogger;
import com.appsflyer.internal.components.network.http.exceptions.HttpException;
import com.appsflyer.internal.components.network.http.exceptions.ParsingException;
import java.io.IOException;
import java.io.InterruptedIOException;
import java.net.SocketTimeoutException;
import java.nio.charset.Charset;

public final class AFf1hSDK extends AFe1fSDK<AFf1lSDK> {
    public AFf1lSDK AFLogger;
    private final AFf1dSDK afInfoLog;

    public final AFf1iSDK f349d;

    private final AFf1cSDK f350e;
    private final AFf1gSDK force;

    private final AFg1zSDK f351i;
    private final AFd1rSDK registerClient;
    public AFh1iSDK unregisterClient;

    private final AFe1zSDK f352v;

    private final String f353w;

    @Override
    public final long AFKeystoreWrapper() {
        return 1500L;
    }

    @Override
    public final boolean values() {
        return false;
    }

    public AFf1hSDK(AFf1cSDK aFf1cSDK, AFd1rSDK aFd1rSDK, AFg1zSDK aFg1zSDK, AFf1gSDK aFf1gSDK, AFe1zSDK aFe1zSDK, AFf1dSDK aFf1dSDK, String str, AFf1iSDK aFf1iSDK) {
        super(AFe1bSDK.RC_CDN, new AFe1bSDK[0], "UpdateRemoteConfiguration");
        this.AFLogger = null;
        this.f350e = aFf1cSDK;
        this.registerClient = aFd1rSDK;
        this.f351i = aFg1zSDK;
        this.force = aFf1gSDK;
        this.f352v = aFe1zSDK;
        this.afInfoLog = aFf1dSDK;
        this.f353w = str;
        this.f349d = aFf1iSDK;
    }

    @Override
    public final AFe1cSDK AFInAppEventType() throws Exception {
        try {
            AFf1lSDK aFf1lSDKUnregisterClient = unregisterClient();
            this.AFLogger = aFf1lSDKUnregisterClient;
            if (aFf1lSDKUnregisterClient == AFf1lSDK.FAILURE) {
                return AFe1cSDK.FAILURE;
            }
            return AFe1cSDK.SUCCESS;
        } catch (InterruptedException e) {
            e = e;
            AFLogger.afErrorLogForExcManagerOnly("RC update config failed", e);
            this.AFLogger = AFf1lSDK.FAILURE;
            return AFe1cSDK.TIMEOUT;
        } catch (SocketTimeoutException unused) {
            this.AFLogger = AFf1lSDK.FAILURE;
            return AFe1cSDK.TIMEOUT;
        } catch (InterruptedIOException e2) {
            e = e2;
            AFLogger.afErrorLogForExcManagerOnly("RC update config failed", e);
            this.AFLogger = AFf1lSDK.FAILURE;
            return AFe1cSDK.TIMEOUT;
        }
    }

    private AFf1lSDK unregisterClient() throws InterruptedException, InterruptedIOException {
        String strAFInAppEventParameterName;
        AFe1pSDK<AFh1nSDK> aFe1pSDKValueOf;
        AFh1nSDK body;
        String strAFInAppEventType;
        String strAFInAppEventType2;
        String str;
        boolean zAFInAppEventParameterName;
        AFh1hSDK aFh1hSDKValueOf;
        AFh1mSDK aFh1mSDK;
        long jCurrentTimeMillis = System.currentTimeMillis();
        String str2 = this.f353w;
        String str3 = this.f351i.registerClient;
        if (str3 != null && str3.trim().length() != 0) {
            if (str2 == null) {
                AFLogger.INSTANCE.m804w(AFg1hSDK.REMOTE_CONTROL, "Can't create CDN token, domain or version is not provided.");
            } else {
                strAFInAppEventParameterName = AFb1mSDK.AFInAppEventParameterName(TextUtils.join("\u2063", new String[]{"appsflyersdk.com", str2, this.registerClient.AFKeystoreWrapper.AFInAppEventParameterName.getPackageName()}), str3);
            }
            if (strAFInAppEventParameterName == null) {
                AFLogger.INSTANCE.m803v(AFg1hSDK.REMOTE_CONTROL, "can't create CDN token, skipping fetch config");
                return AFf1lSDK.FAILURE;
            }
            try {
                if (this.afInfoLog.values()) {
                    AFLogger.INSTANCE.m802i(AFg1hSDK.REMOTE_CONTROL, "Cached config is expired, updating...");
                    aFe1pSDKValueOf = this.f352v.values(this.afInfoLog.AFInAppEventType(), this.afInfoLog.AFInAppEventParameterName(), strAFInAppEventParameterName, 1500).valueOf();
                    if (aFe1pSDKValueOf.isSuccessful()) {
                        body = aFe1pSDKValueOf.getBody();
                        strAFInAppEventType = aFe1pSDKValueOf.AFInAppEventType("x-amz-meta-af-auth-v1");
                        String strAFInAppEventType3 = aFe1pSDKValueOf.AFInAppEventType("X-Af-Date");
                        strAFInAppEventType2 = aFe1pSDKValueOf.AFInAppEventType("CF-Cache-Status");
                        str = this.f351i.registerClient;
                        zAFInAppEventParameterName = new AFf1fSDK().AFInAppEventParameterName(strAFInAppEventType3);
                        if (str != null && str.trim().length() != 0) {
                            aFh1hSDKValueOf = this.f350e.valueOf(body, strAFInAppEventType, strAFInAppEventParameterName, str);
                            if (aFh1hSDKValueOf.AFInAppEventType()) {
                                if (!zAFInAppEventParameterName && (aFh1mSDK = body.AFInAppEventType) != null) {
                                    aFh1mSDK.AFInAppEventType = null;
                                }
                                long jValueOf = this.afInfoLog.valueOf();
                                AFLogger aFLogger = AFLogger.INSTANCE;
                                AFg1hSDK aFg1hSDK = AFg1hSDK.REMOTE_CONTROL;
                                StringBuilder sb = new StringBuilder("using max-age fallback: ");
                                sb.append(jValueOf);
                                sb.append(" seconds");
                                aFLogger.m803v(aFg1hSDK, sb.toString());
                                long jCurrentTimeMillis2 = System.currentTimeMillis();
                                AFf1gSDK aFf1gSDK = this.force;
                                aFf1gSDK.values.values("af_remote_config", Base64.encodeToString(body.AFInAppEventParameterName.getBytes(Charset.defaultCharset()), 2));
                                aFf1gSDK.AFInAppEventParameterName = aFf1gSDK.AFInAppEventType;
                                aFf1gSDK.values.AFInAppEventParameterName("af_rc_timestamp", jCurrentTimeMillis2);
                                aFf1gSDK.values.AFInAppEventParameterName("af_rc_max_age", jValueOf);
                                aFf1gSDK.AFInAppEventType = body;
                                aFf1gSDK.valueOf = jCurrentTimeMillis2;
                                aFf1gSDK.AFKeystoreWrapper = jValueOf;
                                AFLogger aFLogger2 = AFLogger.INSTANCE;
                                AFg1hSDK aFg1hSDK2 = AFg1hSDK.REMOTE_CONTROL;
                                StringBuilder sb2 = new StringBuilder("Config successfully updated, timeToLive: ");
                                sb2.append(jValueOf);
                                sb2.append(" seconds");
                                aFLogger2.m797d(aFg1hSDK2, sb2.toString());
                                values(strAFInAppEventParameterName, jCurrentTimeMillis, aFh1hSDKValueOf.AFInAppEventType, strAFInAppEventType2, aFe1pSDKValueOf);
                                return AFf1lSDK.SUCCESS;
                            }
                            values(strAFInAppEventParameterName, jCurrentTimeMillis, aFh1hSDKValueOf.AFInAppEventType, strAFInAppEventType2, aFe1pSDKValueOf);
                            AFLogger.INSTANCE.m804w(AFg1hSDK.REMOTE_CONTROL, "fetched config is not valid (MITM?) refuse to use it.");
                            return AFf1lSDK.FAILURE;
                        }
                        AFLogger.INSTANCE.m804w(AFg1hSDK.REMOTE_CONTROL, "Dev key is not set, SDK is not started.");
                        return AFf1lSDK.FAILURE;
                    }
                    values(strAFInAppEventParameterName, jCurrentTimeMillis, null, null, aFe1pSDKValueOf);
                    AFLogger aFLogger3 = AFLogger.INSTANCE;
                    AFg1hSDK aFg1hSDK3 = AFg1hSDK.REMOTE_CONTROL;
                    StringBuilder sb3 = new StringBuilder("failed to fetch remote config from CDN with status code: ");
                    sb3.append(aFe1pSDKValueOf.getStatusCode());
                    aFLogger3.m804w(aFg1hSDK3, sb3.toString());
                    return AFf1lSDK.FAILURE;
                }
                AFLogger.INSTANCE.m797d(AFg1hSDK.REMOTE_CONTROL, "active config is valid, skipping fetch");
                return AFf1lSDK.USE_CACHED;
            } catch (IOException e) {
                AFLogger aFLogger4 = AFLogger.INSTANCE;
                AFg1hSDK aFg1hSDK4 = AFg1hSDK.REMOTE_CONTROL;
                StringBuilder sb4 = new StringBuilder("failed to fetch remote config: ");
                sb4.append(e.getMessage());
                aFLogger4.m801e(aFg1hSDK4, sb4.toString(), e, true, false, false);
                AFKeystoreWrapper(strAFInAppEventParameterName, jCurrentTimeMillis, e instanceof ParsingException ? ((ParsingException) e).getRawResponse() : null, null, null, null, e);
                if (e.getCause() instanceof InterruptedIOException) {
                    throw ((InterruptedIOException) e.getCause());
                }
                return AFf1lSDK.FAILURE;
            } catch (Throwable th) {
                AFLogger aFLogger5 = AFLogger.INSTANCE;
                AFg1hSDK aFg1hSDK5 = AFg1hSDK.REMOTE_CONTROL;
                StringBuilder sb5 = new StringBuilder("failed to update remote config: ");
                sb5.append(th.getMessage());
                aFLogger5.m801e(aFg1hSDK5, sb5.toString(), th, true, false, false);
                AFKeystoreWrapper(strAFInAppEventParameterName, jCurrentTimeMillis, null, null, null, null, th);
                if (th.getCause() instanceof InterruptedException) {
                    throw ((InterruptedException) th.getCause());
                }
                return AFf1lSDK.FAILURE;
            }
        }
        AFLogger.INSTANCE.m804w(AFg1hSDK.REMOTE_CONTROL, "Dev key is not set, SDK is not started.");
        strAFInAppEventParameterName = null;
        if (strAFInAppEventParameterName == null) {
            AFLogger.INSTANCE.m803v(AFg1hSDK.REMOTE_CONTROL, "can't create CDN token, skipping fetch config");
            return AFf1lSDK.FAILURE;
        }
        if (this.afInfoLog.values()) {
            AFLogger.INSTANCE.m802i(AFg1hSDK.REMOTE_CONTROL, "Cached config is expired, updating...");
            aFe1pSDKValueOf = this.f352v.values(this.afInfoLog.AFInAppEventType(), this.afInfoLog.AFInAppEventParameterName(), strAFInAppEventParameterName, 1500).valueOf();
            if (aFe1pSDKValueOf.isSuccessful()) {
                body = aFe1pSDKValueOf.getBody();
                strAFInAppEventType = aFe1pSDKValueOf.AFInAppEventType("x-amz-meta-af-auth-v1");
                String strAFInAppEventType4 = aFe1pSDKValueOf.AFInAppEventType("X-Af-Date");
                strAFInAppEventType2 = aFe1pSDKValueOf.AFInAppEventType("CF-Cache-Status");
                str = this.f351i.registerClient;
                zAFInAppEventParameterName = new AFf1fSDK().AFInAppEventParameterName(strAFInAppEventType4);
                if (str != null) {
                    aFh1hSDKValueOf = this.f350e.valueOf(body, strAFInAppEventType, strAFInAppEventParameterName, str);
                    if (aFh1hSDKValueOf.AFInAppEventType()) {
                        if (!zAFInAppEventParameterName) {
                            aFh1mSDK.AFInAppEventType = null;
                        }
                        long jValueOf2 = this.afInfoLog.valueOf();
                        AFLogger aFLogger6 = AFLogger.INSTANCE;
                        AFg1hSDK aFg1hSDK6 = AFg1hSDK.REMOTE_CONTROL;
                        StringBuilder sb6 = new StringBuilder("using max-age fallback: ");
                        sb6.append(jValueOf2);
                        sb6.append(" seconds");
                        aFLogger6.m803v(aFg1hSDK6, sb6.toString());
                        long jCurrentTimeMillis3 = System.currentTimeMillis();
                        AFf1gSDK aFf1gSDK2 = this.force;
                        aFf1gSDK2.values.values("af_remote_config", Base64.encodeToString(body.AFInAppEventParameterName.getBytes(Charset.defaultCharset()), 2));
                        aFf1gSDK2.AFInAppEventParameterName = aFf1gSDK2.AFInAppEventType;
                        aFf1gSDK2.values.AFInAppEventParameterName("af_rc_timestamp", jCurrentTimeMillis3);
                        aFf1gSDK2.values.AFInAppEventParameterName("af_rc_max_age", jValueOf2);
                        aFf1gSDK2.AFInAppEventType = body;
                        aFf1gSDK2.valueOf = jCurrentTimeMillis3;
                        aFf1gSDK2.AFKeystoreWrapper = jValueOf2;
                        AFLogger aFLogger7 = AFLogger.INSTANCE;
                        AFg1hSDK aFg1hSDK7 = AFg1hSDK.REMOTE_CONTROL;
                        StringBuilder sb7 = new StringBuilder("Config successfully updated, timeToLive: ");
                        sb7.append(jValueOf2);
                        sb7.append(" seconds");
                        aFLogger7.m797d(aFg1hSDK7, sb7.toString());
                        values(strAFInAppEventParameterName, jCurrentTimeMillis, aFh1hSDKValueOf.AFInAppEventType, strAFInAppEventType2, aFe1pSDKValueOf);
                        return AFf1lSDK.SUCCESS;
                    }
                    values(strAFInAppEventParameterName, jCurrentTimeMillis, aFh1hSDKValueOf.AFInAppEventType, strAFInAppEventType2, aFe1pSDKValueOf);
                    AFLogger.INSTANCE.m804w(AFg1hSDK.REMOTE_CONTROL, "fetched config is not valid (MITM?) refuse to use it.");
                    return AFf1lSDK.FAILURE;
                }
                AFLogger.INSTANCE.m804w(AFg1hSDK.REMOTE_CONTROL, "Dev key is not set, SDK is not started.");
                return AFf1lSDK.FAILURE;
            }
            values(strAFInAppEventParameterName, jCurrentTimeMillis, null, null, aFe1pSDKValueOf);
            AFLogger aFLogger8 = AFLogger.INSTANCE;
            AFg1hSDK aFg1hSDK8 = AFg1hSDK.REMOTE_CONTROL;
            StringBuilder sb8 = new StringBuilder("failed to fetch remote config from CDN with status code: ");
            sb8.append(aFe1pSDKValueOf.getStatusCode());
            aFLogger8.m804w(aFg1hSDK8, sb8.toString());
            return AFf1lSDK.FAILURE;
        }
        AFLogger.INSTANCE.m797d(AFg1hSDK.REMOTE_CONTROL, "active config is valid, skipping fetch");
        return AFf1lSDK.USE_CACHED;
    }

    private void values(String str, long j, AFh1fSDK aFh1fSDK, String str2, AFe1pSDK<AFh1nSDK> aFe1pSDK) {
        AFKeystoreWrapper(str, j, aFe1pSDK, aFe1pSDK != null ? aFe1pSDK.getBody() : null, aFh1fSDK, str2 != null ? str2 : null, null);
    }

    private void AFKeystoreWrapper(String str, long j, AFe1pSDK<?> aFe1pSDK, AFh1nSDK aFh1nSDK, AFh1fSDK aFh1fSDK, String str2, Throwable th) {
        long j2;
        int statusCode;
        Throwable cause;
        long j3;
        if (aFe1pSDK != null) {
            j2 = aFe1pSDK.values.AFKeystoreWrapper;
            statusCode = aFe1pSDK.getStatusCode();
        } else {
            j2 = 0;
            statusCode = 0;
        }
        int i = statusCode;
        if (th instanceof HttpException) {
            cause = th.getCause();
            j3 = ((HttpException) th).getMetrics().AFKeystoreWrapper;
        } else {
            cause = th;
            j3 = j2;
        }
        this.unregisterClient = new AFh1iSDK(aFh1nSDK != null ? aFh1nSDK.values : null, str, j3, System.currentTimeMillis() - j, i, aFh1fSDK, str2, cause);
    }
}
