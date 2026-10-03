package net.aihelp.core.net.mqtt.tansport;

import java.io.IOException;

public interface TransportListener {
    void onRefill();

    void onTransportCommand(Object obj);

    void onTransportConnected();

    void onTransportDisconnected();

    void onTransportFailure(IOException iOException);
}
