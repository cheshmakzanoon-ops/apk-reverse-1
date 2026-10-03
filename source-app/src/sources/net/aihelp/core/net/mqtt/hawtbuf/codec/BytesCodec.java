package net.aihelp.core.net.mqtt.hawtbuf.codec;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;

public class BytesCodec implements Codec<byte[]> {
    public static final BytesCodec INSTANCE = new BytesCodec();

    @Override
    public int getFixedSize() {
        return -1;
    }

    @Override
    public boolean isDeepCopySupported() {
        return true;
    }

    @Override
    public boolean isEstimatedSizeSupported() {
        return true;
    }

    @Override
    public void encode(byte[] bArr, DataOutput dataOutput) throws IOException {
        dataOutput.writeInt(bArr.length);
        dataOutput.write(bArr);
    }

    @Override
    public byte[] decode(DataInput dataInput) throws IOException {
        byte[] bArr = new byte[dataInput.readInt()];
        dataInput.readFully(bArr);
        return bArr;
    }

    @Override
    public byte[] deepCopy(byte[] bArr) {
        byte[] bArr2 = new byte[bArr.length];
        System.arraycopy(bArr, 0, bArr2, 0, bArr.length);
        return bArr2;
    }

    @Override
    public int estimatedSize(byte[] bArr) {
        return bArr.length + 4;
    }
}
