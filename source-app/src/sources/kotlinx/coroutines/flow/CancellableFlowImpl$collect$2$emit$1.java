package kotlinx.coroutines.flow;

import kotlin.Metadata;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;

@Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
@DebugMetadata(m36c = "kotlinx.coroutines.flow.CancellableFlowImpl$collect$2", m37f = "Context.kt", m38i = {}, m39l = {271}, m40m = "emit", m41n = {}, m42s = {})
final class CancellableFlowImpl$collect$2$emit$1 extends ContinuationImpl {
    int label;
    Object result;
    final CancellableFlowImpl.C02622<T> this$0;

    CancellableFlowImpl$collect$2$emit$1(CancellableFlowImpl.C02622<? super T> c02622, Continuation<? super CancellableFlowImpl$collect$2$emit$1> continuation) {
        super(continuation);
        this.this$0 = c02622;
    }

    @Override
    public final Object invokeSuspend(Object obj) {
        this.result = obj;
        this.label |= Integer.MIN_VALUE;
        return this.this$0.emit(null, this);
    }
}
