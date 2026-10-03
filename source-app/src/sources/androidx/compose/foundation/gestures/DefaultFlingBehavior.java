package androidx.compose.foundation.gestures;

import androidx.compose.animation.core.AnimationScope;
import androidx.compose.animation.core.AnimationState;
import androidx.compose.animation.core.AnimationStateKt;
import androidx.compose.animation.core.AnimationVector1D;
import androidx.compose.animation.core.DecayAnimationSpec;
import androidx.compose.animation.core.SuspendAnimationKt;
import androidx.compose.p002ui.MotionDurationScale;
import java.util.concurrent.CancellationException;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.Boxing;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Ref;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineScope;

@Metadata(d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0007\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\b\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0000\u0018\u00002\u00020\u0001B\u001d\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003\u0012\b\b\u0002\u0010\u0005\u001a\u00020\u0006¢\u0006\u0002\u0010\u0007J\u001a\u0010\u0012\u001a\u00020\u0004*\u00020\u00132\u0006\u0010\u0014\u001a\u00020\u0004H\u0096@¢\u0006\u0002\u0010\u0015R \u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\b\u0010\t\"\u0004\b\n\u0010\u000bR\u001a\u0010\f\u001a\u00020\rX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u000e\u0010\u000f\"\u0004\b\u0010\u0010\u0011R\u000e\u0010\u0005\u001a\u00020\u0006X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0016"}, d2 = {"Landroidx/compose/foundation/gestures/DefaultFlingBehavior;", "Landroidx/compose/foundation/gestures/FlingBehavior;", "flingDecay", "Landroidx/compose/animation/core/DecayAnimationSpec;", "", "motionDurationScale", "Landroidx/compose/ui/MotionDurationScale;", "(Landroidx/compose/animation/core/DecayAnimationSpec;Landroidx/compose/ui/MotionDurationScale;)V", "getFlingDecay", "()Landroidx/compose/animation/core/DecayAnimationSpec;", "setFlingDecay", "(Landroidx/compose/animation/core/DecayAnimationSpec;)V", "lastAnimationCycleCount", "", "getLastAnimationCycleCount", "()I", "setLastAnimationCycleCount", "(I)V", "performFling", "Landroidx/compose/foundation/gestures/ScrollScope;", "initialVelocity", "(Landroidx/compose/foundation/gestures/ScrollScope;FLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class DefaultFlingBehavior implements FlingBehavior {
    public static final int $stable = 0;
    private DecayAnimationSpec<Float> flingDecay;
    private int lastAnimationCycleCount;
    private final MotionDurationScale motionDurationScale;

    public DefaultFlingBehavior(DecayAnimationSpec<Float> decayAnimationSpec, MotionDurationScale motionDurationScale) {
        this.flingDecay = decayAnimationSpec;
        this.motionDurationScale = motionDurationScale;
    }

    public final DecayAnimationSpec<Float> getFlingDecay() {
        return this.flingDecay;
    }

    public final void setFlingDecay(DecayAnimationSpec<Float> decayAnimationSpec) {
        this.flingDecay = decayAnimationSpec;
    }

    public DefaultFlingBehavior(DecayAnimationSpec decayAnimationSpec, MotionDurationScale motionDurationScale, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(decayAnimationSpec, (i & 2) != 0 ? ScrollableKt.getDefaultScrollMotionDurationScale() : motionDurationScale);
    }

    public final int getLastAnimationCycleCount() {
        return this.lastAnimationCycleCount;
    }

    public final void setLastAnimationCycleCount(int i) {
        this.lastAnimationCycleCount = i;
    }

    @Override
    public Object performFling(ScrollScope scrollScope, float f, Continuation<? super Float> continuation) {
        this.lastAnimationCycleCount = 0;
        return BuildersKt.withContext(this.motionDurationScale, new C04422(f, this, scrollScope, null), continuation);
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0007\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.gestures.DefaultFlingBehavior$performFling$2", f = "Scrollable.kt", i = {0, 0}, l = {893}, m = "invokeSuspend", n = {"velocityLeft", "animationState"}, s = {"L$0", "L$1"})
    static final class C04422 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Float>, Object> {
        final float $initialVelocity;
        final ScrollScope $this_performFling;
        Object L$0;
        Object L$1;
        int label;
        final DefaultFlingBehavior this$0;

        C04422(float f, DefaultFlingBehavior defaultFlingBehavior, ScrollScope scrollScope, Continuation<? super C04422> continuation) {
            super(2, continuation);
            this.$initialVelocity = f;
            this.this$0 = defaultFlingBehavior;
            this.$this_performFling = scrollScope;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return new C04422(this.$initialVelocity, this.this$0, this.$this_performFling, continuation);
        }

        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Float> continuation) {
            return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) {
            float f;
            final Ref.FloatRef floatRef;
            AnimationState animationState;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                if (Math.abs(this.$initialVelocity) > 1.0f) {
                    floatRef = new Ref.FloatRef();
                    floatRef.element = this.$initialVelocity;
                    final Ref.FloatRef floatRef2 = new Ref.FloatRef();
                    AnimationState animationStateAnimationState$default = AnimationStateKt.AnimationState$default(0.0f, this.$initialVelocity, 0L, 0L, false, 28, null);
                    try {
                        DecayAnimationSpec<Float> flingDecay = this.this$0.getFlingDecay();
                        final ScrollScope scrollScope = this.$this_performFling;
                        final DefaultFlingBehavior defaultFlingBehavior = this.this$0;
                        this.L$0 = floatRef;
                        this.L$1 = animationStateAnimationState$default;
                        this.label = 1;
                        if (SuspendAnimationKt.animateDecay$default(animationStateAnimationState$default, flingDecay, false, new Function1<AnimationScope<Float, AnimationVector1D>, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj2) {
                                invoke((AnimationScope<Float, AnimationVector1D>) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(AnimationScope<Float, AnimationVector1D> animationScope) {
                                float fFloatValue = animationScope.getValue().floatValue() - floatRef2.element;
                                float fScrollBy = scrollScope.scrollBy(fFloatValue);
                                floatRef2.element = animationScope.getValue().floatValue();
                                floatRef.element = animationScope.getVelocity().floatValue();
                                if (Math.abs(fFloatValue - fScrollBy) > 0.5f) {
                                    animationScope.cancelAnimation();
                                }
                                DefaultFlingBehavior defaultFlingBehavior2 = defaultFlingBehavior;
                                defaultFlingBehavior2.setLastAnimationCycleCount(defaultFlingBehavior2.getLastAnimationCycleCount() + 1);
                            }
                        }, (Continuation) this, 2, null) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                    } catch (CancellationException unused) {
                        animationState = animationStateAnimationState$default;
                        floatRef.element = ((Number) animationState.getVelocity()).floatValue();
                    }
                    f = floatRef.element;
                } else {
                    f = this.$initialVelocity;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                animationState = (AnimationState) this.L$1;
                floatRef = (Ref.FloatRef) this.L$0;
                try {
                    ResultKt.throwOnFailure(obj);
                } catch (CancellationException unused2) {
                    floatRef.element = ((Number) animationState.getVelocity()).floatValue();
                }
                f = floatRef.element;
            }
            return Boxing.boxFloat(f);
        }
    }
}
