package net.aihelp.core.net.mqtt.tansport;

import java.net.SocketAddress;
import java.util.concurrent.Executor;
import net.aihelp.core.net.mqtt.hawtdispatch.DispatchQueue;
import net.aihelp.core.net.mqtt.hawtdispatch.Task;

public interface TransportServer {
    Executor getBlockingExecutor();

    String getBoundAddress();

    DispatchQueue getDispatchQueue();

    SocketAddress getSocketAddress();

    void resume();

    void setBlockingExecutor(Executor executor);

    void setDispatchQueue(DispatchQueue dispatchQueue);

    void setTransportServerListener(TransportServerListener transportServerListener);

    void start(Runnable runnable) throws Exception;

    void start(Task task) throws Exception;

    void stop(Runnable runnable) throws Exception;

    void stop(Task task) throws Exception;

    void suspend();
}
