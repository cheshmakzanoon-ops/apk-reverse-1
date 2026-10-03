package net.aihelp.core.net.mqtt.client;

import net.aihelp.core.net.mqtt.hawtbuf.Buffer;
import net.aihelp.core.net.mqtt.hawtbuf.UTF8Buffer;

public interface ExtendedListener extends Listener {
    void onPublish(UTF8Buffer uTF8Buffer, Buffer buffer, Callback<Callback<Void>> callback);
}
