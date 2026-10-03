package kotlinx.coroutines.channels;

import java.util.concurrent.CancellationException;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.jvm.functions.Function1;
import kotlinx.coroutines.AbstractCoroutine;
import kotlinx.coroutines.JobCancellationException;
import kotlinx.coroutines.JobSupport;
import kotlinx.coroutines.selects.SelectClause1;
import kotlinx.coroutines.selects.SelectClause2;
import zendesk.faye.internal.Bayeux;

@Metadata(m17d1 = {"\u0000b\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\t\n\u0002\u0010\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0010\u0018\u0000*\u0004\b\u0000\u0010\u00012\b\u0012\u0004\u0012\u00020\u00030\u00022\b\u0012\u0004\u0012\u0002H\u00010\u0004B-\u0012\u0006\u0010\u0005\u001a\u00020\u0006\u0012\f\u0010\u0007\u001a\b\u0012\u0004\u0012\u00028\u00000\u0004\u0012\u0006\u0010\b\u001a\u00020\t\u0012\u0006\u0010\n\u001a\u00020\t¢\u0006\u0004\b\u000b\u0010\fJ\b\u0010\u0011\u001a\u00020\u0003H\u0017J\u0012\u0010\u0011\u001a\u00020\t2\b\u0010\u0012\u001a\u0004\u0018\u00010\u0013H\u0007J\u001b\u0010\u0011\u001a\u00020\u00032\u000e\u0010\u0012\u001a\n\u0018\u00010\u0015j\u0004\u0018\u0001`\u0014¢\u0006\u0002\u0010\u0016J\u0010\u0010\u0017\u001a\u00020\u00032\u0006\u0010\u0012\u001a\u00020\u0013H\u0016J\u0013\u0010\u0018\u001a\u00020\t2\b\u0010\u0012\u001a\u0004\u0018\u00010\u0013H\u0096\u0001J.\u0010\u0019\u001a\u00020\u00032#\u0010\u001a\u001a\u001f\u0012\u0015\u0012\u0013\u0018\u00010\u0013¢\u0006\f\b\u001c\u0012\b\b\u001d\u0012\u0004\b\b(\u0012\u0012\u0004\u0012\u00020\u00030\u001bH\u0096\u0001J\u000f\u0010\u001e\u001a\b\u0012\u0004\u0012\u00028\u00000\u001fH\u0096\u0003J\u0011\u0010 \u001a\u00020\t2\u0006\u0010!\u001a\u00028\u0000H\u0097\u0001J\u000b\u0010\"\u001a\u0004\u0018\u00018\u0000H\u0097\u0001J\t\u0010#\u001a\u00028\u0000H\u0096AJ\u000f\u0010$\u001a\b\u0012\u0004\u0012\u00028\u00000%H\u0096AJ\u000b\u0010&\u001a\u0004\u0018\u00018\u0000H\u0097AJ\u0011\u0010'\u001a\u00020\u00032\u0006\u0010!\u001a\u00028\u0000H\u0096AJ\u000f\u0010(\u001a\b\u0012\u0004\u0012\u00028\u00000%H\u0096\u0001J\u0017\u0010)\u001a\b\u0012\u0004\u0012\u00020\u00030%2\u0006\u0010!\u001a\u00028\u0000H\u0096\u0001R\u001a\u0010\u0007\u001a\b\u0012\u0004\u0012\u00028\u00000\u0004X\u0084\u0004¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000eR\u0017\u0010\u000f\u001a\b\u0012\u0004\u0012\u00028\u00000\u00048F¢\u0006\u0006\u001a\u0004\b\u0010\u0010\u000eR\u000b\u0010*\u001a\u00020\t8\u0016X\u0097\u0005R\u000b\u0010+\u001a\u00020\t8\u0016X\u0097\u0005R\u000b\u0010,\u001a\u00020\t8\u0016X\u0097\u0005R\u000f\u0010-\u001a\b\u0012\u0004\u0012\u00028\u00000.X\u0096\u0005R\u0015\u0010/\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000%0.X\u0096\u0005R\u0013\u00100\u001a\n\u0012\u0006\u0012\u0004\u0018\u00018\u00000.8\u0016X\u0097\u0005R\u001b\u00101\u001a\u0014\u0012\u0004\u0012\u00028\u0000\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000302X\u0096\u0005¨\u00064"}, m18d2 = {"Lkotlinx/coroutines/channels/ChannelCoroutine;", "E", "Lkotlinx/coroutines/AbstractCoroutine;", "", "Lkotlinx/coroutines/channels/Channel;", "parentContext", "Lkotlin/coroutines/CoroutineContext;", "_channel", "initParentJob", "", "active", "<init>", "(Lkotlin/coroutines/CoroutineContext;Lkotlinx/coroutines/channels/Channel;ZZ)V", "get_channel", "()Lkotlinx/coroutines/channels/Channel;", Bayeux.KEY_CHANNEL, "getChannel", "cancel", "cause", "", "Lkotlinx/coroutines/CancellationException;", "Ljava/util/concurrent/CancellationException;", "(Ljava/util/concurrent/CancellationException;)V", "cancelInternal", "close", "invokeOnClose", "handler", "Lkotlin/Function1;", "Lkotlin/ParameterName;", "name", "iterator", "Lkotlinx/coroutines/channels/ChannelIterator;", "offer", "element", "poll", "receive", "receiveCatching", "Lkotlinx/coroutines/channels/ChannelResult;", "receiveOrNull", "send", "tryReceive", "trySend", "isClosedForReceive", "isClosedForSend", "isEmpty", "onReceive", "Lkotlinx/coroutines/selects/SelectClause1;", "onReceiveCatching", "onReceiveOrNull", "onSend", "Lkotlinx/coroutines/selects/SelectClause2;", "Lkotlinx/coroutines/channels/SendChannel;", "kotlinx-coroutines-core"}, m19k = 1, m20mv = {2, 0, 0}, m22xi = 48)
public class ChannelCoroutine<E> extends AbstractCoroutine<Unit> implements Channel<E> {
    private final Channel<E> _channel;

