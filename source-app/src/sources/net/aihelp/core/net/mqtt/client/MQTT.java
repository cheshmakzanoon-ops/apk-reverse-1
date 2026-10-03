package net.aihelp.core.net.mqtt.client;

import java.net.URI;
import java.net.URISyntaxException;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.Executor;
import java.util.concurrent.SynchronousQueue;
import java.util.concurrent.ThreadFactory;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;
import javax.net.ssl.SSLContext;
import net.aihelp.core.net.mqtt.codec.CONNECT;
import net.aihelp.core.net.mqtt.hawtbuf.Buffer;
import net.aihelp.core.net.mqtt.hawtbuf.UTF8Buffer;
import net.aihelp.core.net.mqtt.hawtdispatch.DispatchQueue;

public class MQTT {
    private static ThreadPoolExecutor blockingThreadPool;
    protected Executor blockingExecutor;
    protected CONNECT connect;
    protected long connectAttemptsMax;
    protected DispatchQueue dispatchQueue;
    protected URI host;
    protected URI localAddress;
    protected int maxReadRate;
    protected int maxWriteRate;
    protected int receiveBufferSize;
    protected long reconnectAttemptsMax;
    protected double reconnectBackOffMultiplier;
    protected long reconnectDelay;
    protected long reconnectDelayMax;
    protected int sendBufferSize;
    protected SSLContext sslContext;
    protected Tracer tracer;
    protected int trafficClass;
    protected boolean useLocalHost;
    private static final long KEEP_ALIVE = Long.parseLong(System.getProperty("mqtt.thread.keep_alive", Integer.toString(1000)));
    private static final long STACK_SIZE = Long.parseLong(System.getProperty("mqtt.thread.stack_size", Integer.toString(524288)));
    private static final URI DEFAULT_HOST = createDefaultHost();

    public static synchronized ThreadPoolExecutor getBlockingThreadPool() {
        if (blockingThreadPool == null) {
            blockingThreadPool = new ThreadPoolExecutor(0, Integer.MAX_VALUE, KEEP_ALIVE, TimeUnit.MILLISECONDS, new SynchronousQueue(), new ThreadFactory() {
                @Override
                public Thread newThread(Runnable runnable) {
                    Thread thread = new Thread(null, runnable, "MQTT Task", MQTT.STACK_SIZE);
                    thread.setDaemon(true);
                    return thread;
                }
            }) {
                @Override
                public void shutdown() {
                }

                @Override
                public List<Runnable> shutdownNow() {
                    return Collections.emptyList();
                }
            };
        }
        return blockingThreadPool;
    }

    public static synchronized void setBlockingThreadPool(ThreadPoolExecutor threadPoolExecutor) {
        blockingThreadPool = threadPoolExecutor;
    }

    private static URI createDefaultHost() {
        try {
            return new URI("tcp://127.0.0.1:1883");
        } catch (URISyntaxException unused) {
            return null;
        }
    }

    public MQTT() {
        this.host = DEFAULT_HOST;
        this.trafficClass = 8;
        this.receiveBufferSize = 65536;
        this.sendBufferSize = 65536;
        this.useLocalHost = true;
        this.connect = new CONNECT();
        this.reconnectDelay = 10L;
        this.reconnectDelayMax = 30000L;
        this.reconnectBackOffMultiplier = 2.0d;
        this.reconnectAttemptsMax = -1L;
        this.connectAttemptsMax = -1L;
        this.tracer = new Tracer();
    }

    public MQTT(MQTT mqtt) {
        this.host = DEFAULT_HOST;
        this.trafficClass = 8;
        this.receiveBufferSize = 65536;
        this.sendBufferSize = 65536;
        this.useLocalHost = true;
        this.connect = new CONNECT();
        this.reconnectDelay = 10L;
        this.reconnectDelayMax = 30000L;
        this.reconnectBackOffMultiplier = 2.0d;
        this.reconnectAttemptsMax = -1L;
        this.connectAttemptsMax = -1L;
        this.tracer = new Tracer();
        this.host = mqtt.host;
        this.localAddress = mqtt.localAddress;
        this.sslContext = mqtt.sslContext;
        this.dispatchQueue = mqtt.dispatchQueue;
        this.blockingExecutor = mqtt.blockingExecutor;
        this.maxReadRate = mqtt.maxReadRate;
        this.maxWriteRate = mqtt.maxWriteRate;
        this.trafficClass = mqtt.trafficClass;
        this.receiveBufferSize = mqtt.receiveBufferSize;
        this.sendBufferSize = mqtt.sendBufferSize;
        this.useLocalHost = mqtt.useLocalHost;
        this.connect = new CONNECT(mqtt.connect);
        this.reconnectDelay = mqtt.reconnectDelay;
        this.reconnectDelayMax = mqtt.reconnectDelayMax;
        this.reconnectBackOffMultiplier = mqtt.reconnectBackOffMultiplier;
        this.reconnectAttemptsMax = mqtt.reconnectAttemptsMax;
        this.connectAttemptsMax = mqtt.connectAttemptsMax;
        this.tracer = mqtt.tracer;
    }

    public CallbackConnection callbackConnection() {
        if (!isCleanSession() && (getClientId() == null || getClientId().length == 0)) {
            throw new IllegalArgumentException("The client id MUST be configured when clean session is set to false");
        }
        return new CallbackConnection(new MQTT(this));
    }

    public FutureConnection futureConnection() {
        return new FutureConnection(callbackConnection());
    }

    public BlockingConnection blockingConnection() {
        return new BlockingConnection(futureConnection());
    }

