package net.aihelp.core.net.mqtt.hawtbuf;

import java.io.DataOutput;
import java.io.IOException;
import java.io.OutputStream;
import java.io.UTFDataFormatException;

public class DataByteArrayOutputStream extends OutputStream implements DataOutput {
    private static final int DEFAULT_SIZE = 2048;
    protected byte[] buf;
    protected AbstractVarIntSupport helper;
    protected int pos;

    protected void onWrite() throws IOException {
    }

    public DataByteArrayOutputStream(int i) {
        this.helper = new AbstractVarIntSupport() {
            @Override
            protected byte readByte() {
                throw new UnsupportedOperationException();
            }

            @Override
            protected void writeByte(int i2) throws IOException {
                DataByteArrayOutputStream.this.writeByte(i2);
            }
        };
        if (i <= 0) {
            throw new IllegalArgumentException("Invalid size: " + i);
        }
        this.buf = new byte[i];
    }

    public DataByteArrayOutputStream(byte[] bArr) {
        this.helper = new AbstractVarIntSupport() {
            @Override
            protected byte readByte() {
                throw new UnsupportedOperationException();
            }

            @Override
            protected void writeByte(int i2) throws IOException {
                DataByteArrayOutputStream.this.writeByte(i2);
            }
        };
        if (bArr == null || bArr.length == 0) {
            throw new IllegalArgumentException("Invalid buffer");
        }
        this.buf = bArr;
    }

    public DataByteArrayOutputStream() {
        this(DEFAULT_SIZE);
    }

    public void restart(int i) {
        this.buf = new byte[i];
        this.pos = 0;
    }

    public void restart() {
        restart(DEFAULT_SIZE);
    }

    public Buffer toBuffer() {
        return new Buffer(this.buf, 0, this.pos);
    }

    @Override
    public void write(int i) throws IOException {
        int i2 = this.pos + 1;
        ensureEnoughBuffer(i2);
        this.buf[this.pos] = (byte) i;
        this.pos = i2;
        onWrite();
    }

    public void write(Buffer buffer) throws IOException {
        write(buffer.data, buffer.offset, buffer.length);
    }

    @Override
    public void write(byte[] bArr, int i, int i2) throws IOException {
        if (i2 == 0) {
            return;
        }
        int i3 = this.pos + i2;
        ensureEnoughBuffer(i3);
        System.arraycopy(bArr, i, this.buf, this.pos, i2);
        this.pos = i3;
        onWrite();
    }

    public byte[] getData() {
        return this.buf;
    }

    public void reset() {
        this.pos = 0;
    }

    public void position(int i) throws IOException {
        ensureEnoughBuffer(i);
        this.pos = i;
        onWrite();
    }

    public int position() {
        return this.pos;
    }

    public int size() {
        return this.pos;
    }

    @Override
    public void writeBoolean(boolean z) throws IOException {
        ensureEnoughBuffer(this.pos + 1);
        byte[] bArr = this.buf;
        int i = this.pos;
        this.pos = i + 1;
        bArr[i] = z ? (byte) 1 : (byte) 0;
        onWrite();
    }

    @Override
    public void writeByte(int i) throws IOException {
        ensureEnoughBuffer(this.pos + 1);
        byte[] bArr = this.buf;
        int i2 = this.pos;
        this.pos = i2 + 1;
        bArr[i2] = (byte) i;
        onWrite();
    }

    @Override
    public void writeShort(int i) throws IOException {
        ensureEnoughBuffer(this.pos + 2);
        byte[] bArr = this.buf;
        int i2 = this.pos;
        int i3 = i2 + 1;
        this.pos = i3;
        bArr[i2] = (byte) (i >>> 8);
        this.pos = i2 + 2;
        bArr[i3] = (byte) i;
        onWrite();
    }

    @Override
    public void writeChar(int i) throws IOException {
        ensureEnoughBuffer(this.pos + 2);
        byte[] bArr = this.buf;
        int i2 = this.pos;
        int i3 = i2 + 1;
        this.pos = i3;
        bArr[i2] = (byte) (i >>> 8);
        this.pos = i2 + 2;
        bArr[i3] = (byte) i;
        onWrite();
    }

    @Override
    public void writeInt(int i) throws IOException {
        ensureEnoughBuffer(this.pos + 4);
        byte[] bArr = this.buf;
        int i2 = this.pos;
        int i3 = i2 + 1;
        this.pos = i3;
        bArr[i2] = (byte) (i >>> 24);
        int i4 = i2 + 2;
        this.pos = i4;
        bArr[i3] = (byte) (i >>> 16);
        int i5 = i2 + 3;
        this.pos = i5;
        bArr[i4] = (byte) (i >>> 8);
        this.pos = i2 + 4;
        bArr[i5] = (byte) i;
        onWrite();
    }