    @Override
    public boolean close(Throwable cause) {
        return this._channel.close(cause);
    }

    @Override
    public SelectClause1<E> getOnReceive() {
        return this._channel.getOnReceive();
    }

    @Override
    public SelectClause1<ChannelResult<E>> getOnReceiveCatching() {
        return this._channel.getOnReceiveCatching();
    }

    @Override
    public SelectClause1<E> getOnReceiveOrNull() {
        return this._channel.getOnReceiveOrNull();
    }

    @Override
    public SelectClause2<E, SendChannel<E>> getOnSend() {
        return this._channel.getOnSend();
    }

    @Override
    public void invokeOnClose(Function1<? super Throwable, Unit> handler) {
        this._channel.invokeOnClose(handler);
    }

    @Override
    public boolean isClosedForReceive() {
        return this._channel.isClosedForReceive();
    }

    @Override
    public boolean isClosedForSend() {
        return this._channel.isClosedForSend();
    }

    @Override
    public boolean isEmpty() {
        return this._channel.isEmpty();
    }

    @Override
    public ChannelIterator<E> iterator() {
        return this._channel.iterator();
    }

    @Override
    @Deprecated(level = DeprecationLevel.ERROR, message = "Deprecated in the favour of 'trySend' method", replaceWith = @ReplaceWith(expression = "trySend(element).isSuccess", imports = {}))
    public boolean offer(E e) {
        return this._channel.offer(e);
    }

    @Override
    @Deprecated(level = DeprecationLevel.ERROR, message = "Deprecated in the favour of 'tryReceive'. Please note that the provided replacement does not rethrow channel's close cause as 'poll' did, for the precise replacement please refer to the 'poll' documentation", replaceWith = @ReplaceWith(expression = "tryReceive().getOrNull()", imports = {}))
    public E poll() {
        return this._channel.poll();
    }

    @Override
    public Object receive(Continuation<? super E> continuation) {
        return this._channel.receive(continuation);
    }

    @Override
    public Object mo1816receiveCatchingJP2dKIU(Continuation<? super ChannelResult<? extends E>> continuation) {
        Object obj = this._channel.mo1816receiveCatchingJP2dKIU(continuation);
        IntrinsicsKt.getCOROUTINE_SUSPENDED();
        return obj;
    }

    @Override
    @Deprecated(level = DeprecationLevel.ERROR, message = "Deprecated in favor of 'receiveCatching'. Please note that the provided replacement does not rethrow channel's close cause as 'receiveOrNull' did, for the detailed replacement please refer to the 'receiveOrNull' documentation", replaceWith = @ReplaceWith(expression = "receiveCatching().getOrNull()", imports = {}))
    public Object receiveOrNull(Continuation<? super E> continuation) {
        return this._channel.receiveOrNull(continuation);
    }

    @Override
    public Object send(E e, Continuation<? super Unit> continuation) {
        return this._channel.send(e, continuation);
    }

    @Override
    public Object mo1817tryReceivePtdJZtk() {
        return this._channel.mo1817tryReceivePtdJZtk();
    }

    @Override
    public Object mo1809trySendJP2dKIU(E e) {
        return this._channel.mo1809trySendJP2dKIU(e);
    }

    protected final Channel<E> get_channel() {
        return this._channel;
    }

    public ChannelCoroutine(CoroutineContext coroutineContext, Channel<E> channel, boolean z, boolean z2) {
        super(coroutineContext, z, z2);
        this._channel = channel;
    }

    public final Channel<E> getChannel() {
        return this;
    }

    @Override
    public final void cancel(CancellationException cause) {
        if (isCancelled()) {
            return;
        }
        if (cause == null) {
            ChannelCoroutine<E> channelCoroutine = this;
            cause = new JobCancellationException(channelCoroutine.cancellationExceptionMessage(), null, channelCoroutine);
        }
        cancelInternal(cause);
    }

    @Override
    public void cancelInternal(Throwable cause) {
        CancellationException cancellationException$default = JobSupport.toCancellationException$default(this, cause, null, 1, null);
        this._channel.cancel(cancellationException$default);
        cancelCoroutine(cancellationException$default);
    }

    @Override
    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Since 1.2.0, binary compatibility with versions <= 1.1.x")
    public void cancel() {
        ChannelCoroutine<E> channelCoroutine = this;
        cancelInternal(new JobCancellationException(channelCoroutine.cancellationExceptionMessage(), null, channelCoroutine));
    }

    @Override
    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Since 1.2.0, binary compatibility with versions <= 1.1.x")
    public final boolean cancel(Throwable cause) {
        ChannelCoroutine<E> channelCoroutine = this;
        cancelInternal(new JobCancellationException(channelCoroutine.cancellationExceptionMessage(), null, channelCoroutine));
        return true;
    }
}
