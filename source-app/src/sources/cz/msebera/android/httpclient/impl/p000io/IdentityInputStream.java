package cz.msebera.android.httpclient.impl.p000io;

import cz.msebera.android.httpclient.p001io.BufferInfo;
import cz.msebera.android.httpclient.p001io.SessionInputBuffer;
import cz.msebera.android.httpclient.util.Args;
import java.io.IOException;
import java.io.InputStream;

public class IdentityInputStream extends InputStream {
    private boolean closed = false;

    private final SessionInputBuffer f26in;

    public IdentityInputStream(SessionInputBuffer sessionInputBuffer) {
        this.f26in = (SessionInputBuffer) Args.notNull(sessionInputBuffer, "Session input buffer");
    }

    @Override
    public int available() throws IOException {
        SessionInputBuffer sessionInputBuffer = this.f26in;
        if (sessionInputBuffer instanceof BufferInfo) {
            return ((BufferInfo) sessionInputBuffer).length();
        }
        return 0;
    }

    @Override
    public void close() throws IOException {
        this.closed = true;
    }

    @Override
    public int read() throws IOException {
        if (this.closed) {
            return -1;
        }
        return this.f26in.read();
    }

    @Override
    public int read(byte[] bArr, int i, int i2) throws IOException {
        if (this.closed) {
            return -1;
        }
        return this.f26in.read(bArr, i, i2);
    }
}
