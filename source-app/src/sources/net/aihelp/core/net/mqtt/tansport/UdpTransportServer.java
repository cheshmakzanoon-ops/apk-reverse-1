package net.aihelp.core.net.mqtt.tansport;

import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.UnknownHostException;
import java.nio.channels.DatagramChannel;
import java.util.concurrent.Executor;
import net.aihelp.core.net.mqtt.hawtdispatch.DispatchQueue;
import net.aihelp.core.net.mqtt.hawtdispatch.Task;

public class UdpTransportServer extends ServiceBase implements TransportServer {
    private final InetSocketAddress bindAddress;
    private final String bindScheme;
    private Executor blockingExecutor;
    private DatagramChannel channel;
    private DispatchQueue dispatchQueue;
    private TransportServerListener listener;
    private UdpTransport transport;

    public UdpTransportServer(URI uri) throws UnknownHostException {
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
    protected void _start(Task task) {
        accept();
        if (task != null) {
            this.dispatchQueue.execute(task);
        }
    }

    public void queueAccept() {
        this.dispatchQueue.execute(new Task() {
            @Override
            public void run() {
                UdpTransportServer.this.accept();
            }
        });
    }

    public void accept() {
        if (getServiceState().isStarted() || getServiceState().isStarting()) {
            try {
                UdpTransport udpTransportCreateTransport = createTransport();
                this.transport = udpTransportCreateTransport;
                udpTransportCreateTransport.onDispose = new Task() {
                    @Override
                    public void run() {
                        UdpTransportServer.this.queueAccept();
                    }
                };
                DatagramChannel datagramChannelOpen = DatagramChannel.open();
                this.channel = datagramChannelOpen;
                datagramChannelOpen.socket().bind(this.bindAddress);
                this.transport.connected(this.channel);
                this.listener.onAccept(this.transport);
            } catch (Exception e) {
                this.listener.onAcceptError(e);
            }
        }
    }

    protected UdpTransport createTransport() {
        UdpTransport udpTransport = new UdpTransport();
        udpTransport.setBlockingExecutor(this.blockingExecutor);
        udpTransport.setDispatchQueue(this.dispatchQueue);
        return udpTransport;
    }

    @Override
    protected void _stop(Task task) {
        this.transport.stop(task);
    }

    @Override
    public void suspend() {
        this.dispatchQueue.suspend();
    }

    @Override
    public void resume() {
        this.dispatchQueue.resume();
    }

    @Override
    public String getBoundAddress() {
        try {
            return new URI(this.bindScheme, null, this.bindAddress.getAddress().getHostAddress(), this.channel.socket().getLocalPort(), null, null, null).toString();
        } catch (URISyntaxException e) {
            throw new RuntimeException(e);
        }
    }

    public String toString() {
        return getBoundAddress();
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
