package net.aihelp.core.net.mqtt.client;

import j$.util.concurrent.ConcurrentHashMap;
import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.ProtocolException;
import java.net.SocketAddress;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.Map;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;
import javax.net.ssl.SSLContext;
import net.aihelp.core.net.mqtt.codec.CONNACK;
import net.aihelp.core.net.mqtt.codec.DISCONNECT;
import net.aihelp.core.net.mqtt.codec.MQTTFrame;
import net.aihelp.core.net.mqtt.codec.MQTTProtocolCodec;
import net.aihelp.core.net.mqtt.codec.MessageSupport;
import net.aihelp.core.net.mqtt.codec.PINGREQ;
import net.aihelp.core.net.mqtt.codec.PUBACK;
import net.aihelp.core.net.mqtt.codec.PUBCOMP;
import net.aihelp.core.net.mqtt.codec.PUBLISH;
import net.aihelp.core.net.mqtt.codec.PUBREC;
import net.aihelp.core.net.mqtt.codec.PUBREL;
import net.aihelp.core.net.mqtt.codec.SUBACK;
import net.aihelp.core.net.mqtt.codec.SUBSCRIBE;
import net.aihelp.core.net.mqtt.codec.UNSUBACK;
import net.aihelp.core.net.mqtt.codec.UNSUBSCRIBE;
import net.aihelp.core.net.mqtt.hawtbuf.Buffer;
import net.aihelp.core.net.mqtt.hawtbuf.HexSupport;
import net.aihelp.core.net.mqtt.hawtbuf.UTF8Buffer;
import net.aihelp.core.net.mqtt.hawtdispatch.Dispatch;
import net.aihelp.core.net.mqtt.hawtdispatch.DispatchQueue;
import net.aihelp.core.net.mqtt.hawtdispatch.Task;
import net.aihelp.core.net.mqtt.tansport.DefaultTransportListener;
import net.aihelp.core.net.mqtt.tansport.HeartBeatMonitor;
import net.aihelp.core.net.mqtt.tansport.SslTransport;
import net.aihelp.core.net.mqtt.tansport.TcpTransport;
import net.aihelp.core.net.mqtt.tansport.Transport;

public class CallbackConnection {
    private static final ExtendedListener DEFAULT_LISTENER = new ExtendedListener() {
        @Override
        public void onConnected() {
        }

        @Override
        public void onDisconnected() {
        }

        @Override
        public void onPublish(UTF8Buffer uTF8Buffer, Buffer buffer, Runnable runnable) {
            onFailure(CallbackConnection.createListenerNotSetError());
        }

        @Override
        public void onPublish(UTF8Buffer uTF8Buffer, Buffer buffer, Callback<Callback<Void>> callback) {
            onFailure(CallbackConnection.createListenerNotSetError());
        }

        @Override
        public void onFailure(Throwable th) {
            Thread.currentThread().getUncaughtExceptionHandler().uncaughtException(Thread.currentThread(), th);
        }
    };
    public static final Task NOOP = Dispatch.NOOP;
    private Throwable failure;
    private HeartBeatMonitor heartBeatMonitor;
    private int identifier;
    private final MQTT mqtt;
    private long pingedAt;
    private final DispatchQueue queue;
    private Runnable refiller;
    private Transport transport;
    private ExtendedListener listener = DEFAULT_LISTENER;
    private Map<Short, Request> requests = new ConcurrentHashMap();
    private LinkedList<Request> overflow = new LinkedList<>();
    private final HashMap<Short, Callback<Void>> processed = new HashMap<>();
    private boolean disconnected = false;
    private long reconnects = 0;
    private AtomicBoolean isReconnecting = new AtomicBoolean(false);
    private final AtomicInteger suspendCount = new AtomicInteger(0);
    private final AtomicInteger suspendChanges = new AtomicInteger(0);
    private final HashMap<UTF8Buffer, QoS> activeSubs = new HashMap<>();
    private final Object nextMessageIdLock = new Object();
    private boolean onRefillCalled = false;
    private short nextMessageId = 1;

    private static class Request {

        private final Callback f68cb;
        private final MQTTFrame frame;

        private final short f69id;

        Request(int i, MQTTFrame mQTTFrame, Callback callback) {
            this.f69id = (short) i;
            this.f68cb = callback;
            this.frame = mQTTFrame;
        }
    }

    public int getIdentifier() {
        return this.identifier;
    }

    public void setIdentifier(int i) {
        this.identifier = i;
    }

