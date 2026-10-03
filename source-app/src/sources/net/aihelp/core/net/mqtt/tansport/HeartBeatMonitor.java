package net.aihelp.core.net.mqtt.tansport;

import java.util.concurrent.TimeUnit;
import net.aihelp.core.net.mqtt.hawtdispatch.Dispatch;
import net.aihelp.core.net.mqtt.hawtdispatch.Task;

public class HeartBeatMonitor {
    long initialReadCheckDelay;
    long initialWriteCheckDelay;
    long readInterval;
    short readSuspendCount;
    boolean readSuspendedInterval;
    Transport transport;
    long writeInterval;
    Task onKeepAlive = Dispatch.NOOP;
    Task onDead = Dispatch.NOOP;
    volatile short session = 0;
    Object lock = new Object();

    public void suspendRead() {
        this.readSuspendCount = (short) (this.readSuspendCount + 1);
        this.readSuspendedInterval = true;
    }

    public void resumeRead() {
        this.readSuspendCount = (short) (this.readSuspendCount - 1);
    }

    private void schedule(final short s, long j, final Task task) {
        if (this.session == s) {
            this.transport.getDispatchQueue().executeAfter(j, TimeUnit.MILLISECONDS, new Task() {
                @Override
                public void run() {
                    synchronized (HeartBeatMonitor.this.lock) {
                        if (HeartBeatMonitor.this.session == s) {
                            task.run();
                        }
                    }
                }
            });
        }
    }

    public void scheduleCheckWrites(final short s) {
        Task task;
        final ProtocolCodec protocolCodec = this.transport.getProtocolCodec();
        if (protocolCodec == null) {
            task = new Task() {
                @Override
                public void run() {
                    HeartBeatMonitor.this.scheduleCheckWrites(s);
                }
            };
        } else {
            final long writeCounter = protocolCodec.getWriteCounter();
            task = new Task() {
                @Override
                public void run() {
                    if (writeCounter == protocolCodec.getWriteCounter()) {
                        HeartBeatMonitor.this.onKeepAlive.run();
                    }
                    HeartBeatMonitor.this.scheduleCheckWrites(s);
                }
            };
        }
        schedule(s, this.writeInterval, task);
    }

    public void scheduleCheckReads(final short s) {
        Task task;
        final ProtocolCodec protocolCodec = this.transport.getProtocolCodec();
        if (protocolCodec == null) {
            task = new Task() {
                @Override
                public void run() {
                    HeartBeatMonitor.this.scheduleCheckReads(s);
                }
            };
        } else {
            final long readCounter = protocolCodec.getReadCounter();
            task = new Task() {
                @Override
                public void run() {
                    if (readCounter == protocolCodec.getReadCounter() && !HeartBeatMonitor.this.readSuspendedInterval && HeartBeatMonitor.this.readSuspendCount == 0) {
                        HeartBeatMonitor.this.onDead.run();
                    }
                    HeartBeatMonitor.this.readSuspendedInterval = false;
                    HeartBeatMonitor.this.scheduleCheckReads(s);
                }
            };
        }
        schedule(s, this.readInterval, task);
    }

    public void start() {
        this.session = (short) (this.session + 1);
        this.readSuspendedInterval = false;
        if (this.writeInterval != 0) {
            if (this.initialWriteCheckDelay != 0) {
                this.transport.getDispatchQueue().executeAfter(this.initialWriteCheckDelay, TimeUnit.MILLISECONDS, new Task() {
                    @Override
                    public void run() {
                        HeartBeatMonitor heartBeatMonitor = HeartBeatMonitor.this;
                        heartBeatMonitor.scheduleCheckWrites(heartBeatMonitor.session);
                    }
                });
            } else {
                scheduleCheckWrites(this.session);
            }
        }
        if (this.readInterval != 0) {
            if (this.initialReadCheckDelay != 0) {
                this.transport.getDispatchQueue().executeAfter(this.initialReadCheckDelay, TimeUnit.MILLISECONDS, new Task() {
                    @Override
                    public void run() {
                        HeartBeatMonitor heartBeatMonitor = HeartBeatMonitor.this;
                        heartBeatMonitor.scheduleCheckReads(heartBeatMonitor.session);
                    }
                });
            } else {
                scheduleCheckReads(this.session);
            }
        }
    }

    public void stop() {
        synchronized (this.lock) {
            this.session = (short) (this.session + 1);
        }
    }

    public long getInitialReadCheckDelay() {
        return this.initialReadCheckDelay;
    }

    public void setInitialReadCheckDelay(long j) {
        this.initialReadCheckDelay = j;
    }

    public long getInitialWriteCheckDelay() {
        return this.initialWriteCheckDelay;
    }

    public void setInitialWriteCheckDelay(long j) {
        this.initialWriteCheckDelay = j;
    }

    public Task getOnDead() {
        return this.onDead;
    }

    public void setOnDead(Task task) {
        this.onDead = task;
    }

    public Task getOnKeepAlive() {
        return this.onKeepAlive;
    }

    public void setOnKeepAlive(Task task) {
        this.onKeepAlive = task;
    }

    public long getWriteInterval() {
        return this.writeInterval;
    }

    public void setWriteInterval(long j) {
        this.writeInterval = j;
    }

    public Transport getTransport() {
        return this.transport;
    }

    public void setTransport(Transport transport) {
        this.transport = transport;
    }

    public long getReadInterval() {
        return this.readInterval;
    }

    public void setReadInterval(long j) {
        this.readInterval = j;
    }
}
