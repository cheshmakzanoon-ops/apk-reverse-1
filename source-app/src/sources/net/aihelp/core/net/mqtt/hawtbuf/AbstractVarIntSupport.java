package net.aihelp.core.net.mqtt.hawtbuf;

import java.io.IOException;
import java.net.ProtocolException;
import kotlin.jvm.internal.ByteCompanionObject;
import net.aihelp.core.net.mqtt.codec.DISCONNECT;

public abstract class AbstractVarIntSupport {
    public static int computeVarIntSize(int i) {
        if ((i & (-128)) == 0) {
            return 1;
        }
        if ((i & (-16384)) == 0) {
            return 2;
        }
        if (((-2097152) & i) == 0) {
            return 3;
        }
        return (i & (-268435456)) == 0 ? 4 : 5;
    }

    public static int computeVarLongSize(long j) {
        if (((-128) & j) == 0) {
            return 1;
        }
        if (((-16384) & j) == 0) {
            return 2;
        }
        if (((-2097152) & j) == 0) {
            return 3;
        }
        if (((-268435456) & j) == 0) {
            return 4;
        }
        if (((-34359738368L) & j) == 0) {
            return 5;
        }
        if (((-4398046511104L) & j) == 0) {
            return 6;
        }
        if (((-562949953421312L) & j) == 0) {
            return 7;
        }
        if (((-72057594037927936L) & j) == 0) {
            return 8;
        }
        return (j & Long.MIN_VALUE) == 0 ? 9 : 10;
    }

    private static int decodeZigZag32(int i) {
        return (-(i & 1)) ^ (i >>> 1);
    }

    private static long decodeZigZag64(long j) {
        return (-(j & 1)) ^ (j >>> 1);
    }

    private static int encodeZigZag32(int i) {
        return (i >> 31) ^ (i << 1);
    }

    private static long encodeZigZag64(long j) {
        return (j >> 63) ^ (j << 1);
    }

    protected abstract byte readByte() throws IOException;

    protected abstract void writeByte(int i) throws IOException;

    public int readVarInt() throws IOException {
        int i;
        byte b = readByte();
        if (b >= 0) {
            return b;
        }
        int i2 = b & 127;
        byte b2 = readByte();
        if (b2 >= 0) {
            i = b2 << 7;
        } else {
            i2 |= (b2 & 127) << 7;
            byte b3 = readByte();
            if (b3 >= 0) {
                i = b3 << DISCONNECT.TYPE;
            } else {
                i2 |= (b3 & 127) << 14;
                byte b4 = readByte();
                if (b4 < 0) {
                    int i3 = i2 | ((b4 & 127) << 21);
                    byte b5 = readByte();
                    int i4 = i3 | (b5 << 28);
                    if (b5 >= 0) {
                        return i4;
                    }
                    for (int i5 = 0; i5 < 5; i5++) {
                        if (readByte() >= 0) {
                            return i4;
                        }
                    }
                    throw new ProtocolException("Encountered a malformed variable int");
                }
                i = b4 << 21;
            }
        }
        return i2 | i;
    }

    public long readVarLong() throws IOException {
        long j = 0;
        for (int i = 0; i < 64; i += 7) {
            byte b = readByte();
            j |= ((long) (b & 127)) << i;
            if ((b & ByteCompanionObject.MIN_VALUE) == 0) {
                return j;
            }
        }
        throw new ProtocolException("Encountered a malformed variable int");
    }

    public int readVarSignedInt() throws IOException {
        return decodeZigZag32(readVarInt());
    }

    public long readVarSignedLong() throws IOException {
        return decodeZigZag64(readVarLong());
    }

    public void writeVarInt(int i) throws IOException {
        while ((i & (-128)) != 0) {
            writeByte((i & 127) | 128);
            i >>>= 7;
        }
        writeByte(i);
    }

    public void writeVarLong(long j) throws IOException {
        while (((-128) & j) != 0) {
            writeByte((((int) j) & 127) | 128);
            j >>>= 7;
        }
        writeByte((int) j);
    }

    public void writeVarSignedInt(int i) throws IOException {
        writeVarInt(encodeZigZag32(i));
    }

    public void writeVarSignedLong(long j) throws IOException {
        writeVarLong(encodeZigZag64(j));
    }

    public static int computeVarSignedIntSize(int i) {
        return computeVarIntSize(encodeZigZag32(i));
    }

    public static int computeVarSignedLongSize(long j) {
        return computeVarLongSize(encodeZigZag64(j));
    }
}
