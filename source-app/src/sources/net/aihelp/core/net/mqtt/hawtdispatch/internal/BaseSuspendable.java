package net.aihelp.core.net.mqtt.hawtdispatch.internal;

import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;
import net.aihelp.core.net.mqtt.hawtdispatch.Suspendable;
import net.aihelp.core.net.mqtt.hawtdispatch.Task;

public class BaseSuspendable extends Task implements Suspendable {
    protected final AtomicBoolean startup = new AtomicBoolean(true);
    protected final AtomicInteger suspended = new AtomicInteger();

    protected void onResume() {
    }

    protected void onStartup() {
    }

    protected void onSuspend() {
    }

    @Override
    public void run() {
    }

    @Override
    public boolean isSuspended() {
        return this.suspended.get() > 0;
    }

    @Override
    public void resume() {
        if (this.suspended.decrementAndGet() == 0) {
            if (this.startup.compareAndSet(true, false)) {
                onStartup();
            } else {
                onResume();
            }
        }
    }

    @Override
    public void suspend() {
        if (this.suspended.getAndIncrement() == 0) {
            onSuspend();
        }
    }
}
