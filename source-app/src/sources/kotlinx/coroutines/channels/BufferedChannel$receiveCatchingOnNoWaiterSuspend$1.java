package kotlinx.coroutines.channels;

import kotlin.Metadata;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;

@Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
@DebugMetadata(m36c = "kotlinx.coroutines.channels.BufferedChannel", m37f = "BufferedChannel.kt", m38i = {0, 0, 0, 0}, m39l = {3117}, m40m = "receiveCatchingOnNoWaiterSuspend-GKJJFZk", m41n = {"this", "segment", "index", "r"}, m42s = {"L$0", "L$1", "I$0", "J$0"})
final class BufferedChannel$receiveCatchingOnNoWaiterSuspend$1 extends ContinuationImpl {
    int I$0;
    long J$0;
    Object L$0;
    Object L$1;
    int label;
    Object result;
    final BufferedChannel<E> this$0;

    BufferedChannel$receiveCatchingOnNoWaiterSuspend$1(BufferedChannel<E> bufferedChannel, Continuation<? super BufferedChannel$receiveCatchingOnNoWaiterSuspend$1> continuation) {
        super(continuation);
        this.this$0 = bufferedChannel;
    }

    @Override
    public final Object invokeSuspend(Object obj) throws Throwable {
        this.result = obj;
        this.label |= Integer.MIN_VALUE;
        Object objM1815receiveCatchingOnNoWaiterSuspendGKJJFZk = this.this$0.m1815receiveCatchingOnNoWaiterSuspendGKJJFZk(null, 0, 0L, this);
        return objM1815receiveCatchingOnNoWaiterSuspendGKJJFZk == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objM1815receiveCatchingOnNoWaiterSuspendGKJJFZk : ChannelResult.m1824boximpl(objM1815receiveCatchingOnNoWaiterSuspendGKJJFZk);
    }
}
