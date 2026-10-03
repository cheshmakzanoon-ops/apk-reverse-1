package net.aihelp.core.net.mqtt.hawtbuf.codec;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;
import net.aihelp.core.net.mqtt.hawtbuf.Buffer;

public class FixedBufferCodec implements Codec<Buffer> {
    private final int size;

    @Override
    public boolean isDeepCopySupported() {
        return true;
    }

    @Override
    public boolean isEstimatedSizeSupported() {
        return true;
    }

    public FixedBufferCodec(int i) {
        this.size = i;
    }

    @Override
    public void encode(Buffer buffer, DataOutput dataOutput) throws IOException {
        dataOutput.write(buffer.data, buffer.offset, this.size);
    }

    @Override
    public Buffer decode(DataInput dataInput) throws IOException {
        byte[] bArr = new byte[this.size];
        dataInput.readFully(bArr);
        return new Buffer(bArr);
    }

    @Override
    public int getFixedSize() {
        return this.size;
    }

    @Override
    public Buffer deepCopy(Buffer buffer) {
        return buffer.deepCopy();
    }

    @Override
    public int estimatedSize(Buffer buffer) {
        return this.size;
    }
}
