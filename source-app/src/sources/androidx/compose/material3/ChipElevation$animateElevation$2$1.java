package androidx.compose.material3;

import androidx.compose.animation.core.Animatable;
import androidx.compose.animation.core.AnimationVector1D;
import androidx.compose.foundation.interaction.Interaction;
import androidx.compose.material3.internal.ElevationKt;
import androidx.compose.runtime.MutableState;
import androidx.compose.ui.unit.Dp;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.CoroutineScope;

@Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
@DebugMetadata(c = "androidx.compose.material3.ChipElevation$animateElevation$2$1", f = "Chip.kt", i = {}, l = {2241, 2243}, m = "invokeSuspend", n = {}, s = {})
final class ChipElevation$animateElevation$2$1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
    final Animatable<Dp, AnimationVector1D> $animatable;
    final boolean $enabled;
    final Interaction $interaction;
    final MutableState<Interaction> $lastInteraction$delegate;
    final float $target;
    int label;

    ChipElevation$animateElevation$2$1(Animatable<Dp, AnimationVector1D> animatable, float f, boolean z, Interaction interaction, MutableState<Interaction> mutableState, Continuation<? super ChipElevation$animateElevation$2$1> continuation) {
        super(2, continuation);
        this.$animatable = animatable;
        this.$target = f;
        this.$enabled = z;
        this.$interaction = interaction;
        this.$lastInteraction$delegate = mutableState;
    }

    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        return new ChipElevation$animateElevation$2$1(this.$animatable, this.$target, this.$enabled, this.$interaction, this.$lastInteraction$delegate, continuation);
    }

    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
        return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
    }

    public final Object invokeSuspend(Object obj) {
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            if (!Dp.equals-impl0(this.$animatable.getTargetValue().unbox-impl(), this.$target)) {
                if (this.$enabled) {
                    Interaction interactionAnimateElevation$lambda$2 = ChipElevation.animateElevation$lambda$2(this.$lastInteraction$delegate);
                    this.label = 2;
                    if (ElevationKt.m3260animateElevationrAjV9yQ(this.$animatable, this.$target, interactionAnimateElevation$lambda$2, this.$interaction, (Continuation) this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } else {
                    this.label = 1;
                    if (this.$animatable.snapTo(Dp.box-impl(this.$target), (Continuation) this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                }
            }
            return Unit.INSTANCE;
        }
        if (i != 1 && i != 2) {
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
        ResultKt.throwOnFailure(obj);
        this.$lastInteraction$delegate.setValue(this.$interaction);
        return Unit.INSTANCE;
    }
}
