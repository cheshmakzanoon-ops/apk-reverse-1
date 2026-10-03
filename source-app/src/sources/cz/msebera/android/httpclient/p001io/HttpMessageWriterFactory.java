package cz.msebera.android.httpclient.p001io;

import cz.msebera.android.httpclient.HttpMessage;

public interface HttpMessageWriterFactory<T extends HttpMessage> {
    HttpMessageWriter<T> create(SessionOutputBuffer sessionOutputBuffer);
}
