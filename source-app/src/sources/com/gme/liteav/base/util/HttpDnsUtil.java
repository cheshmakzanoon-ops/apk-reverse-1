package com.gme.liteav.base.util;

import android.net.SSLCertificateSocketFactory;
import android.os.SystemClock;
import android.text.TextUtils;
import android.util.Base64;
import com.facebook.internal.security.CertificateUtil;
import com.gme.liteav.base.Log;
import com.gme.liteav.base.annotations.JNINamespace;
import java.io.IOException;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.net.HttpURLConnection;
import java.net.Inet4Address;
import java.net.Inet6Address;
import java.net.InetAddress;
import java.net.Socket;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLPeerUnverifiedException;
import javax.net.ssl.SSLSession;
import javax.net.ssl.SSLSocket;
import javax.net.ssl.SSLSocketFactory;

@JNINamespace("liteav::dns")
public class HttpDnsUtil {
    private static final String TAG = "HttpDnsUtil";
    private static final List<String> WHITE_LIST_HOST;
    private static InterfaceC1045a mCustomHttpDNSCallback = null;
    private static boolean mEnableCustomHttpDNS = false;
    private static final Object mLock = new Object();
    private static final String sIPV4Regular = "(([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\.){3}([01]?\\d\\d?|2[0-4]\\d|25[0-5])";
    private static final String sVClass = "amF2YXgubmV0LnNzbC5Ib3N0bmFtZVZlcmlmaWVy";
    private static Pattern sValidIPV4Pattern = null;
    private static final String sVerifyMethodBase64 = "c2V0SG9zdG5hbWVWZXJpZmllcg";

    public interface InterfaceC1045a {
    }

    static {
        ArrayList arrayList = new ArrayList();
        WHITE_LIST_HOST = arrayList;
        arrayList.add("YVc1MGJDMXpaR3RzYjJjdWRISjBZeTUwWlc1alpXNTBMV05zYjNWa0xtTnZiUT09");
        arrayList.add("WVZjMU1HSkRNWHBhUjNSellqSmpkV1JJU2pCWmVUVXdXbGMxYWxwWE5UQk1WMDV6WWpOV2EweHRUblppVVQwOQ==");
        arrayList.add("aW5sYW5kLXNka2xvZy50cnRjLnRlbmNlbnQtY2xvdWQuY29t");
        arrayList.add("dHJ0Yy1zZGstbG9nLTEyNTgzNDQ2OTkuY29zLmFwLWd1YW5nemhvdS5teXFjbG91ZC5jb20=");
        arrayList.add("dHJ0Yy1zZGstY29uZmlnLTEyNTgzNDQ2OTkuZmlsZS5teXFjbG91ZC5jb20=");
        arrayList.add("bGl0ZWF2LnNkay5xY2xvdWQuY29t");
        arrayList.add("eXVuLnRpbS5xcS5jb20=");
        arrayList.add("dmlkZW9hcGktc2dwLmltLnFjbG91ZC5jb20=");
        arrayList.add("c2RrZGMubGl2ZS5xY2xvdWQuY29t");
        arrayList.add("bWx2YmRjLmxpdmUucWNsb3VkLmNvbQ==");
        arrayList.add("Y29uZi5zZGsucWNsb3VkLmNvbQ==");
        arrayList.add("c3BlZWR0ZXN0aW50LnRydGMudGVuY2VudC1jbG91ZC5jb20=");
        arrayList.add("c3BlZWR0ZXN0LnRydGMudGVuY2VudC1jbG91ZC5jb20=");
        arrayList.add("d2VicnRjLXNpZ25hbC1zY2hlZHVsZXIudGxpdmVzb3VyY2UuY29t");
        arrayList.add("Y2xvdWQudGltLnFxLmNvbQ==");
        arrayList.add("bGl2ZXB1bGwubXlxY2xvdWQuY29t");
        arrayList.add("bGl2ZXB1bGxpcHY2Lm15cWNsb3VkLmNvbQ==");
        arrayList.add("dGNkbnMubXlxY2xvdWQuY29t");
        arrayList.add("dGNkbnNpcHY2Lm15cWNsb3VkLmNvbQ==");
        arrayList.add("bGl0ZWF2YXBwLnFjbG91ZC5jb20=");
        arrayList.add("bGljZW5zZS10ZXN0LnZvZDIubXlxY2xvdWQuY29t");
        arrayList.add("c2RrY29uZmlnLnRsaXZlc291cmNlLmNvbQ==");
        arrayList.add("bWx2YmRjLmxpdmUudGxpdmVzb3VyY2UuY29t");
        arrayList.add("bGljZW5zZS52b2RnbGNkbi5jb20=");
        arrayList.add("bGljZW5zZS52b2QtY29tbW9uLmNvbQ==");
        arrayList.add("bGljZW5zZS52b2RnbGNkbjEuY29t");
        arrayList.add("bGljZW5zZS52b2QtY29tbW9uMS5jb20=");
        arrayList.add("bGljZW5zZS52b2RwbGF5dmlkZW8ubmV0");
        arrayList.add("bGljZW5zZS52b2RwbGF5dmlkZW8uY29t");
    }

