package com.gme.liteav.base.http;

import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkRequest;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.SystemClock;
import android.text.TextUtils;
import androidx.constraintlayout.core.motion.utils.TypedValues;
import androidx.core.view.PointerIconCompat;
import androidx.recyclerview.widget.ItemTouchHelper;
import com.gme.liteav.base.ContextUtils;
import com.gme.liteav.base.Log;
import com.gme.liteav.base.annotations.JNINamespace;
import com.gme.liteav.base.system.LiteavSystemInfo;
import com.gme.liteav.base.util.HttpDnsUtil;
import com.gme.liteav.base.util.LiteavLog;
import com.gme.p007av.sdk.AVError;
import j$.util.concurrent.ConcurrentHashMap;
import java.io.ByteArrayOutputStream;
import java.io.Closeable;
import java.io.EOFException;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Authenticator;
import java.net.ConnectException;
import java.net.HttpURLConnection;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.MalformedURLException;
import java.net.NoRouteToHostException;
import java.net.PasswordAuthentication;
import java.net.ProtocolException;
import java.net.Proxy;
import java.net.SocketException;
import java.net.SocketTimeoutException;
import java.net.URL;
import java.net.UnknownHostException;
import java.nio.ByteBuffer;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;
import javax.net.ssl.SSLException;

@JNINamespace("liteav")
public class HttpClientAndroid {
    private static final int ERROR_CODE_INVALID_REQUEST = 0;
    private static final String HTTPS_PREFIX = "https://";
    private static final String HTTP_PREFIX = "http://";
    private static final String METHOD_GET = "GET";
    private static final String METHOD_POST = "POST";
    private static final String METHOD_PUT = "PUT";
    private static final int READ_STREAM_SIZE = 8192;
    private static final int REDIRECT_REQUEST_MAX = 3;
    private static final String TAG = "HttpClientAndroid";
    private static final Object mLock = new Object();
    private HttpURLConnection mConnection;
    private C1008b mHttpConfig;
    private final Handler mHttpHandler;
    private String mLastRequestURL;
    private long mNativeHttpClientAndroidJni;
    private final ConcurrentHashMap<Long, C1011e> mRunningRequestMap = new ConcurrentHashMap<>();
    private final Object mLocker = new Object();
    private volatile EnumC1009c mInternalState = EnumC1009c.NONE;
    private long mTotalReadBytes = 0;
    private long mStartReadTime = 0;
    byte[] mReadDataBytes = new byte[8192];
    private boolean mPausedRepeatDownloading = false;
    private EnumC1010d mReallyNetworkChannel = EnumC1010d.DEFAULT;
    private ConnectivityManager.NetworkCallback mNetworkCallback = null;
    private EnumC1014h mRepeatDownloadingStatusCode = EnumC1014h.kUnknownError;
    private ByteBuffer mRepeatByteBuffer = null;

    enum EnumC1009c {
        NONE,
        RUNNING_REPEAT,
        RUNNING_ONCE
    }

    public static class C1012f {

        ByteBuffer f657c;

        EnumC1014h f655a = EnumC1014h.kUnknownError;

        String f656b = "";

        int f658d = 0;

        String f659e = "";

        Map<String, String> f660f = null;

        int f661g = 0;

        int f662h = 0;

        String f663i = "";
    }

    private static native boolean nativeOnCallback(long j, boolean z, int i, long j2, int i2, String str, int i3, ByteBuffer byteBuffer, String str2, Map map, int i4, int i5, String str3, int i6);

    private static native void nativeOnUploadProgress(long j, long j2, long j3, long j4);

    enum EnumC1014h {
        kHTTP200OK(ItemTouchHelper.Callback.DEFAULT_DRAG_ANIMATION_DURATION),
        kHTTP204NoContent(204),
        kHTTP206PartialContent(206),
        kHTTP301MovedPermanently(301),
        kHTTP302Found(302),
        kHTTP303SeeOther(303),
        kHTTP304NotModified(304),
        kHTTP307TemporaryRedirect(307),
        kHTTP308PermanentRedirect(308),
        kHTTP403Forbidden(TypedValues.CycleType.TYPE_ALPHA),
        kHTTP404NotFound(404),
        kHTTP405MethodNotAllowed(405),
        kHTTP503ServiceUnavailable(TypedValues.PositionType.TYPE_PERCENT_WIDTH),
        kSystemFileOpenFailed(1001),
        kSystemFileWriteFailed(1002),
        kSystemUnknownHost(1003),
        kSystemConnectHostFailed(1004),
        kSystemCreateSocketFailed(AVError.AV_ERR_TIMEOUT),
        kSystemNetworkDisabled(1006),
        kSystemConnectTimeout(1007),
        kSystemConnectRefused(1008),
        kSystemProtocolError(1009),
        kSystemSSLError(PointerIconCompat.TYPE_ALIAS),
        kUnknownError(1999);

        final int nativeValue;

        EnumC1014h(int i) {
            this.nativeValue = i;
        }
    }

    public static class C1008b {

        int f626a;

        int f627b;

        int f628c;

        boolean f629d;

        int f630e;

        int f631f;

        String f632g;

        String f633h;

        String f634i;

        EnumC1010d f635j;

        C1008b(int i, int i2, int i3, boolean z, int i4, int i5, String str, String str2, String str3, EnumC1010d enumC1010d) {
            this.f626a = i;
            this.f627b = i2;
            this.f628c = i3;
            this.f629d = z;
            this.f630e = i4;
            this.f631f = i5;
            this.f632g = str;
            this.f633h = str2;
            this.f634i = str3;
            this.f635j = enumC1010d;
        }
    }

