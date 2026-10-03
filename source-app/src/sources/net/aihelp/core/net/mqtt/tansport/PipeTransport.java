package net.aihelp.core.net.mqtt.tansport;

import java.io.EOFException;
import java.io.IOException;
import java.net.SocketAddress;
import java.nio.channels.ReadableByteChannel;
import java.nio.channels.WritableByteChannel;
import java.util.LinkedList;
import java.util.concurrent.Executor;
import java.util.concurrent.atomic.AtomicBoolean;
import net.aihelp.core.net.mqtt.hawtdispatch.CustomDispatchSource;
import net.aihelp.core.net.mqtt.hawtdispatch.Dispatch;
import net.aihelp.core.net.mqtt.hawtdispatch.DispatchQueue;
import net.aihelp.core.net.mqtt.hawtdispatch.EventAggregators;
import net.aihelp.core.net.mqtt.hawtdispatch.Retained;
import net.aihelp.core.net.mqtt.hawtdispatch.Task;
import net.aihelp.core.net.mqtt.hawtdispatch.TaskWrapper;

public class PipeTransport implements Transport {
    private static final Object EOF_TOKEN = new Object();
    private boolean connected;
    private DispatchQueue dispatchQueue;
    private CustomDispatchSource<Object, LinkedList<Object>> dispatchSource;
    private TransportListener listener;
    private boolean marshal;
    private String name;
    PipeTransport peer;
    private ProtocolCodec protocolCodec;
    private SocketAddress remoteAddress;
    private final PipeTransportServer server;
    private boolean trace;
    private AtomicBoolean stopping = new AtomicBoolean();
    private long writeCounter = 0;
    private long readCounter = 0;
    int outbound = 0;
    int maxOutbound = 100;

    @Override
    public Executor getBlockingExecutor() {
        return null;
    }

    @Override
    public ReadableByteChannel getReadChannel() {
        return null;
    }

    @Override
    public WritableByteChannel getWriteChannel() {
        return null;
    }

    @Override
    public boolean isClosed() {
        return false;
    }

    @Override
    public void setBlockingExecutor(Executor executor) {
    }

    static long access$308(PipeTransport pipeTransport) {
        long j = pipeTransport.readCounter;
        pipeTransport.readCounter = 1 + j;
        return j;
    }

    public PipeTransport(PipeTransportServer pipeTransportServer) {
        this.server = pipeTransportServer;
    }

    @Override
    public DispatchQueue getDispatchQueue() {
        return this.dispatchQueue;
    }

    @Override
    public void setDispatchQueue(DispatchQueue dispatchQueue) {
        this.dispatchQueue = dispatchQueue;
    }

    @Override
    @Deprecated
    public void start(Runnable runnable) {
        start((Task) new TaskWrapper(runnable));
    }

    @Override
    public void start(Task task) {
        if (this.dispatchQueue == null) {
            throw new IllegalArgumentException("dispatchQueue is not set");
        }
        this.server.dispatchQueue.execute((Task) new C05301(task));
    }

    class C05301 extends Task {
        final Task val$onCompleted;

        C05301(Task task) {
            this.val$onCompleted = task;
        }

        @Override
        public void run() {
            PipeTransport.this.dispatchSource = Dispatch.createSource(EventAggregators.linkedList(), PipeTransport.this.dispatchQueue);
            PipeTransport.this.dispatchSource.setEventHandler(new Task() {
                @Override
                public void run() {
                    try {
                        final LinkedList linkedList = (LinkedList) PipeTransport.this.dispatchSource.getData();
                        for (Object obj : linkedList) {
                            if (obj == PipeTransport.EOF_TOKEN) {
                                throw new EOFException();
                            }
                            PipeTransport.access$308(PipeTransport.this);
                            PipeTransport.this.listener.onTransportCommand(obj);
                        }
                        PipeTransport.this.peer.dispatchQueue.execute(new Task() {
                            @Override
                            public void run() {
                                PipeTransport.this.outbound -= linkedList.size();
                                PipeTransport.this.drainInbound();
                            }
                        });
                    } catch (IOException e) {
                        PipeTransport.this.listener.onTransportFailure(e);
                    }
                }
            });
            if (PipeTransport.this.peer.dispatchSource != null) {
                PipeTransport.this.fireConnected();
                PipeTransport.this.peer.fireConnected();
            }
            Task task = this.val$onCompleted;
            if (task != null) {
                task.run();
            }
        }
    }

    public void fireConnected() {
        this.dispatchQueue.execute(new Task() {
            @Override
            public void run() {
                PipeTransport.this.connected = true;
                PipeTransport.this.dispatchSource.resume();
                PipeTransport.this.listener.onTransportConnected();
                PipeTransport.this.drainInbound();
            }
        });
    }

    @Override
    public void flush() {
        this.listener.onRefill();
    }

    @Override
    @Deprecated
    public void stop(Runnable runnable) {
        stop((Task) new TaskWrapper(runnable));
    }

    @Override
    public void stop(Task task) {
        if (this.connected) {
            this.peer.dispatchSource.merge(EOF_TOKEN);
        }
        CustomDispatchSource<Object, LinkedList<Object>> customDispatchSource = this.dispatchSource;
        if (customDispatchSource != null) {
            customDispatchSource.setCancelHandler(task);
            this.dispatchSource.cancel();
        }
        setDispatchQueue(null);
    }

    static final class OneWay {
        final Object command;
        final Retained retained;

        public OneWay(Object obj, Retained retained) {
            this.command = obj;
            this.retained = retained;
        }
    }

    @Override
    public boolean full() {
        return this.outbound >= this.maxOutbound;
    }

    @Override
    public boolean offer(Object obj) {
        if (!this.connected || full()) {
            return false;
        }
        transmit(obj);
        return true;
    }

    @Override
    public void drainInbound() {
        if (full()) {
            return;
        }
        this.listener.onRefill();
    }

    private void transmit(Object obj) {
        this.writeCounter++;
        this.outbound++;
        this.peer.dispatchSource.merge(obj);
    }

    public long getWriteCounter() {
        return this.writeCounter;
    }

    public long getReadCounter() {
        return this.readCounter;
    }

    @Override
    public SocketAddress getLocalAddress() {
        return this.remoteAddress;
    }

    @Override
    public SocketAddress getRemoteAddress() {
        return this.remoteAddress;
    }

    @Override
    public void suspendRead() {
        this.dispatchSource.suspend();
    }

    @Override
    public void resumeRead() {
        this.dispatchSource.resume();
    }

    public void setRemoteAddress(final String str) {
        this.remoteAddress = new SocketAddress() {
            public String toString() {
                return str;
            }
        };
        if (this.name == null) {
            this.name = str;
        }
    }

    public void setName(String str) {
        this.name = str;
    }

    @Override
    public TransportListener getTransportListener() {
        return this.listener;
    }

    @Override
    public void setTransportListener(TransportListener transportListener) {
        this.listener = transportListener;
    }

    @Override
    public ProtocolCodec getProtocolCodec() {
        return this.protocolCodec;
    }

    @Override
    public void setProtocolCodec(ProtocolCodec protocolCodec) {
        this.protocolCodec = protocolCodec;
    }

    public boolean isTrace() {
        return this.trace;
    }

    public void setTrace(boolean z) {
        this.trace = z;
    }

    public boolean isMarshal() {
        return this.marshal;
    }

    public void setMarshal(boolean z) {
        this.marshal = z;
    }

    @Override
    public boolean isConnected() {
        return !this.stopping.get();
    }
}
