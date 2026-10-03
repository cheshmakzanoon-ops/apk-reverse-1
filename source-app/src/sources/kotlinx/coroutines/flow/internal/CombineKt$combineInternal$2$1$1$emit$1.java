package kotlinx.coroutines.flow.internal;

import kotlin.Metadata;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;

@Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
@DebugMetadata(m36c = "kotlinx.coroutines.flow.internal.CombineKt$combineInternal$2$1$1", m37f = "Combine.kt", m38i = {}, m39l = {29, 30}, m40m = "emit", m41n = {}, m42s = {})
final class CombineKt$combineInternal$2$1$1$emit$1 extends ContinuationImpl {
    int label;
    Object result;
    final CombineKt.C03722.AnonymousClass1.C16601<T> this$0;

    CombineKt$combineInternal$2$1$1$emit$1(CombineKt.C03722.AnonymousClass1.C16601<? super T> c16601, Continuation<? super CombineKt$combineInternal$2$1$1$emit$1> continuation) {
        super(continuation);
        this.this$0 = c16601;
    }

    @Override
    public final Object invokeSuspend(Object obj) {
        this.result = obj;
        this.label |= Integer.MIN_VALUE;
        return this.this$0.emit(null, this);
    }
}
