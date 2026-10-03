package com.google.firebase.concurrent;

import java.util.Collection;
import java.util.List;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Future;
import java.util.concurrent.FutureTask;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

final class PausableExecutorServiceImpl implements PausableExecutorService {
    private final ExecutorService delegateService;
    private final PausableExecutor pausableDelegate;

    PausableExecutorServiceImpl(boolean z, ExecutorService executorService) {
        this.delegateService = executorService;
        this.pausableDelegate = new PausableExecutorImpl(z, executorService);
    }

    @Override
    public void execute(Runnable runnable) {
        this.pausableDelegate.execute(runnable);
    }

    @Override
    public void pause() {
        this.pausableDelegate.pause();
    }

    @Override
    public void resume() {
        this.pausableDelegate.resume();
    }

    @Override
    public boolean isPaused() {
        return this.pausableDelegate.isPaused();
    }

    @Override
    public void shutdown() {
        throw new UnsupportedOperationException("Shutting down is not allowed.");
    }

    @Override
    public List<Runnable> shutdownNow() {
        throw new UnsupportedOperationException("Shutting down is not allowed.");
    }

    @Override
    public boolean isShutdown() {
        return this.delegateService.isShutdown();
    }

    @Override
    public boolean isTerminated() {
        return this.delegateService.isTerminated();
    }

    @Override
    public boolean awaitTermination(long j, TimeUnit timeUnit) throws InterruptedException {
        return this.delegateService.awaitTermination(j, timeUnit);
    }

    @Override
    public <T> Future<T> submit(Callable<T> callable) {
        FutureTask futureTask = new FutureTask(callable);
        execute(futureTask);
        return futureTask;
    }

    @Override
    public <T> Future<T> submit(final Runnable runnable, final T t) {
        return submit(new Callable() {
            @Override
            public final Object call() {
                return PausableExecutorServiceImpl.lambda$submit$0(runnable, t);
            }
        });
    }

    static Object lambda$submit$0(Runnable runnable, Object obj) throws Exception {
        runnable.run();
        return obj;
    }

    @Override
    public Future<?> submit(final Runnable runnable) {
        return submit(new Callable() {
            @Override
            public final Object call() {
                return PausableExecutorServiceImpl.lambda$submit$1(runnable);
            }
        });
    }

    static Object lambda$submit$1(Runnable runnable) throws Exception {
        runnable.run();
        return null;
    }

    @Override
    public <T> List<Future<T>> invokeAll(Collection<? extends Callable<T>> collection) throws InterruptedException {
        return this.delegateService.invokeAll(collection);
    }

    @Override
    public <T> List<Future<T>> invokeAll(Collection<? extends Callable<T>> collection, long j, TimeUnit timeUnit) throws InterruptedException {
        return this.delegateService.invokeAll(collection, j, timeUnit);
    }

    @Override
    public <T> T invokeAny(Collection<? extends Callable<T>> collection) throws ExecutionException, InterruptedException {
        return (T) this.delegateService.invokeAny(collection);
    }

    @Override
    public <T> T invokeAny(Collection<? extends Callable<T>> collection, long j, TimeUnit timeUnit) throws ExecutionException, InterruptedException, TimeoutException {
        return (T) this.delegateService.invokeAny(collection, j, timeUnit);
    }
}
