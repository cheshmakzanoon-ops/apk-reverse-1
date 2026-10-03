package net.aihelp.core.net.mqtt.hawtdispatch.internal.pool;

import java.io.IOException;
import java.util.concurrent.ConcurrentLinkedQueue;
import net.aihelp.core.net.mqtt.hawtdispatch.DispatchPriority;
import net.aihelp.core.net.mqtt.hawtdispatch.Task;
import net.aihelp.core.net.mqtt.hawtdispatch.internal.GlobalDispatchQueue;
import net.aihelp.core.net.mqtt.hawtdispatch.internal.HawtThreadGroup;
import net.aihelp.core.net.mqtt.hawtdispatch.internal.WorkerPool;
import net.aihelp.core.net.mqtt.hawtdispatch.internal.WorkerThread;

public class SimplePool implements WorkerPool {
    public static final boolean DEBUG = false;
    final GlobalDispatchQueue globalQueue;
    final ThreadGroup group;
    final String name;
    final int priority;
    final SimpleThread[] threads;
    final ConcurrentLinkedQueue<Task> tasks = new ConcurrentLinkedQueue<>();
    volatile boolean shutdown = false;

    protected void debug(String str, Object... objArr) {
    }

    protected void debug(Throwable th, String str, Object... objArr) {
    }

    public SimplePool(GlobalDispatchQueue globalDispatchQueue, int i, DispatchPriority dispatchPriority) {
        this.globalQueue = globalDispatchQueue;
        String str = globalDispatchQueue.dispatcher.getLabel() + "-" + dispatchPriority;
        this.name = str;
        this.group = new HawtThreadGroup(globalDispatchQueue.dispatcher, str);
        this.priority = priority(dispatchPriority);
        this.threads = new SimpleThread[i];
    }

    static class C05151 {

        static final int[] f72x7a9eb68a;

        static {
            int[] iArr = new int[DispatchPriority.values().length];
            f72x7a9eb68a = iArr;
            try {
                iArr[DispatchPriority.HIGH.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                f72x7a9eb68a[DispatchPriority.DEFAULT.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                f72x7a9eb68a[DispatchPriority.LOW.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
        }
    }

    private static int priority(DispatchPriority dispatchPriority) {
        int i = C05151.f72x7a9eb68a[dispatchPriority.ordinal()];
        if (i == 1) {
            return 10;
        }
        if (i != 2) {
            return i != 3 ? 0 : 1;
        }
        return 5;
    }

    @Override
    public void start() {
        int i = 0;
        this.shutdown = false;
        while (true) {
            SimpleThread[] simpleThreadArr = this.threads;
            if (i >= simpleThreadArr.length) {
                return;
            }
            simpleThreadArr[i] = createWorker(i);
            this.threads[i].start();
            i++;
        }
    }

    private SimpleThread createWorker(int i) {
        try {
            SimpleThread simpleThread = new SimpleThread(this);
            simpleThread.setDaemon(true);
            simpleThread.setPriority(this.priority);
            simpleThread.setName(this.name + "-" + (i + 1));
            return simpleThread;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public WorkerThread[] getThreads() {
        return this.threads;
    }

    @Override
    public void shutdown() {
        while (!this.tasks.isEmpty()) {
            try {
                Thread.sleep(50L);
            } catch (InterruptedException unused) {
                Thread.currentThread().interrupt();
                return;
            }
        }
        this.shutdown = true;
        int i = 0;
        int i2 = 0;
        while (true) {
            SimpleThread[] simpleThreadArr = this.threads;
            if (i2 >= simpleThreadArr.length) {
                break;
            }
            simpleThreadArr[i2].unpark();
            i2++;
        }
        while (true) {
            SimpleThread[] simpleThreadArr2 = this.threads;
            if (i >= simpleThreadArr2.length) {
                return;
            }
            simpleThreadArr2[i].join();
            i++;
        }
    }

    @Override
    public void execute(Task task) {
        WorkerThread workerThreadCurrentWorkerThread = WorkerThread.currentWorkerThread();
        this.tasks.add(task);
        int i = 0;
        while (true) {
            SimpleThread[] simpleThreadArr = this.threads;
            if (i >= simpleThreadArr.length) {
                return;
            }
            SimpleThread simpleThread = simpleThreadArr[i];
            if (simpleThread != workerThreadCurrentWorkerThread && simpleThread.getNioManager().wakeupIfSelecting()) {
                return;
            } else {
                i++;
            }
        }
    }

    public void park(SimpleThread simpleThread) {
        try {
            debug("parking thread: %s", simpleThread.getName());
            simpleThread.getNioManager().select(-1L);
            debug("unparking thread: %s", simpleThread.getName());
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}
