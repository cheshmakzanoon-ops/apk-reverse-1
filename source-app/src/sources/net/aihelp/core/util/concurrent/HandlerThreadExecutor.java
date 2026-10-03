package net.aihelp.core.util.concurrent;

import android.os.Handler;
import android.os.HandlerThread;
import android.os.Looper;

public class HandlerThreadExecutor implements ApiExecutor {
    private Handler handler;
    private final Object syncLock = new Object();
    private Handler uiHandler;

    public HandlerThreadExecutor(String str) {
        HandlerThread handlerThread = new HandlerThread(str);
        handlerThread.start();
        this.handler = new Handler(handlerThread.getLooper());
        this.uiHandler = new Handler(Looper.getMainLooper());
    }

    @Override
    public void runAsync(Runnable runnable) {
        this.handler.post(runnable);
    }

    @Override
    public void runAsyncDelayed(Runnable runnable, long j) {
        this.handler.postDelayed(runnable, j);
    }

    @Override
    public void runSync(Runnable runnable) {
        NotifyingRunnable notifyingRunnable = new NotifyingRunnable(runnable);
        synchronized (this.syncLock) {
            this.handler.post(notifyingRunnable);
            notifyingRunnable.waitForCompletion();
        }
    }

    @Override
    public void runSyncDelayed(Runnable runnable, long j) {
        NotifyingRunnable notifyingRunnable = new NotifyingRunnable(runnable);
        synchronized (this.syncLock) {
            this.handler.postDelayed(notifyingRunnable, j);
            notifyingRunnable.waitForCompletion();
        }
    }

    @Override
    public void runOnUiThread(final Runnable runnable) {
        runAsync(new Runnable() {
            @Override
            public void run() {
                HandlerThreadExecutor.this.uiHandler.post(runnable);
            }
        });
    }

    @Override
    public void runOnUiThreadDelayed(final Runnable runnable, final long j) {
        runAsync(new Runnable() {
            @Override
            public void run() {
                HandlerThreadExecutor.this.uiHandler.postDelayed(runnable, j);
            }
        });
    }

    @Override
    public void awaitForSyncExecution() {
        runSync(new Runnable() {
            @Override
            public void run() {
            }
        });
    }
}