    public static class C1011e {

        long f644a;

        String f645b;

        String f646c;

        byte[] f647d;

        Map<String, String> f648e;

        int f649f;

        String f650g;

        boolean f651h;

        String f652i;

        byte[] f653j;

        byte[] f654k;

        C1011e(String str, String str2, byte[] bArr, Map<String, String> map, boolean z) {
            this(str, str2, bArr, map, z, "", null, null);
        }

        C1011e(String str, String str2, byte[] bArr, Map<String, String> map, boolean z, String str3, byte[] bArr2, byte[] bArr3) {
            this.f645b = str;
            this.f646c = str2;
            this.f647d = bArr;
            this.f648e = map;
            this.f649f = 0;
            this.f650g = "";
            this.f651h = z;
            this.f652i = str3;
            this.f653j = bArr2;
            this.f654k = bArr3;
        }

        final boolean m957a() {
            if (TextUtils.isEmpty(this.f645b)) {
                return false;
            }
            return this.f645b.startsWith(HttpClientAndroid.HTTP_PREFIX) || this.f645b.startsWith(HttpClientAndroid.HTTPS_PREFIX);
        }

        final boolean m958b() {
            byte[] bArr = this.f647d;
            return bArr != null && bArr.length > 0;
        }

        final boolean m959c() {
            return HttpClientAndroid.METHOD_POST.equals(m960d()) || HttpClientAndroid.METHOD_PUT.equals(m960d());
        }

        final String m960d() {
            if (TextUtils.isEmpty(this.f646c)) {
                return "";
            }
            if (HttpClientAndroid.METHOD_POST.equalsIgnoreCase(this.f646c)) {
                return HttpClientAndroid.METHOD_POST;
            }
            if (HttpClientAndroid.METHOD_GET.equalsIgnoreCase(this.f646c)) {
                return HttpClientAndroid.METHOD_GET;
            }
            return HttpClientAndroid.METHOD_PUT.equalsIgnoreCase(this.f646c) ? HttpClientAndroid.METHOD_PUT : "";
        }

        public final String toString() {
            StringBuilder sb = new StringBuilder("Request{requestId=");
            sb.append(this.f644a);
            sb.append(", url='");
            sb.append(this.f645b);
            sb.append("', method='");
            sb.append(this.f646c);
            sb.append("', body.size=");
            sb.append(m958b() ? this.f647d.length : 0);
            sb.append(", headers=");
            sb.append(this.f648e);
            sb.append(", autoRedirect=");
            sb.append(this.f651h);
            sb.append('}');
            return sb.toString();
        }
    }

    public enum EnumC1013g {
        CONNECTED(0),
        DISCONNECTED(1),
        FINISHED(2);

        int nativeValue;

        EnumC1013g(int i) {
            this.nativeValue = i;
        }
    }

    public enum EnumC1010d {
        DEFAULT(0),
        WIFI(1),
        CELLULAR(2);

        int nativeValue;

        EnumC1010d(int i) {
            this.nativeValue = i;
        }

        public static EnumC1010d m956a(int i) {
            for (EnumC1010d enumC1010d : values()) {
                if (enumC1010d.nativeValue == i) {
                    return enumC1010d;
                }
            }
            LiteavLog.m998i(HttpClientAndroid.TAG, "Invalid value:".concat(String.valueOf(i)));
            return DEFAULT;
        }
    }

    static class C1007a extends Authenticator {

        String f624a;

        String f625b;

        C1007a(String str, String str2) {
            this.f624a = str;
            this.f625b = str2;
        }

        @Override
        protected final PasswordAuthentication getPasswordAuthentication() {
            return new PasswordAuthentication(this.f624a, this.f625b.toCharArray());
        }
    }

    public HttpClientAndroid(int i, int i2, int i3, boolean z, int i4, int i5, String str, String str2, String str3, int i6, long j) {
        Handler handler = null;
        try {
            this.mHttpConfig = new C1008b(i, i2, i3, z, i4, i5, str, str2, str3, EnumC1010d.m956a(i6));
            this.mNativeHttpClientAndroidJni = j;
            HandlerThread handlerThread = new HandlerThread("HttpClient_" + hashCode());
            handlerThread.start();
            LiteavLog.m998i(TAG, "Create http client(" + hashCode() + "). [ThreadName:" + handlerThread.getName() + "][ThreadId:" + handlerThread.getId() + "]");
            handler = new Handler(handlerThread.getLooper());
        } catch (Throwable th) {
            LiteavLog.m995e(TAG, "HttpClientAndroid failed.", th);
        }
        this.mHttpHandler = handler;
    }

    public long send(long j, String str, String str2, byte[] bArr, Map<String, String> map, boolean z, boolean z2) {
        try {
            if (!checkNativeValid()) {
                LiteavLog.m994e(TAG, "(" + hashCode() + ")Send request failed. Invalid native handle.");
                return 0L;
            }
            try {
                return sendInternal(j, new C1011e(str, str2, bArr, map, z2), z);
            } catch (Throwable th) {
                th = th;
                LiteavLog.m995e(TAG, "send failed.", th);
                return 0L;
            }
        } catch (Throwable th2) {
            th = th2;
        }
    }

