package net.aihelp.core.net.mqtt.hawtbuf;

import java.io.IOException;
import java.io.InputStream;
import kotlin.UByte;

public class ByteArrayInputStream extends InputStream {
    byte[] buffer;
    int limit;
    int mark;
    int pos;

    @Override
    public boolean markSupported() {
        return true;
    }

    public ByteArrayInputStream(byte[] bArr) {
        this(bArr, 0, bArr.length);
    }

    public ByteArrayInputStream(Buffer buffer) {
        this(buffer.getData(), buffer.getOffset(), buffer.getLength());
    }

    public ByteArrayInputStream(byte[] bArr, int i, int i2) {
        this.buffer = bArr;
        this.mark = i;
        this.pos = i;
        this.limit = i + i2;
    }

    @Override
    public int read() throws IOException {
        int i = this.pos;
        if (i >= this.limit) {
            return -1;
        }
        byte[] bArr = this.buffer;
        this.pos = i + 1;
        return bArr[i] & UByte.MAX_VALUE;
    }

    @Override
    public int read(byte[] bArr) throws IOException {
        return read(bArr, 0, bArr.length);
    }

    @Override
    public int read(byte[] bArr, int i, int i2) {
        int i3 = this.pos;
        int i4 = this.limit;
        if (i3 >= i4) {
            return -1;
        }
        int iMin = Math.min(i2, i4 - i3);
        if (iMin > 0) {
            System.arraycopy(this.buffer, this.pos, bArr, i, iMin);
            this.pos += iMin;
        }
        return iMin;
    }

    @Override
    public long skip(long j) throws IOException {
        int i = this.pos;
        int i2 = this.limit;
        if (i >= i2) {
            return -1L;
        }
        long jMin = Math.min(j, i2 - i);
        if (jMin > 0) {
            this.pos = (int) (((long) this.pos) + jMin);
        }
        return jMin;
    }

    @Override
    public int available() {
        return this.limit - this.pos;
    }

    @Override
    public void mark(int i) {
        this.mark = this.pos;
    }

    @Override
    public void reset() {
        this.pos = this.mark;
    }
}
