package androidx.compose.p002ui.input.pointer;

import kotlin.Metadata;
import kotlin.Result;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.DelayKt;

@Metadata(d1 = {"\u0000\u000e\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002\"\u0004\b\u0001\u0010\u0003*\u00020\u0004H\u008a@"}, d2 = {"<anonymous>", "", "T", "R", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
@DebugMetadata(c = "androidx.compose.ui.input.pointer.SuspendingPointerInputModifierNodeImpl$PointerEventHandlerCoroutine$withTimeout$job$1", f = "SuspendingPointerInputFilter.kt", i = {}, l = {774, 775}, m = "invokeSuspend", n = {}, s = {})
final class C1638xf3489d20 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
    final long $timeMillis;
    int label;
    final SuspendingPointerInputModifierNodeImpl.PointerEventHandlerCoroutine<R> this$0;

    C1638xf3489d20(long j, SuspendingPointerInputModifierNodeImpl.PointerEventHandlerCoroutine<R> pointerEventHandlerCoroutine, Continuation<? super C1638xf3489d20> continuation) {
        super(2, continuation);
        this.$timeMillis = j;
        this.this$0 = pointerEventHandlerCoroutine;
    }

    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        return new C1638xf3489d20(this.$timeMillis, this.this$0, continuation);
    }

    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
        return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
    }

    public final Object invokeSuspend(Object obj) {
        Continuation continuation;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i != 0) {
            if (i == 1) {
                ResultKt.throwOnFailure(obj);
            } else {
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            continuation = ((SuspendingPointerInputModifierNodeImpl.PointerEventHandlerCoroutine) this.this$0).pointerAwaiter;
            if (continuation != null) {
                Result.Companion companion = Result.Companion;
                continuation.resumeWith(Result.constructor-impl(ResultKt.createFailure(new PointerEventTimeoutCancellationException(this.$timeMillis))));
            }
            return Unit.INSTANCE;
        }
        ResultKt.throwOnFailure(obj);
        this.label = 1;
        if (DelayKt.delay(this.$timeMillis - 1, (Continuation) this) == coroutine_suspended) {
            return coroutine_suspended;
        }
        this.label = 2;
        if (DelayKt.delay(1L, (Continuation) this) == coroutine_suspended) {
            return coroutine_suspended;
        }
        continuation = ((SuspendingPointerInputModifierNodeImpl.PointerEventHandlerCoroutine) this.this$0).pointerAwaiter;
        if (continuation != null) {
            Result.Companion companion2 = Result.Companion;
            continuation.resumeWith(Result.constructor-impl(ResultKt.createFailure(new PointerEventTimeoutCancellationException(this.$timeMillis))));
        }
        return Unit.INSTANCE;
    }
}
