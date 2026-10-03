package net.aihelp.core.net.mqtt.tansport;

import java.io.IOException;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.SocketAddress;
import java.net.SocketException;
import java.net.URI;
import java.net.UnknownHostException;
import java.nio.ByteBuffer;
import java.nio.channels.GatheringByteChannel;
import java.nio.channels.ReadableByteChannel;
import java.nio.channels.ScatteringByteChannel;
import java.nio.channels.SocketChannel;
import java.nio.channels.WritableByteChannel;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.concurrent.Executor;
import java.util.concurrent.TimeUnit;
import net.aihelp.core.net.mqtt.hawtdispatch.CustomDispatchSource;
import net.aihelp.core.net.mqtt.hawtdispatch.Dispatch;
import net.aihelp.core.net.mqtt.hawtdispatch.DispatchQueue;
import net.aihelp.core.net.mqtt.hawtdispatch.DispatchSource;
import net.aihelp.core.net.mqtt.hawtdispatch.EventAggregators;
import net.aihelp.core.net.mqtt.hawtdispatch.Retained;
import net.aihelp.core.net.mqtt.hawtdispatch.Task;

public class TcpTransport extends ServiceBase implements Transport {
    public static final int IPTOS_LOWCOST = 2;
    public static final int IPTOS_LOWDELAY = 16;
    public static final int IPTOS_RELIABILITY = 4;
    public static final int IPTOS_THROUGHPUT = 8;
    static InetAddress localhost;
    protected Executor blockingExecutor;
    protected SocketChannel channel;
    protected ProtocolCodec codec;
    protected DispatchQueue dispatchQueue;
    protected CustomDispatchSource<Integer, Integer> drainOutboundSource;
    protected TransportListener listener;
    SocketAddress localAddress;
    protected URI localLocation;
    int maxReadRate;
    int maxWriteRate;
    protected RateLimitingChannel rateLimitingChannel;
    private DispatchSource readSource;
    boolean rejectingOffers;
    SocketAddress remoteAddress;
    protected URI remoteLocation;
    private DispatchSource writeSource;
    protected CustomDispatchSource<Integer, Integer> yieldSource;
    protected SocketState socketState = new DISCONNECTED();
    protected boolean useLocalHost = true;
    int receiveBufferSize = 65536;
    int sendBufferSize = 65536;
    boolean closeOnCancel = true;
    boolean keepAlive = true;
    int trafficClass = 8;
    private final Task CANCEL_HANDLER = new Task() {
        @Override
        public void run() {
            TcpTransport.this.socketState.onCanceled();
        }
    };
    boolean writeResumedForCodecFlush = false;

    public void trace(String str) {
    }

    protected boolean transportFlush() throws IOException {
        return true;
    }

    public static synchronized InetAddress getLocalHost() throws UnknownHostException {
        if (localhost == null) {
            localhost = InetAddress.getLocalHost();
        }
        return localhost;
    }

    static abstract class SocketState {
        void onCanceled() {
        }

        void onStop(Task task) {
        }

        SocketState() {
        }

        boolean m132is(Class<? extends SocketState> cls) {
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
            TcpTransport.this.trace("CONNECTING.onStop");
            CANCELING canceling = TcpTransport.this.new CANCELING();
            TcpTransport.this.socketState = canceling;
            canceling.onStop(task);
        }

        @Override
        void onCanceled() {
            TcpTransport.this.trace("CONNECTING.onCanceled");
            CANCELING canceling = TcpTransport.this.new CANCELING();
            TcpTransport.this.socketState = canceling;
            canceling.onCanceled();
        }
    }

    class CONNECTED extends SocketState {
        public CONNECTED() {
            TcpTransport.this.localAddress = TcpTransport.this.channel.socket().getLocalSocketAddress();
            TcpTransport.this.remoteAddress = TcpTransport.this.channel.socket().getRemoteSocketAddress();
        }

        @Override
        void onStop(Task task) {
            TcpTransport.this.trace("CONNECTED.onStop");
            CANCELING canceling = TcpTransport.this.new CANCELING();
            TcpTransport.this.socketState = canceling;
            canceling.add(createDisconnectTask());
            canceling.onStop(task);
        }

        @Override
        void onCanceled() {
            TcpTransport.this.trace("CONNECTED.onCanceled");
            CANCELING canceling = TcpTransport.this.new CANCELING();
            TcpTransport.this.socketState = canceling;
            canceling.add(createDisconnectTask());
            canceling.onCanceled();
        }

