package com.appsflyer.internal;

import com.appsflyer.AFLogger;
import com.appsflyer.internal.components.network.http.exceptions.HttpException;
import com.facebook.internal.security.CertificateUtil;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.Map;

public final class AFe1sSDK {
    private final int AFKeystoreWrapper;

    public AFe1sSDK(int i) {
        this.AFKeystoreWrapper = i;
    }

    public final AFe1pSDK<String> valueOf(AFe1mSDK aFe1mSDK) throws Throwable {
        HttpURLConnection httpURLConnection;
        String strAFInAppEventParameterName;
        BufferedOutputStream bufferedOutputStream;
        long jCurrentTimeMillis = System.currentTimeMillis();
        try {
            byte[] bArrValues = aFe1mSDK.values();
            StringBuilder sb = new StringBuilder();
            sb.append(aFe1mSDK.valueOf);
            sb.append(CertificateUtil.DELIMITER);
            sb.append(aFe1mSDK.values);
            StringBuilder sb2 = new StringBuilder(sb.toString());
            byte[] bArrValues2 = aFe1mSDK.values();
            if (aFe1mSDK.AFInAppEventType() && bArrValues2 != null) {
                try {
                    String str = aFe1mSDK.valueOf() ? "<encrypted>" : new String(bArrValues2, Charset.defaultCharset());
                    sb2.append("\n payload: ");
                    sb2.append(str);
                } catch (Exception e) {
                    e = e;
                    httpURLConnection = null;
                    try {
                        AFe1tSDK aFe1tSDK = new AFe1tSDK(System.currentTimeMillis() - jCurrentTimeMillis);
                        StringBuilder sb3 = new StringBuilder("error: ");
                        sb3.append(e);
                        sb3.append("\n took ");
                        sb3.append(aFe1tSDK.AFKeystoreWrapper);
                        sb3.append("ms");
                        String string = sb3.toString();
                        AFLogger aFLogger = AFLogger.INSTANCE;
                        AFg1hSDK aFg1hSDK = AFg1hSDK.HTTP_CLIENT;
                        StringBuilder sb4 = new StringBuilder("[");
                        sb4.append(aFe1mSDK.hashCode());
                        sb4.append("] ");
                        sb4.append(string);
                        aFLogger.m801e(aFg1hSDK, sb4.toString(), e, false, false, false);
                        throw new HttpException(e, aFe1tSDK);
                    } catch (Throwable th) {
                        th = th;
                        if (httpURLConnection != null) {
                            httpURLConnection.disconnect();
                        }
                        throw th;
                    }
                } catch (Throwable th2) {
                    th = th2;
                    httpURLConnection = null;
                    if (httpURLConnection != null) {
                        httpURLConnection.disconnect();
                    }
                    throw th;
                }
            }
            for (Map.Entry<String, String> entry : aFe1mSDK.AFInAppEventParameterName.entrySet()) {
                sb2.append("\n ");
                sb2.append(entry.getKey());
                sb2.append(": ");
                sb2.append(entry.getValue());
            }
            StringBuilder sb5 = new StringBuilder("[");
            sb5.append(aFe1mSDK.hashCode());
            sb5.append("] ");
            sb5.append((Object) sb2);
            AFLogger.INSTANCE.m797d(AFg1hSDK.HTTP_CLIENT, sb5.toString());
            HttpURLConnection httpURLConnection2 = (HttpURLConnection) new URL(aFe1mSDK.values).openConnection();
            try {
                httpURLConnection2.setRequestMethod(aFe1mSDK.valueOf);
                if (aFe1mSDK.AFInAppEventParameterName()) {
                    httpURLConnection2.setUseCaches(false);
                }
                if (!aFe1mSDK.registerClient()) {
                    httpURLConnection2.setInstanceFollowRedirects(false);
                }
                try {
                    int i = this.AFKeystoreWrapper;
                    int i2 = aFe1mSDK.AFLogger;
                    if (i2 != -1) {
                        i = i2;
                    }
                    httpURLConnection2.setConnectTimeout(i);
                    httpURLConnection2.setReadTimeout(i);
                    httpURLConnection2.addRequestProperty("Content-Type", aFe1mSDK.valueOf() ? "application/octet-stream" : "application/json");
                    for (Map.Entry<String, String> entry2 : aFe1mSDK.AFInAppEventParameterName.entrySet()) {
                        httpURLConnection2.setRequestProperty(entry2.getKey(), entry2.getValue());
                    }
                    if (bArrValues != null) {
                        httpURLConnection2.setDoOutput(true);
                        StringBuilder sb6 = new StringBuilder();
                        sb6.append(bArrValues.length);
                        httpURLConnection2.setRequestProperty("Content-Length", sb6.toString());
                        try {
                            BufferedOutputStream bufferedOutputStream2 = new BufferedOutputStream(httpURLConnection2.getOutputStream());
                            try {
                                bufferedOutputStream2.write(bArrValues);
                                bufferedOutputStream2.close();
                            } catch (Throwable th3) {
                                th = th3;
                                bufferedOutputStream = bufferedOutputStream2;
                                if (bufferedOutputStream != null) {
                                    bufferedOutputStream.close();
                                }
                                throw th;
                            }
                        } catch (Throwable th4) {
                            th = th4;
                            bufferedOutputStream = null;
                        }
                    }
                    boolean z = httpURLConnection2.getResponseCode() / 100 == 2;
                    if (!aFe1mSDK.AFKeystoreWrapper()) {
                        strAFInAppEventParameterName = "";
                    } else {
                        strAFInAppEventParameterName = AFInAppEventParameterName(httpURLConnection2, z);
                    }
                    AFe1tSDK aFe1tSDK2 = new AFe1tSDK(System.currentTimeMillis() - jCurrentTimeMillis);
                    StringBuilder sb7 = new StringBuilder("response code:");
                    sb7.append(httpURLConnection2.getResponseCode());
                    sb7.append(" ");
                    sb7.append(httpURLConnection2.getResponseMessage());
                    sb7.append("\n body:");
                    sb7.append(strAFInAppEventParameterName);
                    sb7.append("\n took ");
                    sb7.append(aFe1tSDK2.AFKeystoreWrapper);
                    sb7.append("ms");
                    String string2 = sb7.toString();
                    AFLogger aFLogger2 = AFLogger.INSTANCE;
                    AFg1hSDK aFg1hSDK2 = AFg1hSDK.HTTP_CLIENT;
                    StringBuilder sb8 = new StringBuilder("[");
                    sb8.append(aFe1mSDK.hashCode());
                    sb8.append("] ");
                    sb8.append(string2);
                    aFLogger2.m797d(aFg1hSDK2, sb8.toString());
                    HashMap map = new HashMap(httpURLConnection2.getHeaderFields());
                    map.remove(null);
                    AFe1pSDK<String> aFe1pSDK = new AFe1pSDK<>(strAFInAppEventParameterName, httpURLConnection2.getResponseCode(), z, map, aFe1tSDK2);
                    if (httpURLConnection2 != null) {
                        httpURLConnection2.disconnect();
                    }
                    return aFe1pSDK;
                } catch (Exception e2) {
                    e = e2;
                    httpURLConnection = httpURLConnection2;
                    AFe1tSDK aFe1tSDK3 = new AFe1tSDK(System.currentTimeMillis() - jCurrentTimeMillis);
                    StringBuilder sb9 = new StringBuilder("error: ");
                    sb9.append(e);
                    sb9.append("\n took ");
                    sb9.append(aFe1tSDK3.AFKeystoreWrapper);
                    sb9.append("ms");
                    String string3 = sb9.toString();
                    AFLogger aFLogger3 = AFLogger.INSTANCE;
                    AFg1hSDK aFg1hSDK3 = AFg1hSDK.HTTP_CLIENT;
                    StringBuilder sb10 = new StringBuilder("[");
                    sb10.append(aFe1mSDK.hashCode());
                    sb10.append("] ");
                    sb10.append(string3);
                    aFLogger3.m801e(aFg1hSDK3, sb10.toString(), e, false, false, false);
                    throw new HttpException(e, aFe1tSDK3);
                } catch (Throwable th5) {
                    th = th5;
                    httpURLConnection = httpURLConnection2;
                    if (httpURLConnection != null) {
                        httpURLConnection.disconnect();
                    }
                    throw th;
                }
            } catch (Exception e3) {
                e = e3;
            } catch (Throwable th6) {
                th = th6;
            }
        } catch (Exception e4) {
            e = e4;
            httpURLConnection = null;
        } catch (Throwable th7) {
            th = th7;
            httpURLConnection = null;
        }
    }

