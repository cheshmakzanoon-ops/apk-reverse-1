package net.aihelp.core.net.mqtt.hawtdispatch.internal;

import net.aihelp.core.net.mqtt.hawtdispatch.DispatchObject;
import net.aihelp.core.net.mqtt.hawtdispatch.DispatchQueue;

public abstract class AbstractDispatchObject extends BaseSuspendable implements DispatchObject {
    protected volatile HawtDispatchQueue targetQueue;

    @Override
    public void setTargetQueue(DispatchQueue dispatchQueue) {
        if (dispatchQueue != this.targetQueue) {
            this.targetQueue = (HawtDispatchQueue) dispatchQueue;
        }
    }

    @Override
    public HawtDispatchQueue getTargetQueue() {
        return this.targetQueue;
    }
}
