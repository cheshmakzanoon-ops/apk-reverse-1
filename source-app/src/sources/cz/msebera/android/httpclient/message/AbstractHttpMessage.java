package cz.msebera.android.httpclient.message;

import cz.msebera.android.httpclient.Header;
import cz.msebera.android.httpclient.HeaderIterator;
import cz.msebera.android.httpclient.HttpMessage;
import cz.msebera.android.httpclient.params.BasicHttpParams;
import cz.msebera.android.httpclient.params.HttpParams;
import cz.msebera.android.httpclient.util.Args;

public abstract class AbstractHttpMessage implements HttpMessage {
    protected HeaderGroup headergroup;

    @Deprecated
    protected HttpParams params;

    @Deprecated
    protected AbstractHttpMessage(HttpParams httpParams) {
        this.headergroup = new HeaderGroup();
        this.params = httpParams;
    }

    protected AbstractHttpMessage() {
        this(null);
    }

    @Override
    public boolean containsHeader(String str) {
        return this.headergroup.containsHeader(str);
    }

    @Override
    public Header[] getHeaders(String str) {
        return this.headergroup.getHeaders(str);
    }

    @Override
    public Header getFirstHeader(String str) {
        return this.headergroup.getFirstHeader(str);
    }

    @Override
    public Header getLastHeader(String str) {
        return this.headergroup.getLastHeader(str);
    }

    @Override
    public Header[] getAllHeaders() {
        return this.headergroup.getAllHeaders();
    }

    @Override
    public void addHeader(Header header) {
        this.headergroup.addHeader(header);
    }

    @Override
    public void addHeader(String str, String str2) {
        Args.notNull(str, "Header name");
        this.headergroup.addHeader(new BasicHeader(str, str2));
    }

    @Override
    public void setHeader(Header header) {
        this.headergroup.updateHeader(header);
    }

    @Override
    public void setHeader(String str, String str2) {
        Args.notNull(str, "Header name");
        this.headergroup.updateHeader(new BasicHeader(str, str2));
    }

    @Override
    public void setHeaders(Header[] headerArr) {
        this.headergroup.setHeaders(headerArr);
    }

    @Override
    public void removeHeader(Header header) {
        this.headergroup.removeHeader(header);
    }

    @Override
    public void removeHeaders(String str) {
        if (str == null) {
            return;
        }
        HeaderIterator it = this.headergroup.iterator();
        while (it.hasNext()) {
            if (str.equalsIgnoreCase(it.nextHeader().getName())) {
                it.remove();
            }
        }
    }

    @Override
    public HeaderIterator headerIterator() {
        return this.headergroup.iterator();
    }

    @Override
    public HeaderIterator headerIterator(String str) {
        return this.headergroup.iterator(str);
    }

    @Override
    @Deprecated
    public HttpParams getParams() {
        if (this.params == null) {
            this.params = new BasicHttpParams();
        }
        return this.params;
    }

    @Override
    @Deprecated
    public void setParams(HttpParams httpParams) {
        this.params = (HttpParams) Args.notNull(httpParams, "HTTP parameters");
    }
}
