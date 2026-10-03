package com.gme.liteav.base.system;

import java.util.concurrent.Callable;

final class CallableC1030f implements Callable {

    private static final CallableC1030f f721a = new CallableC1030f();

    private CallableC1030f() {
    }

    public static Callable m976a() {
        return f721a;
    }

    @Override
    public final Object call() {
        return C1041q.m987a(LiteavSystemInfo.sAppPackageName.m1027a());
    }
}
