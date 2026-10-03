package com.gme.liteav.base.http;

final class RunnableC1018d implements Runnable {

    private final HttpClientAndroid f698a;

    private final long f699b;

    private RunnableC1018d(HttpClientAndroid httpClientAndroid, long j) {
        this.f698a = httpClientAndroid;
        this.f699b = j;
    }

    public static Runnable m964a(HttpClientAndroid httpClientAndroid, long j) {
        return new RunnableC1018d(httpClientAndroid, j);
    }

    @Override
    public final void run() {
        HttpClientAndroid.lambda$resumeRepeatDownload$3(this.f698a, this.f699b);
    }
}
