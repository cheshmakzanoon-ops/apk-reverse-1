package androidx.compose.material3;

import kotlin.Metadata;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;

@Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
@DebugMetadata(c = "androidx.compose.material3.ExitUntilCollapsedScrollBehavior$nestedScrollConnection$1", f = "AppBar.kt", i = {0, 0}, l = {2467, 2469}, m = "onPostFling-RZ2iAVY", n = {"this", "available"}, s = {"L$0", "J$0"})
final class C1173x78ae0263 extends ContinuationImpl {
    long J$0;
    Object L$0;
    int label;
    Object result;
    final ExitUntilCollapsedScrollBehavior$nestedScrollConnection$1 this$0;

    C1173x78ae0263(ExitUntilCollapsedScrollBehavior$nestedScrollConnection$1 exitUntilCollapsedScrollBehavior$nestedScrollConnection$1, Continuation<? super C1173x78ae0263> continuation) {
        super(continuation);
        this.this$0 = exitUntilCollapsedScrollBehavior$nestedScrollConnection$1;
    }

    public final Object invokeSuspend(Object obj) {
        this.result = obj;
        this.label |= Integer.MIN_VALUE;
        return this.this$0.mo828onPostFlingRZ2iAVY(0L, 0L, (Continuation) this);
    }
}
