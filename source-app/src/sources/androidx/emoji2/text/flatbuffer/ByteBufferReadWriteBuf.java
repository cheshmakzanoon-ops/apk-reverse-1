package androidx.emoji2.text.flatbuffer;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;

public class ByteBufferReadWriteBuf implements ReadWriteBuf {
    private final ByteBuffer buffer;

    public ByteBufferReadWriteBuf(ByteBuffer byteBuffer) {
        this.buffer = byteBuffer;
        byteBuffer.order(ByteOrder.LITTLE_ENDIAN);
    }

    @Override
    public boolean getBoolean(int i) {
        return get(i) != 0;
    }

    @Override
    public byte get(int i) {
        return this.buffer.get(i);
    }

    @Override
    public short getShort(int i) {
        return this.buffer.getShort(i);
    }

    @Override
    public int getInt(int i) {
        return this.buffer.getInt(i);
    }

    @Override
    public long getLong(int i) {
        return this.buffer.getLong(i);
    }

    @Override
    public float getFloat(int i) {
        return this.buffer.getFloat(i);
    }

    @Override
    public double getDouble(int i) {
        return this.buffer.getDouble(i);
    }

    @Override
    public String getString(int i, int i2) {
        return Utf8Safe.decodeUtf8Buffer(this.buffer, i, i2);
    }

    @Override
    public byte[] data() {
        return this.buffer.array();
    }

    @Override
    public void putBoolean(boolean z) {
        this.buffer.put(z ? (byte) 1 : (byte) 0);
    }

    @Override
    public void put(byte[] bArr, int i, int i2) {
        this.buffer.put(bArr, i, i2);
    }

    @Override
    public void put(byte b) {
        this.buffer.put(b);
    }

    @Override
    public void putShort(short s) {
        this.buffer.putShort(s);
    }

    @Override
    public void putInt(int i) {
        this.buffer.putInt(i);
    }

    @Override
    public void putLong(long j) {
        this.buffer.putLong(j);
    }

    @Override
    public void putFloat(float f) {
        this.buffer.putFloat(f);
    }

    @Override
    public void putDouble(double d) {
        this.buffer.putDouble(d);
    }

    @Override
    public void setBoolean(int i, boolean z) {
        set(i, z ? (byte) 1 : (byte) 0);
    }

    @Override
    public void set(int i, byte b) {
        requestCapacity(i + 1);
        this.buffer.put(i, b);
    }

    @Override
    public void set(int i, byte[] bArr, int i2, int i3) {
        requestCapacity((i3 - i2) + i);
        int iPosition = this.buffer.position();
        this.buffer.position(i);
        this.buffer.put(bArr, i2, i3);
        this.buffer.position(iPosition);
    }

    @Override
    public void setShort(int i, short s) {
        requestCapacity(i + 2);
        this.buffer.putShort(i, s);
    }

    @Override
    public void setInt(int i, int i2) {
        requestCapacity(i + 4);
        this.buffer.putInt(i, i2);
    }

    @Override
    public void setLong(int i, long j) {
        requestCapacity(i + 8);
        this.buffer.putLong(i, j);
    }

    @Override
    public void setFloat(int i, float f) {
        requestCapacity(i + 4);
        this.buffer.putFloat(i, f);
    }

    @Override
    public void setDouble(int i, double d) {
        requestCapacity(i + 8);
        this.buffer.putDouble(i, d);
    }

    @Override
    public int writePosition() {
        return this.buffer.position();
    }

    @Override
    public int limit() {
        return this.buffer.limit();
    }

    @Override
    public boolean requestCapacity(int i) {
        return i <= this.buffer.limit();
    }
}
