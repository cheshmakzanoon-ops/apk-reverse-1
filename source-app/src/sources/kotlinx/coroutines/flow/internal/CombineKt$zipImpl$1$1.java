package kotlinx.coroutines.flow.internal;

import java.util.concurrent.CancellationException;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.CompletableJob;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.Job;
import kotlinx.coroutines.JobKt__JobKt;
import kotlinx.coroutines.channels.ChannelResult;
import kotlinx.coroutines.channels.ProduceKt;
import kotlinx.coroutines.channels.ReceiveChannel;
import kotlinx.coroutines.channels.SendChannel;
import kotlinx.coroutines.flow.Flow;
import kotlinx.coroutines.flow.FlowCollector;
import kotlinx.coroutines.internal.ThreadContextKt;
import okhttp3.internal.p011ws.WebSocketProtocol;

@Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\n"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
@DebugMetadata(m36c = "kotlinx.coroutines.flow.internal.CombineKt$zipImpl$1$1", m37f = "Combine.kt", m38i = {0, 0}, m39l = {123}, m40m = "invokeSuspend", m41n = {"second", "collectJob"}, m42s = {"L$0", "L$1"})
final class CombineKt$zipImpl$1$1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
    final Flow<T1> $flow;
    final Flow<T2> $flow2;
    final FlowCollector<R> $this_unsafeFlow;
    final Function3<T1, T2, Continuation<? super R>, Object> $transform;
    private Object L$0;
    Object L$1;
    int label;

    CombineKt$zipImpl$1$1(Flow<? extends T2> flow, Flow<? extends T1> flow2, FlowCollector<? super R> flowCollector, Function3<? super T1, ? super T2, ? super Continuation<? super R>, ? extends Object> function3, Continuation<? super CombineKt$zipImpl$1$1> continuation) {
        super(2, continuation);
        this.$flow2 = flow;
        this.$flow = flow2;
        this.$this_unsafeFlow = flowCollector;
        this.$transform = function3;
    }

    @Override
    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        CombineKt$zipImpl$1$1 combineKt$zipImpl$1$1 = new CombineKt$zipImpl$1$1(this.$flow2, this.$flow, this.$this_unsafeFlow, this.$transform, continuation);
        combineKt$zipImpl$1$1.L$0 = obj;
        return combineKt$zipImpl$1$1;
    }

    @Override
    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
        return ((CombineKt$zipImpl$1$1) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
    }

    @Override
    public final Object invokeSuspend(Object obj) throws Throwable {
        ReceiveChannel receiveChannelProduce$default;
        CompletableJob completableJob;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                CoroutineScope coroutineScope = (CoroutineScope) this.L$0;
                receiveChannelProduce$default = ProduceKt.produce$default(coroutineScope, null, 0, new CombineKt$zipImpl$1$1$second$1(this.$flow2, null), 3, null);
                final CompletableJob completableJobJob$default = JobKt__JobKt.Job$default((Job) null, 1, (Object) null);
                Intrinsics.checkNotNull(receiveChannelProduce$default, "null cannot be cast to non-null type kotlinx.coroutines.channels.SendChannel<*>");
                ((SendChannel) receiveChannelProduce$default).invokeOnClose(new Function1<Throwable, Unit>() {
                    @Override
                    public Unit invoke(Throwable th) {
                        invoke2(th);
                        return Unit.INSTANCE;
                    }

                    public final void invoke2(Throwable th) {
                        if (completableJobJob$default.isActive()) {
                            completableJobJob$default.cancel((CancellationException) new AbortFlowException(completableJobJob$default));
                        }
                    }
                });
                try {
                    CoroutineContext coroutineContext = coroutineScope.getCoroutineContext();
                    Object objThreadContextElements = ThreadContextKt.threadContextElements(coroutineContext);
                    this.L$0 = receiveChannelProduce$default;
                    this.L$1 = completableJobJob$default;
                    this.label = 1;
                    if (ChannelFlowKt.withContextUndispatched$default(coroutineScope.getCoroutineContext().plus(completableJobJob$default), Unit.INSTANCE, null, new C03742(this.$flow, coroutineContext, objThreadContextElements, receiveChannelProduce$default, this.$this_unsafeFlow, this.$transform, completableJobJob$default, null), this, 4, null) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } catch (AbortFlowException e) {
                    e = e;
                    completableJob = completableJobJob$default;
                    FlowExceptions_commonKt.checkOwnership(e, completableJob);
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                completableJob = (CompletableJob) this.L$1;
                receiveChannelProduce$default = (ReceiveChannel) this.L$0;
                try {
                    ResultKt.throwOnFailure(obj);
                } catch (AbortFlowException e2) {
                    e = e2;
                    FlowExceptions_commonKt.checkOwnership(e, completableJob);
                }
            }
            ReceiveChannel.DefaultImpls.cancel$default(receiveChannelProduce$default, (CancellationException) null, 1, (Object) null);
            return Unit.INSTANCE;
        } catch (Throwable th) {
            ReceiveChannel.DefaultImpls.cancel$default(receiveChannelProduce$default, (CancellationException) null, 1, (Object) null);
            throw th;
        }
    }

    @Metadata(m17d1 = {"\u0000\b\n\u0000\n\u0002\u0010\u0002\n\u0000\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u0001H\n"}, m18d2 = {"<anonymous>", "", "it"}, m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.flow.internal.CombineKt$zipImpl$1$1$2", m37f = "Combine.kt", m38i = {}, m39l = {124}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C03742 extends SuspendLambda implements Function2<Unit, Continuation<? super Unit>, Object> {
        final Object $cnt;
        final CompletableJob $collectJob;
        final Flow<T1> $flow;
        final CoroutineContext $scopeContext;
        final ReceiveChannel<Object> $second;
        final FlowCollector<R> $this_unsafeFlow;
        final Function3<T1, T2, Continuation<? super R>, Object> $transform;
        int label;

        C03742(Flow<? extends T1> flow, CoroutineContext coroutineContext, Object obj, ReceiveChannel<? extends Object> receiveChannel, FlowCollector<? super R> flowCollector, Function3<? super T1, ? super T2, ? super Continuation<? super R>, ? extends Object> function3, CompletableJob completableJob, Continuation<? super C03742> continuation) {
            super(2, continuation);
            this.$flow = flow;
            this.$scopeContext = coroutineContext;
            this.$cnt = obj;
            this.$second = receiveChannel;
            this.$this_unsafeFlow = flowCollector;
            this.$transform = function3;
            this.$collectJob = completableJob;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return new C03742(this.$flow, this.$scopeContext, this.$cnt, this.$second, this.$this_unsafeFlow, this.$transform, this.$collectJob, continuation);
        }

        @Override
        public final Object invoke(Unit unit, Continuation<? super Unit> continuation) {
            return ((C03742) create(unit, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
        static final class AnonymousClass1<T> implements FlowCollector {
            final Object $cnt;
            final CompletableJob $collectJob;
            final CoroutineContext $scopeContext;
            final ReceiveChannel<Object> $second;
            final FlowCollector<R> $this_unsafeFlow;
            final Function3<T1, T2, Continuation<? super R>, Object> $transform;

            AnonymousClass1(CoroutineContext coroutineContext, Object obj, ReceiveChannel<? extends Object> receiveChannel, FlowCollector<? super R> flowCollector, Function3<? super T1, ? super T2, ? super Continuation<? super R>, ? extends Object> function3, CompletableJob completableJob) {
                this.$scopeContext = coroutineContext;
                this.$cnt = obj;
                this.$second = receiveChannel;
                this.$this_unsafeFlow = flowCollector;
                this.$transform = function3;
                this.$collectJob = completableJob;
            }

            @Metadata(m17d1 = {"\u0000\b\n\u0000\n\u0002\u0010\u0002\n\u0000\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u0001H\n"}, m18d2 = {"<anonymous>", "", "it"}, m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
            @DebugMetadata(m36c = "kotlinx.coroutines.flow.internal.CombineKt$zipImpl$1$1$2$1$1", m37f = "Combine.kt", m38i = {}, m39l = {WebSocketProtocol.PAYLOAD_SHORT, 129, 129}, m40m = "invokeSuspend", m41n = {}, m42s = {})
            static final class C16611 extends SuspendLambda implements Function2<Unit, Continuation<? super Unit>, Object> {
                final CompletableJob $collectJob;
                final ReceiveChannel<Object> $second;
                final FlowCollector<R> $this_unsafeFlow;
                final Function3<T1, T2, Continuation<? super R>, Object> $transform;
                final T1 $value;
                Object L$0;
                int label;

                C16611(ReceiveChannel<? extends Object> receiveChannel, FlowCollector<? super R> flowCollector, Function3<? super T1, ? super T2, ? super Continuation<? super R>, ? extends Object> function3, T1 t1, CompletableJob completableJob, Continuation<? super C16611> continuation) {
                    super(2, continuation);
                    this.$second = receiveChannel;
                    this.$this_unsafeFlow = flowCollector;
                    this.$transform = function3;
                    this.$value = t1;
                    this.$collectJob = completableJob;
                }

                @Override
                public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                    return new C16611(this.$second, this.$this_unsafeFlow, this.$transform, this.$value, this.$collectJob, continuation);
                }

                @Override
                public final Object invoke(Unit unit, Continuation<? super Unit> continuation) {
                    return ((C16611) create(unit, continuation)).invokeSuspend(Unit.INSTANCE);
                }

                @Override
                public final Object invokeSuspend(Object obj) throws Throwable {
                    Object objMo1816receiveCatchingJP2dKIU;
                    ?? r1;
                    Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                    int i = this.label;
                    if (i == 0) {
                        ResultKt.throwOnFailure(obj);
                        this.label = 1;
                        objMo1816receiveCatchingJP2dKIU = this.$second.mo1816receiveCatchingJP2dKIU(this);
                        if (objMo1816receiveCatchingJP2dKIU == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                    } else {
                        if (i == 1) {
                            ResultKt.throwOnFailure(obj);
                            objMo1816receiveCatchingJP2dKIU = ((ChannelResult) obj).getHolder();
                        } else if (i == 2) {
                            FlowCollector flowCollector = (FlowCollector) this.L$0;
                            ResultKt.throwOnFailure(obj);
                            r1 = flowCollector;
                            this.L$0 = null;
                            this.label = 3;
                            if (r1.emit(obj, this) == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                        } else {
                            if (i != 3) {
                                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                            }
                            ResultKt.throwOnFailure(obj);
                        }
                        return Unit.INSTANCE;
                    }
                    CompletableJob completableJob = this.$collectJob;
                    if (objMo1816receiveCatchingJP2dKIU instanceof ChannelResult.Failed) {
                        Throwable thM1828exceptionOrNullimpl = ChannelResult.m1828exceptionOrNullimpl(objMo1816receiveCatchingJP2dKIU);
                        if (thM1828exceptionOrNullimpl == null) {
                            throw new AbortFlowException(completableJob);
                        }
                        throw thM1828exceptionOrNullimpl;
                    }
                    Object obj2 = this.$this_unsafeFlow;
                    Function3 function3 = this.$transform;
                    Object obj3 = this.$value;
                    if (objMo1816receiveCatchingJP2dKIU == NullSurrogateKt.NULL) {
                        objMo1816receiveCatchingJP2dKIU = null;
                    }
                    this.L$0 = obj2;
                    this.label = 2;
                    obj = function3.invoke(obj3, objMo1816receiveCatchingJP2dKIU, this);
                    r1 = obj2;
                    if (obj == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    this.L$0 = null;
                    this.label = 3;
                    if (r1.emit(obj, this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    return Unit.INSTANCE;
                }
            }

            @Override
            public final Object emit(T1 t1, Continuation<? super Unit> continuation) throws Throwable {
                CombineKt$zipImpl$1$1$2$1$emit$1 combineKt$zipImpl$1$1$2$1$emit$1;
                if (continuation instanceof CombineKt$zipImpl$1$1$2$1$emit$1) {
                    combineKt$zipImpl$1$1$2$1$emit$1 = (CombineKt$zipImpl$1$1$2$1$emit$1) continuation;
                    if ((combineKt$zipImpl$1$1$2$1$emit$1.label & Integer.MIN_VALUE) != 0) {
                        combineKt$zipImpl$1$1$2$1$emit$1.label -= Integer.MIN_VALUE;
                    } else {
                        combineKt$zipImpl$1$1$2$1$emit$1 = new CombineKt$zipImpl$1$1$2$1$emit$1(this, continuation);
                    }
                } else {
                    combineKt$zipImpl$1$1$2$1$emit$1 = new CombineKt$zipImpl$1$1$2$1$emit$1(this, continuation);
                }
                Object obj = combineKt$zipImpl$1$1$2$1$emit$1.result;
                Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                int i = combineKt$zipImpl$1$1$2$1$emit$1.label;
                if (i == 0) {
                    ResultKt.throwOnFailure(obj);
                    CoroutineContext coroutineContext = this.$scopeContext;
                    Unit unit = Unit.INSTANCE;
                    Object obj2 = this.$cnt;
                    C16611 c16611 = new C16611(this.$second, this.$this_unsafeFlow, this.$transform, t1, this.$collectJob, null);
                    combineKt$zipImpl$1$1$2$1$emit$1.label = 1;
                    if (ChannelFlowKt.withContextUndispatched(coroutineContext, unit, obj2, c16611, combineKt$zipImpl$1$1$2$1$emit$1) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } else {
                    if (i != 1) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                }
                return Unit.INSTANCE;
            }
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                Flow<T1> flow = this.$flow;
                AnonymousClass1 anonymousClass1 = new AnonymousClass1(this.$scopeContext, this.$cnt, this.$second, this.$this_unsafeFlow, this.$transform, this.$collectJob);
                this.label = 1;
                if (flow.collect(anonymousClass1, this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return Unit.INSTANCE;
        }
    }
}
