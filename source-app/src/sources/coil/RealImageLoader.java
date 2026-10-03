package coil;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import androidx.constraintlayout.core.motion.utils.TypedValues;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.lifecycle.Lifecycle;
import coil.decode.BitmapFactoryDecoder;
import coil.decode.DataSource;
import coil.disk.DiskCache;
import coil.fetch.AssetUriFetcher;
import coil.fetch.BitmapFetcher;
import coil.fetch.ByteBufferFetcher;
import coil.fetch.ContentUriFetcher;
import coil.fetch.DrawableFetcher;
import coil.fetch.FileFetcher;
import coil.fetch.HttpUriFetcher;
import coil.fetch.ResourceUriFetcher;
import coil.intercept.EngineInterceptor;
import coil.intercept.Interceptor;
import coil.key.FileKeyer;
import coil.key.UriKeyer;
import coil.map.ByteArrayMapper;
import coil.map.FileUriMapper;
import coil.map.HttpUrlMapper;
import coil.map.ResourceIntMapper;
import coil.map.ResourceUriMapper;
import coil.map.StringMapper;
import coil.memory.MemoryCache;
import coil.request.DefaultRequestOptions;
import coil.request.Disposable;
import coil.request.ErrorResult;
import coil.request.ImageRequest;
import coil.request.ImageResult;
import coil.request.NullRequestData;
import coil.request.NullRequestDataException;
import coil.request.OneShotDisposable;
import coil.request.RequestDelegate;
import coil.request.RequestService;
import coil.request.SuccessResult;
import coil.size.Size;
import coil.size.SizeResolver;
import coil.target.Target;
import coil.target.ViewTarget;
import coil.transition.NoneTransition;
import coil.transition.Transition;
import coil.transition.TransitionTarget;
import coil.util.ImageLoaderOptions;
import coil.util.Lifecycles;
import coil.util.Logger;
import coil.util.SystemCallbacks;
import coil.util.Utils;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import java.io.File;
import java.nio.ByteBuffer;
import java.util.List;
import java.util.concurrent.CancellationException;
import java.util.concurrent.atomic.AtomicBoolean;
import kotlin.Lazy;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineExceptionHandler;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.CoroutineScopeKt;
import kotlinx.coroutines.CoroutineStart;
import kotlinx.coroutines.Deferred;
import kotlinx.coroutines.Dispatchers;
import kotlinx.coroutines.Job;
import kotlinx.coroutines.JobKt;
import kotlinx.coroutines.SupervisorKt;
import okhttp3.Call;
import okhttp3.HttpUrl;

