package net.aihelp.core.net.mqtt.client;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedList;
import net.aihelp.core.net.mqtt.hawtbuf.Buffer;
import net.aihelp.core.net.mqtt.hawtbuf.UTF8Buffer;
import net.aihelp.core.net.mqtt.hawtdispatch.DispatchQueue;
import net.aihelp.core.net.mqtt.hawtdispatch.Task;

public class FutureConnection {
    private volatile boolean connected;
    private final CallbackConnection next;
    private final LinkedList<Promise<Message>> receiveFutures = new LinkedList<>();
    private final LinkedList<Message> receivedFrames = new LinkedList<>();
    private long receiveBuffer = 1048576;
    private long receiveBufferRemaining = 1048576;
    private boolean receiveBufferFull = false;

    static long access$114(FutureConnection futureConnection, long j) {
        long j2 = futureConnection.receiveBufferRemaining + j;
        futureConnection.receiveBufferRemaining = j2;
        return j2;
    }

    static long access$122(FutureConnection futureConnection, long j) {
        long j2 = futureConnection.receiveBufferRemaining - j;
        futureConnection.receiveBufferRemaining = j2;
        return j2;
    }

    public FutureConnection(CallbackConnection callbackConnection) {
        this.next = callbackConnection;
        callbackConnection.listener(new ExtendedListener() {
            @Override
            public void onConnected() {
                FutureConnection.this.connected = true;
            }

            @Override
            public void onDisconnected() {
                FutureConnection.this.connected = false;
            }

            @Override
            public void onPublish(UTF8Buffer uTF8Buffer, final Buffer buffer, final Callback<Callback<Void>> callback) {
                FutureConnection.access$122(FutureConnection.this, buffer.length());
                if (!FutureConnection.this.receiveBufferFull && FutureConnection.this.receiveBufferRemaining <= 0) {
                    FutureConnection.this.receiveBufferFull = true;
                    FutureConnection.this.suspend();
                }
                FutureConnection.this.deliverMessage(new Message(FutureConnection.this.getDispatchQueue(), uTF8Buffer, buffer, new Callback<Callback<Void>>() {
                    @Override
                    public void onSuccess(Callback<Void> callback2) {
                        processed();
                        callback.onSuccess(callback2);
                    }

                    @Override
                    public void onFailure(Throwable th) {
                        processed();
                        callback.onFailure(th);
                    }

                    private void processed() {
                        FutureConnection.this.getDispatchQueue().assertExecuting();
                        FutureConnection.access$114(FutureConnection.this, buffer.length());
                        if (!FutureConnection.this.receiveBufferFull || FutureConnection.this.receiveBufferRemaining <= 0) {
                            return;
                        }
                        FutureConnection.this.receiveBufferFull = false;
                        FutureConnection.this.resume();
                    }
                }));
            }

            @Override
            public void onPublish(UTF8Buffer uTF8Buffer, Buffer buffer, final Runnable runnable) {
                onPublish(uTF8Buffer, buffer, new Callback<Callback<Void>>() {
                    @Override
                    public void onFailure(Throwable th) {
                    }

                    @Override
                    public void onSuccess(Callback<Void> callback) {
                        runnable.run();
                    }
                });
            }

            @Override
            public void onFailure(Throwable th) {
                ArrayList arrayList = new ArrayList(FutureConnection.this.receiveFutures);
                FutureConnection.this.receiveFutures.clear();
                Iterator it = arrayList.iterator();
                while (it.hasNext()) {
                    ((Promise) it.next()).onFailure(th);
                }
                FutureConnection.this.connected = false;
            }
        });
    }

    void deliverMessage(Message message) {
        if (this.receiveFutures.isEmpty()) {
            this.receivedFrames.add(message);
        } else {
            this.receiveFutures.removeFirst().onSuccess(message);
        }
    }

