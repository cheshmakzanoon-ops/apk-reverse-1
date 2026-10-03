package androidx.compose.foundation;

import android.content.Context;
import android.os.Build;
import android.widget.EdgeEffect;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.geometry.OffsetKt;
import androidx.compose.p002ui.geometry.Size;
import androidx.compose.p002ui.geometry.SizeKt;
import androidx.compose.p002ui.graphics.ColorKt;
import androidx.compose.p002ui.input.nestedscroll.NestedScrollSource;
import androidx.compose.p002ui.input.pointer.PointerId;
import androidx.compose.p002ui.input.pointer.SuspendingPointerInputFilterKt;
import androidx.compose.p002ui.platform.InspectableValueKt;
import androidx.compose.p002ui.platform.InspectorInfo;
import androidx.compose.runtime.MutableState;
import androidx.compose.runtime.SnapshotStateKt;
import androidx.compose.ui.unit.IntSizeKt;
import androidx.compose.ui.unit.Velocity;
import androidx.compose.ui.unit.VelocityKt;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.math.MathKt;

@Metadata(d1 = {"\u0000z\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\b\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0010\u0007\n\u0002\b\u0012\b\u0000\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\b\u0010#\u001a\u00020\u001fH\u0002J?\u0010$\u001a\u00020\u001f2\u0006\u0010%\u001a\u00020&2\"\u0010'\u001a\u001e\b\u0001\u0012\u0004\u0012\u00020&\u0012\n\u0012\b\u0012\u0004\u0012\u00020&0)\u0012\u0006\u0012\u0004\u0018\u00010*0(H\u0096@ø\u0001\u0000¢\u0006\u0004\b+\u0010,J6\u0010-\u001a\u00020\u001c2\u0006\u0010.\u001a\u00020\u001c2\u0006\u0010/\u001a\u0002002\u0012\u00101\u001a\u000e\u0012\u0004\u0012\u00020\u001c\u0012\u0004\u0012\u00020\u001c02H\u0016ø\u0001\u0000¢\u0006\u0004\b3\u00104J\u0015\u00105\u001a\u00020\u001cH\u0000ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b6\u00107J\r\u00108\u001a\u00020\u001fH\u0000¢\u0006\u0002\b9J\u001a\u0010:\u001a\u00020;2\u0006\u0010<\u001a\u00020\u001cH\u0002ø\u0001\u0000¢\u0006\u0004\b=\u0010>J\u001a\u0010?\u001a\u00020;2\u0006\u0010<\u001a\u00020\u001cH\u0002ø\u0001\u0000¢\u0006\u0004\b@\u0010>J\u001a\u0010A\u001a\u00020;2\u0006\u0010<\u001a\u00020\u001cH\u0002ø\u0001\u0000¢\u0006\u0004\bB\u0010>J\u001a\u0010C\u001a\u00020;2\u0006\u0010<\u001a\u00020\u001cH\u0002ø\u0001\u0000¢\u0006\u0004\bD\u0010>J\u001a\u0010E\u001a\u00020\u00112\u0006\u0010.\u001a\u00020\u001cH\u0002ø\u0001\u0000¢\u0006\u0004\bF\u0010GJ\b\u0010H\u001a\u00020\u0011H\u0002J\u001a\u0010I\u001a\u00020\u001f2\u0006\u0010J\u001a\u00020\bH\u0000ø\u0001\u0000¢\u0006\u0004\bK\u0010LR\u0016\u0010\u0007\u001a\u00020\bX\u0082\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\n\u0002\u0010\tR\u000e\u0010\n\u001a\u00020\u000bX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\f\u001a\u00020\rX\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000fR$\u0010\u0010\u001a\u00020\u00118\u0000@\u0000X\u0081\u000e¢\u0006\u0014\n\u0000\u0012\u0004\b\u0012\u0010\u0013\u001a\u0004\b\u0014\u0010\u0015\"\u0004\b\u0016\u0010\u0017R\u0014\u0010\u0018\u001a\u00020\u00118VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u0018\u0010\u0015R\u0016\u0010\u0019\u001a\u0004\u0018\u00010\u001aX\u0082\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0002\n\u0000R\u0016\u0010\u001b\u001a\u0004\u0018\u00010\u001cX\u0082\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0002\n\u0000R\u001a\u0010\u001d\u001a\b\u0012\u0004\u0012\u00020\u001f0\u001eX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b \u0010!R\u000e\u0010\"\u001a\u00020\u0011X\u0082\u000e¢\u0006\u0002\n\u0000\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006M"}, d2 = {"Landroidx/compose/foundation/AndroidEdgeEffectOverscrollEffect;", "Landroidx/compose/foundation/OverscrollEffect;", "context", "Landroid/content/Context;", "overscrollConfig", "Landroidx/compose/foundation/OverscrollConfiguration;", "(Landroid/content/Context;Landroidx/compose/foundation/OverscrollConfiguration;)V", "containerSize", "Landroidx/compose/ui/geometry/Size;", "J", "edgeEffectWrapper", "Landroidx/compose/foundation/EdgeEffectWrapper;", "effectModifier", "Landroidx/compose/ui/Modifier;", "getEffectModifier", "()Landroidx/compose/ui/Modifier;", "invalidationEnabled", "", "getInvalidationEnabled$foundation_release$annotations", "()V", "getInvalidationEnabled$foundation_release", "()Z", "setInvalidationEnabled$foundation_release", "(Z)V", "isInProgress", "pointerId", "Landroidx/compose/ui/input/pointer/PointerId;", "pointerPosition", "Landroidx/compose/ui/geometry/Offset;", "redrawSignal", "Landroidx/compose/runtime/MutableState;", "", "getRedrawSignal$foundation_release", "()Landroidx/compose/runtime/MutableState;", "scrollCycleInProgress", "animateToRelease", "applyToFling", "velocity", "Landroidx/compose/ui/unit/Velocity;", "performFling", "Lkotlin/Function2;", "Lkotlin/coroutines/Continuation;", "", "applyToFling-BMRW4eQ", "(JLkotlin/jvm/functions/Function2;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "applyToScroll", "delta", "source", "Landroidx/compose/ui/input/nestedscroll/NestedScrollSource;", "performScroll", "Lkotlin/Function1;", "applyToScroll-Rhakbz0", "(JILkotlin/jvm/functions/Function1;)J", "displacement", "displacement-F1C5BW0$foundation_release", "()J", "invalidateOverscroll", "invalidateOverscroll$foundation_release", "pullBottom", "", "scroll", "pullBottom-k-4lQ0M", "(J)F", "pullLeft", "pullLeft-k-4lQ0M", "pullRight", "pullRight-k-4lQ0M", "pullTop", "pullTop-k-4lQ0M", "releaseOppositeOverscroll", "releaseOppositeOverscroll-k-4lQ0M", "(J)Z", "stopOverscrollAnimation", "updateSize", "size", "updateSize-uvyYCjk$foundation_release", "(J)V", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class AndroidEdgeEffectOverscrollEffect implements OverscrollEffect {
    public static final int $stable = 0;
    private long containerSize;
    private final EdgeEffectWrapper edgeEffectWrapper;
    private final Modifier effectModifier;
    private boolean invalidationEnabled;
    private PointerId pointerId;
    private Offset pointerPosition;
    private final MutableState<Unit> redrawSignal;
    private boolean scrollCycleInProgress;

    public static void getInvalidationEnabled$foundation_release$annotations() {
    }

    public AndroidEdgeEffectOverscrollEffect(Context context, OverscrollConfiguration overscrollConfiguration) {
        Modifier drawGlowOverscrollModifier;
        EdgeEffectWrapper edgeEffectWrapper = new EdgeEffectWrapper(context, ColorKt.m4644toArgb8_81llA(overscrollConfiguration.getGlowColor()));
        this.edgeEffectWrapper = edgeEffectWrapper;
        this.redrawSignal = SnapshotStateKt.mutableStateOf(Unit.INSTANCE, SnapshotStateKt.neverEqualPolicy());
        this.invalidationEnabled = true;
        this.containerSize = Size.INSTANCE.m4424getZeroNHjbRc();
        Modifier modifierPointerInput = SuspendingPointerInputFilterKt.pointerInput(Modifier.INSTANCE, Unit.INSTANCE, new AndroidEdgeEffectOverscrollEffect$effectModifier$1(this, null));
        if (Build.VERSION.SDK_INT >= 31) {
            drawGlowOverscrollModifier = new DrawStretchOverscrollModifier(this, edgeEffectWrapper, InspectableValueKt.isDebugInspectorInfoEnabled() ? new Function1<InspectorInfo, Unit>() {
                {
                    super(1);
                }

                public Object invoke(Object obj) {
                    invoke((InspectorInfo) obj);
                    return Unit.INSTANCE;
                }

                public final void invoke(InspectorInfo inspectorInfo) {
                    inspectorInfo.setName("overscroll");
                    inspectorInfo.setValue(this.this$0);
                }
            } : InspectableValueKt.getNoInspectorInfo());
        } else {
            drawGlowOverscrollModifier = new DrawGlowOverscrollModifier(this, edgeEffectWrapper, overscrollConfiguration, InspectableValueKt.isDebugInspectorInfoEnabled() ? new Function1<InspectorInfo, Unit>() {
                {
                    super(1);
                }

                public Object invoke(Object obj) {
                    invoke((InspectorInfo) obj);
                    return Unit.INSTANCE;
                }

                public final void invoke(InspectorInfo inspectorInfo) {
                    inspectorInfo.setName("overscroll");
                    inspectorInfo.setValue(this.this$0);
                }
            } : InspectableValueKt.getNoInspectorInfo());
        }
        this.effectModifier = modifierPointerInput.then(drawGlowOverscrollModifier);
    }

    public final MutableState<Unit> getRedrawSignal$foundation_release() {
        return this.redrawSignal;
    }

    public final boolean getInvalidationEnabled() {
        return this.invalidationEnabled;
    }

    public final void setInvalidationEnabled$foundation_release(boolean z) {
        this.invalidationEnabled = z;
    }

    @Override
    public long mo501applyToScrollRhakbz0(long delta, int source, Function1<? super Offset, Offset> performScroll) {
        float fM495pullBottomk4lQ0M;
        boolean z;
        boolean z2;
        if (Size.m4417isEmptyimpl(this.containerSize)) {
            return ((Offset) performScroll.invoke(Offset.m4335boximpl(delta))).getPackedValue();
        }
        boolean z3 = true;
        if (!this.scrollCycleInProgress) {
            stopOverscrollAnimation();
            this.scrollCycleInProgress = true;
        }
        float fM497pullRightk4lQ0M = 0.0f;
        if (Offset.m4347getYimpl(delta) == 0.0f) {
            fM495pullBottomk4lQ0M = 0.0f;
        } else if (this.edgeEffectWrapper.isTopStretched()) {
            fM495pullBottomk4lQ0M = m498pullTopk4lQ0M(delta);
            if (!this.edgeEffectWrapper.isTopStretched()) {
                this.edgeEffectWrapper.getOrCreateTopEffect().onRelease();
            }
        } else if (this.edgeEffectWrapper.isBottomStretched()) {
            fM495pullBottomk4lQ0M = m495pullBottomk4lQ0M(delta);
            if (!this.edgeEffectWrapper.isBottomStretched()) {
                this.edgeEffectWrapper.getOrCreateBottomEffect().onRelease();
            }
        } else {
            fM495pullBottomk4lQ0M = 0.0f;
        }
        if (Offset.m4346getXimpl(delta) != 0.0f) {
            if (this.edgeEffectWrapper.isLeftStretched()) {
                fM497pullRightk4lQ0M = m496pullLeftk4lQ0M(delta);
                if (!this.edgeEffectWrapper.isLeftStretched()) {
                    this.edgeEffectWrapper.getOrCreateLeftEffect().onRelease();
                }
            } else if (this.edgeEffectWrapper.isRightStretched()) {
                fM497pullRightk4lQ0M = m497pullRightk4lQ0M(delta);
                if (!this.edgeEffectWrapper.isRightStretched()) {
                    this.edgeEffectWrapper.getOrCreateRightEffect().onRelease();
                }
            }
        }
        long jOffset = OffsetKt.Offset(fM497pullRightk4lQ0M, fM495pullBottomk4lQ0M);
        if (!Offset.m4343equalsimpl0(jOffset, Offset.INSTANCE.m4362getZeroF1C5BW0())) {
            invalidateOverscroll$foundation_release();
        }
        long jM4350minusMKHz9U = Offset.m4350minusMKHz9U(delta, jOffset);
        long packedValue = ((Offset) performScroll.invoke(Offset.m4335boximpl(jM4350minusMKHz9U))).getPackedValue();
        long jM4350minusMKHz9U2 = Offset.m4350minusMKHz9U(jM4350minusMKHz9U, packedValue);
        boolean z4 = false;
        if (NestedScrollSource.m5728equalsimpl0(source, NestedScrollSource.INSTANCE.m5740getUserInputWNlRxjI())) {
            if (Offset.m4346getXimpl(jM4350minusMKHz9U2) > 0.5f) {
                m496pullLeftk4lQ0M(jM4350minusMKHz9U2);
            } else {
                if (Offset.m4346getXimpl(jM4350minusMKHz9U2) < -0.5f) {
                    m497pullRightk4lQ0M(jM4350minusMKHz9U2);
                } else {
                    z = false;
                }
                if (Offset.m4347getYimpl(jM4350minusMKHz9U2) > 0.5f) {
                    m498pullTopk4lQ0M(jM4350minusMKHz9U2);
                } else {
                    if (Offset.m4347getYimpl(jM4350minusMKHz9U2) < -0.5f) {
                        m495pullBottomk4lQ0M(jM4350minusMKHz9U2);
                    } else {
                        z2 = false;
                    }
                    if (!z && !z2) {
                        z3 = false;
                    }
                    z4 = z3;
                }
                z2 = true;
                if (!z) {
                    z3 = false;
                }
                z4 = z3;
            }
            z = true;
            if (Offset.m4347getYimpl(jM4350minusMKHz9U2) > 0.5f) {
                m498pullTopk4lQ0M(jM4350minusMKHz9U2);
            } else {
                if (Offset.m4347getYimpl(jM4350minusMKHz9U2) < -0.5f) {
                    m495pullBottomk4lQ0M(jM4350minusMKHz9U2);
                } else {
                    z2 = false;
                }
                if (!z) {
                    z3 = false;
                }
                z4 = z3;
            }
            z2 = true;
            if (!z) {
                z3 = false;
            }
            z4 = z3;
        }
        if (m499releaseOppositeOverscrollk4lQ0M(delta) || z4) {
            invalidateOverscroll$foundation_release();
        }
        return Offset.m4351plusMKHz9U(jOffset, packedValue);
    }

    @Override
    public Object mo500applyToFlingBMRW4eQ(long j, Function2<? super Velocity, ? super Continuation<? super Velocity>, ? extends Object> function2, Continuation<? super Unit> continuation) {
        AndroidEdgeEffectOverscrollEffect$applyToFling$1 androidEdgeEffectOverscrollEffect$applyToFling$1;
        float f;
        float f2;
        long j2;
        AndroidEdgeEffectOverscrollEffect androidEdgeEffectOverscrollEffect;
        long j3;
        if (continuation instanceof AndroidEdgeEffectOverscrollEffect$applyToFling$1) {
            androidEdgeEffectOverscrollEffect$applyToFling$1 = (AndroidEdgeEffectOverscrollEffect$applyToFling$1) continuation;
            if ((androidEdgeEffectOverscrollEffect$applyToFling$1.label & Integer.MIN_VALUE) != 0) {
                androidEdgeEffectOverscrollEffect$applyToFling$1.label -= Integer.MIN_VALUE;
            } else {
                androidEdgeEffectOverscrollEffect$applyToFling$1 = new AndroidEdgeEffectOverscrollEffect$applyToFling$1(this, continuation);
            }
        } else {
            androidEdgeEffectOverscrollEffect$applyToFling$1 = new AndroidEdgeEffectOverscrollEffect$applyToFling$1(this, continuation);
        }
        Object objInvoke = androidEdgeEffectOverscrollEffect$applyToFling$1.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = androidEdgeEffectOverscrollEffect$applyToFling$1.label;
        if (i != 0) {
            if (i == 1) {
                ResultKt.throwOnFailure(objInvoke);
                return Unit.INSTANCE;
            }
            if (i != 2) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            j2 = androidEdgeEffectOverscrollEffect$applyToFling$1.J$0;
            androidEdgeEffectOverscrollEffect = (AndroidEdgeEffectOverscrollEffect) androidEdgeEffectOverscrollEffect$applyToFling$1.L$0;
            ResultKt.throwOnFailure(objInvoke);
            j3 = Velocity.minus-AH228Gc(j2, ((Velocity) objInvoke).unbox-impl());
            androidEdgeEffectOverscrollEffect.scrollCycleInProgress = false;
            if (Velocity.getX-impl(j3) > 0.0f) {
                EdgeEffectCompat.INSTANCE.onAbsorbCompat(androidEdgeEffectOverscrollEffect.edgeEffectWrapper.getOrCreateLeftEffect(), MathKt.roundToInt(Velocity.getX-impl(j3)));
            } else if (Velocity.getX-impl(j3) < 0.0f) {
                EdgeEffectCompat.INSTANCE.onAbsorbCompat(androidEdgeEffectOverscrollEffect.edgeEffectWrapper.getOrCreateRightEffect(), -MathKt.roundToInt(Velocity.getX-impl(j3)));
            }
            if (Velocity.getY-impl(j3) > 0.0f) {
                EdgeEffectCompat.INSTANCE.onAbsorbCompat(androidEdgeEffectOverscrollEffect.edgeEffectWrapper.getOrCreateTopEffect(), MathKt.roundToInt(Velocity.getY-impl(j3)));
            } else if (Velocity.getY-impl(j3) < 0.0f) {
                EdgeEffectCompat.INSTANCE.onAbsorbCompat(androidEdgeEffectOverscrollEffect.edgeEffectWrapper.getOrCreateBottomEffect(), -MathKt.roundToInt(Velocity.getY-impl(j3)));
            }
            if (!Velocity.equals-impl0(j3, Velocity.Companion.getZero-9UxMQ8M())) {
                androidEdgeEffectOverscrollEffect.invalidateOverscroll$foundation_release();
            }
            androidEdgeEffectOverscrollEffect.animateToRelease();
            return Unit.INSTANCE;
        }
        ResultKt.throwOnFailure(objInvoke);
        if (Size.m4417isEmptyimpl(this.containerSize)) {
            Velocity velocity = Velocity.box-impl(j);
            androidEdgeEffectOverscrollEffect$applyToFling$1.label = 1;
            if (function2.invoke(velocity, androidEdgeEffectOverscrollEffect$applyToFling$1) == coroutine_suspended) {
                return coroutine_suspended;
            }
            return Unit.INSTANCE;
        }
        if (Velocity.getX-impl(j) > 0.0f && this.edgeEffectWrapper.isLeftStretched()) {
            EdgeEffectCompat.INSTANCE.onAbsorbCompat(this.edgeEffectWrapper.getOrCreateLeftEffect(), MathKt.roundToInt(Velocity.getX-impl(j)));
            f = Velocity.getX-impl(j);
        } else if (Velocity.getX-impl(j) >= 0.0f || !this.edgeEffectWrapper.isRightStretched()) {
            f = 0.0f;
        } else {
            EdgeEffectCompat.INSTANCE.onAbsorbCompat(this.edgeEffectWrapper.getOrCreateRightEffect(), -MathKt.roundToInt(Velocity.getX-impl(j)));
            f = Velocity.getX-impl(j);
        }
        if (Velocity.getY-impl(j) > 0.0f && this.edgeEffectWrapper.isTopStretched()) {
            EdgeEffectCompat.INSTANCE.onAbsorbCompat(this.edgeEffectWrapper.getOrCreateTopEffect(), MathKt.roundToInt(Velocity.getY-impl(j)));
            f2 = Velocity.getY-impl(j);
        } else if (Velocity.getY-impl(j) >= 0.0f || !this.edgeEffectWrapper.isBottomStretched()) {
            f2 = 0.0f;
        } else {
            EdgeEffectCompat.INSTANCE.onAbsorbCompat(this.edgeEffectWrapper.getOrCreateBottomEffect(), -MathKt.roundToInt(Velocity.getY-impl(j)));
            f2 = Velocity.getY-impl(j);
        }
        long jVelocity = VelocityKt.Velocity(f, f2);
        if (!Velocity.equals-impl0(jVelocity, Velocity.Companion.getZero-9UxMQ8M())) {
            invalidateOverscroll$foundation_release();
        }
        j2 = Velocity.minus-AH228Gc(j, jVelocity);
        Velocity velocity2 = Velocity.box-impl(j2);
        androidEdgeEffectOverscrollEffect$applyToFling$1.L$0 = this;
        androidEdgeEffectOverscrollEffect$applyToFling$1.J$0 = j2;
        androidEdgeEffectOverscrollEffect$applyToFling$1.label = 2;
        objInvoke = function2.invoke(velocity2, androidEdgeEffectOverscrollEffect$applyToFling$1);
        if (objInvoke == coroutine_suspended) {
            return coroutine_suspended;
        }
        androidEdgeEffectOverscrollEffect = this;
        j3 = Velocity.minus-AH228Gc(j2, ((Velocity) objInvoke).unbox-impl());
        androidEdgeEffectOverscrollEffect.scrollCycleInProgress = false;
        if (Velocity.getX-impl(j3) > 0.0f) {
            EdgeEffectCompat.INSTANCE.onAbsorbCompat(androidEdgeEffectOverscrollEffect.edgeEffectWrapper.getOrCreateLeftEffect(), MathKt.roundToInt(Velocity.getX-impl(j3)));
        } else if (Velocity.getX-impl(j3) < 0.0f) {
            EdgeEffectCompat.INSTANCE.onAbsorbCompat(androidEdgeEffectOverscrollEffect.edgeEffectWrapper.getOrCreateRightEffect(), -MathKt.roundToInt(Velocity.getX-impl(j3)));
        }
        if (Velocity.getY-impl(j3) > 0.0f) {
            EdgeEffectCompat.INSTANCE.onAbsorbCompat(androidEdgeEffectOverscrollEffect.edgeEffectWrapper.getOrCreateTopEffect(), MathKt.roundToInt(Velocity.getY-impl(j3)));
        } else if (Velocity.getY-impl(j3) < 0.0f) {
            EdgeEffectCompat.INSTANCE.onAbsorbCompat(androidEdgeEffectOverscrollEffect.edgeEffectWrapper.getOrCreateBottomEffect(), -MathKt.roundToInt(Velocity.getY-impl(j3)));
        }
        if (!Velocity.equals-impl0(j3, Velocity.Companion.getZero-9UxMQ8M())) {
            androidEdgeEffectOverscrollEffect.invalidateOverscroll$foundation_release();
        }
        androidEdgeEffectOverscrollEffect.animateToRelease();
        return Unit.INSTANCE;
    }

    @Override
    public boolean isInProgress() {
        EdgeEffectWrapper edgeEffectWrapper = this.edgeEffectWrapper;
        EdgeEffect edgeEffect = edgeEffectWrapper.topEffect;
        if (edgeEffect != null && EdgeEffectCompat.INSTANCE.getDistanceCompat(edgeEffect) != 0.0f) {
            return true;
        }
        EdgeEffect edgeEffect2 = edgeEffectWrapper.bottomEffect;
        if (edgeEffect2 != null && EdgeEffectCompat.INSTANCE.getDistanceCompat(edgeEffect2) != 0.0f) {
            return true;
        }
        EdgeEffect edgeEffect3 = edgeEffectWrapper.leftEffect;
        if (edgeEffect3 != null && EdgeEffectCompat.INSTANCE.getDistanceCompat(edgeEffect3) != 0.0f) {
            return true;
        }
        EdgeEffect edgeEffect4 = edgeEffectWrapper.rightEffect;
        return (edgeEffect4 == null || EdgeEffectCompat.INSTANCE.getDistanceCompat(edgeEffect4) == 0.0f) ? false : true;
    }

    private final boolean stopOverscrollAnimation() {
        boolean z;
        if (this.edgeEffectWrapper.isLeftStretched()) {
            m496pullLeftk4lQ0M(Offset.INSTANCE.m4362getZeroF1C5BW0());
            z = true;
        } else {
            z = false;
        }
        if (this.edgeEffectWrapper.isRightStretched()) {
            m497pullRightk4lQ0M(Offset.INSTANCE.m4362getZeroF1C5BW0());
            z = true;
        }
        if (this.edgeEffectWrapper.isTopStretched()) {
            m498pullTopk4lQ0M(Offset.INSTANCE.m4362getZeroF1C5BW0());
            z = true;
        }
        if (!this.edgeEffectWrapper.isBottomStretched()) {
            return z;
        }
        m495pullBottomk4lQ0M(Offset.INSTANCE.m4362getZeroF1C5BW0());
        return true;
    }

    public final void m503updateSizeuvyYCjk$foundation_release(long size) {
        boolean zM4411equalsimpl0 = Size.m4411equalsimpl0(this.containerSize, Size.INSTANCE.m4424getZeroNHjbRc());
        boolean zM4411equalsimpl1 = Size.m4411equalsimpl0(size, this.containerSize);
        this.containerSize = size;
        if (!zM4411equalsimpl1) {
            this.edgeEffectWrapper.m580setSizeozmzZPI(IntSizeKt.IntSize(MathKt.roundToInt(Size.m4415getWidthimpl(size)), MathKt.roundToInt(Size.m4412getHeightimpl(size))));
        }
        if (zM4411equalsimpl0 || zM4411equalsimpl1) {
            return;
        }
        invalidateOverscroll$foundation_release();
        animateToRelease();
    }

    public final long m502displacementF1C5BW0$foundation_release() {
        Offset offset = this.pointerPosition;
        long packedValue = offset != null ? offset.getPackedValue() : SizeKt.m4425getCenteruvyYCjk(this.containerSize);
        return OffsetKt.Offset(Offset.m4346getXimpl(packedValue) / Size.m4415getWidthimpl(this.containerSize), Offset.m4347getYimpl(packedValue) / Size.m4412getHeightimpl(this.containerSize));
    }

    @Override
    public Modifier getEffectModifier() {
        return this.effectModifier;
    }

    public final void invalidateOverscroll$foundation_release() {
        if (this.invalidationEnabled) {
            this.redrawSignal.setValue(Unit.INSTANCE);
        }
    }

    private final void animateToRelease() {
        boolean zIsFinished;
        EdgeEffectWrapper edgeEffectWrapper = this.edgeEffectWrapper;
        EdgeEffect edgeEffect = edgeEffectWrapper.topEffect;
        if (edgeEffect != null) {
            edgeEffect.onRelease();
            zIsFinished = edgeEffect.isFinished();
        } else {
            zIsFinished = false;
        }
        EdgeEffect edgeEffect2 = edgeEffectWrapper.bottomEffect;
        if (edgeEffect2 != null) {
            edgeEffect2.onRelease();
            zIsFinished = edgeEffect2.isFinished() || zIsFinished;
        }
        EdgeEffect edgeEffect3 = edgeEffectWrapper.leftEffect;
        if (edgeEffect3 != null) {
            edgeEffect3.onRelease();
            zIsFinished = edgeEffect3.isFinished() || zIsFinished;
        }
        EdgeEffect edgeEffect4 = edgeEffectWrapper.rightEffect;
        if (edgeEffect4 != null) {
            edgeEffect4.onRelease();
            zIsFinished = edgeEffect4.isFinished() || zIsFinished;
        }
        if (zIsFinished) {
            invalidateOverscroll$foundation_release();
        }
    }

    private final boolean m499releaseOppositeOverscrollk4lQ0M(long delta) {
        boolean z;
        boolean z2 = true;
        if (!this.edgeEffectWrapper.isLeftAnimating() || Offset.m4346getXimpl(delta) >= 0.0f) {
            z = false;
        } else {
            EdgeEffectCompat.INSTANCE.onReleaseWithOppositeDelta(this.edgeEffectWrapper.getOrCreateLeftEffect(), Offset.m4346getXimpl(delta));
            z = !this.edgeEffectWrapper.isLeftAnimating();
        }
        if (this.edgeEffectWrapper.isRightAnimating() && Offset.m4346getXimpl(delta) > 0.0f) {
            EdgeEffectCompat.INSTANCE.onReleaseWithOppositeDelta(this.edgeEffectWrapper.getOrCreateRightEffect(), Offset.m4346getXimpl(delta));
            z = z || !this.edgeEffectWrapper.isRightAnimating();
        }
        if (this.edgeEffectWrapper.isTopAnimating() && Offset.m4347getYimpl(delta) < 0.0f) {
            EdgeEffectCompat.INSTANCE.onReleaseWithOppositeDelta(this.edgeEffectWrapper.getOrCreateTopEffect(), Offset.m4347getYimpl(delta));
            z = z || !this.edgeEffectWrapper.isTopAnimating();
        }
        if (!this.edgeEffectWrapper.isBottomAnimating() || Offset.m4347getYimpl(delta) <= 0.0f) {
            return z;
        }
        EdgeEffectCompat.INSTANCE.onReleaseWithOppositeDelta(this.edgeEffectWrapper.getOrCreateBottomEffect(), Offset.m4347getYimpl(delta));
        if (!z && this.edgeEffectWrapper.isBottomAnimating()) {
            z2 = false;
        }
        return z2;
    }

    private final float m498pullTopk4lQ0M(long scroll) {
        float fM4346getXimpl = Offset.m4346getXimpl(m502displacementF1C5BW0$foundation_release());
        float fM4347getYimpl = Offset.m4347getYimpl(scroll) / Size.m4412getHeightimpl(this.containerSize);
        EdgeEffect orCreateTopEffect = this.edgeEffectWrapper.getOrCreateTopEffect();
        return EdgeEffectCompat.INSTANCE.getDistanceCompat(orCreateTopEffect) == 0.0f ? EdgeEffectCompat.INSTANCE.onPullDistanceCompat(orCreateTopEffect, fM4347getYimpl, fM4346getXimpl) * Size.m4412getHeightimpl(this.containerSize) : Offset.m4347getYimpl(scroll);
    }

    private final float m495pullBottomk4lQ0M(long scroll) {
        float fM4346getXimpl = Offset.m4346getXimpl(m502displacementF1C5BW0$foundation_release());
        float fM4347getYimpl = Offset.m4347getYimpl(scroll) / Size.m4412getHeightimpl(this.containerSize);
        EdgeEffect orCreateBottomEffect = this.edgeEffectWrapper.getOrCreateBottomEffect();
        return EdgeEffectCompat.INSTANCE.getDistanceCompat(orCreateBottomEffect) == 0.0f ? (-EdgeEffectCompat.INSTANCE.onPullDistanceCompat(orCreateBottomEffect, -fM4347getYimpl, 1 - fM4346getXimpl)) * Size.m4412getHeightimpl(this.containerSize) : Offset.m4347getYimpl(scroll);
    }

    private final float m496pullLeftk4lQ0M(long scroll) {
        float fM4347getYimpl = Offset.m4347getYimpl(m502displacementF1C5BW0$foundation_release());
        float fM4346getXimpl = Offset.m4346getXimpl(scroll) / Size.m4415getWidthimpl(this.containerSize);
        EdgeEffect orCreateLeftEffect = this.edgeEffectWrapper.getOrCreateLeftEffect();
        return EdgeEffectCompat.INSTANCE.getDistanceCompat(orCreateLeftEffect) == 0.0f ? EdgeEffectCompat.INSTANCE.onPullDistanceCompat(orCreateLeftEffect, fM4346getXimpl, 1 - fM4347getYimpl) * Size.m4415getWidthimpl(this.containerSize) : Offset.m4346getXimpl(scroll);
    }

    private final float m497pullRightk4lQ0M(long scroll) {
        float fM4347getYimpl = Offset.m4347getYimpl(m502displacementF1C5BW0$foundation_release());
        float fM4346getXimpl = Offset.m4346getXimpl(scroll) / Size.m4415getWidthimpl(this.containerSize);
        EdgeEffect orCreateRightEffect = this.edgeEffectWrapper.getOrCreateRightEffect();
        return EdgeEffectCompat.INSTANCE.getDistanceCompat(orCreateRightEffect) == 0.0f ? (-EdgeEffectCompat.INSTANCE.onPullDistanceCompat(orCreateRightEffect, -fM4346getXimpl, fM4347getYimpl)) * Size.m4415getWidthimpl(this.containerSize) : Offset.m4346getXimpl(scroll);
    }
}
