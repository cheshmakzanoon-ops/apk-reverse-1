package cz.msebera.android.httpclient.impl.conn;

import cz.msebera.android.httpclient.HttpConnectionMetrics;
import cz.msebera.android.httpclient.HttpEntityEnclosingRequest;
import cz.msebera.android.httpclient.HttpException;
import cz.msebera.android.httpclient.HttpHost;
import cz.msebera.android.httpclient.HttpRequest;
import cz.msebera.android.httpclient.HttpResponse;
import cz.msebera.android.httpclient.conn.ClientConnectionManager;
import cz.msebera.android.httpclient.conn.ClientConnectionOperator;
import cz.msebera.android.httpclient.conn.ManagedClientConnection;
import cz.msebera.android.httpclient.conn.OperatedClientConnection;
import cz.msebera.android.httpclient.conn.routing.HttpRoute;
import cz.msebera.android.httpclient.conn.routing.RouteTracker;
import cz.msebera.android.httpclient.params.HttpParams;
import cz.msebera.android.httpclient.protocol.HttpContext;
import cz.msebera.android.httpclient.util.Args;
import cz.msebera.android.httpclient.util.Asserts;
import java.io.IOException;
import java.io.InterruptedIOException;
import java.net.InetAddress;
import java.net.Socket;
import java.util.concurrent.TimeUnit;
import javax.net.ssl.SSLSession;
import javax.net.ssl.SSLSocket;
import kotlin.jvm.internal.LongCompanionObject;

@Deprecated
class ManagedClientConnectionImpl implements ManagedClientConnection {
    private volatile long duration;
    private final ClientConnectionManager manager;
    private final ClientConnectionOperator operator;
    private volatile HttpPoolEntry poolEntry;
    private volatile boolean reusable;

    @Override
    public String getId() {
        return null;
    }

    ManagedClientConnectionImpl(ClientConnectionManager clientConnectionManager, ClientConnectionOperator clientConnectionOperator, HttpPoolEntry httpPoolEntry) {
        Args.notNull(clientConnectionManager, "Connection manager");
        Args.notNull(clientConnectionOperator, "Connection operator");
        Args.notNull(httpPoolEntry, "HTTP pool entry");
        this.manager = clientConnectionManager;
        this.operator = clientConnectionOperator;
        this.poolEntry = httpPoolEntry;
        this.reusable = false;
        this.duration = LongCompanionObject.MAX_VALUE;
    }

    HttpPoolEntry getPoolEntry() {
        return this.poolEntry;
    }

    HttpPoolEntry detach() {
        HttpPoolEntry httpPoolEntry = this.poolEntry;
        this.poolEntry = null;
        return httpPoolEntry;
    }

    public ClientConnectionManager getManager() {
        return this.manager;
    }

    private OperatedClientConnection getConnection() {
        HttpPoolEntry httpPoolEntry = this.poolEntry;
        if (httpPoolEntry == null) {
            return null;
        }
        return httpPoolEntry.getConnection();
    }

    private OperatedClientConnection ensureConnection() {
        HttpPoolEntry httpPoolEntry = this.poolEntry;
        if (httpPoolEntry == null) {
            throw new ConnectionShutdownException();
        }
        return httpPoolEntry.getConnection();
    }

    private HttpPoolEntry ensurePoolEntry() {
        HttpPoolEntry httpPoolEntry = this.poolEntry;
        if (httpPoolEntry != null) {
            return httpPoolEntry;
        }
        throw new ConnectionShutdownException();
    }

    @Override
    public void close() throws IOException {
        HttpPoolEntry httpPoolEntry = this.poolEntry;
        if (httpPoolEntry != null) {
            OperatedClientConnection connection = httpPoolEntry.getConnection();
            httpPoolEntry.getTracker().reset();
            connection.close();
        }
    }

    @Override
    public void shutdown() throws IOException {
        HttpPoolEntry httpPoolEntry = this.poolEntry;
        if (httpPoolEntry != null) {
            OperatedClientConnection connection = httpPoolEntry.getConnection();
            httpPoolEntry.getTracker().reset();
            connection.shutdown();
        }
    }

    @Override
    public boolean isOpen() {
        OperatedClientConnection connection = getConnection();
        if (connection != null) {
            return connection.isOpen();
        }
        return false;
    }

