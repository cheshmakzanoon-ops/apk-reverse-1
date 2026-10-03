package net.aihelp.core.net.mqtt.codec;

import java.net.ProtocolException;

public class PUBREC extends MessageSupport.AckBase implements MessageSupport.Message {
    public static final byte TYPE = 5;

    @Override
    public byte messageType() {
        return (byte) 5;
    }

    @Override
    public PUBREC mo1934decode(MQTTFrame mQTTFrame) throws ProtocolException {
        return (PUBREC) super.mo1934decode(mQTTFrame);
    }

    @Override
    public PUBREC messageId(short s) {
        return (PUBREC) super.messageId(s);
    }
}
