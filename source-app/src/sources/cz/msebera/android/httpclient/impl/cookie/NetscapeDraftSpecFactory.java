package cz.msebera.android.httpclient.impl.cookie;

import cz.msebera.android.httpclient.cookie.CookieSpec;
import cz.msebera.android.httpclient.cookie.CookieSpecFactory;
import cz.msebera.android.httpclient.cookie.CookieSpecProvider;
import cz.msebera.android.httpclient.cookie.params.CookieSpecPNames;
import cz.msebera.android.httpclient.params.HttpParams;
import cz.msebera.android.httpclient.protocol.HttpContext;
import java.util.Collection;

public class NetscapeDraftSpecFactory implements CookieSpecFactory, CookieSpecProvider {
    private final String[] datepatterns;

    public NetscapeDraftSpecFactory(String[] strArr) {
        this.datepatterns = strArr;
    }

    public NetscapeDraftSpecFactory() {
        this(null);
    }

    @Override
    public CookieSpec newInstance(HttpParams httpParams) {
        if (httpParams != null) {
            Collection collection = (Collection) httpParams.getParameter(CookieSpecPNames.DATE_PATTERNS);
            return new NetscapeDraftSpec(collection != null ? (String[]) collection.toArray(new String[collection.size()]) : null);
        }
        return new NetscapeDraftSpec();
    }

    @Override
    public CookieSpec create(HttpContext httpContext) {
        return new NetscapeDraftSpec(this.datepatterns);
    }
}
