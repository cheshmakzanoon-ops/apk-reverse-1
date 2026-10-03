package androidx.compose.animation.core;

import androidx.autofill.HintConstants;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.CompositionScopedCoroutineScopeCanceller;
import androidx.compose.runtime.DisposableEffectResult;
import androidx.compose.runtime.DisposableEffectScope;
import androidx.compose.runtime.EffectsKt;
import androidx.compose.runtime.MonotonicFrameClockKt;
import androidx.compose.runtime.MutableFloatState;
import androidx.compose.runtime.MutableLongState;
import androidx.compose.runtime.MutableState;
import androidx.compose.runtime.PrimitiveSnapshotStateKt;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.SnapshotLongStateKt;
import androidx.compose.runtime.SnapshotStateKt;
import androidx.compose.runtime.SnapshotStateKt__SnapshotStateKt;
import androidx.compose.runtime.State;
import androidx.compose.runtime.snapshots.SnapshotStateList;
import java.util.List;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.EmptyCoroutineContext;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.math.MathKt;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.CoroutineScopeKt;
import kotlinx.coroutines.CoroutineStart;

@Metadata(d1 = {"\u0000l\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\t\n\u0002\b\t\n\u0002\u0010 \n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0002\b\u0015\n\u0002\u0018\u0002\n\u0002\b \n\u0002\u0010\u0002\n\u0002\b\u000e\n\u0002\u0010\u0007\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u000b\n\u0002\u0018\u0002\n\u0002\b\u000e\b\u0007\u0018\u0000*\u0004\b\u0000\u0010\u00012\u00020\u0002:\b\u0086\u0001\u0087\u0001\u0088\u0001\u0089\u0001B!\b\u0011\u0012\f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00028\u00000\u0004\u0012\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u0006¢\u0006\u0002\u0010\u0007B\u0019\b\u0010\u0012\u0006\u0010\b\u001a\u00028\u0000\u0012\b\u0010\u0005\u001a\u0004\u0018\u00010\u0006¢\u0006\u0002\u0010\tB!\b\u0011\u0012\f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00028\u00000\n\u0012\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u0006¢\u0006\u0002\u0010\u000bB/\b\u0000\u0012\f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00028\u00000\u0004\u0012\f\u0010\f\u001a\b\u0012\u0002\b\u0003\u0018\u00010\u0000\u0012\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u0006¢\u0006\u0002\u0010\rJ'\u0010S\u001a\u00020#2\u0018\u0010T\u001a\u0014\u0012\u0002\b\u0003\u0012\u0002\b\u00030\u0010R\b\u0012\u0004\u0012\u00028\u00000\u0000H\u0000¢\u0006\u0002\bUJ\u0019\u0010V\u001a\u00020#2\n\u0010W\u001a\u0006\u0012\u0002\b\u00030\u0000H\u0000¢\u0006\u0002\bXJ\u0017\u0010Y\u001a\u00020Z2\u0006\u0010D\u001a\u00028\u0000H\u0001¢\u0006\u0004\b[\u0010\\J\b\u0010]\u001a\u00020\u0012H\u0002J\r\u0010^\u001a\u00020ZH\u0000¢\u0006\u0002\b_J\b\u0010`\u001a\u00020ZH\u0002J\r\u0010a\u001a\u00020ZH\u0000¢\u0006\u0002\bbJ\u001d\u0010c\u001a\u00020Z2\u0006\u0010d\u001a\u00020\u00122\u0006\u0010e\u001a\u00020#H\u0000¢\u0006\u0002\bfJ\u001d\u0010c\u001a\u00020Z2\u0006\u0010g\u001a\u00020\u00122\u0006\u0010h\u001a\u00020iH\u0000¢\u0006\u0002\bfJ\r\u0010j\u001a\u00020ZH\u0000¢\u0006\u0002\bkJ\u0015\u0010l\u001a\u00020Z2\u0006\u0010g\u001a\u00020\u0012H\u0000¢\u0006\u0002\bmJ'\u0010n\u001a\u00020Z2\u0018\u0010o\u001a\u0014\u0012\u0002\b\u0003\u0012\u0002\b\u00030pR\b\u0012\u0004\u0012\u00028\u00000\u0000H\u0000¢\u0006\u0002\bqJ'\u0010n\u001a\u00020Z2\u0018\u0010T\u001a\u0014\u0012\u0002\b\u0003\u0012\u0002\b\u00030\u0010R\b\u0012\u0004\u0012\u00028\u00000\u0000H\u0000¢\u0006\u0002\bqJ\u0019\u0010r\u001a\u00020#2\n\u0010W\u001a\u0006\u0012\u0002\b\u00030\u0000H\u0000¢\u0006\u0002\bsJ\u0015\u0010t\u001a\u00020Z2\u0006\u0010u\u001a\u00020iH\u0000¢\u0006\u0002\bvJ\b\u0010w\u001a\u00020ZH\u0002J\u0015\u0010x\u001a\u00020Z2\u0006\u00106\u001a\u00020\u0012H\u0000¢\u0006\u0002\byJ\u0015\u0010z\u001a\u00020Z2\u0006\u0010{\u001a\u00020|H\u0000¢\u0006\u0002\b}J(\u0010~\u001a\u00020Z2\u0006\u0010\b\u001a\u00028\u00002\u0006\u0010D\u001a\u00028\u00002\u0006\u00106\u001a\u00020\u0012H\u0007¢\u0006\u0005\b\u007f\u0010\u0080\u0001J\t\u0010\u0081\u0001\u001a\u00020\u0006H\u0016J\u000f\u0010\u0082\u0001\u001a\u00020ZH\u0000¢\u0006\u0003\b\u0083\u0001J\u0019\u0010\u0084\u0001\u001a\u00020Z2\u0006\u0010D\u001a\u00028\u0000H\u0000¢\u0006\u0005\b\u0085\u0001\u0010GR&\u0010\u000e\u001a\u001a\u0012\u0016\u0012\u0014\u0012\u0002\b\u0003\u0012\u0002\b\u00030\u0010R\b\u0012\u0004\u0012\u00028\u00000\u00000\u000fX\u0082\u0004¢\u0006\u0002\n\u0000R+\u0010\u0013\u001a\u00020\u00122\u0006\u0010\u0011\u001a\u00020\u00128B@BX\u0082\u008e\u0002¢\u0006\u0012\n\u0004\b\u0018\u0010\u0019\u001a\u0004\b\u0014\u0010\u0015\"\u0004\b\u0016\u0010\u0017R\u0018\u0010\u001a\u001a\f\u0012\b\u0012\u0006\u0012\u0002\b\u00030\u00000\u000fX\u0082\u0004¢\u0006\u0002\n\u0000R)\u0010\u001b\u001a\u001a\u0012\u0016\u0012\u0014\u0012\u0002\b\u0003\u0012\u0002\b\u00030\u0010R\b\u0012\u0004\u0012\u00028\u00000\u00000\u001c8F¢\u0006\u0006\u001a\u0004\b\u001d\u0010\u001eR\u0011\u0010\u001f\u001a\u00028\u00008F¢\u0006\u0006\u001a\u0004\b \u0010!R\u001a\u0010\"\u001a\u00020#8GX\u0087\u0004¢\u0006\f\u0012\u0004\b$\u0010%\u001a\u0004\b&\u0010'R\u0011\u0010(\u001a\u00020#8F¢\u0006\u0006\u001a\u0004\b(\u0010'R+\u0010)\u001a\u00020#2\u0006\u0010\u0011\u001a\u00020#8G@AX\u0086\u008e\u0002¢\u0006\u0012\n\u0004\b,\u0010-\u001a\u0004\b)\u0010'\"\u0004\b*\u0010+R\u0013\u0010\u0005\u001a\u0004\u0018\u00010\u0006¢\u0006\b\n\u0000\u001a\u0004\b.\u0010/R\u001a\u00100\u001a\u00020\u0012X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b1\u0010\u0015\"\u0004\b2\u0010\u0017R\u0019\u0010\f\u001a\b\u0012\u0002\b\u0003\u0018\u00010\u00008\u0007¢\u0006\b\n\u0000\u001a\u0004\b3\u00104R$\u00106\u001a\u00020\u00122\u0006\u00105\u001a\u00020\u00128G@GX\u0086\u000e¢\u0006\f\u001a\u0004\b7\u0010\u0015\"\u0004\b8\u0010\u0017R7\u0010:\u001a\b\u0012\u0004\u0012\u00028\u0000092\f\u0010\u0011\u001a\b\u0012\u0004\u0012\u00028\u0000098F@BX\u0086\u008e\u0002¢\u0006\u0012\n\u0004\b?\u0010-\u001a\u0004\b;\u0010<\"\u0004\b=\u0010>R+\u0010@\u001a\u00020\u00122\u0006\u0010\u0011\u001a\u00020\u00128@@@X\u0080\u008e\u0002¢\u0006\u0012\n\u0004\bC\u0010\u0019\u001a\u0004\bA\u0010\u0015\"\u0004\bB\u0010\u0017R+\u0010D\u001a\u00028\u00002\u0006\u0010\u0011\u001a\u00028\u00008F@@X\u0086\u008e\u0002¢\u0006\u0012\n\u0004\bH\u0010-\u001a\u0004\bE\u0010!\"\u0004\bF\u0010GR\u001b\u0010I\u001a\u00020\u00128FX\u0086\u0084\u0002¢\u0006\f\n\u0004\bK\u0010L\u001a\u0004\bJ\u0010\u0015R\u0014\u0010\u0003\u001a\b\u0012\u0004\u0012\u00028\u00000\u0004X\u0082\u0004¢\u0006\u0002\n\u0000R\u001b\u0010M\u001a\f\u0012\b\u0012\u0006\u0012\u0002\b\u00030\u00000\u001c8F¢\u0006\u0006\u001a\u0004\bN\u0010\u001eR+\u0010O\u001a\u00020#2\u0006\u0010\u0011\u001a\u00020#8B@BX\u0082\u008e\u0002¢\u0006\u0012\n\u0004\bR\u0010-\u001a\u0004\bP\u0010'\"\u0004\bQ\u0010+¨\u0006\u008a\u0001"}, d2 = {"Landroidx/compose/animation/core/Transition;", "S", "", "transitionState", "Landroidx/compose/animation/core/TransitionState;", "label", "", "(Landroidx/compose/animation/core/TransitionState;Ljava/lang/String;)V", "initialState", "(Ljava/lang/Object;Ljava/lang/String;)V", "Landroidx/compose/animation/core/MutableTransitionState;", "(Landroidx/compose/animation/core/MutableTransitionState;Ljava/lang/String;)V", "parentTransition", "(Landroidx/compose/animation/core/TransitionState;Landroidx/compose/animation/core/Transition;Ljava/lang/String;)V", "_animations", "Landroidx/compose/runtime/snapshots/SnapshotStateList;", "Landroidx/compose/animation/core/Transition$TransitionAnimationState;", "<set-?>", "", "_playTimeNanos", "get_playTimeNanos", "()J", "set_playTimeNanos", "(J)V", "_playTimeNanos$delegate", "Landroidx/compose/runtime/MutableLongState;", "_transitions", "animations", "", "getAnimations", "()Ljava/util/List;", "currentState", "getCurrentState", "()Ljava/lang/Object;", "hasInitialValueAnimations", "", "getHasInitialValueAnimations$annotations", "()V", "getHasInitialValueAnimations", "()Z", "isRunning", "isSeeking", "setSeeking$animation_core_release", "(Z)V", "isSeeking$delegate", "Landroidx/compose/runtime/MutableState;", "getLabel", "()Ljava/lang/String;", "lastSeekedTimeNanos", "getLastSeekedTimeNanos$animation_core_release", "setLastSeekedTimeNanos$animation_core_release", "getParentTransition", "()Landroidx/compose/animation/core/Transition;", "value", "playTimeNanos", "getPlayTimeNanos", "setPlayTimeNanos", "Landroidx/compose/animation/core/Transition$Segment;", "segment", "getSegment", "()Landroidx/compose/animation/core/Transition$Segment;", "setSegment", "(Landroidx/compose/animation/core/Transition$Segment;)V", "segment$delegate", "startTimeNanos", "getStartTimeNanos$animation_core_release", "setStartTimeNanos$animation_core_release", "startTimeNanos$delegate", "targetState", "getTargetState", "setTargetState$animation_core_release", "(Ljava/lang/Object;)V", "targetState$delegate", "totalDurationNanos", "getTotalDurationNanos", "totalDurationNanos$delegate", "Landroidx/compose/runtime/State;", "transitions", "getTransitions", "updateChildrenNeeded", "getUpdateChildrenNeeded", "setUpdateChildrenNeeded", "updateChildrenNeeded$delegate", "addAnimation", "animation", "addAnimation$animation_core_release", "addTransition", "transition", "addTransition$animation_core_release", "animateTo", "", "animateTo$animation_core_release", "(Ljava/lang/Object;Landroidx/compose/runtime/Composer;I)V", "calculateTotalDurationNanos", "clearInitialAnimations", "clearInitialAnimations$animation_core_release", "onChildAnimationUpdated", "onDisposed", "onDisposed$animation_core_release", "onFrame", "scaledPlayTimeNanos", "scaleToEnd", "onFrame$animation_core_release", "frameTimeNanos", "durationScale", "", "onTransitionEnd", "onTransitionEnd$animation_core_release", "onTransitionStart", "onTransitionStart$animation_core_release", "removeAnimation", "deferredAnimation", "Landroidx/compose/animation/core/Transition$DeferredAnimation;", "removeAnimation$animation_core_release", "removeTransition", "removeTransition$animation_core_release", "resetAnimationFraction", "fraction", "resetAnimationFraction$animation_core_release", "resetAnimations", "seekAnimations", "seekAnimations$animation_core_release", "setInitialAnimations", "animationState", "Landroidx/compose/animation/core/SeekableTransitionState$SeekingAnimationState;", "setInitialAnimations$animation_core_release", "setPlaytimeAfterInitialAndTargetStateEstablished", "seek", "(Ljava/lang/Object;Ljava/lang/Object;J)V", "toString", "updateInitialValues", "updateInitialValues$animation_core_release", "updateTarget", "updateTarget$animation_core_release", "DeferredAnimation", "Segment", "SegmentImpl", "TransitionAnimationState", "animation-core_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class Transition<S> {
    public static final int $stable = 0;
    private final SnapshotStateList<Transition<S>.TransitionAnimationState<?, ?>> _animations;

    private final MutableLongState _playTimeNanos;
    private final SnapshotStateList<Transition<?>> _transitions;

    private final MutableState isSeeking;
    private final String label;
    private long lastSeekedTimeNanos;
    private final Transition<?> parentTransition;

    private final MutableState segment;

    private final MutableLongState startTimeNanos;

    private final MutableState targetState;

    private final State totalDurationNanos;
    private final TransitionState<S> transitionState;

    private final MutableState updateChildrenNeeded;

    public static void getHasInitialValueAnimations$annotations() {
    }

    public Transition(TransitionState<S> transitionState, Transition<?> transition, String str) {
        this.transitionState = transitionState;
        this.parentTransition = transition;
        this.label = str;
        this.targetState = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(getCurrentState(), null, 2, null);
        this.segment = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(new SegmentImpl(getCurrentState(), getCurrentState()), null, 2, null);
        this._playTimeNanos = SnapshotLongStateKt.mutableLongStateOf(0L);
        this.startTimeNanos = SnapshotLongStateKt.mutableLongStateOf(Long.MIN_VALUE);
        this.updateChildrenNeeded = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(false, null, 2, null);
        this._animations = SnapshotStateKt.mutableStateListOf();
        this._transitions = SnapshotStateKt.mutableStateListOf();
        this.isSeeking = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(false, null, 2, null);
        this.totalDurationNanos = SnapshotStateKt.derivedStateOf(new Function0<Long>(this) {
            final Transition<S> this$0;

            {
                super(0);
                this.this$0 = this;
            }

            public final Long m471invoke() {
                return Long.valueOf(this.this$0.calculateTotalDurationNanos());
            }
        });
        transitionState.transitionConfigured$animation_core_release(this);
    }

    public Transition(TransitionState transitionState, Transition transition, String str, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(transitionState, transition, (i & 4) != 0 ? null : str);
    }

    public final Transition<?> getParentTransition() {
        return this.parentTransition;
    }

    public final String getLabel() {
        return this.label;
    }

    public Transition(TransitionState transitionState, String str, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(transitionState, (i & 2) != 0 ? null : str);
    }

    public Transition(TransitionState<S> transitionState, String str) {
        this(transitionState, null, str);
    }

    public Transition(S s, String str) {
        this(new MutableTransitionState(s), null, str);
    }

    public Transition(MutableTransitionState mutableTransitionState, String str, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(mutableTransitionState, (i & 2) != 0 ? null : str);
    }

    public Transition(MutableTransitionState<S> mutableTransitionState, String str) {
        this(mutableTransitionState, null, str);
        Intrinsics.checkNotNull(mutableTransitionState, "null cannot be cast to non-null type androidx.compose.animation.core.TransitionState<S of androidx.compose.animation.core.Transition>");
    }

    public final S getCurrentState() {
        return this.transitionState.getCurrentState();
    }

    public final S getTargetState() {
        return (S) this.targetState.getValue();
    }

    public final void setTargetState$animation_core_release(S s) {
        this.targetState.setValue(s);
    }

    private final void setSegment(Segment<S> segment) {
        this.segment.setValue(segment);
    }

    public final Segment<S> getSegment() {
        return (Segment) this.segment.getValue();
    }

    public final boolean isRunning() {
        return getStartTimeNanos$animation_core_release() != Long.MIN_VALUE;
    }

    private final long get_playTimeNanos() {
        return this._playTimeNanos.getLongValue();
    }

    private final void set_playTimeNanos(long j) {
        this._playTimeNanos.setLongValue(j);
    }

    public final long getPlayTimeNanos() {
        Transition<?> transition = this.parentTransition;
        return transition != null ? transition.getPlayTimeNanos() : get_playTimeNanos();
    }

    public final void setPlayTimeNanos(long j) {
        if (this.parentTransition == null) {
            set_playTimeNanos(j);
        }
    }

    public final long getStartTimeNanos$animation_core_release() {
        return this.startTimeNanos.getLongValue();
    }

    public final void setStartTimeNanos$animation_core_release(long j) {
        this.startTimeNanos.setLongValue(j);
    }

    private final boolean getUpdateChildrenNeeded() {
        return ((Boolean) this.updateChildrenNeeded.getValue()).booleanValue();
    }

    private final void setUpdateChildrenNeeded(boolean z) {
        this.updateChildrenNeeded.setValue(Boolean.valueOf(z));
    }

    public final List<Transition<?>> getTransitions() {
        return this._transitions;
    }

    public final List<Transition<S>.TransitionAnimationState<?, ?>> getAnimations() {
        return this._animations;
    }

    public final boolean isSeeking() {
        return ((Boolean) this.isSeeking.getValue()).booleanValue();
    }

    public final void setSeeking$animation_core_release(boolean z) {
        this.isSeeking.setValue(Boolean.valueOf(z));
    }

    public final long getLastSeekedTimeNanos() {
        return this.lastSeekedTimeNanos;
    }

    public final void setLastSeekedTimeNanos$animation_core_release(long j) {
        this.lastSeekedTimeNanos = j;
    }

    public final boolean getHasInitialValueAnimations() {
        SnapshotStateList<Transition<S>.TransitionAnimationState<?, ?>> snapshotStateList = this._animations;
        int size = snapshotStateList.size();
        for (int i = 0; i < size; i++) {
            if (snapshotStateList.get(i).getInitialValueState() != null) {
                return true;
            }
        }
        SnapshotStateList<Transition<?>> snapshotStateList2 = this._transitions;
        int size2 = snapshotStateList2.size();
        for (int i2 = 0; i2 < size2; i2++) {
            if (snapshotStateList2.get(i2).getHasInitialValueAnimations()) {
                return true;
            }
        }
        return false;
    }

    public final long getTotalDurationNanos() {
        return ((Number) this.totalDurationNanos.getValue()).longValue();
    }

    public final long calculateTotalDurationNanos() {
        SnapshotStateList<Transition<S>.TransitionAnimationState<?, ?>> snapshotStateList = this._animations;
        int size = snapshotStateList.size();
        long jMax = 0;
        for (int i = 0; i < size; i++) {
            jMax = Math.max(jMax, snapshotStateList.get(i).getDurationNanos$animation_core_release());
        }
        SnapshotStateList<Transition<?>> snapshotStateList2 = this._transitions;
        int size2 = snapshotStateList2.size();
        for (int i2 = 0; i2 < size2; i2++) {
            jMax = Math.max(jMax, snapshotStateList2.get(i2).calculateTotalDurationNanos());
        }
        return jMax;
    }

    public final void onFrame$animation_core_release(long frameTimeNanos, float durationScale) {
        if (getStartTimeNanos$animation_core_release() == Long.MIN_VALUE) {
            onTransitionStart$animation_core_release(frameTimeNanos);
        }
        long startTimeNanos$animation_core_release = frameTimeNanos - getStartTimeNanos$animation_core_release();
        if (durationScale != 0.0f) {
            startTimeNanos$animation_core_release = MathKt.roundToLong(startTimeNanos$animation_core_release / ((double) durationScale));
        }
        setPlayTimeNanos(startTimeNanos$animation_core_release);
        onFrame$animation_core_release(startTimeNanos$animation_core_release, durationScale == 0.0f);
    }

    public final void onFrame$animation_core_release(long scaledPlayTimeNanos, boolean scaleToEnd) {
        boolean z = true;
        if (getStartTimeNanos$animation_core_release() == Long.MIN_VALUE) {
            onTransitionStart$animation_core_release(scaledPlayTimeNanos);
        } else if (!this.transitionState.isRunning$animation_core_release()) {
            this.transitionState.setRunning$animation_core_release(true);
        }
        setUpdateChildrenNeeded(false);
        SnapshotStateList<Transition<S>.TransitionAnimationState<?, ?>> snapshotStateList = this._animations;
        int size = snapshotStateList.size();
        for (int i = 0; i < size; i++) {
            Transition<S>.TransitionAnimationState<?, ?> transitionAnimationState = snapshotStateList.get(i);
            if (!transitionAnimationState.isFinished$animation_core_release()) {
                transitionAnimationState.onPlayTimeChanged$animation_core_release(scaledPlayTimeNanos, scaleToEnd);
            }
            if (!transitionAnimationState.isFinished$animation_core_release()) {
                z = false;
            }
        }
        SnapshotStateList<Transition<?>> snapshotStateList2 = this._transitions;
        int size2 = snapshotStateList2.size();
        for (int i2 = 0; i2 < size2; i2++) {
            Transition<?> transition = snapshotStateList2.get(i2);
            if (!Intrinsics.areEqual(transition.getTargetState(), transition.getCurrentState())) {
                transition.onFrame$animation_core_release(scaledPlayTimeNanos, scaleToEnd);
            }
            if (!Intrinsics.areEqual(transition.getTargetState(), transition.getCurrentState())) {
                z = false;
            }
        }
        if (z) {
            onTransitionEnd$animation_core_release();
        }
    }

    public final void onTransitionStart$animation_core_release(long frameTimeNanos) {
        setStartTimeNanos$animation_core_release(frameTimeNanos);
        this.transitionState.setRunning$animation_core_release(true);
    }

    public final void onDisposed$animation_core_release() {
        onTransitionEnd$animation_core_release();
        this.transitionState.transitionRemoved$animation_core_release();
    }

    public final void onTransitionEnd$animation_core_release() {
        setStartTimeNanos$animation_core_release(Long.MIN_VALUE);
        TransitionState<S> transitionState = this.transitionState;
        if (transitionState instanceof MutableTransitionState) {
            transitionState.setCurrentState$animation_core_release(getTargetState());
        }
        setPlayTimeNanos(0L);
        this.transitionState.setRunning$animation_core_release(false);
        SnapshotStateList<Transition<?>> snapshotStateList = this._transitions;
        int size = snapshotStateList.size();
        for (int i = 0; i < size; i++) {
            snapshotStateList.get(i).onTransitionEnd$animation_core_release();
        }
    }

    public final void seek(S initialState, S targetState, long playTimeNanos) {
        setStartTimeNanos$animation_core_release(Long.MIN_VALUE);
        this.transitionState.setRunning$animation_core_release(false);
        if (!isSeeking() || !Intrinsics.areEqual(getCurrentState(), initialState) || !Intrinsics.areEqual(getTargetState(), targetState)) {
            if (!Intrinsics.areEqual(getCurrentState(), initialState)) {
                TransitionState<S> transitionState = this.transitionState;
                if (transitionState instanceof MutableTransitionState) {
                    transitionState.setCurrentState$animation_core_release(initialState);
                }
            }
            setTargetState$animation_core_release(targetState);
            setSeeking$animation_core_release(true);
            setSegment(new SegmentImpl(initialState, targetState));
        }
        SnapshotStateList<Transition<?>> snapshotStateList = this._transitions;
        int size = snapshotStateList.size();
        for (int i = 0; i < size; i++) {
            Transition<?> transition = snapshotStateList.get(i);
            Intrinsics.checkNotNull(transition, "null cannot be cast to non-null type androidx.compose.animation.core.Transition<kotlin.Any>");
            if (transition.isSeeking()) {
                transition.seek(transition.getCurrentState(), transition.getTargetState(), playTimeNanos);
            }
        }
        SnapshotStateList<Transition<S>.TransitionAnimationState<?, ?>> snapshotStateList2 = this._animations;
        int size2 = snapshotStateList2.size();
        for (int i2 = 0; i2 < size2; i2++) {
            snapshotStateList2.get(i2).seekTo$animation_core_release(playTimeNanos);
        }
        this.lastSeekedTimeNanos = playTimeNanos;
    }

    public final boolean addTransition$animation_core_release(Transition<?> transition) {
        return this._transitions.add(transition);
    }

    public final boolean removeTransition$animation_core_release(Transition<?> transition) {
        return this._transitions.remove(transition);
    }

    public final boolean addAnimation$animation_core_release(Transition<S>.TransitionAnimationState<?, ?> animation) {
        return this._animations.add(animation);
    }

    public final void removeAnimation$animation_core_release(Transition<S>.TransitionAnimationState<?, ?> animation) {
        this._animations.remove(animation);
    }

    public final void updateTarget$animation_core_release(S targetState) {
        if (Intrinsics.areEqual(getTargetState(), targetState)) {
            return;
        }
        setSegment(new SegmentImpl(getTargetState(), targetState));
        if (!Intrinsics.areEqual(getCurrentState(), getTargetState())) {
            this.transitionState.setCurrentState$animation_core_release(getTargetState());
        }
        setTargetState$animation_core_release(targetState);
        if (!isRunning()) {
            setUpdateChildrenNeeded(true);
        }
        resetAnimations();
    }

    private final void resetAnimations() {
        SnapshotStateList<Transition<S>.TransitionAnimationState<?, ?>> snapshotStateList = this._animations;
        int size = snapshotStateList.size();
        for (int i = 0; i < size; i++) {
            snapshotStateList.get(i).resetAnimation$animation_core_release();
        }
        SnapshotStateList<Transition<?>> snapshotStateList2 = this._transitions;
        int size2 = snapshotStateList2.size();
        for (int i2 = 0; i2 < size2; i2++) {
            snapshotStateList2.get(i2).resetAnimations();
        }
    }

    public final void animateTo$animation_core_release(final S s, Composer composer, final int i) {
        int i2;
        Composer composerStartRestartGroup = composer.startRestartGroup(-1493585151);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(animateTo):Transition.kt#pdpnli");
        if ((i & 6) == 0) {
            i2 = ((i & 8) == 0 ? composerStartRestartGroup.changed(s) : composerStartRestartGroup.changedInstance(s) ? 4 : 2) | i;
        } else {
            i2 = i;
        }
        if ((i & 48) == 0) {
            i2 |= composerStartRestartGroup.changed(this) ? 32 : 16;
        }
        if ((i2 & 19) != 18 || !composerStartRestartGroup.getSkipping()) {
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1493585151, i2, -1, "androidx.compose.animation.core.Transition.animateTo (Transition.kt:1211)");
            }
            if (!isSeeking()) {
                composerStartRestartGroup.startReplaceGroup(1822507602);
                ComposerKt.sourceInformation(composerStartRestartGroup, "");
                updateTarget$animation_core_release(s);
                if (!Intrinsics.areEqual(s, getCurrentState()) || isRunning() || getUpdateChildrenNeeded()) {
                    composerStartRestartGroup.startReplaceGroup(1822738893);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "1219@49831L24,1220@49911L1012,1220@49872L1051");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                    Object objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                        composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller);
                        objRememberedValue = compositionScopedCoroutineScopeCanceller;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final CoroutineScope coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 335900987, "CC(remember):Transition.kt#9igjgp");
                    int i3 = i2 & 112;
                    boolean zChangedInstance = composerStartRestartGroup.changedInstance(coroutineScope) | (i3 == 32);
                    Object objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (zChangedInstance || objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                            {
                                super(1);
                            }

                            @Metadata(d1 = {"\u0000\f\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\u00020\u0003H\u008a@"}, d2 = {"<anonymous>", "", "S", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
                            @DebugMetadata(c = "androidx.compose.animation.core.Transition$animateTo$1$1$1", f = "Transition.kt", i = {0, 0}, l = {1227}, m = "invokeSuspend", n = {"$this$launch", "durationScale"}, s = {"L$0", "F$0"})
                            static final class C03201 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                                float F$0;
                                private Object L$0;
                                int label;
                                final Transition<S> this$0;

                                C03201(Transition<S> transition, Continuation<? super C03201> continuation) {
                                    super(2, continuation);
                                    this.this$0 = transition;
                                }

                                public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                                    Continuation<Unit> c03201 = new C03201(this.this$0, continuation);
                                    c03201.L$0 = obj;
                                    return c03201;
                                }

                                public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                                    return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
                                }

                                public final Object invokeSuspend(Object obj) {
                                    final float durationScale;
                                    CoroutineScope coroutineScope;
                                    Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                                    int i = this.label;
                                    if (i == 0) {
                                        ResultKt.throwOnFailure(obj);
                                        CoroutineScope coroutineScope2 = (CoroutineScope) this.L$0;
                                        durationScale = SuspendAnimationKt.getDurationScale(coroutineScope2.getCoroutineContext());
                                        coroutineScope = coroutineScope2;
                                    } else {
                                        if (i != 1) {
                                            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                                        }
                                        durationScale = this.F$0;
                                        coroutineScope = (CoroutineScope) this.L$0;
                                        ResultKt.throwOnFailure(obj);
                                    }
                                    while (CoroutineScopeKt.isActive(coroutineScope)) {
                                        final Transition<S> transition = this.this$0;
                                        this.L$0 = coroutineScope;
                                        this.F$0 = durationScale;
                                        this.label = 1;
                                        if (MonotonicFrameClockKt.withFrameNanos(new Function1<Long, Unit>() {
                                            {
                                                super(1);
                                            }

                                            public Object invoke(Object obj2) {
                                                invoke(((Number) obj2).longValue());
                                                return Unit.INSTANCE;
                                            }

                                            public final void invoke(long j) {
                                                if (transition.isSeeking()) {
                                                    return;
                                                }
                                                transition.onFrame$animation_core_release(j, durationScale);
                                            }
                                        }, (Continuation) this) == coroutine_suspended) {
                                            return coroutine_suspended;
                                        }
                                    }
                                    return Unit.INSTANCE;
                                }
                            }

                            public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                                BuildersKt.launch$default(coroutineScope, (CoroutineContext) null, CoroutineStart.UNDISPATCHED, new C03201(this, null), 1, (Object) null);
                                return new DisposableEffectResult() {
                                    @Override
                                    public void dispose() {
                                    }
                                };
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    EffectsKt.DisposableEffect(coroutineScope, this, (Function1) objRememberedValue2, composerStartRestartGroup, i3);
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(1823982427);
                    composerStartRestartGroup.endReplaceGroup();
                }
                composerStartRestartGroup.endReplaceGroup();
            } else {
                composerStartRestartGroup.startReplaceGroup(1823992347);
                composerStartRestartGroup.endReplaceGroup();
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        } else {
            composerStartRestartGroup.skipToGroupEnd();
        }
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>(this) {
                final Transition<S> $tmp1_rcvr;

                {
                    super(2);
                    this.$tmp1_rcvr = this;
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i4) {
                    this.$tmp1_rcvr.animateTo$animation_core_release(s, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1));
                }
            });
        }
    }

    public final void seekAnimations$animation_core_release(long playTimeNanos) {
        if (getStartTimeNanos$animation_core_release() == Long.MIN_VALUE) {
            setStartTimeNanos$animation_core_release(playTimeNanos);
        }
        setPlayTimeNanos(playTimeNanos);
        setUpdateChildrenNeeded(false);
        SnapshotStateList<Transition<S>.TransitionAnimationState<?, ?>> snapshotStateList = this._animations;
        int size = snapshotStateList.size();
        for (int i = 0; i < size; i++) {
            snapshotStateList.get(i).seekTo$animation_core_release(playTimeNanos);
        }
        SnapshotStateList<Transition<?>> snapshotStateList2 = this._transitions;
        int size2 = snapshotStateList2.size();
        for (int i2 = 0; i2 < size2; i2++) {
            Transition<?> transition = snapshotStateList2.get(i2);
            if (!Intrinsics.areEqual(transition.getTargetState(), transition.getCurrentState())) {
                transition.seekAnimations$animation_core_release(playTimeNanos);
            }
        }
    }

    public final void setInitialAnimations$animation_core_release(SeekableTransitionState.SeekingAnimationState animationState) {
        SnapshotStateList<Transition<S>.TransitionAnimationState<?, ?>> snapshotStateList = this._animations;
        int size = snapshotStateList.size();
        for (int i = 0; i < size; i++) {
            snapshotStateList.get(i).setInitialValueAnimation$animation_core_release(animationState);
        }
        SnapshotStateList<Transition<?>> snapshotStateList2 = this._transitions;
        int size2 = snapshotStateList2.size();
        for (int i2 = 0; i2 < size2; i2++) {
            snapshotStateList2.get(i2).setInitialAnimations$animation_core_release(animationState);
        }
    }

    public final void resetAnimationFraction$animation_core_release(float fraction) {
        SnapshotStateList<Transition<S>.TransitionAnimationState<?, ?>> snapshotStateList = this._animations;
        int size = snapshotStateList.size();
        for (int i = 0; i < size; i++) {
            snapshotStateList.get(i).resetAnimationValue$animation_core_release(fraction);
        }
        SnapshotStateList<Transition<?>> snapshotStateList2 = this._transitions;
        int size2 = snapshotStateList2.size();
        for (int i2 = 0; i2 < size2; i2++) {
            snapshotStateList2.get(i2).resetAnimationFraction$animation_core_release(fraction);
        }
    }

    public final void clearInitialAnimations$animation_core_release() {
        SnapshotStateList<Transition<S>.TransitionAnimationState<?, ?>> snapshotStateList = this._animations;
        int size = snapshotStateList.size();
        for (int i = 0; i < size; i++) {
            snapshotStateList.get(i).clearInitialAnimation$animation_core_release();
        }
        SnapshotStateList<Transition<?>> snapshotStateList2 = this._transitions;
        int size2 = snapshotStateList2.size();
        for (int i2 = 0; i2 < size2; i2++) {
            snapshotStateList2.get(i2).clearInitialAnimations$animation_core_release();
        }
    }

    public final void updateInitialValues$animation_core_release() {
        SnapshotStateList<Transition<S>.TransitionAnimationState<?, ?>> snapshotStateList = this._animations;
        int size = snapshotStateList.size();
        for (int i = 0; i < size; i++) {
            snapshotStateList.get(i).updateInitialValue$animation_core_release();
        }
        SnapshotStateList<Transition<?>> snapshotStateList2 = this._transitions;
        int size2 = snapshotStateList2.size();
        for (int i2 = 0; i2 < size2; i2++) {
            snapshotStateList2.get(i2).updateInitialValues$animation_core_release();
        }
    }

    public String toString() {
        List<Transition<S>.TransitionAnimationState<?, ?>> animations = getAnimations();
        int size = animations.size();
        String str = "Transition animation values: ";
        for (int i = 0; i < size; i++) {
            str = str + animations.get(i) + ", ";
        }
        return str;
    }

    public final void onChildAnimationUpdated() {
        setUpdateChildrenNeeded(true);
        if (isSeeking()) {
            SnapshotStateList<Transition<S>.TransitionAnimationState<?, ?>> snapshotStateList = this._animations;
            int size = snapshotStateList.size();
            long jMax = 0;
            for (int i = 0; i < size; i++) {
                Transition<S>.TransitionAnimationState<?, ?> transitionAnimationState = snapshotStateList.get(i);
                jMax = Math.max(jMax, transitionAnimationState.getDurationNanos$animation_core_release());
                transitionAnimationState.seekTo$animation_core_release(this.lastSeekedTimeNanos);
            }
            setUpdateChildrenNeeded(false);
        }
    }

    @Metadata(d1 = {"\u0000^\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\u0010\t\n\u0002\b\t\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u000b\n\u0002\b\t\n\u0002\u0010\u0007\n\u0002\b\u0017\n\u0002\u0010\u0002\n\u0002\b\u001c\b\u0087\u0004\u0018\u0000*\u0004\b\u0001\u0010\u0001*\b\b\u0002\u0010\u0002*\u00020\u00032\b\u0012\u0004\u0012\u0002H\u00010\u0004B3\b\u0000\u0012\u0006\u0010\u0005\u001a\u00028\u0001\u0012\u0006\u0010\u0006\u001a\u00028\u0002\u0012\u0012\u0010\u0007\u001a\u000e\u0012\u0004\u0012\u00028\u0001\u0012\u0004\u0012\u00028\u00020\b\u0012\u0006\u0010\t\u001a\u00020\n¢\u0006\u0002\u0010\u000bJ\r\u0010O\u001a\u00020PH\u0000¢\u0006\u0002\bQJ\u001d\u0010R\u001a\u00020P2\u0006\u0010S\u001a\u00020\u001e2\u0006\u0010T\u001a\u00020.H\u0000¢\u0006\u0002\bUJ\r\u0010V\u001a\u00020PH\u0000¢\u0006\u0002\bWJ\u0015\u0010X\u001a\u00020P2\u0006\u0010Y\u001a\u000208H\u0000¢\u0006\u0002\bZJ\u0015\u0010[\u001a\u00020P2\u0006\u0010S\u001a\u00020\u001eH\u0000¢\u0006\u0002\b\\J\u0015\u0010]\u001a\u00020P2\u0006\u0010^\u001a\u00020(H\u0000¢\u0006\u0002\b_J\b\u0010`\u001a\u00020\nH\u0016J!\u0010a\u001a\u00020P2\b\b\u0002\u0010\u0005\u001a\u00028\u00012\b\b\u0002\u0010b\u001a\u00020.H\u0002¢\u0006\u0002\u0010cJ-\u0010d\u001a\u00020P2\u0006\u0010\u0005\u001a\u00028\u00012\u0006\u0010@\u001a\u00028\u00012\f\u0010\u0016\u001a\b\u0012\u0004\u0012\u00028\u00010\u0015H\u0000¢\u0006\u0004\be\u0010fJ\r\u0010g\u001a\u00020PH\u0000¢\u0006\u0002\bhJ%\u0010i\u001a\u00020P2\u0006\u0010@\u001a\u00028\u00012\f\u0010\u0016\u001a\b\u0012\u0004\u0012\u00028\u00010\u0015H\u0000¢\u0006\u0004\bj\u0010kRC\u0010\u000e\u001a\u000e\u0012\u0004\u0012\u00028\u0001\u0012\u0004\u0012\u00028\u00020\r2\u0012\u0010\f\u001a\u000e\u0012\u0004\u0012\u00028\u0001\u0012\u0004\u0012\u00028\u00020\r8F@BX\u0086\u008e\u0002¢\u0006\u0012\n\u0004\b\u0013\u0010\u0014\u001a\u0004\b\u000f\u0010\u0010\"\u0004\b\u0011\u0010\u0012R7\u0010\u0016\u001a\b\u0012\u0004\u0012\u00028\u00010\u00152\f\u0010\f\u001a\b\u0012\u0004\u0012\u00028\u00010\u00158F@BX\u0086\u008e\u0002¢\u0006\u0012\n\u0004\b\u001b\u0010\u0014\u001a\u0004\b\u0017\u0010\u0018\"\u0004\b\u0019\u0010\u001aR\u0014\u0010\u001c\u001a\b\u0012\u0004\u0012\u00028\u00010\u001dX\u0082\u0004¢\u0006\u0002\n\u0000R+\u0010\u001f\u001a\u00020\u001e2\u0006\u0010\f\u001a\u00020\u001e8@@@X\u0080\u008e\u0002¢\u0006\u0012\n\u0004\b$\u0010%\u001a\u0004\b \u0010!\"\u0004\b\"\u0010#R\u001c\u0010&\u001a\u0010\u0012\u0004\u0012\u00028\u0001\u0012\u0004\u0012\u00028\u0002\u0018\u00010\rX\u0082\u000e¢\u0006\u0002\n\u0000R\u001c\u0010'\u001a\u0004\u0018\u00010(X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b)\u0010*\"\u0004\b+\u0010,R\u0014\u0010-\u001a\b\u0012\u0004\u0012\u00028\u00010\u0015X\u0082\u0004¢\u0006\u0002\n\u0000R+\u0010/\u001a\u00020.2\u0006\u0010\f\u001a\u00020.8@@@X\u0080\u008e\u0002¢\u0006\u0012\n\u0004\b4\u0010\u0014\u001a\u0004\b0\u00101\"\u0004\b2\u00103R\u000e\u00105\u001a\u00020.X\u0082\u000e¢\u0006\u0002\n\u0000R\u0011\u0010\t\u001a\u00020\n¢\u0006\b\n\u0000\u001a\u0004\b6\u00107R+\u00109\u001a\u0002082\u0006\u0010\f\u001a\u0002088@@@X\u0080\u008e\u0002¢\u0006\u0012\n\u0004\b>\u0010?\u001a\u0004\b:\u0010;\"\u0004\b<\u0010=R+\u0010@\u001a\u00028\u00012\u0006\u0010\f\u001a\u00028\u00018B@BX\u0082\u008e\u0002¢\u0006\u0012\n\u0004\bE\u0010\u0014\u001a\u0004\bA\u0010B\"\u0004\bC\u0010DR\u001d\u0010\u0007\u001a\u000e\u0012\u0004\u0012\u00028\u0001\u0012\u0004\u0012\u00028\u00020\b¢\u0006\b\n\u0000\u001a\u0004\bF\u0010GR\u000e\u0010H\u001a\u00020.X\u0082\u000e¢\u0006\u0002\n\u0000R+\u0010I\u001a\u00028\u00012\u0006\u0010\f\u001a\u00028\u00018V@PX\u0096\u008e\u0002¢\u0006\u0012\n\u0004\bL\u0010\u0014\u001a\u0004\bJ\u0010B\"\u0004\bK\u0010DR\u0010\u0010M\u001a\u00028\u0002X\u0082\u000e¢\u0006\u0004\n\u0002\u0010N¨\u0006l"}, d2 = {"Landroidx/compose/animation/core/Transition$TransitionAnimationState;", "T", "V", "Landroidx/compose/animation/core/AnimationVector;", "Landroidx/compose/runtime/State;", "initialValue", "initialVelocityVector", "typeConverter", "Landroidx/compose/animation/core/TwoWayConverter;", "label", "", "(Landroidx/compose/animation/core/Transition;Ljava/lang/Object;Landroidx/compose/animation/core/AnimationVector;Landroidx/compose/animation/core/TwoWayConverter;Ljava/lang/String;)V", "<set-?>", "Landroidx/compose/animation/core/TargetBasedAnimation;", "animation", "getAnimation", "()Landroidx/compose/animation/core/TargetBasedAnimation;", "setAnimation", "(Landroidx/compose/animation/core/TargetBasedAnimation;)V", "animation$delegate", "Landroidx/compose/runtime/MutableState;", "Landroidx/compose/animation/core/FiniteAnimationSpec;", "animationSpec", "getAnimationSpec", "()Landroidx/compose/animation/core/FiniteAnimationSpec;", "setAnimationSpec", "(Landroidx/compose/animation/core/FiniteAnimationSpec;)V", "animationSpec$delegate", "defaultSpring", "Landroidx/compose/animation/core/SpringSpec;", "", "durationNanos", "getDurationNanos$animation_core_release", "()J", "setDurationNanos$animation_core_release", "(J)V", "durationNanos$delegate", "Landroidx/compose/runtime/MutableLongState;", "initialValueAnimation", "initialValueState", "Landroidx/compose/animation/core/SeekableTransitionState$SeekingAnimationState;", "getInitialValueState$animation_core_release", "()Landroidx/compose/animation/core/SeekableTransitionState$SeekingAnimationState;", "setInitialValueState$animation_core_release", "(Landroidx/compose/animation/core/SeekableTransitionState$SeekingAnimationState;)V", "interruptionSpec", "", "isFinished", "isFinished$animation_core_release", "()Z", "setFinished$animation_core_release", "(Z)V", "isFinished$delegate", "isSeeking", "getLabel", "()Ljava/lang/String;", "", "resetSnapValue", "getResetSnapValue$animation_core_release", "()F", "setResetSnapValue$animation_core_release", "(F)V", "resetSnapValue$delegate", "Landroidx/compose/runtime/MutableFloatState;", "targetValue", "getTargetValue", "()Ljava/lang/Object;", "setTargetValue", "(Ljava/lang/Object;)V", "targetValue$delegate", "getTypeConverter", "()Landroidx/compose/animation/core/TwoWayConverter;", "useOnlyInitialValue", "value", "getValue", "setValue$animation_core_release", "value$delegate", "velocityVector", "Landroidx/compose/animation/core/AnimationVector;", "clearInitialAnimation", "", "clearInitialAnimation$animation_core_release", "onPlayTimeChanged", "playTimeNanos", "scaleToEnd", "onPlayTimeChanged$animation_core_release", "resetAnimation", "resetAnimation$animation_core_release", "resetAnimationValue", "fraction", "resetAnimationValue$animation_core_release", "seekTo", "seekTo$animation_core_release", "setInitialValueAnimation", "animationState", "setInitialValueAnimation$animation_core_release", "toString", "updateAnimation", "isInterrupted", "(Ljava/lang/Object;Z)V", "updateInitialAndTargetValue", "updateInitialAndTargetValue$animation_core_release", "(Ljava/lang/Object;Ljava/lang/Object;Landroidx/compose/animation/core/FiniteAnimationSpec;)V", "updateInitialValue", "updateInitialValue$animation_core_release", "updateTargetValue", "updateTargetValue$animation_core_release", "(Ljava/lang/Object;Landroidx/compose/animation/core/FiniteAnimationSpec;)V", "animation-core_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public final class TransitionAnimationState<T, V extends AnimationVector> implements State<T> {

        private final MutableState animation;

        private final MutableState animationSpec;
        private final SpringSpec<T> defaultSpring;

        private final MutableLongState durationNanos;
        private TargetBasedAnimation<T, V> initialValueAnimation;
        private SeekableTransitionState.SeekingAnimationState initialValueState;
        private final FiniteAnimationSpec<T> interruptionSpec;

        private final MutableState isFinished;
        private boolean isSeeking;
        private final String label;

        private final MutableFloatState resetSnapValue;

        private final MutableState targetValue;
        private final TwoWayConverter<T, V> typeConverter;
        private boolean useOnlyInitialValue;

        private final MutableState value;
        private V velocityVector;

        public TransitionAnimationState(T t, V v, TwoWayConverter<T, V> twoWayConverter, String str) {
            Object objInvoke;
            this.typeConverter = twoWayConverter;
            this.label = str;
            this.targetValue = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(t, null, 2, null);
            SpringSpec<T> springSpecSpring$default = AnimationSpecKt.spring$default(0.0f, 0.0f, null, 7, null);
            this.defaultSpring = springSpecSpring$default;
            this.animationSpec = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(springSpecSpring$default, null, 2, null);
            this.animation = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(new TargetBasedAnimation(getAnimationSpec(), twoWayConverter, t, getTargetValue(), v), null, 2, null);
            this.isFinished = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(true, null, 2, null);
            this.resetSnapValue = PrimitiveSnapshotStateKt.mutableFloatStateOf(-1.0f);
            this.value = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(t, null, 2, null);
            this.velocityVector = v;
            this.durationNanos = SnapshotLongStateKt.mutableLongStateOf(getAnimation().getDurationNanos());
            Float f = VisibilityThresholdsKt.getVisibilityThresholdMap().get(twoWayConverter);
            if (f != null) {
                float fFloatValue = f.floatValue();
                AnimationVector animationVector = (AnimationVector) twoWayConverter.getConvertToVector().invoke(t);
                int size = animationVector.getSize();
                for (int i = 0; i < size; i++) {
                    animationVector.set$animation_core_release(i, fFloatValue);
                }
                objInvoke = this.typeConverter.getConvertFromVector().invoke(animationVector);
            } else {
                objInvoke = null;
            }
            this.interruptionSpec = AnimationSpecKt.spring$default(0.0f, 0.0f, objInvoke, 3, null);
        }

        public final TwoWayConverter<T, V> getTypeConverter() {
            return this.typeConverter;
        }

        public final String getLabel() {
            return this.label;
        }

        private final T getTargetValue() {
            return this.targetValue.getValue();
        }

        private final void setTargetValue(T t) {
            this.targetValue.setValue(t);
        }

        private final void setAnimationSpec(FiniteAnimationSpec<T> finiteAnimationSpec) {
            this.animationSpec.setValue(finiteAnimationSpec);
        }

        public final FiniteAnimationSpec<T> getAnimationSpec() {
            return (FiniteAnimationSpec) this.animationSpec.getValue();
        }

        private final void setAnimation(TargetBasedAnimation<T, V> targetBasedAnimation) {
            this.animation.setValue(targetBasedAnimation);
        }

        public final TargetBasedAnimation<T, V> getAnimation() {
            return (TargetBasedAnimation) this.animation.getValue();
        }

        public final SeekableTransitionState.SeekingAnimationState getInitialValueState() {
            return this.initialValueState;
        }

        public final void setInitialValueState$animation_core_release(SeekableTransitionState.SeekingAnimationState seekingAnimationState) {
            this.initialValueState = seekingAnimationState;
        }

        public final boolean isFinished$animation_core_release() {
            return ((Boolean) this.isFinished.getValue()).booleanValue();
        }

        public final void setFinished$animation_core_release(boolean z) {
            this.isFinished.setValue(Boolean.valueOf(z));
        }

        public final float getResetSnapValue$animation_core_release() {
            return this.resetSnapValue.getFloatValue();
        }

        public final void setResetSnapValue$animation_core_release(float f) {
            this.resetSnapValue.setFloatValue(f);
        }

        @Override
        public T getValue() {
            return this.value.getValue();
        }

        public void setValue$animation_core_release(T t) {
            this.value.setValue(t);
        }

        public final long getDurationNanos$animation_core_release() {
            return this.durationNanos.getLongValue();
        }

        public final void setDurationNanos$animation_core_release(long j) {
            this.durationNanos.setLongValue(j);
        }

        public final void onPlayTimeChanged$animation_core_release(long playTimeNanos, boolean scaleToEnd) {
            if (scaleToEnd) {
                playTimeNanos = getAnimation().getDurationNanos();
            }
            setValue$animation_core_release(getAnimation().getValueFromNanos(playTimeNanos));
            this.velocityVector = (V) getAnimation().getVelocityVectorFromNanos(playTimeNanos);
            if (getAnimation().isFinishedFromNanos(playTimeNanos)) {
                setFinished$animation_core_release(true);
            }
        }

        public final void seekTo$animation_core_release(long playTimeNanos) {
            if (getResetSnapValue$animation_core_release() == -1.0f) {
                this.isSeeking = true;
                if (Intrinsics.areEqual(getAnimation().getTargetValue(), getAnimation().getInitialValue())) {
                    setValue$animation_core_release(getAnimation().getTargetValue());
                } else {
                    setValue$animation_core_release(getAnimation().getValueFromNanos(playTimeNanos));
                    this.velocityVector = (V) getAnimation().getVelocityVectorFromNanos(playTimeNanos);
                }
            }
        }

        public final void updateInitialValue$animation_core_release() {
            TargetBasedAnimation<T, V> targetBasedAnimation;
            SeekableTransitionState.SeekingAnimationState seekingAnimationState = this.initialValueState;
            if (seekingAnimationState == null || (targetBasedAnimation = this.initialValueAnimation) == null) {
                return;
            }
            long jRoundToLong = MathKt.roundToLong(seekingAnimationState.getDurationNanos() * ((double) seekingAnimationState.getValue()));
            T valueFromNanos = targetBasedAnimation.getValueFromNanos(jRoundToLong);
            if (this.useOnlyInitialValue) {
                getAnimation().setMutableTargetValue$animation_core_release(valueFromNanos);
            }
            getAnimation().setMutableInitialValue$animation_core_release(valueFromNanos);
            setDurationNanos$animation_core_release(getAnimation().getDurationNanos());
            if (getResetSnapValue$animation_core_release() == -2.0f || this.useOnlyInitialValue) {
                setValue$animation_core_release(valueFromNanos);
            } else {
                seekTo$animation_core_release(Transition.this.getPlayTimeNanos());
            }
            if (jRoundToLong >= seekingAnimationState.getDurationNanos()) {
                this.initialValueState = null;
                this.initialValueAnimation = null;
            } else {
                seekingAnimationState.setComplete(false);
            }
        }

        static void updateAnimation$default(TransitionAnimationState transitionAnimationState, Object obj, boolean z, int i, Object obj2) {
            if ((i & 1) != 0) {
                obj = transitionAnimationState.getValue();
            }
            if ((i & 2) != 0) {
                z = false;
            }
            transitionAnimationState.updateAnimation(obj, z);
        }

        private final void updateAnimation(T initialValue, boolean isInterrupted) {
            FiniteAnimationSpec<T> finiteAnimationSpecDelayed;
            TargetBasedAnimation<T, V> targetBasedAnimation = this.initialValueAnimation;
            if (Intrinsics.areEqual(targetBasedAnimation != null ? targetBasedAnimation.getTargetValue() : null, getTargetValue())) {
                setAnimation(new TargetBasedAnimation<>(this.interruptionSpec, this.typeConverter, initialValue, initialValue, AnimationVectorsKt.newInstance(this.velocityVector)));
                this.useOnlyInitialValue = true;
                setDurationNanos$animation_core_release(getAnimation().getDurationNanos());
                return;
            }
            FiniteAnimationSpec<T> animationSpec = (!isInterrupted || this.isSeeking || (getAnimationSpec() instanceof SpringSpec)) ? getAnimationSpec() : this.interruptionSpec;
            if (Transition.this.getPlayTimeNanos() <= 0) {
                finiteAnimationSpecDelayed = animationSpec;
            } else {
                finiteAnimationSpecDelayed = AnimationSpecKt.delayed(animationSpec, Transition.this.getPlayTimeNanos());
            }
            setAnimation(new TargetBasedAnimation<>(finiteAnimationSpecDelayed, this.typeConverter, initialValue, getTargetValue(), this.velocityVector));
            setDurationNanos$animation_core_release(getAnimation().getDurationNanos());
            this.useOnlyInitialValue = false;
            Transition.this.onChildAnimationUpdated();
        }

        public final void resetAnimation$animation_core_release() {
            setResetSnapValue$animation_core_release(-2.0f);
        }

        public final void resetAnimationValue$animation_core_release(float fraction) {
            Object targetValue;
            if (fraction == -4.0f || fraction == -5.0f) {
                TargetBasedAnimation<T, V> targetBasedAnimation = this.initialValueAnimation;
                if (targetBasedAnimation != null) {
                    getAnimation().setMutableInitialValue$animation_core_release(targetBasedAnimation.getTargetValue());
                    this.initialValueState = null;
                    this.initialValueAnimation = null;
                }
                if (fraction == -4.0f) {
                    targetValue = getAnimation().getInitialValue();
                } else {
                    targetValue = getAnimation().getTargetValue();
                }
                getAnimation().setMutableInitialValue$animation_core_release(targetValue);
                getAnimation().setMutableTargetValue$animation_core_release(targetValue);
                setValue$animation_core_release(targetValue);
                setDurationNanos$animation_core_release(getAnimation().getDurationNanos());
                return;
            }
            setResetSnapValue$animation_core_release(fraction);
        }

        public final void setInitialValueAnimation$animation_core_release(SeekableTransitionState.SeekingAnimationState animationState) {
            if (!Intrinsics.areEqual(getAnimation().getTargetValue(), getAnimation().getInitialValue())) {
                this.initialValueAnimation = getAnimation();
                this.initialValueState = animationState;
            }
            setAnimation(new TargetBasedAnimation<>(this.interruptionSpec, this.typeConverter, getValue(), getValue(), AnimationVectorsKt.newInstance(this.velocityVector)));
            setDurationNanos$animation_core_release(getAnimation().getDurationNanos());
            this.useOnlyInitialValue = true;
        }

        public final void clearInitialAnimation$animation_core_release() {
            this.initialValueAnimation = null;
            this.initialValueState = null;
            this.useOnlyInitialValue = false;
        }

        public String toString() {
            return "current value: " + getValue() + ", target: " + getTargetValue() + ", spec: " + getAnimationSpec();
        }

        public final void updateTargetValue$animation_core_release(T targetValue, FiniteAnimationSpec<T> animationSpec) {
            if (this.useOnlyInitialValue) {
                TargetBasedAnimation<T, V> targetBasedAnimation = this.initialValueAnimation;
                if (Intrinsics.areEqual(targetValue, targetBasedAnimation != null ? targetBasedAnimation.getTargetValue() : null)) {
                    return;
                }
            }
            if (Intrinsics.areEqual(getTargetValue(), targetValue) && getResetSnapValue$animation_core_release() == -1.0f) {
                return;
            }
            setTargetValue(targetValue);
            setAnimationSpec(animationSpec);
            updateAnimation(getResetSnapValue$animation_core_release() == -3.0f ? targetValue : getValue(), !isFinished$animation_core_release());
            setFinished$animation_core_release(getResetSnapValue$animation_core_release() == -3.0f);
            if (getResetSnapValue$animation_core_release() >= 0.0f) {
                setValue$animation_core_release(getAnimation().getValueFromNanos((long) (getAnimation().getDurationNanos() * getResetSnapValue$animation_core_release())));
            } else if (getResetSnapValue$animation_core_release() == -3.0f) {
                setValue$animation_core_release(targetValue);
            }
            this.useOnlyInitialValue = false;
            setResetSnapValue$animation_core_release(-1.0f);
        }

        public final void updateInitialAndTargetValue$animation_core_release(T initialValue, T targetValue, FiniteAnimationSpec<T> animationSpec) {
            setTargetValue(targetValue);
            setAnimationSpec(animationSpec);
            if (Intrinsics.areEqual(getAnimation().getInitialValue(), initialValue) && Intrinsics.areEqual(getAnimation().getTargetValue(), targetValue)) {
                return;
            }
            updateAnimation$default(this, initialValue, false, 2, null);
        }
    }

    @Metadata(d1 = {"\u0000 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\b\u0002\u0018\u0000*\u0004\b\u0001\u0010\u00012\b\u0012\u0004\u0012\u0002H\u00010\u0002B\u0015\u0012\u0006\u0010\u0003\u001a\u00028\u0001\u0012\u0006\u0010\u0004\u001a\u00028\u0001¢\u0006\u0002\u0010\u0005J\u0013\u0010\n\u001a\u00020\u000b2\b\u0010\f\u001a\u0004\u0018\u00010\rH\u0096\u0002J\b\u0010\u000e\u001a\u00020\u000fH\u0016R\u0016\u0010\u0003\u001a\u00028\u0001X\u0096\u0004¢\u0006\n\n\u0002\u0010\b\u001a\u0004\b\u0006\u0010\u0007R\u0016\u0010\u0004\u001a\u00028\u0001X\u0096\u0004¢\u0006\n\n\u0002\u0010\b\u001a\u0004\b\t\u0010\u0007¨\u0006\u0010"}, d2 = {"Landroidx/compose/animation/core/Transition$SegmentImpl;", "S", "Landroidx/compose/animation/core/Transition$Segment;", "initialState", "targetState", "(Ljava/lang/Object;Ljava/lang/Object;)V", "getInitialState", "()Ljava/lang/Object;", "Ljava/lang/Object;", "getTargetState", "equals", "", "other", "", "hashCode", "", "animation-core_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    private static final class SegmentImpl<S> implements Segment<S> {
        private final S initialState;
        private final S targetState;

        @Override
        public boolean isTransitioningTo(Object obj, Object obj2) {
            return Segment.CC.$default$isTransitioningTo(this, obj, obj2);
        }

        public SegmentImpl(S s, S s2) {
            this.initialState = s;
            this.targetState = s2;
        }

        @Override
        public S getInitialState() {
            return this.initialState;
        }

        @Override
        public S getTargetState() {
            return this.targetState;
        }

        public boolean equals(Object other) {
            if (other instanceof Segment) {
                Segment segment = (Segment) other;
                if (Intrinsics.areEqual(getInitialState(), segment.getInitialState()) && Intrinsics.areEqual(getTargetState(), segment.getTargetState())) {
                    return true;
                }
            }
            return false;
        }

        public int hashCode() {
            S initialState = getInitialState();
            int iHashCode = (initialState != null ? initialState.hashCode() : 0) * 31;
            S targetState = getTargetState();
            return iHashCode + (targetState != null ? targetState.hashCode() : 0);
        }
    }

    @Metadata(d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0002\b\u0002\bf\u0018\u0000*\u0004\b\u0001\u0010\u00012\u00020\u0002J\u001a\u0010\b\u001a\u00020\t*\u00028\u00012\u0006\u0010\u0006\u001a\u00028\u0001H\u0096\u0004¢\u0006\u0002\u0010\nR\u0012\u0010\u0003\u001a\u00028\u0001X¦\u0004¢\u0006\u0006\u001a\u0004\b\u0004\u0010\u0005R\u0012\u0010\u0006\u001a\u00028\u0001X¦\u0004¢\u0006\u0006\u001a\u0004\b\u0007\u0010\u0005ø\u0001\u0000\u0082\u0002\u0006\n\u0004\b!0\u0001¨\u0006\u000bÀ\u0006\u0003"}, d2 = {"Landroidx/compose/animation/core/Transition$Segment;", "S", "", "initialState", "getInitialState", "()Ljava/lang/Object;", "targetState", "getTargetState", "isTransitioningTo", "", "(Ljava/lang/Object;Ljava/lang/Object;)Z", "animation-core_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public interface Segment<S> {
        S getInitialState();

        S getTargetState();

        boolean isTransitioningTo(S s, S s2);

        public final class CC {
            public static boolean $default$isTransitioningTo(Segment _this, Object obj, Object obj2) {
                return Intrinsics.areEqual(obj, _this.getInitialState()) && Intrinsics.areEqual(obj2, _this.getTargetState());
            }
        }

        @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
        public static final class DefaultImpls {
            @Deprecated
            public static <S> boolean isTransitioningTo(Segment<S> segment, S s, S s2) {
                return CC.$default$isTransitioningTo(segment, s, s2);
            }
        }
    }

    @Metadata(d1 = {"\u0000T\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\f\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0003\b\u0087\u0004\u0018\u0000*\u0004\b\u0001\u0010\u0001*\b\b\u0002\u0010\u0002*\u00020\u00032\u00020\u0004:\u0001&B#\b\u0000\u0012\u0012\u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00028\u0001\u0012\u0004\u0012\u00028\u00020\u0006\u0012\u0006\u0010\u0007\u001a\u00020\b¢\u0006\u0002\u0010\tJT\u0010\u0018\u001a\b\u0012\u0004\u0012\u00028\u00010\u00192#\u0010\u001a\u001a\u001f\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000\u001c\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00010\u001d0\u001b¢\u0006\u0002\b\u001e2!\u0010\u001f\u001a\u001d\u0012\u0013\u0012\u00118\u0000¢\u0006\f\b \u0012\b\b!\u0012\u0004\b\b(\"\u0012\u0004\u0012\u00028\u00010\u001bJ\r\u0010#\u001a\u00020$H\u0000¢\u0006\u0002\b%R{\u0010\r\u001a*\u0012\u0004\u0012\u00028\u0001\u0012\u0004\u0012\u00028\u0002\u0018\u00010\u000bR\u0018\u0012\u0004\u0012\u00028\u0001\u0012\u0004\u0012\u00028\u00020\u0000R\b\u0012\u0004\u0012\u00028\u00000\f2.\u0010\n\u001a*\u0012\u0004\u0012\u00028\u0001\u0012\u0004\u0012\u00028\u0002\u0018\u00010\u000bR\u0018\u0012\u0004\u0012\u00028\u0001\u0012\u0004\u0012\u00028\u00020\u0000R\b\u0012\u0004\u0012\u00028\u00000\f8@@@X\u0080\u008e\u0002¢\u0006\u0012\n\u0004\b\u0012\u0010\u0013\u001a\u0004\b\u000e\u0010\u000f\"\u0004\b\u0010\u0010\u0011R\u0011\u0010\u0007\u001a\u00020\b¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u0015R\u001d\u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00028\u0001\u0012\u0004\u0012\u00028\u00020\u0006¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u0017¨\u0006'"}, d2 = {"Landroidx/compose/animation/core/Transition$DeferredAnimation;", "T", "V", "Landroidx/compose/animation/core/AnimationVector;", "", "typeConverter", "Landroidx/compose/animation/core/TwoWayConverter;", "label", "", "(Landroidx/compose/animation/core/Transition;Landroidx/compose/animation/core/TwoWayConverter;Ljava/lang/String;)V", "<set-?>", "Landroidx/compose/animation/core/Transition$DeferredAnimation$DeferredAnimationData;", "Landroidx/compose/animation/core/Transition;", "data", "getData$animation_core_release", "()Landroidx/compose/animation/core/Transition$DeferredAnimation$DeferredAnimationData;", "setData$animation_core_release", "(Landroidx/compose/animation/core/Transition$DeferredAnimation$DeferredAnimationData;)V", "data$delegate", "Landroidx/compose/runtime/MutableState;", "getLabel", "()Ljava/lang/String;", "getTypeConverter", "()Landroidx/compose/animation/core/TwoWayConverter;", "animate", "Landroidx/compose/runtime/State;", "transitionSpec", "Lkotlin/Function1;", "Landroidx/compose/animation/core/Transition$Segment;", "Landroidx/compose/animation/core/FiniteAnimationSpec;", "Lkotlin/ExtensionFunctionType;", "targetValueByState", "Lkotlin/ParameterName;", HintConstants.AUTOFILL_HINT_NAME, "state", "setupSeeking", "", "setupSeeking$animation_core_release", "DeferredAnimationData", "animation-core_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public final class DeferredAnimation<T, V extends AnimationVector> {

        private final MutableState data = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
        private final String label;
        private final TwoWayConverter<T, V> typeConverter;

        public DeferredAnimation(TwoWayConverter<T, V> twoWayConverter, String str) {
            this.typeConverter = twoWayConverter;
            this.label = str;
        }

        public final TwoWayConverter<T, V> getTypeConverter() {
            return this.typeConverter;
        }

        public final String getLabel() {
            return this.label;
        }

        public final Transition<S>.DeferredAnimationData<T, V>.DeferredAnimationData<T, V> getData$animation_core_release() {
            return (DeferredAnimationData) this.data.getValue();
        }

        public final void setData$animation_core_release(Transition<S>.DeferredAnimationData<T, V>.DeferredAnimationData<T, V> deferredAnimationData) {
            this.data.setValue(deferredAnimationData);
        }

        @Metadata(d1 = {"\u0000>\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u000f\n\u0002\u0010\u0002\n\u0002\b\u0002\b\u0080\u0004\u0018\u0000*\u0004\b\u0003\u0010\u0001*\b\b\u0004\u0010\u0002*\u00020\u00032\b\u0012\u0004\u0012\u0002H\u00010\u0004Bk\u0012\u001c\u0010\u0005\u001a\u0018\u0012\u0004\u0012\u00028\u0003\u0012\u0004\u0012\u00028\u00040\u0006R\b\u0012\u0004\u0012\u00028\u00000\u0007\u0012#\u0010\b\u001a\u001f\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000\n\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00030\u000b0\t¢\u0006\u0002\b\f\u0012!\u0010\r\u001a\u001d\u0012\u0013\u0012\u00118\u0000¢\u0006\f\b\u000e\u0012\b\b\u000f\u0012\u0004\b\b(\u0010\u0012\u0004\u0012\u00028\u00030\t¢\u0006\u0002\u0010\u0011J\u0014\u0010\u001d\u001a\u00020\u001e2\f\u0010\u001f\u001a\b\u0012\u0004\u0012\u00028\u00000\nR'\u0010\u0005\u001a\u0018\u0012\u0004\u0012\u00028\u0003\u0012\u0004\u0012\u00028\u00040\u0006R\b\u0012\u0004\u0012\u00028\u00000\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0013R5\u0010\r\u001a\u001d\u0012\u0013\u0012\u00118\u0000¢\u0006\f\b\u000e\u0012\b\b\u000f\u0012\u0004\b\b(\u0010\u0012\u0004\u0012\u00028\u00030\tX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0014\u0010\u0015\"\u0004\b\u0016\u0010\u0017R7\u0010\b\u001a\u001f\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000\n\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00030\u000b0\t¢\u0006\u0002\b\fX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0018\u0010\u0015\"\u0004\b\u0019\u0010\u0017R\u0014\u0010\u001a\u001a\u00028\u00038VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u001b\u0010\u001c¨\u0006 "}, d2 = {"Landroidx/compose/animation/core/Transition$DeferredAnimation$DeferredAnimationData;", "T", "V", "Landroidx/compose/animation/core/AnimationVector;", "Landroidx/compose/runtime/State;", "animation", "Landroidx/compose/animation/core/Transition$TransitionAnimationState;", "Landroidx/compose/animation/core/Transition;", "transitionSpec", "Lkotlin/Function1;", "Landroidx/compose/animation/core/Transition$Segment;", "Landroidx/compose/animation/core/FiniteAnimationSpec;", "Lkotlin/ExtensionFunctionType;", "targetValueByState", "Lkotlin/ParameterName;", HintConstants.AUTOFILL_HINT_NAME, "state", "(Landroidx/compose/animation/core/Transition$DeferredAnimation;Landroidx/compose/animation/core/Transition$TransitionAnimationState;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;)V", "getAnimation", "()Landroidx/compose/animation/core/Transition$TransitionAnimationState;", "getTargetValueByState", "()Lkotlin/jvm/functions/Function1;", "setTargetValueByState", "(Lkotlin/jvm/functions/Function1;)V", "getTransitionSpec", "setTransitionSpec", "value", "getValue", "()Ljava/lang/Object;", "updateAnimationStates", "", "segment", "animation-core_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
        public final class DeferredAnimationData<T, V extends AnimationVector> implements State<T> {
            private final Transition<S>.TransitionAnimationState<T, V> animation;
            private Function1<? super S, ? extends T> targetValueByState;
            private Function1<? super Segment<S>, ? extends FiniteAnimationSpec<T>> transitionSpec;

            public DeferredAnimationData(Transition<S>.TransitionAnimationState<T, V> transitionAnimationState, Function1<? super Segment<S>, ? extends FiniteAnimationSpec<T>> function1, Function1<? super S, ? extends T> function2) {
                this.animation = transitionAnimationState;
                this.transitionSpec = function1;
                this.targetValueByState = function2;
            }

            public final Transition<S>.TransitionAnimationState<T, V> getAnimation() {
                return this.animation;
            }

            public final Function1<Segment<S>, FiniteAnimationSpec<T>> getTransitionSpec() {
                return this.transitionSpec;
            }

            public final void setTransitionSpec(Function1<? super Segment<S>, ? extends FiniteAnimationSpec<T>> function1) {
                this.transitionSpec = function1;
            }

            public final Function1<S, T> getTargetValueByState() {
                return this.targetValueByState;
            }

            public final void setTargetValueByState(Function1<? super S, ? extends T> function1) {
                this.targetValueByState = function1;
            }

            public final void updateAnimationStates(Segment<S> segment) {
                Object objInvoke = this.targetValueByState.invoke(segment.getTargetState());
                if (Transition.this.isSeeking()) {
                    this.animation.updateInitialAndTargetValue$animation_core_release((T) this.targetValueByState.invoke(segment.getInitialState()), (T) objInvoke, (FiniteAnimationSpec) this.transitionSpec.invoke(segment));
                } else {
                    this.animation.updateTargetValue$animation_core_release((T) objInvoke, (FiniteAnimationSpec) this.transitionSpec.invoke(segment));
                }
            }

            @Override
            public T getValue() {
                updateAnimationStates(Transition.this.getSegment());
                return this.animation.getValue();
            }
        }

        public final State<T> animate(Function1<? super Segment<S>, ? extends FiniteAnimationSpec<T>> transitionSpec, Function1<? super S, ? extends T> targetValueByState) {
            Transition<S>.DeferredAnimationData<T, V>.DeferredAnimationData<T, V> data$animation_core_release = getData$animation_core_release();
            if (data$animation_core_release == null) {
                Transition<S> transition = Transition.this;
                data$animation_core_release = new DeferredAnimationData<>(transition.new TransitionAnimationState(targetValueByState.invoke(transition.getCurrentState()), AnimationStateKt.createZeroVectorFrom(this.typeConverter, targetValueByState.invoke(Transition.this.getCurrentState())), this.typeConverter, this.label), transitionSpec, targetValueByState);
                Transition<S> transition2 = Transition.this;
                setData$animation_core_release(data$animation_core_release);
                transition2.addAnimation$animation_core_release(data$animation_core_release.getAnimation());
            }
            Transition<S> transition3 = Transition.this;
            data$animation_core_release.setTargetValueByState(targetValueByState);
            data$animation_core_release.setTransitionSpec(transitionSpec);
            data$animation_core_release.updateAnimationStates(transition3.getSegment());
            return data$animation_core_release;
        }

        public final void setupSeeking$animation_core_release() {
            Transition<S>.DeferredAnimationData<T, V>.DeferredAnimationData<T, V> data$animation_core_release = getData$animation_core_release();
            if (data$animation_core_release != null) {
                Transition<S> transition = Transition.this;
                data$animation_core_release.getAnimation().updateInitialAndTargetValue$animation_core_release(data$animation_core_release.getTargetValueByState().invoke(transition.getSegment().getInitialState()), data$animation_core_release.getTargetValueByState().invoke(transition.getSegment().getTargetState()), (FiniteAnimationSpec) data$animation_core_release.getTransitionSpec().invoke(transition.getSegment()));
            }
        }
    }

    public final void removeAnimation$animation_core_release(Transition<S>.DeferredAnimation<?, ?> deferredAnimation) {
        Transition<S>.TransitionAnimationState<?, ?> animation;
        Transition<S>.DeferredAnimationData<?, ?>.DeferredAnimationData<?, V> data$animation_core_release = deferredAnimation.getData$animation_core_release();
        if (data$animation_core_release == 0 || (animation = data$animation_core_release.getAnimation()) == null) {
            return;
        }
        removeAnimation$animation_core_release(animation);
    }
}
