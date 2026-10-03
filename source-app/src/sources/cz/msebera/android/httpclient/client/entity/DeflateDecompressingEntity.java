package cz.msebera.android.httpclient.client.entity;

import cz.msebera.android.httpclient.Header;
import cz.msebera.android.httpclient.HttpEntity;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public class DeflateDecompressingEntity extends DecompressingEntity {
    @Override
    public Header getContentEncoding() {
        return null;
    }

    @Override
    public long getContentLength() {
        return -1L;
    }

    @Override
    public InputStream getContent() throws IOException {
        return super.getContent();
    }

    @Override
    public void writeTo(OutputStream outputStream) throws IOException {
        super.writeTo(outputStream);
    }

    public DeflateDecompressingEntity(HttpEntity httpEntity) {
        super(httpEntity);
    }

    @Override
    InputStream decorate(InputStream inputStream) throws IOException {
        return new DeflateInputStream(inputStream);
    }
}
