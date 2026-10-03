package net.aihelp.core.net.mqtt.hawtdispatch.internal;

import java.util.concurrent.atomic.AtomicLong;
import net.aihelp.core.net.mqtt.hawtdispatch.DispatchQueue;
import net.aihelp.core.net.mqtt.hawtdispatch.Metrics;
import net.aihelp.core.net.mqtt.hawtdispatch.Task;

public final class ActiveMetricsCollector extends MetricsCollector {
    private final DispatchQueue queue;
    private final AtomicLong max_run_time = new AtomicLong();
    private final AtomicLong max_wait_time = new AtomicLong();
    private final AtomicLong enqueued = new AtomicLong();
    private final AtomicLong dequeued = new AtomicLong();
    private final AtomicLong total_run_time = new AtomicLong();
    private final AtomicLong total_wait_time = new AtomicLong();
    private final AtomicLong reset_at = new AtomicLong(System.nanoTime());

    public ActiveMetricsCollector(DispatchQueue dispatchQueue) {
        this.queue = dispatchQueue;
    }

    public void setMax(AtomicLong atomicLong, long j) {
        long j2;
        do {
            j2 = atomicLong.get();
            if (j <= j2) {
                return;
            }
        } while (!atomicLong.compareAndSet(j2, j));
    }

    @Override
    public Task track(final Task task) {
        this.enqueued.incrementAndGet();
        final long jNanoTime = System.nanoTime();
        return new Task() {
            @Override
            public void run() {
                long jNanoTime2 = System.nanoTime();
                long j = jNanoTime2 - jNanoTime;
                ActiveMetricsCollector.this.total_wait_time.addAndGet(j);
                ActiveMetricsCollector activeMetricsCollector = ActiveMetricsCollector.this;
                activeMetricsCollector.setMax(activeMetricsCollector.max_wait_time, j);
                ActiveMetricsCollector.this.dequeued.incrementAndGet();
                try {
                    task.run();
                } finally {
                    long jNanoTime3 = System.nanoTime() - jNanoTime2;
                    ActiveMetricsCollector.this.total_run_time.addAndGet(jNanoTime3);
                    ActiveMetricsCollector activeMetricsCollector2 = ActiveMetricsCollector.this;
                    activeMetricsCollector2.setMax(activeMetricsCollector2.max_run_time, jNanoTime3);
                }
            }
        };
    }

    @Override
    public Metrics metrics() {
        long jNanoTime = System.nanoTime();
        long andSet = this.reset_at.getAndSet(jNanoTime);
        long andSet2 = this.enqueued.getAndSet(0L);
        long andSet3 = this.dequeued.getAndSet(0L);
        if (andSet2 == 0 && andSet3 == 0) {
            return null;
        }
        Metrics metrics = new Metrics();
        metrics.durationNS = jNanoTime - andSet;
        metrics.queue = this.queue;
        metrics.enqueued = andSet2;
        metrics.dequeued = andSet3;
        metrics.maxWaitTimeNS = this.max_wait_time.getAndSet(0L);
        metrics.maxRunTimeNS = this.max_run_time.getAndSet(0L);
        metrics.totalRunTimeNS = this.total_run_time.getAndSet(0L);
        metrics.totalWaitTimeNS = this.total_wait_time.getAndSet(0L);
        return metrics;
    }
}
