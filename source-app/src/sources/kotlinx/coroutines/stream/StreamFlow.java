package kotlinx.coroutines.stream;

import j$.util.stream.Stream;
import java.util.Iterator;
import java.util.concurrent.atomic.AtomicIntegerFieldUpdater;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlinx.coroutines.flow.Flow;
import kotlinx.coroutines.flow.FlowCollector;

@Metadata(m17d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0002\u0018\u0000*\u0004\b\u0000\u0010\u00012\b\u0012\u0004\u0012\u00028\u00000\u0002B\u0015\u0012\f\u0010\u0004\u001a\b\u0012\u0004\u0012\u00028\u00000\u0003¢\u0006\u0004\b\u0005\u0010\u0006J\u001e\u0010\n\u001a\u00020\t2\f\u0010\b\u001a\b\u0012\u0004\u0012\u00028\u00000\u0007H\u0096@¢\u0006\u0004\b\n\u0010\u000bR\u001a\u0010\u0004\u001a\b\u0012\u0004\u0012\u00028\u00000\u00038\u0002X\u0082\u0004¢\u0006\u0006\n\u0004\b\u0004\u0010\fR\u000b\u0010\u000e\u001a\u00020\r8\u0002X\u0082\u0004¨\u0006\u000f"}, m18d2 = {"Lkotlinx/coroutines/stream/StreamFlow;", "T", "Lkotlinx/coroutines/flow/Flow;", "j$/util/stream/Stream", "stream", "<init>", "(Lj$/util/stream/Stream;)V", "Lkotlinx/coroutines/flow/FlowCollector;", "collector", "", "collect", "(Lkotlinx/coroutines/flow/FlowCollector;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "Lj$/util/stream/Stream;", "Lkotlinx/atomicfu/AtomicBoolean;", "consumed", "kotlinx-coroutines-core"}, m19k = 1, m20mv = {2, 0, 0}, m22xi = 48)
final class StreamFlow<T> implements Flow<T> {
    private static final AtomicIntegerFieldUpdater consumed$volatile$FU = AtomicIntegerFieldUpdater.newUpdater(StreamFlow.class, "consumed$volatile");
    private volatile int consumed$volatile = 0;
    private final Stream<T> stream;

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.stream.StreamFlow", m37f = "Stream.kt", m38i = {0, 0}, m39l = {22}, m40m = "collect", m41n = {"this", "collector"}, m42s = {"L$0", "L$1"})
    static final class C03841 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;
        final StreamFlow<T> this$0;

        C03841(StreamFlow<T> streamFlow, Continuation<? super C03841> continuation) {
            super(continuation);
            this.this$0 = streamFlow;
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return this.this$0.collect(null, this);
        }
    }

    private final int getConsumed$volatile() {
        return this.consumed$volatile;
    }

    private final void setConsumed$volatile(int i) {
        this.consumed$volatile = i;
    }

    public StreamFlow(Stream<T> stream) {
        this.stream = stream;
    }

    @Override
    public Object collect(FlowCollector<? super T> flowCollector, Continuation<? super Unit> continuation) throws Throwable {
        C03841 c03841;
        StreamFlow<T> streamFlow;
        FlowCollector flowCollector2;
        Iterator it;
        if (continuation instanceof C03841) {
            c03841 = (C03841) continuation;
            if ((c03841.label & Integer.MIN_VALUE) != 0) {
                c03841.label -= Integer.MIN_VALUE;
            } else {
                c03841 = new C03841(this, continuation);
            }
        } else {
            c03841 = new C03841(this, continuation);
        }
        Object obj = c03841.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c03841.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            if (!consumed$volatile$FU.compareAndSet(this, 0, 1)) {
                throw new IllegalStateException("Stream.consumeAsFlow can be collected only once".toString());
            }
            try {
                streamFlow = this;
                flowCollector2 = flowCollector;
                it = this.stream.iterator();
            } catch (Throwable th) {
                th = th;
                streamFlow = this;
                streamFlow.stream.close();
                throw th;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            it = (Iterator) c03841.L$2;
            FlowCollector flowCollector3 = (FlowCollector) c03841.L$1;
            streamFlow = (StreamFlow) c03841.L$0;
            try {
                ResultKt.throwOnFailure(obj);
                flowCollector2 = flowCollector3;
            } catch (Throwable th2) {
                th = th2;
                streamFlow.stream.close();
                throw th;
            }
        }
        while (it.hasNext()) {
            Object next = it.next();
            c03841.L$0 = streamFlow;
            c03841.L$1 = flowCollector2;
            c03841.L$2 = it;
            c03841.label = 1;
            if (flowCollector2.emit(next, c03841) == coroutine_suspended) {
                return coroutine_suspended;
            }
        }
        streamFlow.stream.close();
        return Unit.INSTANCE;
    }
}