    public static void enableCustomHttpDNS(boolean z, InterfaceC1045a interfaceC1045a) {
        LiteavLog.m998i(TAG, "enableCustomHttpDNS: ".concat(String.valueOf(z)));
        synchronized (mLock) {
            mEnableCustomHttpDNS = z;
            mCustomHttpDNSCallback = interfaceC1045a;
        }
    }

    public static boolean isEnableCustomHttpDNS() {
        return mEnableCustomHttpDNS;
    }

    public static String parseAddressUseCustomHttpDns(String str) {
        if (!verifyCustomHttpDNS(str)) {
            return "";
        }
        long jElapsedRealtime = SystemClock.elapsedRealtime();
        ArrayList arrayList = new ArrayList();
        synchronized (mLock) {
        }
        if (arrayList.size() > 0) {
            String str2 = (String) arrayList.get(0);
            LiteavLog.m998i(TAG, "parse host: " + str + " and return ipAddress: " + str2 + " ,costTime: " + (SystemClock.elapsedRealtime() - jElapsedRealtime) + " ms");
            return str2;
        }
        LiteavLog.m998i(TAG, "parse host: " + str + " ,return empty ipAddress");
        return "";
    }

    public static boolean isHostInWhiteList(String str) {
        if (TextUtils.isEmpty(str)) {
            return false;
        }
        return WHITE_LIST_HOST.contains(new String(Base64.encode(str.getBytes(), 0)).trim());
    }

    public static boolean isIpAddress(String str) {
        if (str != null && !"".equals(str)) {
            if (sValidIPV4Pattern == null) {
                try {
                    sValidIPV4Pattern = Pattern.compile(sIPV4Regular, 2);
                } catch (Exception e) {
                    LiteavLog.m994e(TAG, "Pattern.compile fail " + Log.getStackTraceString(e));
                    return false;
                }
            }
            if (sValidIPV4Pattern.matcher(str).matches() || str.contains(CertificateUtil.DELIMITER)) {
                return true;
            }
        }
        return false;
    }

    public static HttpURLConnection createConnectionUseCustomHttpDNS(String str, String str2) throws Exception {
        String strConvertHttpDNSURL = convertHttpDNSURL(str, str2);
        if (TextUtils.isEmpty(strConvertHttpDNSURL)) {
            return (HttpURLConnection) new URL(str).openConnection();
        }
        HttpURLConnection httpURLConnection = (HttpURLConnection) new URL(strConvertHttpDNSURL).openConnection();
        httpURLConnection.setRequestProperty("Host", str2);
        applySniForHttpsConnection(httpURLConnection, str2);
        LiteavLog.m998i(TAG, "create http conn use httpDns, original url: " + str + " , new url: " + strConvertHttpDNSURL);
        return httpURLConnection;
    }

    public static String convertHttpDNSURL(String str, String str2) throws Exception {
        String addressUseCustomHttpDns = parseAddressUseCustomHttpDns(str2);
        if (TextUtils.isEmpty(addressUseCustomHttpDns)) {
            return null;
        }
        InetAddress byName = InetAddress.getByName(addressUseCustomHttpDns);
        if (byName instanceof Inet4Address) {
            return str.replaceFirst(str2, addressUseCustomHttpDns);
        }
        if (!(byName instanceof Inet6Address)) {
            return null;
        }
        return str.replaceFirst(str2, "[" + addressUseCustomHttpDns + "]");
    }

