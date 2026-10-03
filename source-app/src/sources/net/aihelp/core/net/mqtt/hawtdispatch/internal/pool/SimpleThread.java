package net.aihelp.core.net.mqtt.hawtdispatch.internal.pool;

import java.io.IOException;
import java.util.concurrent.ConcurrentLinkedQueue;
import net.aihelp.core.net.mqtt.hawtdispatch.Task;
import net.aihelp.core.net.mqtt.hawtdispatch.internal.NioManager;
import net.aihelp.core.net.mqtt.hawtdispatch.internal.ThreadDispatchQueue;
import net.aihelp.core.net.mqtt.hawtdispatch.internal.WorkerThread;

public class SimpleThread extends WorkerThread {
    public static final boolean DEBUG = false;
    private final NioManager nioManager;
    private SimplePool pool;
    private ThreadDispatchQueue threadQueue;

    protected void debug(String str, Object... objArr) {
    }

    protected void debug(Throwable th, String str, Object... objArr) {
    }

    public SimpleThread(SimplePool simplePool) throws IOException {
        super(simplePool.group, simplePool.name);
        this.pool = simplePool;
        this.nioManager = new NioManager();
        this.threadQueue = new ThreadDispatchQueue(simplePool.globalQueue, this);
    }

    @Override
    public ThreadDispatchQueue getDispatchQueue() {
        return this.threadQueue;
    }

    @Override
    public void unpark() {
        this.nioManager.wakeupIfSelecting();
    }

    @Override
    public NioManager getNioManager() {
        return this.nioManager;
    }

    @Override
    public void run() {
        debug("run start", new Object[0]);
        try {
            ConcurrentLinkedQueue<Task> concurrentLinkedQueue = this.pool.tasks;
            while (!this.pool.shutdown) {
                Task taskPoll = this.threadQueue.poll();
                if (taskPoll == null && (taskPoll = concurrentLinkedQueue.poll()) == null) {
                    taskPoll = this.threadQueue.getSourceQueue().poll();
                }
                if (taskPoll == null) {
                    this.pool.park(this);
                } else {
                    taskPoll.run();
                }
            }
            debug("run end", new Object[0]);
        } catch (Throwable th) {
            debug("run end", new Object[0]);
            throw th;
        }
    }
}
