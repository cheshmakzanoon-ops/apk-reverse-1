package com.gme.liteav.base.system;

import com.gme.liteav.base.util.C1053e;

final class C1027c implements C1053e.a {

    private static final C1027c f718a = new C1027c();

    private C1027c() {
    }

    public static C1053e.a m972a() {
        return f718a;
    }

    @Override
    public final void mo973a(boolean z) {
        LiteavSystemInfo.onAppBackgroundStateChanged(z);
    }
}
