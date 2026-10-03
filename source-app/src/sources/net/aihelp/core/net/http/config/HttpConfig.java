package net.aihelp.core.net.http.config;

import android.text.TextUtils;
import cz.msebera.android.httpclient.entity.mime.MIME;
import java.io.File;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Random;
import java.util.concurrent.TimeUnit;
import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import kotlin.UByte;
import net.aihelp.common.API;
import net.aihelp.common.Const;
import net.aihelp.common.UserProfile;
import net.aihelp.core.net.http.FileProgressRequestBody;
import net.aihelp.core.net.http.interceptor.HeaderInterceptor;
import net.aihelp.core.net.http.interceptor.LogInterceptor;
import net.aihelp.core.net.http.interceptor.SignInterceptor;
import okhttp3.CipherSuite;
import okhttp3.ConnectionSpec;
import okhttp3.Cookie;
import okhttp3.CookieJar;
import okhttp3.Headers;
import okhttp3.HttpUrl;
import okhttp3.MediaType;
import okhttp3.MultipartBody;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.TlsVersion;

public class HttpConfig {
    private static final int TIME_OUT_LIMIT = 60;
    public static final MediaType MEDIA_TYPE_URLENCODED = MediaType.parse("application/x-www-form-urlencoded; charset=utf-8");
    public static final MediaType MEDIA_TYPE_JSON = MediaType.parse("application/json; charset=utf-8");
    public static final MediaType MEDIA_OBJECT_STREAM = MediaType.parse("application/octet-stream");
    private static final ConnectionSpec spec = new ConnectionSpec.Builder(ConnectionSpec.COMPATIBLE_TLS).supportsTlsExtensions(true).tlsVersions(TlsVersion.TLS_1_2, TlsVersion.TLS_1_1, TlsVersion.TLS_1_0).cipherSuites(CipherSuite.TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256, CipherSuite.TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256, CipherSuite.TLS_DHE_RSA_WITH_AES_128_GCM_SHA256, CipherSuite.TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA, CipherSuite.TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA, CipherSuite.TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA, CipherSuite.TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA, CipherSuite.TLS_ECDHE_ECDSA_WITH_RC4_128_SHA, CipherSuite.TLS_ECDHE_RSA_WITH_RC4_128_SHA, CipherSuite.TLS_DHE_RSA_WITH_AES_128_CBC_SHA, CipherSuite.TLS_DHE_DSS_WITH_AES_128_CBC_SHA, CipherSuite.TLS_DHE_RSA_WITH_AES_256_CBC_SHA).build();

    public static OkHttpClient getOkHttpClient(boolean z) {
        OkHttpClient.Builder builderCookieJar = new OkHttpClient().newBuilder().connectTimeout(60L, TimeUnit.SECONDS).readTimeout(60L, TimeUnit.SECONDS).writeTimeout(60L, TimeUnit.SECONDS).hostnameVerifier(createInsecureHostnameVerifier()).cookieJar(new CookieJar() {
            private final HashMap<HttpUrl, List<Cookie>> cookieStore = new HashMap<>();

            @Override
            public void saveFromResponse(HttpUrl httpUrl, List<Cookie> list) {
                this.cookieStore.put(httpUrl, list);
            }

            @Override
            public List<Cookie> loadForRequest(HttpUrl httpUrl) {
                List<Cookie> list = this.cookieStore.get(httpUrl);
                return list != null ? list : new ArrayList();
            }
        });
        if (z) {
            builderCookieJar.addInterceptor(new HeaderInterceptor());
        }
        builderCookieJar.addInterceptor(new LogInterceptor());
        builderCookieJar.addInterceptor(new SignInterceptor());
        builderCookieJar.connectionSpecs(Arrays.asList(ConnectionSpec.CLEARTEXT, ConnectionSpec.MODERN_TLS, spec));
        return builderCookieJar.build();
    }

    private static List<ConnectionSpec> getSpecsBelowLollipopMR1(OkHttpClient.Builder builder) {
        try {
            SSLContext sSLContext = SSLContext.getInstance("TLSv1.2");
            sSLContext.init(null, null, null);
            builder.sslSocketFactory(new Tls12SocketFactory(sSLContext.getSocketFactory()));
            ConnectionSpec connectionSpecBuild = new ConnectionSpec.Builder(ConnectionSpec.MODERN_TLS).tlsVersions(TlsVersion.TLS_1_2).build();
            ArrayList arrayList = new ArrayList();
            arrayList.add(connectionSpecBuild);
            arrayList.add(ConnectionSpec.COMPATIBLE_TLS);
            return arrayList;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private static HostnameVerifier createInsecureHostnameVerifier() {
        return new HostnameVerifier() {
            @Override
            public boolean verify(String str, SSLSession sSLSession) {
                return str.contains("aihelp");
            }
        };
    }

    public static Request getUploadRequest(String str, File file) {
        String str2;
        try {
            str2 = String.format("form-data;name=file;filename=%s", URLEncoder.encode(file.getName(), "utf-8"));
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            str2 = null;
        }
        if (str2 == null) {
            return null;
        }
        MultipartBody.Builder builderAddPart = new MultipartBody.Builder().setType(MultipartBody.FORM).addPart(Headers.m142of(MIME.CONTENT_DISPOSITION, str2), new FileProgressRequestBody(MultipartBody.FORM, file, null));
        if (str.contains(API.UPLOAD_VIDEO_URL) || str.contains(API.UPLOAD_LOG_URL) || str.contains(API.UPLOAD_IMAGE_URL) || str.contains(API.UPLOAD_ATTACHMENT_URL)) {
            String strValueOf = String.valueOf(new Random().nextInt(Integer.MAX_VALUE));
            String strValueOf2 = String.valueOf(System.currentTimeMillis());
            builderAddPart.addFormDataPart("appId", Const.APP_ID).addFormDataPart("random", strValueOf).addFormDataPart("timespan", strValueOf2).addFormDataPart("userId", UserProfile.USER_ID).addFormDataPart("siga", getUploadVideoSig(strValueOf, strValueOf2));
        }
        return new Request.Builder().url(str).post(builderAddPart.build()).build();
    }

    private static String getUploadVideoSig(String str, String str2) {
        return md5("appId_" + Const.APP_ID + "random_" + str + "timespan_" + str2 + "userId_" + UserProfile.USER_ID);
    }

    public static String md5(String str) {
        byte[] bArrDigest;
        if (!TextUtils.isEmpty(str)) {
            try {
                bArrDigest = MessageDigest.getInstance("MD5").digest(str.getBytes("UTF-8"));
            } catch (Exception e) {
                e.printStackTrace();
                bArrDigest = new byte[2];
            }
            StringBuilder sb = new StringBuilder(bArrDigest.length * 2);
            for (byte b : bArrDigest) {
                int i = b & UByte.MAX_VALUE;
                if (i < 16) {
                    sb.append("0");
                }
                sb.append(Integer.toHexString(i));
            }
            return sb.toString();
        }
        return "";
    }
}
