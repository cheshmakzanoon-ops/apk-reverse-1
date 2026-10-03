package androidx.compose.foundation;

import android.view.Surface;
import androidx.autofill.HintConstants;
import java.util.concurrent.CancellationException;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.Boxing;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.functions.Function5;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.CoroutineStart;
import kotlinx.coroutines.Job;
import kotlinx.coroutines.JobKt;

@Metadata(d1 = {"\u0000Z\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\t\b\"\u0018\u00002\u00020\u00012\u00020\u0002B\r\u0012\u0006\u0010\u0003\u001a\u00020\u0004¢\u0006\u0002\u0010\u0005J\u001e\u0010\u001d\u001a\u00020\u00132\u0006\u0010\u000e\u001a\u00020\u000b2\u0006\u0010\u0010\u001a\u00020\u000f2\u0006\u0010\u0011\u001a\u00020\u000fJ\u001e\u0010\u001e\u001a\u00020\u00132\u0006\u0010\u000e\u001a\u00020\u000b2\u0006\u0010\u0010\u001a\u00020\u000f2\u0006\u0010\u0011\u001a\u00020\u000fJ\u000e\u0010\u001f\u001a\u00020\u00132\u0006\u0010\u000e\u001a\u00020\u000bJu\u0010\b\u001a\u00020\u00132f\u0010\b\u001ab\b\u0001\u0012\u0004\u0012\u00020\n\u0012\u0013\u0012\u00110\u000b¢\u0006\f\b\f\u0012\b\b\r\u0012\u0004\b\b(\u000e\u0012\u0013\u0012\u00110\u000f¢\u0006\f\b\f\u0012\b\b\r\u0012\u0004\b\b(\u0010\u0012\u0013\u0012\u00110\u000f¢\u0006\f\b\f\u0012\b\b\r\u0012\u0004\b\b(\u0011\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00130\u0012\u0012\u0006\u0012\u0004\u0018\u00010\u00140\t¢\u0006\u0002\b\u0015H\u0016¢\u0006\u0002\u0010 JO\u0010!\u001a\u00020\u0013*\u00020\u000b2A\u0010!\u001a=\u0012\u0004\u0012\u00020\u000b\u0012\u0013\u0012\u00110\u000f¢\u0006\f\b\f\u0012\b\b\r\u0012\u0004\b\b(\u0010\u0012\u0013\u0012\u00110\u000f¢\u0006\f\b\f\u0012\b\b\r\u0012\u0004\b\b(\u0011\u0012\u0004\u0012\u00020\u00130\u0018¢\u0006\u0002\b\u0015H\u0016J%\u0010\"\u001a\u00020\u0013*\u00020\u000b2\u0017\u0010\"\u001a\u0013\u0012\u0004\u0012\u00020\u000b\u0012\u0004\u0012\u00020\u00130\u001a¢\u0006\u0002\b\u0015H\u0016R\u0010\u0010\u0006\u001a\u0004\u0018\u00010\u0007X\u0082\u000e¢\u0006\u0002\n\u0000Rr\u0010\b\u001ad\b\u0001\u0012\u0004\u0012\u00020\n\u0012\u0013\u0012\u00110\u000b¢\u0006\f\b\f\u0012\b\b\r\u0012\u0004\b\b(\u000e\u0012\u0013\u0012\u00110\u000f¢\u0006\f\b\f\u0012\b\b\r\u0012\u0004\b\b(\u0010\u0012\u0013\u0012\u00110\u000f¢\u0006\f\b\f\u0012\b\b\r\u0012\u0004\b\b(\u0011\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00130\u0012\u0012\u0006\u0012\u0004\u0018\u00010\u0014\u0018\u00010\t¢\u0006\u0002\b\u0015X\u0082\u000e¢\u0006\u0004\n\u0002\u0010\u0016RK\u0010\u0017\u001a?\u0012\u0004\u0012\u00020\u000b\u0012\u0013\u0012\u00110\u000f¢\u0006\f\b\f\u0012\b\b\r\u0012\u0004\b\b(\u0010\u0012\u0013\u0012\u00110\u000f¢\u0006\f\b\f\u0012\b\b\r\u0012\u0004\b\b(\u0011\u0012\u0004\u0012\u00020\u0013\u0018\u00010\u0018¢\u0006\u0002\b\u0015X\u0082\u000e¢\u0006\u0002\n\u0000R!\u0010\u0019\u001a\u0015\u0012\u0004\u0012\u00020\u000b\u0012\u0004\u0012\u00020\u0013\u0018\u00010\u001a¢\u0006\u0002\b\u0015X\u0082\u000e¢\u0006\u0002\n\u0000R\u0011\u0010\u0003\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u001c¨\u0006#"}, d2 = {"Landroidx/compose/foundation/BaseAndroidExternalSurfaceState;", "Landroidx/compose/foundation/AndroidExternalSurfaceScope;", "Landroidx/compose/foundation/SurfaceScope;", "scope", "Lkotlinx/coroutines/CoroutineScope;", "(Lkotlinx/coroutines/CoroutineScope;)V", "job", "Lkotlinx/coroutines/Job;", "onSurface", "Lkotlin/Function5;", "Landroidx/compose/foundation/SurfaceCoroutineScope;", "Landroid/view/Surface;", "Lkotlin/ParameterName;", HintConstants.AUTOFILL_HINT_NAME, "surface", "", "width", "height", "Lkotlin/coroutines/Continuation;", "", "", "Lkotlin/ExtensionFunctionType;", "Lkotlin/jvm/functions/Function5;", "onSurfaceChanged", "Lkotlin/Function3;", "onSurfaceDestroyed", "Lkotlin/Function1;", "getScope", "()Lkotlinx/coroutines/CoroutineScope;", "dispatchSurfaceChanged", "dispatchSurfaceCreated", "dispatchSurfaceDestroyed", "(Lkotlin/jvm/functions/Function5;)V", "onChanged", "onDestroyed", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
abstract class BaseAndroidExternalSurfaceState implements AndroidExternalSurfaceScope, SurfaceScope {
    private Job job;
    private Function5<? super SurfaceCoroutineScope, ? super Surface, ? super Integer, ? super Integer, ? super Continuation<? super Unit>, ? extends Object> onSurface;
    private Function3<? super Surface, ? super Integer, ? super Integer, Unit> onSurfaceChanged;
    private Function1<? super Surface, Unit> onSurfaceDestroyed;
    private final CoroutineScope scope;

    public BaseAndroidExternalSurfaceState(CoroutineScope coroutineScope) {
        this.scope = coroutineScope;
    }

    public final CoroutineScope getScope() {
        return this.scope;
    }

    @Override
    public void onSurface(Function5<? super SurfaceCoroutineScope, ? super Surface, ? super Integer, ? super Integer, ? super Continuation<? super Unit>, ? extends Object> onSurface) {
        this.onSurface = onSurface;
    }

    @Override
    public void onChanged(Surface surface, Function3<? super Surface, ? super Integer, ? super Integer, Unit> function3) {
        this.onSurfaceChanged = function3;
    }

    @Override
    public void onDestroyed(Surface surface, Function1<? super Surface, Unit> function1) {
        this.onSurfaceDestroyed = function1;
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.BaseAndroidExternalSurfaceState$dispatchSurfaceCreated$1", f = "AndroidExternalSurface.android.kt", i = {0}, l = {132, 137}, m = "invokeSuspend", n = {"$this$launch"}, s = {"L$0"})
    static final class C03461 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final int $height;
        final Surface $surface;
        final int $width;
        private Object L$0;
        int label;

        C03461(Surface surface, int i, int i2, Continuation<? super C03461> continuation) {
            super(2, continuation);
            this.$surface = surface;
            this.$width = i;
            this.$height = i2;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            Continuation<Unit> c03461 = BaseAndroidExternalSurfaceState.this.new C03461(this.$surface, this.$width, this.$height, continuation);
            c03461.L$0 = obj;
            return c03461;
        }

        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) {
            CoroutineScope coroutineScope;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                coroutineScope = (CoroutineScope) this.L$0;
                Job job = BaseAndroidExternalSurfaceState.this.job;
                if (job != null) {
                    this.L$0 = coroutineScope;
                    this.label = 1;
                    if (JobKt.cancelAndJoin(job, (Continuation) this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                }
            } else {
                if (i == 1) {
                    coroutineScope = (CoroutineScope) this.L$0;
                    ResultKt.throwOnFailure(obj);
                } else {
                    if (i != 2) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                }
                return Unit.INSTANCE;
            }
            C0347x6d6f8e47 c0347x6d6f8e47 = new C0347x6d6f8e47(BaseAndroidExternalSurfaceState.this, coroutineScope);
            Function5 function5 = BaseAndroidExternalSurfaceState.this.onSurface;
            if (function5 != null) {
                Surface surface = this.$surface;
                Integer numBoxInt = Boxing.boxInt(this.$width);
                Integer numBoxInt2 = Boxing.boxInt(this.$height);
                this.L$0 = null;
                this.label = 2;
                if (function5.invoke(c0347x6d6f8e47, surface, numBoxInt, numBoxInt2, this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            }
            return Unit.INSTANCE;
        }
    }

    public final void dispatchSurfaceCreated(Surface surface, int width, int height) {
        if (this.onSurface != null) {
            this.job = BuildersKt.launch$default(this.scope, (CoroutineContext) null, CoroutineStart.UNDISPATCHED, new C03461(surface, width, height, null), 1, (Object) null);
        }
    }

    public final void dispatchSurfaceChanged(Surface surface, int width, int height) {
        Function3<? super Surface, ? super Integer, ? super Integer, Unit> function3 = this.onSurfaceChanged;
        if (function3 != null) {
            function3.invoke(surface, Integer.valueOf(width), Integer.valueOf(height));
        }
    }

    public final void dispatchSurfaceDestroyed(Surface surface) {
        Function1<? super Surface, Unit> function1 = this.onSurfaceDestroyed;
        if (function1 != null) {
            function1.invoke(surface);
        }
        Job job = this.job;
        if (job != null) {
            Job.DefaultImpls.cancel$default(job, (CancellationException) null, 1, (Object) null);
        }
        this.job = null;
    }
}
