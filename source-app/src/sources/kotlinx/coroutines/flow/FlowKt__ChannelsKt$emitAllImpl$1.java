package kotlinx.coroutines.flow;

import kotlin.Metadata;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlinx.collections.immutable.implementations.immutableList.UtilsKt;
import zendesk.faye.internal.Bayeux;

@Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
@DebugMetadata(m36c = "kotlinx.coroutines.flow.FlowKt__ChannelsKt", m37f = "Channels.kt", m38i = {0, 0, 0, 1, 1, 1}, m39l = {32, UtilsKt.MUTABLE_BUFFER_SIZE}, m40m = "emitAllImpl$FlowKt__ChannelsKt", m41n = {"$this$emitAllImpl", Bayeux.KEY_CHANNEL, "consume", "$this$emitAllImpl", Bayeux.KEY_CHANNEL, "consume"}, m42s = {"L$0", "L$1", "Z$0", "L$0", "L$1", "Z$0"})
final class FlowKt__ChannelsKt$emitAllImpl$1<T> extends ContinuationImpl {
    Object L$0;
    Object L$1;
    Object L$2;
    boolean Z$0;
    int label;
    Object result;

    FlowKt__ChannelsKt$emitAllImpl$1(Continuation<? super FlowKt__ChannelsKt$emitAllImpl$1> continuation) {
        super(continuation);
    }

    @Override
    public final Object invokeSuspend(Object obj) {
        this.result = obj;
        this.label |= Integer.MIN_VALUE;
        return FlowKt__ChannelsKt.emitAllImpl$FlowKt__ChannelsKt(null, null, false, this);
    }
}
