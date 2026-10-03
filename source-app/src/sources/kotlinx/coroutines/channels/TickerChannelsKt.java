package kotlinx.coroutines.channels;

import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.EmptyCoroutineContext;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.Dispatchers;
import kotlinx.coroutines.GlobalScope;
import net.aihelp.data.track.data.TrackType;
import zendesk.faye.internal.Bayeux;

@Metadata(m17d1 = {"\u0000*\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\t\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\u001a4\u0010\u0000\u001a\b\u0012\u0004\u0012\u00020\u00020\u00012\u0006\u0010\u0003\u001a\u00020\u00042\b\b\u0002\u0010\u0005\u001a\u00020\u00042\b\b\u0002\u0010\u0006\u001a\u00020\u00072\b\b\u0002\u0010\b\u001a\u00020\tH\u0007\u001a,\u0010\n\u001a\u00020\u00022\u0006\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00042\f\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\u00020\fH\u0082@¢\u0006\u0002\u0010\r\u001a,\u0010\u000e\u001a\u00020\u00022\u0006\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00042\f\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\u00020\fH\u0082@¢\u0006\u0002\u0010\r¨\u0006\u000f"}, m18d2 = {"ticker", "Lkotlinx/coroutines/channels/ReceiveChannel;", "", "delayMillis", "", "initialDelayMillis", "context", "Lkotlin/coroutines/CoroutineContext;", "mode", "Lkotlinx/coroutines/channels/TickerMode;", "fixedPeriodTicker", Bayeux.KEY_CHANNEL, "Lkotlinx/coroutines/channels/SendChannel;", "(JJLkotlinx/coroutines/channels/SendChannel;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "fixedDelayTicker", "kotlinx-coroutines-core"}, m19k = 2, m20mv = {2, 0, 0}, m22xi = 48)
public final class TickerChannelsKt {

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.TickerChannelsKt", m37f = "TickerChannels.kt", m38i = {0, 0, 1, 1, 2, 2}, m39l = {102, 104, TrackType.TRACK_ENTRANCE_CLICK_FAQ}, m40m = "fixedDelayTicker", m41n = {Bayeux.KEY_CHANNEL, "delayMillis", Bayeux.KEY_CHANNEL, "delayMillis", Bayeux.KEY_CHANNEL, "delayMillis"}, m42s = {"L$0", "J$0", "L$0", "J$0", "L$0", "J$0"})
    static final class C02521 extends ContinuationImpl {
        long J$0;
        Object L$0;
        int label;
        Object result;

        C02521(Continuation<? super C02521> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return TickerChannelsKt.fixedDelayTicker(0L, 0L, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.TickerChannelsKt", m37f = "TickerChannels.kt", m38i = {0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3}, m39l = {80, 84, 90, 92}, m40m = "fixedPeriodTicker", m41n = {Bayeux.KEY_CHANNEL, "delayMillis", "deadline", Bayeux.KEY_CHANNEL, "deadline", "delayNs", Bayeux.KEY_CHANNEL, "deadline", "delayNs", Bayeux.KEY_CHANNEL, "deadline", "delayNs"}, m42s = {"L$0", "J$0", "J$1", "L$0", "J$0", "J$1", "L$0", "J$0", "J$1", "L$0", "J$0", "J$1"})
    static final class C02531 extends ContinuationImpl {
        long J$0;
        long J$1;
        Object L$0;
        int label;
        Object result;

        C02531(Continuation<? super C02531> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return TickerChannelsKt.fixedPeriodTicker(0L, 0L, null, this);
        }
    }

    public static ReceiveChannel ticker$default(long j, long j2, CoroutineContext coroutineContext, TickerMode tickerMode, int i, Object obj) {
        if ((i & 2) != 0) {
            j2 = j;
        }
        if ((i & 4) != 0) {
            coroutineContext = EmptyCoroutineContext.INSTANCE;
        }
        if ((i & 8) != 0) {
            tickerMode = TickerMode.FIXED_PERIOD;
        }
        return ticker(j, j2, coroutineContext, tickerMode);
    }

    public static final ReceiveChannel<Unit> ticker(long j, long j2, CoroutineContext coroutineContext, TickerMode tickerMode) {
        if (j < 0) {
            throw new IllegalArgumentException(("Expected non-negative delay, but has " + j + " ms").toString());
        }
        if (j2 < 0) {
            throw new IllegalArgumentException(("Expected non-negative initial delay, but has " + j2 + " ms").toString());
        }
        return ProduceKt.produce(GlobalScope.INSTANCE, Dispatchers.getUnconfined().plus(coroutineContext), 0, new C02543(tickerMode, j, j2, null));
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\b\u0012\u0004\u0012\u00020\u00010\u0002H\n"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/channels/ProducerScope;"}, m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.channels.TickerChannelsKt$ticker$3", m37f = "TickerChannels.kt", m38i = {}, m39l = {68, 69}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C02543 extends SuspendLambda implements Function2<ProducerScope<? super Unit>, Continuation<? super Unit>, Object> {
        final long $delayMillis;
        final long $initialDelayMillis;
        final TickerMode $mode;
        private Object L$0;
        int label;

        @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
        public class WhenMappings {
            public static final int[] $EnumSwitchMapping$0;

            static {
                int[] iArr = new int[TickerMode.values().length];
                try {
                    iArr[TickerMode.FIXED_PERIOD.ordinal()] = 1;
                } catch (NoSuchFieldError unused) {
                }
                try {
                    iArr[TickerMode.FIXED_DELAY.ordinal()] = 2;
                } catch (NoSuchFieldError unused2) {
                }
                $EnumSwitchMapping$0 = iArr;
            }
        }

        C02543(TickerMode tickerMode, long j, long j2, Continuation<? super C02543> continuation) {
            super(2, continuation);
            this.$mode = tickerMode;
            this.$delayMillis = j;
            this.$initialDelayMillis = j2;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            C02543 c02543 = new C02543(this.$mode, this.$delayMillis, this.$initialDelayMillis, continuation);
            c02543.L$0 = obj;
            return c02543;
        }

        @Override
        public final Object invoke(ProducerScope<? super Unit> producerScope, Continuation<? super Unit> continuation) {
            return ((C02543) create(producerScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                ProducerScope producerScope = (ProducerScope) this.L$0;
                int i2 = WhenMappings.$EnumSwitchMapping$0[this.$mode.ordinal()];
                if (i2 == 1) {
                    this.label = 1;
                    if (TickerChannelsKt.fixedPeriodTicker(this.$delayMillis, this.$initialDelayMillis, producerScope.getChannel(), this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } else if (i2 == 2) {
                    this.label = 2;
                    if (TickerChannelsKt.fixedDelayTicker(this.$delayMillis, this.$initialDelayMillis, producerScope.getChannel(), this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } else {
                    throw new NoWhenBranchMatchedException();
                }
            } else {
                if (i != 1 && i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return Unit.INSTANCE;
        }
    }

    public static final java.lang.Object fixedPeriodTicker(long r18, long r20, kotlinx.coroutines.channels.SendChannel<? super kotlin.Unit> r22, kotlin.coroutines.Continuation<? super kotlin.Unit> r23) {
        throw new UnsupportedOperationException("Method not decompiled: kotlinx.coroutines.channels.TickerChannelsKt.fixedPeriodTicker(long, long, kotlinx.coroutines.channels.SendChannel, kotlin.coroutines.Continuation):java.lang.Object");
    }

    public static final java.lang.Object fixedDelayTicker(long r6, long r8, kotlinx.coroutines.channels.SendChannel<? super kotlin.Unit> r10, kotlin.coroutines.Continuation<? super kotlin.Unit> r11) {
        throw new UnsupportedOperationException("Method not decompiled: kotlinx.coroutines.channels.TickerChannelsKt.fixedDelayTicker(long, long, kotlinx.coroutines.channels.SendChannel, kotlin.coroutines.Continuation):java.lang.Object");
    }
}
