package cz.msebera.android.httpclient.impl.client.cache;

import cz.msebera.android.httpclient.client.cache.Resource;
import java.io.ByteArrayInputStream;
import java.io.InputStream;

public class HeapResource implements Resource {
    private static final long serialVersionUID = -2078599905620463394L;

    private final byte[] f17b;

    @Override
    public void dispose() {
    }

    public HeapResource(byte[] bArr) {
        this.f17b = bArr;
    }

    byte[] getByteArray() {
        return this.f17b;
    }

    @Override
    public InputStream getInputStream() {
        return new ByteArrayInputStream(this.f17b);
    }

    @Override
    public long length() {
        return this.f17b.length;
    }
}
