package kotlinx.coroutines.flow;

import kotlin.Metadata;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import net.aihelp.data.model.p005cs.ConversationMsg;

@Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
@DebugMetadata(m36c = "kotlinx.coroutines.flow.FlowKt__ReduceKt$reduce$2", m37f = "Reduce.kt", m38i = {}, m39l = {ConversationMsg.TYPE_USER_TEXT}, m40m = "emit", m41n = {}, m42s = {})
final class FlowKt__ReduceKt$reduce$2$emit$1 extends ContinuationImpl {
    Object L$0;
    int label;
    Object result;
    final FlowKt__ReduceKt.C03242<T> this$0;

    FlowKt__ReduceKt$reduce$2$emit$1(FlowKt__ReduceKt.C03242<? super T> c03242, Continuation<? super FlowKt__ReduceKt$reduce$2$emit$1> continuation) {
        super(continuation);
        this.this$0 = c03242;
    }

    @Override
    public final Object invokeSuspend(Object obj) {
        this.result = obj;
        this.label |= Integer.MIN_VALUE;
        return this.this$0.emit(null, this);
    }
}
