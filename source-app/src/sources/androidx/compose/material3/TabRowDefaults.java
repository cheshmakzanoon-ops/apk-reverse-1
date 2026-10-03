package androidx.compose.material3;

import androidx.compose.animation.core.AnimateAsStateKt;
import androidx.compose.foundation.BackgroundKt;
import androidx.compose.foundation.layout.BoxKt;
import androidx.compose.foundation.layout.OffsetKt;
import androidx.compose.foundation.layout.SizeKt;
import androidx.compose.foundation.layout.SpacerKt;
import androidx.compose.material3.tokens.PrimaryNavigationTabTokens;
import androidx.compose.material3.tokens.SecondaryNavigationTabTokens;
import androidx.compose.p002ui.Alignment;
import androidx.compose.p002ui.ComposedModifierKt;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.graphics.Shape;
import androidx.compose.p002ui.platform.InspectableValueKt;
import androidx.compose.p002ui.platform.InspectorInfo;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.State;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.Dp;
import androidx.compose.ui.unit.IntOffset;
import androidx.compose.ui.unit.IntOffsetKt;
import kotlin.Deprecated;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.Lambda;

@Metadata(d1 = {"\u0000:\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u000f\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0003\bÇ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J0\u0010\u0018\u001a\u00020\u00192\b\b\u0002\u0010\u001a\u001a\u00020\u001b2\b\b\u0002\u0010\u001c\u001a\u00020\u00042\b\b\u0002\u0010\u001d\u001a\u00020\tH\u0007ø\u0001\u0000¢\u0006\u0004\b\u001e\u0010\u001fJD\u0010 \u001a\u00020\u00192\b\b\u0002\u0010\u001a\u001a\u00020\u001b2\b\b\u0002\u0010!\u001a\u00020\u00042\b\b\u0002\u0010\u001c\u001a\u00020\u00042\b\b\u0002\u0010\u001d\u001a\u00020\t2\b\b\u0002\u0010\"\u001a\u00020#H\u0007ø\u0001\u0000¢\u0006\u0004\b$\u0010%J0\u0010&\u001a\u00020\u00192\b\b\u0002\u0010\u001a\u001a\u00020\u001b2\b\b\u0002\u0010\u001c\u001a\u00020\u00042\b\b\u0002\u0010\u001d\u001a\u00020\tH\u0007ø\u0001\u0000¢\u0006\u0004\b'\u0010\u001fJ\u0012\u0010(\u001a\u00020\u001b*\u00020\u001b2\u0006\u0010)\u001a\u00020*R\u0019\u0010\u0003\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0005\u0010\u0006R \u0010\b\u001a\u00020\t8GX\u0087\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\f\u0012\u0004\b\n\u0010\u0002\u001a\u0004\b\u000b\u0010\fR \u0010\r\u001a\u00020\t8GX\u0087\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\f\u0012\u0004\b\u000e\u0010\u0002\u001a\u0004\b\u000f\u0010\fR\u0017\u0010\u0010\u001a\u00020\t8Gø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\u0011\u0010\fR\u0017\u0010\u0012\u001a\u00020\t8Gø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\u0013\u0010\fR\u0017\u0010\u0014\u001a\u00020\t8Gø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\u0015\u0010\fR\u0017\u0010\u0016\u001a\u00020\t8Gø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\u0017\u0010\f\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006+²\u0006\n\u0010,\u001a\u00020\u0004X\u008a\u0084\u0002²\u0006\n\u0010-\u001a\u00020\u0004X\u008a\u0084\u0002"}, d2 = {"Landroidx/compose/material3/TabRowDefaults;", "", "()V", "ScrollableTabRowEdgeStartPadding", "Landroidx/compose/ui/unit/Dp;", "getScrollableTabRowEdgeStartPadding-D9Ej5fM", "()F", "F", "containerColor", "Landroidx/compose/ui/graphics/Color;", "getContainerColor$annotations", "getContainerColor", "(Landroidx/compose/runtime/Composer;I)J", "contentColor", "getContentColor$annotations", "getContentColor", "primaryContainerColor", "getPrimaryContainerColor", "primaryContentColor", "getPrimaryContentColor", "secondaryContainerColor", "getSecondaryContainerColor", "secondaryContentColor", "getSecondaryContentColor", "Indicator", "", "modifier", "Landroidx/compose/ui/Modifier;", "height", "color", "Indicator-9IZ8Weo", "(Landroidx/compose/ui/Modifier;FJLandroidx/compose/runtime/Composer;II)V", "PrimaryIndicator", "width", "shape", "Landroidx/compose/ui/graphics/Shape;", "PrimaryIndicator-10LGxhE", "(Landroidx/compose/ui/Modifier;FFJLandroidx/compose/ui/graphics/Shape;Landroidx/compose/runtime/Composer;II)V", "SecondaryIndicator", "SecondaryIndicator-9IZ8Weo", "tabIndicatorOffset", "currentTabPosition", "Landroidx/compose/material3/TabPosition;", "material3_release", "currentTabWidth", "indicatorOffset"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class TabRowDefaults {
    public static final int $stable = 0;
    public static final TabRowDefaults INSTANCE = new TabRowDefaults();
    private static final float ScrollableTabRowEdgeStartPadding = Dp.constructor-impl(52);

    @Deprecated(message = "Use TabRowDefaults.primaryContainerColor instead", replaceWith = @ReplaceWith(expression = "primaryContainerColor", imports = {}))
    public static void getContainerColor$annotations() {
    }

    @Deprecated(message = "Use TabRowDefaults.primaryContentColor instead", replaceWith = @ReplaceWith(expression = "primaryContentColor", imports = {}))
    public static void getContentColor$annotations() {
    }

    private TabRowDefaults() {
    }

    public final float m2916getScrollableTabRowEdgeStartPaddingD9Ej5fM() {
        return ScrollableTabRowEdgeStartPadding;
    }

    public final long getContainerColor(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, -2026555673, "C1159@49855L5:TabRow.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-2026555673, i, -1, "androidx.compose.material3.TabRowDefaults.<get-containerColor> (TabRow.kt:1159)");
        }
        long value = ColorSchemeKt.getValue(PrimaryNavigationTabTokens.INSTANCE.getContainerColor(), composer, 6);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return value;
    }

    public final long getPrimaryContainerColor(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, -2069154037, "C1163@50026L5:TabRow.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-2069154037, i, -1, "androidx.compose.material3.TabRowDefaults.<get-primaryContainerColor> (TabRow.kt:1163)");
        }
        long value = ColorSchemeKt.getValue(PrimaryNavigationTabTokens.INSTANCE.getContainerColor(), composer, 6);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return value;
    }

    public final long getSecondaryContainerColor(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, -1938007129, "C1167@50203L5:TabRow.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-1938007129, i, -1, "androidx.compose.material3.TabRowDefaults.<get-secondaryContainerColor> (TabRow.kt:1167)");
        }
        long value = ColorSchemeKt.getValue(SecondaryNavigationTabTokens.INSTANCE.getContainerColor(), composer, 6);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return value;
    }

    public final long getContentColor(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 1163072359, "C1175@50509L5:TabRow.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1163072359, i, -1, "androidx.compose.material3.TabRowDefaults.<get-contentColor> (TabRow.kt:1175)");
        }
        long value = ColorSchemeKt.getValue(PrimaryNavigationTabTokens.INSTANCE.getActiveLabelTextColor(), composer, 6);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return value;
    }

    public final long getPrimaryContentColor(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 1410362619, "C1179@50682L5:TabRow.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1410362619, i, -1, "androidx.compose.material3.TabRowDefaults.<get-primaryContentColor> (TabRow.kt:1179)");
        }
        long value = ColorSchemeKt.getValue(PrimaryNavigationTabTokens.INSTANCE.getActiveLabelTextColor(), composer, 6);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return value;
    }

    public final long getSecondaryContentColor(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 1166419479, "C1183@50861L5:TabRow.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1166419479, i, -1, "androidx.compose.material3.TabRowDefaults.<get-secondaryContentColor> (TabRow.kt:1183)");
        }
        long value = ColorSchemeKt.getValue(SecondaryNavigationTabTokens.INSTANCE.getActiveLabelTextColor(), composer, 6);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return value;
    }

    @Deprecated(message = "Use SecondaryIndicator instead.", replaceWith = @ReplaceWith(expression = "SecondaryIndicator(modifier, height, color)", imports = {}))
    public final void m2913Indicator9IZ8Weo(Modifier modifier, float f, long j, Composer composer, final int i, final int i2) {
        Modifier modifier2;
        int i3;
        float f2;
        long j2;
        final Modifier.Companion companion;
        final float fM3822getActiveIndicatorHeightD9Ej5fM;
        int i4;
        final long jFromToken;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i5;
        Composer composerStartRestartGroup = composer.startRestartGroup(1454716052);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(Indicator)P(2,1:c#ui.unit.Dp,0:c#ui.graphics.Color)1202@51501L11,1204@51588L69:TabRow.kt#uh7d8r");
        int i6 = i2 & 1;
        if (i6 != 0) {
            i3 = i | 6;
            modifier2 = modifier;
        } else if ((i & 6) == 0) {
            modifier2 = modifier;
            i3 = (composerStartRestartGroup.changed(modifier2) ? 4 : 2) | i;
        } else {
            modifier2 = modifier;
            i3 = i;
        }
        int i7 = i2 & 2;
        if (i7 == 0) {
            if ((i & 48) == 0) {
                f2 = f;
                i3 |= composerStartRestartGroup.changed(f2) ? 32 : 16;
            }
            if ((i & 384) == 0) {
                if ((i2 & 4) == 0) {
                    j2 = j;
                    if (composerStartRestartGroup.changed(j2)) {
                        i5 = Fields.RotationX;
                    }
                    i3 |= i5;
                } else {
                    j2 = j;
                }
                i5 = Fields.SpotShadowColor;
                i3 |= i5;
            } else {
                j2 = j;
            }
            if ((i3 & 147) == 146 || !composerStartRestartGroup.getSkipping()) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) == 0 && !composerStartRestartGroup.getDefaultsInvalid()) {
                    composerStartRestartGroup.skipToGroupEnd();
                    if ((i2 & 4) != 0) {
                        i3 &= -897;
                    }
                    companion = modifier2;
                    fM3822getActiveIndicatorHeightD9Ej5fM = f2;
                } else {
                    if (i6 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i7 != 0) {
                        fM3822getActiveIndicatorHeightD9Ej5fM = PrimaryNavigationTabTokens.INSTANCE.m3822getActiveIndicatorHeightD9Ej5fM();
                    } else {
                        fM3822getActiveIndicatorHeightD9Ej5fM = f2;
                    }
                    if ((i2 & 4) != 0) {
                        i4 = i3 & (-897);
                        jFromToken = ColorSchemeKt.fromToken(MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6), PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorColor());
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1454716052, i4, -1, "androidx.compose.material3.TabRowDefaults.Indicator (TabRow.kt:1203)");
                    }
                    BoxKt.Box(BackgroundKt.m519backgroundbw27NRU$default(SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), fM3822getActiveIndicatorHeightD9Ej5fM), jFromToken, null, 2, null), composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
                i4 = i3;
                jFromToken = j2;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1454716052, i4, -1, "androidx.compose.material3.TabRowDefaults.Indicator (TabRow.kt:1203)");
                }
                BoxKt.Box(BackgroundKt.m519backgroundbw27NRU$default(SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), fM3822getActiveIndicatorHeightD9Ej5fM), jFromToken, null, 2, null), composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
            } else {
                composerStartRestartGroup.skipToGroupEnd();
                companion = modifier2;
                fM3822getActiveIndicatorHeightD9Ej5fM = f2;
                jFromToken = j2;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i8) {
                        this.$tmp0_rcvr.m2913Indicator9IZ8Weo(companion, fM3822getActiveIndicatorHeightD9Ej5fM, jFromToken, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        f2 = f;
        if ((i & 384) == 0) {
            if ((i2 & 4) == 0) {
                j2 = j;
                if (composerStartRestartGroup.changed(j2)) {
                    i5 = Fields.RotationX;
                }
                i3 |= i5;
            } else {
                j2 = j;
            }
            i5 = Fields.SpotShadowColor;
            i3 |= i5;
        } else {
            j2 = j;
        }
        if ((i3 & 147) == 146) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) == 0) {
                if (i6 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i7 != 0) {
                    fM3822getActiveIndicatorHeightD9Ej5fM = PrimaryNavigationTabTokens.INSTANCE.m3822getActiveIndicatorHeightD9Ej5fM();
                } else {
                    fM3822getActiveIndicatorHeightD9Ej5fM = f2;
                }
                if ((i2 & 4) != 0) {
                    i4 = i3 & (-897);
                    jFromToken = ColorSchemeKt.fromToken(MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6), PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorColor());
                } else {
                    i4 = i3;
                    jFromToken = j2;
                }
            } else {
                if (i6 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i7 != 0) {
                    fM3822getActiveIndicatorHeightD9Ej5fM = PrimaryNavigationTabTokens.INSTANCE.m3822getActiveIndicatorHeightD9Ej5fM();
                } else {
                    fM3822getActiveIndicatorHeightD9Ej5fM = f2;
                }
                if ((i2 & 4) != 0) {
                    i4 = i3 & (-897);
                    jFromToken = ColorSchemeKt.fromToken(MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6), PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorColor());
                } else {
                    i4 = i3;
                    jFromToken = j2;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1454716052, i4, -1, "androidx.compose.material3.TabRowDefaults.Indicator (TabRow.kt:1203)");
            }
            BoxKt.Box(BackgroundKt.m519backgroundbw27NRU$default(SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), fM3822getActiveIndicatorHeightD9Ej5fM), jFromToken, null, 2, null), composerStartRestartGroup, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) == 0) {
                if (i6 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i7 != 0) {
                    fM3822getActiveIndicatorHeightD9Ej5fM = PrimaryNavigationTabTokens.INSTANCE.m3822getActiveIndicatorHeightD9Ej5fM();
                } else {
                    fM3822getActiveIndicatorHeightD9Ej5fM = f2;
                }
                if ((i2 & 4) != 0) {
                    i4 = i3 & (-897);
                    jFromToken = ColorSchemeKt.fromToken(MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6), PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorColor());
                } else {
                    i4 = i3;
                    jFromToken = j2;
                }
            } else {
                if (i6 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i7 != 0) {
                    fM3822getActiveIndicatorHeightD9Ej5fM = PrimaryNavigationTabTokens.INSTANCE.m3822getActiveIndicatorHeightD9Ej5fM();
                } else {
                    fM3822getActiveIndicatorHeightD9Ej5fM = f2;
                }
                if ((i2 & 4) != 0) {
                    i4 = i3 & (-897);
                    jFromToken = ColorSchemeKt.fromToken(MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6), PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorColor());
                } else {
                    i4 = i3;
                    jFromToken = j2;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1454716052, i4, -1, "androidx.compose.material3.TabRowDefaults.Indicator (TabRow.kt:1203)");
            }
            BoxKt.Box(BackgroundKt.m519backgroundbw27NRU$default(SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), fM3822getActiveIndicatorHeightD9Ej5fM), jFromToken, null, 2, null), composerStartRestartGroup, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i8) {
                    this.$tmp0_rcvr.m2913Indicator9IZ8Weo(companion, fM3822getActiveIndicatorHeightD9Ej5fM, jFromToken, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public final void m2914PrimaryIndicator10LGxhE(Modifier modifier, float f, float f2, long j, Shape shape, Composer composer, final int i, final int i2) {
        Modifier modifier2;
        int i3;
        float f3;
        int i4;
        float fM3822getActiveIndicatorHeightD9Ej5fM;
        int i5;
        long value;
        int i6;
        Shape activeIndicatorShape;
        int i7;
        final Modifier.Companion companion;
        final float f4;
        final float f5;
        final long j2;
        final Shape shape2;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i8;
        Composer composerStartRestartGroup = composer.startRestartGroup(-1895596205);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(PrimaryIndicator)P(2,4:c#ui.unit.Dp,1:c#ui.unit.Dp,0:c#ui.graphics.Color)1222@52283L5,1225@52377L174:TabRow.kt#uh7d8r");
        int i9 = i2 & 1;
        if (i9 != 0) {
            i3 = i | 6;
            modifier2 = modifier;
        } else if ((i & 6) == 0) {
            modifier2 = modifier;
            i3 = (composerStartRestartGroup.changed(modifier2) ? 4 : 2) | i;
        } else {
            modifier2 = modifier;
            i3 = i;
        }
        int i10 = i2 & 2;
        if (i10 == 0) {
            if ((i & 48) == 0) {
                f3 = f;
                i3 |= composerStartRestartGroup.changed(f3) ? 32 : 16;
            }
            i4 = i2 & 4;
            if (i4 != 0) {
                if ((i & 384) == 0) {
                    fM3822getActiveIndicatorHeightD9Ej5fM = f2;
                    if (composerStartRestartGroup.changed(fM3822getActiveIndicatorHeightD9Ej5fM)) {
                        i5 = Fields.RotationX;
                    } else {
                        i5 = Fields.SpotShadowColor;
                    }
                    i3 |= i5;
                }
                if ((i & 3072) == 0) {
                    if ((i2 & 8) == 0) {
                        value = j;
                        if (composerStartRestartGroup.changed(value)) {
                            i8 = Fields.CameraDistance;
                        }
                        i3 |= i8;
                    } else {
                        value = j;
                    }
                    i8 = Fields.RotationZ;
                    i3 |= i8;
                } else {
                    value = j;
                }
                i6 = i2 & 16;
                if (i6 != 0) {
                    if ((i & 24576) == 0) {
                        activeIndicatorShape = shape;
                        if (composerStartRestartGroup.changed(activeIndicatorShape)) {
                            i7 = Fields.Clip;
                        } else {
                            i7 = Fields.Shape;
                        }
                        i3 |= i7;
                    }
                    if ((i3 & 9363) == 9362 || !composerStartRestartGroup.getSkipping()) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                            if (i9 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i10 != 0) {
                                f3 = Dp.constructor-impl(24);
                            }
                            if (i4 != 0) {
                                fM3822getActiveIndicatorHeightD9Ej5fM = PrimaryNavigationTabTokens.INSTANCE.m3822getActiveIndicatorHeightD9Ej5fM();
                            }
                            if ((i2 & 8) != 0) {
                                value = ColorSchemeKt.getValue(PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorColor(), composerStartRestartGroup, 6);
                                i3 &= -7169;
                            }
                            if (i6 != 0) {
                                activeIndicatorShape = PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorShape();
                            }
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            if ((i2 & 8) != 0) {
                                i3 &= -7169;
                            }
                            companion = modifier2;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1895596205, i3, -1, "androidx.compose.material3.TabRowDefaults.PrimaryIndicator (TabRow.kt:1224)");
                        }
                        SpacerKt.Spacer(BackgroundKt.m518backgroundbw27NRU(SizeKt.m1077requiredWidth3ABfNKs(SizeKt.m1069requiredHeight3ABfNKs(companion, fM3822getActiveIndicatorHeightD9Ej5fM), f3), value, activeIndicatorShape), composerStartRestartGroup, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        companion = modifier2;
                    }
                    f4 = f3;
                    f5 = fM3822getActiveIndicatorHeightD9Ej5fM;
                    j2 = value;
                    shape2 = activeIndicatorShape;
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11) {
                                this.$tmp0_rcvr.m2914PrimaryIndicator10LGxhE(companion, f4, f5, j2, shape2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 24576;
                activeIndicatorShape = shape;
                if ((i3 & 9363) == 9362) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i9 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i10 != 0) {
                            f3 = Dp.constructor-impl(24);
                        }
                        if (i4 != 0) {
                            fM3822getActiveIndicatorHeightD9Ej5fM = PrimaryNavigationTabTokens.INSTANCE.m3822getActiveIndicatorHeightD9Ej5fM();
                        }
                        if ((i2 & 8) != 0) {
                            value = ColorSchemeKt.getValue(PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorColor(), composerStartRestartGroup, 6);
                            i3 &= -7169;
                        }
                        if (i6 != 0) {
                            activeIndicatorShape = PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorShape();
                        }
                    } else {
                        if (i9 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i10 != 0) {
                            f3 = Dp.constructor-impl(24);
                        }
                        if (i4 != 0) {
                            fM3822getActiveIndicatorHeightD9Ej5fM = PrimaryNavigationTabTokens.INSTANCE.m3822getActiveIndicatorHeightD9Ej5fM();
                        }
                        if ((i2 & 8) != 0) {
                            value = ColorSchemeKt.getValue(PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorColor(), composerStartRestartGroup, 6);
                            i3 &= -7169;
                        }
                        if (i6 != 0) {
                            activeIndicatorShape = PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorShape();
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1895596205, i3, -1, "androidx.compose.material3.TabRowDefaults.PrimaryIndicator (TabRow.kt:1224)");
                    }
                    SpacerKt.Spacer(BackgroundKt.m518backgroundbw27NRU(SizeKt.m1077requiredWidth3ABfNKs(SizeKt.m1069requiredHeight3ABfNKs(companion, fM3822getActiveIndicatorHeightD9Ej5fM), f3), value, activeIndicatorShape), composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i9 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i10 != 0) {
                            f3 = Dp.constructor-impl(24);
                        }
                        if (i4 != 0) {
                            fM3822getActiveIndicatorHeightD9Ej5fM = PrimaryNavigationTabTokens.INSTANCE.m3822getActiveIndicatorHeightD9Ej5fM();
                        }
                        if ((i2 & 8) != 0) {
                            value = ColorSchemeKt.getValue(PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorColor(), composerStartRestartGroup, 6);
                            i3 &= -7169;
                        }
                        if (i6 != 0) {
                            activeIndicatorShape = PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorShape();
                        }
                    } else {
                        if (i9 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i10 != 0) {
                            f3 = Dp.constructor-impl(24);
                        }
                        if (i4 != 0) {
                            fM3822getActiveIndicatorHeightD9Ej5fM = PrimaryNavigationTabTokens.INSTANCE.m3822getActiveIndicatorHeightD9Ej5fM();
                        }
                        if ((i2 & 8) != 0) {
                            value = ColorSchemeKt.getValue(PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorColor(), composerStartRestartGroup, 6);
                            i3 &= -7169;
                        }
                        if (i6 != 0) {
                            activeIndicatorShape = PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorShape();
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1895596205, i3, -1, "androidx.compose.material3.TabRowDefaults.PrimaryIndicator (TabRow.kt:1224)");
                    }
                    SpacerKt.Spacer(BackgroundKt.m518backgroundbw27NRU(SizeKt.m1077requiredWidth3ABfNKs(SizeKt.m1069requiredHeight3ABfNKs(companion, fM3822getActiveIndicatorHeightD9Ej5fM), f3), value, activeIndicatorShape), composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
                f4 = f3;
                f5 = fM3822getActiveIndicatorHeightD9Ej5fM;
                j2 = value;
                shape2 = activeIndicatorShape;
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11) {
                            this.$tmp0_rcvr.m2914PrimaryIndicator10LGxhE(companion, f4, f5, j2, shape2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 384;
            fM3822getActiveIndicatorHeightD9Ej5fM = f2;
            if ((i & 3072) == 0) {
                if ((i2 & 8) == 0) {
                    value = j;
                    if (composerStartRestartGroup.changed(value)) {
                        i8 = Fields.CameraDistance;
                    }
                    i3 |= i8;
                } else {
                    value = j;
                }
                i8 = Fields.RotationZ;
                i3 |= i8;
            } else {
                value = j;
            }
            i6 = i2 & 16;
            if (i6 != 0) {
                if ((i & 24576) == 0) {
                    activeIndicatorShape = shape;
                    if (composerStartRestartGroup.changed(activeIndicatorShape)) {
                        i7 = Fields.Clip;
                    } else {
                        i7 = Fields.Shape;
                    }
                    i3 |= i7;
                }
                if ((i3 & 9363) == 9362) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i9 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i10 != 0) {
                            f3 = Dp.constructor-impl(24);
                        }
                        if (i4 != 0) {
                            fM3822getActiveIndicatorHeightD9Ej5fM = PrimaryNavigationTabTokens.INSTANCE.m3822getActiveIndicatorHeightD9Ej5fM();
                        }
                        if ((i2 & 8) != 0) {
                            value = ColorSchemeKt.getValue(PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorColor(), composerStartRestartGroup, 6);
                            i3 &= -7169;
                        }
                        if (i6 != 0) {
                            activeIndicatorShape = PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorShape();
                        }
                    } else {
                        if (i9 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i10 != 0) {
                            f3 = Dp.constructor-impl(24);
                        }
                        if (i4 != 0) {
                            fM3822getActiveIndicatorHeightD9Ej5fM = PrimaryNavigationTabTokens.INSTANCE.m3822getActiveIndicatorHeightD9Ej5fM();
                        }
                        if ((i2 & 8) != 0) {
                            value = ColorSchemeKt.getValue(PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorColor(), composerStartRestartGroup, 6);
                            i3 &= -7169;
                        }
                        if (i6 != 0) {
                            activeIndicatorShape = PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorShape();
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1895596205, i3, -1, "androidx.compose.material3.TabRowDefaults.PrimaryIndicator (TabRow.kt:1224)");
                    }
                    SpacerKt.Spacer(BackgroundKt.m518backgroundbw27NRU(SizeKt.m1077requiredWidth3ABfNKs(SizeKt.m1069requiredHeight3ABfNKs(companion, fM3822getActiveIndicatorHeightD9Ej5fM), f3), value, activeIndicatorShape), composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i9 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i10 != 0) {
                            f3 = Dp.constructor-impl(24);
                        }
                        if (i4 != 0) {
                            fM3822getActiveIndicatorHeightD9Ej5fM = PrimaryNavigationTabTokens.INSTANCE.m3822getActiveIndicatorHeightD9Ej5fM();
                        }
                        if ((i2 & 8) != 0) {
                            value = ColorSchemeKt.getValue(PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorColor(), composerStartRestartGroup, 6);
                            i3 &= -7169;
                        }
                        if (i6 != 0) {
                            activeIndicatorShape = PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorShape();
                        }
                    } else {
                        if (i9 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i10 != 0) {
                            f3 = Dp.constructor-impl(24);
                        }
                        if (i4 != 0) {
                            fM3822getActiveIndicatorHeightD9Ej5fM = PrimaryNavigationTabTokens.INSTANCE.m3822getActiveIndicatorHeightD9Ej5fM();
                        }
                        if ((i2 & 8) != 0) {
                            value = ColorSchemeKt.getValue(PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorColor(), composerStartRestartGroup, 6);
                            i3 &= -7169;
                        }
                        if (i6 != 0) {
                            activeIndicatorShape = PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorShape();
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1895596205, i3, -1, "androidx.compose.material3.TabRowDefaults.PrimaryIndicator (TabRow.kt:1224)");
                    }
                    SpacerKt.Spacer(BackgroundKt.m518backgroundbw27NRU(SizeKt.m1077requiredWidth3ABfNKs(SizeKt.m1069requiredHeight3ABfNKs(companion, fM3822getActiveIndicatorHeightD9Ej5fM), f3), value, activeIndicatorShape), composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
                f4 = f3;
                f5 = fM3822getActiveIndicatorHeightD9Ej5fM;
                j2 = value;
                shape2 = activeIndicatorShape;
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11) {
                            this.$tmp0_rcvr.m2914PrimaryIndicator10LGxhE(companion, f4, f5, j2, shape2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            activeIndicatorShape = shape;
            if ((i3 & 9363) == 9362) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i10 != 0) {
                        f3 = Dp.constructor-impl(24);
                    }
                    if (i4 != 0) {
                        fM3822getActiveIndicatorHeightD9Ej5fM = PrimaryNavigationTabTokens.INSTANCE.m3822getActiveIndicatorHeightD9Ej5fM();
                    }
                    if ((i2 & 8) != 0) {
                        value = ColorSchemeKt.getValue(PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorColor(), composerStartRestartGroup, 6);
                        i3 &= -7169;
                    }
                    if (i6 != 0) {
                        activeIndicatorShape = PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorShape();
                    }
                } else {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i10 != 0) {
                        f3 = Dp.constructor-impl(24);
                    }
                    if (i4 != 0) {
                        fM3822getActiveIndicatorHeightD9Ej5fM = PrimaryNavigationTabTokens.INSTANCE.m3822getActiveIndicatorHeightD9Ej5fM();
                    }
                    if ((i2 & 8) != 0) {
                        value = ColorSchemeKt.getValue(PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorColor(), composerStartRestartGroup, 6);
                        i3 &= -7169;
                    }
                    if (i6 != 0) {
                        activeIndicatorShape = PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorShape();
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1895596205, i3, -1, "androidx.compose.material3.TabRowDefaults.PrimaryIndicator (TabRow.kt:1224)");
                }
                SpacerKt.Spacer(BackgroundKt.m518backgroundbw27NRU(SizeKt.m1077requiredWidth3ABfNKs(SizeKt.m1069requiredHeight3ABfNKs(companion, fM3822getActiveIndicatorHeightD9Ej5fM), f3), value, activeIndicatorShape), composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i10 != 0) {
                        f3 = Dp.constructor-impl(24);
                    }
                    if (i4 != 0) {
                        fM3822getActiveIndicatorHeightD9Ej5fM = PrimaryNavigationTabTokens.INSTANCE.m3822getActiveIndicatorHeightD9Ej5fM();
                    }
                    if ((i2 & 8) != 0) {
                        value = ColorSchemeKt.getValue(PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorColor(), composerStartRestartGroup, 6);
                        i3 &= -7169;
                    }
                    if (i6 != 0) {
                        activeIndicatorShape = PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorShape();
                    }
                } else {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i10 != 0) {
                        f3 = Dp.constructor-impl(24);
                    }
                    if (i4 != 0) {
                        fM3822getActiveIndicatorHeightD9Ej5fM = PrimaryNavigationTabTokens.INSTANCE.m3822getActiveIndicatorHeightD9Ej5fM();
                    }
                    if ((i2 & 8) != 0) {
                        value = ColorSchemeKt.getValue(PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorColor(), composerStartRestartGroup, 6);
                        i3 &= -7169;
                    }
                    if (i6 != 0) {
                        activeIndicatorShape = PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorShape();
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1895596205, i3, -1, "androidx.compose.material3.TabRowDefaults.PrimaryIndicator (TabRow.kt:1224)");
                }
                SpacerKt.Spacer(BackgroundKt.m518backgroundbw27NRU(SizeKt.m1077requiredWidth3ABfNKs(SizeKt.m1069requiredHeight3ABfNKs(companion, fM3822getActiveIndicatorHeightD9Ej5fM), f3), value, activeIndicatorShape), composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
            }
            f4 = f3;
            f5 = fM3822getActiveIndicatorHeightD9Ej5fM;
            j2 = value;
            shape2 = activeIndicatorShape;
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11) {
                        this.$tmp0_rcvr.m2914PrimaryIndicator10LGxhE(companion, f4, f5, j2, shape2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        f3 = f;
        i4 = i2 & 4;
        if (i4 != 0) {
            if ((i & 384) == 0) {
                fM3822getActiveIndicatorHeightD9Ej5fM = f2;
                if (composerStartRestartGroup.changed(fM3822getActiveIndicatorHeightD9Ej5fM)) {
                    i5 = Fields.RotationX;
                } else {
                    i5 = Fields.SpotShadowColor;
                }
                i3 |= i5;
            }
            if ((i & 3072) == 0) {
                if ((i2 & 8) == 0) {
                    value = j;
                    if (composerStartRestartGroup.changed(value)) {
                        i8 = Fields.CameraDistance;
                    }
                    i3 |= i8;
                } else {
                    value = j;
                }
                i8 = Fields.RotationZ;
                i3 |= i8;
            } else {
                value = j;
            }
            i6 = i2 & 16;
            if (i6 != 0) {
                if ((i & 24576) == 0) {
                    activeIndicatorShape = shape;
                    if (composerStartRestartGroup.changed(activeIndicatorShape)) {
                        i7 = Fields.Clip;
                    } else {
                        i7 = Fields.Shape;
                    }
                    i3 |= i7;
                }
                if ((i3 & 9363) == 9362) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i9 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i10 != 0) {
                            f3 = Dp.constructor-impl(24);
                        }
                        if (i4 != 0) {
                            fM3822getActiveIndicatorHeightD9Ej5fM = PrimaryNavigationTabTokens.INSTANCE.m3822getActiveIndicatorHeightD9Ej5fM();
                        }
                        if ((i2 & 8) != 0) {
                            value = ColorSchemeKt.getValue(PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorColor(), composerStartRestartGroup, 6);
                            i3 &= -7169;
                        }
                        if (i6 != 0) {
                            activeIndicatorShape = PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorShape();
                        }
                    } else {
                        if (i9 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i10 != 0) {
                            f3 = Dp.constructor-impl(24);
                        }
                        if (i4 != 0) {
                            fM3822getActiveIndicatorHeightD9Ej5fM = PrimaryNavigationTabTokens.INSTANCE.m3822getActiveIndicatorHeightD9Ej5fM();
                        }
                        if ((i2 & 8) != 0) {
                            value = ColorSchemeKt.getValue(PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorColor(), composerStartRestartGroup, 6);
                            i3 &= -7169;
                        }
                        if (i6 != 0) {
                            activeIndicatorShape = PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorShape();
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1895596205, i3, -1, "androidx.compose.material3.TabRowDefaults.PrimaryIndicator (TabRow.kt:1224)");
                    }
                    SpacerKt.Spacer(BackgroundKt.m518backgroundbw27NRU(SizeKt.m1077requiredWidth3ABfNKs(SizeKt.m1069requiredHeight3ABfNKs(companion, fM3822getActiveIndicatorHeightD9Ej5fM), f3), value, activeIndicatorShape), composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i9 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i10 != 0) {
                            f3 = Dp.constructor-impl(24);
                        }
                        if (i4 != 0) {
                            fM3822getActiveIndicatorHeightD9Ej5fM = PrimaryNavigationTabTokens.INSTANCE.m3822getActiveIndicatorHeightD9Ej5fM();
                        }
                        if ((i2 & 8) != 0) {
                            value = ColorSchemeKt.getValue(PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorColor(), composerStartRestartGroup, 6);
                            i3 &= -7169;
                        }
                        if (i6 != 0) {
                            activeIndicatorShape = PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorShape();
                        }
                    } else {
                        if (i9 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i10 != 0) {
                            f3 = Dp.constructor-impl(24);
                        }
                        if (i4 != 0) {
                            fM3822getActiveIndicatorHeightD9Ej5fM = PrimaryNavigationTabTokens.INSTANCE.m3822getActiveIndicatorHeightD9Ej5fM();
                        }
                        if ((i2 & 8) != 0) {
                            value = ColorSchemeKt.getValue(PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorColor(), composerStartRestartGroup, 6);
                            i3 &= -7169;
                        }
                        if (i6 != 0) {
                            activeIndicatorShape = PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorShape();
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1895596205, i3, -1, "androidx.compose.material3.TabRowDefaults.PrimaryIndicator (TabRow.kt:1224)");
                    }
                    SpacerKt.Spacer(BackgroundKt.m518backgroundbw27NRU(SizeKt.m1077requiredWidth3ABfNKs(SizeKt.m1069requiredHeight3ABfNKs(companion, fM3822getActiveIndicatorHeightD9Ej5fM), f3), value, activeIndicatorShape), composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
                f4 = f3;
                f5 = fM3822getActiveIndicatorHeightD9Ej5fM;
                j2 = value;
                shape2 = activeIndicatorShape;
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11) {
                            this.$tmp0_rcvr.m2914PrimaryIndicator10LGxhE(companion, f4, f5, j2, shape2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            activeIndicatorShape = shape;
            if ((i3 & 9363) == 9362) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i10 != 0) {
                        f3 = Dp.constructor-impl(24);
                    }
                    if (i4 != 0) {
                        fM3822getActiveIndicatorHeightD9Ej5fM = PrimaryNavigationTabTokens.INSTANCE.m3822getActiveIndicatorHeightD9Ej5fM();
                    }
                    if ((i2 & 8) != 0) {
                        value = ColorSchemeKt.getValue(PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorColor(), composerStartRestartGroup, 6);
                        i3 &= -7169;
                    }
                    if (i6 != 0) {
                        activeIndicatorShape = PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorShape();
                    }
                } else {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i10 != 0) {
                        f3 = Dp.constructor-impl(24);
                    }
                    if (i4 != 0) {
                        fM3822getActiveIndicatorHeightD9Ej5fM = PrimaryNavigationTabTokens.INSTANCE.m3822getActiveIndicatorHeightD9Ej5fM();
                    }
                    if ((i2 & 8) != 0) {
                        value = ColorSchemeKt.getValue(PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorColor(), composerStartRestartGroup, 6);
                        i3 &= -7169;
                    }
                    if (i6 != 0) {
                        activeIndicatorShape = PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorShape();
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1895596205, i3, -1, "androidx.compose.material3.TabRowDefaults.PrimaryIndicator (TabRow.kt:1224)");
                }
                SpacerKt.Spacer(BackgroundKt.m518backgroundbw27NRU(SizeKt.m1077requiredWidth3ABfNKs(SizeKt.m1069requiredHeight3ABfNKs(companion, fM3822getActiveIndicatorHeightD9Ej5fM), f3), value, activeIndicatorShape), composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i10 != 0) {
                        f3 = Dp.constructor-impl(24);
                    }
                    if (i4 != 0) {
                        fM3822getActiveIndicatorHeightD9Ej5fM = PrimaryNavigationTabTokens.INSTANCE.m3822getActiveIndicatorHeightD9Ej5fM();
                    }
                    if ((i2 & 8) != 0) {
                        value = ColorSchemeKt.getValue(PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorColor(), composerStartRestartGroup, 6);
                        i3 &= -7169;
                    }
                    if (i6 != 0) {
                        activeIndicatorShape = PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorShape();
                    }
                } else {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i10 != 0) {
                        f3 = Dp.constructor-impl(24);
                    }
                    if (i4 != 0) {
                        fM3822getActiveIndicatorHeightD9Ej5fM = PrimaryNavigationTabTokens.INSTANCE.m3822getActiveIndicatorHeightD9Ej5fM();
                    }
                    if ((i2 & 8) != 0) {
                        value = ColorSchemeKt.getValue(PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorColor(), composerStartRestartGroup, 6);
                        i3 &= -7169;
                    }
                    if (i6 != 0) {
                        activeIndicatorShape = PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorShape();
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1895596205, i3, -1, "androidx.compose.material3.TabRowDefaults.PrimaryIndicator (TabRow.kt:1224)");
                }
                SpacerKt.Spacer(BackgroundKt.m518backgroundbw27NRU(SizeKt.m1077requiredWidth3ABfNKs(SizeKt.m1069requiredHeight3ABfNKs(companion, fM3822getActiveIndicatorHeightD9Ej5fM), f3), value, activeIndicatorShape), composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
            }
            f4 = f3;
            f5 = fM3822getActiveIndicatorHeightD9Ej5fM;
            j2 = value;
            shape2 = activeIndicatorShape;
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11) {
                        this.$tmp0_rcvr.m2914PrimaryIndicator10LGxhE(companion, f4, f5, j2, shape2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 384;
        fM3822getActiveIndicatorHeightD9Ej5fM = f2;
        if ((i & 3072) == 0) {
            if ((i2 & 8) == 0) {
                value = j;
                if (composerStartRestartGroup.changed(value)) {
                    i8 = Fields.CameraDistance;
                }
                i3 |= i8;
            } else {
                value = j;
            }
            i8 = Fields.RotationZ;
            i3 |= i8;
        } else {
            value = j;
        }
        i6 = i2 & 16;
        if (i6 != 0) {
            if ((i & 24576) == 0) {
                activeIndicatorShape = shape;
                if (composerStartRestartGroup.changed(activeIndicatorShape)) {
                    i7 = Fields.Clip;
                } else {
                    i7 = Fields.Shape;
                }
                i3 |= i7;
            }
            if ((i3 & 9363) == 9362) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i10 != 0) {
                        f3 = Dp.constructor-impl(24);
                    }
                    if (i4 != 0) {
                        fM3822getActiveIndicatorHeightD9Ej5fM = PrimaryNavigationTabTokens.INSTANCE.m3822getActiveIndicatorHeightD9Ej5fM();
                    }
                    if ((i2 & 8) != 0) {
                        value = ColorSchemeKt.getValue(PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorColor(), composerStartRestartGroup, 6);
                        i3 &= -7169;
                    }
                    if (i6 != 0) {
                        activeIndicatorShape = PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorShape();
                    }
                } else {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i10 != 0) {
                        f3 = Dp.constructor-impl(24);
                    }
                    if (i4 != 0) {
                        fM3822getActiveIndicatorHeightD9Ej5fM = PrimaryNavigationTabTokens.INSTANCE.m3822getActiveIndicatorHeightD9Ej5fM();
                    }
                    if ((i2 & 8) != 0) {
                        value = ColorSchemeKt.getValue(PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorColor(), composerStartRestartGroup, 6);
                        i3 &= -7169;
                    }
                    if (i6 != 0) {
                        activeIndicatorShape = PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorShape();
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1895596205, i3, -1, "androidx.compose.material3.TabRowDefaults.PrimaryIndicator (TabRow.kt:1224)");
                }
                SpacerKt.Spacer(BackgroundKt.m518backgroundbw27NRU(SizeKt.m1077requiredWidth3ABfNKs(SizeKt.m1069requiredHeight3ABfNKs(companion, fM3822getActiveIndicatorHeightD9Ej5fM), f3), value, activeIndicatorShape), composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i10 != 0) {
                        f3 = Dp.constructor-impl(24);
                    }
                    if (i4 != 0) {
                        fM3822getActiveIndicatorHeightD9Ej5fM = PrimaryNavigationTabTokens.INSTANCE.m3822getActiveIndicatorHeightD9Ej5fM();
                    }
                    if ((i2 & 8) != 0) {
                        value = ColorSchemeKt.getValue(PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorColor(), composerStartRestartGroup, 6);
                        i3 &= -7169;
                    }
                    if (i6 != 0) {
                        activeIndicatorShape = PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorShape();
                    }
                } else {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i10 != 0) {
                        f3 = Dp.constructor-impl(24);
                    }
                    if (i4 != 0) {
                        fM3822getActiveIndicatorHeightD9Ej5fM = PrimaryNavigationTabTokens.INSTANCE.m3822getActiveIndicatorHeightD9Ej5fM();
                    }
                    if ((i2 & 8) != 0) {
                        value = ColorSchemeKt.getValue(PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorColor(), composerStartRestartGroup, 6);
                        i3 &= -7169;
                    }
                    if (i6 != 0) {
                        activeIndicatorShape = PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorShape();
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1895596205, i3, -1, "androidx.compose.material3.TabRowDefaults.PrimaryIndicator (TabRow.kt:1224)");
                }
                SpacerKt.Spacer(BackgroundKt.m518backgroundbw27NRU(SizeKt.m1077requiredWidth3ABfNKs(SizeKt.m1069requiredHeight3ABfNKs(companion, fM3822getActiveIndicatorHeightD9Ej5fM), f3), value, activeIndicatorShape), composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
            }
            f4 = f3;
            f5 = fM3822getActiveIndicatorHeightD9Ej5fM;
            j2 = value;
            shape2 = activeIndicatorShape;
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11) {
                        this.$tmp0_rcvr.m2914PrimaryIndicator10LGxhE(companion, f4, f5, j2, shape2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 24576;
        activeIndicatorShape = shape;
        if ((i3 & 9363) == 9362) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i9 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i10 != 0) {
                    f3 = Dp.constructor-impl(24);
                }
                if (i4 != 0) {
                    fM3822getActiveIndicatorHeightD9Ej5fM = PrimaryNavigationTabTokens.INSTANCE.m3822getActiveIndicatorHeightD9Ej5fM();
                }
                if ((i2 & 8) != 0) {
                    value = ColorSchemeKt.getValue(PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorColor(), composerStartRestartGroup, 6);
                    i3 &= -7169;
                }
                if (i6 != 0) {
                    activeIndicatorShape = PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorShape();
                }
            } else {
                if (i9 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i10 != 0) {
                    f3 = Dp.constructor-impl(24);
                }
                if (i4 != 0) {
                    fM3822getActiveIndicatorHeightD9Ej5fM = PrimaryNavigationTabTokens.INSTANCE.m3822getActiveIndicatorHeightD9Ej5fM();
                }
                if ((i2 & 8) != 0) {
                    value = ColorSchemeKt.getValue(PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorColor(), composerStartRestartGroup, 6);
                    i3 &= -7169;
                }
                if (i6 != 0) {
                    activeIndicatorShape = PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorShape();
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1895596205, i3, -1, "androidx.compose.material3.TabRowDefaults.PrimaryIndicator (TabRow.kt:1224)");
            }
            SpacerKt.Spacer(BackgroundKt.m518backgroundbw27NRU(SizeKt.m1077requiredWidth3ABfNKs(SizeKt.m1069requiredHeight3ABfNKs(companion, fM3822getActiveIndicatorHeightD9Ej5fM), f3), value, activeIndicatorShape), composerStartRestartGroup, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i9 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i10 != 0) {
                    f3 = Dp.constructor-impl(24);
                }
                if (i4 != 0) {
                    fM3822getActiveIndicatorHeightD9Ej5fM = PrimaryNavigationTabTokens.INSTANCE.m3822getActiveIndicatorHeightD9Ej5fM();
                }
                if ((i2 & 8) != 0) {
                    value = ColorSchemeKt.getValue(PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorColor(), composerStartRestartGroup, 6);
                    i3 &= -7169;
                }
                if (i6 != 0) {
                    activeIndicatorShape = PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorShape();
                }
            } else {
                if (i9 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i10 != 0) {
                    f3 = Dp.constructor-impl(24);
                }
                if (i4 != 0) {
                    fM3822getActiveIndicatorHeightD9Ej5fM = PrimaryNavigationTabTokens.INSTANCE.m3822getActiveIndicatorHeightD9Ej5fM();
                }
                if ((i2 & 8) != 0) {
                    value = ColorSchemeKt.getValue(PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorColor(), composerStartRestartGroup, 6);
                    i3 &= -7169;
                }
                if (i6 != 0) {
                    activeIndicatorShape = PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorShape();
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1895596205, i3, -1, "androidx.compose.material3.TabRowDefaults.PrimaryIndicator (TabRow.kt:1224)");
            }
            SpacerKt.Spacer(BackgroundKt.m518backgroundbw27NRU(SizeKt.m1077requiredWidth3ABfNKs(SizeKt.m1069requiredHeight3ABfNKs(companion, fM3822getActiveIndicatorHeightD9Ej5fM), f3), value, activeIndicatorShape), composerStartRestartGroup, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        }
        f4 = f3;
        f5 = fM3822getActiveIndicatorHeightD9Ej5fM;
        j2 = value;
        shape2 = activeIndicatorShape;
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i11) {
                    this.$tmp0_rcvr.m2914PrimaryIndicator10LGxhE(companion, f4, f5, j2, shape2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public final void m2915SecondaryIndicator9IZ8Weo(Modifier modifier, float f, long j, Composer composer, final int i, final int i2) {
        Modifier modifier2;
        int i3;
        float f2;
        long j2;
        final Modifier.Companion companion;
        final float fM3822getActiveIndicatorHeightD9Ej5fM;
        int i4;
        final long value;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i5;
        Composer composerStartRestartGroup = composer.startRestartGroup(-1498258020);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(SecondaryIndicator)P(2,1:c#ui.unit.Dp,0:c#ui.graphics.Color)1245@53068L5,1247@53090L69:TabRow.kt#uh7d8r");
        int i6 = i2 & 1;
        if (i6 != 0) {
            i3 = i | 6;
            modifier2 = modifier;
        } else if ((i & 6) == 0) {
            modifier2 = modifier;
            i3 = (composerStartRestartGroup.changed(modifier2) ? 4 : 2) | i;
        } else {
            modifier2 = modifier;
            i3 = i;
        }
        int i7 = i2 & 2;
        if (i7 == 0) {
            if ((i & 48) == 0) {
                f2 = f;
                i3 |= composerStartRestartGroup.changed(f2) ? 32 : 16;
            }
            if ((i & 384) == 0) {
                if ((i2 & 4) == 0) {
                    j2 = j;
                    if (composerStartRestartGroup.changed(j2)) {
                        i5 = Fields.RotationX;
                    }
                    i3 |= i5;
                } else {
                    j2 = j;
                }
                i5 = Fields.SpotShadowColor;
                i3 |= i5;
            } else {
                j2 = j;
            }
            if ((i3 & 147) == 146 || !composerStartRestartGroup.getSkipping()) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) == 0 && !composerStartRestartGroup.getDefaultsInvalid()) {
                    composerStartRestartGroup.skipToGroupEnd();
                    if ((i2 & 4) != 0) {
                        i3 &= -897;
                    }
                    companion = modifier2;
                    fM3822getActiveIndicatorHeightD9Ej5fM = f2;
                } else {
                    if (i6 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i7 != 0) {
                        fM3822getActiveIndicatorHeightD9Ej5fM = PrimaryNavigationTabTokens.INSTANCE.m3822getActiveIndicatorHeightD9Ej5fM();
                    } else {
                        fM3822getActiveIndicatorHeightD9Ej5fM = f2;
                    }
                    if ((i2 & 4) != 0) {
                        i4 = i3 & (-897);
                        value = ColorSchemeKt.getValue(PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorColor(), composerStartRestartGroup, 6);
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1498258020, i4, -1, "androidx.compose.material3.TabRowDefaults.SecondaryIndicator (TabRow.kt:1246)");
                    }
                    BoxKt.Box(BackgroundKt.m519backgroundbw27NRU$default(SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), fM3822getActiveIndicatorHeightD9Ej5fM), value, null, 2, null), composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
                i4 = i3;
                value = j2;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1498258020, i4, -1, "androidx.compose.material3.TabRowDefaults.SecondaryIndicator (TabRow.kt:1246)");
                }
                BoxKt.Box(BackgroundKt.m519backgroundbw27NRU$default(SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), fM3822getActiveIndicatorHeightD9Ej5fM), value, null, 2, null), composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
            } else {
                composerStartRestartGroup.skipToGroupEnd();
                companion = modifier2;
                fM3822getActiveIndicatorHeightD9Ej5fM = f2;
                value = j2;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i8) {
                        this.$tmp0_rcvr.m2915SecondaryIndicator9IZ8Weo(companion, fM3822getActiveIndicatorHeightD9Ej5fM, value, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        f2 = f;
        if ((i & 384) == 0) {
            if ((i2 & 4) == 0) {
                j2 = j;
                if (composerStartRestartGroup.changed(j2)) {
                    i5 = Fields.RotationX;
                }
                i3 |= i5;
            } else {
                j2 = j;
            }
            i5 = Fields.SpotShadowColor;
            i3 |= i5;
        } else {
            j2 = j;
        }
        if ((i3 & 147) == 146) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) == 0) {
                if (i6 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i7 != 0) {
                    fM3822getActiveIndicatorHeightD9Ej5fM = PrimaryNavigationTabTokens.INSTANCE.m3822getActiveIndicatorHeightD9Ej5fM();
                } else {
                    fM3822getActiveIndicatorHeightD9Ej5fM = f2;
                }
                if ((i2 & 4) != 0) {
                    i4 = i3 & (-897);
                    value = ColorSchemeKt.getValue(PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorColor(), composerStartRestartGroup, 6);
                } else {
                    i4 = i3;
                    value = j2;
                }
            } else {
                if (i6 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i7 != 0) {
                    fM3822getActiveIndicatorHeightD9Ej5fM = PrimaryNavigationTabTokens.INSTANCE.m3822getActiveIndicatorHeightD9Ej5fM();
                } else {
                    fM3822getActiveIndicatorHeightD9Ej5fM = f2;
                }
                if ((i2 & 4) != 0) {
                    i4 = i3 & (-897);
                    value = ColorSchemeKt.getValue(PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorColor(), composerStartRestartGroup, 6);
                } else {
                    i4 = i3;
                    value = j2;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1498258020, i4, -1, "androidx.compose.material3.TabRowDefaults.SecondaryIndicator (TabRow.kt:1246)");
            }
            BoxKt.Box(BackgroundKt.m519backgroundbw27NRU$default(SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), fM3822getActiveIndicatorHeightD9Ej5fM), value, null, 2, null), composerStartRestartGroup, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) == 0) {
                if (i6 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i7 != 0) {
                    fM3822getActiveIndicatorHeightD9Ej5fM = PrimaryNavigationTabTokens.INSTANCE.m3822getActiveIndicatorHeightD9Ej5fM();
                } else {
                    fM3822getActiveIndicatorHeightD9Ej5fM = f2;
                }
                if ((i2 & 4) != 0) {
                    i4 = i3 & (-897);
                    value = ColorSchemeKt.getValue(PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorColor(), composerStartRestartGroup, 6);
                } else {
                    i4 = i3;
                    value = j2;
                }
            } else {
                if (i6 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i7 != 0) {
                    fM3822getActiveIndicatorHeightD9Ej5fM = PrimaryNavigationTabTokens.INSTANCE.m3822getActiveIndicatorHeightD9Ej5fM();
                } else {
                    fM3822getActiveIndicatorHeightD9Ej5fM = f2;
                }
                if ((i2 & 4) != 0) {
                    i4 = i3 & (-897);
                    value = ColorSchemeKt.getValue(PrimaryNavigationTabTokens.INSTANCE.getActiveIndicatorColor(), composerStartRestartGroup, 6);
                } else {
                    i4 = i3;
                    value = j2;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1498258020, i4, -1, "androidx.compose.material3.TabRowDefaults.SecondaryIndicator (TabRow.kt:1246)");
            }
            BoxKt.Box(BackgroundKt.m519backgroundbw27NRU$default(SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), fM3822getActiveIndicatorHeightD9Ej5fM), value, null, 2, null), composerStartRestartGroup, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i8) {
                    this.$tmp0_rcvr.m2915SecondaryIndicator9IZ8Weo(companion, fM3822getActiveIndicatorHeightD9Ej5fM, value, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0001H\u000b¢\u0006\u0004\b\u0002\u0010\u0003"}, d2 = {"<anonymous>", "Landroidx/compose/ui/Modifier;", "invoke", "(Landroidx/compose/ui/Modifier;Landroidx/compose/runtime/Composer;I)Landroidx/compose/ui/Modifier;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    static final class C13922 extends Lambda implements Function3<Modifier, Composer, Integer, Modifier> {
        final TabPosition $currentTabPosition;

        C13922(TabPosition tabPosition) {
            super(3);
            this.$currentTabPosition = tabPosition;
        }

        public Object invoke(Object obj, Object obj2, Object obj3) {
            return invoke((Modifier) obj, (Composer) obj2, ((Number) obj3).intValue());
        }

        public final Modifier invoke(Modifier modifier, Composer composer, int i) {
            composer.startReplaceGroup(-1541271084);
            ComposerKt.sourceInformation(composer, "C1266@53909L151,1271@54112L150,1277@54370L53:TabRow.kt#uh7d8r");
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1541271084, i, -1, "androidx.compose.material3.TabRowDefaults.tabIndicatorOffset.<anonymous> (TabRow.kt:1265)");
            }
            State<Dp> stateM401animateDpAsStateAjpBEmI = AnimateAsStateKt.m401animateDpAsStateAjpBEmI(this.$currentTabPosition.getWidth(), TabRowKt.TabRowIndicatorSpec, null, null, composer, 0, 12);
            final State<Dp> stateM401animateDpAsStateAjpBEmI2 = AnimateAsStateKt.m401animateDpAsStateAjpBEmI(this.$currentTabPosition.getLeft(), TabRowKt.TabRowIndicatorSpec, null, null, composer, 0, 12);
            Modifier modifierWrapContentSize$default = SizeKt.wrapContentSize$default(SizeKt.fillMaxWidth$default(modifier, 0.0f, 1, null), Alignment.INSTANCE.getBottomStart(), false, 2, null);
            ComposerKt.sourceInformationMarkerStart(composer, -1825077707, "CC(remember):TabRow.kt#9igjgp");
            boolean zChanged = composer.changed(stateM401animateDpAsStateAjpBEmI2);
            Object objRememberedValue = composer.rememberedValue();
            if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                objRememberedValue = (Function1) new Function1<Density, IntOffset>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        return IntOffset.box-impl(m2917invokeBjo55l4((Density) obj));
                    }

                    public final long m2917invokeBjo55l4(Density density) {
                        return IntOffsetKt.IntOffset(density.roundToPx-0680j_4(TabRowDefaults.C13922.invoke$lambda$1(stateM401animateDpAsStateAjpBEmI2)), 0);
                    }
                };
                composer.updateRememberedValue(objRememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composer);
            Modifier modifierM1085width3ABfNKs = SizeKt.m1085width3ABfNKs(OffsetKt.offset(modifierWrapContentSize$default, (Function1) objRememberedValue), invoke$lambda$0(stateM401animateDpAsStateAjpBEmI));
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            composer.endReplaceGroup();
            return modifierM1085width3ABfNKs;
        }

        private static final float invoke$lambda$0(State<Dp> state) {
            return state.getValue().unbox-impl();
        }

        public static final float invoke$lambda$1(State<Dp> state) {
            return state.getValue().unbox-impl();
        }
    }

    public final Modifier tabIndicatorOffset(Modifier modifier, final TabPosition tabPosition) {
        return ComposedModifierKt.composed(modifier, InspectableValueKt.isDebugInspectorInfoEnabled() ? new Function1<InspectorInfo, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((InspectorInfo) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(InspectorInfo inspectorInfo) {
                inspectorInfo.setName("tabIndicatorOffset");
                inspectorInfo.setValue(tabPosition);
            }
        } : InspectableValueKt.getNoInspectorInfo(), new C13922(tabPosition));
    }
}
