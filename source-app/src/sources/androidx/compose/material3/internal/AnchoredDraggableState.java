package androidx.compose.material3.internal;

import androidx.autofill.HintConstants;
import androidx.compose.animation.core.AnimationSpec;
import androidx.compose.foundation.MutatePriority;
import androidx.compose.foundation.gestures.DraggableState;
import androidx.compose.runtime.MutableFloatState;
import androidx.compose.runtime.MutableState;
import androidx.compose.runtime.PrimitiveSnapshotStateKt;
import androidx.compose.runtime.SnapshotStateKt;
import androidx.compose.runtime.SnapshotStateKt__SnapshotStateKt;
import androidx.compose.runtime.State;
import androidx.compose.runtime.saveable.Saver;
import androidx.compose.runtime.saveable.SaverKt;
import androidx.compose.runtime.saveable.SaverScope;
import kotlin.Metadata;
import kotlin.Pair;
import kotlin.ResultKt;
import kotlin.TuplesKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.functions.Function4;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.ranges.RangesKt;

@Metadata(d1 = {"\u0000t\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0007\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0016\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0019\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0015\b\u0001\u0018\u0000 i*\u0004\b\u0000\u0010\u00012\u00020\u0002:\u0001iB\u0081\u0001\b\u0016\u0012\u0006\u0010\u0003\u001a\u00028\u0000\u0012\f\u0010\u0004\u001a\b\u0012\u0004\u0012\u00028\u00000\u0005\u0012!\u0010\u0006\u001a\u001d\u0012\u0013\u0012\u00110\b¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\u000b\u0012\u0004\u0012\u00020\b0\u0007\u0012\f\u0010\f\u001a\b\u0012\u0004\u0012\u00020\b0\r\u0012\f\u0010\u000e\u001a\b\u0012\u0004\u0012\u00020\b0\u000f\u0012#\b\u0002\u0010\u0010\u001a\u001d\u0012\u0013\u0012\u00118\u0000¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\u0011\u0012\u0004\u0012\u00020\u00120\u0007¢\u0006\u0002\u0010\u0013Bq\u0012\u0006\u0010\u0003\u001a\u00028\u0000\u0012!\u0010\u0006\u001a\u001d\u0012\u0013\u0012\u00110\b¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\u000b\u0012\u0004\u0012\u00020\b0\u0007\u0012\f\u0010\f\u001a\b\u0012\u0004\u0012\u00020\b0\r\u0012\f\u0010\u000e\u001a\b\u0012\u0004\u0012\u00020\b0\u000f\u0012#\b\u0002\u0010\u0010\u001a\u001d\u0012\u0013\u0012\u00118\u0000¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\u0011\u0012\u0004\u0012\u00020\u00120\u0007¢\u0006\u0002\u0010\u0014Jy\u0010L\u001a\u00020M2\u0006\u0010G\u001a\u00028\u00002\b\b\u0002\u0010N\u001a\u00020O2W\u0010P\u001aS\b\u0001\u0012\u0004\u0012\u00020\u0016\u0012\u0019\u0012\u0017\u0012\u0004\u0012\u00028\u00000\u0005¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\u0004\u0012\u0013\u0012\u00118\u0000¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(G\u0012\n\u0012\b\u0012\u0004\u0012\u00020M0R\u0012\u0006\u0012\u0004\u0018\u00010\u00020Q¢\u0006\u0002\bSH\u0086@¢\u0006\u0002\u0010TJ\\\u0010L\u001a\u00020M2\b\b\u0002\u0010N\u001a\u00020O2B\u0010P\u001a>\b\u0001\u0012\u0004\u0012\u00020\u0016\u0012\u0019\u0012\u0017\u0012\u0004\u0012\u00028\u00000\u0005¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\u0004\u0012\n\u0012\b\u0012\u0004\u0012\u00020M0R\u0012\u0006\u0012\u0004\u0018\u00010\u00020U¢\u0006\u0002\bSH\u0086@¢\u0006\u0002\u0010VJ%\u0010W\u001a\u00028\u00002\u0006\u0010?\u001a\u00020\b2\u0006\u0010'\u001a\u00028\u00002\u0006\u0010X\u001a\u00020\bH\u0002¢\u0006\u0002\u0010YJ\u001d\u0010Z\u001a\u00028\u00002\u0006\u0010?\u001a\u00020\b2\u0006\u0010'\u001a\u00028\u0000H\u0002¢\u0006\u0002\u0010[J\u000e\u0010\\\u001a\u00020\b2\u0006\u0010]\u001a\u00020\bJ\u0015\u0010^\u001a\u00020\b2\u0006\u0010]\u001a\u00020\bH\u0000¢\u0006\u0002\b_J\u0006\u0010`\u001a\u00020\bJ\u0016\u0010a\u001a\u00020M2\u0006\u0010X\u001a\u00020\bH\u0086@¢\u0006\u0002\u0010bJ\u0015\u0010c\u001a\u00020\u00122\u0006\u0010G\u001a\u00028\u0000H\u0002¢\u0006\u0002\u0010dJ#\u0010e\u001a\u00020M2\f\u0010f\u001a\b\u0012\u0004\u0012\u00028\u00000\u00052\b\b\u0002\u0010g\u001a\u00028\u0000¢\u0006\u0002\u0010hR\u000e\u0010\u0015\u001a\u00020\u0016X\u0082\u0004¢\u0006\u0002\n\u0000R7\u0010\u0004\u001a\b\u0012\u0004\u0012\u00028\u00000\u00052\f\u0010\u0017\u001a\b\u0012\u0004\u0012\u00028\u00000\u00058F@BX\u0086\u008e\u0002¢\u0006\u0012\n\u0004\b\u001c\u0010\u001d\u001a\u0004\b\u0018\u0010\u0019\"\u0004\b\u001a\u0010\u001bR\u0017\u0010\u000e\u001a\b\u0012\u0004\u0012\u00020\b0\u000f¢\u0006\b\n\u0000\u001a\u0004\b\u001e\u0010\u001fR\u001b\u0010 \u001a\u00028\u00008@X\u0080\u0084\u0002¢\u0006\f\n\u0004\b#\u0010$\u001a\u0004\b!\u0010\"R/\u0010\u0010\u001a\u001d\u0012\u0013\u0012\u00118\u0000¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\u0011\u0012\u0004\u0012\u00020\u00120\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b%\u0010&R+\u0010'\u001a\u00028\u00002\u0006\u0010\u0017\u001a\u00028\u00008F@BX\u0086\u008e\u0002¢\u0006\u0012\n\u0004\b+\u0010\u001d\u001a\u0004\b(\u0010\"\"\u0004\b)\u0010*R\u000e\u0010,\u001a\u00020-X\u0082\u0004¢\u0006\u0002\n\u0000R/\u0010.\u001a\u0004\u0018\u00018\u00002\b\u0010\u0017\u001a\u0004\u0018\u00018\u00008B@BX\u0082\u008e\u0002¢\u0006\u0012\n\u0004\b1\u0010\u001d\u001a\u0004\b/\u0010\"\"\u0004\b0\u0010*R\u0014\u00102\u001a\u000203X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b4\u00105R\u0011\u00106\u001a\u00020\u00128F¢\u0006\u0006\u001a\u0004\b6\u00107R+\u00108\u001a\u00020\b2\u0006\u0010\u0017\u001a\u00020\b8F@BX\u0086\u008e\u0002¢\u0006\u0012\n\u0004\b=\u0010>\u001a\u0004\b9\u0010:\"\u0004\b;\u0010<R+\u0010?\u001a\u00020\b2\u0006\u0010\u0017\u001a\u00020\b8F@BX\u0086\u008e\u0002¢\u0006\u0012\n\u0004\bB\u0010>\u001a\u0004\b@\u0010:\"\u0004\bA\u0010<R/\u0010\u0006\u001a\u001d\u0012\u0013\u0012\u00110\b¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\u000b\u0012\u0004\u0012\u00020\b0\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\bC\u0010&R\u001b\u0010D\u001a\u00020\b8GX\u0086\u0084\u0002¢\u0006\f\n\u0004\bF\u0010$\u001a\u0004\bE\u0010:R\u001b\u0010G\u001a\u00028\u00008FX\u0086\u0084\u0002¢\u0006\f\n\u0004\bI\u0010$\u001a\u0004\bH\u0010\"R\u001a\u0010\f\u001a\b\u0012\u0004\u0012\u00020\b0\rX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\bJ\u0010K¨\u0006j"}, d2 = {"Landroidx/compose/material3/internal/AnchoredDraggableState;", "T", "", "initialValue", "anchors", "Landroidx/compose/material3/internal/DraggableAnchors;", "positionalThreshold", "Lkotlin/Function1;", "", "Lkotlin/ParameterName;", HintConstants.AUTOFILL_HINT_NAME, "totalDistance", "velocityThreshold", "Lkotlin/Function0;", "animationSpec", "Landroidx/compose/animation/core/AnimationSpec;", "confirmValueChange", "newValue", "", "(Ljava/lang/Object;Landroidx/compose/material3/internal/DraggableAnchors;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function0;Landroidx/compose/animation/core/AnimationSpec;Lkotlin/jvm/functions/Function1;)V", "(Ljava/lang/Object;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function0;Landroidx/compose/animation/core/AnimationSpec;Lkotlin/jvm/functions/Function1;)V", "anchoredDragScope", "Landroidx/compose/material3/internal/AnchoredDragScope;", "<set-?>", "getAnchors", "()Landroidx/compose/material3/internal/DraggableAnchors;", "setAnchors", "(Landroidx/compose/material3/internal/DraggableAnchors;)V", "anchors$delegate", "Landroidx/compose/runtime/MutableState;", "getAnimationSpec", "()Landroidx/compose/animation/core/AnimationSpec;", "closestValue", "getClosestValue$material3_release", "()Ljava/lang/Object;", "closestValue$delegate", "Landroidx/compose/runtime/State;", "getConfirmValueChange$material3_release", "()Lkotlin/jvm/functions/Function1;", "currentValue", "getCurrentValue", "setCurrentValue", "(Ljava/lang/Object;)V", "currentValue$delegate", "dragMutex", "Landroidx/compose/material3/internal/InternalMutatorMutex;", "dragTarget", "getDragTarget", "setDragTarget", "dragTarget$delegate", "draggableState", "Landroidx/compose/foundation/gestures/DraggableState;", "getDraggableState$material3_release", "()Landroidx/compose/foundation/gestures/DraggableState;", "isAnimationRunning", "()Z", "lastVelocity", "getLastVelocity", "()F", "setLastVelocity", "(F)V", "lastVelocity$delegate", "Landroidx/compose/runtime/MutableFloatState;", "offset", "getOffset", "setOffset", "offset$delegate", "getPositionalThreshold$material3_release", "progress", "getProgress", "progress$delegate", "targetValue", "getTargetValue", "targetValue$delegate", "getVelocityThreshold$material3_release", "()Lkotlin/jvm/functions/Function0;", "anchoredDrag", "", "dragPriority", "Landroidx/compose/foundation/MutatePriority;", "block", "Lkotlin/Function4;", "Lkotlin/coroutines/Continuation;", "Lkotlin/ExtensionFunctionType;", "(Ljava/lang/Object;Landroidx/compose/foundation/MutatePriority;Lkotlin/jvm/functions/Function4;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "Lkotlin/Function3;", "(Landroidx/compose/foundation/MutatePriority;Lkotlin/jvm/functions/Function3;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "computeTarget", "velocity", "(FLjava/lang/Object;F)Ljava/lang/Object;", "computeTargetWithoutThresholds", "(FLjava/lang/Object;)Ljava/lang/Object;", "dispatchRawDelta", "delta", "newOffsetForDelta", "newOffsetForDelta$material3_release", "requireOffset", "settle", "(FLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "trySnapTo", "(Ljava/lang/Object;)Z", "updateAnchors", "newAnchors", "newTarget", "(Landroidx/compose/material3/internal/DraggableAnchors;Ljava/lang/Object;)V", "Companion", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class AnchoredDraggableState<T> {
    public static final int $stable = 0;

    public static final Companion INSTANCE = new Companion(null);
    private final AnchoredDragScope anchoredDragScope;

    private final MutableState anchors;
    private final AnimationSpec<Float> animationSpec;

    private final State closestValue;
    private final Function1<T, Boolean> confirmValueChange;

    private final MutableState currentValue;
    private final InternalMutatorMutex dragMutex;

    private final MutableState dragTarget;
    private final DraggableState draggableState;

    private final MutableFloatState lastVelocity;

    private final MutableFloatState offset;
    private final Function1<Float, Float> positionalThreshold;

    private final State progress;

    private final State targetValue;
    private final Function0<Float> velocityThreshold;

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.material3.internal.AnchoredDraggableState", f = "AnchoredDraggable.kt", i = {0}, l = {520}, m = "anchoredDrag", n = {"this"}, s = {"L$0"})
    static final class C14711 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;
        final AnchoredDraggableState<T> this$0;

        C14711(AnchoredDraggableState<T> anchoredDraggableState, Continuation<? super C14711> continuation) {
            super(continuation);
            this.this$0 = anchoredDraggableState;
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return this.this$0.anchoredDrag(null, null, (Continuation) this);
        }
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.material3.internal.AnchoredDraggableState", f = "AnchoredDraggable.kt", i = {0}, l = {567}, m = "anchoredDrag", n = {"this"}, s = {"L$0"})
    static final class C14733 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;
        final AnchoredDraggableState<T> this$0;

        C14733(AnchoredDraggableState<T> anchoredDraggableState, Continuation<? super C14733> continuation) {
            super(continuation);
            this.this$0 = anchoredDraggableState;
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return this.this$0.anchoredDrag(null, null, null, (Continuation) this);
        }
    }

    public AnchoredDraggableState(T t, Function1<? super Float, Float> function1, Function0<Float> function0, AnimationSpec<Float> animationSpec, Function1<? super T, Boolean> function2) {
        this.positionalThreshold = function1;
        this.velocityThreshold = function0;
        this.animationSpec = animationSpec;
        this.confirmValueChange = function2;
        this.dragMutex = new InternalMutatorMutex();
        this.draggableState = new AnchoredDraggableState$draggableState$1(this);
        this.currentValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(t, null, 2, null);
        this.targetValue = SnapshotStateKt.derivedStateOf(new Function0<T>(this) {
            final AnchoredDraggableState<T> this$0;

            {
                super(0);
                this.this$0 = this;
            }

            public final T invoke() {
                T t2 = (T) this.this$0.getDragTarget();
                if (t2 != null) {
                    return t2;
                }
                AnchoredDraggableState<T> anchoredDraggableState = this.this$0;
                float offset = anchoredDraggableState.getOffset();
                if (!Float.isNaN(offset)) {
                    return (T) anchoredDraggableState.computeTarget(offset, anchoredDraggableState.getCurrentValue(), 0.0f);
                }
                return anchoredDraggableState.getCurrentValue();
            }
        });
        this.closestValue = SnapshotStateKt.derivedStateOf(new Function0<T>(this) {
            final AnchoredDraggableState<T> this$0;

            {
                super(0);
                this.this$0 = this;
            }

            public final T invoke() {
                T t2 = (T) this.this$0.getDragTarget();
                if (t2 != null) {
                    return t2;
                }
                AnchoredDraggableState<T> anchoredDraggableState = this.this$0;
                float offset = anchoredDraggableState.getOffset();
                if (!Float.isNaN(offset)) {
                    return (T) anchoredDraggableState.computeTargetWithoutThresholds(offset, anchoredDraggableState.getCurrentValue());
                }
                return anchoredDraggableState.getCurrentValue();
            }
        });
        this.offset = PrimitiveSnapshotStateKt.mutableFloatStateOf(Float.NaN);
        this.progress = SnapshotStateKt.derivedStateOf(SnapshotStateKt.structuralEqualityPolicy(), new Function0<Float>(this) {
            final AnchoredDraggableState<T> this$0;

            {
                super(0);
                this.this$0 = this;
            }

            public final Float m3247invoke() {
                float fPositionOf = this.this$0.getAnchors().positionOf(this.this$0.getCurrentValue());
                float fPositionOf2 = this.this$0.getAnchors().positionOf(this.this$0.getClosestValue$material3_release()) - fPositionOf;
                float fAbs = Math.abs(fPositionOf2);
                float f = 1.0f;
                if (!Float.isNaN(fAbs) && fAbs > 1.0E-6f) {
                    float fRequireOffset = (this.this$0.requireOffset() - fPositionOf) / fPositionOf2;
                    if (fRequireOffset < 1.0E-6f) {
                        f = 0.0f;
                    } else if (fRequireOffset <= 0.999999f) {
                        f = fRequireOffset;
                    }
                }
                return Float.valueOf(f);
            }
        });
        this.lastVelocity = PrimitiveSnapshotStateKt.mutableFloatStateOf(0.0f);
        this.dragTarget = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
        this.anchors = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(AnchoredDraggableKt.emptyDraggableAnchors(), null, 2, null);
        this.anchoredDragScope = new AnchoredDragScope(this) {
            final AnchoredDraggableState<T> this$0;

            {
                this.this$0 = this;
            }

            @Override
            public void dragTo(float newOffset, float lastKnownVelocity) {
                this.this$0.setOffset(newOffset);
                this.this$0.setLastVelocity(lastKnownVelocity);
            }
        };
    }

    public final Function1<Float, Float> getPositionalThreshold$material3_release() {
        return this.positionalThreshold;
    }

    public final Function0<Float> getVelocityThreshold$material3_release() {
        return this.velocityThreshold;
    }

    public final AnimationSpec<Float> getAnimationSpec() {
        return this.animationSpec;
    }

    public AnchoredDraggableState(Object obj, Function1 function1, Function0 function0, AnimationSpec animationSpec, C14691 c14691, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(obj, function1, function0, animationSpec, (i & 16) != 0 ? new Function1<T, Boolean>() {
            public final Boolean m3242invoke(T t) {
                return true;
            }
        } : c14691);
    }

    public final Function1<T, Boolean> getConfirmValueChange$material3_release() {
        return this.confirmValueChange;
    }

    public AnchoredDraggableState(Object obj, DraggableAnchors draggableAnchors, Function1 function1, Function0 function0, AnimationSpec animationSpec, C14702 c14702, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(obj, draggableAnchors, function1, function0, animationSpec, (i & 32) != 0 ? new Function1<T, Boolean>() {
            public final Boolean m3243invoke(T t) {
                return true;
            }
        } : c14702);
    }

    public AnchoredDraggableState(T t, DraggableAnchors<T> draggableAnchors, Function1<? super Float, Float> function1, Function0<Float> function0, AnimationSpec<Float> animationSpec, Function1<? super T, Boolean> function2) {
        this(t, function1, function0, animationSpec, function2);
        setAnchors(draggableAnchors);
        trySnapTo(t);
    }

    public final DraggableState getDraggableState() {
        return this.draggableState;
    }

    public final void setCurrentValue(T t) {
        this.currentValue.setValue(t);
    }

    public final T getCurrentValue() {
        return this.currentValue.getValue();
    }

    public final T getTargetValue() {
        return (T) this.targetValue.getValue();
    }

    public final T getClosestValue$material3_release() {
        return (T) this.closestValue.getValue();
    }

    public final void setOffset(float f) {
        this.offset.setFloatValue(f);
    }

    public final float getOffset() {
        return this.offset.getFloatValue();
    }

    public final float requireOffset() {
        if (Float.isNaN(getOffset())) {
            throw new IllegalStateException("The offset was read before being initialized. Did you access the offset in a phase before layout, like effects or composition?".toString());
        }
        return getOffset();
    }

    public final boolean isAnimationRunning() {
        return getDragTarget() != null;
    }

    public final float getProgress() {
        return ((Number) this.progress.getValue()).floatValue();
    }

    public final void setLastVelocity(float f) {
        this.lastVelocity.setFloatValue(f);
    }

    public final float getLastVelocity() {
        return this.lastVelocity.getFloatValue();
    }

    public final T getDragTarget() {
        return this.dragTarget.getValue();
    }

    public final void setDragTarget(T t) {
        this.dragTarget.setValue(t);
    }

    private final void setAnchors(DraggableAnchors<T> draggableAnchors) {
        this.anchors.setValue(draggableAnchors);
    }

    public final DraggableAnchors<T> getAnchors() {
        return (DraggableAnchors) this.anchors.getValue();
    }

    public static void updateAnchors$default(AnchoredDraggableState anchoredDraggableState, DraggableAnchors draggableAnchors, Object obj, int i, Object obj2) {
        if ((i & 2) != 0 && (Float.isNaN(anchoredDraggableState.getOffset()) || (obj = draggableAnchors.closestAnchor(anchoredDraggableState.getOffset())) == null)) {
            obj = anchoredDraggableState.getTargetValue();
        }
        anchoredDraggableState.updateAnchors(draggableAnchors, obj);
    }

    public final void updateAnchors(DraggableAnchors<T> newAnchors, T newTarget) {
        if (Intrinsics.areEqual(getAnchors(), newAnchors)) {
            return;
        }
        setAnchors(newAnchors);
        if (trySnapTo(newTarget)) {
            return;
        }
        setDragTarget(newTarget);
    }

    public final Object settle(float f, Continuation<? super Unit> continuation) {
        T currentValue = getCurrentValue();
        T tComputeTarget = computeTarget(requireOffset(), currentValue, f);
        if (((Boolean) this.confirmValueChange.invoke(tComputeTarget)).booleanValue()) {
            Object objAnimateTo = AnchoredDraggableKt.animateTo(this, tComputeTarget, f, continuation);
            return objAnimateTo == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objAnimateTo : Unit.INSTANCE;
        }
        Object objAnimateTo2 = AnchoredDraggableKt.animateTo(this, currentValue, f, continuation);
        return objAnimateTo2 == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objAnimateTo2 : Unit.INSTANCE;
    }

    public final T computeTarget(float offset, T currentValue, float velocity) {
        T tClosestAnchor;
        DraggableAnchors<T> anchors = getAnchors();
        float fPositionOf = anchors.positionOf(currentValue);
        float fFloatValue = ((Number) this.velocityThreshold.invoke()).floatValue();
        if (fPositionOf == offset || Float.isNaN(fPositionOf)) {
            return currentValue;
        }
        if (fPositionOf < offset) {
            if (velocity >= fFloatValue) {
                T tClosestAnchor2 = anchors.closestAnchor(offset, true);
                Intrinsics.checkNotNull(tClosestAnchor2);
                return tClosestAnchor2;
            }
            tClosestAnchor = anchors.closestAnchor(offset, true);
            Intrinsics.checkNotNull(tClosestAnchor);
            if (offset < Math.abs(fPositionOf + Math.abs(((Number) this.positionalThreshold.invoke(Float.valueOf(Math.abs(anchors.positionOf(tClosestAnchor) - fPositionOf)))).floatValue()))) {
                return currentValue;
            }
        } else {
            if (velocity <= (-fFloatValue)) {
                T tClosestAnchor3 = anchors.closestAnchor(offset, false);
                Intrinsics.checkNotNull(tClosestAnchor3);
                return tClosestAnchor3;
            }
            tClosestAnchor = anchors.closestAnchor(offset, false);
            Intrinsics.checkNotNull(tClosestAnchor);
            float fAbs = Math.abs(fPositionOf - Math.abs(((Number) this.positionalThreshold.invoke(Float.valueOf(Math.abs(fPositionOf - anchors.positionOf(tClosestAnchor))))).floatValue()));
            if (offset < 0.0f) {
                if (Math.abs(offset) < fAbs) {
                    return currentValue;
                }
            } else if (offset > fAbs) {
                return currentValue;
            }
        }
        return tClosestAnchor;
    }

    public final T computeTargetWithoutThresholds(float offset, T currentValue) {
        T tClosestAnchor;
        DraggableAnchors<T> anchors = getAnchors();
        float fPositionOf = anchors.positionOf(currentValue);
        if (fPositionOf == offset || Float.isNaN(fPositionOf)) {
            return currentValue;
        }
        if (fPositionOf < offset) {
            tClosestAnchor = anchors.closestAnchor(offset, true);
            if (tClosestAnchor == null) {
                return currentValue;
            }
        } else {
            tClosestAnchor = anchors.closestAnchor(offset, false);
            if (tClosestAnchor == null) {
                return currentValue;
            }
        }
        return tClosestAnchor;
    }

    public final Object anchoredDrag(MutatePriority mutatePriority, Function3<? super AnchoredDragScope, ? super DraggableAnchors<T>, ? super Continuation<? super Unit>, ? extends Object> function3, Continuation<? super Unit> continuation) throws Throwable {
        C14711 c14711;
        AnchoredDraggableState<T> anchoredDraggableState;
        T tClosestAnchor;
        T tClosestAnchor2;
        if (continuation instanceof C14711) {
            c14711 = (C14711) continuation;
            if ((c14711.label & Integer.MIN_VALUE) != 0) {
                c14711.label -= Integer.MIN_VALUE;
            } else {
                c14711 = new C14711(this, continuation);
            }
        } else {
            c14711 = new C14711(this, continuation);
        }
        Object obj = c14711.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c14711.label;
        if (i != 0) {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            anchoredDraggableState = (AnchoredDraggableState) c14711.L$0;
            try {
                ResultKt.throwOnFailure(obj);
                tClosestAnchor2 = anchoredDraggableState.getAnchors().closestAnchor(anchoredDraggableState.getOffset());
                if (tClosestAnchor2 != null && Math.abs(anchoredDraggableState.getOffset() - anchoredDraggableState.getAnchors().positionOf(tClosestAnchor2)) <= 0.5f && ((Boolean) anchoredDraggableState.confirmValueChange.invoke(tClosestAnchor2)).booleanValue()) {
                    anchoredDraggableState.setCurrentValue(tClosestAnchor2);
                }
                return Unit.INSTANCE;
            } catch (Throwable th) {
                th = th;
                tClosestAnchor = anchoredDraggableState.getAnchors().closestAnchor(anchoredDraggableState.getOffset());
                if (tClosestAnchor != null && Math.abs(anchoredDraggableState.getOffset() - anchoredDraggableState.getAnchors().positionOf(tClosestAnchor)) <= 0.5f && ((Boolean) anchoredDraggableState.confirmValueChange.invoke(tClosestAnchor)).booleanValue()) {
                    anchoredDraggableState.setCurrentValue(tClosestAnchor);
                }
                throw th;
            }
        }
        ResultKt.throwOnFailure(obj);
        try {
            InternalMutatorMutex internalMutatorMutex = this.dragMutex;
            C14722 c14722 = new C14722(this, function3, null);
            c14711.L$0 = this;
            c14711.label = 1;
            if (internalMutatorMutex.mutate(mutatePriority, c14722, c14711) == coroutine_suspended) {
                return coroutine_suspended;
            }
            anchoredDraggableState = this;
            tClosestAnchor2 = anchoredDraggableState.getAnchors().closestAnchor(anchoredDraggableState.getOffset());
            if (tClosestAnchor2 != null) {
                anchoredDraggableState.setCurrentValue(tClosestAnchor2);
            }
            return Unit.INSTANCE;
        } catch (Throwable th2) {
            th = th2;
            anchoredDraggableState = this;
            tClosestAnchor = anchoredDraggableState.getAnchors().closestAnchor(anchoredDraggableState.getOffset());
            if (tClosestAnchor != null) {
                anchoredDraggableState.setCurrentValue(tClosestAnchor);
            }
            throw th;
        }
    }

    public static Object anchoredDrag$default(AnchoredDraggableState anchoredDraggableState, MutatePriority mutatePriority, Function3 function3, Continuation continuation, int i, Object obj) {
        if ((i & 1) != 0) {
            mutatePriority = MutatePriority.Default;
        }
        return anchoredDraggableState.anchoredDrag(mutatePriority, function3, continuation);
    }

    @Metadata(d1 = {"\u0000\b\n\u0000\n\u0002\u0010\u0002\n\u0000\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002H\u008a@"}, d2 = {"<anonymous>", "", "T"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.material3.internal.AnchoredDraggableState$anchoredDrag$2", f = "AnchoredDraggable.kt", i = {}, l = {521}, m = "invokeSuspend", n = {}, s = {})
    static final class C14722 extends SuspendLambda implements Function1<Continuation<? super Unit>, Object> {
        final Function3<AnchoredDragScope, DraggableAnchors<T>, Continuation<? super Unit>, Object> $block;
        int label;
        final AnchoredDraggableState<T> this$0;

        C14722(AnchoredDraggableState<T> anchoredDraggableState, Function3<? super AnchoredDragScope, ? super DraggableAnchors<T>, ? super Continuation<? super Unit>, ? extends Object> function3, Continuation<? super C14722> continuation) {
            super(1, continuation);
            this.this$0 = anchoredDraggableState;
            this.$block = function3;
        }

        public final Continuation<Unit> create(Continuation<?> continuation) {
            return new C14722(this.this$0, this.$block, continuation);
        }

        public final Object invoke(Continuation<? super Unit> continuation) {
            return create(continuation).invokeSuspend(Unit.INSTANCE);
        }

        @Metadata(d1 = {"\u0000\u000e\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u00022\f\u0010\u0003\u001a\b\u0012\u0004\u0012\u0002H\u00020\u0004H\u008a@"}, d2 = {"<anonymous>", "", "T", "latestAnchors", "Landroidx/compose/material3/internal/DraggableAnchors;"}, k = 3, mv = {1, 8, 0}, xi = 48)
        @DebugMetadata(c = "androidx.compose.material3.internal.AnchoredDraggableState$anchoredDrag$2$2", f = "AnchoredDraggable.kt", i = {}, l = {522}, m = "invokeSuspend", n = {}, s = {})
        static final class AnonymousClass2 extends SuspendLambda implements Function2<DraggableAnchors<T>, Continuation<? super Unit>, Object> {
            final Function3<AnchoredDragScope, DraggableAnchors<T>, Continuation<? super Unit>, Object> $block;
            Object L$0;
            int label;
            final AnchoredDraggableState<T> this$0;

            AnonymousClass2(Function3<? super AnchoredDragScope, ? super DraggableAnchors<T>, ? super Continuation<? super Unit>, ? extends Object> function3, AnchoredDraggableState<T> anchoredDraggableState, Continuation<? super AnonymousClass2> continuation) {
                super(2, continuation);
                this.$block = function3;
                this.this$0 = anchoredDraggableState;
            }

            public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                Continuation<Unit> anonymousClass2 = new AnonymousClass2(this.$block, this.this$0, continuation);
                anonymousClass2.L$0 = obj;
                return anonymousClass2;
            }

            public final Object invoke(DraggableAnchors<T> draggableAnchors, Continuation<? super Unit> continuation) {
                return create(draggableAnchors, continuation).invokeSuspend(Unit.INSTANCE);
            }

            public final Object invokeSuspend(Object obj) {
                Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                int i = this.label;
                if (i == 0) {
                    ResultKt.throwOnFailure(obj);
                    DraggableAnchors draggableAnchors = (DraggableAnchors) this.L$0;
                    Function3<AnchoredDragScope, DraggableAnchors<T>, Continuation<? super Unit>, Object> function3 = this.$block;
                    AnchoredDragScope anchoredDragScope = ((AnchoredDraggableState) this.this$0).anchoredDragScope;
                    this.label = 1;
                    if (function3.invoke(anchoredDragScope, draggableAnchors, this) == coroutine_suspended) {
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

        public final Object invokeSuspend(Object obj) {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                final AnchoredDraggableState<T> anchoredDraggableState = this.this$0;
                this.label = 1;
                if (AnchoredDraggableKt.restartable(new Function0<DraggableAnchors<T>>() {
                    {
                        super(0);
                    }

                    public final DraggableAnchors<T> m3245invoke() {
                        return anchoredDraggableState.getAnchors();
                    }
                }, new AnonymousClass2(this.$block, this.this$0, null), (Continuation) this) == coroutine_suspended) {
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

    public final Object anchoredDrag(T t, MutatePriority mutatePriority, Function4<? super AnchoredDragScope, ? super DraggableAnchors<T>, ? super T, ? super Continuation<? super Unit>, ? extends Object> function4, Continuation<? super Unit> continuation) {
        C14733 c14733;
        AnchoredDraggableState<T> anchoredDraggableState;
        T tClosestAnchor;
        T tClosestAnchor2;
        if (continuation instanceof C14733) {
            c14733 = (C14733) continuation;
            if ((c14733.label & Integer.MIN_VALUE) != 0) {
                c14733.label -= Integer.MIN_VALUE;
            } else {
                c14733 = new C14733(this, continuation);
            }
        } else {
            c14733 = new C14733(this, continuation);
        }
        Object obj = c14733.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c14733.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            if (getAnchors().hasAnchorFor(t)) {
                try {
                    InternalMutatorMutex internalMutatorMutex = this.dragMutex;
                    C14744 c14744 = new C14744(this, t, function4, null);
                    c14733.L$0 = this;
                    c14733.label = 1;
                    if (internalMutatorMutex.mutate(mutatePriority, c14744, c14733) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    anchoredDraggableState = this;
                    anchoredDraggableState.setDragTarget(null);
                    tClosestAnchor2 = anchoredDraggableState.getAnchors().closestAnchor(anchoredDraggableState.getOffset());
                    if (tClosestAnchor2 != null) {
                        anchoredDraggableState.setCurrentValue(tClosestAnchor2);
                    }
                } catch (Throwable th) {
                    th = th;
                    anchoredDraggableState = this;
                    anchoredDraggableState.setDragTarget(null);
                    tClosestAnchor = anchoredDraggableState.getAnchors().closestAnchor(anchoredDraggableState.getOffset());
                    if (tClosestAnchor != null) {
                        anchoredDraggableState.setCurrentValue(tClosestAnchor);
                    }
                    throw th;
                }
            } else {
                setCurrentValue(t);
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            anchoredDraggableState = (AnchoredDraggableState) c14733.L$0;
            try {
                ResultKt.throwOnFailure(obj);
                anchoredDraggableState.setDragTarget(null);
                tClosestAnchor2 = anchoredDraggableState.getAnchors().closestAnchor(anchoredDraggableState.getOffset());
                if (tClosestAnchor2 != null && Math.abs(anchoredDraggableState.getOffset() - anchoredDraggableState.getAnchors().positionOf(tClosestAnchor2)) <= 0.5f && ((Boolean) anchoredDraggableState.confirmValueChange.invoke(tClosestAnchor2)).booleanValue()) {
                    anchoredDraggableState.setCurrentValue(tClosestAnchor2);
                }
            } catch (Throwable th2) {
                th = th2;
                anchoredDraggableState.setDragTarget(null);
                tClosestAnchor = anchoredDraggableState.getAnchors().closestAnchor(anchoredDraggableState.getOffset());
                if (tClosestAnchor != null && Math.abs(anchoredDraggableState.getOffset() - anchoredDraggableState.getAnchors().positionOf(tClosestAnchor)) <= 0.5f && ((Boolean) anchoredDraggableState.confirmValueChange.invoke(tClosestAnchor)).booleanValue()) {
                    anchoredDraggableState.setCurrentValue(tClosestAnchor);
                }
                throw th;
            }
        }
        return Unit.INSTANCE;
    }

    public static Object anchoredDrag$default(AnchoredDraggableState anchoredDraggableState, Object obj, MutatePriority mutatePriority, Function4 function4, Continuation continuation, int i, Object obj2) {
        if ((i & 2) != 0) {
            mutatePriority = MutatePriority.Default;
        }
        return anchoredDraggableState.anchoredDrag(obj, mutatePriority, function4, continuation);
    }

    @Metadata(d1 = {"\u0000\b\n\u0000\n\u0002\u0010\u0002\n\u0000\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002H\u008a@"}, d2 = {"<anonymous>", "", "T"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.material3.internal.AnchoredDraggableState$anchoredDrag$4", f = "AnchoredDraggable.kt", i = {}, l = {569}, m = "invokeSuspend", n = {}, s = {})
    static final class C14744 extends SuspendLambda implements Function1<Continuation<? super Unit>, Object> {
        final Function4<AnchoredDragScope, DraggableAnchors<T>, T, Continuation<? super Unit>, Object> $block;
        final T $targetValue;
        int label;
        final AnchoredDraggableState<T> this$0;

        C14744(AnchoredDraggableState<T> anchoredDraggableState, T t, Function4<? super AnchoredDragScope, ? super DraggableAnchors<T>, ? super T, ? super Continuation<? super Unit>, ? extends Object> function4, Continuation<? super C14744> continuation) {
            super(1, continuation);
            this.this$0 = anchoredDraggableState;
            this.$targetValue = t;
            this.$block = function4;
        }

        public final Continuation<Unit> create(Continuation<?> continuation) {
            return new C14744(this.this$0, this.$targetValue, this.$block, continuation);
        }

        public final Object invoke(Continuation<? super Unit> continuation) {
            return create(continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.this$0.setDragTarget(this.$targetValue);
                final AnchoredDraggableState<T> anchoredDraggableState = this.this$0;
                this.label = 1;
                if (AnchoredDraggableKt.restartable(new Function0<Pair<? extends DraggableAnchors<T>, ? extends T>>() {
                    {
                        super(0);
                    }

                    public final Pair<DraggableAnchors<T>, T> invoke() {
                        return TuplesKt.to(anchoredDraggableState.getAnchors(), anchoredDraggableState.getTargetValue());
                    }
                }, new AnonymousClass2(this.$block, this.this$0, null), (Continuation) this) == coroutine_suspended) {
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

        @Metadata(d1 = {"\u0000\u0012\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u00022\u0018\u0010\u0003\u001a\u0014\u0012\n\u0012\b\u0012\u0004\u0012\u0002H\u00020\u0005\u0012\u0004\u0012\u0002H\u00020\u0004H\u008a@"}, d2 = {"<anonymous>", "", "T", "<name for destructuring parameter 0>", "Lkotlin/Pair;", "Landroidx/compose/material3/internal/DraggableAnchors;"}, k = 3, mv = {1, 8, 0}, xi = 48)
        @DebugMetadata(c = "androidx.compose.material3.internal.AnchoredDraggableState$anchoredDrag$4$2", f = "AnchoredDraggable.kt", i = {}, l = {571}, m = "invokeSuspend", n = {}, s = {})
        static final class AnonymousClass2 extends SuspendLambda implements Function2<Pair<? extends DraggableAnchors<T>, ? extends T>, Continuation<? super Unit>, Object> {
            final Function4<AnchoredDragScope, DraggableAnchors<T>, T, Continuation<? super Unit>, Object> $block;
            Object L$0;
            int label;
            final AnchoredDraggableState<T> this$0;

            AnonymousClass2(Function4<? super AnchoredDragScope, ? super DraggableAnchors<T>, ? super T, ? super Continuation<? super Unit>, ? extends Object> function4, AnchoredDraggableState<T> anchoredDraggableState, Continuation<? super AnonymousClass2> continuation) {
                super(2, continuation);
                this.$block = function4;
                this.this$0 = anchoredDraggableState;
            }

            public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                Continuation<Unit> anonymousClass2 = new AnonymousClass2(this.$block, this.this$0, continuation);
                anonymousClass2.L$0 = obj;
                return anonymousClass2;
            }

            public final Object invoke(Pair<? extends DraggableAnchors<T>, ? extends T> pair, Continuation<? super Unit> continuation) {
                return create(pair, continuation).invokeSuspend(Unit.INSTANCE);
            }

            public final Object invokeSuspend(Object obj) {
                Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                int i = this.label;
                if (i == 0) {
                    ResultKt.throwOnFailure(obj);
                    Pair pair = (Pair) this.L$0;
                    DraggableAnchors draggableAnchors = (DraggableAnchors) pair.component1();
                    Object objComponent2 = pair.component2();
                    Function4<AnchoredDragScope, DraggableAnchors<T>, T, Continuation<? super Unit>, Object> function4 = this.$block;
                    AnchoredDragScope anchoredDragScope = ((AnchoredDraggableState) this.this$0).anchoredDragScope;
                    this.label = 1;
                    if (function4.invoke(anchoredDragScope, draggableAnchors, objComponent2, this) == coroutine_suspended) {
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

    public final float newOffsetForDelta$material3_release(float delta) {
        return RangesKt.coerceIn((Float.isNaN(getOffset()) ? 0.0f : getOffset()) + delta, getAnchors().minAnchor(), getAnchors().maxAnchor());
    }

    public final float dispatchRawDelta(float delta) {
        float fNewOffsetForDelta$material3_release = newOffsetForDelta$material3_release(delta);
        float offset = Float.isNaN(getOffset()) ? 0.0f : getOffset();
        setOffset(fNewOffsetForDelta$material3_release);
        return fNewOffsetForDelta$material3_release - offset;
    }

    private final boolean trySnapTo(final T targetValue) {
        return this.dragMutex.tryMutate(new Function0<Unit>(this) {
            final AnchoredDraggableState<T> this$0;

            {
                super(0);
                this.this$0 = this;
            }

            public Object invoke() {
                m3248invoke();
                return Unit.INSTANCE;
            }

            public final void m3248invoke() {
                AnchoredDragScope anchoredDragScope = ((AnchoredDraggableState) this.this$0).anchoredDragScope;
                AnchoredDraggableState<T> anchoredDraggableState = this.this$0;
                T t = targetValue;
                float fPositionOf = anchoredDraggableState.getAnchors().positionOf(t);
                if (!Float.isNaN(fPositionOf)) {
                    AnchoredDragScope.CC.dragTo$default(anchoredDragScope, fPositionOf, 0.0f, 2, null);
                    anchoredDraggableState.setDragTarget(null);
                }
                anchoredDraggableState.setCurrentValue(t);
            }
        });
    }

    @Metadata(d1 = {"\u0000:\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0007\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002Ju\u0010\u0003\u001a\u0014\u0012\n\u0012\b\u0012\u0004\u0012\u0002H\u00060\u0005\u0012\u0004\u0012\u0002H\u00060\u0004\"\b\b\u0001\u0010\u0006*\u00020\u00012\f\u0010\u0007\u001a\b\u0012\u0004\u0012\u00020\t0\b2\u0012\u0010\n\u001a\u000e\u0012\u0004\u0012\u0002H\u0006\u0012\u0004\u0012\u00020\f0\u000b2!\u0010\r\u001a\u001d\u0012\u0013\u0012\u00110\t¢\u0006\f\b\u000e\u0012\b\b\u000f\u0012\u0004\b\b(\u0010\u0012\u0004\u0012\u00020\t0\u000b2\f\u0010\u0011\u001a\b\u0012\u0004\u0012\u00020\t0\u0012¨\u0006\u0013"}, d2 = {"Landroidx/compose/material3/internal/AnchoredDraggableState$Companion;", "", "()V", "Saver", "Landroidx/compose/runtime/saveable/Saver;", "Landroidx/compose/material3/internal/AnchoredDraggableState;", "T", "animationSpec", "Landroidx/compose/animation/core/AnimationSpec;", "", "confirmValueChange", "Lkotlin/Function1;", "", "positionalThreshold", "Lkotlin/ParameterName;", HintConstants.AUTOFILL_HINT_NAME, "distance", "velocityThreshold", "Lkotlin/Function0;", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final <T> Saver<AnchoredDraggableState<T>, T> Saver(final AnimationSpec<Float> animationSpec, final Function1<? super T, Boolean> confirmValueChange, final Function1<? super Float, Float> positionalThreshold, final Function0<Float> velocityThreshold) {
            return SaverKt.Saver(new Function2<SaverScope, AnchoredDraggableState<T>, T>() {
                public final T invoke(SaverScope saverScope, AnchoredDraggableState<T> anchoredDraggableState) {
                    return anchoredDraggableState.getCurrentValue();
                }
            }, new Function1<T, AnchoredDraggableState<T>>() {
                {
                    super(1);
                }

                public final AnchoredDraggableState<T> m3244invoke(T t) {
                    return new AnchoredDraggableState<>(t, positionalThreshold, velocityThreshold, animationSpec, confirmValueChange);
                }
            });
        }
    }
}
