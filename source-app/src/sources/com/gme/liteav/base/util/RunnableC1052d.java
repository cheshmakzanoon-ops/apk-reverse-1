package com.gme.liteav.base.util;

import android.os.MessageQueue;

final class RunnableC1052d implements Runnable {

    private final CustomHandler f748a;

    private final MessageQueue.IdleHandler f749b;

    private RunnableC1052d(CustomHandler customHandler, MessageQueue.IdleHandler idleHandler) {
        this.f748a = customHandler;
        this.f749b = idleHandler;
    }

    public static Runnable m1010a(CustomHandler customHandler, MessageQueue.IdleHandler idleHandler) {
        return new RunnableC1052d(customHandler, idleHandler);
    }

    @Override
    public final void run() {
        CustomHandler.lambda$quitLooper$3(this.f748a, this.f749b);
    }
}
