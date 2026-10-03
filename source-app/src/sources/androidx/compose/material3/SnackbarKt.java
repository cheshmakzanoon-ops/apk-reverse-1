package androidx.compose.material3;

import androidx.compose.foundation.layout.AlignmentLineKt;
import androidx.compose.foundation.layout.Arrangement;
import androidx.compose.foundation.layout.BoxKt;
import androidx.compose.foundation.layout.BoxScopeInstance;
import androidx.compose.foundation.layout.ColumnKt;
import androidx.compose.foundation.layout.ColumnScopeInstance;
import androidx.compose.foundation.layout.PaddingKt;
import androidx.compose.foundation.layout.RowKt;
import androidx.compose.foundation.layout.RowScope;
import androidx.compose.foundation.layout.RowScopeInstance;
import androidx.compose.foundation.layout.SizeKt;
import androidx.compose.material3.tokens.SnackbarTokens;
import androidx.compose.p002ui.Alignment;
import androidx.compose.p002ui.ComposedModifierKt;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.graphics.Color;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.graphics.Shape;
import androidx.compose.p002ui.layout.IntrinsicMeasureScope;
import androidx.compose.p002ui.layout.LayoutIdKt;
import androidx.compose.p002ui.layout.Measurable;
import androidx.compose.p002ui.layout.MeasurePolicy;
import androidx.compose.p002ui.layout.MeasureResult;
import androidx.compose.p002ui.layout.MeasureScope;
import androidx.compose.p002ui.layout.Placeable;
import androidx.compose.p002ui.node.ComposeUiNode;
import androidx.compose.runtime.Applier;
import androidx.compose.runtime.ComposablesKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.CompositionLocalKt;
import androidx.compose.runtime.CompositionLocalMap;
import androidx.compose.runtime.ProvidedValue;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.Updater;
import androidx.compose.runtime.internal.ComposableLambda;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import androidx.compose.ui.text.TextLayoutResult;
import androidx.compose.ui.text.TextStyle;
import androidx.compose.ui.text.font.FontFamily;
import androidx.compose.ui.text.font.FontStyle;
import androidx.compose.ui.text.font.FontWeight;
import androidx.compose.ui.text.style.TextAlign;
import androidx.compose.ui.text.style.TextDecoration;
import androidx.compose.ui.unit.Constraints;
import androidx.compose.ui.unit.Dp;
import java.util.List;
import java.util.NoSuchElementException;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.Intrinsics;
import kotlin.ranges.RangesKt;

