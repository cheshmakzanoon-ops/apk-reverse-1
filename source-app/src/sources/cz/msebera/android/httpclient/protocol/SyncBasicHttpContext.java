package cz.msebera.android.httpclient.protocol;

@Deprecated
public class SyncBasicHttpContext extends BasicHttpContext {
    public SyncBasicHttpContext(HttpContext httpContext) {
        super(httpContext);
    }

    public SyncBasicHttpContext() {
    }

    @Override
    public synchronized Object getAttribute(String str) {
        return super.getAttribute(str);
    }

    @Override
    public synchronized void setAttribute(String str, Object obj) {
        super.setAttribute(str, obj);
    }

    @Override
    public synchronized Object removeAttribute(String str) {
        return super.removeAttribute(str);
    }

    @Override
    public synchronized void clear() {
        super.clear();
    }
}
