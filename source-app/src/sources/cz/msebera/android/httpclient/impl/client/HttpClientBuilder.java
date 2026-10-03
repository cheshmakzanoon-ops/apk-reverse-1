package cz.msebera.android.httpclient.impl.client;

import cz.msebera.android.httpclient.ConnectionReuseStrategy;
import cz.msebera.android.httpclient.Header;
import cz.msebera.android.httpclient.HttpHost;
import cz.msebera.android.httpclient.HttpRequestInterceptor;
import cz.msebera.android.httpclient.HttpResponseInterceptor;
import cz.msebera.android.httpclient.auth.AuthSchemeProvider;
import cz.msebera.android.httpclient.client.AuthenticationStrategy;
import cz.msebera.android.httpclient.client.BackoffManager;
import cz.msebera.android.httpclient.client.ConnectionBackoffStrategy;
import cz.msebera.android.httpclient.client.CookieStore;
import cz.msebera.android.httpclient.client.CredentialsProvider;
import cz.msebera.android.httpclient.client.HttpRequestRetryHandler;
import cz.msebera.android.httpclient.client.RedirectStrategy;
import cz.msebera.android.httpclient.client.ServiceUnavailableRetryStrategy;
import cz.msebera.android.httpclient.client.UserTokenHandler;
import cz.msebera.android.httpclient.client.config.CookieSpecs;
import cz.msebera.android.httpclient.client.config.RequestConfig;
import cz.msebera.android.httpclient.client.params.CookiePolicy;
import cz.msebera.android.httpclient.client.protocol.RequestAcceptEncoding;
import cz.msebera.android.httpclient.client.protocol.RequestAddCookies;
import cz.msebera.android.httpclient.client.protocol.RequestAuthCache;
import cz.msebera.android.httpclient.client.protocol.RequestClientConnControl;
import cz.msebera.android.httpclient.client.protocol.RequestDefaultHeaders;
import cz.msebera.android.httpclient.client.protocol.RequestExpectContinue;
import cz.msebera.android.httpclient.client.protocol.ResponseContentEncoding;
import cz.msebera.android.httpclient.client.protocol.ResponseProcessCookies;
import cz.msebera.android.httpclient.config.ConnectionConfig;
import cz.msebera.android.httpclient.config.Lookup;
import cz.msebera.android.httpclient.config.Registry;
import cz.msebera.android.httpclient.config.RegistryBuilder;
import cz.msebera.android.httpclient.config.SocketConfig;
import cz.msebera.android.httpclient.conn.ConnectionKeepAliveStrategy;
import cz.msebera.android.httpclient.conn.HttpClientConnectionManager;
import cz.msebera.android.httpclient.conn.SchemePortResolver;
import cz.msebera.android.httpclient.conn.routing.HttpRoutePlanner;
import cz.msebera.android.httpclient.conn.socket.ConnectionSocketFactory;
import cz.msebera.android.httpclient.conn.socket.LayeredConnectionSocketFactory;
import cz.msebera.android.httpclient.conn.socket.PlainConnectionSocketFactory;
import cz.msebera.android.httpclient.conn.ssl.SSLConnectionSocketFactory;
import cz.msebera.android.httpclient.conn.ssl.SSLContexts;
import cz.msebera.android.httpclient.conn.ssl.X509HostnameVerifier;
import cz.msebera.android.httpclient.cookie.CookieSpecProvider;
import cz.msebera.android.httpclient.impl.DefaultConnectionReuseStrategy;
import cz.msebera.android.httpclient.impl.NoConnectionReuseStrategy;
import cz.msebera.android.httpclient.impl.auth.BasicSchemeFactory;
import cz.msebera.android.httpclient.impl.auth.DigestSchemeFactory;
import cz.msebera.android.httpclient.impl.auth.NTLMSchemeFactory;
import cz.msebera.android.httpclient.impl.conn.DefaultProxyRoutePlanner;
import cz.msebera.android.httpclient.impl.conn.DefaultRoutePlanner;
import cz.msebera.android.httpclient.impl.conn.DefaultSchemePortResolver;
import cz.msebera.android.httpclient.impl.conn.PoolingHttpClientConnectionManager;
import cz.msebera.android.httpclient.impl.conn.SystemDefaultRoutePlanner;
import cz.msebera.android.httpclient.impl.cookie.BestMatchSpecFactory;
import cz.msebera.android.httpclient.impl.cookie.BrowserCompatSpecFactory;
import cz.msebera.android.httpclient.impl.cookie.IgnoreSpecFactory;
import cz.msebera.android.httpclient.impl.cookie.NetscapeDraftSpecFactory;
import cz.msebera.android.httpclient.impl.cookie.RFC2109SpecFactory;
import cz.msebera.android.httpclient.impl.cookie.RFC2965SpecFactory;
import cz.msebera.android.httpclient.impl.execchain.BackoffStrategyExec;
import cz.msebera.android.httpclient.impl.execchain.ClientExecChain;
import cz.msebera.android.httpclient.impl.execchain.MainClientExec;
import cz.msebera.android.httpclient.impl.execchain.ProtocolExec;
import cz.msebera.android.httpclient.impl.execchain.RedirectExec;
import cz.msebera.android.httpclient.impl.execchain.RetryExec;
import cz.msebera.android.httpclient.impl.execchain.ServiceUnavailableRetryExec;
import cz.msebera.android.httpclient.protocol.HttpProcessor;
import cz.msebera.android.httpclient.protocol.HttpProcessorBuilder;
import cz.msebera.android.httpclient.protocol.HttpRequestExecutor;
import cz.msebera.android.httpclient.protocol.RequestContent;
import cz.msebera.android.httpclient.protocol.RequestTargetHost;
import cz.msebera.android.httpclient.protocol.RequestUserAgent;
import cz.msebera.android.httpclient.util.TextUtils;
import cz.msebera.android.httpclient.util.VersionInfo;
import java.io.Closeable;
import java.net.ProxySelector;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSocketFactory;
import net.aihelp.p007ui.helper.LogoutMqttHelper;

