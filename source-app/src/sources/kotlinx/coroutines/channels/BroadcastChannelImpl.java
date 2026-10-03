package kotlinx.coroutines.channels;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.locks.ReentrantLock;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.BuildersKt__Builders_commonKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.CoroutineScopeKt;
import kotlinx.coroutines.CoroutineStart;
import kotlinx.coroutines.DebugKt;
import kotlinx.coroutines.selects.SelectImplementation;
import kotlinx.coroutines.selects.SelectInstance;
import kotlinx.coroutines.selects.TrySelectDetailedResult;

@Metadata(m17d1 = {"\u0000h\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010 \n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0003\n\u0002\b\r\n\u0002\u0010\u000e\n\u0002\b\u0003\b\u0000\u0018\u0000*\u0004\b\u0000\u0010\u00012\b\u0012\u0004\u0012\u0002H\u00010\u00022\b\u0012\u0004\u0012\u0002H\u00010\u0003:\u000256B\u000f\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0004\b\u0006\u0010\u0007J\u000e\u0010\u0012\u001a\b\u0012\u0004\u0012\u00028\u00000\u0013H\u0016J\u0016\u0010\u0014\u001a\u00020\u00152\f\u0010\u0016\u001a\b\u0012\u0004\u0012\u00028\u00000\u0013H\u0002J\u0016\u0010\u0017\u001a\u00020\u00152\u0006\u0010\u0018\u001a\u00028\u0000H\u0096@¢\u0006\u0002\u0010\u0019J\u001d\u0010\u001a\u001a\b\u0012\u0004\u0012\u00020\u00150\u001b2\u0006\u0010\u0018\u001a\u00028\u0000H\u0016¢\u0006\u0004\b\u001c\u0010\u001dJ\u001e\u0010\u001e\u001a\u00020\u00152\n\u0010\u001f\u001a\u0006\u0012\u0002\b\u00030 2\b\u0010\u0018\u001a\u0004\u0018\u00010\u0011H\u0014J\u0012\u0010#\u001a\u00020$2\b\u0010%\u001a\u0004\u0018\u00010&H\u0016J\u0017\u0010'\u001a\u00020$2\b\u0010%\u001a\u0004\u0018\u00010&H\u0010¢\u0006\u0002\b(J\b\u00103\u001a\u000204H\u0016R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\tR\u0014\u0010\n\u001a\u00060\fj\u0002`\u000bX\u0082\u0004¢\u0006\u0004\n\u0002\u0010\rR\u001a\u0010\u000e\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000\u00020\u000fX\u0082\u000e¢\u0006\u0002\n\u0000R\u0010\u0010\u0010\u001a\u0004\u0018\u00010\u0011X\u0082\u000e¢\u0006\u0002\n\u0000R \u0010!\u001a\u0014\u0012\b\u0012\u0006\u0012\u0002\b\u00030 \u0012\u0006\u0012\u0004\u0018\u00010\u00110\"X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010)\u001a\u00020$8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b)\u0010*R\u0017\u0010+\u001a\u00028\u00008F¢\u0006\f\u0012\u0004\b,\u0010-\u001a\u0004\b.\u0010/R\u0019\u00100\u001a\u0004\u0018\u00018\u00008F¢\u0006\f\u0012\u0004\b1\u0010-\u001a\u0004\b2\u0010/¨\u00067"}, m18d2 = {"Lkotlinx/coroutines/channels/BroadcastChannelImpl;", "E", "Lkotlinx/coroutines/channels/BufferedChannel;", "Lkotlinx/coroutines/channels/BroadcastChannel;", "capacity", "", "<init>", "(I)V", "getCapacity", "()I", "lock", "Lkotlinx/coroutines/internal/ReentrantLock;", "Ljava/util/concurrent/locks/ReentrantLock;", "Ljava/util/concurrent/locks/ReentrantLock;", "subscribers", "", "lastConflatedElement", "", "openSubscription", "Lkotlinx/coroutines/channels/ReceiveChannel;", "removeSubscriber", "", "s", "send", "element", "(Ljava/lang/Object;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "trySend", "Lkotlinx/coroutines/channels/ChannelResult;", "trySend-JP2dKIU", "(Ljava/lang/Object;)Ljava/lang/Object;", "registerSelectForSend", "select", "Lkotlinx/coroutines/selects/SelectInstance;", "onSendInternalResult", "Ljava/util/HashMap;", "close", "", "cause", "", "cancelImpl", "cancelImpl$kotlinx_coroutines_core", "isClosedForSend", "()Z", "value", "getValue$annotations", "()V", "getValue", "()Ljava/lang/Object;", "valueOrNull", "getValueOrNull$annotations", "getValueOrNull", "toString", "", "SubscriberBuffered", "SubscriberConflated", "kotlinx-coroutines-core"}, m19k = 1, m20mv = {2, 0, 0}, m22xi = 48)
public final class BroadcastChannelImpl<E> extends BufferedChannel<E> implements BroadcastChannel<E> {
    private final int capacity;
    private Object lastConflatedElement;
    private final ReentrantLock lock;
    private final HashMap<SelectInstance<?>, Object> onSendInternalResult;
    private List<? extends BufferedChannel<E>> subscribers;

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.BroadcastChannelImpl", m37f = "BroadcastChannel.kt", m38i = {0, 0}, m39l = {179}, m40m = "send", m41n = {"this", "element"}, m42s = {"L$0", "L$1"})
    static final class C02021 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;
        final BroadcastChannelImpl<E> this$0;

        C02021(BroadcastChannelImpl<E> broadcastChannelImpl, Continuation<? super C02021> continuation) {
            super(continuation);
            this.this$0 = broadcastChannelImpl;
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return this.this$0.send(null, this);
        }
    }

    public static void getValue$annotations() {
    }

    public static void getValueOrNull$annotations() {
    }

    public final int getCapacity() {
        return this.capacity;
    }

    public BroadcastChannelImpl(int i) {
        super(0, null);
        this.capacity = i;
        if (i < 1 && i != -1) {
            throw new IllegalArgumentException(("BroadcastChannel capacity must be positive or Channel.CONFLATED, but " + i + " was specified").toString());
        }
        this.lock = new ReentrantLock();
        this.subscribers = CollectionsKt.emptyList();
        this.lastConflatedElement = BroadcastChannelKt.NO_ELEMENT;
        this.onSendInternalResult = new HashMap<>();
    }

    @Override
    public ReceiveChannel<E> openSubscription() {
        ReentrantLock reentrantLock = this.lock;
        reentrantLock.lock();
        try {
            BufferedChannel subscriberConflated = this.capacity == -1 ? new SubscriberConflated() : new SubscriberBuffered();
            if (!isClosedForSend() || this.lastConflatedElement != BroadcastChannelKt.NO_ELEMENT) {
                if (this.lastConflatedElement != BroadcastChannelKt.NO_ELEMENT) {
                    subscriberConflated.mo1809trySendJP2dKIU(getValue());
                }
                this.subscribers = CollectionsKt.plus((Collection<? extends BufferedChannel>) this.subscribers, subscriberConflated);
                return subscriberConflated;
            }
            subscriberConflated.close(getCloseCause());
            return subscriberConflated;
        } finally {
            reentrantLock.unlock();
        }
    }

    public final void removeSubscriber(ReceiveChannel<? extends E> s) {
        ReentrantLock reentrantLock = this.lock;
        reentrantLock.lock();
        try {
            List<? extends BufferedChannel<E>> list = this.subscribers;
            ArrayList arrayList = new ArrayList();
            Iterator<T> it = list.iterator();
            while (it.hasNext()) {
                BufferedChannel bufferedChannel = (Object) it.next();
                if (bufferedChannel != s) {
                    arrayList.add(bufferedChannel);
                }
            }
            this.subscribers = arrayList;
            Unit unit = Unit.INSTANCE;
        } finally {
            reentrantLock.unlock();
        }
    }

    @Override
    public java.lang.Object send(E r7, kotlin.coroutines.Continuation<? super kotlin.Unit> r8) {
        throw new UnsupportedOperationException("Method not decompiled: kotlinx.coroutines.channels.BroadcastChannelImpl.send(java.lang.Object, kotlin.coroutines.Continuation):java.lang.Object");
    }

    @Override
    public Object mo1809trySendJP2dKIU(E element) {
        ReentrantLock reentrantLock = this.lock;
        reentrantLock.lock();
        try {
            if (isClosedForSend()) {
                Object objMo1809trySendJP2dKIU = super.mo1809trySendJP2dKIU(element);
                reentrantLock.unlock();
                return objMo1809trySendJP2dKIU;
            }
            List<? extends BufferedChannel<E>> list = this.subscribers;
            if (!(list instanceof Collection) || !list.isEmpty()) {
                Iterator<T> it = list.iterator();
                while (it.hasNext()) {
                    if (((BufferedChannel) it.next()).shouldSendSuspend$kotlinx_coroutines_core()) {
                        Object objM1838failurePtdJZtk = ChannelResult.INSTANCE.m1838failurePtdJZtk();
                        reentrantLock.unlock();
                        return objM1838failurePtdJZtk;
                    }
                }
            }
            if (this.capacity == -1) {
                this.lastConflatedElement = element;
            }
            Iterator<T> it2 = this.subscribers.iterator();
            while (it2.hasNext()) {
                ((BufferedChannel) it2.next()).mo1809trySendJP2dKIU(element);
            }
            Object objM1839successJP2dKIU = ChannelResult.INSTANCE.m1839successJP2dKIU(Unit.INSTANCE);
            reentrantLock.unlock();
            return objM1839successJP2dKIU;
        } catch (Throwable th) {
            reentrantLock.unlock();
            throw th;
        }
    }

    @Override
    protected void registerSelectForSend(SelectInstance<?> select, Object element) {
        ReentrantLock reentrantLock = this.lock;
        reentrantLock.lock();
        try {
            Object objRemove = this.onSendInternalResult.remove(select);
            if (objRemove != null) {
                select.selectInRegistrationPhase(objRemove);
                reentrantLock.unlock();
            } else {
                Unit unit = Unit.INSTANCE;
                reentrantLock.unlock();
                BuildersKt__Builders_commonKt.launch$default(CoroutineScopeKt.CoroutineScope(select.getContext()), null, CoroutineStart.UNDISPATCHED, new C02012(this, element, select, null), 1, null);
            }
        } catch (Throwable th) {
            reentrantLock.unlock();
            throw th;
        }
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\n"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.BroadcastChannelImpl$registerSelectForSend$2", m37f = "BroadcastChannel.kt", m38i = {}, m39l = {240}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C02012 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final Object $element;
        final SelectInstance<?> $select;
        int label;
        final BroadcastChannelImpl<E> this$0;

        C02012(BroadcastChannelImpl<E> broadcastChannelImpl, Object obj, SelectInstance<?> selectInstance, Continuation<? super C02012> continuation) {
            super(2, continuation);
            this.this$0 = broadcastChannelImpl;
            this.$element = obj;
            this.$select = selectInstance;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return new C02012(this.this$0, this.$element, this.$select, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C02012) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            boolean z = true;
            try {
                if (i == 0) {
                    ResultKt.throwOnFailure(obj);
                    BroadcastChannelImpl<E> broadcastChannelImpl = this.this$0;
                    Object obj2 = this.$element;
                    this.label = 1;
                    if (broadcastChannelImpl.send((E) obj2, this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } else {
                    if (i != 1) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                }
            } catch (Throwable th) {
                if (!this.this$0.isClosedForSend() || (!(th instanceof ClosedSendChannelException) && this.this$0.getSendException() != th)) {
                    throw th;
                }
                z = false;
            }
            ReentrantLock reentrantLock = ((BroadcastChannelImpl) this.this$0).lock;
            BroadcastChannelImpl<E> broadcastChannelImpl2 = this.this$0;
            SelectInstance<?> selectInstance = this.$select;
            ReentrantLock reentrantLock2 = reentrantLock;
            reentrantLock2.lock();
            try {
                if (DebugKt.getASSERTIONS_ENABLED() && ((BroadcastChannelImpl) broadcastChannelImpl2).onSendInternalResult.get(selectInstance) != null) {
                    throw new AssertionError();
                }
                ((BroadcastChannelImpl) broadcastChannelImpl2).onSendInternalResult.put(selectInstance, z ? Unit.INSTANCE : BufferedChannelKt.getCHANNEL_CLOSED());
                Intrinsics.checkNotNull(selectInstance, "null cannot be cast to non-null type kotlinx.coroutines.selects.SelectImplementation<*>");
                if (((SelectImplementation) selectInstance).trySelectDetailed(broadcastChannelImpl2, Unit.INSTANCE) != TrySelectDetailedResult.REREGISTER) {
                    ((BroadcastChannelImpl) broadcastChannelImpl2).onSendInternalResult.remove(selectInstance);
                }
                Unit unit = Unit.INSTANCE;
                reentrantLock2.unlock();
                return Unit.INSTANCE;
            } catch (Throwable th2) {
                reentrantLock2.unlock();
                throw th2;
            }
        }
    }

    @Override
    public boolean close(Throwable cause) {
        ReentrantLock reentrantLock = this.lock;
        reentrantLock.lock();
        try {
            Iterator<T> it = this.subscribers.iterator();
            while (it.hasNext()) {
                ((BufferedChannel) it.next()).close(cause);
            }
            List<? extends BufferedChannel<E>> list = this.subscribers;
            ArrayList arrayList = new ArrayList();
            Iterator<T> it2 = list.iterator();
            while (it2.hasNext()) {
                BufferedChannel bufferedChannel = (Object) it2.next();
                if (bufferedChannel.hasElements$kotlinx_coroutines_core()) {
                    arrayList.add(bufferedChannel);
                }
            }
            this.subscribers = arrayList;
            return super.close(cause);
        } finally {
            reentrantLock.unlock();
        }
    }

    @Override
    public boolean cancelImpl$kotlinx_coroutines_core(Throwable cause) {
        ReentrantLock reentrantLock = this.lock;
        reentrantLock.lock();
        try {
            Iterator<T> it = this.subscribers.iterator();
            while (it.hasNext()) {
                ((BufferedChannel) it.next()).cancelImpl$kotlinx_coroutines_core(cause);
            }
            this.lastConflatedElement = BroadcastChannelKt.NO_ELEMENT;
            return super.cancelImpl$kotlinx_coroutines_core(cause);
        } finally {
            reentrantLock.unlock();
        }
    }

    @Override
    public boolean isClosedForSend() {
        ReentrantLock reentrantLock = this.lock;
        reentrantLock.lock();
        try {
            return super.isClosedForSend();
        } finally {
            reentrantLock.unlock();
        }
    }

    @Metadata(m17d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0003\n\u0000\b\u0082\u0004\u0018\u00002\b\u0012\u0004\u0012\u00028\u00000\u0001B\u0007¢\u0006\u0004\b\u0002\u0010\u0003J\u0012\u0010\u0004\u001a\u00020\u00052\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007H\u0016¨\u0006\b"}, m18d2 = {"Lkotlinx/coroutines/channels/BroadcastChannelImpl$SubscriberBuffered;", "Lkotlinx/coroutines/channels/BufferedChannel;", "<init>", "(Lkotlinx/coroutines/channels/BroadcastChannelImpl;)V", "cancelImpl", "", "cause", "", "kotlinx-coroutines-core"}, m19k = 1, m20mv = {2, 0, 0}, m22xi = 48)
    private final class SubscriberBuffered extends BufferedChannel<E> {
        public SubscriberBuffered() {
            super(BroadcastChannelImpl.this.getCapacity(), null, 2, 0 == true ? 1 : 0);
        }

        @Override
        public boolean cancelImpl$kotlinx_coroutines_core(Throwable cause) {
            ReentrantLock reentrantLock = ((BroadcastChannelImpl) BroadcastChannelImpl.this).lock;
            BroadcastChannelImpl<E> broadcastChannelImpl = BroadcastChannelImpl.this;
            ReentrantLock reentrantLock2 = reentrantLock;
            reentrantLock2.lock();
            try {
                broadcastChannelImpl.removeSubscriber(this);
                return super.cancelImpl$kotlinx_coroutines_core(cause);
            } finally {
                reentrantLock2.unlock();
            }
        }
    }

    @Metadata(m17d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0003\n\u0000\b\u0082\u0004\u0018\u00002\b\u0012\u0004\u0012\u00028\u00000\u0001B\u0007¢\u0006\u0004\b\u0002\u0010\u0003J\u0012\u0010\u0004\u001a\u00020\u00052\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007H\u0016¨\u0006\b"}, m18d2 = {"Lkotlinx/coroutines/channels/BroadcastChannelImpl$SubscriberConflated;", "Lkotlinx/coroutines/channels/ConflatedBufferedChannel;", "<init>", "(Lkotlinx/coroutines/channels/BroadcastChannelImpl;)V", "cancelImpl", "", "cause", "", "kotlinx-coroutines-core"}, m19k = 1, m20mv = {2, 0, 0}, m22xi = 48)
    private final class SubscriberConflated extends ConflatedBufferedChannel<E> {
        public SubscriberConflated() {
            super(1, BufferOverflow.DROP_OLDEST, null, 4, null);
        }

        @Override
        public boolean cancelImpl$kotlinx_coroutines_core(Throwable cause) {
            BroadcastChannelImpl.this.removeSubscriber(this);
            return super.cancelImpl$kotlinx_coroutines_core(cause);
        }
    }

    public final E getValue() throws Throwable {
        ReentrantLock reentrantLock = this.lock;
        reentrantLock.lock();
        try {
            if (!isClosedForSend()) {
                if (this.lastConflatedElement == BroadcastChannelKt.NO_ELEMENT) {
                    throw new IllegalStateException("No value".toString());
                }
                E e = (E) this.lastConflatedElement;
                reentrantLock.unlock();
                return e;
            }
            Throwable closeCause = getCloseCause();
            if (closeCause == null) {
                throw new IllegalStateException("This broadcast channel is closed");
            }
            throw closeCause;
        } catch (Throwable th) {
            reentrantLock.unlock();
            throw th;
        }
    }

    public final E getValueOrNull() {
        ReentrantLock reentrantLock = this.lock;
        reentrantLock.lock();
        try {
            E e = null;
            if (!isClosedForReceive() && this.lastConflatedElement != BroadcastChannelKt.NO_ELEMENT) {
                e = (E) this.lastConflatedElement;
            }
            return e;
        } finally {
            reentrantLock.unlock();
        }
    }

    @Override
    public String toString() {
        String str;
        StringBuilder sb = new StringBuilder();
        if (this.lastConflatedElement != BroadcastChannelKt.NO_ELEMENT) {
            str = "CONFLATED_ELEMENT=" + this.lastConflatedElement + "; ";
        } else {
            str = "";
        }
        sb.append(str);
        sb.append("BROADCAST=<");
        sb.append(super.toString());
        sb.append(">; SUBSCRIBERS=");
        sb.append(CollectionsKt.joinToString$default(this.subscribers, ";", "<", ">", 0, null, null, 56, null));
        return sb.toString();
    }
}