    public long uploadFile(long j, String str, String str2, byte[] bArr, Map<String, String> map, boolean z, boolean z2, String str3, byte[] bArr2, byte[] bArr3) {
        try {
            if (!checkNativeValid()) {
                LiteavLog.m994e(TAG, "(" + hashCode() + ")upload file failed. Invalid native handle.");
                return 0L;
            }
            if (str3.isEmpty()) {
                LiteavLog.m994e(TAG, "(" + hashCode() + ")upload file failed. Invalid file path(" + str3 + ").");
                return 0L;
            }
            try {
                return sendInternal(j, new C1011e(str, str2, bArr, map, z2, str3, bArr2, bArr3), z);
            } catch (Throwable th) {
                th = th;
                LiteavLog.m995e(TAG, "uploadFile failed.", th);
                return 0L;
            }
        } catch (Throwable th2) {
            th = th2;
        }
    }

    private long sendInternal(long j, C1011e c1011e, boolean z) {
        if (c1011e == null || !c1011e.m957a()) {
            LiteavLog.m994e(TAG, "(" + hashCode() + ")upload file failed. Invalid request url(" + c1011e.f645b + ").");
            return 0L;
        }
        if (TextUtils.isEmpty(c1011e.m960d())) {
            LiteavLog.m994e(TAG, "(" + hashCode() + ")upload file failed. Request method(" + c1011e.f646c + ") is not supported.");
            return 0L;
        }
        synchronized (this.mLocker) {
            if (this.mInternalState == EnumC1009c.NONE) {
                this.mInternalState = z ? EnumC1009c.RUNNING_REPEAT : EnumC1009c.RUNNING_ONCE;
            } else if (this.mInternalState != EnumC1009c.RUNNING_ONCE) {
                LiteavLog.m994e(TAG, "(" + hashCode() + ")Send request failed. Invalid state:" + this.mInternalState);
                return 0L;
            }
            c1011e.f644a = j;
            this.mRunningRequestMap.put(Long.valueOf(j), c1011e);
            this.mHttpHandler.post(RunnableC1015a.m961a(this, c1011e));
            return c1011e.f644a;
        }
    }

    public void cancel(long j) {
        try {
            synchronized (this.mLocker) {
                if (!checkNativeValid()) {
                    LiteavLog.m994e(TAG, "(" + hashCode() + ")Cancel request failed. Invalid native handle.");
                    return;
                }
                if (this.mRunningRequestMap.size() == 0) {
                    return;
                }
                LiteavLog.m998i(TAG, "(" + hashCode() + ")Cancel request. request:" + ((C1011e) this.mRunningRequestMap.remove(Long.valueOf(j))));
                if (this.mRunningRequestMap.size() == 0) {
                    this.mInternalState = EnumC1009c.NONE;
                }
            }
        } catch (Throwable th) {
            LiteavLog.m995e(TAG, "cancel failed.", th);
        }
    }

    public void cancelAll() {
        try {
            synchronized (this.mLocker) {
                if (!checkNativeValid()) {
                    LiteavLog.m994e(TAG, "(" + hashCode() + ")Cancel all request failed. Invalid native handle.");
                    return;
                }
                if (this.mInternalState == EnumC1009c.NONE) {
                    return;
                }
                this.mInternalState = EnumC1009c.NONE;
                LiteavLog.m998i(TAG, "(" + hashCode() + ")Cancel all. size:" + this.mRunningRequestMap.size());
                this.mRunningRequestMap.clear();
                this.mHttpHandler.post(RunnableC1016b.m962a(this));
            }
        } catch (Throwable th) {
            LiteavLog.m995e(TAG, "cancelAll failed.", th);
        }
    }

    static void lambda$cancelAll$1(HttpClientAndroid httpClientAndroid) {
        httpClientAndroid.closeConnectionSafely(httpClientAndroid.mConnection);
        httpClientAndroid.mConnection = null;
    }

    public void resumeRepeatDownload(long j) {
        try {
            synchronized (this.mLocker) {
                if (!checkNativeValid()) {
                    LiteavLog.m994e(TAG, "(" + hashCode() + ")Cancel request failed. Invalid native handle.");
                    return;
                }
                if (this.mRunningRequestMap.size() == 0) {
                    return;
                }
                if (this.mInternalState == EnumC1009c.RUNNING_REPEAT && this.mPausedRepeatDownloading) {
                    this.mPausedRepeatDownloading = false;
                    if (j == 0) {
                        Iterator it = this.mRunningRequestMap.keySet().iterator();
                        while (it.hasNext()) {
                            this.mHttpHandler.post(RunnableC1017c.m963a(this, (Long) it.next()));
                        }
                    } else if (checkRequestValid(j)) {
                        if (((C1011e) this.mRunningRequestMap.get(Long.valueOf(j))) == null) {
                        } else {
                            this.mHttpHandler.post(RunnableC1018d.m964a(this, j));
                        }
                    }
                }
            }
        } catch (Throwable th) {
            LiteavLog.m995e(TAG, "resumeRepeatDownload failed.", th);
        }
    }

    static void lambda$resumeRepeatDownload$2(HttpClientAndroid httpClientAndroid, Long l) {
        C1012f c1012f = new C1012f();
        c1012f.f655a = httpClientAndroid.mRepeatDownloadingStatusCode;
        httpClientAndroid.doReadData(l.longValue(), c1012f);
    }

    static void lambda$resumeRepeatDownload$3(HttpClientAndroid httpClientAndroid, long j) {
        C1012f c1012f = new C1012f();
        c1012f.f655a = httpClientAndroid.mRepeatDownloadingStatusCode;
        httpClientAndroid.doReadData(j, c1012f);
    }

