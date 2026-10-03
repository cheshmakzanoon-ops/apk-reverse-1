package com.gme.liteav.base.system;

import java.util.concurrent.Callable;

final class CallableC1032h implements Callable {

    private static final CallableC1032h f723a = new CallableC1032h();

    private CallableC1032h() {
    }

    public static Callable m978a() {
        return f723a;
    }

    @Override
    public final Object call() {
        return LiteavSystemInfo.getForegroundServices();
    }
}
