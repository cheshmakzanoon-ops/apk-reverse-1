package androidx.compose.foundation.gestures;

import androidx.compose.foundation.MutatePriority;
import androidx.compose.foundation.MutatorMutex;
import androidx.compose.p002ui.geometry.Offset;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.CoroutineScopeKt;

@Metadata(d1 = {"\u0000B\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0002\u0018\u00002\u00020\u0001B\u0019\u0012\u0012\u0010\u0002\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00050\u0003¢\u0006\u0002\u0010\u0006J\u001a\u0010\r\u001a\u00020\u00052\u0006\u0010\u000e\u001a\u00020\u0004H\u0016ø\u0001\u0000¢\u0006\u0004\b\u000f\u0010\u0010J?\u0010\u0011\u001a\u00020\u00052\u0006\u0010\u0012\u001a\u00020\u00132'\u0010\u0014\u001a#\b\u0001\u0012\u0004\u0012\u00020\n\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00050\u0016\u0012\u0006\u0012\u0004\u0018\u00010\u00170\u0015¢\u0006\u0002\b\u0018H\u0096@¢\u0006\u0002\u0010\u0019R\u000e\u0010\u0007\u001a\u00020\bX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\t\u001a\u00020\nX\u0082\u0004¢\u0006\u0002\n\u0000R\u001d\u0010\u0002\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00050\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\f\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\u001a"}, d2 = {"Landroidx/compose/foundation/gestures/DefaultDraggable2DState;", "Landroidx/compose/foundation/gestures/Draggable2DState;", "onDelta", "Lkotlin/Function1;", "Landroidx/compose/ui/geometry/Offset;", "", "(Lkotlin/jvm/functions/Function1;)V", "drag2DMutex", "Landroidx/compose/foundation/MutatorMutex;", "drag2DScope", "Landroidx/compose/foundation/gestures/Drag2DScope;", "getOnDelta", "()Lkotlin/jvm/functions/Function1;", "dispatchRawDelta", "delta", "dispatchRawDelta-k-4lQ0M", "(J)V", "drag", "dragPriority", "Landroidx/compose/foundation/MutatePriority;", "block", "Lkotlin/Function2;", "Lkotlin/coroutines/Continuation;", "", "Lkotlin/ExtensionFunctionType;", "(Landroidx/compose/foundation/MutatePriority;Lkotlin/jvm/functions/Function2;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
final class DefaultDraggable2DState implements Draggable2DState {
    private final Function1<Offset, Unit> onDelta;
    private final Drag2DScope drag2DScope = new Drag2DScope() {
        @Override
        public void mo714dragByk4lQ0M(long pixels) {
            this.this$0.getOnDelta().invoke(Offset.m4335boximpl(pixels));
        }
    };
    private final MutatorMutex drag2DMutex = new MutatorMutex();

    public DefaultDraggable2DState(Function1<? super Offset, Unit> function1) {
        this.onDelta = function1;
    }

    public final Function1<Offset, Unit> getOnDelta() {
        return this.onDelta;
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.gestures.DefaultDraggable2DState$drag$2", f = "Draggable2D.kt", i = {}, l = {497}, m = "invokeSuspend", n = {}, s = {})
    static final class C04402 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final Function2<Drag2DScope, Continuation<? super Unit>, Object> $block;
        final MutatePriority $dragPriority;
        int label;

        C04402(MutatePriority mutatePriority, Function2<? super Drag2DScope, ? super Continuation<? super Unit>, ? extends Object> function2, Continuation<? super C04402> continuation) {
            super(2, continuation);
            this.$dragPriority = mutatePriority;
            this.$block = function2;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return DefaultDraggable2DState.this.new C04402(this.$dragPriority, this.$block, continuation);
        }

        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (DefaultDraggable2DState.this.drag2DMutex.mutateWith(DefaultDraggable2DState.this.drag2DScope, this.$dragPriority, this.$block, (Continuation) this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return Unit.INSTANCE;
        }
    }

    @Override
    public Object drag(MutatePriority mutatePriority, Function2<? super Drag2DScope, ? super Continuation<? super Unit>, ? extends Object> function2, Continuation<? super Unit> continuation) {
        Object objCoroutineScope = CoroutineScopeKt.coroutineScope(new C04402(mutatePriority, function2, null), continuation);
        return objCoroutineScope == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objCoroutineScope : Unit.INSTANCE;
    }

    @Override
    public void mo713dispatchRawDeltak4lQ0M(long delta) {
        this.onDelta.invoke(Offset.m4335boximpl(delta));
    }
}
