package kotlinx.coroutines.flow;

import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.Boxing;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Ref;

@Metadata(m17d1 = {"\u0000$\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u000b\n\u0002\u0010\u0000\n\u0002\b\u0002\u001a\u001e\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u0003H\u0086@¢\u0006\u0002\u0010\u0004\u001aB\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u00032\"\u0010\u0005\u001a\u001e\b\u0001\u0012\u0004\u0012\u0002H\u0002\u0012\n\u0012\b\u0012\u0004\u0012\u00020\b0\u0007\u0012\u0006\u0012\u0004\u0018\u00010\t0\u0006H\u0086@¢\u0006\u0002\u0010\n¨\u0006\u000b"}, m18d2 = {"count", "", "T", "Lkotlinx/coroutines/flow/Flow;", "(Lkotlinx/coroutines/flow/Flow;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "predicate", "Lkotlin/Function2;", "Lkotlin/coroutines/Continuation;", "", "", "(Lkotlinx/coroutines/flow/Flow;Lkotlin/jvm/functions/Function2;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "kotlinx-coroutines-core"}, m19k = 5, m20mv = {2, 0, 0}, m22xi = 48, m23xs = "kotlinx/coroutines/flow/FlowKt")
final class FlowKt__CountKt {

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.flow.FlowKt__CountKt", m37f = "Count.kt", m38i = {0}, m39l = {13}, m40m = "count", m41n = {"i"}, m42s = {"L$0"})
    static final class C02791<T> extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C02791(Continuation<? super C02791> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return FlowKt.count(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.flow.FlowKt__CountKt", m37f = "Count.kt", m38i = {0}, m39l = {25}, m40m = "count", m41n = {"i"}, m42s = {"L$0"})
    static final class C02813<T> extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C02813(Continuation<? super C02813> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return FlowKt.count(null, null, this);
        }
    }

    public static final <T> Object count(Flow<? extends T> flow, Continuation<? super Integer> continuation) throws Throwable {
        C02791 c02791;
        Ref.IntRef intRef;
        if (continuation instanceof C02791) {
            c02791 = (C02791) continuation;
            if ((c02791.label & Integer.MIN_VALUE) != 0) {
                c02791.label -= Integer.MIN_VALUE;
            } else {
                c02791 = new C02791(continuation);
            }
        } else {
            c02791 = new C02791(continuation);
        }
        Object obj = c02791.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c02791.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            final Ref.IntRef intRef2 = new Ref.IntRef();
            FlowCollector<? super Object> flowCollector = new FlowCollector() {
                @Override
                public final Object emit(T t, Continuation<? super Unit> continuation2) {
                    intRef2.element++;
                    int i2 = intRef2.element;
                    return Unit.INSTANCE;
                }
            };
            c02791.L$0 = intRef2;
            c02791.label = 1;
            if (flow.collect(flowCollector, c02791) == coroutine_suspended) {
                return coroutine_suspended;
            }
            intRef = intRef2;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            intRef = (Ref.IntRef) c02791.L$0;
            ResultKt.throwOnFailure(obj);
        }
        return Boxing.boxInt(intRef.element);
    }

    public static final <T> Object count(Flow<? extends T> flow, Function2<? super T, ? super Continuation<? super Boolean>, ? extends Object> function2, Continuation<? super Integer> continuation) throws Throwable {
        C02813 c02813;
        Ref.IntRef intRef;
        if (continuation instanceof C02813) {
            c02813 = (C02813) continuation;
            if ((c02813.label & Integer.MIN_VALUE) != 0) {
                c02813.label -= Integer.MIN_VALUE;
            } else {
                c02813 = new C02813(continuation);
            }
        } else {
            c02813 = new C02813(continuation);
        }
        Object obj = c02813.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c02813.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            Ref.IntRef intRef2 = new Ref.IntRef();
            FlowCollector<? super Object> c02824 = new C02824<>(function2, intRef2);
            c02813.L$0 = intRef2;
            c02813.label = 1;
            if (flow.collect(c02824, c02813) == coroutine_suspended) {
                return coroutine_suspended;
            }
            intRef = intRef2;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            intRef = (Ref.IntRef) c02813.L$0;
            ResultKt.throwOnFailure(obj);
        }
        return Boxing.boxInt(intRef.element);
    }

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    static final class C02824<T> implements FlowCollector {

        final Ref.IntRef f47$i;
        final Function2<T, Continuation<? super Boolean>, Object> $predicate;

        C02824(Function2<? super T, ? super Continuation<? super Boolean>, ? extends Object> function2, Ref.IntRef intRef) {
            this.$predicate = function2;
            this.f47$i = intRef;
        }

        @Override
        public final Object emit(T t, Continuation<? super Unit> continuation) throws Throwable {
            FlowKt__CountKt$count$4$emit$1 flowKt__CountKt$count$4$emit$1;
            C02824<T> c02824;
            if (continuation instanceof FlowKt__CountKt$count$4$emit$1) {
                flowKt__CountKt$count$4$emit$1 = (FlowKt__CountKt$count$4$emit$1) continuation;
                if ((flowKt__CountKt$count$4$emit$1.label & Integer.MIN_VALUE) != 0) {
                    flowKt__CountKt$count$4$emit$1.label -= Integer.MIN_VALUE;
                } else {
                    flowKt__CountKt$count$4$emit$1 = new FlowKt__CountKt$count$4$emit$1(this, continuation);
                }
            } else {
                flowKt__CountKt$count$4$emit$1 = new FlowKt__CountKt$count$4$emit$1(this, continuation);
            }
            Object objInvoke = flowKt__CountKt$count$4$emit$1.result;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = flowKt__CountKt$count$4$emit$1.label;
            if (i == 0) {
                ResultKt.throwOnFailure(objInvoke);
                Function2<T, Continuation<? super Boolean>, Object> function2 = this.$predicate;
                flowKt__CountKt$count$4$emit$1.L$0 = this;
                flowKt__CountKt$count$4$emit$1.label = 1;
                objInvoke = function2.invoke(t, flowKt__CountKt$count$4$emit$1);
                if (objInvoke == coroutine_suspended) {
                    return coroutine_suspended;
                }
                c02824 = this;
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                c02824 = (C02824) flowKt__CountKt$count$4$emit$1.L$0;
                ResultKt.throwOnFailure(objInvoke);
            }
            if (((Boolean) objInvoke).booleanValue()) {
                c02824.f47$i.element++;
                int i2 = c02824.f47$i.element;
            }
            return Unit.INSTANCE;
        }
    }
}
