package com.google.common.p001io;

import com.google.common.base.Preconditions;
import java.io.FilterOutputStream;
import java.io.IOException;
import java.io.OutputStream;

@ElementTypesAreNonnullByDefault
public final class CountingOutputStream extends FilterOutputStream {
    private long count;

    public CountingOutputStream(OutputStream outputStream) {
        super((OutputStream) Preconditions.checkNotNull(outputStream));
    }

    public long getCount() {
        return this.count;
    }

    @Override
    public void write(byte[] bArr, int i, int i2) throws IOException {
        this.out.write(bArr, i, i2);
        this.count += (long) i2;
    }

    @Override
    public void write(int i) throws IOException {
        this.out.write(i);
        this.count++;
    }

    @Override
    public void close() throws IOException {
        this.out.close();
    }
}
