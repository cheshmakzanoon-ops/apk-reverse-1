package cz.msebera.android.httpclient.client.methods;

import java.net.URI;

public class HttpGet extends HttpRequestBase {
    public static final String METHOD_NAME = "GET";

    public HttpGet() {
    }

    public HttpGet(URI uri) {
        setURI(uri);
    }

    public HttpGet(String str) {
        setURI(URI.create(str));
    }

    @Override
    public String getMethod() {
        return "GET";
    }
}
