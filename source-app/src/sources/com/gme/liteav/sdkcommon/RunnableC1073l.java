package com.gme.liteav.sdkcommon;

final class RunnableC1073l implements Runnable {

    private final C1068g f824a;

    private RunnableC1073l(C1068g c1068g) {
        this.f824a = c1068g;
    }

    public static Runnable m1059a(C1068g c1068g) {
        return new RunnableC1073l(c1068g);
    }

    @Override
    public final void run() {
        C1068g c1068g = this.f824a;
        if (c1068g.f808k != null) {
            c1068g.f808k.fullScroll(130);
        }
    }
}