public class HttpClientBuilder {
    static final String DEFAULT_USER_AGENT;
    private boolean authCachingDisabled;
    private Lookup<AuthSchemeProvider> authSchemeRegistry;
    private boolean automaticRetriesDisabled;
    private BackoffManager backoffManager;
    private List<Closeable> closeables;
    private HttpClientConnectionManager connManager;
    private ConnectionBackoffStrategy connectionBackoffStrategy;
    private boolean connectionStateDisabled;
    private boolean contentCompressionDisabled;
    private boolean cookieManagementDisabled;
    private Lookup<CookieSpecProvider> cookieSpecRegistry;
    private CookieStore cookieStore;
    private CredentialsProvider credentialsProvider;
    private ConnectionConfig defaultConnectionConfig;
    private Collection<? extends Header> defaultHeaders;
    private RequestConfig defaultRequestConfig;
    private SocketConfig defaultSocketConfig;
    private X509HostnameVerifier hostnameVerifier;
    private HttpProcessor httpprocessor;
    private ConnectionKeepAliveStrategy keepAliveStrategy;
    private HttpHost proxy;
    private AuthenticationStrategy proxyAuthStrategy;
    private boolean redirectHandlingDisabled;
    private RedirectStrategy redirectStrategy;
    private HttpRequestExecutor requestExec;
    private LinkedList<HttpRequestInterceptor> requestFirst;
    private LinkedList<HttpRequestInterceptor> requestLast;
    private LinkedList<HttpResponseInterceptor> responseFirst;
    private LinkedList<HttpResponseInterceptor> responseLast;
    private HttpRequestRetryHandler retryHandler;
    private ConnectionReuseStrategy reuseStrategy;
    private HttpRoutePlanner routePlanner;
    private SchemePortResolver schemePortResolver;
    private ServiceUnavailableRetryStrategy serviceUnavailStrategy;
    private LayeredConnectionSocketFactory sslSocketFactory;
    private SSLContext sslcontext;
    private boolean systemProperties;
    private AuthenticationStrategy targetAuthStrategy;
    private String userAgent;
    private UserTokenHandler userTokenHandler;
    private int maxConnTotal = 0;
    private int maxConnPerRoute = 0;

    protected ClientExecChain decorateMainExec(ClientExecChain clientExecChain) {
        return clientExecChain;
    }

    protected ClientExecChain decorateProtocolExec(ClientExecChain clientExecChain) {
        return clientExecChain;
    }