    public static boolean verifyCustomHttpDNS(String str) {
        synchronized (mLock) {
            if (mEnableCustomHttpDNS && mCustomHttpDNSCallback != null) {
                if (isHostInWhiteList(str) || isIpAddress(str)) {
                    return false;
                }
                String property = System.getProperty("http.proxyHost");
                String property2 = System.getProperty("http.proxyPort");
                if (property == null || property2 == null) {
                    return true;
                }
                LiteavLog.m1004w(TAG, "local proxy is on, don't use httpdns. proxyHost=" + property + " ,proxyPort=" + property2);
                return false;
            }
            return false;
        }
    }

    public static void applySniForHttpsConnection(HttpURLConnection httpURLConnection, final String str) {
        if (httpURLConnection instanceof HttpsURLConnection) {
            HttpsURLConnection httpsURLConnection = (HttpsURLConnection) httpURLConnection;
            httpsURLConnection.setSSLSocketFactory(new C1046b(httpsURLConnection));
            try {
                InvocationHandler invocationHandler = new InvocationHandler() {
                    @Override
                    public final Object invoke(Object obj, Method method, Object[] objArr) throws Throwable {
                        if (method.getName().equals("verify")) {
                            return Boolean.valueOf(HttpsURLConnection.getDefaultHostnameVerifier().verify(str, (SSLSession) objArr[1]));
                        }
                        return method.invoke(HttpsURLConnection.getDefaultHostnameVerifier(), objArr);
                    }
                };
                Class<?> cls = Class.forName(new String(Base64.decode(sVClass, 0)));
                Object objNewProxyInstance = Proxy.newProxyInstance(cls.getClassLoader(), new Class[]{cls}, invocationHandler);
                Method declaredMethod = HttpsURLConnection.class.getDeclaredMethod(new String(Base64.decode(sVerifyMethodBase64, 0)), cls);
                declaredMethod.setAccessible(true);
                declaredMethod.invoke(httpsURLConnection, objNewProxyInstance);
            } catch (Throwable th) {
                LiteavLog.m994e(TAG, "applySniForHttpsConnection error: " + Log.getStackTraceString(th));
            }
        }
    }

    static class C1046b extends SSLSocketFactory {

        private HttpsURLConnection f735a;

        @Override
        public final Socket createSocket() throws IOException {
            return null;
        }

        @Override
        public final Socket createSocket(String str, int i) throws IOException {
            return null;
        }

        @Override
        public final Socket createSocket(String str, int i, InetAddress inetAddress, int i2) throws IOException {
            return null;
        }

        @Override
        public final Socket createSocket(InetAddress inetAddress, int i) throws IOException {
            return null;
        }

        @Override
        public final Socket createSocket(InetAddress inetAddress, int i, InetAddress inetAddress2, int i2) throws IOException {
            return null;
        }

        public C1046b(HttpsURLConnection httpsURLConnection) {
            this.f735a = httpsURLConnection;
        }

        @Override
        public final String[] getDefaultCipherSuites() {
            return new String[0];
        }

        @Override
        public final String[] getSupportedCipherSuites() {
            return new String[0];
        }

        @Override
        public final Socket createSocket(Socket socket, String str, int i, boolean z) throws IOException {
            String requestProperty = this.f735a.getRequestProperty("Host");
            if (requestProperty != null) {
                str = requestProperty;
            }
            InetAddress inetAddress = socket.getInetAddress();
            if (z) {
                socket.close();
            }
            SSLCertificateSocketFactory sSLCertificateSocketFactory = (SSLCertificateSocketFactory) SSLCertificateSocketFactory.getDefault(0);
            SSLSocket sSLSocket = (SSLSocket) sSLCertificateSocketFactory.createSocket(inetAddress, i);
            sSLSocket.setEnabledProtocols(sSLSocket.getSupportedProtocols());
            LiteavLog.m998i(HttpDnsUtil.TAG, "Setting SNI hostname");
            sSLCertificateSocketFactory.setHostname(sSLSocket, str);
            SSLSession session = sSLSocket.getSession();
            if (!HttpsURLConnection.getDefaultHostnameVerifier().verify(str, session)) {
                throw new SSLPeerUnverifiedException("Cannot verify hostname: ".concat(String.valueOf(str)));
            }
            LiteavLog.m998i(HttpDnsUtil.TAG, "Established " + session.getProtocol() + " connection with " + session.getPeerHost() + " using " + session.getCipherSuite());
            return sSLSocket;
        }
    }
}
