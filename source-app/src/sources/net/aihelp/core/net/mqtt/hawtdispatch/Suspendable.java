package net.aihelp.core.net.mqtt.hawtdispatch;

public interface Suspendable {
    boolean isSuspended();

    void resume();

    void suspend();
}
