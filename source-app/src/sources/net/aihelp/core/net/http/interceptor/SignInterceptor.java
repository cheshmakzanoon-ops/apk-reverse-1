package net.aihelp.core.net.http.interceptor;

import android.text.TextUtils;
import cz.msebera.android.httpclient.client.methods.HttpPost;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.Iterator;
import java.util.Map;
import java.util.TreeMap;
import java.util.UUID;
import java.util.regex.Pattern;
import net.aihelp.BuildConfig;
import net.aihelp.common.Const;
import net.aihelp.common.UserProfile;
import net.aihelp.core.net.http.config.HttpConfig;
import okhttp3.FormBody;
import okhttp3.Interceptor;
import okhttp3.MediaType;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
import okio.Buffer;
import org.json.JSONArray;
import org.json.JSONObject;

public class SignInterceptor implements Interceptor {
    @Override
    public Response intercept(Interceptor.Chain chain) throws IOException {
        Request request = chain.request();
        Request.Builder builderNewBuilder = request.newBuilder();
        long jCurrentTimeMillis = System.currentTimeMillis();
        String string = UUID.randomUUID().toString();
        try {
            if (request.method().equals("GET")) {
                String url = request.url().getUrl();
                if (!Pattern.matches("^/.+\\.(ini|json|aiml)$", url)) {
                    request = addHeaders(builderNewBuilder, jCurrentTimeMillis, string, getRequestSign(getParamDictionary(url, jCurrentTimeMillis, string))).url(url).build();
                }
            } else if (request.method().equals(HttpPost.METHOD_NAME)) {
                RequestBody requestBodyBody = request.body();
                if (requestBodyBody instanceof FormBody) {
                    return chain.proceed(addHeaders(builderNewBuilder, jCurrentTimeMillis, string, getRequestSign(getParamDictionary((FormBody) requestBodyBody, jCurrentTimeMillis, string))).post(requestBodyBody).build());
                }
                MediaType contentType = requestBodyBody != null ? request.body().getContentType() : null;
                if (contentType != null && "json".equals(contentType.subtype())) {
                    String strBodyToString = bodyToString(request.body());
                    if (!TextUtils.isEmpty(strBodyToString)) {
                        try {
                            new JSONArray(strBodyToString);
                        } catch (Exception unused) {
                            request = addHeaders(builderNewBuilder, jCurrentTimeMillis, string, getRequestSign(getParamDictionary(new JSONObject(strBodyToString), jCurrentTimeMillis, string))).post(requestBodyBody).build();
                        }
                    }
                } else {
                    JSONObject jSONObject = new JSONObject();
                    jSONObject.put("appId", Const.APP_ID);
                    jSONObject.put("appkey", Const.APP_KEY);
                    jSONObject.put("lan", Const.CORRECT_LANGUAGE);
                    jSONObject.put("l", Const.CORRECT_LANGUAGE);
                    jSONObject.put("platform", 2);
                    jSONObject.put("sdkVersion", BuildConfig.SDK_VERSION);
                    request = addHeaders(builderNewBuilder, jCurrentTimeMillis, string, getRequestSign(getParamDictionary(jSONObject, jCurrentTimeMillis, string))).post(requestBodyBody).build();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return chain.proceed(request);
    }

    private String getPostRawString(Object obj) {
        StringBuilder sb = new StringBuilder();
        if (obj instanceof FormBody) {
            FormBody formBody = (FormBody) obj;
            for (int i = 0; i < formBody.size(); i++) {
                sb.append(formBody.encodedName(i));
                sb.append("=");
                sb.append(formBody.encodedValue(i));
                sb.append("&");
            }
        }
        if (obj instanceof JSONObject) {
            JSONObject jSONObject = (JSONObject) obj;
            Iterator<String> itKeys = jSONObject.keys();
            while (itKeys.hasNext()) {
                String next = itKeys.next();
                sb.append(next);
                sb.append("=");
                sb.append(jSONObject.opt(next));
                sb.append("&");
            }
        }
        return sb.toString();
    }

    private Map<String, Object> getParamDictionary(Object obj, long j, String str) {
        TreeMap treeMap = new TreeMap();
        try {
            treeMap.put("timestamp", String.valueOf(j));
            treeMap.put("nonce", str);
            if (obj instanceof String) {
                String str2 = (String) obj;
                for (String str3 : str2.substring(str2.indexOf("?") + 1).split("&")) {
                    if (!TextUtils.isEmpty(str3)) {
                        String[] strArrSplit = str3.split("=");
                        if (strArrSplit.length > 0) {
                            treeMap.put(strArrSplit[0], strArrSplit.length == 2 ? strArrSplit[1] : "");
                        }
                    }
                }
            }
            if (obj instanceof FormBody) {
                FormBody formBody = (FormBody) obj;
                for (int i = 0; i < formBody.size(); i++) {
                    treeMap.put(formBody.encodedName(i), formBody.encodedValue(i));
                }
            }
            if (obj instanceof JSONObject) {
                JSONObject jSONObject = (JSONObject) obj;
                Iterator<String> itKeys = jSONObject.keys();
                while (itKeys.hasNext()) {
                    String next = itKeys.next();
                    treeMap.put(next, jSONObject.opt(next));
                }
            }
            if (!treeMap.containsKey("appkey")) {
                treeMap.put("appkey", Const.APP_KEY);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return treeMap;
    }

    private Request.Builder addHeaders(Request.Builder builder, long j, String str, String str2) throws UnsupportedEncodingException {
        return builder.addHeader("appkey", Const.APP_KEY).addHeader("nonce", str).addHeader("appId", Const.APP_ID).addHeader("userId", URLEncoder.encode(UserProfile.USER_ID, "utf-8")).addHeader("timestamp", String.valueOf(j)).addHeader("sign", str2);
    }

    private String getRequestSign(Map<String, Object> map) {
        StringBuilder sb = new StringBuilder();
        int i = 0;
        for (String str : map.keySet()) {
            Object obj = map.get(str);
            if (i > 0) {
                sb.append("&");
            }
            sb.append(str);
            sb.append("=");
            if (obj instanceof String) {
                try {
                    sb.append(URLDecoder.decode(String.valueOf(obj)));
                } catch (Exception unused) {
                    sb.append(obj);
                }
            } else {
                sb.append(obj);
            }
            i++;
        }
        return HttpConfig.md5(sb.toString() + HttpConfig.md5(Const.APP_KEY + map.get("timestamp")).toLowerCase()).toLowerCase();
    }

    private String bodyToString(RequestBody requestBody) {
        try {
            Buffer buffer = new Buffer();
            if (requestBody != null) {
                requestBody.writeTo(buffer);
                return buffer.readUtf8();
            }
        } catch (IOException unused) {
        }
        return "";
    }
}
