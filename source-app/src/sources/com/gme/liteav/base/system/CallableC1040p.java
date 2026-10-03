package com.gme.liteav.base.system;

import java.util.concurrent.Callable;

final class CallableC1040p implements Callable {

    private static final CallableC1040p f731a = new CallableC1040p();

    private CallableC1040p() {
    }

    public static Callable m986a() {
        return f731a;
    }

    @Override
    public final Object call() {
        return C1025a.m967a();
    }
}
