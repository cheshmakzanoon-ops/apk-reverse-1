package net.aihelp.core.net.mqtt.hawtdispatch.internal;

public abstract class WorkerThread extends Thread {
    public abstract ThreadDispatchQueue getDispatchQueue();

    public abstract NioManager getNioManager();

    public abstract void unpark();

    protected WorkerThread() {
    }

    protected WorkerThread(ThreadGroup threadGroup, String str) {
        super(threadGroup, str);
    }

    protected WorkerThread(String str) {
        super(str);
    }

    public static WorkerThread currentWorkerThread() {
        Thread threadCurrentThread = Thread.currentThread();
        if (threadCurrentThread instanceof WorkerThread) {
            return (WorkerThread) threadCurrentThread;
        }
        return null;
    }

    @Override
    public void setUncaughtExceptionHandler(Thread.UncaughtExceptionHandler uncaughtExceptionHandler) {
        getDispatchQueue().getDispatcher().setUncaughtExceptionHandler(uncaughtExceptionHandler);
    }
}
