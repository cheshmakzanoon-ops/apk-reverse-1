package net.aihelp.core.net.http.interceptor;

import android.text.TextUtils;
import cz.msebera.android.httpclient.client.methods.HttpPost;
import java.io.IOException;
import net.aihelp.common.API;
import net.aihelp.utils.TLog;
import okhttp3.FormBody;
import okhttp3.HttpUrl;
import okhttp3.Interceptor;
import okhttp3.MediaType;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
import okio.Buffer;
import org.json.JSONObject;
import zendesk.messaging.android.internal.AttachmentFileResolver;

public final class LogInterceptor implements Interceptor {
    @Override
    public Response intercept(Interceptor.Chain chain) throws IOException {
        Request request = chain.request();
        Response responseProceed = chain.proceed(request);
        try {
            String lineTag = getLineTag(request.url());
            if (!TextUtils.isEmpty(lineTag) && !isFileAddress(lineTag)) {
                TLog.m140l(lineTag, true);
                long jCurrentTimeMillis = System.currentTimeMillis();
                if (HttpPost.METHOD_NAME.equals(request.method()) && request.body() != null) {
                    if (request.body() instanceof FormBody) {
                        FormBody formBody = (FormBody) request.body();
                        JSONObject jSONObject = new JSONObject();
                        for (int i = 0; i < formBody.size(); i++) {
                            jSONObject.put(formBody.encodedName(i), formBody.encodedValue(i));
                        }
                        TLog.json(String.format("[%s] [%s]", "Params", request.url()), jSONObject.toString());
                    }
                    MediaType contentType = request.body().getContentType();
                    if (contentType != null && "json".equals(contentType.subtype())) {
                        TLog.json(String.format("[%s] [%s]", "Params", request.url()), bodyToString(request.body()));
                    }
                }
                long jCurrentTimeMillis2 = System.currentTimeMillis();
                if (!TextUtils.isEmpty(lineTag) && !isFileAddress(lineTag)) {
                    TLog.json(String.format("[%s] [%s]", request.method(), request.url()), responseProceed.peekBody(1048576L).string());
                }
                TLog.m138d("Request Time: " + (((jCurrentTimeMillis2 - jCurrentTimeMillis) * 1.0d) / 1000.0d) + "s\t\t");
                TLog.m140l(lineTag, false);
                return responseProceed;
            }
            return responseProceed;
        } catch (Exception e) {
            e.printStackTrace();
        }
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

    private String getLineTag(HttpUrl httpUrl) {
        String strReplace = httpUrl.getUrl().replace(httpUrl.scheme() + "://" + httpUrl.host(), "");
        if (!strReplace.contains("?")) {
            return isFileAddress(strReplace) ? "" : strReplace;
        }
        return " " + strReplace.substring(0, strReplace.indexOf("?"));
    }

    private boolean isFileAddress(String str) {
        return API.TRACK_RPA.contains(str.trim()) || API.FAQ_URL.contains(str.trim()) || API.OP_URL.contains(str.trim()) || str.endsWith(".json") || str.endsWith(".aiml") || str.endsWith(".ini") || str.endsWith(AttachmentFileResolver.TEMP_FILE_SUFFIX) || str.endsWith(".jpeg") || str.endsWith(".png") || str.endsWith(".mp4");
    }
}
