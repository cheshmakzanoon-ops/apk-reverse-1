package androidx.compose.foundation.lazy.layout;

import androidx.compose.animation.core.Animatable;
import androidx.compose.animation.core.AnimationVector2D;
import androidx.compose.animation.core.FiniteAnimationSpec;
import androidx.compose.animation.core.SpringSpec;
import androidx.compose.ui.unit.IntOffset;
import java.util.concurrent.CancellationException;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.CoroutineScope;

@Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
@DebugMetadata(c = "androidx.compose.foundation.lazy.layout.LazyLayoutItemAnimation$animatePlacementDelta$1", f = "LazyLayoutItemAnimation.kt", i = {0}, l = {151, 158}, m = "invokeSuspend", n = {"finalSpec"}, s = {"L$0"})
final class LazyLayoutItemAnimation$animatePlacementDelta$1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
    final FiniteAnimationSpec<IntOffset> $spec;
    final long $totalDelta;
    Object L$0;
    int label;
    final LazyLayoutItemAnimation this$0;

    LazyLayoutItemAnimation$animatePlacementDelta$1(LazyLayoutItemAnimation lazyLayoutItemAnimation, FiniteAnimationSpec<IntOffset> finiteAnimationSpec, long j, Continuation<? super LazyLayoutItemAnimation$animatePlacementDelta$1> continuation) {
        super(2, continuation);
        this.this$0 = lazyLayoutItemAnimation;
        this.$spec = finiteAnimationSpec;
        this.$totalDelta = j;
    }

    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        return new LazyLayoutItemAnimation$animatePlacementDelta$1(this.this$0, this.$spec, this.$totalDelta, continuation);
    }

    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
        return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
    }

    public final Object invokeSuspend(Object obj) {
        SpringSpec springSpec;
        FiniteAnimationSpec<IntOffset> finiteAnimationSpec;
        SpringSpec springSpec2;
        final long j;
        Animatable animatable;
        IntOffset intOffset;
        FiniteAnimationSpec<IntOffset> finiteAnimationSpec2;
        final LazyLayoutItemAnimation lazyLayoutItemAnimation;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        try {
            if (i != 0) {
                if (i == 1) {
                    finiteAnimationSpec = (FiniteAnimationSpec) this.L$0;
                    ResultKt.throwOnFailure(obj);
                } else {
                    if (i != 2) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                }
                this.this$0.setPlacementAnimationInProgress(false);
                this.this$0.isRunningMovingAwayAnimation = false;
                return Unit.INSTANCE;
            }
            ResultKt.throwOnFailure(obj);
            if (this.this$0.placementDeltaAnimation.isRunning()) {
                FiniteAnimationSpec<IntOffset> finiteAnimationSpec3 = this.$spec;
                if (!(finiteAnimationSpec3 instanceof SpringSpec)) {
                    springSpec2 = LazyLayoutItemAnimationKt.InterruptionSpec;
                } else {
                    springSpec2 = (SpringSpec) finiteAnimationSpec3;
                }
                springSpec = springSpec2;
            } else {
                springSpec = this.$spec;
            }
            finiteAnimationSpec = springSpec;
            if (!this.this$0.placementDeltaAnimation.isRunning()) {
                this.L$0 = finiteAnimationSpec;
                this.label = 1;
                if (this.this$0.placementDeltaAnimation.snapTo(IntOffset.box-impl(this.$totalDelta), (Continuation) this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            }
            j = IntOffset.minus-qkQi6aY(((IntOffset) this.this$0.placementDeltaAnimation.getValue()).unbox-impl(), this.$totalDelta);
            animatable = this.this$0.placementDeltaAnimation;
            intOffset = IntOffset.box-impl(j);
            finiteAnimationSpec2 = finiteAnimationSpec;
            lazyLayoutItemAnimation = this.this$0;
            this.L$0 = null;
            this.label = 2;
            if (Animatable.animateTo$default(animatable, intOffset, finiteAnimationSpec2, null, new Function1<Animatable<IntOffset, AnimationVector2D>, Unit>() {
                {
                    super(1);
                }

                public Object invoke(Object obj2) {
                    invoke((Animatable<IntOffset, AnimationVector2D>) obj2);
                    return Unit.INSTANCE;
                }

                public final void invoke(Animatable<IntOffset, AnimationVector2D> animatable2) {
                    lazyLayoutItemAnimation.m1202setPlacementDeltagyyYBs(IntOffset.minus-qkQi6aY(animatable2.getValue().unbox-impl(), j));
                    lazyLayoutItemAnimation.onLayerPropertyChanged.invoke();
                }
            }, (Continuation) this, 4, null) == coroutine_suspended) {
                return coroutine_suspended;
            }
            this.this$0.setPlacementAnimationInProgress(false);
            this.this$0.isRunningMovingAwayAnimation = false;
            return Unit.INSTANCE;
            this.this$0.onLayerPropertyChanged.invoke();
            j = IntOffset.minus-qkQi6aY(((IntOffset) this.this$0.placementDeltaAnimation.getValue()).unbox-impl(), this.$totalDelta);
            animatable = this.this$0.placementDeltaAnimation;
            intOffset = IntOffset.box-impl(j);
            finiteAnimationSpec2 = finiteAnimationSpec;
            lazyLayoutItemAnimation = this.this$0;
            this.L$0 = null;
            this.label = 2;
            if (Animatable.animateTo$default(animatable, intOffset, finiteAnimationSpec2, null, new Function1<Animatable<IntOffset, AnimationVector2D>, Unit>() {
                {
                    super(1);
                }

                public Object invoke(Object obj2) {
                    invoke((Animatable<IntOffset, AnimationVector2D>) obj2);
                    return Unit.INSTANCE;
                }

                public final void invoke(Animatable<IntOffset, AnimationVector2D> animatable2) {
                    lazyLayoutItemAnimation.m1202setPlacementDeltagyyYBs(IntOffset.minus-qkQi6aY(animatable2.getValue().unbox-impl(), j));
                    lazyLayoutItemAnimation.onLayerPropertyChanged.invoke();
                }
            }, (Continuation) this, 4, null) == coroutine_suspended) {
                return coroutine_suspended;
            }
            this.this$0.setPlacementAnimationInProgress(false);
            this.this$0.isRunningMovingAwayAnimation = false;
        } catch (CancellationException unused) {
        }
        return Unit.INSTANCE;
    }
}
