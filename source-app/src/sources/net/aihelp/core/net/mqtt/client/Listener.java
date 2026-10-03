package net.aihelp.core.net.mqtt.client;

import net.aihelp.core.net.mqtt.hawtbuf.Buffer;
import net.aihelp.core.net.mqtt.hawtbuf.UTF8Buffer;

@Deprecated
public interface Listener {
    void onConnected();

    void onDisconnected();

    void onFailure(Throwable th);

    void onPublish(UTF8Buffer uTF8Buffer, Buffer buffer, Runnable runnable);
}
