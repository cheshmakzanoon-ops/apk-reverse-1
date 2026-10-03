package cz.msebera.android.httpclient.client.methods;

import java.net.URI;

public class HttpTrace extends HttpRequestBase {
    public static final String METHOD_NAME = "TRACE";

    public HttpTrace() {
    }

    public HttpTrace(URI uri) {
        setURI(uri);
    }

    public HttpTrace(String str) {
        setURI(URI.create(str));
    }

    @Override
    public String getMethod() {
        return "TRACE";
    }
}
