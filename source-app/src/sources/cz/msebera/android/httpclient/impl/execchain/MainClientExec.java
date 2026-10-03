package cz.msebera.android.httpclient.impl.execchain;

import cz.msebera.android.httpclient.ConnectionReuseStrategy;
import cz.msebera.android.httpclient.HttpClientConnection;
import cz.msebera.android.httpclient.HttpEntity;
import cz.msebera.android.httpclient.HttpEntityEnclosingRequest;
import cz.msebera.android.httpclient.HttpException;
import cz.msebera.android.httpclient.HttpHost;
import cz.msebera.android.httpclient.HttpRequest;
import cz.msebera.android.httpclient.HttpResponse;
import cz.msebera.android.httpclient.auth.AuthProtocolState;
import cz.msebera.android.httpclient.auth.AuthState;
import cz.msebera.android.httpclient.client.AuthenticationStrategy;
import cz.msebera.android.httpclient.client.NonRepeatableRequestException;
import cz.msebera.android.httpclient.client.UserTokenHandler;
import cz.msebera.android.httpclient.client.config.RequestConfig;
import cz.msebera.android.httpclient.client.methods.CloseableHttpResponse;
import cz.msebera.android.httpclient.client.methods.HttpExecutionAware;
import cz.msebera.android.httpclient.client.methods.HttpRequestWrapper;
import cz.msebera.android.httpclient.client.protocol.HttpClientContext;
import cz.msebera.android.httpclient.client.protocol.RequestClientConnControl;
import cz.msebera.android.httpclient.conn.ConnectionKeepAliveStrategy;
import cz.msebera.android.httpclient.conn.ConnectionRequest;
import cz.msebera.android.httpclient.conn.HttpClientConnectionManager;
import cz.msebera.android.httpclient.conn.routing.BasicRouteDirector;
import cz.msebera.android.httpclient.conn.routing.HttpRoute;
import cz.msebera.android.httpclient.conn.routing.HttpRouteDirector;
import cz.msebera.android.httpclient.conn.routing.RouteTracker;
import cz.msebera.android.httpclient.entity.BufferedHttpEntity;
import cz.msebera.android.httpclient.extras.HttpClientAndroidLog;
import cz.msebera.android.httpclient.impl.auth.HttpAuthenticator;
import cz.msebera.android.httpclient.impl.conn.ConnectionShutdownException;
import cz.msebera.android.httpclient.message.BasicHttpRequest;
import cz.msebera.android.httpclient.protocol.HttpProcessor;
import cz.msebera.android.httpclient.protocol.HttpRequestExecutor;
import cz.msebera.android.httpclient.protocol.ImmutableHttpProcessor;
import cz.msebera.android.httpclient.protocol.RequestTargetHost;
import cz.msebera.android.httpclient.util.Args;
import cz.msebera.android.httpclient.util.EntityUtils;
import java.io.IOException;
import java.io.InterruptedIOException;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;

public class MainClientExec implements ClientExecChain {
    private final HttpAuthenticator authenticator;
    private final HttpClientConnectionManager connManager;
    private final ConnectionKeepAliveStrategy keepAliveStrategy;
    public HttpClientAndroidLog log = new HttpClientAndroidLog(getClass());
    private final AuthenticationStrategy proxyAuthStrategy;
    private final HttpProcessor proxyHttpProcessor;
    private final HttpRequestExecutor requestExecutor;
    private final ConnectionReuseStrategy reuseStrategy;
    private final HttpRouteDirector routeDirector;
    private final AuthenticationStrategy targetAuthStrategy;
    private final UserTokenHandler userTokenHandler;

