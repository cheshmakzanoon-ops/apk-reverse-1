package net.aihelp.core.net.mqtt.hawtbuf.codec;

import net.aihelp.core.net.mqtt.hawtbuf.AsciiBuffer;

public class AsciiBufferCodec extends AbstractBufferCodec<AsciiBuffer> {
    public static final AsciiBufferCodec INSTANCE = new AsciiBufferCodec();

    @Override
    public AsciiBuffer createBuffer(byte[] bArr) {
        return new AsciiBuffer(bArr);
    }
}
