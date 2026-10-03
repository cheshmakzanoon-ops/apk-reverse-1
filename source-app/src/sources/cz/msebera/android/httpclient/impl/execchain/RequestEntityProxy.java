package cz.msebera.android.httpclient.impl.execchain;

import cz.msebera.android.httpclient.Header;
import cz.msebera.android.httpclient.HttpEntity;
import cz.msebera.android.httpclient.HttpEntityEnclosingRequest;
import cz.msebera.android.httpclient.HttpRequest;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import kotlinx.serialization.json.internal.AbstractJsonLexerKt;

class RequestEntityProxy implements HttpEntity {
    private boolean consumed = false;
    private final HttpEntity original;

    static void enhance(HttpEntityEnclosingRequest httpEntityEnclosingRequest) {
        HttpEntity entity = httpEntityEnclosingRequest.getEntity();
        if (entity == null || entity.isRepeatable() || isEnhanced(entity)) {
            return;
        }
        httpEntityEnclosingRequest.setEntity(new RequestEntityProxy(entity));
    }

    static boolean isEnhanced(HttpEntity httpEntity) {
        return httpEntity instanceof RequestEntityProxy;
    }

    static boolean isRepeatable(HttpRequest httpRequest) {
        HttpEntity entity;
        if (!(httpRequest instanceof HttpEntityEnclosingRequest) || (entity = ((HttpEntityEnclosingRequest) httpRequest).getEntity()) == null) {
            return true;
        }
        if (!isEnhanced(entity) || ((RequestEntityProxy) entity).isConsumed()) {
            return entity.isRepeatable();
        }
        return true;
    }

    RequestEntityProxy(HttpEntity httpEntity) {
        this.original = httpEntity;
    }

    public HttpEntity getOriginal() {
        return this.original;
    }

    public boolean isConsumed() {
        return this.consumed;
    }

    @Override
    public boolean isRepeatable() {
        return this.original.isRepeatable();
    }

    @Override
    public boolean isChunked() {
        return this.original.isChunked();
    }

    @Override
    public long getContentLength() {
        return this.original.getContentLength();
    }

    @Override
    public Header getContentType() {
        return this.original.getContentType();
    }

    @Override
    public Header getContentEncoding() {
        return this.original.getContentEncoding();
    }

    @Override
    public InputStream getContent() throws IllegalStateException, IOException {
        return this.original.getContent();
    }

    @Override
    public void writeTo(OutputStream outputStream) throws IOException {
        this.consumed = true;
        this.original.writeTo(outputStream);
    }

    @Override
    public boolean isStreaming() {
        return this.original.isStreaming();
    }

    @Override
    @Deprecated
    public void consumeContent() throws IOException {
        this.consumed = true;
        this.original.consumeContent();
    }

    public String toString() {
        return "RequestEntityProxy{" + this.original + AbstractJsonLexerKt.END_OBJ;
    }
}
