package kotlinx.coroutines.flow;

import kotlin.Metadata;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;

@Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
@DebugMetadata(m36c = "kotlinx.coroutines.flow.DistinctFlowImpl$collect$2", m37f = "Distinct.kt", m38i = {}, m39l = {73}, m40m = "emit", m41n = {}, m42s = {})
final class DistinctFlowImpl$collect$2$emit$1 extends ContinuationImpl {
    int label;
    Object result;
    final DistinctFlowImpl.C02632<T> this$0;

    DistinctFlowImpl$collect$2$emit$1(DistinctFlowImpl.C02632<? super T> c02632, Continuation<? super DistinctFlowImpl$collect$2$emit$1> continuation) {
        super(continuation);
        this.this$0 = c02632;
    }

    @Override
    public final Object invokeSuspend(Object obj) {
        this.result = obj;
        this.label |= Integer.MIN_VALUE;
        return this.this$0.emit(null, this);
    }
}