    public void destroy() {
        try {
            synchronized (this.mLocker) {
                this.mRunningRequestMap.clear();
                this.mNativeHttpClientAndroidJni = -1L;
                this.mHttpHandler.post(RunnableC1019e.m965a(this));
            }
        } catch (Throwable th) {
            LiteavLog.m995e(TAG, "destroy failed.", th);
        }
    }

    static void lambda$destroy$4(HttpClientAndroid httpClientAndroid) {
        httpClientAndroid.closeConnectionSafely(httpClientAndroid.mConnection);
        httpClientAndroid.mConnection = null;
        if (LiteavSystemInfo.getSystemOSVersionInt() >= 18) {
            httpClientAndroid.mHttpHandler.getLooper().quitSafely();
        } else {
            httpClientAndroid.mHttpHandler.getLooper().quit();
        }
    }

    public void updateConfig(final int i, final int i2, final int i3, final boolean z, final int i4, final int i5, final String str, final String str2, final String str3, final int i6, long j) {
        try {
            this.mHttpHandler.post(new Runnable() {
                @Override
                public final void run() {
                    HttpClientAndroid.this.mHttpConfig = new C1008b(i, i2, i3, z, i4, i5, str, str2, str3, EnumC1010d.m956a(i6));
                    HttpClientAndroid.this.mReallyNetworkChannel = EnumC1010d.DEFAULT;
                    if (i4 > 0) {
                        HttpClientAndroid.this.mTotalReadBytes = 0L;
                        HttpClientAndroid.this.mStartReadTime = SystemClock.elapsedRealtime();
                    }
                }
            });
        } catch (Throwable th) {
            LiteavLog.m995e(TAG, "updateConfig failed.", th);
        }
    }

    private boolean checkRequestValid(long j) {
        return this.mRunningRequestMap.containsKey(Long.valueOf(j));
    }

    private boolean checkNativeValid() {
        boolean z;
        synchronized (this.mLocker) {
            z = this.mNativeHttpClientAndroidJni != -1;
        }
        return z;
    }

    private HttpURLConnection createConnection(C1011e c1011e) throws Exception {
        Proxy proxy;
        HttpURLConnection httpURLConnectionCreateConnection;
        String strReplace = c1011e.f645b.replace(" ", "%20");
        URL url = new URL(strReplace);
        if (!TextUtils.isEmpty(this.mHttpConfig.f632g) && this.mHttpConfig.f631f > 0) {
            proxy = new Proxy(Proxy.Type.SOCKS, new InetSocketAddress(this.mHttpConfig.f632g, this.mHttpConfig.f631f));
            Authenticator.setDefault(new C1007a(this.mHttpConfig.f633h, this.mHttpConfig.f634i));
        } else {
            proxy = ("127.0.0.1".equals(url.getHost()) || "localhost".equals(url.getHost())) ? Proxy.NO_PROXY : null;
        }
        if (proxy != null) {
            httpURLConnectionCreateConnection = createConnection(url, proxy);
        } else if (HttpDnsUtil.verifyCustomHttpDNS(url.getHost())) {
            try {
                String strConvertHttpDNSURL = HttpDnsUtil.convertHttpDNSURL(strReplace, url.getHost());
                if (!TextUtils.isEmpty(strConvertHttpDNSURL)) {
                    httpURLConnectionCreateConnection = createConnection(new URL(strConvertHttpDNSURL), null);
                    httpURLConnectionCreateConnection.setRequestProperty("Host", url.getHost());
                    HttpDnsUtil.applySniForHttpsConnection(httpURLConnectionCreateConnection, url.getHost());
                } else {
                    httpURLConnectionCreateConnection = createConnection(new URL(strReplace), null);
                }
            } catch (Exception e) {
                LiteavLog.m1004w(TAG, "(" + hashCode() + ")createConnectionUseCustomHttpDNS failed. error: " + Log.getStackTraceString(e));
                httpURLConnectionCreateConnection = createConnection(url, null);
            }
        } else {
            httpURLConnectionCreateConnection = createConnection(url, null);
        }
        httpURLConnectionCreateConnection.setInstanceFollowRedirects(false);
        httpURLConnectionCreateConnection.setConnectTimeout(this.mHttpConfig.f626a);
        httpURLConnectionCreateConnection.setReadTimeout(this.mHttpConfig.f627b);
        httpURLConnectionCreateConnection.setRequestProperty("Accept-Encoding", "identity");
        httpURLConnectionCreateConnection.setRequestMethod(c1011e.m960d());
        if (c1011e.m959c()) {
            httpURLConnectionCreateConnection.setDoOutput(true);
        }
        if (this.mHttpConfig.f629d) {
            httpURLConnectionCreateConnection.setRequestProperty("Connection", "Keep-Alive");
        } else {
            httpURLConnectionCreateConnection.setRequestProperty("Connection", "close");
        }
        if (c1011e.f648e != null && !c1011e.f648e.isEmpty()) {
            for (Map.Entry<String, String> entry : c1011e.f648e.entrySet()) {
                httpURLConnectionCreateConnection.setRequestProperty(entry.getKey(), entry.getValue());
            }
        }
        return httpURLConnectionCreateConnection;
    }

