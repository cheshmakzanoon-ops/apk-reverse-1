package cz.msebera.android.httpclient.impl.auth;

import cz.msebera.android.httpclient.auth.AuthScheme;
import cz.msebera.android.httpclient.auth.AuthSchemeFactory;
import cz.msebera.android.httpclient.auth.AuthSchemeProvider;
import cz.msebera.android.httpclient.params.HttpParams;
import cz.msebera.android.httpclient.protocol.HttpContext;
import java.nio.charset.Charset;

public class BasicSchemeFactory implements AuthSchemeFactory, AuthSchemeProvider {
    private final Charset charset;

    public BasicSchemeFactory(Charset charset) {
        this.charset = charset;
    }

    public BasicSchemeFactory() {
        this(null);
    }

    @Override
    public AuthScheme newInstance(HttpParams httpParams) {
        return new BasicScheme();
    }

    @Override
    public AuthScheme create(HttpContext httpContext) {
        return new BasicScheme(this.charset);
    }
}
