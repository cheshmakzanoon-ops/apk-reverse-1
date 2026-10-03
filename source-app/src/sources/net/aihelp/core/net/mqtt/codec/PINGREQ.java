package net.aihelp.core.net.mqtt.codec;

import java.net.ProtocolException;

public class PINGREQ extends MessageSupport.EmptyBase implements MessageSupport.Message {
    public static final byte TYPE = 12;

    @Override
    public byte messageType() {
        return TYPE;
    }

    @Override
    public PINGREQ mo1934decode(MQTTFrame mQTTFrame) throws ProtocolException {
        return (PINGREQ) super.mo1934decode(mQTTFrame);
    }

    public String toString() {
        return "PINGREQ";
    }
}
