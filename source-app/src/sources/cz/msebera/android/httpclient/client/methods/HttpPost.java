package cz.msebera.android.httpclient.client.methods;

import java.net.URI;

public class HttpPost extends HttpEntityEnclosingRequestBase {
    public static final String METHOD_NAME = "POST";

    public HttpPost() {
    }

    public HttpPost(URI uri) {
        setURI(uri);
    }

    public HttpPost(String str) {
        setURI(URI.create(str));
    }

    @Override
    public String getMethod() {
        return METHOD_NAME;
    }
}
