package com.gme.liteav.base.util;

import java.util.concurrent.CountDownLatch;

final class RunnableC1050b implements Runnable {

    private final Runnable f745a;

    private final CountDownLatch f746b;

    private RunnableC1050b(Runnable runnable, CountDownLatch countDownLatch) {
        this.f745a = runnable;
        this.f746b = countDownLatch;
    }

    public static Runnable m1008a(Runnable runnable, CountDownLatch countDownLatch) {
        return new RunnableC1050b(runnable, countDownLatch);
    }

    @Override
    public final void run() {
        CustomHandler.lambda$runAndWaitDone$1(this.f745a, this.f746b);
    }
}