    public CallbackConnection(MQTT mqtt) {
        this.mqtt = mqtt;
        if (mqtt.dispatchQueue == null) {
            this.queue = Dispatch.createQueue("mqtt client");
        } else {
            this.queue = mqtt.dispatchQueue;
        }
    }

    public void connect(Callback<Void> callback) {
        if (this.transport != null) {
            callback.onFailure(new IllegalStateException("Already connected"));
            return;
        }
        try {
            createTransport(new LoginHandler(callback, true));
        } catch (Throwable th) {
            callback.onFailure(th);
        }
    }

    private long calculateDelay() {
        long jPow = this.mqtt.reconnectDelay;
        if (jPow > 0 && this.mqtt.reconnectBackOffMultiplier > 1.0d) {
            jPow = (long) Math.pow(this.mqtt.reconnectDelay * this.reconnects, this.mqtt.reconnectBackOffMultiplier);
        }
        long jMin = Math.min(jPow, this.mqtt.reconnectDelayMax);
        this.reconnects++;
        return jMin;
    }

    void reconnect() {
        if (this.isReconnecting.getAndSet(true)) {
            return;
        }
        try {
            Thread.sleep(calculateDelay());
        } catch (InterruptedException unused) {
        }
        try {
            createTransport(new LoginHandler(new Callback<Void>() {
                @Override
                public void onSuccess(Void r8) {
                    CallbackConnection.this.mqtt.tracer.debug("Restoring MQTT connection state", new Object[0]);
                    LinkedList linkedList = CallbackConnection.this.overflow;
                    Map map = CallbackConnection.this.requests;
                    CallbackConnection.this.overflow = new LinkedList();
                    CallbackConnection.this.requests = new ConcurrentHashMap();
                    if (!CallbackConnection.this.activeSubs.isEmpty()) {
                        ArrayList arrayList = new ArrayList(CallbackConnection.this.activeSubs.size());
                        for (Map.Entry entry : CallbackConnection.this.activeSubs.entrySet()) {
                            arrayList.add(new Topic((UTF8Buffer) entry.getKey(), (QoS) entry.getValue()));
                        }
                        CallbackConnection.this.send(new SUBSCRIBE().topics((Topic[]) arrayList.toArray(new Topic[arrayList.size()])), null);
                    }
                    for (Map.Entry entry2 : map.entrySet()) {
                        MQTTFrame mQTTFrame = ((Request) entry2.getValue()).frame;
                        mQTTFrame.dup(mQTTFrame.messageType() == 3);
                        CallbackConnection.this.send((Request) entry2.getValue());
                    }
                    Iterator it = linkedList.iterator();
                    while (it.hasNext()) {
                        CallbackConnection.this.send((Request) it.next());
                    }
                    CallbackConnection.this.reconnects = 0L;
                    CallbackConnection.this.isReconnecting.set(false);
                }

                @Override
                public void onFailure(Throwable th) {
                    CallbackConnection.this.isReconnecting.set(false);
                    CallbackConnection.this.handleFatalFailure(th);
                }
            }, false));
        } catch (Throwable th) {
            this.isReconnecting.set(false);
            handleFatalFailure(th);
        }
    }

    void handleSessionFailure(Throwable th) {
        if (!this.disconnected && (this.mqtt.reconnectAttemptsMax < 0 || this.reconnects < this.mqtt.reconnectAttemptsMax)) {
            this.mqtt.tracer.debug("Reconnecting transport", new Object[0]);
            HeartBeatMonitor heartBeatMonitor = this.heartBeatMonitor;
            if (heartBeatMonitor != null) {
                heartBeatMonitor.stop();
                this.heartBeatMonitor = null;
            }
            Transport transport = this.transport;
            this.transport = null;
            if (transport != null) {
                transport.stop(new Task() {
                    @Override
                    public void run() {
                        CallbackConnection.this.listener.onDisconnected();
                        CallbackConnection.this.reconnect();
                    }
                });
                return;
            } else {
                reconnect();
                return;
            }
        }
        handleFatalFailure(th);
    }

    void reconnect(final Callback<Transport> callback) {
        this.queue.executeAfter(calculateDelay(), TimeUnit.MILLISECONDS, new Task() {
            @Override
            public void run() {
                if (CallbackConnection.this.disconnected) {
                    callback.onFailure(CallbackConnection.createDisconnectedError());
                    return;
                }
                try {
                    CallbackConnection.this.createTransport(callback);
                } catch (Exception e) {
                    callback.onFailure(e);
                }
            }
        });
    }

