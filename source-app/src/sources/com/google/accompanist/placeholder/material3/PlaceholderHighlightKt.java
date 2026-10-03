package com.google.accompanist.placeholder.material3;

import androidx.compose.animation.core.InfiniteRepeatableSpec;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.constraintlayout.widget.ConstraintLayout;
import com.google.accompanist.placeholder.PlaceholderDefaults;
import com.google.accompanist.placeholder.PlaceholderHighlight;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000\u0018\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0007\n\u0002\b\u0005\u001a!\u0010\u0000\u001a\u00020\u0001*\u00020\u00022\u000e\b\u0002\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004H\u0007¢\u0006\u0002\u0010\u0006\u001a+\u0010\u0007\u001a\u00020\u0001*\u00020\u00022\u000e\b\u0002\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u00042\b\b\u0003\u0010\b\u001a\u00020\u0005H\u0007¢\u0006\u0002\u0010\t¨\u0006\n"}, d2 = {"fade", "Lcom/google/accompanist/placeholder/PlaceholderHighlight;", "Lcom/google/accompanist/placeholder/PlaceholderHighlight$Companion;", "animationSpec", "Landroidx/compose/animation/core/InfiniteRepeatableSpec;", "", "(Lcom/google/accompanist/placeholder/PlaceholderHighlight$Companion;Landroidx/compose/animation/core/InfiniteRepeatableSpec;Landroidx/compose/runtime/Composer;II)Lcom/google/accompanist/placeholder/PlaceholderHighlight;", "shimmer", "progressForMaxAlpha", "(Lcom/google/accompanist/placeholder/PlaceholderHighlight$Companion;Landroidx/compose/animation/core/InfiniteRepeatableSpec;FLandroidx/compose/runtime/Composer;II)Lcom/google/accompanist/placeholder/PlaceholderHighlight;", "placeholder-material3_release"}, k = 2, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class PlaceholderHighlightKt {
    public static final PlaceholderHighlight fade(PlaceholderHighlight.Companion companion, InfiniteRepeatableSpec<Float> infiniteRepeatableSpec, Composer composer, int i, int i2) {
        Intrinsics.checkNotNullParameter(companion, "<this>");
        composer.startReplaceableGroup(-287479417);
        ComposerKt.sourceInformation(composer, "C(fade)");
        if ((i2 & 1) != 0) {
            infiniteRepeatableSpec = PlaceholderDefaults.INSTANCE.getFadeAnimationSpec();
        }
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-287479417, i, -1, "com.google.accompanist.placeholder.material3.fade (PlaceholderHighlight.kt:36)");
        }
        PlaceholderHighlight placeholderHighlightM2592fadebw27NRU = com.google.accompanist.placeholder.PlaceholderHighlightKt.m2592fadebw27NRU(PlaceholderHighlight.INSTANCE, PlaceholderKt.m2604fadeHighlightColor3IgeMak(PlaceholderDefaults.INSTANCE, 0L, 0.0f, composer, PlaceholderDefaults.$stable, 3), infiniteRepeatableSpec);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceableGroup();
        return placeholderHighlightM2592fadebw27NRU;
    }

    public static final PlaceholderHighlight shimmer(PlaceholderHighlight.Companion companion, InfiniteRepeatableSpec<Float> infiniteRepeatableSpec, float f, Composer composer, int i, int i2) {
        Intrinsics.checkNotNullParameter(companion, "<this>");
        composer.startReplaceableGroup(444987100);
        ComposerKt.sourceInformation(composer, "C(shimmer)");
        if ((i2 & 1) != 0) {
            infiniteRepeatableSpec = PlaceholderDefaults.INSTANCE.getShimmerAnimationSpec();
        }
        if ((i2 & 2) != 0) {
            f = 0.6f;
        }
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(444987100, i, -1, "com.google.accompanist.placeholder.material3.shimmer (PlaceholderHighlight.kt:57)");
        }
        PlaceholderHighlight placeholderHighlightM2594shimmerRPmYEkk = com.google.accompanist.placeholder.PlaceholderHighlightKt.m2594shimmerRPmYEkk(PlaceholderHighlight.INSTANCE, PlaceholderKt.m2607shimmerHighlightColor3IgeMak(PlaceholderDefaults.INSTANCE, 0L, 0.0f, composer, PlaceholderDefaults.$stable, 3), infiniteRepeatableSpec, f);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceableGroup();
        return placeholderHighlightM2594shimmerRPmYEkk;
    }
}
