package com.gme.liteav.base.util;

import java.util.concurrent.CountDownLatch;

final class RunnableC1049a implements Runnable {

    private final Runnable f743a;

    private final CountDownLatch f744b;

    private RunnableC1049a(Runnable runnable, CountDownLatch countDownLatch) {
        this.f743a = runnable;
        this.f744b = countDownLatch;
    }

    public static Runnable m1007a(Runnable runnable, CountDownLatch countDownLatch) {
        return new RunnableC1049a(runnable, countDownLatch);
    }

    @Override
    public final void run() {
        CustomHandler.lambda$runAndWaitDone$0(this.f743a, this.f744b);
    }
}
