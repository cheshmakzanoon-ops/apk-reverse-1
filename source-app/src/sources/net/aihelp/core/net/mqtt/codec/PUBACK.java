package net.aihelp.core.net.mqtt.codec;

import java.net.ProtocolException;

public class PUBACK extends MessageSupport.AckBase implements MessageSupport.Message {
    public static final byte TYPE = 4;

    @Override
    public byte messageType() {
        return (byte) 4;
    }

    @Override
    public PUBACK mo1934decode(MQTTFrame mQTTFrame) throws ProtocolException {
        return (PUBACK) super.mo1934decode(mQTTFrame);
    }

    @Override
    public PUBACK messageId(short s) {
        return (PUBACK) super.messageId(s);
    }
}
