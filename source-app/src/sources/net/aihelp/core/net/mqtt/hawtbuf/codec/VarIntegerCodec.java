package net.aihelp.core.net.mqtt.hawtbuf.codec;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;
import java.net.ProtocolException;
import net.aihelp.core.net.mqtt.codec.DISCONNECT;

public class VarIntegerCodec implements Codec<Integer> {
    public static final VarIntegerCodec INSTANCE = new VarIntegerCodec();

    @Override
    public Integer deepCopy(Integer num) {
        return num;
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
    public void encode(Integer num, DataOutput dataOutput) throws IOException {
        int iIntValue = num.intValue();
        while ((iIntValue & (-128)) != 0) {
            dataOutput.writeByte((iIntValue & 127) | 128);
            iIntValue >>>= 7;
        }
        dataOutput.writeByte(iIntValue);
    }

    @Override
    public Integer decode(DataInput dataInput) throws IOException {
        int i;
        int i2;
        byte b = dataInput.readByte();
        if (b >= 0) {
            return Integer.valueOf(b);
        }
        int i3 = b & 127;
        byte b2 = dataInput.readByte();
        if (b2 >= 0) {
            i2 = b2 << 7;
        } else {
            i3 |= (b2 & 127) << 7;
            byte b3 = dataInput.readByte();
            if (b3 < 0) {
                i3 |= (b3 & 127) << 14;
                byte b4 = dataInput.readByte();
                if (b4 >= 0) {
                    i2 = b4 << 21;
                } else {
                    int i4 = i3 | ((b4 & 127) << 21);
                    byte b5 = dataInput.readByte();
                    int i5 = i4 | (b5 << 28);
                    if (b5 < 0) {
                        for (int i6 = 0; i6 < 5; i6++) {
                            if (dataInput.readByte() >= 0) {
                                return Integer.valueOf(i5);
                            }
                        }
                        throw new ProtocolException("Encountered a malformed variable int");
                    }
                    i = i5;
                }
                return Integer.valueOf(i);
            }
            i2 = b3 << DISCONNECT.TYPE;
        }
        i = i2 | i3;
        return Integer.valueOf(i);
    }

    @Override
    public int estimatedSize(Integer num) {
        int iIntValue = num.intValue();
        if ((iIntValue & (-128)) == 0) {
            return 1;
        }
        if ((iIntValue & (-16384)) == 0) {
            return 2;
        }
        if (((-2097152) & iIntValue) == 0) {
            return 3;
        }
        return (iIntValue & (-268435456)) == 0 ? 4 : 5;
    }
}
