package coil;

import androidx.constraintlayout.widget.ConstraintLayout;
import coil.request.ErrorResult;
import coil.request.ImageRequest;
import coil.request.ImageResult;
import coil.util.Logger;
import coil.util.Logs;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.CoroutineScope;

@Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "Lcoil/request/ImageResult;", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
@DebugMetadata(c = "coil.RealImageLoader$enqueue$job$1", f = "RealImageLoader.kt", i = {}, l = {113}, m = "invokeSuspend", n = {}, s = {})
final class RealImageLoader$enqueue$job$1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super ImageResult>, Object> {
    final ImageRequest $request;
    int label;
    final RealImageLoader this$0;

    RealImageLoader$enqueue$job$1(RealImageLoader realImageLoader, ImageRequest imageRequest, Continuation<? super RealImageLoader$enqueue$job$1> continuation) {
        super(2, continuation);
        this.this$0 = realImageLoader;
        this.$request = imageRequest;
    }

    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        return new RealImageLoader$enqueue$job$1(this.this$0, this.$request, continuation);
    }

    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super ImageResult> continuation) {
        return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
    }

    public final Object invokeSuspend(Object obj) {
        Logger logger;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            this.label = 1;
            obj = this.this$0.executeMain(this.$request, 0, (Continuation) this);
            if (obj == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
        }
        RealImageLoader realImageLoader = this.this$0;
        ImageResult imageResult = (ImageResult) obj;
        if ((imageResult instanceof ErrorResult) && (logger = realImageLoader.getLogger()) != null) {
            Logs.log(logger, "RealImageLoader", ((ErrorResult) imageResult).getThrowable());
        }
        return obj;
    }
}
