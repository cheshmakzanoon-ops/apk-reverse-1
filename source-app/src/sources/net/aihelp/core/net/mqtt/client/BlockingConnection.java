package net.aihelp.core.net.mqtt.client;

import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;
import java.util.concurrent.atomic.AtomicLong;
import net.aihelp.core.net.mqtt.hawtbuf.Buffer;
import net.aihelp.core.net.mqtt.hawtbuf.UTF8Buffer;

public class BlockingConnection {
    private final FutureConnection next;

    public BlockingConnection(FutureConnection futureConnection) {
        this.next = futureConnection;
    }

    public boolean isConnected() {
        return this.next.isConnected();
    }

    public void connect() throws Exception {
        this.next.connect().await();
    }

    public void disconnect() throws Exception {
        this.next.disconnect().await();
    }

    public void kill() throws Exception {
        this.next.kill().await();
    }

    public byte[] subscribe(Topic[] topicArr) throws Exception {
        return this.next.subscribe(topicArr).await();
    }

    public void unsubscribe(String[] strArr) throws Exception {
        this.next.unsubscribe(strArr).await();
    }

    public void unsubscribe(UTF8Buffer[] uTF8BufferArr) throws Exception {
        this.next.unsubscribe(uTF8BufferArr).await();
    }

    public void publish(UTF8Buffer uTF8Buffer, Buffer buffer, QoS qoS, boolean z) throws Exception {
        this.next.publish(uTF8Buffer, buffer, qoS, z).await();
    }

    protected Object clone() throws CloneNotSupportedException {
        return super.clone();
    }

    public void publish(String str, byte[] bArr, QoS qoS, boolean z) throws Exception {
        publish(Buffer.utf8(str), new Buffer(bArr), qoS, z);
    }

    public Message receive() throws Exception {
        return this.next.receive().await();
    }

    public Message receive(long j, TimeUnit timeUnit) throws Exception {
        Future<Message> futureReceive = this.next.receive();
        try {
            Message messageAwait = futureReceive.await(j, timeUnit);
            if (messageAwait != null) {
                messageAwait.blocking = true;
            }
            return messageAwait;
        } catch (TimeoutException unused) {
            futureReceive.then(new Callback<Message>() {
                @Override
                public void onFailure(Throwable th) {
                }

                @Override
                public void onSuccess(Message message) {
                    BlockingConnection.this.next.putBackMessage(message);
                }
            });
            return null;
        }
    }

    public void setReceiveBuffer(final long j) throws InterruptedException {
        final CountDownLatch countDownLatch = new CountDownLatch(1);
        this.next.getDispatchQueue().execute(new Runnable() {
            @Override
            public void run() {
                try {
                    BlockingConnection.this.next.setReceiveBuffer(j);
                } finally {
                    countDownLatch.countDown();
                }
            }
        });
        countDownLatch.await();
    }

    public long getReceiveBuffer() throws InterruptedException {
        final CountDownLatch countDownLatch = new CountDownLatch(1);
        final AtomicLong atomicLong = new AtomicLong();
        this.next.getDispatchQueue().execute(new Runnable() {
            @Override
            public void run() {
                try {
                    atomicLong.set(BlockingConnection.this.next.getReceiveBuffer());
                } finally {
                    countDownLatch.countDown();
                }
            }
        });
        countDownLatch.await();
        return atomicLong.get();
    }

    public void resume() {
        this.next.resume();
    }

    public void suspend() {
        this.next.suspend();
    }
}
