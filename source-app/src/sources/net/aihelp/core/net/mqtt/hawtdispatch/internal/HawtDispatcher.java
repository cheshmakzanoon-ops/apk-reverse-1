package net.aihelp.core.net.mqtt.hawtdispatch.internal;

import java.nio.channels.SelectableChannel;
import java.util.ArrayList;
import java.util.List;
import java.util.WeakHashMap;
import java.util.concurrent.atomic.AtomicInteger;
import net.aihelp.core.net.mqtt.hawtdispatch.CustomDispatchSource;
import net.aihelp.core.net.mqtt.hawtdispatch.DispatchPriority;
import net.aihelp.core.net.mqtt.hawtdispatch.DispatchQueue;
import net.aihelp.core.net.mqtt.hawtdispatch.DispatchSource;
import net.aihelp.core.net.mqtt.hawtdispatch.Dispatcher;
import net.aihelp.core.net.mqtt.hawtdispatch.EventAggregator;
import net.aihelp.core.net.mqtt.hawtdispatch.Metrics;
import net.aihelp.core.net.mqtt.hawtdispatch.Task;

public final class HawtDispatcher implements Dispatcher {
    public static final ThreadLocal<HawtDispatchQueue> CURRENT_QUEUE = new ThreadLocal<>();
    public static final WeakHashMap<HawtDispatchQueue, Object> queues = new WeakHashMap<>();
    final GlobalDispatchQueue DEFAULT_QUEUE;
    private GlobalDispatchQueue HIGH_QUEUE;
    private GlobalDispatchQueue LOW_QUEUE;
    final int drains;
    final boolean jmx;
    private final String label;
    private volatile boolean profile;
    private final int threads;
    volatile TimerThread timerThread;
    private final Object HIGH_MUTEX = new Object();
    private final Object LOW_MUTEX = new Object();
    final AtomicInteger shutdownState = new AtomicInteger(0);
    volatile Thread.UncaughtExceptionHandler uncaughtExceptionHandler = null;

    public HawtDispatcher(DispatcherConfig dispatcherConfig) {
        this.threads = dispatcherConfig.getThreads();
        this.label = dispatcherConfig.getLabel();
        this.profile = dispatcherConfig.isProfile();
        this.drains = dispatcherConfig.getDrains();
        this.jmx = dispatcherConfig.isJmx();
        GlobalDispatchQueue globalDispatchQueue = new GlobalDispatchQueue(this, DispatchPriority.DEFAULT, dispatcherConfig.getThreads());
        this.DEFAULT_QUEUE = globalDispatchQueue;
        globalDispatchQueue.start();
        globalDispatchQueue.profile(this.profile);
        this.timerThread = new TimerThread(this);
        this.timerThread.start();
    }

    @Override
    public void shutdown() {
        if (this.shutdownState.compareAndSet(0, 1)) {
            sleep(100L);
            this.timerThread.shutdown(new Task() {
                @Override
                public void run() {
                    HawtDispatcher.this.shutdownState.set(2);
                    HawtDispatcher.this.sleep(100L);
                    HawtDispatcher.this.DEFAULT_QUEUE.shutdown();
                    if (HawtDispatcher.this.LOW_QUEUE != null) {
                        HawtDispatcher.this.LOW_QUEUE.shutdown();
                    }
                    if (HawtDispatcher.this.HIGH_QUEUE != null) {
                        HawtDispatcher.this.HIGH_QUEUE.shutdown();
                    }
                    HawtDispatcher.this.shutdownState.set(3);
                }
            }, this.DEFAULT_QUEUE);
        }
    }

    public void sleep(long j) {
        try {
            Thread.sleep(j);
        } catch (InterruptedException unused) {
        }
    }

    @Override
    public void restart() {
        if (this.shutdownState.compareAndSet(3, 0)) {
            this.timerThread = new TimerThread(this);
            this.timerThread.start();
            this.DEFAULT_QUEUE.start();
            GlobalDispatchQueue globalDispatchQueue = this.LOW_QUEUE;
            if (globalDispatchQueue != null) {
                globalDispatchQueue.start();
            }
            GlobalDispatchQueue globalDispatchQueue2 = this.HIGH_QUEUE;
            if (globalDispatchQueue2 != null) {
                globalDispatchQueue2.start();
                return;
            }
            return;
        }
        throw new IllegalStateException("Not shutdown yet.");
    }

    @Override
    public DispatchQueue getGlobalQueue() {
        return getGlobalQueue(DispatchPriority.DEFAULT);
    }

    static class C05052 {

        static final int[] f70x7a9eb68a;

