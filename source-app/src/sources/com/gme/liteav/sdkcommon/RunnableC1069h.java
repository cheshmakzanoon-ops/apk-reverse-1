package com.gme.liteav.sdkcommon;

final class RunnableC1069h implements Runnable {

    private final C1068g f819a;

    private RunnableC1069h(C1068g c1068g) {
        this.f819a = c1068g;
    }

    public static Runnable m1055a(C1068g c1068g) {
        return new RunnableC1069h(c1068g);
    }

    @Override
    public final void run() {
        C1068g c1068g = this.f819a;
        if (c1068g.f808k != null) {
            c1068g.f808k.fullScroll(130);
        }
    }
}
