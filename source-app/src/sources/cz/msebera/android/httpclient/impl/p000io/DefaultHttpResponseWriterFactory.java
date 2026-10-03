package cz.msebera.android.httpclient.impl.p000io;

import cz.msebera.android.httpclient.HttpResponse;
import cz.msebera.android.httpclient.message.BasicLineFormatter;
import cz.msebera.android.httpclient.message.LineFormatter;
import cz.msebera.android.httpclient.p001io.HttpMessageWriter;
import cz.msebera.android.httpclient.p001io.HttpMessageWriterFactory;
import cz.msebera.android.httpclient.p001io.SessionOutputBuffer;

public class DefaultHttpResponseWriterFactory implements HttpMessageWriterFactory<HttpResponse> {
    public static final DefaultHttpResponseWriterFactory INSTANCE = new DefaultHttpResponseWriterFactory();
    private final LineFormatter lineFormatter;

    public DefaultHttpResponseWriterFactory(LineFormatter lineFormatter) {
        this.lineFormatter = lineFormatter == null ? BasicLineFormatter.INSTANCE : lineFormatter;
    }

    public DefaultHttpResponseWriterFactory() {
        this(null);
    }

    @Override
    public HttpMessageWriter<HttpResponse> create(SessionOutputBuffer sessionOutputBuffer) {
        return new DefaultHttpResponseWriter(sessionOutputBuffer, this.lineFormatter);
    }
}
