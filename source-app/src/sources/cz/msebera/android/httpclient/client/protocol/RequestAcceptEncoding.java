package cz.msebera.android.httpclient.client.protocol;

import cz.msebera.android.httpclient.HttpException;
import cz.msebera.android.httpclient.HttpHeaders;
import cz.msebera.android.httpclient.HttpRequest;
import cz.msebera.android.httpclient.HttpRequestInterceptor;
import cz.msebera.android.httpclient.protocol.HttpContext;
import java.io.IOException;

public class RequestAcceptEncoding implements HttpRequestInterceptor {
    @Override
    public void process(HttpRequest httpRequest, HttpContext httpContext) throws HttpException, IOException {
        if (httpRequest.containsHeader(HttpHeaders.ACCEPT_ENCODING)) {
            return;
        }
        httpRequest.addHeader(HttpHeaders.ACCEPT_ENCODING, "gzip,deflate");
    }
}
