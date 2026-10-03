package net.aihelp.core.net.http.interceptor;

import android.text.TextUtils;
import cz.msebera.android.httpclient.client.methods.HttpPost;
import java.io.IOException;
import java.util.regex.Pattern;
import net.aihelp.BuildConfig;
import net.aihelp.common.Const;
import okhttp3.FormBody;
import okhttp3.Interceptor;
import okhttp3.MediaType;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
import okio.Buffer;
import org.json.JSONArray;
import org.json.JSONObject;

public class HeaderInterceptor implements Interceptor {
    private boolean isUniqueRequest(String str) {
        return false;
    }

    @Override
    public Response intercept(Interceptor.Chain chain) throws IOException {
        Request request = chain.request();
        if (isUniqueRequest(request.url().getUrl())) {
            return chain.proceed(request);
        }
        try {
            RequestBody requestBodyBody = request.body();
            if (request.method().equals("GET")) {
                String url = request.url().getUrl();
                if (!Pattern.matches(".+\\.(ini|json|aiml|jpg|JPG|png|PNG|mp4|MP4)", url) && !url.contains("AIML") && !url.contains("FAQ") && !url.contains("OPerMode")) {
                    request = request.newBuilder().url((url.indexOf("?") > 0 ? url + "&" : url + "?") + getAppendedParams()).build();
                }
            } else if (request.method().equals(HttpPost.METHOD_NAME)) {
                if (requestBodyBody instanceof FormBody) {
                    FormBody.Builder builder = new FormBody.Builder();
                    FormBody formBody = (FormBody) requestBodyBody;
                    for (int i = 0; i < formBody.size(); i++) {
                        builder.addEncoded(formBody.encodedName(i), formBody.encodedValue(i));
                    }
                    builder.addEncoded("appId", Const.APP_ID);
                    builder.addEncoded("lan", Const.CORRECT_LANGUAGE);
                    builder.addEncoded("l", Const.CORRECT_LANGUAGE);
                    builder.addEncoded("platform", String.valueOf(2));
                    builder.addEncoded("sdkVersion", BuildConfig.SDK_VERSION);
                    builder.addEncoded("sdkVersionDetail", BuildConfig.SDK_VERSION);
                    return chain.proceed(request.newBuilder().post(builder.build()).build());
                }
                MediaType contentType = request.body() != null ? request.body().getContentType() : null;
                if (contentType != null && "json".equals(contentType.subtype())) {
                    String strBodyToString = bodyToString(request.body());
                    if (!TextUtils.isEmpty(strBodyToString)) {
                        try {
                            new JSONArray(strBodyToString);
                        } catch (Exception unused) {
                            JSONObject jSONObject = new JSONObject(strBodyToString);
                            jSONObject.put("appId", Const.APP_ID);
                            jSONObject.put("lan", Const.CORRECT_LANGUAGE);
                            jSONObject.put("l", Const.CORRECT_LANGUAGE);
                            jSONObject.put("platform", 2);
                            jSONObject.put("sdkVersion", BuildConfig.SDK_VERSION);
                            jSONObject.put("sdkVersionDetail", BuildConfig.SDK_VERSION);
                            request = request.newBuilder().post(RequestBody.create(MediaType.parse("application/json; charset=utf-8"), jSONObject.toString())).build();
                        }
                    }
                } else {
                    JSONObject jSONObject2 = new JSONObject();
                    jSONObject2.put("appId", Const.APP_ID);
                    jSONObject2.put("lan", Const.CORRECT_LANGUAGE);
                    jSONObject2.put("l", Const.CORRECT_LANGUAGE);
                    jSONObject2.put("platform", 2);
                    jSONObject2.put("sdkVersion", BuildConfig.SDK_VERSION);
                    jSONObject2.put("sdkVersionDetail", BuildConfig.SDK_VERSION);
                    request = request.newBuilder().post(RequestBody.create(MediaType.parse("application/json; charset=utf-8"), jSONObject2.toString())).build();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return chain.proceed(request);
    }

    private String getAppendedParams() {
        String str = Const.CORRECT_LANGUAGE;
        return String.format("appId=%s&l=%s&lan=%s&platform=%s&sdkVersion=%s&sdkVersionDetail=%s", Const.APP_ID, str, str, 2, BuildConfig.SDK_VERSION, BuildConfig.SDK_VERSION);
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