    private HttpURLConnection createConnection(URL url, Proxy proxy) throws Exception {
        if (LiteavSystemInfo.getSystemOSVersionInt() < 23) {
            return openConnection(url, proxy);
        }
        if (this.mHttpConfig.f635j == EnumC1010d.DEFAULT) {
            return openConnection(url, proxy);
        }
        HttpURLConnection httpURLConnectionCreateConnectionByNetworkType = createConnectionByNetworkType(url, proxy);
        return httpURLConnectionCreateConnectionByNetworkType != null ? httpURLConnectionCreateConnectionByNetworkType : openConnection(url, proxy);
    }

    private HttpURLConnection createConnectionByNetworkType(final URL url, final Proxy proxy) {
        int i;
        if (this.mHttpConfig.f635j == EnumC1010d.WIFI) {
            i = 1;
        } else {
            if (this.mHttpConfig.f635j != EnumC1010d.CELLULAR) {
                return null;
            }
            i = 0;
        }
        final CountDownLatch countDownLatch = new CountDownLatch(1);
        final HttpURLConnection[] httpURLConnectionArr = {null};
        NetworkRequest networkRequestBuild = new NetworkRequest.Builder().addCapability(12).addTransportType(i).build();
        ConnectivityManager connectivityManager = (ConnectivityManager) ContextUtils.getApplicationContext().getSystemService("connectivity");
        ConnectivityManager.NetworkCallback networkCallback = new ConnectivityManager.NetworkCallback() {
            @Override
            public final void onAvailable(Network network) {
                HttpClientAndroid httpClientAndroid = HttpClientAndroid.this;
                httpClientAndroid.mReallyNetworkChannel = httpClientAndroid.mHttpConfig.f635j;
                LiteavLog.m998i(HttpClientAndroid.TAG, "(" + HttpClientAndroid.this.hashCode() + ")createConnectionSpecifyNetwork onAvailable.");
                try {
                    try {
                        Proxy proxy2 = proxy;
                        if (proxy2 == null) {
                            httpURLConnectionArr[0] = (HttpURLConnection) network.openConnection(url);
                        } else {
                            httpURLConnectionArr[0] = (HttpURLConnection) network.openConnection(url, proxy2);
                        }
                    } catch (IOException e) {
                        LiteavLog.m1004w(HttpClientAndroid.TAG, "(" + HttpClientAndroid.this.hashCode() + ")createConnectionSpecifyNetwork failed. error: " + Log.getStackTraceString(e));
                    }
                } finally {
                    countDownLatch.countDown();
                }
            }

            @Override
            public final void onLost(Network network) {
                LiteavLog.m1004w(HttpClientAndroid.TAG, "(" + HttpClientAndroid.this.hashCode() + ")createConnectionSpecifyNetwork onLost.");
                countDownLatch.countDown();
            }
        };
        this.mNetworkCallback = networkCallback;
        connectivityManager.requestNetwork(networkRequestBuild, networkCallback);
        try {
            countDownLatch.await(2L, TimeUnit.SECONDS);
        } catch (InterruptedException unused) {
            LiteavLog.m1004w(TAG, "(" + hashCode() + ")createConnectionSpecifyNetwork timeout.");
        }
        if (httpURLConnectionArr[0] != null) {
            LiteavLog.m998i(TAG, "(" + hashCode() + ")createConnectionSpecifyNetwork success.");
        } else {
            LiteavLog.m1004w(TAG, "(" + hashCode() + ")createConnectionSpecifyNetwork lost or timeout.");
        }
        return httpURLConnectionArr[0];
    }

    private HttpURLConnection openConnection(URL url, Proxy proxy) throws Exception {
        if (proxy != null) {
            return (HttpURLConnection) url.openConnection(proxy);
        }
        return (HttpURLConnection) url.openConnection();
    }

    private void closeConnectionSafely(HttpURLConnection httpURLConnection) {
        if (this.mNetworkCallback != null && LiteavSystemInfo.getSystemOSVersionInt() >= 23) {
            try {
                try {
                    ((ConnectivityManager) ContextUtils.getApplicationContext().getSystemService("connectivity")).unregisterNetworkCallback(this.mNetworkCallback);
                } catch (Throwable th) {
                    this.mNetworkCallback = null;
                    throw th;
                }
            } catch (Exception e) {
                LiteavLog.m1004w(TAG, "(" + hashCode() + ")" + Log.getStackTraceString(e));
            }
            this.mNetworkCallback = null;
        }
        if (httpURLConnection != null) {
            try {
                closeIO(httpURLConnection.getInputStream());
            } catch (Exception e2) {
                e2.printStackTrace();
            } finally {
                try {
                    httpURLConnection.disconnect();
                } catch (Exception e3) {
                    e3.printStackTrace();
                }
            }
        }
    }

