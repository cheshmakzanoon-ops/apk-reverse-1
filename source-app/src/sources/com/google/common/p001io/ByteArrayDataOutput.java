package com.google.common.p001io;

import java.io.DataOutput;

@ElementTypesAreNonnullByDefault
public interface ByteArrayDataOutput extends DataOutput {
    byte[] toByteArray();

    @Override
    void write(int i);

    @Override
    void write(byte[] bArr);

    @Override
    void write(byte[] bArr, int i, int i2);

    @Override
    void writeBoolean(boolean z);

    @Override
    void writeByte(int i);

    @Override
    @Deprecated
    void writeBytes(String str);

    @Override
    void writeChar(int i);

    @Override
    void writeChars(String str);

    @Override
    void writeDouble(double d);

    @Override
    void writeFloat(float f);

    @Override
    void writeInt(int i);

    @Override
    void writeLong(long j);

    @Override
    void writeShort(int i);

    @Override
    void writeUTF(String str);
}
