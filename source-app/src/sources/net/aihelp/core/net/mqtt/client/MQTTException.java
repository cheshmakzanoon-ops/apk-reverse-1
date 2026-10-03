package net.aihelp.core.net.mqtt.client;

import java.io.IOException;
import net.aihelp.core.net.mqtt.codec.CONNACK;

public class MQTTException extends IOException {
    public final CONNACK connack;

    public MQTTException(String str, CONNACK connack) {
        super(str);
        this.connack = connack;
    }
}
