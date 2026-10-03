package kotlinx.coroutines;

import kotlin.KotlinNothingValueException;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.ContinuationInterceptor;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.DebugProbesKt;
import kotlin.jvm.internal.LongCompanionObject;
import kotlin.time.Duration;
import kotlin.time.DurationKt;
import kotlin.time.DurationUnit;

@Metadata(m17d1 = {"\u0000*\n\u0000\n\u0002\u0010\u0001\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\t\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\u001a\u000e\u0010\u0000\u001a\u00020\u0001H\u0086@¢\u0006\u0002\u0010\u0002\u001a\u0016\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u0006H\u0086@¢\u0006\u0002\u0010\u0007\u001a\u0018\u0010\u0003\u001a\u00020\u00042\u0006\u0010\b\u001a\u00020\tH\u0086@¢\u0006\u0004\b\n\u0010\u0007\u001a\u0013\u0010\u000f\u001a\u00020\u0006*\u00020\tH\u0000¢\u0006\u0004\b\u0010\u0010\u0011\"\u0018\u0010\u0003\u001a\u00020\u000b*\u00020\f8@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b\r\u0010\u000e¨\u0006\u0012"}, m18d2 = {"awaitCancellation", "", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "delay", "", "timeMillis", "", "(JLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "duration", "Lkotlin/time/Duration;", "delay-VtjQ1oo", "Lkotlinx/coroutines/Delay;", "Lkotlin/coroutines/CoroutineContext;", "getDelay", "(Lkotlin/coroutines/CoroutineContext;)Lkotlinx/coroutines/Delay;", "toDelayMillis", "toDelayMillis-LRDsOJo", "(J)J", "kotlinx-coroutines-core"}, m19k = 2, m20mv = {2, 0, 0}, m22xi = 48)
public final class DelayKt {

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.DelayKt", m37f = "Delay.kt", m38i = {}, m39l = {160}, m40m = "awaitCancellation", m41n = {}, m42s = {})
    static final class C01941 extends ContinuationImpl {
        int label;
        Object result;

        C01941(Continuation<? super C01941> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return DelayKt.awaitCancellation(this);
        }
    }

    public static final Object awaitCancellation(Continuation<?> continuation) throws Throwable {
        C01941 c01941;
        if (continuation instanceof C01941) {
            c01941 = (C01941) continuation;
            if ((c01941.label & Integer.MIN_VALUE) != 0) {
                c01941.label -= Integer.MIN_VALUE;
            } else {
                c01941 = new C01941(continuation);
            }
        } else {
            c01941 = new C01941(continuation);
        }
        Object obj = c01941.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c01941.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            c01941.label = 1;
            C01941 c01942 = c01941;
            CancellableContinuationImpl cancellableContinuationImpl = new CancellableContinuationImpl(IntrinsicsKt.intercepted(c01942), 1);
            cancellableContinuationImpl.initCancellability();
            Object result = cancellableContinuationImpl.getResult();
            if (result == IntrinsicsKt.getCOROUTINE_SUSPENDED()) {
                DebugProbesKt.probeCoroutineSuspended(c01942);
            }
            if (result == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
        }
        throw new KotlinNothingValueException();
    }

    public static final Object delay(long j, Continuation<? super Unit> continuation) {
        if (j <= 0) {
            return Unit.INSTANCE;
        }
        CancellableContinuationImpl cancellableContinuationImpl = new CancellableContinuationImpl(IntrinsicsKt.intercepted(continuation), 1);
        cancellableContinuationImpl.initCancellability();
        CancellableContinuationImpl cancellableContinuationImpl2 = cancellableContinuationImpl;
        if (j < LongCompanionObject.MAX_VALUE) {
            getDelay(cancellableContinuationImpl2.getContext()).mo1876scheduleResumeAfterDelay(j, cancellableContinuationImpl2);
        }
        Object result = cancellableContinuationImpl.getResult();
        if (result == IntrinsicsKt.getCOROUTINE_SUSPENDED()) {
            DebugProbesKt.probeCoroutineSuspended(continuation);
        }
        return result == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? result : Unit.INSTANCE;
    }

    public static final Object m1797delayVtjQ1oo(long j, Continuation<? super Unit> continuation) {
        Object objDelay = delay(m1798toDelayMillisLRDsOJo(j), continuation);
        return objDelay == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objDelay : Unit.INSTANCE;
    }

    public static final Delay getDelay(CoroutineContext coroutineContext) {
        CoroutineContext.Element element = coroutineContext.get(ContinuationInterceptor.INSTANCE);
        Delay delay = element instanceof Delay ? (Delay) element : null;
        return delay == null ? DefaultExecutorKt.getDefaultDelay() : delay;
    }

    public static final long m1798toDelayMillisLRDsOJo(long j) {
        boolean zM1665isPositiveimpl = Duration.m1665isPositiveimpl(j);
        if (zM1665isPositiveimpl) {
            Duration.Companion companion = Duration.INSTANCE;
            return Duration.m1649getInWholeMillisecondsimpl(Duration.m1667plusLRDsOJo(j, DurationKt.toDuration(999999L, DurationUnit.NANOSECONDS)));
        }
        if (zM1665isPositiveimpl) {
            throw new NoWhenBranchMatchedException();
        }
        return 0L;
    }
}
