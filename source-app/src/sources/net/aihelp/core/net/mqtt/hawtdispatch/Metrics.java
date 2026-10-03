package net.aihelp.core.net.mqtt.hawtdispatch;

public class Metrics {
    public long dequeued;
    public long durationNS;
    public long enqueued;
    public long maxRunTimeNS;
    public long maxWaitTimeNS;
    public DispatchQueue queue;
    public long totalRunTimeNS;
    public long totalWaitTimeNS;

    public String toString() {
        return String.format("{ label:%s, enqueued:%d, dequeued:%d, max_wait_time:%.2f ms, max_run_time:%.2f ms, total_run_time:%.2f ms, total_wait_time:%.2f ms }", this.queue.getLabel(), Long.valueOf(this.enqueued), Long.valueOf(this.dequeued), Float.valueOf(this.maxWaitTimeNS / 1000000.0f), Float.valueOf(this.maxRunTimeNS / 1000000.0f), Float.valueOf(this.totalRunTimeNS / 1000000.0f), Float.valueOf(this.totalWaitTimeNS / 1000000.0f));
    }
}
