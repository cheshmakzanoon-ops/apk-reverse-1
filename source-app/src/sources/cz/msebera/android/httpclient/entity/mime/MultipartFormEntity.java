package cz.msebera.android.httpclient.entity.mime;

import cz.msebera.android.httpclient.HttpEntity;
import cz.msebera.android.httpclient.message.BasicHeader;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

class MultipartFormEntity implements HttpEntity {
    private final long contentLength;
    private final cz.msebera.android.httpclient.Header contentType;
    private final AbstractMultipartForm multipart;

    @Override
    public cz.msebera.android.httpclient.Header getContentEncoding() {
        return null;
    }

    MultipartFormEntity(AbstractMultipartForm abstractMultipartForm, String str, long j) {
        this.multipart = abstractMultipartForm;
        this.contentType = new BasicHeader("Content-Type", str);
        this.contentLength = j;
    }

    AbstractMultipartForm getMultipart() {
        return this.multipart;
    }

    @Override
    public boolean isRepeatable() {
        return this.contentLength != -1;
    }

    @Override
    public boolean isChunked() {
        return !isRepeatable();
    }

    @Override
    public boolean isStreaming() {
        return !isRepeatable();
    }

    @Override
    public long getContentLength() {
        return this.contentLength;
    }

    @Override
    public cz.msebera.android.httpclient.Header getContentType() {
        return this.contentType;
    }

    @Override
    public void consumeContent() throws UnsupportedOperationException, IOException {
        if (isStreaming()) {
            throw new UnsupportedOperationException("Streaming entity does not implement #consumeContent()");
        }
    }

    @Override
    public InputStream getContent() throws IOException {
        throw new UnsupportedOperationException("Multipart form entity does not implement #getContent()");
    }

    @Override
    public void writeTo(OutputStream outputStream) throws IOException {
        this.multipart.writeTo(outputStream);
    }
}
