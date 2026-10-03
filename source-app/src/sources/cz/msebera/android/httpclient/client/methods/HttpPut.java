package cz.msebera.android.httpclient.client.methods;

import java.net.URI;

public class HttpPut extends HttpEntityEnclosingRequestBase {
    public static final String METHOD_NAME = "PUT";

    public HttpPut() {
    }

    public HttpPut(URI uri) {
        setURI(uri);
    }

    public HttpPut(String str) {
        setURI(URI.create(str));
    }

    @Override
    public String getMethod() {
        return "PUT";
    }
}
