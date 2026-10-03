package coil;

import android.content.Context;
import androidx.constraintlayout.widget.ConstraintLayout;
import coil.request.ImageRequest;
import coil.request.ImageResult;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineScope;

@Metadata(d1 = {"\u0000\u001c\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\u001a\u0015\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u0003H\u0007¢\u0006\u0002\b\u0004\u001a\u0014\u0010\u0005\u001a\u00020\u0006*\u00020\u00012\u0006\u0010\u0007\u001a\u00020\bH\u0007¨\u0006\t"}, d2 = {"ImageLoader", "Lcoil/ImageLoader;", "context", "Landroid/content/Context;", "create", "executeBlocking", "Lcoil/request/ImageResult;", "request", "Lcoil/request/ImageRequest;", "coil-base_release"}, k = 2, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class ImageLoaders {
    public static final ImageLoader create(Context context) {
        return new ImageLoader.Builder(context).build();
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "Lcoil/request/ImageResult;", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    @DebugMetadata(c = "coil.ImageLoaders$executeBlocking$1", f = "ImageLoaders.kt", i = {}, l = {26}, m = "invokeSuspend", n = {}, s = {})
    static final class C07711 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super ImageResult>, Object> {
        final ImageRequest $request;
        final ImageLoader $this_executeBlocking;
        int label;

        C07711(ImageLoader imageLoader, ImageRequest imageRequest, Continuation<? super C07711> continuation) {
            super(2, continuation);
            this.$this_executeBlocking = imageLoader;
            this.$request = imageRequest;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return new C07711(this.$this_executeBlocking, this.$request, continuation);
        }

        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super ImageResult> continuation) {
            return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                obj = this.$this_executeBlocking.execute(this.$request, (Continuation) this);
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

    public static final ImageResult executeBlocking(ImageLoader imageLoader, ImageRequest imageRequest) {
        return (ImageResult) BuildersKt.runBlocking$default((CoroutineContext) null, new C07711(imageLoader, imageRequest, null), 1, (Object) null);
    }
}