    void createTransport(final Callback<Transport> callback) throws Exception {
        final TcpTransport tcpTransport;
        this.mqtt.tracer.debug("Connecting", new Object[0]);
        String scheme = this.mqtt.host.getScheme();
        if ("tcp".equals(scheme)) {
            tcpTransport = new TcpTransport();
        } else if (SslTransport.protocol(scheme) != null) {
            SslTransport sslTransport = new SslTransport();
            if (this.mqtt.sslContext == null) {
                this.mqtt.sslContext = SSLContext.getDefault();
            }
            sslTransport.setSSLContext(this.mqtt.sslContext);
            tcpTransport = sslTransport;
        } else {
            throw new Exception("Unsupported URI scheme '" + scheme + "'");
        }
        if (this.mqtt.blockingExecutor == null) {
            this.mqtt.blockingExecutor = MQTT.getBlockingThreadPool();
        }
        tcpTransport.setBlockingExecutor(this.mqtt.blockingExecutor);
        tcpTransport.setDispatchQueue(this.queue);
        tcpTransport.setProtocolCodec(new MQTTProtocolCodec());
        if (tcpTransport instanceof TcpTransport) {
            TcpTransport tcpTransport2 = tcpTransport;
            tcpTransport2.setMaxReadRate(this.mqtt.maxReadRate);
            tcpTransport2.setMaxWriteRate(this.mqtt.maxWriteRate);
            tcpTransport2.setReceiveBufferSize(this.mqtt.receiveBufferSize);
            tcpTransport2.setSendBufferSize(this.mqtt.sendBufferSize);
            tcpTransport2.setTrafficClass(this.mqtt.trafficClass);
            tcpTransport2.setUseLocalHost(this.mqtt.useLocalHost);
            tcpTransport2.connecting(this.mqtt.host, this.mqtt.localAddress);
        }
        tcpTransport.setTransportListener(new DefaultTransportListener() {
            @Override
            public void onTransportConnected() {
                CallbackConnection.this.mqtt.tracer.debug("Transport connected", new Object[0]);
                if (CallbackConnection.this.disconnected) {
                    onFailure(CallbackConnection.createDisconnectedError());
                } else {
                    callback.onSuccess(tcpTransport);
                }
            }

            @Override
            public void onTransportFailure(IOException iOException) {
                CallbackConnection.this.mqtt.tracer.debug("Transport failure: %s", iOException);
                onFailure(iOException);
            }

            private void onFailure(final Throwable th) {
                if (tcpTransport.isClosed()) {
                    return;
                }
                tcpTransport.stop(new Task() {
                    @Override
                    public void run() {
                        callback.onFailure(th);
                    }
                });
            }
        });
        tcpTransport.start(NOOP);
    }

    class LoginHandler implements Callback<Transport> {

        private final Callback<Void> f67cb;
        private final boolean initialConnect;

        LoginHandler(Callback<Void> callback, boolean z) {
            this.f67cb = callback;
            this.initialConnect = z;
        }

