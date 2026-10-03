package net.aihelp.core.net.mqtt.client;

import net.aihelp.core.net.mqtt.hawtbuf.Buffer;
import net.aihelp.core.net.mqtt.hawtbuf.UTF8Buffer;
import net.aihelp.core.net.mqtt.hawtdispatch.DispatchQueue;
import net.aihelp.core.net.mqtt.hawtdispatch.Task;

public class Message {
    boolean blocking = false;
    private Callback<Callback<Void>> onComplete;
    private final Buffer payload;
    private final DispatchQueue queue;
    private final UTF8Buffer topic;

    public Message(DispatchQueue dispatchQueue, UTF8Buffer uTF8Buffer, Buffer buffer, Callback<Callback<Void>> callback) {
        this.queue = dispatchQueue;
        this.payload = buffer;
        this.topic = uTF8Buffer;
        this.onComplete = callback;
    }

    public byte[] getPayload() {
        return this.payload.toByteArray();
    }

    public Buffer getPayloadBuffer() {
        return this.payload;
    }

    public String getTopic() {
        return this.topic.toString();
    }

    public UTF8Buffer getTopicBuffer() {
        return this.topic;
    }

    public void ack() {
        if (this.blocking) {
            Promise promise = new Promise();
            ack(promise);
            try {
                promise.await();
                return;
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        }
        ack(null);
    }

    public void ack(final Callback<Void> callback) {
        if (this.onComplete != null) {
            this.queue.execute(new Task() {
                Callback<Callback<Void>> onCompleteCopy;

                {
                    this.onCompleteCopy = Message.this.onComplete;
                }

                @Override
                public void run() {
                    this.onCompleteCopy.onSuccess(callback);
                }
            });
            this.onComplete = null;
        } else if (callback != null) {
            callback.onSuccess(null);
        }
    }
}
