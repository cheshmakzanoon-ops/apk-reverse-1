package com.gme.liteav.base.http;

final class RunnableC1019e implements Runnable {

    private final HttpClientAndroid f700a;

    private RunnableC1019e(HttpClientAndroid httpClientAndroid) {
        this.f700a = httpClientAndroid;
    }

    public static Runnable m965a(HttpClientAndroid httpClientAndroid) {
        return new RunnableC1019e(httpClientAndroid);
    }

    @Override
    public final void run() {
        HttpClientAndroid.lambda$destroy$4(this.f700a);
    }
}
