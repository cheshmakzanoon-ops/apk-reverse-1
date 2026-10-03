package androidx.compose.material3;

import androidx.compose.material3.tokens.SwitchTokens;
import androidx.compose.p002ui.graphics.Color;
import androidx.compose.p002ui.graphics.ColorKt;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.ui.unit.Dp;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0012\bÇ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\r\u0010\r\u001a\u00020\tH\u0007¢\u0006\u0002\u0010\u000eJ²\u0001\u0010\r\u001a\u00020\t2\b\b\u0002\u0010\u000f\u001a\u00020\u00102\b\b\u0002\u0010\u0011\u001a\u00020\u00102\b\b\u0002\u0010\u0012\u001a\u00020\u00102\b\b\u0002\u0010\u0013\u001a\u00020\u00102\b\b\u0002\u0010\u0014\u001a\u00020\u00102\b\b\u0002\u0010\u0015\u001a\u00020\u00102\b\b\u0002\u0010\u0016\u001a\u00020\u00102\b\b\u0002\u0010\u0017\u001a\u00020\u00102\b\b\u0002\u0010\u0018\u001a\u00020\u00102\b\b\u0002\u0010\u0019\u001a\u00020\u00102\b\b\u0002\u0010\u001a\u001a\u00020\u00102\b\b\u0002\u0010\u001b\u001a\u00020\u00102\b\b\u0002\u0010\u001c\u001a\u00020\u00102\b\b\u0002\u0010\u001d\u001a\u00020\u00102\b\b\u0002\u0010\u001e\u001a\u00020\u00102\b\b\u0002\u0010\u001f\u001a\u00020\u0010H\u0007ø\u0001\u0000¢\u0006\u0004\b \u0010!R\u0019\u0010\u0003\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0005\u0010\u0006R\u0018\u0010\b\u001a\u00020\t*\u00020\n8@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b\u000b\u0010\f\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\""}, d2 = {"Landroidx/compose/material3/SwitchDefaults;", "", "()V", "IconSize", "Landroidx/compose/ui/unit/Dp;", "getIconSize-D9Ej5fM", "()F", "F", "defaultSwitchColors", "Landroidx/compose/material3/SwitchColors;", "Landroidx/compose/material3/ColorScheme;", "getDefaultSwitchColors$material3_release", "(Landroidx/compose/material3/ColorScheme;)Landroidx/compose/material3/SwitchColors;", "colors", "(Landroidx/compose/runtime/Composer;I)Landroidx/compose/material3/SwitchColors;", "checkedThumbColor", "Landroidx/compose/ui/graphics/Color;", "checkedTrackColor", "checkedBorderColor", "checkedIconColor", "uncheckedThumbColor", "uncheckedTrackColor", "uncheckedBorderColor", "uncheckedIconColor", "disabledCheckedThumbColor", "disabledCheckedTrackColor", "disabledCheckedBorderColor", "disabledCheckedIconColor", "disabledUncheckedThumbColor", "disabledUncheckedTrackColor", "disabledUncheckedBorderColor", "disabledUncheckedIconColor", "colors-V1nXRL4", "(JJJJJJJJJJJJJJJJLandroidx/compose/runtime/Composer;III)Landroidx/compose/material3/SwitchColors;", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class SwitchDefaults {
    public static final int $stable = 0;
    public static final SwitchDefaults INSTANCE = new SwitchDefaults();
    private static final float IconSize = Dp.constructor-impl(16);

    private SwitchDefaults() {
    }

    public final SwitchColors colors(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 435552781, "C(colors)299@11393L11:Switch.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(435552781, i, -1, "androidx.compose.material3.SwitchDefaults.colors (Switch.kt:299)");
        }
        SwitchColors defaultSwitchColors$material3_release = getDefaultSwitchColors$material3_release(MaterialTheme.INSTANCE.getColorScheme(composer, 6));
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return defaultSwitchColors$material3_release;
    }

    public final SwitchColors m2902colorsV1nXRL4(long j, long j2, long j3, long j4, long j5, long j6, long j7, long j8, long j9, long j10, long j11, long j12, long j13, long j14, long j15, long j16, Composer composer, int i, int i2, int i3) {
        int i4;
        long jM4635compositeOverOWjLjI;
        long jM4635compositeOverOWjLjI2;
        ComposerKt.sourceInformationMarkerStart(composer, 1937926421, "C(colors)P(2:c#ui.graphics.Color,3:c#ui.graphics.Color,0:c#ui.graphics.Color,1:c#ui.graphics.Color,14:c#ui.graphics.Color,15:c#ui.graphics.Color,12:c#ui.graphics.Color,13:c#ui.graphics.Color,6:c#ui.graphics.Color,7:c#ui.graphics.Color,4:c#ui.graphics.Color,5:c#ui.graphics.Color,10:c#ui.graphics.Color,11:c#ui.graphics.Color,8:c#ui.graphics.Color,9:c#ui.graphics.Color)324@13145L5,325@13219L5,327@13346L5,328@13425L5,329@13503L5,330@13594L5,331@13670L5,333@13773L5,335@13898L11,337@14015L5,339@14131L11,342@14309L5,344@14432L11,346@14554L5,348@14681L11,350@14802L5,352@14918L11,354@15047L5,356@15163L11,358@15282L5,360@15407L11:Switch.kt#uh7d8r");
        long value = (i3 & 1) != 0 ? ColorSchemeKt.getValue(SwitchTokens.INSTANCE.getSelectedHandleColor(), composer, 6) : j;
        long value2 = (i3 & 2) != 0 ? ColorSchemeKt.getValue(SwitchTokens.INSTANCE.getSelectedTrackColor(), composer, 6) : j2;
        long jM4625getTransparent0d7_KjU = (i3 & 4) != 0 ? Color.INSTANCE.m4625getTransparent0d7_KjU() : j3;
        long value3 = (i3 & 8) != 0 ? ColorSchemeKt.getValue(SwitchTokens.INSTANCE.getSelectedIconColor(), composer, 6) : j4;
        long value4 = (i3 & 16) != 0 ? ColorSchemeKt.getValue(SwitchTokens.INSTANCE.getUnselectedHandleColor(), composer, 6) : j5;
        long value5 = (i3 & 32) != 0 ? ColorSchemeKt.getValue(SwitchTokens.INSTANCE.getUnselectedTrackColor(), composer, 6) : j6;
        long value6 = (i3 & 64) != 0 ? ColorSchemeKt.getValue(SwitchTokens.INSTANCE.getUnselectedFocusTrackOutlineColor(), composer, 6) : j7;
        long value7 = (i3 & Fields.SpotShadowColor) != 0 ? ColorSchemeKt.getValue(SwitchTokens.INSTANCE.getUnselectedIconColor(), composer, 6) : j8;
        long jM4635compositeOverOWjLjI3 = (i3 & Fields.RotationX) != 0 ? ColorKt.m4635compositeOverOWjLjI(Color.m4589copywmQWz5c$default(ColorSchemeKt.getValue(SwitchTokens.INSTANCE.getDisabledSelectedHandleColor(), composer, 6), SwitchTokens.INSTANCE.getDisabledSelectedHandleOpacity(), 0.0f, 0.0f, 0.0f, 14, null), MaterialTheme.INSTANCE.getColorScheme(composer, 6).getSurface()) : j9;
        long jM4635compositeOverOWjLjI4 = (i3 & Fields.RotationY) != 0 ? ColorKt.m4635compositeOverOWjLjI(Color.m4589copywmQWz5c$default(ColorSchemeKt.getValue(SwitchTokens.INSTANCE.getDisabledSelectedTrackColor(), composer, 6), SwitchTokens.INSTANCE.getDisabledTrackOpacity(), 0.0f, 0.0f, 0.0f, 14, null), MaterialTheme.INSTANCE.getColorScheme(composer, 6).getSurface()) : j10;
        long jM4625getTransparent0d7_KjU2 = (i3 & Fields.RotationZ) != 0 ? Color.INSTANCE.m4625getTransparent0d7_KjU() : j11;
        long jM4635compositeOverOWjLjI5 = (i3 & Fields.CameraDistance) != 0 ? ColorKt.m4635compositeOverOWjLjI(Color.m4589copywmQWz5c$default(ColorSchemeKt.getValue(SwitchTokens.INSTANCE.getDisabledSelectedIconColor(), composer, 6), SwitchTokens.INSTANCE.getDisabledSelectedIconOpacity(), 0.0f, 0.0f, 0.0f, 14, null), MaterialTheme.INSTANCE.getColorScheme(composer, 6).getSurface()) : j12;
        long jM4635compositeOverOWjLjI6 = (i3 & Fields.TransformOrigin) != 0 ? ColorKt.m4635compositeOverOWjLjI(Color.m4589copywmQWz5c$default(ColorSchemeKt.getValue(SwitchTokens.INSTANCE.getDisabledUnselectedHandleColor(), composer, 6), SwitchTokens.INSTANCE.getDisabledUnselectedHandleOpacity(), 0.0f, 0.0f, 0.0f, 14, null), MaterialTheme.INSTANCE.getColorScheme(composer, 6).getSurface()) : j13;
        if ((i3 & Fields.Shape) != 0) {
            i4 = 6;
            jM4635compositeOverOWjLjI = ColorKt.m4635compositeOverOWjLjI(Color.m4589copywmQWz5c$default(ColorSchemeKt.getValue(SwitchTokens.INSTANCE.getDisabledUnselectedTrackColor(), composer, 6), SwitchTokens.INSTANCE.getDisabledTrackOpacity(), 0.0f, 0.0f, 0.0f, 14, null), MaterialTheme.INSTANCE.getColorScheme(composer, 6).getSurface());
        } else {
            i4 = 6;
            jM4635compositeOverOWjLjI = j14;
        }
        if ((i3 & Fields.Clip) != 0) {
            long jM4589copywmQWz5c$default = Color.m4589copywmQWz5c$default(ColorSchemeKt.getValue(SwitchTokens.INSTANCE.getDisabledUnselectedTrackOutlineColor(), composer, i4), SwitchTokens.INSTANCE.getDisabledTrackOpacity(), 0.0f, 0.0f, 0.0f, 14, null);
            i4 = 6;
            jM4635compositeOverOWjLjI2 = ColorKt.m4635compositeOverOWjLjI(jM4589copywmQWz5c$default, MaterialTheme.INSTANCE.getColorScheme(composer, 6).getSurface());
        } else {
            jM4635compositeOverOWjLjI2 = j15;
        }
        long jM4635compositeOverOWjLjI7 = (i3 & Fields.CompositingStrategy) != 0 ? ColorKt.m4635compositeOverOWjLjI(Color.m4589copywmQWz5c$default(ColorSchemeKt.getValue(SwitchTokens.INSTANCE.getDisabledUnselectedIconColor(), composer, i4), SwitchTokens.INSTANCE.getDisabledUnselectedIconOpacity(), 0.0f, 0.0f, 0.0f, 14, null), MaterialTheme.INSTANCE.getColorScheme(composer, 6).getSurface()) : j16;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1937926421, i, i2, "androidx.compose.material3.SwitchDefaults.colors (Switch.kt:362)");
        }
        SwitchColors switchColors = new SwitchColors(value, value2, jM4625getTransparent0d7_KjU, value3, value4, value5, value6, value7, jM4635compositeOverOWjLjI3, jM4635compositeOverOWjLjI4, jM4625getTransparent0d7_KjU2, jM4635compositeOverOWjLjI5, jM4635compositeOverOWjLjI6, jM4635compositeOverOWjLjI, jM4635compositeOverOWjLjI2, jM4635compositeOverOWjLjI7, null);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return switchColors;
    }

    public final SwitchColors getDefaultSwitchColors$material3_release(ColorScheme colorScheme) {
        SwitchColors defaultSwitchColorsCached = colorScheme.getDefaultSwitchColorsCached();
        if (defaultSwitchColorsCached != null) {
            return defaultSwitchColorsCached;
        }
        SwitchColors switchColors = new SwitchColors(ColorSchemeKt.fromToken(colorScheme, SwitchTokens.INSTANCE.getSelectedHandleColor()), ColorSchemeKt.fromToken(colorScheme, SwitchTokens.INSTANCE.getSelectedTrackColor()), Color.INSTANCE.m4625getTransparent0d7_KjU(), ColorSchemeKt.fromToken(colorScheme, SwitchTokens.INSTANCE.getSelectedIconColor()), ColorSchemeKt.fromToken(colorScheme, SwitchTokens.INSTANCE.getUnselectedHandleColor()), ColorSchemeKt.fromToken(colorScheme, SwitchTokens.INSTANCE.getUnselectedTrackColor()), ColorSchemeKt.fromToken(colorScheme, SwitchTokens.INSTANCE.getUnselectedFocusTrackOutlineColor()), ColorSchemeKt.fromToken(colorScheme, SwitchTokens.INSTANCE.getUnselectedIconColor()), ColorKt.m4635compositeOverOWjLjI(Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, SwitchTokens.INSTANCE.getDisabledSelectedHandleColor()), SwitchTokens.INSTANCE.getDisabledSelectedHandleOpacity(), 0.0f, 0.0f, 0.0f, 14, null), colorScheme.getSurface()), ColorKt.m4635compositeOverOWjLjI(Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, SwitchTokens.INSTANCE.getDisabledSelectedTrackColor()), SwitchTokens.INSTANCE.getDisabledTrackOpacity(), 0.0f, 0.0f, 0.0f, 14, null), colorScheme.getSurface()), Color.INSTANCE.m4625getTransparent0d7_KjU(), ColorKt.m4635compositeOverOWjLjI(Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, SwitchTokens.INSTANCE.getDisabledSelectedIconColor()), SwitchTokens.INSTANCE.getDisabledSelectedIconOpacity(), 0.0f, 0.0f, 0.0f, 14, null), colorScheme.getSurface()), ColorKt.m4635compositeOverOWjLjI(Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, SwitchTokens.INSTANCE.getDisabledUnselectedHandleColor()), SwitchTokens.INSTANCE.getDisabledUnselectedHandleOpacity(), 0.0f, 0.0f, 0.0f, 14, null), colorScheme.getSurface()), ColorKt.m4635compositeOverOWjLjI(Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, SwitchTokens.INSTANCE.getDisabledUnselectedTrackColor()), SwitchTokens.INSTANCE.getDisabledTrackOpacity(), 0.0f, 0.0f, 0.0f, 14, null), colorScheme.getSurface()), ColorKt.m4635compositeOverOWjLjI(Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, SwitchTokens.INSTANCE.getDisabledUnselectedTrackOutlineColor()), SwitchTokens.INSTANCE.getDisabledTrackOpacity(), 0.0f, 0.0f, 0.0f, 14, null), colorScheme.getSurface()), ColorKt.m4635compositeOverOWjLjI(Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, SwitchTokens.INSTANCE.getDisabledUnselectedIconColor()), SwitchTokens.INSTANCE.getDisabledUnselectedIconOpacity(), 0.0f, 0.0f, 0.0f, 14, null), colorScheme.getSurface()), null);
        colorScheme.setDefaultSwitchColorsCached$material3_release(switchColors);
        return switchColors;
    }

    public final float m2903getIconSizeD9Ej5fM() {
        return IconSize;
    }
}
