package androidx.compose.material3;

import androidx.compose.animation.AnimatedVisibilityKt;
import androidx.compose.animation.AnimatedVisibilityScope;
import androidx.compose.animation.CrossfadeKt;
import androidx.compose.animation.EnterExitTransitionKt;
import androidx.compose.animation.ExitTransition;
import androidx.compose.animation.core.AnimationSpecKt;
import androidx.compose.animation.core.FiniteAnimationSpec;
import androidx.compose.foundation.BorderStroke;
import androidx.compose.foundation.BorderStrokeKt;
import androidx.compose.foundation.layout.SizeKt;
import androidx.compose.foundation.shape.CornerBasedShape;
import androidx.compose.material.icons.Icons;
import androidx.compose.material.icons.filled.CheckKt;
import androidx.compose.material3.tokens.OutlinedSegmentedButtonTokens;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.graphics.Color;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.graphics.RectangleShapeKt;
import androidx.compose.p002ui.graphics.Shape;
import androidx.compose.p002ui.graphics.TransformOriginKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000^\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0014\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\bÇ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\r\u0010\u0013\u001a\u00020\u0014H\u0007¢\u0006\u0002\u0010\u0015JA\u0010\u0016\u001a\u00020\u00142\u0006\u0010\u0017\u001a\u00020\u00182\u0013\b\u0002\u0010\u0019\u001a\r\u0012\u0004\u0012\u00020\u00140\u001a¢\u0006\u0002\b\u001b2\u0015\b\u0002\u0010\u001c\u001a\u000f\u0012\u0004\u0012\u00020\u0014\u0018\u00010\u001a¢\u0006\u0002\b\u001bH\u0007¢\u0006\u0002\u0010\u001dJ\"\u0010\u001e\u001a\u00020\u001f2\u0006\u0010 \u001a\u00020!2\b\b\u0002\u0010\"\u001a\u00020\u0004ø\u0001\u0000¢\u0006\u0004\b#\u0010$J\r\u0010%\u001a\u00020\u000fH\u0007¢\u0006\u0002\u0010&J\u008a\u0001\u0010%\u001a\u00020\u000f2\b\b\u0002\u0010'\u001a\u00020!2\b\b\u0002\u0010(\u001a\u00020!2\b\b\u0002\u0010)\u001a\u00020!2\b\b\u0002\u0010*\u001a\u00020!2\b\b\u0002\u0010+\u001a\u00020!2\b\b\u0002\u0010,\u001a\u00020!2\b\b\u0002\u0010-\u001a\u00020!2\b\b\u0002\u0010.\u001a\u00020!2\b\b\u0002\u0010/\u001a\u00020!2\b\b\u0002\u00100\u001a\u00020!2\b\b\u0002\u00101\u001a\u00020!2\b\b\u0002\u00102\u001a\u00020!H\u0007ø\u0001\u0000¢\u0006\u0004\b3\u00104J'\u00105\u001a\u0002062\u0006\u00107\u001a\u0002082\u0006\u00109\u001a\u0002082\b\b\u0002\u0010\n\u001a\u00020\u000bH\u0007¢\u0006\u0002\u0010:R\u0019\u0010\u0003\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0005\u0010\u0006R\u0019\u0010\b\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\t\u0010\u0006R\u0011\u0010\n\u001a\u00020\u000b8G¢\u0006\u0006\u001a\u0004\b\f\u0010\rR\u0018\u0010\u000e\u001a\u00020\u000f*\u00020\u00108@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b\u0011\u0010\u0012\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006;"}, d2 = {"Landroidx/compose/material3/SegmentedButtonDefaults;", "", "()V", "BorderWidth", "Landroidx/compose/ui/unit/Dp;", "getBorderWidth-D9Ej5fM", "()F", "F", "IconSize", "getIconSize-D9Ej5fM", "baseShape", "Landroidx/compose/foundation/shape/CornerBasedShape;", "getBaseShape", "(Landroidx/compose/runtime/Composer;I)Landroidx/compose/foundation/shape/CornerBasedShape;", "defaultSegmentedButtonColors", "Landroidx/compose/material3/SegmentedButtonColors;", "Landroidx/compose/material3/ColorScheme;", "getDefaultSegmentedButtonColors$material3_release", "(Landroidx/compose/material3/ColorScheme;)Landroidx/compose/material3/SegmentedButtonColors;", "ActiveIcon", "", "(Landroidx/compose/runtime/Composer;I)V", "Icon", "active", "", "activeContent", "Lkotlin/Function0;", "Landroidx/compose/runtime/Composable;", "inactiveContent", "(ZLkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function2;Landroidx/compose/runtime/Composer;II)V", "borderStroke", "Landroidx/compose/foundation/BorderStroke;", "color", "Landroidx/compose/ui/graphics/Color;", "width", "borderStroke-l07J4OM", "(JF)Landroidx/compose/foundation/BorderStroke;", "colors", "(Landroidx/compose/runtime/Composer;I)Landroidx/compose/material3/SegmentedButtonColors;", "activeContainerColor", "activeContentColor", "activeBorderColor", "inactiveContainerColor", "inactiveContentColor", "inactiveBorderColor", "disabledActiveContainerColor", "disabledActiveContentColor", "disabledActiveBorderColor", "disabledInactiveContainerColor", "disabledInactiveContentColor", "disabledInactiveBorderColor", "colors-XqyqHi0", "(JJJJJJJJJJJJLandroidx/compose/runtime/Composer;III)Landroidx/compose/material3/SegmentedButtonColors;", "itemShape", "Landroidx/compose/ui/graphics/Shape;", "index", "", "count", "(IILandroidx/compose/foundation/shape/CornerBasedShape;Landroidx/compose/runtime/Composer;II)Landroidx/compose/ui/graphics/Shape;", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class SegmentedButtonDefaults {
    public static final int $stable = 0;
    public static final SegmentedButtonDefaults INSTANCE = new SegmentedButtonDefaults();
    private static final float BorderWidth = OutlinedSegmentedButtonTokens.INSTANCE.m3723getOutlineWidthD9Ej5fM();
    private static final float IconSize = OutlinedSegmentedButtonTokens.INSTANCE.m3722getIconSizeD9Ej5fM();

    private SegmentedButtonDefaults() {
    }

    public final SegmentedButtonColors colors(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 679457321, "C(colors)431@18542L11:SegmentedButton.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(679457321, i, -1, "androidx.compose.material3.SegmentedButtonDefaults.colors (SegmentedButton.kt:431)");
        }
        SegmentedButtonColors defaultSegmentedButtonColors$material3_release = getDefaultSegmentedButtonColors$material3_release(MaterialTheme.INSTANCE.getColorScheme(composer, 6));
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return defaultSegmentedButtonColors$material3_release;
    }

    public final SegmentedButtonColors m2768colorsXqyqHi0(long j, long j2, long j3, long j4, long j5, long j6, long j7, long j8, long j9, long j10, long j11, long j12, Composer composer, int i, int i2, int i3) {
        ComposerKt.sourceInformationMarkerStart(composer, 132526205, "C(colors)P(1:c#ui.graphics.Color,2:c#ui.graphics.Color,0:c#ui.graphics.Color,10:c#ui.graphics.Color,11:c#ui.graphics.Color,9:c#ui.graphics.Color,4:c#ui.graphics.Color,5:c#ui.graphics.Color,3:c#ui.graphics.Color,7:c#ui.graphics.Color,8:c#ui.graphics.Color,6:c#ui.graphics.Color)467@20709L11:SegmentedButton.kt#uh7d8r");
        long jM4626getUnspecified0d7_KjU = (i3 & 1) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j;
        long jM4626getUnspecified0d7_KjU2 = (i3 & 2) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j2;
        long jM4626getUnspecified0d7_KjU3 = (i3 & 4) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j3;
        long jM4626getUnspecified0d7_KjU4 = (i3 & 8) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j4;
        long jM4626getUnspecified0d7_KjU5 = (i3 & 16) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j5;
        long jM4626getUnspecified0d7_KjU6 = (i3 & 32) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j6;
        long jM4626getUnspecified0d7_KjU7 = (i3 & 64) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j7;
        long jM4626getUnspecified0d7_KjU8 = (i3 & Fields.SpotShadowColor) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j8;
        long jM4626getUnspecified0d7_KjU9 = (i3 & Fields.RotationX) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j9;
        long jM4626getUnspecified0d7_KjU10 = (i3 & Fields.RotationY) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j10;
        long jM4626getUnspecified0d7_KjU11 = (i3 & Fields.RotationZ) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j11;
        long jM4626getUnspecified0d7_KjU12 = (i3 & Fields.CameraDistance) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j12;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(132526205, i, i2, "androidx.compose.material3.SegmentedButtonDefaults.colors (SegmentedButton.kt:467)");
        }
        SegmentedButtonColors segmentedButtonColorsM2753copy2qZNXz8 = getDefaultSegmentedButtonColors$material3_release(MaterialTheme.INSTANCE.getColorScheme(composer, 6)).m2753copy2qZNXz8(jM4626getUnspecified0d7_KjU, jM4626getUnspecified0d7_KjU2, jM4626getUnspecified0d7_KjU3, jM4626getUnspecified0d7_KjU4, jM4626getUnspecified0d7_KjU5, jM4626getUnspecified0d7_KjU6, jM4626getUnspecified0d7_KjU7, jM4626getUnspecified0d7_KjU8, jM4626getUnspecified0d7_KjU9, jM4626getUnspecified0d7_KjU10, jM4626getUnspecified0d7_KjU11, jM4626getUnspecified0d7_KjU12);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return segmentedButtonColorsM2753copy2qZNXz8;
    }

    public final SegmentedButtonColors getDefaultSegmentedButtonColors$material3_release(ColorScheme colorScheme) {
        SegmentedButtonColors defaultSegmentedButtonColorsCached = colorScheme.getDefaultSegmentedButtonColorsCached();
        if (defaultSegmentedButtonColorsCached != null) {
            return defaultSegmentedButtonColorsCached;
        }
        SegmentedButtonColors segmentedButtonColors = new SegmentedButtonColors(ColorSchemeKt.fromToken(colorScheme, OutlinedSegmentedButtonTokens.INSTANCE.getSelectedContainerColor()), ColorSchemeKt.fromToken(colorScheme, OutlinedSegmentedButtonTokens.INSTANCE.getSelectedLabelTextColor()), ColorSchemeKt.fromToken(colorScheme, OutlinedSegmentedButtonTokens.INSTANCE.getOutlineColor()), colorScheme.getSurface(), ColorSchemeKt.fromToken(colorScheme, OutlinedSegmentedButtonTokens.INSTANCE.getUnselectedLabelTextColor()), ColorSchemeKt.fromToken(colorScheme, OutlinedSegmentedButtonTokens.INSTANCE.getOutlineColor()), ColorSchemeKt.fromToken(colorScheme, OutlinedSegmentedButtonTokens.INSTANCE.getSelectedContainerColor()), Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, OutlinedSegmentedButtonTokens.INSTANCE.getDisabledLabelTextColor()), OutlinedSegmentedButtonTokens.INSTANCE.getDisabledLabelTextOpacity(), 0.0f, 0.0f, 0.0f, 14, null), Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, OutlinedSegmentedButtonTokens.INSTANCE.getOutlineColor()), OutlinedSegmentedButtonTokens.INSTANCE.getDisabledOutlineOpacity(), 0.0f, 0.0f, 0.0f, 14, null), colorScheme.getSurface(), ColorSchemeKt.fromToken(colorScheme, OutlinedSegmentedButtonTokens.INSTANCE.getDisabledLabelTextColor()), ColorSchemeKt.fromToken(colorScheme, OutlinedSegmentedButtonTokens.INSTANCE.getOutlineColor()), null);
        colorScheme.setDefaultSegmentedButtonColorsCached$material3_release(segmentedButtonColors);
        return segmentedButtonColors;
    }

    public final CornerBasedShape getBaseShape(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 1264240381, "C512@23272L5:SegmentedButton.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1264240381, i, -1, "androidx.compose.material3.SegmentedButtonDefaults.<get-baseShape> (SegmentedButton.kt:512)");
        }
        Shape value = ShapesKt.getValue(OutlinedSegmentedButtonTokens.INSTANCE.getShape(), composer, 6);
        Intrinsics.checkNotNull(value, "null cannot be cast to non-null type androidx.compose.foundation.shape.CornerBasedShape");
        CornerBasedShape cornerBasedShape = (CornerBasedShape) value;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return cornerBasedShape;
    }

    public final float m2769getBorderWidthD9Ej5fM() {
        return BorderWidth;
    }

    public final Shape itemShape(int i, int i2, CornerBasedShape cornerBasedShape, Composer composer, int i3, int i4) {
        CornerBasedShape rectangleShape;
        ComposerKt.sourceInformationMarkerStart(composer, -942072063, "C(itemShape)P(2,1)528@23938L9:SegmentedButton.kt#uh7d8r");
        if ((i4 & 4) != 0) {
            cornerBasedShape = getBaseShape(composer, (i3 >> 9) & 14);
        }
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-942072063, i3, -1, "androidx.compose.material3.SegmentedButtonDefaults.itemShape (SegmentedButton.kt:528)");
        }
        if (i2 == 1) {
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            ComposerKt.sourceInformationMarkerEnd(composer);
            return cornerBasedShape;
        }
        if (i == 0) {
            rectangleShape = ShapesKt.start(cornerBasedShape);
        } else if (i == i2 - 1) {
            rectangleShape = ShapesKt.end(cornerBasedShape);
        } else {
            rectangleShape = RectangleShapeKt.getRectangleShape();
        }
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return rectangleShape;
    }

    public final float m2770getIconSizeD9Ej5fM() {
        return IconSize;
    }

    public final void ActiveIcon(Composer composer, final int i) {
        int i2;
        Composer composerStartRestartGroup = composer.startRestartGroup(-1273041460);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(ActiveIcon)546@24428L147:SegmentedButton.kt#uh7d8r");
        if ((i & 6) == 0) {
            i2 = (composerStartRestartGroup.changed(this) ? 4 : 2) | i;
        } else {
            i2 = i;
        }
        if ((i2 & 3) != 2 || !composerStartRestartGroup.getSkipping()) {
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1273041460, i2, -1, "androidx.compose.material3.SegmentedButtonDefaults.ActiveIcon (SegmentedButton.kt:545)");
            }
            IconKt.m2433Iconww6aTOc(CheckKt.getCheck(Icons.Filled.INSTANCE), (String) null, SizeKt.m1080size3ABfNKs(Modifier.INSTANCE, IconSize), 0L, composerStartRestartGroup, 48, 8);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        } else {
            composerStartRestartGroup.skipToGroupEnd();
        }
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i3) {
                    SegmentedButtonDefaults.this.ActiveIcon(composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1));
                }
            });
        }
    }

    public final void Icon(final boolean z, Function2<? super Composer, ? super Integer, Unit> function2, Function2<? super Composer, ? super Integer, Unit> function3, Composer composer, final int i, final int i2) {
        int i3;
        Function2<? super Composer, ? super Integer, Unit> function4;
        int i4;
        Function2<? super Composer, ? super Integer, Unit> function5;
        int i5;
        final Function2<? super Composer, ? super Integer, Unit> function2M2225getLambda1$material3_release;
        Function2<? super Composer, ? super Integer, Unit> function6;
        Composer composer2;
        final Function2<? super Composer, ? super Integer, Unit> function7;
        final Function2<? super Composer, ? super Integer, Unit> function8;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        Composer composerStartRestartGroup = composer.startRestartGroup(683517296);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(Icon):SegmentedButton.kt#uh7d8r");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changed(z) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i6 = i2 & 2;
        if (i6 == 0) {
            if ((i & 48) == 0) {
                function4 = function2;
                i3 |= composerStartRestartGroup.changedInstance(function4) ? 32 : 16;
            }
            i4 = i2 & 4;
            if (i4 != 0) {
                if ((i & 384) == 0) {
                    function5 = function3;
                    if (composerStartRestartGroup.changedInstance(function5)) {
                        i5 = Fields.RotationX;
                    } else {
                        i5 = Fields.SpotShadowColor;
                    }
                    i3 |= i5;
                }
                if ((i3 & 147) == 146 || !composerStartRestartGroup.getSkipping()) {
                    if (i6 != 0) {
                        function2M2225getLambda1$material3_release = ComposableSingletons$SegmentedButtonKt.INSTANCE.m2225getLambda1$material3_release();
                    } else {
                        function2M2225getLambda1$material3_release = function4;
                    }
                    if (i4 != 0) {
                        function6 = null;
                    } else {
                        function6 = function5;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(683517296, i3, -1, "androidx.compose.material3.SegmentedButtonDefaults.Icon (SegmentedButton.kt:566)");
                    }
                    if (function6 == null) {
                        composerStartRestartGroup.startReplaceGroup(1631306250);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "578@25645L47,568@25168L524");
                        composer2 = composerStartRestartGroup;
                        function7 = function6;
                        AnimatedVisibilityKt.AnimatedVisibility(z, (Modifier) null, EnterExitTransitionKt.fadeIn$default(AnimationSpecKt.tween$default(350, 0, null, 6, null), 0.0f, 2, null).plus(EnterExitTransitionKt.m333scaleInL8ZKhE(AnimationSpecKt.tween$default(350, 0, null, 6, null), 0.0f, TransformOriginKt.TransformOrigin(0.0f, 1.0f))), ExitTransition.INSTANCE.getNone(), (String) null, ComposableLambdaKt.rememberComposableLambda(-750750819, true, new Function3<AnimatedVisibilityScope, Composer, Integer, Unit>() {
                            {
                                super(3);
                            }

                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                invoke((AnimatedVisibilityScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(AnimatedVisibilityScope animatedVisibilityScope, Composer composer3, int i7) {
                                ComposerKt.sourceInformation(composer3, "C579@25663L15:SegmentedButton.kt#uh7d8r");
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-750750819, i7, -1, "androidx.compose.material3.SegmentedButtonDefaults.Icon.<anonymous> (SegmentedButton.kt:579)");
                                }
                                function2M2225getLambda1$material3_release.invoke(composer3, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composer2, 54), composer2, (i3 & 14) | 196608, 18);
                        composer2.endReplaceGroup();
                    } else {
                        composer2 = composerStartRestartGroup;
                        function7 = function6;
                        composer2.startReplaceGroup(1631842116);
                        ComposerKt.sourceInformation(composer2, "582@25754L50,582@25722L82");
                        CrossfadeKt.Crossfade(Boolean.valueOf(z), (Modifier) null, (FiniteAnimationSpec<Float>) null, (String) null, ComposableLambdaKt.rememberComposableLambda(-1364873619, true, new Function3<Boolean, Composer, Integer, Unit>() {
                            {
                                super(3);
                            }

                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                invoke(((Boolean) obj).booleanValue(), (Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(boolean z2, Composer composer3, int i7) {
                                Function2<Composer, Integer, Unit> function9;
                                ComposerKt.sourceInformation(composer3, "C:SegmentedButton.kt#uh7d8r");
                                if ((i7 & 6) == 0) {
                                    i7 |= composer3.changed(z2) ? 4 : 2;
                                }
                                if ((i7 & 19) == 18 && composer3.getSkipping()) {
                                    composer3.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1364873619, i7, -1, "androidx.compose.material3.SegmentedButtonDefaults.Icon.<anonymous> (SegmentedButton.kt:582)");
                                }
                                if (z2) {
                                    composer3.startReplaceGroup(94251810);
                                    ComposerKt.sourceInformation(composer3, "582@25764L15");
                                    function9 = function2M2225getLambda1$material3_release;
                                } else {
                                    composer3.startReplaceGroup(94252484);
                                    ComposerKt.sourceInformation(composer3, "582@25785L17");
                                    function9 = function7;
                                }
                                function9.invoke(composer3, 0);
                                composer3.endReplaceGroup();
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composer2, 54), composer2, (i3 & 14) | 24576, 14);
                        composer2.endReplaceGroup();
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function8 = function7;
                } else {
                    composerStartRestartGroup.skipToGroupEnd();
                    composer2 = composerStartRestartGroup;
                    function2M2225getLambda1$material3_release = function4;
                    function8 = function5;
                }
                scopeUpdateScopeEndRestartGroup = composer2.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Function2<? super Composer, ? super Integer, Unit> function9 = function2M2225getLambda1$material3_release;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer3, int i7) {
                            SegmentedButtonDefaults.this.Icon(z, function9, function8, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 384;
            function5 = function3;
            if ((i3 & 147) == 146) {
                if (i6 != 0) {
                    function2M2225getLambda1$material3_release = ComposableSingletons$SegmentedButtonKt.INSTANCE.m2225getLambda1$material3_release();
                } else {
                    function2M2225getLambda1$material3_release = function4;
                }
                if (i4 != 0) {
                    function6 = null;
                } else {
                    function6 = function5;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(683517296, i3, -1, "androidx.compose.material3.SegmentedButtonDefaults.Icon (SegmentedButton.kt:566)");
                }
                if (function6 == null) {
                    composerStartRestartGroup.startReplaceGroup(1631306250);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "578@25645L47,568@25168L524");
                    composer2 = composerStartRestartGroup;
                    function7 = function6;
                    AnimatedVisibilityKt.AnimatedVisibility(z, (Modifier) null, EnterExitTransitionKt.fadeIn$default(AnimationSpecKt.tween$default(350, 0, null, 6, null), 0.0f, 2, null).plus(EnterExitTransitionKt.m333scaleInL8ZKhE(AnimationSpecKt.tween$default(350, 0, null, 6, null), 0.0f, TransformOriginKt.TransformOrigin(0.0f, 1.0f))), ExitTransition.INSTANCE.getNone(), (String) null, ComposableLambdaKt.rememberComposableLambda(-750750819, true, new Function3<AnimatedVisibilityScope, Composer, Integer, Unit>() {
                        {
                            super(3);
                        }

                        public Object invoke(Object obj, Object obj2, Object obj3) {
                            invoke((AnimatedVisibilityScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(AnimatedVisibilityScope animatedVisibilityScope, Composer composer3, int i7) {
                            ComposerKt.sourceInformation(composer3, "C579@25663L15:SegmentedButton.kt#uh7d8r");
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-750750819, i7, -1, "androidx.compose.material3.SegmentedButtonDefaults.Icon.<anonymous> (SegmentedButton.kt:579)");
                            }
                            function2M2225getLambda1$material3_release.invoke(composer3, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composer2, 54), composer2, (i3 & 14) | 196608, 18);
                    composer2.endReplaceGroup();
                } else {
                    composer2 = composerStartRestartGroup;
                    function7 = function6;
                    composer2.startReplaceGroup(1631842116);
                    ComposerKt.sourceInformation(composer2, "582@25754L50,582@25722L82");
                    CrossfadeKt.Crossfade(Boolean.valueOf(z), (Modifier) null, (FiniteAnimationSpec<Float>) null, (String) null, ComposableLambdaKt.rememberComposableLambda(-1364873619, true, new Function3<Boolean, Composer, Integer, Unit>() {
                        {
                            super(3);
                        }

                        public Object invoke(Object obj, Object obj2, Object obj3) {
                            invoke(((Boolean) obj).booleanValue(), (Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(boolean z2, Composer composer3, int i7) {
                            Function2<Composer, Integer, Unit> function10;
                            ComposerKt.sourceInformation(composer3, "C:SegmentedButton.kt#uh7d8r");
                            if ((i7 & 6) == 0) {
                                i7 |= composer3.changed(z2) ? 4 : 2;
                            }
                            if ((i7 & 19) == 18 && composer3.getSkipping()) {
                                composer3.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1364873619, i7, -1, "androidx.compose.material3.SegmentedButtonDefaults.Icon.<anonymous> (SegmentedButton.kt:582)");
                            }
                            if (z2) {
                                composer3.startReplaceGroup(94251810);
                                ComposerKt.sourceInformation(composer3, "582@25764L15");
                                function10 = function2M2225getLambda1$material3_release;
                            } else {
                                composer3.startReplaceGroup(94252484);
                                ComposerKt.sourceInformation(composer3, "582@25785L17");
                                function10 = function7;
                            }
                            function10.invoke(composer3, 0);
                            composer3.endReplaceGroup();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composer2, 54), composer2, (i3 & 14) | 24576, 14);
                    composer2.endReplaceGroup();
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function8 = function7;
            } else {
                if (i6 != 0) {
                    function2M2225getLambda1$material3_release = ComposableSingletons$SegmentedButtonKt.INSTANCE.m2225getLambda1$material3_release();
                } else {
                    function2M2225getLambda1$material3_release = function4;
                }
                if (i4 != 0) {
                    function6 = null;
                } else {
                    function6 = function5;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(683517296, i3, -1, "androidx.compose.material3.SegmentedButtonDefaults.Icon (SegmentedButton.kt:566)");
                }
                if (function6 == null) {
                    composerStartRestartGroup.startReplaceGroup(1631306250);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "578@25645L47,568@25168L524");
                    composer2 = composerStartRestartGroup;
                    function7 = function6;
                    AnimatedVisibilityKt.AnimatedVisibility(z, (Modifier) null, EnterExitTransitionKt.fadeIn$default(AnimationSpecKt.tween$default(350, 0, null, 6, null), 0.0f, 2, null).plus(EnterExitTransitionKt.m333scaleInL8ZKhE(AnimationSpecKt.tween$default(350, 0, null, 6, null), 0.0f, TransformOriginKt.TransformOrigin(0.0f, 1.0f))), ExitTransition.INSTANCE.getNone(), (String) null, ComposableLambdaKt.rememberComposableLambda(-750750819, true, new Function3<AnimatedVisibilityScope, Composer, Integer, Unit>() {
                        {
                            super(3);
                        }

                        public Object invoke(Object obj, Object obj2, Object obj3) {
                            invoke((AnimatedVisibilityScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(AnimatedVisibilityScope animatedVisibilityScope, Composer composer3, int i7) {
                            ComposerKt.sourceInformation(composer3, "C579@25663L15:SegmentedButton.kt#uh7d8r");
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-750750819, i7, -1, "androidx.compose.material3.SegmentedButtonDefaults.Icon.<anonymous> (SegmentedButton.kt:579)");
                            }
                            function2M2225getLambda1$material3_release.invoke(composer3, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composer2, 54), composer2, (i3 & 14) | 196608, 18);
                    composer2.endReplaceGroup();
                } else {
                    composer2 = composerStartRestartGroup;
                    function7 = function6;
                    composer2.startReplaceGroup(1631842116);
                    ComposerKt.sourceInformation(composer2, "582@25754L50,582@25722L82");
                    CrossfadeKt.Crossfade(Boolean.valueOf(z), (Modifier) null, (FiniteAnimationSpec<Float>) null, (String) null, ComposableLambdaKt.rememberComposableLambda(-1364873619, true, new Function3<Boolean, Composer, Integer, Unit>() {
                        {
                            super(3);
                        }

                        public Object invoke(Object obj, Object obj2, Object obj3) {
                            invoke(((Boolean) obj).booleanValue(), (Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(boolean z2, Composer composer3, int i7) {
                            Function2<Composer, Integer, Unit> function10;
                            ComposerKt.sourceInformation(composer3, "C:SegmentedButton.kt#uh7d8r");
                            if ((i7 & 6) == 0) {
                                i7 |= composer3.changed(z2) ? 4 : 2;
                            }
                            if ((i7 & 19) == 18 && composer3.getSkipping()) {
                                composer3.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1364873619, i7, -1, "androidx.compose.material3.SegmentedButtonDefaults.Icon.<anonymous> (SegmentedButton.kt:582)");
                            }
                            if (z2) {
                                composer3.startReplaceGroup(94251810);
                                ComposerKt.sourceInformation(composer3, "582@25764L15");
                                function10 = function2M2225getLambda1$material3_release;
                            } else {
                                composer3.startReplaceGroup(94252484);
                                ComposerKt.sourceInformation(composer3, "582@25785L17");
                                function10 = function7;
                            }
                            function10.invoke(composer3, 0);
                            composer3.endReplaceGroup();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composer2, 54), composer2, (i3 & 14) | 24576, 14);
                    composer2.endReplaceGroup();
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function8 = function7;
            }
            scopeUpdateScopeEndRestartGroup = composer2.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Function2<? super Composer, ? super Integer, Unit> function10 = function2M2225getLambda1$material3_release;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer3, int i7) {
                        SegmentedButtonDefaults.this.Icon(z, function10, function8, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        function4 = function2;
        i4 = i2 & 4;
        if (i4 != 0) {
            if ((i & 384) == 0) {
                function5 = function3;
                if (composerStartRestartGroup.changedInstance(function5)) {
                    i5 = Fields.RotationX;
                } else {
                    i5 = Fields.SpotShadowColor;
                }
                i3 |= i5;
            }
            if ((i3 & 147) == 146) {
                if (i6 != 0) {
                    function2M2225getLambda1$material3_release = ComposableSingletons$SegmentedButtonKt.INSTANCE.m2225getLambda1$material3_release();
                } else {
                    function2M2225getLambda1$material3_release = function4;
                }
                if (i4 != 0) {
                    function6 = null;
                } else {
                    function6 = function5;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(683517296, i3, -1, "androidx.compose.material3.SegmentedButtonDefaults.Icon (SegmentedButton.kt:566)");
                }
                if (function6 == null) {
                    composerStartRestartGroup.startReplaceGroup(1631306250);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "578@25645L47,568@25168L524");
                    composer2 = composerStartRestartGroup;
                    function7 = function6;
                    AnimatedVisibilityKt.AnimatedVisibility(z, (Modifier) null, EnterExitTransitionKt.fadeIn$default(AnimationSpecKt.tween$default(350, 0, null, 6, null), 0.0f, 2, null).plus(EnterExitTransitionKt.m333scaleInL8ZKhE(AnimationSpecKt.tween$default(350, 0, null, 6, null), 0.0f, TransformOriginKt.TransformOrigin(0.0f, 1.0f))), ExitTransition.INSTANCE.getNone(), (String) null, ComposableLambdaKt.rememberComposableLambda(-750750819, true, new Function3<AnimatedVisibilityScope, Composer, Integer, Unit>() {
                        {
                            super(3);
                        }

                        public Object invoke(Object obj, Object obj2, Object obj3) {
                            invoke((AnimatedVisibilityScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(AnimatedVisibilityScope animatedVisibilityScope, Composer composer3, int i7) {
                            ComposerKt.sourceInformation(composer3, "C579@25663L15:SegmentedButton.kt#uh7d8r");
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-750750819, i7, -1, "androidx.compose.material3.SegmentedButtonDefaults.Icon.<anonymous> (SegmentedButton.kt:579)");
                            }
                            function2M2225getLambda1$material3_release.invoke(composer3, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composer2, 54), composer2, (i3 & 14) | 196608, 18);
                    composer2.endReplaceGroup();
                } else {
                    composer2 = composerStartRestartGroup;
                    function7 = function6;
                    composer2.startReplaceGroup(1631842116);
                    ComposerKt.sourceInformation(composer2, "582@25754L50,582@25722L82");
                    CrossfadeKt.Crossfade(Boolean.valueOf(z), (Modifier) null, (FiniteAnimationSpec<Float>) null, (String) null, ComposableLambdaKt.rememberComposableLambda(-1364873619, true, new Function3<Boolean, Composer, Integer, Unit>() {
                        {
                            super(3);
                        }

                        public Object invoke(Object obj, Object obj2, Object obj3) {
                            invoke(((Boolean) obj).booleanValue(), (Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(boolean z2, Composer composer3, int i7) {
                            Function2<Composer, Integer, Unit> function11;
                            ComposerKt.sourceInformation(composer3, "C:SegmentedButton.kt#uh7d8r");
                            if ((i7 & 6) == 0) {
                                i7 |= composer3.changed(z2) ? 4 : 2;
                            }
                            if ((i7 & 19) == 18 && composer3.getSkipping()) {
                                composer3.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1364873619, i7, -1, "androidx.compose.material3.SegmentedButtonDefaults.Icon.<anonymous> (SegmentedButton.kt:582)");
                            }
                            if (z2) {
                                composer3.startReplaceGroup(94251810);
                                ComposerKt.sourceInformation(composer3, "582@25764L15");
                                function11 = function2M2225getLambda1$material3_release;
                            } else {
                                composer3.startReplaceGroup(94252484);
                                ComposerKt.sourceInformation(composer3, "582@25785L17");
                                function11 = function7;
                            }
                            function11.invoke(composer3, 0);
                            composer3.endReplaceGroup();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composer2, 54), composer2, (i3 & 14) | 24576, 14);
                    composer2.endReplaceGroup();
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function8 = function7;
            } else {
                if (i6 != 0) {
                    function2M2225getLambda1$material3_release = ComposableSingletons$SegmentedButtonKt.INSTANCE.m2225getLambda1$material3_release();
                } else {
                    function2M2225getLambda1$material3_release = function4;
                }
                if (i4 != 0) {
                    function6 = null;
                } else {
                    function6 = function5;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(683517296, i3, -1, "androidx.compose.material3.SegmentedButtonDefaults.Icon (SegmentedButton.kt:566)");
                }
                if (function6 == null) {
                    composerStartRestartGroup.startReplaceGroup(1631306250);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "578@25645L47,568@25168L524");
                    composer2 = composerStartRestartGroup;
                    function7 = function6;
                    AnimatedVisibilityKt.AnimatedVisibility(z, (Modifier) null, EnterExitTransitionKt.fadeIn$default(AnimationSpecKt.tween$default(350, 0, null, 6, null), 0.0f, 2, null).plus(EnterExitTransitionKt.m333scaleInL8ZKhE(AnimationSpecKt.tween$default(350, 0, null, 6, null), 0.0f, TransformOriginKt.TransformOrigin(0.0f, 1.0f))), ExitTransition.INSTANCE.getNone(), (String) null, ComposableLambdaKt.rememberComposableLambda(-750750819, true, new Function3<AnimatedVisibilityScope, Composer, Integer, Unit>() {
                        {
                            super(3);
                        }

                        public Object invoke(Object obj, Object obj2, Object obj3) {
                            invoke((AnimatedVisibilityScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(AnimatedVisibilityScope animatedVisibilityScope, Composer composer3, int i7) {
                            ComposerKt.sourceInformation(composer3, "C579@25663L15:SegmentedButton.kt#uh7d8r");
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-750750819, i7, -1, "androidx.compose.material3.SegmentedButtonDefaults.Icon.<anonymous> (SegmentedButton.kt:579)");
                            }
                            function2M2225getLambda1$material3_release.invoke(composer3, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composer2, 54), composer2, (i3 & 14) | 196608, 18);
                    composer2.endReplaceGroup();
                } else {
                    composer2 = composerStartRestartGroup;
                    function7 = function6;
                    composer2.startReplaceGroup(1631842116);
                    ComposerKt.sourceInformation(composer2, "582@25754L50,582@25722L82");
                    CrossfadeKt.Crossfade(Boolean.valueOf(z), (Modifier) null, (FiniteAnimationSpec<Float>) null, (String) null, ComposableLambdaKt.rememberComposableLambda(-1364873619, true, new Function3<Boolean, Composer, Integer, Unit>() {
                        {
                            super(3);
                        }

                        public Object invoke(Object obj, Object obj2, Object obj3) {
                            invoke(((Boolean) obj).booleanValue(), (Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(boolean z2, Composer composer3, int i7) {
                            Function2<Composer, Integer, Unit> function11;
                            ComposerKt.sourceInformation(composer3, "C:SegmentedButton.kt#uh7d8r");
                            if ((i7 & 6) == 0) {
                                i7 |= composer3.changed(z2) ? 4 : 2;
                            }
                            if ((i7 & 19) == 18 && composer3.getSkipping()) {
                                composer3.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1364873619, i7, -1, "androidx.compose.material3.SegmentedButtonDefaults.Icon.<anonymous> (SegmentedButton.kt:582)");
                            }
                            if (z2) {
                                composer3.startReplaceGroup(94251810);
                                ComposerKt.sourceInformation(composer3, "582@25764L15");
                                function11 = function2M2225getLambda1$material3_release;
                            } else {
                                composer3.startReplaceGroup(94252484);
                                ComposerKt.sourceInformation(composer3, "582@25785L17");
                                function11 = function7;
                            }
                            function11.invoke(composer3, 0);
                            composer3.endReplaceGroup();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composer2, 54), composer2, (i3 & 14) | 24576, 14);
                    composer2.endReplaceGroup();
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function8 = function7;
            }
            scopeUpdateScopeEndRestartGroup = composer2.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Function2<? super Composer, ? super Integer, Unit> function11 = function2M2225getLambda1$material3_release;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer3, int i7) {
                        SegmentedButtonDefaults.this.Icon(z, function11, function8, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 384;
        function5 = function3;
        if ((i3 & 147) == 146) {
            if (i6 != 0) {
                function2M2225getLambda1$material3_release = ComposableSingletons$SegmentedButtonKt.INSTANCE.m2225getLambda1$material3_release();
            } else {
                function2M2225getLambda1$material3_release = function4;
            }
            if (i4 != 0) {
                function6 = null;
            } else {
                function6 = function5;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(683517296, i3, -1, "androidx.compose.material3.SegmentedButtonDefaults.Icon (SegmentedButton.kt:566)");
            }
            if (function6 == null) {
                composerStartRestartGroup.startReplaceGroup(1631306250);
                ComposerKt.sourceInformation(composerStartRestartGroup, "578@25645L47,568@25168L524");
                composer2 = composerStartRestartGroup;
                function7 = function6;
                AnimatedVisibilityKt.AnimatedVisibility(z, (Modifier) null, EnterExitTransitionKt.fadeIn$default(AnimationSpecKt.tween$default(350, 0, null, 6, null), 0.0f, 2, null).plus(EnterExitTransitionKt.m333scaleInL8ZKhE(AnimationSpecKt.tween$default(350, 0, null, 6, null), 0.0f, TransformOriginKt.TransformOrigin(0.0f, 1.0f))), ExitTransition.INSTANCE.getNone(), (String) null, ComposableLambdaKt.rememberComposableLambda(-750750819, true, new Function3<AnimatedVisibilityScope, Composer, Integer, Unit>() {
                    {
                        super(3);
                    }

                    public Object invoke(Object obj, Object obj2, Object obj3) {
                        invoke((AnimatedVisibilityScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(AnimatedVisibilityScope animatedVisibilityScope, Composer composer3, int i7) {
                        ComposerKt.sourceInformation(composer3, "C579@25663L15:SegmentedButton.kt#uh7d8r");
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-750750819, i7, -1, "androidx.compose.material3.SegmentedButtonDefaults.Icon.<anonymous> (SegmentedButton.kt:579)");
                        }
                        function2M2225getLambda1$material3_release.invoke(composer3, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composer2, 54), composer2, (i3 & 14) | 196608, 18);
                composer2.endReplaceGroup();
            } else {
                composer2 = composerStartRestartGroup;
                function7 = function6;
                composer2.startReplaceGroup(1631842116);
                ComposerKt.sourceInformation(composer2, "582@25754L50,582@25722L82");
                CrossfadeKt.Crossfade(Boolean.valueOf(z), (Modifier) null, (FiniteAnimationSpec<Float>) null, (String) null, ComposableLambdaKt.rememberComposableLambda(-1364873619, true, new Function3<Boolean, Composer, Integer, Unit>() {
                    {
                        super(3);
                    }

                    public Object invoke(Object obj, Object obj2, Object obj3) {
                        invoke(((Boolean) obj).booleanValue(), (Composer) obj2, ((Number) obj3).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(boolean z2, Composer composer3, int i7) {
                        Function2<Composer, Integer, Unit> function12;
                        ComposerKt.sourceInformation(composer3, "C:SegmentedButton.kt#uh7d8r");
                        if ((i7 & 6) == 0) {
                            i7 |= composer3.changed(z2) ? 4 : 2;
                        }
                        if ((i7 & 19) == 18 && composer3.getSkipping()) {
                            composer3.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1364873619, i7, -1, "androidx.compose.material3.SegmentedButtonDefaults.Icon.<anonymous> (SegmentedButton.kt:582)");
                        }
                        if (z2) {
                            composer3.startReplaceGroup(94251810);
                            ComposerKt.sourceInformation(composer3, "582@25764L15");
                            function12 = function2M2225getLambda1$material3_release;
                        } else {
                            composer3.startReplaceGroup(94252484);
                            ComposerKt.sourceInformation(composer3, "582@25785L17");
                            function12 = function7;
                        }
                        function12.invoke(composer3, 0);
                        composer3.endReplaceGroup();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composer2, 54), composer2, (i3 & 14) | 24576, 14);
                composer2.endReplaceGroup();
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            function8 = function7;
        } else {
            if (i6 != 0) {
                function2M2225getLambda1$material3_release = ComposableSingletons$SegmentedButtonKt.INSTANCE.m2225getLambda1$material3_release();
            } else {
                function2M2225getLambda1$material3_release = function4;
            }
            if (i4 != 0) {
                function6 = null;
            } else {
                function6 = function5;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(683517296, i3, -1, "androidx.compose.material3.SegmentedButtonDefaults.Icon (SegmentedButton.kt:566)");
            }
            if (function6 == null) {
                composerStartRestartGroup.startReplaceGroup(1631306250);
                ComposerKt.sourceInformation(composerStartRestartGroup, "578@25645L47,568@25168L524");
                composer2 = composerStartRestartGroup;
                function7 = function6;
                AnimatedVisibilityKt.AnimatedVisibility(z, (Modifier) null, EnterExitTransitionKt.fadeIn$default(AnimationSpecKt.tween$default(350, 0, null, 6, null), 0.0f, 2, null).plus(EnterExitTransitionKt.m333scaleInL8ZKhE(AnimationSpecKt.tween$default(350, 0, null, 6, null), 0.0f, TransformOriginKt.TransformOrigin(0.0f, 1.0f))), ExitTransition.INSTANCE.getNone(), (String) null, ComposableLambdaKt.rememberComposableLambda(-750750819, true, new Function3<AnimatedVisibilityScope, Composer, Integer, Unit>() {
                    {
                        super(3);
                    }

                    public Object invoke(Object obj, Object obj2, Object obj3) {
                        invoke((AnimatedVisibilityScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(AnimatedVisibilityScope animatedVisibilityScope, Composer composer3, int i7) {
                        ComposerKt.sourceInformation(composer3, "C579@25663L15:SegmentedButton.kt#uh7d8r");
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-750750819, i7, -1, "androidx.compose.material3.SegmentedButtonDefaults.Icon.<anonymous> (SegmentedButton.kt:579)");
                        }
                        function2M2225getLambda1$material3_release.invoke(composer3, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composer2, 54), composer2, (i3 & 14) | 196608, 18);
                composer2.endReplaceGroup();
            } else {
                composer2 = composerStartRestartGroup;
                function7 = function6;
                composer2.startReplaceGroup(1631842116);
                ComposerKt.sourceInformation(composer2, "582@25754L50,582@25722L82");
                CrossfadeKt.Crossfade(Boolean.valueOf(z), (Modifier) null, (FiniteAnimationSpec<Float>) null, (String) null, ComposableLambdaKt.rememberComposableLambda(-1364873619, true, new Function3<Boolean, Composer, Integer, Unit>() {
                    {
                        super(3);
                    }

                    public Object invoke(Object obj, Object obj2, Object obj3) {
                        invoke(((Boolean) obj).booleanValue(), (Composer) obj2, ((Number) obj3).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(boolean z2, Composer composer3, int i7) {
                        Function2<Composer, Integer, Unit> function12;
                        ComposerKt.sourceInformation(composer3, "C:SegmentedButton.kt#uh7d8r");
                        if ((i7 & 6) == 0) {
                            i7 |= composer3.changed(z2) ? 4 : 2;
                        }
                        if ((i7 & 19) == 18 && composer3.getSkipping()) {
                            composer3.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1364873619, i7, -1, "androidx.compose.material3.SegmentedButtonDefaults.Icon.<anonymous> (SegmentedButton.kt:582)");
                        }
                        if (z2) {
                            composer3.startReplaceGroup(94251810);
                            ComposerKt.sourceInformation(composer3, "582@25764L15");
                            function12 = function2M2225getLambda1$material3_release;
                        } else {
                            composer3.startReplaceGroup(94252484);
                            ComposerKt.sourceInformation(composer3, "582@25785L17");
                            function12 = function7;
                        }
                        function12.invoke(composer3, 0);
                        composer3.endReplaceGroup();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composer2, 54), composer2, (i3 & 14) | 24576, 14);
                composer2.endReplaceGroup();
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            function8 = function7;
        }
        scopeUpdateScopeEndRestartGroup = composer2.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Function2<? super Composer, ? super Integer, Unit> function12 = function2M2225getLambda1$material3_release;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer3, int i7) {
                    SegmentedButtonDefaults.this.Icon(z, function12, function8, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static BorderStroke m2766borderStrokel07J4OM$default(SegmentedButtonDefaults segmentedButtonDefaults, long j, float f, int i, Object obj) {
        if ((i & 2) != 0) {
            f = BorderWidth;
        }
        return segmentedButtonDefaults.m2767borderStrokel07J4OM(j, f);
    }

    public final BorderStroke m2767borderStrokel07J4OM(long color, float width) {
        return BorderStrokeKt.m549BorderStrokecXLIe8U(width, color);
    }
}
