package com.google.accompanist.placeholder.material3;

import androidx.compose.animation.core.FiniteAnimationSpec;
import androidx.compose.animation.core.Transition;
import androidx.compose.material3.ColorSchemeKt;
import androidx.compose.material3.MaterialTheme;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.ui.ComposedModifierKt;
import androidx.compose.ui.Modifier;
import androidx.compose.ui.graphics.Color;
import androidx.compose.ui.graphics.ColorKt;
import androidx.compose.ui.graphics.Shape;
import androidx.constraintlayout.core.motion.utils.TypedValues;
import androidx.constraintlayout.widget.ConstraintLayout;
import com.google.accompanist.placeholder.PlaceholderDefaults;
import com.google.accompanist.placeholder.PlaceholderHighlight;
import kotlin.Metadata;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000F\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0007\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\u001a7\u0010\u0000\u001a\u00020\u0001*\u00020\u00022\b\b\u0002\u0010\u0003\u001a\u00020\u00012\b\b\u0002\u0010\u0004\u001a\u00020\u00012\b\b\u0002\u0010\u0005\u001a\u00020\u0006H\u0007ø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\b\u0007\u0010\b\u001a-\u0010\t\u001a\u00020\u0001*\u00020\u00022\b\b\u0002\u0010\u0003\u001a\u00020\u00012\b\b\u0002\u0010\n\u001a\u00020\u0006H\u0007ø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\b\u000b\u0010\f\u001a\u0099\u0001\u0010\r\u001a\u00020\u000e*\u00020\u000e2\u0006\u0010\u000f\u001a\u00020\u00102\b\b\u0002\u0010\u0000\u001a\u00020\u00012\n\b\u0002\u0010\u0011\u001a\u0004\u0018\u00010\u00122\n\b\u0002\u0010\u0013\u001a\u0004\u0018\u00010\u00142*\b\u0002\u0010\u0015\u001a$\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00100\u0017\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00060\u00180\u0016¢\u0006\u0002\b\u0019¢\u0006\u0002\b\u001a2*\b\u0002\u0010\u001b\u001a$\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00100\u0017\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00060\u00180\u0016¢\u0006\u0002\b\u0019¢\u0006\u0002\b\u001aø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\b\u001c\u0010\u001d\u001a-\u0010\u001e\u001a\u00020\u0001*\u00020\u00022\b\b\u0002\u0010\u0003\u001a\u00020\u00012\b\b\u0002\u0010\n\u001a\u00020\u0006H\u0007ø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\b\u001f\u0010\f\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b\u0019¨\u0006 "}, d2 = {TypedValues.Custom.S_COLOR, "Landroidx/compose/ui/graphics/Color;", "Lcom/google/accompanist/placeholder/PlaceholderDefaults;", "backgroundColor", "contentColor", "contentAlpha", "", "color-eopBjH0", "(Lcom/google/accompanist/placeholder/PlaceholderDefaults;JJFLandroidx/compose/runtime/Composer;II)J", "fadeHighlightColor", "alpha", "fadeHighlightColor-3IgeMak", "(Lcom/google/accompanist/placeholder/PlaceholderDefaults;JFLandroidx/compose/runtime/Composer;II)J", "placeholder", "Landroidx/compose/ui/Modifier;", "visible", "", "shape", "Landroidx/compose/ui/graphics/Shape;", "highlight", "Lcom/google/accompanist/placeholder/PlaceholderHighlight;", "placeholderFadeTransitionSpec", "Lkotlin/Function1;", "Landroidx/compose/animation/core/Transition$Segment;", "Landroidx/compose/animation/core/FiniteAnimationSpec;", "Landroidx/compose/runtime/Composable;", "Lkotlin/ExtensionFunctionType;", "contentFadeTransitionSpec", "placeholder-cf5BqRc", "(Landroidx/compose/ui/Modifier;ZJLandroidx/compose/ui/graphics/Shape;Lcom/google/accompanist/placeholder/PlaceholderHighlight;Lkotlin/jvm/functions/Function3;Lkotlin/jvm/functions/Function3;)Landroidx/compose/ui/Modifier;", "shimmerHighlightColor", "shimmerHighlightColor-3IgeMak", "placeholder-material3_release"}, k = 2, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class PlaceholderKt {
    public static final long m2603coloreopBjH0(PlaceholderDefaults placeholderDefaults, long j, long j2, float f, Composer composer, int i, int i2) {
        Intrinsics.checkNotNullParameter(placeholderDefaults, "$this$color");
        composer.startReplaceableGroup(1944456629);
        ComposerKt.sourceInformation(composer, "C(color)P(0:c#ui.graphics.Color,2:c#ui.graphics.Color)");
        long j3 = (i2 & 1) != 0 ? MaterialTheme.INSTANCE.getColorScheme(composer, MaterialTheme.$stable).getSurface-0d7_KjU() : j;
        long j4 = (i2 & 2) != 0 ? ColorSchemeKt.contentColorFor-ek8zF_U(j3, composer, (i >> 3) & 14) : j2;
        float f2 = (i2 & 4) != 0 ? 0.1f : f;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1944456629, i, -1, "com.google.accompanist.placeholder.material3.color (Placeholder.kt:44)");
        }
        long j5 = ColorKt.compositeOver--OWjLjI(Color.copy-wmQWz5c$default(j4, f2, 0.0f, 0.0f, 0.0f, 14, (Object) null), j3);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceableGroup();
        return j5;
    }

    public static final long m2604fadeHighlightColor3IgeMak(PlaceholderDefaults placeholderDefaults, long j, float f, Composer composer, int i, int i2) {
        Intrinsics.checkNotNullParameter(placeholderDefaults, "$this$fadeHighlightColor");
        composer.startReplaceableGroup(-1161857258);
        ComposerKt.sourceInformation(composer, "C(fadeHighlightColor)P(1:c#ui.graphics.Color)");
        if ((i2 & 1) != 0) {
            j = MaterialTheme.INSTANCE.getColorScheme(composer, MaterialTheme.$stable).getSurface-0d7_KjU();
        }
        long j2 = j;
        if ((i2 & 2) != 0) {
            f = 0.3f;
        }
        float f2 = f;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-1161857258, i, -1, "com.google.accompanist.placeholder.material3.fadeHighlightColor (Placeholder.kt:59)");
        }
        long j3 = Color.copy-wmQWz5c$default(j2, f2, 0.0f, 0.0f, 0.0f, 14, (Object) null);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceableGroup();
        return j3;
    }

    public static final long m2607shimmerHighlightColor3IgeMak(PlaceholderDefaults placeholderDefaults, long j, float f, Composer composer, int i, int i2) {
        Intrinsics.checkNotNullParameter(placeholderDefaults, "$this$shimmerHighlightColor");
        composer.startReplaceableGroup(1501692543);
        ComposerKt.sourceInformation(composer, "C(shimmerHighlightColor)P(1:c#ui.graphics.Color)");
        if ((i2 & 1) != 0) {
            j = MaterialTheme.INSTANCE.getColorScheme(composer, MaterialTheme.$stable).getInverseSurface-0d7_KjU();
        }
        long j2 = j;
        if ((i2 & 2) != 0) {
            f = 0.75f;
        }
        float f2 = f;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1501692543, i, -1, "com.google.accompanist.placeholder.material3.shimmerHighlightColor (Placeholder.kt:73)");
        }
        long j3 = Color.copy-wmQWz5c$default(j2, f2, 0.0f, 0.0f, 0.0f, 14, (Object) null);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceableGroup();
        return j3;
    }

    public static final Modifier m2605placeholdercf5BqRc(Modifier modifier, final boolean z, final long j, final Shape shape, final PlaceholderHighlight placeholderHighlight, final Function3<? super Transition.Segment<Boolean>, ? super Composer, ? super Integer, ? extends FiniteAnimationSpec<Float>> function3, final Function3<? super Transition.Segment<Boolean>, ? super Composer, ? super Integer, ? extends FiniteAnimationSpec<Float>> function4) {
        Intrinsics.checkNotNullParameter(modifier, "$this$placeholder");
        Intrinsics.checkNotNullParameter(function3, "placeholderFadeTransitionSpec");
        Intrinsics.checkNotNullParameter(function4, "contentFadeTransitionSpec");
        return ComposedModifierKt.composed$default(modifier, (Function1) null, new Function3<Modifier, Composer, Integer, Modifier>() {
            {
                super(3);
            }

            public Object invoke(Object obj, Object obj2, Object obj3) {
                return invoke((Modifier) obj, (Composer) obj2, ((Number) obj3).intValue());
            }

            public final Modifier invoke(Modifier modifier2, Composer composer, int i) {
                Intrinsics.checkNotNullParameter(modifier2, "$this$composed");
                composer.startReplaceableGroup(-1952471226);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1952471226, i, -1, "com.google.accompanist.placeholder.material3.placeholder.<anonymous> (Placeholder.kt:117)");
                }
                Modifier modifier3 = Modifier.Companion;
                boolean z2 = z;
                composer.startReplaceableGroup(1897802498);
                long jM2603coloreopBjH0 = j != Color.Companion.getUnspecified-0d7_KjU() ? j : PlaceholderKt.m2603coloreopBjH0(PlaceholderDefaults.INSTANCE, 0L, 0L, 0.0f, composer, PlaceholderDefaults.$stable, 7);
                composer.endReplaceableGroup();
                Shape shape2 = shape;
                if (shape2 == null) {
                    shape2 = (Shape) MaterialTheme.INSTANCE.getShapes(composer, MaterialTheme.$stable).getSmall();
                }
                Modifier modifierM2598placeholdercf5BqRc = com.google.accompanist.placeholder.PlaceholderKt.m2598placeholdercf5BqRc(modifier3, z2, jM2603coloreopBjH0, shape2, placeholderHighlight, function3, function4);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                composer.endReplaceableGroup();
                return modifierM2598placeholdercf5BqRc;
            }
        }, 1, (Object) null);
    }
}
