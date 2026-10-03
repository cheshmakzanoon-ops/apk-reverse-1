package cz.msebera.android.httpclient.impl.client;

import cz.msebera.android.httpclient.HttpRequest;
import j$.util.concurrent.ConcurrentHashMap;
import java.util.Locale;
import java.util.Map;

public class StandardHttpRequestRetryHandler extends DefaultHttpRequestRetryHandler {
    private final Map<String, Boolean> idempotentMethods;

    public StandardHttpRequestRetryHandler(int i, boolean z) {
        super(i, z);
        ConcurrentHashMap concurrentHashMap = new ConcurrentHashMap();
        this.idempotentMethods = concurrentHashMap;
        concurrentHashMap.put("GET", Boolean.TRUE);
        concurrentHashMap.put("HEAD", Boolean.TRUE);
        concurrentHashMap.put("PUT", Boolean.TRUE);
        concurrentHashMap.put("DELETE", Boolean.TRUE);
        concurrentHashMap.put("OPTIONS", Boolean.TRUE);
        concurrentHashMap.put("TRACE", Boolean.TRUE);
    }

    public StandardHttpRequestRetryHandler() {
        this(3, false);
    }

    @Override
    protected boolean handleAsIdempotent(HttpRequest httpRequest) {
        Boolean bool = this.idempotentMethods.get(httpRequest.getRequestLine().getMethod().toUpperCase(Locale.ENGLISH));
        return bool != null && bool.booleanValue();
    }
}
