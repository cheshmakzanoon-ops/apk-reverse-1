package cz.msebera.android.httpclient.impl.client;

import cz.msebera.android.httpclient.client.UserTokenHandler;
import cz.msebera.android.httpclient.protocol.HttpContext;

public class NoopUserTokenHandler implements UserTokenHandler {
    public static final NoopUserTokenHandler INSTANCE = new NoopUserTokenHandler();

    @Override
    public Object getUserToken(HttpContext httpContext) {
        return null;
    }
}
