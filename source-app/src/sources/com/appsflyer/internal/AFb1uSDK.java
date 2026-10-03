package com.appsflyer.internal;

import android.media.AudioTrack;
import android.net.TrafficStats;
import android.os.Process;
import android.text.AndroidCharacter;
import android.text.TextUtils;
import android.view.ViewConfiguration;
import com.appsflyer.AFLogger;
import java.io.OutputStream;
import java.lang.reflect.Method;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.Charset;
import java.util.Map;

@Deprecated
public final class AFb1uSDK {
    private final AFb1cSDK AFKeystoreWrapper;
    private final AFh1vSDK values;

    public AFb1uSDK(AFh1vSDK aFh1vSDK, AFb1cSDK aFb1cSDK) {
        this.values = aFh1vSDK;
        this.AFKeystoreWrapper = aFb1cSDK;
    }

    public final HttpURLConnection AFKeystoreWrapper(String str) {
        HttpURLConnection httpURLConnection;
        String str2 = this.values.unregisterClient;
        String string = AFa1oSDK.values((Map<String, ?>) this.values.AFInAppEventType()).toString();
        boolean zM818w = this.values.m818w();
        boolean zM816i = this.values.m816i();
        boolean zM817v = this.values.m817v();
        boolean zAFKeystoreWrapper = this.values.AFKeystoreWrapper();
        String strAFInAppEventType = "";
        byte[] bytes = string.getBytes(Charset.defaultCharset());
        HttpURLConnection httpURLConnection2 = null;
        if (zM818w) {
            return null;
        }
        boolean z = true;
        try {
            URL url = new URL(str2);
            if (zM817v) {
                this.AFKeystoreWrapper.AFKeystoreWrapper(url.toString(), string);
                int length = string.getBytes(Charset.defaultCharset()).length;
                StringBuilder sb = new StringBuilder("call = ");
                sb.append(url);
                sb.append("; size = ");
                sb.append(length);
                sb.append(" byte");
                sb.append(length > 1 ? "s" : "");
                sb.append("; body = ");
                sb.append(string);
                AFb1bSDK.valueOf(sb.toString());
            }
            TrafficStats.setThreadStatsTag("AppsFlyer".hashCode());
            httpURLConnection = (HttpURLConnection) url.openConnection();
            try {
                httpURLConnection.setReadTimeout(30000);
                httpURLConnection.setConnectTimeout(30000);
                httpURLConnection.setRequestMethod("POST");
                httpURLConnection.setDoInput(true);
                httpURLConnection.setDoOutput(true);
                httpURLConnection.setRequestProperty("Content-Type", zAFKeystoreWrapper ? "application/octet-stream" : "application/json");
                OutputStream outputStream = httpURLConnection.getOutputStream();
                try {
                    if (zAFKeystoreWrapper) {
                        try {
                            Object[] objArr = {str};
                            Object method = AFa1zSDK.afDebugLog.get(-1876220023);
                            if (method == null) {
                                method = ((Class) AFa1zSDK.valueOf(38 - (AudioTrack.getMaxVolume() > 0.0f ? 1 : (AudioTrack.getMaxVolume() == 0.0f ? 0 : -1)), (char) ((Process.myPid() >> 22) + 6139), TextUtils.lastIndexOf("", '0', 0, 0) + 37)).getMethod("AFInAppEventParameterName", String.class);
                                AFa1zSDK.afDebugLog.put(-1876220023, method);
                            }
                            Object objInvoke = ((Method) method).invoke(null, objArr);
                            try {
                                Object[] objArr2 = {bytes};
                                Object declaredMethod = AFa1zSDK.afDebugLog.get(-1942994109);
                                if (declaredMethod == null) {
                                    declaredMethod = ((Class) AFa1zSDK.valueOf(38 - (ViewConfiguration.getZoomControlsTimeout() > 0L ? 1 : (ViewConfiguration.getZoomControlsTimeout() == 0L ? 0 : -1)), (char) ((Process.myPid() >> 22) + 6139), 'T' - AndroidCharacter.getMirror('0'))).getDeclaredMethod("valueOf", byte[].class);
                                    AFa1zSDK.afDebugLog.put(-1942994109, declaredMethod);
                                }
                                bytes = (byte[]) ((Method) declaredMethod).invoke(objInvoke, objArr2);
                            } catch (Throwable th) {
                                Throwable cause = th.getCause();
                                if (cause != null) {
                                    throw cause;
                                }
                                throw th;
                            }
                        } catch (Throwable th2) {
                            Throwable cause2 = th2.getCause();
                            if (cause2 != null) {
                                throw cause2;
                            }
                            throw th2;
                        }
                    }
                    outputStream.write(bytes);
                } catch (Exception e) {
                    AFLogger.afErrorLogForExcManagerOnly("AFCrypto: reflection init failed", e);
                }
                outputStream.close();
                httpURLConnection.connect();
                int responseCode = httpURLConnection.getResponseCode();
                if (zM816i) {
                    strAFInAppEventType = AFb1vSDK.AFInAppEventType(httpURLConnection);
                }
                if (zM817v) {
                    this.AFKeystoreWrapper.AFInAppEventParameterName(url.toString(), responseCode, strAFInAppEventType);
                }
                if (responseCode == 200) {
                    AFLogger.afInfoLog("Status 200 ok");
                    z = false;
                }
            } catch (Throwable th3) {
                th = th3;
                httpURLConnection2 = httpURLConnection;
                AFLogger.afErrorLog("Error while calling ".concat(String.valueOf(str2)), th);
                httpURLConnection = httpURLConnection2;
            }
        } catch (Throwable th4) {
            th = th4;
        }
        StringBuilder sb2 = new StringBuilder("Connection ");
        sb2.append(z ? "error" : "call succeeded");
        sb2.append(": ");
        sb2.append(strAFInAppEventType);
        AFLogger.afInfoLog(sb2.toString());
        return httpURLConnection;
    }
}
