package net.aihelp.core.net.mqtt.hawtdispatch;

public interface DispatchObject extends Suspendable {
    DispatchQueue getTargetQueue();

    void setTargetQueue(DispatchQueue dispatchQueue);
}
