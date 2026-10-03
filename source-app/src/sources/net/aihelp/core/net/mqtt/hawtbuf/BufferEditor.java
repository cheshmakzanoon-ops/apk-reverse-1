package net.aihelp.core.net.mqtt.hawtbuf;

import kotlin.UByte;

public abstract class BufferEditor extends AbstractVarIntSupport {
    protected final Buffer buffer;

    public abstract char readChar();

    public abstract double readDouble();

    public abstract float readFloat();

    public abstract int readInt();

    public abstract long readLong();

    public abstract short readShort();

    public abstract int readUnsignedShort();

    public abstract void writeChar(int i);

    public abstract void writeDouble(double d);

    public abstract void writeFloat(float f);

    public abstract void writeInt(int i);

    public abstract void writeLong(long j);

    public abstract void writeRawDouble(double d);

    public abstract void writeRawFloat(float f);

    public abstract void writeShort(int i);

    private BufferEditor(Buffer buffer) {
        this.buffer = buffer;
    }

    protected boolean hasCapacity(int i) {
        return this.buffer.length >= i;
    }

    public int read() {
        this.buffer.length--;
        byte[] bArr = this.buffer.data;
        Buffer buffer = this.buffer;
        int i = buffer.offset;
        buffer.offset = i + 1;
        return bArr[i] & UByte.MAX_VALUE;
    }

    public void readFully(byte[] bArr) {
        readFully(bArr, 0, bArr.length);
    }

    public void readFully(byte[] bArr, int i, int i2) {
        System.arraycopy(this.buffer.data, this.buffer.offset, bArr, i, i2);
        this.buffer.offset += i2;
        this.buffer.length -= i2;
    }

    public int skipBytes(int i) {
        int iMin = Math.min(i, this.buffer.length);
        this.buffer.offset += iMin;
        this.buffer.length -= iMin;
        return iMin;
    }

    public boolean readBoolean() {
        return read() != 0;
    }

    @Override
    public byte readByte() {
        return (byte) read();
    }

    public int readUnsignedByte() {
        return read();
    }

    public void write(int i) {
        byte[] bArr = this.buffer.data;
        Buffer buffer = this.buffer;
        int i2 = buffer.offset;
        buffer.offset = i2 + 1;
        bArr[i2] = (byte) i;
        this.buffer.length--;
    }

    public void write(byte[] bArr) {
        write(bArr, 0, bArr.length);
    }

    public void write(byte[] bArr, int i, int i2) {
        System.arraycopy(bArr, i, this.buffer.data, this.buffer.offset, i2);
        this.buffer.offset += i2;
        this.buffer.length -= i2;
    }

    public void writeBoolean(boolean z) {
        write(z ? 1 : 0);
    }

    @Override
    public void writeByte(int i) {
        write(i);
    }

    public static BufferEditor big(Buffer buffer) {
        return new BigEndianBufferEditor(buffer);
    }

    public static BufferEditor little(Buffer buffer) {
        return new LittleEndianBufferEditor(buffer);
    }

    static class BigEndianBufferEditor extends BufferEditor {
        BigEndianBufferEditor(Buffer buffer) {
            super(buffer);
        }

        @Override
        public short readShort() {
            return (short) ((read() << 8) + read());
        }

        @Override
        public int readUnsignedShort() {
            return (read() << 8) + read();
        }

        @Override
        public char readChar() {
            return (char) ((read() << 8) + read());
        }

        @Override
        public int readInt() {
            return (read() << 24) + (read() << 16) + (read() << 8) + read();
        }

        @Override
        public long readLong() {
            return (((long) read()) << 56) + (((long) read()) << 48) + (((long) read()) << 40) + (((long) read()) << 32) + (((long) read()) << 24) + ((long) (read() << 16)) + ((long) (read() << 8)) + ((long) read());
        }

        @Override
        public double readDouble() {
            return Double.longBitsToDouble(readLong());
        }

        @Override
        public float readFloat() {
            return Float.intBitsToFloat(readInt());
        }

        @Override
        public void writeShort(int i) {
            write((i >>> 8) & 255);
            write(i & 255);
        }

        @Override
        public void writeChar(int i) {
            write((i >>> 8) & 255);
            write(i & 255);
        }

        @Override
        public void writeInt(int i) {
            write((i >>> 24) & 255);
            write((i >>> 16) & 255);
            write((i >>> 8) & 255);
            write(i & 255);
        }

        @Override
        public void writeLong(long j) {
            write(((int) (j >>> 56)) & 255);
            write(((int) (j >>> 48)) & 255);
            write(((int) (j >>> 40)) & 255);
            write(((int) (j >>> 32)) & 255);
            write(((int) (j >>> 24)) & 255);
            write(((int) (j >>> 16)) & 255);
            write(((int) (j >>> 8)) & 255);
            write(((int) j) & 255);
        }

        @Override
        public void writeDouble(double d) {
            writeLong(Double.doubleToLongBits(d));
        }

        @Override
        public void writeFloat(float f) {
            writeInt(Float.floatToIntBits(f));
        }

        @Override
        public void writeRawDouble(double d) {
            writeLong(Double.doubleToRawLongBits(d));
        }

        @Override
        public void writeRawFloat(float f) {
            writeInt(Float.floatToRawIntBits(f));
        }
    }

    static class LittleEndianBufferEditor extends BufferEditor {
        LittleEndianBufferEditor(Buffer buffer) {
            super(buffer);
        }

        @Override
        public short readShort() {
            return (short) (read() + (read() << 8));
        }

        @Override
        public int readUnsignedShort() {
            return read() + (read() << 8);
        }

        @Override
        public char readChar() {
            return (char) (read() + (read() << 8));
        }

        @Override
        public int readInt() {
            return read() + (read() << 8) + (read() << 16) + (read() << 24);
        }

        @Override
        public long readLong() {
            return ((long) (read() + (read() << 8) + (read() << 16))) + (((long) read()) << 24) + (((long) read()) << 32) + (((long) read()) << 40) + (((long) read()) << 48) + (((long) read()) << 56);
        }

        @Override
        public double readDouble() {
            return Double.longBitsToDouble(readLong());
        }

        @Override
        public float readFloat() {
            return Float.intBitsToFloat(readInt());
        }

        @Override
        public void writeShort(int i) {
            write(i & 255);
            write((i >>> 8) & 255);
        }

        @Override
        public void writeChar(int i) {
            write(i & 255);
            write((i >>> 8) & 255);
        }

        @Override
        public void writeInt(int i) {
            write(i & 255);
            write((i >>> 8) & 255);
            write((i >>> 16) & 255);
            write((i >>> 24) & 255);
        }

        @Override
        public void writeLong(long j) {
            write(((int) j) & 255);
            write(((int) (j >>> 8)) & 255);
            write(((int) (j >>> 16)) & 255);
            write(((int) (j >>> 24)) & 255);
            write(((int) (j >>> 32)) & 255);
            write(((int) (j >>> 40)) & 255);
            write(((int) (j >>> 48)) & 255);
            write(((int) (j >>> 56)) & 255);
        }

        @Override
        public void writeDouble(double d) {
            writeLong(Double.doubleToLongBits(d));
        }

        @Override
        public void writeFloat(float f) {
            writeInt(Float.floatToIntBits(f));
        }

        @Override
        public void writeRawDouble(double d) {
            writeLong(Double.doubleToRawLongBits(d));
        }

        @Override
        public void writeRawFloat(float f) {
            writeInt(Float.floatToRawIntBits(f));
        }
    }
}
