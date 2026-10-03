package net.aihelp.core.net.mqtt.codec;

import java.net.ProtocolException;

public class DISCONNECT extends MessageSupport.EmptyBase implements MessageSupport.Message {
    public static final byte TYPE = 14;

    @Override
    public byte messageType() {
        return TYPE;
    }

    @Override
    public DISCONNECT mo1934decode(MQTTFrame mQTTFrame) throws ProtocolException {
        return (DISCONNECT) super.mo1934decode(mQTTFrame);
    }

    public String toString() {
        return "DISCONNECT";
    }
}
