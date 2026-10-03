package net.aihelp.core.net.http.callback;

import android.text.TextUtils;
import java.io.Closeable;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import net.aihelp.core.util.concurrent.ApiExecutorFactory;
import net.aihelp.core.util.logger.AIHelpLogger;
import net.aihelp.utils.TLog;
import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.Response;

public class DownloadCallback<T> implements Callback {
    private static final String TAG = "RequestManager";
    private final BaseCallback<T> reqCallBack;
    private final String targetPath;

    public DownloadCallback(BaseCallback<T> baseCallback, String str) {
        this.reqCallBack = baseCallback;
        this.targetPath = str;
    }

    @Override
    public void onFailure(Call call, IOException iOException) {
        TLog.m139d(TAG, "DownloadCallback onFailure: " + iOException.toString());
        String url = call.request().url().getUrl();
        failedCallBack(url, iOException.getMessage(), this.reqCallBack);
        AIHelpLogger.error(url, iOException);
    }

    @Override
    public void onResponse(Call call, Response response) {
        FileOutputStream fileOutputStream;
        String url = call.request().url().getUrl();
        if (TextUtils.isEmpty(this.targetPath)) {
            return;
        }
        if (response.body() == null || !response.isSuccessful()) {
            failedCallBack(url, "response.isSuccessful() returning false", this.reqCallBack);
            return;
        }
        long jContentLength = response.body().getContentLength();
        File file = new File(this.targetPath);
        long j = 0;
        if (file.exists() && file.length() > 0) {
            progressCallback(this.reqCallBack, jContentLength, jContentLength);
            successCallBack(this.reqCallBack);
            return;
        }
        InputStream inputStream = null;
        try {
            InputStream inputStreamByteStream = response.body().byteStream();
            try {
                fileOutputStream = new FileOutputStream(file);
                try {
                    byte[] bArr = new byte[8192];
                    while (true) {
                        int i = inputStreamByteStream.read(bArr, 0, 8192);
                        if (i < 0) {
                            break;
                        }
                        fileOutputStream.write(bArr, 0, i);
                        long j2 = j + ((long) i);
                        progressCallback(this.reqCallBack, jContentLength, j2);
                        j = j2;
                    }
                    successCallBack(this.reqCallBack);
                    closeQuietly(inputStreamByteStream);
                } catch (Throwable th) {
                    th = th;
                    inputStream = inputStreamByteStream;
                    try {
                        TLog.m139d(TAG, "DownloadCallback onResponse catch Exception: " + th.toString());
                        failedCallBack(url, th.getMessage(), this.reqCallBack);
                        AIHelpLogger.error(url, th);
                        closeQuietly(inputStream);
                    } catch (Throwable th2) {
                        closeQuietly(inputStream);
                        closeQuietly(fileOutputStream);
                        throw th2;
                    }
                }
            } catch (Throwable th3) {
                th = th3;
                fileOutputStream = null;
            }
        } catch (Throwable th4) {
            th = th4;
            fileOutputStream = null;
        }
        closeQuietly(fileOutputStream);
    }

    private void successCallBack(final BaseCallback<T> baseCallback) {
        if (baseCallback == null) {
            return;
        }
        baseCallback.onAsyncReqSuccess(null);
        ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                baseCallback.onReqSuccess(null);
            }
        });
    }

    private void failedCallBack(final String str, final String str2, final BaseCallback<T> baseCallback) {
        if (baseCallback == null) {
            return;
        }
        baseCallback.onAsyncFailure(str, -1, str2);
        ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                baseCallback.onFailure(str, -1, str2);
            }
        });
    }

    private void progressCallback(final BaseCallback<T> baseCallback, final long j, final long j2) {
        if (baseCallback == null) {
            return;
        }
        final int i = (int) (((j2 * 1.0f) / j) * 100.0f);
        baseCallback.onAsyncReqProgress(j, j2, i);
        ApiExecutorFactory.getHandlerExecutor().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                baseCallback.onReqProgress(j, j2, i);
            }
        });
    }

    private void closeQuietly(Closeable closeable) {
        if (closeable != null) {
            try {
                closeable.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
