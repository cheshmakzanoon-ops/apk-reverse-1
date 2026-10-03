package cz.msebera.android.httpclient.client.entity;

import java.io.IOException;
import java.io.InputStream;

class LazyDecompressingInputStream extends InputStream {
    private final DecompressingEntity decompressingEntity;
    private final InputStream wrappedStream;
    private InputStream wrapperStream;

    @Override
    public boolean markSupported() {
        return false;
    }

    public LazyDecompressingInputStream(InputStream inputStream, DecompressingEntity decompressingEntity) {
        this.wrappedStream = inputStream;
        this.decompressingEntity = decompressingEntity;
    }

    private void initWrapper() throws IOException {
        if (this.wrapperStream == null) {
            this.wrapperStream = this.decompressingEntity.decorate(this.wrappedStream);
        }
    }

    @Override
    public int read() throws IOException {
        initWrapper();
        return this.wrapperStream.read();
    }

    @Override
    public int read(byte[] bArr) throws IOException {
        initWrapper();
        return this.wrapperStream.read(bArr);
    }

    @Override
    public int read(byte[] bArr, int i, int i2) throws IOException {
        initWrapper();
        return this.wrapperStream.read(bArr, i, i2);
    }

    @Override
    public long skip(long j) throws IOException {
        initWrapper();
        return this.wrapperStream.skip(j);
    }

    @Override
    public int available() throws IOException {
        initWrapper();
        return this.wrapperStream.available();
    }

    @Override
    public void close() throws IOException {
        try {
            InputStream inputStream = this.wrapperStream;
            if (inputStream != null) {
                inputStream.close();
            }
        } finally {
            this.wrappedStream.close();
        }
    }
}
