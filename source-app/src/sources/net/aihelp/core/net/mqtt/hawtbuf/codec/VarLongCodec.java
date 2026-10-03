package net.aihelp.core.net.mqtt.hawtbuf.codec;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;
import java.net.ProtocolException;
import kotlin.jvm.internal.ByteCompanionObject;

public class VarLongCodec implements Codec<Long> {
    public static final VarLongCodec INSTANCE = new VarLongCodec();

    @Override
    public Long deepCopy(Long l) {
        return l;
    }

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
    public void encode(Long l, DataOutput dataOutput) throws IOException {
        long jLongValue = l.longValue();
        while (((-128) & jLongValue) != 0) {
            dataOutput.writeByte((((int) jLongValue) & 127) | 128);
            jLongValue >>>= 7;
        }
        dataOutput.writeByte((int) jLongValue);
    }

    @Override
    public Long decode(DataInput dataInput) throws IOException {
        long j = 0;
        for (int i = 0; i < 64; i += 7) {
            byte b = dataInput.readByte();
            j |= ((long) (b & 127)) << i;
            if ((b & ByteCompanionObject.MIN_VALUE) == 0) {
                return Long.valueOf(j);
            }
        }
        throw new ProtocolException("Encountered a malformed variable int");
    }

    @Override
    public int estimatedSize(Long l) {
        long jLongValue = l.longValue();
        if (((-128) & jLongValue) == 0) {
            return 1;
        }
        if (((-16384) & jLongValue) == 0) {
            return 2;
        }
        if (((-2097152) & jLongValue) == 0) {
            return 3;
        }
        if (((-268435456) & jLongValue) == 0) {
            return 4;
        }
        if (((-34359738368L) & jLongValue) == 0) {
            return 5;
        }
        if (((-4398046511104L) & jLongValue) == 0) {
            return 6;
        }
        if (((-562949953421312L) & jLongValue) == 0) {
            return 7;
        }
        if (((-72057594037927936L) & jLongValue) == 0) {
            return 8;
        }
        return (jLongValue & Long.MIN_VALUE) == 0 ? 9 : 10;
    }
}