        Task createDisconnectTask() {
            return new Task() {
                @Override
                public void run() {
                    TcpTransport.this.listener.onTransportDisconnected();
                }
            };
        }
    }

    class CANCELING extends SocketState {
        private boolean dispose;
        private int remaining;
        private LinkedList<Task> runnables = new LinkedList<>();

        public CANCELING() {
            if (TcpTransport.this.readSource != null) {
                this.remaining++;
                TcpTransport.this.readSource.cancel();
            }
            if (TcpTransport.this.writeSource != null) {
                this.remaining++;
                TcpTransport.this.writeSource.cancel();
            }
        }

        @Override
        void onStop(Task task) {
            TcpTransport.this.trace("CANCELING.onCompleted");
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
            TcpTransport.this.trace("CANCELING.onCanceled");
            int i = this.remaining - 1;
            this.remaining = i;
            if (i != 0) {
                return;
            }
            try {
                if (TcpTransport.this.closeOnCancel) {
                    TcpTransport.this.channel.close();
                }
            } catch (IOException unused) {
            }
            TcpTransport.this.socketState = TcpTransport.this.new CANCELED(this.dispose);
            Iterator<Task> it = this.runnables.iterator();
            while (it.hasNext()) {
                it.next().run();
            }
            if (this.dispose) {
                TcpTransport.this.dispose();
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
            TcpTransport.this.trace("CANCELED.onStop");
            if (!this.disposed) {
                this.disposed = true;
                TcpTransport.this.dispose();
            }
            task.run();
        }
    }

    class RateLimitingChannel implements ScatteringByteChannel, GatheringByteChannel {
        int read_allowance;
        int write_allowance;
        boolean read_suspended = false;
        boolean write_suspended = false;

        RateLimitingChannel() {
            this.read_allowance = TcpTransport.this.maxReadRate;
            this.write_allowance = TcpTransport.this.maxWriteRate;
        }

        public void resetAllowance() {
            if (this.read_allowance == TcpTransport.this.maxReadRate && this.write_allowance == TcpTransport.this.maxWriteRate) {
                return;
            }
            this.read_allowance = TcpTransport.this.maxReadRate;
            this.write_allowance = TcpTransport.this.maxWriteRate;
            if (this.write_suspended) {
                this.write_suspended = false;
                TcpTransport.this.resumeWrite();
            }
            if (this.read_suspended) {
                this.read_suspended = false;
                resumeRead();
            }
        }

        @Override
        public int read(ByteBuffer byteBuffer) throws IOException {
            if (TcpTransport.this.maxReadRate == 0) {
                return TcpTransport.this.channel.read(byteBuffer);
            }
            int i = 0;
            try {
                int iRemaining = byteBuffer.remaining();
                int i2 = this.read_allowance;
                if (i2 != 0 && iRemaining != 0) {
                    if (iRemaining > i2) {
                        i = iRemaining - i2;
                        byteBuffer.limit(byteBuffer.limit() - i);
                    }
                    int i3 = TcpTransport.this.channel.read(byteBuffer);
                    int i4 = this.read_allowance - i3;
                    this.read_allowance = i4;
                    if (i4 <= 0 && !this.read_suspended) {
                        TcpTransport.this.readSource.suspend();
                        this.read_suspended = true;
                    }
                    if (i != 0) {
                        byteBuffer.limit(byteBuffer.limit() + i);
                    }
                    return i3;
                }
                if (i2 <= 0 && !this.read_suspended) {
                    TcpTransport.this.readSource.suspend();
                    this.read_suspended = true;
                }
                return 0;
            } catch (Throwable th) {
                if (this.read_allowance <= 0 && !this.read_suspended) {
                    TcpTransport.this.readSource.suspend();
                    this.read_suspended = true;
                }
                if (i != 0) {
                    byteBuffer.limit(byteBuffer.limit() + i);
                }
                throw th;
            }
        }

        @Override
        public int write(ByteBuffer byteBuffer) throws IOException {
            if (TcpTransport.this.maxWriteRate == 0) {
                return TcpTransport.this.channel.write(byteBuffer);
            }
            int iRemaining = byteBuffer.remaining();
            int i = this.write_allowance;
            int i2 = 0;
            if (i == 0 || iRemaining == 0) {
                return 0;
            }
            if (iRemaining > i) {
                i2 = iRemaining - i;
                byteBuffer.limit(byteBuffer.limit() - i2);
            }
            try {
                int iWrite = TcpTransport.this.channel.write(byteBuffer);
                this.write_allowance -= iWrite;
                return iWrite;
            } finally {
                if (i2 != 0) {
                    if (byteBuffer.remaining() == 0) {
                        this.write_suspended = true;
                        TcpTransport.this.suspendWrite();
                    }
                    byteBuffer.limit(byteBuffer.limit() + i2);
                }
            }
        }

