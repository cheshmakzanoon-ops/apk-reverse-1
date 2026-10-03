package cz.msebera.android.httpclient.impl;

import cz.msebera.android.httpclient.ConnectionReuseStrategy;
import cz.msebera.android.httpclient.HeaderIterator;
import cz.msebera.android.httpclient.HttpResponse;
import cz.msebera.android.httpclient.TokenIterator;
import cz.msebera.android.httpclient.message.BasicTokenIterator;

public class DefaultConnectionReuseStrategy implements ConnectionReuseStrategy {
    public static final DefaultConnectionReuseStrategy INSTANCE = new DefaultConnectionReuseStrategy();

    @Override
    public boolean keepAlive(cz.msebera.android.httpclient.HttpResponse r6, cz.msebera.android.httpclient.protocol.HttpContext r7) {
        throw new UnsupportedOperationException("Method not decompiled: cz.msebera.android.httpclient.impl.DefaultConnectionReuseStrategy.keepAlive(cz.msebera.android.httpclient.HttpResponse, cz.msebera.android.httpclient.protocol.HttpContext):boolean");
    }

    protected TokenIterator createTokenIterator(HeaderIterator headerIterator) {
        return new BasicTokenIterator(headerIterator);
    }

    private boolean canResponseHaveBody(HttpResponse httpResponse) {
        int statusCode = httpResponse.getStatusLine().getStatusCode();
        return (statusCode < 200 || statusCode == 204 || statusCode == 304 || statusCode == 205) ? false : true;
    }
}
