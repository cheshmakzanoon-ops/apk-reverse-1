package cz.msebera.android.httpclient.auth;

import cz.msebera.android.httpclient.HttpRequest;
import cz.msebera.android.httpclient.config.Lookup;
import cz.msebera.android.httpclient.params.HttpParams;
import cz.msebera.android.httpclient.protocol.HttpContext;
import cz.msebera.android.httpclient.util.Args;
import j$.util.concurrent.ConcurrentHashMap;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Map;

@Deprecated
public final class AuthSchemeRegistry implements Lookup<AuthSchemeProvider> {
    private final ConcurrentHashMap<String, AuthSchemeFactory> registeredSchemes = new ConcurrentHashMap<>();

    public void register(String str, AuthSchemeFactory authSchemeFactory) {
        Args.notNull(str, "Name");
        Args.notNull(authSchemeFactory, "Authentication scheme factory");
        this.registeredSchemes.put(str.toLowerCase(Locale.ENGLISH), authSchemeFactory);
    }

    public void unregister(String str) {
        Args.notNull(str, "Name");
        this.registeredSchemes.remove(str.toLowerCase(Locale.ENGLISH));
    }

    public AuthScheme getAuthScheme(String str, HttpParams httpParams) throws IllegalStateException {
        Args.notNull(str, "Name");
        AuthSchemeFactory authSchemeFactory = (AuthSchemeFactory) this.registeredSchemes.get(str.toLowerCase(Locale.ENGLISH));
        if (authSchemeFactory != null) {
            return authSchemeFactory.newInstance(httpParams);
        }
        throw new IllegalStateException("Unsupported authentication scheme: " + str);
    }

    public List<String> getSchemeNames() {
        return new ArrayList(this.registeredSchemes.keySet());
    }

    public void setItems(Map<String, AuthSchemeFactory> map) {
        if (map == null) {
            return;
        }
        this.registeredSchemes.clear();
        this.registeredSchemes.putAll(map);
    }

    @Override
    public AuthSchemeProvider lookup(final String str) {
        return new AuthSchemeProvider() {
            @Override
            public AuthScheme create(HttpContext httpContext) {
                return AuthSchemeRegistry.this.getAuthScheme(str, ((HttpRequest) httpContext.getAttribute("http.request")).getParams());
            }
        };
    }
}
