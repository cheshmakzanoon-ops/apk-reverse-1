package net.aihelp.core.net.mqtt.hawtbuf;

import java.io.OutputStream;

public class ByteArrayOutputStream extends OutputStream {
    byte[] buffer;
    int size;

    public ByteArrayOutputStream() {
        this(1028);
    }

    public ByteArrayOutputStream(int i) {
        this.buffer = new byte[i];
    }

    @Override
    public void write(int i) {
        int i2 = this.size + 1;
        checkCapacity(i2);
        this.buffer[this.size] = (byte) i;
        this.size = i2;
    }

    @Override
    public void write(byte[] bArr, int i, int i2) {
        int i3 = this.size + i2;
        checkCapacity(i3);
        System.arraycopy(bArr, i, this.buffer, this.size, i2);
        this.size = i3;
    }

    public void write(Buffer buffer) {
        write(buffer.data, buffer.offset, buffer.length);
    }

    private void checkCapacity(int i) {
        byte[] bArr = this.buffer;
        if (i > bArr.length) {
            byte[] bArr2 = new byte[Math.max(bArr.length << 1, i)];
            System.arraycopy(this.buffer, 0, bArr2, 0, this.size);
            this.buffer = bArr2;
        }
    }

    public void reset() {
        this.size = 0;
    }

    public Buffer toBuffer() {
        return new Buffer(this.buffer, 0, this.size);
    }

    public byte[] toByteArray() {
        return toBuffer().toByteArray();
    }

    public int size() {
        return this.size;
    }
}
