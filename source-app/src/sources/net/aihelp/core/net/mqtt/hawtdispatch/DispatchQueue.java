package net.aihelp.core.net.mqtt.hawtdispatch;

import java.util.concurrent.Executor;
import java.util.concurrent.TimeUnit;

public interface DispatchQueue extends DispatchObject, Executor {

    public enum QueueType {
        GLOBAL_QUEUE,
        SERIAL_QUEUE,
        THREAD_QUEUE
    }

    void assertExecuting();

    DispatchQueue createQueue(String str);

    @Override
    void execute(Runnable runnable);

    void execute(Task task);

    void executeAfter(long j, TimeUnit timeUnit, Runnable runnable);

    void executeAfter(long j, TimeUnit timeUnit, Task task);

    String getLabel();

    QueueType getQueueType();

    boolean isExecuting();

    Metrics metrics();

    void profile(boolean z);

    boolean profile();

    void setLabel(String str);
}