        @Override
        public void onSuccess(final Transport transport) {
            transport.setTransportListener(new DefaultTransportListener() {
                @Override
                public void onTransportFailure(IOException iOException) {
                    CallbackConnection.this.mqtt.tracer.debug("Transport failure: %s", iOException);
                    transport.stop(CallbackConnection.NOOP);
                    LoginHandler.this.onFailure(iOException);
                }

                @Override
                public void onTransportCommand(Object obj) {
                    MQTTFrame mQTTFrame = (MQTTFrame) obj;
                    CallbackConnection.this.mqtt.tracer.onReceive(mQTTFrame);
                    try {
                        if (mQTTFrame.messageType() != 2) {
                            CallbackConnection.this.mqtt.tracer.debug("Received unexpected MQTT frame: %d", Byte.valueOf(mQTTFrame.messageType()));
                            transport.stop(CallbackConnection.NOOP);
                            LoginHandler.this.f67cb.onFailure(new IOException("Could not connect. Received unexpected command: " + ((int) mQTTFrame.messageType())));
                        } else {
                            CONNACK connackMo1934decode = new CONNACK().mo1934decode(mQTTFrame);
                            if (C046417.$SwitchMap$net$aihelp$core$net$mqtt$codec$CONNACK$Code[connackMo1934decode.code().ordinal()] != 1) {
                                CallbackConnection.this.mqtt.tracer.debug("MQTT login rejected", new Object[0]);
                                transport.stop(CallbackConnection.NOOP);
                                LoginHandler.this.f67cb.onFailure(new MQTTException("Could not connect: " + connackMo1934decode.code(), connackMo1934decode));
                            } else {
                                CallbackConnection.this.mqtt.tracer.debug("MQTT login accepted", new Object[0]);
                                CallbackConnection.this.onSessionEstablished(transport);
                                LoginHandler.this.f67cb.onSuccess(null);
                                CallbackConnection.this.listener.onConnected();
                                CallbackConnection.this.queue.execute(new Task() {
                                    @Override
                                    public void run() {
                                        CallbackConnection.this.drainOverflow();
                                    }
                                });
                            }
                        }
                    } catch (ProtocolException e) {
                        CallbackConnection.this.mqtt.tracer.debug("Protocol error: %s", e);
                        transport.stop(CallbackConnection.NOOP);
                        LoginHandler.this.f67cb.onFailure(e);
                    }
                }
            });
            transport.resumeRead();
            if (CallbackConnection.this.mqtt.connect.clientId() == null) {
                String strSubstring = CallbackConnection.hex(transport.getLocalAddress()) + Long.toHexString(System.currentTimeMillis() / 1000);
                if (strSubstring.length() > 23) {
                    strSubstring = strSubstring.substring(0, 23);
                }
                CallbackConnection.this.mqtt.connect.clientId(Buffer.utf8(strSubstring));
            }
            MQTTFrame mQTTFrameEncode = CallbackConnection.this.mqtt.connect.encode();
            transport.offer(mQTTFrameEncode);
            CallbackConnection.this.mqtt.tracer.onSend(mQTTFrameEncode);
            CallbackConnection.this.mqtt.tracer.debug("Logging in", new Object[0]);
        }

        private boolean tryReconnect() {
            if (this.initialConnect) {
                return CallbackConnection.this.mqtt.connectAttemptsMax < 0 || CallbackConnection.this.reconnects < CallbackConnection.this.mqtt.connectAttemptsMax;
            }
            return CallbackConnection.this.mqtt.reconnectAttemptsMax < 0 || CallbackConnection.this.reconnects < CallbackConnection.this.mqtt.reconnectAttemptsMax;
        }

        @Override
        public void onFailure(Throwable th) {
            if (!CallbackConnection.this.disconnected && tryReconnect()) {
                CallbackConnection.this.reconnect(this);
            } else {
                this.f67cb.onFailure(th);
            }
        }
    }

    public void onSessionEstablished(Transport transport) {
        this.transport = transport;
        if (this.suspendCount.get() > 0) {
            this.transport.suspendRead();
        }
        this.transport.setTransportListener(new DefaultTransportListener() {
            @Override
            public void onTransportCommand(Object obj) {
                MQTTFrame mQTTFrame = (MQTTFrame) obj;
                CallbackConnection.this.mqtt.tracer.onReceive(mQTTFrame);
                CallbackConnection.this.processFrame(mQTTFrame);
            }

            @Override
            public void onRefill() {
                CallbackConnection.this.onRefillCalled = true;
                CallbackConnection.this.drainOverflow();
            }

            @Override
            public void onTransportFailure(IOException iOException) {
                CallbackConnection.this.handleSessionFailure(iOException);
            }
        });
        this.pingedAt = 0L;
        if (this.mqtt.getKeepAlive() > 0) {
            HeartBeatMonitor heartBeatMonitor = new HeartBeatMonitor();
            this.heartBeatMonitor = heartBeatMonitor;
            heartBeatMonitor.setWriteInterval((this.mqtt.getKeepAlive() * 1000) / 2);
            this.heartBeatMonitor.setTransport(this.transport);
            this.heartBeatMonitor.suspendRead();
            this.heartBeatMonitor.setOnKeepAlive(new Task() {
                @Override
                public void run() {
                    if (CallbackConnection.this.disconnected || CallbackConnection.this.pingedAt != 0) {
                        return;
                    }
                    MQTTFrame mQTTFrameEncode = new PINGREQ().encode();
                    if (CallbackConnection.this.transport == null || !CallbackConnection.this.transport.offer(mQTTFrameEncode)) {
                        return;
                    }
                    CallbackConnection.this.mqtt.tracer.onSend(mQTTFrameEncode);
                    final long jCurrentTimeMillis = System.currentTimeMillis();
                    final long j = CallbackConnection.this.suspendChanges.get();
                    CallbackConnection.this.pingedAt = jCurrentTimeMillis;
                    CallbackConnection.this.queue.executeAfter(CallbackConnection.this.mqtt.getKeepAlive(), TimeUnit.SECONDS, new Task() {
                        @Override
                        public void run() {
                            if (jCurrentTimeMillis == CallbackConnection.this.pingedAt) {
                                if (j != CallbackConnection.this.suspendChanges.get() || CallbackConnection.this.suspendCount.get() <= 0) {
                                    CallbackConnection.this.mqtt.tracer.debug("Ping timeout", new Object[0]);
                                    CallbackConnection.this.handleSessionFailure(new ProtocolException("Ping timeout").fillInStackTrace());
                                } else {
                                    CallbackConnection.this.mqtt.tracer.debug("The connection has remained suspended for an extended period of time so it cannot do proper keep alive processing.  Did you forget to resume the connection?", new Object[0]);
                                }
                            }
                        }
                    });
                }
            });
            this.heartBeatMonitor.start();
        }
    }

