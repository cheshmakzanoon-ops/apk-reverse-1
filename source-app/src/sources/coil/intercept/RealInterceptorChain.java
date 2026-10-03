package coil.intercept;

import androidx.constraintlayout.widget.ConstraintLayout;
import coil.EventListener;
import coil.request.ImageRequest;
import coil.request.ImageResult;
import coil.request.NullRequestData;
import coil.size.Size;
import java.util.List;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;

@Metadata(d1 = {"\u0000F\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u000e\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0000\u0018\u00002\u00020\u0001BC\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\f\u0010\u0004\u001a\b\u0012\u0004\u0012\u00020\u00060\u0005\u0012\u0006\u0010\u0007\u001a\u00020\b\u0012\u0006\u0010\t\u001a\u00020\u0003\u0012\u0006\u0010\n\u001a\u00020\u000b\u0012\u0006\u0010\f\u001a\u00020\r\u0012\u0006\u0010\u000e\u001a\u00020\u000f¢\u0006\u0002\u0010\u0010J\u0018\u0010\u001d\u001a\u00020\u001e2\u0006\u0010\t\u001a\u00020\u00032\u0006\u0010\u001f\u001a\u00020\u0006H\u0002J&\u0010 \u001a\u00020\u00002\b\b\u0002\u0010\u0007\u001a\u00020\b2\b\b\u0002\u0010\t\u001a\u00020\u00032\b\b\u0002\u0010\n\u001a\u00020\u000bH\u0002J\u0016\u0010!\u001a\u00020\"2\u0006\u0010\t\u001a\u00020\u0003H\u0096@¢\u0006\u0002\u0010#J\u0010\u0010$\u001a\u00020\u00012\u0006\u0010\t\u001a\u00020\u0003H\u0016J\u0010\u0010%\u001a\u00020\u00012\u0006\u0010\n\u001a\u00020\u000bH\u0016R\u0011\u0010\f\u001a\u00020\r¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0012R\u0011\u0010\u0007\u001a\u00020\b¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u0014R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0016R\u0017\u0010\u0004\u001a\b\u0012\u0004\u0012\u00020\u00060\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0018R\u0011\u0010\u000e\u001a\u00020\u000f¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u0019R\u0014\u0010\t\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001a\u0010\u0016R\u0014\u0010\n\u001a\u00020\u000bX\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u001c¨\u0006&"}, d2 = {"Lcoil/intercept/RealInterceptorChain;", "Lcoil/intercept/Interceptor$Chain;", "initialRequest", "Lcoil/request/ImageRequest;", "interceptors", "", "Lcoil/intercept/Interceptor;", "index", "", "request", "size", "Lcoil/size/Size;", "eventListener", "Lcoil/EventListener;", "isPlaceholderCached", "", "(Lcoil/request/ImageRequest;Ljava/util/List;ILcoil/request/ImageRequest;Lcoil/size/Size;Lcoil/EventListener;Z)V", "getEventListener", "()Lcoil/EventListener;", "getIndex", "()I", "getInitialRequest", "()Lcoil/request/ImageRequest;", "getInterceptors", "()Ljava/util/List;", "()Z", "getRequest", "getSize", "()Lcoil/size/Size;", "checkRequest", "", "interceptor", "copy", "proceed", "Lcoil/request/ImageResult;", "(Lcoil/request/ImageRequest;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "withRequest", "withSize", "coil-base_release"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class RealInterceptorChain implements Interceptor.Chain {
    private final EventListener eventListener;
    private final int index;
    private final ImageRequest initialRequest;
    private final List<Interceptor> interceptors;
    private final boolean isPlaceholderCached;
    private final ImageRequest request;
    private final Size size;

    @Metadata(k = 3, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    @DebugMetadata(c = "coil.intercept.RealInterceptorChain", f = "RealInterceptorChain.kt", i = {0, 0}, l = {32}, m = "proceed", n = {"this", "interceptor"}, s = {"L$0", "L$1"})
    static final class C08071 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C08071(Continuation<? super C08071> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return RealInterceptorChain.this.proceed(null, (Continuation) this);
        }
    }

    public RealInterceptorChain(ImageRequest imageRequest, List<? extends Interceptor> list, int i, ImageRequest imageRequest2, Size size, EventListener eventListener, boolean z) {
        this.initialRequest = imageRequest;
        this.interceptors = list;
        this.index = i;
        this.request = imageRequest2;
        this.size = size;
        this.eventListener = eventListener;
        this.isPlaceholderCached = z;
    }

    public final ImageRequest getInitialRequest() {
        return this.initialRequest;
    }

    public final List<Interceptor> getInterceptors() {
        return this.interceptors;
    }

    public final int getIndex() {
        return this.index;
    }

    @Override
    public ImageRequest getRequest() {
        return this.request;
    }

    @Override
    public Size getSize() {
        return this.size;
    }

    public final EventListener getEventListener() {
        return this.eventListener;
    }

    public final boolean getIsPlaceholderCached() {
        return this.isPlaceholderCached;
    }

    @Override
    public Interceptor.Chain withRequest(ImageRequest request) {
        int i = this.index;
        if (i > 0) {
            checkRequest(request, this.interceptors.get(i - 1));
        }
        return copy$default(this, 0, request, null, 5, null);
    }

    @Override
    public Interceptor.Chain withSize(Size size) {
        return copy$default(this, 0, null, size, 3, null);
    }

    @Override
    public Object proceed(ImageRequest imageRequest, Continuation<? super ImageResult> continuation) {
        C08071 c08071;
        RealInterceptorChain realInterceptorChain;
        Interceptor interceptor;
        if (continuation instanceof C08071) {
            c08071 = (C08071) continuation;
            if ((c08071.label & Integer.MIN_VALUE) != 0) {
                c08071.label -= Integer.MIN_VALUE;
            } else {
                c08071 = new C08071(continuation);
            }
        } else {
            c08071 = new C08071(continuation);
        }
        Object obj = c08071.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c08071.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            int i2 = this.index;
            if (i2 > 0) {
                checkRequest(imageRequest, this.interceptors.get(i2 - 1));
            }
            Interceptor interceptor2 = this.interceptors.get(this.index);
            RealInterceptorChain realInterceptorChainCopy$default = copy$default(this, this.index + 1, imageRequest, null, 4, null);
            c08071.L$0 = this;
            c08071.L$1 = interceptor2;
            c08071.label = 1;
            Object objIntercept = interceptor2.intercept(realInterceptorChainCopy$default, c08071);
            if (objIntercept == coroutine_suspended) {
                return coroutine_suspended;
            }
            realInterceptorChain = this;
            obj = objIntercept;
            interceptor = interceptor2;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            interceptor = (Interceptor) c08071.L$1;
            realInterceptorChain = (RealInterceptorChain) c08071.L$0;
            ResultKt.throwOnFailure(obj);
        }
        ImageResult imageResult = (ImageResult) obj;
        realInterceptorChain.checkRequest(imageResult.getRequest(), interceptor);
        return imageResult;
    }

    private final void checkRequest(ImageRequest request, Interceptor interceptor) {
        if (request.getContext() != this.initialRequest.getContext()) {
            throw new IllegalStateException(("Interceptor '" + interceptor + "' cannot modify the request's context.").toString());
        }
        if (request.getData() == NullRequestData.INSTANCE) {
            throw new IllegalStateException(("Interceptor '" + interceptor + "' cannot set the request's data to null.").toString());
        }
        if (request.getTarget() != this.initialRequest.getTarget()) {
            throw new IllegalStateException(("Interceptor '" + interceptor + "' cannot modify the request's target.").toString());
        }
        if (request.getLifecycle() != this.initialRequest.getLifecycle()) {
            throw new IllegalStateException(("Interceptor '" + interceptor + "' cannot modify the request's lifecycle.").toString());
        }
        if (request.getSizeResolver() == this.initialRequest.getSizeResolver()) {
            return;
        }
        throw new IllegalStateException(("Interceptor '" + interceptor + "' cannot modify the request's size resolver. Use `Interceptor.Chain.withSize` instead.").toString());
    }

    static RealInterceptorChain copy$default(RealInterceptorChain realInterceptorChain, int i, ImageRequest imageRequest, Size size, int i2, Object obj) {
        if ((i2 & 1) != 0) {
            i = realInterceptorChain.index;
        }
        if ((i2 & 2) != 0) {
            imageRequest = realInterceptorChain.getRequest();
        }
        if ((i2 & 4) != 0) {
            size = realInterceptorChain.getSize();
        }
        return realInterceptorChain.copy(i, imageRequest, size);
    }

    private final RealInterceptorChain copy(int index, ImageRequest request, Size size) {
        return new RealInterceptorChain(this.initialRequest, this.interceptors, index, request, size, this.eventListener, this.isPlaceholderCached);
    }
}
