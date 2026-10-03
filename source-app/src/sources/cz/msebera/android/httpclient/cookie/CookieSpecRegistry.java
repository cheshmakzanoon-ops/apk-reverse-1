package cz.msebera.android.httpclient.cookie;

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
public final class CookieSpecRegistry implements Lookup<CookieSpecProvider> {
    private final ConcurrentHashMap<String, CookieSpecFactory> registeredSpecs = new ConcurrentHashMap<>();

    public void register(String str, CookieSpecFactory cookieSpecFactory) {
        Args.notNull(str, "Name");
        Args.notNull(cookieSpecFactory, "Cookie spec factory");
        this.registeredSpecs.put(str.toLowerCase(Locale.ENGLISH), cookieSpecFactory);
    }

    public void unregister(String str) {
        Args.notNull(str, "Id");
        this.registeredSpecs.remove(str.toLowerCase(Locale.ENGLISH));
    }

    public CookieSpec getCookieSpec(String str, HttpParams httpParams) throws IllegalStateException {
        Args.notNull(str, "Name");
        CookieSpecFactory cookieSpecFactory = (CookieSpecFactory) this.registeredSpecs.get(str.toLowerCase(Locale.ENGLISH));
        if (cookieSpecFactory != null) {
            return cookieSpecFactory.newInstance(httpParams);
        }
        throw new IllegalStateException("Unsupported cookie spec: " + str);
    }

    public CookieSpec getCookieSpec(String str) throws IllegalStateException {
        return getCookieSpec(str, null);
    }

    public List<String> getSpecNames() {
        return new ArrayList(this.registeredSpecs.keySet());
    }

    public void setItems(Map<String, CookieSpecFactory> map) {
        if (map == null) {
            return;
        }
        this.registeredSpecs.clear();
        this.registeredSpecs.putAll(map);
    }

    @Override
    public CookieSpecProvider lookup(final String str) {
        return new CookieSpecProvider() {
            @Override
            public CookieSpec create(HttpContext httpContext) {
                return CookieSpecRegistry.this.getCookieSpec(str, ((HttpRequest) httpContext.getAttribute("http.request")).getParams());
            }
        };
    }
}
