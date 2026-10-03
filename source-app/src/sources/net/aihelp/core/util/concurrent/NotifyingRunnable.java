package net.aihelp.core.util.concurrent;

public class NotifyingRunnable implements Runnable {
    private static final String TAG = "NotifyingRunnable";
    private boolean isFinished;
    private final Runnable runnable;
    private final Object syncLock = new Object();

    NotifyingRunnable(Runnable runnable) {
        this.runnable = runnable;
    }

    public void waitForCompletion() {
        synchronized (this.syncLock) {
            try {
                if (!this.isFinished) {
                    this.syncLock.wait();
                }
            } catch (InterruptedException e) {
                e.printStackTrace();
                Thread.currentThread().interrupt();
            }
        }
    }

    @Override
    public void run() {
        synchronized (this.syncLock) {
            try {
                this.runnable.run();
                this.isFinished = true;
                this.syncLock.notifyAll();
            } catch (Throwable th) {
                this.isFinished = true;
                this.syncLock.notifyAll();
                throw th;
            }
        }
    }
}