        @Override
        public boolean isOpen() {
            return TcpTransport.this.channel.isOpen();
        }

        @Override
        public void close() throws IOException {
            TcpTransport.this.channel.close();
        }

        public void resumeRead() {
            TcpTransport.this._resumeRead();
        }

        @Override
        public long read(ByteBuffer[] byteBufferArr, int i, int i2) throws IOException {
            if (i + i2 > byteBufferArr.length || i2 < 0 || i < 0) {
                throw new IndexOutOfBoundsException();
            }
            long j = 0;
            for (int i3 = 0; i3 < i2; i3++) {
                ByteBuffer byteBuffer = byteBufferArr[i + i3];
                if (byteBuffer.hasRemaining()) {
                    j += (long) read(byteBuffer);
                }
                if (byteBuffer.hasRemaining()) {
                    return j;
                }
            }
            return j;
        }

        @Override
        public long read(ByteBuffer[] byteBufferArr) throws IOException {
            return read(byteBufferArr, 0, byteBufferArr.length);
        }

        @Override
        public long write(ByteBuffer[] byteBufferArr, int i, int i2) throws IOException {
            if (i + i2 > byteBufferArr.length || i2 < 0 || i < 0) {
                throw new IndexOutOfBoundsException();
            }
            long jWrite = 0;
            for (int i3 = 0; i3 < i2; i3++) {
                ByteBuffer byteBuffer = byteBufferArr[i + i3];
                if (byteBuffer.hasRemaining()) {
                    jWrite += (long) write(byteBuffer);
                }
                if (byteBuffer.hasRemaining()) {
                    return jWrite;
                }
            }
            return jWrite;
        }

        @Override
        public long write(ByteBuffer[] byteBufferArr) throws IOException {
            return write(byteBufferArr, 0, byteBufferArr.length);
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

    public void connected(SocketChannel socketChannel) throws Exception {
        this.channel = socketChannel;
        initializeChannel();
        this.socketState = new CONNECTED();
    }

    protected void initializeChannel() throws Exception {
        this.channel.configureBlocking(false);
        Socket socket = this.channel.socket();
        try {
            socket.setReuseAddress(true);
        } catch (SocketException unused) {
        }
        try {
            socket.setSoLinger(true, 0);
        } catch (SocketException unused2) {
        }
        try {
            socket.setTrafficClass(this.trafficClass);
        } catch (SocketException unused3) {
        }
        try {
            socket.setKeepAlive(this.keepAlive);
        } catch (SocketException unused4) {
        }
        try {
            socket.setTcpNoDelay(true);
        } catch (SocketException unused5) {
        }
        try {
            socket.setReceiveBufferSize(this.receiveBufferSize);
        } catch (SocketException unused6) {
        }
        try {
            socket.setSendBufferSize(this.sendBufferSize);
        } catch (SocketException unused7) {
        }
        if (this.channel == null || this.codec == null) {
            return;
        }
        initializeCodec();
    }

    protected void initializeCodec() throws Exception {
        this.codec.setTransport(this);
    }

    private void initRateLimitingChannel() {
        if (!(this.maxReadRate == 0 && this.maxWriteRate == 0) && this.rateLimitingChannel == null) {
            this.rateLimitingChannel = new RateLimitingChannel();
        }
    }

    public void connecting(URI uri, URI uri2) throws Exception {
        this.channel = SocketChannel.open();
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
            if (this.socketState.m132is(CONNECTING.class)) {
                this.blockingExecutor.execute(new RunnableC05432());
            } else if (this.socketState.m132is(CONNECTED.class)) {
                this.dispatchQueue.execute(new Task() {
                    @Override
                    public void run() {
                        try {
                            TcpTransport.this.trace("was connected.");
                            TcpTransport.this.onConnected();
                        } catch (IOException e) {
                            TcpTransport.this.onTransportFailure(e);
                        }
                    }
                });
            } else {
                trace("cannot be started.  socket state is: " + this.socketState);
            }
        } finally {
            if (task != null) {
                task.run();
            }
        }
    }

