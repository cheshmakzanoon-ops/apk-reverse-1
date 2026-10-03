package net.aihelp.core.net.mqtt.tansport;

import java.io.IOException;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.SocketAddress;
import java.net.SocketException;
import java.net.URI;
import java.net.UnknownHostException;
import java.nio.channels.DatagramChannel;
import java.nio.channels.ReadableByteChannel;
import java.nio.channels.WritableByteChannel;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.concurrent.Executor;
import net.aihelp.core.net.mqtt.hawtdispatch.CustomDispatchSource;
import net.aihelp.core.net.mqtt.hawtdispatch.Dispatch;
import net.aihelp.core.net.mqtt.hawtdispatch.DispatchQueue;
import net.aihelp.core.net.mqtt.hawtdispatch.DispatchSource;
import net.aihelp.core.net.mqtt.hawtdispatch.EventAggregators;
import net.aihelp.core.net.mqtt.hawtdispatch.Retained;
import net.aihelp.core.net.mqtt.hawtdispatch.Task;

public class UdpTransport extends ServiceBase implements Transport {
    public static final SocketAddress ANY_ADDRESS = new SocketAddress() {
        public String toString() {
            return "*:*";
        }
    };
    public static final int IPTOS_LOWCOST = 2;
    public static final int IPTOS_LOWDELAY = 16;
    public static final int IPTOS_RELIABILITY = 4;
    public static final int IPTOS_THROUGHPUT = 8;
    Executor blockingExecutor;
    protected DatagramChannel channel;
    protected ProtocolCodec codec;
    protected DispatchQueue dispatchQueue;
    protected CustomDispatchSource<Integer, Integer> drainOutboundSource;
    protected TransportListener listener;
    SocketAddress localAddress;
    protected URI localLocation;
    Task onDispose;
    private DispatchSource readSource;
    boolean rejectingOffers;
    protected URI remoteLocation;
    private DispatchSource writeSource;
    protected CustomDispatchSource<Integer, Integer> yieldSource;
    protected SocketState socketState = new DISCONNECTED();
    protected boolean useLocalHost = true;
    int receiveBufferSize = 65536;
    int sendBufferSize = 65536;
    int trafficClass = 8;
    SocketAddress remoteAddress = ANY_ADDRESS;
    private final Task CANCEL_HANDLER = new Task() {
        @Override
        public void run() {
            UdpTransport.this.socketState.onCanceled();
        }
    };
    boolean writeResumedForCodecFlush = false;

    public void trace(String str) {
    }

    protected boolean transportFlush() throws IOException {
        return true;
    }

    static abstract class SocketState {
        void onCanceled() {
        }

        void onStop(Task task) {
        }

        SocketState() {
        }

        boolean m133is(Class<? extends SocketState> cls) {
            return getClass() == cls;
        }
    }

    static class DISCONNECTED extends SocketState {
        DISCONNECTED() {
        }
    }

    class CONNECTING extends SocketState {
        CONNECTING() {
        }

        @Override
        void onStop(Task task) {
            UdpTransport.this.trace("CONNECTING.onStop");
            CANCELING canceling = UdpTransport.this.new CANCELING();
            UdpTransport.this.socketState = canceling;
            canceling.onStop(task);
        }

        @Override
        void onCanceled() {
            UdpTransport.this.trace("CONNECTING.onCanceled");
            CANCELING canceling = UdpTransport.this.new CANCELING();
            UdpTransport.this.socketState = canceling;
            canceling.onCanceled();
        }
    }

    class CONNECTED extends SocketState {
        public CONNECTED() {
            UdpTransport.this.localAddress = UdpTransport.this.channel.socket().getLocalSocketAddress();
            UdpTransport.this.remoteAddress = UdpTransport.this.channel.socket().getRemoteSocketAddress();
            if (UdpTransport.this.remoteAddress == null) {
                UdpTransport.this.remoteAddress = UdpTransport.ANY_ADDRESS;
            }
        }

        @Override
        void onStop(Task task) {
            UdpTransport.this.trace("CONNECTED.onStop");
            CANCELING canceling = UdpTransport.this.new CANCELING();
            UdpTransport.this.socketState = canceling;
            canceling.add(createDisconnectTask());
            canceling.onStop(task);
        }

        @Override
        void onCanceled() {
            UdpTransport.this.trace("CONNECTED.onCanceled");
            CANCELING canceling = UdpTransport.this.new CANCELING();
            UdpTransport.this.socketState = canceling;
            canceling.add(createDisconnectTask());
            canceling.onCanceled();
        }

        Task createDisconnectTask() {
            return new Task() {
                @Override
                public void run() {
                    UdpTransport.this.listener.onTransportDisconnected();
                }
            };
        }
    }

