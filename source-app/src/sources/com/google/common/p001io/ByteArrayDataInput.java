package com.google.common.p001io;

import java.io.DataInput;
import javax.annotation.CheckForNull;

@ElementTypesAreNonnullByDefault
public interface ByteArrayDataInput extends DataInput {
    @Override
    boolean readBoolean();

    @Override
    byte readByte();

    @Override
    char readChar();

    @Override
    double readDouble();

    @Override
    float readFloat();

    @Override
    void readFully(byte[] bArr);

    @Override
    void readFully(byte[] bArr, int i, int i2);

    @Override
    int readInt();

    @Override
    @CheckForNull
    String readLine();

    @Override
    long readLong();

    @Override
    short readShort();

    @Override
    String readUTF();

    @Override
    int readUnsignedByte();

    @Override
    int readUnsignedShort();

    @Override
    int skipBytes(int i);
}
