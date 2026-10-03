package net.aihelp.core.net.mqtt.hawtdispatch.internal;

import java.util.Iterator;
import java.util.LinkedList;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicBoolean;
import net.aihelp.core.net.mqtt.hawtdispatch.DispatchQueue;
import net.aihelp.core.net.mqtt.hawtdispatch.Metrics;
import net.aihelp.core.net.mqtt.hawtdispatch.Task;
import net.aihelp.core.net.mqtt.hawtdispatch.TaskWrapper;

public class SerialDispatchQueue extends AbstractDispatchObject implements HawtDispatchQueue {
    protected volatile String label;
    protected final AtomicBoolean triggered = new AtomicBoolean();
    protected final ConcurrentLinkedQueue<Task> externalQueue = new ConcurrentLinkedQueue<>();
    private final LinkedList<Task> localQueue = new LinkedList<>();
    private final LinkedList<Task> sourceQueue = new LinkedList<>();
    private final ThreadLocal<Boolean> executing = new ThreadLocal<>();
    private MetricsCollector metricsCollector = InactiveMetricsCollector.INSTANCE;
    private boolean profile = false;

    @Override
    public void assertExecuting() {
    }

    @Override
    public GlobalDispatchQueue isGlobalDispatchQueue() {
        return null;
    }

    @Override
    public SerialDispatchQueue isSerialDispatchQueue() {
        return this;
    }

    @Override
    public ThreadDispatchQueue isThreadDispatchQueue() {
        return null;
    }

    public SerialDispatchQueue(String str) {
        this.label = str;
    }

    @Override
    public void execute(Task task) {
        enqueue(this.metricsCollector.track(task));
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
    public LinkedList<Task> getSourceQueue() {
        return this.sourceQueue;
    }

    private void enqueue(Task task) {
        if (this.executing.get() != null) {
            this.localQueue.add(task);
        } else {
            this.externalQueue.add(task);
            triggerExecution();
        }
    }

    @Override
    public void run() {
        boolean z;
        checkCollector();
        HawtDispatchQueue hawtDispatchQueue = HawtDispatcher.CURRENT_QUEUE.get();
        HawtDispatcher.CURRENT_QUEUE.set(this);
        this.executing.set(Boolean.TRUE);
        while (true) {
            try {
                Task taskPoll = this.externalQueue.poll();
                if (taskPoll == null) {
                    break;
                } else {
                    this.localQueue.add(taskPoll);
                }
            } catch (Throwable th) {
                Iterator<Task> it = this.sourceQueue.iterator();
                while (it.hasNext()) {
                    it.next().run();
                }
                this.sourceQueue.clear();
                this.executing.remove();
                HawtDispatcher.CURRENT_QUEUE.set(hawtDispatchQueue);
                this.triggered.set(false);
                z = this.externalQueue.isEmpty() && this.localQueue.isEmpty();
                if (!isSuspended() && !z) {
                    triggerExecution();
                }
                throw th;
            }
        }
        while (!isSuspended()) {
            Task taskPoll2 = this.localQueue.poll();
            if (taskPoll2 != null) {
                try {
                    taskPoll2.run();
                } catch (Throwable th2) {
                    Thread threadCurrentThread = Thread.currentThread();
                    threadCurrentThread.getUncaughtExceptionHandler().uncaughtException(threadCurrentThread, th2);
                }
            } else {
                Iterator<Task> it2 = this.sourceQueue.iterator();
                while (it2.hasNext()) {
                    it2.next().run();
                }
                this.sourceQueue.clear();
                this.executing.remove();
                HawtDispatcher.CURRENT_QUEUE.set(hawtDispatchQueue);
                this.triggered.set(false);
                z = this.externalQueue.isEmpty() && this.localQueue.isEmpty();
                if (isSuspended() || z) {
                    return;
                }
                triggerExecution();
                return;
            }
        }
        Iterator<Task> it3 = this.sourceQueue.iterator();
        while (it3.hasNext()) {
            it3.next().run();
        }
        this.sourceQueue.clear();
        this.executing.remove();
        HawtDispatcher.CURRENT_QUEUE.set(hawtDispatchQueue);
        this.triggered.set(false);
        z = this.externalQueue.isEmpty() && this.localQueue.isEmpty();
        if (isSuspended() || z) {
            return;
        }
        triggerExecution();
    }

    protected void triggerExecution() {
        if (this.triggered.compareAndSet(false, true)) {
            getTargetQueue().execute((Task) this);
        }
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
        return this.executing.get() != null;
    }

    @Override
    protected void onStartup() {
        triggerExecution();
    }

    @Override
    protected void onResume() {
        triggerExecution();
    }

    @Override
    public DispatchQueue.QueueType getQueueType() {
        return DispatchQueue.QueueType.SERIAL_QUEUE;
    }

    @Override
    public void executeAfter(long j, TimeUnit timeUnit, Task task) {
        getDispatcher().timerThread.addRelative(task, this, j, timeUnit);
    }

    @Override
    public DispatchQueue createQueue(String str) {
        SerialDispatchQueue serialDispatchQueueCreateQueue = getDispatcher().createQueue(str);
        serialDispatchQueueCreateQueue.setTargetQueue(this);
        return serialDispatchQueueCreateQueue;
    }

    @Override
    public HawtDispatcher getDispatcher() {
        HawtDispatchQueue targetQueue = getTargetQueue();
        if (targetQueue == null) {
            throw new UnsupportedOperationException();
        }
        return targetQueue.getDispatcher();
    }

    @Override
    public void profile(boolean z) {
        this.profile = z;
        checkCollector();
    }

    @Override
    public boolean profile() {
        return this.profile;
    }

    private void checkCollector() {
        if (profile() || getDispatcher().profile()) {
            if (this.metricsCollector == InactiveMetricsCollector.INSTANCE) {
                this.metricsCollector = new ActiveMetricsCollector(this);
                getDispatcher().track(this);
                return;
            }
            return;
        }
        if (this.metricsCollector != InactiveMetricsCollector.INSTANCE) {
            this.metricsCollector = InactiveMetricsCollector.INSTANCE;
            getDispatcher().untrack(this);
        }
    }

    @Override
    public Metrics metrics() {
        return this.metricsCollector.metrics();
    }

    private int drains() {
        return getDispatcher().drains;
    }

    public String toString() {
        if (this.label == null) {
            return "serial queue";
        }
        return "serial queue { label: \"" + this.label + "\" }";
    }
}
