package kotlinx.coroutines.flow;

import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.Boxing;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.CoroutineScope;

@Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\n"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
@DebugMetadata(m36c = "kotlinx.coroutines.flow.FlowKt__ShareKt$launchSharing$1", m37f = "Share.kt", m38i = {}, m39l = {210, 214, 215, 221}, m40m = "invokeSuspend", m41n = {}, m42s = {})
final class FlowKt__ShareKt$launchSharing$1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
    final T $initialValue;
    final MutableSharedFlow<T> $shared;
    final SharingStarted $started;
    final Flow<T> $upstream;
    int label;

    FlowKt__ShareKt$launchSharing$1(SharingStarted sharingStarted, Flow<? extends T> flow, MutableSharedFlow<T> mutableSharedFlow, T t, Continuation<? super FlowKt__ShareKt$launchSharing$1> continuation) {
        super(2, continuation);
        this.$started = sharingStarted;
        this.$upstream = flow;
        this.$shared = mutableSharedFlow;
        this.$initialValue = t;
    }

    @Override
    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        return new FlowKt__ShareKt$launchSharing$1(this.$started, this.$upstream, this.$shared, this.$initialValue, continuation);
    }

    @Override
    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
        return ((FlowKt__ShareKt$launchSharing$1) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
    }

    @Override
    public final Object invokeSuspend(Object obj) throws Throwable {
        Flow<T> flow;
        FlowCollector flowCollector;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i != 0) {
            if (i != 1) {
                if (i == 2) {
                    ResultKt.throwOnFailure(obj);
                    flow = this.$upstream;
                    flowCollector = this.$shared;
                    this.label = 3;
                    if (flow.collect((FlowCollector<? super T>) flowCollector, this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } else if (i != 3 && i != 4) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
            }
            ResultKt.throwOnFailure(obj);
        } else {
            ResultKt.throwOnFailure(obj);
            if (this.$started == SharingStarted.INSTANCE.getEagerly()) {
                Flow<T> flow2 = this.$upstream;
                FlowCollector flowCollector2 = this.$shared;
                this.label = 1;
                if (flow2.collect((FlowCollector<? super T>) flowCollector2, this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else if (this.$started == SharingStarted.INSTANCE.getLazily()) {
                this.label = 2;
                if (FlowKt.first(this.$shared.getSubscriptionCount(), new C03281(null), this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                flow = this.$upstream;
                flowCollector = this.$shared;
                this.label = 3;
                if (flow.collect((FlowCollector<? super T>) flowCollector, this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                this.label = 4;
                if (FlowKt.collectLatest(FlowKt.distinctUntilChanged(this.$started.command(this.$shared.getSubscriptionCount())), new C03292(this.$upstream, this.$shared, this.$initialValue, null), this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            }
        }
        return Unit.INSTANCE;
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\b\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u0003H\n"}, m18d2 = {"<anonymous>", "", "it", ""}, m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.flow.FlowKt__ShareKt$launchSharing$1$1", m37f = "Share.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C03281 extends SuspendLambda implements Function2<Integer, Continuation<? super Boolean>, Object> {
        int I$0;
        int label;

        C03281(Continuation<? super C03281> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            C03281 c03281 = new C03281(continuation);
            c03281.I$0 = ((Number) obj).intValue();
            return c03281;
        }

        public final Object invoke(int i, Continuation<? super Boolean> continuation) {
            return ((C03281) create(Integer.valueOf(i), continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public Object invoke(Integer num, Continuation<? super Boolean> continuation) {
            return invoke(num.intValue(), continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            return Boxing.boxBoolean(this.I$0 > 0);
        }
    }

    @Metadata(m17d1 = {"\u0000\u0014\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\u0010\u0000\u001a\u00020\u00012\u0015\u0010\u0002\u001a\u00110\u0003¢\u0006\f\b\u0004\u0012\b\b\u0005\u0012\u0004\b\b(\u0006H\n"}, m18d2 = {"<anonymous>", "", "it", "Lkotlinx/coroutines/flow/SharingCommand;", "Lkotlin/ParameterName;", "name", "value"}, m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.flow.FlowKt__ShareKt$launchSharing$1$2", m37f = "Share.kt", m38i = {}, m39l = {223}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C03292 extends SuspendLambda implements Function2<SharingCommand, Continuation<? super Unit>, Object> {
        final T $initialValue;
        final MutableSharedFlow<T> $shared;
        final Flow<T> $upstream;
        Object L$0;
        int label;

        @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
        public class WhenMappings {
            public static final int[] $EnumSwitchMapping$0;

            static {
                int[] iArr = new int[SharingCommand.values().length];
                try {
                    iArr[SharingCommand.START.ordinal()] = 1;
                } catch (NoSuchFieldError unused) {
                }
                try {
                    iArr[SharingCommand.STOP.ordinal()] = 2;
                } catch (NoSuchFieldError unused2) {
                }
                try {
                    iArr[SharingCommand.STOP_AND_RESET_REPLAY_CACHE.ordinal()] = 3;
                } catch (NoSuchFieldError unused3) {
                }
                $EnumSwitchMapping$0 = iArr;
            }
        }

        C03292(Flow<? extends T> flow, MutableSharedFlow<T> mutableSharedFlow, T t, Continuation<? super C03292> continuation) {
            super(2, continuation);
            this.$upstream = flow;
            this.$shared = mutableSharedFlow;
            this.$initialValue = t;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            C03292 c03292 = new C03292(this.$upstream, this.$shared, this.$initialValue, continuation);
            c03292.L$0 = obj;
            return c03292;
        }

        @Override
        public final Object invoke(SharingCommand sharingCommand, Continuation<? super Unit> continuation) {
            return ((C03292) create(sharingCommand, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final java.lang.Object invokeSuspend(java.lang.Object r5) {
            throw new UnsupportedOperationException("Method not decompiled: kotlinx.coroutines.flow.FlowKt__ShareKt$launchSharing$1.C03292.invokeSuspend(java.lang.Object):java.lang.Object");
        }
    }
}
