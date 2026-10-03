package com.gme.liteav.base.http;

final class RunnableC1016b implements Runnable {

    private final HttpClientAndroid f695a;

    private RunnableC1016b(HttpClientAndroid httpClientAndroid) {
        this.f695a = httpClientAndroid;
    }

    public static Runnable m962a(HttpClientAndroid httpClientAndroid) {
        return new RunnableC1016b(httpClientAndroid);
    }

    @Override
    public final void run() {
        HttpClientAndroid.lambda$cancelAll$1(this.f695a);
    }
}