    static {
        VersionInfo versionInfoLoadVersionInfo = VersionInfo.loadVersionInfo("cz.msebera.android.httpclient.client", HttpClientBuilder.class.getClassLoader());
        DEFAULT_USER_AGENT = "Apache-HttpClient/" + (versionInfoLoadVersionInfo != null ? versionInfoLoadVersionInfo.getRelease() : VersionInfo.UNAVAILABLE) + " (java 1.5)";
    }

    public static HttpClientBuilder create() {
        return new HttpClientBuilder();
    }

    protected HttpClientBuilder() {
    }

    public final HttpClientBuilder setRequestExecutor(HttpRequestExecutor httpRequestExecutor) {
        this.requestExec = httpRequestExecutor;
        return this;
    }

    public final HttpClientBuilder setHostnameVerifier(X509HostnameVerifier x509HostnameVerifier) {
        this.hostnameVerifier = x509HostnameVerifier;
        return this;
    }

    public final HttpClientBuilder setSslcontext(SSLContext sSLContext) {
        this.sslcontext = sSLContext;
        return this;
    }

    public final HttpClientBuilder setSSLSocketFactory(LayeredConnectionSocketFactory layeredConnectionSocketFactory) {
        this.sslSocketFactory = layeredConnectionSocketFactory;
        return this;
    }

    public final HttpClientBuilder setMaxConnTotal(int i) {
        this.maxConnTotal = i;
        return this;
    }

    public final HttpClientBuilder setMaxConnPerRoute(int i) {
        this.maxConnPerRoute = i;
        return this;
    }

    public final HttpClientBuilder setDefaultSocketConfig(SocketConfig socketConfig) {
        this.defaultSocketConfig = socketConfig;
        return this;
    }

    public final HttpClientBuilder setDefaultConnectionConfig(ConnectionConfig connectionConfig) {
        this.defaultConnectionConfig = connectionConfig;
        return this;
    }

    public final HttpClientBuilder setConnectionManager(HttpClientConnectionManager httpClientConnectionManager) {
        this.connManager = httpClientConnectionManager;
        return this;
    }

    public final HttpClientBuilder setConnectionReuseStrategy(ConnectionReuseStrategy connectionReuseStrategy) {
        this.reuseStrategy = connectionReuseStrategy;
        return this;
    }

    public final HttpClientBuilder setKeepAliveStrategy(ConnectionKeepAliveStrategy connectionKeepAliveStrategy) {
        this.keepAliveStrategy = connectionKeepAliveStrategy;
        return this;
    }

    public final HttpClientBuilder setTargetAuthenticationStrategy(AuthenticationStrategy authenticationStrategy) {
        this.targetAuthStrategy = authenticationStrategy;
        return this;
    }

    public final HttpClientBuilder setProxyAuthenticationStrategy(AuthenticationStrategy authenticationStrategy) {
        this.proxyAuthStrategy = authenticationStrategy;
        return this;
    }

    public final HttpClientBuilder setUserTokenHandler(UserTokenHandler userTokenHandler) {
        this.userTokenHandler = userTokenHandler;
        return this;
    }

    public final HttpClientBuilder disableConnectionState() {
        this.connectionStateDisabled = true;
        return this;
    }

    public final HttpClientBuilder setSchemePortResolver(SchemePortResolver schemePortResolver) {
        this.schemePortResolver = schemePortResolver;
        return this;
    }

    public final HttpClientBuilder setUserAgent(String str) {
        this.userAgent = str;
        return this;
    }

    public final HttpClientBuilder setDefaultHeaders(Collection<? extends Header> collection) {
        this.defaultHeaders = collection;
        return this;
    }

    public final HttpClientBuilder addInterceptorFirst(HttpResponseInterceptor httpResponseInterceptor) {
        if (httpResponseInterceptor == null) {
            return this;
        }
        if (this.responseFirst == null) {
            this.responseFirst = new LinkedList<>();
        }
        this.responseFirst.addFirst(httpResponseInterceptor);
        return this;
    }

    public final HttpClientBuilder addInterceptorLast(HttpResponseInterceptor httpResponseInterceptor) {
        if (httpResponseInterceptor == null) {
            return this;
        }
        if (this.responseLast == null) {
            this.responseLast = new LinkedList<>();
        }
        this.responseLast.addLast(httpResponseInterceptor);
        return this;
    }

