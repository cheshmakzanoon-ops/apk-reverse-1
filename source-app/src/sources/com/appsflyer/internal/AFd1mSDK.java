package com.appsflyer.internal;

import androidx.constraintlayout.widget.ConstraintLayout;
import com.appsflyer.AFLogger;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.util.Map;
import kotlin.Metadata;
import kotlin.collections.CollectionsKt;
import kotlin.io.TextStreamsKt;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;
import kotlin.text.Charsets;

@Metadata(d1 = {"\u0000B\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\t\n\u0002\b\u0003\n\u0002\u0010\u0012\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010$\n\u0002\b\u0003\n\u0002\u0010\b\n\u0002\b\u0007\b&\u0018\u00002\u00020\u0001B/\u0012\u0006\u0010\n\u001a\u00020\r\u0012\u0014\u0010\u001a\u001a\u0010\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u0005\u0018\u00010\u0012\u0012\b\b\u0002\u0010\u001b\u001a\u00020\u0016¢\u0006\u0004\b\u001c\u0010\u001dJ\u000f\u0010\u0003\u001a\u00020\u0002H\u0007¢\u0006\u0004\b\u0003\u0010\u0004J\u0015\u0010\u0006\u001a\u00020\u0005*\u0004\u0018\u00010\u0005H'¢\u0006\u0004\b\u0006\u0010\u0007J\u001b\u0010\u000b\u001a\u00020\u0002*\u00020\b2\u0006\u0010\n\u001a\u00020\tH\u0002¢\u0006\u0004\b\u000b\u0010\fR\u0012\u0010\u0003\u001a\u00020\rX\u0087\u0002¢\u0006\u0006\n\u0004\b\u000e\u0010\u000fR\u0014\u0010\u000b\u001a\u00020\u00108'X¦\u0004¢\u0006\u0006\u001a\u0004\b\u000e\u0010\u0011R \u0010\u0006\u001a\u0010\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u0005\u0018\u00010\u0012X\u0087\u0002¢\u0006\u0006\n\u0004\b\u0013\u0010\u0014R\u001a\u0010\u0013\u001a\u00020\u00028\u0017X\u0097D¢\u0006\f\n\u0004\b\u000b\u0010\u0015\u001a\u0004\b\u0013\u0010\u0004R\u0011\u0010\u000e\u001a\u00020\u0016X\u0007¢\u0006\u0006\n\u0004\b\u0006\u0010\u0017R\u0014\u0010\u0019\u001a\u00020\u00058'X¦\u0004¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0018"}, d2 = {"Lcom/appsflyer/internal/AFd1mSDK;", "", "", "AFInAppEventParameterName", "()Z", "", "AFInAppEventType", "(Ljava/lang/String;)Ljava/lang/String;", "Ljava/net/HttpURLConnection;", "", "p0", "AFKeystoreWrapper", "(Ljava/net/HttpURLConnection;J)Z", "", "values", "[B", "Lcom/appsflyer/internal/AFe1uSDK;", "()Lcom/appsflyer/internal/AFe1uSDK;", "", "valueOf", "Ljava/util/Map;", "Z", "", "I", "()Ljava/lang/String;", "registerClient", "p1", "p2", "<init>", "([BLjava/util/Map;I)V"}, k = 1, mv = {1, 6, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public abstract class AFd1mSDK {

    public int values;

    private final boolean valueOf;

    public Map<String, String> AFInAppEventType;

    public byte[] AFInAppEventParameterName;

    public abstract String AFInAppEventType();

    public abstract String AFInAppEventType(String str);

    public abstract AFe1uSDK values();

    public AFd1mSDK(byte[] bArr, Map<String, String> map, int i) {
        Intrinsics.checkNotNullParameter(bArr, "");
        this.AFInAppEventParameterName = bArr;
        this.AFInAppEventType = map;
        this.values = i;
        this.valueOf = true;
    }

    public boolean getValueOf() {
        return this.valueOf;
    }

    public final boolean AFInAppEventParameterName() {
        HttpURLConnection httpURLConnection;
        Throwable th;
        long jCurrentTimeMillis = System.currentTimeMillis();
        try {
            String strAFInAppEventType = AFInAppEventType();
            Intrinsics.checkNotNullParameter(strAFInAppEventType, "");
            URLConnection uRLConnectionOpenConnection = new URL(strAFInAppEventType).openConnection();
            if (uRLConnectionOpenConnection != null) {
                httpURLConnection = (HttpURLConnection) uRLConnectionOpenConnection;
                try {
                    boolean zAFKeystoreWrapper = AFKeystoreWrapper(httpURLConnection, jCurrentTimeMillis);
                    if (httpURLConnection == null) {
                        return zAFKeystoreWrapper;
                    }
                    httpURLConnection.disconnect();
                    return zAFKeystoreWrapper;
                } catch (Throwable th2) {
                    th = th2;
                    try {
                        long jCurrentTimeMillis2 = System.currentTimeMillis() - jCurrentTimeMillis;
                        StringBuilder sb = new StringBuilder("error: ");
                        sb.append(th);
                        sb.append("\n\ttook ");
                        sb.append(jCurrentTimeMillis2);
                        sb.append("ms\n\t");
                        sb.append(th.getMessage());
                        String string = sb.toString();
                        StringBuilder sb2 = new StringBuilder("HTTP: [");
                        sb2.append(httpURLConnection != null ? httpURLConnection.hashCode() : 0);
                        sb2.append("] ");
                        sb2.append(string);
                        String strAFInAppEventType2 = AFInAppEventType(sb2.toString());
                        if (getValueOf()) {
                            AFLogger.afRDLog(strAFInAppEventType2);
                        } else {
                            AFLogger.afVerboseLog(strAFInAppEventType2);
                        }
                        return false;
                    } finally {
                        if (httpURLConnection != null) {
                            httpURLConnection.disconnect();
                        }
                    }
                }
            }
            throw new NullPointerException("null cannot be cast to non-null type java.net.HttpURLConnection");
        } catch (Throwable th3) {
            httpURLConnection = null;
            th = th3;
        }
    }

    private final boolean AFKeystoreWrapper(HttpURLConnection httpURLConnection, long j) throws IOException {
        InputStream errorStream;
        String str = "";
        httpURLConnection.setRequestMethod("POST");
        StringBuilder sb = new StringBuilder();
        sb.append(httpURLConnection.getRequestMethod());
        sb.append(':');
        sb.append(httpURLConnection.getURL());
        StringBuilder sb2 = new StringBuilder(sb.toString());
        sb2.append("\n length: ");
        sb2.append(new String(this.AFInAppEventParameterName, Charsets.UTF_8).length());
        Map<String, String> map = this.AFInAppEventType;
        if (map != null) {
            for (Map.Entry<String, String> entry : map.entrySet()) {
                sb2.append("\n ");
                sb2.append(entry.getKey());
                sb2.append(": ");
                sb2.append(entry.getValue());
            }
        }
        StringBuilder sb3 = new StringBuilder("HTTP: [");
        sb3.append(httpURLConnection.hashCode());
        sb3.append("] ");
        sb3.append((Object) sb2);
        String strAFInAppEventType = AFInAppEventType(sb3.toString());
        if (getValueOf()) {
            AFLogger.afRDLog(strAFInAppEventType);
        } else {
            AFLogger.afVerboseLog(strAFInAppEventType);
        }
        httpURLConnection.setInstanceFollowRedirects(false);
        httpURLConnection.setUseCaches(false);
        httpURLConnection.setReadTimeout(this.values);
        httpURLConnection.setConnectTimeout(this.values);
        httpURLConnection.addRequestProperty("Content-Type", values().AFInAppEventParameterName);
        Map<String, String> map2 = this.AFInAppEventType;
        if (map2 != null) {
            for (Map.Entry<String, String> entry2 : map2.entrySet()) {
                httpURLConnection.addRequestProperty(entry2.getKey(), entry2.getValue());
            }
        }
        httpURLConnection.setDoOutput(true);
        httpURLConnection.setRequestProperty("Content-Length", String.valueOf(this.AFInAppEventParameterName.length));
        OutputStream outputStream = httpURLConnection.getOutputStream();
        Intrinsics.checkNotNullExpressionValue(outputStream, "");
        BufferedOutputStream bufferedOutputStream = outputStream instanceof BufferedOutputStream ? (BufferedOutputStream) outputStream : new BufferedOutputStream(outputStream, 8192);
        bufferedOutputStream.write(this.AFInAppEventParameterName);
        bufferedOutputStream.close();
        if (AFd1eSDK.values(httpURLConnection)) {
            errorStream = httpURLConnection.getInputStream();
        } else {
            errorStream = httpURLConnection.getErrorStream();
        }
        if (errorStream != null) {
            Intrinsics.checkNotNullExpressionValue(errorStream, "");
            BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(errorStream, Charsets.UTF_8), 8192);
            String strJoinToString$default = CollectionsKt.joinToString$default(TextStreamsKt.readLines(bufferedReader), (CharSequence) null, (CharSequence) null, (CharSequence) null, 0, (CharSequence) null, (Function1) null, 63, (Object) null);
            bufferedReader.close();
            if (strJoinToString$default != null) {
                str = strJoinToString$default;
            }
        }
        long jCurrentTimeMillis = System.currentTimeMillis() - j;
        StringBuilder sb4 = new StringBuilder("response code:");
        sb4.append(httpURLConnection.getResponseCode());
        sb4.append(' ');
        sb4.append(httpURLConnection.getResponseMessage());
        sb4.append("\n\tbody:");
        sb4.append(str);
        sb4.append("\n\ttook ");
        sb4.append(jCurrentTimeMillis);
        sb4.append("ms");
        String string = sb4.toString();
        StringBuilder sb5 = new StringBuilder("HTTP: [");
        sb5.append(httpURLConnection.hashCode());
        sb5.append("] ");
        sb5.append(string);
        String strAFInAppEventType2 = AFInAppEventType(sb5.toString());
        if (getValueOf()) {
            AFLogger.afRDLog(strAFInAppEventType2);
        } else {
            AFLogger.afVerboseLog(strAFInAppEventType2);
        }
        return AFd1eSDK.values(httpURLConnection);
    }
}