    public MainClientExec(HttpRequestExecutor httpRequestExecutor, HttpClientConnectionManager httpClientConnectionManager, ConnectionReuseStrategy connectionReuseStrategy, ConnectionKeepAliveStrategy connectionKeepAliveStrategy, AuthenticationStrategy authenticationStrategy, AuthenticationStrategy authenticationStrategy2, UserTokenHandler userTokenHandler) {
        Args.notNull(httpRequestExecutor, "HTTP request executor");
        Args.notNull(httpClientConnectionManager, "Client connection manager");
        Args.notNull(connectionReuseStrategy, "Connection reuse strategy");
        Args.notNull(connectionKeepAliveStrategy, "Connection keep alive strategy");
        Args.notNull(authenticationStrategy, "Target authentication strategy");
        Args.notNull(authenticationStrategy2, "Proxy authentication strategy");
        Args.notNull(userTokenHandler, "User token handler");
        this.authenticator = new HttpAuthenticator();
        this.proxyHttpProcessor = new ImmutableHttpProcessor(new RequestTargetHost(), new RequestClientConnControl());
        this.routeDirector = new BasicRouteDirector();
        this.requestExecutor = httpRequestExecutor;
        this.connManager = httpClientConnectionManager;
        this.reuseStrategy = connectionReuseStrategy;
        this.keepAliveStrategy = connectionKeepAliveStrategy;
        this.targetAuthStrategy = authenticationStrategy;
        this.proxyAuthStrategy = authenticationStrategy2;
        this.userTokenHandler = userTokenHandler;
    }

