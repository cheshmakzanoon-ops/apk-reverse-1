package net.aihelp.core.net.mqtt.hawtbuf.codec;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;

public class VarSignedIntegerCodec extends VarIntegerCodec {
    public static final VarSignedIntegerCodec INSTANCE = new VarSignedIntegerCodec();

    private static int decodeZigZag(int i) {
        return (-(i & 1)) ^ (i >>> 1);
    }

    private static int encodeZigZag(int i) {
        return (i >> 31) ^ (i << 1);
    }

    @Override
    public void encode(Integer num, DataOutput dataOutput) throws IOException {
        super.encode(Integer.valueOf(encodeZigZag(num.intValue())), dataOutput);
    }

    @Override
    public Integer decode(DataInput dataInput) throws IOException {
        return Integer.valueOf(decodeZigZag(super.decode(dataInput).intValue()));
    }

    @Override
    public int estimatedSize(Integer num) {
        return super.estimatedSize(Integer.valueOf(encodeZigZag(num.intValue())));
    }
}
