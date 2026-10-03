package cz.msebera.android.httpclient.impl.client.cache;

import cz.msebera.android.httpclient.Header;
import cz.msebera.android.httpclient.HeaderIterator;
import cz.msebera.android.httpclient.HttpEntity;
import cz.msebera.android.httpclient.HttpResponse;
import cz.msebera.android.httpclient.HttpStatus;
import cz.msebera.android.httpclient.HttpVersion;
import cz.msebera.android.httpclient.ProtocolVersion;
import cz.msebera.android.httpclient.StatusLine;
import cz.msebera.android.httpclient.message.AbstractHttpMessage;
import cz.msebera.android.httpclient.message.BasicStatusLine;
import cz.msebera.android.httpclient.params.BasicHttpParams;
import cz.msebera.android.httpclient.params.HttpParams;
import java.util.Locale;

final class OptionsHttp11Response extends AbstractHttpMessage implements HttpResponse {
    private final StatusLine statusLine = new BasicStatusLine(HttpVersion.HTTP_1_1, HttpStatus.SC_NOT_IMPLEMENTED, "");
    private final ProtocolVersion version = HttpVersion.HTTP_1_1;

    @Override
    public void addHeader(Header header) {
    }

    @Override
    public void addHeader(String str, String str2) {
    }

    @Override
    public HttpEntity getEntity() {
        return null;
    }

    @Override
    public Locale getLocale() {
        return null;
    }

    @Override
    public void removeHeader(Header header) {
    }

    @Override
    public void removeHeaders(String str) {
    }

    @Override
    public void setEntity(HttpEntity httpEntity) {
    }

    @Override
    public void setHeader(Header header) {
    }

    @Override
    public void setHeader(String str, String str2) {
    }

    @Override
    public void setHeaders(Header[] headerArr) {
    }

    @Override
    public void setLocale(Locale locale) {
    }

    @Override
    public void setParams(HttpParams httpParams) {
    }

    @Override
    public void setReasonPhrase(String str) throws IllegalStateException {
    }

    @Override
    public void setStatusCode(int i) throws IllegalStateException {
    }

    @Override
    public void setStatusLine(ProtocolVersion protocolVersion, int i) {
    }

    @Override
    public void setStatusLine(ProtocolVersion protocolVersion, int i, String str) {
    }

    @Override
    public void setStatusLine(StatusLine statusLine) {
    }

    OptionsHttp11Response() {
    }

    @Override
    public StatusLine getStatusLine() {
        return this.statusLine;
    }

    @Override
    public ProtocolVersion getProtocolVersion() {
        return this.version;
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
    public HeaderIterator headerIterator() {
        return this.headergroup.iterator();
    }

    @Override
    public HeaderIterator headerIterator(String str) {
        return this.headergroup.iterator(str);
    }

    @Override
    public HttpParams getParams() {
        if (this.params == null) {
            this.params = new BasicHttpParams();
        }
        return this.params;
    }
}