    @Override
    public CloseableHttpResponse execute(HttpRoute httpRoute, HttpRequestWrapper httpRequestWrapper, HttpClientContext httpClientContext, HttpExecutionAware httpExecutionAware) throws HttpException, IOException {
        RuntimeException runtimeException;
        ConnectionHolder connectionHolder;
        IOException iOException;
        HttpException httpException;
        ConnectionHolder connectionHolder2;
        int i;
        Object obj;
        HttpResponse response;
        Object userToken;
        AuthState authState;
        String str;
        HttpRoute httpRoute2 = httpRoute;
        HttpExecutionAware httpExecutionAware2 = httpExecutionAware;
        Args.notNull(httpRoute2, "HTTP route");
        Args.notNull(httpRequestWrapper, "HTTP request");
        Args.notNull(httpClientContext, "HTTP context");
        AuthState targetAuthState = httpClientContext.getTargetAuthState();
        if (targetAuthState == null) {
            targetAuthState = new AuthState();
            httpClientContext.setAttribute("http.auth.target-scope", targetAuthState);
        }
        AuthState authState2 = targetAuthState;
        AuthState proxyAuthState = httpClientContext.getProxyAuthState();
        if (proxyAuthState == null) {
            proxyAuthState = new AuthState();
            httpClientContext.setAttribute("http.auth.proxy-scope", proxyAuthState);
        }
        AuthState authState3 = proxyAuthState;
        if (httpRequestWrapper instanceof HttpEntityEnclosingRequest) {
            RequestEntityProxy.enhance((HttpEntityEnclosingRequest) httpRequestWrapper);
        }
        Object userToken2 = httpClientContext.getUserToken();
        ConnectionRequest connectionRequestRequestConnection = this.connManager.requestConnection(httpRoute2, userToken2);
        String str2 = "Request aborted";
        if (httpExecutionAware2 != null) {
            if (httpExecutionAware.isAborted()) {
                connectionRequestRequestConnection.cancel();
                throw new RequestAbortedException("Request aborted");
            }
            httpExecutionAware2.setCancellable(connectionRequestRequestConnection);
        }
        RequestConfig requestConfig = httpClientContext.getRequestConfig();
        try {
            int connectionRequestTimeout = requestConfig.getConnectionRequestTimeout();
            HttpClientConnection httpClientConnection = connectionRequestRequestConnection.get(connectionRequestTimeout > 0 ? connectionRequestTimeout : 0L, TimeUnit.MILLISECONDS);
            httpClientContext.setAttribute("http.connection", httpClientConnection);
            if (requestConfig.isStaleConnectionCheckEnabled() && httpClientConnection.isOpen()) {
                this.log.debug("Stale connection check");
                if (httpClientConnection.isStale()) {
                    this.log.debug("Stale connection detected");
                    httpClientConnection.close();
                }
            }
            ConnectionHolder connectionHolder3 = new ConnectionHolder(this.log, this.connManager, httpClientConnection);
            if (httpExecutionAware2 != null) {
                try {
                    try {
                        httpExecutionAware2.setCancellable(connectionHolder3);
                    } catch (ConnectionShutdownException e) {
                        InterruptedIOException interruptedIOException = new InterruptedIOException("Connection has been shut down");
                        interruptedIOException.initCause(e);
                        throw interruptedIOException;
                    }
                } catch (HttpException e2) {
                    httpException = e2;
                    connectionHolder = connectionHolder3;
                    connectionHolder.abortConnection();
                    throw httpException;
                } catch (IOException e3) {
                    iOException = e3;
                    connectionHolder = connectionHolder3;
                    connectionHolder.abortConnection();
                    throw iOException;
                } catch (RuntimeException e4) {
                    runtimeException = e4;
                    connectionHolder = connectionHolder3;
                    connectionHolder.abortConnection();
                    throw runtimeException;
                }
            }
            int i2 = 1;
            int i3 = 1;
            while (true) {
                if (i3 > i2 && !RequestEntityProxy.isRepeatable(httpRequestWrapper)) {
                    throw new NonRepeatableRequestException("Cannot retry request with a non-repeatable request entity.");
                }
                if (httpExecutionAware2 != null && httpExecutionAware.isAborted()) {
                    throw new RequestAbortedException(str2);
                }
                try {
                    if (httpClientConnection.isOpen()) {
                        i = i2;
                        connectionHolder2 = connectionHolder3;
                        obj = userToken2;
                    } else {
                        try {
                            HttpClientAndroidLog httpClientAndroidLog = this.log;
                            StringBuilder sb = new StringBuilder();
                            connectionHolder2 = connectionHolder3;
                            try {
                                sb.append("Opening connection ");
                                sb.append(httpRoute2);
                                httpClientAndroidLog.debug(sb.toString());
                                i = 1;
                                obj = userToken2;
                                try {
                                    establishRoute(authState3, httpClientConnection, httpRoute, httpRequestWrapper, httpClientContext);
                                } catch (TunnelRefusedException e5) {
                                    if (this.log.isDebugEnabled()) {
                                        this.log.debug(e5.getMessage());
                                    }
                                    response = e5.getResponse();
                                    connectionHolder = connectionHolder2;
                                }
                            } catch (HttpException e6) {
                                e = e6;
                                httpException = e;
                                connectionHolder = connectionHolder2;
                                connectionHolder.abortConnection();
                                throw httpException;
                            } catch (IOException e7) {
                                e = e7;
                                iOException = e;
                                connectionHolder = connectionHolder2;
                                connectionHolder.abortConnection();
                                throw iOException;
                            } catch (RuntimeException e8) {
                                e = e8;
                                runtimeException = e;
                                connectionHolder = connectionHolder2;
                                connectionHolder.abortConnection();
                                throw runtimeException;
                            }
                        } catch (HttpException e9) {
                            e = e9;
                            connectionHolder2 = connectionHolder3;
                        } catch (IOException e10) {
                            e = e10;
                            connectionHolder2 = connectionHolder3;
                        } catch (RuntimeException e11) {
                            e = e11;
                            connectionHolder2 = connectionHolder3;
                        }
                    }
                    try {
                        int socketTimeout = requestConfig.getSocketTimeout();
                        if (socketTimeout >= 0) {
                            httpClientConnection.setSocketTimeout(socketTimeout);
                        }
                        if (httpExecutionAware2 != null && httpExecutionAware.isAborted()) {
                            throw new RequestAbortedException(str2);
                        }
                        if (this.log.isDebugEnabled()) {
                            this.log.debug("Executing request " + httpRequestWrapper.getRequestLine());
                        }
                        if (!httpRequestWrapper.containsHeader("Authorization")) {
                            if (this.log.isDebugEnabled()) {
                                this.log.debug("Target auth state: " + authState2.getState());
                            }
                            this.authenticator.generateAuthResponse(httpRequestWrapper, authState2, httpClientContext);
                        }
                        if (httpRequestWrapper.containsHeader("Proxy-Authorization") || httpRoute.isTunnelled()) {
                            authState = authState3;
                        } else {
                            if (this.log.isDebugEnabled()) {
                                this.log.debug("Proxy auth state: " + authState3.getState());
                            }
                            authState = authState3;
                            this.authenticator.generateAuthResponse(httpRequestWrapper, authState, httpClientContext);
                        }
                        HttpResponse httpResponseExecute = this.requestExecutor.execute(httpRequestWrapper, httpClientConnection, httpClientContext);
                        if (this.reuseStrategy.keepAlive(httpResponseExecute, httpClientContext)) {
                            long keepAliveDuration = this.keepAliveStrategy.getKeepAliveDuration(httpResponseExecute, httpClientContext);
                            if (this.log.isDebugEnabled()) {
                                if (keepAliveDuration > 0) {
                                    str = "for " + keepAliveDuration + " " + TimeUnit.MILLISECONDS;
                                } else {
                                    str = "indefinitely";
                                }
                                this.log.debug("Connection can be kept alive " + str);
                            }
                            connectionHolder = connectionHolder2;
                            try {
                                connectionHolder.setValidFor(keepAliveDuration, TimeUnit.MILLISECONDS);
                                connectionHolder.markReusable();
                            } catch (HttpException e12) {
                                e = e12;
                                httpException = e;
                                connectionHolder.abortConnection();
                                throw httpException;
                            } catch (IOException e13) {
                                e = e13;
                                iOException = e;
                                connectionHolder.abortConnection();
                                throw iOException;
                            } catch (RuntimeException e14) {
                                e = e14;
                                runtimeException = e;
                                connectionHolder.abortConnection();
                                throw runtimeException;
                            }
                        } else {
                            httpResponseExecute = httpResponseExecute;
                            connectionHolder = connectionHolder2;
                            connectionHolder.markNonReusable();
                        }
                        HttpResponse httpResponse = httpResponseExecute;
                        AuthState authState4 = authState;
                        if (!needAuthentication(authState2, authState, httpRoute, httpResponse, httpClientContext)) {
                            response = httpResponse;
                            break;
                        }
                        HttpEntity entity = httpResponse.getEntity();
                        if (connectionHolder.isReusable()) {
                            EntityUtils.consume(entity);
                        } else {
                            httpClientConnection.close();
                            if (authState4.getState() == AuthProtocolState.SUCCESS && authState4.getAuthScheme() != null && authState4.getAuthScheme().isConnectionBased()) {
                                this.log.debug("Resetting proxy auth state");
                                authState4.reset();
                            }
                            if (authState2.getState() == AuthProtocolState.SUCCESS && authState2.getAuthScheme() != null && authState2.getAuthScheme().isConnectionBased()) {
                                this.log.debug("Resetting target auth state");
                                authState2.reset();
                            }
                        }
                        HttpRequest original = httpRequestWrapper.getOriginal();
                        if (!original.containsHeader("Authorization")) {
                            httpRequestWrapper.removeHeaders("Authorization");
                        }
                        if (!original.containsHeader("Proxy-Authorization")) {
                            httpRequestWrapper.removeHeaders("Proxy-Authorization");
                        }
                        i3++;
                        httpClientConnection = httpClientConnection;
                        connectionHolder3 = connectionHolder;
                        str2 = str2;
                        i2 = i;
                        authState3 = authState4;
                        userToken2 = obj;
                        httpRoute2 = httpRoute;
                        httpExecutionAware2 = httpExecutionAware;
                    } catch (HttpException e15) {
                        e = e15;
                        connectionHolder = connectionHolder2;
                    } catch (IOException e16) {
                        e = e16;
                        connectionHolder = connectionHolder2;
                    } catch (RuntimeException e17) {
                        e = e17;
                        connectionHolder = connectionHolder2;
                    }
                } catch (HttpException e18) {
                    e = e18;
                    connectionHolder = connectionHolder3;
                } catch (IOException e19) {
                    e = e19;
                    connectionHolder = connectionHolder3;
                } catch (RuntimeException e20) {
                    e = e20;
                    connectionHolder = connectionHolder3;
                }
            }
            if (obj == null) {
                userToken = this.userTokenHandler.getUserToken(httpClientContext);
                httpClientContext.setAttribute("http.user-token", userToken);
            } else {
                userToken = obj;
            }
            if (userToken != null) {
                connectionHolder.setState(userToken);
            }
            HttpEntity entity2 = response.getEntity();
            if (entity2 != null && entity2.isStreaming()) {
                return new HttpResponseProxy(response, connectionHolder);
            }
            connectionHolder.releaseConnection();
            return new HttpResponseProxy(response, null);
        } catch (InterruptedException e21) {
            Thread.currentThread().interrupt();
            throw new RequestAbortedException("Request aborted", e21);
        } catch (ExecutionException e22) {
            ExecutionException executionException = e22;
            Throwable cause = executionException.getCause();
            if (cause != null) {
                executionException = cause;
            }
            throw new RequestAbortedException("Request execution failed", executionException);
        }
    }

