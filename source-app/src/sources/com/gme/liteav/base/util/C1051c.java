package com.gme.liteav.base.util;

import android.os.MessageQueue;

final class C1051c implements MessageQueue.IdleHandler {

    private final CustomHandler f747a;

    private C1051c(CustomHandler customHandler) {
        this.f747a = customHandler;
    }

    public static MessageQueue.IdleHandler m1009a(CustomHandler customHandler) {
        return new C1051c(customHandler);
    }

    @Override
    public final boolean queueIdle() {
        return CustomHandler.lambda$quitLooper$2(this.f747a);
    }
}
