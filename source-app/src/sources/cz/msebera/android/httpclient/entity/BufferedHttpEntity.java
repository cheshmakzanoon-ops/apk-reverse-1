package cz.msebera.android.httpclient.entity;

import cz.msebera.android.httpclient.HttpEntity;
import cz.msebera.android.httpclient.util.Args;
import cz.msebera.android.httpclient.util.EntityUtils;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public class BufferedHttpEntity extends HttpEntityWrapper {
    private final byte[] buffer;

    @Override
    public boolean isRepeatable() {
        return true;
    }

    public BufferedHttpEntity(HttpEntity httpEntity) throws IOException {
        super(httpEntity);
        if (!httpEntity.isRepeatable() || httpEntity.getContentLength() < 0) {
            this.buffer = EntityUtils.toByteArray(httpEntity);
        } else {
            this.buffer = null;
        }
    }

    @Override
    public long getContentLength() {
        byte[] bArr = this.buffer;
        if (bArr != null) {
            return bArr.length;
        }
        return super.getContentLength();
    }

    @Override
    public InputStream getContent() throws IOException {
        if (this.buffer != null) {
            return new ByteArrayInputStream(this.buffer);
        }
        return super.getContent();
    }

    @Override
    public boolean isChunked() {
        return this.buffer == null && super.isChunked();
    }

    @Override
    public void writeTo(OutputStream outputStream) throws IOException {
        Args.notNull(outputStream, "Output stream");
        byte[] bArr = this.buffer;
        if (bArr != null) {
            outputStream.write(bArr);
        } else {
            super.writeTo(outputStream);
        }
    }

    @Override
    public boolean isStreaming() {
        return this.buffer == null && super.isStreaming();
    }
}
