package net.aihelp.core.net.mqtt.hawtdispatch.internal.util;

import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;
import net.aihelp.core.net.mqtt.hawtdispatch.Task;

public class RunnableCountDownLatch extends Task {
    private final CountDownLatch latch;

    public RunnableCountDownLatch(int i) {
        this.latch = new CountDownLatch(i);
    }

    @Override
    public void run() {
        this.latch.countDown();
    }

    public void await() throws InterruptedException {
        this.latch.await();
    }

    public boolean await(long j, TimeUnit timeUnit) throws InterruptedException {
        return this.latch.await(j, timeUnit);
    }

    public long getCount() {
        return this.latch.getCount();
    }

    public void countDown() {
        this.latch.countDown();
    }

    public String toString() {
        return this.latch.toString();
    }
}
