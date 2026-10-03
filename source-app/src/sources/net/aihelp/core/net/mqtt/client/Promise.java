package net.aihelp.core.net.mqtt.client;

import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

public class Promise<T> implements Callback<T>, Future<T> {
    private Throwable error;
    private final CountDownLatch latch = new CountDownLatch(1);
    private Callback<T> next;
    private T value;

    @Override
    public void onFailure(Throwable th) {
        Callback<T> callback;
        synchronized (this) {
            this.error = th;
            this.latch.countDown();
            callback = this.next;
        }
        if (callback != null) {
            callback.onFailure(th);
        }
    }

    @Override
    public void onSuccess(T t) {
        Callback<T> callback;
        synchronized (this) {
            this.value = t;
            this.latch.countDown();
            callback = this.next;
        }
        if (callback != null) {
            callback.onSuccess(t);
        }
    }

    @Override
    public void then(Callback<T> callback) {
        boolean z;
        synchronized (this) {
            this.next = callback;
            z = this.latch.getCount() == 0;
        }
        if (z) {
            Throwable th = this.error;
            if (th != null) {
                callback.onFailure(th);
            } else {
                callback.onSuccess(this.value);
            }
        }
    }

    @Override
    public T await(long j, TimeUnit timeUnit) throws Exception {
        if (this.latch.await(j, timeUnit)) {
            return get();
        }
        throw new TimeoutException();
    }

    @Override
    public T await() throws Exception {
        this.latch.await();
        return get();
    }

    private T get() throws Exception {
        Throwable th = this.error;
        if (th != null) {
            if (th instanceof RuntimeException) {
                throw ((RuntimeException) th);
            }
            if (th instanceof Exception) {
                throw ((Exception) th);
            }
            if (th instanceof Error) {
                throw ((Error) th);
            }
            throw new RuntimeException(th);
        }
        return this.value;
    }
}