    class CANCELING extends SocketState {
        private boolean dispose;
        private int remaining;
        private LinkedList<Task> runnables = new LinkedList<>();

        public CANCELING() {
            if (UdpTransport.this.readSource != null) {
                this.remaining++;
                UdpTransport.this.readSource.cancel();
            }
            if (UdpTransport.this.writeSource != null) {
                this.remaining++;
                UdpTransport.this.writeSource.cancel();
            }
        }

        @Override
        void onStop(Task task) {
            UdpTransport.this.trace("CANCELING.onCompleted");
            add(task);
            this.dispose = true;
        }

        void add(Task task) {
            if (task != null) {
                this.runnables.add(task);
            }
        }

        @Override
        void onCanceled() {
            UdpTransport.this.trace("CANCELING.onCanceled");
            int i = this.remaining - 1;
            this.remaining = i;
            if (i != 0) {
                return;
            }
            try {
                UdpTransport.this.channel.close();
            } catch (IOException unused) {
            }
            UdpTransport.this.socketState = UdpTransport.this.new CANCELED(this.dispose);
            Iterator<Task> it = this.runnables.iterator();
            while (it.hasNext()) {
                it.next().run();
            }
            if (this.dispose) {
                UdpTransport.this.dispose();
            }
        }
    }

    class CANCELED extends SocketState {
        private boolean disposed;

        public CANCELED(boolean z) {
            this.disposed = z;
        }

        @Override
        void onStop(Task task) {
            UdpTransport.this.trace("CANCELED.onStop");
            if (!this.disposed) {
                this.disposed = true;
                UdpTransport.this.dispose();
            }
            task.run();
        }
    }

    static final class OneWay {
        final Object command;
        final Retained retained;

        public OneWay(Object obj, Retained retained) {
            this.command = obj;
            this.retained = retained;
        }
    }

    public void connected(DatagramChannel datagramChannel) throws Exception {
        this.channel = datagramChannel;
        initializeChannel();
        this.socketState = new CONNECTED();
    }

    protected void initializeChannel() throws Exception {
        this.channel.configureBlocking(false);
        DatagramSocket datagramSocketSocket = this.channel.socket();
        try {
            datagramSocketSocket.setReuseAddress(true);
        } catch (SocketException unused) {
        }
        try {
            datagramSocketSocket.setTrafficClass(this.trafficClass);
        } catch (SocketException unused2) {
        }
        try {
            datagramSocketSocket.setReceiveBufferSize(this.receiveBufferSize);
        } catch (SocketException unused3) {
        }
        try {
            datagramSocketSocket.setSendBufferSize(this.sendBufferSize);
        } catch (SocketException unused4) {
        }
        if (this.channel == null || this.codec == null) {
            return;
        }
        initializeCodec();
    }

    protected void initializeCodec() throws Exception {
        this.codec.setTransport(this);
    }

    public void connecting(URI uri, URI uri2) throws Exception {
        this.channel = DatagramChannel.open();
        initializeChannel();
        this.remoteLocation = uri;
        this.localLocation = uri2;
        this.socketState = new CONNECTING();
    }

    @Override
    public DispatchQueue getDispatchQueue() {
        return this.dispatchQueue;
    }

    @Override
    public void setDispatchQueue(DispatchQueue dispatchQueue) {
        this.dispatchQueue = dispatchQueue;
        DispatchSource dispatchSource = this.readSource;
        if (dispatchSource != null) {
            dispatchSource.setTargetQueue(dispatchQueue);
        }
        DispatchSource dispatchSource2 = this.writeSource;
        if (dispatchSource2 != null) {
            dispatchSource2.setTargetQueue(dispatchQueue);
        }
        CustomDispatchSource<Integer, Integer> customDispatchSource = this.drainOutboundSource;
        if (customDispatchSource != null) {
            customDispatchSource.setTargetQueue(dispatchQueue);
        }
        CustomDispatchSource<Integer, Integer> customDispatchSource2 = this.yieldSource;
        if (customDispatchSource2 != null) {
            customDispatchSource2.setTargetQueue(dispatchQueue);
        }
    }

