package net.aihelp.core.net.mqtt.hawtdispatch.internal;

import java.util.LinkedList;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.concurrent.TimeUnit;
import net.aihelp.core.net.mqtt.hawtdispatch.DispatchPriority;
import net.aihelp.core.net.mqtt.hawtdispatch.DispatchQueue;
import net.aihelp.core.net.mqtt.hawtdispatch.Metrics;
import net.aihelp.core.net.mqtt.hawtdispatch.Task;
import net.aihelp.core.net.mqtt.hawtdispatch.TaskWrapper;

public final class ThreadDispatchQueue implements HawtDispatchQueue {
    final GlobalDispatchQueue globalQueue;
    volatile String label;
    final LinkedList<Task> localTasks = new LinkedList<>();
    final ConcurrentLinkedQueue<Task> sharedTasks = new ConcurrentLinkedQueue<>();
    private final LinkedList<Task> sourceQueue = new LinkedList<>();
    final WorkerThread thread;

    @Override
    public void assertExecuting() {
    }

    @Override
    public HawtDispatchQueue getTargetQueue() {
        return null;
    }

    @Override
    public GlobalDispatchQueue isGlobalDispatchQueue() {
        return null;
    }

    @Override
    public SerialDispatchQueue isSerialDispatchQueue() {
        return null;
    }

    @Override
    public ThreadDispatchQueue isThreadDispatchQueue() {
        return this;
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

    public ThreadDispatchQueue(GlobalDispatchQueue globalDispatchQueue, WorkerThread workerThread) {
        this.thread = workerThread;
        this.globalQueue = globalDispatchQueue;
        this.label = workerThread.getName() + " pritority: " + globalDispatchQueue.getLabel();
        getDispatcher().track(this);
    }

    @Override
    public LinkedList<Task> getSourceQueue() {
        return this.sourceQueue;
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
        return this.globalQueue.dispatcher.getCurrentThreadQueue() == this;
    }

    @Override
    public HawtDispatcher getDispatcher() {
        return this.globalQueue.dispatcher;
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
        if (Thread.currentThread() != this.thread) {
            this.sharedTasks.add(task);
            this.thread.unpark();
        } else {
            this.localTasks.add(task);
        }
    }

    public Task poll() {
        Task taskPoll = this.localTasks.poll();
        return taskPoll == null ? this.sharedTasks.poll() : taskPoll;
    }

    @Override
    public void executeAfter(long j, TimeUnit timeUnit, Task task) {
        getDispatcher().timerThread.addRelative(task, this, j, timeUnit);
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

    public DispatchPriority getPriority() {
        return this.globalQueue.getPriority();
    }

    @Override
    public DispatchQueue createQueue(String str) {
        SerialDispatchQueue serialDispatchQueueCreateQueue = this.globalQueue.dispatcher.createQueue(str);
        serialDispatchQueueCreateQueue.setTargetQueue(this);
        return serialDispatchQueueCreateQueue;
    }

    @Override
    public DispatchQueue.QueueType getQueueType() {
        return DispatchQueue.QueueType.THREAD_QUEUE;
    }

    public WorkerThread getThread() {
        return this.thread;
    }
}
