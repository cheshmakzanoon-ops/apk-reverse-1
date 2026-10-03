package androidx.compose.foundation.gestures;

import kotlin.Metadata;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;

@Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
@DebugMetadata(c = "androidx.compose.foundation.gestures.ScrollableNestedScrollConnection", f = "Scrollable.kt", i = {0}, l = {865}, m = "onPostFling-RZ2iAVY", n = {"available"}, s = {"J$0"})
final class ScrollableNestedScrollConnection$onPostFling$1 extends ContinuationImpl {
    long J$0;
    int label;
    Object result;
    final ScrollableNestedScrollConnection this$0;

    ScrollableNestedScrollConnection$onPostFling$1(ScrollableNestedScrollConnection scrollableNestedScrollConnection, Continuation<? super ScrollableNestedScrollConnection$onPostFling$1> continuation) {
        super(continuation);
        this.this$0 = scrollableNestedScrollConnection;
    }

    public final Object invokeSuspend(Object obj) {
        this.result = obj;
        this.label |= Integer.MIN_VALUE;
        return this.this$0.mo828onPostFlingRZ2iAVY(0L, 0L, (Continuation) this);
    }
}