@Metadata(d1 = {"\u0000¶\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0014\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0000\u0018\u0000 [2\u00020\u0001:\u0001[Be\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u000e\u0010\u0006\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\b0\u0007\u0012\u000e\u0010\t\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\n0\u0007\u0012\f\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\f0\u0007\u0012\u0006\u0010\r\u001a\u00020\u000e\u0012\u0006\u0010\u000f\u001a\u00020\u0010\u0012\u0006\u0010\u0011\u001a\u00020\u0012\u0012\b\u0010\u0013\u001a\u0004\u0018\u00010\u0014¢\u0006\u0002\u0010\u0015J\u0010\u0010<\u001a\u00020=2\u0006\u0010>\u001a\u00020?H\u0016J\u0016\u0010@\u001a\u00020A2\u0006\u0010>\u001a\u00020?H\u0096@¢\u0006\u0002\u0010BJ\u001e\u0010C\u001a\u00020A2\u0006\u0010D\u001a\u00020?2\u0006\u0010E\u001a\u00020FH\u0083@¢\u0006\u0002\u0010GJ\b\u0010H\u001a\u00020IH\u0016J\u0018\u0010J\u001a\u00020K2\u0006\u0010>\u001a\u00020?2\u0006\u0010L\u001a\u00020MH\u0002J\"\u0010N\u001a\u00020K2\u0006\u0010O\u001a\u00020P2\b\u0010Q\u001a\u0004\u0018\u00010R2\u0006\u0010L\u001a\u00020MH\u0002J\"\u0010S\u001a\u00020K2\u0006\u0010O\u001a\u00020T2\b\u0010Q\u001a\u0004\u0018\u00010R2\u0006\u0010L\u001a\u00020MH\u0002J\u0015\u0010U\u001a\u00020K2\u0006\u0010V\u001a\u00020FH\u0000¢\u0006\u0002\bWJ\b\u00108\u001a\u00020KH\u0016J1\u0010X\u001a\u00020K2\u0006\u0010O\u001a\u00020A2\b\u0010Q\u001a\u0004\u0018\u00010R2\u0006\u0010L\u001a\u00020M2\f\u0010Y\u001a\b\u0012\u0004\u0012\u00020K0ZH\u0082\bR\u0017\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\f0\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u0017R\u0011\u0010\u000f\u001a\u00020\u0010¢\u0006\b\n\u0000\u001a\u0004\b\u0018\u0010\u0019R\u0014\u0010\u001a\u001a\u00020\u0010X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u0019R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u001c\u0010\u001dR\u0014\u0010\u0004\u001a\u00020\u0005X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001e\u0010\u001fR\u001d\u0010 \u001a\u0004\u0018\u00010\n8VX\u0096\u0084\u0002¢\u0006\f\u001a\u0004\b#\u0010$*\u0004\b!\u0010\"R\u0019\u0010\t\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\n0\u0007¢\u0006\b\n\u0000\u001a\u0004\b%\u0010\u0017R\u0011\u0010\r\u001a\u00020\u000e¢\u0006\b\n\u0000\u001a\u0004\b&\u0010'R\u0014\u0010(\u001a\b\u0012\u0004\u0012\u00020*0)X\u0082\u0004¢\u0006\u0002\n\u0000R\u0013\u0010\u0013\u001a\u0004\u0018\u00010\u0014¢\u0006\b\n\u0000\u001a\u0004\b+\u0010,R\u001d\u0010-\u001a\u0004\u0018\u00010\b8VX\u0096\u0084\u0002¢\u0006\f\u001a\u0004\b/\u00100*\u0004\b.\u0010\"R\u0019\u0010\u0006\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\b0\u0007¢\u0006\b\n\u0000\u001a\u0004\b1\u0010\u0017R\u0011\u0010\u0011\u001a\u00020\u0012¢\u0006\b\n\u0000\u001a\u0004\b2\u00103R\u000e\u00104\u001a\u000205X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u00106\u001a\u000207X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u00108\u001a\u000209X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010:\u001a\u00020;X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\\"}, d2 = {"Lcoil/RealImageLoader;", "Lcoil/ImageLoader;", "context", "Landroid/content/Context;", "defaults", "Lcoil/request/DefaultRequestOptions;", "memoryCacheLazy", "Lkotlin/Lazy;", "Lcoil/memory/MemoryCache;", "diskCacheLazy", "Lcoil/disk/DiskCache;", "callFactoryLazy", "Lokhttp3/Call$Factory;", "eventListenerFactory", "Lcoil/EventListener$Factory;", "componentRegistry", "Lcoil/ComponentRegistry;", SDKConstants.PARAM_GAME_REQUESTS_OPTIONS, "Lcoil/util/ImageLoaderOptions;", "logger", "Lcoil/util/Logger;", "(Landroid/content/Context;Lcoil/request/DefaultRequestOptions;Lkotlin/Lazy;Lkotlin/Lazy;Lkotlin/Lazy;Lcoil/EventListener$Factory;Lcoil/ComponentRegistry;Lcoil/util/ImageLoaderOptions;Lcoil/util/Logger;)V", "getCallFactoryLazy", "()Lkotlin/Lazy;", "getComponentRegistry", "()Lcoil/ComponentRegistry;", "components", "getComponents", "getContext", "()Landroid/content/Context;", "getDefaults", "()Lcoil/request/DefaultRequestOptions;", "diskCache", "getDiskCache$delegate", "(Lcoil/RealImageLoader;)Ljava/lang/Object;", "getDiskCache", "()Lcoil/disk/DiskCache;", "getDiskCacheLazy", "getEventListenerFactory", "()Lcoil/EventListener$Factory;", "interceptors", "", "Lcoil/intercept/Interceptor;", "getLogger", "()Lcoil/util/Logger;", "memoryCache", "getMemoryCache$delegate", "getMemoryCache", "()Lcoil/memory/MemoryCache;", "getMemoryCacheLazy", "getOptions", "()Lcoil/util/ImageLoaderOptions;", "requestService", "Lcoil/request/RequestService;", "scope", "Lkotlinx/coroutines/CoroutineScope;", "shutdown", "Ljava/util/concurrent/atomic/AtomicBoolean;", "systemCallbacks", "Lcoil/util/SystemCallbacks;", "enqueue", "Lcoil/request/Disposable;", "request", "Lcoil/request/ImageRequest;", "execute", "Lcoil/request/ImageResult;", "(Lcoil/request/ImageRequest;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "executeMain", "initialRequest", "type", "", "(Lcoil/request/ImageRequest;ILkotlin/coroutines/Continuation;)Ljava/lang/Object;", "newBuilder", "Lcoil/ImageLoader$Builder;", "onCancel", "", "eventListener", "Lcoil/EventListener;", "onError", "result", "Lcoil/request/ErrorResult;", TypedValues.AttributesType.S_TARGET, "Lcoil/target/Target;", "onSuccess", "Lcoil/request/SuccessResult;", "onTrimMemory", "level", "onTrimMemory$coil_base_release", "transition", "setDrawable", "Lkotlin/Function0;", "Companion", "coil-base_release"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class RealImageLoader implements ImageLoader {
    private static final int REQUEST_TYPE_ENQUEUE = 0;
    private static final int REQUEST_TYPE_EXECUTE = 1;
    private static final String TAG = "RealImageLoader";
    private final Lazy<Call.Factory> callFactoryLazy;
    private final ComponentRegistry componentRegistry;
    private final ComponentRegistry components;
    private final Context context;
    private final DefaultRequestOptions defaults;
    private final Lazy<DiskCache> diskCacheLazy;
    private final EventListener.Factory eventListenerFactory;
    private final List<Interceptor> interceptors;
    private final Logger logger;
    private final Lazy<MemoryCache> memoryCacheLazy;
    private final ImageLoaderOptions options;
    private final RequestService requestService;
    private final CoroutineScope scope = CoroutineScopeKt.CoroutineScope(SupervisorKt.SupervisorJob$default((Job) null, 1, (Object) null).plus(Dispatchers.getMain().getImmediate()).plus((CoroutineExceptionHandler) new RealImageLoader$special$$inlined$CoroutineExceptionHandler$1(CoroutineExceptionHandler.Key, this)));
    private final AtomicBoolean shutdown;
    private final SystemCallbacks systemCallbacks;

    @Metadata(k = 3, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    @DebugMetadata(c = "coil.RealImageLoader", f = "RealImageLoader.kt", i = {0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 2, 2}, l = {162, 174, 178}, m = "executeMain", n = {"this", "requestDelegate", "request", "eventListener", "this", "requestDelegate", "request", "eventListener", "placeholderBitmap", "this", "requestDelegate", "request", "eventListener"}, s = {"L$0", "L$1", "L$2", "L$3", "L$0", "L$1", "L$2", "L$3", "L$4", "L$0", "L$1", "L$2", "L$3"})
    static final class C07731 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        Object L$4;
        int label;
        Object result;

        C07731(Continuation<? super C07731> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return RealImageLoader.this.executeMain(null, 0, (Continuation) this);
        }
    }

    public RealImageLoader(Context context, DefaultRequestOptions defaultRequestOptions, Lazy<? extends MemoryCache> lazy, Lazy<? extends DiskCache> lazy2, Lazy<? extends Call.Factory> lazy3, EventListener.Factory factory, ComponentRegistry componentRegistry, ImageLoaderOptions imageLoaderOptions, Logger logger) {
        this.context = context;
        this.defaults = defaultRequestOptions;
        this.memoryCacheLazy = lazy;
        this.diskCacheLazy = lazy2;
        this.callFactoryLazy = lazy3;
        this.eventListenerFactory = factory;
        this.componentRegistry = componentRegistry;
        this.options = imageLoaderOptions;
        this.logger = logger;
        SystemCallbacks systemCallbacks = new SystemCallbacks(this);
        this.systemCallbacks = systemCallbacks;
        RealImageLoader realImageLoader = this;
        RequestService requestService = new RequestService(realImageLoader, systemCallbacks, logger);
        this.requestService = requestService;
        this.components = componentRegistry.newBuilder().add(new HttpUrlMapper(), HttpUrl.class).add(new StringMapper(), String.class).add(new FileUriMapper(), Uri.class).add(new ResourceUriMapper(), Uri.class).add(new ResourceIntMapper(), Integer.class).add(new ByteArrayMapper(), byte[].class).add(new UriKeyer(), Uri.class).add(new FileKeyer(imageLoaderOptions.getAddLastModifiedToFileCacheKey()), File.class).add(new HttpUriFetcher.Factory(lazy3, lazy2, imageLoaderOptions.getRespectCacheHeaders()), Uri.class).add(new FileFetcher.Factory(), File.class).add(new AssetUriFetcher.Factory(), Uri.class).add(new ContentUriFetcher.Factory(), Uri.class).add(new ResourceUriFetcher.Factory(), Uri.class).add(new DrawableFetcher.Factory(), Drawable.class).add(new BitmapFetcher.Factory(), Bitmap.class).add(new ByteBufferFetcher.Factory(), ByteBuffer.class).add(new BitmapFactoryDecoder.Factory(imageLoaderOptions.getBitmapFactoryMaxParallelism(), imageLoaderOptions.getBitmapFactoryExifOrientationPolicy())).build();
        this.interceptors = CollectionsKt.plus(getComponents().getInterceptors(), new EngineInterceptor(realImageLoader, systemCallbacks, requestService, logger));
        this.shutdown = new AtomicBoolean(false);
    }

    public final Context getContext() {
        return this.context;
    }

    @Override
    public DefaultRequestOptions getDefaults() {
        return this.defaults;
    }

    public final Lazy<MemoryCache> getMemoryCacheLazy() {
        return this.memoryCacheLazy;
    }

    public final Lazy<DiskCache> getDiskCacheLazy() {
        return this.diskCacheLazy;
    }

    public final Lazy<Call.Factory> getCallFactoryLazy() {
        return this.callFactoryLazy;
    }

    public final EventListener.Factory getEventListenerFactory() {
        return this.eventListenerFactory;
    }

    public final ComponentRegistry getComponentRegistry() {
        return this.componentRegistry;
    }

    public final ImageLoaderOptions getOptions() {
        return this.options;
    }

    public final Logger getLogger() {
        return this.logger;
    }

    @Override
    public MemoryCache getMemoryCache() {
        return (MemoryCache) this.memoryCacheLazy.getValue();
    }

    @Override
    public DiskCache getDiskCache() {
        return (DiskCache) this.diskCacheLazy.getValue();
    }

    @Override
    public ComponentRegistry getComponents() {
        return this.components;
    }

    @Override
    public Disposable enqueue(ImageRequest request) {
        Deferred<? extends ImageResult> deferredAsync$default = BuildersKt.async$default(this.scope, (CoroutineContext) null, (CoroutineStart) null, new RealImageLoader$enqueue$job$1(this, request, null), 3, (Object) null);
        if (request.getTarget() instanceof ViewTarget) {
            return Utils.getRequestManager(((ViewTarget) request.getTarget()).getView()).getDisposable(deferredAsync$default);
        }
        return new OneShotDisposable(deferredAsync$default);
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "Lcoil/request/ImageResult;", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    @DebugMetadata(c = "coil.RealImageLoader$execute$2", f = "RealImageLoader.kt", i = {}, l = {136}, m = "invokeSuspend", n = {}, s = {})
    static final class C07722 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super ImageResult>, Object> {
        final ImageRequest $request;
        private Object L$0;
        int label;
        final RealImageLoader this$0;

        C07722(ImageRequest imageRequest, RealImageLoader realImageLoader, Continuation<? super C07722> continuation) {
            super(2, continuation);
            this.$request = imageRequest;
            this.this$0 = realImageLoader;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            Continuation<Unit> c07722 = new C07722(this.$request, this.this$0, continuation);
            c07722.L$0 = obj;
            return c07722;
        }

        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super ImageResult> continuation) {
            return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                Deferred<? extends ImageResult> deferredAsync$default = BuildersKt.async$default((CoroutineScope) this.L$0, Dispatchers.getMain().getImmediate(), (CoroutineStart) null, new RealImageLoader$execute$2$job$1(this.this$0, this.$request, null), 2, (Object) null);
                if (this.$request.getTarget() instanceof ViewTarget) {
                    Utils.getRequestManager(((ViewTarget) this.$request.getTarget()).getView()).getDisposable(deferredAsync$default);
                }
                this.label = 1;
                obj = deferredAsync$default.await((Continuation) this);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return obj;
        }
    }

    @Override
    public Object execute(ImageRequest imageRequest, Continuation<? super ImageResult> continuation) {
        return CoroutineScopeKt.coroutineScope(new C07722(imageRequest, this, null), continuation);
    }

    public final Object executeMain(ImageRequest imageRequest, int i, Continuation<? super ImageResult> continuation) {
        C07731 c07731;
        RequestDelegate requestDelegate;
        ImageRequest imageRequestBuild;
        RealImageLoader realImageLoader;
        RequestDelegate requestDelegate2;
        EventListener eventListener;
        RealImageLoader realImageLoader2;
        ImageRequest imageRequest2;
        EventListener eventListener2;
        RequestDelegate requestDelegate3;
        Bitmap bitmap;
        Bitmap bitmap2;
        RealImageLoader realImageLoader3;
        RequestDelegate requestDelegate4;
        ImageRequest imageRequest3;
        ImageResult imageResult;
        if (continuation instanceof C07731) {
            c07731 = (C07731) continuation;
            if ((c07731.label & Integer.MIN_VALUE) != 0) {
                c07731.label -= Integer.MIN_VALUE;
            } else {
                c07731 = new C07731(continuation);
            }
        } else {
            c07731 = new C07731(continuation);
        }
        Object objWithContext = c07731.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i2 = c07731.label;
        try {
            if (i2 == 0) {
                ResultKt.throwOnFailure(objWithContext);
                requestDelegate = this.requestService.requestDelegate(imageRequest, JobKt.getJob(c07731.getContext()));
                requestDelegate.assertActive();
                imageRequestBuild = ImageRequest.newBuilder$default(imageRequest, null, 1, null).defaults(getDefaults()).build();
                EventListener eventListenerCreate = this.eventListenerFactory.create(imageRequestBuild);
                try {
                    if (imageRequestBuild.getData() == NullRequestData.INSTANCE) {
                        throw new NullRequestDataException();
                    }
                    requestDelegate.start();
                    if (i == 0) {
                        Lifecycle lifecycle = imageRequestBuild.getLifecycle();
                        c07731.L$0 = this;
                        c07731.L$1 = requestDelegate;
                        c07731.L$2 = imageRequestBuild;
                        c07731.L$3 = eventListenerCreate;
                        c07731.label = 1;
                        if (Lifecycles.awaitStarted(lifecycle, c07731) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        realImageLoader2 = this;
                        imageRequest2 = imageRequestBuild;
                        eventListener2 = eventListenerCreate;
                        requestDelegate3 = requestDelegate;
                        requestDelegate = requestDelegate3;
                    } else {
                        realImageLoader2 = this;
                        imageRequest2 = imageRequestBuild;
                        eventListener2 = eventListenerCreate;
                    }
                } catch (Throwable th) {
                    th = th;
                    realImageLoader = this;
                    requestDelegate2 = requestDelegate;
                    eventListener = eventListenerCreate;
                    if (th instanceof CancellationException) {
                        realImageLoader.onCancel(imageRequestBuild, eventListener);
                        throw th;
                    }
                    ErrorResult errorResult = realImageLoader.requestService.errorResult(imageRequestBuild, th);
                    realImageLoader.onError(errorResult, imageRequestBuild.getTarget(), eventListener);
                    requestDelegate2.complete();
                    return errorResult;
                }
            } else {
                if (i2 != 1) {
                    if (i2 == 2) {
                        Bitmap bitmap3 = (Bitmap) c07731.L$4;
                        eventListener2 = (EventListener) c07731.L$3;
                        imageRequest3 = (ImageRequest) c07731.L$2;
                        requestDelegate4 = (RequestDelegate) c07731.L$1;
                        realImageLoader3 = (RealImageLoader) c07731.L$0;
                        try {
                            ResultKt.throwOnFailure(objWithContext);
                            bitmap2 = bitmap3;
                            Size size = (Size) objWithContext;
                            eventListener2.resolveSizeEnd(imageRequest3, size);
                            CoroutineContext interceptorDispatcher = imageRequest3.getInterceptorDispatcher();
                            RealImageLoader$executeMain$result$1 realImageLoader$executeMain$result$1 = new RealImageLoader$executeMain$result$1(imageRequest3, realImageLoader3, size, eventListener2, bitmap2, null);
                            c07731.L$0 = realImageLoader3;
                            c07731.L$1 = requestDelegate4;
                            c07731.L$2 = imageRequest3;
                            c07731.L$3 = eventListener2;
                            c07731.L$4 = null;
                            c07731.label = 3;
                            objWithContext = BuildersKt.withContext(interceptorDispatcher, realImageLoader$executeMain$result$1, c07731);
                            if (objWithContext == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                            eventListener = eventListener2;
                            imageRequestBuild = imageRequest3;
                            requestDelegate2 = requestDelegate4;
                            realImageLoader = realImageLoader3;
                        } catch (Throwable th2) {
                            th = th2;
                            eventListener = eventListener2;
                            imageRequestBuild = imageRequest3;
                            requestDelegate2 = requestDelegate4;
                            realImageLoader = realImageLoader3;
                            if (th instanceof CancellationException) {
                                realImageLoader.onCancel(imageRequestBuild, eventListener);
                                throw th;
                            }
                            ErrorResult errorResult2 = realImageLoader.requestService.errorResult(imageRequestBuild, th);
                            realImageLoader.onError(errorResult2, imageRequestBuild.getTarget(), eventListener);
                            requestDelegate2.complete();
                            return errorResult2;
                        }
                    } else {
                        if (i2 != 3) {
                            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                        }
                        eventListener = (EventListener) c07731.L$3;
                        imageRequestBuild = (ImageRequest) c07731.L$2;
                        requestDelegate2 = (RequestDelegate) c07731.L$1;
                        realImageLoader = (RealImageLoader) c07731.L$0;
                        try {
                            ResultKt.throwOnFailure(objWithContext);
                        } catch (Throwable th3) {
                            th = th3;
                            try {
                                if (th instanceof CancellationException) {
                                    realImageLoader.onCancel(imageRequestBuild, eventListener);
                                    throw th;
                                }
                                ErrorResult errorResult3 = realImageLoader.requestService.errorResult(imageRequestBuild, th);
                                realImageLoader.onError(errorResult3, imageRequestBuild.getTarget(), eventListener);
                                requestDelegate2.complete();
                                return errorResult3;
                            } catch (Throwable th4) {
                                requestDelegate2.complete();
                                throw th4;
                            }
                        }
                    }
                    imageResult = (ImageResult) objWithContext;
                    if (imageResult instanceof SuccessResult) {
                        realImageLoader.onSuccess((SuccessResult) imageResult, imageRequestBuild.getTarget(), eventListener);
                    } else if (imageResult instanceof ErrorResult) {
                        realImageLoader.onError((ErrorResult) imageResult, imageRequestBuild.getTarget(), eventListener);
                    }
                    requestDelegate2.complete();
                    return imageResult;
                }
                eventListener2 = (EventListener) c07731.L$3;
                imageRequest2 = (ImageRequest) c07731.L$2;
                requestDelegate3 = (RequestDelegate) c07731.L$1;
                realImageLoader2 = (RealImageLoader) c07731.L$0;
                try {
                    ResultKt.throwOnFailure(objWithContext);
                    requestDelegate = requestDelegate3;
                } catch (Throwable th5) {
                    th = th5;
                    eventListener = eventListener2;
                    imageRequestBuild = imageRequest2;
                    requestDelegate2 = requestDelegate3;
                    realImageLoader = realImageLoader2;
                    if (th instanceof CancellationException) {
                        realImageLoader.onCancel(imageRequestBuild, eventListener);
                        throw th;
                    }
                    ErrorResult errorResult4 = realImageLoader.requestService.errorResult(imageRequestBuild, th);
                    realImageLoader.onError(errorResult4, imageRequestBuild.getTarget(), eventListener);
                    requestDelegate2.complete();
                    return errorResult4;
                }
            }
            MemoryCache memoryCache = realImageLoader2.getMemoryCache();
            if (memoryCache == null) {
                bitmap = null;
            } else {
                MemoryCache.Key placeholderMemoryCacheKey = imageRequest2.getPlaceholderMemoryCacheKey();
                MemoryCache.Value value = placeholderMemoryCacheKey != null ? memoryCache.get(placeholderMemoryCacheKey) : null;
                if (value != null) {
                    bitmap = value.getBitmap();
                } else {
                    bitmap = null;
                }
            }
            BitmapDrawable bitmapDrawable = bitmap != null ? new BitmapDrawable(imageRequest2.getContext().getResources(), bitmap) : imageRequest2.getPlaceholder();
            Target target = imageRequest2.getTarget();
            if (target != null) {
                target.onStart(bitmapDrawable);
            }
            eventListener2.onStart(imageRequest2);
            ImageRequest.Listener listener = imageRequest2.getListener();
            if (listener != null) {
                listener.onStart(imageRequest2);
            }
            eventListener2.resolveSizeStart(imageRequest2);
            SizeResolver sizeResolver = imageRequest2.getSizeResolver();
            c07731.L$0 = realImageLoader2;
            c07731.L$1 = requestDelegate;
            c07731.L$2 = imageRequest2;
            c07731.L$3 = eventListener2;
            c07731.L$4 = bitmap;
            c07731.label = 2;
            Object size2 = sizeResolver.size(c07731);
            if (size2 == coroutine_suspended) {
                return coroutine_suspended;
            }
            bitmap2 = bitmap;
            realImageLoader3 = realImageLoader2;
            ImageRequest imageRequest4 = imageRequest2;
            requestDelegate4 = requestDelegate;
            objWithContext = size2;
            imageRequest3 = imageRequest4;
            Size size3 = (Size) objWithContext;
            eventListener2.resolveSizeEnd(imageRequest3, size3);
            CoroutineContext interceptorDispatcher2 = imageRequest3.getInterceptorDispatcher();
            RealImageLoader$executeMain$result$1 realImageLoader$executeMain$result$2 = new RealImageLoader$executeMain$result$1(imageRequest3, realImageLoader3, size3, eventListener2, bitmap2, null);
            c07731.L$0 = realImageLoader3;
            c07731.L$1 = requestDelegate4;
            c07731.L$2 = imageRequest3;
            c07731.L$3 = eventListener2;
            c07731.L$4 = null;
            c07731.label = 3;
            objWithContext = BuildersKt.withContext(interceptorDispatcher2, realImageLoader$executeMain$result$2, c07731);
            if (objWithContext == coroutine_suspended) {
                return coroutine_suspended;
            }
            eventListener = eventListener2;
            imageRequestBuild = imageRequest3;
            requestDelegate2 = requestDelegate4;
            realImageLoader = realImageLoader3;
            imageResult = (ImageResult) objWithContext;
            if (imageResult instanceof SuccessResult) {
                realImageLoader.onSuccess((SuccessResult) imageResult, imageRequestBuild.getTarget(), eventListener);
            } else if (imageResult instanceof ErrorResult) {
                realImageLoader.onError((ErrorResult) imageResult, imageRequestBuild.getTarget(), eventListener);
            }
            requestDelegate2.complete();
            return imageResult;
        } catch (Throwable th6) {
            th = th6;
            requestDelegate2 = requestDelegate;
            eventListener = eventListener2;
            imageRequestBuild = imageRequest2;
            realImageLoader = realImageLoader2;
            if (th instanceof CancellationException) {
                realImageLoader.onCancel(imageRequestBuild, eventListener);
                throw th;
            }
            ErrorResult errorResult5 = realImageLoader.requestService.errorResult(imageRequestBuild, th);
            realImageLoader.onError(errorResult5, imageRequestBuild.getTarget(), eventListener);
            requestDelegate2.complete();
            return errorResult5;
        }
    }

    public final void onTrimMemory$coil_base_release(int level) {
        MemoryCache memoryCache;
        Lazy<MemoryCache> lazy = this.memoryCacheLazy;
        if (lazy == null || (memoryCache = (MemoryCache) lazy.getValue()) == null) {
            return;
        }
        memoryCache.trimMemory(level);
    }

    @Override
    public void shutdown() {
        if (this.shutdown.getAndSet(true)) {
            return;
        }
        CoroutineScopeKt.cancel$default(this.scope, (CancellationException) null, 1, (Object) null);
        this.systemCallbacks.shutdown();
        MemoryCache memoryCache = getMemoryCache();
        if (memoryCache != null) {
            memoryCache.clear();
        }
    }

    @Override
    public ImageLoader.Builder newBuilder() {
        return new ImageLoader.Builder(this);
    }

    private final void onSuccess(SuccessResult result, Target target, EventListener eventListener) {
        ImageRequest request = result.getRequest();
        DataSource dataSource = result.getDataSource();
        Logger logger = this.logger;
        if (logger != null && logger.getLevel() <= 4) {
            logger.log(TAG, 4, Utils.getEmoji(dataSource) + " Successful (" + dataSource.name() + ") - " + request.getData(), null);
        }
        if (target instanceof TransitionTarget) {
            SuccessResult successResult = result;
            Transition transitionCreate = successResult.getRequest().getTransitionFactory().create((TransitionTarget) target, successResult);
            if (transitionCreate instanceof NoneTransition) {
                target.onSuccess(result.getDrawable());
            } else {
                eventListener.transitionStart(successResult.getRequest(), transitionCreate);
                transitionCreate.transition();
                eventListener.transitionEnd(successResult.getRequest(), transitionCreate);
            }
        } else if (target != null) {
            target.onSuccess(result.getDrawable());
        }
        eventListener.onSuccess(request, result);
        ImageRequest.Listener listener = request.getListener();
        if (listener != null) {
            listener.onSuccess(request, result);
        }
    }

    private final void onError(ErrorResult result, Target target, EventListener eventListener) {
        ImageRequest request = result.getRequest();
        Logger logger = this.logger;
        if (logger != null && logger.getLevel() <= 4) {
            logger.log(TAG, 4, "🚨 Failed - " + request.getData() + " - " + result.getThrowable(), null);
        }
        if (target instanceof TransitionTarget) {
            ErrorResult errorResult = result;
            Transition transitionCreate = errorResult.getRequest().getTransitionFactory().create((TransitionTarget) target, errorResult);
            if (transitionCreate instanceof NoneTransition) {
                target.onError(result.getDrawable());
            } else {
                eventListener.transitionStart(errorResult.getRequest(), transitionCreate);
                transitionCreate.transition();
                eventListener.transitionEnd(errorResult.getRequest(), transitionCreate);
            }
        } else if (target != null) {
            target.onError(result.getDrawable());
        }
        eventListener.onError(request, result);
        ImageRequest.Listener listener = request.getListener();
        if (listener != null) {
            listener.onError(request, result);
        }
    }

    private final void onCancel(ImageRequest request, EventListener eventListener) {
        Logger logger = this.logger;
        if (logger != null && logger.getLevel() <= 4) {
            logger.log(TAG, 4, "🏗  Cancelled - " + request.getData(), null);
        }
        eventListener.onCancel(request);
        ImageRequest.Listener listener = request.getListener();
        if (listener != null) {
            listener.onCancel(request);
        }
    }

    private final void transition(ImageResult result, Target target, EventListener eventListener, Function0<Unit> setDrawable) {
        if (!(target instanceof TransitionTarget)) {
            setDrawable.invoke();
            return;
        }
        Transition transitionCreate = result.getRequest().getTransitionFactory().create((TransitionTarget) target, result);
        if (transitionCreate instanceof NoneTransition) {
            setDrawable.invoke();
            return;
        }
        eventListener.transitionStart(result.getRequest(), transitionCreate);
        transitionCreate.transition();
        eventListener.transitionEnd(result.getRequest(), transitionCreate);
    }
}
