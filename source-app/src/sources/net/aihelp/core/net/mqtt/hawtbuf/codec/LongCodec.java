package net.aihelp.core.net.mqtt.hawtbuf.codec;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;

public class LongCodec implements Codec<Long> {
    public static final LongCodec INSTANCE = new LongCodec();

    @Override
    public Long deepCopy(Long l) {
        return l;
    }

    @Override
    public int estimatedSize(Long l) {
        return 8;
    }

    @Override
    public int getFixedSize() {
        return 8;
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
    public void encode(Long l, DataOutput dataOutput) throws IOException {
        dataOutput.writeLong(l.longValue());
    }

    @Override
    public Long decode(DataInput dataInput) throws IOException {
        return Long.valueOf(dataInput.readLong());
    }
}
