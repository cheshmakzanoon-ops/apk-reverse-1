package cz.msebera.android.httpclient.impl.client;

import cz.msebera.android.httpclient.HttpResponse;
import cz.msebera.android.httpclient.client.ConnectionBackoffStrategy;

public class NullBackoffStrategy implements ConnectionBackoffStrategy {
    @Override
    public boolean shouldBackoff(HttpResponse httpResponse) {
        return false;
    }

    @Override
    public boolean shouldBackoff(Throwable th) {
        return false;
    }
}
