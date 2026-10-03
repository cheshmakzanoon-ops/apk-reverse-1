package com.gme.liteav.audio2;

final class RunnableC0993f implements Runnable {

    private final C0992e f587a;

    private RunnableC0993f(C0992e c0992e) {
        this.f587a = c0992e;
    }

    public static Runnable m932a(C0992e c0992e) {
        return new RunnableC0993f(c0992e);
    }

    @Override
    public final void run() {
        this.f587a.m930d();
    }
}