@Metadata(d1 = {"\u0000D\n\u0000\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\t\u001ae\u0010\n\u001a\u00020\u000b2\u0011\u0010\f\u001a\r\u0012\u0004\u0012\u00020\u000b0\r¢\u0006\u0002\b\u000e2\u0011\u0010\u000f\u001a\r\u0012\u0004\u0012\u00020\u000b0\r¢\u0006\u0002\b\u000e2\u0013\u0010\u0010\u001a\u000f\u0012\u0004\u0012\u00020\u000b\u0018\u00010\r¢\u0006\u0002\b\u000e2\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u00142\u0006\u0010\u0015\u001a\u00020\u0014H\u0003ø\u0001\u0000¢\u0006\u0004\b\u0016\u0010\u0017\u001ag\u0010\u0018\u001a\u00020\u000b2\u0011\u0010\f\u001a\r\u0012\u0004\u0012\u00020\u000b0\r¢\u0006\u0002\b\u000e2\u0013\u0010\u000f\u001a\u000f\u0012\u0004\u0012\u00020\u000b\u0018\u00010\r¢\u0006\u0002\b\u000e2\u0013\u0010\u0010\u001a\u000f\u0012\u0004\u0012\u00020\u000b\u0018\u00010\r¢\u0006\u0002\b\u000e2\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0019\u001a\u00020\u00142\u0006\u0010\u001a\u001a\u00020\u0014H\u0003ø\u0001\u0000¢\u0006\u0004\b\u001b\u0010\u0017\u001aj\u0010\u001c\u001a\u00020\u000b2\u0006\u0010\u001d\u001a\u00020\u001e2\b\b\u0002\u0010\u001f\u001a\u00020 2\b\b\u0002\u0010!\u001a\u00020\"2\b\b\u0002\u0010#\u001a\u00020$2\b\b\u0002\u0010%\u001a\u00020\u00142\b\b\u0002\u0010&\u001a\u00020\u00142\b\b\u0002\u0010'\u001a\u00020\u00142\b\b\u0002\u0010\u0013\u001a\u00020\u00142\b\b\u0002\u0010\u0015\u001a\u00020\u0014H\u0007ø\u0001\u0000¢\u0006\u0004\b(\u0010)\u001a\u0099\u0001\u0010\u001c\u001a\u00020\u000b2\b\b\u0002\u0010\u001f\u001a\u00020 2\u0015\b\u0002\u0010\u000f\u001a\u000f\u0012\u0004\u0012\u00020\u000b\u0018\u00010\r¢\u0006\u0002\b\u000e2\u0015\b\u0002\u0010\u0010\u001a\u000f\u0012\u0004\u0012\u00020\u000b\u0018\u00010\r¢\u0006\u0002\b\u000e2\b\b\u0002\u0010!\u001a\u00020\"2\b\b\u0002\u0010#\u001a\u00020$2\b\b\u0002\u0010%\u001a\u00020\u00142\b\b\u0002\u0010&\u001a\u00020\u00142\b\b\u0002\u0010\u0013\u001a\u00020\u00142\b\b\u0002\u0010\u0015\u001a\u00020\u00142\u0011\u0010*\u001a\r\u0012\u0004\u0012\u00020\u000b0\r¢\u0006\u0002\b\u000eH\u0007ø\u0001\u0000¢\u0006\u0004\b+\u0010,\"\u0010\u0010\u0000\u001a\u00020\u0001X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0002\"\u0010\u0010\u0003\u001a\u00020\u0001X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0002\"\u0010\u0010\u0004\u001a\u00020\u0001X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0002\"\u0010\u0010\u0005\u001a\u00020\u0001X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0002\"\u0010\u0010\u0006\u001a\u00020\u0001X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0002\"\u0010\u0010\u0007\u001a\u00020\u0001X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0002\"\u0010\u0010\b\u001a\u00020\u0001X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0002\"\u0010\u0010\t\u001a\u00020\u0001X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0002\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006-"}, d2 = {"ContainerMaxWidth", "Landroidx/compose/ui/unit/Dp;", "F", "HeightToFirstLine", "HorizontalSpacing", "HorizontalSpacingButtonSide", "LongButtonVerticalOffset", "SeparateButtonExtraY", "SnackbarVerticalPadding", "TextEndExtraSpacing", "NewLineButtonSnackbar", "", "text", "Lkotlin/Function0;", "Landroidx/compose/runtime/Composable;", "action", "dismissAction", "actionTextStyle", "Landroidx/compose/ui/text/TextStyle;", "actionContentColor", "Landroidx/compose/ui/graphics/Color;", "dismissActionContentColor", "NewLineButtonSnackbar-kKq0p4A", "(Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function2;Landroidx/compose/ui/text/TextStyle;JJLandroidx/compose/runtime/Composer;I)V", "OneRowSnackbar", "actionTextColor", "dismissActionColor", "OneRowSnackbar-kKq0p4A", "Snackbar", "snackbarData", "Landroidx/compose/material3/SnackbarData;", "modifier", "Landroidx/compose/ui/Modifier;", "actionOnNewLine", "", "shape", "Landroidx/compose/ui/graphics/Shape;", "containerColor", "contentColor", "actionColor", "Snackbar-sDKtq54", "(Landroidx/compose/material3/SnackbarData;Landroidx/compose/ui/Modifier;ZLandroidx/compose/ui/graphics/Shape;JJJJJLandroidx/compose/runtime/Composer;II)V", "content", "Snackbar-eQBnUkQ", "(Landroidx/compose/ui/Modifier;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function2;ZLandroidx/compose/ui/graphics/Shape;JJJJLkotlin/jvm/functions/Function2;Landroidx/compose/runtime/Composer;II)V", "material3_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class SnackbarKt {
    private static final float HorizontalSpacingButtonSide;
    private static final float TextEndExtraSpacing;
    private static final float ContainerMaxWidth = Dp.constructor-impl(600);
    private static final float HeightToFirstLine = Dp.constructor-impl(30);
    private static final float HorizontalSpacing = Dp.constructor-impl(16);
    private static final float SeparateButtonExtraY = Dp.constructor-impl(2);
    private static final float SnackbarVerticalPadding = Dp.constructor-impl(6);
    private static final float LongButtonVerticalOffset = Dp.constructor-impl(12);

    public static final void m2851SnackbareQBnUkQ(Modifier modifier, Function2<? super Composer, ? super Integer, Unit> function2, Function2<? super Composer, ? super Integer, Unit> function3, boolean z, Shape shape, long j, long j2, long j3, long j4, final Function2<? super Composer, ? super Integer, Unit> function4, Composer composer, final int i, final int i2) {
        int i3;
        Function2<? super Composer, ? super Integer, Unit> function5;
        int i4;
        Function2<? super Composer, ? super Integer, Unit> function6;
        int i5;
        int i6;
        int i7;
        long color;
        long dismissActionContentColor;
        int i8;
        Modifier.Companion companion;
        Function2<? super Composer, ? super Integer, Unit> function7;
        boolean z2;
        Shape shape2;
        long contentColor;
        long actionContentColor;
        final Function2<? super Composer, ? super Integer, Unit> function8;
        Modifier modifier2;
        final Shape shape3;
        final boolean z3;
        final long j5;
        long j6;
        final long j7;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i9;
        int i10;
        int i11;
        Composer composerStartRestartGroup = composer.startRestartGroup(-1235788955);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(Snackbar)P(8!1,6,2,9,3:c#ui.graphics.Color,5:c#ui.graphics.Color,1:c#ui.graphics.Color,7:c#ui.graphics.Color)107@5066L5,108@5118L5,109@5168L12,110@5231L18,111@5307L25,120@5574L1123,114@5378L1319:Snackbar.kt#uh7d8r");
        int i12 = i2 & 1;
        if (i12 != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changed(modifier) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i13 = i2 & 2;
        if (i13 == 0) {
            if ((i & 48) == 0) {
                function5 = function2;
                i3 |= composerStartRestartGroup.changedInstance(function5) ? 32 : 16;
            }
            i4 = i2 & 4;
            if (i4 != 0) {
                if ((i & 384) == 0) {
                    function6 = function3;
                    if (composerStartRestartGroup.changedInstance(function6)) {
                        i5 = Fields.RotationX;
                    } else {
                        i5 = Fields.SpotShadowColor;
                    }
                    i3 |= i5;
                }
                i6 = i2 & 8;
                if (i6 != 0) {
                    if ((i & 3072) == 0) {
                        if (composerStartRestartGroup.changed(z)) {
                            i7 = Fields.CameraDistance;
                        } else {
                            i7 = Fields.RotationZ;
                        }
                        i3 |= i7;
                    }
                    if ((i & 24576) != 0) {
                        i3 |= ((i2 & 16) == 0 || !composerStartRestartGroup.changed(shape)) ? Fields.Shape : Fields.Clip;
                    }
                    if ((196608 & i) == 0) {
                        if ((i2 & 32) == 0) {
                            color = j;
                            int i14 = composerStartRestartGroup.changed(color) ? Fields.RenderEffect : 65536;
                            i3 |= i14;
                        } else {
                            color = j;
                        }
                        i3 |= i14;
                    } else {
                        color = j;
                    }
                    if ((i & 1572864) != 0) {
                        if ((i2 & 64) == 0 || !composerStartRestartGroup.changed(j2)) {
                            i11 = 524288;
                        } else {
                            i11 = 1048576;
                        }
                        i3 |= i11;
                    }
                    if ((i & 12582912) != 0) {
                        if ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(j3)) {
                            i10 = 4194304;
                        } else {
                            i10 = 8388608;
                        }
                        i3 |= i10;
                    }
                    if ((100663296 & i) == 0) {
                        dismissActionContentColor = j4;
                        if ((i2 & Fields.RotationX) == 0 || !composerStartRestartGroup.changed(dismissActionContentColor)) {
                            i9 = 33554432;
                        } else {
                            i9 = 67108864;
                        }
                        i3 |= i9;
                    } else {
                        dismissActionContentColor = j4;
                    }
                    if ((i2 & Fields.RotationY) != 0) {
                        if ((i & 805306368) == 0) {
                            if (composerStartRestartGroup.changedInstance(function4)) {
                                i8 = 536870912;
                            } else {
                                i8 = 268435456;
                            }
                            i3 |= i8;
                        }
                        if ((i3 & 306783379) == 306783378 || !composerStartRestartGroup.getSkipping()) {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                                if (i12 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i13 != 0) {
                                    function5 = null;
                                }
                                function7 = i4 == 0 ? function6 : null;
                                if (i6 != 0) {
                                    z2 = false;
                                } else {
                                    z2 = z;
                                }
                                if ((i2 & 16) != 0) {
                                    shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                                    i3 &= -57345;
                                } else {
                                    shape2 = shape;
                                }
                                if ((i2 & 32) != 0) {
                                    color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                                    i3 &= -458753;
                                }
                                if ((i2 & 64) != 0) {
                                    contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                                    i3 &= -3670017;
                                } else {
                                    contentColor = j2;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    actionContentColor = j3;
                                }
                                if ((i2 & Fields.RotationX) != 0) {
                                    i3 &= -234881025;
                                    dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                                }
                            } else {
                                composerStartRestartGroup.skipToGroupEnd();
                                if ((i2 & 16) != 0) {
                                    i3 &= -57345;
                                }
                                if ((i2 & 32) != 0) {
                                    i3 &= -458753;
                                }
                                if ((i2 & 64) != 0) {
                                    i3 &= -3670017;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    i3 &= -29360129;
                                }
                                if ((i2 & Fields.RotationX) != 0) {
                                    i3 &= -234881025;
                                }
                                companion = modifier;
                                z2 = z;
                                shape2 = shape;
                                contentColor = j2;
                                actionContentColor = j3;
                                function7 = function6;
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1235788955, i3, -1, "androidx.compose.material3.Snackbar (Snackbar.kt:113)");
                            }
                            final boolean z4 = z2;
                            final Function2<? super Composer, ? super Integer, Unit> function9 = function5;
                            final Function2<? super Composer, ? super Integer, Unit> function10 = function7;
                            final long j8 = actionContentColor;
                            final long j9 = dismissActionContentColor;
                            Function2<? super Composer, ? super Integer, Unit> function11 = function7;
                            boolean z5 = z2;
                            int i15 = (i3 & 14) | 12779520;
                            int i16 = i3 >> 9;
                            SurfaceKt.m2868SurfaceT9BRK9s(companion, shape2, color, contentColor, 0.0f, SnackbarTokens.INSTANCE.m3866getContainerElevationD9Ej5fM(), null, ComposableLambdaKt.rememberComposableLambda(-1829663446, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i17) {
                                    ComposerKt.sourceInformation(composer2, "C121@5634L5,122@5705L5,123@5779L912,123@5719L972:Snackbar.kt#uh7d8r");
                                    if ((i17 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1829663446, i17, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:121)");
                                        }
                                        TextStyle value = TypographyKt.getValue(SnackbarTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                                        final TextStyle value2 = TypographyKt.getValue(SnackbarTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                                        ProvidedValue<TextStyle> providedValueProvides = TextKt.getLocalTextStyle().provides(value);
                                        final boolean z6 = z4;
                                        final Function2<Composer, Integer, Unit> function12 = function9;
                                        final Function2<Composer, Integer, Unit> function13 = function4;
                                        final Function2<Composer, Integer, Unit> function14 = function10;
                                        final long j10 = j8;
                                        final long j11 = j9;
                                        CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>) providedValueProvides, (Function2<? super Composer, ? super Integer, Unit>) ComposableLambdaKt.rememberComposableLambda(835891690, true, new Function2<Composer, Integer, Unit>() {
                                            {
                                                super(2);
                                            }

                                            public Object invoke(Object obj, Object obj2) {
                                                invoke((Composer) obj, ((Number) obj2).intValue());
                                                return Unit.INSTANCE;
                                            }

                                            public final void invoke(Composer composer3, int i18) {
                                                ComposerKt.sourceInformation(composer3, "C:Snackbar.kt#uh7d8r");
                                                if ((i18 & 3) != 2 || !composer3.getSkipping()) {
                                                    if (ComposerKt.isTraceInProgress()) {
                                                        ComposerKt.traceEventStart(835891690, i18, -1, "androidx.compose.material3.Snackbar.<anonymous>.<anonymous> (Snackbar.kt:124)");
                                                    }
                                                    if (z6 && function12 != null) {
                                                        composer3.startReplaceGroup(-810715387);
                                                        ComposerKt.sourceInformation(composer3, "126@5873L383");
                                                        SnackbarKt.m2849NewLineButtonSnackbarkKq0p4A(function13, function12, function14, value2, j10, j11, composer3, 0);
                                                        composer3.endReplaceGroup();
                                                    } else {
                                                        composer3.startReplaceGroup(-810701708);
                                                        ComposerKt.sourceInformation(composer3, "135@6301L366");
                                                        SnackbarKt.m2850OneRowSnackbarkKq0p4A(function13, function12, function14, value2, j10, j11, composer3, 0);
                                                        composer3.endReplaceGroup();
                                                    }
                                                    if (ComposerKt.isTraceInProgress()) {
                                                        ComposerKt.traceEventEnd();
                                                        return;
                                                    }
                                                    return;
                                                }
                                                composer3.skipToGroupEnd();
                                            }
                                        }, composer2, 54), composer2, ProvidedValue.$stable | 48);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i16 & 7168) | i15 | (i16 & 112) | (i16 & 896), 80);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            function8 = function11;
                            modifier2 = companion;
                            shape3 = shape2;
                            z3 = z5;
                            j5 = contentColor;
                            j6 = dismissActionContentColor;
                            j7 = actionContentColor;
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            modifier2 = modifier;
                            z3 = z;
                            shape3 = shape;
                            function8 = function6;
                            j6 = dismissActionContentColor;
                            j5 = j2;
                            j7 = j3;
                        }
                        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                        if (scopeUpdateScopeEndRestartGroup != null) {
                            final Modifier modifier3 = modifier2;
                            final Function2<? super Composer, ? super Integer, Unit> function12 = function5;
                            final long j10 = color;
                            final long j11 = j6;
                            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i17) {
                                    SnackbarKt.m2851SnackbareQBnUkQ(modifier3, function12, function8, z3, shape3, j10, j5, j7, j11, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                                }
                            });
                        }
                    }
                    i3 |= 805306368;
                    if ((i3 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i12 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i13 != 0) {
                                function5 = null;
                            }
                            if (i4 == 0) {
                            }
                            if (i6 != 0) {
                                z2 = false;
                            } else {
                                z2 = z;
                            }
                            if ((i2 & 16) != 0) {
                                shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                                i3 &= -57345;
                            } else {
                                shape2 = shape;
                            }
                            if ((i2 & 32) != 0) {
                                color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                                i3 &= -458753;
                            }
                            if ((i2 & 64) != 0) {
                                contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                contentColor = j2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                actionContentColor = j3;
                            }
                            if ((i2 & Fields.RotationX) != 0) {
                                i3 &= -234881025;
                                dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                            }
                        } else {
                            if (i12 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i13 != 0) {
                                function5 = null;
                            }
                            if (i4 == 0) {
                            }
                            if (i6 != 0) {
                                z2 = false;
                            } else {
                                z2 = z;
                            }
                            if ((i2 & 16) != 0) {
                                shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                                i3 &= -57345;
                            } else {
                                shape2 = shape;
                            }
                            if ((i2 & 32) != 0) {
                                color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                                i3 &= -458753;
                            }
                            if ((i2 & 64) != 0) {
                                contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                contentColor = j2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                actionContentColor = j3;
                            }
                            if ((i2 & Fields.RotationX) != 0) {
                                i3 &= -234881025;
                                dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1235788955, i3, -1, "androidx.compose.material3.Snackbar (Snackbar.kt:113)");
                        }
                        final boolean z6 = z2;
                        final Function2<? super Composer, ? super Integer, Unit> function13 = function5;
                        final Function2<? super Composer, ? super Integer, Unit> function14 = function7;
                        final long j12 = actionContentColor;
                        final long j13 = dismissActionContentColor;
                        Function2<? super Composer, ? super Integer, Unit> function15 = function7;
                        boolean z7 = z2;
                        int i17 = (i3 & 14) | 12779520;
                        int i18 = i3 >> 9;
                        SurfaceKt.m2868SurfaceT9BRK9s(companion, shape2, color, contentColor, 0.0f, SnackbarTokens.INSTANCE.m3866getContainerElevationD9Ej5fM(), null, ComposableLambdaKt.rememberComposableLambda(-1829663446, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i19) {
                                ComposerKt.sourceInformation(composer2, "C121@5634L5,122@5705L5,123@5779L912,123@5719L972:Snackbar.kt#uh7d8r");
                                if ((i19 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1829663446, i19, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:121)");
                                    }
                                    TextStyle value = TypographyKt.getValue(SnackbarTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                                    final TextStyle value2 = TypographyKt.getValue(SnackbarTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                                    ProvidedValue<TextStyle> providedValueProvides = TextKt.getLocalTextStyle().provides(value);
                                    final boolean z8 = z6;
                                    final Function2<? super Composer, ? super Integer, Unit> function16 = function13;
                                    final Function2<? super Composer, ? super Integer, Unit> function17 = function4;
                                    final Function2<? super Composer, ? super Integer, Unit> function18 = function14;
                                    final long j14 = j12;
                                    final long j15 = j13;
                                    CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>) providedValueProvides, (Function2<? super Composer, ? super Integer, Unit>) ComposableLambdaKt.rememberComposableLambda(835891690, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer3, int i110) {
                                            ComposerKt.sourceInformation(composer3, "C:Snackbar.kt#uh7d8r");
                                            if ((i110 & 3) != 2 || !composer3.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(835891690, i110, -1, "androidx.compose.material3.Snackbar.<anonymous>.<anonymous> (Snackbar.kt:124)");
                                                }
                                                if (z8 && function16 != null) {
                                                    composer3.startReplaceGroup(-810715387);
                                                    ComposerKt.sourceInformation(composer3, "126@5873L383");
                                                    SnackbarKt.m2849NewLineButtonSnackbarkKq0p4A(function17, function16, function18, value2, j14, j15, composer3, 0);
                                                    composer3.endReplaceGroup();
                                                } else {
                                                    composer3.startReplaceGroup(-810701708);
                                                    ComposerKt.sourceInformation(composer3, "135@6301L366");
                                                    SnackbarKt.m2850OneRowSnackbarkKq0p4A(function17, function16, function18, value2, j14, j15, composer3, 0);
                                                    composer3.endReplaceGroup();
                                                }
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer3.skipToGroupEnd();
                                        }
                                    }, composer2, 54), composer2, ProvidedValue.$stable | 48);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i18 & 7168) | i17 | (i18 & 112) | (i18 & 896), 80);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        function8 = function15;
                        modifier2 = companion;
                        shape3 = shape2;
                        z3 = z7;
                        j5 = contentColor;
                        j6 = dismissActionContentColor;
                        j7 = actionContentColor;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i12 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i13 != 0) {
                                function5 = null;
                            }
                            if (i4 == 0) {
                            }
                            if (i6 != 0) {
                                z2 = false;
                            } else {
                                z2 = z;
                            }
                            if ((i2 & 16) != 0) {
                                shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                                i3 &= -57345;
                            } else {
                                shape2 = shape;
                            }
                            if ((i2 & 32) != 0) {
                                color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                                i3 &= -458753;
                            }
                            if ((i2 & 64) != 0) {
                                contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                contentColor = j2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                actionContentColor = j3;
                            }
                            if ((i2 & Fields.RotationX) != 0) {
                                i3 &= -234881025;
                                dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                            }
                        } else {
                            if (i12 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i13 != 0) {
                                function5 = null;
                            }
                            if (i4 == 0) {
                            }
                            if (i6 != 0) {
                                z2 = false;
                            } else {
                                z2 = z;
                            }
                            if ((i2 & 16) != 0) {
                                shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                                i3 &= -57345;
                            } else {
                                shape2 = shape;
                            }
                            if ((i2 & 32) != 0) {
                                color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                                i3 &= -458753;
                            }
                            if ((i2 & 64) != 0) {
                                contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                contentColor = j2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                actionContentColor = j3;
                            }
                            if ((i2 & Fields.RotationX) != 0) {
                                i3 &= -234881025;
                                dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1235788955, i3, -1, "androidx.compose.material3.Snackbar (Snackbar.kt:113)");
                        }
                        final boolean z8 = z2;
                        final Function2<? super Composer, ? super Integer, Unit> function16 = function5;
                        final Function2<? super Composer, ? super Integer, Unit> function17 = function7;
                        final long j14 = actionContentColor;
                        final long j15 = dismissActionContentColor;
                        Function2<? super Composer, ? super Integer, Unit> function18 = function7;
                        boolean z9 = z2;
                        int i19 = (i3 & 14) | 12779520;
                        int i110 = i3 >> 9;
                        SurfaceKt.m2868SurfaceT9BRK9s(companion, shape2, color, contentColor, 0.0f, SnackbarTokens.INSTANCE.m3866getContainerElevationD9Ej5fM(), null, ComposableLambdaKt.rememberComposableLambda(-1829663446, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i111) {
                                ComposerKt.sourceInformation(composer2, "C121@5634L5,122@5705L5,123@5779L912,123@5719L972:Snackbar.kt#uh7d8r");
                                if ((i111 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1829663446, i111, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:121)");
                                    }
                                    TextStyle value = TypographyKt.getValue(SnackbarTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                                    final TextStyle value2 = TypographyKt.getValue(SnackbarTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                                    ProvidedValue<TextStyle> providedValueProvides = TextKt.getLocalTextStyle().provides(value);
                                    final boolean z10 = z8;
                                    final Function2<? super Composer, ? super Integer, Unit> function19 = function16;
                                    final Function2<? super Composer, ? super Integer, Unit> function110 = function4;
                                    final Function2<? super Composer, ? super Integer, Unit> function111 = function17;
                                    final long j16 = j14;
                                    final long j17 = j15;
                                    CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>) providedValueProvides, (Function2<? super Composer, ? super Integer, Unit>) ComposableLambdaKt.rememberComposableLambda(835891690, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer3, int i112) {
                                            ComposerKt.sourceInformation(composer3, "C:Snackbar.kt#uh7d8r");
                                            if ((i112 & 3) != 2 || !composer3.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(835891690, i112, -1, "androidx.compose.material3.Snackbar.<anonymous>.<anonymous> (Snackbar.kt:124)");
                                                }
                                                if (z10 && function19 != null) {
                                                    composer3.startReplaceGroup(-810715387);
                                                    ComposerKt.sourceInformation(composer3, "126@5873L383");
                                                    SnackbarKt.m2849NewLineButtonSnackbarkKq0p4A(function110, function19, function111, value2, j16, j17, composer3, 0);
                                                    composer3.endReplaceGroup();
                                                } else {
                                                    composer3.startReplaceGroup(-810701708);
                                                    ComposerKt.sourceInformation(composer3, "135@6301L366");
                                                    SnackbarKt.m2850OneRowSnackbarkKq0p4A(function110, function19, function111, value2, j16, j17, composer3, 0);
                                                    composer3.endReplaceGroup();
                                                }
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer3.skipToGroupEnd();
                                        }
                                    }, composer2, 54), composer2, ProvidedValue.$stable | 48);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i110 & 7168) | i19 | (i110 & 112) | (i110 & 896), 80);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        function8 = function18;
                        modifier2 = companion;
                        shape3 = shape2;
                        z3 = z9;
                        j5 = contentColor;
                        j6 = dismissActionContentColor;
                        j7 = actionContentColor;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier4 = modifier2;
                        final Function2<? super Composer, ? super Integer, Unit> function19 = function5;
                        final long j16 = color;
                        final long j17 = j6;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i111) {
                                SnackbarKt.m2851SnackbareQBnUkQ(modifier4, function19, function8, z3, shape3, j16, j5, j7, j17, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 3072;
                if ((i & 24576) != 0) {
                    i3 |= ((i2 & 16) == 0 || !composerStartRestartGroup.changed(shape)) ? Fields.Shape : Fields.Clip;
                }
                if ((196608 & i) == 0) {
                    if ((i2 & 32) == 0) {
                        color = j;
                        if (composerStartRestartGroup.changed(color)) {
                        }
                        i3 |= i14;
                    } else {
                        color = j;
                    }
                    i3 |= i14;
                } else {
                    color = j;
                }
                if ((i & 1572864) != 0) {
                    if ((i2 & 64) == 0) {
                        i11 = 524288;
                    } else {
                        i11 = 524288;
                    }
                    i3 |= i11;
                }
                if ((i & 12582912) != 0) {
                    if ((i2 & Fields.SpotShadowColor) == 0) {
                        i10 = 4194304;
                    } else {
                        i10 = 4194304;
                    }
                    i3 |= i10;
                }
                if ((100663296 & i) == 0) {
                    dismissActionContentColor = j4;
                    if ((i2 & Fields.RotationX) == 0) {
                        i9 = 33554432;
                    } else {
                        i9 = 33554432;
                    }
                    i3 |= i9;
                } else {
                    dismissActionContentColor = j4;
                }
                if ((i2 & Fields.RotationY) != 0) {
                    if ((i & 805306368) == 0) {
                        if (composerStartRestartGroup.changedInstance(function4)) {
                            i8 = 536870912;
                        } else {
                            i8 = 268435456;
                        }
                        i3 |= i8;
                    }
                    if ((i3 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i12 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i13 != 0) {
                                function5 = null;
                            }
                            if (i4 == 0) {
                            }
                            if (i6 != 0) {
                                z2 = false;
                            } else {
                                z2 = z;
                            }
                            if ((i2 & 16) != 0) {
                                shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                                i3 &= -57345;
                            } else {
                                shape2 = shape;
                            }
                            if ((i2 & 32) != 0) {
                                color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                                i3 &= -458753;
                            }
                            if ((i2 & 64) != 0) {
                                contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                contentColor = j2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                actionContentColor = j3;
                            }
                            if ((i2 & Fields.RotationX) != 0) {
                                i3 &= -234881025;
                                dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                            }
                        } else {
                            if (i12 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i13 != 0) {
                                function5 = null;
                            }
                            if (i4 == 0) {
                            }
                            if (i6 != 0) {
                                z2 = false;
                            } else {
                                z2 = z;
                            }
                            if ((i2 & 16) != 0) {
                                shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                                i3 &= -57345;
                            } else {
                                shape2 = shape;
                            }
                            if ((i2 & 32) != 0) {
                                color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                                i3 &= -458753;
                            }
                            if ((i2 & 64) != 0) {
                                contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                contentColor = j2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                actionContentColor = j3;
                            }
                            if ((i2 & Fields.RotationX) != 0) {
                                i3 &= -234881025;
                                dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1235788955, i3, -1, "androidx.compose.material3.Snackbar (Snackbar.kt:113)");
                        }
                        final boolean z10 = z2;
                        final Function2<? super Composer, ? super Integer, Unit> function110 = function5;
                        final Function2<? super Composer, ? super Integer, Unit> function111 = function7;
                        final long j18 = actionContentColor;
                        final long j19 = dismissActionContentColor;
                        Function2<? super Composer, ? super Integer, Unit> function112 = function7;
                        boolean z11 = z2;
                        int i111 = (i3 & 14) | 12779520;
                        int i112 = i3 >> 9;
                        SurfaceKt.m2868SurfaceT9BRK9s(companion, shape2, color, contentColor, 0.0f, SnackbarTokens.INSTANCE.m3866getContainerElevationD9Ej5fM(), null, ComposableLambdaKt.rememberComposableLambda(-1829663446, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i113) {
                                ComposerKt.sourceInformation(composer2, "C121@5634L5,122@5705L5,123@5779L912,123@5719L972:Snackbar.kt#uh7d8r");
                                if ((i113 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1829663446, i113, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:121)");
                                    }
                                    TextStyle value = TypographyKt.getValue(SnackbarTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                                    final TextStyle value2 = TypographyKt.getValue(SnackbarTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                                    ProvidedValue<TextStyle> providedValueProvides = TextKt.getLocalTextStyle().provides(value);
                                    final boolean z12 = z10;
                                    final Function2<? super Composer, ? super Integer, Unit> function113 = function110;
                                    final Function2<? super Composer, ? super Integer, Unit> function114 = function4;
                                    final Function2<? super Composer, ? super Integer, Unit> function115 = function111;
                                    final long j110 = j18;
                                    final long j111 = j19;
                                    CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>) providedValueProvides, (Function2<? super Composer, ? super Integer, Unit>) ComposableLambdaKt.rememberComposableLambda(835891690, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer3, int i114) {
                                            ComposerKt.sourceInformation(composer3, "C:Snackbar.kt#uh7d8r");
                                            if ((i114 & 3) != 2 || !composer3.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(835891690, i114, -1, "androidx.compose.material3.Snackbar.<anonymous>.<anonymous> (Snackbar.kt:124)");
                                                }
                                                if (z12 && function113 != null) {
                                                    composer3.startReplaceGroup(-810715387);
                                                    ComposerKt.sourceInformation(composer3, "126@5873L383");
                                                    SnackbarKt.m2849NewLineButtonSnackbarkKq0p4A(function114, function113, function115, value2, j110, j111, composer3, 0);
                                                    composer3.endReplaceGroup();
                                                } else {
                                                    composer3.startReplaceGroup(-810701708);
                                                    ComposerKt.sourceInformation(composer3, "135@6301L366");
                                                    SnackbarKt.m2850OneRowSnackbarkKq0p4A(function114, function113, function115, value2, j110, j111, composer3, 0);
                                                    composer3.endReplaceGroup();
                                                }
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer3.skipToGroupEnd();
                                        }
                                    }, composer2, 54), composer2, ProvidedValue.$stable | 48);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i112 & 7168) | i111 | (i112 & 112) | (i112 & 896), 80);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        function8 = function112;
                        modifier2 = companion;
                        shape3 = shape2;
                        z3 = z11;
                        j5 = contentColor;
                        j6 = dismissActionContentColor;
                        j7 = actionContentColor;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i12 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i13 != 0) {
                                function5 = null;
                            }
                            if (i4 == 0) {
                            }
                            if (i6 != 0) {
                                z2 = false;
                            } else {
                                z2 = z;
                            }
                            if ((i2 & 16) != 0) {
                                shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                                i3 &= -57345;
                            } else {
                                shape2 = shape;
                            }
                            if ((i2 & 32) != 0) {
                                color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                                i3 &= -458753;
                            }
                            if ((i2 & 64) != 0) {
                                contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                contentColor = j2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                actionContentColor = j3;
                            }
                            if ((i2 & Fields.RotationX) != 0) {
                                i3 &= -234881025;
                                dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                            }
                        } else {
                            if (i12 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i13 != 0) {
                                function5 = null;
                            }
                            if (i4 == 0) {
                            }
                            if (i6 != 0) {
                                z2 = false;
                            } else {
                                z2 = z;
                            }
                            if ((i2 & 16) != 0) {
                                shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                                i3 &= -57345;
                            } else {
                                shape2 = shape;
                            }
                            if ((i2 & 32) != 0) {
                                color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                                i3 &= -458753;
                            }
                            if ((i2 & 64) != 0) {
                                contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                contentColor = j2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                actionContentColor = j3;
                            }
                            if ((i2 & Fields.RotationX) != 0) {
                                i3 &= -234881025;
                                dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1235788955, i3, -1, "androidx.compose.material3.Snackbar (Snackbar.kt:113)");
                        }
                        final boolean z12 = z2;
                        final Function2<? super Composer, ? super Integer, Unit> function113 = function5;
                        final Function2<? super Composer, ? super Integer, Unit> function114 = function7;
                        final long j110 = actionContentColor;
                        final long j111 = dismissActionContentColor;
                        Function2<? super Composer, ? super Integer, Unit> function115 = function7;
                        boolean z13 = z2;
                        int i113 = (i3 & 14) | 12779520;
                        int i114 = i3 >> 9;
                        SurfaceKt.m2868SurfaceT9BRK9s(companion, shape2, color, contentColor, 0.0f, SnackbarTokens.INSTANCE.m3866getContainerElevationD9Ej5fM(), null, ComposableLambdaKt.rememberComposableLambda(-1829663446, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i115) {
                                ComposerKt.sourceInformation(composer2, "C121@5634L5,122@5705L5,123@5779L912,123@5719L972:Snackbar.kt#uh7d8r");
                                if ((i115 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1829663446, i115, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:121)");
                                    }
                                    TextStyle value = TypographyKt.getValue(SnackbarTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                                    final TextStyle value2 = TypographyKt.getValue(SnackbarTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                                    ProvidedValue<TextStyle> providedValueProvides = TextKt.getLocalTextStyle().provides(value);
                                    final boolean z14 = z12;
                                    final Function2<? super Composer, ? super Integer, Unit> function116 = function113;
                                    final Function2<? super Composer, ? super Integer, Unit> function117 = function4;
                                    final Function2<? super Composer, ? super Integer, Unit> function118 = function114;
                                    final long j112 = j110;
                                    final long j113 = j111;
                                    CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>) providedValueProvides, (Function2<? super Composer, ? super Integer, Unit>) ComposableLambdaKt.rememberComposableLambda(835891690, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer3, int i116) {
                                            ComposerKt.sourceInformation(composer3, "C:Snackbar.kt#uh7d8r");
                                            if ((i116 & 3) != 2 || !composer3.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(835891690, i116, -1, "androidx.compose.material3.Snackbar.<anonymous>.<anonymous> (Snackbar.kt:124)");
                                                }
                                                if (z14 && function116 != null) {
                                                    composer3.startReplaceGroup(-810715387);
                                                    ComposerKt.sourceInformation(composer3, "126@5873L383");
                                                    SnackbarKt.m2849NewLineButtonSnackbarkKq0p4A(function117, function116, function118, value2, j112, j113, composer3, 0);
                                                    composer3.endReplaceGroup();
                                                } else {
                                                    composer3.startReplaceGroup(-810701708);
                                                    ComposerKt.sourceInformation(composer3, "135@6301L366");
                                                    SnackbarKt.m2850OneRowSnackbarkKq0p4A(function117, function116, function118, value2, j112, j113, composer3, 0);
                                                    composer3.endReplaceGroup();
                                                }
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer3.skipToGroupEnd();
                                        }
                                    }, composer2, 54), composer2, ProvidedValue.$stable | 48);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i114 & 7168) | i113 | (i114 & 112) | (i114 & 896), 80);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        function8 = function115;
                        modifier2 = companion;
                        shape3 = shape2;
                        z3 = z13;
                        j5 = contentColor;
                        j6 = dismissActionContentColor;
                        j7 = actionContentColor;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier5 = modifier2;
                        final Function2<? super Composer, ? super Integer, Unit> function116 = function5;
                        final long j112 = color;
                        final long j113 = j6;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i115) {
                                SnackbarKt.m2851SnackbareQBnUkQ(modifier5, function116, function8, z3, shape3, j112, j5, j7, j113, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 805306368;
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i13 != 0) {
                            function5 = null;
                        }
                        if (i4 == 0) {
                        }
                        if (i6 != 0) {
                            z2 = false;
                        } else {
                            z2 = z;
                        }
                        if ((i2 & 16) != 0) {
                            shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i3 &= -57345;
                        } else {
                            shape2 = shape;
                        }
                        if ((i2 & 32) != 0) {
                            color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        }
                        if ((i2 & 64) != 0) {
                            contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            contentColor = j2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            actionContentColor = j3;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            i3 &= -234881025;
                            dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                        }
                    } else {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i13 != 0) {
                            function5 = null;
                        }
                        if (i4 == 0) {
                        }
                        if (i6 != 0) {
                            z2 = false;
                        } else {
                            z2 = z;
                        }
                        if ((i2 & 16) != 0) {
                            shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i3 &= -57345;
                        } else {
                            shape2 = shape;
                        }
                        if ((i2 & 32) != 0) {
                            color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        }
                        if ((i2 & 64) != 0) {
                            contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            contentColor = j2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            actionContentColor = j3;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            i3 &= -234881025;
                            dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1235788955, i3, -1, "androidx.compose.material3.Snackbar (Snackbar.kt:113)");
                    }
                    final boolean z14 = z2;
                    final Function2<? super Composer, ? super Integer, Unit> function117 = function5;
                    final Function2<? super Composer, ? super Integer, Unit> function118 = function7;
                    final long j114 = actionContentColor;
                    final long j115 = dismissActionContentColor;
                    Function2<? super Composer, ? super Integer, Unit> function119 = function7;
                    boolean z15 = z2;
                    int i115 = (i3 & 14) | 12779520;
                    int i116 = i3 >> 9;
                    SurfaceKt.m2868SurfaceT9BRK9s(companion, shape2, color, contentColor, 0.0f, SnackbarTokens.INSTANCE.m3866getContainerElevationD9Ej5fM(), null, ComposableLambdaKt.rememberComposableLambda(-1829663446, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i117) {
                            ComposerKt.sourceInformation(composer2, "C121@5634L5,122@5705L5,123@5779L912,123@5719L972:Snackbar.kt#uh7d8r");
                            if ((i117 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1829663446, i117, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:121)");
                                }
                                TextStyle value = TypographyKt.getValue(SnackbarTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                                final TextStyle value2 = TypographyKt.getValue(SnackbarTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                                ProvidedValue<TextStyle> providedValueProvides = TextKt.getLocalTextStyle().provides(value);
                                final boolean z16 = z14;
                                final Function2<? super Composer, ? super Integer, Unit> function1110 = function117;
                                final Function2<? super Composer, ? super Integer, Unit> function1111 = function4;
                                final Function2<? super Composer, ? super Integer, Unit> function1112 = function118;
                                final long j116 = j114;
                                final long j117 = j115;
                                CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>) providedValueProvides, (Function2<? super Composer, ? super Integer, Unit>) ComposableLambdaKt.rememberComposableLambda(835891690, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer3, int i118) {
                                        ComposerKt.sourceInformation(composer3, "C:Snackbar.kt#uh7d8r");
                                        if ((i118 & 3) != 2 || !composer3.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(835891690, i118, -1, "androidx.compose.material3.Snackbar.<anonymous>.<anonymous> (Snackbar.kt:124)");
                                            }
                                            if (z16 && function1110 != null) {
                                                composer3.startReplaceGroup(-810715387);
                                                ComposerKt.sourceInformation(composer3, "126@5873L383");
                                                SnackbarKt.m2849NewLineButtonSnackbarkKq0p4A(function1111, function1110, function1112, value2, j116, j117, composer3, 0);
                                                composer3.endReplaceGroup();
                                            } else {
                                                composer3.startReplaceGroup(-810701708);
                                                ComposerKt.sourceInformation(composer3, "135@6301L366");
                                                SnackbarKt.m2850OneRowSnackbarkKq0p4A(function1111, function1110, function1112, value2, j116, j117, composer3, 0);
                                                composer3.endReplaceGroup();
                                            }
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer3.skipToGroupEnd();
                                    }
                                }, composer2, 54), composer2, ProvidedValue.$stable | 48);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i116 & 7168) | i115 | (i116 & 112) | (i116 & 896), 80);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function8 = function119;
                    modifier2 = companion;
                    shape3 = shape2;
                    z3 = z15;
                    j5 = contentColor;
                    j6 = dismissActionContentColor;
                    j7 = actionContentColor;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i13 != 0) {
                            function5 = null;
                        }
                        if (i4 == 0) {
                        }
                        if (i6 != 0) {
                            z2 = false;
                        } else {
                            z2 = z;
                        }
                        if ((i2 & 16) != 0) {
                            shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i3 &= -57345;
                        } else {
                            shape2 = shape;
                        }
                        if ((i2 & 32) != 0) {
                            color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        }
                        if ((i2 & 64) != 0) {
                            contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            contentColor = j2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            actionContentColor = j3;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            i3 &= -234881025;
                            dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                        }
                    } else {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i13 != 0) {
                            function5 = null;
                        }
                        if (i4 == 0) {
                        }
                        if (i6 != 0) {
                            z2 = false;
                        } else {
                            z2 = z;
                        }
                        if ((i2 & 16) != 0) {
                            shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i3 &= -57345;
                        } else {
                            shape2 = shape;
                        }
                        if ((i2 & 32) != 0) {
                            color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        }
                        if ((i2 & 64) != 0) {
                            contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            contentColor = j2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            actionContentColor = j3;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            i3 &= -234881025;
                            dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1235788955, i3, -1, "androidx.compose.material3.Snackbar (Snackbar.kt:113)");
                    }
                    final boolean z16 = z2;
                    final Function2<? super Composer, ? super Integer, Unit> function1110 = function5;
                    final Function2<? super Composer, ? super Integer, Unit> function1111 = function7;
                    final long j116 = actionContentColor;
                    final long j117 = dismissActionContentColor;
                    Function2<? super Composer, ? super Integer, Unit> function1112 = function7;
                    boolean z17 = z2;
                    int i117 = (i3 & 14) | 12779520;
                    int i118 = i3 >> 9;
                    SurfaceKt.m2868SurfaceT9BRK9s(companion, shape2, color, contentColor, 0.0f, SnackbarTokens.INSTANCE.m3866getContainerElevationD9Ej5fM(), null, ComposableLambdaKt.rememberComposableLambda(-1829663446, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i119) {
                            ComposerKt.sourceInformation(composer2, "C121@5634L5,122@5705L5,123@5779L912,123@5719L972:Snackbar.kt#uh7d8r");
                            if ((i119 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1829663446, i119, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:121)");
                                }
                                TextStyle value = TypographyKt.getValue(SnackbarTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                                final TextStyle value2 = TypographyKt.getValue(SnackbarTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                                ProvidedValue<TextStyle> providedValueProvides = TextKt.getLocalTextStyle().provides(value);
                                final boolean z18 = z16;
                                final Function2<? super Composer, ? super Integer, Unit> function1113 = function1110;
                                final Function2<? super Composer, ? super Integer, Unit> function1114 = function4;
                                final Function2<? super Composer, ? super Integer, Unit> function1115 = function1111;
                                final long j118 = j116;
                                final long j119 = j117;
                                CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>) providedValueProvides, (Function2<? super Composer, ? super Integer, Unit>) ComposableLambdaKt.rememberComposableLambda(835891690, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer3, int i1110) {
                                        ComposerKt.sourceInformation(composer3, "C:Snackbar.kt#uh7d8r");
                                        if ((i1110 & 3) != 2 || !composer3.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(835891690, i1110, -1, "androidx.compose.material3.Snackbar.<anonymous>.<anonymous> (Snackbar.kt:124)");
                                            }
                                            if (z18 && function1113 != null) {
                                                composer3.startReplaceGroup(-810715387);
                                                ComposerKt.sourceInformation(composer3, "126@5873L383");
                                                SnackbarKt.m2849NewLineButtonSnackbarkKq0p4A(function1114, function1113, function1115, value2, j118, j119, composer3, 0);
                                                composer3.endReplaceGroup();
                                            } else {
                                                composer3.startReplaceGroup(-810701708);
                                                ComposerKt.sourceInformation(composer3, "135@6301L366");
                                                SnackbarKt.m2850OneRowSnackbarkKq0p4A(function1114, function1113, function1115, value2, j118, j119, composer3, 0);
                                                composer3.endReplaceGroup();
                                            }
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer3.skipToGroupEnd();
                                    }
                                }, composer2, 54), composer2, ProvidedValue.$stable | 48);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i118 & 7168) | i117 | (i118 & 112) | (i118 & 896), 80);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function8 = function1112;
                    modifier2 = companion;
                    shape3 = shape2;
                    z3 = z17;
                    j5 = contentColor;
                    j6 = dismissActionContentColor;
                    j7 = actionContentColor;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier6 = modifier2;
                    final Function2<? super Composer, ? super Integer, Unit> function1113 = function5;
                    final long j118 = color;
                    final long j119 = j6;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i119) {
                            SnackbarKt.m2851SnackbareQBnUkQ(modifier6, function1113, function8, z3, shape3, j118, j5, j7, j119, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 384;
            function6 = function3;
            i6 = i2 & 8;
            if (i6 != 0) {
                if ((i & 3072) == 0) {
                    if (composerStartRestartGroup.changed(z)) {
                        i7 = Fields.CameraDistance;
                    } else {
                        i7 = Fields.RotationZ;
                    }
                    i3 |= i7;
                }
                if ((i & 24576) != 0) {
                    i3 |= ((i2 & 16) == 0 || !composerStartRestartGroup.changed(shape)) ? Fields.Shape : Fields.Clip;
                }
                if ((196608 & i) == 0) {
                    if ((i2 & 32) == 0) {
                        color = j;
                        if (composerStartRestartGroup.changed(color)) {
                        }
                        i3 |= i14;
                    } else {
                        color = j;
                    }
                    i3 |= i14;
                } else {
                    color = j;
                }
                if ((i & 1572864) != 0) {
                    if ((i2 & 64) == 0) {
                        i11 = 524288;
                    } else {
                        i11 = 524288;
                    }
                    i3 |= i11;
                }
                if ((i & 12582912) != 0) {
                    if ((i2 & Fields.SpotShadowColor) == 0) {
                        i10 = 4194304;
                    } else {
                        i10 = 4194304;
                    }
                    i3 |= i10;
                }
                if ((100663296 & i) == 0) {
                    dismissActionContentColor = j4;
                    if ((i2 & Fields.RotationX) == 0) {
                        i9 = 33554432;
                    } else {
                        i9 = 33554432;
                    }
                    i3 |= i9;
                } else {
                    dismissActionContentColor = j4;
                }
                if ((i2 & Fields.RotationY) != 0) {
                    if ((i & 805306368) == 0) {
                        if (composerStartRestartGroup.changedInstance(function4)) {
                            i8 = 536870912;
                        } else {
                            i8 = 268435456;
                        }
                        i3 |= i8;
                    }
                    if ((i3 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i12 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i13 != 0) {
                                function5 = null;
                            }
                            if (i4 == 0) {
                            }
                            if (i6 != 0) {
                                z2 = false;
                            } else {
                                z2 = z;
                            }
                            if ((i2 & 16) != 0) {
                                shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                                i3 &= -57345;
                            } else {
                                shape2 = shape;
                            }
                            if ((i2 & 32) != 0) {
                                color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                                i3 &= -458753;
                            }
                            if ((i2 & 64) != 0) {
                                contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                contentColor = j2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                actionContentColor = j3;
                            }
                            if ((i2 & Fields.RotationX) != 0) {
                                i3 &= -234881025;
                                dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                            }
                        } else {
                            if (i12 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i13 != 0) {
                                function5 = null;
                            }
                            if (i4 == 0) {
                            }
                            if (i6 != 0) {
                                z2 = false;
                            } else {
                                z2 = z;
                            }
                            if ((i2 & 16) != 0) {
                                shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                                i3 &= -57345;
                            } else {
                                shape2 = shape;
                            }
                            if ((i2 & 32) != 0) {
                                color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                                i3 &= -458753;
                            }
                            if ((i2 & 64) != 0) {
                                contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                contentColor = j2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                actionContentColor = j3;
                            }
                            if ((i2 & Fields.RotationX) != 0) {
                                i3 &= -234881025;
                                dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1235788955, i3, -1, "androidx.compose.material3.Snackbar (Snackbar.kt:113)");
                        }
                        final boolean z18 = z2;
                        final Function2<? super Composer, ? super Integer, Unit> function1114 = function5;
                        final Function2<? super Composer, ? super Integer, Unit> function1115 = function7;
                        final long j1110 = actionContentColor;
                        final long j1111 = dismissActionContentColor;
                        Function2<? super Composer, ? super Integer, Unit> function1116 = function7;
                        boolean z19 = z2;
                        int i119 = (i3 & 14) | 12779520;
                        int i1110 = i3 >> 9;
                        SurfaceKt.m2868SurfaceT9BRK9s(companion, shape2, color, contentColor, 0.0f, SnackbarTokens.INSTANCE.m3866getContainerElevationD9Ej5fM(), null, ComposableLambdaKt.rememberComposableLambda(-1829663446, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i1111) {
                                ComposerKt.sourceInformation(composer2, "C121@5634L5,122@5705L5,123@5779L912,123@5719L972:Snackbar.kt#uh7d8r");
                                if ((i1111 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1829663446, i1111, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:121)");
                                    }
                                    TextStyle value = TypographyKt.getValue(SnackbarTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                                    final TextStyle value2 = TypographyKt.getValue(SnackbarTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                                    ProvidedValue<TextStyle> providedValueProvides = TextKt.getLocalTextStyle().provides(value);
                                    final boolean z110 = z18;
                                    final Function2<? super Composer, ? super Integer, Unit> function1117 = function1114;
                                    final Function2<? super Composer, ? super Integer, Unit> function1118 = function4;
                                    final Function2<? super Composer, ? super Integer, Unit> function1119 = function1115;
                                    final long j1112 = j1110;
                                    final long j1113 = j1111;
                                    CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>) providedValueProvides, (Function2<? super Composer, ? super Integer, Unit>) ComposableLambdaKt.rememberComposableLambda(835891690, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer3, int i1112) {
                                            ComposerKt.sourceInformation(composer3, "C:Snackbar.kt#uh7d8r");
                                            if ((i1112 & 3) != 2 || !composer3.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(835891690, i1112, -1, "androidx.compose.material3.Snackbar.<anonymous>.<anonymous> (Snackbar.kt:124)");
                                                }
                                                if (z110 && function1117 != null) {
                                                    composer3.startReplaceGroup(-810715387);
                                                    ComposerKt.sourceInformation(composer3, "126@5873L383");
                                                    SnackbarKt.m2849NewLineButtonSnackbarkKq0p4A(function1118, function1117, function1119, value2, j1112, j1113, composer3, 0);
                                                    composer3.endReplaceGroup();
                                                } else {
                                                    composer3.startReplaceGroup(-810701708);
                                                    ComposerKt.sourceInformation(composer3, "135@6301L366");
                                                    SnackbarKt.m2850OneRowSnackbarkKq0p4A(function1118, function1117, function1119, value2, j1112, j1113, composer3, 0);
                                                    composer3.endReplaceGroup();
                                                }
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer3.skipToGroupEnd();
                                        }
                                    }, composer2, 54), composer2, ProvidedValue.$stable | 48);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i1110 & 7168) | i119 | (i1110 & 112) | (i1110 & 896), 80);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        function8 = function1116;
                        modifier2 = companion;
                        shape3 = shape2;
                        z3 = z19;
                        j5 = contentColor;
                        j6 = dismissActionContentColor;
                        j7 = actionContentColor;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i12 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i13 != 0) {
                                function5 = null;
                            }
                            if (i4 == 0) {
                            }
                            if (i6 != 0) {
                                z2 = false;
                            } else {
                                z2 = z;
                            }
                            if ((i2 & 16) != 0) {
                                shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                                i3 &= -57345;
                            } else {
                                shape2 = shape;
                            }
                            if ((i2 & 32) != 0) {
                                color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                                i3 &= -458753;
                            }
                            if ((i2 & 64) != 0) {
                                contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                contentColor = j2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                actionContentColor = j3;
                            }
                            if ((i2 & Fields.RotationX) != 0) {
                                i3 &= -234881025;
                                dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                            }
                        } else {
                            if (i12 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i13 != 0) {
                                function5 = null;
                            }
                            if (i4 == 0) {
                            }
                            if (i6 != 0) {
                                z2 = false;
                            } else {
                                z2 = z;
                            }
                            if ((i2 & 16) != 0) {
                                shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                                i3 &= -57345;
                            } else {
                                shape2 = shape;
                            }
                            if ((i2 & 32) != 0) {
                                color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                                i3 &= -458753;
                            }
                            if ((i2 & 64) != 0) {
                                contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                contentColor = j2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                actionContentColor = j3;
                            }
                            if ((i2 & Fields.RotationX) != 0) {
                                i3 &= -234881025;
                                dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1235788955, i3, -1, "androidx.compose.material3.Snackbar (Snackbar.kt:113)");
                        }
                        final boolean z110 = z2;
                        final Function2<? super Composer, ? super Integer, Unit> function1117 = function5;
                        final Function2<? super Composer, ? super Integer, Unit> function1118 = function7;
                        final long j1112 = actionContentColor;
                        final long j1113 = dismissActionContentColor;
                        Function2<? super Composer, ? super Integer, Unit> function1119 = function7;
                        boolean z111 = z2;
                        int i1111 = (i3 & 14) | 12779520;
                        int i1112 = i3 >> 9;
                        SurfaceKt.m2868SurfaceT9BRK9s(companion, shape2, color, contentColor, 0.0f, SnackbarTokens.INSTANCE.m3866getContainerElevationD9Ej5fM(), null, ComposableLambdaKt.rememberComposableLambda(-1829663446, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i1113) {
                                ComposerKt.sourceInformation(composer2, "C121@5634L5,122@5705L5,123@5779L912,123@5719L972:Snackbar.kt#uh7d8r");
                                if ((i1113 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1829663446, i1113, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:121)");
                                    }
                                    TextStyle value = TypographyKt.getValue(SnackbarTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                                    final TextStyle value2 = TypographyKt.getValue(SnackbarTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                                    ProvidedValue<TextStyle> providedValueProvides = TextKt.getLocalTextStyle().provides(value);
                                    final boolean z112 = z110;
                                    final Function2<? super Composer, ? super Integer, Unit> function11110 = function1117;
                                    final Function2<? super Composer, ? super Integer, Unit> function11111 = function4;
                                    final Function2<? super Composer, ? super Integer, Unit> function11112 = function1118;
                                    final long j1114 = j1112;
                                    final long j1115 = j1113;
                                    CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>) providedValueProvides, (Function2<? super Composer, ? super Integer, Unit>) ComposableLambdaKt.rememberComposableLambda(835891690, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer3, int i1114) {
                                            ComposerKt.sourceInformation(composer3, "C:Snackbar.kt#uh7d8r");
                                            if ((i1114 & 3) != 2 || !composer3.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(835891690, i1114, -1, "androidx.compose.material3.Snackbar.<anonymous>.<anonymous> (Snackbar.kt:124)");
                                                }
                                                if (z112 && function11110 != null) {
                                                    composer3.startReplaceGroup(-810715387);
                                                    ComposerKt.sourceInformation(composer3, "126@5873L383");
                                                    SnackbarKt.m2849NewLineButtonSnackbarkKq0p4A(function11111, function11110, function11112, value2, j1114, j1115, composer3, 0);
                                                    composer3.endReplaceGroup();
                                                } else {
                                                    composer3.startReplaceGroup(-810701708);
                                                    ComposerKt.sourceInformation(composer3, "135@6301L366");
                                                    SnackbarKt.m2850OneRowSnackbarkKq0p4A(function11111, function11110, function11112, value2, j1114, j1115, composer3, 0);
                                                    composer3.endReplaceGroup();
                                                }
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer3.skipToGroupEnd();
                                        }
                                    }, composer2, 54), composer2, ProvidedValue.$stable | 48);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i1112 & 7168) | i1111 | (i1112 & 112) | (i1112 & 896), 80);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        function8 = function1119;
                        modifier2 = companion;
                        shape3 = shape2;
                        z3 = z111;
                        j5 = contentColor;
                        j6 = dismissActionContentColor;
                        j7 = actionContentColor;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier7 = modifier2;
                        final Function2<? super Composer, ? super Integer, Unit> function11110 = function5;
                        final long j1114 = color;
                        final long j1115 = j6;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i1113) {
                                SnackbarKt.m2851SnackbareQBnUkQ(modifier7, function11110, function8, z3, shape3, j1114, j5, j7, j1115, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 805306368;
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i13 != 0) {
                            function5 = null;
                        }
                        if (i4 == 0) {
                        }
                        if (i6 != 0) {
                            z2 = false;
                        } else {
                            z2 = z;
                        }
                        if ((i2 & 16) != 0) {
                            shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i3 &= -57345;
                        } else {
                            shape2 = shape;
                        }
                        if ((i2 & 32) != 0) {
                            color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        }
                        if ((i2 & 64) != 0) {
                            contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            contentColor = j2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            actionContentColor = j3;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            i3 &= -234881025;
                            dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                        }
                    } else {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i13 != 0) {
                            function5 = null;
                        }
                        if (i4 == 0) {
                        }
                        if (i6 != 0) {
                            z2 = false;
                        } else {
                            z2 = z;
                        }
                        if ((i2 & 16) != 0) {
                            shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i3 &= -57345;
                        } else {
                            shape2 = shape;
                        }
                        if ((i2 & 32) != 0) {
                            color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        }
                        if ((i2 & 64) != 0) {
                            contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            contentColor = j2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            actionContentColor = j3;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            i3 &= -234881025;
                            dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1235788955, i3, -1, "androidx.compose.material3.Snackbar (Snackbar.kt:113)");
                    }
                    final boolean z112 = z2;
                    final Function2<? super Composer, ? super Integer, Unit> function11111 = function5;
                    final Function2<? super Composer, ? super Integer, Unit> function11112 = function7;
                    final long j1116 = actionContentColor;
                    final long j1117 = dismissActionContentColor;
                    Function2<? super Composer, ? super Integer, Unit> function11113 = function7;
                    boolean z113 = z2;
                    int i1113 = (i3 & 14) | 12779520;
                    int i1114 = i3 >> 9;
                    SurfaceKt.m2868SurfaceT9BRK9s(companion, shape2, color, contentColor, 0.0f, SnackbarTokens.INSTANCE.m3866getContainerElevationD9Ej5fM(), null, ComposableLambdaKt.rememberComposableLambda(-1829663446, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1115) {
                            ComposerKt.sourceInformation(composer2, "C121@5634L5,122@5705L5,123@5779L912,123@5719L972:Snackbar.kt#uh7d8r");
                            if ((i1115 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1829663446, i1115, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:121)");
                                }
                                TextStyle value = TypographyKt.getValue(SnackbarTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                                final TextStyle value2 = TypographyKt.getValue(SnackbarTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                                ProvidedValue<TextStyle> providedValueProvides = TextKt.getLocalTextStyle().provides(value);
                                final boolean z114 = z112;
                                final Function2<? super Composer, ? super Integer, Unit> function11114 = function11111;
                                final Function2<? super Composer, ? super Integer, Unit> function11115 = function4;
                                final Function2<? super Composer, ? super Integer, Unit> function11116 = function11112;
                                final long j1118 = j1116;
                                final long j1119 = j1117;
                                CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>) providedValueProvides, (Function2<? super Composer, ? super Integer, Unit>) ComposableLambdaKt.rememberComposableLambda(835891690, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer3, int i1116) {
                                        ComposerKt.sourceInformation(composer3, "C:Snackbar.kt#uh7d8r");
                                        if ((i1116 & 3) != 2 || !composer3.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(835891690, i1116, -1, "androidx.compose.material3.Snackbar.<anonymous>.<anonymous> (Snackbar.kt:124)");
                                            }
                                            if (z114 && function11114 != null) {
                                                composer3.startReplaceGroup(-810715387);
                                                ComposerKt.sourceInformation(composer3, "126@5873L383");
                                                SnackbarKt.m2849NewLineButtonSnackbarkKq0p4A(function11115, function11114, function11116, value2, j1118, j1119, composer3, 0);
                                                composer3.endReplaceGroup();
                                            } else {
                                                composer3.startReplaceGroup(-810701708);
                                                ComposerKt.sourceInformation(composer3, "135@6301L366");
                                                SnackbarKt.m2850OneRowSnackbarkKq0p4A(function11115, function11114, function11116, value2, j1118, j1119, composer3, 0);
                                                composer3.endReplaceGroup();
                                            }
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer3.skipToGroupEnd();
                                    }
                                }, composer2, 54), composer2, ProvidedValue.$stable | 48);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i1114 & 7168) | i1113 | (i1114 & 112) | (i1114 & 896), 80);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function8 = function11113;
                    modifier2 = companion;
                    shape3 = shape2;
                    z3 = z113;
                    j5 = contentColor;
                    j6 = dismissActionContentColor;
                    j7 = actionContentColor;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i13 != 0) {
                            function5 = null;
                        }
                        if (i4 == 0) {
                        }
                        if (i6 != 0) {
                            z2 = false;
                        } else {
                            z2 = z;
                        }
                        if ((i2 & 16) != 0) {
                            shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i3 &= -57345;
                        } else {
                            shape2 = shape;
                        }
                        if ((i2 & 32) != 0) {
                            color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        }
                        if ((i2 & 64) != 0) {
                            contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            contentColor = j2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            actionContentColor = j3;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            i3 &= -234881025;
                            dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                        }
                    } else {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i13 != 0) {
                            function5 = null;
                        }
                        if (i4 == 0) {
                        }
                        if (i6 != 0) {
                            z2 = false;
                        } else {
                            z2 = z;
                        }
                        if ((i2 & 16) != 0) {
                            shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i3 &= -57345;
                        } else {
                            shape2 = shape;
                        }
                        if ((i2 & 32) != 0) {
                            color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        }
                        if ((i2 & 64) != 0) {
                            contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            contentColor = j2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            actionContentColor = j3;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            i3 &= -234881025;
                            dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1235788955, i3, -1, "androidx.compose.material3.Snackbar (Snackbar.kt:113)");
                    }
                    final boolean z114 = z2;
                    final Function2<? super Composer, ? super Integer, Unit> function11114 = function5;
                    final Function2<? super Composer, ? super Integer, Unit> function11115 = function7;
                    final long j1118 = actionContentColor;
                    final long j1119 = dismissActionContentColor;
                    Function2<? super Composer, ? super Integer, Unit> function11116 = function7;
                    boolean z115 = z2;
                    int i1115 = (i3 & 14) | 12779520;
                    int i1116 = i3 >> 9;
                    SurfaceKt.m2868SurfaceT9BRK9s(companion, shape2, color, contentColor, 0.0f, SnackbarTokens.INSTANCE.m3866getContainerElevationD9Ej5fM(), null, ComposableLambdaKt.rememberComposableLambda(-1829663446, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1117) {
                            ComposerKt.sourceInformation(composer2, "C121@5634L5,122@5705L5,123@5779L912,123@5719L972:Snackbar.kt#uh7d8r");
                            if ((i1117 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1829663446, i1117, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:121)");
                                }
                                TextStyle value = TypographyKt.getValue(SnackbarTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                                final TextStyle value2 = TypographyKt.getValue(SnackbarTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                                ProvidedValue<TextStyle> providedValueProvides = TextKt.getLocalTextStyle().provides(value);
                                final boolean z116 = z114;
                                final Function2<? super Composer, ? super Integer, Unit> function11117 = function11114;
                                final Function2<? super Composer, ? super Integer, Unit> function11118 = function4;
                                final Function2<? super Composer, ? super Integer, Unit> function11119 = function11115;
                                final long j11110 = j1118;
                                final long j11111 = j1119;
                                CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>) providedValueProvides, (Function2<? super Composer, ? super Integer, Unit>) ComposableLambdaKt.rememberComposableLambda(835891690, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer3, int i1118) {
                                        ComposerKt.sourceInformation(composer3, "C:Snackbar.kt#uh7d8r");
                                        if ((i1118 & 3) != 2 || !composer3.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(835891690, i1118, -1, "androidx.compose.material3.Snackbar.<anonymous>.<anonymous> (Snackbar.kt:124)");
                                            }
                                            if (z116 && function11117 != null) {
                                                composer3.startReplaceGroup(-810715387);
                                                ComposerKt.sourceInformation(composer3, "126@5873L383");
                                                SnackbarKt.m2849NewLineButtonSnackbarkKq0p4A(function11118, function11117, function11119, value2, j11110, j11111, composer3, 0);
                                                composer3.endReplaceGroup();
                                            } else {
                                                composer3.startReplaceGroup(-810701708);
                                                ComposerKt.sourceInformation(composer3, "135@6301L366");
                                                SnackbarKt.m2850OneRowSnackbarkKq0p4A(function11118, function11117, function11119, value2, j11110, j11111, composer3, 0);
                                                composer3.endReplaceGroup();
                                            }
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer3.skipToGroupEnd();
                                    }
                                }, composer2, 54), composer2, ProvidedValue.$stable | 48);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i1116 & 7168) | i1115 | (i1116 & 112) | (i1116 & 896), 80);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function8 = function11116;
                    modifier2 = companion;
                    shape3 = shape2;
                    z3 = z115;
                    j5 = contentColor;
                    j6 = dismissActionContentColor;
                    j7 = actionContentColor;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier8 = modifier2;
                    final Function2<? super Composer, ? super Integer, Unit> function11117 = function5;
                    final long j11110 = color;
                    final long j11111 = j6;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1117) {
                            SnackbarKt.m2851SnackbareQBnUkQ(modifier8, function11117, function8, z3, shape3, j11110, j5, j7, j11111, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            if ((i & 24576) != 0) {
                i3 |= ((i2 & 16) == 0 || !composerStartRestartGroup.changed(shape)) ? Fields.Shape : Fields.Clip;
            }
            if ((196608 & i) == 0) {
                if ((i2 & 32) == 0) {
                    color = j;
                    if (composerStartRestartGroup.changed(color)) {
                    }
                    i3 |= i14;
                } else {
                    color = j;
                }
                i3 |= i14;
            } else {
                color = j;
            }
            if ((i & 1572864) != 0) {
                if ((i2 & 64) == 0) {
                    i11 = 524288;
                } else {
                    i11 = 524288;
                }
                i3 |= i11;
            }
            if ((i & 12582912) != 0) {
                if ((i2 & Fields.SpotShadowColor) == 0) {
                    i10 = 4194304;
                } else {
                    i10 = 4194304;
                }
                i3 |= i10;
            }
            if ((100663296 & i) == 0) {
                dismissActionContentColor = j4;
                if ((i2 & Fields.RotationX) == 0) {
                    i9 = 33554432;
                } else {
                    i9 = 33554432;
                }
                i3 |= i9;
            } else {
                dismissActionContentColor = j4;
            }
            if ((i2 & Fields.RotationY) != 0) {
                if ((i & 805306368) == 0) {
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i8 = 536870912;
                    } else {
                        i8 = 268435456;
                    }
                    i3 |= i8;
                }
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i13 != 0) {
                            function5 = null;
                        }
                        if (i4 == 0) {
                        }
                        if (i6 != 0) {
                            z2 = false;
                        } else {
                            z2 = z;
                        }
                        if ((i2 & 16) != 0) {
                            shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i3 &= -57345;
                        } else {
                            shape2 = shape;
                        }
                        if ((i2 & 32) != 0) {
                            color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        }
                        if ((i2 & 64) != 0) {
                            contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            contentColor = j2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            actionContentColor = j3;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            i3 &= -234881025;
                            dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                        }
                    } else {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i13 != 0) {
                            function5 = null;
                        }
                        if (i4 == 0) {
                        }
                        if (i6 != 0) {
                            z2 = false;
                        } else {
                            z2 = z;
                        }
                        if ((i2 & 16) != 0) {
                            shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i3 &= -57345;
                        } else {
                            shape2 = shape;
                        }
                        if ((i2 & 32) != 0) {
                            color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        }
                        if ((i2 & 64) != 0) {
                            contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            contentColor = j2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            actionContentColor = j3;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            i3 &= -234881025;
                            dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1235788955, i3, -1, "androidx.compose.material3.Snackbar (Snackbar.kt:113)");
                    }
                    final boolean z116 = z2;
                    final Function2<? super Composer, ? super Integer, Unit> function11118 = function5;
                    final Function2<? super Composer, ? super Integer, Unit> function11119 = function7;
                    final long j11112 = actionContentColor;
                    final long j11113 = dismissActionContentColor;
                    Function2<? super Composer, ? super Integer, Unit> function111110 = function7;
                    boolean z117 = z2;
                    int i1117 = (i3 & 14) | 12779520;
                    int i1118 = i3 >> 9;
                    SurfaceKt.m2868SurfaceT9BRK9s(companion, shape2, color, contentColor, 0.0f, SnackbarTokens.INSTANCE.m3866getContainerElevationD9Ej5fM(), null, ComposableLambdaKt.rememberComposableLambda(-1829663446, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1119) {
                            ComposerKt.sourceInformation(composer2, "C121@5634L5,122@5705L5,123@5779L912,123@5719L972:Snackbar.kt#uh7d8r");
                            if ((i1119 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1829663446, i1119, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:121)");
                                }
                                TextStyle value = TypographyKt.getValue(SnackbarTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                                final TextStyle value2 = TypographyKt.getValue(SnackbarTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                                ProvidedValue<TextStyle> providedValueProvides = TextKt.getLocalTextStyle().provides(value);
                                final boolean z118 = z116;
                                final Function2<? super Composer, ? super Integer, Unit> function111111 = function11118;
                                final Function2<? super Composer, ? super Integer, Unit> function111112 = function4;
                                final Function2<? super Composer, ? super Integer, Unit> function111113 = function11119;
                                final long j11114 = j11112;
                                final long j11115 = j11113;
                                CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>) providedValueProvides, (Function2<? super Composer, ? super Integer, Unit>) ComposableLambdaKt.rememberComposableLambda(835891690, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer3, int i11110) {
                                        ComposerKt.sourceInformation(composer3, "C:Snackbar.kt#uh7d8r");
                                        if ((i11110 & 3) != 2 || !composer3.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(835891690, i11110, -1, "androidx.compose.material3.Snackbar.<anonymous>.<anonymous> (Snackbar.kt:124)");
                                            }
                                            if (z118 && function111111 != null) {
                                                composer3.startReplaceGroup(-810715387);
                                                ComposerKt.sourceInformation(composer3, "126@5873L383");
                                                SnackbarKt.m2849NewLineButtonSnackbarkKq0p4A(function111112, function111111, function111113, value2, j11114, j11115, composer3, 0);
                                                composer3.endReplaceGroup();
                                            } else {
                                                composer3.startReplaceGroup(-810701708);
                                                ComposerKt.sourceInformation(composer3, "135@6301L366");
                                                SnackbarKt.m2850OneRowSnackbarkKq0p4A(function111112, function111111, function111113, value2, j11114, j11115, composer3, 0);
                                                composer3.endReplaceGroup();
                                            }
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer3.skipToGroupEnd();
                                    }
                                }, composer2, 54), composer2, ProvidedValue.$stable | 48);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i1118 & 7168) | i1117 | (i1118 & 112) | (i1118 & 896), 80);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function8 = function111110;
                    modifier2 = companion;
                    shape3 = shape2;
                    z3 = z117;
                    j5 = contentColor;
                    j6 = dismissActionContentColor;
                    j7 = actionContentColor;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i13 != 0) {
                            function5 = null;
                        }
                        if (i4 == 0) {
                        }
                        if (i6 != 0) {
                            z2 = false;
                        } else {
                            z2 = z;
                        }
                        if ((i2 & 16) != 0) {
                            shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i3 &= -57345;
                        } else {
                            shape2 = shape;
                        }
                        if ((i2 & 32) != 0) {
                            color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        }
                        if ((i2 & 64) != 0) {
                            contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            contentColor = j2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            actionContentColor = j3;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            i3 &= -234881025;
                            dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                        }
                    } else {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i13 != 0) {
                            function5 = null;
                        }
                        if (i4 == 0) {
                        }
                        if (i6 != 0) {
                            z2 = false;
                        } else {
                            z2 = z;
                        }
                        if ((i2 & 16) != 0) {
                            shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i3 &= -57345;
                        } else {
                            shape2 = shape;
                        }
                        if ((i2 & 32) != 0) {
                            color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        }
                        if ((i2 & 64) != 0) {
                            contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            contentColor = j2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            actionContentColor = j3;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            i3 &= -234881025;
                            dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1235788955, i3, -1, "androidx.compose.material3.Snackbar (Snackbar.kt:113)");
                    }
                    final boolean z118 = z2;
                    final Function2<? super Composer, ? super Integer, Unit> function111111 = function5;
                    final Function2<? super Composer, ? super Integer, Unit> function111112 = function7;
                    final long j11114 = actionContentColor;
                    final long j11115 = dismissActionContentColor;
                    Function2<? super Composer, ? super Integer, Unit> function111113 = function7;
                    boolean z119 = z2;
                    int i1119 = (i3 & 14) | 12779520;
                    int i11110 = i3 >> 9;
                    SurfaceKt.m2868SurfaceT9BRK9s(companion, shape2, color, contentColor, 0.0f, SnackbarTokens.INSTANCE.m3866getContainerElevationD9Ej5fM(), null, ComposableLambdaKt.rememberComposableLambda(-1829663446, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11111) {
                            ComposerKt.sourceInformation(composer2, "C121@5634L5,122@5705L5,123@5779L912,123@5719L972:Snackbar.kt#uh7d8r");
                            if ((i11111 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1829663446, i11111, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:121)");
                                }
                                TextStyle value = TypographyKt.getValue(SnackbarTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                                final TextStyle value2 = TypographyKt.getValue(SnackbarTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                                ProvidedValue<TextStyle> providedValueProvides = TextKt.getLocalTextStyle().provides(value);
                                final boolean z1110 = z118;
                                final Function2<? super Composer, ? super Integer, Unit> function111114 = function111111;
                                final Function2<? super Composer, ? super Integer, Unit> function111115 = function4;
                                final Function2<? super Composer, ? super Integer, Unit> function111116 = function111112;
                                final long j11116 = j11114;
                                final long j11117 = j11115;
                                CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>) providedValueProvides, (Function2<? super Composer, ? super Integer, Unit>) ComposableLambdaKt.rememberComposableLambda(835891690, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer3, int i11112) {
                                        ComposerKt.sourceInformation(composer3, "C:Snackbar.kt#uh7d8r");
                                        if ((i11112 & 3) != 2 || !composer3.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(835891690, i11112, -1, "androidx.compose.material3.Snackbar.<anonymous>.<anonymous> (Snackbar.kt:124)");
                                            }
                                            if (z1110 && function111114 != null) {
                                                composer3.startReplaceGroup(-810715387);
                                                ComposerKt.sourceInformation(composer3, "126@5873L383");
                                                SnackbarKt.m2849NewLineButtonSnackbarkKq0p4A(function111115, function111114, function111116, value2, j11116, j11117, composer3, 0);
                                                composer3.endReplaceGroup();
                                            } else {
                                                composer3.startReplaceGroup(-810701708);
                                                ComposerKt.sourceInformation(composer3, "135@6301L366");
                                                SnackbarKt.m2850OneRowSnackbarkKq0p4A(function111115, function111114, function111116, value2, j11116, j11117, composer3, 0);
                                                composer3.endReplaceGroup();
                                            }
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer3.skipToGroupEnd();
                                    }
                                }, composer2, 54), composer2, ProvidedValue.$stable | 48);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i11110 & 7168) | i1119 | (i11110 & 112) | (i11110 & 896), 80);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function8 = function111113;
                    modifier2 = companion;
                    shape3 = shape2;
                    z3 = z119;
                    j5 = contentColor;
                    j6 = dismissActionContentColor;
                    j7 = actionContentColor;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier9 = modifier2;
                    final Function2<? super Composer, ? super Integer, Unit> function111114 = function5;
                    final long j11116 = color;
                    final long j11117 = j6;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11111) {
                            SnackbarKt.m2851SnackbareQBnUkQ(modifier9, function111114, function8, z3, shape3, j11116, j5, j7, j11117, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 805306368;
            if ((i3 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i13 != 0) {
                        function5 = null;
                    }
                    if (i4 == 0) {
                    }
                    if (i6 != 0) {
                        z2 = false;
                    } else {
                        z2 = z;
                    }
                    if ((i2 & 16) != 0) {
                        shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        shape2 = shape;
                    }
                    if ((i2 & 32) != 0) {
                        color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    }
                    if ((i2 & 64) != 0) {
                        contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        contentColor = j2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        actionContentColor = j3;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        i3 &= -234881025;
                        dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                    }
                } else {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i13 != 0) {
                        function5 = null;
                    }
                    if (i4 == 0) {
                    }
                    if (i6 != 0) {
                        z2 = false;
                    } else {
                        z2 = z;
                    }
                    if ((i2 & 16) != 0) {
                        shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        shape2 = shape;
                    }
                    if ((i2 & 32) != 0) {
                        color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    }
                    if ((i2 & 64) != 0) {
                        contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        contentColor = j2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        actionContentColor = j3;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        i3 &= -234881025;
                        dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1235788955, i3, -1, "androidx.compose.material3.Snackbar (Snackbar.kt:113)");
                }
                final boolean z1110 = z2;
                final Function2<? super Composer, ? super Integer, Unit> function111115 = function5;
                final Function2<? super Composer, ? super Integer, Unit> function111116 = function7;
                final long j11118 = actionContentColor;
                final long j11119 = dismissActionContentColor;
                Function2<? super Composer, ? super Integer, Unit> function111117 = function7;
                boolean z1111 = z2;
                int i11111 = (i3 & 14) | 12779520;
                int i11112 = i3 >> 9;
                SurfaceKt.m2868SurfaceT9BRK9s(companion, shape2, color, contentColor, 0.0f, SnackbarTokens.INSTANCE.m3866getContainerElevationD9Ej5fM(), null, ComposableLambdaKt.rememberComposableLambda(-1829663446, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11113) {
                        ComposerKt.sourceInformation(composer2, "C121@5634L5,122@5705L5,123@5779L912,123@5719L972:Snackbar.kt#uh7d8r");
                        if ((i11113 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1829663446, i11113, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:121)");
                            }
                            TextStyle value = TypographyKt.getValue(SnackbarTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                            final TextStyle value2 = TypographyKt.getValue(SnackbarTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                            ProvidedValue<TextStyle> providedValueProvides = TextKt.getLocalTextStyle().provides(value);
                            final boolean z1112 = z1110;
                            final Function2<? super Composer, ? super Integer, Unit> function111118 = function111115;
                            final Function2<? super Composer, ? super Integer, Unit> function111119 = function4;
                            final Function2<? super Composer, ? super Integer, Unit> function1111110 = function111116;
                            final long j111110 = j11118;
                            final long j111111 = j11119;
                            CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>) providedValueProvides, (Function2<? super Composer, ? super Integer, Unit>) ComposableLambdaKt.rememberComposableLambda(835891690, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer3, int i11114) {
                                    ComposerKt.sourceInformation(composer3, "C:Snackbar.kt#uh7d8r");
                                    if ((i11114 & 3) != 2 || !composer3.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(835891690, i11114, -1, "androidx.compose.material3.Snackbar.<anonymous>.<anonymous> (Snackbar.kt:124)");
                                        }
                                        if (z1112 && function111118 != null) {
                                            composer3.startReplaceGroup(-810715387);
                                            ComposerKt.sourceInformation(composer3, "126@5873L383");
                                            SnackbarKt.m2849NewLineButtonSnackbarkKq0p4A(function111119, function111118, function1111110, value2, j111110, j111111, composer3, 0);
                                            composer3.endReplaceGroup();
                                        } else {
                                            composer3.startReplaceGroup(-810701708);
                                            ComposerKt.sourceInformation(composer3, "135@6301L366");
                                            SnackbarKt.m2850OneRowSnackbarkKq0p4A(function111119, function111118, function1111110, value2, j111110, j111111, composer3, 0);
                                            composer3.endReplaceGroup();
                                        }
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer3.skipToGroupEnd();
                                }
                            }, composer2, 54), composer2, ProvidedValue.$stable | 48);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i11112 & 7168) | i11111 | (i11112 & 112) | (i11112 & 896), 80);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function8 = function111117;
                modifier2 = companion;
                shape3 = shape2;
                z3 = z1111;
                j5 = contentColor;
                j6 = dismissActionContentColor;
                j7 = actionContentColor;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i13 != 0) {
                        function5 = null;
                    }
                    if (i4 == 0) {
                    }
                    if (i6 != 0) {
                        z2 = false;
                    } else {
                        z2 = z;
                    }
                    if ((i2 & 16) != 0) {
                        shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        shape2 = shape;
                    }
                    if ((i2 & 32) != 0) {
                        color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    }
                    if ((i2 & 64) != 0) {
                        contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        contentColor = j2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        actionContentColor = j3;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        i3 &= -234881025;
                        dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                    }
                } else {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i13 != 0) {
                        function5 = null;
                    }
                    if (i4 == 0) {
                    }
                    if (i6 != 0) {
                        z2 = false;
                    } else {
                        z2 = z;
                    }
                    if ((i2 & 16) != 0) {
                        shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        shape2 = shape;
                    }
                    if ((i2 & 32) != 0) {
                        color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    }
                    if ((i2 & 64) != 0) {
                        contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        contentColor = j2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        actionContentColor = j3;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        i3 &= -234881025;
                        dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1235788955, i3, -1, "androidx.compose.material3.Snackbar (Snackbar.kt:113)");
                }
                final boolean z1112 = z2;
                final Function2<? super Composer, ? super Integer, Unit> function111118 = function5;
                final Function2<? super Composer, ? super Integer, Unit> function111119 = function7;
                final long j111110 = actionContentColor;
                final long j111111 = dismissActionContentColor;
                Function2<? super Composer, ? super Integer, Unit> function1111110 = function7;
                boolean z1113 = z2;
                int i11113 = (i3 & 14) | 12779520;
                int i11114 = i3 >> 9;
                SurfaceKt.m2868SurfaceT9BRK9s(companion, shape2, color, contentColor, 0.0f, SnackbarTokens.INSTANCE.m3866getContainerElevationD9Ej5fM(), null, ComposableLambdaKt.rememberComposableLambda(-1829663446, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11115) {
                        ComposerKt.sourceInformation(composer2, "C121@5634L5,122@5705L5,123@5779L912,123@5719L972:Snackbar.kt#uh7d8r");
                        if ((i11115 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1829663446, i11115, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:121)");
                            }
                            TextStyle value = TypographyKt.getValue(SnackbarTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                            final TextStyle value2 = TypographyKt.getValue(SnackbarTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                            ProvidedValue<TextStyle> providedValueProvides = TextKt.getLocalTextStyle().provides(value);
                            final boolean z1114 = z1112;
                            final Function2<? super Composer, ? super Integer, Unit> function1111111 = function111118;
                            final Function2<? super Composer, ? super Integer, Unit> function1111112 = function4;
                            final Function2<? super Composer, ? super Integer, Unit> function1111113 = function111119;
                            final long j111112 = j111110;
                            final long j111113 = j111111;
                            CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>) providedValueProvides, (Function2<? super Composer, ? super Integer, Unit>) ComposableLambdaKt.rememberComposableLambda(835891690, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer3, int i11116) {
                                    ComposerKt.sourceInformation(composer3, "C:Snackbar.kt#uh7d8r");
                                    if ((i11116 & 3) != 2 || !composer3.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(835891690, i11116, -1, "androidx.compose.material3.Snackbar.<anonymous>.<anonymous> (Snackbar.kt:124)");
                                        }
                                        if (z1114 && function1111111 != null) {
                                            composer3.startReplaceGroup(-810715387);
                                            ComposerKt.sourceInformation(composer3, "126@5873L383");
                                            SnackbarKt.m2849NewLineButtonSnackbarkKq0p4A(function1111112, function1111111, function1111113, value2, j111112, j111113, composer3, 0);
                                            composer3.endReplaceGroup();
                                        } else {
                                            composer3.startReplaceGroup(-810701708);
                                            ComposerKt.sourceInformation(composer3, "135@6301L366");
                                            SnackbarKt.m2850OneRowSnackbarkKq0p4A(function1111112, function1111111, function1111113, value2, j111112, j111113, composer3, 0);
                                            composer3.endReplaceGroup();
                                        }
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer3.skipToGroupEnd();
                                }
                            }, composer2, 54), composer2, ProvidedValue.$stable | 48);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i11114 & 7168) | i11113 | (i11114 & 112) | (i11114 & 896), 80);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function8 = function1111110;
                modifier2 = companion;
                shape3 = shape2;
                z3 = z1113;
                j5 = contentColor;
                j6 = dismissActionContentColor;
                j7 = actionContentColor;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier10 = modifier2;
                final Function2<? super Composer, ? super Integer, Unit> function1111111 = function5;
                final long j111112 = color;
                final long j111113 = j6;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11115) {
                        SnackbarKt.m2851SnackbareQBnUkQ(modifier10, function1111111, function8, z3, shape3, j111112, j5, j7, j111113, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        function5 = function2;
        i4 = i2 & 4;
        if (i4 != 0) {
            if ((i & 384) == 0) {
                function6 = function3;
                if (composerStartRestartGroup.changedInstance(function6)) {
                    i5 = Fields.RotationX;
                } else {
                    i5 = Fields.SpotShadowColor;
                }
                i3 |= i5;
            }
            i6 = i2 & 8;
            if (i6 != 0) {
                if ((i & 3072) == 0) {
                    if (composerStartRestartGroup.changed(z)) {
                        i7 = Fields.CameraDistance;
                    } else {
                        i7 = Fields.RotationZ;
                    }
                    i3 |= i7;
                }
                if ((i & 24576) != 0) {
                    i3 |= ((i2 & 16) == 0 || !composerStartRestartGroup.changed(shape)) ? Fields.Shape : Fields.Clip;
                }
                if ((196608 & i) == 0) {
                    if ((i2 & 32) == 0) {
                        color = j;
                        if (composerStartRestartGroup.changed(color)) {
                        }
                        i3 |= i14;
                    } else {
                        color = j;
                    }
                    i3 |= i14;
                } else {
                    color = j;
                }
                if ((i & 1572864) != 0) {
                    if ((i2 & 64) == 0) {
                        i11 = 524288;
                    } else {
                        i11 = 524288;
                    }
                    i3 |= i11;
                }
                if ((i & 12582912) != 0) {
                    if ((i2 & Fields.SpotShadowColor) == 0) {
                        i10 = 4194304;
                    } else {
                        i10 = 4194304;
                    }
                    i3 |= i10;
                }
                if ((100663296 & i) == 0) {
                    dismissActionContentColor = j4;
                    if ((i2 & Fields.RotationX) == 0) {
                        i9 = 33554432;
                    } else {
                        i9 = 33554432;
                    }
                    i3 |= i9;
                } else {
                    dismissActionContentColor = j4;
                }
                if ((i2 & Fields.RotationY) != 0) {
                    if ((i & 805306368) == 0) {
                        if (composerStartRestartGroup.changedInstance(function4)) {
                            i8 = 536870912;
                        } else {
                            i8 = 268435456;
                        }
                        i3 |= i8;
                    }
                    if ((i3 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i12 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i13 != 0) {
                                function5 = null;
                            }
                            if (i4 == 0) {
                            }
                            if (i6 != 0) {
                                z2 = false;
                            } else {
                                z2 = z;
                            }
                            if ((i2 & 16) != 0) {
                                shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                                i3 &= -57345;
                            } else {
                                shape2 = shape;
                            }
                            if ((i2 & 32) != 0) {
                                color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                                i3 &= -458753;
                            }
                            if ((i2 & 64) != 0) {
                                contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                contentColor = j2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                actionContentColor = j3;
                            }
                            if ((i2 & Fields.RotationX) != 0) {
                                i3 &= -234881025;
                                dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                            }
                        } else {
                            if (i12 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i13 != 0) {
                                function5 = null;
                            }
                            if (i4 == 0) {
                            }
                            if (i6 != 0) {
                                z2 = false;
                            } else {
                                z2 = z;
                            }
                            if ((i2 & 16) != 0) {
                                shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                                i3 &= -57345;
                            } else {
                                shape2 = shape;
                            }
                            if ((i2 & 32) != 0) {
                                color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                                i3 &= -458753;
                            }
                            if ((i2 & 64) != 0) {
                                contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                contentColor = j2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                actionContentColor = j3;
                            }
                            if ((i2 & Fields.RotationX) != 0) {
                                i3 &= -234881025;
                                dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1235788955, i3, -1, "androidx.compose.material3.Snackbar (Snackbar.kt:113)");
                        }
                        final boolean z1114 = z2;
                        final Function2<? super Composer, ? super Integer, Unit> function1111112 = function5;
                        final Function2<? super Composer, ? super Integer, Unit> function1111113 = function7;
                        final long j111114 = actionContentColor;
                        final long j111115 = dismissActionContentColor;
                        Function2<? super Composer, ? super Integer, Unit> function1111114 = function7;
                        boolean z1115 = z2;
                        int i11115 = (i3 & 14) | 12779520;
                        int i11116 = i3 >> 9;
                        SurfaceKt.m2868SurfaceT9BRK9s(companion, shape2, color, contentColor, 0.0f, SnackbarTokens.INSTANCE.m3866getContainerElevationD9Ej5fM(), null, ComposableLambdaKt.rememberComposableLambda(-1829663446, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11117) {
                                ComposerKt.sourceInformation(composer2, "C121@5634L5,122@5705L5,123@5779L912,123@5719L972:Snackbar.kt#uh7d8r");
                                if ((i11117 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1829663446, i11117, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:121)");
                                    }
                                    TextStyle value = TypographyKt.getValue(SnackbarTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                                    final TextStyle value2 = TypographyKt.getValue(SnackbarTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                                    ProvidedValue<TextStyle> providedValueProvides = TextKt.getLocalTextStyle().provides(value);
                                    final boolean z1116 = z1114;
                                    final Function2<? super Composer, ? super Integer, Unit> function1111115 = function1111112;
                                    final Function2<? super Composer, ? super Integer, Unit> function1111116 = function4;
                                    final Function2<? super Composer, ? super Integer, Unit> function1111117 = function1111113;
                                    final long j111116 = j111114;
                                    final long j111117 = j111115;
                                    CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>) providedValueProvides, (Function2<? super Composer, ? super Integer, Unit>) ComposableLambdaKt.rememberComposableLambda(835891690, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer3, int i11118) {
                                            ComposerKt.sourceInformation(composer3, "C:Snackbar.kt#uh7d8r");
                                            if ((i11118 & 3) != 2 || !composer3.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(835891690, i11118, -1, "androidx.compose.material3.Snackbar.<anonymous>.<anonymous> (Snackbar.kt:124)");
                                                }
                                                if (z1116 && function1111115 != null) {
                                                    composer3.startReplaceGroup(-810715387);
                                                    ComposerKt.sourceInformation(composer3, "126@5873L383");
                                                    SnackbarKt.m2849NewLineButtonSnackbarkKq0p4A(function1111116, function1111115, function1111117, value2, j111116, j111117, composer3, 0);
                                                    composer3.endReplaceGroup();
                                                } else {
                                                    composer3.startReplaceGroup(-810701708);
                                                    ComposerKt.sourceInformation(composer3, "135@6301L366");
                                                    SnackbarKt.m2850OneRowSnackbarkKq0p4A(function1111116, function1111115, function1111117, value2, j111116, j111117, composer3, 0);
                                                    composer3.endReplaceGroup();
                                                }
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer3.skipToGroupEnd();
                                        }
                                    }, composer2, 54), composer2, ProvidedValue.$stable | 48);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i11116 & 7168) | i11115 | (i11116 & 112) | (i11116 & 896), 80);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        function8 = function1111114;
                        modifier2 = companion;
                        shape3 = shape2;
                        z3 = z1115;
                        j5 = contentColor;
                        j6 = dismissActionContentColor;
                        j7 = actionContentColor;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i12 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i13 != 0) {
                                function5 = null;
                            }
                            if (i4 == 0) {
                            }
                            if (i6 != 0) {
                                z2 = false;
                            } else {
                                z2 = z;
                            }
                            if ((i2 & 16) != 0) {
                                shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                                i3 &= -57345;
                            } else {
                                shape2 = shape;
                            }
                            if ((i2 & 32) != 0) {
                                color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                                i3 &= -458753;
                            }
                            if ((i2 & 64) != 0) {
                                contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                contentColor = j2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                actionContentColor = j3;
                            }
                            if ((i2 & Fields.RotationX) != 0) {
                                i3 &= -234881025;
                                dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                            }
                        } else {
                            if (i12 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i13 != 0) {
                                function5 = null;
                            }
                            if (i4 == 0) {
                            }
                            if (i6 != 0) {
                                z2 = false;
                            } else {
                                z2 = z;
                            }
                            if ((i2 & 16) != 0) {
                                shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                                i3 &= -57345;
                            } else {
                                shape2 = shape;
                            }
                            if ((i2 & 32) != 0) {
                                color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                                i3 &= -458753;
                            }
                            if ((i2 & 64) != 0) {
                                contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                contentColor = j2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                actionContentColor = j3;
                            }
                            if ((i2 & Fields.RotationX) != 0) {
                                i3 &= -234881025;
                                dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1235788955, i3, -1, "androidx.compose.material3.Snackbar (Snackbar.kt:113)");
                        }
                        final boolean z1116 = z2;
                        final Function2<? super Composer, ? super Integer, Unit> function1111115 = function5;
                        final Function2<? super Composer, ? super Integer, Unit> function1111116 = function7;
                        final long j111116 = actionContentColor;
                        final long j111117 = dismissActionContentColor;
                        Function2<? super Composer, ? super Integer, Unit> function1111117 = function7;
                        boolean z1117 = z2;
                        int i11117 = (i3 & 14) | 12779520;
                        int i11118 = i3 >> 9;
                        SurfaceKt.m2868SurfaceT9BRK9s(companion, shape2, color, contentColor, 0.0f, SnackbarTokens.INSTANCE.m3866getContainerElevationD9Ej5fM(), null, ComposableLambdaKt.rememberComposableLambda(-1829663446, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11119) {
                                ComposerKt.sourceInformation(composer2, "C121@5634L5,122@5705L5,123@5779L912,123@5719L972:Snackbar.kt#uh7d8r");
                                if ((i11119 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1829663446, i11119, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:121)");
                                    }
                                    TextStyle value = TypographyKt.getValue(SnackbarTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                                    final TextStyle value2 = TypographyKt.getValue(SnackbarTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                                    ProvidedValue<TextStyle> providedValueProvides = TextKt.getLocalTextStyle().provides(value);
                                    final boolean z1118 = z1116;
                                    final Function2<? super Composer, ? super Integer, Unit> function1111118 = function1111115;
                                    final Function2<? super Composer, ? super Integer, Unit> function1111119 = function4;
                                    final Function2<? super Composer, ? super Integer, Unit> function11111110 = function1111116;
                                    final long j111118 = j111116;
                                    final long j111119 = j111117;
                                    CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>) providedValueProvides, (Function2<? super Composer, ? super Integer, Unit>) ComposableLambdaKt.rememberComposableLambda(835891690, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer3, int i111110) {
                                            ComposerKt.sourceInformation(composer3, "C:Snackbar.kt#uh7d8r");
                                            if ((i111110 & 3) != 2 || !composer3.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(835891690, i111110, -1, "androidx.compose.material3.Snackbar.<anonymous>.<anonymous> (Snackbar.kt:124)");
                                                }
                                                if (z1118 && function1111118 != null) {
                                                    composer3.startReplaceGroup(-810715387);
                                                    ComposerKt.sourceInformation(composer3, "126@5873L383");
                                                    SnackbarKt.m2849NewLineButtonSnackbarkKq0p4A(function1111119, function1111118, function11111110, value2, j111118, j111119, composer3, 0);
                                                    composer3.endReplaceGroup();
                                                } else {
                                                    composer3.startReplaceGroup(-810701708);
                                                    ComposerKt.sourceInformation(composer3, "135@6301L366");
                                                    SnackbarKt.m2850OneRowSnackbarkKq0p4A(function1111119, function1111118, function11111110, value2, j111118, j111119, composer3, 0);
                                                    composer3.endReplaceGroup();
                                                }
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer3.skipToGroupEnd();
                                        }
                                    }, composer2, 54), composer2, ProvidedValue.$stable | 48);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i11118 & 7168) | i11117 | (i11118 & 112) | (i11118 & 896), 80);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        function8 = function1111117;
                        modifier2 = companion;
                        shape3 = shape2;
                        z3 = z1117;
                        j5 = contentColor;
                        j6 = dismissActionContentColor;
                        j7 = actionContentColor;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier11 = modifier2;
                        final Function2<? super Composer, ? super Integer, Unit> function1111118 = function5;
                        final long j111118 = color;
                        final long j111119 = j6;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11119) {
                                SnackbarKt.m2851SnackbareQBnUkQ(modifier11, function1111118, function8, z3, shape3, j111118, j5, j7, j111119, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 805306368;
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i13 != 0) {
                            function5 = null;
                        }
                        if (i4 == 0) {
                        }
                        if (i6 != 0) {
                            z2 = false;
                        } else {
                            z2 = z;
                        }
                        if ((i2 & 16) != 0) {
                            shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i3 &= -57345;
                        } else {
                            shape2 = shape;
                        }
                        if ((i2 & 32) != 0) {
                            color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        }
                        if ((i2 & 64) != 0) {
                            contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            contentColor = j2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            actionContentColor = j3;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            i3 &= -234881025;
                            dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                        }
                    } else {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i13 != 0) {
                            function5 = null;
                        }
                        if (i4 == 0) {
                        }
                        if (i6 != 0) {
                            z2 = false;
                        } else {
                            z2 = z;
                        }
                        if ((i2 & 16) != 0) {
                            shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i3 &= -57345;
                        } else {
                            shape2 = shape;
                        }
                        if ((i2 & 32) != 0) {
                            color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        }
                        if ((i2 & 64) != 0) {
                            contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            contentColor = j2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            actionContentColor = j3;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            i3 &= -234881025;
                            dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1235788955, i3, -1, "androidx.compose.material3.Snackbar (Snackbar.kt:113)");
                    }
                    final boolean z1118 = z2;
                    final Function2<? super Composer, ? super Integer, Unit> function1111119 = function5;
                    final Function2<? super Composer, ? super Integer, Unit> function11111110 = function7;
                    final long j1111110 = actionContentColor;
                    final long j1111111 = dismissActionContentColor;
                    Function2<? super Composer, ? super Integer, Unit> function11111111 = function7;
                    boolean z1119 = z2;
                    int i11119 = (i3 & 14) | 12779520;
                    int i111110 = i3 >> 9;
                    SurfaceKt.m2868SurfaceT9BRK9s(companion, shape2, color, contentColor, 0.0f, SnackbarTokens.INSTANCE.m3866getContainerElevationD9Ej5fM(), null, ComposableLambdaKt.rememberComposableLambda(-1829663446, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i111111) {
                            ComposerKt.sourceInformation(composer2, "C121@5634L5,122@5705L5,123@5779L912,123@5719L972:Snackbar.kt#uh7d8r");
                            if ((i111111 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1829663446, i111111, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:121)");
                                }
                                TextStyle value = TypographyKt.getValue(SnackbarTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                                final TextStyle value2 = TypographyKt.getValue(SnackbarTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                                ProvidedValue<TextStyle> providedValueProvides = TextKt.getLocalTextStyle().provides(value);
                                final boolean z11110 = z1118;
                                final Function2<? super Composer, ? super Integer, Unit> function11111112 = function1111119;
                                final Function2<? super Composer, ? super Integer, Unit> function11111113 = function4;
                                final Function2<? super Composer, ? super Integer, Unit> function11111114 = function11111110;
                                final long j1111112 = j1111110;
                                final long j1111113 = j1111111;
                                CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>) providedValueProvides, (Function2<? super Composer, ? super Integer, Unit>) ComposableLambdaKt.rememberComposableLambda(835891690, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer3, int i111112) {
                                        ComposerKt.sourceInformation(composer3, "C:Snackbar.kt#uh7d8r");
                                        if ((i111112 & 3) != 2 || !composer3.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(835891690, i111112, -1, "androidx.compose.material3.Snackbar.<anonymous>.<anonymous> (Snackbar.kt:124)");
                                            }
                                            if (z11110 && function11111112 != null) {
                                                composer3.startReplaceGroup(-810715387);
                                                ComposerKt.sourceInformation(composer3, "126@5873L383");
                                                SnackbarKt.m2849NewLineButtonSnackbarkKq0p4A(function11111113, function11111112, function11111114, value2, j1111112, j1111113, composer3, 0);
                                                composer3.endReplaceGroup();
                                            } else {
                                                composer3.startReplaceGroup(-810701708);
                                                ComposerKt.sourceInformation(composer3, "135@6301L366");
                                                SnackbarKt.m2850OneRowSnackbarkKq0p4A(function11111113, function11111112, function11111114, value2, j1111112, j1111113, composer3, 0);
                                                composer3.endReplaceGroup();
                                            }
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer3.skipToGroupEnd();
                                    }
                                }, composer2, 54), composer2, ProvidedValue.$stable | 48);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i111110 & 7168) | i11119 | (i111110 & 112) | (i111110 & 896), 80);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function8 = function11111111;
                    modifier2 = companion;
                    shape3 = shape2;
                    z3 = z1119;
                    j5 = contentColor;
                    j6 = dismissActionContentColor;
                    j7 = actionContentColor;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i13 != 0) {
                            function5 = null;
                        }
                        if (i4 == 0) {
                        }
                        if (i6 != 0) {
                            z2 = false;
                        } else {
                            z2 = z;
                        }
                        if ((i2 & 16) != 0) {
                            shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i3 &= -57345;
                        } else {
                            shape2 = shape;
                        }
                        if ((i2 & 32) != 0) {
                            color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        }
                        if ((i2 & 64) != 0) {
                            contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            contentColor = j2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            actionContentColor = j3;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            i3 &= -234881025;
                            dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                        }
                    } else {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i13 != 0) {
                            function5 = null;
                        }
                        if (i4 == 0) {
                        }
                        if (i6 != 0) {
                            z2 = false;
                        } else {
                            z2 = z;
                        }
                        if ((i2 & 16) != 0) {
                            shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i3 &= -57345;
                        } else {
                            shape2 = shape;
                        }
                        if ((i2 & 32) != 0) {
                            color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        }
                        if ((i2 & 64) != 0) {
                            contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            contentColor = j2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            actionContentColor = j3;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            i3 &= -234881025;
                            dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1235788955, i3, -1, "androidx.compose.material3.Snackbar (Snackbar.kt:113)");
                    }
                    final boolean z11110 = z2;
                    final Function2<? super Composer, ? super Integer, Unit> function11111112 = function5;
                    final Function2<? super Composer, ? super Integer, Unit> function11111113 = function7;
                    final long j1111112 = actionContentColor;
                    final long j1111113 = dismissActionContentColor;
                    Function2<? super Composer, ? super Integer, Unit> function11111114 = function7;
                    boolean z11111 = z2;
                    int i111111 = (i3 & 14) | 12779520;
                    int i111112 = i3 >> 9;
                    SurfaceKt.m2868SurfaceT9BRK9s(companion, shape2, color, contentColor, 0.0f, SnackbarTokens.INSTANCE.m3866getContainerElevationD9Ej5fM(), null, ComposableLambdaKt.rememberComposableLambda(-1829663446, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i111113) {
                            ComposerKt.sourceInformation(composer2, "C121@5634L5,122@5705L5,123@5779L912,123@5719L972:Snackbar.kt#uh7d8r");
                            if ((i111113 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1829663446, i111113, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:121)");
                                }
                                TextStyle value = TypographyKt.getValue(SnackbarTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                                final TextStyle value2 = TypographyKt.getValue(SnackbarTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                                ProvidedValue<TextStyle> providedValueProvides = TextKt.getLocalTextStyle().provides(value);
                                final boolean z11112 = z11110;
                                final Function2<? super Composer, ? super Integer, Unit> function11111115 = function11111112;
                                final Function2<? super Composer, ? super Integer, Unit> function11111116 = function4;
                                final Function2<? super Composer, ? super Integer, Unit> function11111117 = function11111113;
                                final long j1111114 = j1111112;
                                final long j1111115 = j1111113;
                                CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>) providedValueProvides, (Function2<? super Composer, ? super Integer, Unit>) ComposableLambdaKt.rememberComposableLambda(835891690, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer3, int i111114) {
                                        ComposerKt.sourceInformation(composer3, "C:Snackbar.kt#uh7d8r");
                                        if ((i111114 & 3) != 2 || !composer3.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(835891690, i111114, -1, "androidx.compose.material3.Snackbar.<anonymous>.<anonymous> (Snackbar.kt:124)");
                                            }
                                            if (z11112 && function11111115 != null) {
                                                composer3.startReplaceGroup(-810715387);
                                                ComposerKt.sourceInformation(composer3, "126@5873L383");
                                                SnackbarKt.m2849NewLineButtonSnackbarkKq0p4A(function11111116, function11111115, function11111117, value2, j1111114, j1111115, composer3, 0);
                                                composer3.endReplaceGroup();
                                            } else {
                                                composer3.startReplaceGroup(-810701708);
                                                ComposerKt.sourceInformation(composer3, "135@6301L366");
                                                SnackbarKt.m2850OneRowSnackbarkKq0p4A(function11111116, function11111115, function11111117, value2, j1111114, j1111115, composer3, 0);
                                                composer3.endReplaceGroup();
                                            }
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer3.skipToGroupEnd();
                                    }
                                }, composer2, 54), composer2, ProvidedValue.$stable | 48);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i111112 & 7168) | i111111 | (i111112 & 112) | (i111112 & 896), 80);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function8 = function11111114;
                    modifier2 = companion;
                    shape3 = shape2;
                    z3 = z11111;
                    j5 = contentColor;
                    j6 = dismissActionContentColor;
                    j7 = actionContentColor;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier12 = modifier2;
                    final Function2<? super Composer, ? super Integer, Unit> function11111115 = function5;
                    final long j1111114 = color;
                    final long j1111115 = j6;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i111113) {
                            SnackbarKt.m2851SnackbareQBnUkQ(modifier12, function11111115, function8, z3, shape3, j1111114, j5, j7, j1111115, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            if ((i & 24576) != 0) {
                i3 |= ((i2 & 16) == 0 || !composerStartRestartGroup.changed(shape)) ? Fields.Shape : Fields.Clip;
            }
            if ((196608 & i) == 0) {
                if ((i2 & 32) == 0) {
                    color = j;
                    if (composerStartRestartGroup.changed(color)) {
                    }
                    i3 |= i14;
                } else {
                    color = j;
                }
                i3 |= i14;
            } else {
                color = j;
            }
            if ((i & 1572864) != 0) {
                if ((i2 & 64) == 0) {
                    i11 = 524288;
                } else {
                    i11 = 524288;
                }
                i3 |= i11;
            }
            if ((i & 12582912) != 0) {
                if ((i2 & Fields.SpotShadowColor) == 0) {
                    i10 = 4194304;
                } else {
                    i10 = 4194304;
                }
                i3 |= i10;
            }
            if ((100663296 & i) == 0) {
                dismissActionContentColor = j4;
                if ((i2 & Fields.RotationX) == 0) {
                    i9 = 33554432;
                } else {
                    i9 = 33554432;
                }
                i3 |= i9;
            } else {
                dismissActionContentColor = j4;
            }
            if ((i2 & Fields.RotationY) != 0) {
                if ((i & 805306368) == 0) {
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i8 = 536870912;
                    } else {
                        i8 = 268435456;
                    }
                    i3 |= i8;
                }
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i13 != 0) {
                            function5 = null;
                        }
                        if (i4 == 0) {
                        }
                        if (i6 != 0) {
                            z2 = false;
                        } else {
                            z2 = z;
                        }
                        if ((i2 & 16) != 0) {
                            shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i3 &= -57345;
                        } else {
                            shape2 = shape;
                        }
                        if ((i2 & 32) != 0) {
                            color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        }
                        if ((i2 & 64) != 0) {
                            contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            contentColor = j2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            actionContentColor = j3;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            i3 &= -234881025;
                            dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                        }
                    } else {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i13 != 0) {
                            function5 = null;
                        }
                        if (i4 == 0) {
                        }
                        if (i6 != 0) {
                            z2 = false;
                        } else {
                            z2 = z;
                        }
                        if ((i2 & 16) != 0) {
                            shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i3 &= -57345;
                        } else {
                            shape2 = shape;
                        }
                        if ((i2 & 32) != 0) {
                            color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        }
                        if ((i2 & 64) != 0) {
                            contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            contentColor = j2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            actionContentColor = j3;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            i3 &= -234881025;
                            dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1235788955, i3, -1, "androidx.compose.material3.Snackbar (Snackbar.kt:113)");
                    }
                    final boolean z11112 = z2;
                    final Function2<? super Composer, ? super Integer, Unit> function11111116 = function5;
                    final Function2<? super Composer, ? super Integer, Unit> function11111117 = function7;
                    final long j1111116 = actionContentColor;
                    final long j1111117 = dismissActionContentColor;
                    Function2<? super Composer, ? super Integer, Unit> function11111118 = function7;
                    boolean z11113 = z2;
                    int i111113 = (i3 & 14) | 12779520;
                    int i111114 = i3 >> 9;
                    SurfaceKt.m2868SurfaceT9BRK9s(companion, shape2, color, contentColor, 0.0f, SnackbarTokens.INSTANCE.m3866getContainerElevationD9Ej5fM(), null, ComposableLambdaKt.rememberComposableLambda(-1829663446, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i111115) {
                            ComposerKt.sourceInformation(composer2, "C121@5634L5,122@5705L5,123@5779L912,123@5719L972:Snackbar.kt#uh7d8r");
                            if ((i111115 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1829663446, i111115, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:121)");
                                }
                                TextStyle value = TypographyKt.getValue(SnackbarTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                                final TextStyle value2 = TypographyKt.getValue(SnackbarTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                                ProvidedValue<TextStyle> providedValueProvides = TextKt.getLocalTextStyle().provides(value);
                                final boolean z11114 = z11112;
                                final Function2<? super Composer, ? super Integer, Unit> function11111119 = function11111116;
                                final Function2<? super Composer, ? super Integer, Unit> function111111110 = function4;
                                final Function2<? super Composer, ? super Integer, Unit> function111111111 = function11111117;
                                final long j1111118 = j1111116;
                                final long j1111119 = j1111117;
                                CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>) providedValueProvides, (Function2<? super Composer, ? super Integer, Unit>) ComposableLambdaKt.rememberComposableLambda(835891690, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer3, int i111116) {
                                        ComposerKt.sourceInformation(composer3, "C:Snackbar.kt#uh7d8r");
                                        if ((i111116 & 3) != 2 || !composer3.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(835891690, i111116, -1, "androidx.compose.material3.Snackbar.<anonymous>.<anonymous> (Snackbar.kt:124)");
                                            }
                                            if (z11114 && function11111119 != null) {
                                                composer3.startReplaceGroup(-810715387);
                                                ComposerKt.sourceInformation(composer3, "126@5873L383");
                                                SnackbarKt.m2849NewLineButtonSnackbarkKq0p4A(function111111110, function11111119, function111111111, value2, j1111118, j1111119, composer3, 0);
                                                composer3.endReplaceGroup();
                                            } else {
                                                composer3.startReplaceGroup(-810701708);
                                                ComposerKt.sourceInformation(composer3, "135@6301L366");
                                                SnackbarKt.m2850OneRowSnackbarkKq0p4A(function111111110, function11111119, function111111111, value2, j1111118, j1111119, composer3, 0);
                                                composer3.endReplaceGroup();
                                            }
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer3.skipToGroupEnd();
                                    }
                                }, composer2, 54), composer2, ProvidedValue.$stable | 48);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i111114 & 7168) | i111113 | (i111114 & 112) | (i111114 & 896), 80);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function8 = function11111118;
                    modifier2 = companion;
                    shape3 = shape2;
                    z3 = z11113;
                    j5 = contentColor;
                    j6 = dismissActionContentColor;
                    j7 = actionContentColor;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i13 != 0) {
                            function5 = null;
                        }
                        if (i4 == 0) {
                        }
                        if (i6 != 0) {
                            z2 = false;
                        } else {
                            z2 = z;
                        }
                        if ((i2 & 16) != 0) {
                            shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i3 &= -57345;
                        } else {
                            shape2 = shape;
                        }
                        if ((i2 & 32) != 0) {
                            color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        }
                        if ((i2 & 64) != 0) {
                            contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            contentColor = j2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            actionContentColor = j3;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            i3 &= -234881025;
                            dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                        }
                    } else {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i13 != 0) {
                            function5 = null;
                        }
                        if (i4 == 0) {
                        }
                        if (i6 != 0) {
                            z2 = false;
                        } else {
                            z2 = z;
                        }
                        if ((i2 & 16) != 0) {
                            shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i3 &= -57345;
                        } else {
                            shape2 = shape;
                        }
                        if ((i2 & 32) != 0) {
                            color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        }
                        if ((i2 & 64) != 0) {
                            contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            contentColor = j2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            actionContentColor = j3;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            i3 &= -234881025;
                            dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1235788955, i3, -1, "androidx.compose.material3.Snackbar (Snackbar.kt:113)");
                    }
                    final boolean z11114 = z2;
                    final Function2<? super Composer, ? super Integer, Unit> function11111119 = function5;
                    final Function2<? super Composer, ? super Integer, Unit> function111111110 = function7;
                    final long j1111118 = actionContentColor;
                    final long j1111119 = dismissActionContentColor;
                    Function2<? super Composer, ? super Integer, Unit> function111111111 = function7;
                    boolean z11115 = z2;
                    int i111115 = (i3 & 14) | 12779520;
                    int i111116 = i3 >> 9;
                    SurfaceKt.m2868SurfaceT9BRK9s(companion, shape2, color, contentColor, 0.0f, SnackbarTokens.INSTANCE.m3866getContainerElevationD9Ej5fM(), null, ComposableLambdaKt.rememberComposableLambda(-1829663446, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i111117) {
                            ComposerKt.sourceInformation(composer2, "C121@5634L5,122@5705L5,123@5779L912,123@5719L972:Snackbar.kt#uh7d8r");
                            if ((i111117 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1829663446, i111117, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:121)");
                                }
                                TextStyle value = TypographyKt.getValue(SnackbarTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                                final TextStyle value2 = TypographyKt.getValue(SnackbarTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                                ProvidedValue<TextStyle> providedValueProvides = TextKt.getLocalTextStyle().provides(value);
                                final boolean z11116 = z11114;
                                final Function2<? super Composer, ? super Integer, Unit> function111111112 = function11111119;
                                final Function2<? super Composer, ? super Integer, Unit> function111111113 = function4;
                                final Function2<? super Composer, ? super Integer, Unit> function111111114 = function111111110;
                                final long j11111110 = j1111118;
                                final long j11111111 = j1111119;
                                CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>) providedValueProvides, (Function2<? super Composer, ? super Integer, Unit>) ComposableLambdaKt.rememberComposableLambda(835891690, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer3, int i111118) {
                                        ComposerKt.sourceInformation(composer3, "C:Snackbar.kt#uh7d8r");
                                        if ((i111118 & 3) != 2 || !composer3.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(835891690, i111118, -1, "androidx.compose.material3.Snackbar.<anonymous>.<anonymous> (Snackbar.kt:124)");
                                            }
                                            if (z11116 && function111111112 != null) {
                                                composer3.startReplaceGroup(-810715387);
                                                ComposerKt.sourceInformation(composer3, "126@5873L383");
                                                SnackbarKt.m2849NewLineButtonSnackbarkKq0p4A(function111111113, function111111112, function111111114, value2, j11111110, j11111111, composer3, 0);
                                                composer3.endReplaceGroup();
                                            } else {
                                                composer3.startReplaceGroup(-810701708);
                                                ComposerKt.sourceInformation(composer3, "135@6301L366");
                                                SnackbarKt.m2850OneRowSnackbarkKq0p4A(function111111113, function111111112, function111111114, value2, j11111110, j11111111, composer3, 0);
                                                composer3.endReplaceGroup();
                                            }
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer3.skipToGroupEnd();
                                    }
                                }, composer2, 54), composer2, ProvidedValue.$stable | 48);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i111116 & 7168) | i111115 | (i111116 & 112) | (i111116 & 896), 80);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function8 = function111111111;
                    modifier2 = companion;
                    shape3 = shape2;
                    z3 = z11115;
                    j5 = contentColor;
                    j6 = dismissActionContentColor;
                    j7 = actionContentColor;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier13 = modifier2;
                    final Function2<? super Composer, ? super Integer, Unit> function111111112 = function5;
                    final long j11111110 = color;
                    final long j11111111 = j6;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i111117) {
                            SnackbarKt.m2851SnackbareQBnUkQ(modifier13, function111111112, function8, z3, shape3, j11111110, j5, j7, j11111111, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 805306368;
            if ((i3 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i13 != 0) {
                        function5 = null;
                    }
                    if (i4 == 0) {
                    }
                    if (i6 != 0) {
                        z2 = false;
                    } else {
                        z2 = z;
                    }
                    if ((i2 & 16) != 0) {
                        shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        shape2 = shape;
                    }
                    if ((i2 & 32) != 0) {
                        color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    }
                    if ((i2 & 64) != 0) {
                        contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        contentColor = j2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        actionContentColor = j3;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        i3 &= -234881025;
                        dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                    }
                } else {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i13 != 0) {
                        function5 = null;
                    }
                    if (i4 == 0) {
                    }
                    if (i6 != 0) {
                        z2 = false;
                    } else {
                        z2 = z;
                    }
                    if ((i2 & 16) != 0) {
                        shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        shape2 = shape;
                    }
                    if ((i2 & 32) != 0) {
                        color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    }
                    if ((i2 & 64) != 0) {
                        contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        contentColor = j2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        actionContentColor = j3;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        i3 &= -234881025;
                        dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1235788955, i3, -1, "androidx.compose.material3.Snackbar (Snackbar.kt:113)");
                }
                final boolean z11116 = z2;
                final Function2<? super Composer, ? super Integer, Unit> function111111113 = function5;
                final Function2<? super Composer, ? super Integer, Unit> function111111114 = function7;
                final long j11111112 = actionContentColor;
                final long j11111113 = dismissActionContentColor;
                Function2<? super Composer, ? super Integer, Unit> function111111115 = function7;
                boolean z11117 = z2;
                int i111117 = (i3 & 14) | 12779520;
                int i111118 = i3 >> 9;
                SurfaceKt.m2868SurfaceT9BRK9s(companion, shape2, color, contentColor, 0.0f, SnackbarTokens.INSTANCE.m3866getContainerElevationD9Ej5fM(), null, ComposableLambdaKt.rememberComposableLambda(-1829663446, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i111119) {
                        ComposerKt.sourceInformation(composer2, "C121@5634L5,122@5705L5,123@5779L912,123@5719L972:Snackbar.kt#uh7d8r");
                        if ((i111119 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1829663446, i111119, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:121)");
                            }
                            TextStyle value = TypographyKt.getValue(SnackbarTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                            final TextStyle value2 = TypographyKt.getValue(SnackbarTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                            ProvidedValue<TextStyle> providedValueProvides = TextKt.getLocalTextStyle().provides(value);
                            final boolean z11118 = z11116;
                            final Function2<? super Composer, ? super Integer, Unit> function111111116 = function111111113;
                            final Function2<? super Composer, ? super Integer, Unit> function111111117 = function4;
                            final Function2<? super Composer, ? super Integer, Unit> function111111118 = function111111114;
                            final long j11111114 = j11111112;
                            final long j11111115 = j11111113;
                            CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>) providedValueProvides, (Function2<? super Composer, ? super Integer, Unit>) ComposableLambdaKt.rememberComposableLambda(835891690, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer3, int i1111110) {
                                    ComposerKt.sourceInformation(composer3, "C:Snackbar.kt#uh7d8r");
                                    if ((i1111110 & 3) != 2 || !composer3.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(835891690, i1111110, -1, "androidx.compose.material3.Snackbar.<anonymous>.<anonymous> (Snackbar.kt:124)");
                                        }
                                        if (z11118 && function111111116 != null) {
                                            composer3.startReplaceGroup(-810715387);
                                            ComposerKt.sourceInformation(composer3, "126@5873L383");
                                            SnackbarKt.m2849NewLineButtonSnackbarkKq0p4A(function111111117, function111111116, function111111118, value2, j11111114, j11111115, composer3, 0);
                                            composer3.endReplaceGroup();
                                        } else {
                                            composer3.startReplaceGroup(-810701708);
                                            ComposerKt.sourceInformation(composer3, "135@6301L366");
                                            SnackbarKt.m2850OneRowSnackbarkKq0p4A(function111111117, function111111116, function111111118, value2, j11111114, j11111115, composer3, 0);
                                            composer3.endReplaceGroup();
                                        }
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer3.skipToGroupEnd();
                                }
                            }, composer2, 54), composer2, ProvidedValue.$stable | 48);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i111118 & 7168) | i111117 | (i111118 & 112) | (i111118 & 896), 80);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function8 = function111111115;
                modifier2 = companion;
                shape3 = shape2;
                z3 = z11117;
                j5 = contentColor;
                j6 = dismissActionContentColor;
                j7 = actionContentColor;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i13 != 0) {
                        function5 = null;
                    }
                    if (i4 == 0) {
                    }
                    if (i6 != 0) {
                        z2 = false;
                    } else {
                        z2 = z;
                    }
                    if ((i2 & 16) != 0) {
                        shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        shape2 = shape;
                    }
                    if ((i2 & 32) != 0) {
                        color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    }
                    if ((i2 & 64) != 0) {
                        contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        contentColor = j2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        actionContentColor = j3;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        i3 &= -234881025;
                        dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                    }
                } else {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i13 != 0) {
                        function5 = null;
                    }
                    if (i4 == 0) {
                    }
                    if (i6 != 0) {
                        z2 = false;
                    } else {
                        z2 = z;
                    }
                    if ((i2 & 16) != 0) {
                        shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        shape2 = shape;
                    }
                    if ((i2 & 32) != 0) {
                        color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    }
                    if ((i2 & 64) != 0) {
                        contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        contentColor = j2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        actionContentColor = j3;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        i3 &= -234881025;
                        dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1235788955, i3, -1, "androidx.compose.material3.Snackbar (Snackbar.kt:113)");
                }
                final boolean z11118 = z2;
                final Function2<? super Composer, ? super Integer, Unit> function111111116 = function5;
                final Function2<? super Composer, ? super Integer, Unit> function111111117 = function7;
                final long j11111114 = actionContentColor;
                final long j11111115 = dismissActionContentColor;
                Function2<? super Composer, ? super Integer, Unit> function111111118 = function7;
                boolean z11119 = z2;
                int i111119 = (i3 & 14) | 12779520;
                int i1111110 = i3 >> 9;
                SurfaceKt.m2868SurfaceT9BRK9s(companion, shape2, color, contentColor, 0.0f, SnackbarTokens.INSTANCE.m3866getContainerElevationD9Ej5fM(), null, ComposableLambdaKt.rememberComposableLambda(-1829663446, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i1111111) {
                        ComposerKt.sourceInformation(composer2, "C121@5634L5,122@5705L5,123@5779L912,123@5719L972:Snackbar.kt#uh7d8r");
                        if ((i1111111 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1829663446, i1111111, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:121)");
                            }
                            TextStyle value = TypographyKt.getValue(SnackbarTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                            final TextStyle value2 = TypographyKt.getValue(SnackbarTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                            ProvidedValue<TextStyle> providedValueProvides = TextKt.getLocalTextStyle().provides(value);
                            final boolean z111110 = z11118;
                            final Function2<? super Composer, ? super Integer, Unit> function111111119 = function111111116;
                            final Function2<? super Composer, ? super Integer, Unit> function1111111110 = function4;
                            final Function2<? super Composer, ? super Integer, Unit> function1111111111 = function111111117;
                            final long j11111116 = j11111114;
                            final long j11111117 = j11111115;
                            CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>) providedValueProvides, (Function2<? super Composer, ? super Integer, Unit>) ComposableLambdaKt.rememberComposableLambda(835891690, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer3, int i1111112) {
                                    ComposerKt.sourceInformation(composer3, "C:Snackbar.kt#uh7d8r");
                                    if ((i1111112 & 3) != 2 || !composer3.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(835891690, i1111112, -1, "androidx.compose.material3.Snackbar.<anonymous>.<anonymous> (Snackbar.kt:124)");
                                        }
                                        if (z111110 && function111111119 != null) {
                                            composer3.startReplaceGroup(-810715387);
                                            ComposerKt.sourceInformation(composer3, "126@5873L383");
                                            SnackbarKt.m2849NewLineButtonSnackbarkKq0p4A(function1111111110, function111111119, function1111111111, value2, j11111116, j11111117, composer3, 0);
                                            composer3.endReplaceGroup();
                                        } else {
                                            composer3.startReplaceGroup(-810701708);
                                            ComposerKt.sourceInformation(composer3, "135@6301L366");
                                            SnackbarKt.m2850OneRowSnackbarkKq0p4A(function1111111110, function111111119, function1111111111, value2, j11111116, j11111117, composer3, 0);
                                            composer3.endReplaceGroup();
                                        }
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer3.skipToGroupEnd();
                                }
                            }, composer2, 54), composer2, ProvidedValue.$stable | 48);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i1111110 & 7168) | i111119 | (i1111110 & 112) | (i1111110 & 896), 80);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function8 = function111111118;
                modifier2 = companion;
                shape3 = shape2;
                z3 = z11119;
                j5 = contentColor;
                j6 = dismissActionContentColor;
                j7 = actionContentColor;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier14 = modifier2;
                final Function2<? super Composer, ? super Integer, Unit> function111111119 = function5;
                final long j11111116 = color;
                final long j11111117 = j6;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i1111111) {
                        SnackbarKt.m2851SnackbareQBnUkQ(modifier14, function111111119, function8, z3, shape3, j11111116, j5, j7, j11111117, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 384;
        function6 = function3;
        i6 = i2 & 8;
        if (i6 != 0) {
            if ((i & 3072) == 0) {
                if (composerStartRestartGroup.changed(z)) {
                    i7 = Fields.CameraDistance;
                } else {
                    i7 = Fields.RotationZ;
                }
                i3 |= i7;
            }
            if ((i & 24576) != 0) {
                i3 |= ((i2 & 16) == 0 || !composerStartRestartGroup.changed(shape)) ? Fields.Shape : Fields.Clip;
            }
            if ((196608 & i) == 0) {
                if ((i2 & 32) == 0) {
                    color = j;
                    if (composerStartRestartGroup.changed(color)) {
                    }
                    i3 |= i14;
                } else {
                    color = j;
                }
                i3 |= i14;
            } else {
                color = j;
            }
            if ((i & 1572864) != 0) {
                if ((i2 & 64) == 0) {
                    i11 = 524288;
                } else {
                    i11 = 524288;
                }
                i3 |= i11;
            }
            if ((i & 12582912) != 0) {
                if ((i2 & Fields.SpotShadowColor) == 0) {
                    i10 = 4194304;
                } else {
                    i10 = 4194304;
                }
                i3 |= i10;
            }
            if ((100663296 & i) == 0) {
                dismissActionContentColor = j4;
                if ((i2 & Fields.RotationX) == 0) {
                    i9 = 33554432;
                } else {
                    i9 = 33554432;
                }
                i3 |= i9;
            } else {
                dismissActionContentColor = j4;
            }
            if ((i2 & Fields.RotationY) != 0) {
                if ((i & 805306368) == 0) {
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i8 = 536870912;
                    } else {
                        i8 = 268435456;
                    }
                    i3 |= i8;
                }
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i13 != 0) {
                            function5 = null;
                        }
                        if (i4 == 0) {
                        }
                        if (i6 != 0) {
                            z2 = false;
                        } else {
                            z2 = z;
                        }
                        if ((i2 & 16) != 0) {
                            shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i3 &= -57345;
                        } else {
                            shape2 = shape;
                        }
                        if ((i2 & 32) != 0) {
                            color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        }
                        if ((i2 & 64) != 0) {
                            contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            contentColor = j2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            actionContentColor = j3;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            i3 &= -234881025;
                            dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                        }
                    } else {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i13 != 0) {
                            function5 = null;
                        }
                        if (i4 == 0) {
                        }
                        if (i6 != 0) {
                            z2 = false;
                        } else {
                            z2 = z;
                        }
                        if ((i2 & 16) != 0) {
                            shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i3 &= -57345;
                        } else {
                            shape2 = shape;
                        }
                        if ((i2 & 32) != 0) {
                            color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        }
                        if ((i2 & 64) != 0) {
                            contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            contentColor = j2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            actionContentColor = j3;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            i3 &= -234881025;
                            dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1235788955, i3, -1, "androidx.compose.material3.Snackbar (Snackbar.kt:113)");
                    }
                    final boolean z111110 = z2;
                    final Function2<? super Composer, ? super Integer, Unit> function1111111110 = function5;
                    final Function2<? super Composer, ? super Integer, Unit> function1111111111 = function7;
                    final long j11111118 = actionContentColor;
                    final long j11111119 = dismissActionContentColor;
                    Function2<? super Composer, ? super Integer, Unit> function1111111112 = function7;
                    boolean z111111 = z2;
                    int i1111111 = (i3 & 14) | 12779520;
                    int i1111112 = i3 >> 9;
                    SurfaceKt.m2868SurfaceT9BRK9s(companion, shape2, color, contentColor, 0.0f, SnackbarTokens.INSTANCE.m3866getContainerElevationD9Ej5fM(), null, ComposableLambdaKt.rememberComposableLambda(-1829663446, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1111113) {
                            ComposerKt.sourceInformation(composer2, "C121@5634L5,122@5705L5,123@5779L912,123@5719L972:Snackbar.kt#uh7d8r");
                            if ((i1111113 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1829663446, i1111113, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:121)");
                                }
                                TextStyle value = TypographyKt.getValue(SnackbarTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                                final TextStyle value2 = TypographyKt.getValue(SnackbarTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                                ProvidedValue<TextStyle> providedValueProvides = TextKt.getLocalTextStyle().provides(value);
                                final boolean z111112 = z111110;
                                final Function2<? super Composer, ? super Integer, Unit> function1111111113 = function1111111110;
                                final Function2<? super Composer, ? super Integer, Unit> function1111111114 = function4;
                                final Function2<? super Composer, ? super Integer, Unit> function1111111115 = function1111111111;
                                final long j111111110 = j11111118;
                                final long j111111111 = j11111119;
                                CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>) providedValueProvides, (Function2<? super Composer, ? super Integer, Unit>) ComposableLambdaKt.rememberComposableLambda(835891690, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer3, int i1111114) {
                                        ComposerKt.sourceInformation(composer3, "C:Snackbar.kt#uh7d8r");
                                        if ((i1111114 & 3) != 2 || !composer3.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(835891690, i1111114, -1, "androidx.compose.material3.Snackbar.<anonymous>.<anonymous> (Snackbar.kt:124)");
                                            }
                                            if (z111112 && function1111111113 != null) {
                                                composer3.startReplaceGroup(-810715387);
                                                ComposerKt.sourceInformation(composer3, "126@5873L383");
                                                SnackbarKt.m2849NewLineButtonSnackbarkKq0p4A(function1111111114, function1111111113, function1111111115, value2, j111111110, j111111111, composer3, 0);
                                                composer3.endReplaceGroup();
                                            } else {
                                                composer3.startReplaceGroup(-810701708);
                                                ComposerKt.sourceInformation(composer3, "135@6301L366");
                                                SnackbarKt.m2850OneRowSnackbarkKq0p4A(function1111111114, function1111111113, function1111111115, value2, j111111110, j111111111, composer3, 0);
                                                composer3.endReplaceGroup();
                                            }
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer3.skipToGroupEnd();
                                    }
                                }, composer2, 54), composer2, ProvidedValue.$stable | 48);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i1111112 & 7168) | i1111111 | (i1111112 & 112) | (i1111112 & 896), 80);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function8 = function1111111112;
                    modifier2 = companion;
                    shape3 = shape2;
                    z3 = z111111;
                    j5 = contentColor;
                    j6 = dismissActionContentColor;
                    j7 = actionContentColor;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i13 != 0) {
                            function5 = null;
                        }
                        if (i4 == 0) {
                        }
                        if (i6 != 0) {
                            z2 = false;
                        } else {
                            z2 = z;
                        }
                        if ((i2 & 16) != 0) {
                            shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i3 &= -57345;
                        } else {
                            shape2 = shape;
                        }
                        if ((i2 & 32) != 0) {
                            color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        }
                        if ((i2 & 64) != 0) {
                            contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            contentColor = j2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            actionContentColor = j3;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            i3 &= -234881025;
                            dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                        }
                    } else {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i13 != 0) {
                            function5 = null;
                        }
                        if (i4 == 0) {
                        }
                        if (i6 != 0) {
                            z2 = false;
                        } else {
                            z2 = z;
                        }
                        if ((i2 & 16) != 0) {
                            shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i3 &= -57345;
                        } else {
                            shape2 = shape;
                        }
                        if ((i2 & 32) != 0) {
                            color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        }
                        if ((i2 & 64) != 0) {
                            contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            contentColor = j2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            actionContentColor = j3;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            i3 &= -234881025;
                            dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1235788955, i3, -1, "androidx.compose.material3.Snackbar (Snackbar.kt:113)");
                    }
                    final boolean z111112 = z2;
                    final Function2<? super Composer, ? super Integer, Unit> function1111111113 = function5;
                    final Function2<? super Composer, ? super Integer, Unit> function1111111114 = function7;
                    final long j111111110 = actionContentColor;
                    final long j111111111 = dismissActionContentColor;
                    Function2<? super Composer, ? super Integer, Unit> function1111111115 = function7;
                    boolean z111113 = z2;
                    int i1111113 = (i3 & 14) | 12779520;
                    int i1111114 = i3 >> 9;
                    SurfaceKt.m2868SurfaceT9BRK9s(companion, shape2, color, contentColor, 0.0f, SnackbarTokens.INSTANCE.m3866getContainerElevationD9Ej5fM(), null, ComposableLambdaKt.rememberComposableLambda(-1829663446, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1111115) {
                            ComposerKt.sourceInformation(composer2, "C121@5634L5,122@5705L5,123@5779L912,123@5719L972:Snackbar.kt#uh7d8r");
                            if ((i1111115 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1829663446, i1111115, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:121)");
                                }
                                TextStyle value = TypographyKt.getValue(SnackbarTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                                final TextStyle value2 = TypographyKt.getValue(SnackbarTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                                ProvidedValue<TextStyle> providedValueProvides = TextKt.getLocalTextStyle().provides(value);
                                final boolean z111114 = z111112;
                                final Function2<? super Composer, ? super Integer, Unit> function1111111116 = function1111111113;
                                final Function2<? super Composer, ? super Integer, Unit> function1111111117 = function4;
                                final Function2<? super Composer, ? super Integer, Unit> function1111111118 = function1111111114;
                                final long j111111112 = j111111110;
                                final long j111111113 = j111111111;
                                CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>) providedValueProvides, (Function2<? super Composer, ? super Integer, Unit>) ComposableLambdaKt.rememberComposableLambda(835891690, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer3, int i1111116) {
                                        ComposerKt.sourceInformation(composer3, "C:Snackbar.kt#uh7d8r");
                                        if ((i1111116 & 3) != 2 || !composer3.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(835891690, i1111116, -1, "androidx.compose.material3.Snackbar.<anonymous>.<anonymous> (Snackbar.kt:124)");
                                            }
                                            if (z111114 && function1111111116 != null) {
                                                composer3.startReplaceGroup(-810715387);
                                                ComposerKt.sourceInformation(composer3, "126@5873L383");
                                                SnackbarKt.m2849NewLineButtonSnackbarkKq0p4A(function1111111117, function1111111116, function1111111118, value2, j111111112, j111111113, composer3, 0);
                                                composer3.endReplaceGroup();
                                            } else {
                                                composer3.startReplaceGroup(-810701708);
                                                ComposerKt.sourceInformation(composer3, "135@6301L366");
                                                SnackbarKt.m2850OneRowSnackbarkKq0p4A(function1111111117, function1111111116, function1111111118, value2, j111111112, j111111113, composer3, 0);
                                                composer3.endReplaceGroup();
                                            }
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer3.skipToGroupEnd();
                                    }
                                }, composer2, 54), composer2, ProvidedValue.$stable | 48);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i1111114 & 7168) | i1111113 | (i1111114 & 112) | (i1111114 & 896), 80);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function8 = function1111111115;
                    modifier2 = companion;
                    shape3 = shape2;
                    z3 = z111113;
                    j5 = contentColor;
                    j6 = dismissActionContentColor;
                    j7 = actionContentColor;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier15 = modifier2;
                    final Function2<? super Composer, ? super Integer, Unit> function1111111116 = function5;
                    final long j111111112 = color;
                    final long j111111113 = j6;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1111115) {
                            SnackbarKt.m2851SnackbareQBnUkQ(modifier15, function1111111116, function8, z3, shape3, j111111112, j5, j7, j111111113, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 805306368;
            if ((i3 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i13 != 0) {
                        function5 = null;
                    }
                    if (i4 == 0) {
                    }
                    if (i6 != 0) {
                        z2 = false;
                    } else {
                        z2 = z;
                    }
                    if ((i2 & 16) != 0) {
                        shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        shape2 = shape;
                    }
                    if ((i2 & 32) != 0) {
                        color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    }
                    if ((i2 & 64) != 0) {
                        contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        contentColor = j2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        actionContentColor = j3;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        i3 &= -234881025;
                        dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                    }
                } else {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i13 != 0) {
                        function5 = null;
                    }
                    if (i4 == 0) {
                    }
                    if (i6 != 0) {
                        z2 = false;
                    } else {
                        z2 = z;
                    }
                    if ((i2 & 16) != 0) {
                        shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        shape2 = shape;
                    }
                    if ((i2 & 32) != 0) {
                        color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    }
                    if ((i2 & 64) != 0) {
                        contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        contentColor = j2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        actionContentColor = j3;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        i3 &= -234881025;
                        dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1235788955, i3, -1, "androidx.compose.material3.Snackbar (Snackbar.kt:113)");
                }
                final boolean z111114 = z2;
                final Function2<? super Composer, ? super Integer, Unit> function1111111117 = function5;
                final Function2<? super Composer, ? super Integer, Unit> function1111111118 = function7;
                final long j111111114 = actionContentColor;
                final long j111111115 = dismissActionContentColor;
                Function2<? super Composer, ? super Integer, Unit> function1111111119 = function7;
                boolean z111115 = z2;
                int i1111115 = (i3 & 14) | 12779520;
                int i1111116 = i3 >> 9;
                SurfaceKt.m2868SurfaceT9BRK9s(companion, shape2, color, contentColor, 0.0f, SnackbarTokens.INSTANCE.m3866getContainerElevationD9Ej5fM(), null, ComposableLambdaKt.rememberComposableLambda(-1829663446, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i1111117) {
                        ComposerKt.sourceInformation(composer2, "C121@5634L5,122@5705L5,123@5779L912,123@5719L972:Snackbar.kt#uh7d8r");
                        if ((i1111117 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1829663446, i1111117, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:121)");
                            }
                            TextStyle value = TypographyKt.getValue(SnackbarTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                            final TextStyle value2 = TypographyKt.getValue(SnackbarTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                            ProvidedValue<TextStyle> providedValueProvides = TextKt.getLocalTextStyle().provides(value);
                            final boolean z111116 = z111114;
                            final Function2<? super Composer, ? super Integer, Unit> function11111111110 = function1111111117;
                            final Function2<? super Composer, ? super Integer, Unit> function11111111111 = function4;
                            final Function2<? super Composer, ? super Integer, Unit> function11111111112 = function1111111118;
                            final long j111111116 = j111111114;
                            final long j111111117 = j111111115;
                            CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>) providedValueProvides, (Function2<? super Composer, ? super Integer, Unit>) ComposableLambdaKt.rememberComposableLambda(835891690, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer3, int i1111118) {
                                    ComposerKt.sourceInformation(composer3, "C:Snackbar.kt#uh7d8r");
                                    if ((i1111118 & 3) != 2 || !composer3.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(835891690, i1111118, -1, "androidx.compose.material3.Snackbar.<anonymous>.<anonymous> (Snackbar.kt:124)");
                                        }
                                        if (z111116 && function11111111110 != null) {
                                            composer3.startReplaceGroup(-810715387);
                                            ComposerKt.sourceInformation(composer3, "126@5873L383");
                                            SnackbarKt.m2849NewLineButtonSnackbarkKq0p4A(function11111111111, function11111111110, function11111111112, value2, j111111116, j111111117, composer3, 0);
                                            composer3.endReplaceGroup();
                                        } else {
                                            composer3.startReplaceGroup(-810701708);
                                            ComposerKt.sourceInformation(composer3, "135@6301L366");
                                            SnackbarKt.m2850OneRowSnackbarkKq0p4A(function11111111111, function11111111110, function11111111112, value2, j111111116, j111111117, composer3, 0);
                                            composer3.endReplaceGroup();
                                        }
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer3.skipToGroupEnd();
                                }
                            }, composer2, 54), composer2, ProvidedValue.$stable | 48);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i1111116 & 7168) | i1111115 | (i1111116 & 112) | (i1111116 & 896), 80);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function8 = function1111111119;
                modifier2 = companion;
                shape3 = shape2;
                z3 = z111115;
                j5 = contentColor;
                j6 = dismissActionContentColor;
                j7 = actionContentColor;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i13 != 0) {
                        function5 = null;
                    }
                    if (i4 == 0) {
                    }
                    if (i6 != 0) {
                        z2 = false;
                    } else {
                        z2 = z;
                    }
                    if ((i2 & 16) != 0) {
                        shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        shape2 = shape;
                    }
                    if ((i2 & 32) != 0) {
                        color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    }
                    if ((i2 & 64) != 0) {
                        contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        contentColor = j2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        actionContentColor = j3;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        i3 &= -234881025;
                        dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                    }
                } else {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i13 != 0) {
                        function5 = null;
                    }
                    if (i4 == 0) {
                    }
                    if (i6 != 0) {
                        z2 = false;
                    } else {
                        z2 = z;
                    }
                    if ((i2 & 16) != 0) {
                        shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        shape2 = shape;
                    }
                    if ((i2 & 32) != 0) {
                        color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    }
                    if ((i2 & 64) != 0) {
                        contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        contentColor = j2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        actionContentColor = j3;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        i3 &= -234881025;
                        dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1235788955, i3, -1, "androidx.compose.material3.Snackbar (Snackbar.kt:113)");
                }
                final boolean z111116 = z2;
                final Function2<? super Composer, ? super Integer, Unit> function11111111110 = function5;
                final Function2<? super Composer, ? super Integer, Unit> function11111111111 = function7;
                final long j111111116 = actionContentColor;
                final long j111111117 = dismissActionContentColor;
                Function2<? super Composer, ? super Integer, Unit> function11111111112 = function7;
                boolean z111117 = z2;
                int i1111117 = (i3 & 14) | 12779520;
                int i1111118 = i3 >> 9;
                SurfaceKt.m2868SurfaceT9BRK9s(companion, shape2, color, contentColor, 0.0f, SnackbarTokens.INSTANCE.m3866getContainerElevationD9Ej5fM(), null, ComposableLambdaKt.rememberComposableLambda(-1829663446, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i1111119) {
                        ComposerKt.sourceInformation(composer2, "C121@5634L5,122@5705L5,123@5779L912,123@5719L972:Snackbar.kt#uh7d8r");
                        if ((i1111119 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1829663446, i1111119, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:121)");
                            }
                            TextStyle value = TypographyKt.getValue(SnackbarTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                            final TextStyle value2 = TypographyKt.getValue(SnackbarTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                            ProvidedValue<TextStyle> providedValueProvides = TextKt.getLocalTextStyle().provides(value);
                            final boolean z111118 = z111116;
                            final Function2<? super Composer, ? super Integer, Unit> function11111111113 = function11111111110;
                            final Function2<? super Composer, ? super Integer, Unit> function11111111114 = function4;
                            final Function2<? super Composer, ? super Integer, Unit> function11111111115 = function11111111111;
                            final long j111111118 = j111111116;
                            final long j111111119 = j111111117;
                            CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>) providedValueProvides, (Function2<? super Composer, ? super Integer, Unit>) ComposableLambdaKt.rememberComposableLambda(835891690, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer3, int i11111110) {
                                    ComposerKt.sourceInformation(composer3, "C:Snackbar.kt#uh7d8r");
                                    if ((i11111110 & 3) != 2 || !composer3.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(835891690, i11111110, -1, "androidx.compose.material3.Snackbar.<anonymous>.<anonymous> (Snackbar.kt:124)");
                                        }
                                        if (z111118 && function11111111113 != null) {
                                            composer3.startReplaceGroup(-810715387);
                                            ComposerKt.sourceInformation(composer3, "126@5873L383");
                                            SnackbarKt.m2849NewLineButtonSnackbarkKq0p4A(function11111111114, function11111111113, function11111111115, value2, j111111118, j111111119, composer3, 0);
                                            composer3.endReplaceGroup();
                                        } else {
                                            composer3.startReplaceGroup(-810701708);
                                            ComposerKt.sourceInformation(composer3, "135@6301L366");
                                            SnackbarKt.m2850OneRowSnackbarkKq0p4A(function11111111114, function11111111113, function11111111115, value2, j111111118, j111111119, composer3, 0);
                                            composer3.endReplaceGroup();
                                        }
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer3.skipToGroupEnd();
                                }
                            }, composer2, 54), composer2, ProvidedValue.$stable | 48);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i1111118 & 7168) | i1111117 | (i1111118 & 112) | (i1111118 & 896), 80);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function8 = function11111111112;
                modifier2 = companion;
                shape3 = shape2;
                z3 = z111117;
                j5 = contentColor;
                j6 = dismissActionContentColor;
                j7 = actionContentColor;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier16 = modifier2;
                final Function2<? super Composer, ? super Integer, Unit> function11111111113 = function5;
                final long j111111118 = color;
                final long j111111119 = j6;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i1111119) {
                        SnackbarKt.m2851SnackbareQBnUkQ(modifier16, function11111111113, function8, z3, shape3, j111111118, j5, j7, j111111119, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 3072;
        if ((i & 24576) != 0) {
            i3 |= ((i2 & 16) == 0 || !composerStartRestartGroup.changed(shape)) ? Fields.Shape : Fields.Clip;
        }
        if ((196608 & i) == 0) {
            if ((i2 & 32) == 0) {
                color = j;
                if (composerStartRestartGroup.changed(color)) {
                }
                i3 |= i14;
            } else {
                color = j;
            }
            i3 |= i14;
        } else {
            color = j;
        }
        if ((i & 1572864) != 0) {
            if ((i2 & 64) == 0) {
                i11 = 524288;
            } else {
                i11 = 524288;
            }
            i3 |= i11;
        }
        if ((i & 12582912) != 0) {
            if ((i2 & Fields.SpotShadowColor) == 0) {
                i10 = 4194304;
            } else {
                i10 = 4194304;
            }
            i3 |= i10;
        }
        if ((100663296 & i) == 0) {
            dismissActionContentColor = j4;
            if ((i2 & Fields.RotationX) == 0) {
                i9 = 33554432;
            } else {
                i9 = 33554432;
            }
            i3 |= i9;
        } else {
            dismissActionContentColor = j4;
        }
        if ((i2 & Fields.RotationY) != 0) {
            if ((i & 805306368) == 0) {
                if (composerStartRestartGroup.changedInstance(function4)) {
                    i8 = 536870912;
                } else {
                    i8 = 268435456;
                }
                i3 |= i8;
            }
            if ((i3 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i13 != 0) {
                        function5 = null;
                    }
                    if (i4 == 0) {
                    }
                    if (i6 != 0) {
                        z2 = false;
                    } else {
                        z2 = z;
                    }
                    if ((i2 & 16) != 0) {
                        shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        shape2 = shape;
                    }
                    if ((i2 & 32) != 0) {
                        color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    }
                    if ((i2 & 64) != 0) {
                        contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        contentColor = j2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        actionContentColor = j3;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        i3 &= -234881025;
                        dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                    }
                } else {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i13 != 0) {
                        function5 = null;
                    }
                    if (i4 == 0) {
                    }
                    if (i6 != 0) {
                        z2 = false;
                    } else {
                        z2 = z;
                    }
                    if ((i2 & 16) != 0) {
                        shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        shape2 = shape;
                    }
                    if ((i2 & 32) != 0) {
                        color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    }
                    if ((i2 & 64) != 0) {
                        contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        contentColor = j2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        actionContentColor = j3;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        i3 &= -234881025;
                        dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1235788955, i3, -1, "androidx.compose.material3.Snackbar (Snackbar.kt:113)");
                }
                final boolean z111118 = z2;
                final Function2<? super Composer, ? super Integer, Unit> function11111111114 = function5;
                final Function2<? super Composer, ? super Integer, Unit> function11111111115 = function7;
                final long j1111111110 = actionContentColor;
                final long j1111111111 = dismissActionContentColor;
                Function2<? super Composer, ? super Integer, Unit> function11111111116 = function7;
                boolean z111119 = z2;
                int i1111119 = (i3 & 14) | 12779520;
                int i11111110 = i3 >> 9;
                SurfaceKt.m2868SurfaceT9BRK9s(companion, shape2, color, contentColor, 0.0f, SnackbarTokens.INSTANCE.m3866getContainerElevationD9Ej5fM(), null, ComposableLambdaKt.rememberComposableLambda(-1829663446, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11111111) {
                        ComposerKt.sourceInformation(composer2, "C121@5634L5,122@5705L5,123@5779L912,123@5719L972:Snackbar.kt#uh7d8r");
                        if ((i11111111 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1829663446, i11111111, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:121)");
                            }
                            TextStyle value = TypographyKt.getValue(SnackbarTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                            final TextStyle value2 = TypographyKt.getValue(SnackbarTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                            ProvidedValue<TextStyle> providedValueProvides = TextKt.getLocalTextStyle().provides(value);
                            final boolean z1111110 = z111118;
                            final Function2<? super Composer, ? super Integer, Unit> function11111111117 = function11111111114;
                            final Function2<? super Composer, ? super Integer, Unit> function11111111118 = function4;
                            final Function2<? super Composer, ? super Integer, Unit> function11111111119 = function11111111115;
                            final long j1111111112 = j1111111110;
                            final long j1111111113 = j1111111111;
                            CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>) providedValueProvides, (Function2<? super Composer, ? super Integer, Unit>) ComposableLambdaKt.rememberComposableLambda(835891690, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer3, int i11111112) {
                                    ComposerKt.sourceInformation(composer3, "C:Snackbar.kt#uh7d8r");
                                    if ((i11111112 & 3) != 2 || !composer3.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(835891690, i11111112, -1, "androidx.compose.material3.Snackbar.<anonymous>.<anonymous> (Snackbar.kt:124)");
                                        }
                                        if (z1111110 && function11111111117 != null) {
                                            composer3.startReplaceGroup(-810715387);
                                            ComposerKt.sourceInformation(composer3, "126@5873L383");
                                            SnackbarKt.m2849NewLineButtonSnackbarkKq0p4A(function11111111118, function11111111117, function11111111119, value2, j1111111112, j1111111113, composer3, 0);
                                            composer3.endReplaceGroup();
                                        } else {
                                            composer3.startReplaceGroup(-810701708);
                                            ComposerKt.sourceInformation(composer3, "135@6301L366");
                                            SnackbarKt.m2850OneRowSnackbarkKq0p4A(function11111111118, function11111111117, function11111111119, value2, j1111111112, j1111111113, composer3, 0);
                                            composer3.endReplaceGroup();
                                        }
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer3.skipToGroupEnd();
                                }
                            }, composer2, 54), composer2, ProvidedValue.$stable | 48);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i11111110 & 7168) | i1111119 | (i11111110 & 112) | (i11111110 & 896), 80);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function8 = function11111111116;
                modifier2 = companion;
                shape3 = shape2;
                z3 = z111119;
                j5 = contentColor;
                j6 = dismissActionContentColor;
                j7 = actionContentColor;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i13 != 0) {
                        function5 = null;
                    }
                    if (i4 == 0) {
                    }
                    if (i6 != 0) {
                        z2 = false;
                    } else {
                        z2 = z;
                    }
                    if ((i2 & 16) != 0) {
                        shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        shape2 = shape;
                    }
                    if ((i2 & 32) != 0) {
                        color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    }
                    if ((i2 & 64) != 0) {
                        contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        contentColor = j2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        actionContentColor = j3;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        i3 &= -234881025;
                        dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                    }
                } else {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i13 != 0) {
                        function5 = null;
                    }
                    if (i4 == 0) {
                    }
                    if (i6 != 0) {
                        z2 = false;
                    } else {
                        z2 = z;
                    }
                    if ((i2 & 16) != 0) {
                        shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        shape2 = shape;
                    }
                    if ((i2 & 32) != 0) {
                        color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    }
                    if ((i2 & 64) != 0) {
                        contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        contentColor = j2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        actionContentColor = j3;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        i3 &= -234881025;
                        dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1235788955, i3, -1, "androidx.compose.material3.Snackbar (Snackbar.kt:113)");
                }
                final boolean z1111110 = z2;
                final Function2<? super Composer, ? super Integer, Unit> function11111111117 = function5;
                final Function2<? super Composer, ? super Integer, Unit> function11111111118 = function7;
                final long j1111111112 = actionContentColor;
                final long j1111111113 = dismissActionContentColor;
                Function2<? super Composer, ? super Integer, Unit> function11111111119 = function7;
                boolean z1111111 = z2;
                int i11111111 = (i3 & 14) | 12779520;
                int i11111112 = i3 >> 9;
                SurfaceKt.m2868SurfaceT9BRK9s(companion, shape2, color, contentColor, 0.0f, SnackbarTokens.INSTANCE.m3866getContainerElevationD9Ej5fM(), null, ComposableLambdaKt.rememberComposableLambda(-1829663446, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11111113) {
                        ComposerKt.sourceInformation(composer2, "C121@5634L5,122@5705L5,123@5779L912,123@5719L972:Snackbar.kt#uh7d8r");
                        if ((i11111113 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1829663446, i11111113, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:121)");
                            }
                            TextStyle value = TypographyKt.getValue(SnackbarTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                            final TextStyle value2 = TypographyKt.getValue(SnackbarTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                            ProvidedValue<TextStyle> providedValueProvides = TextKt.getLocalTextStyle().provides(value);
                            final boolean z1111112 = z1111110;
                            final Function2<? super Composer, ? super Integer, Unit> function111111111110 = function11111111117;
                            final Function2<? super Composer, ? super Integer, Unit> function111111111111 = function4;
                            final Function2<? super Composer, ? super Integer, Unit> function111111111112 = function11111111118;
                            final long j1111111114 = j1111111112;
                            final long j1111111115 = j1111111113;
                            CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>) providedValueProvides, (Function2<? super Composer, ? super Integer, Unit>) ComposableLambdaKt.rememberComposableLambda(835891690, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer3, int i11111114) {
                                    ComposerKt.sourceInformation(composer3, "C:Snackbar.kt#uh7d8r");
                                    if ((i11111114 & 3) != 2 || !composer3.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(835891690, i11111114, -1, "androidx.compose.material3.Snackbar.<anonymous>.<anonymous> (Snackbar.kt:124)");
                                        }
                                        if (z1111112 && function111111111110 != null) {
                                            composer3.startReplaceGroup(-810715387);
                                            ComposerKt.sourceInformation(composer3, "126@5873L383");
                                            SnackbarKt.m2849NewLineButtonSnackbarkKq0p4A(function111111111111, function111111111110, function111111111112, value2, j1111111114, j1111111115, composer3, 0);
                                            composer3.endReplaceGroup();
                                        } else {
                                            composer3.startReplaceGroup(-810701708);
                                            ComposerKt.sourceInformation(composer3, "135@6301L366");
                                            SnackbarKt.m2850OneRowSnackbarkKq0p4A(function111111111111, function111111111110, function111111111112, value2, j1111111114, j1111111115, composer3, 0);
                                            composer3.endReplaceGroup();
                                        }
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer3.skipToGroupEnd();
                                }
                            }, composer2, 54), composer2, ProvidedValue.$stable | 48);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i11111112 & 7168) | i11111111 | (i11111112 & 112) | (i11111112 & 896), 80);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function8 = function11111111119;
                modifier2 = companion;
                shape3 = shape2;
                z3 = z1111111;
                j5 = contentColor;
                j6 = dismissActionContentColor;
                j7 = actionContentColor;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier17 = modifier2;
                final Function2<? super Composer, ? super Integer, Unit> function111111111110 = function5;
                final long j1111111114 = color;
                final long j1111111115 = j6;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11111113) {
                        SnackbarKt.m2851SnackbareQBnUkQ(modifier17, function111111111110, function8, z3, shape3, j1111111114, j5, j7, j1111111115, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 805306368;
        if ((i3 & 306783379) == 306783378) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i12 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i13 != 0) {
                    function5 = null;
                }
                if (i4 == 0) {
                }
                if (i6 != 0) {
                    z2 = false;
                } else {
                    z2 = z;
                }
                if ((i2 & 16) != 0) {
                    shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    i3 &= -57345;
                } else {
                    shape2 = shape;
                }
                if ((i2 & 32) != 0) {
                    color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                    i3 &= -458753;
                }
                if ((i2 & 64) != 0) {
                    contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                    i3 &= -3670017;
                } else {
                    contentColor = j2;
                }
                if ((i2 & Fields.SpotShadowColor) != 0) {
                    actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                    i3 &= -29360129;
                } else {
                    actionContentColor = j3;
                }
                if ((i2 & Fields.RotationX) != 0) {
                    i3 &= -234881025;
                    dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                }
            } else {
                if (i12 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i13 != 0) {
                    function5 = null;
                }
                if (i4 == 0) {
                }
                if (i6 != 0) {
                    z2 = false;
                } else {
                    z2 = z;
                }
                if ((i2 & 16) != 0) {
                    shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    i3 &= -57345;
                } else {
                    shape2 = shape;
                }
                if ((i2 & 32) != 0) {
                    color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                    i3 &= -458753;
                }
                if ((i2 & 64) != 0) {
                    contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                    i3 &= -3670017;
                } else {
                    contentColor = j2;
                }
                if ((i2 & Fields.SpotShadowColor) != 0) {
                    actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                    i3 &= -29360129;
                } else {
                    actionContentColor = j3;
                }
                if ((i2 & Fields.RotationX) != 0) {
                    i3 &= -234881025;
                    dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1235788955, i3, -1, "androidx.compose.material3.Snackbar (Snackbar.kt:113)");
            }
            final boolean z1111112 = z2;
            final Function2<? super Composer, ? super Integer, Unit> function111111111111 = function5;
            final Function2<? super Composer, ? super Integer, Unit> function111111111112 = function7;
            final long j1111111116 = actionContentColor;
            final long j1111111117 = dismissActionContentColor;
            Function2<? super Composer, ? super Integer, Unit> function111111111113 = function7;
            boolean z1111113 = z2;
            int i11111113 = (i3 & 14) | 12779520;
            int i11111114 = i3 >> 9;
            SurfaceKt.m2868SurfaceT9BRK9s(companion, shape2, color, contentColor, 0.0f, SnackbarTokens.INSTANCE.m3866getContainerElevationD9Ej5fM(), null, ComposableLambdaKt.rememberComposableLambda(-1829663446, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i11111115) {
                    ComposerKt.sourceInformation(composer2, "C121@5634L5,122@5705L5,123@5779L912,123@5719L972:Snackbar.kt#uh7d8r");
                    if ((i11111115 & 3) != 2 || !composer2.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1829663446, i11111115, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:121)");
                        }
                        TextStyle value = TypographyKt.getValue(SnackbarTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                        final TextStyle value2 = TypographyKt.getValue(SnackbarTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                        ProvidedValue<TextStyle> providedValueProvides = TextKt.getLocalTextStyle().provides(value);
                        final boolean z1111114 = z1111112;
                        final Function2<? super Composer, ? super Integer, Unit> function111111111114 = function111111111111;
                        final Function2<? super Composer, ? super Integer, Unit> function111111111115 = function4;
                        final Function2<? super Composer, ? super Integer, Unit> function111111111116 = function111111111112;
                        final long j1111111118 = j1111111116;
                        final long j1111111119 = j1111111117;
                        CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>) providedValueProvides, (Function2<? super Composer, ? super Integer, Unit>) ComposableLambdaKt.rememberComposableLambda(835891690, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer3, int i11111116) {
                                ComposerKt.sourceInformation(composer3, "C:Snackbar.kt#uh7d8r");
                                if ((i11111116 & 3) != 2 || !composer3.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(835891690, i11111116, -1, "androidx.compose.material3.Snackbar.<anonymous>.<anonymous> (Snackbar.kt:124)");
                                    }
                                    if (z1111114 && function111111111114 != null) {
                                        composer3.startReplaceGroup(-810715387);
                                        ComposerKt.sourceInformation(composer3, "126@5873L383");
                                        SnackbarKt.m2849NewLineButtonSnackbarkKq0p4A(function111111111115, function111111111114, function111111111116, value2, j1111111118, j1111111119, composer3, 0);
                                        composer3.endReplaceGroup();
                                    } else {
                                        composer3.startReplaceGroup(-810701708);
                                        ComposerKt.sourceInformation(composer3, "135@6301L366");
                                        SnackbarKt.m2850OneRowSnackbarkKq0p4A(function111111111115, function111111111114, function111111111116, value2, j1111111118, j1111111119, composer3, 0);
                                        composer3.endReplaceGroup();
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer3.skipToGroupEnd();
                            }
                        }, composer2, 54), composer2, ProvidedValue.$stable | 48);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                            return;
                        }
                        return;
                    }
                    composer2.skipToGroupEnd();
                }
            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i11111114 & 7168) | i11111113 | (i11111114 & 112) | (i11111114 & 896), 80);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            function8 = function111111111113;
            modifier2 = companion;
            shape3 = shape2;
            z3 = z1111113;
            j5 = contentColor;
            j6 = dismissActionContentColor;
            j7 = actionContentColor;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i12 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i13 != 0) {
                    function5 = null;
                }
                if (i4 == 0) {
                }
                if (i6 != 0) {
                    z2 = false;
                } else {
                    z2 = z;
                }
                if ((i2 & 16) != 0) {
                    shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    i3 &= -57345;
                } else {
                    shape2 = shape;
                }
                if ((i2 & 32) != 0) {
                    color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                    i3 &= -458753;
                }
                if ((i2 & 64) != 0) {
                    contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                    i3 &= -3670017;
                } else {
                    contentColor = j2;
                }
                if ((i2 & Fields.SpotShadowColor) != 0) {
                    actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                    i3 &= -29360129;
                } else {
                    actionContentColor = j3;
                }
                if ((i2 & Fields.RotationX) != 0) {
                    i3 &= -234881025;
                    dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                }
            } else {
                if (i12 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i13 != 0) {
                    function5 = null;
                }
                if (i4 == 0) {
                }
                if (i6 != 0) {
                    z2 = false;
                } else {
                    z2 = z;
                }
                if ((i2 & 16) != 0) {
                    shape2 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    i3 &= -57345;
                } else {
                    shape2 = shape;
                }
                if ((i2 & 32) != 0) {
                    color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                    i3 &= -458753;
                }
                if ((i2 & 64) != 0) {
                    contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                    i3 &= -3670017;
                } else {
                    contentColor = j2;
                }
                if ((i2 & Fields.SpotShadowColor) != 0) {
                    actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                    i3 &= -29360129;
                } else {
                    actionContentColor = j3;
                }
                if ((i2 & Fields.RotationX) != 0) {
                    i3 &= -234881025;
                    dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1235788955, i3, -1, "androidx.compose.material3.Snackbar (Snackbar.kt:113)");
            }
            final boolean z1111114 = z2;
            final Function2<? super Composer, ? super Integer, Unit> function111111111114 = function5;
            final Function2<? super Composer, ? super Integer, Unit> function111111111115 = function7;
            final long j1111111118 = actionContentColor;
            final long j1111111119 = dismissActionContentColor;
            Function2<? super Composer, ? super Integer, Unit> function111111111116 = function7;
            boolean z1111115 = z2;
            int i11111115 = (i3 & 14) | 12779520;
            int i11111116 = i3 >> 9;
            SurfaceKt.m2868SurfaceT9BRK9s(companion, shape2, color, contentColor, 0.0f, SnackbarTokens.INSTANCE.m3866getContainerElevationD9Ej5fM(), null, ComposableLambdaKt.rememberComposableLambda(-1829663446, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i11111117) {
                    ComposerKt.sourceInformation(composer2, "C121@5634L5,122@5705L5,123@5779L912,123@5719L972:Snackbar.kt#uh7d8r");
                    if ((i11111117 & 3) != 2 || !composer2.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1829663446, i11111117, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:121)");
                        }
                        TextStyle value = TypographyKt.getValue(SnackbarTokens.INSTANCE.getSupportingTextFont(), composer2, 6);
                        final TextStyle value2 = TypographyKt.getValue(SnackbarTokens.INSTANCE.getActionLabelTextFont(), composer2, 6);
                        ProvidedValue<TextStyle> providedValueProvides = TextKt.getLocalTextStyle().provides(value);
                        final boolean z1111116 = z1111114;
                        final Function2<? super Composer, ? super Integer, Unit> function111111111117 = function111111111114;
                        final Function2<? super Composer, ? super Integer, Unit> function111111111118 = function4;
                        final Function2<? super Composer, ? super Integer, Unit> function111111111119 = function111111111115;
                        final long j11111111110 = j1111111118;
                        final long j11111111111 = j1111111119;
                        CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>) providedValueProvides, (Function2<? super Composer, ? super Integer, Unit>) ComposableLambdaKt.rememberComposableLambda(835891690, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer3, int i11111118) {
                                ComposerKt.sourceInformation(composer3, "C:Snackbar.kt#uh7d8r");
                                if ((i11111118 & 3) != 2 || !composer3.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(835891690, i11111118, -1, "androidx.compose.material3.Snackbar.<anonymous>.<anonymous> (Snackbar.kt:124)");
                                    }
                                    if (z1111116 && function111111111117 != null) {
                                        composer3.startReplaceGroup(-810715387);
                                        ComposerKt.sourceInformation(composer3, "126@5873L383");
                                        SnackbarKt.m2849NewLineButtonSnackbarkKq0p4A(function111111111118, function111111111117, function111111111119, value2, j11111111110, j11111111111, composer3, 0);
                                        composer3.endReplaceGroup();
                                    } else {
                                        composer3.startReplaceGroup(-810701708);
                                        ComposerKt.sourceInformation(composer3, "135@6301L366");
                                        SnackbarKt.m2850OneRowSnackbarkKq0p4A(function111111111118, function111111111117, function111111111119, value2, j11111111110, j11111111111, composer3, 0);
                                        composer3.endReplaceGroup();
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer3.skipToGroupEnd();
                            }
                        }, composer2, 54), composer2, ProvidedValue.$stable | 48);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                            return;
                        }
                        return;
                    }
                    composer2.skipToGroupEnd();
                }
            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i11111116 & 7168) | i11111115 | (i11111116 & 112) | (i11111116 & 896), 80);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            function8 = function111111111116;
            modifier2 = companion;
            shape3 = shape2;
            z3 = z1111115;
            j5 = contentColor;
            j6 = dismissActionContentColor;
            j7 = actionContentColor;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier18 = modifier2;
            final Function2<? super Composer, ? super Integer, Unit> function111111111117 = function5;
            final long j11111111110 = color;
            final long j11111111111 = j6;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i11111117) {
                    SnackbarKt.m2851SnackbareQBnUkQ(modifier18, function111111111117, function8, z3, shape3, j11111111110, j5, j7, j11111111111, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void m2852SnackbarsDKtq54(final SnackbarData snackbarData, Modifier modifier, boolean z, Shape shape, long j, long j2, long j3, long j4, long j5, Composer composer, final int i, final int i2) {
        int i3;
        Modifier modifier2;
        int i4;
        boolean z2;
        int i5;
        Shape shape2;
        long j6;
        long j7;
        Modifier.Companion companion;
        boolean z3;
        Shape shape3;
        long color;
        long contentColor;
        final long actionColor;
        long actionContentColor;
        long dismissActionContentColor;
        long j8;
        final String actionLabel;
        final SnackbarData snackbarData2;
        ComposableLambda composableLambdaRememberComposableLambda;
        ComposableLambda composableLambdaRememberComposableLambda2;
        long j9;
        final boolean z4;
        final Shape shape4;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i6;
        int i7;
        int i8;
        int i9;
        int i10;
        Composer composerStartRestartGroup = composer.startRestartGroup(274621471);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(Snackbar)P(8,6,2,7,3:c#ui.graphics.Color,4:c#ui.graphics.Color,0:c#ui.graphics.Color,1:c#ui.graphics.Color,5:c#ui.graphics.Color)205@9602L5,206@9654L5,207@9704L12,208@9760L11,209@9822L18,210@9898L25,251@11371L38,241@10959L456:Snackbar.kt#uh7d8r");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changed(snackbarData) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i11 = i2 & 2;
        if (i11 == 0) {
            if ((i & 48) == 0) {
                modifier2 = modifier;
                i3 |= composerStartRestartGroup.changed(modifier2) ? 32 : 16;
            }
            i4 = i2 & 4;
            if (i4 != 0) {
                if ((i & 384) == 0) {
                    z2 = z;
                    if (composerStartRestartGroup.changed(z2)) {
                        i5 = Fields.RotationX;
                    } else {
                        i5 = Fields.SpotShadowColor;
                    }
                    i3 |= i5;
                }
                if ((i & 3072) == 0) {
                    if ((i2 & 8) == 0) {
                        shape2 = shape;
                        if (composerStartRestartGroup.changed(shape2)) {
                            i10 = Fields.CameraDistance;
                        }
                        i3 |= i10;
                    } else {
                        shape2 = shape;
                    }
                    i10 = Fields.RotationZ;
                    i3 |= i10;
                } else {
                    shape2 = shape;
                }
                if ((i & 24576) == 0) {
                    if ((i2 & 16) == 0) {
                        j6 = j;
                        if (composerStartRestartGroup.changed(j6)) {
                            i9 = Fields.Clip;
                        }
                        i3 |= i9;
                    } else {
                        j6 = j;
                    }
                    i9 = Fields.Shape;
                    i3 |= i9;
                } else {
                    j6 = j;
                }
                if ((196608 & i) == 0) {
                    if ((i2 & 32) == 0) {
                        j7 = j2;
                        int i12 = composerStartRestartGroup.changed(j7) ? Fields.RenderEffect : 65536;
                        i3 |= i12;
                    } else {
                        j7 = j2;
                    }
                    i3 |= i12;
                } else {
                    j7 = j2;
                }
                if ((1572864 & i) != 0) {
                    if ((i2 & 64) == 0 || !composerStartRestartGroup.changed(j3)) {
                        i8 = 524288;
                    } else {
                        i8 = 1048576;
                    }
                    i3 |= i8;
                }
                if ((i & 12582912) != 0) {
                    if ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(j4)) {
                        i7 = 4194304;
                    } else {
                        i7 = 8388608;
                    }
                    i3 |= i7;
                }
                if ((100663296 & i) != 0) {
                    if ((i2 & Fields.RotationX) == 0 || !composerStartRestartGroup.changed(j5)) {
                        i6 = 33554432;
                    } else {
                        i6 = 67108864;
                    }
                    i3 |= i6;
                }
                if ((38347923 & i3) == 38347922 || !composerStartRestartGroup.getSkipping()) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                        if (i11 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i4 != 0) {
                            z3 = false;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 8) != 0) {
                            shape3 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i3 &= -7169;
                        } else {
                            shape3 = shape2;
                        }
                        if ((i2 & 16) != 0) {
                            color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                            i3 &= -57345;
                        } else {
                            color = j6;
                        }
                        if ((i2 & 32) != 0) {
                            contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        } else {
                            contentColor = j7;
                        }
                        if ((i2 & 64) != 0) {
                            actionColor = SnackbarDefaults.INSTANCE.getActionColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            actionColor = j3;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            actionContentColor = j4;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            i3 &= -234881025;
                            j8 = actionContentColor;
                            dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                        } else {
                            dismissActionContentColor = j5;
                            j8 = actionContentColor;
                        }
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                        }
                        if ((i2 & 32) != 0) {
                            i3 &= -458753;
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            i3 &= -29360129;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            i3 &= -234881025;
                        }
                        j8 = j4;
                        dismissActionContentColor = j5;
                        companion = modifier2;
                        z3 = z2;
                        shape3 = shape2;
                        color = j6;
                        contentColor = j7;
                        actionColor = j3;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(274621471, i3, -1, "androidx.compose.material3.Snackbar (Snackbar.kt:211)");
                    }
                    actionLabel = snackbarData.getVisuals().getActionLabel();
                    composerStartRestartGroup.startReplaceGroup(1561344786);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "215@10097L267");
                    if (actionLabel != null) {
                        snackbarData2 = snackbarData;
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-1378313599, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i13) {
                                ComposerKt.sourceInformation(composer2, "C217@10171L44,218@10247L32,219@10311L21,216@10115L235:Snackbar.kt#uh7d8r");
                                if ((i13 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1378313599, i13, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:216)");
                                    }
                                    ButtonColors buttonColorsM2061textButtonColorsro_MJ88 = ButtonDefaults.INSTANCE.m2061textButtonColorsro_MJ88(0L, actionColor, 0L, 0L, composer2, 24576, 13);
                                    ComposerKt.sourceInformationMarkerStart(composer2, 642119911, "CC(remember):Snackbar.kt#9igjgp");
                                    boolean zChanged = composer2.changed(snackbarData2);
                                    final SnackbarData snackbarData3 = snackbarData2;
                                    Object objRememberedValue = composer2.rememberedValue();
                                    if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                        objRememberedValue = (Function0) new Function0<Unit>() {
                                            {
                                                super(0);
                                            }

                                            public Object invoke() {
                                                m2855invoke();
                                                return Unit.INSTANCE;
                                            }

                                            public final void m2855invoke() {
                                                snackbarData3.performAction();
                                            }
                                        };
                                        composer2.updateRememberedValue(objRememberedValue);
                                    }
                                    Function0 function0 = (Function0) objRememberedValue;
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    final String str = actionLabel;
                                    ButtonKt.TextButton(function0, null, false, null, buttonColorsM2061textButtonColorsro_MJ88, null, null, null, null, ComposableLambdaKt.rememberComposableLambda(521110564, true, new Function3<RowScope, Composer, Integer, Unit>() {
                                        {
                                            super(3);
                                        }

                                        public Object invoke(Object obj, Object obj2, Object obj3) {
                                            invoke((RowScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(RowScope rowScope, Composer composer3, int i14) {
                                            ComposerKt.sourceInformation(composer3, "C219@10313L17:Snackbar.kt#uh7d8r");
                                            if ((i14 & 17) == 16 && composer3.getSkipping()) {
                                                composer3.skipToGroupEnd();
                                                return;
                                            }
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(521110564, i14, -1, "androidx.compose.material3.Snackbar.<anonymous>.<anonymous> (Snackbar.kt:219)");
                                            }
                                            TextKt.m3021Text4IGK_g(str, (Modifier) null, 0L, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1<? super TextLayoutResult, Unit>) null, (TextStyle) null, composer3, 0, 0, 131070);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                            }
                                        }
                                    }, composer2, 54), composer2, 805306368, 494);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                    } else {
                        snackbarData2 = snackbarData;
                        composableLambdaRememberComposableLambda = null;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    composerStartRestartGroup.startReplaceGroup(1561358724);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "227@10548L362");
                    if (snackbarData.getVisuals().getWithDismissAction()) {
                        composableLambdaRememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-1812633777, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i13) {
                                ComposerKt.sourceInformation(composer2, "C229@10608L26,228@10566L330:Snackbar.kt#uh7d8r");
                                if ((i13 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1812633777, i13, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:228)");
                                    }
                                    ComposerKt.sourceInformationMarkerStart(composer2, 642131457, "CC(remember):Snackbar.kt#9igjgp");
                                    boolean zChanged = composer2.changed(snackbarData2);
                                    final SnackbarData snackbarData3 = snackbarData2;
                                    Object objRememberedValue = composer2.rememberedValue();
                                    if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                        objRememberedValue = (Function0) new Function0<Unit>() {
                                            {
                                                super(0);
                                            }

                                            public Object invoke() {
                                                m2856invoke();
                                                return Unit.INSTANCE;
                                            }

                                            public final void m2856invoke() {
                                                snackbarData3.dismiss();
                                            }
                                        };
                                        composer2.updateRememberedValue(objRememberedValue);
                                    }
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    IconButtonKt.IconButton((Function0) objRememberedValue, null, false, null, null, ComposableSingletons$SnackbarKt.INSTANCE.m2227getLambda1$material3_release(), composer2, 196608, 30);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                    } else {
                        composableLambdaRememberComposableLambda2 = null;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    int i13 = i3 << 3;
                    m2851SnackbareQBnUkQ(PaddingKt.m1035padding3ABfNKs(companion, Dp.constructor-impl(12)), composableLambdaRememberComposableLambda, composableLambdaRememberComposableLambda2, z3, shape3, color, contentColor, j8, dismissActionContentColor, ComposableLambdaKt.rememberComposableLambda(-1266389126, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i14) {
                            ComposerKt.sourceInformation(composer2, "C251@11373L34:Snackbar.kt#uh7d8r");
                            if ((i14 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1266389126, i14, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:251)");
                            }
                            TextKt.m3021Text4IGK_g(snackbarData2.getVisuals().getMessage(), (Modifier) null, 0L, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1<? super TextLayoutResult, Unit>) null, (TextStyle) null, composer2, 0, 0, 131070);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i13 & 3670016) | (i13 & 7168) | 805306368 | (57344 & i13) | (458752 & i13) | (29360128 & i3) | (i3 & 234881024), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    j9 = actionColor;
                    z4 = z3;
                    shape4 = shape3;
                    modifier2 = companion;
                } else {
                    composerStartRestartGroup.skipToGroupEnd();
                    j8 = j4;
                    dismissActionContentColor = j5;
                    z4 = z2;
                    shape4 = shape2;
                    color = j6;
                    contentColor = j7;
                    j9 = j3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier3 = modifier2;
                    final long j10 = color;
                    final long j11 = contentColor;
                    final long j12 = j9;
                    final long j13 = j8;
                    final long j14 = dismissActionContentColor;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i14) {
                            SnackbarKt.m2852SnackbarsDKtq54(snackbarData, modifier3, z4, shape4, j10, j11, j12, j13, j14, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 384;
            z2 = z;
            if ((i & 3072) == 0) {
                if ((i2 & 8) == 0) {
                    shape2 = shape;
                    if (composerStartRestartGroup.changed(shape2)) {
                        i10 = Fields.CameraDistance;
                    }
                    i3 |= i10;
                } else {
                    shape2 = shape;
                }
                i10 = Fields.RotationZ;
                i3 |= i10;
            } else {
                shape2 = shape;
            }
            if ((i & 24576) == 0) {
                if ((i2 & 16) == 0) {
                    j6 = j;
                    if (composerStartRestartGroup.changed(j6)) {
                        i9 = Fields.Clip;
                    }
                    i3 |= i9;
                } else {
                    j6 = j;
                }
                i9 = Fields.Shape;
                i3 |= i9;
            } else {
                j6 = j;
            }
            if ((196608 & i) == 0) {
                if ((i2 & 32) == 0) {
                    j7 = j2;
                    if (composerStartRestartGroup.changed(j7)) {
                    }
                    i3 |= i12;
                } else {
                    j7 = j2;
                }
                i3 |= i12;
            } else {
                j7 = j2;
            }
            if ((1572864 & i) != 0) {
                if ((i2 & 64) == 0) {
                    i8 = 524288;
                } else {
                    i8 = 524288;
                }
                i3 |= i8;
            }
            if ((i & 12582912) != 0) {
                if ((i2 & Fields.SpotShadowColor) == 0) {
                    i7 = 4194304;
                } else {
                    i7 = 4194304;
                }
                i3 |= i7;
            }
            if ((100663296 & i) != 0) {
                if ((i2 & Fields.RotationX) == 0) {
                    i6 = 33554432;
                } else {
                    i6 = 33554432;
                }
                i3 |= i6;
            }
            if ((38347923 & i3) == 38347922) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        z3 = false;
                    } else {
                        z3 = z2;
                    }
                    if ((i2 & 8) != 0) {
                        shape3 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i3 &= -7169;
                    } else {
                        shape3 = shape2;
                    }
                    if ((i2 & 16) != 0) {
                        color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        color = j6;
                    }
                    if ((i2 & 32) != 0) {
                        contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    } else {
                        contentColor = j7;
                    }
                    if ((i2 & 64) != 0) {
                        actionColor = SnackbarDefaults.INSTANCE.getActionColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        actionColor = j3;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        actionContentColor = j4;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        i3 &= -234881025;
                        j8 = actionContentColor;
                        dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                    } else {
                        dismissActionContentColor = j5;
                        j8 = actionContentColor;
                    }
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        z3 = false;
                    } else {
                        z3 = z2;
                    }
                    if ((i2 & 8) != 0) {
                        shape3 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i3 &= -7169;
                    } else {
                        shape3 = shape2;
                    }
                    if ((i2 & 16) != 0) {
                        color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        color = j6;
                    }
                    if ((i2 & 32) != 0) {
                        contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    } else {
                        contentColor = j7;
                    }
                    if ((i2 & 64) != 0) {
                        actionColor = SnackbarDefaults.INSTANCE.getActionColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        actionColor = j3;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        actionContentColor = j4;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        i3 &= -234881025;
                        j8 = actionContentColor;
                        dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                    } else {
                        dismissActionContentColor = j5;
                        j8 = actionContentColor;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(274621471, i3, -1, "androidx.compose.material3.Snackbar (Snackbar.kt:211)");
                }
                actionLabel = snackbarData.getVisuals().getActionLabel();
                composerStartRestartGroup.startReplaceGroup(1561344786);
                ComposerKt.sourceInformation(composerStartRestartGroup, "215@10097L267");
                if (actionLabel != null) {
                    snackbarData2 = snackbarData;
                    composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-1378313599, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i14) {
                            ComposerKt.sourceInformation(composer2, "C217@10171L44,218@10247L32,219@10311L21,216@10115L235:Snackbar.kt#uh7d8r");
                            if ((i14 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1378313599, i14, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:216)");
                                }
                                ButtonColors buttonColorsM2061textButtonColorsro_MJ88 = ButtonDefaults.INSTANCE.m2061textButtonColorsro_MJ88(0L, actionColor, 0L, 0L, composer2, 24576, 13);
                                ComposerKt.sourceInformationMarkerStart(composer2, 642119911, "CC(remember):Snackbar.kt#9igjgp");
                                boolean zChanged = composer2.changed(snackbarData2);
                                final SnackbarData snackbarData3 = snackbarData2;
                                Object objRememberedValue = composer2.rememberedValue();
                                if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue = (Function0) new Function0<Unit>() {
                                        {
                                            super(0);
                                        }

                                        public Object invoke() {
                                            m2855invoke();
                                            return Unit.INSTANCE;
                                        }

                                        public final void m2855invoke() {
                                            snackbarData3.performAction();
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue);
                                }
                                Function0 function0 = (Function0) objRememberedValue;
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                final String str = actionLabel;
                                ButtonKt.TextButton(function0, null, false, null, buttonColorsM2061textButtonColorsro_MJ88, null, null, null, null, ComposableLambdaKt.rememberComposableLambda(521110564, true, new Function3<RowScope, Composer, Integer, Unit>() {
                                    {
                                        super(3);
                                    }

                                    public Object invoke(Object obj, Object obj2, Object obj3) {
                                        invoke((RowScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(RowScope rowScope, Composer composer3, int i15) {
                                        ComposerKt.sourceInformation(composer3, "C219@10313L17:Snackbar.kt#uh7d8r");
                                        if ((i15 & 17) == 16 && composer3.getSkipping()) {
                                            composer3.skipToGroupEnd();
                                            return;
                                        }
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(521110564, i15, -1, "androidx.compose.material3.Snackbar.<anonymous>.<anonymous> (Snackbar.kt:219)");
                                        }
                                        TextKt.m3021Text4IGK_g(str, (Modifier) null, 0L, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1<? super TextLayoutResult, Unit>) null, (TextStyle) null, composer3, 0, 0, 131070);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                        }
                                    }
                                }, composer2, 54), composer2, 805306368, 494);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                } else {
                    snackbarData2 = snackbarData;
                    composableLambdaRememberComposableLambda = null;
                }
                composerStartRestartGroup.endReplaceGroup();
                composerStartRestartGroup.startReplaceGroup(1561358724);
                ComposerKt.sourceInformation(composerStartRestartGroup, "227@10548L362");
                if (snackbarData.getVisuals().getWithDismissAction()) {
                    composableLambdaRememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-1812633777, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i14) {
                            ComposerKt.sourceInformation(composer2, "C229@10608L26,228@10566L330:Snackbar.kt#uh7d8r");
                            if ((i14 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1812633777, i14, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:228)");
                                }
                                ComposerKt.sourceInformationMarkerStart(composer2, 642131457, "CC(remember):Snackbar.kt#9igjgp");
                                boolean zChanged = composer2.changed(snackbarData2);
                                final SnackbarData snackbarData3 = snackbarData2;
                                Object objRememberedValue = composer2.rememberedValue();
                                if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue = (Function0) new Function0<Unit>() {
                                        {
                                            super(0);
                                        }

                                        public Object invoke() {
                                            m2856invoke();
                                            return Unit.INSTANCE;
                                        }

                                        public final void m2856invoke() {
                                            snackbarData3.dismiss();
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                IconButtonKt.IconButton((Function0) objRememberedValue, null, false, null, null, ComposableSingletons$SnackbarKt.INSTANCE.m2227getLambda1$material3_release(), composer2, 196608, 30);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                } else {
                    composableLambdaRememberComposableLambda2 = null;
                }
                composerStartRestartGroup.endReplaceGroup();
                int i14 = i3 << 3;
                m2851SnackbareQBnUkQ(PaddingKt.m1035padding3ABfNKs(companion, Dp.constructor-impl(12)), composableLambdaRememberComposableLambda, composableLambdaRememberComposableLambda2, z3, shape3, color, contentColor, j8, dismissActionContentColor, ComposableLambdaKt.rememberComposableLambda(-1266389126, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i15) {
                        ComposerKt.sourceInformation(composer2, "C251@11373L34:Snackbar.kt#uh7d8r");
                        if ((i15 & 3) == 2 && composer2.getSkipping()) {
                            composer2.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1266389126, i15, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:251)");
                        }
                        TextKt.m3021Text4IGK_g(snackbarData2.getVisuals().getMessage(), (Modifier) null, 0L, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1<? super TextLayoutResult, Unit>) null, (TextStyle) null, composer2, 0, 0, 131070);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i14 & 3670016) | (i14 & 7168) | 805306368 | (57344 & i14) | (458752 & i14) | (29360128 & i3) | (i3 & 234881024), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                j9 = actionColor;
                z4 = z3;
                shape4 = shape3;
                modifier2 = companion;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        z3 = false;
                    } else {
                        z3 = z2;
                    }
                    if ((i2 & 8) != 0) {
                        shape3 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i3 &= -7169;
                    } else {
                        shape3 = shape2;
                    }
                    if ((i2 & 16) != 0) {
                        color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        color = j6;
                    }
                    if ((i2 & 32) != 0) {
                        contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    } else {
                        contentColor = j7;
                    }
                    if ((i2 & 64) != 0) {
                        actionColor = SnackbarDefaults.INSTANCE.getActionColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        actionColor = j3;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        actionContentColor = j4;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        i3 &= -234881025;
                        j8 = actionContentColor;
                        dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                    } else {
                        dismissActionContentColor = j5;
                        j8 = actionContentColor;
                    }
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        z3 = false;
                    } else {
                        z3 = z2;
                    }
                    if ((i2 & 8) != 0) {
                        shape3 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i3 &= -7169;
                    } else {
                        shape3 = shape2;
                    }
                    if ((i2 & 16) != 0) {
                        color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        color = j6;
                    }
                    if ((i2 & 32) != 0) {
                        contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    } else {
                        contentColor = j7;
                    }
                    if ((i2 & 64) != 0) {
                        actionColor = SnackbarDefaults.INSTANCE.getActionColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        actionColor = j3;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        actionContentColor = j4;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        i3 &= -234881025;
                        j8 = actionContentColor;
                        dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                    } else {
                        dismissActionContentColor = j5;
                        j8 = actionContentColor;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(274621471, i3, -1, "androidx.compose.material3.Snackbar (Snackbar.kt:211)");
                }
                actionLabel = snackbarData.getVisuals().getActionLabel();
                composerStartRestartGroup.startReplaceGroup(1561344786);
                ComposerKt.sourceInformation(composerStartRestartGroup, "215@10097L267");
                if (actionLabel != null) {
                    snackbarData2 = snackbarData;
                    composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-1378313599, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i15) {
                            ComposerKt.sourceInformation(composer2, "C217@10171L44,218@10247L32,219@10311L21,216@10115L235:Snackbar.kt#uh7d8r");
                            if ((i15 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1378313599, i15, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:216)");
                                }
                                ButtonColors buttonColorsM2061textButtonColorsro_MJ88 = ButtonDefaults.INSTANCE.m2061textButtonColorsro_MJ88(0L, actionColor, 0L, 0L, composer2, 24576, 13);
                                ComposerKt.sourceInformationMarkerStart(composer2, 642119911, "CC(remember):Snackbar.kt#9igjgp");
                                boolean zChanged = composer2.changed(snackbarData2);
                                final SnackbarData snackbarData3 = snackbarData2;
                                Object objRememberedValue = composer2.rememberedValue();
                                if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue = (Function0) new Function0<Unit>() {
                                        {
                                            super(0);
                                        }

                                        public Object invoke() {
                                            m2855invoke();
                                            return Unit.INSTANCE;
                                        }

                                        public final void m2855invoke() {
                                            snackbarData3.performAction();
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue);
                                }
                                Function0 function0 = (Function0) objRememberedValue;
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                final String str = actionLabel;
                                ButtonKt.TextButton(function0, null, false, null, buttonColorsM2061textButtonColorsro_MJ88, null, null, null, null, ComposableLambdaKt.rememberComposableLambda(521110564, true, new Function3<RowScope, Composer, Integer, Unit>() {
                                    {
                                        super(3);
                                    }

                                    public Object invoke(Object obj, Object obj2, Object obj3) {
                                        invoke((RowScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(RowScope rowScope, Composer composer3, int i16) {
                                        ComposerKt.sourceInformation(composer3, "C219@10313L17:Snackbar.kt#uh7d8r");
                                        if ((i16 & 17) == 16 && composer3.getSkipping()) {
                                            composer3.skipToGroupEnd();
                                            return;
                                        }
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(521110564, i16, -1, "androidx.compose.material3.Snackbar.<anonymous>.<anonymous> (Snackbar.kt:219)");
                                        }
                                        TextKt.m3021Text4IGK_g(str, (Modifier) null, 0L, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1<? super TextLayoutResult, Unit>) null, (TextStyle) null, composer3, 0, 0, 131070);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                        }
                                    }
                                }, composer2, 54), composer2, 805306368, 494);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                } else {
                    snackbarData2 = snackbarData;
                    composableLambdaRememberComposableLambda = null;
                }
                composerStartRestartGroup.endReplaceGroup();
                composerStartRestartGroup.startReplaceGroup(1561358724);
                ComposerKt.sourceInformation(composerStartRestartGroup, "227@10548L362");
                if (snackbarData.getVisuals().getWithDismissAction()) {
                    composableLambdaRememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-1812633777, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i15) {
                            ComposerKt.sourceInformation(composer2, "C229@10608L26,228@10566L330:Snackbar.kt#uh7d8r");
                            if ((i15 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1812633777, i15, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:228)");
                                }
                                ComposerKt.sourceInformationMarkerStart(composer2, 642131457, "CC(remember):Snackbar.kt#9igjgp");
                                boolean zChanged = composer2.changed(snackbarData2);
                                final SnackbarData snackbarData3 = snackbarData2;
                                Object objRememberedValue = composer2.rememberedValue();
                                if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue = (Function0) new Function0<Unit>() {
                                        {
                                            super(0);
                                        }

                                        public Object invoke() {
                                            m2856invoke();
                                            return Unit.INSTANCE;
                                        }

                                        public final void m2856invoke() {
                                            snackbarData3.dismiss();
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                IconButtonKt.IconButton((Function0) objRememberedValue, null, false, null, null, ComposableSingletons$SnackbarKt.INSTANCE.m2227getLambda1$material3_release(), composer2, 196608, 30);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                } else {
                    composableLambdaRememberComposableLambda2 = null;
                }
                composerStartRestartGroup.endReplaceGroup();
                int i15 = i3 << 3;
                m2851SnackbareQBnUkQ(PaddingKt.m1035padding3ABfNKs(companion, Dp.constructor-impl(12)), composableLambdaRememberComposableLambda, composableLambdaRememberComposableLambda2, z3, shape3, color, contentColor, j8, dismissActionContentColor, ComposableLambdaKt.rememberComposableLambda(-1266389126, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i16) {
                        ComposerKt.sourceInformation(composer2, "C251@11373L34:Snackbar.kt#uh7d8r");
                        if ((i16 & 3) == 2 && composer2.getSkipping()) {
                            composer2.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1266389126, i16, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:251)");
                        }
                        TextKt.m3021Text4IGK_g(snackbarData2.getVisuals().getMessage(), (Modifier) null, 0L, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1<? super TextLayoutResult, Unit>) null, (TextStyle) null, composer2, 0, 0, 131070);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i15 & 3670016) | (i15 & 7168) | 805306368 | (57344 & i15) | (458752 & i15) | (29360128 & i3) | (i3 & 234881024), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                j9 = actionColor;
                z4 = z3;
                shape4 = shape3;
                modifier2 = companion;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier4 = modifier2;
                final long j15 = color;
                final long j16 = contentColor;
                final long j17 = j9;
                final long j18 = j8;
                final long j19 = dismissActionContentColor;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i16) {
                        SnackbarKt.m2852SnackbarsDKtq54(snackbarData, modifier4, z4, shape4, j15, j16, j17, j18, j19, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        modifier2 = modifier;
        i4 = i2 & 4;
        if (i4 != 0) {
            if ((i & 384) == 0) {
                z2 = z;
                if (composerStartRestartGroup.changed(z2)) {
                    i5 = Fields.RotationX;
                } else {
                    i5 = Fields.SpotShadowColor;
                }
                i3 |= i5;
            }
            if ((i & 3072) == 0) {
                if ((i2 & 8) == 0) {
                    shape2 = shape;
                    if (composerStartRestartGroup.changed(shape2)) {
                        i10 = Fields.CameraDistance;
                    }
                    i3 |= i10;
                } else {
                    shape2 = shape;
                }
                i10 = Fields.RotationZ;
                i3 |= i10;
            } else {
                shape2 = shape;
            }
            if ((i & 24576) == 0) {
                if ((i2 & 16) == 0) {
                    j6 = j;
                    if (composerStartRestartGroup.changed(j6)) {
                        i9 = Fields.Clip;
                    }
                    i3 |= i9;
                } else {
                    j6 = j;
                }
                i9 = Fields.Shape;
                i3 |= i9;
            } else {
                j6 = j;
            }
            if ((196608 & i) == 0) {
                if ((i2 & 32) == 0) {
                    j7 = j2;
                    if (composerStartRestartGroup.changed(j7)) {
                    }
                    i3 |= i12;
                } else {
                    j7 = j2;
                }
                i3 |= i12;
            } else {
                j7 = j2;
            }
            if ((1572864 & i) != 0) {
                if ((i2 & 64) == 0) {
                    i8 = 524288;
                } else {
                    i8 = 524288;
                }
                i3 |= i8;
            }
            if ((i & 12582912) != 0) {
                if ((i2 & Fields.SpotShadowColor) == 0) {
                    i7 = 4194304;
                } else {
                    i7 = 4194304;
                }
                i3 |= i7;
            }
            if ((100663296 & i) != 0) {
                if ((i2 & Fields.RotationX) == 0) {
                    i6 = 33554432;
                } else {
                    i6 = 33554432;
                }
                i3 |= i6;
            }
            if ((38347923 & i3) == 38347922) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        z3 = false;
                    } else {
                        z3 = z2;
                    }
                    if ((i2 & 8) != 0) {
                        shape3 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i3 &= -7169;
                    } else {
                        shape3 = shape2;
                    }
                    if ((i2 & 16) != 0) {
                        color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        color = j6;
                    }
                    if ((i2 & 32) != 0) {
                        contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    } else {
                        contentColor = j7;
                    }
                    if ((i2 & 64) != 0) {
                        actionColor = SnackbarDefaults.INSTANCE.getActionColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        actionColor = j3;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        actionContentColor = j4;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        i3 &= -234881025;
                        j8 = actionContentColor;
                        dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                    } else {
                        dismissActionContentColor = j5;
                        j8 = actionContentColor;
                    }
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        z3 = false;
                    } else {
                        z3 = z2;
                    }
                    if ((i2 & 8) != 0) {
                        shape3 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i3 &= -7169;
                    } else {
                        shape3 = shape2;
                    }
                    if ((i2 & 16) != 0) {
                        color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        color = j6;
                    }
                    if ((i2 & 32) != 0) {
                        contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    } else {
                        contentColor = j7;
                    }
                    if ((i2 & 64) != 0) {
                        actionColor = SnackbarDefaults.INSTANCE.getActionColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        actionColor = j3;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        actionContentColor = j4;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        i3 &= -234881025;
                        j8 = actionContentColor;
                        dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                    } else {
                        dismissActionContentColor = j5;
                        j8 = actionContentColor;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(274621471, i3, -1, "androidx.compose.material3.Snackbar (Snackbar.kt:211)");
                }
                actionLabel = snackbarData.getVisuals().getActionLabel();
                composerStartRestartGroup.startReplaceGroup(1561344786);
                ComposerKt.sourceInformation(composerStartRestartGroup, "215@10097L267");
                if (actionLabel != null) {
                    snackbarData2 = snackbarData;
                    composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-1378313599, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i16) {
                            ComposerKt.sourceInformation(composer2, "C217@10171L44,218@10247L32,219@10311L21,216@10115L235:Snackbar.kt#uh7d8r");
                            if ((i16 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1378313599, i16, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:216)");
                                }
                                ButtonColors buttonColorsM2061textButtonColorsro_MJ88 = ButtonDefaults.INSTANCE.m2061textButtonColorsro_MJ88(0L, actionColor, 0L, 0L, composer2, 24576, 13);
                                ComposerKt.sourceInformationMarkerStart(composer2, 642119911, "CC(remember):Snackbar.kt#9igjgp");
                                boolean zChanged = composer2.changed(snackbarData2);
                                final SnackbarData snackbarData3 = snackbarData2;
                                Object objRememberedValue = composer2.rememberedValue();
                                if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue = (Function0) new Function0<Unit>() {
                                        {
                                            super(0);
                                        }

                                        public Object invoke() {
                                            m2855invoke();
                                            return Unit.INSTANCE;
                                        }

                                        public final void m2855invoke() {
                                            snackbarData3.performAction();
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue);
                                }
                                Function0 function0 = (Function0) objRememberedValue;
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                final String str = actionLabel;
                                ButtonKt.TextButton(function0, null, false, null, buttonColorsM2061textButtonColorsro_MJ88, null, null, null, null, ComposableLambdaKt.rememberComposableLambda(521110564, true, new Function3<RowScope, Composer, Integer, Unit>() {
                                    {
                                        super(3);
                                    }

                                    public Object invoke(Object obj, Object obj2, Object obj3) {
                                        invoke((RowScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(RowScope rowScope, Composer composer3, int i17) {
                                        ComposerKt.sourceInformation(composer3, "C219@10313L17:Snackbar.kt#uh7d8r");
                                        if ((i17 & 17) == 16 && composer3.getSkipping()) {
                                            composer3.skipToGroupEnd();
                                            return;
                                        }
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(521110564, i17, -1, "androidx.compose.material3.Snackbar.<anonymous>.<anonymous> (Snackbar.kt:219)");
                                        }
                                        TextKt.m3021Text4IGK_g(str, (Modifier) null, 0L, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1<? super TextLayoutResult, Unit>) null, (TextStyle) null, composer3, 0, 0, 131070);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                        }
                                    }
                                }, composer2, 54), composer2, 805306368, 494);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                } else {
                    snackbarData2 = snackbarData;
                    composableLambdaRememberComposableLambda = null;
                }
                composerStartRestartGroup.endReplaceGroup();
                composerStartRestartGroup.startReplaceGroup(1561358724);
                ComposerKt.sourceInformation(composerStartRestartGroup, "227@10548L362");
                if (snackbarData.getVisuals().getWithDismissAction()) {
                    composableLambdaRememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-1812633777, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i16) {
                            ComposerKt.sourceInformation(composer2, "C229@10608L26,228@10566L330:Snackbar.kt#uh7d8r");
                            if ((i16 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1812633777, i16, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:228)");
                                }
                                ComposerKt.sourceInformationMarkerStart(composer2, 642131457, "CC(remember):Snackbar.kt#9igjgp");
                                boolean zChanged = composer2.changed(snackbarData2);
                                final SnackbarData snackbarData3 = snackbarData2;
                                Object objRememberedValue = composer2.rememberedValue();
                                if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue = (Function0) new Function0<Unit>() {
                                        {
                                            super(0);
                                        }

                                        public Object invoke() {
                                            m2856invoke();
                                            return Unit.INSTANCE;
                                        }

                                        public final void m2856invoke() {
                                            snackbarData3.dismiss();
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                IconButtonKt.IconButton((Function0) objRememberedValue, null, false, null, null, ComposableSingletons$SnackbarKt.INSTANCE.m2227getLambda1$material3_release(), composer2, 196608, 30);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                } else {
                    composableLambdaRememberComposableLambda2 = null;
                }
                composerStartRestartGroup.endReplaceGroup();
                int i16 = i3 << 3;
                m2851SnackbareQBnUkQ(PaddingKt.m1035padding3ABfNKs(companion, Dp.constructor-impl(12)), composableLambdaRememberComposableLambda, composableLambdaRememberComposableLambda2, z3, shape3, color, contentColor, j8, dismissActionContentColor, ComposableLambdaKt.rememberComposableLambda(-1266389126, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i17) {
                        ComposerKt.sourceInformation(composer2, "C251@11373L34:Snackbar.kt#uh7d8r");
                        if ((i17 & 3) == 2 && composer2.getSkipping()) {
                            composer2.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1266389126, i17, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:251)");
                        }
                        TextKt.m3021Text4IGK_g(snackbarData2.getVisuals().getMessage(), (Modifier) null, 0L, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1<? super TextLayoutResult, Unit>) null, (TextStyle) null, composer2, 0, 0, 131070);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i16 & 3670016) | (i16 & 7168) | 805306368 | (57344 & i16) | (458752 & i16) | (29360128 & i3) | (i3 & 234881024), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                j9 = actionColor;
                z4 = z3;
                shape4 = shape3;
                modifier2 = companion;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        z3 = false;
                    } else {
                        z3 = z2;
                    }
                    if ((i2 & 8) != 0) {
                        shape3 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i3 &= -7169;
                    } else {
                        shape3 = shape2;
                    }
                    if ((i2 & 16) != 0) {
                        color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        color = j6;
                    }
                    if ((i2 & 32) != 0) {
                        contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    } else {
                        contentColor = j7;
                    }
                    if ((i2 & 64) != 0) {
                        actionColor = SnackbarDefaults.INSTANCE.getActionColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        actionColor = j3;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        actionContentColor = j4;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        i3 &= -234881025;
                        j8 = actionContentColor;
                        dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                    } else {
                        dismissActionContentColor = j5;
                        j8 = actionContentColor;
                    }
                } else {
                    if (i11 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i4 != 0) {
                        z3 = false;
                    } else {
                        z3 = z2;
                    }
                    if ((i2 & 8) != 0) {
                        shape3 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i3 &= -7169;
                    } else {
                        shape3 = shape2;
                    }
                    if ((i2 & 16) != 0) {
                        color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                        i3 &= -57345;
                    } else {
                        color = j6;
                    }
                    if ((i2 & 32) != 0) {
                        contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    } else {
                        contentColor = j7;
                    }
                    if ((i2 & 64) != 0) {
                        actionColor = SnackbarDefaults.INSTANCE.getActionColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        actionColor = j3;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        actionContentColor = j4;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        i3 &= -234881025;
                        j8 = actionContentColor;
                        dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                    } else {
                        dismissActionContentColor = j5;
                        j8 = actionContentColor;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(274621471, i3, -1, "androidx.compose.material3.Snackbar (Snackbar.kt:211)");
                }
                actionLabel = snackbarData.getVisuals().getActionLabel();
                composerStartRestartGroup.startReplaceGroup(1561344786);
                ComposerKt.sourceInformation(composerStartRestartGroup, "215@10097L267");
                if (actionLabel != null) {
                    snackbarData2 = snackbarData;
                    composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-1378313599, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i17) {
                            ComposerKt.sourceInformation(composer2, "C217@10171L44,218@10247L32,219@10311L21,216@10115L235:Snackbar.kt#uh7d8r");
                            if ((i17 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1378313599, i17, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:216)");
                                }
                                ButtonColors buttonColorsM2061textButtonColorsro_MJ88 = ButtonDefaults.INSTANCE.m2061textButtonColorsro_MJ88(0L, actionColor, 0L, 0L, composer2, 24576, 13);
                                ComposerKt.sourceInformationMarkerStart(composer2, 642119911, "CC(remember):Snackbar.kt#9igjgp");
                                boolean zChanged = composer2.changed(snackbarData2);
                                final SnackbarData snackbarData3 = snackbarData2;
                                Object objRememberedValue = composer2.rememberedValue();
                                if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue = (Function0) new Function0<Unit>() {
                                        {
                                            super(0);
                                        }

                                        public Object invoke() {
                                            m2855invoke();
                                            return Unit.INSTANCE;
                                        }

                                        public final void m2855invoke() {
                                            snackbarData3.performAction();
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue);
                                }
                                Function0 function0 = (Function0) objRememberedValue;
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                final String str = actionLabel;
                                ButtonKt.TextButton(function0, null, false, null, buttonColorsM2061textButtonColorsro_MJ88, null, null, null, null, ComposableLambdaKt.rememberComposableLambda(521110564, true, new Function3<RowScope, Composer, Integer, Unit>() {
                                    {
                                        super(3);
                                    }

                                    public Object invoke(Object obj, Object obj2, Object obj3) {
                                        invoke((RowScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(RowScope rowScope, Composer composer3, int i18) {
                                        ComposerKt.sourceInformation(composer3, "C219@10313L17:Snackbar.kt#uh7d8r");
                                        if ((i18 & 17) == 16 && composer3.getSkipping()) {
                                            composer3.skipToGroupEnd();
                                            return;
                                        }
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(521110564, i18, -1, "androidx.compose.material3.Snackbar.<anonymous>.<anonymous> (Snackbar.kt:219)");
                                        }
                                        TextKt.m3021Text4IGK_g(str, (Modifier) null, 0L, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1<? super TextLayoutResult, Unit>) null, (TextStyle) null, composer3, 0, 0, 131070);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                        }
                                    }
                                }, composer2, 54), composer2, 805306368, 494);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                } else {
                    snackbarData2 = snackbarData;
                    composableLambdaRememberComposableLambda = null;
                }
                composerStartRestartGroup.endReplaceGroup();
                composerStartRestartGroup.startReplaceGroup(1561358724);
                ComposerKt.sourceInformation(composerStartRestartGroup, "227@10548L362");
                if (snackbarData.getVisuals().getWithDismissAction()) {
                    composableLambdaRememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-1812633777, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i17) {
                            ComposerKt.sourceInformation(composer2, "C229@10608L26,228@10566L330:Snackbar.kt#uh7d8r");
                            if ((i17 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1812633777, i17, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:228)");
                                }
                                ComposerKt.sourceInformationMarkerStart(composer2, 642131457, "CC(remember):Snackbar.kt#9igjgp");
                                boolean zChanged = composer2.changed(snackbarData2);
                                final SnackbarData snackbarData3 = snackbarData2;
                                Object objRememberedValue = composer2.rememberedValue();
                                if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue = (Function0) new Function0<Unit>() {
                                        {
                                            super(0);
                                        }

                                        public Object invoke() {
                                            m2856invoke();
                                            return Unit.INSTANCE;
                                        }

                                        public final void m2856invoke() {
                                            snackbarData3.dismiss();
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                IconButtonKt.IconButton((Function0) objRememberedValue, null, false, null, null, ComposableSingletons$SnackbarKt.INSTANCE.m2227getLambda1$material3_release(), composer2, 196608, 30);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                } else {
                    composableLambdaRememberComposableLambda2 = null;
                }
                composerStartRestartGroup.endReplaceGroup();
                int i17 = i3 << 3;
                m2851SnackbareQBnUkQ(PaddingKt.m1035padding3ABfNKs(companion, Dp.constructor-impl(12)), composableLambdaRememberComposableLambda, composableLambdaRememberComposableLambda2, z3, shape3, color, contentColor, j8, dismissActionContentColor, ComposableLambdaKt.rememberComposableLambda(-1266389126, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i18) {
                        ComposerKt.sourceInformation(composer2, "C251@11373L34:Snackbar.kt#uh7d8r");
                        if ((i18 & 3) == 2 && composer2.getSkipping()) {
                            composer2.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1266389126, i18, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:251)");
                        }
                        TextKt.m3021Text4IGK_g(snackbarData2.getVisuals().getMessage(), (Modifier) null, 0L, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1<? super TextLayoutResult, Unit>) null, (TextStyle) null, composer2, 0, 0, 131070);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i17 & 3670016) | (i17 & 7168) | 805306368 | (57344 & i17) | (458752 & i17) | (29360128 & i3) | (i3 & 234881024), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                j9 = actionColor;
                z4 = z3;
                shape4 = shape3;
                modifier2 = companion;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier5 = modifier2;
                final long j110 = color;
                final long j111 = contentColor;
                final long j112 = j9;
                final long j113 = j8;
                final long j114 = dismissActionContentColor;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i18) {
                        SnackbarKt.m2852SnackbarsDKtq54(snackbarData, modifier5, z4, shape4, j110, j111, j112, j113, j114, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 384;
        z2 = z;
        if ((i & 3072) == 0) {
            if ((i2 & 8) == 0) {
                shape2 = shape;
                if (composerStartRestartGroup.changed(shape2)) {
                    i10 = Fields.CameraDistance;
                }
                i3 |= i10;
            } else {
                shape2 = shape;
            }
            i10 = Fields.RotationZ;
            i3 |= i10;
        } else {
            shape2 = shape;
        }
        if ((i & 24576) == 0) {
            if ((i2 & 16) == 0) {
                j6 = j;
                if (composerStartRestartGroup.changed(j6)) {
                    i9 = Fields.Clip;
                }
                i3 |= i9;
            } else {
                j6 = j;
            }
            i9 = Fields.Shape;
            i3 |= i9;
        } else {
            j6 = j;
        }
        if ((196608 & i) == 0) {
            if ((i2 & 32) == 0) {
                j7 = j2;
                if (composerStartRestartGroup.changed(j7)) {
                }
                i3 |= i12;
            } else {
                j7 = j2;
            }
            i3 |= i12;
        } else {
            j7 = j2;
        }
        if ((1572864 & i) != 0) {
            if ((i2 & 64) == 0) {
                i8 = 524288;
            } else {
                i8 = 524288;
            }
            i3 |= i8;
        }
        if ((i & 12582912) != 0) {
            if ((i2 & Fields.SpotShadowColor) == 0) {
                i7 = 4194304;
            } else {
                i7 = 4194304;
            }
            i3 |= i7;
        }
        if ((100663296 & i) != 0) {
            if ((i2 & Fields.RotationX) == 0) {
                i6 = 33554432;
            } else {
                i6 = 33554432;
            }
            i3 |= i6;
        }
        if ((38347923 & i3) == 38347922) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    z3 = false;
                } else {
                    z3 = z2;
                }
                if ((i2 & 8) != 0) {
                    shape3 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    i3 &= -7169;
                } else {
                    shape3 = shape2;
                }
                if ((i2 & 16) != 0) {
                    color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                    i3 &= -57345;
                } else {
                    color = j6;
                }
                if ((i2 & 32) != 0) {
                    contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                    i3 &= -458753;
                } else {
                    contentColor = j7;
                }
                if ((i2 & 64) != 0) {
                    actionColor = SnackbarDefaults.INSTANCE.getActionColor(composerStartRestartGroup, 6);
                    i3 &= -3670017;
                } else {
                    actionColor = j3;
                }
                if ((i2 & Fields.SpotShadowColor) != 0) {
                    actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                    i3 &= -29360129;
                } else {
                    actionContentColor = j4;
                }
                if ((i2 & Fields.RotationX) != 0) {
                    i3 &= -234881025;
                    j8 = actionContentColor;
                    dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                } else {
                    dismissActionContentColor = j5;
                    j8 = actionContentColor;
                }
            } else {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    z3 = false;
                } else {
                    z3 = z2;
                }
                if ((i2 & 8) != 0) {
                    shape3 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    i3 &= -7169;
                } else {
                    shape3 = shape2;
                }
                if ((i2 & 16) != 0) {
                    color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                    i3 &= -57345;
                } else {
                    color = j6;
                }
                if ((i2 & 32) != 0) {
                    contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                    i3 &= -458753;
                } else {
                    contentColor = j7;
                }
                if ((i2 & 64) != 0) {
                    actionColor = SnackbarDefaults.INSTANCE.getActionColor(composerStartRestartGroup, 6);
                    i3 &= -3670017;
                } else {
                    actionColor = j3;
                }
                if ((i2 & Fields.SpotShadowColor) != 0) {
                    actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                    i3 &= -29360129;
                } else {
                    actionContentColor = j4;
                }
                if ((i2 & Fields.RotationX) != 0) {
                    i3 &= -234881025;
                    j8 = actionContentColor;
                    dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                } else {
                    dismissActionContentColor = j5;
                    j8 = actionContentColor;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(274621471, i3, -1, "androidx.compose.material3.Snackbar (Snackbar.kt:211)");
            }
            actionLabel = snackbarData.getVisuals().getActionLabel();
            composerStartRestartGroup.startReplaceGroup(1561344786);
            ComposerKt.sourceInformation(composerStartRestartGroup, "215@10097L267");
            if (actionLabel != null) {
                snackbarData2 = snackbarData;
                composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-1378313599, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i18) {
                        ComposerKt.sourceInformation(composer2, "C217@10171L44,218@10247L32,219@10311L21,216@10115L235:Snackbar.kt#uh7d8r");
                        if ((i18 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1378313599, i18, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:216)");
                            }
                            ButtonColors buttonColorsM2061textButtonColorsro_MJ88 = ButtonDefaults.INSTANCE.m2061textButtonColorsro_MJ88(0L, actionColor, 0L, 0L, composer2, 24576, 13);
                            ComposerKt.sourceInformationMarkerStart(composer2, 642119911, "CC(remember):Snackbar.kt#9igjgp");
                            boolean zChanged = composer2.changed(snackbarData2);
                            final SnackbarData snackbarData3 = snackbarData2;
                            Object objRememberedValue = composer2.rememberedValue();
                            if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue = (Function0) new Function0<Unit>() {
                                    {
                                        super(0);
                                    }

                                    public Object invoke() {
                                        m2855invoke();
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2855invoke() {
                                        snackbarData3.performAction();
                                    }
                                };
                                composer2.updateRememberedValue(objRememberedValue);
                            }
                            Function0 function0 = (Function0) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            final String str = actionLabel;
                            ButtonKt.TextButton(function0, null, false, null, buttonColorsM2061textButtonColorsro_MJ88, null, null, null, null, ComposableLambdaKt.rememberComposableLambda(521110564, true, new Function3<RowScope, Composer, Integer, Unit>() {
                                {
                                    super(3);
                                }

                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    invoke((RowScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(RowScope rowScope, Composer composer3, int i19) {
                                    ComposerKt.sourceInformation(composer3, "C219@10313L17:Snackbar.kt#uh7d8r");
                                    if ((i19 & 17) == 16 && composer3.getSkipping()) {
                                        composer3.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(521110564, i19, -1, "androidx.compose.material3.Snackbar.<anonymous>.<anonymous> (Snackbar.kt:219)");
                                    }
                                    TextKt.m3021Text4IGK_g(str, (Modifier) null, 0L, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1<? super TextLayoutResult, Unit>) null, (TextStyle) null, composer3, 0, 0, 131070);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }, composer2, 54), composer2, 805306368, 494);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54);
            } else {
                snackbarData2 = snackbarData;
                composableLambdaRememberComposableLambda = null;
            }
            composerStartRestartGroup.endReplaceGroup();
            composerStartRestartGroup.startReplaceGroup(1561358724);
            ComposerKt.sourceInformation(composerStartRestartGroup, "227@10548L362");
            if (snackbarData.getVisuals().getWithDismissAction()) {
                composableLambdaRememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-1812633777, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i18) {
                        ComposerKt.sourceInformation(composer2, "C229@10608L26,228@10566L330:Snackbar.kt#uh7d8r");
                        if ((i18 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1812633777, i18, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:228)");
                            }
                            ComposerKt.sourceInformationMarkerStart(composer2, 642131457, "CC(remember):Snackbar.kt#9igjgp");
                            boolean zChanged = composer2.changed(snackbarData2);
                            final SnackbarData snackbarData3 = snackbarData2;
                            Object objRememberedValue = composer2.rememberedValue();
                            if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue = (Function0) new Function0<Unit>() {
                                    {
                                        super(0);
                                    }

                                    public Object invoke() {
                                        m2856invoke();
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2856invoke() {
                                        snackbarData3.dismiss();
                                    }
                                };
                                composer2.updateRememberedValue(objRememberedValue);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            IconButtonKt.IconButton((Function0) objRememberedValue, null, false, null, null, ComposableSingletons$SnackbarKt.INSTANCE.m2227getLambda1$material3_release(), composer2, 196608, 30);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54);
            } else {
                composableLambdaRememberComposableLambda2 = null;
            }
            composerStartRestartGroup.endReplaceGroup();
            int i18 = i3 << 3;
            m2851SnackbareQBnUkQ(PaddingKt.m1035padding3ABfNKs(companion, Dp.constructor-impl(12)), composableLambdaRememberComposableLambda, composableLambdaRememberComposableLambda2, z3, shape3, color, contentColor, j8, dismissActionContentColor, ComposableLambdaKt.rememberComposableLambda(-1266389126, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i19) {
                    ComposerKt.sourceInformation(composer2, "C251@11373L34:Snackbar.kt#uh7d8r");
                    if ((i19 & 3) == 2 && composer2.getSkipping()) {
                        composer2.skipToGroupEnd();
                        return;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1266389126, i19, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:251)");
                    }
                    TextKt.m3021Text4IGK_g(snackbarData2.getVisuals().getMessage(), (Modifier) null, 0L, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1<? super TextLayoutResult, Unit>) null, (TextStyle) null, composer2, 0, 0, 131070);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i18 & 3670016) | (i18 & 7168) | 805306368 | (57344 & i18) | (458752 & i18) | (29360128 & i3) | (i3 & 234881024), 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            j9 = actionColor;
            z4 = z3;
            shape4 = shape3;
            modifier2 = companion;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    z3 = false;
                } else {
                    z3 = z2;
                }
                if ((i2 & 8) != 0) {
                    shape3 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    i3 &= -7169;
                } else {
                    shape3 = shape2;
                }
                if ((i2 & 16) != 0) {
                    color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                    i3 &= -57345;
                } else {
                    color = j6;
                }
                if ((i2 & 32) != 0) {
                    contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                    i3 &= -458753;
                } else {
                    contentColor = j7;
                }
                if ((i2 & 64) != 0) {
                    actionColor = SnackbarDefaults.INSTANCE.getActionColor(composerStartRestartGroup, 6);
                    i3 &= -3670017;
                } else {
                    actionColor = j3;
                }
                if ((i2 & Fields.SpotShadowColor) != 0) {
                    actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                    i3 &= -29360129;
                } else {
                    actionContentColor = j4;
                }
                if ((i2 & Fields.RotationX) != 0) {
                    i3 &= -234881025;
                    j8 = actionContentColor;
                    dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                } else {
                    dismissActionContentColor = j5;
                    j8 = actionContentColor;
                }
            } else {
                if (i11 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i4 != 0) {
                    z3 = false;
                } else {
                    z3 = z2;
                }
                if ((i2 & 8) != 0) {
                    shape3 = SnackbarDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    i3 &= -7169;
                } else {
                    shape3 = shape2;
                }
                if ((i2 & 16) != 0) {
                    color = SnackbarDefaults.INSTANCE.getColor(composerStartRestartGroup, 6);
                    i3 &= -57345;
                } else {
                    color = j6;
                }
                if ((i2 & 32) != 0) {
                    contentColor = SnackbarDefaults.INSTANCE.getContentColor(composerStartRestartGroup, 6);
                    i3 &= -458753;
                } else {
                    contentColor = j7;
                }
                if ((i2 & 64) != 0) {
                    actionColor = SnackbarDefaults.INSTANCE.getActionColor(composerStartRestartGroup, 6);
                    i3 &= -3670017;
                } else {
                    actionColor = j3;
                }
                if ((i2 & Fields.SpotShadowColor) != 0) {
                    actionContentColor = SnackbarDefaults.INSTANCE.getActionContentColor(composerStartRestartGroup, 6);
                    i3 &= -29360129;
                } else {
                    actionContentColor = j4;
                }
                if ((i2 & Fields.RotationX) != 0) {
                    i3 &= -234881025;
                    j8 = actionContentColor;
                    dismissActionContentColor = SnackbarDefaults.INSTANCE.getDismissActionContentColor(composerStartRestartGroup, 6);
                } else {
                    dismissActionContentColor = j5;
                    j8 = actionContentColor;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(274621471, i3, -1, "androidx.compose.material3.Snackbar (Snackbar.kt:211)");
            }
            actionLabel = snackbarData.getVisuals().getActionLabel();
            composerStartRestartGroup.startReplaceGroup(1561344786);
            ComposerKt.sourceInformation(composerStartRestartGroup, "215@10097L267");
            if (actionLabel != null) {
                snackbarData2 = snackbarData;
                composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-1378313599, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i19) {
                        ComposerKt.sourceInformation(composer2, "C217@10171L44,218@10247L32,219@10311L21,216@10115L235:Snackbar.kt#uh7d8r");
                        if ((i19 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1378313599, i19, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:216)");
                            }
                            ButtonColors buttonColorsM2061textButtonColorsro_MJ88 = ButtonDefaults.INSTANCE.m2061textButtonColorsro_MJ88(0L, actionColor, 0L, 0L, composer2, 24576, 13);
                            ComposerKt.sourceInformationMarkerStart(composer2, 642119911, "CC(remember):Snackbar.kt#9igjgp");
                            boolean zChanged = composer2.changed(snackbarData2);
                            final SnackbarData snackbarData3 = snackbarData2;
                            Object objRememberedValue = composer2.rememberedValue();
                            if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue = (Function0) new Function0<Unit>() {
                                    {
                                        super(0);
                                    }

                                    public Object invoke() {
                                        m2855invoke();
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2855invoke() {
                                        snackbarData3.performAction();
                                    }
                                };
                                composer2.updateRememberedValue(objRememberedValue);
                            }
                            Function0 function0 = (Function0) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            final String str = actionLabel;
                            ButtonKt.TextButton(function0, null, false, null, buttonColorsM2061textButtonColorsro_MJ88, null, null, null, null, ComposableLambdaKt.rememberComposableLambda(521110564, true, new Function3<RowScope, Composer, Integer, Unit>() {
                                {
                                    super(3);
                                }

                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    invoke((RowScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(RowScope rowScope, Composer composer3, int i110) {
                                    ComposerKt.sourceInformation(composer3, "C219@10313L17:Snackbar.kt#uh7d8r");
                                    if ((i110 & 17) == 16 && composer3.getSkipping()) {
                                        composer3.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(521110564, i110, -1, "androidx.compose.material3.Snackbar.<anonymous>.<anonymous> (Snackbar.kt:219)");
                                    }
                                    TextKt.m3021Text4IGK_g(str, (Modifier) null, 0L, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1<? super TextLayoutResult, Unit>) null, (TextStyle) null, composer3, 0, 0, 131070);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }, composer2, 54), composer2, 805306368, 494);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54);
            } else {
                snackbarData2 = snackbarData;
                composableLambdaRememberComposableLambda = null;
            }
            composerStartRestartGroup.endReplaceGroup();
            composerStartRestartGroup.startReplaceGroup(1561358724);
            ComposerKt.sourceInformation(composerStartRestartGroup, "227@10548L362");
            if (snackbarData.getVisuals().getWithDismissAction()) {
                composableLambdaRememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-1812633777, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i19) {
                        ComposerKt.sourceInformation(composer2, "C229@10608L26,228@10566L330:Snackbar.kt#uh7d8r");
                        if ((i19 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1812633777, i19, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:228)");
                            }
                            ComposerKt.sourceInformationMarkerStart(composer2, 642131457, "CC(remember):Snackbar.kt#9igjgp");
                            boolean zChanged = composer2.changed(snackbarData2);
                            final SnackbarData snackbarData3 = snackbarData2;
                            Object objRememberedValue = composer2.rememberedValue();
                            if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue = (Function0) new Function0<Unit>() {
                                    {
                                        super(0);
                                    }

                                    public Object invoke() {
                                        m2856invoke();
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2856invoke() {
                                        snackbarData3.dismiss();
                                    }
                                };
                                composer2.updateRememberedValue(objRememberedValue);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            IconButtonKt.IconButton((Function0) objRememberedValue, null, false, null, null, ComposableSingletons$SnackbarKt.INSTANCE.m2227getLambda1$material3_release(), composer2, 196608, 30);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54);
            } else {
                composableLambdaRememberComposableLambda2 = null;
            }
            composerStartRestartGroup.endReplaceGroup();
            int i19 = i3 << 3;
            m2851SnackbareQBnUkQ(PaddingKt.m1035padding3ABfNKs(companion, Dp.constructor-impl(12)), composableLambdaRememberComposableLambda, composableLambdaRememberComposableLambda2, z3, shape3, color, contentColor, j8, dismissActionContentColor, ComposableLambdaKt.rememberComposableLambda(-1266389126, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i110) {
                    ComposerKt.sourceInformation(composer2, "C251@11373L34:Snackbar.kt#uh7d8r");
                    if ((i110 & 3) == 2 && composer2.getSkipping()) {
                        composer2.skipToGroupEnd();
                        return;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1266389126, i110, -1, "androidx.compose.material3.Snackbar.<anonymous> (Snackbar.kt:251)");
                    }
                    TextKt.m3021Text4IGK_g(snackbarData2.getVisuals().getMessage(), (Modifier) null, 0L, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1<? super TextLayoutResult, Unit>) null, (TextStyle) null, composer2, 0, 0, 131070);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i19 & 3670016) | (i19 & 7168) | 805306368 | (57344 & i19) | (458752 & i19) | (29360128 & i3) | (i3 & 234881024), 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            j9 = actionColor;
            z4 = z3;
            shape4 = shape3;
            modifier2 = companion;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier6 = modifier2;
            final long j115 = color;
            final long j116 = contentColor;
            final long j117 = j9;
            final long j118 = j8;
            final long j119 = dismissActionContentColor;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i110) {
                    SnackbarKt.m2852SnackbarsDKtq54(snackbarData, modifier6, z4, shape4, j115, j116, j117, j118, j119, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void m2849NewLineButtonSnackbarkKq0p4A(final Function2<? super Composer, ? super Integer, Unit> function2, final Function2<? super Composer, ? super Integer, Unit> function3, final Function2<? super Composer, ? super Integer, Unit> function4, final TextStyle textStyle, final long j, final long j2, Composer composer, final int i) {
        int i2;
        Composer composerStartRestartGroup = composer.startRestartGroup(-1332496681);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(NewLineButtonSnackbar)P(5!1,3,2,1:c#ui.graphics.Color,4:c#ui.graphics.Color)264@11690L1175:Snackbar.kt#uh7d8r");
        if ((i & 6) == 0) {
            i2 = (composerStartRestartGroup.changedInstance(function2) ? 4 : 2) | i;
        } else {
            i2 = i;
        }
        if ((i & 48) == 0) {
            i2 |= composerStartRestartGroup.changedInstance(function3) ? 32 : 16;
        }
        if ((i & 384) == 0) {
            i2 |= composerStartRestartGroup.changedInstance(function4) ? Fields.RotationX : Fields.SpotShadowColor;
        }
        if ((i & 3072) == 0) {
            i2 |= composerStartRestartGroup.changed(textStyle) ? Fields.CameraDistance : Fields.RotationZ;
        }
        if ((i & 24576) == 0) {
            i2 |= composerStartRestartGroup.changed(j) ? Fields.Clip : Fields.Shape;
        }
        if ((196608 & i) == 0) {
            i2 |= composerStartRestartGroup.changed(j2) ? Fields.RenderEffect : 65536;
        }
        if ((74899 & i2) != 74898 || !composerStartRestartGroup.getSkipping()) {
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1332496681, i2, -1, "androidx.compose.material3.NewLineButtonSnackbar (Snackbar.kt:263)");
            }
            Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.fillMaxWidth$default(SizeKt.m1087widthInVpY3zN4$default(Modifier.INSTANCE, 0.0f, ContainerMaxWidth, 1, null), 0.0f, 1, null), HorizontalSpacing, 0.0f, 0.0f, SeparateButtonExtraY, 6, null);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
            MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(Arrangement.INSTANCE.getTop(), Alignment.INSTANCE.getStart(), composerStartRestartGroup, 0);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
            CompositionLocalMap currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierM1039paddingqDBjuR0$default);
            Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
            if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                ComposablesKt.invalidApplier();
            }
            composerStartRestartGroup.startReusableNode();
            if (composerStartRestartGroup.getInserting()) {
                composerStartRestartGroup.createNode(constructor);
            } else {
                composerStartRestartGroup.useNode();
            }
            Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyColumnMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
            if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
            }
            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -384862393, "C87@4365L9:Column.kt#2w3rfo");
            ColumnScopeInstance columnScopeInstance = ColumnScopeInstance.INSTANCE;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -376152340, "C272@11979L191,279@12180L679:Snackbar.kt#uh7d8r");
            Modifier modifierM885paddingFromBaselineVpY3zN4 = AlignmentLineKt.m885paddingFromBaselineVpY3zN4(Modifier.INSTANCE, HeightToFirstLine, LongButtonVerticalOffset);
            float f = HorizontalSpacingButtonSide;
            Modifier modifierM1039paddingqDBjuR0$default2 = PaddingKt.m1039paddingqDBjuR0$default(modifierM885paddingFromBaselineVpY3zN4, 0.0f, 0.0f, f, 0.0f, 11, null);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
            int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
            CompositionLocalMap currentCompositionLocalMap2 = composerStartRestartGroup.getCurrentCompositionLocalMap();
            Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierM1039paddingqDBjuR0$default2);
            Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
            if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                ComposablesKt.invalidApplier();
            }
            composerStartRestartGroup.startReusableNode();
            if (composerStartRestartGroup.getInserting()) {
                composerStartRestartGroup.createNode(constructor2);
            } else {
                composerStartRestartGroup.useNode();
            }
            Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composerStartRestartGroup);
            Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
            Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
            if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
            }
            Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
            BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1482962025, "C276@12154L6:Snackbar.kt#uh7d8r");
            function2.invoke(composerStartRestartGroup, Integer.valueOf(i2 & 14));
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composerStartRestartGroup.endNode();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            Modifier modifierM1039paddingqDBjuR0$default3 = PaddingKt.m1039paddingqDBjuR0$default(columnScopeInstance.align(Modifier.INSTANCE, Alignment.INSTANCE.getEnd()), 0.0f, 0.0f, function4 == null ? f : Dp.constructor-impl(0), 0.0f, 11, null);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
            int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
            CompositionLocalMap currentCompositionLocalMap3 = composerStartRestartGroup.getCurrentCompositionLocalMap();
            Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierM1039paddingqDBjuR0$default3);
            Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
            if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                ComposablesKt.invalidApplier();
            }
            composerStartRestartGroup.startReusableNode();
            if (composerStartRestartGroup.getInserting()) {
                composerStartRestartGroup.createNode(constructor3);
            } else {
                composerStartRestartGroup.useNode();
            }
            Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composerStartRestartGroup);
            Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
            Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
            if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
            }
            Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
            BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1482754232, "C283@12348L501:Snackbar.kt#uh7d8r");
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
            Modifier.Companion companion = Modifier.INSTANCE;
            MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(Arrangement.INSTANCE.getStart(), Alignment.INSTANCE.getTop(), composerStartRestartGroup, 0);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
            int currentCompositeKeyHash4 = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
            CompositionLocalMap currentCompositionLocalMap4 = composerStartRestartGroup.getCurrentCompositionLocalMap();
            Modifier modifierMaterializeModifier4 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
            Function0<ComposeUiNode> constructor4 = ComposeUiNode.INSTANCE.getConstructor();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
            if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                ComposablesKt.invalidApplier();
            }
            composerStartRestartGroup.startReusableNode();
            if (composerStartRestartGroup.getInserting()) {
                composerStartRestartGroup.createNode(constructor4);
            } else {
                composerStartRestartGroup.useNode();
            }
            Composer composerM4037constructorimpl4 = Updater.m4037constructorimpl(composerStartRestartGroup);
            Updater.m4044setimpl(composerM4037constructorimpl4, measurePolicyRowMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
            Updater.m4044setimpl(composerM4037constructorimpl4, currentCompositionLocalMap4, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash4 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
            if (composerM4037constructorimpl4.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl4.rememberedValue(), Integer.valueOf(currentCompositeKeyHash4))) {
                composerM4037constructorimpl4.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash4));
                composerM4037constructorimpl4.apply(Integer.valueOf(currentCompositeKeyHash4), setCompositeKeyHash4);
            }
            Updater.m4044setimpl(composerM4037constructorimpl4, modifierMaterializeModifier4, ComposeUiNode.INSTANCE.getSetModifier());
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -407918630, "C100@5047L9:Row.kt#2w3rfo");
            RowScopeInstance rowScopeInstance = RowScopeInstance.INSTANCE;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1996615437, "C284@12370L208:Snackbar.kt#uh7d8r");
            CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(j)), TextKt.getLocalTextStyle().provides(textStyle)}, function3, composerStartRestartGroup, ProvidedValue.$stable | (i2 & 112));
            composerStartRestartGroup.startReplaceGroup(618603253);
            ComposerKt.sourceInformation(composerStartRestartGroup, "290@12644L173");
            if (function4 != null) {
                CompositionLocalKt.CompositionLocalProvider(ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(j2)), function4, composerStartRestartGroup, ((i2 >> 3) & 112) | ProvidedValue.$stable);
            }
            composerStartRestartGroup.endReplaceGroup();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composerStartRestartGroup.endNode();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composerStartRestartGroup.endNode();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composerStartRestartGroup.endNode();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
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
                    SnackbarKt.m2849NewLineButtonSnackbarkKq0p4A(function2, function3, function4, textStyle, j, j2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1));
                }
            });
        }
    }

    public static final void m2850OneRowSnackbarkKq0p4A(final Function2<? super Composer, ? super Integer, Unit> function2, final Function2<? super Composer, ? super Integer, Unit> function3, final Function2<? super Composer, ? super Integer, Unit> function4, final TextStyle textStyle, final long j, final long j2, Composer composer, final int i) {
        int i2;
        float f;
        Composer composerStartRestartGroup = composer.startRestartGroup(-903235475);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(OneRowSnackbar)P(5!1,3,2,1:c#ui.graphics.Color,4:c#ui.graphics.Color)338@14229L3580,312@13223L4586:Snackbar.kt#uh7d8r");
        if ((i & 6) == 0) {
            i2 = (composerStartRestartGroup.changedInstance(function2) ? 4 : 2) | i;
        } else {
            i2 = i;
        }
        if ((i & 48) == 0) {
            i2 |= composerStartRestartGroup.changedInstance(function3) ? 32 : 16;
        }
        if ((i & 384) == 0) {
            i2 |= composerStartRestartGroup.changedInstance(function4) ? Fields.RotationX : Fields.SpotShadowColor;
        }
        if ((i & 3072) == 0) {
            i2 |= composerStartRestartGroup.changed(textStyle) ? Fields.CameraDistance : Fields.RotationZ;
        }
        if ((i & 24576) == 0) {
            i2 |= composerStartRestartGroup.changed(j) ? Fields.Clip : Fields.Shape;
        }
        if ((196608 & i) == 0) {
            i2 |= composerStartRestartGroup.changed(j2) ? Fields.RenderEffect : 65536;
        }
        if ((74899 & i2) != 74898 || !composerStartRestartGroup.getSkipping()) {
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-903235475, i2, -1, "androidx.compose.material3.OneRowSnackbar (Snackbar.kt:308)");
            }
            Modifier.Companion companion = Modifier.INSTANCE;
            float f2 = HorizontalSpacing;
            if (function4 == null) {
                f = HorizontalSpacingButtonSide;
            } else {
                f = Dp.constructor-impl(0);
            }
            Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(companion, f2, 0.0f, f, 0.0f, 10, null);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1386942712, "CC(remember):Snackbar.kt#9igjgp");
            MeasurePolicy measurePolicyRememberedValue = composerStartRestartGroup.rememberedValue();
            final String str = "text";
            final String str2 = "action";
            final String str3 = "dismissAction";
            if (measurePolicyRememberedValue == Composer.INSTANCE.getEmpty()) {
                measurePolicyRememberedValue = new MeasurePolicy() {
                    @Override
                    public int maxIntrinsicHeight(IntrinsicMeasureScope intrinsicMeasureScope, List list, int i3) {
                        return MeasurePolicy.CC.$default$maxIntrinsicHeight(this, intrinsicMeasureScope, list, i3);
                    }

                    @Override
                    public int maxIntrinsicWidth(IntrinsicMeasureScope intrinsicMeasureScope, List list, int i3) {
                        return MeasurePolicy.CC.$default$maxIntrinsicWidth(this, intrinsicMeasureScope, list, i3);
                    }

                    @Override
                    public int minIntrinsicHeight(IntrinsicMeasureScope intrinsicMeasureScope, List list, int i3) {
                        return MeasurePolicy.CC.$default$minIntrinsicHeight(this, intrinsicMeasureScope, list, i3);
                    }

                    @Override
                    public int minIntrinsicWidth(IntrinsicMeasureScope intrinsicMeasureScope, List list, int i3) {
                        return MeasurePolicy.CC.$default$minIntrinsicWidth(this, intrinsicMeasureScope, list, i3);
                    }

                    @Override
                    public final MeasureResult mo296measure3p2s80s(MeasureScope measureScope, List<? extends Measurable> list, long j3) {
                        Measurable measurable;
                        Measurable measurable2;
                        Placeable placeable;
                        final int i3;
                        final int height;
                        int iMax;
                        int iMin = Math.min(Constraints.getMaxWidth-impl(j3), measureScope.roundToPx-0680j_4(SnackbarKt.ContainerMaxWidth));
                        String str4 = str2;
                        int size = list.size();
                        int i4 = 0;
                        while (true) {
                            if (i4 >= size) {
                                measurable = null;
                                break;
                            }
                            measurable = list.get(i4);
                            if (Intrinsics.areEqual(LayoutIdKt.getLayoutId(measurable), str4)) {
                                break;
                            }
                            i4++;
                        }
                        Measurable measurable3 = measurable;
                        Placeable placeableMo6026measureBRTryo0 = measurable3 != null ? measurable3.mo6026measureBRTryo0(j3) : null;
                        String str5 = str3;
                        int size2 = list.size();
                        int i5 = 0;
                        while (true) {
                            if (i5 >= size2) {
                                measurable2 = null;
                                break;
                            }
                            measurable2 = list.get(i5);
                            if (Intrinsics.areEqual(LayoutIdKt.getLayoutId(measurable2), str5)) {
                                break;
                            }
                            i5++;
                        }
                        Measurable measurable4 = measurable2;
                        final Placeable placeableMo6026measureBRTryo1 = measurable4 != null ? measurable4.mo6026measureBRTryo0(j3) : null;
                        int width = placeableMo6026measureBRTryo0 != null ? placeableMo6026measureBRTryo0.getWidth() : 0;
                        int height2 = placeableMo6026measureBRTryo0 != null ? placeableMo6026measureBRTryo0.getHeight() : 0;
                        int width2 = placeableMo6026measureBRTryo1 != null ? placeableMo6026measureBRTryo1.getWidth() : 0;
                        int height3 = placeableMo6026measureBRTryo1 != null ? placeableMo6026measureBRTryo1.getHeight() : 0;
                        int iCoerceAtLeast = RangesKt.coerceAtLeast(((iMin - width) - width2) - (width2 == 0 ? measureScope.roundToPx-0680j_4(SnackbarKt.TextEndExtraSpacing) : 0), Constraints.getMinWidth-impl(j3));
                        String str6 = str;
                        int size3 = list.size();
                        int i6 = 0;
                        while (i6 < size3) {
                            Measurable measurable5 = list.get(i6);
                            if (Intrinsics.areEqual(LayoutIdKt.getLayoutId(measurable5), str6)) {
                                Placeable placeable2 = placeableMo6026measureBRTryo0;
                                int i7 = height3;
                                final Placeable placeableMo6026measureBRTryo2 = measurable5.mo6026measureBRTryo0(Constraints.copy-Zbe2FdA$default(j3, 0, iCoerceAtLeast, 0, 0, 9, (Object) null));
                                int i8 = placeableMo6026measureBRTryo2.get(androidx.compose.p002ui.layout.AlignmentLineKt.getFirstBaseline());
                                int i9 = placeableMo6026measureBRTryo2.get(androidx.compose.p002ui.layout.AlignmentLineKt.getLastBaseline());
                                boolean z = true;
                                boolean z2 = (i8 == Integer.MIN_VALUE || i9 == Integer.MIN_VALUE) ? false : true;
                                if (i8 != i9 && z2) {
                                    z = false;
                                }
                                final int i10 = iMin - width2;
                                final int i11 = i10 - width;
                                if (!z) {
                                    placeable = placeable2;
                                    int i12 = measureScope.roundToPx-0680j_4(SnackbarKt.HeightToFirstLine) - i8;
                                    int iMax2 = Math.max(measureScope.roundToPx-0680j_4(SnackbarTokens.INSTANCE.m3869getTwoLinesContainerHeightD9Ej5fM()), placeableMo6026measureBRTryo2.getHeight() + i12);
                                    i3 = i12;
                                    height = placeable != null ? (iMax2 - placeable.getHeight()) / 2 : 0;
                                    iMax = iMax2;
                                } else {
                                    iMax = Math.max(measureScope.roundToPx-0680j_4(SnackbarTokens.INSTANCE.m3868getSingleLineContainerHeightD9Ej5fM()), Math.max(height2, i7));
                                    int height4 = (iMax - placeableMo6026measureBRTryo2.getHeight()) / 2;
                                    if (placeable2 != null) {
                                        placeable = placeable2;
                                        int i13 = placeable.get(androidx.compose.p002ui.layout.AlignmentLineKt.getFirstBaseline());
                                        int i14 = i13 != Integer.MIN_VALUE ? (i8 + height4) - i13 : 0;
                                        height = i14;
                                        i3 = height4;
                                    } else {
                                        placeable = placeable2;
                                    }
                                    height = i14;
                                    i3 = height4;
                                }
                                final int height5 = placeableMo6026measureBRTryo1 != null ? (iMax - placeableMo6026measureBRTryo1.getHeight()) / 2 : 0;
                                final Placeable placeable3 = placeable;
                                return MeasureScope.CC.layout$default(measureScope, iMin, iMax, null, new Function1<Placeable.PlacementScope, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((Placeable.PlacementScope) obj);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Placeable.PlacementScope placementScope) {
                                        Placeable.PlacementScope.placeRelative$default(placementScope, placeableMo6026measureBRTryo2, 0, i3, 0.0f, 4, null);
                                        Placeable placeable4 = placeableMo6026measureBRTryo1;
                                        if (placeable4 != null) {
                                            Placeable.PlacementScope.placeRelative$default(placementScope, placeable4, i10, height5, 0.0f, 4, null);
                                        }
                                        Placeable placeable5 = placeable3;
                                        if (placeable5 != null) {
                                            Placeable.PlacementScope.placeRelative$default(placementScope, placeable5, i11, height, 0.0f, 4, null);
                                        }
                                    }
                                }, 4, null);
                            }
                            i6++;
                            placeableMo6026measureBRTryo0 = placeableMo6026measureBRTryo0;
                        }
                        throw new NoSuchElementException("Collection contains no element matching the predicate.");
                    }
                };
                composerStartRestartGroup.updateRememberedValue(measurePolicyRememberedValue);
            }
            MeasurePolicy measurePolicy = (MeasurePolicy) measurePolicyRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
            CompositionLocalMap currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierM1039paddingqDBjuR0$default);
            Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
            if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                ComposablesKt.invalidApplier();
            }
            composerStartRestartGroup.startReusableNode();
            if (composerStartRestartGroup.getInserting()) {
                composerStartRestartGroup.createNode(constructor);
            } else {
                composerStartRestartGroup.useNode();
            }
            Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
            if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
            }
            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2016566027, "C314@13253L86:Snackbar.kt#uh7d8r");
            Modifier modifierM1037paddingVpY3zN4$default = PaddingKt.m1037paddingVpY3zN4$default(LayoutIdKt.layoutId(Modifier.INSTANCE, "text"), 0.0f, SnackbarVerticalPadding, 1, null);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
            int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
            CompositionLocalMap currentCompositionLocalMap2 = composerStartRestartGroup.getCurrentCompositionLocalMap();
            Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierM1037paddingVpY3zN4$default);
            Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
            if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                ComposablesKt.invalidApplier();
            }
            composerStartRestartGroup.startReusableNode();
            if (composerStartRestartGroup.getInserting()) {
                composerStartRestartGroup.createNode(constructor2);
            } else {
                composerStartRestartGroup.useNode();
            }
            Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composerStartRestartGroup);
            Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
            Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
            if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
            }
            Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
            BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1308937155, "C314@13331L6:Snackbar.kt#uh7d8r");
            function2.invoke(composerStartRestartGroup, Integer.valueOf(i2 & 14));
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composerStartRestartGroup.endNode();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composerStartRestartGroup.startReplaceGroup(-904778058);
            ComposerKt.sourceInformation(composerStartRestartGroup, "316@13390L295");
            if (function3 != null) {
                Modifier modifierLayoutId = LayoutIdKt.layoutId(Modifier.INSTANCE, "action");
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy2 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                int currentCompositeKeyHash3 = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap3 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierLayoutId);
                Function0<ComposeUiNode> constructor3 = ComposeUiNode.INSTANCE.getConstructor();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                    ComposablesKt.invalidApplier();
                }
                composerStartRestartGroup.startReusableNode();
                if (composerStartRestartGroup.getInserting()) {
                    composerStartRestartGroup.createNode(constructor3);
                } else {
                    composerStartRestartGroup.useNode();
                }
                Composer composerM4037constructorimpl3 = Updater.m4037constructorimpl(composerStartRestartGroup);
                Updater.m4044setimpl(composerM4037constructorimpl3, measurePolicyMaybeCachedBoxMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                Updater.m4044setimpl(composerM4037constructorimpl3, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash3 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                if (composerM4037constructorimpl3.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl3.rememberedValue(), Integer.valueOf(currentCompositeKeyHash3))) {
                    composerM4037constructorimpl3.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash3));
                    composerM4037constructorimpl3.apply(Integer.valueOf(currentCompositeKeyHash3), setCompositeKeyHash3);
                }
                Updater.m4044setimpl(composerM4037constructorimpl3, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                BoxScopeInstance boxScopeInstance2 = BoxScopeInstance.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1309057900, "C317@13446L221:Snackbar.kt#uh7d8r");
                CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(j)), TextKt.getLocalTextStyle().provides(textStyle)}, function3, composerStartRestartGroup, ProvidedValue.$stable | (i2 & 112));
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            }
            composerStartRestartGroup.endReplaceGroup();
            composerStartRestartGroup.startReplaceGroup(-904766579);
            ComposerKt.sourceInformation(composerStartRestartGroup, "325@13757L247");
            if (function4 != null) {
                Modifier modifierLayoutId2 = LayoutIdKt.layoutId(Modifier.INSTANCE, "dismissAction");
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy3 = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                int currentCompositeKeyHash4 = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap4 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier4 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierLayoutId2);
                Function0<ComposeUiNode> constructor4 = ComposeUiNode.INSTANCE.getConstructor();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                    ComposablesKt.invalidApplier();
                }
                composerStartRestartGroup.startReusableNode();
                if (composerStartRestartGroup.getInserting()) {
                    composerStartRestartGroup.createNode(constructor4);
                } else {
                    composerStartRestartGroup.useNode();
                }
                Composer composerM4037constructorimpl4 = Updater.m4037constructorimpl(composerStartRestartGroup);
                Updater.m4044setimpl(composerM4037constructorimpl4, measurePolicyMaybeCachedBoxMeasurePolicy3, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                Updater.m4044setimpl(composerM4037constructorimpl4, currentCompositionLocalMap4, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash4 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                if (composerM4037constructorimpl4.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl4.rememberedValue(), Integer.valueOf(currentCompositeKeyHash4))) {
                    composerM4037constructorimpl4.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash4));
                    composerM4037constructorimpl4.apply(Integer.valueOf(currentCompositeKeyHash4), setCompositeKeyHash4);
                }
                Updater.m4044setimpl(composerM4037constructorimpl4, modifierMaterializeModifier4, ComposeUiNode.INSTANCE.getSetModifier());
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                BoxScopeInstance boxScopeInstance3 = BoxScopeInstance.INSTANCE;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1309427203, "C326@13820L166:Snackbar.kt#uh7d8r");
                CompositionLocalKt.CompositionLocalProvider(ContentColorKt.getLocalContentColor().provides(Color.m4580boximpl(j2)), function4, composerStartRestartGroup, ((i2 >> 3) & 112) | ProvidedValue.$stable);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            }
            composerStartRestartGroup.endReplaceGroup();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composerStartRestartGroup.endNode();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
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
                    SnackbarKt.m2850OneRowSnackbarkKq0p4A(function2, function3, function4, textStyle, j, j2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1));
                }
            });
        }
    }

    static {
        float f = 8;
        HorizontalSpacingButtonSide = Dp.constructor-impl(f);
        TextEndExtraSpacing = Dp.constructor-impl(f);
    }
}
