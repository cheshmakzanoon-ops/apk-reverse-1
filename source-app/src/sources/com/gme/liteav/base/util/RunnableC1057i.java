package com.gme.liteav.base.util;

final class RunnableC1057i implements Runnable {

    private final C1055g.a f768a;

    private final Runnable f769b;

    private RunnableC1057i(C1055g.a aVar, Runnable runnable) {
        this.f768a = aVar;
        this.f769b = runnable;
    }

    public static Runnable m1025a(C1055g.a aVar, Runnable runnable) {
        return new RunnableC1057i(aVar, runnable);
    }

    @Override
    public final void run() {
        C1055g.a aVar = this.f768a;
        this.f769b.run();
        synchronized (C1055g.this) {
            C1055g.this.f761c.remove(aVar);
        }
    }
}