    public final HttpClientBuilder addInterceptorFirst(HttpRequestInterceptor httpRequestInterceptor) {
        if (httpRequestInterceptor == null) {
            return this;
        }
        if (this.requestFirst == null) {
            this.requestFirst = new LinkedList<>();
        }
        this.requestFirst.addFirst(httpRequestInterceptor);
        return this;
    }

    public final HttpClientBuilder addInterceptorLast(HttpRequestInterceptor httpRequestInterceptor) {
        if (httpRequestInterceptor == null) {
            return this;
        }
        if (this.requestLast == null) {
            this.requestLast = new LinkedList<>();
        }
        this.requestLast.addLast(httpRequestInterceptor);
        return this;
    }

    public final HttpClientBuilder disableCookieManagement() {
        this.cookieManagementDisabled = true;
        return this;
    }

    public final HttpClientBuilder disableContentCompression() {
        this.contentCompressionDisabled = true;
        return this;
    }

    public final HttpClientBuilder disableAuthCaching() {
        this.authCachingDisabled = true;
        return this;
    }

    public final HttpClientBuilder setHttpProcessor(HttpProcessor httpProcessor) {
        this.httpprocessor = httpProcessor;
        return this;
    }

    public final HttpClientBuilder setRetryHandler(HttpRequestRetryHandler httpRequestRetryHandler) {
        this.retryHandler = httpRequestRetryHandler;
        return this;
    }

    public final HttpClientBuilder disableAutomaticRetries() {
        this.automaticRetriesDisabled = true;
        return this;
    }

    public final HttpClientBuilder setProxy(HttpHost httpHost) {
        this.proxy = httpHost;
        return this;
    }

    public final HttpClientBuilder setRoutePlanner(HttpRoutePlanner httpRoutePlanner) {
        this.routePlanner = httpRoutePlanner;
        return this;
    }

    public final HttpClientBuilder setRedirectStrategy(RedirectStrategy redirectStrategy) {
        this.redirectStrategy = redirectStrategy;
        return this;
    }

    public final HttpClientBuilder disableRedirectHandling() {
        this.redirectHandlingDisabled = true;
        return this;
    }

    public final HttpClientBuilder setConnectionBackoffStrategy(ConnectionBackoffStrategy connectionBackoffStrategy) {
        this.connectionBackoffStrategy = connectionBackoffStrategy;
        return this;
    }

    public final HttpClientBuilder setBackoffManager(BackoffManager backoffManager) {
        this.backoffManager = backoffManager;
        return this;
    }

    public final HttpClientBuilder setServiceUnavailableRetryStrategy(ServiceUnavailableRetryStrategy serviceUnavailableRetryStrategy) {
        this.serviceUnavailStrategy = serviceUnavailableRetryStrategy;
        return this;
    }

    public final HttpClientBuilder setDefaultCookieStore(CookieStore cookieStore) {
        this.cookieStore = cookieStore;
        return this;
    }

    public final HttpClientBuilder setDefaultCredentialsProvider(CredentialsProvider credentialsProvider) {
        this.credentialsProvider = credentialsProvider;
        return this;
    }

    public final HttpClientBuilder setDefaultAuthSchemeRegistry(Lookup<AuthSchemeProvider> lookup) {
        this.authSchemeRegistry = lookup;
        return this;
    }

    public final HttpClientBuilder setDefaultCookieSpecRegistry(Lookup<CookieSpecProvider> lookup) {
        this.cookieSpecRegistry = lookup;
        return this;
    }

    public final HttpClientBuilder setDefaultRequestConfig(RequestConfig requestConfig) {
        this.defaultRequestConfig = requestConfig;
        return this;
    }

    public final HttpClientBuilder useSystemProperties() {
        this.systemProperties = true;
        return this;
    }

    protected void addCloseable(Closeable closeable) {
        if (closeable == null) {
            return;
        }
        if (this.closeables == null) {
            this.closeables = new ArrayList();
        }
        this.closeables.add(closeable);
    }

    private static String[] split(String str) {
        if (TextUtils.isBlank(str)) {
            return null;
        }
        return str.split(" *, *");
    }

