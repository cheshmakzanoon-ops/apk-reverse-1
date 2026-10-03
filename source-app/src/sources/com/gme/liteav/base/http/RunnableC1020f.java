package com.gme.liteav.base.http;

final class RunnableC1020f implements Runnable {

    private final HttpClientAndroid f701a;

    private final HttpClientAndroid.C1012f f702b;

    private final long f703c;

    private RunnableC1020f(HttpClientAndroid httpClientAndroid, HttpClientAndroid.C1012f c1012f, long j) {
        this.f701a = httpClientAndroid;
        this.f702b = c1012f;
        this.f703c = j;
    }

    public static Runnable m966a(HttpClientAndroid httpClientAndroid, HttpClientAndroid.C1012f c1012f, long j) {
        return new RunnableC1020f(httpClientAndroid, c1012f, j);
    }

    @Override
    public final void run() {
        HttpClientAndroid.lambda$doReadData$5(this.f701a, this.f702b, this.f703c);
    }
}
