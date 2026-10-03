package cz.msebera.android.httpclient.client.protocol;

import cz.msebera.android.httpclient.Header;
import cz.msebera.android.httpclient.HttpException;
import cz.msebera.android.httpclient.HttpHost;
import cz.msebera.android.httpclient.HttpRequest;
import cz.msebera.android.httpclient.HttpRequestInterceptor;
import cz.msebera.android.httpclient.client.CookieStore;
import cz.msebera.android.httpclient.client.methods.HttpUriRequest;
import cz.msebera.android.httpclient.config.Lookup;
import cz.msebera.android.httpclient.conn.routing.RouteInfo;
import cz.msebera.android.httpclient.cookie.Cookie;
import cz.msebera.android.httpclient.cookie.CookieOrigin;
import cz.msebera.android.httpclient.cookie.CookieSpec;
import cz.msebera.android.httpclient.cookie.CookieSpecProvider;
import cz.msebera.android.httpclient.cookie.SetCookie2;
import cz.msebera.android.httpclient.extras.HttpClientAndroidLog;
import cz.msebera.android.httpclient.protocol.HttpContext;
import cz.msebera.android.httpclient.util.Args;
import cz.msebera.android.httpclient.util.TextUtils;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;

public class RequestAddCookies implements HttpRequestInterceptor {
    public HttpClientAndroidLog log = new HttpClientAndroidLog(getClass());

    @Override
    public void process(HttpRequest httpRequest, HttpContext httpContext) throws HttpException, IOException {
        URI uri;
        Header versionHeader;
        Args.notNull(httpRequest, "HTTP request");
        Args.notNull(httpContext, "HTTP context");
        if (httpRequest.getRequestLine().getMethod().equalsIgnoreCase("CONNECT")) {
            return;
        }
        HttpClientContext httpClientContextAdapt = HttpClientContext.adapt(httpContext);
        CookieStore cookieStore = httpClientContextAdapt.getCookieStore();
        if (cookieStore == null) {
            this.log.debug("Cookie store not specified in HTTP context");
            return;
        }
        Lookup<CookieSpecProvider> cookieSpecRegistry = httpClientContextAdapt.getCookieSpecRegistry();
        if (cookieSpecRegistry == null) {
            this.log.debug("CookieSpec registry not specified in HTTP context");
            return;
        }
        HttpHost targetHost = httpClientContextAdapt.getTargetHost();
        if (targetHost == null) {
            this.log.debug("Target host not set in the context");
            return;
        }
        RouteInfo httpRoute = httpClientContextAdapt.getHttpRoute();
        if (httpRoute == null) {
            this.log.debug("Connection route not set in the context");
            return;
        }
        String cookieSpec = httpClientContextAdapt.getRequestConfig().getCookieSpec();
        if (cookieSpec == null) {
            cookieSpec = "best-match";
        }
        if (this.log.isDebugEnabled()) {
            this.log.debug("CookieSpec selected: " + cookieSpec);
        }
        if (httpRequest instanceof HttpUriRequest) {
            uri = ((HttpUriRequest) httpRequest).getURI();
        } else {
            try {
                uri = new URI(httpRequest.getRequestLine().getUri());
            } catch (URISyntaxException unused) {
                uri = null;
            }
        }
        String path = uri != null ? uri.getPath() : null;
        String hostName = targetHost.getHostName();
        int port = targetHost.getPort();
        if (port < 0) {
            port = httpRoute.getTargetHost().getPort();
        }
        boolean z = false;
        if (port < 0) {
            port = 0;
        }
        if (TextUtils.isEmpty(path)) {
            path = "/";
        }
        CookieOrigin cookieOrigin = new CookieOrigin(hostName, port, path, httpRoute.isSecure());
        CookieSpecProvider cookieSpecProviderLookup = cookieSpecRegistry.lookup(cookieSpec);
        if (cookieSpecProviderLookup == null) {
            throw new HttpException("Unsupported cookie policy: " + cookieSpec);
        }
        CookieSpec cookieSpecCreate = cookieSpecProviderLookup.create(httpClientContextAdapt);
        ArrayList<Cookie> arrayList = new ArrayList(cookieStore.getCookies());
        ArrayList arrayList2 = new ArrayList();
        Date date = new Date();
        for (Cookie cookie : arrayList) {
            if (!cookie.isExpired(date)) {
                if (cookieSpecCreate.match(cookie, cookieOrigin)) {
                    if (this.log.isDebugEnabled()) {
                        this.log.debug("Cookie " + cookie + " match " + cookieOrigin);
                    }
                    arrayList2.add(cookie);
                }
            } else if (this.log.isDebugEnabled()) {
                this.log.debug("Cookie " + cookie + " expired");
            }
        }
        if (!arrayList2.isEmpty()) {
            Iterator<Header> it = cookieSpecCreate.formatCookies(arrayList2).iterator();
            while (it.hasNext()) {
                httpRequest.addHeader(it.next());
            }
        }
        int version = cookieSpecCreate.getVersion();
        if (version > 0) {
            for (Cookie cookie2 : arrayList2) {
                if (version != cookie2.getVersion() || !(cookie2 instanceof SetCookie2)) {
                    z = true;
                }
            }
            if (z && (versionHeader = cookieSpecCreate.getVersionHeader()) != null) {
                httpRequest.addHeader(versionHeader);
            }
        }
        httpContext.setAttribute("http.cookie-spec", cookieSpecCreate);
        httpContext.setAttribute("http.cookie-origin", cookieOrigin);
    }
}
