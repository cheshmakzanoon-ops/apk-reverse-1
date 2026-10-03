package net.aihelp.core.util.concurrent;

public interface ApiExecutor {
    void awaitForSyncExecution();

    void runAsync(Runnable runnable);

    void runAsyncDelayed(Runnable runnable, long j);

    void runOnUiThread(Runnable runnable);

    void runOnUiThreadDelayed(Runnable runnable, long j);

    void runSync(Runnable runnable);

    void runSyncDelayed(Runnable runnable, long j);
}
