package net.aihelp.core.net.http.callback;

import java.io.IOException;
import net.aihelp.core.net.http.pojo.ResultEntity;
import net.aihelp.core.net.json.JsonHelper;
import net.aihelp.core.util.concurrent.ApiExecutorFactory;
import net.aihelp.core.util.logger.AIHelpLogger;
import net.aihelp.utils.TLog;
import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.Request;
import okhttp3.Response;

public class AIHelpCallback<T> implements Callback {
    private final BaseCallback<T> reqCallBack;

    public AIHelpCallback(BaseCallback<T> baseCallback) {
        this.reqCallBack = baseCallback;
    }

    @Override
    public void onFailure(Call call, IOException iOException) {
        TLog.m138d("AIHelpCallback onFailure: " + iOException.toString());
        String url = call.request().url().getUrl();
        failedCallBack(call.request(), url, -1, iOException.toString(), this.reqCallBack);
        AIHelpLogger.error(url, iOException);
    }

    @Override
    public void onResponse(Call call, Response response) {
        if (this.reqCallBack == null) {
            return;
        }
        String url = call.request().url().getUrl();
        try {
            if (response.isSuccessful() && response.body() != null) {
                String strString = response.body().string();
                if (isUniqueRequest(call, strString)) {
                    return;
                }
                ResultEntity resultEntity = (ResultEntity) JsonHelper.toJavaObject(strString, ResultEntity.class);
                if (resultEntity != null) {
                    if (resultEntity.isFlag() || resultEntity.getCode() == 200) {
                        String data = resultEntity.getData();
                        if (data == null || data.equals("")) {
                            successCallBack(null, this.reqCallBack);
                        } else if (this.reqCallBack.getType() == String.class || this.reqCallBack.getType() == Integer.class || this.reqCallBack.getType() == Double.class || this.reqCallBack.getType() == Float.class) {
                            successCallBack(data, this.reqCallBack);
                        } else {
                            successCallBack(JsonHelper.toJavaObject(data, this.reqCallBack.getType()), this.reqCallBack);
                        }
                    } else {
                        failedCallBack(call.request(), url, resultEntity.getCode(), resultEntity.getDesc(), this.reqCallBack);
                    }
                } else {
                    failedCallBack(call.request(), url, -1, "ResultEntity is NULL", this.reqCallBack);
                }
            } else {
                failedCallBack(call.request(), url, response.code(), response.message(), this.reqCallBack);
            }
        } catch (Throwable th) {
            TLog.m138d("AIHelpCallback onResponse catch Exception: " + th.toString());
            failedCallBack(call.request(), url, -1, th.toString(), this.reqCallBack);
            AIHelpLogger.error(url, th);
        }
    }

    private void successCallBack(final T t, final BaseCallback<T> baseCallback) {
        if (baseCallback == null) {
            return;
        }
        baseCallback.onAsyncReqSuccess(t);
        ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                baseCallback.onReqSuccess(t);
            }
        });
    }

    private void failedCallBack(Request request, final String str, final int i, final String str2, final BaseCallback<T> baseCallback) {
        if (baseCallback == null) {
            return;
        }
        baseCallback.onAsyncFailure(str, i, str2);
        ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                baseCallback.onFailure(str, i, str2);
            }
        });
    }

    private boolean isUniqueRequest(Call call, String str) {
        String url = call.request().url().getUrl();
        if (!url.contains("initset") && !url.contains("getfaqfilenames") && !url.contains("upload") && !url.contains("faqs") && !url.contains("crmtoken") && !url.contains("sdkconfig") && !url.contains("collect") && !url.endsWith(".json")) {
            return false;
        }
        successCallBack(JsonHelper.toJavaObject(str, this.reqCallBack.getType()), this.reqCallBack);
        return true;
    }
}
