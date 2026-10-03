package androidx.compose.runtime;

import androidx.autofill.HintConstants;
import androidx.compose.p002ui.graphics.colorspace.ColorSpace;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;

@Metadata(d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0010\t\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0007\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0001¢\u0006\u0002\u0010\u0003J\u0006\u0010\t\u001a\u00020\nJ\u0006\u0010\u000b\u001a\u00020\nJ7\u0010\f\u001a\u0002H\r\"\u0004\b\u0000\u0010\r2!\u0010\u000e\u001a\u001d\u0012\u0013\u0012\u00110\u0010¢\u0006\f\b\u0011\u0012\b\b\u0012\u0012\u0004\b\b(\u0013\u0012\u0004\u0012\u0002H\r0\u000fH\u0096@¢\u0006\u0002\u0010\u0014R\u000e\u0010\u0002\u001a\u00020\u0001X\u0082\u0004¢\u0006\u0002\n\u0000R\u0011\u0010\u0004\u001a\u00020\u00058F¢\u0006\u0006\u001a\u0004\b\u0004\u0010\u0006R\u000e\u0010\u0007\u001a\u00020\bX\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0015"}, d2 = {"Landroidx/compose/runtime/PausableMonotonicFrameClock;", "Landroidx/compose/runtime/MonotonicFrameClock;", "frameClock", "(Landroidx/compose/runtime/MonotonicFrameClock;)V", "isPaused", "", "()Z", "latch", "Landroidx/compose/runtime/Latch;", "pause", "", "resume", "withFrameNanos", "R", "onFrame", "Lkotlin/Function1;", "", "Lkotlin/ParameterName;", HintConstants.AUTOFILL_HINT_NAME, "frameTimeNanos", "(Lkotlin/jvm/functions/Function1;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "runtime_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class PausableMonotonicFrameClock implements MonotonicFrameClock {
    public static final int $stable = 8;
    private final MonotonicFrameClock frameClock;
    private final Latch latch = new Latch();

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.runtime.PausableMonotonicFrameClock", f = "PausableMonotonicFrameClock.kt", i = {0, 0}, l = {62, ColorSpace.MaxId}, m = "withFrameNanos", n = {"this", "onFrame"}, s = {"L$0", "L$1"})
    static final class C15231<R> extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C15231(Continuation<? super C15231> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return PausableMonotonicFrameClock.this.withFrameNanos(null, (Continuation) this);
        }
    }

    @Override
    public CoroutineContext.Key getKey() {
        return MonotonicFrameClock.CC.$default$getKey(this);
    }

    public PausableMonotonicFrameClock(MonotonicFrameClock monotonicFrameClock) {
        this.frameClock = monotonicFrameClock;
    }

    public <R> R fold(R r, Function2<? super R, ? super CoroutineContext.Element, ? extends R> function2) {
        return (R) MonotonicFrameClock.DefaultImpls.fold(this, r, function2);
    }

    public <E extends CoroutineContext.Element> E get(CoroutineContext.Key<E> key) {
        return (E) MonotonicFrameClock.DefaultImpls.get(this, key);
    }

    public CoroutineContext minusKey(CoroutineContext.Key<?> key) {
        return MonotonicFrameClock.DefaultImpls.minusKey(this, key);
    }

    public CoroutineContext plus(CoroutineContext coroutineContext) {
        return MonotonicFrameClock.DefaultImpls.plus(this, coroutineContext);
    }

    public final boolean isPaused() {
        return !this.latch.isOpen();
    }

    public final void pause() {
        this.latch.closeLatch();
    }

    public final void resume() {
        this.latch.openLatch();
    }

    @Override
    public <R> Object withFrameNanos(Function1<? super Long, ? extends R> function1, Continuation<? super R> continuation) {
        C15231 c15231;
        PausableMonotonicFrameClock pausableMonotonicFrameClock;
        if (continuation instanceof C15231) {
            c15231 = (C15231) continuation;
            if ((c15231.label & Integer.MIN_VALUE) != 0) {
                c15231.label -= Integer.MIN_VALUE;
            } else {
                c15231 = new C15231(continuation);
            }
        } else {
            c15231 = new C15231(continuation);
        }
        Object objWithFrameNanos = c15231.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c15231.label;
        if (i != 0) {
            if (i == 1) {
                function1 = (Function1) c15231.L$1;
                pausableMonotonicFrameClock = (PausableMonotonicFrameClock) c15231.L$0;
                ResultKt.throwOnFailure(objWithFrameNanos);
            } else {
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(objWithFrameNanos);
            }
        }
        ResultKt.throwOnFailure(objWithFrameNanos);
        Latch latch = this.latch;
        c15231.L$0 = this;
        c15231.L$1 = function1;
        c15231.label = 1;
        if (latch.await(c15231) == coroutine_suspended) {
            return coroutine_suspended;
        }
        pausableMonotonicFrameClock = this;
        MonotonicFrameClock monotonicFrameClock = pausableMonotonicFrameClock.frameClock;
        c15231.L$0 = null;
        c15231.L$1 = null;
        c15231.label = 2;
        objWithFrameNanos = monotonicFrameClock.withFrameNanos(function1, c15231);
        return objWithFrameNanos == coroutine_suspended ? coroutine_suspended : objWithFrameNanos;
    }
}
