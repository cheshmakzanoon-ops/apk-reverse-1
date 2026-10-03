package com.ishumei.smantifraud;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ThreadFactory;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

public class l1l11I1l1l {
    public static final ExecutorService l1111l111111Il = new ThreadPoolExecutor(0, 1, 3000, TimeUnit.MILLISECONDS, new LinkedBlockingQueue(20), new ThreadFactory() {
        @Override
        public final Thread newThread(Runnable runnable) {
            return l1l11I1l1l.l1111l111111Il(runnable);
        }
    }, new ThreadPoolExecutor.DiscardOldestPolicy());

    public static Thread l1111l111111Il(Runnable runnable) {
        return new Thread(runnable, "sm-thread-p-stp");
    }
}
