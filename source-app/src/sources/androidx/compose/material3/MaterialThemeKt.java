package androidx.compose.material3;

import androidx.compose.foundation.IndicationKt;
import androidx.compose.foundation.text.selection.TextSelectionColors;
import androidx.compose.foundation.text.selection.TextSelectionColorsKt;
import androidx.compose.material.ripple.RippleThemeKt;
import androidx.compose.p002ui.graphics.Color;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.layout.LayoutKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.CompositionLocalKt;
import androidx.compose.runtime.ProvidableCompositionLocal;
import androidx.compose.runtime.ProvidedValue;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function2;

@Metadata(d1 = {"\u0000@\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0010\u0007\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\u001aD\u0010\u0007\u001a\u00020\b2\n\b\u0002\u0010\t\u001a\u0004\u0018\u00010\n2\n\b\u0002\u0010\u000b\u001a\u0004\u0018\u00010\f2\n\b\u0002\u0010\r\u001a\u0004\u0018\u00010\u000e2\u0011\u0010\u000f\u001a\r\u0012\u0004\u0012\u00020\b0\u0010¢\u0006\u0002\b\u0011H\u0001¢\u0006\u0002\u0010\u0012\u001a>\u0010\u0013\u001a\u00020\b2\b\b\u0002\u0010\t\u001a\u00020\n2\b\b\u0002\u0010\u000b\u001a\u00020\f2\b\b\u0002\u0010\r\u001a\u00020\u000e2\u0011\u0010\u000f\u001a\r\u0012\u0004\u0012\u00020\b0\u0010¢\u0006\u0002\b\u0011H\u0007¢\u0006\u0002\u0010\u0012\u001a\u0015\u0010\u0014\u001a\u00020\u00152\u0006\u0010\t\u001a\u00020\nH\u0001¢\u0006\u0002\u0010\u0016\"\u001a\u0010\u0000\u001a\b\u0012\u0004\u0012\u00020\u00020\u0001X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0003\u0010\u0004\"\u000e\u0010\u0005\u001a\u00020\u0006X\u0080T¢\u0006\u0002\n\u0000¨\u0006\u0017"}, d2 = {"LocalUsingExpressiveTheme", "Landroidx/compose/runtime/ProvidableCompositionLocal;", "", "getLocalUsingExpressiveTheme", "()Landroidx/compose/runtime/ProvidableCompositionLocal;", "TextSelectionBackgroundOpacity", "", "MaterialExpressiveTheme", "", "colorScheme", "Landroidx/compose/material3/ColorScheme;", "shapes", "Landroidx/compose/material3/Shapes;", "typography", "Landroidx/compose/material3/Typography;", "content", "Lkotlin/Function0;", "Landroidx/compose/runtime/Composable;", "(Landroidx/compose/material3/ColorScheme;Landroidx/compose/material3/Shapes;Landroidx/compose/material3/Typography;Lkotlin/jvm/functions/Function2;Landroidx/compose/runtime/Composer;II)V", "MaterialTheme", "rememberTextSelectionColors", "Landroidx/compose/foundation/text/selection/TextSelectionColors;", "(Landroidx/compose/material3/ColorScheme;Landroidx/compose/runtime/Composer;I)Landroidx/compose/foundation/text/selection/TextSelectionColors;", "material3_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class MaterialThemeKt {
    private static final ProvidableCompositionLocal<Boolean> LocalUsingExpressiveTheme = CompositionLocalKt.staticCompositionLocalOf(new Function0<Boolean>() {
        public final Boolean m2502invoke() {
            return false;
        }
    });
    public static final float TextSelectionBackgroundOpacity = 0.4f;

    public static final void MaterialTheme(ColorScheme colorScheme, Shapes shapes, Typography typography, final Function2<? super Composer, ? super Integer, Unit> function2, Composer composer, final int i, final int i2) {
        ColorScheme colorScheme2;
        int i3;
        Shapes shapes2;
        Typography typography2;
        Shapes shapes3;
        final Typography typography3;
        int i4;
        int i5;
        Composer composerStartRestartGroup = composer.startRestartGroup(-2127166334);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(MaterialTheme)P(!1,2,3)51@2364L11,52@2412L6,53@2463L10,56@2542L32,57@2601L40,67@3101L81,59@2681L501:MaterialTheme.kt#uh7d8r");
        if ((i & 6) == 0) {
            if ((i2 & 1) == 0) {
                colorScheme2 = colorScheme;
                if (composerStartRestartGroup.changed(colorScheme2)) {
                    i5 = 4;
                }
                i3 = i5 | i;
            } else {
                colorScheme2 = colorScheme;
            }
            i5 = 2;
            i3 = i5 | i;
        } else {
            colorScheme2 = colorScheme;
            i3 = i;
        }
        if ((i & 48) == 0) {
            if ((i2 & 2) == 0) {
                shapes2 = shapes;
                int i6 = composerStartRestartGroup.changed(shapes2) ? 32 : 16;
                i3 |= i6;
            } else {
                shapes2 = shapes;
            }
            i3 |= i6;
        } else {
            shapes2 = shapes;
        }
        if ((i & 384) == 0) {
            if ((i2 & 4) == 0) {
                typography2 = typography;
                if (composerStartRestartGroup.changed(typography2)) {
                    i4 = Fields.RotationX;
                }
                i3 |= i4;
            } else {
                typography2 = typography;
            }
            i4 = Fields.SpotShadowColor;
            i3 |= i4;
        } else {
            typography2 = typography;
        }
        if ((i2 & 8) != 0) {
            i3 |= 3072;
        } else if ((i & 3072) == 0) {
            i3 |= composerStartRestartGroup.changedInstance(function2) ? Fields.CameraDistance : Fields.RotationZ;
        }
        if ((i3 & 1171) != 1170 || !composerStartRestartGroup.getSkipping()) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) == 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                if ((i2 & 1) != 0) {
                    colorScheme2 = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6);
                    i3 &= -15;
                }
                if ((i2 & 2) != 0) {
                    shapes2 = MaterialTheme.INSTANCE.getShapes(composerStartRestartGroup, 6);
                    i3 &= -113;
                }
                if ((i2 & 4) != 0) {
                    typography2 = MaterialTheme.INSTANCE.getTypography(composerStartRestartGroup, 6);
                    i3 &= -897;
                }
            } else {
                composerStartRestartGroup.skipToGroupEnd();
                if ((i2 & 1) != 0) {
                    i3 &= -15;
                }
                if ((i2 & 2) != 0) {
                    i3 &= -113;
                }
                if ((i2 & 4) != 0) {
                    i3 &= -897;
                }
            }
            int i7 = i3;
            shapes3 = shapes2;
            final Typography typography4 = typography2;
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-2127166334, i7, -1, "androidx.compose.material3.MaterialTheme (MaterialTheme.kt:55)");
            }
            CompositionLocalKt.CompositionLocalProvider((ProvidedValue<?>[]) new ProvidedValue[]{ColorSchemeKt.getLocalColorScheme().provides(colorScheme2), IndicationKt.getLocalIndication().provides(RippleKt.m2717rippleOrFallbackImplementation9IZ8Weo(false, 0.0f, 0L, composerStartRestartGroup, 0, 7)), RippleThemeKt.getLocalRippleTheme().provides(CompatRippleTheme.INSTANCE), ShapesKt.getLocalShapes().provides(shapes3), TextSelectionColorsKt.getLocalTextSelectionColors().provides(rememberTextSelectionColors(colorScheme2, composerStartRestartGroup, i7 & 14)), TypographyKt.getLocalTypography().provides(typography4)}, ComposableLambdaKt.rememberComposableLambda(-1066563262, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i8) {
                    ComposerKt.sourceInformation(composer2, "C68@3111L65:MaterialTheme.kt#uh7d8r");
                    if ((i8 & 3) == 2 && composer2.getSkipping()) {
                        composer2.skipToGroupEnd();
                        return;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1066563262, i8, -1, "androidx.compose.material3.MaterialTheme.<anonymous> (MaterialTheme.kt:68)");
                    }
                    TextKt.ProvideTextStyle(typography4.getBodyLarge(), function2, composer2, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
            }, composerStartRestartGroup, 54), composerStartRestartGroup, ProvidedValue.$stable | 48);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            typography3 = typography4;
        } else {
            composerStartRestartGroup.skipToGroupEnd();
            shapes3 = shapes2;
            typography3 = typography2;
        }
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final ColorScheme colorScheme3 = colorScheme2;
            final Shapes shapes4 = shapes3;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i8) {
                    MaterialThemeKt.MaterialTheme(colorScheme3, shapes4, typography3, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void MaterialExpressiveTheme(final ColorScheme colorScheme, final Shapes shapes, final Typography typography, final Function2<? super Composer, ? super Integer, Unit> function2, Composer composer, final int i, final int i2) {
        int i3;
        Composer composerStartRestartGroup = composer.startRestartGroup(-1399457222);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(MaterialExpressiveTheme)P(!1,2,3)134@5791L7:MaterialTheme.kt#uh7d8r");
        int i4 = i2 & 1;
        if (i4 != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changed(colorScheme) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i5 = i2 & 2;
        if (i5 != 0) {
            i3 |= 48;
        } else if ((i & 48) == 0) {
            i3 |= composerStartRestartGroup.changed(shapes) ? 32 : 16;
        }
        int i6 = i2 & 4;
        if (i6 != 0) {
            i3 |= 384;
        } else if ((i & 384) == 0) {
            i3 |= composerStartRestartGroup.changed(typography) ? Fields.RotationX : Fields.SpotShadowColor;
        }
        if ((i2 & 8) != 0) {
            i3 |= 3072;
        } else if ((i & 3072) == 0) {
            i3 |= composerStartRestartGroup.changedInstance(function2) ? Fields.CameraDistance : Fields.RotationZ;
        }
        if ((i3 & 1171) != 1170 || !composerStartRestartGroup.getSkipping()) {
            if (i4 != 0) {
                colorScheme = null;
            }
            if (i5 != 0) {
                shapes = null;
            }
            if (i6 != 0) {
                typography = null;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1399457222, i3, -1, "androidx.compose.material3.MaterialExpressiveTheme (MaterialTheme.kt:133)");
            }
            ProvidableCompositionLocal<Boolean> providableCompositionLocal = LocalUsingExpressiveTheme;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume = composerStartRestartGroup.consume(providableCompositionLocal);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            if (((Boolean) objConsume).booleanValue()) {
                composerStartRestartGroup.startReplaceGroup(547059915);
                ComposerKt.sourceInformation(composerStartRestartGroup, "135@5810L240");
                composerStartRestartGroup.startReplaceGroup(1126027167);
                ComposerKt.sourceInformation(composerStartRestartGroup, "136@5880L11");
                ColorScheme colorScheme2 = colorScheme == null ? MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6) : colorScheme;
                composerStartRestartGroup.endReplaceGroup();
                composerStartRestartGroup.startReplaceGroup(1126029309);
                ComposerKt.sourceInformation(composerStartRestartGroup, "137@5946L10");
                Typography typography2 = typography == null ? MaterialTheme.INSTANCE.getTypography(composerStartRestartGroup, 6) : typography;
                composerStartRestartGroup.endReplaceGroup();
                composerStartRestartGroup.startReplaceGroup(1126031253);
                ComposerKt.sourceInformation(composerStartRestartGroup, "138@6003L6");
                Shapes shapes2 = shapes == null ? MaterialTheme.INSTANCE.getShapes(composerStartRestartGroup, 6) : shapes;
                composerStartRestartGroup.endReplaceGroup();
                MaterialTheme(colorScheme2, shapes2, typography2, function2, composerStartRestartGroup, i3 & 7168, 0);
                composerStartRestartGroup.endReplaceGroup();
            } else {
                composerStartRestartGroup.startReplaceGroup(547327197);
                ComposerKt.sourceInformation(composerStartRestartGroup, "142@6138L412,142@6072L478");
                CompositionLocalKt.CompositionLocalProvider(providableCompositionLocal.provides(true), ComposableLambdaKt.rememberComposableLambda(2050809758, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i7) {
                        ComposerKt.sourceInformation(composer2, "C143@6152L388:MaterialTheme.kt#uh7d8r");
                        if ((i7 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(2050809758, i7, -1, "androidx.compose.material3.MaterialExpressiveTheme.<anonymous> (MaterialTheme.kt:143)");
                            }
                            ColorScheme colorSchemeExpressiveLightColorScheme = colorScheme;
                            if (colorSchemeExpressiveLightColorScheme == null) {
                                colorSchemeExpressiveLightColorScheme = ColorSchemeKt.expressiveLightColorScheme();
                            }
                            ColorScheme colorScheme3 = colorSchemeExpressiveLightColorScheme;
                            Shapes shapes3 = shapes;
                            if (shapes3 == null) {
                                shapes3 = new Shapes(null, null, null, null, null, 31, null);
                            }
                            Shapes shapes4 = shapes3;
                            Typography typography3 = typography;
                            if (typography3 == null) {
                                typography3 = new Typography(null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, LayoutKt.LargeDimension, null);
                            }
                            MaterialThemeKt.MaterialTheme(colorScheme3, shapes4, typography3, function2, composer2, 0, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, ProvidedValue.$stable | 48);
                composerStartRestartGroup.endReplaceGroup();
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        } else {
            composerStartRestartGroup.skipToGroupEnd();
        }
        final ColorScheme colorScheme3 = colorScheme;
        final Shapes shapes3 = shapes;
        final Typography typography3 = typography;
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

                public final void invoke(Composer composer2, int i7) {
                    MaterialThemeKt.MaterialExpressiveTheme(colorScheme3, shapes3, typography3, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final ProvidableCompositionLocal<Boolean> getLocalUsingExpressiveTheme() {
        return LocalUsingExpressiveTheme;
    }

    public static final TextSelectionColors rememberTextSelectionColors(ColorScheme colorScheme, Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 1866455512, "C(rememberTextSelectionColors)161@6816L198:MaterialTheme.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1866455512, i, -1, "androidx.compose.material3.rememberTextSelectionColors (MaterialTheme.kt:159)");
        }
        long primary = colorScheme.getPrimary();
        ComposerKt.sourceInformationMarkerStart(composer, -1160063291, "CC(remember):MaterialTheme.kt#9igjgp");
        boolean zChanged = composer.changed(primary);
        Object objRememberedValue = composer.rememberedValue();
        if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
            objRememberedValue = new TextSelectionColors(primary, Color.m4589copywmQWz5c$default(primary, 0.4f, 0.0f, 0.0f, 0.0f, 14, null), null);
            composer.updateRememberedValue(objRememberedValue);
        }
        TextSelectionColors textSelectionColors = (TextSelectionColors) objRememberedValue;
        ComposerKt.sourceInformationMarkerEnd(composer);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return textSelectionColors;
    }
}
