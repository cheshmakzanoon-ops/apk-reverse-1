package kotlinx.coroutines.flow;

import kotlin.Metadata;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;

@Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 176)
@DebugMetadata(m36c = "kotlinx.coroutines.flow.FlowKt__EmittersKt$transform$1$1", m37f = "Emitters.kt", m38i = {}, m39l = {38}, m40m = "emit", m41n = {}, m42s = {})
public final class FlowKt__EmittersKt$transform$1$1$emit$1 extends ContinuationImpl {
    int label;
    Object result;
    final FlowKt__EmittersKt.C02901.AnonymousClass1<T> this$0;

    public FlowKt__EmittersKt$transform$1$1$emit$1(FlowKt__EmittersKt.C02901.AnonymousClass1<? super T> anonymousClass1, Continuation<? super FlowKt__EmittersKt$transform$1$1$emit$1> continuation) {
        super(continuation);
        this.this$0 = anonymousClass1;
    }

    @Override
    public final Object invokeSuspend(Object obj) {
        this.result = obj;
        this.label |= Integer.MIN_VALUE;
        return this.this$0.emit(null, this);
    }
}
