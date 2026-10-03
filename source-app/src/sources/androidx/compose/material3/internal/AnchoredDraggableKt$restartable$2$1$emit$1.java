package androidx.compose.material3.internal;

import kotlin.Metadata;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;

@Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
@DebugMetadata(c = "androidx.compose.material3.internal.AnchoredDraggableKt$restartable$2$1", f = "AnchoredDraggable.kt", i = {0, 0}, l = {718}, m = "emit", n = {"this", "latestInputs"}, s = {"L$0", "L$1"})
final class AnchoredDraggableKt$restartable$2$1$emit$1 extends ContinuationImpl {
    Object L$0;
    Object L$1;
    Object L$2;
    int label;
    Object result;
    final AnchoredDraggableKt.C14672.AnonymousClass1<T> this$0;

    AnchoredDraggableKt$restartable$2$1$emit$1(AnchoredDraggableKt.C14672.AnonymousClass1<? super T> anonymousClass1, Continuation<? super AnchoredDraggableKt$restartable$2$1$emit$1> continuation) {
        super(continuation);
        this.this$0 = anonymousClass1;
    }

    public final Object invokeSuspend(Object obj) {
        this.result = obj;
        this.label |= Integer.MIN_VALUE;
        return this.this$0.emit(null, (Continuation) this);
    }
}
