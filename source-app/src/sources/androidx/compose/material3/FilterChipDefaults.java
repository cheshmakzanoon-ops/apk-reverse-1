package androidx.compose.material3;

import androidx.compose.foundation.BorderStroke;
import androidx.compose.foundation.BorderStrokeKt;
import androidx.compose.material3.tokens.FilterChipTokens;
import androidx.compose.p002ui.graphics.Color;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.graphics.Shape;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000F\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u000e\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u000e\bÇ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\r\u0010\u0015\u001a\u00020\u000fH\u0007¢\u0006\u0002\u0010\u0016J\u008a\u0001\u0010\u0015\u001a\u00020\u000f2\b\b\u0002\u0010\u0017\u001a\u00020\u00182\b\b\u0002\u0010\u0019\u001a\u00020\u00182\b\b\u0002\u0010\u001a\u001a\u00020\u00182\b\b\u0002\u0010\u001b\u001a\u00020\u00182\b\b\u0002\u0010\u001c\u001a\u00020\u00182\b\b\u0002\u0010\u001d\u001a\u00020\u00182\b\b\u0002\u0010\u001e\u001a\u00020\u00182\b\b\u0002\u0010\u001f\u001a\u00020\u00182\b\b\u0002\u0010 \u001a\u00020\u00182\b\b\u0002\u0010!\u001a\u00020\u00182\b\b\u0002\u0010\"\u001a\u00020\u00182\b\b\u0002\u0010#\u001a\u00020\u0018H\u0007ø\u0001\u0000¢\u0006\u0004\b$\u0010%JN\u0010&\u001a\u00020'2\b\b\u0002\u0010(\u001a\u00020\u00042\b\b\u0002\u0010)\u001a\u00020\u00042\b\b\u0002\u0010*\u001a\u00020\u00042\b\b\u0002\u0010+\u001a\u00020\u00042\b\b\u0002\u0010,\u001a\u00020\u00042\b\b\u0002\u0010-\u001a\u00020\u0004H\u0007ø\u0001\u0000¢\u0006\u0004\b.\u0010/J^\u00100\u001a\u0002012\u0006\u00102\u001a\u0002032\u0006\u00104\u001a\u0002032\b\b\u0002\u00105\u001a\u00020\u00182\b\b\u0002\u00106\u001a\u00020\u00182\b\b\u0002\u00107\u001a\u00020\u00182\b\b\u0002\u00108\u001a\u00020\u00182\b\b\u0002\u00109\u001a\u00020\u00042\b\b\u0002\u0010:\u001a\u00020\u0004H\u0007ø\u0001\u0000¢\u0006\u0004\b;\u0010<J\r\u0010=\u001a\u00020\u000fH\u0007¢\u0006\u0002\u0010\u0016J\u008a\u0001\u0010=\u001a\u00020\u000f2\b\b\u0002\u0010\u0017\u001a\u00020\u00182\b\b\u0002\u0010\u0019\u001a\u00020\u00182\b\b\u0002\u0010\u001a\u001a\u00020\u00182\b\b\u0002\u0010\u001b\u001a\u00020\u00182\b\b\u0002\u0010\u001c\u001a\u00020\u00182\b\b\u0002\u0010\u001d\u001a\u00020\u00182\b\b\u0002\u0010\u001e\u001a\u00020\u00182\b\b\u0002\u0010\u001f\u001a\u00020\u00182\b\b\u0002\u0010 \u001a\u00020\u00182\b\b\u0002\u0010!\u001a\u00020\u00182\b\b\u0002\u0010\"\u001a\u00020\u00182\b\b\u0002\u0010#\u001a\u00020\u0018H\u0007ø\u0001\u0000¢\u0006\u0004\b>\u0010%JN\u0010?\u001a\u00020'2\b\b\u0002\u0010(\u001a\u00020\u00042\b\b\u0002\u0010)\u001a\u00020\u00042\b\b\u0002\u0010*\u001a\u00020\u00042\b\b\u0002\u0010+\u001a\u00020\u00042\b\b\u0002\u0010,\u001a\u00020\u00042\b\b\u0002\u0010-\u001a\u00020\u0004H\u0007ø\u0001\u0000¢\u0006\u0004\b@\u0010/R\u0019\u0010\u0003\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0005\u0010\u0006R\u0019\u0010\b\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\t\u0010\u0006R\u0011\u0010\n\u001a\u00020\u000b8G¢\u0006\u0006\u001a\u0004\b\f\u0010\rR\u0018\u0010\u000e\u001a\u00020\u000f*\u00020\u00108@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b\u0011\u0010\u0012R\u0018\u0010\u0013\u001a\u00020\u000f*\u00020\u00108@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b\u0014\u0010\u0012\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006A"}, d2 = {"Landroidx/compose/material3/FilterChipDefaults;", "", "()V", "Height", "Landroidx/compose/ui/unit/Dp;", "getHeight-D9Ej5fM", "()F", "F", "IconSize", "getIconSize-D9Ej5fM", "shape", "Landroidx/compose/ui/graphics/Shape;", "getShape", "(Landroidx/compose/runtime/Composer;I)Landroidx/compose/ui/graphics/Shape;", "defaultElevatedFilterChipColors", "Landroidx/compose/material3/SelectableChipColors;", "Landroidx/compose/material3/ColorScheme;", "getDefaultElevatedFilterChipColors$material3_release", "(Landroidx/compose/material3/ColorScheme;)Landroidx/compose/material3/SelectableChipColors;", "defaultFilterChipColors", "getDefaultFilterChipColors$material3_release", "elevatedFilterChipColors", "(Landroidx/compose/runtime/Composer;I)Landroidx/compose/material3/SelectableChipColors;", "containerColor", "Landroidx/compose/ui/graphics/Color;", "labelColor", "iconColor", "disabledContainerColor", "disabledLabelColor", "disabledLeadingIconColor", "disabledTrailingIconColor", "selectedContainerColor", "disabledSelectedContainerColor", "selectedLabelColor", "selectedLeadingIconColor", "selectedTrailingIconColor", "elevatedFilterChipColors-XqyqHi0", "(JJJJJJJJJJJJLandroidx/compose/runtime/Composer;III)Landroidx/compose/material3/SelectableChipColors;", "elevatedFilterChipElevation", "Landroidx/compose/material3/SelectableChipElevation;", "elevation", "pressedElevation", "focusedElevation", "hoveredElevation", "draggedElevation", "disabledElevation", "elevatedFilterChipElevation-aqJV_2Y", "(FFFFFFLandroidx/compose/runtime/Composer;II)Landroidx/compose/material3/SelectableChipElevation;", "filterChipBorder", "Landroidx/compose/foundation/BorderStroke;", "enabled", "", "selected", "borderColor", "selectedBorderColor", "disabledBorderColor", "disabledSelectedBorderColor", "borderWidth", "selectedBorderWidth", "filterChipBorder-_7El2pE", "(ZZJJJJFFLandroidx/compose/runtime/Composer;II)Landroidx/compose/foundation/BorderStroke;", "filterChipColors", "filterChipColors-XqyqHi0", "filterChipElevation", "filterChipElevation-aqJV_2Y", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class FilterChipDefaults {
    public static final int $stable = 0;
    public static final FilterChipDefaults INSTANCE = new FilterChipDefaults();
    private static final float Height = FilterChipTokens.INSTANCE.m3637getContainerHeightD9Ej5fM();
    private static final float IconSize = FilterChipTokens.INSTANCE.m3653getIconSizeD9Ej5fM();

    private FilterChipDefaults() {
    }

    public final float m2396getHeightD9Ej5fM() {
        return Height;
    }

    public final float m2397getIconSizeD9Ej5fM() {
        return IconSize;
    }

    public final SelectableChipColors filterChipColors(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, -1743772077, "C(filterChipColors)1273@61089L11:Chip.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-1743772077, i, -1, "androidx.compose.material3.FilterChipDefaults.filterChipColors (Chip.kt:1273)");
        }
        SelectableChipColors defaultFilterChipColors$material3_release = getDefaultFilterChipColors$material3_release(MaterialTheme.INSTANCE.getColorScheme(composer, 6));
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return defaultFilterChipColors$material3_release;
    }

    public final SelectableChipColors m2394filterChipColorsXqyqHi0(long j, long j2, long j3, long j4, long j5, long j6, long j7, long j8, long j9, long j10, long j11, long j12, Composer composer, int i, int i2, int i3) {
        ComposerKt.sourceInformationMarkerStart(composer, -1831479801, "C(filterChipColors)P(0:c#ui.graphics.Color,7:c#ui.graphics.Color,6:c#ui.graphics.Color,1:c#ui.graphics.Color,2:c#ui.graphics.Color,3:c#ui.graphics.Color,5:c#ui.graphics.Color,8:c#ui.graphics.Color,4:c#ui.graphics.Color,9:c#ui.graphics.Color,10:c#ui.graphics.Color,11:c#ui.graphics.Color)1308@63087L11:Chip.kt#uh7d8r");
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
            ComposerKt.traceEventStart(-1831479801, i, i2, "androidx.compose.material3.FilterChipDefaults.filterChipColors (Chip.kt:1308)");
        }
        SelectableChipColors selectableChipColorsM2776copydaRQuJA = getDefaultFilterChipColors$material3_release(MaterialTheme.INSTANCE.getColorScheme(composer, 6)).m2776copydaRQuJA(jM4626getUnspecified0d7_KjU, jM4626getUnspecified0d7_KjU2, jM4626getUnspecified0d7_KjU3, jM4626getUnspecified0d7_KjU3, jM4626getUnspecified0d7_KjU4, jM4626getUnspecified0d7_KjU5, jM4626getUnspecified0d7_KjU6, jM4626getUnspecified0d7_KjU7, jM4626getUnspecified0d7_KjU8, jM4626getUnspecified0d7_KjU9, jM4626getUnspecified0d7_KjU10, jM4626getUnspecified0d7_KjU11, jM4626getUnspecified0d7_KjU12);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return selectableChipColorsM2776copydaRQuJA;
    }

    public final SelectableChipColors getDefaultFilterChipColors$material3_release(ColorScheme colorScheme) {
        SelectableChipColors defaultFilterChipColorsCached = colorScheme.getDefaultFilterChipColorsCached();
        if (defaultFilterChipColorsCached != null) {
            return defaultFilterChipColorsCached;
        }
        SelectableChipColors selectableChipColors = new SelectableChipColors(Color.INSTANCE.m4625getTransparent0d7_KjU(), ColorSchemeKt.fromToken(colorScheme, FilterChipTokens.INSTANCE.getUnselectedLabelTextColor()), ColorSchemeKt.fromToken(colorScheme, FilterChipTokens.INSTANCE.getUnselectedLeadingIconColor()), ColorSchemeKt.fromToken(colorScheme, FilterChipTokens.INSTANCE.getUnselectedLeadingIconColor()), Color.INSTANCE.m4625getTransparent0d7_KjU(), Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, FilterChipTokens.INSTANCE.getDisabledLabelTextColor()), FilterChipTokens.INSTANCE.getDisabledLabelTextOpacity(), 0.0f, 0.0f, 0.0f, 14, null), Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, FilterChipTokens.INSTANCE.getDisabledLeadingIconColor()), FilterChipTokens.INSTANCE.getDisabledLeadingIconOpacity(), 0.0f, 0.0f, 0.0f, 14, null), Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, FilterChipTokens.INSTANCE.getDisabledLeadingIconColor()), FilterChipTokens.INSTANCE.getDisabledLeadingIconOpacity(), 0.0f, 0.0f, 0.0f, 14, null), ColorSchemeKt.fromToken(colorScheme, FilterChipTokens.INSTANCE.getFlatSelectedContainerColor()), Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, FilterChipTokens.INSTANCE.getFlatDisabledSelectedContainerColor()), FilterChipTokens.INSTANCE.getFlatDisabledSelectedContainerOpacity(), 0.0f, 0.0f, 0.0f, 14, null), ColorSchemeKt.fromToken(colorScheme, FilterChipTokens.INSTANCE.getSelectedLabelTextColor()), ColorSchemeKt.fromToken(colorScheme, FilterChipTokens.INSTANCE.getSelectedLeadingIconColor()), ColorSchemeKt.fromToken(colorScheme, FilterChipTokens.INSTANCE.getSelectedLeadingIconColor()), null);
        colorScheme.setDefaultFilterChipColorsCached$material3_release(selectableChipColors);
        return selectableChipColors;
    }

    public final SelectableChipElevation m2395filterChipElevationaqJV_2Y(float f, float f2, float f3, float f4, float f5, float f6, Composer composer, int i, int i2) {
        ComposerKt.sourceInformationMarkerStart(composer, -757972185, "C(filterChipElevation)P(2:c#ui.unit.Dp,5:c#ui.unit.Dp,3:c#ui.unit.Dp,4:c#ui.unit.Dp,1:c#ui.unit.Dp,0:c#ui.unit.Dp):Chip.kt#uh7d8r");
        float fM3644getFlatContainerElevationD9Ej5fM = (i2 & 1) != 0 ? FilterChipTokens.INSTANCE.m3644getFlatContainerElevationD9Ej5fM() : f;
        float fM3648getFlatSelectedPressedContainerElevationD9Ej5fM = (i2 & 2) != 0 ? FilterChipTokens.INSTANCE.m3648getFlatSelectedPressedContainerElevationD9Ej5fM() : f2;
        float fM3645getFlatSelectedFocusContainerElevationD9Ej5fM = (i2 & 4) != 0 ? FilterChipTokens.INSTANCE.m3645getFlatSelectedFocusContainerElevationD9Ej5fM() : f3;
        float fM3646getFlatSelectedHoverContainerElevationD9Ej5fM = (i2 & 8) != 0 ? FilterChipTokens.INSTANCE.m3646getFlatSelectedHoverContainerElevationD9Ej5fM() : f4;
        float fM3638getDraggedContainerElevationD9Ej5fM = (i2 & 16) != 0 ? FilterChipTokens.INSTANCE.m3638getDraggedContainerElevationD9Ej5fM() : f5;
        float f7 = (i2 & 32) != 0 ? fM3644getFlatContainerElevationD9Ej5fM : f6;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-757972185, i, -1, "androidx.compose.material3.FilterChipDefaults.filterChipElevation (Chip.kt:1378)");
        }
        SelectableChipElevation selectableChipElevation = new SelectableChipElevation(fM3644getFlatContainerElevationD9Ej5fM, fM3648getFlatSelectedPressedContainerElevationD9Ej5fM, fM3645getFlatSelectedFocusContainerElevationD9Ej5fM, fM3646getFlatSelectedHoverContainerElevationD9Ej5fM, fM3638getDraggedContainerElevationD9Ej5fM, f7, null);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return selectableChipElevation;
    }

    public final BorderStroke m2393filterChipBorder_7El2pE(boolean z, boolean z2, long j, long j2, long j3, long j4, float f, float f2, Composer composer, int i, int i2) {
        ComposerKt.sourceInformationMarkerStart(composer, -1138342447, "C(filterChipBorder)P(4,5,0:c#ui.graphics.Color,6:c#ui.graphics.Color,2:c#ui.graphics.Color,3:c#ui.graphics.Color,1:c#ui.unit.Dp,7:c#ui.unit.Dp)1406@68670L5,1409@68834L5:Chip.kt#uh7d8r");
        long value = (i2 & 4) != 0 ? ColorSchemeKt.getValue(FilterChipTokens.INSTANCE.getFlatUnselectedOutlineColor(), composer, 6) : j;
        long jM4625getTransparent0d7_KjU = (i2 & 8) != 0 ? Color.INSTANCE.m4625getTransparent0d7_KjU() : j2;
        long jM4589copywmQWz5c$default = (i2 & 16) != 0 ? Color.m4589copywmQWz5c$default(ColorSchemeKt.getValue(FilterChipTokens.INSTANCE.getFlatDisabledUnselectedOutlineColor(), composer, 6), FilterChipTokens.INSTANCE.getFlatDisabledUnselectedOutlineOpacity(), 0.0f, 0.0f, 0.0f, 14, null) : j3;
        long jM4625getTransparent0d7_KjU2 = (i2 & 32) != 0 ? Color.INSTANCE.m4625getTransparent0d7_KjU() : j4;
        float fM3651getFlatUnselectedOutlineWidthD9Ej5fM = (i2 & 64) != 0 ? FilterChipTokens.INSTANCE.m3651getFlatUnselectedOutlineWidthD9Ej5fM() : f;
        float fM3647getFlatSelectedOutlineWidthD9Ej5fM = (i2 & Fields.SpotShadowColor) != 0 ? FilterChipTokens.INSTANCE.m3647getFlatSelectedOutlineWidthD9Ej5fM() : f2;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-1138342447, i, -1, "androidx.compose.material3.FilterChipDefaults.filterChipBorder (Chip.kt:1415)");
        }
        if (!z) {
            value = z2 ? jM4625getTransparent0d7_KjU2 : jM4589copywmQWz5c$default;
        } else if (z2) {
            value = jM4625getTransparent0d7_KjU;
        }
        if (z2) {
            fM3651getFlatUnselectedOutlineWidthD9Ej5fM = fM3647getFlatSelectedOutlineWidthD9Ej5fM;
        }
        BorderStroke borderStrokeM549BorderStrokecXLIe8U = BorderStrokeKt.m549BorderStrokecXLIe8U(fM3651getFlatUnselectedOutlineWidthD9Ej5fM, value);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return borderStrokeM549BorderStrokecXLIe8U;
    }

    public final SelectableChipColors elevatedFilterChipColors(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 1082953289, "C(elevatedFilterChipColors)1430@69720L11:Chip.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1082953289, i, -1, "androidx.compose.material3.FilterChipDefaults.elevatedFilterChipColors (Chip.kt:1430)");
        }
        SelectableChipColors defaultElevatedFilterChipColors$material3_release = getDefaultElevatedFilterChipColors$material3_release(MaterialTheme.INSTANCE.getColorScheme(composer, 6));
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return defaultElevatedFilterChipColors$material3_release;
    }

    public final SelectableChipColors m2391elevatedFilterChipColorsXqyqHi0(long j, long j2, long j3, long j4, long j5, long j6, long j7, long j8, long j9, long j10, long j11, long j12, Composer composer, int i, int i2, int i3) {
        ComposerKt.sourceInformationMarkerStart(composer, -915841711, "C(elevatedFilterChipColors)P(0:c#ui.graphics.Color,7:c#ui.graphics.Color,6:c#ui.graphics.Color,1:c#ui.graphics.Color,2:c#ui.graphics.Color,3:c#ui.graphics.Color,5:c#ui.graphics.Color,8:c#ui.graphics.Color,4:c#ui.graphics.Color,9:c#ui.graphics.Color,10:c#ui.graphics.Color,11:c#ui.graphics.Color)1465@71739L11:Chip.kt#uh7d8r");
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
            ComposerKt.traceEventStart(-915841711, i, i2, "androidx.compose.material3.FilterChipDefaults.elevatedFilterChipColors (Chip.kt:1465)");
        }
        SelectableChipColors selectableChipColorsM2776copydaRQuJA = getDefaultElevatedFilterChipColors$material3_release(MaterialTheme.INSTANCE.getColorScheme(composer, 6)).m2776copydaRQuJA(jM4626getUnspecified0d7_KjU, jM4626getUnspecified0d7_KjU2, jM4626getUnspecified0d7_KjU3, jM4626getUnspecified0d7_KjU3, jM4626getUnspecified0d7_KjU4, jM4626getUnspecified0d7_KjU5, jM4626getUnspecified0d7_KjU6, jM4626getUnspecified0d7_KjU7, jM4626getUnspecified0d7_KjU8, jM4626getUnspecified0d7_KjU9, jM4626getUnspecified0d7_KjU10, jM4626getUnspecified0d7_KjU11, jM4626getUnspecified0d7_KjU12);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return selectableChipColorsM2776copydaRQuJA;
    }

    public final SelectableChipColors getDefaultElevatedFilterChipColors$material3_release(ColorScheme colorScheme) {
        SelectableChipColors defaultElevatedFilterChipColorsCached = colorScheme.getDefaultElevatedFilterChipColorsCached();
        if (defaultElevatedFilterChipColorsCached != null) {
            return defaultElevatedFilterChipColorsCached;
        }
        SelectableChipColors selectableChipColors = new SelectableChipColors(ColorSchemeKt.fromToken(colorScheme, FilterChipTokens.INSTANCE.getElevatedUnselectedContainerColor()), ColorSchemeKt.fromToken(colorScheme, FilterChipTokens.INSTANCE.getUnselectedLabelTextColor()), ColorSchemeKt.fromToken(colorScheme, FilterChipTokens.INSTANCE.getUnselectedLeadingIconColor()), ColorSchemeKt.fromToken(colorScheme, FilterChipTokens.INSTANCE.getUnselectedLeadingIconColor()), Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, FilterChipTokens.INSTANCE.getElevatedDisabledContainerColor()), FilterChipTokens.INSTANCE.getElevatedDisabledContainerOpacity(), 0.0f, 0.0f, 0.0f, 14, null), Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, FilterChipTokens.INSTANCE.getDisabledLabelTextColor()), FilterChipTokens.INSTANCE.getDisabledLabelTextOpacity(), 0.0f, 0.0f, 0.0f, 14, null), Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, FilterChipTokens.INSTANCE.getDisabledLeadingIconColor()), FilterChipTokens.INSTANCE.getDisabledLeadingIconOpacity(), 0.0f, 0.0f, 0.0f, 14, null), Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, FilterChipTokens.INSTANCE.getDisabledLeadingIconColor()), FilterChipTokens.INSTANCE.getDisabledLeadingIconOpacity(), 0.0f, 0.0f, 0.0f, 14, null), ColorSchemeKt.fromToken(colorScheme, FilterChipTokens.INSTANCE.getElevatedSelectedContainerColor()), Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, FilterChipTokens.INSTANCE.getElevatedDisabledContainerColor()), FilterChipTokens.INSTANCE.getElevatedDisabledContainerOpacity(), 0.0f, 0.0f, 0.0f, 14, null), ColorSchemeKt.fromToken(colorScheme, FilterChipTokens.INSTANCE.getSelectedLabelTextColor()), ColorSchemeKt.fromToken(colorScheme, FilterChipTokens.INSTANCE.getSelectedLeadingIconColor()), ColorSchemeKt.fromToken(colorScheme, FilterChipTokens.INSTANCE.getSelectedLeadingIconColor()), null);
        colorScheme.setDefaultElevatedFilterChipColorsCached$material3_release(selectableChipColors);
        return selectableChipColors;
    }

    public final SelectableChipElevation m2392elevatedFilterChipElevationaqJV_2Y(float f, float f2, float f3, float f4, float f5, float f6, Composer composer, int i, int i2) {
        ComposerKt.sourceInformationMarkerStart(composer, 684803697, "C(elevatedFilterChipElevation)P(2:c#ui.unit.Dp,5:c#ui.unit.Dp,3:c#ui.unit.Dp,4:c#ui.unit.Dp,1:c#ui.unit.Dp,0:c#ui.unit.Dp):Chip.kt#uh7d8r");
        float fM3639getElevatedContainerElevationD9Ej5fM = (i2 & 1) != 0 ? FilterChipTokens.INSTANCE.m3639getElevatedContainerElevationD9Ej5fM() : f;
        float fM3643getElevatedPressedContainerElevationD9Ej5fM = (i2 & 2) != 0 ? FilterChipTokens.INSTANCE.m3643getElevatedPressedContainerElevationD9Ej5fM() : f2;
        float fM3641getElevatedFocusContainerElevationD9Ej5fM = (i2 & 4) != 0 ? FilterChipTokens.INSTANCE.m3641getElevatedFocusContainerElevationD9Ej5fM() : f3;
        float fM3642getElevatedHoverContainerElevationD9Ej5fM = (i2 & 8) != 0 ? FilterChipTokens.INSTANCE.m3642getElevatedHoverContainerElevationD9Ej5fM() : f4;
        float fM3638getDraggedContainerElevationD9Ej5fM = (i2 & 16) != 0 ? FilterChipTokens.INSTANCE.m3638getDraggedContainerElevationD9Ej5fM() : f5;
        float fM3640getElevatedDisabledContainerElevationD9Ej5fM = (i2 & 32) != 0 ? FilterChipTokens.INSTANCE.m3640getElevatedDisabledContainerElevationD9Ej5fM() : f6;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(684803697, i, -1, "androidx.compose.material3.FilterChipDefaults.elevatedFilterChipElevation (Chip.kt:1536)");
        }
        SelectableChipElevation selectableChipElevation = new SelectableChipElevation(fM3639getElevatedContainerElevationD9Ej5fM, fM3643getElevatedPressedContainerElevationD9Ej5fM, fM3641getElevatedFocusContainerElevationD9Ej5fM, fM3642getElevatedHoverContainerElevationD9Ej5fM, fM3638getDraggedContainerElevationD9Ej5fM, fM3640getElevatedDisabledContainerElevationD9Ej5fM, null);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return selectableChipElevation;
    }

    public final Shape getShape(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, -1598643637, "C1547@76563L5:Chip.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-1598643637, i, -1, "androidx.compose.material3.FilterChipDefaults.<get-shape> (Chip.kt:1547)");
        }
        Shape value = ShapesKt.getValue(FilterChipTokens.INSTANCE.getContainerShape(), composer, 6);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return value;
    }
}
