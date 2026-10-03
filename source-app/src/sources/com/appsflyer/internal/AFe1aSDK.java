package com.appsflyer.internal;

import java.util.TimerTask;

public final class AFe1aSDK extends TimerTask {
    private final Thread AFInAppEventType;

    public AFe1aSDK(Thread thread) {
        this.AFInAppEventType = thread;
    }

    @Override
    public final void run() {
        this.AFInAppEventType.interrupt();
    }
}
