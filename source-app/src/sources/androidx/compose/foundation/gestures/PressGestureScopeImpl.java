package androidx.compose.foundation.gestures;

import androidx.compose.p002ui.geometry.Rect;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.DpRect;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.Boxing;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlinx.coroutines.sync.Mutex;
import kotlinx.coroutines.sync.MutexKt;
import zendesk.p005ui.android.BuildConfig;

@Metadata(d1 = {"\u0000Z\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0007\n\u0002\b\u0005\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0006\n\u0002\u0010\b\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\b\b\u0000\u0018\u00002\u00020\u00012\u00020\u0002B\r\u0012\u0006\u0010\u0003\u001a\u00020\u0002¢\u0006\u0002\u0010\u0004J\u000e\u0010\u000f\u001a\u00020\u0010H\u0096@¢\u0006\u0002\u0010\u0011J\u0006\u0010\u0012\u001a\u00020\u0010J\u0006\u0010\u0013\u001a\u00020\u0010J\u000e\u0010\u0014\u001a\u00020\u0010H\u0086@¢\u0006\u0002\u0010\u0011J\u000e\u0010\u0015\u001a\u00020\u000bH\u0096@¢\u0006\u0002\u0010\u0011J\u0017\u0010\u0016\u001a\u00020\u0017*\u00020\u0018H\u0097\u0001ø\u0001\u0000¢\u0006\u0004\b\u0019\u0010\u001aJ\u0017\u0010\u0016\u001a\u00020\u0017*\u00020\u001bH\u0097\u0001ø\u0001\u0000¢\u0006\u0004\b\u001c\u0010\u001dJ\u0017\u0010\u001e\u001a\u00020\u0018*\u00020\u001bH\u0097\u0001ø\u0001\u0000¢\u0006\u0004\b\u001f\u0010 J\u001a\u0010\u001e\u001a\u00020\u0018*\u00020\u0005H\u0097\u0001ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b!\u0010\"J\u001a\u0010\u001e\u001a\u00020\u0018*\u00020\u0017H\u0097\u0001ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b!\u0010#J\u0017\u0010$\u001a\u00020%*\u00020&H\u0097\u0001ø\u0001\u0000¢\u0006\u0004\b'\u0010(J\u0017\u0010)\u001a\u00020\u0005*\u00020\u0018H\u0097\u0001ø\u0001\u0000¢\u0006\u0004\b*\u0010\"J\u0017\u0010)\u001a\u00020\u0005*\u00020\u001bH\u0097\u0001ø\u0001\u0000¢\u0006\u0004\b+\u0010 J\r\u0010,\u001a\u00020-*\u00020.H\u0097\u0001J\u0017\u0010/\u001a\u00020&*\u00020%H\u0097\u0001ø\u0001\u0000¢\u0006\u0004\b0\u0010(J\u0017\u00101\u001a\u00020\u001b*\u00020\u0018H\u0097\u0001ø\u0001\u0000¢\u0006\u0004\b2\u00103J\u001a\u00101\u001a\u00020\u001b*\u00020\u0005H\u0097\u0001ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b4\u00103J\u001a\u00101\u001a\u00020\u001b*\u00020\u0017H\u0097\u0001ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b4\u00105R\u0014\u0010\u0003\u001a\u00020\u00058\u0016X\u0097\u0005¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007R\u0014\u0010\b\u001a\u00020\u00058\u0016X\u0097\u0005¢\u0006\u0006\u001a\u0004\b\t\u0010\u0007R\u000e\u0010\n\u001a\u00020\u000bX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\f\u001a\u00020\u000bX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\r\u001a\u00020\u000eX\u0082\u0004¢\u0006\u0002\n\u0000\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u00066"}, d2 = {"Landroidx/compose/foundation/gestures/PressGestureScopeImpl;", "Landroidx/compose/foundation/gestures/PressGestureScope;", "Landroidx/compose/ui/unit/Density;", "density", "(Landroidx/compose/ui/unit/Density;)V", "", "getDensity", "()F", "fontScale", "getFontScale", "isCanceled", "", "isReleased", "mutex", "Lkotlinx/coroutines/sync/Mutex;", "awaitRelease", "", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "cancel", BuildConfig.BUILD_TYPE, "reset", "tryAwaitRelease", "roundToPx", "", "Landroidx/compose/ui/unit/Dp;", "roundToPx-0680j_4", "(F)I", "Landroidx/compose/ui/unit/TextUnit;", "roundToPx--R2X_6o", "(J)I", "toDp", "toDp-GaN1DYA", "(J)F", "toDp-u2uoSUM", "(F)F", "(I)F", "toDpSize", "Landroidx/compose/ui/unit/DpSize;", "Landroidx/compose/ui/geometry/Size;", "toDpSize-k-rfVVM", "(J)J", "toPx", "toPx-0680j_4", "toPx--R2X_6o", "toRect", "Landroidx/compose/ui/geometry/Rect;", "Landroidx/compose/ui/unit/DpRect;", "toSize", "toSize-XkaWNTQ", "toSp", "toSp-0xMU5do", "(F)J", "toSp-kPz2Gy4", "(I)J", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class PressGestureScopeImpl implements PressGestureScope, Density {
    public static final int $stable = 0;
    private final Density $$delegate_0;
    private boolean isCanceled;
    private boolean isReleased;
    private final Mutex mutex = MutexKt.Mutex(false);

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.gestures.PressGestureScopeImpl", f = "TapGestureDetector.kt", i = {}, l = {363}, m = "awaitRelease", n = {}, s = {})
    static final class C04761 extends ContinuationImpl {
        int label;
        Object result;

        C04761(Continuation<? super C04761> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return PressGestureScopeImpl.this.awaitRelease((Continuation) this);
        }
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.gestures.PressGestureScopeImpl", f = "TapGestureDetector.kt", i = {0}, l = {357}, m = "reset", n = {"this"}, s = {"L$0"})
    static final class C04771 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C04771(Continuation<? super C04771> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return PressGestureScopeImpl.this.reset((Continuation) this);
        }
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.gestures.PressGestureScopeImpl", f = "TapGestureDetector.kt", i = {0}, l = {370}, m = "tryAwaitRelease", n = {"this"}, s = {"L$0"})
    static final class C04781 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C04781(Continuation<? super C04781> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return PressGestureScopeImpl.this.tryAwaitRelease((Continuation) this);
        }
    }

    public float getDensity() {
        return this.$$delegate_0.getDensity();
    }

    public float getFontScale() {
        return this.$$delegate_0.getFontScale();
    }

    public int m802roundToPxR2X_6o(long j) {
        return this.$$delegate_0.roundToPx--R2X_6o(j);
    }

    public int m803roundToPx0680j_4(float f) {
        return this.$$delegate_0.roundToPx-0680j_4(f);
    }

    public float m804toDpGaN1DYA(long j) {
        return this.$$delegate_0.toDp-GaN1DYA(j);
    }

    public float m805toDpu2uoSUM(float f) {
        return this.$$delegate_0.toDp-u2uoSUM(f);
    }

    public float m806toDpu2uoSUM(int i) {
        return this.$$delegate_0.toDp-u2uoSUM(i);
    }

    public long m807toDpSizekrfVVM(long j) {
        return this.$$delegate_0.toDpSize-k-rfVVM(j);
    }

    public float m808toPxR2X_6o(long j) {
        return this.$$delegate_0.toPx--R2X_6o(j);
    }

    public float m809toPx0680j_4(float f) {
        return this.$$delegate_0.toPx-0680j_4(f);
    }

    public Rect toRect(DpRect dpRect) {
        return this.$$delegate_0.toRect(dpRect);
    }

    public long m810toSizeXkaWNTQ(long j) {
        return this.$$delegate_0.toSize-XkaWNTQ(j);
    }

    public long m811toSp0xMU5do(float f) {
        return this.$$delegate_0.toSp-0xMU5do(f);
    }

    public long m812toSpkPz2Gy4(float f) {
        return this.$$delegate_0.toSp-kPz2Gy4(f);
    }

    public long m813toSpkPz2Gy4(int i) {
        return this.$$delegate_0.toSp-kPz2Gy4(i);
    }

    public PressGestureScopeImpl(Density density) {
        this.$$delegate_0 = density;
    }

    public final void cancel() {
        this.isCanceled = true;
        Mutex.DefaultImpls.unlock$default(this.mutex, (Object) null, 1, (Object) null);
    }

    public final void release() {
        this.isReleased = true;
        Mutex.DefaultImpls.unlock$default(this.mutex, (Object) null, 1, (Object) null);
    }

    public final Object reset(Continuation<? super Unit> continuation) {
        C04771 c04771;
        PressGestureScopeImpl pressGestureScopeImpl;
        if (continuation instanceof C04771) {
            c04771 = (C04771) continuation;
            if ((c04771.label & Integer.MIN_VALUE) != 0) {
                c04771.label -= Integer.MIN_VALUE;
            } else {
                c04771 = new C04771(continuation);
            }
        } else {
            c04771 = new C04771(continuation);
        }
        Object obj = c04771.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c04771.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            Mutex mutex = this.mutex;
            c04771.L$0 = this;
            c04771.label = 1;
            if (Mutex.DefaultImpls.lock$default(mutex, (Object) null, c04771, 1, (Object) null) == coroutine_suspended) {
                return coroutine_suspended;
            }
            pressGestureScopeImpl = this;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            pressGestureScopeImpl = (PressGestureScopeImpl) c04771.L$0;
            ResultKt.throwOnFailure(obj);
        }
        pressGestureScopeImpl.isReleased = false;
        pressGestureScopeImpl.isCanceled = false;
        return Unit.INSTANCE;
    }

    @Override
    public Object awaitRelease(Continuation<? super Unit> continuation) {
        C04761 c04761;
        if (continuation instanceof C04761) {
            c04761 = (C04761) continuation;
            if ((c04761.label & Integer.MIN_VALUE) != 0) {
                c04761.label -= Integer.MIN_VALUE;
            } else {
                c04761 = new C04761(continuation);
            }
        } else {
            c04761 = new C04761(continuation);
        }
        Object objTryAwaitRelease = c04761.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c04761.label;
        if (i == 0) {
            ResultKt.throwOnFailure(objTryAwaitRelease);
            c04761.label = 1;
            objTryAwaitRelease = tryAwaitRelease(c04761);
            if (objTryAwaitRelease == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(objTryAwaitRelease);
        }
        if (!((Boolean) objTryAwaitRelease).booleanValue()) {
            throw new GestureCancellationException("The press gesture was canceled.");
        }
        return Unit.INSTANCE;
    }

    @Override
    public Object tryAwaitRelease(Continuation<? super Boolean> continuation) {
        C04781 c04781;
        PressGestureScopeImpl pressGestureScopeImpl;
        if (continuation instanceof C04781) {
            c04781 = (C04781) continuation;
            if ((c04781.label & Integer.MIN_VALUE) != 0) {
                c04781.label -= Integer.MIN_VALUE;
            } else {
                c04781 = new C04781(continuation);
            }
        } else {
            c04781 = new C04781(continuation);
        }
        Object obj = c04781.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c04781.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            if (this.isReleased || this.isCanceled) {
                pressGestureScopeImpl = this;
            } else {
                Mutex mutex = this.mutex;
                c04781.L$0 = this;
                c04781.label = 1;
                if (Mutex.DefaultImpls.lock$default(mutex, (Object) null, c04781, 1, (Object) null) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                pressGestureScopeImpl = this;
            }
            return Boxing.boxBoolean(pressGestureScopeImpl.isReleased);
        }
        if (i != 1) {
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
        pressGestureScopeImpl = (PressGestureScopeImpl) c04781.L$0;
        ResultKt.throwOnFailure(obj);
        Mutex.DefaultImpls.unlock$default(pressGestureScopeImpl.mutex, (Object) null, 1, (Object) null);
        return Boxing.boxBoolean(pressGestureScopeImpl.isReleased);
    }
}
