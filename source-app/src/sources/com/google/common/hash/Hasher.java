package com.google.common.hash;

import java.nio.ByteBuffer;
import java.nio.charset.Charset;

@ElementTypesAreNonnullByDefault
public interface Hasher extends PrimitiveSink {
    HashCode hash();

    @Deprecated
    int hashCode();

    @Override
    Hasher putBoolean(boolean z);

    @Override
    Hasher putByte(byte b);

    @Override
    Hasher putBytes(ByteBuffer byteBuffer);

    @Override
    Hasher putBytes(byte[] bArr);

    @Override
    Hasher putBytes(byte[] bArr, int i, int i2);

    @Override
    Hasher putChar(char c);

    @Override
    Hasher putDouble(double d);

    @Override
    Hasher putFloat(float f);

    @Override
    Hasher putInt(int i);

    @Override
    Hasher putLong(long j);

    <T> Hasher putObject(@ParametricNullness T t, Funnel<? super T> funnel);

    @Override
    Hasher putShort(short s);

    @Override
    Hasher putString(CharSequence charSequence, Charset charset);

    @Override
    Hasher putUnencodedChars(CharSequence charSequence);

    public final class CC {
    }
}
