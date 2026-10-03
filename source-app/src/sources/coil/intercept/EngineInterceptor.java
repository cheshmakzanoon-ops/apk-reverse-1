package coil.intercept;

import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import androidx.constraintlayout.widget.ConstraintLayout;
import coil.ComponentRegistry;
import coil.EventListener;
import coil.ImageLoader;
import coil.decode.DataSource;
import coil.decode.Decoder;
import coil.decode.ImageSource;
import coil.fetch.DrawableResult;
import coil.fetch.FetchResult;
import coil.fetch.Fetcher;
import coil.fetch.SourceResult;
import coil.memory.MemoryCache;
import coil.memory.MemoryCacheService;
import coil.request.ImageRequest;
import coil.request.ImageResult;
import coil.request.Options;
import coil.request.RequestService;
import coil.request.SuccessResult;
import coil.size.Scale;
import coil.size.Size;
import coil.transform.Transformation;
import coil.util.Bitmaps;
import coil.util.DrawableUtils;
import coil.util.Logger;
import coil.util.SystemCallbacks;
import coil.util.Utils;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import java.util.List;
import java.util.concurrent.CancellationException;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.Pair;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.collections.ArraysKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Ref;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineScope;

@Metadata(d1 = {"\u0000\u0082\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\b\b\u0000\u0018\u0000 22\u00020\u0001:\u000223B'\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\b\u0010\b\u001a\u0004\u0018\u00010\t¢\u0006\u0002\u0010\nJ&\u0010\r\u001a\u00020\u000e2\u0006\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\f\u0010\u0013\u001a\b\u0012\u0004\u0012\u00020\u00150\u0014H\u0002J>\u0010\u0016\u001a\u00020\u00172\u0006\u0010\u0018\u001a\u00020\u00192\u0006\u0010\u001a\u001a\u00020\u001b2\u0006\u0010\u001c\u001a\u00020\u001d2\u0006\u0010\u001e\u001a\u00020\u001f2\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010 \u001a\u00020!H\u0082@¢\u0006\u0002\u0010\"J.\u0010#\u001a\u00020\u00172\u0006\u0010\u001c\u001a\u00020\u001d2\u0006\u0010\u001e\u001a\u00020\u001f2\u0006\u0010$\u001a\u00020\u00122\u0006\u0010 \u001a\u00020!H\u0082@¢\u0006\u0002\u0010%J6\u0010&\u001a\u00020'2\u0006\u0010\u001a\u001a\u00020\u001b2\u0006\u0010\u001c\u001a\u00020\u001d2\u0006\u0010\u001e\u001a\u00020\u001f2\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010 \u001a\u00020!H\u0082@¢\u0006\u0002\u0010(J\u0016\u0010)\u001a\u00020*2\u0006\u0010+\u001a\u00020,H\u0096@¢\u0006\u0002\u0010-J0\u0010.\u001a\u00020\u00172\u0006\u0010/\u001a\u00020\u00172\u0006\u0010\u001c\u001a\u00020\u001d2\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010 \u001a\u00020!H\u0081@¢\u0006\u0004\b0\u00101R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\b\u001a\u0004\u0018\u00010\tX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000b\u001a\u00020\fX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000¨\u00064"}, d2 = {"Lcoil/intercept/EngineInterceptor;", "Lcoil/intercept/Interceptor;", "imageLoader", "Lcoil/ImageLoader;", "systemCallbacks", "Lcoil/util/SystemCallbacks;", "requestService", "Lcoil/request/RequestService;", "logger", "Lcoil/util/Logger;", "(Lcoil/ImageLoader;Lcoil/util/SystemCallbacks;Lcoil/request/RequestService;Lcoil/util/Logger;)V", "memoryCacheService", "Lcoil/memory/MemoryCacheService;", "convertDrawableToBitmap", "Landroid/graphics/Bitmap;", "drawable", "Landroid/graphics/drawable/Drawable;", SDKConstants.PARAM_GAME_REQUESTS_OPTIONS, "Lcoil/request/Options;", "transformations", "", "Lcoil/transform/Transformation;", "decode", "Lcoil/intercept/EngineInterceptor$ExecuteResult;", "fetchResult", "Lcoil/fetch/SourceResult;", "components", "Lcoil/ComponentRegistry;", "request", "Lcoil/request/ImageRequest;", "mappedData", "", "eventListener", "Lcoil/EventListener;", "(Lcoil/fetch/SourceResult;Lcoil/ComponentRegistry;Lcoil/request/ImageRequest;Ljava/lang/Object;Lcoil/request/Options;Lcoil/EventListener;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "execute", "_options", "(Lcoil/request/ImageRequest;Ljava/lang/Object;Lcoil/request/Options;Lcoil/EventListener;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "fetch", "Lcoil/fetch/FetchResult;", "(Lcoil/ComponentRegistry;Lcoil/request/ImageRequest;Ljava/lang/Object;Lcoil/request/Options;Lcoil/EventListener;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "intercept", "Lcoil/request/ImageResult;", "chain", "Lcoil/intercept/Interceptor$Chain;", "(Lcoil/intercept/Interceptor$Chain;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "transform", "result", "transform$coil_base_release", "(Lcoil/intercept/EngineInterceptor$ExecuteResult;Lcoil/request/ImageRequest;Lcoil/request/Options;Lcoil/EventListener;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "Companion", "ExecuteResult", "coil-base_release"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class EngineInterceptor implements Interceptor {
    private static final String TAG = "EngineInterceptor";
    private final ImageLoader imageLoader;
    private final Logger logger;
    private final MemoryCacheService memoryCacheService;
    private final RequestService requestService;
    private final SystemCallbacks systemCallbacks;

    @Metadata(k = 3, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    @DebugMetadata(c = "coil.intercept.EngineInterceptor", f = "EngineInterceptor.kt", i = {0, 0, 0, 0, 0, 0, 0, 0, 0}, l = {203}, m = "decode", n = {"this", "fetchResult", "components", "request", "mappedData", SDKConstants.PARAM_GAME_REQUESTS_OPTIONS, "eventListener", "decoder", "searchIndex"}, s = {"L$0", "L$1", "L$2", "L$3", "L$4", "L$5", "L$6", "L$7", "I$0"})
    static final class C08021 extends ContinuationImpl {
        int I$0;
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        Object L$4;
        Object L$5;
        Object L$6;
        Object L$7;
        int label;
        Object result;

        C08021(Continuation<? super C08021> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return EngineInterceptor.this.decode(null, null, null, null, null, null, (Continuation) this);
        }
    }

    @Metadata(k = 3, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    @DebugMetadata(c = "coil.intercept.EngineInterceptor", f = "EngineInterceptor.kt", i = {0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1}, l = {126, 130, 148}, m = "execute", n = {"this", "request", "mappedData", "eventListener", SDKConstants.PARAM_GAME_REQUESTS_OPTIONS, "components", "fetchResult", "this", "request", "eventListener", SDKConstants.PARAM_GAME_REQUESTS_OPTIONS, "fetchResult"}, s = {"L$0", "L$1", "L$2", "L$3", "L$4", "L$5", "L$6", "L$0", "L$1", "L$2", "L$3", "L$4"})
    static final class C08031 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        Object L$4;
        Object L$5;
        Object L$6;
        Object L$7;
        int label;
        Object result;

        C08031(Continuation<? super C08031> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return EngineInterceptor.this.execute(null, null, null, null, (Continuation) this);
        }
    }

    @Metadata(k = 3, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    @DebugMetadata(c = "coil.intercept.EngineInterceptor", f = "EngineInterceptor.kt", i = {0, 0, 0, 0, 0, 0, 0, 0}, l = {169}, m = "fetch", n = {"this", "components", "request", "mappedData", SDKConstants.PARAM_GAME_REQUESTS_OPTIONS, "eventListener", "fetcher", "searchIndex"}, s = {"L$0", "L$1", "L$2", "L$3", "L$4", "L$5", "L$6", "I$0"})
    static final class C08041 extends ContinuationImpl {
        int I$0;
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        Object L$4;
        Object L$5;
        Object L$6;
        int label;
        Object result;

        C08041(Continuation<? super C08041> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return EngineInterceptor.this.fetch(null, null, null, null, null, (Continuation) this);
        }
    }

    @Metadata(k = 3, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    @DebugMetadata(c = "coil.intercept.EngineInterceptor", f = "EngineInterceptor.kt", i = {0, 0}, l = {75}, m = "intercept", n = {"this", "chain"}, s = {"L$0", "L$1"})
    static final class C08051 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C08051(Continuation<? super C08051> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return EngineInterceptor.this.intercept(null, (Continuation) this);
        }
    }

    public EngineInterceptor(ImageLoader imageLoader, SystemCallbacks systemCallbacks, RequestService requestService, Logger logger) {
        this.imageLoader = imageLoader;
        this.systemCallbacks = systemCallbacks;
        this.requestService = requestService;
        this.logger = logger;
        this.memoryCacheService = new MemoryCacheService(imageLoader, requestService, logger);
    }

    @Override
    public Object intercept(Interceptor.Chain chain, Continuation<? super ImageResult> continuation) throws Throwable {
        C08051 c08051;
        EngineInterceptor engineInterceptor;
        if (continuation instanceof C08051) {
            c08051 = (C08051) continuation;
            if ((c08051.label & Integer.MIN_VALUE) != 0) {
                c08051.label -= Integer.MIN_VALUE;
            } else {
                c08051 = new C08051(continuation);
            }
        } else {
            c08051 = new C08051(continuation);
        }
        Object objWithContext = c08051.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c08051.label;
        if (i != 0) {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            chain = (Interceptor.Chain) c08051.L$1;
            engineInterceptor = (EngineInterceptor) c08051.L$0;
            try {
                ResultKt.throwOnFailure(objWithContext);
            } catch (Throwable th) {
                th = th;
                if (!(th instanceof CancellationException)) {
                    throw th;
                }
                return engineInterceptor.requestService.errorResult(chain.getRequest(), th);
            }
        }
        ResultKt.throwOnFailure(objWithContext);
        try {
            ImageRequest request = chain.getRequest();
            Object data = request.getData();
            Size size = chain.getSize();
            EventListener eventListener = Utils.getEventListener(chain);
            Options options = this.requestService.options(request, size);
            Scale scale = options.getScale();
            eventListener.mapStart(request, data);
            Object map = this.imageLoader.getComponents().map(data, options);
            eventListener.mapEnd(request, map);
            MemoryCache.Key keyNewCacheKey = this.memoryCacheService.newCacheKey(request, map, options, eventListener);
            MemoryCache.Value cacheValue = keyNewCacheKey != null ? this.memoryCacheService.getCacheValue(request, keyNewCacheKey, size, scale) : null;
            if (cacheValue != null) {
                return this.memoryCacheService.newResult(chain, request, keyNewCacheKey, cacheValue);
            }
            CoroutineContext fetcherDispatcher = request.getFetcherDispatcher();
            C08062 c08062 = new C08062(request, map, options, eventListener, keyNewCacheKey, chain, null);
            c08051.L$0 = this;
            c08051.L$1 = chain;
            c08051.label = 1;
            objWithContext = BuildersKt.withContext(fetcherDispatcher, c08062, c08051);
            return objWithContext == coroutine_suspended ? coroutine_suspended : objWithContext;
        } catch (Throwable th2) {
            th = th2;
            engineInterceptor = this;
            if (!(th instanceof CancellationException)) {
                throw th;
            }
            return engineInterceptor.requestService.errorResult(chain.getRequest(), th);
        }
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "Lcoil/request/SuccessResult;", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    @DebugMetadata(c = "coil.intercept.EngineInterceptor$intercept$2", f = "EngineInterceptor.kt", i = {}, l = {77}, m = "invokeSuspend", n = {}, s = {})
    static final class C08062 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super SuccessResult>, Object> {
        final MemoryCache.Key $cacheKey;
        final Interceptor.Chain $chain;
        final EventListener $eventListener;
        final Object $mappedData;
        final Options $options;
        final ImageRequest $request;
        int label;

        C08062(ImageRequest imageRequest, Object obj, Options options, EventListener eventListener, MemoryCache.Key key, Interceptor.Chain chain, Continuation<? super C08062> continuation) {
            super(2, continuation);
            this.$request = imageRequest;
            this.$mappedData = obj;
            this.$options = options;
            this.$eventListener = eventListener;
            this.$cacheKey = key;
            this.$chain = chain;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return EngineInterceptor.this.new C08062(this.$request, this.$mappedData, this.$options, this.$eventListener, this.$cacheKey, this.$chain, continuation);
        }

        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super SuccessResult> continuation) {
            return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                obj = EngineInterceptor.this.execute(this.$request, this.$mappedData, this.$options, this.$eventListener, (Continuation) this);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            ExecuteResult executeResult = (ExecuteResult) obj;
            EngineInterceptor.this.systemCallbacks.registerMemoryPressureCallbacks();
            return new SuccessResult(executeResult.getDrawable(), this.$request, executeResult.getDataSource(), EngineInterceptor.this.memoryCacheService.setCacheValue(this.$cacheKey, this.$request, executeResult) ? this.$cacheKey : null, executeResult.getDiskCacheKey(), executeResult.getIsSampled(), Utils.isPlaceholderCached(this.$chain));
        }
    }

    public final Object execute(ImageRequest imageRequest, Object obj, Options options, EventListener eventListener, Continuation<? super ExecuteResult> continuation) throws Throwable {
        C08031 c08031;
        Ref.ObjectRef objectRef;
        Ref.ObjectRef objectRef2;
        Object obj2;
        EventListener eventListener2;
        Ref.ObjectRef objectRef3;
        Ref.ObjectRef objectRef4;
        Ref.ObjectRef objectRef5;
        ImageRequest imageRequest2;
        EngineInterceptor engineInterceptor;
        FetchResult fetchResult;
        ExecuteResult executeResult;
        ImageRequest imageRequest3;
        EngineInterceptor engineInterceptor2;
        EventListener eventListener3;
        ImageRequest imageRequest4;
        EngineInterceptor engineInterceptor3;
        SourceResult sourceResult;
        ImageSource source;
        Object obj3;
        SourceResult sourceResult2;
        ImageSource source2;
        Bitmap bitmap;
        if (continuation instanceof C08031) {
            c08031 = (C08031) continuation;
            if ((c08031.label & Integer.MIN_VALUE) != 0) {
                c08031.label -= Integer.MIN_VALUE;
            } else {
                c08031 = new C08031(continuation);
            }
        } else {
            c08031 = new C08031(continuation);
        }
        C08031 c08032 = c08031;
        Object objFetch = c08032.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c08032.label;
        if (i == 0) {
            ResultKt.throwOnFailure(objFetch);
            Ref.ObjectRef objectRef6 = new Ref.ObjectRef();
            objectRef6.element = options;
            Ref.ObjectRef objectRef7 = new Ref.ObjectRef();
            objectRef7.element = this.imageLoader.getComponents();
            objectRef = new Ref.ObjectRef();
            try {
                objectRef6.element = this.requestService.updateOptionsOnWorkerThread((Options) objectRef6.element);
                if (imageRequest.getFetcherFactory() != null || imageRequest.getDecoderFactory() != null) {
                    ComponentRegistry.Builder builderNewBuilder = ((ComponentRegistry) objectRef7.element).newBuilder();
                    Pair<Fetcher.Factory<?>, Class<?>> fetcherFactory = imageRequest.getFetcherFactory();
                    if (fetcherFactory != null) {
                        builderNewBuilder.getFetcherFactories$coil_base_release().add(0, fetcherFactory);
                    }
                    Decoder.Factory decoderFactory = imageRequest.getDecoderFactory();
                    if (decoderFactory != null) {
                        builderNewBuilder.getDecoderFactories$coil_base_release().add(0, decoderFactory);
                    }
                    objectRef7.element = builderNewBuilder.build();
                }
                ComponentRegistry componentRegistry = (ComponentRegistry) objectRef7.element;
                Options options2 = (Options) objectRef6.element;
                c08032.L$0 = this;
                c08032.L$1 = imageRequest;
                c08032.L$2 = obj;
                c08032.L$3 = eventListener;
                c08032.L$4 = objectRef6;
                c08032.L$5 = objectRef7;
                c08032.L$6 = objectRef;
                c08032.L$7 = objectRef;
                c08032.label = 1;
                objFetch = fetch(componentRegistry, imageRequest, obj, options2, eventListener, c08032);
                if (objFetch == coroutine_suspended) {
                    return coroutine_suspended;
                }
                obj2 = obj;
                eventListener2 = eventListener;
                objectRef3 = objectRef6;
                objectRef4 = objectRef7;
                objectRef5 = objectRef;
                imageRequest2 = imageRequest;
                engineInterceptor = this;
                objectRef5.element = objFetch;
                fetchResult = (FetchResult) objectRef.element;
                if (fetchResult instanceof SourceResult) {
                    CoroutineContext decoderDispatcher = imageRequest2.getDecoderDispatcher();
                    EngineInterceptor$execute$executeResult$1 engineInterceptor$execute$executeResult$1 = new EngineInterceptor$execute$executeResult$1(engineInterceptor, objectRef, objectRef4, imageRequest2, obj2, objectRef3, eventListener2, null);
                    c08032.L$0 = engineInterceptor;
                    c08032.L$1 = imageRequest2;
                    c08032.L$2 = eventListener2;
                    c08032.L$3 = objectRef3;
                    c08032.L$4 = objectRef;
                    c08032.L$5 = null;
                    c08032.L$6 = null;
                    c08032.L$7 = null;
                    c08032.label = 2;
                    objFetch = BuildersKt.withContext(decoderDispatcher, engineInterceptor$execute$executeResult$1, c08032);
                    if (objFetch == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    eventListener3 = eventListener2;
                    imageRequest4 = imageRequest2;
                    engineInterceptor3 = engineInterceptor;
                    objectRef2 = objectRef;
                    executeResult = (ExecuteResult) objFetch;
                    objectRef = objectRef2;
                    engineInterceptor2 = engineInterceptor3;
                    eventListener2 = eventListener3;
                    imageRequest3 = imageRequest4;
                } else if (fetchResult instanceof DrawableResult) {
                    executeResult = new ExecuteResult(((DrawableResult) objectRef.element).getDrawable(), ((DrawableResult) objectRef.element).getIsSampled(), ((DrawableResult) objectRef.element).getDataSource(), null);
                    imageRequest3 = imageRequest2;
                    engineInterceptor2 = engineInterceptor;
                } else {
                    throw new NoWhenBranchMatchedException();
                }
                Ref.ObjectRef objectRef8 = objectRef3;
                ExecuteResult executeResult2 = executeResult;
                obj3 = objectRef.element;
                if (obj3 instanceof SourceResult) {
                    sourceResult2 = (SourceResult) obj3;
                } else {
                    sourceResult2 = null;
                }
                if (sourceResult2 != null) {
                    Utils.closeQuietly(source2);
                }
                Options options3 = (Options) objectRef8.element;
                c08032.L$0 = null;
                c08032.L$1 = null;
                c08032.L$2 = null;
                c08032.L$3 = null;
                c08032.L$4 = null;
                c08032.L$5 = null;
                c08032.L$6 = null;
                c08032.L$7 = null;
                c08032.label = 3;
                objFetch = engineInterceptor2.transform$coil_base_release(executeResult2, imageRequest3, options3, eventListener2, c08032);
                if (objFetch == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } catch (Throwable th) {
                th = th;
                objectRef2 = objectRef;
                Object obj4 = objectRef2.element;
                if (obj4 instanceof SourceResult) {
                }
                if (sourceResult != null) {
                    Utils.closeQuietly(source);
                }
                throw th;
            }
        } else if (i == 1) {
            objectRef5 = (Ref.ObjectRef) c08032.L$7;
            Ref.ObjectRef objectRef9 = (Ref.ObjectRef) c08032.L$6;
            Ref.ObjectRef objectRef10 = (Ref.ObjectRef) c08032.L$5;
            Ref.ObjectRef objectRef11 = (Ref.ObjectRef) c08032.L$4;
            eventListener2 = (EventListener) c08032.L$3;
            Object obj5 = c08032.L$2;
            imageRequest2 = (ImageRequest) c08032.L$1;
            engineInterceptor = (EngineInterceptor) c08032.L$0;
            try {
                ResultKt.throwOnFailure(objFetch);
                objectRef = objectRef9;
                objectRef4 = objectRef10;
                objectRef3 = objectRef11;
                obj2 = obj5;
                objectRef5.element = objFetch;
                fetchResult = (FetchResult) objectRef.element;
                if (fetchResult instanceof SourceResult) {
                    CoroutineContext decoderDispatcher2 = imageRequest2.getDecoderDispatcher();
                    EngineInterceptor$execute$executeResult$1 engineInterceptor$execute$executeResult$2 = new EngineInterceptor$execute$executeResult$1(engineInterceptor, objectRef, objectRef4, imageRequest2, obj2, objectRef3, eventListener2, null);
                    c08032.L$0 = engineInterceptor;
                    c08032.L$1 = imageRequest2;
                    c08032.L$2 = eventListener2;
                    c08032.L$3 = objectRef3;
                    c08032.L$4 = objectRef;
                    c08032.L$5 = null;
                    c08032.L$6 = null;
                    c08032.L$7 = null;
                    c08032.label = 2;
                    objFetch = BuildersKt.withContext(decoderDispatcher2, engineInterceptor$execute$executeResult$2, c08032);
                    if (objFetch == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    eventListener3 = eventListener2;
                    imageRequest4 = imageRequest2;
                    engineInterceptor3 = engineInterceptor;
                    objectRef2 = objectRef;
                    executeResult = (ExecuteResult) objFetch;
                    objectRef = objectRef2;
                    engineInterceptor2 = engineInterceptor3;
                    eventListener2 = eventListener3;
                    imageRequest3 = imageRequest4;
                } else if (fetchResult instanceof DrawableResult) {
                    executeResult = new ExecuteResult(((DrawableResult) objectRef.element).getDrawable(), ((DrawableResult) objectRef.element).getIsSampled(), ((DrawableResult) objectRef.element).getDataSource(), null);
                    imageRequest3 = imageRequest2;
                    engineInterceptor2 = engineInterceptor;
                } else {
                    throw new NoWhenBranchMatchedException();
                }
                Ref.ObjectRef objectRef12 = objectRef3;
                ExecuteResult executeResult3 = executeResult;
                obj3 = objectRef.element;
                if (obj3 instanceof SourceResult) {
                    sourceResult2 = (SourceResult) obj3;
                } else {
                    sourceResult2 = null;
                }
                if (sourceResult2 != null) {
                    Utils.closeQuietly(source2);
                }
                Options options4 = (Options) objectRef12.element;
                c08032.L$0 = null;
                c08032.L$1 = null;
                c08032.L$2 = null;
                c08032.L$3 = null;
                c08032.L$4 = null;
                c08032.L$5 = null;
                c08032.L$6 = null;
                c08032.L$7 = null;
                c08032.label = 3;
                objFetch = engineInterceptor2.transform$coil_base_release(executeResult3, imageRequest3, options4, eventListener2, c08032);
                if (objFetch == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } catch (Throwable th2) {
                th = th2;
                objectRef2 = objectRef9;
                Object obj6 = objectRef2.element;
                if (obj6 instanceof SourceResult) {
                }
                if (sourceResult != null && (source = sourceResult.getSource()) != null) {
                    Utils.closeQuietly(source);
                }
                throw th;
            }
        } else if (i == 2) {
            objectRef2 = (Ref.ObjectRef) c08032.L$4;
            objectRef3 = (Ref.ObjectRef) c08032.L$3;
            eventListener3 = (EventListener) c08032.L$2;
            imageRequest4 = (ImageRequest) c08032.L$1;
            engineInterceptor3 = (EngineInterceptor) c08032.L$0;
            try {
                ResultKt.throwOnFailure(objFetch);
                executeResult = (ExecuteResult) objFetch;
                objectRef = objectRef2;
                engineInterceptor2 = engineInterceptor3;
                eventListener2 = eventListener3;
                imageRequest3 = imageRequest4;
                Ref.ObjectRef objectRef13 = objectRef3;
                ExecuteResult executeResult4 = executeResult;
                obj3 = objectRef.element;
                if (obj3 instanceof SourceResult) {
                    sourceResult2 = (SourceResult) obj3;
                } else {
                    sourceResult2 = null;
                }
                if (sourceResult2 != null && (source2 = sourceResult2.getSource()) != null) {
                    Utils.closeQuietly(source2);
                }
                Options options5 = (Options) objectRef13.element;
                c08032.L$0 = null;
                c08032.L$1 = null;
                c08032.L$2 = null;
                c08032.L$3 = null;
                c08032.L$4 = null;
                c08032.L$5 = null;
                c08032.L$6 = null;
                c08032.L$7 = null;
                c08032.label = 3;
                objFetch = engineInterceptor2.transform$coil_base_release(executeResult4, imageRequest3, options5, eventListener2, c08032);
                if (objFetch == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } catch (Throwable th3) {
                th = th3;
                Object obj7 = objectRef2.element;
                sourceResult = obj7 instanceof SourceResult ? (SourceResult) obj7 : null;
                if (sourceResult != null) {
                    Utils.closeQuietly(source);
                }
                throw th;
            }
        } else {
            if (i != 3) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(objFetch);
        }
        ExecuteResult executeResult5 = (ExecuteResult) objFetch;
        Drawable drawable = executeResult5.getDrawable();
        BitmapDrawable bitmapDrawable = drawable instanceof BitmapDrawable ? (BitmapDrawable) drawable : null;
        if (bitmapDrawable != null && (bitmap = bitmapDrawable.getBitmap()) != null) {
            bitmap.prepareToDraw();
        }
        return executeResult5;
    }

    public final java.lang.Object fetch(coil.ComponentRegistry r10, coil.request.ImageRequest r11, java.lang.Object r12, coil.request.Options r13, coil.EventListener r14, kotlin.coroutines.Continuation<? super coil.fetch.FetchResult> r15) {
        throw new UnsupportedOperationException("Method not decompiled: coil.intercept.EngineInterceptor.fetch(coil.ComponentRegistry, coil.request.ImageRequest, java.lang.Object, coil.request.Options, coil.EventListener, kotlin.coroutines.Continuation):java.lang.Object");
    }

    public final java.lang.Object decode(coil.fetch.SourceResult r18, coil.ComponentRegistry r19, coil.request.ImageRequest r20, java.lang.Object r21, coil.request.Options r22, coil.EventListener r23, kotlin.coroutines.Continuation<? super coil.intercept.EngineInterceptor.ExecuteResult> r24) {
        throw new UnsupportedOperationException("Method not decompiled: coil.intercept.EngineInterceptor.decode(coil.fetch.SourceResult, coil.ComponentRegistry, coil.request.ImageRequest, java.lang.Object, coil.request.Options, coil.EventListener, kotlin.coroutines.Continuation):java.lang.Object");
    }

    public final Object transform$coil_base_release(ExecuteResult executeResult, ImageRequest imageRequest, Options options, EventListener eventListener, Continuation<? super ExecuteResult> continuation) {
        List<Transformation> transformations = imageRequest.getTransformations();
        if (transformations.isEmpty()) {
            return executeResult;
        }
        if (!(executeResult.getDrawable() instanceof BitmapDrawable) && !imageRequest.getAllowConversionToBitmap()) {
            Logger logger = this.logger;
            if (logger != null && logger.getLevel() <= 4) {
                logger.log(TAG, 4, "allowConversionToBitmap=false, skipping transformations for type " + executeResult.getDrawable().getClass().getCanonicalName() + '.', null);
            }
            return executeResult;
        }
        return BuildersKt.withContext(imageRequest.getTransformationDispatcher(), new EngineInterceptor$transform$3(this, executeResult, options, transformations, eventListener, imageRequest, null), continuation);
    }

    public final Bitmap convertDrawableToBitmap(Drawable drawable, Options options, List<? extends Transformation> transformations) {
        if (drawable instanceof BitmapDrawable) {
            Bitmap bitmap = ((BitmapDrawable) drawable).getBitmap();
            Bitmap.Config safeConfig = Bitmaps.getSafeConfig(bitmap);
            if (ArraysKt.contains(Utils.getVALID_TRANSFORMATION_CONFIGS(), safeConfig)) {
                return bitmap;
            }
            Logger logger = this.logger;
            if (logger != null && logger.getLevel() <= 4) {
                logger.log(TAG, 4, "Converting bitmap with config " + safeConfig + " to apply transformations: " + transformations + '.', null);
            }
        } else {
            Logger logger2 = this.logger;
            if (logger2 != null && logger2.getLevel() <= 4) {
                logger2.log(TAG, 4, "Converting drawable of type " + drawable.getClass().getCanonicalName() + " to apply transformations: " + transformations + '.', null);
            }
        }
        return DrawableUtils.INSTANCE.convertToBitmap(drawable, options.getConfig(), options.getSize(), options.getScale(), options.getAllowInexactSize());
    }

    @Metadata(d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\n\u0018\u00002\u00020\u0001B'\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\b\u0010\b\u001a\u0004\u0018\u00010\t¢\u0006\u0002\u0010\nJ0\u0010\u0012\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00072\n\b\u0002\u0010\b\u001a\u0004\u0018\u00010\tR\u0011\u0010\u0006\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR\u0013\u0010\b\u001a\u0004\u0018\u00010\t¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000eR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0004\u0010\u0011¨\u0006\u0013"}, d2 = {"Lcoil/intercept/EngineInterceptor$ExecuteResult;", "", "drawable", "Landroid/graphics/drawable/Drawable;", "isSampled", "", "dataSource", "Lcoil/decode/DataSource;", "diskCacheKey", "", "(Landroid/graphics/drawable/Drawable;ZLcoil/decode/DataSource;Ljava/lang/String;)V", "getDataSource", "()Lcoil/decode/DataSource;", "getDiskCacheKey", "()Ljava/lang/String;", "getDrawable", "()Landroid/graphics/drawable/Drawable;", "()Z", "copy", "coil-base_release"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class ExecuteResult {
        private final DataSource dataSource;
        private final String diskCacheKey;
        private final Drawable drawable;
        private final boolean isSampled;

        public ExecuteResult(Drawable drawable, boolean z, DataSource dataSource, String str) {
            this.drawable = drawable;
            this.isSampled = z;
            this.dataSource = dataSource;
            this.diskCacheKey = str;
        }

        public final Drawable getDrawable() {
            return this.drawable;
        }

        public final boolean getIsSampled() {
            return this.isSampled;
        }

        public final DataSource getDataSource() {
            return this.dataSource;
        }

        public final String getDiskCacheKey() {
            return this.diskCacheKey;
        }

        public static ExecuteResult copy$default(ExecuteResult executeResult, Drawable drawable, boolean z, DataSource dataSource, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                drawable = executeResult.drawable;
            }
            if ((i & 2) != 0) {
                z = executeResult.isSampled;
            }
            if ((i & 4) != 0) {
                dataSource = executeResult.dataSource;
            }
            if ((i & 8) != 0) {
                str = executeResult.diskCacheKey;
            }
            return executeResult.copy(drawable, z, dataSource, str);
        }

        public final ExecuteResult copy(Drawable drawable, boolean isSampled, DataSource dataSource, String diskCacheKey) {
            return new ExecuteResult(drawable, isSampled, dataSource, diskCacheKey);
        }
    }
}