    @Override
    public void writeLong(long j) throws IOException {
        ensureEnoughBuffer(this.pos + 8);
        byte[] bArr = this.buf;
        int i = this.pos;
        int i2 = i + 1;
        this.pos = i2;
        bArr[i] = (byte) (j >>> 56);
        int i3 = i + 2;
        this.pos = i3;
        bArr[i2] = (byte) (j >>> 48);
        int i4 = i + 3;
        this.pos = i4;
        bArr[i3] = (byte) (j >>> 40);
        int i5 = i + 4;
        this.pos = i5;
        bArr[i4] = (byte) (j >>> 32);
        int i6 = i + 5;
        this.pos = i6;
        bArr[i5] = (byte) (j >>> 24);
        int i7 = i + 6;
        this.pos = i7;
        bArr[i6] = (byte) (j >>> 16);
        int i8 = i + 7;
        this.pos = i8;
        bArr[i7] = (byte) (j >>> 8);
        this.pos = i + 8;
        bArr[i8] = (byte) j;
        onWrite();
    }

    @Override
    public void writeFloat(float f) throws IOException {
        writeInt(Float.floatToIntBits(f));
    }

    @Override
    public void writeDouble(double d) throws IOException {
        writeLong(Double.doubleToLongBits(d));
    }

    @Override
    public void writeBytes(String str) throws IOException {
        int length = str.length();
        for (int i = 0; i < length; i++) {
            write((byte) str.charAt(i));
        }
    }

    @Override
    public void writeChars(String str) throws IOException {
        int length = str.length();
        for (int i = 0; i < length; i++) {
            char cCharAt = str.charAt(i);
            write((cCharAt >>> '\b') & 255);
            write(cCharAt & 255);
        }
    }

    @Override
    public void writeUTF(String str) throws IOException {
        int length = str.length();
        int i = 0;
        int i2 = 0;
        for (int i3 = 0; i3 < length; i3++) {
            char cCharAt = str.charAt(i3);
            i2 = (cCharAt < 1 || cCharAt > 127) ? cCharAt > 2047 ? i2 + 3 : i2 + 2 : i2 + 1;
        }
        if (i2 > 65535) {
            throw new UTFDataFormatException("encoded string too long: " + i2 + " bytes");
        }
        ensureEnoughBuffer(this.pos + i2 + 2);
        writeShort(i2);
        while (i < length) {
            char cCharAt2 = str.charAt(i);
            if (cCharAt2 < 1 || cCharAt2 > 127) {
                break;
            }
            byte[] bArr = this.buf;
            int i4 = this.pos;
            this.pos = i4 + 1;
            bArr[i4] = (byte) cCharAt2;
            i++;
        }
        while (i < length) {
            char cCharAt3 = str.charAt(i);
            if (cCharAt3 >= 1 && cCharAt3 <= 127) {
                byte[] bArr2 = this.buf;
                int i5 = this.pos;
                this.pos = i5 + 1;
                bArr2[i5] = (byte) cCharAt3;
            } else if (cCharAt3 > 2047) {
                byte[] bArr3 = this.buf;
                int i6 = this.pos;
                int i7 = i6 + 1;
                this.pos = i7;
                bArr3[i6] = (byte) (((cCharAt3 >> '\f') & 15) | 224);
                int i8 = i6 + 2;
                this.pos = i8;
                bArr3[i7] = (byte) (((cCharAt3 >> 6) & 63) | 128);
                this.pos = i6 + 3;
                bArr3[i8] = (byte) ((cCharAt3 & '?') | 128);
            } else {
                byte[] bArr4 = this.buf;
                int i9 = this.pos;
                int i10 = i9 + 1;
                this.pos = i10;
                bArr4[i9] = (byte) (((cCharAt3 >> 6) & 31) | 192);
                this.pos = i9 + 2;
                bArr4[i10] = (byte) ((cCharAt3 & '?') | 128);
            }
            i++;
        }
        onWrite();
    }

    private void ensureEnoughBuffer(int i) {
        if (i > this.buf.length) {
            resize(i);
        }
    }

    protected void resize(int i) {
        byte[] bArr = new byte[Math.max(this.buf.length << 1, i)];
        System.arraycopy(this.buf, 0, bArr, 0, this.pos);
        this.buf = bArr;
    }

    public void skip(int i) throws IOException {
        ensureEnoughBuffer(this.pos + i);
        this.pos += i;
        onWrite();
    }

    public void writeVarInt(int i) throws IOException {
        this.helper.writeVarInt(i);
    }

    public void writeVarLong(long j) throws IOException {
        this.helper.writeVarLong(j);
    }

    public void writeVarSignedInt(int i) throws IOException {
        this.helper.writeVarSignedInt(i);
    }

    public void writeVarSignedLong(long j) throws IOException {
        this.helper.writeVarSignedLong(j);
    }
}