    @Override
    public boolean isStale() {
        OperatedClientConnection connection = getConnection();
        if (connection != null) {
            return connection.isStale();
        }
        return true;
    }

    @Override
    public void setSocketTimeout(int i) {
        ensureConnection().setSocketTimeout(i);
    }

    @Override
    public int getSocketTimeout() {
        return ensureConnection().getSocketTimeout();
    }

    @Override
    public HttpConnectionMetrics getMetrics() {
        return ensureConnection().getMetrics();
    }

    @Override
    public void flush() throws IOException {
        ensureConnection().flush();
    }

    @Override
    public boolean isResponseAvailable(int i) throws IOException {
        return ensureConnection().isResponseAvailable(i);
    }

    @Override
    public void receiveResponseEntity(HttpResponse httpResponse) throws HttpException, IOException {
        ensureConnection().receiveResponseEntity(httpResponse);
    }

    @Override
    public HttpResponse receiveResponseHeader() throws HttpException, IOException {
        return ensureConnection().receiveResponseHeader();
    }

    @Override
    public void sendRequestEntity(HttpEntityEnclosingRequest httpEntityEnclosingRequest) throws HttpException, IOException {
        ensureConnection().sendRequestEntity(httpEntityEnclosingRequest);
    }

    @Override
    public void sendRequestHeader(HttpRequest httpRequest) throws HttpException, IOException {
        ensureConnection().sendRequestHeader(httpRequest);
    }

    @Override
    public InetAddress getLocalAddress() {
        return ensureConnection().getLocalAddress();
    }

    @Override
    public int getLocalPort() {
        return ensureConnection().getLocalPort();
    }

    @Override
    public InetAddress getRemoteAddress() {
        return ensureConnection().getRemoteAddress();
    }

    @Override
    public int getRemotePort() {
        return ensureConnection().getRemotePort();
    }

    @Override
    public boolean isSecure() {
        return ensureConnection().isSecure();
    }

    @Override
    public void bind(Socket socket) throws IOException {
        throw new UnsupportedOperationException();
    }

    @Override
    public Socket getSocket() {
        return ensureConnection().getSocket();
    }

    @Override
    public SSLSession getSSLSession() {
        Socket socket = ensureConnection().getSocket();
        if (socket instanceof SSLSocket) {
            return ((SSLSocket) socket).getSession();
        }
        return null;
    }

    public Object getAttribute(String str) {
        OperatedClientConnection operatedClientConnectionEnsureConnection = ensureConnection();
        if (operatedClientConnectionEnsureConnection instanceof HttpContext) {
            return ((HttpContext) operatedClientConnectionEnsureConnection).getAttribute(str);
        }
        return null;
    }

    public Object removeAttribute(String str) {
        OperatedClientConnection operatedClientConnectionEnsureConnection = ensureConnection();
        if (operatedClientConnectionEnsureConnection instanceof HttpContext) {
            return ((HttpContext) operatedClientConnectionEnsureConnection).removeAttribute(str);
        }
        return null;
    }

    public void setAttribute(String str, Object obj) {
        OperatedClientConnection operatedClientConnectionEnsureConnection = ensureConnection();
        if (operatedClientConnectionEnsureConnection instanceof HttpContext) {
            ((HttpContext) operatedClientConnectionEnsureConnection).setAttribute(str, obj);
        }
    }

    @Override
    public HttpRoute getRoute() {
        return ensurePoolEntry().getEffectiveRoute();
    }

    @Override
    public void open(HttpRoute httpRoute, HttpContext httpContext, HttpParams httpParams) throws IOException {
        OperatedClientConnection connection;
        Args.notNull(httpRoute, "Route");
        Args.notNull(httpParams, "HTTP parameters");
        synchronized (this) {
            if (this.poolEntry == null) {
                throw new ConnectionShutdownException();
            }
            RouteTracker tracker = this.poolEntry.getTracker();
            Asserts.notNull(tracker, "Route tracker");
            Asserts.check(!tracker.isConnected(), "Connection already open");
            connection = this.poolEntry.getConnection();
        }
        HttpHost proxyHost = httpRoute.getProxyHost();
        this.operator.openConnection(connection, proxyHost != null ? proxyHost : httpRoute.getTargetHost(), httpRoute.getLocalAddress(), httpContext, httpParams);
        synchronized (this) {
            if (this.poolEntry == null) {
                throw new InterruptedIOException();
            }
            RouteTracker tracker2 = this.poolEntry.getTracker();
            if (proxyHost == null) {
                tracker2.connectTarget(connection.isSecure());
            } else {
                tracker2.connectProxy(proxyHost, connection.isSecure());
            }
        }
    }

