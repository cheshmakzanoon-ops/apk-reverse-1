package com.gme.liteav.base.util;

import java.util.concurrent.ThreadFactory;

final class ThreadFactoryC1056h implements ThreadFactory {

    private final String f767a;

    private ThreadFactoryC1056h(String str) {
        this.f767a = str;
    }

    public static ThreadFactory m1024a(String str) {
        return new ThreadFactoryC1056h(str);
    }

    @Override
    public final Thread newThread(Runnable runnable) {
        return new Thread(runnable, this.f767a);
    }
}
