package net.aihelp.core.net.mqtt.hawtbuf.codec;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;

public class VarSignedLongCodec extends VarLongCodec {
    public static final VarSignedLongCodec INSTANCE = new VarSignedLongCodec();

    private static long decodeZigZag(long j) {
        return (-(j & 1)) ^ (j >>> 1);
    }

    private static long encodeZigZag(long j) {
        return (j >> 63) ^ (j << 1);
    }

    @Override
    public void encode(Long l, DataOutput dataOutput) throws IOException {
        super.encode(Long.valueOf(encodeZigZag(l.longValue())), dataOutput);
    }

    @Override
    public Long decode(DataInput dataInput) throws IOException {
        return Long.valueOf(decodeZigZag(super.decode(dataInput).longValue()));
    }

    @Override
    public int estimatedSize(Long l) {
        return super.estimatedSize(Long.valueOf(encodeZigZag(l.longValue())));
    }
}
