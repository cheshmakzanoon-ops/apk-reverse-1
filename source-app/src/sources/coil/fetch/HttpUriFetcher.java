package coil.fetch;

import android.net.Uri;
import android.os.NetworkOnMainThreadException;
import android.webkit.MimeTypeMap;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.webkit.ProxyConfig;
import coil.ImageLoader;
import coil.decode.DataSource;
import coil.decode.ImageSource;
import coil.decode.ImageSources;
import coil.disk.DiskCache;
import coil.network.CacheResponse;
import coil.network.CacheStrategy;
import coil.network.HttpException;
import coil.request.Options;
import coil.util.Calls;
import coil.util.Utils;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import java.io.Closeable;
import java.io.IOException;
import java.util.Map;
import kotlin.ExceptionsKt;
import kotlin.Lazy;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.internal.Intrinsics;
import kotlin.text.StringsKt;
import okhttp3.CacheControl;
import okhttp3.Call;
import okhttp3.MediaType;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.ResponseBody;
import okio.BufferedSink;
import okio.BufferedSource;
import okio.FileSystem;
import okio.Okio;
import okio.Sink;

@Metadata(d1 = {"\u0000v\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0000\u0018\u0000 02\u00020\u0001:\u000201B;\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\f\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007\u0012\u000e\u0010\t\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\n0\u0007\u0012\u0006\u0010\u000b\u001a\u00020\f¢\u0006\u0002\u0010\rJ\u0016\u0010\u0015\u001a\u00020\u00162\u0006\u0010\u0017\u001a\u00020\u0018H\u0082@¢\u0006\u0002\u0010\u0019J\u000e\u0010\u001a\u001a\u00020\u001bH\u0096@¢\u0006\u0002\u0010\u001cJ!\u0010\u001d\u001a\u0004\u0018\u00010\u00032\u0006\u0010\u0002\u001a\u00020\u00032\b\u0010\u001e\u001a\u0004\u0018\u00010\u001fH\u0001¢\u0006\u0002\b J\u0018\u0010!\u001a\u00020\f2\u0006\u0010\u0017\u001a\u00020\u00182\u0006\u0010\"\u001a\u00020\u0016H\u0002J\b\u0010#\u001a\u00020\u0018H\u0002J\n\u0010$\u001a\u0004\u0018\u00010%H\u0002J.\u0010&\u001a\u0004\u0018\u00010%2\b\u0010'\u001a\u0004\u0018\u00010%2\u0006\u0010\u0017\u001a\u00020\u00182\u0006\u0010\"\u001a\u00020\u00162\b\u0010(\u001a\u0004\u0018\u00010)H\u0002J\u000e\u0010*\u001a\u0004\u0018\u00010)*\u00020%H\u0002J\f\u0010+\u001a\u00020,*\u00020\u0016H\u0002J\f\u0010-\u001a\u00020.*\u00020%H\u0002J\f\u0010-\u001a\u00020.*\u00020/H\u0002R\u0014\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u0016\u0010\t\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\n0\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u000e\u001a\u00020\u00038BX\u0082\u0004¢\u0006\u0006\u001a\u0004\b\u000f\u0010\u0010R\u0014\u0010\u0011\u001a\u00020\u00128BX\u0082\u0004¢\u0006\u0006\u001a\u0004\b\u0013\u0010\u0014R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000b\u001a\u00020\fX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u00062"}, d2 = {"Lcoil/fetch/HttpUriFetcher;", "Lcoil/fetch/Fetcher;", "url", "", SDKConstants.PARAM_GAME_REQUESTS_OPTIONS, "Lcoil/request/Options;", "callFactory", "Lkotlin/Lazy;", "Lokhttp3/Call$Factory;", "diskCache", "Lcoil/disk/DiskCache;", "respectCacheHeaders", "", "(Ljava/lang/String;Lcoil/request/Options;Lkotlin/Lazy;Lkotlin/Lazy;Z)V", "diskCacheKey", "getDiskCacheKey", "()Ljava/lang/String;", "fileSystem", "Lokio/FileSystem;", "getFileSystem", "()Lokio/FileSystem;", "executeNetworkRequest", "Lokhttp3/Response;", "request", "Lokhttp3/Request;", "(Lokhttp3/Request;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "fetch", "Lcoil/fetch/FetchResult;", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getMimeType", "contentType", "Lokhttp3/MediaType;", "getMimeType$coil_base_release", "isCacheable", "response", "newRequest", "readFromDiskCache", "Lcoil/disk/DiskCache$Snapshot;", "writeToDiskCache", "snapshot", "cacheResponse", "Lcoil/network/CacheResponse;", "toCacheResponse", "toDataSource", "Lcoil/decode/DataSource;", "toImageSource", "Lcoil/decode/ImageSource;", "Lokhttp3/ResponseBody;", "Companion", "Factory", "coil-base_release"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class HttpUriFetcher implements Fetcher {
    private static final String MIME_TYPE_TEXT_PLAIN = "text/plain";
    private final Lazy<Call.Factory> callFactory;
    private final Lazy<DiskCache> diskCache;
    private final Options options;
    private final boolean respectCacheHeaders;
    private final String url;
    private static final CacheControl CACHE_CONTROL_FORCE_NETWORK_NO_CACHE = new CacheControl.Builder().noCache().noStore().build();
    private static final CacheControl CACHE_CONTROL_NO_NETWORK_NO_CACHE = new CacheControl.Builder().noCache().onlyIfCached().build();

    @Metadata(k = 3, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    @DebugMetadata(c = "coil.fetch.HttpUriFetcher", f = "HttpUriFetcher.kt", i = {}, l = {224}, m = "executeNetworkRequest", n = {}, s = {})
    static final class C07991 extends ContinuationImpl {
        int label;
        Object result;

        C07991(Continuation<? super C07991> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return HttpUriFetcher.this.executeNetworkRequest(null, (Continuation) this);
        }
    }

    @Metadata(k = 3, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    @DebugMetadata(c = "coil.fetch.HttpUriFetcher", f = "HttpUriFetcher.kt", i = {0, 0, 0, 1, 1, 1}, l = {77, 106}, m = "fetch", n = {"this", "snapshot", "cacheStrategy", "this", "snapshot", "response"}, s = {"L$0", "L$1", "L$2", "L$0", "L$1", "L$2"})
    static final class C08001 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C08001(Continuation<? super C08001> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return HttpUriFetcher.this.fetch((Continuation) this);
        }
    }

    public HttpUriFetcher(String str, Options options, Lazy<? extends Call.Factory> lazy, Lazy<? extends DiskCache> lazy2, boolean z) {
        this.url = str;
        this.options = options;
        this.callFactory = lazy;
        this.diskCache = lazy2;
        this.respectCacheHeaders = z;
    }

    @Override
    public Object fetch(Continuation<? super FetchResult> continuation) throws Exception {
        C08001 c08001;
        DiskCache.Snapshot snapshot;
        Exception e;
        CacheStrategy cacheStrategyCompute;
        HttpUriFetcher httpUriFetcher;
        DiskCache.Snapshot snapshotWriteToDiskCache;
        CacheStrategy cacheStrategy;
        Response response;
        ResponseBody responseBodyRequireBody;
        Response response2;
        Exception e2;
        Object objExecuteNetworkRequest;
        HttpUriFetcher httpUriFetcher2;
        if (continuation instanceof C08001) {
            c08001 = (C08001) continuation;
            if ((c08001.label & Integer.MIN_VALUE) != 0) {
                c08001.label -= Integer.MIN_VALUE;
            } else {
                c08001 = new C08001(continuation);
            }
        } else {
            c08001 = new C08001(continuation);
        }
        Object obj = c08001.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c08001.label;
        if (i != 0) {
            if (i != 1) {
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                response2 = (Response) c08001.L$2;
                snapshotWriteToDiskCache = (DiskCache.Snapshot) c08001.L$1;
                httpUriFetcher2 = (HttpUriFetcher) c08001.L$0;
                try {
                    ResultKt.throwOnFailure(obj);
                    Response response3 = (Response) obj;
                    ResponseBody responseBodyRequireBody2 = Utils.requireBody(response3);
                    return new SourceResult(httpUriFetcher2.toImageSource(responseBodyRequireBody2), httpUriFetcher2.getMimeType$coil_base_release(httpUriFetcher2.url, responseBodyRequireBody2.contentType()), httpUriFetcher2.toDataSource(response3));
                } catch (Exception e3) {
                    e2 = e3;
                    Utils.closeQuietly((Closeable) response2);
                    throw e2;
                }
            }
            CacheStrategy cacheStrategy2 = (CacheStrategy) c08001.L$2;
            snapshot = (DiskCache.Snapshot) c08001.L$1;
            httpUriFetcher = (HttpUriFetcher) c08001.L$0;
            try {
                ResultKt.throwOnFailure(obj);
                cacheStrategy = cacheStrategy2;
                snapshotWriteToDiskCache = snapshot;
                try {
                    response = (Response) obj;
                    responseBodyRequireBody = Utils.requireBody(response);
                    try {
                        snapshotWriteToDiskCache = httpUriFetcher.writeToDiskCache(snapshotWriteToDiskCache, cacheStrategy.getNetworkRequest(), response, cacheStrategy.getCacheResponse());
                        if (snapshotWriteToDiskCache != null) {
                            ImageSource imageSource = httpUriFetcher.toImageSource(snapshotWriteToDiskCache);
                            String str = httpUriFetcher.url;
                            CacheResponse cacheResponse = httpUriFetcher.toCacheResponse(snapshotWriteToDiskCache);
                            return new SourceResult(imageSource, httpUriFetcher.getMimeType$coil_base_release(str, cacheResponse != null ? cacheResponse.getContentType() : null), DataSource.NETWORK);
                        }
                        if (responseBodyRequireBody.contentLength() > 0) {
                            return new SourceResult(httpUriFetcher.toImageSource(responseBodyRequireBody), httpUriFetcher.getMimeType$coil_base_release(httpUriFetcher.url, responseBodyRequireBody.contentType()), httpUriFetcher.toDataSource(response));
                        }
                        Utils.closeQuietly((Closeable) response);
                        Request requestNewRequest = httpUriFetcher.newRequest();
                        c08001.L$0 = httpUriFetcher;
                        c08001.L$1 = snapshotWriteToDiskCache;
                        c08001.L$2 = response;
                        c08001.label = 2;
                        objExecuteNetworkRequest = httpUriFetcher.executeNetworkRequest(requestNewRequest, c08001);
                        if (objExecuteNetworkRequest == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        response2 = response;
                        obj = objExecuteNetworkRequest;
                        httpUriFetcher2 = httpUriFetcher;
                        Response response4 = (Response) obj;
                        ResponseBody responseBodyRequireBody3 = Utils.requireBody(response4);
                        return new SourceResult(httpUriFetcher2.toImageSource(responseBodyRequireBody3), httpUriFetcher2.getMimeType$coil_base_release(httpUriFetcher2.url, responseBodyRequireBody3.contentType()), httpUriFetcher2.toDataSource(response4));
                    } catch (Exception e4) {
                        response2 = response;
                        e2 = e4;
                        Utils.closeQuietly((Closeable) response2);
                        throw e2;
                    }
                } catch (Exception e5) {
                    e = e5;
                    snapshot = snapshotWriteToDiskCache;
                    if (snapshot != null) {
                        Utils.closeQuietly(snapshot);
                    }
                    throw e;
                }
            } catch (Exception e6) {
                e = e6;
                if (snapshot != null) {
                    Utils.closeQuietly(snapshot);
                }
                throw e;
            }
        }
        ResultKt.throwOnFailure(obj);
        DiskCache.Snapshot fromDiskCache = readFromDiskCache();
        try {
            if (fromDiskCache != null) {
                Long size = getFileSystem().metadata(fromDiskCache.getMetadata()).getSize();
                if (size != null && size.longValue() == 0) {
                    return new SourceResult(toImageSource(fromDiskCache), getMimeType$coil_base_release(this.url, null), DataSource.DISK);
                }
                if (this.respectCacheHeaders) {
                    cacheStrategyCompute = new CacheStrategy.Factory(newRequest(), toCacheResponse(fromDiskCache)).compute();
                    if (cacheStrategyCompute.getNetworkRequest() == null && cacheStrategyCompute.getCacheResponse() != null) {
                        return new SourceResult(toImageSource(fromDiskCache), getMimeType$coil_base_release(this.url, cacheStrategyCompute.getCacheResponse().getContentType()), DataSource.DISK);
                    }
                } else {
                    ImageSource imageSource2 = toImageSource(fromDiskCache);
                    String str2 = this.url;
                    CacheResponse cacheResponse2 = toCacheResponse(fromDiskCache);
                    return new SourceResult(imageSource2, getMimeType$coil_base_release(str2, cacheResponse2 != null ? cacheResponse2.getContentType() : null), DataSource.DISK);
                }
            } else {
                cacheStrategyCompute = new CacheStrategy.Factory(newRequest(), null).compute();
            }
            Request networkRequest = cacheStrategyCompute.getNetworkRequest();
            Intrinsics.checkNotNull(networkRequest);
            c08001.L$0 = this;
            c08001.L$1 = fromDiskCache;
            c08001.L$2 = cacheStrategyCompute;
            c08001.label = 1;
            Object objExecuteNetworkRequest2 = executeNetworkRequest(networkRequest, c08001);
            if (objExecuteNetworkRequest2 == coroutine_suspended) {
                return coroutine_suspended;
            }
            httpUriFetcher = this;
            CacheStrategy cacheStrategy3 = cacheStrategyCompute;
            snapshotWriteToDiskCache = fromDiskCache;
            obj = objExecuteNetworkRequest2;
            cacheStrategy = cacheStrategy3;
            response = (Response) obj;
            responseBodyRequireBody = Utils.requireBody(response);
            snapshotWriteToDiskCache = httpUriFetcher.writeToDiskCache(snapshotWriteToDiskCache, cacheStrategy.getNetworkRequest(), response, cacheStrategy.getCacheResponse());
            if (snapshotWriteToDiskCache != null) {
                ImageSource imageSource3 = httpUriFetcher.toImageSource(snapshotWriteToDiskCache);
                String str3 = httpUriFetcher.url;
                CacheResponse cacheResponse3 = httpUriFetcher.toCacheResponse(snapshotWriteToDiskCache);
                return new SourceResult(imageSource3, httpUriFetcher.getMimeType$coil_base_release(str3, cacheResponse3 != null ? cacheResponse3.getContentType() : null), DataSource.NETWORK);
            }
            if (responseBodyRequireBody.contentLength() > 0) {
                return new SourceResult(httpUriFetcher.toImageSource(responseBodyRequireBody), httpUriFetcher.getMimeType$coil_base_release(httpUriFetcher.url, responseBodyRequireBody.contentType()), httpUriFetcher.toDataSource(response));
            }
            Utils.closeQuietly((Closeable) response);
            Request requestNewRequest2 = httpUriFetcher.newRequest();
            c08001.L$0 = httpUriFetcher;
            c08001.L$1 = snapshotWriteToDiskCache;
            c08001.L$2 = response;
            c08001.label = 2;
            objExecuteNetworkRequest = httpUriFetcher.executeNetworkRequest(requestNewRequest2, c08001);
            if (objExecuteNetworkRequest == coroutine_suspended) {
                return coroutine_suspended;
            }
            response2 = response;
            obj = objExecuteNetworkRequest;
            httpUriFetcher2 = httpUriFetcher;
            Response response5 = (Response) obj;
            ResponseBody responseBodyRequireBody4 = Utils.requireBody(response5);
            return new SourceResult(httpUriFetcher2.toImageSource(responseBodyRequireBody4), httpUriFetcher2.getMimeType$coil_base_release(httpUriFetcher2.url, responseBodyRequireBody4.contentType()), httpUriFetcher2.toDataSource(response5));
        } catch (Exception e7) {
            snapshot = fromDiskCache;
            e = e7;
            if (snapshot != null) {
                Utils.closeQuietly(snapshot);
            }
            throw e;
        }
    }

    private final DiskCache.Snapshot readFromDiskCache() {
        DiskCache diskCache;
        if (!this.options.getDiskCachePolicy().getReadEnabled() || (diskCache = (DiskCache) this.diskCache.getValue()) == null) {
            return null;
        }
        return diskCache.openSnapshot(getDiskCacheKey());
    }

    private final DiskCache.Snapshot writeToDiskCache(DiskCache.Snapshot snapshot, Request request, Response response, CacheResponse cacheResponse) {
        DiskCache.Editor editorOpenEditor;
        Throwable th;
        Unit unit;
        Long lValueOf;
        Unit unit2;
        Throwable th2 = null;
        if (!isCacheable(request, response)) {
            if (snapshot != null) {
                Utils.closeQuietly(snapshot);
            }
            return null;
        }
        if (snapshot != null) {
            editorOpenEditor = snapshot.closeAndOpenEditor();
        } else {
            DiskCache diskCache = (DiskCache) this.diskCache.getValue();
            editorOpenEditor = diskCache != null ? diskCache.openEditor(getDiskCacheKey()) : null;
        }
        try {
            if (editorOpenEditor == null) {
                return null;
            }
            try {
                if (response.code() == 304 && cacheResponse != null) {
                    Response responseBuild = response.newBuilder().headers(CacheStrategy.INSTANCE.combineHeaders(cacheResponse.getResponseHeaders(), response.headers())).build();
                    BufferedSink bufferedSink = (Closeable) Okio.buffer(getFileSystem().sink(editorOpenEditor.getMetadata(), false));
                    try {
                        new CacheResponse(responseBuild).writeTo(bufferedSink);
                        unit2 = Unit.INSTANCE;
                        if (bufferedSink != null) {
                            try {
                                bufferedSink.close();
                            } catch (Throwable th3) {
                                th2 = th3;
                            }
                        }
                    } catch (Throwable th4) {
                        if (bufferedSink != null) {
                            try {
                                bufferedSink.close();
                            } catch (Throwable th5) {
                                ExceptionsKt.addSuppressed(th4, th5);
                            }
                        }
                        th2 = th4;
                        unit2 = null;
                    }
                    if (th2 != null) {
                        throw th2;
                    }
                    Intrinsics.checkNotNull(unit2);
                } else {
                    BufferedSink bufferedSink2 = (Closeable) Okio.buffer(getFileSystem().sink(editorOpenEditor.getMetadata(), false));
                    try {
                        new CacheResponse(response).writeTo(bufferedSink2);
                        unit = Unit.INSTANCE;
                        if (bufferedSink2 != null) {
                            try {
                                bufferedSink2.close();
                            } catch (Throwable th6) {
                                th = th6;
                            }
                        }
                        th = null;
                    } catch (Throwable th7) {
                        if (bufferedSink2 != null) {
                            try {
                                bufferedSink2.close();
                            } catch (Throwable th8) {
                                ExceptionsKt.addSuppressed(th7, th8);
                            }
                        }
                        th = th7;
                        unit = null;
                    }
                    if (th != null) {
                        throw th;
                    }
                    Intrinsics.checkNotNull(unit);
                    Sink sink = (Closeable) Okio.buffer(getFileSystem().sink(editorOpenEditor.getData(), false));
                    try {
                        ResponseBody responseBodyBody = response.body();
                        Intrinsics.checkNotNull(responseBodyBody);
                        lValueOf = Long.valueOf(responseBodyBody.source().readAll((BufferedSink) sink));
                        if (sink != null) {
                            try {
                                sink.close();
                            } catch (Throwable th9) {
                                th2 = th9;
                            }
                        }
                    } catch (Throwable th10) {
                        if (sink != null) {
                            try {
                                sink.close();
                            } catch (Throwable th11) {
                                ExceptionsKt.addSuppressed(th10, th11);
                            }
                        }
                        th2 = th10;
                        lValueOf = null;
                    }
                    if (th2 != null) {
                        throw th2;
                    }
                    Intrinsics.checkNotNull(lValueOf);
                }
                DiskCache.Snapshot snapshotCommitAndOpenSnapshot = editorOpenEditor.commitAndOpenSnapshot();
                Utils.closeQuietly((Closeable) response);
                return snapshotCommitAndOpenSnapshot;
            } catch (Exception e) {
                Utils.abortQuietly(editorOpenEditor);
                throw e;
            }
        } catch (Throwable th12) {
            Utils.closeQuietly((Closeable) response);
            throw th12;
        }
    }

    private final Request newRequest() {
        Request.Builder builderHeaders = new Request.Builder().url(this.url).headers(this.options.getHeaders());
        for (Map.Entry<Class<?>, Object> entry : this.options.getTags().asMap().entrySet()) {
            Class<?> key = entry.getKey();
            Intrinsics.checkNotNull(key, "null cannot be cast to non-null type java.lang.Class<kotlin.Any>");
            builderHeaders.tag(key, entry.getValue());
        }
        boolean readEnabled = this.options.getDiskCachePolicy().getReadEnabled();
        boolean readEnabled2 = this.options.getNetworkCachePolicy().getReadEnabled();
        if (!readEnabled2 && readEnabled) {
            builderHeaders.cacheControl(CacheControl.FORCE_CACHE);
        } else if (!readEnabled2 || readEnabled) {
            if (!readEnabled2 && !readEnabled) {
                builderHeaders.cacheControl(CACHE_CONTROL_NO_NETWORK_NO_CACHE);
            }
        } else if (this.options.getDiskCachePolicy().getWriteEnabled()) {
            builderHeaders.cacheControl(CacheControl.FORCE_NETWORK);
        } else {
            builderHeaders.cacheControl(CACHE_CONTROL_FORCE_NETWORK_NO_CACHE);
        }
        return builderHeaders.build();
    }

    public final Object executeNetworkRequest(Request request, Continuation<? super Response> continuation) {
        C07991 c07991;
        Response responseExecute;
        if (continuation instanceof C07991) {
            c07991 = (C07991) continuation;
            if ((c07991.label & Integer.MIN_VALUE) != 0) {
                c07991.label -= Integer.MIN_VALUE;
            } else {
                c07991 = new C07991(continuation);
            }
        } else {
            c07991 = new C07991(continuation);
        }
        Object objAwait = c07991.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c07991.label;
        if (i == 0) {
            ResultKt.throwOnFailure(objAwait);
            if (Utils.isMainThread()) {
                if (this.options.getNetworkCachePolicy().getReadEnabled()) {
                    throw new NetworkOnMainThreadException();
                }
                responseExecute = ((Call.Factory) this.callFactory.getValue()).newCall(request).execute();
            } else {
                Call callNewCall = ((Call.Factory) this.callFactory.getValue()).newCall(request);
                c07991.label = 1;
                objAwait = Calls.await(callNewCall, c07991);
                if (objAwait == coroutine_suspended) {
                    return coroutine_suspended;
                }
            }
            if (!responseExecute.isSuccessful() || responseExecute.code() == 304) {
                return responseExecute;
            }
            Closeable closeableBody = responseExecute.body();
            if (closeableBody != null) {
                Utils.closeQuietly(closeableBody);
            }
            throw new HttpException(responseExecute);
        }
        if (i != 1) {
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
        ResultKt.throwOnFailure(objAwait);
        responseExecute = (Response) objAwait;
        if (responseExecute.isSuccessful()) {
        }
        return responseExecute;
    }

    public final String getMimeType$coil_base_release(String url, MediaType contentType) {
        String mimeTypeFromUrl;
        String string = contentType != null ? contentType.toString() : null;
        if ((string == null || StringsKt.startsWith$default(string, "text/plain", false, 2, (Object) null)) && (mimeTypeFromUrl = Utils.getMimeTypeFromUrl(MimeTypeMap.getSingleton(), url)) != null) {
            return mimeTypeFromUrl;
        }
        if (string != null) {
            return StringsKt.substringBefore$default(string, ';', (String) null, 2, (Object) null);
        }
        return null;
    }

    private final boolean isCacheable(Request request, Response response) {
        return this.options.getDiskCachePolicy().getWriteEnabled() && (!this.respectCacheHeaders || CacheStrategy.INSTANCE.isCacheable(request, response));
    }

    private final CacheResponse toCacheResponse(DiskCache.Snapshot snapshot) throws Throwable {
        CacheResponse cacheResponse;
        Throwable th;
        try {
            BufferedSource bufferedSource = (Closeable) Okio.buffer(getFileSystem().source(snapshot.getMetadata()));
            try {
                cacheResponse = new CacheResponse(bufferedSource);
                if (bufferedSource != null) {
                    try {
                        bufferedSource.close();
                    } catch (Throwable th2) {
                        th = th2;
                    }
                }
                th = null;
            } catch (Throwable th3) {
                if (bufferedSource != null) {
                    try {
                        bufferedSource.close();
                    } catch (Throwable th4) {
                        ExceptionsKt.addSuppressed(th3, th4);
                    }
                }
                cacheResponse = null;
                th = th3;
            }
            if (th != null) {
                throw th;
            }
            Intrinsics.checkNotNull(cacheResponse);
            return cacheResponse;
        } catch (IOException unused) {
            return null;
        }
    }

    private final ImageSource toImageSource(DiskCache.Snapshot snapshot) {
        return ImageSources.create(snapshot.getData(), getFileSystem(), getDiskCacheKey(), snapshot);
    }

    private final ImageSource toImageSource(ResponseBody responseBody) {
        return ImageSources.create(responseBody.source(), this.options.getContext());
    }

    private final DataSource toDataSource(Response response) {
        return response.networkResponse() != null ? DataSource.NETWORK : DataSource.DISK;
    }

    private final String getDiskCacheKey() {
        String diskCacheKey = this.options.getDiskCacheKey();
        return diskCacheKey == null ? this.url : diskCacheKey;
    }

    private final FileSystem getFileSystem() {
        Object value = this.diskCache.getValue();
        Intrinsics.checkNotNull(value);
        return ((DiskCache) value).getFileSystem();
    }

    @Metadata(d1 = {"\u0000<\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B+\u0012\f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004\u0012\u000e\u0010\u0006\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00070\u0004\u0012\u0006\u0010\b\u001a\u00020\t¢\u0006\u0002\u0010\nJ\"\u0010\u000b\u001a\u0004\u0018\u00010\f2\u0006\u0010\r\u001a\u00020\u00022\u0006\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u0011H\u0016J\u0010\u0010\u0012\u001a\u00020\t2\u0006\u0010\r\u001a\u00020\u0002H\u0002R\u0014\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004X\u0082\u0004¢\u0006\u0002\n\u0000R\u0016\u0010\u0006\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00070\u0004X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\tX\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0013"}, d2 = {"Lcoil/fetch/HttpUriFetcher$Factory;", "Lcoil/fetch/Fetcher$Factory;", "Landroid/net/Uri;", "callFactory", "Lkotlin/Lazy;", "Lokhttp3/Call$Factory;", "diskCache", "Lcoil/disk/DiskCache;", "respectCacheHeaders", "", "(Lkotlin/Lazy;Lkotlin/Lazy;Z)V", "create", "Lcoil/fetch/Fetcher;", "data", SDKConstants.PARAM_GAME_REQUESTS_OPTIONS, "Lcoil/request/Options;", "imageLoader", "Lcoil/ImageLoader;", "isApplicable", "coil-base_release"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Factory implements Fetcher.Factory<Uri> {
        private final Lazy<Call.Factory> callFactory;
        private final Lazy<DiskCache> diskCache;
        private final boolean respectCacheHeaders;

        public Factory(Lazy<? extends Call.Factory> lazy, Lazy<? extends DiskCache> lazy2, boolean z) {
            this.callFactory = lazy;
            this.diskCache = lazy2;
            this.respectCacheHeaders = z;
        }

        @Override
        public Fetcher create(Uri data, Options options, ImageLoader imageLoader) {
            if (isApplicable(data)) {
                return new HttpUriFetcher(data.toString(), options, this.callFactory, this.diskCache, this.respectCacheHeaders);
            }
            return null;
        }

        private final boolean isApplicable(Uri data) {
            return Intrinsics.areEqual(data.getScheme(), ProxyConfig.MATCH_HTTP) || Intrinsics.areEqual(data.getScheme(), "https");
        }
    }
}
