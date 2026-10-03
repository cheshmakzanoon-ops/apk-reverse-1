package net.aihelp.core.net.mqtt.tansport;

import java.net.SocketAddress;
import java.nio.channels.ReadableByteChannel;
import java.nio.channels.WritableByteChannel;
import java.util.concurrent.Executor;
import net.aihelp.core.net.mqtt.hawtdispatch.DispatchQueue;
import net.aihelp.core.net.mqtt.hawtdispatch.Task;

public class TransportFilter implements Transport {
    final Transport next;

    public TransportFilter(Transport transport) {
        this.next = transport;
    }

    @Override
    public void flush() {
        this.next.flush();
    }

    @Override
    public boolean full() {
        return this.next.full();
    }

    @Override
    public Executor getBlockingExecutor() {
        return this.next.getBlockingExecutor();
    }

    @Override
    public DispatchQueue getDispatchQueue() {
        return this.next.getDispatchQueue();
    }

    @Override
    public SocketAddress getLocalAddress() {
        return this.next.getLocalAddress();
    }

    @Override
    public ProtocolCodec getProtocolCodec() {
        return this.next.getProtocolCodec();
    }

    @Override
    public ReadableByteChannel getReadChannel() {
        return this.next.getReadChannel();
    }

    @Override
    public SocketAddress getRemoteAddress() {
        return this.next.getRemoteAddress();
    }

    @Override
    public TransportListener getTransportListener() {
        return this.next.getTransportListener();
    }

    @Override
    public WritableByteChannel getWriteChannel() {
        return this.next.getWriteChannel();
    }

    @Override
    public boolean isClosed() {
        return this.next.isClosed();
    }

    @Override
    public boolean isConnected() {
        return this.next.isConnected();
    }

    @Override
    public boolean offer(Object obj) {
        return this.next.offer(obj);
    }

    @Override
    public void resumeRead() {
        this.next.resumeRead();
    }

    @Override
    public void setBlockingExecutor(Executor executor) {
        this.next.setBlockingExecutor(executor);
    }

    @Override
    public void setDispatchQueue(DispatchQueue dispatchQueue) {
        this.next.setDispatchQueue(dispatchQueue);
    }

    @Override
    public void setProtocolCodec(ProtocolCodec protocolCodec) throws Exception {
        this.next.setProtocolCodec(protocolCodec);
    }

    @Override
    public void setTransportListener(TransportListener transportListener) {
        this.next.setTransportListener(transportListener);
    }

    @Override
    public void start(Runnable runnable) {
        this.next.start(runnable);
    }

    @Override
    public void start(Task task) {
        this.next.start(task);
    }

    @Override
    public void stop(Runnable runnable) {
        this.next.stop(runnable);
    }

    @Override
    public void stop(Task task) {
        this.next.stop(task);
    }

    @Override
    public void suspendRead() {
        this.next.suspendRead();
    }

    @Override
    public void drainInbound() {
        this.next.drainInbound();
    }
}
