package net.aihelp.core.net.mqtt.tansport;

public interface TransportServerListener {
    void onAccept(Transport transport) throws Exception;

    void onAcceptError(Exception exc);
}
