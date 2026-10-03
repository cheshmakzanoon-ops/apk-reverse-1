package net.aihelp.core.net.mqtt.client;

public class NoopCallback<T> implements Callback<T> {
    public final Callback<T> next;

    public NoopCallback(Callback<T> callback) {
        this.next = callback;
    }

    @Override
    public void onSuccess(T t) {
        Callback<T> callback = this.next;
        if (callback != null) {
            callback.onSuccess(t);
        }
    }

    @Override
    public void onFailure(Throwable th) {
        Callback<T> callback = this.next;
        if (callback != null) {
            callback.onFailure(th);
        }
    }
}
