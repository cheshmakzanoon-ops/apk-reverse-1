package com.google.accompanist.placeholder;

import androidx.compose.animation.core.AnimationSpecKt;
import androidx.compose.animation.core.Easing;
import androidx.compose.animation.core.InfiniteRepeatableSpec;
import androidx.compose.animation.core.RepeatMode;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.recyclerview.widget.ItemTouchHelper;
import kotlin.Lazy;
import kotlin.LazyKt;
import kotlin.Metadata;
import kotlin.jvm.functions.Function0;

@Metadata(d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0007\n\u0002\b\b\bÇ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R!\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u00048FX\u0086\u0084\u0002¢\u0006\f\n\u0004\b\b\u0010\t\u001a\u0004\b\u0006\u0010\u0007R!\u0010\n\u001a\b\u0012\u0004\u0012\u00020\u00050\u00048FX\u0086\u0084\u0002¢\u0006\f\n\u0004\b\f\u0010\t\u001a\u0004\b\u000b\u0010\u0007¨\u0006\r"}, d2 = {"Lcom/google/accompanist/placeholder/PlaceholderDefaults;", "", "()V", "fadeAnimationSpec", "Landroidx/compose/animation/core/InfiniteRepeatableSpec;", "", "getFadeAnimationSpec", "()Landroidx/compose/animation/core/InfiniteRepeatableSpec;", "fadeAnimationSpec$delegate", "Lkotlin/Lazy;", "shimmerAnimationSpec", "getShimmerAnimationSpec", "shimmerAnimationSpec$delegate", "placeholder_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class PlaceholderDefaults {
    public static final PlaceholderDefaults INSTANCE = new PlaceholderDefaults();

    private static final Lazy fadeAnimationSpec = LazyKt.lazy(new Function0<InfiniteRepeatableSpec<Float>>() {
        public final InfiniteRepeatableSpec<Float> m2590invoke() {
            return AnimationSpecKt.infiniteRepeatable-9IiC70o$default(AnimationSpecKt.tween$default(600, ItemTouchHelper.Callback.DEFAULT_DRAG_ANIMATION_DURATION, (Easing) null, 4, (Object) null), RepeatMode.Reverse, 0L, 4, (Object) null);
        }
    });

    private static final Lazy shimmerAnimationSpec = LazyKt.lazy(new Function0<InfiniteRepeatableSpec<Float>>() {
        public final InfiniteRepeatableSpec<Float> m2591invoke() {
            return AnimationSpecKt.infiniteRepeatable-9IiC70o$default(AnimationSpecKt.tween$default(1700, ItemTouchHelper.Callback.DEFAULT_DRAG_ANIMATION_DURATION, (Easing) null, 4, (Object) null), RepeatMode.Restart, 0L, 4, (Object) null);
        }
    });
    public static final int $stable = 8;

    private PlaceholderDefaults() {
    }

    public final InfiniteRepeatableSpec<Float> getFadeAnimationSpec() {
        return (InfiniteRepeatableSpec) fadeAnimationSpec.getValue();
    }

    public final InfiniteRepeatableSpec<Float> getShimmerAnimationSpec() {
        return (InfiniteRepeatableSpec) shimmerAnimationSpec.getValue();
    }
}
