package net.aihelp.core.net.mqtt.hawtbuf;

import java.io.EOFException;
import java.io.IOException;
import java.io.OutputStream;

public final class BufferOutputStream extends OutputStream {
    byte[] buffer;
    int limit;
    int offset;
    int pos;

    public BufferOutputStream(int i) {
        this(new byte[i]);
    }

    public BufferOutputStream(byte[] bArr) {
        this.buffer = bArr;
        this.limit = bArr.length;
    }

    public BufferOutputStream(Buffer buffer) {
        this.buffer = buffer.data;
        int i = buffer.offset;
        this.offset = i;
        this.pos = i;
        this.limit = buffer.offset + buffer.length;
    }

    @Override
    public void write(int i) throws IOException {
        int i2 = this.pos + 1;
        checkCapacity(i2);
        this.buffer[this.pos] = (byte) i;
        this.pos = i2;
    }

    @Override
    public void write(byte[] bArr, int i, int i2) throws IOException {
        int i3 = this.pos + i2;
        checkCapacity(i3);
        System.arraycopy(bArr, i, this.buffer, this.pos, i2);
        this.pos = i3;
    }

    public Buffer getNextBuffer(int i) throws IOException {
        checkCapacity(this.pos + i);
        return new Buffer(this.buffer, this.pos, i);
    }

    private void checkCapacity(int i) throws IOException {
        if (i > this.limit) {
            throw new EOFException("Buffer limit reached.");
        }
    }

    public void reset() {
        this.pos = this.offset;
    }

    public Buffer toBuffer() {
        return new Buffer(this.buffer, this.offset, this.pos);
    }

    public byte[] toByteArray() {
        return toBuffer().toByteArray();
    }

    public int size() {
        return this.offset - this.pos;
    }
}
