package androidx.compose.material3;

import androidx.compose.animation.core.Animatable;
import androidx.compose.animation.core.AnimationVector1D;
import androidx.compose.foundation.interaction.DragInteraction;
import androidx.compose.foundation.interaction.FocusInteraction;
import androidx.compose.foundation.interaction.HoverInteraction;
import androidx.compose.foundation.interaction.Interaction;
import androidx.compose.foundation.interaction.PressInteraction;
import androidx.compose.material3.internal.ElevationKt;
import androidx.compose.p002ui.geometry.Offset;
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
@DebugMetadata(c = "androidx.compose.material3.CardElevation$animateElevation$2$1", f = "Card.kt", i = {}, l = {731, 741}, m = "invokeSuspend", n = {}, s = {})
final class CardElevation$animateElevation$2$1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
    final Animatable<Dp, AnimationVector1D> $animatable;
    final boolean $enabled;
    final Interaction $interaction;
    final float $target;
    int label;
    final CardElevation this$0;

    CardElevation$animateElevation$2$1(Animatable<Dp, AnimationVector1D> animatable, float f, boolean z, CardElevation cardElevation, Interaction interaction, Continuation<? super CardElevation$animateElevation$2$1> continuation) {
        super(2, continuation);
        this.$animatable = animatable;
        this.$target = f;
        this.$enabled = z;
        this.this$0 = cardElevation;
        this.$interaction = interaction;
    }

    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        return new CardElevation$animateElevation$2$1(this.$animatable, this.$target, this.$enabled, this.this$0, this.$interaction, continuation);
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
                if (!this.$enabled) {
                    this.label = 1;
                    if (this.$animatable.snapTo(Dp.box-impl(this.$target), (Continuation) this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } else {
                    float f = this.$animatable.getTargetValue().unbox-impl();
                    DragInteraction.Start start = null;
                    if (Dp.equals-impl0(f, this.this$0.pressedElevation)) {
                        start = new PressInteraction.Press(Offset.INSTANCE.m4362getZeroF1C5BW0(), null);
                    } else if (Dp.equals-impl0(f, this.this$0.hoveredElevation)) {
                        start = new HoverInteraction.Enter();
                    } else if (Dp.equals-impl0(f, this.this$0.focusedElevation)) {
                        start = new FocusInteraction.Focus();
                    } else if (Dp.equals-impl0(f, this.this$0.draggedElevation)) {
                        start = new DragInteraction.Start();
                    }
                    this.label = 2;
                    if (ElevationKt.m3260animateElevationrAjV9yQ(this.$animatable, this.$target, start, this.$interaction, (Continuation) this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                }
            }
        } else {
            if (i != 1 && i != 2) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
        }
        return Unit.INSTANCE;
    }
}
