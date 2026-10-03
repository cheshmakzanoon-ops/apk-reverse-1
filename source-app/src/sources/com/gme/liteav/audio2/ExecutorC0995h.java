package com.gme.liteav.audio2;

import java.util.concurrent.Executor;

final class ExecutorC0995h implements Executor {

    private final C0992e f589a;

    private ExecutorC0995h(C0992e c0992e) {
        this.f589a = c0992e;
    }

    public static Executor m934a(C0992e c0992e) {
        return new ExecutorC0995h(c0992e);
    }

    @Override
    public final void execute(Runnable runnable) {
        this.f589a.f582f.m1023a(runnable);
    }
}
