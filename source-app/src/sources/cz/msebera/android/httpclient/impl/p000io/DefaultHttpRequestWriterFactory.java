package cz.msebera.android.httpclient.impl.p000io;

import cz.msebera.android.httpclient.HttpRequest;
import cz.msebera.android.httpclient.message.BasicLineFormatter;
import cz.msebera.android.httpclient.message.LineFormatter;
import cz.msebera.android.httpclient.p001io.HttpMessageWriter;
import cz.msebera.android.httpclient.p001io.HttpMessageWriterFactory;
import cz.msebera.android.httpclient.p001io.SessionOutputBuffer;

public class DefaultHttpRequestWriterFactory implements HttpMessageWriterFactory<HttpRequest> {
    public static final DefaultHttpRequestWriterFactory INSTANCE = new DefaultHttpRequestWriterFactory();
    private final LineFormatter lineFormatter;

    public DefaultHttpRequestWriterFactory(LineFormatter lineFormatter) {
        this.lineFormatter = lineFormatter == null ? BasicLineFormatter.INSTANCE : lineFormatter;
    }

    public DefaultHttpRequestWriterFactory() {
        this(null);
    }

    @Override
    public HttpMessageWriter<HttpRequest> create(SessionOutputBuffer sessionOutputBuffer) {
        return new DefaultHttpRequestWriter(sessionOutputBuffer, this.lineFormatter);
    }
}
