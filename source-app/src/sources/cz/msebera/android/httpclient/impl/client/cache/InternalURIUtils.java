package cz.msebera.android.httpclient.impl.client.cache;

import cz.msebera.android.httpclient.client.utils.URIUtils;
import cz.msebera.android.httpclient.conn.routing.RouteInfo;
import java.net.URI;
import java.net.URISyntaxException;

class InternalURIUtils {
    public static URI rewriteURIForRoute(URI uri, RouteInfo routeInfo) throws URISyntaxException {
        if (uri == null) {
            return null;
        }
        if (routeInfo.getProxyHost() != null && !routeInfo.isTunnelled()) {
            if (!uri.isAbsolute()) {
                return URIUtils.rewriteURI(uri, routeInfo.getTargetHost(), true);
            }
            return URIUtils.rewriteURI(uri);
        }
        if (uri.isAbsolute()) {
            return URIUtils.rewriteURI(uri, null, true);
        }
        return URIUtils.rewriteURI(uri);
    }

    private InternalURIUtils() {
    }
}
