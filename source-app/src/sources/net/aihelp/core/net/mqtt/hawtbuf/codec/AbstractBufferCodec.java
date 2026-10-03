package net.aihelp.core.net.mqtt.hawtbuf.codec;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;
import net.aihelp.core.net.mqtt.hawtbuf.Buffer;

public abstract class AbstractBufferCodec<T extends Buffer> extends VariableCodec<T> {
    protected abstract T createBuffer(byte[] bArr);

    @Override
    public boolean isDeepCopySupported() {
        return true;
    }

    @Override
    public boolean isEstimatedSizeSupported() {
        return true;
    }

    @Override
    public void encode(T t, DataOutput dataOutput) throws IOException {
        dataOutput.writeInt(t.length);
        dataOutput.write(t.data, t.offset, t.length);
    }

    @Override
    public T decode(DataInput dataInput) throws IOException {
        byte[] bArr = new byte[dataInput.readInt()];
        dataInput.readFully(bArr);
        return (T) createBuffer(bArr);
    }

    @Override
    public T deepCopy(T t) {
        return (T) createBuffer(t.deepCopy().data);
    }

    @Override
    public int estimatedSize(T t) {
        return t.length + 4;
    }
}
