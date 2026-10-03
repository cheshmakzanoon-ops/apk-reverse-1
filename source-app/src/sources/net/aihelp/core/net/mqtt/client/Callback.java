package net.aihelp.core.net.mqtt.client;

public interface Callback<T> {
    void onFailure(Throwable th);

    void onSuccess(T t);
}
