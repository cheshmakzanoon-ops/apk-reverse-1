package net.aihelp.core.net.mqtt.hawtdispatch.internal;

import net.aihelp.core.net.mqtt.hawtdispatch.Metrics;
import net.aihelp.core.net.mqtt.hawtdispatch.Task;

public final class InactiveMetricsCollector extends MetricsCollector {
    public static final InactiveMetricsCollector INSTANCE = new InactiveMetricsCollector();

    @Override
    public Metrics metrics() {
        return null;
    }

    @Override
    public Task track(Task task) {
        return task;
    }
}
