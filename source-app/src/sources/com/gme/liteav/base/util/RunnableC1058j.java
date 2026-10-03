package com.gme.liteav.base.util;

final class RunnableC1058j implements Runnable {

    private final C1055g.a f770a;

    private RunnableC1058j(C1055g.a aVar) {
        this.f770a = aVar;
    }

    public static Runnable m1026a(C1055g.a aVar) {
        return new RunnableC1058j(aVar);
    }

    @Override
    public final void run() {
        C1055g.a aVar = this.f770a;
        C1055g.this.f759a.execute(aVar.f762a);
    }
}
