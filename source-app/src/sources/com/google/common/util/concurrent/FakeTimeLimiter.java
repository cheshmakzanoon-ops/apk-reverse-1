package com.google.common.util.concurrent;

import com.google.common.base.Preconditions;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;

@ElementTypesAreNonnullByDefault
public final class FakeTimeLimiter implements TimeLimiter {
    @Override
    public <T> T newProxy(T t, Class<T> cls, long j, TimeUnit timeUnit) {
        Preconditions.checkNotNull(t);
        Preconditions.checkNotNull(cls);
        Preconditions.checkNotNull(timeUnit);
        return t;
    }

    @Override
    @ParametricNullness
    public <T> T callWithTimeout(Callable<T> callable, long j, TimeUnit timeUnit) throws ExecutionException {
        Preconditions.checkNotNull(callable);
        Preconditions.checkNotNull(timeUnit);
        try {
            return callable.call();
        } catch (Error e) {
            throw new ExecutionError(e);
        } catch (RuntimeException e2) {
            throw new UncheckedExecutionException(e2);
        } catch (Exception e3) {
            throw new ExecutionException(e3);
        } catch (Throwable th) {
            throw new ExecutionException(th);
        }
    }

    @Override
    @ParametricNullness
    public <T> T callUninterruptiblyWithTimeout(Callable<T> callable, long j, TimeUnit timeUnit) throws ExecutionException {
        return (T) callWithTimeout(callable, j, timeUnit);
    }

    @Override
    public void runWithTimeout(Runnable runnable, long j, TimeUnit timeUnit) {
        Preconditions.checkNotNull(runnable);
        Preconditions.checkNotNull(timeUnit);
        try {
            runnable.run();
        } catch (Error e) {
            throw new ExecutionError(e);
        } catch (RuntimeException e2) {
            throw new UncheckedExecutionException(e2);
        } catch (Throwable th) {
            throw new UncheckedExecutionException(th);
        }
    }

    @Override
    public void runUninterruptiblyWithTimeout(Runnable runnable, long j, TimeUnit timeUnit) {
        runWithTimeout(runnable, j, timeUnit);
    }
}
