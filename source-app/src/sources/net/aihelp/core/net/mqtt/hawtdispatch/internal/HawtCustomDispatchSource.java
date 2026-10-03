package net.aihelp.core.net.mqtt.hawtdispatch.internal;

import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicLong;
import net.aihelp.core.net.mqtt.hawtdispatch.CustomDispatchSource;
import net.aihelp.core.net.mqtt.hawtdispatch.DispatchQueue;
import net.aihelp.core.net.mqtt.hawtdispatch.EventAggregator;
import net.aihelp.core.net.mqtt.hawtdispatch.OrderedEventAggregator;
import net.aihelp.core.net.mqtt.hawtdispatch.Task;
import net.aihelp.core.net.mqtt.hawtdispatch.TaskWrapper;

public final class HawtCustomDispatchSource<Event, MergedEvent> extends AbstractDispatchObject implements CustomDispatchSource<Event, MergedEvent> {
    public static final boolean DEBUG = false;
    private final EventAggregator<Event, MergedEvent> aggregator;
    private Task cancelHandler;
    private Task eventHandler;
    private final boolean ordered;
    private MergedEvent pendingEvent;
    final AtomicBoolean canceled = new AtomicBoolean();
    private final ThreadLocal<MergedEvent> outboundEvent = new ThreadLocal<>();
    private final ThreadLocal<MergedEvent> firedEvent = new ThreadLocal<>();
    protected final ConcurrentLinkedQueue<MergedEvent> externalQueue = new ConcurrentLinkedQueue<>();
    protected final AtomicLong size = new AtomicLong();

    protected void debug(String str, Object... objArr) {
    }

    protected void debug(Throwable th, String str, Object... objArr) {
    }

    public HawtCustomDispatchSource(HawtDispatcher hawtDispatcher, EventAggregator<Event, MergedEvent> eventAggregator, DispatchQueue dispatchQueue) {
        this.aggregator = eventAggregator;
        this.suspended.incrementAndGet();
        this.ordered = eventAggregator instanceof OrderedEventAggregator;
        setTargetQueue(dispatchQueue);
    }

    @Override
    public MergedEvent getData() {
        MergedEvent mergedevent = this.firedEvent.get();
        this.firedEvent.set(null);
        return mergedevent;
    }

    @Override
    public void merge(Event event) {
        debug("merge called", new Object[0]);
        WorkerThread workerThreadCurrentWorkerThread = WorkerThread.currentWorkerThread();
        if (workerThreadCurrentWorkerThread != null) {
            MergedEvent mergedevent = this.outboundEvent.get();
            MergedEvent mergedeventMergeEvent = this.aggregator.mergeEvent(mergedevent, event);
            if (mergedeventMergeEvent == null) {
                debug("merge resulted in cancel", new Object[0]);
                this.outboundEvent.remove();
                return;
            }
            this.outboundEvent.set(mergedeventMergeEvent);
            if (mergedevent == null) {
                debug("first merge, posting deferred fire event", new Object[0]);
                if (this.ordered) {
                    HawtDispatcher.CURRENT_QUEUE.get().getSourceQueue().add(this);
                    return;
                } else {
                    workerThreadCurrentWorkerThread.getDispatchQueue().getSourceQueue().add(this);
                    return;
                }
            }
            debug("there was a previous merge, no need to post deferred fire event", new Object[0]);
            return;
        }
        debug("merge not called from a worker thread.. triggering fire event now", new Object[0]);
        fireEvent(this.aggregator.mergeEvent(null, event));
    }

    @Override
    public void run() {
        debug("deferred fire event executing", new Object[0]);
        fireEvent(this.outboundEvent.get());
        this.outboundEvent.remove();
    }

