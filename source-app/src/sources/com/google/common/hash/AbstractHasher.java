package com.google.common.hash;

import com.google.common.base.Preconditions;
import java.nio.ByteBuffer;
import java.nio.charset.Charset;

@ElementTypesAreNonnullByDefault
abstract class AbstractHasher implements Hasher {
    @Override
    public PrimitiveSink putByte(byte b) {
        return putByte(b);
    }

    AbstractHasher() {
    }

    @Override
    public final Hasher putBoolean(boolean z) {
        return putByte(z ? (byte) 1 : (byte) 0);
    }

    @Override
    public final Hasher putDouble(double d) {
        return putLong(Double.doubleToRawLongBits(d));
    }

    @Override
    public final Hasher putFloat(float f) {
        return putInt(Float.floatToRawIntBits(f));
    }

    @Override
    public Hasher putUnencodedChars(CharSequence charSequence) {
        int length = charSequence.length();
        for (int i = 0; i < length; i++) {
            putChar(charSequence.charAt(i));
        }
        return this;
    }

    @Override
    public Hasher putString(CharSequence charSequence, Charset charset) {
        return putBytes(charSequence.toString().getBytes(charset));
    }

    @Override
    public Hasher putBytes(byte[] bArr) {
        return putBytes(bArr, 0, bArr.length);
    }

    @Override
    public Hasher putBytes(byte[] bArr, int i, int i2) {
        Preconditions.checkPositionIndexes(i, i + i2, bArr.length);
        for (int i3 = 0; i3 < i2; i3++) {
            putByte(bArr[i + i3]);
        }
        return this;
    }

    @Override
    public Hasher putBytes(ByteBuffer byteBuffer) {
        if (byteBuffer.hasArray()) {
            putBytes(byteBuffer.array(), byteBuffer.arrayOffset() + byteBuffer.position(), byteBuffer.remaining());
            Java8Compatibility.position(byteBuffer, byteBuffer.limit());
        } else {
            for (int iRemaining = byteBuffer.remaining(); iRemaining > 0; iRemaining--) {
                putByte(byteBuffer.get());
            }
        }
        return this;
    }

    @Override
    public Hasher putShort(short s) {
        putByte((byte) s);
        putByte((byte) (s >>> 8));
        return this;
    }

    @Override
    public Hasher putInt(int i) {
        putByte((byte) i);
        putByte((byte) (i >>> 8));
        putByte((byte) (i >>> 16));
        putByte((byte) (i >>> 24));
        return this;
    }

    @Override
    public Hasher putLong(long j) {
        for (int i = 0; i < 64; i += 8) {
            putByte((byte) (j >>> i));
        }
        return this;
    }

    @Override
    public Hasher putChar(char c) {
        putByte((byte) c);
        putByte((byte) (c >>> '\b'));
        return this;
    }

    @Override
    public <T> Hasher putObject(@ParametricNullness T t, Funnel<? super T> funnel) {
        funnel.funnel(t, this);
        return this;
    }
}
