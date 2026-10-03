package androidx.compose.animation.core;

import androidx.collection.MutableObjectList;
import androidx.compose.runtime.MonotonicFrameClockKt;
import androidx.compose.runtime.MutableFloatState;
import androidx.compose.runtime.MutableState;
import androidx.compose.runtime.PrimitiveSnapshotStateKt;
import androidx.compose.runtime.SnapshotStateKt__SnapshotStateKt;
import java.util.concurrent.CancellationException;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.collections.ArraysKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.DebugProbesKt;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.FloatCompanionObject;
import kotlin.jvm.internal.Intrinsics;
import kotlin.math.MathKt;
import kotlin.ranges.IntRange;
import kotlin.ranges.RangesKt;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CancellableContinuation;
import kotlinx.coroutines.CancellableContinuationImpl;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.CoroutineScopeKt;
import kotlinx.coroutines.CoroutineStart;
import kotlinx.coroutines.sync.Mutex;
import kotlinx.coroutines.sync.MutexKt;

@Metadata(d1 = {"\u0000d\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0010\t\n\u0002\u0010\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0010\u0007\n\u0002\b\t\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u001a\b\u0007\u0018\u0000 X*\u0004\b\u0000\u0010\u00012\b\u0012\u0004\u0012\u0002H\u00010\u0002:\u0002XYB\r\u0012\u0006\u0010\u0003\u001a\u00028\u0000¢\u0006\u0002\u0010\u0004J\u000e\u0010<\u001a\u00020\bH\u0082@¢\u0006\u0002\u0010=J*\u0010>\u001a\u00020\b2\b\b\u0002\u00101\u001a\u00028\u00002\u0010\b\u0002\u0010?\u001a\n\u0012\u0004\u0012\u00020!\u0018\u00010@H\u0086@¢\u0006\u0002\u0010AJ\u000e\u0010B\u001a\u00020\bH\u0082@¢\u0006\u0002\u0010=J\b\u0010C\u001a\u00020\bH\u0002J\b\u0010D\u001a\u00020\bH\u0002J\r\u0010E\u001a\u00020\bH\u0000¢\u0006\u0002\bFJ\r\u0010G\u001a\u00020\bH\u0000¢\u0006\u0002\bHJ\u0018\u0010I\u001a\u00020\b2\u0006\u0010J\u001a\u00020\u00192\u0006\u0010K\u001a\u00020\u0007H\u0002J\u000e\u0010L\u001a\u00020\bH\u0082@¢\u0006\u0002\u0010=J\"\u0010M\u001a\u00020\b2\b\b\u0001\u0010#\u001a\u00020!2\b\b\u0002\u00101\u001a\u00028\u0000H\u0086@¢\u0006\u0002\u0010NJ\b\u0010O\u001a\u00020\bH\u0002J\u0016\u0010P\u001a\u00020\b2\u0006\u00101\u001a\u00028\u0000H\u0086@¢\u0006\u0002\u0010QJ\u001b\u0010R\u001a\u00020\b2\f\u0010:\u001a\b\u0012\u0004\u0012\u00028\u00000;H\u0010¢\u0006\u0002\bSJ\r\u0010T\u001a\u00020\bH\u0010¢\u0006\u0002\bUJ\u000e\u0010V\u001a\u00020\bH\u0082@¢\u0006\u0002\u0010=J\u000e\u0010W\u001a\u00020\bH\u0082@¢\u0006\u0002\u0010=R\u001a\u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\b0\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R\u001c\u0010\t\u001a\u00028\u0000X\u0080\u000e¢\u0006\u0010\n\u0002\u0010\r\u001a\u0004\b\n\u0010\u000b\"\u0004\b\f\u0010\u0004R\"\u0010\u000e\u001a\n\u0012\u0004\u0012\u00028\u0000\u0018\u00010\u000fX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0010\u0010\u0011\"\u0004\b\u0012\u0010\u0013R\u0014\u0010\u0014\u001a\u00020\u0015X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u0017R\u0010\u0010\u0018\u001a\u0004\u0018\u00010\u0019X\u0082\u000e¢\u0006\u0002\n\u0000R+\u0010\u001b\u001a\u00028\u00002\u0006\u0010\u001a\u001a\u00028\u00008V@PX\u0096\u008e\u0002¢\u0006\u0012\n\u0004\b\u001e\u0010\u001f\u001a\u0004\b\u001c\u0010\u000b\"\u0004\b\u001d\u0010\u0004R\u000e\u0010 \u001a\u00020!X\u0082\u000e¢\u0006\u0002\n\u0000R\u001a\u0010\"\u001a\u000e\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\b0\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R+\u0010#\u001a\u00020!2\u0006\u0010\u001a\u001a\u00020!8G@BX\u0086\u008e\u0002¢\u0006\u0012\n\u0004\b(\u0010)\u001a\u0004\b$\u0010%\"\u0004\b&\u0010'R\u0014\u0010*\u001a\b\u0012\u0004\u0012\u00020\u00190+X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010,\u001a\u00020\u0007X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010-\u001a\u00020.X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010/\u001a\b\u0012\u0004\u0012\u00020\b00X\u0082\u0004¢\u0006\u0002\n\u0000R+\u00101\u001a\u00028\u00002\u0006\u0010\u001a\u001a\u00028\u00008V@PX\u0096\u008e\u0002¢\u0006\u0012\n\u0004\b4\u0010\u001f\u001a\u0004\b2\u0010\u000b\"\u0004\b3\u0010\u0004R\u001a\u00105\u001a\u00020\u0007X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b6\u00107\"\u0004\b8\u00109R\u0016\u0010:\u001a\n\u0012\u0004\u0012\u00028\u0000\u0018\u00010;X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006Z"}, d2 = {"Landroidx/compose/animation/core/SeekableTransitionState;", "S", "Landroidx/compose/animation/core/TransitionState;", "initialState", "(Ljava/lang/Object;)V", "animateOneFrameLambda", "Lkotlin/Function1;", "", "", "composedTargetState", "getComposedTargetState$animation_core_release", "()Ljava/lang/Object;", "setComposedTargetState$animation_core_release", "Ljava/lang/Object;", "compositionContinuation", "Lkotlinx/coroutines/CancellableContinuation;", "getCompositionContinuation$animation_core_release", "()Lkotlinx/coroutines/CancellableContinuation;", "setCompositionContinuation$animation_core_release", "(Lkotlinx/coroutines/CancellableContinuation;)V", "compositionContinuationMutex", "Lkotlinx/coroutines/sync/Mutex;", "getCompositionContinuationMutex$animation_core_release", "()Lkotlinx/coroutines/sync/Mutex;", "currentAnimation", "Landroidx/compose/animation/core/SeekableTransitionState$SeekingAnimationState;", "<set-?>", "currentState", "getCurrentState", "setCurrentState$animation_core_release", "currentState$delegate", "Landroidx/compose/runtime/MutableState;", "durationScale", "", "firstFrameLambda", "fraction", "getFraction", "()F", "setFraction", "(F)V", "fraction$delegate", "Landroidx/compose/runtime/MutableFloatState;", "initialValueAnimations", "Landroidx/collection/MutableObjectList;", "lastFrameTimeNanos", "mutatorMutex", "Landroidx/compose/animation/core/MutatorMutex;", "recalculateTotalDurationNanos", "Lkotlin/Function0;", "targetState", "getTargetState", "setTargetState$animation_core_release", "targetState$delegate", "totalDurationNanos", "getTotalDurationNanos$animation_core_release", "()J", "setTotalDurationNanos$animation_core_release", "(J)V", "transition", "Landroidx/compose/animation/core/Transition;", "animateOneFrame", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "animateTo", "animationSpec", "Landroidx/compose/animation/core/FiniteAnimationSpec;", "(Ljava/lang/Object;Landroidx/compose/animation/core/FiniteAnimationSpec;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "doOneFrame", "endAllAnimations", "moveAnimationToInitialState", "observeTotalDuration", "observeTotalDuration$animation_core_release", "onTotalDurationChanged", "onTotalDurationChanged$animation_core_release", "recalculateAnimationValue", "animation", "deltaPlayTimeNanos", "runAnimations", "seekTo", "(FLjava/lang/Object;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "seekToFraction", "snapTo", "(Ljava/lang/Object;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "transitionConfigured", "transitionConfigured$animation_core_release", "transitionRemoved", "transitionRemoved$animation_core_release", "waitForComposition", "waitForCompositionAfterTargetStateChange", "Companion", "SeekingAnimationState", "animation-core_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class SeekableTransitionState<S> extends TransitionState<S> {
    private final Function1<Long, Unit> animateOneFrameLambda;
    private S composedTargetState;
    private CancellableContinuation<? super S> compositionContinuation;
    private final Mutex compositionContinuationMutex;
    private SeekingAnimationState currentAnimation;

    private final MutableState currentState;
    private float durationScale;
    private final Function1<Long, Unit> firstFrameLambda;

    private final MutableFloatState fraction;
    private final MutableObjectList<SeekingAnimationState> initialValueAnimations;
    private long lastFrameTimeNanos;
    private final MutatorMutex mutatorMutex;
    private final Function0<Unit> recalculateTotalDurationNanos;

    private final MutableState targetState;
    private long totalDurationNanos;
    private Transition<S> transition;
    private static final Companion Companion = new Companion(null);
    public static final int $stable = 8;
    private static final AnimationVector1D ZeroVelocity = new AnimationVector1D(0.0f);
    private static final AnimationVector1D Target1 = new AnimationVector1D(1.0f);

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.animation.core.SeekableTransitionState", f = "Transition.kt", i = {0, 1}, l = {370, 373}, m = "runAnimations", n = {"this", "this"}, s = {"L$0", "L$0"})
    static final class C03051 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;
        final SeekableTransitionState<S> this$0;

        C03051(SeekableTransitionState<S> seekableTransitionState, Continuation<? super C03051> continuation) {
            super(continuation);
            this.this$0 = seekableTransitionState;
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return this.this$0.runAnimations((Continuation) this);
        }
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.animation.core.SeekableTransitionState", f = "Transition.kt", i = {0, 0, 1, 1}, l = {566, 2186}, m = "waitForComposition", n = {"this", "expectedState", "this", "expectedState"}, s = {"L$0", "L$1", "L$0", "L$1"})
    static final class C03081 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;
        final SeekableTransitionState<S> this$0;

        C03081(SeekableTransitionState<S> seekableTransitionState, Continuation<? super C03081> continuation) {
            super(continuation);
            this.this$0 = seekableTransitionState;
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return this.this$0.waitForComposition((Continuation) this);
        }
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.animation.core.SeekableTransitionState", f = "Transition.kt", i = {0, 0, 1, 1}, l = {542, 2186}, m = "waitForCompositionAfterTargetStateChange", n = {"this", "expectedState", "this", "expectedState"}, s = {"L$0", "L$1", "L$0", "L$1"})
    static final class C03091 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;
        final SeekableTransitionState<S> this$0;

        C03091(SeekableTransitionState<S> seekableTransitionState, Continuation<? super C03091> continuation) {
            super(continuation);
            this.this$0 = seekableTransitionState;
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return this.this$0.waitForCompositionAfterTargetStateChange((Continuation) this);
        }
    }

    public SeekableTransitionState(S s) {
        super(null);
        this.targetState = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(s, null, 2, null);
        this.currentState = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(s, null, 2, null);
        this.composedTargetState = s;
        this.recalculateTotalDurationNanos = new Function0<Unit>(this) {
            final SeekableTransitionState<S> this$0;

            {
                super(0);
                this.this$0 = this;
            }

            public Object invoke() {
                m447invoke();
                return Unit.INSTANCE;
            }

            public final void m447invoke() {
                SeekableTransitionState<S> seekableTransitionState = this.this$0;
                Transition transition = ((SeekableTransitionState) seekableTransitionState).transition;
                seekableTransitionState.setTotalDurationNanos$animation_core_release(transition != null ? transition.getTotalDurationNanos() : 0L);
            }
        };
        this.fraction = PrimitiveSnapshotStateKt.mutableFloatStateOf(0.0f);
        this.compositionContinuationMutex = MutexKt.Mutex$default(false, 1, (Object) null);
        this.mutatorMutex = new MutatorMutex();
        this.lastFrameTimeNanos = Long.MIN_VALUE;
        this.initialValueAnimations = new MutableObjectList<>(0, 1, null);
        this.firstFrameLambda = new Function1<Long, Unit>(this) {
            final SeekableTransitionState<S> this$0;

            {
                super(1);
                this.this$0 = this;
            }

            public Object invoke(Object obj) {
                invoke(((Number) obj).longValue());
                return Unit.INSTANCE;
            }

            public final void invoke(long j) {
                ((SeekableTransitionState) this.this$0).lastFrameTimeNanos = j;
            }
        };
        this.animateOneFrameLambda = new Function1<Long, Unit>(this) {
            final SeekableTransitionState<S> this$0;

            {
                super(1);
                this.this$0 = this;
            }

            public Object invoke(Object obj) {
                invoke(((Number) obj).longValue());
                return Unit.INSTANCE;
            }

            public final void invoke(long j) {
                long j2 = j - ((SeekableTransitionState) this.this$0).lastFrameTimeNanos;
                ((SeekableTransitionState) this.this$0).lastFrameTimeNanos = j;
                long jRoundToLong = MathKt.roundToLong(j2 / ((double) ((SeekableTransitionState) this.this$0).durationScale));
                if (((SeekableTransitionState) this.this$0).initialValueAnimations.isNotEmpty()) {
                    MutableObjectList mutableObjectList = ((SeekableTransitionState) this.this$0).initialValueAnimations;
                    SeekableTransitionState<S> seekableTransitionState = this.this$0;
                    Object[] objArr = mutableObjectList.content;
                    int i = mutableObjectList._size;
                    int i2 = 0;
                    for (int i3 = 0; i3 < i; i3++) {
                        SeekableTransitionState.SeekingAnimationState seekingAnimationState = (SeekableTransitionState.SeekingAnimationState) objArr[i3];
                        seekableTransitionState.recalculateAnimationValue(seekingAnimationState, jRoundToLong);
                        seekingAnimationState.setComplete(true);
                    }
                    Transition transition = ((SeekableTransitionState) this.this$0).transition;
                    if (transition != null) {
                        transition.updateInitialValues$animation_core_release();
                    }
                    MutableObjectList mutableObjectList2 = ((SeekableTransitionState) this.this$0).initialValueAnimations;
                    int i4 = mutableObjectList2._size;
                    Object[] objArr2 = mutableObjectList2.content;
                    IntRange intRangeUntil = RangesKt.until(0, mutableObjectList2._size);
                    int first = intRangeUntil.getFirst();
                    int last = intRangeUntil.getLast();
                    if (first <= last) {
                        while (true) {
                            objArr2[first - i2] = objArr2[first];
                            if (((SeekableTransitionState.SeekingAnimationState) objArr2[first]).getIsComplete()) {
                                i2++;
                            }
                            if (first == last) {
                                break;
                            } else {
                                first++;
                            }
                        }
                    }
                    ArraysKt.fill(objArr2, (Object) null, i4 - i2, i4);
                    mutableObjectList2._size -= i2;
                }
                SeekableTransitionState.SeekingAnimationState seekingAnimationState2 = ((SeekableTransitionState) this.this$0).currentAnimation;
                if (seekingAnimationState2 != null) {
                    seekingAnimationState2.setDurationNanos(this.this$0.getTotalDurationNanos());
                    this.this$0.recalculateAnimationValue(seekingAnimationState2, jRoundToLong);
                    this.this$0.setFraction(seekingAnimationState2.getValue());
                    if (seekingAnimationState2.getValue() == 1.0f) {
                        ((SeekableTransitionState) this.this$0).currentAnimation = null;
                    }
                    this.this$0.seekToFraction();
                }
            }
        };
    }

    @Override
    public S getTargetState() {
        return (S) this.targetState.getValue();
    }

    @Override
    public void setTargetState$animation_core_release(S s) {
        this.targetState.setValue(s);
    }

    @Override
    public S getCurrentState() {
        return (S) this.currentState.getValue();
    }

    @Override
    public void setCurrentState$animation_core_release(S s) {
        this.currentState.setValue(s);
    }

    public final S getComposedTargetState$animation_core_release() {
        return this.composedTargetState;
    }

    public final void setComposedTargetState$animation_core_release(S s) {
        this.composedTargetState = s;
    }

    public final long getTotalDurationNanos() {
        return this.totalDurationNanos;
    }

    public final void setTotalDurationNanos$animation_core_release(long j) {
        this.totalDurationNanos = j;
    }

    public final void setFraction(float f) {
        this.fraction.setFloatValue(f);
    }

    public final float getFraction() {
        return this.fraction.getFloatValue();
    }

    public final CancellableContinuation<S> getCompositionContinuation$animation_core_release() {
        return this.compositionContinuation;
    }

    public final void setCompositionContinuation$animation_core_release(CancellableContinuation<? super S> cancellableContinuation) {
        this.compositionContinuation = cancellableContinuation;
    }

    public final Mutex getCompositionContinuationMutex() {
        return this.compositionContinuationMutex;
    }

    public final void endAllAnimations() {
        Transition<S> transition = this.transition;
        if (transition != null) {
            transition.clearInitialAnimations$animation_core_release();
        }
        this.initialValueAnimations.clear();
        if (this.currentAnimation != null) {
            this.currentAnimation = null;
            setFraction(1.0f);
            seekToFraction();
        }
    }

    public final Object runAnimations(Continuation<? super Unit> continuation) {
        C03051 c03051;
        SeekableTransitionState<S> seekableTransitionState;
        if (continuation instanceof C03051) {
            c03051 = (C03051) continuation;
            if ((c03051.label & Integer.MIN_VALUE) != 0) {
                c03051.label -= Integer.MIN_VALUE;
            } else {
                c03051 = new C03051(this, continuation);
            }
        } else {
            c03051 = new C03051(this, continuation);
        }
        Object obj = c03051.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c03051.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            if (this.initialValueAnimations.isEmpty() && this.currentAnimation == null) {
                return Unit.INSTANCE;
            }
            if (SuspendAnimationKt.getDurationScale(c03051.getContext()) == 0.0f) {
                endAllAnimations();
                this.lastFrameTimeNanos = Long.MIN_VALUE;
                return Unit.INSTANCE;
            }
            if (this.lastFrameTimeNanos == Long.MIN_VALUE) {
                Function1<Long, Unit> function1 = this.firstFrameLambda;
                c03051.L$0 = this;
                c03051.label = 1;
                if (MonotonicFrameClockKt.withFrameNanos(function1, c03051) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            }
            seekableTransitionState = this;
        } else {
            if (i != 1 && i != 2) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            seekableTransitionState = (SeekableTransitionState) c03051.L$0;
            ResultKt.throwOnFailure(obj);
        }
        do {
            if (seekableTransitionState.initialValueAnimations.isNotEmpty() || seekableTransitionState.currentAnimation != null) {
                c03051.L$0 = seekableTransitionState;
                c03051.label = 2;
            } else {
                seekableTransitionState.lastFrameTimeNanos = Long.MIN_VALUE;
                return Unit.INSTANCE;
            }
        } while (seekableTransitionState.animateOneFrame(c03051) != coroutine_suspended);
        return coroutine_suspended;
    }

    public final Object doOneFrame(Continuation<? super Unit> continuation) {
        if (this.lastFrameTimeNanos == Long.MIN_VALUE) {
            Object objWithFrameNanos = MonotonicFrameClockKt.withFrameNanos(this.firstFrameLambda, continuation);
            return objWithFrameNanos == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objWithFrameNanos : Unit.INSTANCE;
        }
        Object objAnimateOneFrame = animateOneFrame(continuation);
        return objAnimateOneFrame == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objAnimateOneFrame : Unit.INSTANCE;
    }

    public final Object animateOneFrame(Continuation<? super Unit> continuation) {
        float durationScale = SuspendAnimationKt.getDurationScale(continuation.getContext());
        if (durationScale <= 0.0f) {
            endAllAnimations();
            return Unit.INSTANCE;
        }
        this.durationScale = durationScale;
        Object objWithFrameNanos = MonotonicFrameClockKt.withFrameNanos(this.animateOneFrameLambda, continuation);
        return objWithFrameNanos == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objWithFrameNanos : Unit.INSTANCE;
    }

    public final void recalculateAnimationValue(SeekingAnimationState animation, long deltaPlayTimeNanos) {
        long progressNanos = animation.getProgressNanos() + deltaPlayTimeNanos;
        animation.setProgressNanos(progressNanos);
        long animationSpecDuration = animation.getAnimationSpecDuration();
        if (progressNanos >= animationSpecDuration) {
            animation.setValue(1.0f);
            return;
        }
        VectorizedAnimationSpec<AnimationVector1D> animationSpec = animation.getAnimationSpec();
        if (animationSpec != null) {
            AnimationVector1D start = animation.getStart();
            AnimationVector1D animationVector1D = Target1;
            AnimationVector1D initialVelocity = animation.getInitialVelocity();
            if (initialVelocity == null) {
                initialVelocity = ZeroVelocity;
            }
            animation.setValue(RangesKt.coerceIn(((AnimationVector1D) animationSpec.getValueFromNanos(progressNanos, start, animationVector1D, initialVelocity)).get$animation_core_release(0), 0.0f, 1.0f));
            return;
        }
        animation.setValue(VectorConvertersKt.lerp(animation.getStart().get$animation_core_release(0), 1.0f, progressNanos / animationSpecDuration));
    }

    public final Object snapTo(S s, Continuation<? super Unit> continuation) {
        Transition<S> transition = this.transition;
        if (transition == null) {
            return Unit.INSTANCE;
        }
        if (Intrinsics.areEqual(getCurrentState(), s) && Intrinsics.areEqual(getTargetState(), s)) {
            return Unit.INSTANCE;
        }
        Object objMutate$default = MutatorMutex.mutate$default(this.mutatorMutex, null, new C03072(this, s, transition, null), continuation, 1, null);
        return objMutate$default == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objMutate$default : Unit.INSTANCE;
    }

    @Metadata(d1 = {"\u0000\b\n\u0000\n\u0002\u0010\u0002\n\u0000\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002H\u008a@"}, d2 = {"<anonymous>", "", "S"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.animation.core.SeekableTransitionState$snapTo$2", f = "Transition.kt", i = {}, l = {477}, m = "invokeSuspend", n = {}, s = {})
    static final class C03072 extends SuspendLambda implements Function1<Continuation<? super Unit>, Object> {
        final S $targetState;
        final Transition<S> $transition;
        int label;
        final SeekableTransitionState<S> this$0;

        C03072(SeekableTransitionState<S> seekableTransitionState, S s, Transition<S> transition, Continuation<? super C03072> continuation) {
            super(1, continuation);
            this.this$0 = seekableTransitionState;
            this.$targetState = s;
            this.$transition = transition;
        }

        public final Continuation<Unit> create(Continuation<?> continuation) {
            return new C03072(this.this$0, this.$targetState, this.$transition, continuation);
        }

        public final Object invoke(Continuation<? super Unit> continuation) {
            return create(continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) {
            float f;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.this$0.endAllAnimations();
                ((SeekableTransitionState) this.this$0).lastFrameTimeNanos = Long.MIN_VALUE;
                this.this$0.setFraction(0.0f);
                S s = this.$targetState;
                if (Intrinsics.areEqual(s, this.this$0.getCurrentState())) {
                    f = -4.0f;
                } else {
                    f = Intrinsics.areEqual(s, this.this$0.getTargetState()) ? -5.0f : -3.0f;
                }
                this.$transition.updateTarget$animation_core_release(this.$targetState);
                this.$transition.setPlayTimeNanos(0L);
                this.this$0.setTargetState$animation_core_release(this.$targetState);
                this.this$0.setFraction(0.0f);
                this.this$0.setCurrentState$animation_core_release(this.$targetState);
                this.$transition.resetAnimationFraction$animation_core_release(f);
                if (f == -3.0f) {
                    this.label = 1;
                    if (this.this$0.waitForCompositionAfterTargetStateChange((Continuation) this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            this.$transition.onTransitionEnd$animation_core_release();
            return Unit.INSTANCE;
        }
    }

    public static Object seekTo$default(SeekableTransitionState seekableTransitionState, float f, Object obj, Continuation continuation, int i, Object obj2) {
        if ((i & 2) != 0) {
            obj = seekableTransitionState.getTargetState();
        }
        return seekableTransitionState.seekTo(f, obj, continuation);
    }

    public final Object seekTo(float f, S s, Continuation<? super Unit> continuation) {
        boolean z = false;
        if (0.0f <= f && f <= 1.0f) {
            z = true;
        }
        if (!z) {
            PreconditionsKt.throwIllegalArgumentException("Expecting fraction between 0 and 1. Got " + f);
        }
        Transition<S> transition = this.transition;
        if (transition == null) {
            return Unit.INSTANCE;
        }
        Object objMutate$default = MutatorMutex.mutate$default(this.mutatorMutex, null, new C03063(s, getTargetState(), this, transition, f, null), continuation, 1, null);
        return objMutate$default == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objMutate$default : Unit.INSTANCE;
    }

    @Metadata(d1 = {"\u0000\b\n\u0000\n\u0002\u0010\u0002\n\u0000\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002H\u008a@"}, d2 = {"<anonymous>", "", "S"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.animation.core.SeekableTransitionState$seekTo$3", f = "Transition.kt", i = {}, l = {509}, m = "invokeSuspend", n = {}, s = {})
    static final class C03063 extends SuspendLambda implements Function1<Continuation<? super Unit>, Object> {
        final float $fraction;
        final S $oldTargetState;
        final S $targetState;
        final Transition<S> $transition;
        int label;
        final SeekableTransitionState<S> this$0;

        C03063(S s, S s2, SeekableTransitionState<S> seekableTransitionState, Transition<S> transition, float f, Continuation<? super C03063> continuation) {
            super(1, continuation);
            this.$targetState = s;
            this.$oldTargetState = s2;
            this.this$0 = seekableTransitionState;
            this.$transition = transition;
            this.$fraction = f;
        }

        public final Continuation<Unit> create(Continuation<?> continuation) {
            return new C03063(this.$targetState, this.$oldTargetState, this.this$0, this.$transition, this.$fraction, continuation);
        }

        public final Object invoke(Continuation<? super Unit> continuation) {
            return create(continuation).invokeSuspend(Unit.INSTANCE);
        }

        @Metadata(d1 = {"\u0000\f\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\u00020\u0003H\u008a@"}, d2 = {"<anonymous>", "", "S", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
        @DebugMetadata(c = "androidx.compose.animation.core.SeekableTransitionState$seekTo$3$1", f = "Transition.kt", i = {}, l = {531}, m = "invokeSuspend", n = {}, s = {})
        static final class AnonymousClass1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
            final float $fraction;
            final S $oldTargetState;
            final S $targetState;
            final Transition<S> $transition;
            private Object L$0;
            int label;
            final SeekableTransitionState<S> this$0;

            AnonymousClass1(S s, S s2, SeekableTransitionState<S> seekableTransitionState, Transition<S> transition, float f, Continuation<? super AnonymousClass1> continuation) {
                super(2, continuation);
                this.$targetState = s;
                this.$oldTargetState = s2;
                this.this$0 = seekableTransitionState;
                this.$transition = transition;
                this.$fraction = f;
            }

            public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                Continuation<Unit> anonymousClass1 = new AnonymousClass1(this.$targetState, this.$oldTargetState, this.this$0, this.$transition, this.$fraction, continuation);
                anonymousClass1.L$0 = obj;
                return anonymousClass1;
            }

            public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
            }

            public final Object invokeSuspend(Object obj) {
                Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                int i = this.label;
                if (i == 0) {
                    ResultKt.throwOnFailure(obj);
                    CoroutineScope coroutineScope = (CoroutineScope) this.L$0;
                    if (!Intrinsics.areEqual(this.$targetState, this.$oldTargetState)) {
                        this.this$0.moveAnimationToInitialState();
                    } else {
                        ((SeekableTransitionState) this.this$0).currentAnimation = null;
                        if (Intrinsics.areEqual(this.this$0.getCurrentState(), this.$targetState)) {
                            return Unit.INSTANCE;
                        }
                    }
                    if (!Intrinsics.areEqual(this.$targetState, this.$oldTargetState)) {
                        this.$transition.updateTarget$animation_core_release(this.$targetState);
                        this.$transition.setPlayTimeNanos(0L);
                        this.this$0.setTargetState$animation_core_release(this.$targetState);
                        this.$transition.resetAnimationFraction$animation_core_release(this.$fraction);
                    }
                    this.this$0.setFraction(this.$fraction);
                    if (!((SeekableTransitionState) this.this$0).initialValueAnimations.isNotEmpty()) {
                        ((SeekableTransitionState) this.this$0).lastFrameTimeNanos = Long.MIN_VALUE;
                    } else {
                        BuildersKt.launch$default(coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new C17841(this.this$0, null), 3, (Object) null);
                    }
                    this.label = 1;
                    if (this.this$0.waitForCompositionAfterTargetStateChange((Continuation) this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } else {
                    if (i != 1) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                }
                this.this$0.seekToFraction();
                return Unit.INSTANCE;
            }

            @Metadata(d1 = {"\u0000\f\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\u00020\u0003H\u008a@"}, d2 = {"<anonymous>", "", "S", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
            @DebugMetadata(c = "androidx.compose.animation.core.SeekableTransitionState$seekTo$3$1$1", f = "Transition.kt", i = {}, l = {527}, m = "invokeSuspend", n = {}, s = {})
            static final class C17841 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                int label;
                final SeekableTransitionState<S> this$0;

                C17841(SeekableTransitionState<S> seekableTransitionState, Continuation<? super C17841> continuation) {
                    super(2, continuation);
                    this.this$0 = seekableTransitionState;
                }

                public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                    return new C17841(this.this$0, continuation);
                }

                public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                    return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
                }

                public final Object invokeSuspend(Object obj) {
                    Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                    int i = this.label;
                    if (i == 0) {
                        ResultKt.throwOnFailure(obj);
                        this.label = 1;
                        if (this.this$0.runAnimations((Continuation) this) == coroutine_suspended) {
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

        public final Object invokeSuspend(Object obj) {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (CoroutineScopeKt.coroutineScope(new AnonymousClass1(this.$targetState, this.$oldTargetState, this.this$0, this.$transition, this.$fraction, null), (Continuation) this) == coroutine_suspended) {
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

    public final Object waitForCompositionAfterTargetStateChange(Continuation<? super Unit> continuation) {
        C03091 c03091;
        Object targetState;
        SeekableTransitionState<S> seekableTransitionState;
        Object obj;
        SeekableTransitionState<S> seekableTransitionState2;
        if (continuation instanceof C03091) {
            c03091 = (C03091) continuation;
            if ((c03091.label & Integer.MIN_VALUE) != 0) {
                c03091.label -= Integer.MIN_VALUE;
            } else {
                c03091 = new C03091(this, continuation);
            }
        } else {
            c03091 = new C03091(this, continuation);
        }
        Object obj2 = c03091.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c03091.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj2);
            targetState = getTargetState();
            Mutex mutex = this.compositionContinuationMutex;
            c03091.L$0 = this;
            c03091.L$1 = targetState;
            c03091.label = 1;
            if (Mutex.DefaultImpls.lock$default(mutex, (Object) null, c03091, 1, (Object) null) == coroutine_suspended) {
                return coroutine_suspended;
            }
            seekableTransitionState = this;
        } else {
            if (i == 1) {
                Object obj3 = c03091.L$1;
                seekableTransitionState = (SeekableTransitionState) c03091.L$0;
                ResultKt.throwOnFailure(obj2);
                targetState = obj3;
            } else {
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                obj = c03091.L$1;
                seekableTransitionState2 = (SeekableTransitionState) c03091.L$0;
                ResultKt.throwOnFailure(obj2);
            }
            if (!Intrinsics.areEqual(obj2, obj)) {
                seekableTransitionState2.lastFrameTimeNanos = Long.MIN_VALUE;
                throw new CancellationException("snapTo() was canceled because state was changed to " + obj2 + " instead of " + obj);
            }
            return Unit.INSTANCE;
        }
        if (Intrinsics.areEqual(targetState, seekableTransitionState.composedTargetState)) {
            Mutex.DefaultImpls.unlock$default(seekableTransitionState.compositionContinuationMutex, (Object) null, 1, (Object) null);
        } else {
            c03091.L$0 = seekableTransitionState;
            c03091.L$1 = targetState;
            c03091.label = 2;
            Continuation continuation2 = (Continuation) c03091;
            CancellableContinuationImpl cancellableContinuationImpl = new CancellableContinuationImpl(IntrinsicsKt.intercepted(continuation2), 1);
            cancellableContinuationImpl.initCancellability();
            seekableTransitionState.setCompositionContinuation$animation_core_release((CancellableContinuation) cancellableContinuationImpl);
            Mutex.DefaultImpls.unlock$default(seekableTransitionState.getCompositionContinuationMutex(), (Object) null, 1, (Object) null);
            Object result = cancellableContinuationImpl.getResult();
            if (result == IntrinsicsKt.getCOROUTINE_SUSPENDED()) {
                DebugProbesKt.probeCoroutineSuspended(continuation2);
            }
            if (result == coroutine_suspended) {
                return coroutine_suspended;
            }
            obj = targetState;
            obj2 = result;
            seekableTransitionState2 = seekableTransitionState;
            if (!Intrinsics.areEqual(obj2, obj)) {
                seekableTransitionState2.lastFrameTimeNanos = Long.MIN_VALUE;
                throw new CancellationException("snapTo() was canceled because state was changed to " + obj2 + " instead of " + obj);
            }
        }
        return Unit.INSTANCE;
    }

    public final Object waitForComposition(Continuation<? super Unit> continuation) {
        C03081 c03081;
        Object targetState;
        SeekableTransitionState<S> seekableTransitionState;
        Object obj;
        SeekableTransitionState<S> seekableTransitionState2;
        if (continuation instanceof C03081) {
            c03081 = (C03081) continuation;
            if ((c03081.label & Integer.MIN_VALUE) != 0) {
                c03081.label -= Integer.MIN_VALUE;
            } else {
                c03081 = new C03081(this, continuation);
            }
        } else {
            c03081 = new C03081(this, continuation);
        }
        Object obj2 = c03081.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c03081.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj2);
            targetState = getTargetState();
            Mutex mutex = this.compositionContinuationMutex;
            c03081.L$0 = this;
            c03081.L$1 = targetState;
            c03081.label = 1;
            if (Mutex.DefaultImpls.lock$default(mutex, (Object) null, c03081, 1, (Object) null) == coroutine_suspended) {
                return coroutine_suspended;
            }
            seekableTransitionState = this;
        } else {
            if (i == 1) {
                Object obj3 = c03081.L$1;
                seekableTransitionState = (SeekableTransitionState) c03081.L$0;
                ResultKt.throwOnFailure(obj2);
                targetState = obj3;
            } else {
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                obj = c03081.L$1;
                seekableTransitionState2 = (SeekableTransitionState) c03081.L$0;
                ResultKt.throwOnFailure(obj2);
            }
            if (Intrinsics.areEqual(obj2, obj)) {
                seekableTransitionState2.lastFrameTimeNanos = Long.MIN_VALUE;
                throw new CancellationException("targetState while waiting for composition");
            }
            return Unit.INSTANCE;
        }
        c03081.L$0 = seekableTransitionState;
        c03081.L$1 = targetState;
        c03081.label = 2;
        Continuation continuation2 = (Continuation) c03081;
        CancellableContinuationImpl cancellableContinuationImpl = new CancellableContinuationImpl(IntrinsicsKt.intercepted(continuation2), 1);
        cancellableContinuationImpl.initCancellability();
        seekableTransitionState.setCompositionContinuation$animation_core_release((CancellableContinuation) cancellableContinuationImpl);
        Mutex.DefaultImpls.unlock$default(seekableTransitionState.getCompositionContinuationMutex(), (Object) null, 1, (Object) null);
        Object result = cancellableContinuationImpl.getResult();
        if (result == IntrinsicsKt.getCOROUTINE_SUSPENDED()) {
            DebugProbesKt.probeCoroutineSuspended(continuation2);
        }
        if (result == coroutine_suspended) {
            return coroutine_suspended;
        }
        obj = targetState;
        obj2 = result;
        seekableTransitionState2 = seekableTransitionState;
        if (Intrinsics.areEqual(obj2, obj)) {
            seekableTransitionState2.lastFrameTimeNanos = Long.MIN_VALUE;
            throw new CancellationException("targetState while waiting for composition");
        }
        return Unit.INSTANCE;
    }

    public final void moveAnimationToInitialState() {
        Transition<S> transition = this.transition;
        if (transition == null) {
            return;
        }
        SeekingAnimationState seekingAnimationState = this.currentAnimation;
        if (seekingAnimationState == null) {
            if (this.totalDurationNanos <= 0 || getFraction() == 1.0f || Intrinsics.areEqual(getCurrentState(), getTargetState())) {
                seekingAnimationState = null;
            } else {
                seekingAnimationState = new SeekingAnimationState();
                seekingAnimationState.setValue(getFraction());
                long j = this.totalDurationNanos;
                seekingAnimationState.setDurationNanos(j);
                seekingAnimationState.setAnimationSpecDuration(MathKt.roundToLong(j * (1.0d - ((double) getFraction()))));
                seekingAnimationState.getStart().set$animation_core_release(0, getFraction());
            }
        }
        if (seekingAnimationState != null) {
            seekingAnimationState.setDurationNanos(this.totalDurationNanos);
            this.initialValueAnimations.add(seekingAnimationState);
            transition.setInitialAnimations$animation_core_release(seekingAnimationState);
        }
        this.currentAnimation = null;
    }

    public static Object animateTo$default(SeekableTransitionState seekableTransitionState, Object obj, FiniteAnimationSpec finiteAnimationSpec, Continuation continuation, int i, Object obj2) {
        if ((i & 1) != 0) {
            obj = seekableTransitionState.getTargetState();
        }
        if ((i & 2) != 0) {
            finiteAnimationSpec = null;
        }
        return seekableTransitionState.animateTo(obj, finiteAnimationSpec, continuation);
    }

    @Metadata(d1 = {"\u0000\b\n\u0000\n\u0002\u0010\u0002\n\u0000\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002H\u008a@"}, d2 = {"<anonymous>", "", "S"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.animation.core.SeekableTransitionState$animateTo$2", f = "Transition.kt", i = {}, l = {623}, m = "invokeSuspend", n = {}, s = {})
    static final class C03042 extends SuspendLambda implements Function1<Continuation<? super Unit>, Object> {
        final FiniteAnimationSpec<Float> $animationSpec;
        final S $targetState;
        final Transition<S> $transition;
        int label;
        final SeekableTransitionState<S> this$0;

        C03042(Transition<S> transition, SeekableTransitionState<S> seekableTransitionState, S s, FiniteAnimationSpec<Float> finiteAnimationSpec, Continuation<? super C03042> continuation) {
            super(1, continuation);
            this.$transition = transition;
            this.this$0 = seekableTransitionState;
            this.$targetState = s;
            this.$animationSpec = finiteAnimationSpec;
        }

        public final Continuation<Unit> create(Continuation<?> continuation) {
            return new C03042(this.$transition, this.this$0, this.$targetState, this.$animationSpec, continuation);
        }

        public final Object invoke(Continuation<? super Unit> continuation) {
            return create(continuation).invokeSuspend(Unit.INSTANCE);
        }

        @Metadata(d1 = {"\u0000\f\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\u00020\u0003H\u008a@"}, d2 = {"<anonymous>", "", "S", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
        @DebugMetadata(c = "androidx.compose.animation.core.SeekableTransitionState$animateTo$2$1", f = "Transition.kt", i = {0}, l = {2191, 636, 638, 690, 692}, m = "invokeSuspend", n = {"$this$withLock_u24default$iv"}, s = {"L$0"})
        static final class AnonymousClass1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
            final FiniteAnimationSpec<Float> $animationSpec;
            final S $targetState;
            final Transition<S> $transition;
            Object L$0;
            Object L$1;
            int label;
            final SeekableTransitionState<S> this$0;

            AnonymousClass1(SeekableTransitionState<S> seekableTransitionState, S s, Transition<S> transition, FiniteAnimationSpec<Float> finiteAnimationSpec, Continuation<? super AnonymousClass1> continuation) {
                super(2, continuation);
                this.this$0 = seekableTransitionState;
                this.$targetState = s;
                this.$transition = transition;
                this.$animationSpec = finiteAnimationSpec;
            }

            public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                return new AnonymousClass1(this.this$0, this.$targetState, this.$transition, this.$animationSpec, continuation);
            }

            public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
            }

            public final Object invokeSuspend(Object obj) {
                Mutex mutex;
                SeekableTransitionState<S> seekableTransitionState;
                SeekingAnimationState seekingAnimationState;
                FiniteAnimationSpec<Float> finiteAnimationSpec;
                VectorizedAnimationSpec<AnimationVector1D> vectorizedAnimationSpecVectorize;
                VectorizedAnimationSpec<AnimationVector1D> animationSpec;
                AnimationVector1D zeroVelocity;
                long jRoundToLong;
                AnimationVector1D initialVelocity;
                Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                int i = this.label;
                try {
                    if (i != 0) {
                        if (i == 1) {
                            seekableTransitionState = (SeekableTransitionState) this.L$1;
                            mutex = (Mutex) this.L$0;
                            ResultKt.throwOnFailure(obj);
                        } else {
                            if (i == 2) {
                                ResultKt.throwOnFailure(obj);
                                this.label = 3;
                                if (this.this$0.waitForCompositionAfterTargetStateChange((Continuation) this) == coroutine_suspended) {
                                    return coroutine_suspended;
                                }
                                if (!Intrinsics.areEqual(this.this$0.getCurrentState(), this.$targetState)) {
                                    if (this.this$0.getFraction() < 1.0f) {
                                        seekingAnimationState = ((SeekableTransitionState) this.this$0).currentAnimation;
                                        finiteAnimationSpec = this.$animationSpec;
                                        if (finiteAnimationSpec != null) {
                                            vectorizedAnimationSpecVectorize = finiteAnimationSpec.vectorize((TwoWayConverter<Float, V>) VectorConvertersKt.getVectorConverter(FloatCompanionObject.INSTANCE));
                                        } else {
                                            vectorizedAnimationSpecVectorize = null;
                                        }
                                        if (seekingAnimationState != null) {
                                            if (seekingAnimationState != null) {
                                                animationSpec = seekingAnimationState.getAnimationSpec();
                                            } else {
                                                animationSpec = null;
                                            }
                                            if (animationSpec != null) {
                                                long progressNanos = seekingAnimationState.getProgressNanos();
                                                AnimationVector1D start = seekingAnimationState.getStart();
                                                AnimationVector1D target1 = SeekableTransitionState.Companion.getTarget1();
                                                initialVelocity = seekingAnimationState.getInitialVelocity();
                                                if (initialVelocity == null) {
                                                    initialVelocity = SeekableTransitionState.Companion.getZeroVelocity();
                                                }
                                                zeroVelocity = (AnimationVector1D) animationSpec.getVelocityFromNanos(progressNanos, start, target1, initialVelocity);
                                            } else if (seekingAnimationState != null) {
                                                zeroVelocity = SeekableTransitionState.Companion.getZeroVelocity();
                                            } else {
                                                zeroVelocity = SeekableTransitionState.Companion.getZeroVelocity();
                                            }
                                            if (seekingAnimationState == null) {
                                                seekingAnimationState = new SeekingAnimationState();
                                            }
                                            seekingAnimationState.setAnimationSpec(vectorizedAnimationSpecVectorize);
                                            seekingAnimationState.setComplete(false);
                                            seekingAnimationState.setValue(this.this$0.getFraction());
                                            seekingAnimationState.getStart().set$animation_core_release(0, this.this$0.getFraction());
                                            seekingAnimationState.setDurationNanos(this.this$0.getTotalDurationNanos());
                                            seekingAnimationState.setProgressNanos(0L);
                                            seekingAnimationState.setInitialVelocity(zeroVelocity);
                                            if (vectorizedAnimationSpecVectorize != null) {
                                                jRoundToLong = vectorizedAnimationSpecVectorize.getDurationNanos(seekingAnimationState.getStart(), SeekableTransitionState.Companion.getTarget1(), zeroVelocity);
                                            } else {
                                                jRoundToLong = MathKt.roundToLong(this.this$0.getTotalDurationNanos() * (1.0d - ((double) this.this$0.getFraction())));
                                            }
                                            seekingAnimationState.setAnimationSpecDuration(jRoundToLong);
                                            ((SeekableTransitionState) this.this$0).currentAnimation = seekingAnimationState;
                                        } else {
                                            if (seekingAnimationState != null) {
                                                animationSpec = seekingAnimationState.getAnimationSpec();
                                            } else {
                                                animationSpec = null;
                                            }
                                            if (animationSpec != null) {
                                                long progressNanos2 = seekingAnimationState.getProgressNanos();
                                                AnimationVector1D start2 = seekingAnimationState.getStart();
                                                AnimationVector1D target2 = SeekableTransitionState.Companion.getTarget1();
                                                initialVelocity = seekingAnimationState.getInitialVelocity();
                                                if (initialVelocity == null) {
                                                    initialVelocity = SeekableTransitionState.Companion.getZeroVelocity();
                                                }
                                                zeroVelocity = (AnimationVector1D) animationSpec.getVelocityFromNanos(progressNanos2, start2, target2, initialVelocity);
                                            } else if (seekingAnimationState != null) {
                                                zeroVelocity = SeekableTransitionState.Companion.getZeroVelocity();
                                            } else {
                                                zeroVelocity = SeekableTransitionState.Companion.getZeroVelocity();
                                            }
                                            if (seekingAnimationState == null) {
                                                seekingAnimationState = new SeekingAnimationState();
                                            }
                                            seekingAnimationState.setAnimationSpec(vectorizedAnimationSpecVectorize);
                                            seekingAnimationState.setComplete(false);
                                            seekingAnimationState.setValue(this.this$0.getFraction());
                                            seekingAnimationState.getStart().set$animation_core_release(0, this.this$0.getFraction());
                                            seekingAnimationState.setDurationNanos(this.this$0.getTotalDurationNanos());
                                            seekingAnimationState.setProgressNanos(0L);
                                            seekingAnimationState.setInitialVelocity(zeroVelocity);
                                            if (vectorizedAnimationSpecVectorize != null) {
                                                jRoundToLong = vectorizedAnimationSpecVectorize.getDurationNanos(seekingAnimationState.getStart(), SeekableTransitionState.Companion.getTarget1(), zeroVelocity);
                                            } else {
                                                jRoundToLong = MathKt.roundToLong(this.this$0.getTotalDurationNanos() * (1.0d - ((double) this.this$0.getFraction())));
                                            }
                                            seekingAnimationState.setAnimationSpecDuration(jRoundToLong);
                                            ((SeekableTransitionState) this.this$0).currentAnimation = seekingAnimationState;
                                        }
                                    }
                                    this.L$0 = null;
                                    this.L$1 = null;
                                    this.label = 4;
                                    if (this.this$0.runAnimations((Continuation) this) == coroutine_suspended) {
                                        return coroutine_suspended;
                                    }
                                    this.this$0.setCurrentState$animation_core_release(this.$targetState);
                                    this.label = 5;
                                    if (this.this$0.waitForComposition((Continuation) this) == coroutine_suspended) {
                                        return coroutine_suspended;
                                    }
                                }
                                return Unit.INSTANCE;
                            }
                            if (i == 3) {
                                ResultKt.throwOnFailure(obj);
                                if (!Intrinsics.areEqual(this.this$0.getCurrentState(), this.$targetState)) {
                                    if (this.this$0.getFraction() < 1.0f) {
                                        seekingAnimationState = ((SeekableTransitionState) this.this$0).currentAnimation;
                                        finiteAnimationSpec = this.$animationSpec;
                                        if (finiteAnimationSpec != null) {
                                            vectorizedAnimationSpecVectorize = finiteAnimationSpec.vectorize((TwoWayConverter<Float, V>) VectorConvertersKt.getVectorConverter(FloatCompanionObject.INSTANCE));
                                        } else {
                                            vectorizedAnimationSpecVectorize = null;
                                        }
                                        if (seekingAnimationState != null || !Intrinsics.areEqual(vectorizedAnimationSpecVectorize, seekingAnimationState.getAnimationSpec())) {
                                            if (seekingAnimationState != null) {
                                                animationSpec = seekingAnimationState.getAnimationSpec();
                                            } else {
                                                animationSpec = null;
                                            }
                                            if (animationSpec != null) {
                                                long progressNanos3 = seekingAnimationState.getProgressNanos();
                                                AnimationVector1D start3 = seekingAnimationState.getStart();
                                                AnimationVector1D target3 = SeekableTransitionState.Companion.getTarget1();
                                                initialVelocity = seekingAnimationState.getInitialVelocity();
                                                if (initialVelocity == null) {
                                                    initialVelocity = SeekableTransitionState.Companion.getZeroVelocity();
                                                }
                                                zeroVelocity = (AnimationVector1D) animationSpec.getVelocityFromNanos(progressNanos3, start3, target3, initialVelocity);
                                            } else if (seekingAnimationState != null || seekingAnimationState.getProgressNanos() == 0) {
                                                zeroVelocity = SeekableTransitionState.Companion.getZeroVelocity();
                                            } else {
                                                long durationNanos = seekingAnimationState.getDurationNanos();
                                                if (durationNanos == Long.MIN_VALUE) {
                                                    durationNanos = this.this$0.getTotalDurationNanos();
                                                }
                                                float f = durationNanos / 1.0E9f;
                                                zeroVelocity = f <= 0.0f ? SeekableTransitionState.Companion.getZeroVelocity() : new AnimationVector1D(1.0f / f);
                                            }
                                            if (seekingAnimationState == null) {
                                                seekingAnimationState = new SeekingAnimationState();
                                            }
                                            seekingAnimationState.setAnimationSpec(vectorizedAnimationSpecVectorize);
                                            seekingAnimationState.setComplete(false);
                                            seekingAnimationState.setValue(this.this$0.getFraction());
                                            seekingAnimationState.getStart().set$animation_core_release(0, this.this$0.getFraction());
                                            seekingAnimationState.setDurationNanos(this.this$0.getTotalDurationNanos());
                                            seekingAnimationState.setProgressNanos(0L);
                                            seekingAnimationState.setInitialVelocity(zeroVelocity);
                                            if (vectorizedAnimationSpecVectorize != null) {
                                                jRoundToLong = vectorizedAnimationSpecVectorize.getDurationNanos(seekingAnimationState.getStart(), SeekableTransitionState.Companion.getTarget1(), zeroVelocity);
                                            } else {
                                                jRoundToLong = MathKt.roundToLong(this.this$0.getTotalDurationNanos() * (1.0d - ((double) this.this$0.getFraction())));
                                            }
                                            seekingAnimationState.setAnimationSpecDuration(jRoundToLong);
                                            ((SeekableTransitionState) this.this$0).currentAnimation = seekingAnimationState;
                                        }
                                    }
                                    this.L$0 = null;
                                    this.L$1 = null;
                                    this.label = 4;
                                    if (this.this$0.runAnimations((Continuation) this) == coroutine_suspended) {
                                        return coroutine_suspended;
                                    }
                                    this.this$0.setCurrentState$animation_core_release(this.$targetState);
                                    this.label = 5;
                                    if (this.this$0.waitForComposition((Continuation) this) == coroutine_suspended) {
                                        return coroutine_suspended;
                                    }
                                }
                                return Unit.INSTANCE;
                            }
                            if (i == 4) {
                                ResultKt.throwOnFailure(obj);
                                this.this$0.setCurrentState$animation_core_release(this.$targetState);
                                this.label = 5;
                                if (this.this$0.waitForComposition((Continuation) this) == coroutine_suspended) {
                                    return coroutine_suspended;
                                }
                            } else {
                                if (i != 5) {
                                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                                }
                                ResultKt.throwOnFailure(obj);
                            }
                        }
                        this.this$0.setFraction(0.0f);
                        return Unit.INSTANCE;
                    }
                    ResultKt.throwOnFailure(obj);
                    S targetState = this.this$0.getTargetState();
                    if (!Intrinsics.areEqual(this.$targetState, targetState)) {
                        this.this$0.moveAnimationToInitialState();
                        this.this$0.setFraction(0.0f);
                        this.$transition.updateTarget$animation_core_release(this.$targetState);
                        this.$transition.setPlayTimeNanos(0L);
                        this.this$0.setCurrentState$animation_core_release(targetState);
                        this.this$0.setTargetState$animation_core_release(this.$targetState);
                    }
                    Mutex compositionContinuationMutex = this.this$0.getCompositionContinuationMutex();
                    SeekableTransitionState<S> seekableTransitionState2 = this.this$0;
                    this.L$0 = compositionContinuationMutex;
                    this.L$1 = seekableTransitionState2;
                    this.label = 1;
                    if (compositionContinuationMutex.lock((Object) null, (Continuation) this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    mutex = compositionContinuationMutex;
                    seekableTransitionState = seekableTransitionState2;
                    S composedTargetState$animation_core_release = seekableTransitionState.getComposedTargetState$animation_core_release();
                    mutex.unlock((Object) null);
                    if (!Intrinsics.areEqual(this.$targetState, composedTargetState$animation_core_release)) {
                        this.L$0 = null;
                        this.L$1 = null;
                        this.label = 2;
                        if (this.this$0.doOneFrame((Continuation) this) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        this.label = 3;
                        if (this.this$0.waitForCompositionAfterTargetStateChange((Continuation) this) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        if (!Intrinsics.areEqual(this.this$0.getCurrentState(), this.$targetState)) {
                            if (this.this$0.getFraction() < 1.0f) {
                                seekingAnimationState = ((SeekableTransitionState) this.this$0).currentAnimation;
                                finiteAnimationSpec = this.$animationSpec;
                                if (finiteAnimationSpec != null) {
                                    vectorizedAnimationSpecVectorize = finiteAnimationSpec.vectorize((TwoWayConverter<Float, V>) VectorConvertersKt.getVectorConverter(FloatCompanionObject.INSTANCE));
                                } else {
                                    vectorizedAnimationSpecVectorize = null;
                                }
                                if (seekingAnimationState != null) {
                                    if (seekingAnimationState != null) {
                                        animationSpec = seekingAnimationState.getAnimationSpec();
                                    } else {
                                        animationSpec = null;
                                    }
                                    if (animationSpec != null) {
                                        long progressNanos4 = seekingAnimationState.getProgressNanos();
                                        AnimationVector1D start4 = seekingAnimationState.getStart();
                                        AnimationVector1D target4 = SeekableTransitionState.Companion.getTarget1();
                                        initialVelocity = seekingAnimationState.getInitialVelocity();
                                        if (initialVelocity == null) {
                                            initialVelocity = SeekableTransitionState.Companion.getZeroVelocity();
                                        }
                                        zeroVelocity = (AnimationVector1D) animationSpec.getVelocityFromNanos(progressNanos4, start4, target4, initialVelocity);
                                    } else if (seekingAnimationState != null) {
                                        zeroVelocity = SeekableTransitionState.Companion.getZeroVelocity();
                                    } else {
                                        zeroVelocity = SeekableTransitionState.Companion.getZeroVelocity();
                                    }
                                    if (seekingAnimationState == null) {
                                        seekingAnimationState = new SeekingAnimationState();
                                    }
                                    seekingAnimationState.setAnimationSpec(vectorizedAnimationSpecVectorize);
                                    seekingAnimationState.setComplete(false);
                                    seekingAnimationState.setValue(this.this$0.getFraction());
                                    seekingAnimationState.getStart().set$animation_core_release(0, this.this$0.getFraction());
                                    seekingAnimationState.setDurationNanos(this.this$0.getTotalDurationNanos());
                                    seekingAnimationState.setProgressNanos(0L);
                                    seekingAnimationState.setInitialVelocity(zeroVelocity);
                                    if (vectorizedAnimationSpecVectorize != null) {
                                        jRoundToLong = vectorizedAnimationSpecVectorize.getDurationNanos(seekingAnimationState.getStart(), SeekableTransitionState.Companion.getTarget1(), zeroVelocity);
                                    } else {
                                        jRoundToLong = MathKt.roundToLong(this.this$0.getTotalDurationNanos() * (1.0d - ((double) this.this$0.getFraction())));
                                    }
                                    seekingAnimationState.setAnimationSpecDuration(jRoundToLong);
                                    ((SeekableTransitionState) this.this$0).currentAnimation = seekingAnimationState;
                                } else {
                                    if (seekingAnimationState != null) {
                                        animationSpec = seekingAnimationState.getAnimationSpec();
                                    } else {
                                        animationSpec = null;
                                    }
                                    if (animationSpec != null) {
                                        long progressNanos5 = seekingAnimationState.getProgressNanos();
                                        AnimationVector1D start5 = seekingAnimationState.getStart();
                                        AnimationVector1D target5 = SeekableTransitionState.Companion.getTarget1();
                                        initialVelocity = seekingAnimationState.getInitialVelocity();
                                        if (initialVelocity == null) {
                                            initialVelocity = SeekableTransitionState.Companion.getZeroVelocity();
                                        }
                                        zeroVelocity = (AnimationVector1D) animationSpec.getVelocityFromNanos(progressNanos5, start5, target5, initialVelocity);
                                    } else if (seekingAnimationState != null) {
                                        zeroVelocity = SeekableTransitionState.Companion.getZeroVelocity();
                                    } else {
                                        zeroVelocity = SeekableTransitionState.Companion.getZeroVelocity();
                                    }
                                    if (seekingAnimationState == null) {
                                        seekingAnimationState = new SeekingAnimationState();
                                    }
                                    seekingAnimationState.setAnimationSpec(vectorizedAnimationSpecVectorize);
                                    seekingAnimationState.setComplete(false);
                                    seekingAnimationState.setValue(this.this$0.getFraction());
                                    seekingAnimationState.getStart().set$animation_core_release(0, this.this$0.getFraction());
                                    seekingAnimationState.setDurationNanos(this.this$0.getTotalDurationNanos());
                                    seekingAnimationState.setProgressNanos(0L);
                                    seekingAnimationState.setInitialVelocity(zeroVelocity);
                                    if (vectorizedAnimationSpecVectorize != null) {
                                        jRoundToLong = vectorizedAnimationSpecVectorize.getDurationNanos(seekingAnimationState.getStart(), SeekableTransitionState.Companion.getTarget1(), zeroVelocity);
                                    } else {
                                        jRoundToLong = MathKt.roundToLong(this.this$0.getTotalDurationNanos() * (1.0d - ((double) this.this$0.getFraction())));
                                    }
                                    seekingAnimationState.setAnimationSpecDuration(jRoundToLong);
                                    ((SeekableTransitionState) this.this$0).currentAnimation = seekingAnimationState;
                                }
                            }
                            this.L$0 = null;
                            this.L$1 = null;
                            this.label = 4;
                            if (this.this$0.runAnimations((Continuation) this) == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                            this.this$0.setCurrentState$animation_core_release(this.$targetState);
                            this.label = 5;
                            if (this.this$0.waitForComposition((Continuation) this) == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                            this.this$0.setFraction(0.0f);
                        }
                    } else if (!Intrinsics.areEqual(this.this$0.getCurrentState(), this.$targetState)) {
                        if (this.this$0.getFraction() < 1.0f) {
                            seekingAnimationState = ((SeekableTransitionState) this.this$0).currentAnimation;
                            finiteAnimationSpec = this.$animationSpec;
                            if (finiteAnimationSpec != null) {
                                vectorizedAnimationSpecVectorize = finiteAnimationSpec.vectorize((TwoWayConverter<Float, V>) VectorConvertersKt.getVectorConverter(FloatCompanionObject.INSTANCE));
                            } else {
                                vectorizedAnimationSpecVectorize = null;
                            }
                            if (seekingAnimationState != null) {
                                if (seekingAnimationState != null) {
                                    animationSpec = seekingAnimationState.getAnimationSpec();
                                } else {
                                    animationSpec = null;
                                }
                                if (animationSpec != null) {
                                    long progressNanos6 = seekingAnimationState.getProgressNanos();
                                    AnimationVector1D start6 = seekingAnimationState.getStart();
                                    AnimationVector1D target6 = SeekableTransitionState.Companion.getTarget1();
                                    initialVelocity = seekingAnimationState.getInitialVelocity();
                                    if (initialVelocity == null) {
                                        initialVelocity = SeekableTransitionState.Companion.getZeroVelocity();
                                    }
                                    zeroVelocity = (AnimationVector1D) animationSpec.getVelocityFromNanos(progressNanos6, start6, target6, initialVelocity);
                                } else if (seekingAnimationState != null) {
                                    zeroVelocity = SeekableTransitionState.Companion.getZeroVelocity();
                                } else {
                                    zeroVelocity = SeekableTransitionState.Companion.getZeroVelocity();
                                }
                                if (seekingAnimationState == null) {
                                    seekingAnimationState = new SeekingAnimationState();
                                }
                                seekingAnimationState.setAnimationSpec(vectorizedAnimationSpecVectorize);
                                seekingAnimationState.setComplete(false);
                                seekingAnimationState.setValue(this.this$0.getFraction());
                                seekingAnimationState.getStart().set$animation_core_release(0, this.this$0.getFraction());
                                seekingAnimationState.setDurationNanos(this.this$0.getTotalDurationNanos());
                                seekingAnimationState.setProgressNanos(0L);
                                seekingAnimationState.setInitialVelocity(zeroVelocity);
                                if (vectorizedAnimationSpecVectorize != null) {
                                    jRoundToLong = vectorizedAnimationSpecVectorize.getDurationNanos(seekingAnimationState.getStart(), SeekableTransitionState.Companion.getTarget1(), zeroVelocity);
                                } else {
                                    jRoundToLong = MathKt.roundToLong(this.this$0.getTotalDurationNanos() * (1.0d - ((double) this.this$0.getFraction())));
                                }
                                seekingAnimationState.setAnimationSpecDuration(jRoundToLong);
                                ((SeekableTransitionState) this.this$0).currentAnimation = seekingAnimationState;
                            } else {
                                if (seekingAnimationState != null) {
                                    animationSpec = seekingAnimationState.getAnimationSpec();
                                } else {
                                    animationSpec = null;
                                }
                                if (animationSpec != null) {
                                    long progressNanos7 = seekingAnimationState.getProgressNanos();
                                    AnimationVector1D start7 = seekingAnimationState.getStart();
                                    AnimationVector1D target7 = SeekableTransitionState.Companion.getTarget1();
                                    initialVelocity = seekingAnimationState.getInitialVelocity();
                                    if (initialVelocity == null) {
                                        initialVelocity = SeekableTransitionState.Companion.getZeroVelocity();
                                    }
                                    zeroVelocity = (AnimationVector1D) animationSpec.getVelocityFromNanos(progressNanos7, start7, target7, initialVelocity);
                                } else if (seekingAnimationState != null) {
                                    zeroVelocity = SeekableTransitionState.Companion.getZeroVelocity();
                                } else {
                                    zeroVelocity = SeekableTransitionState.Companion.getZeroVelocity();
                                }
                                if (seekingAnimationState == null) {
                                    seekingAnimationState = new SeekingAnimationState();
                                }
                                seekingAnimationState.setAnimationSpec(vectorizedAnimationSpecVectorize);
                                seekingAnimationState.setComplete(false);
                                seekingAnimationState.setValue(this.this$0.getFraction());
                                seekingAnimationState.getStart().set$animation_core_release(0, this.this$0.getFraction());
                                seekingAnimationState.setDurationNanos(this.this$0.getTotalDurationNanos());
                                seekingAnimationState.setProgressNanos(0L);
                                seekingAnimationState.setInitialVelocity(zeroVelocity);
                                if (vectorizedAnimationSpecVectorize != null) {
                                    jRoundToLong = vectorizedAnimationSpecVectorize.getDurationNanos(seekingAnimationState.getStart(), SeekableTransitionState.Companion.getTarget1(), zeroVelocity);
                                } else {
                                    jRoundToLong = MathKt.roundToLong(this.this$0.getTotalDurationNanos() * (1.0d - ((double) this.this$0.getFraction())));
                                }
                                seekingAnimationState.setAnimationSpecDuration(jRoundToLong);
                                ((SeekableTransitionState) this.this$0).currentAnimation = seekingAnimationState;
                            }
                        }
                        this.L$0 = null;
                        this.L$1 = null;
                        this.label = 4;
                        if (this.this$0.runAnimations((Continuation) this) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        this.this$0.setCurrentState$animation_core_release(this.$targetState);
                        this.label = 5;
                        if (this.this$0.waitForComposition((Continuation) this) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        this.this$0.setFraction(0.0f);
                    }
                    return Unit.INSTANCE;
                } catch (Throwable th) {
                    mutex.unlock((Object) null);
                    throw th;
                }
            }
        }

        public final Object invokeSuspend(Object obj) {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (CoroutineScopeKt.coroutineScope(new AnonymousClass1(this.this$0, this.$targetState, this.$transition, this.$animationSpec, null), (Continuation) this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            this.$transition.onTransitionEnd$animation_core_release();
            return Unit.INSTANCE;
        }
    }

    public final Object animateTo(S s, FiniteAnimationSpec<Float> finiteAnimationSpec, Continuation<? super Unit> continuation) {
        Transition<S> transition = this.transition;
        if (transition == null) {
            return Unit.INSTANCE;
        }
        Object objMutate$default = MutatorMutex.mutate$default(this.mutatorMutex, null, new C03042(transition, this, s, finiteAnimationSpec, null), continuation, 1, null);
        return objMutate$default == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objMutate$default : Unit.INSTANCE;
    }

    @Override
    public void transitionConfigured$animation_core_release(Transition<S> transition) {
        Transition<S> transition2 = this.transition;
        if (!(transition2 == null || Intrinsics.areEqual(transition, transition2))) {
            PreconditionsKt.throwIllegalStateException("An instance of SeekableTransitionState has been used in different Transitions. Previous instance: " + this.transition + ", new instance: " + transition);
        }
        this.transition = transition;
    }

    @Override
    public void transitionRemoved$animation_core_release() {
        this.transition = null;
        TransitionKt.getSeekableStateObserver().clear(this);
    }

    public final void observeTotalDuration$animation_core_release() {
        TransitionKt.getSeekableStateObserver().observeReads(this, TransitionKt.SeekableTransitionStateTotalDurationChanged, this.recalculateTotalDurationNanos);
    }

    public final void onTotalDurationChanged$animation_core_release() {
        long j = this.totalDurationNanos;
        observeTotalDuration$animation_core_release();
        long j2 = this.totalDurationNanos;
        if (j != j2) {
            SeekingAnimationState seekingAnimationState = this.currentAnimation;
            if (seekingAnimationState == null) {
                if (j2 != 0) {
                    seekToFraction();
                }
            } else {
                seekingAnimationState.setDurationNanos(j2);
                if (seekingAnimationState.getAnimationSpec() == null) {
                    seekingAnimationState.setAnimationSpecDuration(MathKt.roundToLong((1.0d - ((double) seekingAnimationState.getStart().get$animation_core_release(0))) * this.totalDurationNanos));
                }
            }
        }
    }

    public final void seekToFraction() {
        Transition<S> transition = this.transition;
        if (transition == null) {
            return;
        }
        transition.seekAnimations$animation_core_release(MathKt.roundToLong(((double) getFraction()) * transition.getTotalDurationNanos()));
    }

    @Metadata(d1 = {"\u00006\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\t\n\u0002\b\r\n\u0002\u0010\u000b\n\u0002\b\n\n\u0002\u0010\u0007\n\u0002\b\u0005\n\u0002\u0010\u000e\n\u0000\b\u0000\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J\b\u0010)\u001a\u00020*H\u0016R\"\u0010\u0003\u001a\n\u0012\u0004\u0012\u00020\u0005\u0018\u00010\u0004X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0006\u0010\u0007\"\u0004\b\b\u0010\tR\u001a\u0010\n\u001a\u00020\u000bX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\f\u0010\r\"\u0004\b\u000e\u0010\u000fR\u001a\u0010\u0010\u001a\u00020\u000bX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0011\u0010\r\"\u0004\b\u0012\u0010\u000fR\u001c\u0010\u0013\u001a\u0004\u0018\u00010\u0005X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0014\u0010\u0015\"\u0004\b\u0016\u0010\u0017R\u001a\u0010\u0018\u001a\u00020\u0019X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0018\u0010\u001a\"\u0004\b\u001b\u0010\u001cR\u001a\u0010\u001d\u001a\u00020\u000bX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001e\u0010\r\"\u0004\b\u001f\u0010\u000fR\u001a\u0010 \u001a\u00020\u0005X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b!\u0010\u0015\"\u0004\b\"\u0010\u0017R\u001a\u0010#\u001a\u00020$X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b%\u0010&\"\u0004\b'\u0010(¨\u0006+"}, d2 = {"Landroidx/compose/animation/core/SeekableTransitionState$SeekingAnimationState;", "", "()V", "animationSpec", "Landroidx/compose/animation/core/VectorizedAnimationSpec;", "Landroidx/compose/animation/core/AnimationVector1D;", "getAnimationSpec", "()Landroidx/compose/animation/core/VectorizedAnimationSpec;", "setAnimationSpec", "(Landroidx/compose/animation/core/VectorizedAnimationSpec;)V", "animationSpecDuration", "", "getAnimationSpecDuration", "()J", "setAnimationSpecDuration", "(J)V", "durationNanos", "getDurationNanos", "setDurationNanos", "initialVelocity", "getInitialVelocity", "()Landroidx/compose/animation/core/AnimationVector1D;", "setInitialVelocity", "(Landroidx/compose/animation/core/AnimationVector1D;)V", "isComplete", "", "()Z", "setComplete", "(Z)V", "progressNanos", "getProgressNanos", "setProgressNanos", "start", "getStart", "setStart", "value", "", "getValue", "()F", "setValue", "(F)V", "toString", "", "animation-core_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class SeekingAnimationState {
        public static final int $stable = 8;
        private VectorizedAnimationSpec<AnimationVector1D> animationSpec;
        private long animationSpecDuration;
        private long durationNanos;
        private AnimationVector1D initialVelocity;
        private boolean isComplete;
        private long progressNanos;
        private AnimationVector1D start = new AnimationVector1D(0.0f);
        private float value;

        public final long getProgressNanos() {
            return this.progressNanos;
        }

        public final void setProgressNanos(long j) {
            this.progressNanos = j;
        }

        public final VectorizedAnimationSpec<AnimationVector1D> getAnimationSpec() {
            return this.animationSpec;
        }

        public final void setAnimationSpec(VectorizedAnimationSpec<AnimationVector1D> vectorizedAnimationSpec) {
            this.animationSpec = vectorizedAnimationSpec;
        }

        public final boolean getIsComplete() {
            return this.isComplete;
        }

        public final void setComplete(boolean z) {
            this.isComplete = z;
        }

        public final float getValue() {
            return this.value;
        }

        public final void setValue(float f) {
            this.value = f;
        }

        public final AnimationVector1D getStart() {
            return this.start;
        }

        public final void setStart(AnimationVector1D animationVector1D) {
            this.start = animationVector1D;
        }

        public final AnimationVector1D getInitialVelocity() {
            return this.initialVelocity;
        }

        public final void setInitialVelocity(AnimationVector1D animationVector1D) {
            this.initialVelocity = animationVector1D;
        }

        public final long getDurationNanos() {
            return this.durationNanos;
        }

        public final void setDurationNanos(long j) {
            this.durationNanos = j;
        }

        public final long getAnimationSpecDuration() {
            return this.animationSpecDuration;
        }

        public final void setAnimationSpecDuration(long j) {
            this.animationSpecDuration = j;
        }

        public String toString() {
            return "progress nanos: " + this.progressNanos + ", animationSpec: " + this.animationSpec + ", isComplete: " + this.isComplete + ", value: " + this.value + ", start: " + this.start + ", initialVelocity: " + this.initialVelocity + ", durationNanos: " + this.durationNanos + ", animationSpecDuration: " + this.animationSpecDuration;
        }
    }

    @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u0011\u0010\u0003\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006R\u0011\u0010\u0007\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\u0006¨\u0006\t"}, d2 = {"Landroidx/compose/animation/core/SeekableTransitionState$Companion;", "", "()V", "Target1", "Landroidx/compose/animation/core/AnimationVector1D;", "getTarget1", "()Landroidx/compose/animation/core/AnimationVector1D;", "ZeroVelocity", "getZeroVelocity", "animation-core_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final AnimationVector1D getZeroVelocity() {
            return SeekableTransitionState.ZeroVelocity;
        }

        public final AnimationVector1D getTarget1() {
            return SeekableTransitionState.Target1;
        }
    }
}