    public Transport transport() {
        return this.transport;
    }

    public DispatchQueue getDispatchQueue() {
        return this.queue;
    }

    public void resume() {
        Transport transport;
        this.suspendChanges.incrementAndGet();
        if (this.suspendCount.decrementAndGet() != 0 || (transport = this.transport) == null) {
            return;
        }
        transport.resumeRead();
        HeartBeatMonitor heartBeatMonitor = this.heartBeatMonitor;
        if (heartBeatMonitor != null) {
            heartBeatMonitor.resumeRead();
        }
    }

    public void suspend() {
        Transport transport;
        this.suspendChanges.incrementAndGet();
        if (this.suspendCount.incrementAndGet() != 1 || (transport = this.transport) == null) {
            return;
        }
        transport.suspendRead();
        HeartBeatMonitor heartBeatMonitor = this.heartBeatMonitor;
        if (heartBeatMonitor != null) {
            heartBeatMonitor.suspendRead();
        }
    }

    public CallbackConnection refiller(Runnable runnable) {
        this.queue.assertExecuting();
        this.refiller = runnable;
        return this;
    }

    public void unregisterListener() {
        listener(null);
    }

    public CallbackConnection listener(final Listener listener) {
        if (listener instanceof ExtendedListener) {
            this.listener = (ExtendedListener) listener;
        } else {
            this.listener = new ExtendedListener() {
                @Override
                public void onPublish(UTF8Buffer uTF8Buffer, Buffer buffer, final Callback<Callback<Void>> callback) {
                    Listener listener2 = listener;
                    if (listener2 != null) {
                        listener2.onPublish(uTF8Buffer, buffer, new Runnable() {
                            @Override
                            public void run() {
                                callback.onSuccess(null);
                            }
                        });
                    }
                }

                @Override
                public void onPublish(UTF8Buffer uTF8Buffer, Buffer buffer, Runnable runnable) {
                    Listener listener2 = listener;
                    if (listener2 != null) {
                        listener2.onPublish(uTF8Buffer, buffer, runnable);
                    }
                }

                @Override
                public void onConnected() {
                    Listener listener2 = listener;
                    if (listener2 != null) {
                        listener2.onConnected();
                    }
                }

                @Override
                public void onDisconnected() {
                    Listener listener2 = listener;
                    if (listener2 != null) {
                        listener2.onDisconnected();
                    }
                }

                @Override
                public void onFailure(Throwable th) {
                    Listener listener2 = listener;
                    if (listener2 != null) {
                        listener2.onFailure(th);
                    }
                }
            };
        }
        return this;
    }

    public boolean full() {
        return this.transport.full();
    }

    public Throwable failure() {
        return this.failure;
    }

