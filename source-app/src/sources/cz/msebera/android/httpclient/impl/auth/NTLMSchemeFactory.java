package cz.msebera.android.httpclient.impl.auth;

import cz.msebera.android.httpclient.auth.AuthScheme;
import cz.msebera.android.httpclient.auth.AuthSchemeFactory;
import cz.msebera.android.httpclient.auth.AuthSchemeProvider;
import cz.msebera.android.httpclient.params.HttpParams;
import cz.msebera.android.httpclient.protocol.HttpContext;

public class NTLMSchemeFactory implements AuthSchemeFactory, AuthSchemeProvider {
    @Override
    public AuthScheme newInstance(HttpParams httpParams) {
        return new NTLMScheme();
    }

    @Override
    public AuthScheme create(HttpContext httpContext) {
        return new NTLMScheme();
    }
}
