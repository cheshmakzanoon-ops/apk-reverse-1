package net.aihelp.core.net.http;

import android.os.Looper;
import android.text.TextUtils;
import java.io.File;
import java.net.URLEncoder;
import java.util.Iterator;
import java.util.regex.Pattern;
import net.aihelp.common.API;
import net.aihelp.core.net.http.callback.AIHelpCallback;
import net.aihelp.core.net.http.callback.BaseCallback;
import net.aihelp.core.net.http.callback.DownloadCallback;
import net.aihelp.core.net.http.callback.UploadCallback;
import net.aihelp.core.net.http.config.HttpConfig;
import net.aihelp.core.util.concurrent.ApiExecutor;
import net.aihelp.core.util.concurrent.ApiExecutorFactory;
import net.aihelp.data.localize.util.LocalizeUtil;
import net.aihelp.utils.TLog;
import okhttp3.Call;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import org.json.JSONObject;

public class AIHelpRequest {
    private static final String ENCODE = "utf-8";
    private OkHttpClient mOkHttpClient;

    private AIHelpRequest() {
        this.mOkHttpClient = HttpConfig.getOkHttpClient(true);
    }

    public static AIHelpRequest getInstance() {
        return Holder.INSTANCE;
    }

    private static class Holder {
        private static final AIHelpRequest INSTANCE = new AIHelpRequest();

        private Holder() {
        }
    }

    public <T> void requestGetByAsync(String str, BaseCallback<T> baseCallback) {
        requestGetByAsync(str, null, baseCallback);
    }

    public <T> void requestGetByAsync(String str, JSONObject jSONObject, BaseCallback<T> baseCallback) {
        if (TextUtils.isEmpty(str)) {
            return;
        }
        if (!str.contains("//")) {
            str = API.REQUEST_SCHEME + API.HOST_URL + str;
        }
        StringBuilder sb = new StringBuilder();
        if (jSONObject != null) {
            try {
                Iterator<String> itKeys = jSONObject.keys();
                int i = 0;
                while (itKeys.hasNext()) {
                    String next = itKeys.next();
                    if (i > 0) {
                        sb.append("&");
                    }
                    sb.append(String.format("%s=%s", next, URLEncoder.encode(jSONObject.optString(next), ENCODE)));
                    i++;
                }
            } catch (Exception e) {
                TLog.m138d("AIHelpRequest requestGetByAsync catch Exception: " + e.toString());
                failedCallBack(str, e.getMessage(), baseCallback);
                return;
            }
        }
        if (!TextUtils.isEmpty(sb)) {
            str = String.format("%s?%s", str, sb.toString());
        }
        onRequest(baseCallback, this.mOkHttpClient.newCall(new Request.Builder().url(str).build()));
    }

    public <T> Call requestPostByJson(String str, String str2, BaseCallback<T> baseCallback) {
        if (TextUtils.isEmpty(str)) {
            return null;
        }
        try {
            if (!str.contains("//")) {
                str = API.REQUEST_SCHEME + API.HOST_URL + str;
            }
            return onRequest(baseCallback, this.mOkHttpClient.newCall(new Request.Builder().url(str).post(RequestBody.create(HttpConfig.MEDIA_TYPE_JSON, str2)).build()));
        } catch (Exception e) {
            TLog.m138d("AIHelpRequest requestPostByAsync catch Exception: " + e.toString());
            failedCallBack(str, e.getMessage(), baseCallback);
            return null;
        }
    }

    public <T> Call requestPostByJson(String str, JSONObject jSONObject, BaseCallback<T> baseCallback) {
        if (jSONObject == null) {
            jSONObject = new JSONObject();
        }
        return requestPostByJson(str, jSONObject.toString(), baseCallback);
    }

    public <T> Call requestUpLoadFile(String str, File file, UploadCallback uploadCallback) {
        if (!str.contains("//")) {
            str = API.REQUEST_SCHEME + API.HOST_URL + str;
        }
        Request uploadRequest = HttpConfig.getUploadRequest(str, file);
        if (uploadRequest == null) {
            failedCallBack(str, "", uploadCallback);
            return null;
        }
        return onRequest(uploadCallback, HttpConfig.getOkHttpClient(false).newCall(uploadRequest));
    }

