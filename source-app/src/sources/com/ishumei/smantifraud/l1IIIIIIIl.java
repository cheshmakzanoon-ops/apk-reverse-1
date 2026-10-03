package com.ishumei.smantifraud;

import java.util.concurrent.Callable;
import java.util.concurrent.Future;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ThreadFactory;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

public class l1IIIIIIIl {
    public static Thread l1111l111111Il(Runnable runnable) {
        return new Thread(runnable, "sm-thread-p-tf");
    }

    public <T> T l1111l111111Il(long j, Callable<T> callable) {
        TimeUnit timeUnit = TimeUnit.MILLISECONDS;
        ThreadPoolExecutor threadPoolExecutor = new ThreadPoolExecutor(1, 1, 0L, timeUnit, new LinkedBlockingQueue(), new ThreadFactory() {
            @Override
            public final Thread newThread(Runnable runnable) {
                return l1IIIIIIIl.l1111l111111Il(runnable);
            }
        }, new ThreadPoolExecutor.DiscardOldestPolicy());
        Future<T> futureSubmit = threadPoolExecutor.submit(callable);
        try {
            T t = futureSubmit.get(j, timeUnit);
            threadPoolExecutor.shutdown();
            return t;
        } catch (Throwable unused) {
            try {
                futureSubmit.cancel(true);
                return null;
            } finally {
                threadPoolExecutor.shutdown();
            }
        }
    }
}
