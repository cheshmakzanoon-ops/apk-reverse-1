package cz.msebera.android.httpclient.impl.conn;

import java.io.IOException;
import java.io.InputStream;

class LoggingInputStream extends InputStream {

    private final InputStream f20in;
    private final Wire wire;

    @Override
    public boolean markSupported() {
        return false;
    }

    public LoggingInputStream(InputStream inputStream, Wire wire) {
        this.f20in = inputStream;
        this.wire = wire;
    }

    @Override
    public int read() throws IOException {
        try {
            int i = this.f20in.read();
            if (i == -1) {
                this.wire.input("end of stream");
            } else {
                this.wire.input(i);
            }
            return i;
        } catch (IOException e) {
            this.wire.input("[read] I/O error: " + e.getMessage());
            throw e;
        }
    }

    @Override
    public int read(byte[] bArr) throws IOException {
        try {
            int i = this.f20in.read(bArr);
            if (i == -1) {
                this.wire.input("end of stream");
            } else if (i > 0) {
                this.wire.input(bArr, 0, i);
            }
            return i;
        } catch (IOException e) {
            this.wire.input("[read] I/O error: " + e.getMessage());
            throw e;
        }
    }

    @Override
    public int read(byte[] bArr, int i, int i2) throws IOException {
        try {
            int i3 = this.f20in.read(bArr, i, i2);
            if (i3 == -1) {
                this.wire.input("end of stream");
            } else if (i3 > 0) {
                this.wire.input(bArr, i, i3);
            }
            return i3;
        } catch (IOException e) {
            this.wire.input("[read] I/O error: " + e.getMessage());
            throw e;
        }
    }

    @Override
    public long skip(long j) throws IOException {
        try {
            return super.skip(j);
        } catch (IOException e) {
            this.wire.input("[skip] I/O error: " + e.getMessage());
            throw e;
        }
    }

    @Override
    public int available() throws IOException {
        try {
            return this.f20in.available();
        } catch (IOException e) {
            this.wire.input("[available] I/O error : " + e.getMessage());
            throw e;
        }
    }

    @Override
    public void mark(int i) {
        super.mark(i);
    }

    @Override
    public void reset() throws IOException {
        super.reset();
    }

    @Override
    public void close() throws IOException {
        try {
            this.f20in.close();
        } catch (IOException e) {
            this.wire.input("[close] I/O error: " + e.getMessage());
            throw e;
        }
    }
}
