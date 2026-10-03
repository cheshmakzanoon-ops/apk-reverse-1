package net.aihelp.core.net.mqtt.codec;

import java.net.ProtocolException;

public class PINGRESP extends MessageSupport.EmptyBase implements MessageSupport.Message {
    public static final byte TYPE = 13;

    @Override
    public byte messageType() {
        return TYPE;
    }

    @Override
    public PINGRESP mo1934decode(MQTTFrame mQTTFrame) throws ProtocolException {
        return (PINGRESP) super.mo1934decode(mQTTFrame);
    }

    public String toString() {
        return "PINGRESP";
    }
}
