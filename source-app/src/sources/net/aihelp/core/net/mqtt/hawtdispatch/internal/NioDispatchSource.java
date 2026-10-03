package net.aihelp.core.net.mqtt.hawtdispatch.internal;

import java.nio.channels.CancelledKeyException;
import java.nio.channels.ClosedChannelException;
import java.nio.channels.SelectableChannel;
import java.nio.channels.SelectionKey;
import java.util.ArrayList;
import java.util.concurrent.atomic.AtomicBoolean;
import net.aihelp.core.net.mqtt.hawtdispatch.DispatchQueue;
import net.aihelp.core.net.mqtt.hawtdispatch.DispatchSource;
import net.aihelp.core.net.mqtt.hawtdispatch.Task;
import net.aihelp.core.net.mqtt.hawtdispatch.TaskWrapper;

public final class NioDispatchSource extends AbstractDispatchObject implements DispatchSource {
    public static final boolean DEBUG = false;
    Task cancelHandler;
    final SelectableChannel channel;
    Task eventHandler;
    final int interestOps;
    volatile DispatchQueue selectorQueue;
    final AtomicBoolean canceled = new AtomicBoolean();
    final ThreadLocal<KeyState> keyState = new ThreadLocal<>();
    private Task updateInterestTask = new Task() {
        @Override
        public void run() {
            KeyState keyState;
            if (NioDispatchSource.this.isSuspended() || NioDispatchSource.this.isCanceled() || (keyState = NioDispatchSource.this.keyState.get()) == null) {
                return;
            }
            SelectionKey selectionKeyKey = keyState.key();
            try {
                selectionKeyKey.interestOps(selectionKeyKey.interestOps() | NioDispatchSource.this.interestOps);
            } catch (CancelledKeyException unused) {
                NioDispatchSource.this.internal_cancel();
            }
        }
    };

    protected void debug(String str, Object... objArr) {
    }

    protected void debug(Throwable th, String str, Object... objArr) {
    }

    public Void getData() {
        return null;
    }

    public static class KeyState {
        final NioAttachment attachment;
        int readyOps;

        public SelectionKey key() {
            return this.attachment.key();
        }

        public KeyState(NioAttachment nioAttachment) {
            this.attachment = nioAttachment;
        }

        public String toString() {
            return "{ready: " + NioDispatchSource.opsToString(this.readyOps) + " }";
        }
    }

    public static String opsToString(int i) {
        ArrayList arrayList = new ArrayList();
        if ((i & 16) != 0) {
            arrayList.add("ACCEPT");
        }
        if ((i & 8) != 0) {
            arrayList.add("CONNECT");
        }
        if ((i & 1) != 0) {
            arrayList.add("READ");
        }
        if ((i & 4) != 0) {
            arrayList.add("WRITE");
        }
        return arrayList.toString();
    }

    public NioDispatchSource(HawtDispatcher hawtDispatcher, SelectableChannel selectableChannel, int i, DispatchQueue dispatchQueue) {
        if (i == 0) {
            throw new IllegalArgumentException("invalid interest ops");
        }
        this.channel = selectableChannel;
        this.selectorQueue = pickThreadQueue(hawtDispatcher, dispatchQueue);
        this.interestOps = i;
        this.suspended.incrementAndGet();
        setTargetQueue(dispatchQueue);
    }

    private static DispatchQueue pickThreadQueue(HawtDispatcher hawtDispatcher, DispatchQueue dispatchQueue) {
        while (dispatchQueue.getQueueType() != DispatchQueue.QueueType.THREAD_QUEUE && dispatchQueue.getTargetQueue() != null) {
            dispatchQueue = dispatchQueue.getTargetQueue();
        }
        if (dispatchQueue.getQueueType() == DispatchQueue.QueueType.THREAD_QUEUE) {
            return dispatchQueue;
        }
        WorkerThread[] threads = hawtDispatcher.DEFAULT_QUEUE.workers.getThreads();
        WorkerThread workerThread = threads[0];
        int registeredKeyCount = workerThread.getNioManager().getRegisteredKeyCount();
        for (int i = 1; i < threads.length; i++) {
            int registeredKeyCount2 = threads[i].getNioManager().getRegisteredKeyCount();
            if (registeredKeyCount2 < registeredKeyCount) {
                workerThread = threads[i];
                registeredKeyCount = registeredKeyCount2;
            }
        }
        return workerThread.getDispatchQueue();
    }

    @Override
    protected void onStartup() {
        if (this.eventHandler == null) {
            throw new IllegalArgumentException("eventHandler must be set");
        }
        register_on(this.selectorQueue);
    }

    @Override
    public void cancel() {
        if (this.canceled.compareAndSet(false, true)) {
            this.selectorQueue.execute(new Task() {
                @Override
                public void run() {
                    NioDispatchSource.this.internal_cancel();
                }
            });
        }
    }

