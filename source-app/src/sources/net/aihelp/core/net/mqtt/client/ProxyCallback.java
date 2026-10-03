package net.aihelp.core.net.mqtt.client;

public class ProxyCallback<T> implements Callback<T> {
    public final Callback<T> next;

    public ProxyCallback(Callback<T> callback) {
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