    void establishRoute(AuthState authState, HttpClientConnection httpClientConnection, HttpRoute httpRoute, HttpRequest httpRequest, HttpClientContext httpClientContext) throws IOException, HttpException {
        int iNextStep;
        int connectTimeout = httpClientContext.getRequestConfig().getConnectTimeout();
        RouteTracker routeTracker = new RouteTracker(httpRoute);
        do {
            HttpRoute route = routeTracker.toRoute();
            iNextStep = this.routeDirector.nextStep(httpRoute, route);
            switch (iNextStep) {
                case -1:
                    throw new HttpException("Unable to establish route: planned = " + httpRoute + "; current = " + route);
                case 0:
                    this.connManager.routeComplete(httpClientConnection, httpRoute, httpClientContext);
                    break;
                case 1:
                    this.connManager.connect(httpClientConnection, httpRoute, connectTimeout > 0 ? connectTimeout : 0, httpClientContext);
                    routeTracker.connectTarget(httpRoute.isSecure());
                    break;
                case 2:
                    this.connManager.connect(httpClientConnection, httpRoute, connectTimeout > 0 ? connectTimeout : 0, httpClientContext);
                    routeTracker.connectProxy(httpRoute.getProxyHost(), false);
                    break;
                case 3:
                    boolean zCreateTunnelToTarget = createTunnelToTarget(authState, httpClientConnection, httpRoute, httpRequest, httpClientContext);
                    this.log.debug("Tunnel to target created.");
                    routeTracker.tunnelTarget(zCreateTunnelToTarget);
                    break;
                case 4:
                    int hopCount = route.getHopCount() - 1;
                    boolean zCreateTunnelToProxy = createTunnelToProxy(httpRoute, hopCount, httpClientContext);
                    this.log.debug("Tunnel to proxy created.");
                    routeTracker.tunnelProxy(httpRoute.getHopTarget(hopCount), zCreateTunnelToProxy);
                    break;
                case 5:
                    this.connManager.upgrade(httpClientConnection, httpRoute, httpClientContext);
                    routeTracker.layerProtocol(httpRoute.isSecure());
                    break;
                default:
                    throw new IllegalStateException("Unknown step indicator " + iNextStep + " from RouteDirector.");
            }
        } while (iNextStep > 0);
    }

