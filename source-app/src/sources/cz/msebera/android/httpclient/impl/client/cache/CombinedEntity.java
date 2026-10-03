package cz.msebera.android.httpclient.impl.client.cache;

import cz.msebera.android.httpclient.client.cache.Resource;
import cz.msebera.android.httpclient.entity.AbstractHttpEntity;
import cz.msebera.android.httpclient.util.Args;
import java.io.FilterInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.SequenceInputStream;

class CombinedEntity extends AbstractHttpEntity {
    private final InputStream combinedStream;
    private final Resource resource;

    @Override
    public long getContentLength() {
        return -1L;
    }

    @Override
    public boolean isRepeatable() {
        return false;
    }

    @Override
    public boolean isStreaming() {
        return true;
    }

    CombinedEntity(Resource resource, InputStream inputStream) throws IOException {
        this.resource = resource;
        this.combinedStream = new SequenceInputStream(new ResourceStream(resource.getInputStream()), inputStream);
    }

    @Override
    public InputStream getContent() throws IllegalStateException, IOException {
        return this.combinedStream;
    }

    @Override
    public void writeTo(OutputStream outputStream) throws IOException {
        Args.notNull(outputStream, "Output stream");
        InputStream content = getContent();
        try {
            byte[] bArr = new byte[2048];
            while (true) {
                int i = content.read(bArr);
                if (i != -1) {
                    outputStream.write(bArr, 0, i);
                } else {
                    content.close();
                    return;
                }
            }
        } catch (Throwable th) {
            content.close();
            throw th;
        }
    }

    public void dispose() {
        this.resource.dispose();
    }

    class ResourceStream extends FilterInputStream {
        protected ResourceStream(InputStream inputStream) {
            super(inputStream);
        }

        @Override
        public void close() throws IOException {
            try {
                super.close();
            } finally {
                CombinedEntity.this.dispose();
            }
        }
    }
}
