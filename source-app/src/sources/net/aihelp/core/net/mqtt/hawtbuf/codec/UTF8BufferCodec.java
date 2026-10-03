package net.aihelp.core.net.mqtt.hawtbuf.codec;

import net.aihelp.core.net.mqtt.hawtbuf.UTF8Buffer;

public class UTF8BufferCodec extends AbstractBufferCodec<UTF8Buffer> {
    public static final UTF8BufferCodec INSTANCE = new UTF8BufferCodec();

    @Override
    public UTF8Buffer createBuffer(byte[] bArr) {
        return new UTF8Buffer(bArr);
    }
}