    @Override
    public void _start(Task task) {
        try {
            if (this.socketState.m133is(CONNECTING.class)) {
                this.blockingExecutor.execute(new Runnable() {
                    @Override
                    public void run() {
                        if (UdpTransport.this.socketState.m133is(CONNECTING.class)) {
                            try {
                                final InetSocketAddress inetSocketAddress = UdpTransport.this.localLocation != null ? new InetSocketAddress(InetAddress.getByName(UdpTransport.this.localLocation.getHost()), UdpTransport.this.localLocation.getPort()) : null;
                                UdpTransport udpTransport = UdpTransport.this;
                                final InetSocketAddress inetSocketAddress2 = new InetSocketAddress(udpTransport.resolveHostName(udpTransport.remoteLocation.getHost()), UdpTransport.this.remoteLocation.getPort());
                                UdpTransport.this.dispatchQueue.execute(new Task() {
                                    @Override
                                    public void run() {
                                        try {
                                            if (inetSocketAddress != null) {
                                                UdpTransport.this.channel.socket().bind(inetSocketAddress);
                                            }
                                            UdpTransport.this.channel.connect(inetSocketAddress2);
                                        } catch (IOException e) {
                                            try {
                                                UdpTransport.this.channel.close();
                                            } catch (IOException unused) {
                                            }
                                            UdpTransport.this.socketState = UdpTransport.this.new CANCELED(true);
                                            UdpTransport.this.listener.onTransportFailure(e);
                                        }
                                    }
                                });
                            } catch (IOException e) {
                                try {
                                    UdpTransport.this.channel.close();
                                } catch (IOException unused) {
                                }
                                UdpTransport.this.socketState = UdpTransport.this.new CANCELED(true);
                                UdpTransport.this.listener.onTransportFailure(e);
                            }
                        }
                    }
                });
            } else if (this.socketState.m133is(CONNECTED.class)) {
                this.dispatchQueue.execute(new Task() {
                    @Override
                    public void run() {
                        try {
                            UdpTransport.this.trace("was connected.");
                            UdpTransport.this.onConnected();
                        } catch (IOException e) {
                            UdpTransport.this.onTransportFailure(e);
                        }
                    }
                });
            } else {
                System.err.println("cannot be started.  socket state is: " + this.socketState);
            }
        } finally {
            if (task != null) {
                task.run();
            }
        }
    }

    @Override
    public void _stop(Task task) {
        trace("stopping.. at state: " + this.socketState);
        this.socketState.onStop(task);
    }

    protected String resolveHostName(String str) throws UnknownHostException {
        String hostName = InetAddress.getLocalHost().getHostName();
        return (hostName != null && isUseLocalHost() && hostName.equals(str)) ? "localhost" : str;
    }

    protected void onConnected() throws IOException {
        CustomDispatchSource<Integer, Integer> customDispatchSourceCreateSource = Dispatch.createSource(EventAggregators.INTEGER_ADD, this.dispatchQueue);
        this.yieldSource = customDispatchSourceCreateSource;
        customDispatchSourceCreateSource.setEventHandler(new Task() {
            @Override
            public void run() {
                UdpTransport.this.drainInbound();
            }
        });
        this.yieldSource.resume();
        CustomDispatchSource<Integer, Integer> customDispatchSourceCreateSource2 = Dispatch.createSource(EventAggregators.INTEGER_ADD, this.dispatchQueue);
        this.drainOutboundSource = customDispatchSourceCreateSource2;
        customDispatchSourceCreateSource2.setEventHandler(new Task() {
            @Override
            public void run() {
                UdpTransport.this.flush();
            }
        });
        this.drainOutboundSource.resume();
        this.readSource = Dispatch.createSource(this.channel, 1, this.dispatchQueue);
        this.writeSource = Dispatch.createSource(this.channel, 4, this.dispatchQueue);
        this.readSource.setCancelHandler(this.CANCEL_HANDLER);
        this.writeSource.setCancelHandler(this.CANCEL_HANDLER);
        this.readSource.setEventHandler(new Task() {
            @Override
            public void run() {
                UdpTransport.this.drainInbound();
            }
        });
        this.writeSource.setEventHandler(new Task() {
            @Override
            public void run() {
                UdpTransport.this.flush();
            }
        });
        this.listener.onTransportConnected();
    }

    public void dispose() {
        DispatchSource dispatchSource = this.readSource;
        if (dispatchSource != null) {
            dispatchSource.cancel();
            this.readSource = null;
        }
        DispatchSource dispatchSource2 = this.writeSource;
        if (dispatchSource2 != null) {
            dispatchSource2.cancel();
            this.writeSource = null;
        }
        this.codec = null;
        Task task = this.onDispose;
        if (task != null) {
            task.run();
            this.onDispose = null;
        }
    }

    public void onTransportFailure(IOException iOException) {
        this.listener.onTransportFailure(iOException);
        this.socketState.onCanceled();
    }

    @Override
    public boolean full() {
        ProtocolCodec protocolCodec = this.codec;
        return protocolCodec == null || protocolCodec.full();
    }

    @Override
    public boolean offer(Object obj) {
        try {
            if (!this.socketState.m133is(CONNECTED.class)) {
                throw new IOException("Not connected.");
            }
            if (getServiceState() != STARTED) {
                throw new IOException("Not running.");
            }
            ProtocolCodec.BufferState bufferStateWrite = this.codec.write(obj);
            this.rejectingOffers = this.codec.full();
            if (C055610.f75x1105eea2[bufferStateWrite.ordinal()] == 1) {
                return false;
            }
            this.drainOutboundSource.merge(1);
            return true;
        } catch (IOException e) {
            onTransportFailure(e);
            return false;
        }
    }