    private boolean createTunnelToTarget(AuthState authState, HttpClientConnection httpClientConnection, HttpRoute httpRoute, HttpRequest httpRequest, HttpClientContext httpClientContext) throws HttpException, IOException {
        HttpResponse httpResponseExecute;
        HttpResponse httpResponse;
        RequestConfig requestConfig = httpClientContext.getRequestConfig();
        int connectTimeout = requestConfig.getConnectTimeout();
        HttpHost targetHost = httpRoute.getTargetHost();
        HttpHost proxyHost = httpRoute.getProxyHost();
        BasicHttpRequest basicHttpRequest = new BasicHttpRequest("CONNECT", targetHost.toHostString(), httpRequest.getProtocolVersion());
        this.requestExecutor.preProcess(basicHttpRequest, this.proxyHttpProcessor, httpClientContext);
        while (true) {
            HttpResponse httpResponse2 = null;
            while (true) {
                if (httpResponse2 == null) {
                    if (!httpClientConnection.isOpen()) {
                        this.connManager.connect(httpClientConnection, httpRoute, connectTimeout > 0 ? connectTimeout : 0, httpClientContext);
                    }
                    basicHttpRequest.removeHeaders("Proxy-Authorization");
                    this.authenticator.generateAuthResponse(basicHttpRequest, authState, httpClientContext);
                    httpResponseExecute = this.requestExecutor.execute(basicHttpRequest, httpClientConnection, httpClientContext);
                    if (httpResponseExecute.getStatusLine().getStatusCode() < 200) {
                        throw new HttpException("Unexpected response to CONNECT request: " + httpResponseExecute.getStatusLine());
                    }
                    if (!requestConfig.isAuthenticationEnabled()) {
                        httpResponse = httpResponseExecute;
                    } else if (!this.authenticator.isAuthenticationRequested(proxyHost, httpResponseExecute, this.proxyAuthStrategy, authState, httpClientContext) || !this.authenticator.handleAuthChallenge(proxyHost, httpResponseExecute, this.proxyAuthStrategy, authState, httpClientContext)) {
                        httpResponse = httpResponseExecute;
                    }
                    httpResponse2 = httpResponse;
                } else {
                    if (httpResponse2.getStatusLine().getStatusCode() <= 299) {
                        return false;
                    }
                    HttpEntity entity = httpResponse2.getEntity();
                    if (entity != null) {
                        httpResponse2.setEntity(new BufferedHttpEntity(entity));
                    }
                    httpClientConnection.close();
                    throw new TunnelRefusedException("CONNECT refused by proxy: " + httpResponse2.getStatusLine(), httpResponse2);
                }
            }
            if (this.reuseStrategy.keepAlive(httpResponseExecute, httpClientContext)) {
                this.log.debug("Connection kept alive");
                EntityUtils.consume(httpResponseExecute.getEntity());
            } else {
                httpClientConnection.close();
            }
        }
    }

