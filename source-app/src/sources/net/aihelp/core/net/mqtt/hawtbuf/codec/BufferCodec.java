package net.aihelp.core.net.mqtt.hawtbuf.codec;

import net.aihelp.core.net.mqtt.hawtbuf.Buffer;

public class BufferCodec extends AbstractBufferCodec<Buffer> {
    public static final BufferCodec INSTANCE = new BufferCodec();

    @Override
    protected Buffer createBuffer(byte[] bArr) {
        return new Buffer(bArr);
    }
}