    @Override
    public void tunnelTarget(boolean z, HttpParams httpParams) throws IOException {
        HttpHost targetHost;
        OperatedClientConnection connection;
        Args.notNull(httpParams, "HTTP parameters");
        synchronized (this) {
            if (this.poolEntry == null) {
                throw new ConnectionShutdownException();
            }
            RouteTracker tracker = this.poolEntry.getTracker();
            Asserts.notNull(tracker, "Route tracker");
            Asserts.check(tracker.isConnected(), "Connection not open");
            Asserts.check(!tracker.isTunnelled(), "Connection is already tunnelled");
            targetHost = tracker.getTargetHost();
            connection = this.poolEntry.getConnection();
        }
        connection.update(null, targetHost, z, httpParams);
        synchronized (this) {
            if (this.poolEntry == null) {
                throw new InterruptedIOException();
            }
            this.poolEntry.getTracker().tunnelTarget(z);
        }
    }

    @Override
    public void tunnelProxy(HttpHost httpHost, boolean z, HttpParams httpParams) throws IOException {
        OperatedClientConnection connection;
        Args.notNull(httpHost, "Next proxy");
        Args.notNull(httpParams, "HTTP parameters");
        synchronized (this) {
            if (this.poolEntry == null) {
                throw new ConnectionShutdownException();
            }
            RouteTracker tracker = this.poolEntry.getTracker();
            Asserts.notNull(tracker, "Route tracker");
            Asserts.check(tracker.isConnected(), "Connection not open");
            connection = this.poolEntry.getConnection();
        }
        connection.update(null, httpHost, z, httpParams);
        synchronized (this) {
            if (this.poolEntry == null) {
                throw new InterruptedIOException();
            }
            this.poolEntry.getTracker().tunnelProxy(httpHost, z);
        }
    }

    @Override
    public void layerProtocol(HttpContext httpContext, HttpParams httpParams) throws IOException {
        HttpHost targetHost;
        OperatedClientConnection connection;
        Args.notNull(httpParams, "HTTP parameters");
        synchronized (this) {
            if (this.poolEntry == null) {
                throw new ConnectionShutdownException();
            }
            RouteTracker tracker = this.poolEntry.getTracker();
            Asserts.notNull(tracker, "Route tracker");
            Asserts.check(tracker.isConnected(), "Connection not open");
            Asserts.check(tracker.isTunnelled(), "Protocol layering without a tunnel not supported");
            Asserts.check(!tracker.isLayered(), "Multiple protocol layering not supported");
            targetHost = tracker.getTargetHost();
            connection = this.poolEntry.getConnection();
        }
        this.operator.updateSecureConnection(connection, targetHost, httpContext, httpParams);
        synchronized (this) {
            if (this.poolEntry == null) {
                throw new InterruptedIOException();
            }
            this.poolEntry.getTracker().layerProtocol(connection.isSecure());
        }
    }

    @Override
    public Object getState() {
        return ensurePoolEntry().getState();
    }

    @Override
    public void setState(Object obj) {
        ensurePoolEntry().setState(obj);
    }

    @Override
    public void markReusable() {
        this.reusable = true;
    }

    @Override
    public void unmarkReusable() {
        this.reusable = false;
    }

    @Override
    public boolean isMarkedReusable() {
        return this.reusable;
    }

    @Override
    public void setIdleDuration(long j, TimeUnit timeUnit) {
        if (j > 0) {
            this.duration = timeUnit.toMillis(j);
        } else {
            this.duration = -1L;
        }
    }

    @Override
    public void releaseConnection() {
        synchronized (this) {
            if (this.poolEntry == null) {
                return;
            }
            this.manager.releaseConnection(this, this.duration, TimeUnit.MILLISECONDS);
            this.poolEntry = null;
        }
    }

    @Override
    public void abortConnection() {
        synchronized (this) {
            if (this.poolEntry == null) {
                return;
            }
            this.reusable = false;
            try {
                this.poolEntry.getConnection().shutdown();
            } catch (IOException unused) {
            }
            this.manager.releaseConnection(this, this.duration, TimeUnit.MILLISECONDS);
            this.poolEntry = null;
        }
    }
}
