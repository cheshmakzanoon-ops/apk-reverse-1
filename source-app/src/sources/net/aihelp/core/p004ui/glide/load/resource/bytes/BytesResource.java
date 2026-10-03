package net.aihelp.core.p004ui.glide.load.resource.bytes;

import net.aihelp.core.p004ui.glide.load.engine.Resource;

public class BytesResource implements Resource<byte[]> {
    private final byte[] bytes;

    @Override
    public void recycle() {
    }

    public BytesResource(byte[] bArr) {
        if (bArr == null) {
            throw new NullPointerException("Bytes must not be null");
        }
        this.bytes = bArr;
    }

    @Override
    public byte[] get() {
        return this.bytes;
    }

    @Override
    public int getSize() {
        return this.bytes.length;
    }
}
