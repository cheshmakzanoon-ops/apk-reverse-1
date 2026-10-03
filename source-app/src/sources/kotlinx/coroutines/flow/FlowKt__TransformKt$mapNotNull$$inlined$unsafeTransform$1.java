package kotlinx.coroutines.flow;

import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.functions.Function2;
import zendesk.messaging.android.internal.conversationscreen.MessageContainerFactory;

@Metadata(m17d1 = {"\u0000\u0019\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003*\u0001\u0000\b\n\u0018\u00002\b\u0012\u0004\u0012\u00028\u00000\u0001J\u001c\u0010\u0002\u001a\u00020\u00032\f\u0010\u0004\u001a\b\u0012\u0004\u0012\u00028\u00000\u0005H\u0096@¢\u0006\u0002\u0010\u0006¨\u0006\u0007¸\u0006\b"}, m18d2 = {"kotlinx/coroutines/flow/internal/SafeCollector_commonKt$unsafeFlow$1", "Lkotlinx/coroutines/flow/Flow;", "collect", "", "collector", "Lkotlinx/coroutines/flow/FlowCollector;", "(Lkotlinx/coroutines/flow/FlowCollector;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "kotlinx-coroutines-core", "kotlinx/coroutines/flow/FlowKt__EmittersKt$unsafeTransform$$inlined$unsafeFlow$1"}, m19k = 1, m20mv = {2, 0, 0}, m22xi = 176)
public final class FlowKt__TransformKt$mapNotNull$$inlined$unsafeTransform$1<R> implements Flow<R> {
    final Flow $this_unsafeTransform$inlined;
    final Function2 $transform$inlined$1;

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 176)
    public static final class C03432<T> implements FlowCollector {
        final FlowCollector $this_unsafeFlow;
        final Function2 $transform$inlined;

        @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 176)
        @DebugMetadata(m36c = "kotlinx.coroutines.flow.FlowKt__TransformKt$mapNotNull$$inlined$unsafeTransform$1$2", m37f = "Transform.kt", m38i = {0}, m39l = {MessageContainerFactory.MAXIMUM_FILE_SIZE_IN_MB, 51}, m40m = "emit", m41n = {"$this$mapNotNull_u24lambda_u246"}, m42s = {"L$0"})
        public static final class AnonymousClass1 extends ContinuationImpl {
            Object L$0;
            int label;
            Object result;

            public AnonymousClass1(Continuation continuation) {
                super(continuation);
            }

            @Override
            public final Object invokeSuspend(Object obj) {
                this.result = obj;
                this.label |= Integer.MIN_VALUE;
                return C03432.this.emit(null, this);
            }
        }

        public C03432(FlowCollector flowCollector, Function2 function2) {
            this.$this_unsafeFlow = flowCollector;
            this.$transform$inlined = function2;
        }

        @Override
        public final Object emit(T t, Continuation<? super Unit> continuation) throws Throwable {
            AnonymousClass1 anonymousClass1;
            FlowCollector flowCollector;
            FlowCollector flowCollector2;
            if (continuation instanceof AnonymousClass1) {
                anonymousClass1 = (AnonymousClass1) continuation;
                if ((anonymousClass1.label & Integer.MIN_VALUE) != 0) {
                    anonymousClass1.label -= Integer.MIN_VALUE;
                } else {
                    anonymousClass1 = new AnonymousClass1(continuation);
                }
            } else {
                anonymousClass1 = new AnonymousClass1(continuation);
            }
            Object obj = anonymousClass1.result;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = anonymousClass1.label;
            if (i != 0) {
                if (i == 1) {
                    flowCollector2 = (FlowCollector) anonymousClass1.L$0;
                    ResultKt.throwOnFailure(obj);
                } else {
                    if (i != 2) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                }
                flowCollector = flowCollector2;
                flowCollector = flowCollector2;
                return Unit.INSTANCE;
            }
            ResultKt.throwOnFailure(obj);
            FlowCollector flowCollector3 = this.$this_unsafeFlow;
            Function2 function2 = this.$transform$inlined;
            anonymousClass1.L$0 = flowCollector3;
            anonymousClass1.label = 1;
            Object objInvoke = function2.invoke(t, anonymousClass1);
            if (objInvoke == coroutine_suspended) {
                return coroutine_suspended;
            }
            obj = objInvoke;
            flowCollector = flowCollector3;
            if (obj != null) {
                anonymousClass1.L$0 = null;
                anonymousClass1.label = 2;
                if (flowCollector.emit(obj, anonymousClass1) == coroutine_suspended) {
                    flowCollector = flowCollector2;
                    return coroutine_suspended;
                }
            }
            flowCollector = flowCollector2;
            flowCollector = flowCollector2;
            return Unit.INSTANCE;
        }

        public final Object emit$$forInline(Object obj, Continuation continuation) {
            new AnonymousClass1(continuation);
            FlowCollector flowCollector = this.$this_unsafeFlow;
            Object objInvoke = this.$transform$inlined.invoke(obj, continuation);
            if (objInvoke != null) {
                flowCollector.emit(objInvoke, continuation);
            }
            return Unit.INSTANCE;
        }
    }

    public FlowKt__TransformKt$mapNotNull$$inlined$unsafeTransform$1(Flow flow, Function2 function2) {
        this.$this_unsafeTransform$inlined = flow;
        this.$transform$inlined$1 = function2;
    }

    @Override
    public Object collect(FlowCollector flowCollector, Continuation continuation) {
        Object objCollect = this.$this_unsafeTransform$inlined.collect(new C03432(flowCollector, this.$transform$inlined$1), continuation);
        return objCollect == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objCollect : Unit.INSTANCE;
    }

    public Object collect$$forInline(FlowCollector flowCollector, Continuation continuation) {
        new ContinuationImpl(continuation) {
            int label;
            Object result;

            @Override
            public final Object invokeSuspend(Object obj) {
                this.result = obj;
                this.label |= Integer.MIN_VALUE;
                return FlowKt__TransformKt$mapNotNull$$inlined$unsafeTransform$1.this.collect(null, this);
            }
        };
        this.$this_unsafeTransform$inlined.collect(new C03432(flowCollector, this.$transform$inlined$1), continuation);
        return Unit.INSTANCE;
    }
}