    public UTF8Buffer getClientId() {
        return this.connect.clientId();
    }

    public short getKeepAlive() {
        return this.connect.keepAlive();
    }

    public UTF8Buffer getPassword() {
        return this.connect.password();
    }

    public byte getType() {
        return this.connect.messageType();
    }

    public UTF8Buffer getUserName() {
        return this.connect.userName();
    }

    public UTF8Buffer getWillMessage() {
        return this.connect.willMessage();
    }

    public QoS getWillQos() {
        return this.connect.willQos();
    }

    public UTF8Buffer getWillTopic() {
        return this.connect.willTopic();
    }

    public boolean isCleanSession() {
        return this.connect.cleanSession();
    }

    public boolean isWillRetain() {
        return this.connect.willRetain();
    }

    public void setCleanSession(boolean z) {
        this.connect.cleanSession(z);
    }

    public void setClientId(String str) {
        setClientId(Buffer.utf8(str));
    }

    public void setClientId(UTF8Buffer uTF8Buffer) {
        this.connect.clientId(uTF8Buffer);
    }

    public void setKeepAlive(short s) {
        this.connect.keepAlive(s);
    }

    public void setPassword(String str) {
        setPassword(Buffer.utf8(str));
    }

    public void setPassword(UTF8Buffer uTF8Buffer) {
        this.connect.password(uTF8Buffer);
    }

    public void setUserName(String str) {
        setUserName(Buffer.utf8(str));
    }

    public void setUserName(UTF8Buffer uTF8Buffer) {
        this.connect.userName(uTF8Buffer);
    }

    public void setWillMessage(String str) {
        this.connect.willMessage(Buffer.utf8(str));
    }

    public void setWillMessage(UTF8Buffer uTF8Buffer) {
        this.connect.willMessage(uTF8Buffer);
    }

    public void setWillQos(QoS qoS) {
        this.connect.willQos(qoS);
    }

    public void setVersion(String str) {
        if ("3.1".equals(str)) {
            this.connect.version(3);
        } else if ("3.1.1".equals(str)) {
            this.connect.version(4);
        }
    }

    public String getVersion() {
        int iVersion = this.connect.version();
        if (iVersion == 3) {
            return "3.1";
        }
        if (iVersion == 4) {
            return "3.1.1";
        }
        return "unknown";
    }

    public void setWillRetain(boolean z) {
        this.connect.willRetain(z);
    }

    public void setWillTopic(String str) {
        setWillTopic(Buffer.utf8(str));
    }

    public void setWillTopic(UTF8Buffer uTF8Buffer) {
        this.connect.willTopic(uTF8Buffer);
    }

    public Executor getBlockingExecutor() {
        return this.blockingExecutor;
    }

    public void setBlockingExecutor(Executor executor) {
        this.blockingExecutor = executor;
    }

    public DispatchQueue getDispatchQueue() {
        return this.dispatchQueue;
    }

    public void setDispatchQueue(DispatchQueue dispatchQueue) {
        this.dispatchQueue = dispatchQueue;
    }

    public URI getLocalAddress() {
        return this.localAddress;
    }

    public void setLocalAddress(String str) throws URISyntaxException {
        setLocalAddress(new URI(str));
    }

    public void setLocalAddress(URI uri) {
        this.localAddress = uri;
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

    public int getReceiveBufferSize() {
        return this.receiveBufferSize;
    }

    public void setReceiveBufferSize(int i) {
        this.receiveBufferSize = i;
    }

    public URI getHost() {
        return this.host;
    }

    public void setHost(String str, int i) throws URISyntaxException {
        setHost(new URI("tcp://" + str + ":" + i));
    }

    public void setHost(String str) throws URISyntaxException {
        setHost(new URI(str));
    }

    public void setHost(URI uri) {
        this.host = uri;
    }

    public int getSendBufferSize() {
        return this.sendBufferSize;
    }

    public void setSendBufferSize(int i) {
        this.sendBufferSize = i;
    }

    public SSLContext getSslContext() {
        return this.sslContext;
    }

    public void setSslContext(SSLContext sSLContext) {
        this.sslContext = sSLContext;
    }

    public int getTrafficClass() {
        return this.trafficClass;
    }

    public void setTrafficClass(int i) {
        this.trafficClass = i;
    }

    public boolean isUseLocalHost() {
        return this.useLocalHost;
    }

    public void setUseLocalHost(boolean z) {
        this.useLocalHost = z;
    }

    public long getConnectAttemptsMax() {
        return this.connectAttemptsMax;
    }

    public void setConnectAttemptsMax(long j) {
        this.connectAttemptsMax = j;
    }

    public long getReconnectAttemptsMax() {
        return this.reconnectAttemptsMax;
    }

    public void setReconnectAttemptsMax(long j) {
        this.reconnectAttemptsMax = j;
    }

    public double getReconnectBackOffMultiplier() {
        return this.reconnectBackOffMultiplier;
    }

    public void setReconnectBackOffMultiplier(double d) {
        this.reconnectBackOffMultiplier = d;
    }

    public long getReconnectDelay() {
        return this.reconnectDelay;
    }

    public void setReconnectDelay(long j) {
        this.reconnectDelay = j;
    }

    public long getReconnectDelayMax() {
        return this.reconnectDelayMax;
    }

    public void setReconnectDelayMax(long j) {
        this.reconnectDelayMax = j;
    }

    public Tracer getTracer() {
        return this.tracer;
    }

    public void setTracer(Tracer tracer) {
        this.tracer = tracer;
    }
}
