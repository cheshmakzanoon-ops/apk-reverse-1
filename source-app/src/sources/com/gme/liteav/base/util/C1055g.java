package com.gme.liteav.base.util;

import android.os.Looper;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

public final class C1055g {

    final ThreadPoolExecutor f759a;

    public final CustomHandler f760b;

    public final List<a> f761c;

    public class a {

        final Runnable f762a;

        public final Runnable f763b = RunnableC1058j.m1026a(this);

        public final long f764c = 500;

        private final Runnable f766e;

        public a(Runnable runnable) {
            this.f766e = runnable;
            this.f762a = RunnableC1057i.m1025a(this, runnable);
        }
    }

    public C1055g() {
        this((byte) 0);
    }

    private C1055g(byte b) {
        this("SequenceTaskRunner_");
    }

    public C1055g(String str) {
        this.f759a = new ThreadPoolExecutor(0, 1, 60L, TimeUnit.SECONDS, new LinkedBlockingQueue(), ThreadFactoryC1056h.m1024a(str));
        this.f760b = new CustomHandler(Looper.getMainLooper());
        this.f761c = new ArrayList();
    }

    public final void m1023a(Runnable runnable) {
        this.f759a.execute(runnable);
    }
}