    public void disconnect(final Callback<Void> callback) {
        if (this.disconnected) {
            if (callback != null) {
                callback.onSuccess(null);
                return;
            }
            return;
        }
        this.disconnected = true;
        final short nextMessageId = getNextMessageId();
        final Runnable runnable = new Runnable() {
            private boolean executed = false;

            @Override
            public void run() {
                if (this.executed) {
                    return;
                }
                this.executed = true;
                CallbackConnection.this.requests.remove(Short.valueOf(nextMessageId));
                if (CallbackConnection.this.heartBeatMonitor != null) {
                    CallbackConnection.this.heartBeatMonitor.stop();
                    CallbackConnection.this.heartBeatMonitor = null;
                }
                if (CallbackConnection.this.transport != null) {
                    CallbackConnection.this.transport.stop(new Task() {
                        @Override
                        public void run() {
                            CallbackConnection.this.listener.onDisconnected();
                            if (callback != null) {
                                callback.onSuccess(null);
                            }
                        }
                    });
                }
            }
        };
        Callback<Void> callback2 = new Callback<Void>() {
            @Override
            public void onSuccess(Void r2) {
                CallbackConnection.this.onRefillCalled = false;
                CallbackConnection.this.refiller = new Runnable() {
                    @Override
                    public void run() {
                        if (CallbackConnection.this.onRefillCalled) {
                            runnable.run();
                        }
                    }
                };
                if (CallbackConnection.this.transport != null) {
                    CallbackConnection.this.transport.flush();
                }
            }

            @Override
            public void onFailure(Throwable th) {
                runnable.run();
            }
        };
        if (this.transport != null) {
            send(new Request(getNextMessageId(), new DISCONNECT().encode(), callback2));
        } else {
            callback2.onSuccess(null);
        }
    }

    public void kill(final Callback<Void> callback) {
        if (this.disconnected) {
            if (callback != null) {
                callback.onSuccess(null);
            }
        } else {
            this.disconnected = true;
            HeartBeatMonitor heartBeatMonitor = this.heartBeatMonitor;
            if (heartBeatMonitor != null) {
                heartBeatMonitor.stop();
                this.heartBeatMonitor = null;
            }
            this.transport.stop(new Task() {
                @Override
                public void run() {
                    CallbackConnection.this.listener.onDisconnected();
                    Callback callback2 = callback;
                    if (callback2 != null) {
                        callback2.onSuccess(null);
                    }
                }
            });
        }
    }

    public void publish(String str, byte[] bArr, QoS qoS, boolean z, Callback<Void> callback) {
        publish(Buffer.utf8(str), new Buffer(bArr), qoS, z, callback);
    }

    public void publish(UTF8Buffer uTF8Buffer, Buffer buffer, QoS qoS, boolean z, Callback<Void> callback) {
        this.queue.assertExecuting();
        if (this.disconnected) {
            callback.onFailure(createDisconnectedError());
            return;
        }
        PUBLISH publishRetain = new PUBLISH().qos(qoS).retain(z);
        publishRetain.topicName(uTF8Buffer).payload(buffer);
        send(publishRetain, callback);
    }

    public void subscribe(final Topic[] topicArr, Callback<byte[]> callback) {
        if (this.disconnected) {
            if (callback != null) {
                callback.onFailure(createDisconnectedError());
            }
        } else if (this.listener != DEFAULT_LISTENER) {
            send(new SUBSCRIBE().topics(topicArr), new ProxyCallback<byte[]>(callback) {
                @Override
                public void onSuccess(byte[] bArr) {
                    Topic[] topicArr2 = topicArr;
                    if (topicArr2 != null) {
                        for (Topic topic : topicArr2) {
                            CallbackConnection.this.activeSubs.put(topic.name(), topic.qos());
                        }
                        if (this.next != null) {
                            this.next.onSuccess(bArr);
                        }
                    }
                }
            });
        } else if (callback != null) {
            callback.onFailure(createListenerNotSetError());
        }
    }

    public void unsubscribe(final UTF8Buffer[] uTF8BufferArr, Callback<Void> callback) {
        this.queue.assertExecuting();
        if (this.disconnected) {
            callback.onFailure(createDisconnectedError());
        } else {
            send(new UNSUBSCRIBE().topics(uTF8BufferArr), new ProxyCallback(callback) {
                @Override
                public void onSuccess(Object obj) {
                    for (UTF8Buffer uTF8Buffer : uTF8BufferArr) {
                        CallbackConnection.this.activeSubs.remove(uTF8Buffer);
                    }
                    if (this.next != 0) {
                        this.next.onSuccess((T) obj);
                    }
                }
            });
        }
    }

    public void send(MessageSupport.Acked acked, Callback callback) {
        short nextMessageId;
        if (acked.qos() != QoS.AT_MOST_ONCE) {
            nextMessageId = getNextMessageId();
            acked.messageId(nextMessageId);
        } else {
            nextMessageId = 0;
        }
        send(new Request(nextMessageId, acked.encode(), callback));
    }

