package net.aihelp.core.net.mqtt.hawtdispatch.internal;

import java.util.LinkedList;
import java.util.concurrent.TimeUnit;
import net.aihelp.core.net.mqtt.hawtdispatch.DispatchPriority;
import net.aihelp.core.net.mqtt.hawtdispatch.DispatchQueue;
import net.aihelp.core.net.mqtt.hawtdispatch.Metrics;
import net.aihelp.core.net.mqtt.hawtdispatch.ShutdownException;
import net.aihelp.core.net.mqtt.hawtdispatch.Task;
import net.aihelp.core.net.mqtt.hawtdispatch.TaskWrapper;
import net.aihelp.core.net.mqtt.hawtdispatch.internal.pool.SimplePool;
import net.aihelp.core.net.mqtt.hawtdispatch.internal.util.IntrospectionSupport;

public final class GlobalDispatchQueue implements HawtDispatchQueue {
    public final HawtDispatcher dispatcher;
    volatile String label;
    private final DispatchPriority priority;
    final WorkerPool workers;

    @Override
    public void assertExecuting() {
    }

    @Override
    public ThreadDispatchQueue getTargetQueue() {
        return null;
    }

    @Override
    public GlobalDispatchQueue isGlobalDispatchQueue() {
        return this;
    }

    @Override
    public SerialDispatchQueue isSerialDispatchQueue() {
        return null;
    }

    @Override
    public ThreadDispatchQueue isThreadDispatchQueue() {
        return null;
    }

    @Override
    public Metrics metrics() {
        return null;
    }

    @Override
    public void profile(boolean z) {
    }

    @Override
    public boolean profile() {
        return false;
    }

    public GlobalDispatchQueue(HawtDispatcher hawtDispatcher, DispatchPriority dispatchPriority, int i) {
        this.dispatcher = hawtDispatcher;
        this.priority = dispatchPriority;
        this.label = dispatchPriority.toString();
        this.workers = new SimplePool(this, i, dispatchPriority);
        hawtDispatcher.track(this);
    }

    public void start() {
        this.workers.start();
    }

    public void shutdown() {
        this.workers.shutdown();
    }

    @Override
    public HawtDispatcher getDispatcher() {
        return this.dispatcher;
    }

    @Override
    public String getLabel() {
        return this.label;
    }

    @Override
    public void setLabel(String str) {
        this.label = str;
    }

    @Override
    public boolean isExecuting() {
        ThreadDispatchQueue currentThreadQueue = this.dispatcher.getCurrentThreadQueue();
        return currentThreadQueue != null && currentThreadQueue.globalQueue == this;
    }

    @Override
    public LinkedList<Task> getSourceQueue() {
        ThreadDispatchQueue currentThreadQueue = this.dispatcher.getCurrentThreadQueue();
        if (currentThreadQueue != null) {
            return currentThreadQueue.getSourceQueue();
        }
        return null;
    }

    @Override
    @Deprecated
    public void execute(Runnable runnable) {
        execute((Task) new TaskWrapper(runnable));
    }

    @Override
    @Deprecated
    public void executeAfter(long j, TimeUnit timeUnit, Runnable runnable) {
        executeAfter(j, timeUnit, (Task) new TaskWrapper(runnable));
    }

    @Override
    public void execute(Task task) {
        if (this.dispatcher.shutdownState.get() > 1) {
            throw new ShutdownException();
        }
        this.workers.execute(task);
    }

    @Override
    public void executeAfter(long j, TimeUnit timeUnit, Task task) {
        if (this.dispatcher.shutdownState.get() > 0) {
            throw new ShutdownException();
        }
        this.dispatcher.timerThread.addRelative(task, this, j, timeUnit);
    }

    public DispatchPriority getPriority() {
        return this.priority;
    }

    @Override
    public void resume() {
        throw new UnsupportedOperationException();
    }

    @Override
    public void suspend() {
        throw new UnsupportedOperationException();
    }

    @Override
    public boolean isSuspended() {
        throw new UnsupportedOperationException();
    }

    @Override
    public void setTargetQueue(DispatchQueue dispatchQueue) {
        throw new UnsupportedOperationException();
    }

    public String toString() {
        return IntrospectionSupport.toString(this);
    }

    @Override
    public DispatchQueue createQueue(String str) {
        SerialDispatchQueue serialDispatchQueueCreateQueue = this.dispatcher.createQueue(str);
        serialDispatchQueueCreateQueue.setTargetQueue(this);
        return serialDispatchQueueCreateQueue;
    }

    @Override
    public DispatchQueue.QueueType getQueueType() {
        return DispatchQueue.QueueType.GLOBAL_QUEUE;
    }

    DispatchQueue[] getThreadQueues() {
        WorkerThread[] threads = this.workers.getThreads();
        DispatchQueue[] dispatchQueueArr = new DispatchQueue[threads.length];
        for (int i = 0; i < threads.length; i++) {
            dispatchQueueArr[i] = threads[i].getDispatchQueue();
        }
        return dispatchQueueArr;
    }
}
