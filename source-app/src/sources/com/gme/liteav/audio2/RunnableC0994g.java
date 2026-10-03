package com.gme.liteav.audio2;

final class RunnableC0994g implements Runnable {

    private final C0992e f588a;

    private RunnableC0994g(C0992e c0992e) {
        this.f588a = c0992e;
    }

    public static Runnable m933a(C0992e c0992e) {
        return new RunnableC0994g(c0992e);
    }

    @Override
    public final void run() {
        this.f588a.m930d();
    }
}
