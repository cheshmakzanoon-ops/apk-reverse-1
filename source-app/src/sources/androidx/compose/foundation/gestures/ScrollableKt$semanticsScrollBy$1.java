package androidx.compose.foundation.gestures;

import kotlin.Metadata;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;

@Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
@DebugMetadata(c = "androidx.compose.foundation.gestures.ScrollableKt", f = "Scrollable.kt", i = {0, 0}, l = {966}, m = "semanticsScrollBy-d-4ec7I", n = {"$this$semanticsScrollBy_u2dd_u2d4ec7I", "previousValue"}, s = {"L$0", "L$1"})
final class ScrollableKt$semanticsScrollBy$1 extends ContinuationImpl {
    Object L$0;
    Object L$1;
    int label;
    Object result;

    ScrollableKt$semanticsScrollBy$1(Continuation<? super ScrollableKt$semanticsScrollBy$1> continuation) {
        super(continuation);
    }

    public final Object invokeSuspend(Object obj) {
        this.result = obj;
        this.label |= Integer.MIN_VALUE;
        return ScrollableKt.m815semanticsScrollByd4ec7I(null, 0L, (Continuation) this);
    }
}