    public void send(Request request) {
        Transport transport;
        if (this.failure != null) {
            if (request.f68cb != null) {
                request.f68cb.onFailure(this.failure);
                return;
            }
            return;
        }
        if (request.f69id != 0) {
            this.requests.put(Short.valueOf(request.f69id), request);
        }
        if (!this.overflow.isEmpty() || (transport = this.transport) == null || !transport.offer(request.frame)) {
            this.requests.remove(Short.valueOf(request.f69id));
            this.overflow.addLast(request);
            return;
        }
        this.mqtt.tracer.onSend(request.frame);
        if (request.f69id != 0 || request.f68cb == null) {
            return;
        }
        request.f68cb.onSuccess(null);
    }

    private short getNextMessageId() {
        short s;
        synchronized (this.nextMessageIdLock) {
            s = this.nextMessageId;
            short s2 = (short) (s + 1);
            this.nextMessageId = s2;
            if (s2 == 0) {
                this.nextMessageId = (short) 1;
            }
        }
        return s;
    }

    public void drainOverflow() {
        Runnable runnable;
        if (this.overflow.isEmpty() || this.transport == null) {
            return;
        }
        while (true) {
            Request requestPeek = this.overflow.peek();
            if (requestPeek == null || !this.transport.offer(requestPeek.frame)) {
                break;
            }
            this.mqtt.tracer.onSend(requestPeek.frame);
            this.overflow.removeFirst();
            if (requestPeek.f69id == 0) {
                if (requestPeek.f68cb != null) {
                    requestPeek.f68cb.onSuccess(null);
                }
            } else {
                this.requests.put(Short.valueOf(requestPeek.f69id), requestPeek);
            }
        }
        if (!this.overflow.isEmpty() || (runnable = this.refiller) == null) {
            return;
        }
        try {
            runnable.run();
        } catch (Throwable th) {
            Thread.currentThread().getUncaughtExceptionHandler().uncaughtException(Thread.currentThread(), th);
        }
    }

    private void completeRequest(short s, byte b, Object obj) {
        Request requestRemove = this.requests.remove(Short.valueOf(s));
        if (requestRemove != null) {
            if (requestRemove.f68cb != null) {
                if (obj == null) {
                    requestRemove.f68cb.onSuccess(null);
                    return;
                } else {
                    requestRemove.f68cb.onSuccess(obj);
                    return;
                }
            }
            return;
        }
        handleFatalFailure(new ProtocolException("Command from server contained an invalid message id: " + ((int) s)));
    }

    public void processFrame(MQTTFrame mQTTFrame) {
        try {
            byte bMessageType = mQTTFrame.messageType();
            if (bMessageType == 3) {
                toReceiver(new PUBLISH().mo1934decode(mQTTFrame));
                return;
            }
            if (bMessageType == 4) {
                completeRequest(new PUBACK().mo1934decode(mQTTFrame).messageId(), (byte) 3, null);
                return;
            }
            if (bMessageType == 5) {
                PUBREC pubrecMo1934decode = new PUBREC().mo1934decode(mQTTFrame);
                PUBREL pubrel = new PUBREL();
                pubrel.messageId(pubrecMo1934decode.messageId());
                send(new Request(0, pubrel.encode(), null));
                return;
            }
            if (bMessageType == 6) {
                PUBREL pubrelMo1934decode = new PUBREL().mo1934decode(mQTTFrame);
                Callback<Void> callbackRemove = this.processed.remove(Short.valueOf(pubrelMo1934decode.messageId()));
                PUBCOMP pubcomp = new PUBCOMP();
                pubcomp.messageId(pubrelMo1934decode.messageId());
                send(new Request(0, pubcomp.encode(), null));
                if (callbackRemove != null) {
                    callbackRemove.onSuccess(null);
                    return;
                }
                return;
            }
            if (bMessageType == 7) {
                completeRequest(new PUBCOMP().mo1934decode(mQTTFrame).messageId(), (byte) 3, null);
                return;
            }
            if (bMessageType == 9) {
                SUBACK subackMo1934decode = new SUBACK().mo1934decode(mQTTFrame);
                completeRequest(subackMo1934decode.messageId(), (byte) 8, subackMo1934decode.grantedQos());
            } else if (bMessageType == 11) {
                completeRequest(new UNSUBACK().mo1934decode(mQTTFrame).messageId(), (byte) 10, null);
            } else if (bMessageType == 13) {
                this.pingedAt = 0L;
            } else {
                throw new ProtocolException("Unexpected MQTT command type: " + ((int) mQTTFrame.messageType()));
            }
        } catch (Throwable th) {
            handleFatalFailure(th);
        }
    }

