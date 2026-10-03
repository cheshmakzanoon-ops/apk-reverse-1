package kotlinx.coroutines.flow;

import kotlin.Metadata;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import net.aihelp.data.model.p005cs.ConversationMsg;

@Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 176)
@DebugMetadata(m36c = "kotlinx.coroutines.flow.FlowKt__ReduceKt$fold$2", m37f = "Reduce.kt", m38i = {}, m39l = {ConversationMsg.TYPE_TIMESTAMP}, m40m = "emit", m41n = {}, m42s = {})
public final class FlowKt__ReduceKt$fold$2$emit$1 extends ContinuationImpl {
    Object L$0;
    int label;
    Object result;
    final FlowKt__ReduceKt.C03182<T> this$0;

    public FlowKt__ReduceKt$fold$2$emit$1(FlowKt__ReduceKt.C03182<? super T> c03182, Continuation<? super FlowKt__ReduceKt$fold$2$emit$1> continuation) {
        super(continuation);
        this.this$0 = c03182;
    }

    @Override
    public final Object invokeSuspend(Object obj) {
        this.result = obj;
        this.label |= Integer.MIN_VALUE;
        return this.this$0.emit(null, this);
    }
}
