package cz.msebera.android.httpclient.client.entity;

import cz.msebera.android.httpclient.Header;
import cz.msebera.android.httpclient.HttpEntity;
import cz.msebera.android.httpclient.entity.HttpEntityWrapper;
import cz.msebera.android.httpclient.message.BasicHeader;
import cz.msebera.android.httpclient.util.Args;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.zip.GZIPOutputStream;

public class GzipCompressingEntity extends HttpEntityWrapper {
    private static final String GZIP_CODEC = "gzip";

    @Override
    public long getContentLength() {
        return -1L;
    }

    @Override
    public boolean isChunked() {
        return true;
    }

    public GzipCompressingEntity(HttpEntity httpEntity) {
        super(httpEntity);
    }

    @Override
    public Header getContentEncoding() {
        return new BasicHeader("Content-Encoding", GZIP_CODEC);
    }

    @Override
    public InputStream getContent() throws IOException {
        throw new UnsupportedOperationException();
    }

    @Override
    public void writeTo(OutputStream outputStream) throws IOException {
        Args.notNull(outputStream, "Output stream");
        GZIPOutputStream gZIPOutputStream = new GZIPOutputStream(outputStream);
        this.wrappedEntity.writeTo(gZIPOutputStream);
        gZIPOutputStream.close();
    }
}
