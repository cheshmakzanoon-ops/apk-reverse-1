package kotlinx.coroutines.sync;

import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.functions.Function0;
import kotlinx.coroutines.internal.Symbol;
import kotlinx.coroutines.internal.SystemPropsKt__SystemProps_commonKt;
import net.aihelp.data.model.p005cs.ConversationMsg;

@Metadata(m17d1 = {"\u0000.\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\t\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\u001a\u0018\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u0003\u001a3\u0010\u0005\u001a\u0002H\u0006\"\u0004\b\u0000\u0010\u0006*\u00020\u00012\f\u0010\u0007\u001a\b\u0012\u0004\u0012\u0002H\u00060\bH\u0086H\u0082\u0002\n\n\b\b\u0001\u0012\u0002\u0010\u0001 \u0001¢\u0006\u0002\u0010\t\u001a\u001a\u0010\n\u001a\u00020\u000b2\u0006\u0010\f\u001a\u00020\r2\b\u0010\u000e\u001a\u0004\u0018\u00010\u000bH\u0002\"\u000e\u0010\u000f\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000\"\u000e\u0010\u0010\u001a\u00020\u0011X\u0082\u0004¢\u0006\u0002\n\u0000\"\u000e\u0010\u0012\u001a\u00020\u0011X\u0082\u0004¢\u0006\u0002\n\u0000\"\u000e\u0010\u0013\u001a\u00020\u0011X\u0082\u0004¢\u0006\u0002\n\u0000\"\u000e\u0010\u0014\u001a\u00020\u0011X\u0082\u0004¢\u0006\u0002\n\u0000\"\u000e\u0010\u0015\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0016"}, m18d2 = {"Semaphore", "Lkotlinx/coroutines/sync/Semaphore;", "permits", "", "acquiredPermits", "withPermit", "T", "action", "Lkotlin/Function0;", "(Lkotlinx/coroutines/sync/Semaphore;Lkotlin/jvm/functions/Function0;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "createSegment", "Lkotlinx/coroutines/sync/SemaphoreSegment;", "id", "", "prev", "MAX_SPIN_CYCLES", "PERMIT", "Lkotlinx/coroutines/internal/Symbol;", "TAKEN", "BROKEN", "CANCELLED", "SEGMENT_SIZE", "kotlinx-coroutines-core"}, m19k = 2, m20mv = {2, 0, 0}, m22xi = 48)
public final class SemaphoreKt {
    private static final int MAX_SPIN_CYCLES = SystemPropsKt__SystemProps_commonKt.systemProp$default("kotlinx.coroutines.semaphore.maxSpinCycles", 100, 0, 0, 12, (Object) null);
    private static final Symbol PERMIT = new Symbol("PERMIT");
    private static final Symbol TAKEN = new Symbol("TAKEN");
    private static final Symbol BROKEN = new Symbol("BROKEN");
    private static final Symbol CANCELLED = new Symbol("CANCELLED");
    private static final int SEGMENT_SIZE = SystemPropsKt__SystemProps_commonKt.systemProp$default("kotlinx.coroutines.semaphore.segmentSize", 16, 0, 0, 12, (Object) null);

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 176)
    @DebugMetadata(m36c = "kotlinx.coroutines.sync.SemaphoreKt", m37f = "Semaphore.kt", m38i = {0, 0}, m39l = {ConversationMsg.TYPE_ADMIN_IMAGE}, m40m = "withPermit", m41n = {"$this$withPermit", "action"}, m42s = {"L$0", "L$1"})
    static final class C03881<T> extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C03881(Continuation<? super C03881> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return SemaphoreKt.withPermit(null, null, this);
        }
    }

    public static Semaphore Semaphore$default(int i, int i2, int i3, Object obj) {
        if ((i3 & 2) != 0) {
            i2 = 0;
        }
        return Semaphore(i, i2);
    }

    public static final Semaphore Semaphore(int i, int i2) {
        return new SemaphoreImpl(i, i2);
    }

    public static final <T> Object withPermit(Semaphore semaphore, Function0<? extends T> function0, Continuation<? super T> continuation) throws Throwable {
        C03881 c03881;
        if (continuation instanceof C03881) {
            c03881 = (C03881) continuation;
            if ((c03881.label & Integer.MIN_VALUE) != 0) {
                c03881.label -= Integer.MIN_VALUE;
            } else {
                c03881 = new C03881(continuation);
            }
        } else {
            c03881 = new C03881(continuation);
        }
        Object obj = c03881.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c03881.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            c03881.L$0 = semaphore;
            c03881.L$1 = function0;
            c03881.label = 1;
            if (semaphore.acquire(c03881) == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            function0 = (Function0) c03881.L$1;
            semaphore = (Semaphore) c03881.L$0;
            ResultKt.throwOnFailure(obj);
        }
        try {
            return function0.invoke();
        } finally {
            semaphore.release();
        }
    }

    private static final <T> Object withPermit$$forInline(Semaphore semaphore, Function0<? extends T> function0, Continuation<? super T> continuation) {
        semaphore.acquire(continuation);
        try {
            return function0.invoke();
        } finally {
            semaphore.release();
        }
    }

    public static final SemaphoreSegment createSegment(long j, SemaphoreSegment semaphoreSegment) {
        return new SemaphoreSegment(j, semaphoreSegment, 0);
    }
}
