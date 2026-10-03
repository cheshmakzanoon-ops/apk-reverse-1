package cz.msebera.android.httpclient.impl.pool;

import cz.msebera.android.httpclient.HttpClientConnection;
import cz.msebera.android.httpclient.HttpHost;
import cz.msebera.android.httpclient.pool.PoolEntry;
import java.io.IOException;

public class BasicPoolEntry extends PoolEntry<HttpHost, HttpClientConnection> {
    public BasicPoolEntry(String str, HttpHost httpHost, HttpClientConnection httpClientConnection) {
        super(str, httpHost, httpClientConnection);
    }

    @Override
    public void close() {
        try {
            getConnection().close();
        } catch (IOException unused) {
        }
    }

    @Override
    public boolean isClosed() {
        return !getConnection().isOpen();
    }
}
