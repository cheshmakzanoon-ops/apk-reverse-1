package kotlinx.coroutines.channels;

import kotlin.Metadata;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;

@Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
@DebugMetadata(m36c = "kotlinx.coroutines.channels.BufferedChannel", m37f = "BufferedChannel.kt", m38i = {}, m39l = {759}, m40m = "receiveCatching-JP2dKIU$suspendImpl", m41n = {}, m42s = {})
final class BufferedChannel$receiveCatching$1<E> extends ContinuationImpl {
    int label;
    Object result;
    final BufferedChannel<E> this$0;

    BufferedChannel$receiveCatching$1(BufferedChannel<E> bufferedChannel, Continuation<? super BufferedChannel$receiveCatching$1> continuation) {
        super(continuation);
        this.this$0 = bufferedChannel;
    }

    @Override
    public final Object invokeSuspend(Object obj) throws Throwable {
        this.result = obj;
        this.label |= Integer.MIN_VALUE;
        Object objM1814receiveCatchingJP2dKIU$suspendImpl = BufferedChannel.m1814receiveCatchingJP2dKIU$suspendImpl(this.this$0, this);
        return objM1814receiveCatchingJP2dKIU$suspendImpl == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objM1814receiveCatchingJP2dKIU$suspendImpl : ChannelResult.m1824boximpl(objM1814receiveCatchingJP2dKIU$suspendImpl);
    }
}
