package com.loopj.android.http;

import cz.msebera.android.httpclient.Header;

public abstract class BaseJsonHttpResponseHandler<JSON_TYPE> extends TextHttpResponseHandler {
    private static final String LOG_TAG = "BaseJsonHttpRH";

    public abstract void onFailure(int i, Header[] headerArr, Throwable th, String str, JSON_TYPE json_type);

    public abstract void onSuccess(int i, Header[] headerArr, String str, JSON_TYPE json_type);

    protected abstract JSON_TYPE parseResponse(String str, boolean z) throws Throwable;

    public BaseJsonHttpResponseHandler() {
        this("UTF-8");
    }

    public BaseJsonHttpResponseHandler(String str) {
        super(str);
    }

    @Override
    public final void onSuccess(final int i, final Header[] headerArr, final String str) {
        if (i != 204) {
            Runnable runnable = new Runnable() {
                @Override
                public void run() {
                    try {
                        final Object response = BaseJsonHttpResponseHandler.this.parseResponse(str, false);
                        BaseJsonHttpResponseHandler.this.postRunnable(new Runnable() {
                            @Override
                            public void run() {
                                BaseJsonHttpResponseHandler.this.onSuccess(i, headerArr, str, response);
                            }
                        });
                    } catch (Throwable th) {
                        AsyncHttpClient.log.mo383d(BaseJsonHttpResponseHandler.LOG_TAG, "parseResponse thrown an problem", th);
                        BaseJsonHttpResponseHandler.this.postRunnable(new Runnable() {
                            @Override
                            public void run() {
                                BaseJsonHttpResponseHandler.this.onFailure(i, headerArr, th, str, null);
                            }
                        });
                    }
                }
            };
            if (!getUseSynchronousMode() && !getUsePoolThread()) {
                new Thread(runnable).start();
                return;
            } else {
                runnable.run();
                return;
            }
        }
        onSuccess(i, headerArr, null, null);
    }

    @Override
    public final void onFailure(final int i, final Header[] headerArr, final String str, final Throwable th) {
        if (str != null) {
            Runnable runnable = new Runnable() {
                @Override
                public void run() {
                    try {
                        final Object response = BaseJsonHttpResponseHandler.this.parseResponse(str, true);
                        BaseJsonHttpResponseHandler.this.postRunnable(new Runnable() {
                            @Override
                            public void run() {
                                BaseJsonHttpResponseHandler.this.onFailure(i, headerArr, th, str, response);
                            }
                        });
                    } catch (Throwable th2) {
                        AsyncHttpClient.log.mo383d(BaseJsonHttpResponseHandler.LOG_TAG, "parseResponse thrown an problem", th2);
                        BaseJsonHttpResponseHandler.this.postRunnable(new Runnable() {
                            @Override
                            public void run() {
                                BaseJsonHttpResponseHandler.this.onFailure(i, headerArr, th, str, null);
                            }
                        });
                    }
                }
            };
            if (!getUseSynchronousMode() && !getUsePoolThread()) {
                new Thread(runnable).start();
                return;
            } else {
                runnable.run();
                return;
            }
        }
        onFailure(i, headerArr, th, null, null);
    }
}
