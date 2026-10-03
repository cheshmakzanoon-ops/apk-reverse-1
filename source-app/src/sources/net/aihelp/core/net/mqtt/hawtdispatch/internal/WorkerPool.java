package net.aihelp.core.net.mqtt.hawtdispatch.internal;

import net.aihelp.core.net.mqtt.hawtdispatch.Task;

public interface WorkerPool {
    void execute(Task task);

    WorkerThread[] getThreads();

    void shutdown();

    void start();
}
