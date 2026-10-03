package cz.msebera.android.httpclient.impl.client.cache;

import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

public class ImmediateSchedulingStrategy implements SchedulingStrategy {
    private final ExecutorService executor;

    public ImmediateSchedulingStrategy(CacheConfig cacheConfig) {
        this(new ThreadPoolExecutor(cacheConfig.getAsynchronousWorkersCore(), cacheConfig.getAsynchronousWorkersMax(), cacheConfig.getAsynchronousWorkerIdleLifetimeSecs(), TimeUnit.SECONDS, new ArrayBlockingQueue(cacheConfig.getRevalidationQueueSize())));
    }

    ImmediateSchedulingStrategy(ExecutorService executorService) {
        this.executor = executorService;
    }

    @Override
    public void schedule(AsynchronousValidationRequest asynchronousValidationRequest) {
        if (asynchronousValidationRequest == null) {
            throw new IllegalArgumentException("AsynchronousValidationRequest may not be null");
        }
        this.executor.execute(asynchronousValidationRequest);
    }

    @Override
    public void close() {
        this.executor.shutdown();
    }

    void awaitTermination(long j, TimeUnit timeUnit) throws InterruptedException {
        this.executor.awaitTermination(j, timeUnit);
    }
}