    void internal_cancel() {
        key_cancel();
        if (this.cancelHandler != null) {
            this.targetQueue.execute(this.cancelHandler);
        }
    }

    public NioManager getCurrentNioManager() {
        return WorkerThread.currentWorkerThread().getNioManager();
    }

    public void key_cancel() {
        KeyState keyState = this.keyState.get();
        if (keyState == null) {
            return;
        }
        debug("canceling source", new Object[0]);
        keyState.attachment.sources.remove(this);
        if (keyState.attachment.sources.isEmpty()) {
            debug("canceling key.", new Object[0]);
            getCurrentNioManager().cancel(keyState.key());
        }
        this.keyState.remove();
    }

    public void register_on(DispatchQueue dispatchQueue) {
        dispatchQueue.execute(new Task() {
            @Override
            public void run() {
                try {
                    NioAttachment nioAttachmentRegister = NioDispatchSource.this.getCurrentNioManager().register(NioDispatchSource.this.channel, NioDispatchSource.this.interestOps);
                    nioAttachmentRegister.sources.add(NioDispatchSource.this);
                    NioDispatchSource.this.keyState.set(new KeyState(nioAttachmentRegister));
                } catch (ClosedChannelException e) {
                    NioDispatchSource.this.debug(e, "could not register with selector", new Object[0]);
                }
                NioDispatchSource.this.debug("Registered", new Object[0]);
            }
        });
    }

    public void fire(final int i) {
        KeyState keyState = this.keyState.get();
        if (keyState == null) {
            return;
        }
        keyState.readyOps |= i;
        if (keyState.readyOps == 0 || isSuspended() || isCanceled()) {
            return;
        }
        keyState.readyOps = 0;
        this.targetQueue.execute(new Task() {
            @Override
            public void run() {
                if (NioDispatchSource.this.isSuspended() || NioDispatchSource.this.isCanceled()) {
                    return;
                }
                try {
                    NioDispatchSource.this.eventHandler.run();
                } catch (Throwable th) {
                    Thread threadCurrentThread = Thread.currentThread();
                    threadCurrentThread.getUncaughtExceptionHandler().uncaughtException(threadCurrentThread, th);
                }
                NioDispatchSource.this.updateInterest();
            }
        });
    }

    public void updateInterest() {
        if (isCurrent(this.selectorQueue)) {
            this.updateInterestTask.run();
        } else {
            this.selectorQueue.execute(this.updateInterestTask);
        }
    }

    private boolean isCurrent(DispatchQueue dispatchQueue) {
        WorkerThread workerThreadCurrentWorkerThread = WorkerThread.currentWorkerThread();
        return workerThreadCurrentWorkerThread != null && workerThreadCurrentWorkerThread.getDispatchQueue() == dispatchQueue;
    }

    @Override
    protected void onSuspend() {
        debug("onSuspend", new Object[0]);
        super.onSuspend();
    }

    @Override
    protected void onResume() {
        debug("onResume", new Object[0]);
        if (isCurrent(this.selectorQueue)) {
            KeyState keyState = this.keyState.get();
            if (keyState == null || keyState.readyOps == 0) {
                updateInterest();
                return;
            } else {
                fire(keyState.readyOps);
                return;
            }
        }
        this.selectorQueue.execute(new Task() {
            @Override
            public void run() {
                KeyState keyState2 = NioDispatchSource.this.keyState.get();
                if (keyState2 == null || keyState2.readyOps == 0) {
                    NioDispatchSource.this.updateInterest();
                } else {
                    NioDispatchSource nioDispatchSource = NioDispatchSource.this;
                    nioDispatchSource.fire(nioDispatchSource.interestOps);
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

    @Override
    public void setTargetQueue(final DispatchQueue dispatchQueue) {
        super.setTargetQueue(dispatchQueue);
        while (dispatchQueue.getQueueType() != DispatchQueue.QueueType.THREAD_QUEUE && dispatchQueue.getTargetQueue() != null) {
            dispatchQueue = dispatchQueue.getTargetQueue();
        }
        if (dispatchQueue.getQueueType() != DispatchQueue.QueueType.THREAD_QUEUE || dispatchQueue == this.selectorQueue) {
            return;
        }
        DispatchQueue dispatchQueue2 = this.selectorQueue;
        debug("Switching to " + dispatchQueue.getLabel(), new Object[0]);
        this.selectorQueue = dispatchQueue;
        if (dispatchQueue2 != null) {
            dispatchQueue2.execute(new Task() {
                @Override
                public void run() {
                    NioDispatchSource.this.key_cancel();
                    NioDispatchSource.this.register_on(dispatchQueue);
                }
            });
        } else {
            register_on(dispatchQueue);
        }
    }
}