    class RunnableC05432 implements Runnable {
        RunnableC05432() {
        }

        @Override
        public void run() {
            try {
                final InetSocketAddress inetSocketAddress = TcpTransport.this.localLocation != null ? new InetSocketAddress(InetAddress.getByName(TcpTransport.this.localLocation.getHost()), TcpTransport.this.localLocation.getPort()) : null;
                TcpTransport tcpTransport = TcpTransport.this;
                final InetSocketAddress inetSocketAddress2 = new InetSocketAddress(tcpTransport.resolveHostName(tcpTransport.remoteLocation.getHost()), TcpTransport.this.remoteLocation.getPort());
                TcpTransport.this.dispatchQueue.execute(new Task() {
                    @Override
                    public void run() {
                        if (TcpTransport.this.socketState.m132is(CONNECTING.class)) {
                            try {
                                if (inetSocketAddress != null) {
                                    TcpTransport.this.channel.socket().bind(inetSocketAddress);
                                }
                                TcpTransport.this.trace("connecting...");
                                if (TcpTransport.this.channel.connect(inetSocketAddress2)) {
                                    TcpTransport.this.socketState = TcpTransport.this.new CONNECTED();
                                    TcpTransport.this.onConnected();
                                } else {
                                    TcpTransport.this.readSource = Dispatch.createSource(TcpTransport.this.channel, 8, TcpTransport.this.dispatchQueue);
                                    TcpTransport.this.readSource.setEventHandler(new Task() {
                                        @Override
                                        public void run() {
                                            if (TcpTransport.this.getServiceState() != ServiceBase.STARTED) {
                                                return;
                                            }
                                            try {
                                                TcpTransport.this.trace("connected.");
                                                TcpTransport.this.channel.finishConnect();
                                                TcpTransport.this.readSource.setCancelHandler((Task) null);
                                                TcpTransport.this.readSource.cancel();
                                                TcpTransport.this.readSource = null;
                                                TcpTransport.this.socketState = TcpTransport.this.new CONNECTED();
                                                TcpTransport.this.onConnected();
                                            } catch (IOException e) {
                                                TcpTransport.this.onTransportFailure(e);
                                            }
                                        }
                                    });
                                    TcpTransport.this.readSource.setCancelHandler(TcpTransport.this.CANCEL_HANDLER);
                                    TcpTransport.this.readSource.resume();
                                }
                            } catch (Exception e) {
                                e = e;
                                try {
                                    TcpTransport.this.channel.close();
                                } catch (Exception unused) {
                                }
                                TcpTransport.this.socketState = TcpTransport.this.new CANCELED(true);
                                if (!(e instanceof IOException)) {
                                    e = new IOException(e);
                                }
                                TcpTransport.this.listener.onTransportFailure((IOException) e);
                            }
                        }
                    }
                });
            } catch (IOException e) {
                TcpTransport.this.dispatchQueue.execute(new Task() {
                    @Override
                    public void run() {
                        try {
                            TcpTransport.this.channel.close();
                        } catch (IOException unused) {
                        }
                        TcpTransport.this.socketState = TcpTransport.this.new CANCELED(true);
                        TcpTransport.this.listener.onTransportFailure(e);
                    }
                });
            }
        }
    }

    @Override
    public void _stop(Task task) {
        trace("stopping.. at state: " + this.socketState);
        this.socketState.onStop(task);
    }

    protected String resolveHostName(String str) throws UnknownHostException {
        String hostName;
        return (isUseLocalHost() && (hostName = getLocalHost().getHostName()) != null && hostName.equals(str)) ? "localhost" : str;
    }

    protected void onConnected() throws IOException {
        CustomDispatchSource<Integer, Integer> customDispatchSourceCreateSource = Dispatch.createSource(EventAggregators.INTEGER_ADD, this.dispatchQueue);
        this.yieldSource = customDispatchSourceCreateSource;
        customDispatchSourceCreateSource.setEventHandler(new Task() {
            @Override
            public void run() {
                TcpTransport.this.drainInbound();
            }
        });
        this.yieldSource.resume();
        CustomDispatchSource<Integer, Integer> customDispatchSourceCreateSource2 = Dispatch.createSource(EventAggregators.INTEGER_ADD, this.dispatchQueue);
        this.drainOutboundSource = customDispatchSourceCreateSource2;
        customDispatchSourceCreateSource2.setEventHandler(new Task() {
            @Override
            public void run() {
                TcpTransport.this.flush();
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
                TcpTransport.this.drainInbound();
            }
        });
        this.writeSource.setEventHandler(new Task() {
            @Override
            public void run() {
                TcpTransport.this.flush();
            }
        });
        initRateLimitingChannel();
        if (this.rateLimitingChannel != null) {
            schedualRateAllowanceReset();
        }
        this.listener.onTransportConnected();
    }

