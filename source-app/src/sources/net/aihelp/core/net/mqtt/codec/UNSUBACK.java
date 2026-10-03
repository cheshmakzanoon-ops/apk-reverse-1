package net.aihelp.core.net.mqtt.codec;

import java.net.ProtocolException;

public class UNSUBACK extends MessageSupport.AckBase implements MessageSupport.Message {
    public static final byte TYPE = 11;

    @Override
    public byte messageType() {
        return TYPE;
    }

    @Override
    public UNSUBACK mo1934decode(MQTTFrame mQTTFrame) throws ProtocolException {
        return (UNSUBACK) super.mo1934decode(mQTTFrame);
    }

    @Override
    public UNSUBACK messageId(short s) {
        return (UNSUBACK) super.messageId(s);
    }
}