    public <T> void requestDownloadFile(int i, BaseCallback<T> baseCallback) {
        String url = LocalizeUtil.getUrl(i);
        if (!TextUtils.isEmpty(url) && LocalizeUtil.isFallbackUrl(i, url)) {
            failedCallBack(url, "The cdn file is not working, requesting data via API.", baseCallback);
            return;
        }
        File file = new File(LocalizeUtil.getFileLocation(i));
        if (file.exists() && file.length() > 0) {
            successCallBack(baseCallback);
            return;
        }
        if (!TextUtils.isEmpty(url)) {
            TLog.m138d(String.format("LocalizeUrl: %s", url));
            if (Pattern.compile(".+\\.(json|aiml)").matcher(url).matches()) {
                this.mOkHttpClient.newCall(new Request.Builder().url(url).build()).enqueue(new DownloadCallback(baseCallback, LocalizeUtil.getFileLocation(i)));
                return;
            }
            return;
        }
        failedCallBack(url, "bad request for mode: " + i, baseCallback);
    }

    public void requestDownloadFile(String str, String str2, BaseCallback baseCallback) {
        File file = new File(str2);
        if (file.exists() && file.length() > 0) {
            progressCallback(baseCallback, file.length(), file.length());
            successCallBack(baseCallback);
        } else {
            this.mOkHttpClient.newCall(new Request.Builder().url(str).build()).enqueue(new DownloadCallback(baseCallback, str2));
        }
    }

    private <T> Call onRequest(BaseCallback<T> baseCallback, Call call) {
        call.enqueue(new AIHelpCallback(baseCallback));
        return call;
    }

    private <T> void progressCallback(final BaseCallback<T> baseCallback, final long j, final long j2) {
        if (baseCallback == null) {
            return;
        }
        final int i = (int) (((j2 * 1.0f) / j) * 100.0f);
        ApiExecutor handlerExecutor = ApiExecutorFactory.getHandlerExecutor();
        if (Looper.getMainLooper().getThread() == Thread.currentThread()) {
            handlerExecutor.runAsync(new Runnable() {
                @Override
                public void run() {
                    baseCallback.onAsyncReqProgress(j, j2, i);
                }
            });
            baseCallback.onReqProgress(j, j2, i);
        } else {
            baseCallback.onAsyncReqProgress(j, j2, i);
            handlerExecutor.runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    baseCallback.onReqProgress(j, j2, i);
                }
            });
        }
    }

    private <T> void successCallBack(final BaseCallback<T> baseCallback) {
        if (baseCallback == null) {
            return;
        }
        ApiExecutor handlerExecutor = ApiExecutorFactory.getHandlerExecutor();
        if (Looper.getMainLooper().getThread() == Thread.currentThread()) {
            handlerExecutor.runAsync(new Runnable() {
                @Override
                public void run() {
                    baseCallback.onAsyncReqSuccess(null);
                }
            });
            baseCallback.onReqSuccess(null);
        } else {
            baseCallback.onAsyncReqSuccess(null);
            handlerExecutor.runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    baseCallback.onReqSuccess(null);
                }
            });
        }
    }

    private <T> void failedCallBack(final String str, final String str2, final BaseCallback<T> baseCallback) {
        if (baseCallback == null) {
            return;
        }
        ApiExecutor handlerExecutor = ApiExecutorFactory.getHandlerExecutor();
        if (Looper.getMainLooper().getThread() == Thread.currentThread()) {
            handlerExecutor.runAsync(new Runnable() {
                @Override
                public void run() {
                    baseCallback.onAsyncFailure(str, -1, str2);
                }
            });
            baseCallback.onFailure(str, -1, str2);
        } else {
            baseCallback.onAsyncFailure(str, -1, str2);
            handlerExecutor.runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    baseCallback.onFailure(str, -1, str2);
                }
            });
        }
    }
}
