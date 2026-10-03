package net.aihelp.core.util.concurrent;

import java.util.Iterator;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.LinkedBlockingQueue;

public class DispatchQueue {
    private static final String TAG = "AIHelp_DispatchQueue";
    private ExecutorService threadPoolExecutor;
    private LinkedBlockingQueue<Future> tasks = new LinkedBlockingQueue<>();
    private LinkedBlockingQueue<Thread> afterThreads = new LinkedBlockingQueue<>();

    public DispatchQueue(boolean z) {
        if (z) {
            this.threadPoolExecutor = Executors.newCachedThreadPool(new AIHelpThreadFactory("cmdpq-a"));
        } else {
            this.threadPoolExecutor = Executors.newSingleThreadExecutor(new AIHelpThreadFactory("cmdpq-b"));
        }
    }

    public void dispatchSync(Runnable runnable) {
        try {
            this.threadPoolExecutor.submit(runnable).get();
        } catch (InterruptedException e) {
            e.printStackTrace();
            Thread.currentThread().interrupt();
        } catch (ExecutionException e2) {
            e2.printStackTrace();
        }
    }

    private void trackTask(Future future) {
        this.tasks.add(future);
    }

    public void dispatchAsync(Runnable runnable) {
        trackTask(this.threadPoolExecutor.submit(runnable));
    }

    public void dispatchAfter(final Runnable runnable, final long j) {
        Thread thread = new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    Thread.sleep(j);
                    DispatchQueue.this.dispatchAsync(runnable);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                    Thread.currentThread().interrupt();
                }
            }
        }, "HS-cmdpq-trig");
        thread.start();
        this.afterThreads.add(thread);
    }

    public void join() {
        try {
            Iterator<Thread> it = this.afterThreads.iterator();
            while (it.hasNext()) {
                it.next().join();
            }
            Iterator<Future> it2 = this.tasks.iterator();
            while (it2.hasNext()) {
                it2.next().get();
            }
            this.tasks.clear();
        } catch (InterruptedException e) {
            e.printStackTrace();
            Thread.currentThread().interrupt();
        } catch (ExecutionException e2) {
            e2.printStackTrace();
        }
    }
}