    private void fireEvent(final MergedEvent mergedevent) {
        if (mergedevent != null) {
            this.targetQueue.execute(new Task() {
                @Override
                public void run() {
                    Object obj;
                    Object objMergeEvents;
                    if (HawtCustomDispatchSource.this.isCanceled()) {
                        HawtCustomDispatchSource.this.debug("canceled", new Object[0]);
                        return;
                    }
                    if (HawtCustomDispatchSource.this.isSuspended()) {
                        HawtCustomDispatchSource.this.debug("fired.. but suspended", new Object[0]);
                        synchronized (HawtCustomDispatchSource.this) {
                            if (HawtCustomDispatchSource.this.pendingEvent == null) {
                                HawtCustomDispatchSource.this.pendingEvent = mergedevent;
                            } else {
                                HawtCustomDispatchSource hawtCustomDispatchSource = HawtCustomDispatchSource.this;
                                hawtCustomDispatchSource.pendingEvent = hawtCustomDispatchSource.aggregator.mergeEvents(HawtCustomDispatchSource.this.pendingEvent, mergedevent);
                            }
                        }
                        return;
                    }
                    synchronized (HawtCustomDispatchSource.this) {
                        obj = HawtCustomDispatchSource.this.pendingEvent;
                        HawtCustomDispatchSource.this.pendingEvent = null;
                    }
                    if (obj != null) {
                        HawtCustomDispatchSource.this.debug("fired.. mergined with previous pending event..", new Object[0]);
                        objMergeEvents = HawtCustomDispatchSource.this.aggregator.mergeEvents(obj, mergedevent);
                    } else {
                        HawtCustomDispatchSource.this.debug("fired.. no previous pending event..", new Object[0]);
                        objMergeEvents = mergedevent;
                    }
                    HawtCustomDispatchSource.this.firedEvent.set(objMergeEvents);
                    try {
                        HawtCustomDispatchSource.this.eventHandler.run();
                    } catch (Throwable th) {
                        Thread threadCurrentThread = Thread.currentThread();
                        threadCurrentThread.getUncaughtExceptionHandler().uncaughtException(threadCurrentThread, th);
                    }
                    HawtCustomDispatchSource.this.firedEvent.remove();
                    HawtCustomDispatchSource.this.debug("eventHandler done", new Object[0]);
                }
            });
        }
    }

    @Override
    protected void onStartup() {
        if (this.eventHandler == null) {
            throw new IllegalArgumentException("eventHandler must be set");
        }
        onResume();
    }

    @Override
    public void cancel() {
        if (this.canceled.compareAndSet(false, true)) {
            this.targetQueue.execute(new Task() {
                @Override
                public void run() {
                    if (HawtCustomDispatchSource.this.cancelHandler != null) {
                        HawtCustomDispatchSource.this.cancelHandler.run();
                    }
                }
            });
        }
    }

    @Override
    protected void onResume() {
        debug("onResume", new Object[0]);
        this.targetQueue.execute(new Task() {
            @Override
            public void run() {
                Object obj;
                if (HawtCustomDispatchSource.this.isCanceled() || HawtCustomDispatchSource.this.isSuspended()) {
                    return;
                }
                synchronized (HawtCustomDispatchSource.this) {
                    obj = HawtCustomDispatchSource.this.pendingEvent;
                    HawtCustomDispatchSource.this.pendingEvent = null;
                }
                if (obj != null) {
                    HawtCustomDispatchSource.this.firedEvent.set(obj);
                    HawtCustomDispatchSource.this.eventHandler.run();
                    HawtCustomDispatchSource.this.firedEvent.remove();
                }
            }
        });
    }

    @Override
    public boolean isCanceled() {
        return this.canceled.get();
    }

    @Override
    @Deprecated
    public void setCancelHandler(Runnable runnable) {
        setCancelHandler((Task) new TaskWrapper(runnable));
    }

    @Override
    @Deprecated
    public void setEventHandler(Runnable runnable) {
        setEventHandler((Task) new TaskWrapper(runnable));
    }

    @Override
    public void setCancelHandler(Task task) {
        this.cancelHandler = task;
    }

    @Override
    public void setEventHandler(Task task) {
        this.eventHandler = task;
    }
}