        static {
            int[] iArr = new int[DispatchPriority.values().length];
            f70x7a9eb68a = iArr;
            try {
                iArr[DispatchPriority.DEFAULT.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                f70x7a9eb68a[DispatchPriority.HIGH.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                f70x7a9eb68a[DispatchPriority.LOW.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
        }
    }

    @Override
    public GlobalDispatchQueue getGlobalQueue(DispatchPriority dispatchPriority) {
        GlobalDispatchQueue globalDispatchQueue;
        GlobalDispatchQueue globalDispatchQueue2;
        int i = C05052.f70x7a9eb68a[dispatchPriority.ordinal()];
        if (i == 1) {
            return this.DEFAULT_QUEUE;
        }
        if (i == 2) {
            synchronized (this.HIGH_MUTEX) {
                if (this.HIGH_QUEUE == null) {
                    GlobalDispatchQueue globalDispatchQueue3 = new GlobalDispatchQueue(this, DispatchPriority.HIGH, this.threads);
                    this.HIGH_QUEUE = globalDispatchQueue3;
                    globalDispatchQueue3.start();
                    this.HIGH_QUEUE.profile(this.profile);
                }
                globalDispatchQueue = this.HIGH_QUEUE;
            }
            return globalDispatchQueue;
        }
        if (i == 3) {
            synchronized (this.LOW_MUTEX) {
                if (this.LOW_QUEUE == null) {
                    GlobalDispatchQueue globalDispatchQueue4 = new GlobalDispatchQueue(this, DispatchPriority.LOW, this.threads);
                    this.LOW_QUEUE = globalDispatchQueue4;
                    globalDispatchQueue4.start();
                    this.LOW_QUEUE.profile(this.profile);
                }
                globalDispatchQueue2 = this.LOW_QUEUE;
            }
            return globalDispatchQueue2;
        }
        throw new AssertionError("switch missing case");
    }

    @Override
    public SerialDispatchQueue createQueue(String str) {
        SerialDispatchQueue serialDispatchQueue = new SerialDispatchQueue(str);
        serialDispatchQueue.setTargetQueue(getGlobalQueue());
        serialDispatchQueue.profile(this.profile);
        return serialDispatchQueue;
    }

    @Override
    public DispatchSource createSource(SelectableChannel selectableChannel, int i, DispatchQueue dispatchQueue) {
        return new NioDispatchSource(this, selectableChannel, i, dispatchQueue);
    }

    @Override
    public <Event, MergedEvent> CustomDispatchSource<Event, MergedEvent> createSource(EventAggregator<Event, MergedEvent> eventAggregator, DispatchQueue dispatchQueue) {
        return new HawtCustomDispatchSource(this, eventAggregator, dispatchQueue);
    }

    public String getLabel() {
        return this.label;
    }

    @Override
    public DispatchQueue getCurrentQueue() {
        return CURRENT_QUEUE.get();
    }

    @Override
    public ThreadDispatchQueue getCurrentThreadQueue() {
        WorkerThread workerThreadCurrentWorkerThread = WorkerThread.currentWorkerThread();
        if (workerThreadCurrentWorkerThread == null) {
            return null;
        }
        return workerThreadCurrentWorkerThread.getDispatchQueue();
    }

    @Override
    public DispatchQueue[] getThreadQueues(DispatchPriority dispatchPriority) {
        return getGlobalQueue(dispatchPriority).getThreadQueues();
    }

    void track(HawtDispatchQueue hawtDispatchQueue) {
        WeakHashMap<HawtDispatchQueue, Object> weakHashMap = queues;
        synchronized (weakHashMap) {
            weakHashMap.put(hawtDispatchQueue, Boolean.TRUE);
        }
    }

    void untrack(HawtDispatchQueue hawtDispatchQueue) {
        WeakHashMap<HawtDispatchQueue, Object> weakHashMap = queues;
        synchronized (weakHashMap) {
            weakHashMap.remove(hawtDispatchQueue);
        }
    }

    @Override
    public void profile(boolean z) {
        this.profile = z;
    }

    @Override
    public boolean profile() {
        return this.profile;
    }

    @Override
    public List<Metrics> metrics() {
        ArrayList arrayList;
        Metrics metrics;
        WeakHashMap<HawtDispatchQueue, Object> weakHashMap = queues;
        synchronized (weakHashMap) {
            arrayList = new ArrayList();
            for (HawtDispatchQueue hawtDispatchQueue : weakHashMap.keySet()) {
                if (hawtDispatchQueue != null && (metrics = hawtDispatchQueue.metrics()) != null) {
                    arrayList.add(metrics);
                }
            }
        }
        return arrayList;
    }

    String assertMessage(String str) {
        StringBuilder sb = new StringBuilder("Dispatch queue '");
        if (str != null) {
            sb.append(str);
        } else {
            sb.append("<no-label>");
        }
        sb.append("' was not executing, (currently executing: '");
        DispatchQueue currentQueue = getCurrentQueue();
        if (currentQueue != null) {
            if (currentQueue.getLabel() != null) {
                sb.append(currentQueue.getLabel());
            } else {
                sb.append("<no-label>");
            }
        } else {
            sb.append("<not-dispatched>");
        }
        sb.append("')");
        return sb.toString();
    }

    public Thread.UncaughtExceptionHandler getUncaughtExceptionHandler() {
        return this.uncaughtExceptionHandler;
    }

    public void setUncaughtExceptionHandler(Thread.UncaughtExceptionHandler uncaughtExceptionHandler) {
        this.uncaughtExceptionHandler = uncaughtExceptionHandler;
    }
}
