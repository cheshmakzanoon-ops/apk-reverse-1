package androidx.compose.material3;

import androidx.compose.animation.core.Animatable;
import androidx.compose.animation.core.AnimationVector1D;
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
@DebugMetadata(c = "androidx.compose.material3.TabIndicatorOffsetNode$measure$3", f = "TabRow.kt", i = {}, l = {916}, m = "invokeSuspend", n = {}, s = {})
final class TabIndicatorOffsetNode$measure$3 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
    final float $indicatorOffset;
    final Animatable<Dp, AnimationVector1D> $offsetAnim;
    int label;

    TabIndicatorOffsetNode$measure$3(Animatable<Dp, AnimationVector1D> animatable, float f, Continuation<? super TabIndicatorOffsetNode$measure$3> continuation) {
        super(2, continuation);
        this.$offsetAnim = animatable;
        this.$indicatorOffset = f;
    }

    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        return new TabIndicatorOffsetNode$measure$3(this.$offsetAnim, this.$indicatorOffset, continuation);
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
            if (Animatable.animateTo$default(this.$offsetAnim, Dp.box-impl(this.$indicatorOffset), TabRowKt.TabRowIndicatorSpec, null, null, (Continuation) this, 12, null) == coroutine_suspended) {
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