    public CloseableHttpClient build() {
        HttpClientConnectionManager httpClientConnectionManager;
        HttpRoutePlanner httpRoutePlanner;
        HttpRoutePlanner defaultRoutePlanner;
        ConnectionSocketFactory sSLConnectionSocketFactory;
        HttpRequestExecutor httpRequestExecutor = this.requestExec;
        if (httpRequestExecutor == null) {
            httpRequestExecutor = new HttpRequestExecutor();
        }
        HttpRequestExecutor httpRequestExecutor2 = httpRequestExecutor;
        HttpClientConnectionManager httpClientConnectionManager2 = this.connManager;
        if (httpClientConnectionManager2 == null) {
            ConnectionSocketFactory sSLConnectionSocketFactory2 = this.sslSocketFactory;
            if (sSLConnectionSocketFactory2 == null) {
                String[] strArrSplit = this.systemProperties ? split(System.getProperty("https.protocols")) : null;
                String[] strArrSplit2 = this.systemProperties ? split(System.getProperty("https.cipherSuites")) : null;
                X509HostnameVerifier x509HostnameVerifier = this.hostnameVerifier;
                if (x509HostnameVerifier == null) {
                    x509HostnameVerifier = SSLConnectionSocketFactory.BROWSER_COMPATIBLE_HOSTNAME_VERIFIER;
                }
                if (this.sslcontext != null) {
                    sSLConnectionSocketFactory = new SSLConnectionSocketFactory(this.sslcontext, strArrSplit, strArrSplit2, x509HostnameVerifier);
                } else if (this.systemProperties) {
                    sSLConnectionSocketFactory = new SSLConnectionSocketFactory((SSLSocketFactory) SSLSocketFactory.getDefault(), strArrSplit, strArrSplit2, x509HostnameVerifier);
                } else {
                    sSLConnectionSocketFactory2 = new SSLConnectionSocketFactory(SSLContexts.createDefault(), x509HostnameVerifier);
                }
                sSLConnectionSocketFactory2 = sSLConnectionSocketFactory;
            }
            PoolingHttpClientConnectionManager poolingHttpClientConnectionManager = new PoolingHttpClientConnectionManager((Registry<ConnectionSocketFactory>) RegistryBuilder.create().register(HttpHost.DEFAULT_SCHEME_NAME, PlainConnectionSocketFactory.getSocketFactory()).register("https", sSLConnectionSocketFactory2).build());
            SocketConfig socketConfig = this.defaultSocketConfig;
            if (socketConfig != null) {
                poolingHttpClientConnectionManager.setDefaultSocketConfig(socketConfig);
            }
            ConnectionConfig connectionConfig = this.defaultConnectionConfig;
            if (connectionConfig != null) {
                poolingHttpClientConnectionManager.setDefaultConnectionConfig(connectionConfig);
            }
            if (this.systemProperties && "true".equalsIgnoreCase(System.getProperty("http.keepAlive", "true"))) {
                int i = Integer.parseInt(System.getProperty("http.maxConnections", LogoutMqttHelper.LOGOUT_TYPE_FAQ_DISPLAY));
                poolingHttpClientConnectionManager.setDefaultMaxPerRoute(i);
                poolingHttpClientConnectionManager.setMaxTotal(i * 2);
            }
            int i2 = this.maxConnTotal;
            if (i2 > 0) {
                poolingHttpClientConnectionManager.setMaxTotal(i2);
            }
            int i3 = this.maxConnPerRoute;
            if (i3 > 0) {
                poolingHttpClientConnectionManager.setDefaultMaxPerRoute(i3);
            }
            httpClientConnectionManager = poolingHttpClientConnectionManager;
        } else {
            httpClientConnectionManager = httpClientConnectionManager2;
        }
        ConnectionReuseStrategy connectionReuseStrategy = this.reuseStrategy;
        if (connectionReuseStrategy == null) {
            if (!this.systemProperties || "true".equalsIgnoreCase(System.getProperty("http.keepAlive", "true"))) {
                connectionReuseStrategy = DefaultConnectionReuseStrategy.INSTANCE;
            } else {
                connectionReuseStrategy = NoConnectionReuseStrategy.INSTANCE;
            }
        }
        ConnectionReuseStrategy connectionReuseStrategy2 = connectionReuseStrategy;
        ConnectionKeepAliveStrategy connectionKeepAliveStrategy = this.keepAliveStrategy;
        if (connectionKeepAliveStrategy == null) {
            connectionKeepAliveStrategy = DefaultConnectionKeepAliveStrategy.INSTANCE;
        }
        ConnectionKeepAliveStrategy connectionKeepAliveStrategy2 = connectionKeepAliveStrategy;
        AuthenticationStrategy authenticationStrategy = this.targetAuthStrategy;
        if (authenticationStrategy == null) {
            authenticationStrategy = TargetAuthenticationStrategy.INSTANCE;
        }
        AuthenticationStrategy authenticationStrategy2 = authenticationStrategy;
        AuthenticationStrategy authenticationStrategy3 = this.proxyAuthStrategy;
        if (authenticationStrategy3 == null) {
            authenticationStrategy3 = ProxyAuthenticationStrategy.INSTANCE;
        }
        AuthenticationStrategy authenticationStrategy4 = authenticationStrategy3;
        UserTokenHandler userTokenHandler = this.userTokenHandler;
        if (userTokenHandler == null) {
            if (!this.connectionStateDisabled) {
                userTokenHandler = DefaultUserTokenHandler.INSTANCE;
            } else {
                userTokenHandler = NoopUserTokenHandler.INSTANCE;
            }
        }
        ClientExecChain clientExecChainDecorateMainExec = decorateMainExec(new MainClientExec(httpRequestExecutor2, httpClientConnectionManager, connectionReuseStrategy2, connectionKeepAliveStrategy2, authenticationStrategy2, authenticationStrategy4, userTokenHandler));
        HttpProcessor httpProcessorBuild = this.httpprocessor;
        if (httpProcessorBuild == null) {
            String property = this.userAgent;
            if (property == null) {
                if (this.systemProperties) {
                    property = System.getProperty("http.agent");
                }
                if (property == null) {
                    property = DEFAULT_USER_AGENT;
                }
            }
            HttpProcessorBuilder httpProcessorBuilderCreate = HttpProcessorBuilder.create();
            LinkedList<HttpRequestInterceptor> linkedList = this.requestFirst;
            if (linkedList != null) {
                Iterator<HttpRequestInterceptor> it = linkedList.iterator();
                while (it.hasNext()) {
                    httpProcessorBuilderCreate.addFirst(it.next());
                }
            }
            LinkedList<HttpResponseInterceptor> linkedList2 = this.responseFirst;
            if (linkedList2 != null) {
                Iterator<HttpResponseInterceptor> it2 = linkedList2.iterator();
                while (it2.hasNext()) {
                    httpProcessorBuilderCreate.addFirst(it2.next());
                }
            }
            httpProcessorBuilderCreate.addAll(new RequestDefaultHeaders(this.defaultHeaders), new RequestContent(), new RequestTargetHost(), new RequestClientConnControl(), new RequestUserAgent(property), new RequestExpectContinue());
            if (!this.cookieManagementDisabled) {
                httpProcessorBuilderCreate.add(new RequestAddCookies());
            }
            if (!this.contentCompressionDisabled) {
                httpProcessorBuilderCreate.add(new RequestAcceptEncoding());
            }
            if (!this.authCachingDisabled) {
                httpProcessorBuilderCreate.add(new RequestAuthCache());
            }
            if (!this.cookieManagementDisabled) {
                httpProcessorBuilderCreate.add(new ResponseProcessCookies());
            }
            if (!this.contentCompressionDisabled) {
                httpProcessorBuilderCreate.add(new ResponseContentEncoding());
            }
            LinkedList<HttpRequestInterceptor> linkedList3 = this.requestLast;
            if (linkedList3 != null) {
                Iterator<HttpRequestInterceptor> it3 = linkedList3.iterator();
                while (it3.hasNext()) {
                    httpProcessorBuilderCreate.addLast(it3.next());
                }
            }
            LinkedList<HttpResponseInterceptor> linkedList4 = this.responseLast;
            if (linkedList4 != null) {
                Iterator<HttpResponseInterceptor> it4 = linkedList4.iterator();
                while (it4.hasNext()) {
                    httpProcessorBuilderCreate.addLast(it4.next());
                }
            }
            httpProcessorBuild = httpProcessorBuilderCreate.build();
        }
        ClientExecChain clientExecChainDecorateProtocolExec = decorateProtocolExec(new ProtocolExec(clientExecChainDecorateMainExec, httpProcessorBuild));
        if (!this.automaticRetriesDisabled) {
            HttpRequestRetryHandler httpRequestRetryHandler = this.retryHandler;
            if (httpRequestRetryHandler == null) {
                httpRequestRetryHandler = DefaultHttpRequestRetryHandler.INSTANCE;
            }
            clientExecChainDecorateProtocolExec = new RetryExec(clientExecChainDecorateProtocolExec, httpRequestRetryHandler);
        }
        HttpRoutePlanner httpRoutePlanner2 = this.routePlanner;
        if (httpRoutePlanner2 == null) {
            SchemePortResolver schemePortResolver = this.schemePortResolver;
            if (schemePortResolver == null) {
                schemePortResolver = DefaultSchemePortResolver.INSTANCE;
            }
            if (this.proxy != null) {
                defaultRoutePlanner = new DefaultProxyRoutePlanner(this.proxy, schemePortResolver);
            } else if (this.systemProperties) {
                defaultRoutePlanner = new SystemDefaultRoutePlanner(schemePortResolver, ProxySelector.getDefault());
            } else {
                defaultRoutePlanner = new DefaultRoutePlanner(schemePortResolver);
            }
            httpRoutePlanner = defaultRoutePlanner;
        } else {
            httpRoutePlanner = httpRoutePlanner2;
        }
        if (!this.redirectHandlingDisabled) {
            RedirectStrategy redirectStrategy = this.redirectStrategy;
            if (redirectStrategy == null) {
                redirectStrategy = DefaultRedirectStrategy.INSTANCE;
            }
            clientExecChainDecorateProtocolExec = new RedirectExec(clientExecChainDecorateProtocolExec, httpRoutePlanner, redirectStrategy);
        }
        ServiceUnavailableRetryStrategy serviceUnavailableRetryStrategy = this.serviceUnavailStrategy;
        if (serviceUnavailableRetryStrategy != null) {
            clientExecChainDecorateProtocolExec = new ServiceUnavailableRetryExec(clientExecChainDecorateProtocolExec, serviceUnavailableRetryStrategy);
        }
        BackoffManager backoffManager = this.backoffManager;
        ConnectionBackoffStrategy connectionBackoffStrategy = this.connectionBackoffStrategy;
        ClientExecChain backoffStrategyExec = (backoffManager == null || connectionBackoffStrategy == null) ? clientExecChainDecorateProtocolExec : new BackoffStrategyExec(clientExecChainDecorateProtocolExec, connectionBackoffStrategy, backoffManager);
        Lookup lookupBuild = this.authSchemeRegistry;
        if (lookupBuild == null) {
            lookupBuild = RegistryBuilder.create().register("Basic", new BasicSchemeFactory()).register("Digest", new DigestSchemeFactory()).register("NTLM", new NTLMSchemeFactory()).build();
        }
        Lookup lookup = lookupBuild;
        Lookup lookupBuild2 = this.cookieSpecRegistry;
        if (lookupBuild2 == null) {
            lookupBuild2 = RegistryBuilder.create().register("best-match", new BestMatchSpecFactory()).register(CookieSpecs.STANDARD, new RFC2965SpecFactory()).register("compatibility", new BrowserCompatSpecFactory()).register("netscape", new NetscapeDraftSpecFactory()).register("ignoreCookies", new IgnoreSpecFactory()).register(CookiePolicy.RFC_2109, new RFC2109SpecFactory()).register(CookiePolicy.RFC_2965, new RFC2965SpecFactory()).build();
        }
        Lookup lookup2 = lookupBuild2;
        CookieStore basicCookieStore = this.cookieStore;
        if (basicCookieStore == null) {
            basicCookieStore = new BasicCookieStore();
        }
        CookieStore cookieStore = basicCookieStore;
        CredentialsProvider basicCredentialsProvider = this.credentialsProvider;
        if (basicCredentialsProvider == null) {
            if (this.systemProperties) {
                basicCredentialsProvider = new SystemDefaultCredentialsProvider();
            } else {
                basicCredentialsProvider = new BasicCredentialsProvider();
            }
        }
        CredentialsProvider credentialsProvider = basicCredentialsProvider;
        RequestConfig requestConfig = this.defaultRequestConfig;
        if (requestConfig == null) {
            requestConfig = RequestConfig.DEFAULT;
        }
        return new InternalHttpClient(backoffStrategyExec, httpClientConnectionManager, httpRoutePlanner, lookup2, lookup, cookieStore, credentialsProvider, requestConfig, this.closeables != null ? new ArrayList(this.closeables) : null);
    }
}
