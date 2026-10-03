package com.google.common.p001io;

import com.google.common.base.Preconditions;
import java.io.IOException;
import java.io.InputStream;
import java.util.Iterator;
import javax.annotation.CheckForNull;

@ElementTypesAreNonnullByDefault
final class MultiInputStream extends InputStream {

    @CheckForNull
    private InputStream f161in;

    private Iterator<? extends ByteSource> f162it;

    @Override
    public boolean markSupported() {
        return false;
    }

    public MultiInputStream(Iterator<? extends ByteSource> it) throws IOException {
        this.f162it = (Iterator) Preconditions.checkNotNull(it);
        advance();
    }

    @Override
    public void close() throws IOException {
        InputStream inputStream = this.f161in;
        if (inputStream != null) {
            try {
                inputStream.close();
            } finally {
                this.f161in = null;
            }
        }
    }

    private void advance() throws IOException {
        close();
        if (this.f162it.hasNext()) {
            this.f161in = this.f162it.next().openStream();
        }
    }

    @Override
    public int available() throws IOException {
        InputStream inputStream = this.f161in;
        if (inputStream == null) {
            return 0;
        }
        return inputStream.available();
    }

    @Override
    public int read() throws IOException {
        while (true) {
            InputStream inputStream = this.f161in;
            if (inputStream == null) {
                return -1;
            }
            int i = inputStream.read();
            if (i != -1) {
                return i;
            }
            advance();
        }
    }

    @Override
    public int read(byte[] bArr, int i, int i2) throws IOException {
        Preconditions.checkNotNull(bArr);
        while (true) {
            InputStream inputStream = this.f161in;
            if (inputStream == null) {
                return -1;
            }
            int i3 = inputStream.read(bArr, i, i2);
            if (i3 != -1) {
                return i3;
            }
            advance();
        }
    }

    @Override
    public long skip(long j) throws IOException {
        InputStream inputStream = this.f161in;
        if (inputStream == null || j <= 0) {
            return 0L;
        }
        long jSkip = inputStream.skip(j);
        if (jSkip != 0) {
            return jSkip;
        }
        if (read() == -1) {
            return 0L;
        }
        return this.f161in.skip(j - 1) + 1;
    }
}