    private boolean createTunnelToProxy(HttpRoute httpRoute, int i, HttpClientContext httpClientContext) throws HttpException {
        throw new HttpException("Proxy chains are not supported.");
    }

    private boolean needAuthentication(AuthState authState, AuthState authState2, HttpRoute httpRoute, HttpResponse httpResponse, HttpClientContext httpClientContext) {
        if (!httpClientContext.getRequestConfig().isAuthenticationEnabled()) {
            return false;
        }
        HttpHost targetHost = httpClientContext.getTargetHost();
        if (targetHost == null) {
            targetHost = httpRoute.getTargetHost();
        }
        if (targetHost.getPort() < 0) {
            targetHost = new HttpHost(targetHost.getHostName(), httpRoute.getTargetHost().getPort(), targetHost.getSchemeName());
        }
        boolean zIsAuthenticationRequested = this.authenticator.isAuthenticationRequested(targetHost, httpResponse, this.targetAuthStrategy, authState, httpClientContext);
        HttpHost proxyHost = httpRoute.getProxyHost();
        if (proxyHost == null) {
            proxyHost = httpRoute.getTargetHost();
        }
        boolean zIsAuthenticationRequested2 = this.authenticator.isAuthenticationRequested(proxyHost, httpResponse, this.proxyAuthStrategy, authState2, httpClientContext);
        if (zIsAuthenticationRequested) {
            return this.authenticator.handleAuthChallenge(targetHost, httpResponse, this.targetAuthStrategy, authState, httpClientContext);
        }
        if (!zIsAuthenticationRequested2) {
            return false;
        }
        return this.authenticator.handleAuthChallenge(proxyHost, httpResponse, this.proxyAuthStrategy, authState2, httpClientContext);
    }
}
