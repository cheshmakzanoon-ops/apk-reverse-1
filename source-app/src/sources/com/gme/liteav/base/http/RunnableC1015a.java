package com.gme.liteav.base.http;

final class RunnableC1015a implements Runnable {

    private final HttpClientAndroid f693a;

    private final HttpClientAndroid.C1011e f694b;

    private RunnableC1015a(HttpClientAndroid httpClientAndroid, HttpClientAndroid.C1011e c1011e) {
        this.f693a = httpClientAndroid;
        this.f694b = c1011e;
    }

    public static Runnable m961a(HttpClientAndroid httpClientAndroid, HttpClientAndroid.C1011e c1011e) {
        return new RunnableC1015a(httpClientAndroid, c1011e);
    }

    @Override
    public final void run() {
        this.f693a.doRequest(this.f694b);
    }
}
