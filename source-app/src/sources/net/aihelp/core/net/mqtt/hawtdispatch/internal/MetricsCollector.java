package net.aihelp.core.net.mqtt.hawtdispatch.internal;

import net.aihelp.core.net.mqtt.hawtdispatch.Metrics;
import net.aihelp.core.net.mqtt.hawtdispatch.Task;

public abstract class MetricsCollector {
    public abstract Metrics metrics();

    public abstract Task track(Task task);
}
