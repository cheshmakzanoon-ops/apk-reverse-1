package androidx.compose.p002ui.input.pointer;

import kotlin.Metadata;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;

@Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
@DebugMetadata(c = "androidx.compose.ui.input.pointer.SuspendingPointerInputModifierNodeImpl$PointerEventHandlerCoroutine", f = "SuspendingPointerInputFilter.kt", i = {0}, l = {782}, m = "withTimeout", n = {"job"}, s = {"L$0"})
final class C1637x647a7347<T> extends ContinuationImpl {
    Object L$0;
    int label;
    Object result;
    final SuspendingPointerInputModifierNodeImpl.PointerEventHandlerCoroutine<R> this$0;

    C1637x647a7347(SuspendingPointerInputModifierNodeImpl.PointerEventHandlerCoroutine<R> pointerEventHandlerCoroutine, Continuation<? super C1637x647a7347> continuation) {
        super(continuation);
        this.this$0 = pointerEventHandlerCoroutine;
    }

    public final Object invokeSuspend(Object obj) {
        this.result = obj;
        this.label |= Integer.MIN_VALUE;
        return this.this$0.withTimeout(0L, null, (Continuation) this);
    }
}
