package com.gme.liteav.base.system;

import java.util.concurrent.Callable;

final class CallableC1029e implements Callable {

    private static final CallableC1029e f720a = new CallableC1029e();

    private CallableC1029e() {
    }

    public static Callable m975a() {
        return f720a;
    }

    @Override
    public final Object call() {
        return C1025a.m969c();
    }
}
