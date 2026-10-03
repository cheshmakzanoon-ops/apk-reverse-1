package com.gme.liteav.base.http;

final class RunnableC1017c implements Runnable {

    private final HttpClientAndroid f696a;

    private final Long f697b;

    private RunnableC1017c(HttpClientAndroid httpClientAndroid, Long l) {
        this.f696a = httpClientAndroid;
        this.f697b = l;
    }

    public static Runnable m963a(HttpClientAndroid httpClientAndroid, Long l) {
        return new RunnableC1017c(httpClientAndroid, l);
    }

    @Override
    public final void run() {
        HttpClientAndroid.lambda$resumeRepeatDownload$2(this.f696a, this.f697b);
    }
}