    private static String AFInAppEventParameterName(HttpURLConnection httpURLConnection, boolean z) throws Throwable {
        BufferedReader bufferedReader;
        InputStream errorStream;
        InputStreamReader inputStreamReader = null;
        try {
            if (z) {
                errorStream = httpURLConnection.getInputStream();
            } else {
                errorStream = httpURLConnection.getErrorStream();
            }
            if (errorStream == null) {
                return "";
            }
            StringBuilder sb = new StringBuilder();
            InputStreamReader inputStreamReader2 = new InputStreamReader(errorStream, Charset.defaultCharset());
            try {
                BufferedReader bufferedReader2 = new BufferedReader(inputStreamReader2);
                boolean z2 = true;
                while (true) {
                    try {
                        String line = bufferedReader2.readLine();
                        if (line != null) {
                            if (!z2) {
                                sb.append('\n');
                            }
                            sb.append(line);
                            z2 = false;
                        } else {
                            String string = sb.toString();
                            inputStreamReader2.close();
                            bufferedReader2.close();
                            return string;
                        }
                    } catch (Throwable th) {
                        inputStreamReader = inputStreamReader2;
                        bufferedReader = bufferedReader2;
                        th = th;
                    }
                }
            } catch (Throwable th2) {
                th = th2;
                bufferedReader = null;
                inputStreamReader = inputStreamReader2;
            }
        } catch (Throwable th3) {
            th = th3;
            bufferedReader = null;
        }
        if (inputStreamReader != null) {
            inputStreamReader.close();
        }
        if (bufferedReader != null) {
            bufferedReader.close();
        }
        throw th;
    }
}
