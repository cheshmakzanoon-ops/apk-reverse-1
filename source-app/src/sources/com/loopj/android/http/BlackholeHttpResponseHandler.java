package com.loopj.android.http;

import cz.msebera.android.httpclient.Header;
import cz.msebera.android.httpclient.HttpResponse;

public class BlackholeHttpResponseHandler extends AsyncHttpResponseHandler {
    @Override
    public void onCancel() {
    }

    @Override
    public void onFailure(int i, Header[] headerArr, byte[] bArr, Throwable th) {
    }

    @Override
    public void onFinish() {
    }

    @Override
    public void onPostProcessResponse(ResponseHandlerInterface responseHandlerInterface, HttpResponse httpResponse) {
    }

    @Override
    public void onPreProcessResponse(ResponseHandlerInterface responseHandlerInterface, HttpResponse httpResponse) {
    }

    @Override
    public void onProgress(long j, long j2) {
    }

    @Override
    public void onRetry(int i) {
    }

    @Override
    public void onStart() {
    }

    @Override
    public void onSuccess(int i, Header[] headerArr, byte[] bArr) {
    }

    @Override
    public void onUserException(Throwable th) {
    }
}
