package com.loopj.android.http;

import com.google.firebase.analytics.FirebaseAnalytics;
import cz.msebera.android.httpclient.Header;
import cz.msebera.android.httpclient.HttpHost;
import cz.msebera.android.httpclient.HttpRequest;
import cz.msebera.android.httpclient.HttpResponse;
import cz.msebera.android.httpclient.ProtocolException;
import cz.msebera.android.httpclient.client.CircularRedirectException;
import cz.msebera.android.httpclient.client.utils.URIUtils;
import cz.msebera.android.httpclient.impl.client.DefaultRedirectHandler;
import cz.msebera.android.httpclient.impl.client.RedirectLocations;
import cz.msebera.android.httpclient.params.HttpParams;
import cz.msebera.android.httpclient.protocol.HttpContext;
import java.net.URI;
import java.net.URISyntaxException;

class MyRedirectHandler extends DefaultRedirectHandler {
    private static final String REDIRECT_LOCATIONS = "http.protocol.redirect-locations";
    private final boolean enableRedirects;

    public MyRedirectHandler(boolean z) {
        this.enableRedirects = z;
    }

    public boolean isRedirectRequested(HttpResponse httpResponse, HttpContext httpContext) {
        if (!this.enableRedirects) {
            return false;
        }
        if (httpResponse == null) {
            throw new IllegalArgumentException("HTTP response may not be null");
        }
        int statusCode = httpResponse.getStatusLine().getStatusCode();
        if (statusCode == 307) {
            return true;
        }
        switch (statusCode) {
            case 301:
            case 302:
            case 303:
                return true;
            default:
                return false;
        }
    }

    public URI getLocationURI(HttpResponse httpResponse, HttpContext httpContext) throws CircularRedirectException, ProtocolException {
        URI uriRewriteURI;
        if (httpResponse == null) {
            throw new IllegalArgumentException("HTTP response may not be null");
        }
        Header firstHeader = httpResponse.getFirstHeader(FirebaseAnalytics.Param.LOCATION);
        if (firstHeader == null) {
            throw new ProtocolException("Received redirect response " + httpResponse.getStatusLine() + " but no location header");
        }
        String strReplaceAll = firstHeader.getValue().replaceAll(" ", "%20");
        try {
            URI uri = new URI(strReplaceAll);
            HttpParams params = httpResponse.getParams();
            if (!uri.isAbsolute()) {
                if (params.isParameterTrue("http.protocol.reject-relative-redirect")) {
                    throw new ProtocolException("Relative redirect location '" + uri + "' not allowed");
                }
                HttpHost httpHost = (HttpHost) httpContext.getAttribute("http.target_host");
                if (httpHost == null) {
                    throw new IllegalStateException("Target host not available in the HTTP context");
                }
                try {
                    uri = URIUtils.resolve(URIUtils.rewriteURI(new URI(((HttpRequest) httpContext.getAttribute("http.request")).getRequestLine().getUri()), httpHost, true), uri);
                } catch (URISyntaxException e) {
                    throw new ProtocolException(e.getMessage(), e);
                }
            }
            if (params.isParameterFalse("http.protocol.allow-circular-redirects")) {
                RedirectLocations redirectLocations = (RedirectLocations) httpContext.getAttribute(REDIRECT_LOCATIONS);
                if (redirectLocations == null) {
                    redirectLocations = new RedirectLocations();
                    httpContext.setAttribute(REDIRECT_LOCATIONS, redirectLocations);
                }
                if (uri.getFragment() != null) {
                    try {
                        uriRewriteURI = URIUtils.rewriteURI(uri, new HttpHost(uri.getHost(), uri.getPort(), uri.getScheme()), true);
                    } catch (URISyntaxException e2) {
                        throw new ProtocolException(e2.getMessage(), e2);
                    }
                } else {
                    uriRewriteURI = uri;
                }
                if (redirectLocations.contains(uriRewriteURI)) {
                    throw new CircularRedirectException("Circular redirect to '" + uriRewriteURI + "'");
                }
                redirectLocations.add(uriRewriteURI);
            }
            return uri;
        } catch (URISyntaxException e3) {
            throw new ProtocolException("Invalid redirect URI: " + strReplaceAll, e3);
        }
    }
}
