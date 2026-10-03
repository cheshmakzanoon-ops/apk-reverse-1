package com.gme.liteav.base.system;

import android.os.Build;
import java.util.concurrent.Callable;

final class CallableC1036l implements Callable {

    private static final CallableC1036l f727a = new CallableC1036l();

    private CallableC1036l() {
    }

    public static Callable m982a() {
        return f727a;
    }

    @Override
    public final Object call() {
        return Build.HARDWARE;
    }
}
