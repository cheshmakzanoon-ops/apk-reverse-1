package cz.msebera.android.httpclient;

import java.io.Closeable;
import java.io.IOException;

public interface HttpConnection extends Closeable {
    @Override
    void close() throws IOException;

    HttpConnectionMetrics getMetrics();

    int getSocketTimeout();

    boolean isOpen();

    boolean isStale();

    void setSocketTimeout(int i);

    void shutdown() throws IOException;
}
