package kotlinx.coroutines.flow;

import cz.msebera.android.httpclient.HttpStatus;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.flow.internal.SafeCollector;

@Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0002\b\b\b\u0000\u0018\u0000*\u0004\b\u0000\u0010\u00012\b\u0012\u0004\u0012\u0002H\u00010\u0002BD\u0012\f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00028\u00000\u0002\u0012-\u0010\u0004\u001a)\b\u0001\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000\u0002\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00070\u0006\u0012\u0006\u0012\u0004\u0018\u00010\b0\u0005¢\u0006\u0002\b\t¢\u0006\u0004\b\n\u0010\u000bJ\u000e\u0010\r\u001a\u00020\u0007H\u0086@¢\u0006\u0002\u0010\u000eJ\u0011\u0010\u000f\u001a\u00020\u00072\u0006\u0010\u0010\u001a\u00028\u0000H\u0096AR\u0014\u0010\u0003\u001a\b\u0012\u0004\u0012\u00028\u00000\u0002X\u0082\u0004¢\u0006\u0002\n\u0000R7\u0010\u0004\u001a)\b\u0001\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000\u0002\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00070\u0006\u0012\u0006\u0012\u0004\u0018\u00010\b0\u0005¢\u0006\u0002\b\tX\u0082\u0004¢\u0006\u0004\n\u0002\u0010\f¨\u0006\u0011"}, m18d2 = {"Lkotlinx/coroutines/flow/SubscribedFlowCollector;", "T", "Lkotlinx/coroutines/flow/FlowCollector;", "collector", "action", "Lkotlin/Function2;", "Lkotlin/coroutines/Continuation;", "", "", "Lkotlin/ExtensionFunctionType;", "<init>", "(Lkotlinx/coroutines/flow/FlowCollector;Lkotlin/jvm/functions/Function2;)V", "Lkotlin/jvm/functions/Function2;", "onSubscription", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "emit", "value", "kotlinx-coroutines-core"}, m19k = 1, m20mv = {2, 0, 0}, m22xi = 48)
public final class SubscribedFlowCollector<T> implements FlowCollector<T> {
    private final Function2<FlowCollector<? super T>, Continuation<? super Unit>, Object> action;
    private final FlowCollector<T> collector;

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.flow.SubscribedFlowCollector", m37f = "Share.kt", m38i = {0, 0}, m39l = {418, HttpStatus.SC_UNPROCESSABLE_ENTITY}, m40m = "onSubscription", m41n = {"this", "safeCollector"}, m42s = {"L$0", "L$1"})
    static final class C03661 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;
        final SubscribedFlowCollector<T> this$0;

        C03661(SubscribedFlowCollector<T> subscribedFlowCollector, Continuation<? super C03661> continuation) {
            super(continuation);
            this.this$0 = subscribedFlowCollector;
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return this.this$0.onSubscription(this);
        }
    }

    @Override
    public Object emit(T t, Continuation<? super Unit> continuation) {
        return this.collector.emit(t, continuation);
    }

    public SubscribedFlowCollector(FlowCollector<? super T> flowCollector, Function2<? super FlowCollector<? super T>, ? super Continuation<? super Unit>, ? extends Object> function2) {
        this.collector = flowCollector;
        this.action = function2;
    }

    public final Object onSubscription(Continuation<? super Unit> continuation) throws Throwable {
        C03661 c03661;
        SafeCollector safeCollector;
        SubscribedFlowCollector<T> subscribedFlowCollector;
        if (continuation instanceof C03661) {
            c03661 = (C03661) continuation;
            if ((c03661.label & Integer.MIN_VALUE) != 0) {
                c03661.label -= Integer.MIN_VALUE;
            } else {
                c03661 = new C03661(this, continuation);
            }
        } else {
            c03661 = new C03661(this, continuation);
        }
        Object obj = c03661.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        ?? r2 = c03661.label;
        try {
            if (r2 == 0) {
                ResultKt.throwOnFailure(obj);
                safeCollector = new SafeCollector(this.collector, c03661.get$context());
                Function2<FlowCollector<? super T>, Continuation<? super Unit>, Object> function2 = this.action;
                c03661.L$0 = this;
                c03661.L$1 = safeCollector;
                c03661.label = 1;
                if (function2.invoke(safeCollector, c03661) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                subscribedFlowCollector = this;
            } else {
                if (r2 == 1) {
                    safeCollector = (SafeCollector) c03661.L$1;
                    subscribedFlowCollector = (SubscribedFlowCollector) c03661.L$0;
                    ResultKt.throwOnFailure(obj);
                } else {
                    if (r2 != 2) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                }
                return Unit.INSTANCE;
            }
            safeCollector.releaseIntercepted();
            FlowCollector<T> flowCollector = subscribedFlowCollector.collector;
            r2 = flowCollector instanceof SubscribedFlowCollector;
            if (r2 == 0) {
                return Unit.INSTANCE;
            }
            c03661.L$0 = null;
            c03661.L$1 = null;
            c03661.label = 2;
            if (((SubscribedFlowCollector) flowCollector).onSubscription(c03661) == coroutine_suspended) {
                return coroutine_suspended;
            }
            return Unit.INSTANCE;
        } catch (Throwable th) {
            r2.releaseIntercepted();
            throw th;
        }
    }
}
