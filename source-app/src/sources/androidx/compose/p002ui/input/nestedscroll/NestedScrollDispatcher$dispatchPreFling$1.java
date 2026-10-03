package androidx.compose.p002ui.input.nestedscroll;

import androidx.compose.runtime.ComposerKt;
import kotlin.Metadata;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;

@Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
@DebugMetadata(c = "androidx.compose.ui.input.nestedscroll.NestedScrollDispatcher", f = "NestedScrollModifier.kt", i = {}, l = {ComposerKt.providerValuesKey}, m = "dispatchPreFling-QWom1Mo", n = {}, s = {})
final class NestedScrollDispatcher$dispatchPreFling$1 extends ContinuationImpl {
    int label;
    Object result;
    final NestedScrollDispatcher this$0;

    NestedScrollDispatcher$dispatchPreFling$1(NestedScrollDispatcher nestedScrollDispatcher, Continuation<? super NestedScrollDispatcher$dispatchPreFling$1> continuation) {
        super(continuation);
        this.this$0 = nestedScrollDispatcher;
    }

    public final Object invokeSuspend(Object obj) {
        this.result = obj;
        this.label |= Integer.MIN_VALUE;
        return this.this$0.m5721dispatchPreFlingQWom1Mo(0L, (Continuation) this);
    }
}
