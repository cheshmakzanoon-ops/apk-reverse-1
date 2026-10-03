package kotlinx.coroutines;

import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.DebugProbesKt;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Ref;
import kotlin.time.Duration;
import kotlin.time.DurationKt;
import kotlin.time.DurationUnit;
import kotlinx.coroutines.intrinsics.UndispatchedKt;

@Metadata(m17d1 = {"\u0000D\n\u0002\b\u0003\n\u0002\u0010\t\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\u001aR\u0010\u0000\u001a\u0002H\u0001\"\u0004\b\u0000\u0010\u00012\u0006\u0010\u0002\u001a\u00020\u00032'\u0010\u0004\u001a#\b\u0001\u0012\u0004\u0012\u00020\u0006\u0012\n\u0012\b\u0012\u0004\u0012\u0002H\u00010\u0007\u0012\u0006\u0012\u0004\u0018\u00010\b0\u0005¢\u0006\u0002\b\tH\u0086@\u0082\u0002\n\n\b\b\u0001\u0012\u0002\u0010\u0002 \u0001¢\u0006\u0002\u0010\n\u001aT\u0010\u0000\u001a\u0002H\u0001\"\u0004\b\u0000\u0010\u00012\u0006\u0010\u000b\u001a\u00020\f2'\u0010\u0004\u001a#\b\u0001\u0012\u0004\u0012\u00020\u0006\u0012\n\u0012\b\u0012\u0004\u0012\u0002H\u00010\u0007\u0012\u0006\u0012\u0004\u0018\u00010\b0\u0005¢\u0006\u0002\b\tH\u0086@\u0082\u0002\n\n\b\b\u0001\u0012\u0002\u0010\u0002 \u0001¢\u0006\u0004\b\r\u0010\n\u001aG\u0010\u000e\u001a\u0004\u0018\u0001H\u0001\"\u0004\b\u0000\u0010\u00012\u0006\u0010\u0002\u001a\u00020\u00032'\u0010\u0004\u001a#\b\u0001\u0012\u0004\u0012\u00020\u0006\u0012\n\u0012\b\u0012\u0004\u0012\u0002H\u00010\u0007\u0012\u0006\u0012\u0004\u0018\u00010\b0\u0005¢\u0006\u0002\b\tH\u0086@¢\u0006\u0002\u0010\n\u001aI\u0010\u000e\u001a\u0004\u0018\u0001H\u0001\"\u0004\b\u0000\u0010\u00012\u0006\u0010\u000b\u001a\u00020\f2'\u0010\u0004\u001a#\b\u0001\u0012\u0004\u0012\u00020\u0006\u0012\n\u0012\b\u0012\u0004\u0012\u0002H\u00010\u0007\u0012\u0006\u0012\u0004\u0018\u00010\b0\u0005¢\u0006\u0002\b\tH\u0086@¢\u0006\u0004\b\u000f\u0010\n\u001a\\\u0010\u0010\u001a\u0004\u0018\u00010\b\"\u0004\b\u0000\u0010\u0011\"\b\b\u0001\u0010\u0001*\u0002H\u00112\u0012\u0010\u0012\u001a\u000e\u0012\u0004\u0012\u0002H\u0011\u0012\u0004\u0012\u0002H\u00010\u00132'\u0010\u0004\u001a#\b\u0001\u0012\u0004\u0012\u00020\u0006\u0012\n\u0012\b\u0012\u0004\u0012\u0002H\u00010\u0007\u0012\u0006\u0012\u0004\u0018\u00010\b0\u0005¢\u0006\u0002\b\tH\u0002¢\u0006\u0002\u0010\u0014\u001a \u0010\u0015\u001a\u00020\u00162\u0006\u0010\u0017\u001a\u00020\u00032\u0006\u0010\u0018\u001a\u00020\u00192\u0006\u0010\u0012\u001a\u00020\u001aH\u0000¨\u0006\u001b"}, m18d2 = {"withTimeout", "T", "timeMillis", "", "block", "Lkotlin/Function2;", "Lkotlinx/coroutines/CoroutineScope;", "Lkotlin/coroutines/Continuation;", "", "Lkotlin/ExtensionFunctionType;", "(JLkotlin/jvm/functions/Function2;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "timeout", "Lkotlin/time/Duration;", "withTimeout-KLykuaI", "withTimeoutOrNull", "withTimeoutOrNull-KLykuaI", "setupTimeout", "U", "coroutine", "Lkotlinx/coroutines/TimeoutCoroutine;", "(Lkotlinx/coroutines/TimeoutCoroutine;Lkotlin/jvm/functions/Function2;)Ljava/lang/Object;", "TimeoutCancellationException", "Lkotlinx/coroutines/TimeoutCancellationException;", "time", "delay", "Lkotlinx/coroutines/Delay;", "Lkotlinx/coroutines/Job;", "kotlinx-coroutines-core"}, m19k = 2, m20mv = {2, 0, 0}, m22xi = 48)
public final class TimeoutKt {

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.TimeoutKt", m37f = "Timeout.kt", m38i = {0, 0, 0}, m39l = {101}, m40m = "withTimeoutOrNull", m41n = {"block", "coroutine", "timeMillis"}, m42s = {"L$0", "L$1", "J$0"})
    static final class C01991<T> extends ContinuationImpl {
        long J$0;
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C01991(Continuation<? super C01991> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return TimeoutKt.withTimeoutOrNull(0L, null, this);
        }
    }

    public static final <T> Object withTimeout(long j, Function2<? super CoroutineScope, ? super Continuation<? super T>, ? extends Object> function2, Continuation<? super T> continuation) {
        if (j <= 0) {
            throw new TimeoutCancellationException("Timed out immediately");
        }
        Object obj = setupTimeout(new TimeoutCoroutine(j, continuation), function2);
        if (obj == IntrinsicsKt.getCOROUTINE_SUSPENDED()) {
            DebugProbesKt.probeCoroutineSuspended(continuation);
        }
        return obj;
    }

    public static final <T> Object m1806withTimeoutKLykuaI(long j, Function2<? super CoroutineScope, ? super Continuation<? super T>, ? extends Object> function2, Continuation<? super T> continuation) {
        return withTimeout(DelayKt.m1798toDelayMillisLRDsOJo(j), function2, continuation);
    }

    public static final <T> Object withTimeoutOrNull(long j, Function2<? super CoroutineScope, ? super Continuation<? super T>, ? extends Object> function2, Continuation<? super T> continuation) throws Throwable {
        C01991 c01991;
        Ref.ObjectRef objectRef;
        if (continuation instanceof C01991) {
            c01991 = (C01991) continuation;
            if ((c01991.label & Integer.MIN_VALUE) != 0) {
                c01991.label -= Integer.MIN_VALUE;
            } else {
                c01991 = new C01991(continuation);
            }
        } else {
            c01991 = new C01991(continuation);
        }
        Object obj = c01991.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c01991.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            if (j <= 0) {
                return null;
            }
            Ref.ObjectRef objectRef2 = new Ref.ObjectRef();
            try {
                c01991.L$0 = function2;
                c01991.L$1 = objectRef2;
                c01991.J$0 = j;
                c01991.label = 1;
                ?? r4 = (T) new TimeoutCoroutine(j, c01991);
                objectRef2.element = r4;
                Object obj2 = setupTimeout(r4, function2);
                if (obj2 == IntrinsicsKt.getCOROUTINE_SUSPENDED()) {
                    DebugProbesKt.probeCoroutineSuspended(c01991);
                }
                return obj2 == coroutine_suspended ? coroutine_suspended : obj2;
            } catch (TimeoutCancellationException e) {
                e = e;
                objectRef = objectRef2;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            long j2 = c01991.J$0;
            objectRef = (Ref.ObjectRef) c01991.L$1;
            try {
                ResultKt.throwOnFailure(obj);
                return obj;
            } catch (TimeoutCancellationException e2) {
                e = e2;
            }
        }
        if (e.coroutine == objectRef.element) {
            return null;
        }
        throw e;
    }

    public static final <T> Object m1807withTimeoutOrNullKLykuaI(long j, Function2<? super CoroutineScope, ? super Continuation<? super T>, ? extends Object> function2, Continuation<? super T> continuation) {
        return withTimeoutOrNull(DelayKt.m1798toDelayMillisLRDsOJo(j), function2, continuation);
    }

    private static final <U, T extends U> Object setupTimeout(TimeoutCoroutine<U, ? super T> timeoutCoroutine, Function2<? super CoroutineScope, ? super Continuation<? super T>, ? extends Object> function2) {
        JobKt.disposeOnCompletion(timeoutCoroutine, DelayKt.getDelay(timeoutCoroutine.uCont.get$context()).invokeOnTimeout(timeoutCoroutine.time, timeoutCoroutine, timeoutCoroutine.get$context()));
        return UndispatchedKt.startUndispatchedOrReturnIgnoreTimeout(timeoutCoroutine, timeoutCoroutine, function2);
    }

    public static final TimeoutCancellationException TimeoutCancellationException(long j, Delay delay, Job job) {
        String strM1799timeoutMessageLRDsOJo;
        DelayWithTimeoutDiagnostics delayWithTimeoutDiagnostics = delay instanceof DelayWithTimeoutDiagnostics ? (DelayWithTimeoutDiagnostics) delay : null;
        if (delayWithTimeoutDiagnostics != null) {
            Duration.Companion companion = Duration.INSTANCE;
            strM1799timeoutMessageLRDsOJo = delayWithTimeoutDiagnostics.m1799timeoutMessageLRDsOJo(DurationKt.toDuration(j, DurationUnit.MILLISECONDS));
            if (strM1799timeoutMessageLRDsOJo == null) {
                strM1799timeoutMessageLRDsOJo = "Timed out waiting for " + j + " ms";
            }
        } else {
            strM1799timeoutMessageLRDsOJo = "Timed out waiting for " + j + " ms";
        }
        return new TimeoutCancellationException(strM1799timeoutMessageLRDsOJo, job);
    }
}
