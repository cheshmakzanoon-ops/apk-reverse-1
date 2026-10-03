package net.aihelp.core.net.mqtt.hawtdispatch;

public interface Retained {
    void release();

    void retain();

    int retained();
}
