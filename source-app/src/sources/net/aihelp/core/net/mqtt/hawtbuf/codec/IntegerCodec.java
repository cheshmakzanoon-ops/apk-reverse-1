package net.aihelp.core.net.mqtt.hawtbuf.codec;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;

public class IntegerCodec implements Codec<Integer> {
    public static final IntegerCodec INSTANCE = new IntegerCodec();

    @Override
    public Integer deepCopy(Integer num) {
        return num;
    }

    @Override
    public int estimatedSize(Integer num) {
        return 4;
    }

    @Override
    public int getFixedSize() {
        return 4;
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
    public void encode(Integer num, DataOutput dataOutput) throws IOException {
        dataOutput.writeInt(num.intValue());
    }

    @Override
    public Integer decode(DataInput dataInput) throws IOException {
        return Integer.valueOf(dataInput.readInt());
    }
}