    void putBackMessage(Message message) {
        if (this.receiveFutures.isEmpty()) {
            this.receivedFrames.addFirst(message);
        } else {
            this.receiveFutures.removeFirst().onSuccess(message);
        }
    }

    public boolean isConnected() {
        return this.connected;
    }

    public DispatchQueue getDispatchQueue() {
        return this.next.getDispatchQueue();
    }

    public Future<Void> connect() {
        final Promise promise = new Promise();
        this.next.getDispatchQueue().execute(new Task() {
            @Override
            public void run() {
                FutureConnection.this.next.connect(promise);
            }
        });
        return promise;
    }

    public Future<Void> disconnect() {
        final Promise promise = new Promise();
        this.next.getDispatchQueue().execute(new Task() {
            @Override
            public void run() {
                FutureConnection.this.next.disconnect(promise);
            }
        });
        return promise;
    }

    public Future<Void> kill() {
        final Promise promise = new Promise();
        this.next.getDispatchQueue().execute(new Task() {
            @Override
            public void run() {
                FutureConnection.this.next.kill(promise);
            }
        });
        return promise;
    }

    public Future<byte[]> subscribe(final Topic[] topicArr) {
        final Promise promise = new Promise();
        this.next.getDispatchQueue().execute(new Task() {
            @Override
            public void run() {
                FutureConnection.this.next.subscribe(topicArr, promise);
            }
        });
        return promise;
    }

    public Future<Void> unsubscribe(String[] strArr) {
        int length = strArr.length;
        UTF8Buffer[] uTF8BufferArr = new UTF8Buffer[length];
        for (int i = 0; i < length; i++) {
            uTF8BufferArr[i] = new UTF8Buffer(strArr[i]);
        }
        return unsubscribe(uTF8BufferArr);
    }

    public Future<Void> unsubscribe(final UTF8Buffer[] uTF8BufferArr) {
        final Promise promise = new Promise();
        this.next.getDispatchQueue().execute(new Task() {
            @Override
            public void run() {
                FutureConnection.this.next.unsubscribe(uTF8BufferArr, promise);
            }
        });
        return promise;
    }

    public Future<Void> publish(String str, byte[] bArr, QoS qoS, boolean z) {
        return publish(Buffer.utf8(str), new Buffer(bArr), qoS, z);
    }

    public Future<Void> publish(final UTF8Buffer uTF8Buffer, final Buffer buffer, final QoS qoS, final boolean z) {
        final Promise promise = new Promise();
        this.next.getDispatchQueue().execute(new Task() {
            @Override
            public void run() {
                FutureConnection.this.next.publish(uTF8Buffer, buffer, qoS, z, promise);
            }
        });
        return promise;
    }

    public Future<Message> receive() {
        final Promise promise = new Promise();
        getDispatchQueue().execute(new Task() {
            @Override
            public void run() {
                if (FutureConnection.this.next.failure() != null) {
                    promise.onFailure(FutureConnection.this.next.failure());
                } else if (FutureConnection.this.receivedFrames.isEmpty()) {
                    FutureConnection.this.receiveFutures.add(promise);
                } else {
                    promise.onSuccess((Message) FutureConnection.this.receivedFrames.removeFirst());
                }
            }
        });
        return promise;
    }

    public long getReceiveBuffer() {
        getDispatchQueue().assertExecuting();
        return this.receiveBuffer;
    }

    public void setReceiveBuffer(long j) {
        long j2 = this.receiveBuffer;
        this.receiveBuffer = j;
        long j3 = this.receiveBufferRemaining - (j2 - j);
        this.receiveBufferRemaining = j3;
        boolean z = this.receiveBufferFull;
        if (!z && j3 <= 0) {
            this.receiveBufferFull = true;
            suspend();
        } else {
            if (!z || j3 <= 0) {
                return;
            }
            this.receiveBufferFull = false;
            resume();
        }
    }

    public void resume() {
        this.next.resume();
    }

    public void suspend() {
        this.next.suspend();
    }
}
