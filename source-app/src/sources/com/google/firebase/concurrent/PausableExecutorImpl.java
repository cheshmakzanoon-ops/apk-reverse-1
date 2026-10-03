package com.google.firebase.concurrent;

import java.util.concurrent.Executor;
import java.util.concurrent.LinkedBlockingQueue;

final class PausableExecutorImpl implements PausableExecutor {
    private final Executor delegate;
    private volatile boolean paused;
    final LinkedBlockingQueue<Runnable> queue = new LinkedBlockingQueue<>();

    PausableExecutorImpl(boolean z, Executor executor) {
        this.paused = z;
        this.delegate = executor;
    }

    @Override
    public void execute(Runnable runnable) {
        this.queue.offer(runnable);
        maybeEnqueueNext();
    }

    private void maybeEnqueueNext() {
        if (this.paused) {
            return;
        }
        Runnable runnablePoll = this.queue.poll();
        while (runnablePoll != null) {
            this.delegate.execute(runnablePoll);
            runnablePoll = !this.paused ? this.queue.poll() : null;
        }
    }

    @Override
    public void pause() {
        this.paused = true;
    }

    @Override
    public void resume() {
        this.paused = false;
        maybeEnqueueNext();
    }

    @Override
    public boolean isPaused() {
        return this.paused;
    }
}