    private void closeIO(Closeable closeable) {
        if (closeable != null) {
            try {
                closeable.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public void doRequest(C1011e c1011e) {
        C1012f c1012fInternalRequest = null;
        for (int i = 0; i < 4; i++) {
            c1012fInternalRequest = internalRequest(c1011e);
            if (c1012fInternalRequest == null) {
                return;
            }
            if (!c1011e.f651h || (c1012fInternalRequest.f655a != EnumC1014h.kHTTP301MovedPermanently && c1012fInternalRequest.f655a != EnumC1014h.kHTTP302Found)) {
                break;
            }
            c1011e.f645b = this.mConnection.getHeaderField("Location");
            c1011e.f649f++;
            c1011e.f650g = c1011e.f645b;
        }
        this.mTotalReadBytes = 0L;
        this.mStartReadTime = SystemClock.elapsedRealtime();
        doReadData(c1011e.f644a, c1012fInternalRequest);
    }

    private void uploadFileByPath(C1011e c1011e, OutputStream outputStream) throws Exception {
        long j;
        if (TextUtils.isEmpty(c1011e.f652i)) {
            return;
        }
        Closeable closeable = null;
        try {
            File file = new File(c1011e.f652i);
            FileInputStream fileInputStream = new FileInputStream(file);
            try {
                byte[] bArr = new byte[524288];
                long length = file.length();
                long j2 = 0;
                while (true) {
                    int i = fileInputStream.read(bArr);
                    if (i != -1) {
                        synchronized (this.mLocker) {
                            if (!checkRequestValid(c1011e.f644a) || !checkNativeValid()) {
                                break;
                                break;
                            } else {
                                j = j2 + ((long) i);
                                outputStream.write(bArr, 0, i);
                                nativeOnUploadProgress(this.mNativeHttpClientAndroidJni, c1011e.f644a, j, length);
                            }
                        }
                    }
                    closeIO(fileInputStream);
                    j2 = j;
                }
                closeIO(fileInputStream);
            } catch (Throwable th) {
                th = th;
                closeable = fileInputStream;
                closeIO(closeable);
                throw th;
            }
        } catch (Throwable th2) {
            th = th2;
        }
    }

    private void writeRequestBody(C1011e c1011e) {
        OutputStream outputStream = null;
        try {
            if (c1011e.m959c() && c1011e.m958b()) {
                outputStream = this.mConnection.getOutputStream();
                outputStream.write(c1011e.f647d);
                outputStream.flush();
            } else if (c1011e.m959c() && !TextUtils.isEmpty(c1011e.f652i)) {
                outputStream = this.mConnection.getOutputStream();
                if (c1011e.f653j != null && c1011e.f653j.length > 0) {
                    outputStream.write(c1011e.f653j);
                }
                uploadFileByPath(c1011e, outputStream);
                if (c1011e.f654k != null && c1011e.f654k.length > 0) {
                    outputStream.write(c1011e.f654k);
                }
                outputStream.flush();
            }
        } catch (Exception e) {
            e.printStackTrace();
            LiteavLog.m1004w(TAG, "(" + hashCode() + ")Do write request body failed.");
        } finally {
            closeIO(null);
        }
    }

    private C1012f internalRequest(C1011e c1011e) {
        boolean z;
        if (!c1011e.m957a()) {
            LiteavLog.m994e(TAG, "(" + hashCode() + ")Send request failed. Invalid request url(" + c1011e.f645b + ").");
            return null;
        }
        if (!checkRequestValid(c1011e.f644a)) {
            LiteavLog.m1004w(TAG, "(" + hashCode() + ")Do send failed. ignore request when cancelled. request:" + c1011e);
            return null;
        }
        C1012f c1012f = new C1012f();
        c1012f.f662h = c1011e.f649f;
        c1012f.f663i = c1011e.f650g;
        synchronized (this.mLocker) {
            z = this.mInternalState == EnumC1009c.RUNNING_ONCE;
        }
        if (z && this.mConnection != null && !c1011e.f645b.equals(this.mLastRequestURL)) {
            closeConnectionSafely(this.mConnection);
            this.mConnection = null;
        }
        this.mLastRequestURL = c1011e.f645b;
        try {
            this.mConnection = createConnection(c1011e);
            writeRequestBody(c1011e);
            try {
                c1012f.f655a = getStatusCode(this.mConnection.getResponseCode());
                c1012f.f656b = this.mConnection.getResponseMessage();
                c1012f.f659e = parseHostAddress(this.mConnection.getURL().getHost());
                c1012f.f661g = this.mConnection.getURL().getPort();
                c1012f.f660f = getResponseHeaders(this.mConnection.getHeaderFields());
                if (checkRequestValid(c1011e.f644a)) {
                    return c1012f;
                }
                closeConnectionSafely(this.mConnection);
                LiteavLog.m1004w(TAG, "(" + hashCode() + ")Do send failed. Invalid request, abort request.");
                return null;
            } catch (Exception e) {
                e.printStackTrace();
                LiteavLog.m994e(TAG, "(" + hashCode() + ")Do send failed. Catch error. ex= " + Log.getStackTraceString(e));
                c1012f.f655a = getStatusCode(e);
                c1012f.f656b = e.toString();
                doCallbackAndResetState(EnumC1013g.DISCONNECTED, c1011e.f644a, c1012f, true);
                return null;
            }
        } catch (Exception e2) {
            e2.printStackTrace();
            LiteavLog.m994e(TAG, "(" + hashCode() + ")Do send failed. Fail to create http connection. ex= " + Log.getStackTraceString(e2));
            c1012f.f655a = getStatusCode(e2);
            c1012f.f656b = e2.toString();
            doCallbackAndResetState(EnumC1013g.DISCONNECTED, c1011e.f644a, c1012f, true);
            return null;
        }
    }

    private void doReadData(long j, C1012f c1012f) {
        boolean z;
        long jElapsedRealtime;
        if (!checkRequestValid(j)) {
            closeConnectionSafely(this.mConnection);
            LiteavLog.m1004w(TAG, "(" + hashCode() + ")Do read data failed. Invalid request id. id:" + j);
            return;
        }
        try {
            InputStream inputStream = this.mConnection.getInputStream();
            synchronized (this.mLocker) {
                z = this.mInternalState == EnumC1009c.RUNNING_ONCE;
            }
            long j2 = 0;
            if (z) {
                try {
                    ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
                    do {
                        int i = inputStream.read(this.mReadDataBytes);
                        if (i > 0) {
                            byteArrayOutputStream.write(this.mReadDataBytes, 0, i);
                        }
                        if (i <= 0) {
                            break;
                        }
                    } while (checkRequestValid(j));
                    int size = byteArrayOutputStream.size();
                    if (size > 0) {
                        c1012f.f657c = ByteBuffer.allocateDirect(size);
                        c1012f.f657c.put(byteArrayOutputStream.toByteArray(), 0, size);
                        c1012f.f658d = size;
                    }
                    jElapsedRealtime = 0;
                } catch (Throwable th) {
                    th.printStackTrace();
                    LiteavLog.m994e(TAG, "(" + hashCode() + ")Do read data failed. Catch error when reading.");
                    c1012f.f655a = getStatusCode(th);
                    c1012f.f656b = th.toString();
                    doCallbackAndResetState(EnumC1013g.DISCONNECTED, j, c1012f, true);
                    return;
                }
            } else {
                try {
                    int i2 = inputStream.read(this.mReadDataBytes);
                    this.mTotalReadBytes += (long) i2;
                    jElapsedRealtime = SystemClock.elapsedRealtime();
                    if (i2 > 0) {
                        ByteBuffer byteBuffer = this.mRepeatByteBuffer;
                        if (byteBuffer == null || byteBuffer.capacity() < i2) {
                            this.mRepeatByteBuffer = ByteBuffer.allocateDirect(i2);
                        }
                        this.mRepeatByteBuffer.clear();
                        this.mRepeatByteBuffer.put(this.mReadDataBytes, 0, i2);
                        c1012f.f657c = this.mRepeatByteBuffer;
                        c1012f.f658d = i2;
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    LiteavLog.m994e(TAG, "(" + hashCode() + ")Do read data failed. Catch error when reading.");
                    c1012f.f655a = getStatusCode(e);
                    c1012f.f656b = e.toString();
                    doCallbackAndResetState(EnumC1013g.DISCONNECTED, j, c1012f, true);
                    return;
                }
            }
            if (c1012f.f658d == 0 && !z) {
                LiteavLog.m1004w(TAG, "(" + hashCode() + ")Do read data failed. Rsp size is 0.");
                doCallbackAndResetState(EnumC1013g.FINISHED, j, c1012f, this.mHttpConfig.f629d ^ true);
                return;
            }
            if (z) {
                doCallbackAndResetState(EnumC1013g.FINISHED, j, c1012f, !this.mHttpConfig.f629d);
                return;
            }
            this.mPausedRepeatDownloading = doOnCallback(EnumC1013g.CONNECTED, j, c1012f);
            this.mRepeatDownloadingStatusCode = c1012f.f655a;
            if (this.mPausedRepeatDownloading) {
                return;
            }
            if (this.mHttpConfig.f630e > 0) {
                long j3 = this.mStartReadTime;
                long j4 = jElapsedRealtime - j3 == 0 ? 1L : jElapsedRealtime - j3;
                if (this.mTotalReadBytes / j4 > this.mHttpConfig.f630e / 1000) {
                    j2 = ((this.mTotalReadBytes * 1000) / ((long) this.mHttpConfig.f630e)) - j4;
                }
            }
            this.mHttpHandler.postDelayed(RunnableC1020f.m966a(this, c1012f, j), j2);
        } catch (Exception e2) {
            e2.printStackTrace();
            LiteavLog.m994e(TAG, "(" + hashCode() + ")Do read data failed. Fail to get InputStream.");
            c1012f.f655a = getStatusCode(e2);
            c1012f.f656b = e2.toString();
            doCallbackAndResetState(EnumC1013g.DISCONNECTED, j, c1012f, true);
        }
    }

    static void lambda$doReadData$5(HttpClientAndroid httpClientAndroid, C1012f c1012f, long j) {
        C1012f c1012f2 = new C1012f();
        c1012f2.f655a = c1012f.f655a;
        httpClientAndroid.doReadData(j, c1012f2);
    }

    private String parseHostAddress(String str) {
        try {
            return InetAddress.getByName(str).getHostAddress();
        } catch (Exception unused) {
            LiteavLog.m1004w(TAG, "(" + hashCode() + ")Parse host error. host:" + str);
            return "";
        }
    }

    private Map<String, String> getResponseHeaders(Map<String, List<String>> map) {
        HashMap map2 = new HashMap();
        for (Map.Entry<String, List<String>> entry : map.entrySet()) {
            if (!TextUtils.isEmpty(entry.getKey())) {
                map2.put(entry.getKey(), entry.getValue().get(0));
            }
        }
        return map2;
    }

    private void doCallbackAndResetState(EnumC1013g enumC1013g, long j, C1012f c1012f, boolean z) {
        synchronized (this.mLocker) {
            boolean z2 = checkNativeValid() && checkRequestValid(j) && c1012f != null;
            boolean z3 = EnumC1009c.RUNNING_REPEAT == this.mInternalState;
            this.mRunningRequestMap.remove(Long.valueOf(j));
            if (this.mRunningRequestMap.size() == 0) {
                this.mInternalState = EnumC1009c.NONE;
            }
            if (z2) {
                nativeOnCallback(this.mNativeHttpClientAndroidJni, z3, enumC1013g.nativeValue, j, c1012f.f655a.nativeValue, c1012f.f656b, c1012f.f661g, c1012f.f657c, c1012f.f659e, c1012f.f660f, c1012f.f658d, c1012f.f662h, c1012f.f663i, this.mReallyNetworkChannel.nativeValue);
            }
        }
        if (z) {
            closeConnectionSafely(this.mConnection);
            this.mConnection = null;
        }
    }

    private boolean doOnCallback(EnumC1013g enumC1013g, long j, C1012f c1012f) {
        synchronized (this.mLocker) {
            if (!checkNativeValid() || !checkRequestValid(j) || c1012f == null) {
                return false;
            }
            return nativeOnCallback(this.mNativeHttpClientAndroidJni, EnumC1009c.RUNNING_REPEAT == this.mInternalState, enumC1013g.nativeValue, j, c1012f.f655a.nativeValue, c1012f.f656b, c1012f.f661g, c1012f.f657c, c1012f.f659e, c1012f.f660f, c1012f.f658d, c1012f.f662h, c1012f.f663i, this.mReallyNetworkChannel.nativeValue);
        }
    }

    public static String[] getMapKeys(Map<String, String> map) {
        if (map != null) {
            try {
                if (!map.isEmpty()) {
                    Set<String> setKeySet = map.keySet();
                    return (String[]) setKeySet.toArray(new String[setKeySet.size()]);
                }
            } catch (Throwable th) {
                LiteavLog.m995e(TAG, "getMapKeys failed.", th);
                return null;
            }
        }
        return new String[0];
    }

    public static String[] getMapValue(Map<String, String> map, String[] strArr) {
        if (map != null) {
            try {
                if (!map.isEmpty() && strArr != null && strArr.length != 0) {
                    String[] strArr2 = new String[strArr.length];
                    for (int i = 0; i < strArr.length; i++) {
                        strArr2[i] = map.get(strArr[i]);
                    }
                    return strArr2;
                }
            } catch (Throwable th) {
                LiteavLog.m995e(TAG, "getMapValue failed.", th);
                return null;
            }
        }
        return new String[0];
    }

    public static HashMap getJavaHashMap(String[] strArr, String[] strArr2) {
        if (strArr != null) {
            try {
                if (strArr.length != 0 && strArr2 != null && strArr2.length != 0) {
                    if (strArr.length != strArr2.length) {
                        LiteavLog.m1004w(TAG, "Invalid parameter, keys and values do not match.");
                        return new HashMap();
                    }
                    HashMap map = new HashMap();
                    for (int i = 0; i < strArr.length; i++) {
                        map.put(strArr[i], strArr2[i]);
                    }
                    return map;
                }
            } catch (Throwable th) {
                LiteavLog.m995e(TAG, "getJavaHashMap failed.", th);
                return null;
            }
        }
        return new HashMap();
    }

    private EnumC1014h getStatusCode(int i) {
        EnumC1014h enumC1014h = EnumC1014h.kUnknownError;
        if (i == 200) {
            return EnumC1014h.kHTTP200OK;
        }
        if (i == 204) {
            return EnumC1014h.kHTTP204NoContent;
        }
        if (i == 206) {
            return EnumC1014h.kHTTP206PartialContent;
        }
        if (i == 301) {
            return EnumC1014h.kHTTP301MovedPermanently;
        }
        if (i == 302) {
            return EnumC1014h.kHTTP302Found;
        }
        if (i == 303) {
            return EnumC1014h.kHTTP303SeeOther;
        }
        if (i == 304) {
            return EnumC1014h.kHTTP304NotModified;
        }
        if (i == 307) {
            return EnumC1014h.kHTTP307TemporaryRedirect;
        }
        if (i == 308) {
            return EnumC1014h.kHTTP308PermanentRedirect;
        }
        if (i == 403) {
            return EnumC1014h.kHTTP403Forbidden;
        }
        if (i == 404) {
            return EnumC1014h.kHTTP404NotFound;
        }
        if (i == 405) {
            return EnumC1014h.kHTTP405MethodNotAllowed;
        }
        if (i == 503) {
            return EnumC1014h.kHTTP503ServiceUnavailable;
        }
        Log.m951w(TAG, "(" + hashCode() + ")Failed to convert status code：" + i, new Object[0]);
        return enumC1014h;
    }

    private EnumC1014h getStatusCode(Throwable th) {
        EnumC1014h enumC1014h = EnumC1014h.kUnknownError;
        if (th instanceof FileNotFoundException) {
            return EnumC1014h.kSystemFileOpenFailed;
        }
        if (th instanceof EOFException) {
            return EnumC1014h.kSystemFileWriteFailed;
        }
        if (th instanceof UnknownHostException) {
            return EnumC1014h.kSystemUnknownHost;
        }
        if (th instanceof NoRouteToHostException) {
            return EnumC1014h.kSystemConnectHostFailed;
        }
        if ((th instanceof SocketException) || (th instanceof MalformedURLException)) {
            return EnumC1014h.kSystemCreateSocketFailed;
        }
        if (th instanceof SocketTimeoutException) {
            return EnumC1014h.kSystemConnectTimeout;
        }
        if (th instanceof ConnectException) {
            return EnumC1014h.kSystemConnectRefused;
        }
        if (th instanceof ProtocolException) {
            return EnumC1014h.kSystemProtocolError;
        }
        if (th instanceof SSLException) {
            return EnumC1014h.kSystemSSLError;
        }
        Log.m951w(TAG, "(" + hashCode() + ")Failed to convert status code, exception：", th.toString());
        return enumC1014h;
    }
}
