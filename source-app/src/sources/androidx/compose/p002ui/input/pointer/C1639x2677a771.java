package androidx.compose.p002ui.input.pointer;

import kotlin.Metadata;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;

@Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
@DebugMetadata(c = "androidx.compose.ui.input.pointer.SuspendingPointerInputModifierNodeImpl$PointerEventHandlerCoroutine", f = "SuspendingPointerInputFilter.kt", i = {}, l = {753}, m = "withTimeoutOrNull", n = {}, s = {})
final class C1639x2677a771<T> extends ContinuationImpl {
    int label;
    Object result;
    final SuspendingPointerInputModifierNodeImpl.PointerEventHandlerCoroutine<R> this$0;

    C1639x2677a771(SuspendingPointerInputModifierNodeImpl.PointerEventHandlerCoroutine<R> pointerEventHandlerCoroutine, Continuation<? super C1639x2677a771> continuation) {
        super(continuation);
        this.this$0 = pointerEventHandlerCoroutine;
    }

    public final Object invokeSuspend(Object obj) {
        this.result = obj;
        this.label |= Integer.MIN_VALUE;
        return this.this$0.withTimeoutOrNull(0L, null, (Continuation) this);
    }
}