    private void toReceiver(final PUBLISH publish) {
        Callback<Callback<Void>> callback;
        if (this.listener != null) {
            try {
                int i = C046417.$SwitchMap$net$aihelp$core$net$mqtt$client$QoS[publish.qos().ordinal()];
                if (i == 1) {
                    callback = new Callback<Callback<Void>>() {
                        @Override
                        public void onFailure(Throwable th) {
                        }

                        @Override
                        public void onSuccess(Callback<Void> callback2) {
                            PUBACK puback = new PUBACK();
                            puback.messageId(publish.messageId());
                            CallbackConnection.this.send(new Request(0, puback.encode(), null));
                            if (callback2 != null) {
                                callback2.onSuccess(null);
                            }
                        }
                    };
                } else if (i == 2) {
                    callback = new Callback<Callback<Void>>() {
                        @Override
                        public void onFailure(Throwable th) {
                        }

                        @Override
                        public void onSuccess(Callback<Void> callback2) {
                            PUBREC pubrec = new PUBREC();
                            pubrec.messageId(publish.messageId());
                            CallbackConnection.this.processed.put(Short.valueOf(publish.messageId()), callback2);
                            CallbackConnection.this.send(new Request(0, pubrec.encode(), null));
                        }
                    };
                    if (this.processed.get(Short.valueOf(publish.messageId())) != null) {
                        return;
                    }
                } else {
                    callback = i != 3 ? null : new Callback<Callback<Void>>() {
                        @Override
                        public void onFailure(Throwable th) {
                        }

                        @Override
                        public void onSuccess(Callback<Void> callback2) {
                            if (callback2 != null) {
                                callback2.onSuccess(null);
                            }
                        }
                    };
                }
                this.listener.onPublish(publish.topicName(), publish.payload(), callback);
            } catch (Throwable th) {
                handleFatalFailure(th);
            }
        }
    }

    static class C046417 {
        static final int[] $SwitchMap$net$aihelp$core$net$mqtt$client$QoS;
        static final int[] $SwitchMap$net$aihelp$core$net$mqtt$codec$CONNACK$Code;

        static {
            int[] iArr = new int[QoS.values().length];
            $SwitchMap$net$aihelp$core$net$mqtt$client$QoS = iArr;
            try {
                iArr[QoS.AT_LEAST_ONCE.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                $SwitchMap$net$aihelp$core$net$mqtt$client$QoS[QoS.EXACTLY_ONCE.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                $SwitchMap$net$aihelp$core$net$mqtt$client$QoS[QoS.AT_MOST_ONCE.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            int[] iArr2 = new int[CONNACK.Code.values().length];
            $SwitchMap$net$aihelp$core$net$mqtt$codec$CONNACK$Code = iArr2;
            try {
                iArr2[CONNACK.Code.CONNECTION_ACCEPTED.ordinal()] = 1;
            } catch (NoSuchFieldError unused4) {
            }
        }
    }

    public void handleFatalFailure(Throwable th) {
        if (this.failure == null) {
            this.failure = th;
            this.mqtt.tracer.debug("Fatal connection failure: %s", th);
            ArrayList<Request> arrayList = new ArrayList(this.requests.values());
            this.requests.clear();
            for (Request request : arrayList) {
                if (request.f68cb != null) {
                    request.f68cb.onFailure(this.failure);
                }
            }
            ArrayList<Request> arrayList2 = new ArrayList(this.overflow);
            this.overflow.clear();
            for (Request request2 : arrayList2) {
                if (request2.f68cb != null) {
                    request2.f68cb.onFailure(this.failure);
                }
            }
            ExtendedListener extendedListener = this.listener;
            if (extendedListener == null || this.disconnected) {
                return;
            }
            try {
                extendedListener.onFailure(this.failure);
            } catch (Exception e) {
                Thread.currentThread().getUncaughtExceptionHandler().uncaughtException(Thread.currentThread(), e);
            }
        }
    }

    public static IllegalStateException createListenerNotSetError() {
        return (IllegalStateException) new IllegalStateException("No connection listener set to handle message received from the server.").fillInStackTrace();
    }

    public static IllegalStateException createDisconnectedError() {
        return (IllegalStateException) new IllegalStateException("Disconnected").fillInStackTrace();
    }

    public static String hex(SocketAddress socketAddress) {
        if (socketAddress instanceof InetSocketAddress) {
            InetSocketAddress inetSocketAddress = (InetSocketAddress) socketAddress;
            return HexSupport.toHexFromBuffer(new Buffer(inetSocketAddress.getAddress().getAddress())) + Integer.toHexString(inetSocketAddress.getPort());
        }
        return "";
    }
}
