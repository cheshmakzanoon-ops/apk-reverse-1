package cz.msebera.android.httpclient.impl.p000io;

import cz.msebera.android.httpclient.ConnectionClosedException;
import cz.msebera.android.httpclient.p001io.BufferInfo;
import cz.msebera.android.httpclient.p001io.SessionInputBuffer;
import cz.msebera.android.httpclient.util.Args;
import java.io.IOException;
import java.io.InputStream;

public class ContentLengthInputStream extends InputStream {
    private static final int BUFFER_SIZE = 2048;
    private final long contentLength;

    private SessionInputBuffer f25in;
    private long pos = 0;
    private boolean closed = false;

    public ContentLengthInputStream(SessionInputBuffer sessionInputBuffer, long j) {
        this.f25in = null;
        this.f25in = (SessionInputBuffer) Args.notNull(sessionInputBuffer, "Session input buffer");
        this.contentLength = Args.notNegative(j, "Content length");
    }

    @Override
    public void close() throws IOException {
        if (this.closed) {
            return;
        }
        try {
            if (this.pos < this.contentLength) {
                do {
                } while (read(new byte[BUFFER_SIZE]) >= 0);
            }
        } finally {
            this.closed = true;
        }
    }

    @Override
    public int available() throws IOException {
        SessionInputBuffer sessionInputBuffer = this.f25in;
        if (sessionInputBuffer instanceof BufferInfo) {
            return Math.min(((BufferInfo) sessionInputBuffer).length(), (int) (this.contentLength - this.pos));
        }
        return 0;
    }

    @Override
    public int read() throws IOException {
        if (this.closed) {
            throw new IOException("Attempted read from closed stream.");
        }
        if (this.pos >= this.contentLength) {
            return -1;
        }
        int i = this.f25in.read();
        if (i != -1) {
            this.pos++;
        } else if (this.pos < this.contentLength) {
            throw new ConnectionClosedException("Premature end of Content-Length delimited message body (expected: " + this.contentLength + "; received: " + this.pos);
        }
        return i;
    }

    @Override
    public int read(byte[] bArr, int i, int i2) throws IOException {
        if (this.closed) {
            throw new IOException("Attempted read from closed stream.");
        }
        long j = this.pos;
        long j2 = this.contentLength;
        if (j >= j2) {
            return -1;
        }
        if (((long) i2) + j > j2) {
            i2 = (int) (j2 - j);
        }
        int i3 = this.f25in.read(bArr, i, i2);
        if (i3 != -1 || this.pos >= this.contentLength) {
            if (i3 > 0) {
                this.pos += (long) i3;
            }
            return i3;
        }
        throw new ConnectionClosedException("Premature end of Content-Length delimited message body (expected: " + this.contentLength + "; received: " + this.pos);
    }

    @Override
    public int read(byte[] bArr) throws IOException {
        return read(bArr, 0, bArr.length);
    }

    @Override
    public long skip(long j) throws IOException {
        int i;
        if (j <= 0) {
            return 0L;
        }
        byte[] bArr = new byte[BUFFER_SIZE];
        long jMin = Math.min(j, this.contentLength - this.pos);
        long j2 = 0;
        while (jMin > 0 && (i = read(bArr, 0, (int) Math.min(2048L, jMin))) != -1) {
            long j3 = i;
            j2 += j3;
            jMin -= j3;
        }
        return j2;
    }
}
