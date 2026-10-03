package com.loopj.android.http;

import android.os.Message;
import com.ishumei.smantifraud.l111l11l11Ill;
import cz.msebera.android.httpclient.HttpEntity;
import cz.msebera.android.httpclient.util.ByteArrayBuffer;
import java.io.IOException;
import java.io.InputStream;

public abstract class DataAsyncHttpResponseHandler extends AsyncHttpResponseHandler {
    private static final String LOG_TAG = "DataAsyncHttpRH";
    protected static final int PROGRESS_DATA_MESSAGE = 7;

    public static byte[] copyOfRange(byte[] bArr, int i, int i2) throws ArrayIndexOutOfBoundsException, IllegalArgumentException, NullPointerException {
        if (i > i2) {
            throw new IllegalArgumentException();
        }
        int length = bArr.length;
        if (i < 0 || i > length) {
            throw new ArrayIndexOutOfBoundsException();
        }
        int i3 = i2 - i;
        int iMin = Math.min(i3, length - i);
        byte[] bArr2 = new byte[i3];
        System.arraycopy(bArr, i, bArr2, 0, iMin);
        return bArr2;
    }

    public void onProgressData(byte[] bArr) {
        AsyncHttpClient.log.mo382d(LOG_TAG, "onProgressData(byte[]) was not overriden, but callback was received");
    }

    public final void sendProgressDataMessage(byte[] bArr) {
        sendMessage(obtainMessage(7, new Object[]{bArr}));
    }

    @Override
    protected void handleMessage(Message message) {
        super.handleMessage(message);
        if (message.what != 7) {
            return;
        }
        Object[] objArr = (Object[]) message.obj;
        if (objArr == null || objArr.length < 1) {
            AsyncHttpClient.log.mo384e(LOG_TAG, "PROGRESS_DATA_MESSAGE didn't got enough params");
            return;
        }
        try {
            onProgressData((byte[]) objArr[0]);
        } catch (Throwable th) {
            AsyncHttpClient.log.mo385e(LOG_TAG, "custom onProgressData contains an error", th);
        }
    }

    @Override
    byte[] getResponseData(HttpEntity httpEntity) throws IOException {
        InputStream content;
        if (httpEntity == null || (content = httpEntity.getContent()) == null) {
            return null;
        }
        long contentLength = httpEntity.getContentLength();
        if (contentLength > 2147483647L) {
            throw new IllegalArgumentException("HTTP entity too large to be buffered in memory");
        }
        if (contentLength < 0) {
            contentLength = 4096;
        }
        try {
            ByteArrayBuffer byteArrayBuffer = new ByteArrayBuffer((int) contentLength);
            try {
                byte[] bArr = new byte[l111l11l11Ill.l111l11111lIl];
                while (true) {
                    int i = content.read(bArr);
                    if (i == -1 || Thread.currentThread().isInterrupted()) {
                        break;
                    }
                    byteArrayBuffer.append(bArr, 0, i);
                    sendProgressDataMessage(copyOfRange(bArr, 0, i));
                    sendProgressMessage(0, contentLength);
                }
                AsyncHttpClient.silentCloseInputStream(content);
                return byteArrayBuffer.toByteArray();
            } catch (Throwable th) {
                AsyncHttpClient.silentCloseInputStream(content);
                throw th;
            }
        } catch (OutOfMemoryError unused) {
            System.gc();
            throw new IOException("File too large to fit into available memory");
        }
    }
}
