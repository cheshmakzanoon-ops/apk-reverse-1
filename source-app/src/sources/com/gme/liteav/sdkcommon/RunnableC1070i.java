package com.gme.liteav.sdkcommon;

final class RunnableC1070i implements Runnable {

    private final C1068g f820a;

    private RunnableC1070i(C1068g c1068g) {
        this.f820a = c1068g;
    }

    public static Runnable m1056a(C1068g c1068g) {
        return new RunnableC1070i(c1068g);
    }

    @Override
    public final void run() {
        C1068g c1068g = this.f820a;
        if (c1068g.f808k != null) {
            c1068g.f808k.fullScroll(130);
        }
    }
}
