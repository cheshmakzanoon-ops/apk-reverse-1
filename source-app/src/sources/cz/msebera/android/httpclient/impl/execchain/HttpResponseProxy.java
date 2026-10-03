package cz.msebera.android.httpclient.impl.execchain;

import cz.msebera.android.httpclient.Header;
import cz.msebera.android.httpclient.HeaderIterator;
import cz.msebera.android.httpclient.HttpEntity;
import cz.msebera.android.httpclient.HttpResponse;
import cz.msebera.android.httpclient.ProtocolVersion;
import cz.msebera.android.httpclient.StatusLine;
import cz.msebera.android.httpclient.client.methods.CloseableHttpResponse;
import cz.msebera.android.httpclient.params.HttpParams;
import java.io.IOException;
import java.util.Locale;
import kotlinx.serialization.json.internal.AbstractJsonLexerKt;

class HttpResponseProxy implements CloseableHttpResponse {
    private final ConnectionHolder connHolder;
    private final HttpResponse original;

    public HttpResponseProxy(HttpResponse httpResponse, ConnectionHolder connectionHolder) {
        this.original = httpResponse;
        this.connHolder = connectionHolder;
        ResponseEntityProxy.enchance(httpResponse, connectionHolder);
    }

    @Override
    public void close() throws IOException {
        ConnectionHolder connectionHolder = this.connHolder;
        if (connectionHolder != null) {
            connectionHolder.abortConnection();
        }
    }

    @Override
    public StatusLine getStatusLine() {
        return this.original.getStatusLine();
    }

    @Override
    public void setStatusLine(StatusLine statusLine) {
        this.original.setStatusLine(statusLine);
    }

    @Override
    public void setStatusLine(ProtocolVersion protocolVersion, int i) {
        this.original.setStatusLine(protocolVersion, i);
    }

    @Override
    public void setStatusLine(ProtocolVersion protocolVersion, int i, String str) {
        this.original.setStatusLine(protocolVersion, i, str);
    }

    @Override
    public void setStatusCode(int i) throws IllegalStateException {
        this.original.setStatusCode(i);
    }

    @Override
    public void setReasonPhrase(String str) throws IllegalStateException {
        this.original.setReasonPhrase(str);
    }

    @Override
    public HttpEntity getEntity() {
        return this.original.getEntity();
    }

    @Override
    public void setEntity(HttpEntity httpEntity) {
        this.original.setEntity(httpEntity);
    }

    @Override
    public Locale getLocale() {
        return this.original.getLocale();
    }

    @Override
    public void setLocale(Locale locale) {
        this.original.setLocale(locale);
    }

    @Override
    public ProtocolVersion getProtocolVersion() {
        return this.original.getProtocolVersion();
    }

    @Override
    public boolean containsHeader(String str) {
        return this.original.containsHeader(str);
    }

    @Override
    public Header[] getHeaders(String str) {
        return this.original.getHeaders(str);
    }

    @Override
    public Header getFirstHeader(String str) {
        return this.original.getFirstHeader(str);
    }

    @Override
    public Header getLastHeader(String str) {
        return this.original.getLastHeader(str);
    }

    @Override
    public Header[] getAllHeaders() {
        return this.original.getAllHeaders();
    }

    @Override
    public void addHeader(Header header) {
        this.original.addHeader(header);
    }

    @Override
    public void addHeader(String str, String str2) {
        this.original.addHeader(str, str2);
    }

    @Override
    public void setHeader(Header header) {
        this.original.setHeader(header);
    }

    @Override
    public void setHeader(String str, String str2) {
        this.original.setHeader(str, str2);
    }

    @Override
    public void setHeaders(Header[] headerArr) {
        this.original.setHeaders(headerArr);
    }

    @Override
    public void removeHeader(Header header) {
        this.original.removeHeader(header);
    }

    @Override
    public void removeHeaders(String str) {
        this.original.removeHeaders(str);
    }

    @Override
    public HeaderIterator headerIterator() {
        return this.original.headerIterator();
    }

    @Override
    public HeaderIterator headerIterator(String str) {
        return this.original.headerIterator(str);
    }

    @Override
    @Deprecated
    public HttpParams getParams() {
        return this.original.getParams();
    }

    @Override
    @Deprecated
    public void setParams(HttpParams httpParams) {
        this.original.setParams(httpParams);
    }

    public String toString() {
        return "HttpResponseProxy{" + this.original + AbstractJsonLexerKt.END_OBJ;
    }
}
