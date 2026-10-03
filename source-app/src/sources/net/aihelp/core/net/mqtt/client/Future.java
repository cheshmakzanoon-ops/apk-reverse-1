package net.aihelp.core.net.mqtt.client;

import java.util.concurrent.TimeUnit;

public interface Future<T> {
    T await() throws Exception;

    T await(long j, TimeUnit timeUnit) throws Exception;

    void then(Callback<T> callback);
}
