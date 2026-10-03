package net.aihelp.core.net.mqtt.codec;

import java.net.ProtocolException;

public class PUBCOMP extends MessageSupport.AckBase implements MessageSupport.Message {
    public static final byte TYPE = 7;

    @Override
    public byte messageType() {
        return (byte) 7;
    }

    @Override
    public PUBCOMP mo1934decode(MQTTFrame mQTTFrame) throws ProtocolException {
        return (PUBCOMP) super.mo1934decode(mQTTFrame);
    }

    @Override
    public PUBCOMP messageId(short s) {
        return (PUBCOMP) super.messageId(s);
    }
}
