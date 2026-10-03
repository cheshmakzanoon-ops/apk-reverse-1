package net.aihelp.core.net.mqtt.tansport;

import java.io.IOException;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.SocketException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.UnknownHostException;
import java.nio.channels.ServerSocketChannel;
import java.nio.channels.SocketChannel;
import java.util.concurrent.Executor;
import net.aihelp.core.net.mqtt.hawtdispatch.Dispatch;
import net.aihelp.core.net.mqtt.hawtdispatch.DispatchQueue;
import net.aihelp.core.net.mqtt.hawtdispatch.DispatchSource;
import net.aihelp.core.net.mqtt.hawtdispatch.Task;
import net.aihelp.core.net.mqtt.hawtdispatch.TaskWrapper;

public class TcpTransportServer implements TransportServer {
    protected DispatchSource acceptSource;
    protected final InetSocketAddress bindAddress;
    protected final String bindScheme;
    protected Executor blockingExecutor;
    protected ServerSocketChannel channel;
    protected DispatchQueue dispatchQueue;
    protected TransportServerListener listener;
    protected int backlog = 100;
    protected int receiveBufferSize = 65536;
    protected int sendBufferSize = 65536;

    public TcpTransportServer(URI uri) throws UnknownHostException {
        this.bindScheme = uri.getScheme();
        String host = uri.getHost();
        this.bindAddress = new InetSocketAddress(InetAddress.getByName((host == null || host.length() == 0) ? "::" : host), uri.getPort());
    }

    @Override
    public void setTransportServerListener(TransportServerListener transportServerListener) {
        this.listener = transportServerListener;
    }

    @Override
    public InetSocketAddress getSocketAddress() {
        return (InetSocketAddress) this.channel.socket().getLocalSocketAddress();
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
    public void suspend() {
        this.acceptSource.suspend();
    }

    @Override
    public void resume() {
        this.acceptSource.resume();
    }

    @Override
    @Deprecated
    public void start(Runnable runnable) throws Exception {
        start((Task) new TaskWrapper(runnable));
    }

    @Override
    @Deprecated
    public void stop(Runnable runnable) throws Exception {
        stop((Task) new TaskWrapper(runnable));
    }

    @Override
    public void start(Task task) throws Exception {
        try {
            ServerSocketChannel serverSocketChannelOpen = ServerSocketChannel.open();
            this.channel = serverSocketChannelOpen;
            serverSocketChannelOpen.configureBlocking(false);
            try {
                this.channel.socket().setReceiveBufferSize(this.receiveBufferSize);
            } catch (SocketException unused) {
            }
            try {
                this.channel.socket().setReceiveBufferSize(this.sendBufferSize);
            } catch (SocketException unused2) {
            }
            this.channel.socket().bind(this.bindAddress, this.backlog);
            DispatchSource dispatchSourceCreateSource = Dispatch.createSource(this.channel, 16, this.dispatchQueue);
            this.acceptSource = dispatchSourceCreateSource;
            dispatchSourceCreateSource.setEventHandler(new Task() {
                @Override
                public void run() {
                    try {
                        SocketChannel socketChannelAccept = TcpTransportServer.this.channel.accept();
                        while (socketChannelAccept != null) {
                            TcpTransportServer.this.handleSocket(socketChannelAccept);
                            socketChannelAccept = TcpTransportServer.this.channel.accept();
                        }
                    } catch (Exception e) {
                        TcpTransportServer.this.listener.onAcceptError(e);
                    }
                }
            });
            this.acceptSource.setCancelHandler(new Task() {
                @Override
                public void run() {
                    try {
                        TcpTransportServer.this.channel.close();
                    } catch (IOException unused3) {
                    }
                }
            });
            this.acceptSource.resume();
            if (task != null) {
                this.dispatchQueue.execute(task);
            }
        } catch (IOException e) {
            throw new IOException("Failed to bind to server socket: " + this.bindAddress + " due to: " + e);
        }
    }

    @Override
    public String getBoundAddress() {
        try {
            return new URI(this.bindScheme, null, this.bindAddress.getAddress().getHostAddress(), this.channel.socket().getLocalPort(), null, null, null).toString();
        } catch (URISyntaxException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void stop(final Task task) throws Exception {
        if (this.acceptSource.isCanceled()) {
            task.run();
        } else {
            this.acceptSource.setCancelHandler(new Task() {
                @Override
                public void run() {
                    try {
                        TcpTransportServer.this.channel.close();
                    } catch (IOException unused) {
                    }
                    task.run();
                }
            });
            this.acceptSource.cancel();
        }
    }

    public int getBacklog() {
        return this.backlog;
    }

    public void setBacklog(int i) {
        this.backlog = i;
    }

    protected final void handleSocket(SocketChannel socketChannel) throws Exception {
        TcpTransport tcpTransportCreateTransport = createTransport();
        tcpTransportCreateTransport.connected(socketChannel);
        this.listener.onAccept(tcpTransportCreateTransport);
    }

    protected TcpTransport createTransport() {
        TcpTransport tcpTransport = new TcpTransport();
        tcpTransport.setBlockingExecutor(this.blockingExecutor);
        tcpTransport.setDispatchQueue(this.dispatchQueue);
        return tcpTransport;
    }

    public String toString() {
        return getBoundAddress();
    }

    public int getReceiveBufferSize() {
        return this.receiveBufferSize;
    }

    public void setReceiveBufferSize(int i) {
        this.receiveBufferSize = i;
        ServerSocketChannel serverSocketChannel = this.channel;
        if (serverSocketChannel != null) {
            try {
                serverSocketChannel.socket().setReceiveBufferSize(i);
            } catch (SocketException unused) {
            }
        }
    }

    public int getSendBufferSize() {
        return this.sendBufferSize;
    }

    public void setSendBufferSize(int i) {
        this.sendBufferSize = i;
        ServerSocketChannel serverSocketChannel = this.channel;
        if (serverSocketChannel != null) {
            try {
                serverSocketChannel.socket().setReceiveBufferSize(i);
            } catch (SocketException unused) {
            }
        }
    }

    @Override
    public Executor getBlockingExecutor() {
        return this.blockingExecutor;
    }

    @Override
    public void setBlockingExecutor(Executor executor) {
        this.blockingExecutor = executor;
    }
}