    static class C055610 {

        static final int[] f75x1105eea2;

        static {
            int[] iArr = new int[ProtocolCodec.BufferState.values().length];
            f75x1105eea2 = iArr;
            try {
                iArr[ProtocolCodec.BufferState.FULL.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
        }
    }

    @Override
    public void flush() {
        if (getServiceState() == STARTED && this.socketState.m133is(CONNECTED.class)) {
            try {
                if (this.codec.flush() == ProtocolCodec.BufferState.EMPTY && transportFlush()) {
                    if (this.writeResumedForCodecFlush) {
                        this.writeResumedForCodecFlush = false;
                        suspendWrite();
                    }
                    this.rejectingOffers = false;
                    this.listener.onRefill();
                    return;
                }
                if (this.writeResumedForCodecFlush) {
                    return;
                }
                this.writeResumedForCodecFlush = true;
                resumeWrite();
            } catch (IOException e) {
                onTransportFailure(e);
            }
        }
    }

    @Override
    public void drainInbound() {
        if (!getServiceState().isStarted() || this.readSource.isSuspended()) {
            return;
        }
        try {
            long readCounter = this.codec.getReadCounter();
            while (this.codec.getReadCounter() - readCounter < (this.codec.getReadBufferSize() << 2)) {
                Object obj = this.codec.read();
                if (obj == null) {
                    return;
                }
                try {
                    this.listener.onTransportCommand(obj);
                } catch (Throwable th) {
                    th.printStackTrace();
                    onTransportFailure(new IOException("Transport listener failure."));
                }
                if (getServiceState() == STOPPED || this.readSource.isSuspended()) {
                    return;
                }
            }
            this.yieldSource.merge(1);
        } catch (IOException e) {
            onTransportFailure(e);
        }
    }

    @Override
    public SocketAddress getLocalAddress() {
        return this.localAddress;
    }

    @Override
    public SocketAddress getRemoteAddress() {
        return this.remoteAddress;
    }

    private boolean assertConnected() {
        try {
            if (isConnected()) {
                return true;
            }
            throw new IOException("Not connected.");
        } catch (IOException e) {
            onTransportFailure(e);
            return false;
        }
    }

    @Override
    public void suspendRead() {
        DispatchSource dispatchSource;
        if (!isConnected() || (dispatchSource = this.readSource) == null) {
            return;
        }
        dispatchSource.suspend();
    }

    @Override
    public void resumeRead() {
        if (!isConnected() || this.readSource == null) {
            return;
        }
        _resumeRead();
    }

    private void _resumeRead() {
        this.readSource.resume();
        this.dispatchQueue.execute(new Task() {
            @Override
            public void run() {
                UdpTransport.this.drainInbound();
            }
        });
    }

    protected void suspendWrite() {
        DispatchSource dispatchSource;
        if (!isConnected() || (dispatchSource = this.writeSource) == null) {
            return;
        }
        dispatchSource.suspend();
    }

    protected void resumeWrite() {
        DispatchSource dispatchSource;
        if (!isConnected() || (dispatchSource = this.writeSource) == null) {
            return;
        }
        dispatchSource.resume();
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
        return this.codec;
    }

    @Override
    public void setProtocolCodec(ProtocolCodec protocolCodec) throws Exception {
        this.codec = protocolCodec;
        if (this.channel == null || protocolCodec == null) {
            return;
        }
        initializeCodec();
    }

    @Override
    public boolean isConnected() {
        return this.socketState.m133is(CONNECTED.class);
    }

    @Override
    public boolean isClosed() {
        return getServiceState() == STOPPED;
    }

    public boolean isUseLocalHost() {
        return this.useLocalHost;
    }

    public void setUseLocalHost(boolean z) {
        this.useLocalHost = z;
    }

    public DatagramChannel getDatagramChannel() {
        return this.channel;
    }

    @Override
    public ReadableByteChannel getReadChannel() {
        return this.channel;
    }

    @Override
    public WritableByteChannel getWriteChannel() {
        return this.channel;
    }

    public int getTrafficClass() {
        return this.trafficClass;
    }

    public void setTrafficClass(int i) {
        this.trafficClass = i;
    }

    public int getReceiveBufferSize() {
        return this.receiveBufferSize;
    }

    public void setReceiveBufferSize(int i) {
        this.receiveBufferSize = i;
    }

    public int getSendBufferSize() {
        return this.sendBufferSize;
    }

    public void setSendBufferSize(int i) {
        this.sendBufferSize = i;
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