    public void schedualRateAllowanceReset() {
        this.dispatchQueue.executeAfter(1L, TimeUnit.SECONDS, new Task() {
            @Override
            public void run() {
                if (TcpTransport.this.socketState.m132is(CONNECTED.class)) {
                    TcpTransport.this.rateLimitingChannel.resetAllowance();
                    TcpTransport.this.schedualRateAllowanceReset();
                }
            }
        });
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
    }

    public void onTransportFailure(IOException iOException) {
        this.listener.onTransportFailure(iOException);
    }

    @Override
    public boolean full() {
        ProtocolCodec protocolCodec = this.codec;
        return protocolCodec == null || protocolCodec.full() || !this.socketState.m132is(CONNECTED.class) || getServiceState() != STARTED;
    }

    @Override
    public boolean offer(Object obj) {
        if (full()) {
            return false;
        }
        try {
            ProtocolCodec.BufferState bufferStateWrite = this.codec.write(obj);
            this.rejectingOffers = this.codec.full();
            if (C054210.f74x1105eea2[bufferStateWrite.ordinal()] == 1) {
                return false;
            }
            this.drainOutboundSource.merge(1);
        } catch (IOException e) {
            onTransportFailure(e);
        }
        return true;
    }

    static class C054210 {

        static final int[] f74x1105eea2;

        static {
            int[] iArr = new int[ProtocolCodec.BufferState.values().length];
            f74x1105eea2 = iArr;
            try {
                iArr[ProtocolCodec.BufferState.FULL.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
        }
    }

    public void flush() {
        if (getServiceState() == STARTED && this.socketState.m132is(CONNECTED.class)) {
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
        RateLimitingChannel rateLimitingChannel = this.rateLimitingChannel;
        if (rateLimitingChannel != null) {
            rateLimitingChannel.resumeRead();
        } else {
            _resumeRead();
        }
    }

    public void _resumeRead() {
        this.readSource.resume();
        this.dispatchQueue.execute(new Task() {
            @Override
            public void run() {
                TcpTransport.this.drainInbound();
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
        return this.socketState.m132is(CONNECTED.class);
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

    public SocketChannel getSocketChannel() {
        return this.channel;
    }

    public ReadableByteChannel getReadChannel() {
        initRateLimitingChannel();
        RateLimitingChannel rateLimitingChannel = this.rateLimitingChannel;
        return rateLimitingChannel != null ? rateLimitingChannel : this.channel;
    }

    public WritableByteChannel getWriteChannel() {
        initRateLimitingChannel();
        RateLimitingChannel rateLimitingChannel = this.rateLimitingChannel;
        return rateLimitingChannel != null ? rateLimitingChannel : this.channel;
    }

    public int getMaxReadRate() {
        return this.maxReadRate;
    }

    public void setMaxReadRate(int i) {
        this.maxReadRate = i;
    }

    public int getMaxWriteRate() {
        return this.maxWriteRate;
    }

    public void setMaxWriteRate(int i) {
        this.maxWriteRate = i;
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
        SocketChannel socketChannel = this.channel;
        if (socketChannel != null) {
            try {
                socketChannel.socket().setReceiveBufferSize(i);
            } catch (SocketException unused) {
            }
        }
    }

    public int getSendBufferSize() {
        return this.sendBufferSize;
    }

    public void setSendBufferSize(int i) {
        this.sendBufferSize = i;
        SocketChannel socketChannel = this.channel;
        if (socketChannel != null) {
            try {
                socketChannel.socket().setReceiveBufferSize(i);
            } catch (SocketException unused) {
            }
        }
    }

    public boolean isKeepAlive() {
        return this.keepAlive;
    }

    public void setKeepAlive(boolean z) {
        this.keepAlive = z;
    }

    @Override
    public Executor getBlockingExecutor() {
        return this.blockingExecutor;
    }

    @Override
    public void setBlockingExecutor(Executor executor) {
        this.blockingExecutor = executor;
    }

    public boolean isCloseOnCancel() {
        return this.closeOnCancel;
    }

    public void setCloseOnCancel(boolean z) {
        this.closeOnCancel = z;
    }
}
