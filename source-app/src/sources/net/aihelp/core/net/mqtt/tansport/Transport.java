package net.aihelp.core.net.mqtt.tansport;

import java.net.SocketAddress;
import java.nio.channels.ReadableByteChannel;
import java.nio.channels.WritableByteChannel;
import java.util.concurrent.Executor;
import net.aihelp.core.net.mqtt.hawtdispatch.DispatchQueue;
import net.aihelp.core.net.mqtt.hawtdispatch.Task;

public interface Transport {
    void drainInbound();

    void flush();

    boolean full();

    Executor getBlockingExecutor();

    DispatchQueue getDispatchQueue();

    SocketAddress getLocalAddress();

    ProtocolCodec getProtocolCodec();

    ReadableByteChannel getReadChannel();

    SocketAddress getRemoteAddress();

    TransportListener getTransportListener();

    WritableByteChannel getWriteChannel();

    boolean isClosed();

    boolean isConnected();

    boolean offer(Object obj);

    void resumeRead();

    void setBlockingExecutor(Executor executor);

    void setDispatchQueue(DispatchQueue dispatchQueue);

    void setProtocolCodec(ProtocolCodec protocolCodec) throws Exception;

    void setTransportListener(TransportListener transportListener);

    void start(Runnable runnable);

    void start(Task task);

    void stop(Runnable runnable);

    void stop(Task task);

    void suspendRead();
}
