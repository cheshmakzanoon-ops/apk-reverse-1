package net.aihelp.core.util.concurrent;

import java.util.concurrent.ThreadFactory;
import java.util.concurrent.atomic.AtomicInteger;

class AIHelpThreadFactory implements ThreadFactory {
    private final String poolName;
    private final AtomicInteger threadNumber = new AtomicInteger(1);

    public AIHelpThreadFactory(String str) {
        this.poolName = str;
    }

    @Override
    public Thread newThread(Runnable runnable) {
        return new Thread(runnable, "AIHelp-" + this.poolName + "-t-" + this.threadNumber.getAndIncrement());
    }
}
