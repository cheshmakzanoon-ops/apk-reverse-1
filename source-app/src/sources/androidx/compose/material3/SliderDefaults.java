package androidx.compose.material3;

import androidx.compose.foundation.BackgroundKt;
import androidx.compose.foundation.CanvasKt;
import androidx.compose.foundation.HoverableKt;
import androidx.compose.foundation.interaction.MutableInteractionSource;
import androidx.compose.foundation.layout.SizeKt;
import androidx.compose.foundation.layout.SpacerKt;
import androidx.compose.material3.tokens.SliderTokens;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.draw.RotateKt;
import androidx.compose.p002ui.geometry.CornerRadiusKt;
import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.geometry.OffsetKt;
import androidx.compose.p002ui.geometry.RectKt;
import androidx.compose.p002ui.geometry.RoundRect;
import androidx.compose.p002ui.geometry.RoundRectKt;
import androidx.compose.p002ui.geometry.Size;
import androidx.compose.p002ui.graphics.AndroidPath_androidKt;
import androidx.compose.p002ui.graphics.Color;
import androidx.compose.p002ui.graphics.ColorKt;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.graphics.Path;
import androidx.compose.p002ui.graphics.PointMode;
import androidx.compose.p002ui.graphics.StrokeCap;
import androidx.compose.p002ui.graphics.drawscope.DrawScope;
import androidx.compose.p002ui.platform.CompositionLocalsKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.EffectsKt;
import androidx.compose.runtime.ProvidableCompositionLocal;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.SnapshotStateKt;
import androidx.compose.runtime.snapshots.SnapshotStateList;
import androidx.compose.ui.unit.Dp;
import androidx.compose.ui.unit.DpSize;
import androidx.compose.ui.unit.LayoutDirection;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.ranges.ClosedFloatingPointRange;
import kotlin.ranges.RangesKt;
import kotlinx.coroutines.CoroutineScope;

@Metadata(d1 = {"\u0000\u0094\u0001\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0017\n\u0002\u0010\u0014\n\u0000\n\u0002\u0010\u0007\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\b\u0005\bÇ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002JB\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u00142\b\b\u0002\u0010\u0015\u001a\u00020\u00162\b\b\u0002\u0010\u0017\u001a\u00020\r2\b\b\u0002\u0010\u0018\u001a\u00020\u00192\b\b\u0002\u0010\u001a\u001a\u00020\u001bH\u0007ø\u0001\u0000¢\u0006\u0004\b\u001c\u0010\u001dJ3\u0010\u001e\u001a\u00020\u00122\u0006\u0010\u001f\u001a\u00020 2\b\b\u0002\u0010\u0015\u001a\u00020\u00162\b\b\u0002\u0010\u0017\u001a\u00020\r2\b\b\u0002\u0010\u0018\u001a\u00020\u0019H\u0007¢\u0006\u0002\u0010!J\u0096\u0001\u0010\u001e\u001a\u00020\u00122\u0006\u0010\u001f\u001a\u00020 2\b\b\u0002\u0010\u0015\u001a\u00020\u00162\b\b\u0002\u0010\u0018\u001a\u00020\u00192\b\b\u0002\u0010\u0017\u001a\u00020\r2!\b\u0002\u0010\"\u001a\u001b\u0012\u0004\u0012\u00020$\u0012\u0004\u0012\u00020%\u0012\u0004\u0012\u00020\u0012\u0018\u00010#¢\u0006\u0002\b&2%\b\u0002\u0010'\u001a\u001f\u0012\u0004\u0012\u00020$\u0012\u0004\u0012\u00020%\u0012\u0004\u0012\u00020)\u0012\u0004\u0012\u00020\u00120(¢\u0006\u0002\b&2\b\b\u0002\u0010*\u001a\u00020\u00042\b\b\u0002\u0010+\u001a\u00020\u0004H\u0007ø\u0001\u0000¢\u0006\u0004\b,\u0010-J3\u0010\u001e\u001a\u00020\u00122\u0006\u0010.\u001a\u00020/2\b\b\u0002\u0010\u0015\u001a\u00020\u00162\b\b\u0002\u0010\u0017\u001a\u00020\r2\b\b\u0002\u0010\u0018\u001a\u00020\u0019H\u0007¢\u0006\u0002\u00100J3\u0010\u001e\u001a\u00020\u00122\u0006\u00101\u001a\u0002022\b\b\u0002\u0010\u0015\u001a\u00020\u00162\b\b\u0002\u0010\u0017\u001a\u00020\r2\b\b\u0002\u0010\u0018\u001a\u00020\u0019H\u0007¢\u0006\u0002\u00103J\u0096\u0001\u0010\u001e\u001a\u00020\u00122\u0006\u00101\u001a\u0002022\b\b\u0002\u0010\u0015\u001a\u00020\u00162\b\b\u0002\u0010\u0018\u001a\u00020\u00192\b\b\u0002\u0010\u0017\u001a\u00020\r2!\b\u0002\u0010\"\u001a\u001b\u0012\u0004\u0012\u00020$\u0012\u0004\u0012\u00020%\u0012\u0004\u0012\u00020\u0012\u0018\u00010#¢\u0006\u0002\b&2%\b\u0002\u0010'\u001a\u001f\u0012\u0004\u0012\u00020$\u0012\u0004\u0012\u00020%\u0012\u0004\u0012\u00020)\u0012\u0004\u0012\u00020\u00120(¢\u0006\u0002\b&2\b\b\u0002\u0010*\u001a\u00020\u00042\b\b\u0002\u0010+\u001a\u00020\u0004H\u0007ø\u0001\u0000¢\u0006\u0004\b,\u00104J\r\u0010\u0017\u001a\u00020\rH\u0007¢\u0006\u0002\u00105Jv\u0010\u0017\u001a\u00020\r2\b\b\u0002\u00106\u001a\u00020)2\b\b\u0002\u00107\u001a\u00020)2\b\b\u0002\u00108\u001a\u00020)2\b\b\u0002\u00109\u001a\u00020)2\b\b\u0002\u0010:\u001a\u00020)2\b\b\u0002\u0010;\u001a\u00020)2\b\b\u0002\u0010<\u001a\u00020)2\b\b\u0002\u0010=\u001a\u00020)2\b\b\u0002\u0010>\u001a\u00020)2\b\b\u0002\u0010?\u001a\u00020)H\u0007ø\u0001\u0000¢\u0006\u0004\b@\u0010AJ2\u0010\"\u001a\u00020\u00122\u0006\u0010B\u001a\u00020$2\u0006\u0010C\u001a\u00020%2\u0006\u0010D\u001a\u00020\u00042\u0006\u0010E\u001a\u00020)H\u0002ø\u0001\u0000¢\u0006\u0004\bF\u0010GJÄ\u0001\u0010H\u001a\u00020\u0012*\u00020$2\u0006\u0010I\u001a\u00020J2\u0006\u0010K\u001a\u00020L2\u0006\u0010M\u001a\u00020L2\u0006\u00109\u001a\u00020)2\u0006\u00107\u001a\u00020)2\u0006\u0010:\u001a\u00020)2\u0006\u00108\u001a\u00020)2\u0006\u0010N\u001a\u00020\u00042\u0006\u0010O\u001a\u00020\u00042\u0006\u0010P\u001a\u00020\u00042\u0006\u0010*\u001a\u00020\u00042\u0006\u0010+\u001a\u00020\u00042\u001f\u0010\"\u001a\u001b\u0012\u0004\u0012\u00020$\u0012\u0004\u0012\u00020%\u0012\u0004\u0012\u00020\u0012\u0018\u00010#¢\u0006\u0002\b&2#\u0010'\u001a\u001f\u0012\u0004\u0012\u00020$\u0012\u0004\u0012\u00020%\u0012\u0004\u0012\u00020)\u0012\u0004\u0012\u00020\u00120(¢\u0006\u0002\b&2\u0006\u0010Q\u001a\u00020\u0019H\u0002ø\u0001\u0000¢\u0006\u0004\bR\u0010SJ>\u0010T\u001a\u00020\u0012*\u00020$2\u0006\u0010C\u001a\u00020%2\u0006\u0010D\u001a\u00020U2\u0006\u0010E\u001a\u00020)2\u0006\u0010V\u001a\u00020L2\u0006\u0010W\u001a\u00020LH\u0002ø\u0001\u0000¢\u0006\u0004\bX\u0010YR\u0019\u0010\u0003\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0005\u0010\u0006R\u0019\u0010\b\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\t\u0010\u0006R\u000e\u0010\n\u001a\u00020\u000bX\u0082\u0004¢\u0006\u0002\n\u0000R\u0018\u0010\f\u001a\u00020\r*\u00020\u000e8@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b\u000f\u0010\u0010\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006Z"}, d2 = {"Landroidx/compose/material3/SliderDefaults;", "", "()V", "TickSize", "Landroidx/compose/ui/unit/Dp;", "getTickSize-D9Ej5fM", "()F", "F", "TrackStopIndicatorSize", "getTrackStopIndicatorSize-D9Ej5fM", "trackPath", "Landroidx/compose/ui/graphics/Path;", "defaultSliderColors", "Landroidx/compose/material3/SliderColors;", "Landroidx/compose/material3/ColorScheme;", "getDefaultSliderColors$material3_release", "(Landroidx/compose/material3/ColorScheme;)Landroidx/compose/material3/SliderColors;", "Thumb", "", "interactionSource", "Landroidx/compose/foundation/interaction/MutableInteractionSource;", "modifier", "Landroidx/compose/ui/Modifier;", "colors", "enabled", "", "thumbSize", "Landroidx/compose/ui/unit/DpSize;", "Thumb-9LiSoMs", "(Landroidx/compose/foundation/interaction/MutableInteractionSource;Landroidx/compose/ui/Modifier;Landroidx/compose/material3/SliderColors;ZJLandroidx/compose/runtime/Composer;II)V", "Track", "rangeSliderState", "Landroidx/compose/material3/RangeSliderState;", "(Landroidx/compose/material3/RangeSliderState;Landroidx/compose/ui/Modifier;Landroidx/compose/material3/SliderColors;ZLandroidx/compose/runtime/Composer;II)V", "drawStopIndicator", "Lkotlin/Function2;", "Landroidx/compose/ui/graphics/drawscope/DrawScope;", "Landroidx/compose/ui/geometry/Offset;", "Lkotlin/ExtensionFunctionType;", "drawTick", "Lkotlin/Function3;", "Landroidx/compose/ui/graphics/Color;", "thumbTrackGapSize", "trackInsideCornerSize", "Track-4EFweAY", "(Landroidx/compose/material3/RangeSliderState;Landroidx/compose/ui/Modifier;ZLandroidx/compose/material3/SliderColors;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function3;FFLandroidx/compose/runtime/Composer;II)V", "sliderPositions", "Landroidx/compose/material3/SliderPositions;", "(Landroidx/compose/material3/SliderPositions;Landroidx/compose/ui/Modifier;Landroidx/compose/material3/SliderColors;ZLandroidx/compose/runtime/Composer;II)V", "sliderState", "Landroidx/compose/material3/SliderState;", "(Landroidx/compose/material3/SliderState;Landroidx/compose/ui/Modifier;Landroidx/compose/material3/SliderColors;ZLandroidx/compose/runtime/Composer;II)V", "(Landroidx/compose/material3/SliderState;Landroidx/compose/ui/Modifier;ZLandroidx/compose/material3/SliderColors;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function3;FFLandroidx/compose/runtime/Composer;II)V", "(Landroidx/compose/runtime/Composer;I)Landroidx/compose/material3/SliderColors;", "thumbColor", "activeTrackColor", "activeTickColor", "inactiveTrackColor", "inactiveTickColor", "disabledThumbColor", "disabledActiveTrackColor", "disabledActiveTickColor", "disabledInactiveTrackColor", "disabledInactiveTickColor", "colors-q0g_0yA", "(JJJJJJJJJJLandroidx/compose/runtime/Composer;III)Landroidx/compose/material3/SliderColors;", "drawScope", "offset", "size", "color", "drawStopIndicator-x3O1jOs", "(Landroidx/compose/ui/graphics/drawscope/DrawScope;JFJ)V", "drawTrack", "tickFractions", "", "activeRangeStart", "", "activeRangeEnd", "height", "startThumbWidth", "endThumbWidth", "isRangeSlider", "drawTrack-ngJ0SCU", "(Landroidx/compose/ui/graphics/drawscope/DrawScope;[FFFJJJJFFFFFLkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function3;Z)V", "drawTrackPath", "Landroidx/compose/ui/geometry/Size;", "startCornerRadius", "endCornerRadius", "drawTrackPath-Cx2C_VA", "(Landroidx/compose/ui/graphics/drawscope/DrawScope;JJJFF)V", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class SliderDefaults {
    public static final int $stable = 0;
    public static final SliderDefaults INSTANCE = new SliderDefaults();
    private static final float TrackStopIndicatorSize = SliderTokens.INSTANCE.m3863getStopIndicatorSizeD9Ej5fM();
    private static final float TickSize = SliderTokens.INSTANCE.m3863getStopIndicatorSizeD9Ej5fM();
    private static final Path trackPath = AndroidPath_androidKt.Path();

    private SliderDefaults() {
    }

    public final SliderColors colors(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 1376295968, "C(colors)845@36907L11:Slider.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1376295968, i, -1, "androidx.compose.material3.SliderDefaults.colors (Slider.kt:845)");
        }
        SliderColors defaultSliderColors$material3_release = getDefaultSliderColors$material3_release(MaterialTheme.INSTANCE.getColorScheme(composer, 6));
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return defaultSliderColors$material3_release;
    }

    public final SliderColors m2814colorsq0g_0yA(long j, long j2, long j3, long j4, long j5, long j6, long j7, long j8, long j9, long j10, Composer composer, int i, int i2, int i3) {
        ComposerKt.sourceInformationMarkerStart(composer, 885588574, "C(colors)P(9:c#ui.graphics.Color,1:c#ui.graphics.Color,0:c#ui.graphics.Color,8:c#ui.graphics.Color,7:c#ui.graphics.Color,6:c#ui.graphics.Color,3:c#ui.graphics.Color,2:c#ui.graphics.Color,5:c#ui.graphics.Color,4:c#ui.graphics.Color)887@39230L11:Slider.kt#uh7d8r");
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
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(885588574, i, i2, "androidx.compose.material3.SliderDefaults.colors (Slider.kt:887)");
        }
        SliderColors sliderColorsM2792copyK518z4 = getDefaultSliderColors$material3_release(MaterialTheme.INSTANCE.getColorScheme(composer, 6)).m2792copyK518z4(jM4626getUnspecified0d7_KjU, jM4626getUnspecified0d7_KjU2, jM4626getUnspecified0d7_KjU3, jM4626getUnspecified0d7_KjU4, jM4626getUnspecified0d7_KjU5, jM4626getUnspecified0d7_KjU6, jM4626getUnspecified0d7_KjU7, jM4626getUnspecified0d7_KjU8, jM4626getUnspecified0d7_KjU9, jM4626getUnspecified0d7_KjU10);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return sliderColorsM2792copyK518z4;
    }

    public final SliderColors getDefaultSliderColors$material3_release(ColorScheme colorScheme) {
        SliderColors defaultSliderColorsCached = colorScheme.getDefaultSliderColorsCached();
        if (defaultSliderColorsCached != null) {
            return defaultSliderColorsCached;
        }
        SliderColors sliderColors = new SliderColors(ColorSchemeKt.fromToken(colorScheme, SliderTokens.INSTANCE.getHandleColor()), ColorSchemeKt.fromToken(colorScheme, SliderTokens.INSTANCE.getActiveTrackColor()), ColorSchemeKt.fromToken(colorScheme, SliderTokens.INSTANCE.getInactiveTrackColor()), ColorSchemeKt.fromToken(colorScheme, SliderTokens.INSTANCE.getInactiveTrackColor()), ColorSchemeKt.fromToken(colorScheme, SliderTokens.INSTANCE.getActiveTrackColor()), ColorKt.m4635compositeOverOWjLjI(Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, SliderTokens.INSTANCE.getDisabledHandleColor()), SliderTokens.INSTANCE.getDisabledHandleOpacity(), 0.0f, 0.0f, 0.0f, 14, null), colorScheme.getSurface()), Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, SliderTokens.INSTANCE.getDisabledActiveTrackColor()), SliderTokens.INSTANCE.getDisabledActiveTrackOpacity(), 0.0f, 0.0f, 0.0f, 14, null), Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, SliderTokens.INSTANCE.getDisabledInactiveTrackColor()), SliderTokens.INSTANCE.getDisabledInactiveTrackOpacity(), 0.0f, 0.0f, 0.0f, 14, null), Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, SliderTokens.INSTANCE.getDisabledInactiveTrackColor()), SliderTokens.INSTANCE.getDisabledInactiveTrackOpacity(), 0.0f, 0.0f, 0.0f, 14, null), Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, SliderTokens.INSTANCE.getDisabledActiveTrackColor()), SliderTokens.INSTANCE.getDisabledActiveTrackOpacity(), 0.0f, 0.0f, 0.0f, 14, null), null);
        colorScheme.setDefaultSliderColorsCached$material3_release(sliderColors);
        return sliderColors;
    }

    public final void m2811Thumb9LiSoMs(final MutableInteractionSource mutableInteractionSource, Modifier modifier, SliderColors sliderColors, boolean z, long j, Composer composer, final int i, final int i2) {
        int i3;
        Modifier modifier2;
        SliderColors sliderColors2;
        int i4;
        boolean z2;
        int i5;
        int i6;
        long j2;
        int i7;
        int i8;
        Object objRememberedValue;
        SnapshotStateList snapshotStateList;
        boolean z3;
        SliderDefaults$Thumb$1$1 sliderDefaults$Thumb$1$1RememberedValue;
        long j3;
        final Modifier modifier3;
        final SliderColors sliderColors3;
        final boolean z4;
        final long j4;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i9;
        Composer composerStartRestartGroup = composer.startRestartGroup(-290277409);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(Thumb)P(2,3!,4:c#ui.unit.DpSize)947@42562L8,951@42678L46,952@42767L658,952@42733L692,975@43824L5,971@43620L220:Slider.kt#uh7d8r");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changed(mutableInteractionSource) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i10 = i2 & 2;
        if (i10 == 0) {
            if ((i & 48) == 0) {
                modifier2 = modifier;
                i3 |= composerStartRestartGroup.changed(modifier2) ? 32 : 16;
            }
            if ((i & 384) == 0) {
                if ((i2 & 4) == 0) {
                    sliderColors2 = sliderColors;
                    if (composerStartRestartGroup.changed(sliderColors2)) {
                        i9 = Fields.RotationX;
                    }
                    i3 |= i9;
                } else {
                    sliderColors2 = sliderColors;
                }
                i9 = Fields.SpotShadowColor;
                i3 |= i9;
            } else {
                sliderColors2 = sliderColors;
            }
            i4 = i2 & 8;
            if (i4 != 0) {
                if ((i & 3072) == 0) {
                    z2 = z;
                    if (composerStartRestartGroup.changed(z2)) {
                        i5 = Fields.CameraDistance;
                    } else {
                        i5 = Fields.RotationZ;
                    }
                    i3 |= i5;
                }
                i6 = i2 & 16;
                if (i6 != 0) {
                    if ((i & 24576) == 0) {
                        j2 = j;
                        if (composerStartRestartGroup.changed(j2)) {
                            i7 = Fields.Clip;
                        } else {
                            i7 = Fields.Shape;
                        }
                        i3 |= i7;
                    }
                    if ((i2 & 32) != 0) {
                        i3 |= 196608;
                    } else if ((i & 196608) == 0) {
                        if (composerStartRestartGroup.changed(this)) {
                            i8 = Fields.RenderEffect;
                        } else {
                            i8 = 65536;
                        }
                        i3 |= i8;
                    }
                    if ((i3 & 74899) == 74898 || !composerStartRestartGroup.getSkipping()) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                            if (i10 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if ((i2 & 4) != 0) {
                                SliderColors sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 15) & 14);
                                i3 &= -897;
                                sliderColors2 = sliderColorsColors;
                            }
                            if (i4 != 0) {
                                z2 = true;
                            }
                            if (i6 != 0) {
                                j2 = SliderKt.ThumbSize;
                            }
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            if ((i2 & 4) != 0) {
                                i3 &= -897;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-290277409, i3, -1, "androidx.compose.material3.SliderDefaults.Thumb (Slider.kt:950)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1068636116, "CC(remember):Slider.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue = SnapshotStateKt.mutableStateListOf();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        snapshotStateList = (SnapshotStateList) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1068632656, "CC(remember):Slider.kt#9igjgp");
                        int i11 = i3 & 14;
                        z3 = i11 == 4;
                        sliderDefaults$Thumb$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z3 || sliderDefaults$Thumb$1$1RememberedValue == Composer.INSTANCE.getEmpty()) {
                            sliderDefaults$Thumb$1$1RememberedValue = new SliderDefaults$Thumb$1$1(mutableInteractionSource, snapshotStateList, null);
                            composerStartRestartGroup.updateRememberedValue(sliderDefaults$Thumb$1$1RememberedValue);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        EffectsKt.LaunchedEffect(mutableInteractionSource, (Function2<? super CoroutineScope, ? super Continuation<? super Unit>, ? extends Object>) sliderDefaults$Thumb$1$1RememberedValue, composerStartRestartGroup, i11);
                        if (snapshotStateList.isEmpty()) {
                            j3 = j2;
                        } else {
                            j3 = DpSize.copy-DwJknco$default(j2, Dp.constructor-impl(DpSize.getWidth-D9Ej5fM(j2) / 2), 0.0f, 2, (Object) null);
                        }
                        SpacerKt.Spacer(BackgroundKt.m518backgroundbw27NRU(HoverableKt.hoverable$default(SizeKt.m1081size6HolHcs(modifier2, j3), mutableInteractionSource, false, 2, null), sliderColors2.m2803thumbColorvNxB06k$material3_release(z2), ShapesKt.getValue(SliderTokens.INSTANCE.getHandleShape(), composerStartRestartGroup, 6)), composerStartRestartGroup, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                    }
                    modifier3 = modifier2;
                    sliderColors3 = sliderColors2;
                    z4 = z2;
                    j4 = j2;
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

                            public final void invoke(Composer composer2, int i12) {
                                this.$tmp2_rcvr.m2811Thumb9LiSoMs(mutableInteractionSource, modifier3, sliderColors3, z4, j4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 24576;
                j2 = j;
                if ((i2 & 32) != 0) {
                    i3 |= 196608;
                } else if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changed(this)) {
                        i8 = Fields.RenderEffect;
                    } else {
                        i8 = 65536;
                    }
                    i3 |= i8;
                }
                if ((i3 & 74899) == 74898) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i10 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i2 & 4) != 0) {
                            SliderColors sliderColorsColors2 = colors(composerStartRestartGroup, (i3 >> 15) & 14);
                            i3 &= -897;
                            sliderColors2 = sliderColorsColors2;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if (i6 != 0) {
                            j2 = SliderKt.ThumbSize;
                        }
                    } else {
                        if (i10 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i2 & 4) != 0) {
                            SliderColors sliderColorsColors3 = colors(composerStartRestartGroup, (i3 >> 15) & 14);
                            i3 &= -897;
                            sliderColors2 = sliderColorsColors3;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if (i6 != 0) {
                            j2 = SliderKt.ThumbSize;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-290277409, i3, -1, "androidx.compose.material3.SliderDefaults.Thumb (Slider.kt:950)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1068636116, "CC(remember):Slider.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotStateKt.mutableStateListOf();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    snapshotStateList = (SnapshotStateList) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1068632656, "CC(remember):Slider.kt#9igjgp");
                    int i12 = i3 & 14;
                    if (i12 == 4) {
                    }
                    sliderDefaults$Thumb$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z3) {
                        sliderDefaults$Thumb$1$1RememberedValue = new SliderDefaults$Thumb$1$1(mutableInteractionSource, snapshotStateList, null);
                        composerStartRestartGroup.updateRememberedValue(sliderDefaults$Thumb$1$1RememberedValue);
                    } else {
                        sliderDefaults$Thumb$1$1RememberedValue = new SliderDefaults$Thumb$1$1(mutableInteractionSource, snapshotStateList, null);
                        composerStartRestartGroup.updateRememberedValue(sliderDefaults$Thumb$1$1RememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    EffectsKt.LaunchedEffect(mutableInteractionSource, (Function2<? super CoroutineScope, ? super Continuation<? super Unit>, ? extends Object>) sliderDefaults$Thumb$1$1RememberedValue, composerStartRestartGroup, i12);
                    if (snapshotStateList.isEmpty()) {
                        j3 = DpSize.copy-DwJknco$default(j2, Dp.constructor-impl(DpSize.getWidth-D9Ej5fM(j2) / 2), 0.0f, 2, (Object) null);
                    } else {
                        j3 = j2;
                    }
                    SpacerKt.Spacer(BackgroundKt.m518backgroundbw27NRU(HoverableKt.hoverable$default(SizeKt.m1081size6HolHcs(modifier2, j3), mutableInteractionSource, false, 2, null), sliderColors2.m2803thumbColorvNxB06k$material3_release(z2), ShapesKt.getValue(SliderTokens.INSTANCE.getHandleShape(), composerStartRestartGroup, 6)), composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i10 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i2 & 4) != 0) {
                            SliderColors sliderColorsColors4 = colors(composerStartRestartGroup, (i3 >> 15) & 14);
                            i3 &= -897;
                            sliderColors2 = sliderColorsColors4;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if (i6 != 0) {
                            j2 = SliderKt.ThumbSize;
                        }
                    } else {
                        if (i10 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i2 & 4) != 0) {
                            SliderColors sliderColorsColors5 = colors(composerStartRestartGroup, (i3 >> 15) & 14);
                            i3 &= -897;
                            sliderColors2 = sliderColorsColors5;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if (i6 != 0) {
                            j2 = SliderKt.ThumbSize;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-290277409, i3, -1, "androidx.compose.material3.SliderDefaults.Thumb (Slider.kt:950)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1068636116, "CC(remember):Slider.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotStateKt.mutableStateListOf();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    snapshotStateList = (SnapshotStateList) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1068632656, "CC(remember):Slider.kt#9igjgp");
                    int i13 = i3 & 14;
                    if (i13 == 4) {
                    }
                    sliderDefaults$Thumb$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z3) {
                        sliderDefaults$Thumb$1$1RememberedValue = new SliderDefaults$Thumb$1$1(mutableInteractionSource, snapshotStateList, null);
                        composerStartRestartGroup.updateRememberedValue(sliderDefaults$Thumb$1$1RememberedValue);
                    } else {
                        sliderDefaults$Thumb$1$1RememberedValue = new SliderDefaults$Thumb$1$1(mutableInteractionSource, snapshotStateList, null);
                        composerStartRestartGroup.updateRememberedValue(sliderDefaults$Thumb$1$1RememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    EffectsKt.LaunchedEffect(mutableInteractionSource, (Function2<? super CoroutineScope, ? super Continuation<? super Unit>, ? extends Object>) sliderDefaults$Thumb$1$1RememberedValue, composerStartRestartGroup, i13);
                    if (snapshotStateList.isEmpty()) {
                        j3 = DpSize.copy-DwJknco$default(j2, Dp.constructor-impl(DpSize.getWidth-D9Ej5fM(j2) / 2), 0.0f, 2, (Object) null);
                    } else {
                        j3 = j2;
                    }
                    SpacerKt.Spacer(BackgroundKt.m518backgroundbw27NRU(HoverableKt.hoverable$default(SizeKt.m1081size6HolHcs(modifier2, j3), mutableInteractionSource, false, 2, null), sliderColors2.m2803thumbColorvNxB06k$material3_release(z2), ShapesKt.getValue(SliderTokens.INSTANCE.getHandleShape(), composerStartRestartGroup, 6)), composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
                modifier3 = modifier2;
                sliderColors3 = sliderColors2;
                z4 = z2;
                j4 = j2;
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

                        public final void invoke(Composer composer2, int i14) {
                            this.$tmp2_rcvr.m2811Thumb9LiSoMs(mutableInteractionSource, modifier3, sliderColors3, z4, j4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            z2 = z;
            i6 = i2 & 16;
            if (i6 != 0) {
                if ((i & 24576) == 0) {
                    j2 = j;
                    if (composerStartRestartGroup.changed(j2)) {
                        i7 = Fields.Clip;
                    } else {
                        i7 = Fields.Shape;
                    }
                    i3 |= i7;
                }
                if ((i2 & 32) != 0) {
                    i3 |= 196608;
                } else if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changed(this)) {
                        i8 = Fields.RenderEffect;
                    } else {
                        i8 = 65536;
                    }
                    i3 |= i8;
                }
                if ((i3 & 74899) == 74898) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i10 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i2 & 4) != 0) {
                            SliderColors sliderColorsColors6 = colors(composerStartRestartGroup, (i3 >> 15) & 14);
                            i3 &= -897;
                            sliderColors2 = sliderColorsColors6;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if (i6 != 0) {
                            j2 = SliderKt.ThumbSize;
                        }
                    } else {
                        if (i10 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i2 & 4) != 0) {
                            SliderColors sliderColorsColors7 = colors(composerStartRestartGroup, (i3 >> 15) & 14);
                            i3 &= -897;
                            sliderColors2 = sliderColorsColors7;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if (i6 != 0) {
                            j2 = SliderKt.ThumbSize;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-290277409, i3, -1, "androidx.compose.material3.SliderDefaults.Thumb (Slider.kt:950)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1068636116, "CC(remember):Slider.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotStateKt.mutableStateListOf();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    snapshotStateList = (SnapshotStateList) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1068632656, "CC(remember):Slider.kt#9igjgp");
                    int i14 = i3 & 14;
                    if (i14 == 4) {
                    }
                    sliderDefaults$Thumb$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z3) {
                        sliderDefaults$Thumb$1$1RememberedValue = new SliderDefaults$Thumb$1$1(mutableInteractionSource, snapshotStateList, null);
                        composerStartRestartGroup.updateRememberedValue(sliderDefaults$Thumb$1$1RememberedValue);
                    } else {
                        sliderDefaults$Thumb$1$1RememberedValue = new SliderDefaults$Thumb$1$1(mutableInteractionSource, snapshotStateList, null);
                        composerStartRestartGroup.updateRememberedValue(sliderDefaults$Thumb$1$1RememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    EffectsKt.LaunchedEffect(mutableInteractionSource, (Function2<? super CoroutineScope, ? super Continuation<? super Unit>, ? extends Object>) sliderDefaults$Thumb$1$1RememberedValue, composerStartRestartGroup, i14);
                    if (snapshotStateList.isEmpty()) {
                        j3 = DpSize.copy-DwJknco$default(j2, Dp.constructor-impl(DpSize.getWidth-D9Ej5fM(j2) / 2), 0.0f, 2, (Object) null);
                    } else {
                        j3 = j2;
                    }
                    SpacerKt.Spacer(BackgroundKt.m518backgroundbw27NRU(HoverableKt.hoverable$default(SizeKt.m1081size6HolHcs(modifier2, j3), mutableInteractionSource, false, 2, null), sliderColors2.m2803thumbColorvNxB06k$material3_release(z2), ShapesKt.getValue(SliderTokens.INSTANCE.getHandleShape(), composerStartRestartGroup, 6)), composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i10 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i2 & 4) != 0) {
                            SliderColors sliderColorsColors8 = colors(composerStartRestartGroup, (i3 >> 15) & 14);
                            i3 &= -897;
                            sliderColors2 = sliderColorsColors8;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if (i6 != 0) {
                            j2 = SliderKt.ThumbSize;
                        }
                    } else {
                        if (i10 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i2 & 4) != 0) {
                            SliderColors sliderColorsColors9 = colors(composerStartRestartGroup, (i3 >> 15) & 14);
                            i3 &= -897;
                            sliderColors2 = sliderColorsColors9;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if (i6 != 0) {
                            j2 = SliderKt.ThumbSize;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-290277409, i3, -1, "androidx.compose.material3.SliderDefaults.Thumb (Slider.kt:950)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1068636116, "CC(remember):Slider.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotStateKt.mutableStateListOf();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    snapshotStateList = (SnapshotStateList) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1068632656, "CC(remember):Slider.kt#9igjgp");
                    int i15 = i3 & 14;
                    if (i15 == 4) {
                    }
                    sliderDefaults$Thumb$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z3) {
                        sliderDefaults$Thumb$1$1RememberedValue = new SliderDefaults$Thumb$1$1(mutableInteractionSource, snapshotStateList, null);
                        composerStartRestartGroup.updateRememberedValue(sliderDefaults$Thumb$1$1RememberedValue);
                    } else {
                        sliderDefaults$Thumb$1$1RememberedValue = new SliderDefaults$Thumb$1$1(mutableInteractionSource, snapshotStateList, null);
                        composerStartRestartGroup.updateRememberedValue(sliderDefaults$Thumb$1$1RememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    EffectsKt.LaunchedEffect(mutableInteractionSource, (Function2<? super CoroutineScope, ? super Continuation<? super Unit>, ? extends Object>) sliderDefaults$Thumb$1$1RememberedValue, composerStartRestartGroup, i15);
                    if (snapshotStateList.isEmpty()) {
                        j3 = DpSize.copy-DwJknco$default(j2, Dp.constructor-impl(DpSize.getWidth-D9Ej5fM(j2) / 2), 0.0f, 2, (Object) null);
                    } else {
                        j3 = j2;
                    }
                    SpacerKt.Spacer(BackgroundKt.m518backgroundbw27NRU(HoverableKt.hoverable$default(SizeKt.m1081size6HolHcs(modifier2, j3), mutableInteractionSource, false, 2, null), sliderColors2.m2803thumbColorvNxB06k$material3_release(z2), ShapesKt.getValue(SliderTokens.INSTANCE.getHandleShape(), composerStartRestartGroup, 6)), composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
                modifier3 = modifier2;
                sliderColors3 = sliderColors2;
                z4 = z2;
                j4 = j2;
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

                        public final void invoke(Composer composer2, int i16) {
                            this.$tmp2_rcvr.m2811Thumb9LiSoMs(mutableInteractionSource, modifier3, sliderColors3, z4, j4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            j2 = j;
            if ((i2 & 32) != 0) {
                i3 |= 196608;
            } else if ((i & 196608) == 0) {
                if (composerStartRestartGroup.changed(this)) {
                    i8 = Fields.RenderEffect;
                } else {
                    i8 = 65536;
                }
                i3 |= i8;
            }
            if ((i3 & 74899) == 74898) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i10 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i2 & 4) != 0) {
                        SliderColors sliderColorsColors10 = colors(composerStartRestartGroup, (i3 >> 15) & 14);
                        i3 &= -897;
                        sliderColors2 = sliderColorsColors10;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if (i6 != 0) {
                        j2 = SliderKt.ThumbSize;
                    }
                } else {
                    if (i10 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i2 & 4) != 0) {
                        SliderColors sliderColorsColors11 = colors(composerStartRestartGroup, (i3 >> 15) & 14);
                        i3 &= -897;
                        sliderColors2 = sliderColorsColors11;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if (i6 != 0) {
                        j2 = SliderKt.ThumbSize;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-290277409, i3, -1, "androidx.compose.material3.SliderDefaults.Thumb (Slider.kt:950)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1068636116, "CC(remember):Slider.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = SnapshotStateKt.mutableStateListOf();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                snapshotStateList = (SnapshotStateList) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1068632656, "CC(remember):Slider.kt#9igjgp");
                int i16 = i3 & 14;
                if (i16 == 4) {
                }
                sliderDefaults$Thumb$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z3) {
                    sliderDefaults$Thumb$1$1RememberedValue = new SliderDefaults$Thumb$1$1(mutableInteractionSource, snapshotStateList, null);
                    composerStartRestartGroup.updateRememberedValue(sliderDefaults$Thumb$1$1RememberedValue);
                } else {
                    sliderDefaults$Thumb$1$1RememberedValue = new SliderDefaults$Thumb$1$1(mutableInteractionSource, snapshotStateList, null);
                    composerStartRestartGroup.updateRememberedValue(sliderDefaults$Thumb$1$1RememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                EffectsKt.LaunchedEffect(mutableInteractionSource, (Function2<? super CoroutineScope, ? super Continuation<? super Unit>, ? extends Object>) sliderDefaults$Thumb$1$1RememberedValue, composerStartRestartGroup, i16);
                if (snapshotStateList.isEmpty()) {
                    j3 = DpSize.copy-DwJknco$default(j2, Dp.constructor-impl(DpSize.getWidth-D9Ej5fM(j2) / 2), 0.0f, 2, (Object) null);
                } else {
                    j3 = j2;
                }
                SpacerKt.Spacer(BackgroundKt.m518backgroundbw27NRU(HoverableKt.hoverable$default(SizeKt.m1081size6HolHcs(modifier2, j3), mutableInteractionSource, false, 2, null), sliderColors2.m2803thumbColorvNxB06k$material3_release(z2), ShapesKt.getValue(SliderTokens.INSTANCE.getHandleShape(), composerStartRestartGroup, 6)), composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i10 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i2 & 4) != 0) {
                        SliderColors sliderColorsColors12 = colors(composerStartRestartGroup, (i3 >> 15) & 14);
                        i3 &= -897;
                        sliderColors2 = sliderColorsColors12;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if (i6 != 0) {
                        j2 = SliderKt.ThumbSize;
                    }
                } else {
                    if (i10 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i2 & 4) != 0) {
                        SliderColors sliderColorsColors13 = colors(composerStartRestartGroup, (i3 >> 15) & 14);
                        i3 &= -897;
                        sliderColors2 = sliderColorsColors13;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if (i6 != 0) {
                        j2 = SliderKt.ThumbSize;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-290277409, i3, -1, "androidx.compose.material3.SliderDefaults.Thumb (Slider.kt:950)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1068636116, "CC(remember):Slider.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = SnapshotStateKt.mutableStateListOf();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                snapshotStateList = (SnapshotStateList) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1068632656, "CC(remember):Slider.kt#9igjgp");
                int i17 = i3 & 14;
                if (i17 == 4) {
                }
                sliderDefaults$Thumb$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z3) {
                    sliderDefaults$Thumb$1$1RememberedValue = new SliderDefaults$Thumb$1$1(mutableInteractionSource, snapshotStateList, null);
                    composerStartRestartGroup.updateRememberedValue(sliderDefaults$Thumb$1$1RememberedValue);
                } else {
                    sliderDefaults$Thumb$1$1RememberedValue = new SliderDefaults$Thumb$1$1(mutableInteractionSource, snapshotStateList, null);
                    composerStartRestartGroup.updateRememberedValue(sliderDefaults$Thumb$1$1RememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                EffectsKt.LaunchedEffect(mutableInteractionSource, (Function2<? super CoroutineScope, ? super Continuation<? super Unit>, ? extends Object>) sliderDefaults$Thumb$1$1RememberedValue, composerStartRestartGroup, i17);
                if (snapshotStateList.isEmpty()) {
                    j3 = DpSize.copy-DwJknco$default(j2, Dp.constructor-impl(DpSize.getWidth-D9Ej5fM(j2) / 2), 0.0f, 2, (Object) null);
                } else {
                    j3 = j2;
                }
                SpacerKt.Spacer(BackgroundKt.m518backgroundbw27NRU(HoverableKt.hoverable$default(SizeKt.m1081size6HolHcs(modifier2, j3), mutableInteractionSource, false, 2, null), sliderColors2.m2803thumbColorvNxB06k$material3_release(z2), ShapesKt.getValue(SliderTokens.INSTANCE.getHandleShape(), composerStartRestartGroup, 6)), composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
            }
            modifier3 = modifier2;
            sliderColors3 = sliderColors2;
            z4 = z2;
            j4 = j2;
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

                    public final void invoke(Composer composer2, int i18) {
                        this.$tmp2_rcvr.m2811Thumb9LiSoMs(mutableInteractionSource, modifier3, sliderColors3, z4, j4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        modifier2 = modifier;
        if ((i & 384) == 0) {
            if ((i2 & 4) == 0) {
                sliderColors2 = sliderColors;
                if (composerStartRestartGroup.changed(sliderColors2)) {
                    i9 = Fields.RotationX;
                }
                i3 |= i9;
            } else {
                sliderColors2 = sliderColors;
            }
            i9 = Fields.SpotShadowColor;
            i3 |= i9;
        } else {
            sliderColors2 = sliderColors;
        }
        i4 = i2 & 8;
        if (i4 != 0) {
            if ((i & 3072) == 0) {
                z2 = z;
                if (composerStartRestartGroup.changed(z2)) {
                    i5 = Fields.CameraDistance;
                } else {
                    i5 = Fields.RotationZ;
                }
                i3 |= i5;
            }
            i6 = i2 & 16;
            if (i6 != 0) {
                if ((i & 24576) == 0) {
                    j2 = j;
                    if (composerStartRestartGroup.changed(j2)) {
                        i7 = Fields.Clip;
                    } else {
                        i7 = Fields.Shape;
                    }
                    i3 |= i7;
                }
                if ((i2 & 32) != 0) {
                    i3 |= 196608;
                } else if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changed(this)) {
                        i8 = Fields.RenderEffect;
                    } else {
                        i8 = 65536;
                    }
                    i3 |= i8;
                }
                if ((i3 & 74899) == 74898) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i10 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i2 & 4) != 0) {
                            SliderColors sliderColorsColors14 = colors(composerStartRestartGroup, (i3 >> 15) & 14);
                            i3 &= -897;
                            sliderColors2 = sliderColorsColors14;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if (i6 != 0) {
                            j2 = SliderKt.ThumbSize;
                        }
                    } else {
                        if (i10 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i2 & 4) != 0) {
                            SliderColors sliderColorsColors15 = colors(composerStartRestartGroup, (i3 >> 15) & 14);
                            i3 &= -897;
                            sliderColors2 = sliderColorsColors15;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if (i6 != 0) {
                            j2 = SliderKt.ThumbSize;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-290277409, i3, -1, "androidx.compose.material3.SliderDefaults.Thumb (Slider.kt:950)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1068636116, "CC(remember):Slider.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotStateKt.mutableStateListOf();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    snapshotStateList = (SnapshotStateList) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1068632656, "CC(remember):Slider.kt#9igjgp");
                    int i18 = i3 & 14;
                    if (i18 == 4) {
                    }
                    sliderDefaults$Thumb$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z3) {
                        sliderDefaults$Thumb$1$1RememberedValue = new SliderDefaults$Thumb$1$1(mutableInteractionSource, snapshotStateList, null);
                        composerStartRestartGroup.updateRememberedValue(sliderDefaults$Thumb$1$1RememberedValue);
                    } else {
                        sliderDefaults$Thumb$1$1RememberedValue = new SliderDefaults$Thumb$1$1(mutableInteractionSource, snapshotStateList, null);
                        composerStartRestartGroup.updateRememberedValue(sliderDefaults$Thumb$1$1RememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    EffectsKt.LaunchedEffect(mutableInteractionSource, (Function2<? super CoroutineScope, ? super Continuation<? super Unit>, ? extends Object>) sliderDefaults$Thumb$1$1RememberedValue, composerStartRestartGroup, i18);
                    if (snapshotStateList.isEmpty()) {
                        j3 = DpSize.copy-DwJknco$default(j2, Dp.constructor-impl(DpSize.getWidth-D9Ej5fM(j2) / 2), 0.0f, 2, (Object) null);
                    } else {
                        j3 = j2;
                    }
                    SpacerKt.Spacer(BackgroundKt.m518backgroundbw27NRU(HoverableKt.hoverable$default(SizeKt.m1081size6HolHcs(modifier2, j3), mutableInteractionSource, false, 2, null), sliderColors2.m2803thumbColorvNxB06k$material3_release(z2), ShapesKt.getValue(SliderTokens.INSTANCE.getHandleShape(), composerStartRestartGroup, 6)), composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i10 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i2 & 4) != 0) {
                            SliderColors sliderColorsColors16 = colors(composerStartRestartGroup, (i3 >> 15) & 14);
                            i3 &= -897;
                            sliderColors2 = sliderColorsColors16;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if (i6 != 0) {
                            j2 = SliderKt.ThumbSize;
                        }
                    } else {
                        if (i10 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i2 & 4) != 0) {
                            SliderColors sliderColorsColors17 = colors(composerStartRestartGroup, (i3 >> 15) & 14);
                            i3 &= -897;
                            sliderColors2 = sliderColorsColors17;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if (i6 != 0) {
                            j2 = SliderKt.ThumbSize;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-290277409, i3, -1, "androidx.compose.material3.SliderDefaults.Thumb (Slider.kt:950)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1068636116, "CC(remember):Slider.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotStateKt.mutableStateListOf();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    snapshotStateList = (SnapshotStateList) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1068632656, "CC(remember):Slider.kt#9igjgp");
                    int i19 = i3 & 14;
                    if (i19 == 4) {
                    }
                    sliderDefaults$Thumb$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z3) {
                        sliderDefaults$Thumb$1$1RememberedValue = new SliderDefaults$Thumb$1$1(mutableInteractionSource, snapshotStateList, null);
                        composerStartRestartGroup.updateRememberedValue(sliderDefaults$Thumb$1$1RememberedValue);
                    } else {
                        sliderDefaults$Thumb$1$1RememberedValue = new SliderDefaults$Thumb$1$1(mutableInteractionSource, snapshotStateList, null);
                        composerStartRestartGroup.updateRememberedValue(sliderDefaults$Thumb$1$1RememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    EffectsKt.LaunchedEffect(mutableInteractionSource, (Function2<? super CoroutineScope, ? super Continuation<? super Unit>, ? extends Object>) sliderDefaults$Thumb$1$1RememberedValue, composerStartRestartGroup, i19);
                    if (snapshotStateList.isEmpty()) {
                        j3 = DpSize.copy-DwJknco$default(j2, Dp.constructor-impl(DpSize.getWidth-D9Ej5fM(j2) / 2), 0.0f, 2, (Object) null);
                    } else {
                        j3 = j2;
                    }
                    SpacerKt.Spacer(BackgroundKt.m518backgroundbw27NRU(HoverableKt.hoverable$default(SizeKt.m1081size6HolHcs(modifier2, j3), mutableInteractionSource, false, 2, null), sliderColors2.m2803thumbColorvNxB06k$material3_release(z2), ShapesKt.getValue(SliderTokens.INSTANCE.getHandleShape(), composerStartRestartGroup, 6)), composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
                modifier3 = modifier2;
                sliderColors3 = sliderColors2;
                z4 = z2;
                j4 = j2;
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

                        public final void invoke(Composer composer2, int i110) {
                            this.$tmp2_rcvr.m2811Thumb9LiSoMs(mutableInteractionSource, modifier3, sliderColors3, z4, j4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            j2 = j;
            if ((i2 & 32) != 0) {
                i3 |= 196608;
            } else if ((i & 196608) == 0) {
                if (composerStartRestartGroup.changed(this)) {
                    i8 = Fields.RenderEffect;
                } else {
                    i8 = 65536;
                }
                i3 |= i8;
            }
            if ((i3 & 74899) == 74898) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i10 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i2 & 4) != 0) {
                        SliderColors sliderColorsColors18 = colors(composerStartRestartGroup, (i3 >> 15) & 14);
                        i3 &= -897;
                        sliderColors2 = sliderColorsColors18;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if (i6 != 0) {
                        j2 = SliderKt.ThumbSize;
                    }
                } else {
                    if (i10 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i2 & 4) != 0) {
                        SliderColors sliderColorsColors19 = colors(composerStartRestartGroup, (i3 >> 15) & 14);
                        i3 &= -897;
                        sliderColors2 = sliderColorsColors19;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if (i6 != 0) {
                        j2 = SliderKt.ThumbSize;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-290277409, i3, -1, "androidx.compose.material3.SliderDefaults.Thumb (Slider.kt:950)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1068636116, "CC(remember):Slider.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = SnapshotStateKt.mutableStateListOf();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                snapshotStateList = (SnapshotStateList) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1068632656, "CC(remember):Slider.kt#9igjgp");
                int i110 = i3 & 14;
                if (i110 == 4) {
                }
                sliderDefaults$Thumb$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z3) {
                    sliderDefaults$Thumb$1$1RememberedValue = new SliderDefaults$Thumb$1$1(mutableInteractionSource, snapshotStateList, null);
                    composerStartRestartGroup.updateRememberedValue(sliderDefaults$Thumb$1$1RememberedValue);
                } else {
                    sliderDefaults$Thumb$1$1RememberedValue = new SliderDefaults$Thumb$1$1(mutableInteractionSource, snapshotStateList, null);
                    composerStartRestartGroup.updateRememberedValue(sliderDefaults$Thumb$1$1RememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                EffectsKt.LaunchedEffect(mutableInteractionSource, (Function2<? super CoroutineScope, ? super Continuation<? super Unit>, ? extends Object>) sliderDefaults$Thumb$1$1RememberedValue, composerStartRestartGroup, i110);
                if (snapshotStateList.isEmpty()) {
                    j3 = DpSize.copy-DwJknco$default(j2, Dp.constructor-impl(DpSize.getWidth-D9Ej5fM(j2) / 2), 0.0f, 2, (Object) null);
                } else {
                    j3 = j2;
                }
                SpacerKt.Spacer(BackgroundKt.m518backgroundbw27NRU(HoverableKt.hoverable$default(SizeKt.m1081size6HolHcs(modifier2, j3), mutableInteractionSource, false, 2, null), sliderColors2.m2803thumbColorvNxB06k$material3_release(z2), ShapesKt.getValue(SliderTokens.INSTANCE.getHandleShape(), composerStartRestartGroup, 6)), composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i10 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i2 & 4) != 0) {
                        SliderColors sliderColorsColors110 = colors(composerStartRestartGroup, (i3 >> 15) & 14);
                        i3 &= -897;
                        sliderColors2 = sliderColorsColors110;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if (i6 != 0) {
                        j2 = SliderKt.ThumbSize;
                    }
                } else {
                    if (i10 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i2 & 4) != 0) {
                        SliderColors sliderColorsColors111 = colors(composerStartRestartGroup, (i3 >> 15) & 14);
                        i3 &= -897;
                        sliderColors2 = sliderColorsColors111;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if (i6 != 0) {
                        j2 = SliderKt.ThumbSize;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-290277409, i3, -1, "androidx.compose.material3.SliderDefaults.Thumb (Slider.kt:950)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1068636116, "CC(remember):Slider.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = SnapshotStateKt.mutableStateListOf();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                snapshotStateList = (SnapshotStateList) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1068632656, "CC(remember):Slider.kt#9igjgp");
                int i111 = i3 & 14;
                if (i111 == 4) {
                }
                sliderDefaults$Thumb$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z3) {
                    sliderDefaults$Thumb$1$1RememberedValue = new SliderDefaults$Thumb$1$1(mutableInteractionSource, snapshotStateList, null);
                    composerStartRestartGroup.updateRememberedValue(sliderDefaults$Thumb$1$1RememberedValue);
                } else {
                    sliderDefaults$Thumb$1$1RememberedValue = new SliderDefaults$Thumb$1$1(mutableInteractionSource, snapshotStateList, null);
                    composerStartRestartGroup.updateRememberedValue(sliderDefaults$Thumb$1$1RememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                EffectsKt.LaunchedEffect(mutableInteractionSource, (Function2<? super CoroutineScope, ? super Continuation<? super Unit>, ? extends Object>) sliderDefaults$Thumb$1$1RememberedValue, composerStartRestartGroup, i111);
                if (snapshotStateList.isEmpty()) {
                    j3 = DpSize.copy-DwJknco$default(j2, Dp.constructor-impl(DpSize.getWidth-D9Ej5fM(j2) / 2), 0.0f, 2, (Object) null);
                } else {
                    j3 = j2;
                }
                SpacerKt.Spacer(BackgroundKt.m518backgroundbw27NRU(HoverableKt.hoverable$default(SizeKt.m1081size6HolHcs(modifier2, j3), mutableInteractionSource, false, 2, null), sliderColors2.m2803thumbColorvNxB06k$material3_release(z2), ShapesKt.getValue(SliderTokens.INSTANCE.getHandleShape(), composerStartRestartGroup, 6)), composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
            }
            modifier3 = modifier2;
            sliderColors3 = sliderColors2;
            z4 = z2;
            j4 = j2;
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

                    public final void invoke(Composer composer2, int i112) {
                        this.$tmp2_rcvr.m2811Thumb9LiSoMs(mutableInteractionSource, modifier3, sliderColors3, z4, j4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 3072;
        z2 = z;
        i6 = i2 & 16;
        if (i6 != 0) {
            if ((i & 24576) == 0) {
                j2 = j;
                if (composerStartRestartGroup.changed(j2)) {
                    i7 = Fields.Clip;
                } else {
                    i7 = Fields.Shape;
                }
                i3 |= i7;
            }
            if ((i2 & 32) != 0) {
                i3 |= 196608;
            } else if ((i & 196608) == 0) {
                if (composerStartRestartGroup.changed(this)) {
                    i8 = Fields.RenderEffect;
                } else {
                    i8 = 65536;
                }
                i3 |= i8;
            }
            if ((i3 & 74899) == 74898) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i10 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i2 & 4) != 0) {
                        SliderColors sliderColorsColors112 = colors(composerStartRestartGroup, (i3 >> 15) & 14);
                        i3 &= -897;
                        sliderColors2 = sliderColorsColors112;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if (i6 != 0) {
                        j2 = SliderKt.ThumbSize;
                    }
                } else {
                    if (i10 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i2 & 4) != 0) {
                        SliderColors sliderColorsColors113 = colors(composerStartRestartGroup, (i3 >> 15) & 14);
                        i3 &= -897;
                        sliderColors2 = sliderColorsColors113;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if (i6 != 0) {
                        j2 = SliderKt.ThumbSize;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-290277409, i3, -1, "androidx.compose.material3.SliderDefaults.Thumb (Slider.kt:950)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1068636116, "CC(remember):Slider.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = SnapshotStateKt.mutableStateListOf();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                snapshotStateList = (SnapshotStateList) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1068632656, "CC(remember):Slider.kt#9igjgp");
                int i112 = i3 & 14;
                if (i112 == 4) {
                }
                sliderDefaults$Thumb$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z3) {
                    sliderDefaults$Thumb$1$1RememberedValue = new SliderDefaults$Thumb$1$1(mutableInteractionSource, snapshotStateList, null);
                    composerStartRestartGroup.updateRememberedValue(sliderDefaults$Thumb$1$1RememberedValue);
                } else {
                    sliderDefaults$Thumb$1$1RememberedValue = new SliderDefaults$Thumb$1$1(mutableInteractionSource, snapshotStateList, null);
                    composerStartRestartGroup.updateRememberedValue(sliderDefaults$Thumb$1$1RememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                EffectsKt.LaunchedEffect(mutableInteractionSource, (Function2<? super CoroutineScope, ? super Continuation<? super Unit>, ? extends Object>) sliderDefaults$Thumb$1$1RememberedValue, composerStartRestartGroup, i112);
                if (snapshotStateList.isEmpty()) {
                    j3 = DpSize.copy-DwJknco$default(j2, Dp.constructor-impl(DpSize.getWidth-D9Ej5fM(j2) / 2), 0.0f, 2, (Object) null);
                } else {
                    j3 = j2;
                }
                SpacerKt.Spacer(BackgroundKt.m518backgroundbw27NRU(HoverableKt.hoverable$default(SizeKt.m1081size6HolHcs(modifier2, j3), mutableInteractionSource, false, 2, null), sliderColors2.m2803thumbColorvNxB06k$material3_release(z2), ShapesKt.getValue(SliderTokens.INSTANCE.getHandleShape(), composerStartRestartGroup, 6)), composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i10 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i2 & 4) != 0) {
                        SliderColors sliderColorsColors114 = colors(composerStartRestartGroup, (i3 >> 15) & 14);
                        i3 &= -897;
                        sliderColors2 = sliderColorsColors114;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if (i6 != 0) {
                        j2 = SliderKt.ThumbSize;
                    }
                } else {
                    if (i10 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i2 & 4) != 0) {
                        SliderColors sliderColorsColors115 = colors(composerStartRestartGroup, (i3 >> 15) & 14);
                        i3 &= -897;
                        sliderColors2 = sliderColorsColors115;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if (i6 != 0) {
                        j2 = SliderKt.ThumbSize;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-290277409, i3, -1, "androidx.compose.material3.SliderDefaults.Thumb (Slider.kt:950)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1068636116, "CC(remember):Slider.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = SnapshotStateKt.mutableStateListOf();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                snapshotStateList = (SnapshotStateList) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1068632656, "CC(remember):Slider.kt#9igjgp");
                int i113 = i3 & 14;
                if (i113 == 4) {
                }
                sliderDefaults$Thumb$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z3) {
                    sliderDefaults$Thumb$1$1RememberedValue = new SliderDefaults$Thumb$1$1(mutableInteractionSource, snapshotStateList, null);
                    composerStartRestartGroup.updateRememberedValue(sliderDefaults$Thumb$1$1RememberedValue);
                } else {
                    sliderDefaults$Thumb$1$1RememberedValue = new SliderDefaults$Thumb$1$1(mutableInteractionSource, snapshotStateList, null);
                    composerStartRestartGroup.updateRememberedValue(sliderDefaults$Thumb$1$1RememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                EffectsKt.LaunchedEffect(mutableInteractionSource, (Function2<? super CoroutineScope, ? super Continuation<? super Unit>, ? extends Object>) sliderDefaults$Thumb$1$1RememberedValue, composerStartRestartGroup, i113);
                if (snapshotStateList.isEmpty()) {
                    j3 = DpSize.copy-DwJknco$default(j2, Dp.constructor-impl(DpSize.getWidth-D9Ej5fM(j2) / 2), 0.0f, 2, (Object) null);
                } else {
                    j3 = j2;
                }
                SpacerKt.Spacer(BackgroundKt.m518backgroundbw27NRU(HoverableKt.hoverable$default(SizeKt.m1081size6HolHcs(modifier2, j3), mutableInteractionSource, false, 2, null), sliderColors2.m2803thumbColorvNxB06k$material3_release(z2), ShapesKt.getValue(SliderTokens.INSTANCE.getHandleShape(), composerStartRestartGroup, 6)), composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
            }
            modifier3 = modifier2;
            sliderColors3 = sliderColors2;
            z4 = z2;
            j4 = j2;
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

                    public final void invoke(Composer composer2, int i114) {
                        this.$tmp2_rcvr.m2811Thumb9LiSoMs(mutableInteractionSource, modifier3, sliderColors3, z4, j4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 24576;
        j2 = j;
        if ((i2 & 32) != 0) {
            i3 |= 196608;
        } else if ((i & 196608) == 0) {
            if (composerStartRestartGroup.changed(this)) {
                i8 = Fields.RenderEffect;
            } else {
                i8 = 65536;
            }
            i3 |= i8;
        }
        if ((i3 & 74899) == 74898) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i10 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if ((i2 & 4) != 0) {
                    SliderColors sliderColorsColors116 = colors(composerStartRestartGroup, (i3 >> 15) & 14);
                    i3 &= -897;
                    sliderColors2 = sliderColorsColors116;
                }
                if (i4 != 0) {
                    z2 = true;
                }
                if (i6 != 0) {
                    j2 = SliderKt.ThumbSize;
                }
            } else {
                if (i10 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if ((i2 & 4) != 0) {
                    SliderColors sliderColorsColors117 = colors(composerStartRestartGroup, (i3 >> 15) & 14);
                    i3 &= -897;
                    sliderColors2 = sliderColorsColors117;
                }
                if (i4 != 0) {
                    z2 = true;
                }
                if (i6 != 0) {
                    j2 = SliderKt.ThumbSize;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-290277409, i3, -1, "androidx.compose.material3.SliderDefaults.Thumb (Slider.kt:950)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1068636116, "CC(remember):Slider.kt#9igjgp");
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                objRememberedValue = SnapshotStateKt.mutableStateListOf();
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            snapshotStateList = (SnapshotStateList) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1068632656, "CC(remember):Slider.kt#9igjgp");
            int i114 = i3 & 14;
            if (i114 == 4) {
            }
            sliderDefaults$Thumb$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
            if (!z3) {
                sliderDefaults$Thumb$1$1RememberedValue = new SliderDefaults$Thumb$1$1(mutableInteractionSource, snapshotStateList, null);
                composerStartRestartGroup.updateRememberedValue(sliderDefaults$Thumb$1$1RememberedValue);
            } else {
                sliderDefaults$Thumb$1$1RememberedValue = new SliderDefaults$Thumb$1$1(mutableInteractionSource, snapshotStateList, null);
                composerStartRestartGroup.updateRememberedValue(sliderDefaults$Thumb$1$1RememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            EffectsKt.LaunchedEffect(mutableInteractionSource, (Function2<? super CoroutineScope, ? super Continuation<? super Unit>, ? extends Object>) sliderDefaults$Thumb$1$1RememberedValue, composerStartRestartGroup, i114);
            if (snapshotStateList.isEmpty()) {
                j3 = DpSize.copy-DwJknco$default(j2, Dp.constructor-impl(DpSize.getWidth-D9Ej5fM(j2) / 2), 0.0f, 2, (Object) null);
            } else {
                j3 = j2;
            }
            SpacerKt.Spacer(BackgroundKt.m518backgroundbw27NRU(HoverableKt.hoverable$default(SizeKt.m1081size6HolHcs(modifier2, j3), mutableInteractionSource, false, 2, null), sliderColors2.m2803thumbColorvNxB06k$material3_release(z2), ShapesKt.getValue(SliderTokens.INSTANCE.getHandleShape(), composerStartRestartGroup, 6)), composerStartRestartGroup, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i10 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if ((i2 & 4) != 0) {
                    SliderColors sliderColorsColors118 = colors(composerStartRestartGroup, (i3 >> 15) & 14);
                    i3 &= -897;
                    sliderColors2 = sliderColorsColors118;
                }
                if (i4 != 0) {
                    z2 = true;
                }
                if (i6 != 0) {
                    j2 = SliderKt.ThumbSize;
                }
            } else {
                if (i10 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if ((i2 & 4) != 0) {
                    SliderColors sliderColorsColors119 = colors(composerStartRestartGroup, (i3 >> 15) & 14);
                    i3 &= -897;
                    sliderColors2 = sliderColorsColors119;
                }
                if (i4 != 0) {
                    z2 = true;
                }
                if (i6 != 0) {
                    j2 = SliderKt.ThumbSize;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-290277409, i3, -1, "androidx.compose.material3.SliderDefaults.Thumb (Slider.kt:950)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1068636116, "CC(remember):Slider.kt#9igjgp");
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                objRememberedValue = SnapshotStateKt.mutableStateListOf();
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            snapshotStateList = (SnapshotStateList) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1068632656, "CC(remember):Slider.kt#9igjgp");
            int i115 = i3 & 14;
            if (i115 == 4) {
            }
            sliderDefaults$Thumb$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
            if (!z3) {
                sliderDefaults$Thumb$1$1RememberedValue = new SliderDefaults$Thumb$1$1(mutableInteractionSource, snapshotStateList, null);
                composerStartRestartGroup.updateRememberedValue(sliderDefaults$Thumb$1$1RememberedValue);
            } else {
                sliderDefaults$Thumb$1$1RememberedValue = new SliderDefaults$Thumb$1$1(mutableInteractionSource, snapshotStateList, null);
                composerStartRestartGroup.updateRememberedValue(sliderDefaults$Thumb$1$1RememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            EffectsKt.LaunchedEffect(mutableInteractionSource, (Function2<? super CoroutineScope, ? super Continuation<? super Unit>, ? extends Object>) sliderDefaults$Thumb$1$1RememberedValue, composerStartRestartGroup, i115);
            if (snapshotStateList.isEmpty()) {
                j3 = DpSize.copy-DwJknco$default(j2, Dp.constructor-impl(DpSize.getWidth-D9Ej5fM(j2) / 2), 0.0f, 2, (Object) null);
            } else {
                j3 = j2;
            }
            SpacerKt.Spacer(BackgroundKt.m518backgroundbw27NRU(HoverableKt.hoverable$default(SizeKt.m1081size6HolHcs(modifier2, j3), mutableInteractionSource, false, 2, null), sliderColors2.m2803thumbColorvNxB06k$material3_release(z2), ShapesKt.getValue(SliderTokens.INSTANCE.getHandleShape(), composerStartRestartGroup, 6)), composerStartRestartGroup, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        }
        modifier3 = modifier2;
        sliderColors3 = sliderColors2;
        z4 = z2;
        j4 = j2;
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

                public final void invoke(Composer composer2, int i116) {
                    this.$tmp2_rcvr.m2811Thumb9LiSoMs(mutableInteractionSource, modifier3, sliderColors3, z4, j4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    @Deprecated(message = "Use version that supports slider state")
    public final void Track(final SliderPositions sliderPositions, Modifier modifier, SliderColors sliderColors, boolean z, Composer composer, final int i, final int i2) {
        int i3;
        Modifier modifier2;
        SliderColors sliderColors2;
        int i4;
        boolean z2;
        int i5;
        int i6;
        Modifier.Companion companion;
        boolean z3;
        int i7;
        final long jM2805trackColorWaAFU9c$material3_release;
        final long jM2805trackColorWaAFU9c$material3_release2;
        final long jM2804tickColorWaAFU9c$material3_release;
        final long jM2804tickColorWaAFU9c$material3_release2;
        Composer composer2;
        boolean z4;
        boolean zChanged;
        Object objRememberedValue;
        final SliderColors sliderColors3;
        final Modifier modifier3;
        final boolean z5;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i8;
        Composer composerStartRestartGroup = composer.startRestartGroup(-1546713545);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(Track)P(3,2)997@44755L8,1004@45160L1834,1004@45108L1886:Slider.kt#uh7d8r");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changed(sliderPositions) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i9 = i2 & 2;
        if (i9 == 0) {
            if ((i & 48) == 0) {
                modifier2 = modifier;
                i3 |= composerStartRestartGroup.changed(modifier2) ? 32 : 16;
            }
            if ((i & 384) == 0) {
                if ((i2 & 4) == 0) {
                    sliderColors2 = sliderColors;
                    if (composerStartRestartGroup.changed(sliderColors2)) {
                        i8 = Fields.RotationX;
                    }
                    i3 |= i8;
                } else {
                    sliderColors2 = sliderColors;
                }
                i8 = Fields.SpotShadowColor;
                i3 |= i8;
            } else {
                sliderColors2 = sliderColors;
            }
            i4 = i2 & 8;
            if (i4 != 0) {
                if ((i & 3072) == 0) {
                    z2 = z;
                    if (composerStartRestartGroup.changed(z2)) {
                        i5 = Fields.CameraDistance;
                    } else {
                        i5 = Fields.RotationZ;
                    }
                    i3 |= i5;
                }
                if ((i2 & 16) != 0) {
                    i3 |= 24576;
                } else if ((i & 24576) == 0) {
                    if (composerStartRestartGroup.changed(this)) {
                        i6 = Fields.Clip;
                    } else {
                        i6 = Fields.Shape;
                    }
                    i3 |= i6;
                }
                if ((i3 & 9363) == 9362 || !composerStartRestartGroup.getSkipping()) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                        if (i9 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i2 & 4) != 0) {
                            SliderColors sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 12) & 14);
                            i3 &= -897;
                            sliderColors2 = sliderColorsColors;
                        }
                        if (i4 != 0) {
                            z3 = true;
                        }
                        SliderColors sliderColors4 = sliderColors2;
                        i7 = i3;
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1546713545, i7, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:999)");
                        }
                        jM2805trackColorWaAFU9c$material3_release = sliderColors4.m2805trackColorWaAFU9c$material3_release(z3, false);
                        jM2805trackColorWaAFU9c$material3_release2 = sliderColors4.m2805trackColorWaAFU9c$material3_release(z3, true);
                        jM2804tickColorWaAFU9c$material3_release = sliderColors4.m2804tickColorWaAFU9c$material3_release(z3, false);
                        jM2804tickColorWaAFU9c$material3_release2 = sliderColors4.m2804tickColorWaAFU9c$material3_release(z3, true);
                        Modifier modifierM1066height3ABfNKs = SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), SliderKt.getTrackHeight());
                        composer2 = composerStartRestartGroup;
                        ComposerKt.sourceInformationMarkerStart(composer2, -801023075, "CC(remember):Slider.kt#9igjgp");
                        boolean zChanged2 = composer2.changed(jM2805trackColorWaAFU9c$material3_release);
                        if ((i7 & 14) == 4) {
                            z4 = true;
                        } else {
                            z4 = false;
                        }
                        zChanged = zChanged2 | z4 | composer2.changed(jM2805trackColorWaAFU9c$material3_release2) | composer2.changed(jM2804tickColorWaAFU9c$material3_release) | composer2.changed(jM2804tickColorWaAFU9c$material3_release2);
                        objRememberedValue = composer2.rememberedValue();
                        if (!zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    boolean z6 = drawScope.getLayoutDirection() == LayoutDirection.Rtl;
                                    long jOffset = OffsetKt.Offset(0.0f, Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()));
                                    long jOffset2 = OffsetKt.Offset(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()));
                                    long j = z6 ? jOffset2 : jOffset;
                                    long j2 = z6 ? jOffset : jOffset2;
                                    float f = drawScope.toPx-0680j_4(SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM());
                                    float f2 = drawScope.toPx-0680j_4(SliderKt.getTrackHeight());
                                    long j3 = j2;
                                    long j4 = j;
                                    DrawScope.CC.m5172drawLineNGM6Ib0$default(drawScope, jM2805trackColorWaAFU9c$material3_release, j, j2, f2, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                                    DrawScope.CC.m5172drawLineNGM6Ib0$default(drawScope, jM2805trackColorWaAFU9c$material3_release2, OffsetKt.Offset(Offset.m4346getXimpl(j4) + ((Offset.m4346getXimpl(j3) - Offset.m4346getXimpl(j4)) * ((Number) sliderPositions.getActiveRange().getStart()).floatValue()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0())), OffsetKt.Offset(Offset.m4346getXimpl(j4) + ((Offset.m4346getXimpl(j3) - Offset.m4346getXimpl(j4)) * ((Number) sliderPositions.getActiveRange().getEndInclusive()).floatValue()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0())), f2, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                                    float[] tickFractions = sliderPositions.getTickFractions();
                                    SliderPositions sliderPositions2 = sliderPositions;
                                    LinkedHashMap linkedHashMap = new LinkedHashMap();
                                    int length = tickFractions.length;
                                    for (int i10 = 0; i10 < length; i10++) {
                                        float f3 = tickFractions[i10];
                                        Boolean boolValueOf = Boolean.valueOf(f3 > ((Number) sliderPositions2.getActiveRange().getEndInclusive()).floatValue() || f3 < ((Number) sliderPositions2.getActiveRange().getStart()).floatValue());
                                        Object obj = linkedHashMap.get(boolValueOf);
                                        if (obj == null) {
                                            obj = (List) new ArrayList();
                                            linkedHashMap.put(boolValueOf, obj);
                                        }
                                        ((List) obj).add(Float.valueOf(f3));
                                    }
                                    long j5 = jM2804tickColorWaAFU9c$material3_release;
                                    long j6 = jM2804tickColorWaAFU9c$material3_release2;
                                    for (Map.Entry entry : linkedHashMap.entrySet()) {
                                        boolean zBooleanValue = ((Boolean) entry.getKey()).booleanValue();
                                        List list = (List) entry.getValue();
                                        ArrayList arrayList = new ArrayList(list.size());
                                        int size = list.size();
                                        for (int i11 = 0; i11 < size; i11++) {
                                            arrayList.add(Offset.m4335boximpl(OffsetKt.Offset(Offset.m4346getXimpl(OffsetKt.m4369lerpWko1d7g(j4, j3, ((Number) list.get(i11)).floatValue())), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()))));
                                        }
                                        long j7 = j4;
                                        j3 = j3;
                                        DrawScope.CC.m5177drawPointsF8ZwMP8$default(drawScope, arrayList, PointMode.INSTANCE.m4904getPointsr_lszbg(), zBooleanValue ? j5 : j6, f, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                                        j6 = j6;
                                        j4 = j7;
                                    }
                                }
                            };
                            composer2.updateRememberedValue(objRememberedValue);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        CanvasKt.Canvas(modifierM1066height3ABfNKs, (Function1) objRememberedValue, composer2, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        sliderColors3 = sliderColors4;
                        modifier3 = companion;
                        z5 = z3;
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        if ((i2 & 4) != 0) {
                            i3 &= -897;
                        }
                        companion = modifier2;
                    }
                    z3 = z2;
                    SliderColors sliderColors5 = sliderColors2;
                    i7 = i3;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1546713545, i7, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:999)");
                    }
                    jM2805trackColorWaAFU9c$material3_release = sliderColors5.m2805trackColorWaAFU9c$material3_release(z3, false);
                    jM2805trackColorWaAFU9c$material3_release2 = sliderColors5.m2805trackColorWaAFU9c$material3_release(z3, true);
                    jM2804tickColorWaAFU9c$material3_release = sliderColors5.m2804tickColorWaAFU9c$material3_release(z3, false);
                    jM2804tickColorWaAFU9c$material3_release2 = sliderColors5.m2804tickColorWaAFU9c$material3_release(z3, true);
                    Modifier modifierM1066height3ABfNKs2 = SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), SliderKt.getTrackHeight());
                    composer2 = composerStartRestartGroup;
                    ComposerKt.sourceInformationMarkerStart(composer2, -801023075, "CC(remember):Slider.kt#9igjgp");
                    boolean zChanged3 = composer2.changed(jM2805trackColorWaAFU9c$material3_release);
                    if ((i7 & 14) == 4) {
                        z4 = true;
                    } else {
                        z4 = false;
                    }
                    zChanged = zChanged3 | z4 | composer2.changed(jM2805trackColorWaAFU9c$material3_release2) | composer2.changed(jM2804tickColorWaAFU9c$material3_release) | composer2.changed(jM2804tickColorWaAFU9c$material3_release2);
                    objRememberedValue = composer2.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                boolean z6 = drawScope.getLayoutDirection() == LayoutDirection.Rtl;
                                long jOffset = OffsetKt.Offset(0.0f, Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()));
                                long jOffset2 = OffsetKt.Offset(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()));
                                long j = z6 ? jOffset2 : jOffset;
                                long j2 = z6 ? jOffset : jOffset2;
                                float f = drawScope.toPx-0680j_4(SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM());
                                float f2 = drawScope.toPx-0680j_4(SliderKt.getTrackHeight());
                                long j3 = j2;
                                long j4 = j;
                                DrawScope.CC.m5172drawLineNGM6Ib0$default(drawScope, jM2805trackColorWaAFU9c$material3_release, j, j2, f2, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                                DrawScope.CC.m5172drawLineNGM6Ib0$default(drawScope, jM2805trackColorWaAFU9c$material3_release2, OffsetKt.Offset(Offset.m4346getXimpl(j4) + ((Offset.m4346getXimpl(j3) - Offset.m4346getXimpl(j4)) * ((Number) sliderPositions.getActiveRange().getStart()).floatValue()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0())), OffsetKt.Offset(Offset.m4346getXimpl(j4) + ((Offset.m4346getXimpl(j3) - Offset.m4346getXimpl(j4)) * ((Number) sliderPositions.getActiveRange().getEndInclusive()).floatValue()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0())), f2, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                                float[] tickFractions = sliderPositions.getTickFractions();
                                SliderPositions sliderPositions2 = sliderPositions;
                                LinkedHashMap linkedHashMap = new LinkedHashMap();
                                int length = tickFractions.length;
                                for (int i10 = 0; i10 < length; i10++) {
                                    float f3 = tickFractions[i10];
                                    Boolean boolValueOf = Boolean.valueOf(f3 > ((Number) sliderPositions2.getActiveRange().getEndInclusive()).floatValue() || f3 < ((Number) sliderPositions2.getActiveRange().getStart()).floatValue());
                                    Object obj = linkedHashMap.get(boolValueOf);
                                    if (obj == null) {
                                        obj = (List) new ArrayList();
                                        linkedHashMap.put(boolValueOf, obj);
                                    }
                                    ((List) obj).add(Float.valueOf(f3));
                                }
                                long j5 = jM2804tickColorWaAFU9c$material3_release;
                                long j6 = jM2804tickColorWaAFU9c$material3_release2;
                                for (Map.Entry entry : linkedHashMap.entrySet()) {
                                    boolean zBooleanValue = ((Boolean) entry.getKey()).booleanValue();
                                    List list = (List) entry.getValue();
                                    ArrayList arrayList = new ArrayList(list.size());
                                    int size = list.size();
                                    for (int i11 = 0; i11 < size; i11++) {
                                        arrayList.add(Offset.m4335boximpl(OffsetKt.Offset(Offset.m4346getXimpl(OffsetKt.m4369lerpWko1d7g(j4, j3, ((Number) list.get(i11)).floatValue())), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()))));
                                    }
                                    long j7 = j4;
                                    j3 = j3;
                                    DrawScope.CC.m5177drawPointsF8ZwMP8$default(drawScope, arrayList, PointMode.INSTANCE.m4904getPointsr_lszbg(), zBooleanValue ? j5 : j6, f, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                                    j6 = j6;
                                    j4 = j7;
                                }
                            }
                        };
                        composer2.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                boolean z6 = drawScope.getLayoutDirection() == LayoutDirection.Rtl;
                                long jOffset = OffsetKt.Offset(0.0f, Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()));
                                long jOffset2 = OffsetKt.Offset(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()));
                                long j = z6 ? jOffset2 : jOffset;
                                long j2 = z6 ? jOffset : jOffset2;
                                float f = drawScope.toPx-0680j_4(SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM());
                                float f2 = drawScope.toPx-0680j_4(SliderKt.getTrackHeight());
                                long j3 = j2;
                                long j4 = j;
                                DrawScope.CC.m5172drawLineNGM6Ib0$default(drawScope, jM2805trackColorWaAFU9c$material3_release, j, j2, f2, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                                DrawScope.CC.m5172drawLineNGM6Ib0$default(drawScope, jM2805trackColorWaAFU9c$material3_release2, OffsetKt.Offset(Offset.m4346getXimpl(j4) + ((Offset.m4346getXimpl(j3) - Offset.m4346getXimpl(j4)) * ((Number) sliderPositions.getActiveRange().getStart()).floatValue()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0())), OffsetKt.Offset(Offset.m4346getXimpl(j4) + ((Offset.m4346getXimpl(j3) - Offset.m4346getXimpl(j4)) * ((Number) sliderPositions.getActiveRange().getEndInclusive()).floatValue()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0())), f2, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                                float[] tickFractions = sliderPositions.getTickFractions();
                                SliderPositions sliderPositions2 = sliderPositions;
                                LinkedHashMap linkedHashMap = new LinkedHashMap();
                                int length = tickFractions.length;
                                for (int i10 = 0; i10 < length; i10++) {
                                    float f3 = tickFractions[i10];
                                    Boolean boolValueOf = Boolean.valueOf(f3 > ((Number) sliderPositions2.getActiveRange().getEndInclusive()).floatValue() || f3 < ((Number) sliderPositions2.getActiveRange().getStart()).floatValue());
                                    Object obj = linkedHashMap.get(boolValueOf);
                                    if (obj == null) {
                                        obj = (List) new ArrayList();
                                        linkedHashMap.put(boolValueOf, obj);
                                    }
                                    ((List) obj).add(Float.valueOf(f3));
                                }
                                long j5 = jM2804tickColorWaAFU9c$material3_release;
                                long j6 = jM2804tickColorWaAFU9c$material3_release2;
                                for (Map.Entry entry : linkedHashMap.entrySet()) {
                                    boolean zBooleanValue = ((Boolean) entry.getKey()).booleanValue();
                                    List list = (List) entry.getValue();
                                    ArrayList arrayList = new ArrayList(list.size());
                                    int size = list.size();
                                    for (int i11 = 0; i11 < size; i11++) {
                                        arrayList.add(Offset.m4335boximpl(OffsetKt.Offset(Offset.m4346getXimpl(OffsetKt.m4369lerpWko1d7g(j4, j3, ((Number) list.get(i11)).floatValue())), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()))));
                                    }
                                    long j7 = j4;
                                    j3 = j3;
                                    DrawScope.CC.m5177drawPointsF8ZwMP8$default(drawScope, arrayList, PointMode.INSTANCE.m4904getPointsr_lszbg(), zBooleanValue ? j5 : j6, f, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                                    j6 = j6;
                                    j4 = j7;
                                }
                            }
                        };
                        composer2.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composer2);
                    CanvasKt.Canvas(modifierM1066height3ABfNKs2, (Function1) objRememberedValue, composer2, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    sliderColors3 = sliderColors5;
                    modifier3 = companion;
                    z5 = z3;
                } else {
                    composerStartRestartGroup.skipToGroupEnd();
                    composer2 = composerStartRestartGroup;
                    modifier3 = modifier2;
                    sliderColors3 = sliderColors2;
                    z5 = z2;
                }
                scopeUpdateScopeEndRestartGroup = composer2.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer3, int i10) {
                            SliderDefaults.this.Track(sliderPositions, modifier3, sliderColors3, z5, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            z2 = z;
            if ((i2 & 16) != 0) {
                i3 |= 24576;
            } else if ((i & 24576) == 0) {
                if (composerStartRestartGroup.changed(this)) {
                    i6 = Fields.Clip;
                } else {
                    i6 = Fields.Shape;
                }
                i3 |= i6;
            }
            if ((i3 & 9363) == 9362) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 4) != 0) {
                        SliderColors sliderColorsColors2 = colors(composerStartRestartGroup, (i3 >> 12) & 14);
                        i3 &= -897;
                        sliderColors2 = sliderColorsColors2;
                    }
                    if (i4 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                } else {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 4) != 0) {
                        SliderColors sliderColorsColors3 = colors(composerStartRestartGroup, (i3 >> 12) & 14);
                        i3 &= -897;
                        sliderColors2 = sliderColorsColors3;
                    }
                    if (i4 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                }
                SliderColors sliderColors6 = sliderColors2;
                i7 = i3;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1546713545, i7, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:999)");
                }
                jM2805trackColorWaAFU9c$material3_release = sliderColors6.m2805trackColorWaAFU9c$material3_release(z3, false);
                jM2805trackColorWaAFU9c$material3_release2 = sliderColors6.m2805trackColorWaAFU9c$material3_release(z3, true);
                jM2804tickColorWaAFU9c$material3_release = sliderColors6.m2804tickColorWaAFU9c$material3_release(z3, false);
                jM2804tickColorWaAFU9c$material3_release2 = sliderColors6.m2804tickColorWaAFU9c$material3_release(z3, true);
                Modifier modifierM1066height3ABfNKs3 = SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), SliderKt.getTrackHeight());
                composer2 = composerStartRestartGroup;
                ComposerKt.sourceInformationMarkerStart(composer2, -801023075, "CC(remember):Slider.kt#9igjgp");
                boolean zChanged4 = composer2.changed(jM2805trackColorWaAFU9c$material3_release);
                if ((i7 & 14) == 4) {
                    z4 = true;
                } else {
                    z4 = false;
                }
                zChanged = zChanged4 | z4 | composer2.changed(jM2805trackColorWaAFU9c$material3_release2) | composer2.changed(jM2804tickColorWaAFU9c$material3_release) | composer2.changed(jM2804tickColorWaAFU9c$material3_release2);
                objRememberedValue = composer2.rememberedValue();
                if (!zChanged) {
                    objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            boolean z6 = drawScope.getLayoutDirection() == LayoutDirection.Rtl;
                            long jOffset = OffsetKt.Offset(0.0f, Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()));
                            long jOffset2 = OffsetKt.Offset(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()));
                            long j = z6 ? jOffset2 : jOffset;
                            long j2 = z6 ? jOffset : jOffset2;
                            float f = drawScope.toPx-0680j_4(SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM());
                            float f2 = drawScope.toPx-0680j_4(SliderKt.getTrackHeight());
                            long j3 = j2;
                            long j4 = j;
                            DrawScope.CC.m5172drawLineNGM6Ib0$default(drawScope, jM2805trackColorWaAFU9c$material3_release, j, j2, f2, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                            DrawScope.CC.m5172drawLineNGM6Ib0$default(drawScope, jM2805trackColorWaAFU9c$material3_release2, OffsetKt.Offset(Offset.m4346getXimpl(j4) + ((Offset.m4346getXimpl(j3) - Offset.m4346getXimpl(j4)) * ((Number) sliderPositions.getActiveRange().getStart()).floatValue()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0())), OffsetKt.Offset(Offset.m4346getXimpl(j4) + ((Offset.m4346getXimpl(j3) - Offset.m4346getXimpl(j4)) * ((Number) sliderPositions.getActiveRange().getEndInclusive()).floatValue()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0())), f2, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                            float[] tickFractions = sliderPositions.getTickFractions();
                            SliderPositions sliderPositions2 = sliderPositions;
                            LinkedHashMap linkedHashMap = new LinkedHashMap();
                            int length = tickFractions.length;
                            for (int i10 = 0; i10 < length; i10++) {
                                float f3 = tickFractions[i10];
                                Boolean boolValueOf = Boolean.valueOf(f3 > ((Number) sliderPositions2.getActiveRange().getEndInclusive()).floatValue() || f3 < ((Number) sliderPositions2.getActiveRange().getStart()).floatValue());
                                Object obj = linkedHashMap.get(boolValueOf);
                                if (obj == null) {
                                    obj = (List) new ArrayList();
                                    linkedHashMap.put(boolValueOf, obj);
                                }
                                ((List) obj).add(Float.valueOf(f3));
                            }
                            long j5 = jM2804tickColorWaAFU9c$material3_release;
                            long j6 = jM2804tickColorWaAFU9c$material3_release2;
                            for (Map.Entry entry : linkedHashMap.entrySet()) {
                                boolean zBooleanValue = ((Boolean) entry.getKey()).booleanValue();
                                List list = (List) entry.getValue();
                                ArrayList arrayList = new ArrayList(list.size());
                                int size = list.size();
                                for (int i11 = 0; i11 < size; i11++) {
                                    arrayList.add(Offset.m4335boximpl(OffsetKt.Offset(Offset.m4346getXimpl(OffsetKt.m4369lerpWko1d7g(j4, j3, ((Number) list.get(i11)).floatValue())), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()))));
                                }
                                long j7 = j4;
                                j3 = j3;
                                DrawScope.CC.m5177drawPointsF8ZwMP8$default(drawScope, arrayList, PointMode.INSTANCE.m4904getPointsr_lszbg(), zBooleanValue ? j5 : j6, f, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                                j6 = j6;
                                j4 = j7;
                            }
                        }
                    };
                    composer2.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            boolean z6 = drawScope.getLayoutDirection() == LayoutDirection.Rtl;
                            long jOffset = OffsetKt.Offset(0.0f, Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()));
                            long jOffset2 = OffsetKt.Offset(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()));
                            long j = z6 ? jOffset2 : jOffset;
                            long j2 = z6 ? jOffset : jOffset2;
                            float f = drawScope.toPx-0680j_4(SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM());
                            float f2 = drawScope.toPx-0680j_4(SliderKt.getTrackHeight());
                            long j3 = j2;
                            long j4 = j;
                            DrawScope.CC.m5172drawLineNGM6Ib0$default(drawScope, jM2805trackColorWaAFU9c$material3_release, j, j2, f2, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                            DrawScope.CC.m5172drawLineNGM6Ib0$default(drawScope, jM2805trackColorWaAFU9c$material3_release2, OffsetKt.Offset(Offset.m4346getXimpl(j4) + ((Offset.m4346getXimpl(j3) - Offset.m4346getXimpl(j4)) * ((Number) sliderPositions.getActiveRange().getStart()).floatValue()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0())), OffsetKt.Offset(Offset.m4346getXimpl(j4) + ((Offset.m4346getXimpl(j3) - Offset.m4346getXimpl(j4)) * ((Number) sliderPositions.getActiveRange().getEndInclusive()).floatValue()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0())), f2, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                            float[] tickFractions = sliderPositions.getTickFractions();
                            SliderPositions sliderPositions2 = sliderPositions;
                            LinkedHashMap linkedHashMap = new LinkedHashMap();
                            int length = tickFractions.length;
                            for (int i10 = 0; i10 < length; i10++) {
                                float f3 = tickFractions[i10];
                                Boolean boolValueOf = Boolean.valueOf(f3 > ((Number) sliderPositions2.getActiveRange().getEndInclusive()).floatValue() || f3 < ((Number) sliderPositions2.getActiveRange().getStart()).floatValue());
                                Object obj = linkedHashMap.get(boolValueOf);
                                if (obj == null) {
                                    obj = (List) new ArrayList();
                                    linkedHashMap.put(boolValueOf, obj);
                                }
                                ((List) obj).add(Float.valueOf(f3));
                            }
                            long j5 = jM2804tickColorWaAFU9c$material3_release;
                            long j6 = jM2804tickColorWaAFU9c$material3_release2;
                            for (Map.Entry entry : linkedHashMap.entrySet()) {
                                boolean zBooleanValue = ((Boolean) entry.getKey()).booleanValue();
                                List list = (List) entry.getValue();
                                ArrayList arrayList = new ArrayList(list.size());
                                int size = list.size();
                                for (int i11 = 0; i11 < size; i11++) {
                                    arrayList.add(Offset.m4335boximpl(OffsetKt.Offset(Offset.m4346getXimpl(OffsetKt.m4369lerpWko1d7g(j4, j3, ((Number) list.get(i11)).floatValue())), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()))));
                                }
                                long j7 = j4;
                                j3 = j3;
                                DrawScope.CC.m5177drawPointsF8ZwMP8$default(drawScope, arrayList, PointMode.INSTANCE.m4904getPointsr_lszbg(), zBooleanValue ? j5 : j6, f, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                                j6 = j6;
                                j4 = j7;
                            }
                        }
                    };
                    composer2.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composer2);
                CanvasKt.Canvas(modifierM1066height3ABfNKs3, (Function1) objRememberedValue, composer2, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                sliderColors3 = sliderColors6;
                modifier3 = companion;
                z5 = z3;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 4) != 0) {
                        SliderColors sliderColorsColors4 = colors(composerStartRestartGroup, (i3 >> 12) & 14);
                        i3 &= -897;
                        sliderColors2 = sliderColorsColors4;
                    }
                    if (i4 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                } else {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 4) != 0) {
                        SliderColors sliderColorsColors5 = colors(composerStartRestartGroup, (i3 >> 12) & 14);
                        i3 &= -897;
                        sliderColors2 = sliderColorsColors5;
                    }
                    if (i4 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                }
                SliderColors sliderColors7 = sliderColors2;
                i7 = i3;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1546713545, i7, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:999)");
                }
                jM2805trackColorWaAFU9c$material3_release = sliderColors7.m2805trackColorWaAFU9c$material3_release(z3, false);
                jM2805trackColorWaAFU9c$material3_release2 = sliderColors7.m2805trackColorWaAFU9c$material3_release(z3, true);
                jM2804tickColorWaAFU9c$material3_release = sliderColors7.m2804tickColorWaAFU9c$material3_release(z3, false);
                jM2804tickColorWaAFU9c$material3_release2 = sliderColors7.m2804tickColorWaAFU9c$material3_release(z3, true);
                Modifier modifierM1066height3ABfNKs4 = SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), SliderKt.getTrackHeight());
                composer2 = composerStartRestartGroup;
                ComposerKt.sourceInformationMarkerStart(composer2, -801023075, "CC(remember):Slider.kt#9igjgp");
                boolean zChanged5 = composer2.changed(jM2805trackColorWaAFU9c$material3_release);
                if ((i7 & 14) == 4) {
                    z4 = true;
                } else {
                    z4 = false;
                }
                zChanged = zChanged5 | z4 | composer2.changed(jM2805trackColorWaAFU9c$material3_release2) | composer2.changed(jM2804tickColorWaAFU9c$material3_release) | composer2.changed(jM2804tickColorWaAFU9c$material3_release2);
                objRememberedValue = composer2.rememberedValue();
                if (!zChanged) {
                    objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            boolean z6 = drawScope.getLayoutDirection() == LayoutDirection.Rtl;
                            long jOffset = OffsetKt.Offset(0.0f, Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()));
                            long jOffset2 = OffsetKt.Offset(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()));
                            long j = z6 ? jOffset2 : jOffset;
                            long j2 = z6 ? jOffset : jOffset2;
                            float f = drawScope.toPx-0680j_4(SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM());
                            float f2 = drawScope.toPx-0680j_4(SliderKt.getTrackHeight());
                            long j3 = j2;
                            long j4 = j;
                            DrawScope.CC.m5172drawLineNGM6Ib0$default(drawScope, jM2805trackColorWaAFU9c$material3_release, j, j2, f2, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                            DrawScope.CC.m5172drawLineNGM6Ib0$default(drawScope, jM2805trackColorWaAFU9c$material3_release2, OffsetKt.Offset(Offset.m4346getXimpl(j4) + ((Offset.m4346getXimpl(j3) - Offset.m4346getXimpl(j4)) * ((Number) sliderPositions.getActiveRange().getStart()).floatValue()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0())), OffsetKt.Offset(Offset.m4346getXimpl(j4) + ((Offset.m4346getXimpl(j3) - Offset.m4346getXimpl(j4)) * ((Number) sliderPositions.getActiveRange().getEndInclusive()).floatValue()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0())), f2, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                            float[] tickFractions = sliderPositions.getTickFractions();
                            SliderPositions sliderPositions2 = sliderPositions;
                            LinkedHashMap linkedHashMap = new LinkedHashMap();
                            int length = tickFractions.length;
                            for (int i10 = 0; i10 < length; i10++) {
                                float f3 = tickFractions[i10];
                                Boolean boolValueOf = Boolean.valueOf(f3 > ((Number) sliderPositions2.getActiveRange().getEndInclusive()).floatValue() || f3 < ((Number) sliderPositions2.getActiveRange().getStart()).floatValue());
                                Object obj = linkedHashMap.get(boolValueOf);
                                if (obj == null) {
                                    obj = (List) new ArrayList();
                                    linkedHashMap.put(boolValueOf, obj);
                                }
                                ((List) obj).add(Float.valueOf(f3));
                            }
                            long j5 = jM2804tickColorWaAFU9c$material3_release;
                            long j6 = jM2804tickColorWaAFU9c$material3_release2;
                            for (Map.Entry entry : linkedHashMap.entrySet()) {
                                boolean zBooleanValue = ((Boolean) entry.getKey()).booleanValue();
                                List list = (List) entry.getValue();
                                ArrayList arrayList = new ArrayList(list.size());
                                int size = list.size();
                                for (int i11 = 0; i11 < size; i11++) {
                                    arrayList.add(Offset.m4335boximpl(OffsetKt.Offset(Offset.m4346getXimpl(OffsetKt.m4369lerpWko1d7g(j4, j3, ((Number) list.get(i11)).floatValue())), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()))));
                                }
                                long j7 = j4;
                                j3 = j3;
                                DrawScope.CC.m5177drawPointsF8ZwMP8$default(drawScope, arrayList, PointMode.INSTANCE.m4904getPointsr_lszbg(), zBooleanValue ? j5 : j6, f, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                                j6 = j6;
                                j4 = j7;
                            }
                        }
                    };
                    composer2.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            boolean z6 = drawScope.getLayoutDirection() == LayoutDirection.Rtl;
                            long jOffset = OffsetKt.Offset(0.0f, Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()));
                            long jOffset2 = OffsetKt.Offset(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()));
                            long j = z6 ? jOffset2 : jOffset;
                            long j2 = z6 ? jOffset : jOffset2;
                            float f = drawScope.toPx-0680j_4(SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM());
                            float f2 = drawScope.toPx-0680j_4(SliderKt.getTrackHeight());
                            long j3 = j2;
                            long j4 = j;
                            DrawScope.CC.m5172drawLineNGM6Ib0$default(drawScope, jM2805trackColorWaAFU9c$material3_release, j, j2, f2, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                            DrawScope.CC.m5172drawLineNGM6Ib0$default(drawScope, jM2805trackColorWaAFU9c$material3_release2, OffsetKt.Offset(Offset.m4346getXimpl(j4) + ((Offset.m4346getXimpl(j3) - Offset.m4346getXimpl(j4)) * ((Number) sliderPositions.getActiveRange().getStart()).floatValue()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0())), OffsetKt.Offset(Offset.m4346getXimpl(j4) + ((Offset.m4346getXimpl(j3) - Offset.m4346getXimpl(j4)) * ((Number) sliderPositions.getActiveRange().getEndInclusive()).floatValue()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0())), f2, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                            float[] tickFractions = sliderPositions.getTickFractions();
                            SliderPositions sliderPositions2 = sliderPositions;
                            LinkedHashMap linkedHashMap = new LinkedHashMap();
                            int length = tickFractions.length;
                            for (int i10 = 0; i10 < length; i10++) {
                                float f3 = tickFractions[i10];
                                Boolean boolValueOf = Boolean.valueOf(f3 > ((Number) sliderPositions2.getActiveRange().getEndInclusive()).floatValue() || f3 < ((Number) sliderPositions2.getActiveRange().getStart()).floatValue());
                                Object obj = linkedHashMap.get(boolValueOf);
                                if (obj == null) {
                                    obj = (List) new ArrayList();
                                    linkedHashMap.put(boolValueOf, obj);
                                }
                                ((List) obj).add(Float.valueOf(f3));
                            }
                            long j5 = jM2804tickColorWaAFU9c$material3_release;
                            long j6 = jM2804tickColorWaAFU9c$material3_release2;
                            for (Map.Entry entry : linkedHashMap.entrySet()) {
                                boolean zBooleanValue = ((Boolean) entry.getKey()).booleanValue();
                                List list = (List) entry.getValue();
                                ArrayList arrayList = new ArrayList(list.size());
                                int size = list.size();
                                for (int i11 = 0; i11 < size; i11++) {
                                    arrayList.add(Offset.m4335boximpl(OffsetKt.Offset(Offset.m4346getXimpl(OffsetKt.m4369lerpWko1d7g(j4, j3, ((Number) list.get(i11)).floatValue())), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()))));
                                }
                                long j7 = j4;
                                j3 = j3;
                                DrawScope.CC.m5177drawPointsF8ZwMP8$default(drawScope, arrayList, PointMode.INSTANCE.m4904getPointsr_lszbg(), zBooleanValue ? j5 : j6, f, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                                j6 = j6;
                                j4 = j7;
                            }
                        }
                    };
                    composer2.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composer2);
                CanvasKt.Canvas(modifierM1066height3ABfNKs4, (Function1) objRememberedValue, composer2, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                sliderColors3 = sliderColors7;
                modifier3 = companion;
                z5 = z3;
            }
            scopeUpdateScopeEndRestartGroup = composer2.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer3, int i10) {
                        SliderDefaults.this.Track(sliderPositions, modifier3, sliderColors3, z5, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        modifier2 = modifier;
        if ((i & 384) == 0) {
            if ((i2 & 4) == 0) {
                sliderColors2 = sliderColors;
                if (composerStartRestartGroup.changed(sliderColors2)) {
                    i8 = Fields.RotationX;
                }
                i3 |= i8;
            } else {
                sliderColors2 = sliderColors;
            }
            i8 = Fields.SpotShadowColor;
            i3 |= i8;
        } else {
            sliderColors2 = sliderColors;
        }
        i4 = i2 & 8;
        if (i4 != 0) {
            if ((i & 3072) == 0) {
                z2 = z;
                if (composerStartRestartGroup.changed(z2)) {
                    i5 = Fields.CameraDistance;
                } else {
                    i5 = Fields.RotationZ;
                }
                i3 |= i5;
            }
            if ((i2 & 16) != 0) {
                i3 |= 24576;
            } else if ((i & 24576) == 0) {
                if (composerStartRestartGroup.changed(this)) {
                    i6 = Fields.Clip;
                } else {
                    i6 = Fields.Shape;
                }
                i3 |= i6;
            }
            if ((i3 & 9363) == 9362) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 4) != 0) {
                        SliderColors sliderColorsColors6 = colors(composerStartRestartGroup, (i3 >> 12) & 14);
                        i3 &= -897;
                        sliderColors2 = sliderColorsColors6;
                    }
                    if (i4 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                } else {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 4) != 0) {
                        SliderColors sliderColorsColors7 = colors(composerStartRestartGroup, (i3 >> 12) & 14);
                        i3 &= -897;
                        sliderColors2 = sliderColorsColors7;
                    }
                    if (i4 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                }
                SliderColors sliderColors8 = sliderColors2;
                i7 = i3;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1546713545, i7, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:999)");
                }
                jM2805trackColorWaAFU9c$material3_release = sliderColors8.m2805trackColorWaAFU9c$material3_release(z3, false);
                jM2805trackColorWaAFU9c$material3_release2 = sliderColors8.m2805trackColorWaAFU9c$material3_release(z3, true);
                jM2804tickColorWaAFU9c$material3_release = sliderColors8.m2804tickColorWaAFU9c$material3_release(z3, false);
                jM2804tickColorWaAFU9c$material3_release2 = sliderColors8.m2804tickColorWaAFU9c$material3_release(z3, true);
                Modifier modifierM1066height3ABfNKs5 = SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), SliderKt.getTrackHeight());
                composer2 = composerStartRestartGroup;
                ComposerKt.sourceInformationMarkerStart(composer2, -801023075, "CC(remember):Slider.kt#9igjgp");
                boolean zChanged6 = composer2.changed(jM2805trackColorWaAFU9c$material3_release);
                if ((i7 & 14) == 4) {
                    z4 = true;
                } else {
                    z4 = false;
                }
                zChanged = zChanged6 | z4 | composer2.changed(jM2805trackColorWaAFU9c$material3_release2) | composer2.changed(jM2804tickColorWaAFU9c$material3_release) | composer2.changed(jM2804tickColorWaAFU9c$material3_release2);
                objRememberedValue = composer2.rememberedValue();
                if (!zChanged) {
                    objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            boolean z6 = drawScope.getLayoutDirection() == LayoutDirection.Rtl;
                            long jOffset = OffsetKt.Offset(0.0f, Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()));
                            long jOffset2 = OffsetKt.Offset(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()));
                            long j = z6 ? jOffset2 : jOffset;
                            long j2 = z6 ? jOffset : jOffset2;
                            float f = drawScope.toPx-0680j_4(SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM());
                            float f2 = drawScope.toPx-0680j_4(SliderKt.getTrackHeight());
                            long j3 = j2;
                            long j4 = j;
                            DrawScope.CC.m5172drawLineNGM6Ib0$default(drawScope, jM2805trackColorWaAFU9c$material3_release, j, j2, f2, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                            DrawScope.CC.m5172drawLineNGM6Ib0$default(drawScope, jM2805trackColorWaAFU9c$material3_release2, OffsetKt.Offset(Offset.m4346getXimpl(j4) + ((Offset.m4346getXimpl(j3) - Offset.m4346getXimpl(j4)) * ((Number) sliderPositions.getActiveRange().getStart()).floatValue()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0())), OffsetKt.Offset(Offset.m4346getXimpl(j4) + ((Offset.m4346getXimpl(j3) - Offset.m4346getXimpl(j4)) * ((Number) sliderPositions.getActiveRange().getEndInclusive()).floatValue()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0())), f2, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                            float[] tickFractions = sliderPositions.getTickFractions();
                            SliderPositions sliderPositions2 = sliderPositions;
                            LinkedHashMap linkedHashMap = new LinkedHashMap();
                            int length = tickFractions.length;
                            for (int i10 = 0; i10 < length; i10++) {
                                float f3 = tickFractions[i10];
                                Boolean boolValueOf = Boolean.valueOf(f3 > ((Number) sliderPositions2.getActiveRange().getEndInclusive()).floatValue() || f3 < ((Number) sliderPositions2.getActiveRange().getStart()).floatValue());
                                Object obj = linkedHashMap.get(boolValueOf);
                                if (obj == null) {
                                    obj = (List) new ArrayList();
                                    linkedHashMap.put(boolValueOf, obj);
                                }
                                ((List) obj).add(Float.valueOf(f3));
                            }
                            long j5 = jM2804tickColorWaAFU9c$material3_release;
                            long j6 = jM2804tickColorWaAFU9c$material3_release2;
                            for (Map.Entry entry : linkedHashMap.entrySet()) {
                                boolean zBooleanValue = ((Boolean) entry.getKey()).booleanValue();
                                List list = (List) entry.getValue();
                                ArrayList arrayList = new ArrayList(list.size());
                                int size = list.size();
                                for (int i11 = 0; i11 < size; i11++) {
                                    arrayList.add(Offset.m4335boximpl(OffsetKt.Offset(Offset.m4346getXimpl(OffsetKt.m4369lerpWko1d7g(j4, j3, ((Number) list.get(i11)).floatValue())), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()))));
                                }
                                long j7 = j4;
                                j3 = j3;
                                DrawScope.CC.m5177drawPointsF8ZwMP8$default(drawScope, arrayList, PointMode.INSTANCE.m4904getPointsr_lszbg(), zBooleanValue ? j5 : j6, f, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                                j6 = j6;
                                j4 = j7;
                            }
                        }
                    };
                    composer2.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            boolean z6 = drawScope.getLayoutDirection() == LayoutDirection.Rtl;
                            long jOffset = OffsetKt.Offset(0.0f, Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()));
                            long jOffset2 = OffsetKt.Offset(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()));
                            long j = z6 ? jOffset2 : jOffset;
                            long j2 = z6 ? jOffset : jOffset2;
                            float f = drawScope.toPx-0680j_4(SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM());
                            float f2 = drawScope.toPx-0680j_4(SliderKt.getTrackHeight());
                            long j3 = j2;
                            long j4 = j;
                            DrawScope.CC.m5172drawLineNGM6Ib0$default(drawScope, jM2805trackColorWaAFU9c$material3_release, j, j2, f2, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                            DrawScope.CC.m5172drawLineNGM6Ib0$default(drawScope, jM2805trackColorWaAFU9c$material3_release2, OffsetKt.Offset(Offset.m4346getXimpl(j4) + ((Offset.m4346getXimpl(j3) - Offset.m4346getXimpl(j4)) * ((Number) sliderPositions.getActiveRange().getStart()).floatValue()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0())), OffsetKt.Offset(Offset.m4346getXimpl(j4) + ((Offset.m4346getXimpl(j3) - Offset.m4346getXimpl(j4)) * ((Number) sliderPositions.getActiveRange().getEndInclusive()).floatValue()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0())), f2, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                            float[] tickFractions = sliderPositions.getTickFractions();
                            SliderPositions sliderPositions2 = sliderPositions;
                            LinkedHashMap linkedHashMap = new LinkedHashMap();
                            int length = tickFractions.length;
                            for (int i10 = 0; i10 < length; i10++) {
                                float f3 = tickFractions[i10];
                                Boolean boolValueOf = Boolean.valueOf(f3 > ((Number) sliderPositions2.getActiveRange().getEndInclusive()).floatValue() || f3 < ((Number) sliderPositions2.getActiveRange().getStart()).floatValue());
                                Object obj = linkedHashMap.get(boolValueOf);
                                if (obj == null) {
                                    obj = (List) new ArrayList();
                                    linkedHashMap.put(boolValueOf, obj);
                                }
                                ((List) obj).add(Float.valueOf(f3));
                            }
                            long j5 = jM2804tickColorWaAFU9c$material3_release;
                            long j6 = jM2804tickColorWaAFU9c$material3_release2;
                            for (Map.Entry entry : linkedHashMap.entrySet()) {
                                boolean zBooleanValue = ((Boolean) entry.getKey()).booleanValue();
                                List list = (List) entry.getValue();
                                ArrayList arrayList = new ArrayList(list.size());
                                int size = list.size();
                                for (int i11 = 0; i11 < size; i11++) {
                                    arrayList.add(Offset.m4335boximpl(OffsetKt.Offset(Offset.m4346getXimpl(OffsetKt.m4369lerpWko1d7g(j4, j3, ((Number) list.get(i11)).floatValue())), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()))));
                                }
                                long j7 = j4;
                                j3 = j3;
                                DrawScope.CC.m5177drawPointsF8ZwMP8$default(drawScope, arrayList, PointMode.INSTANCE.m4904getPointsr_lszbg(), zBooleanValue ? j5 : j6, f, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                                j6 = j6;
                                j4 = j7;
                            }
                        }
                    };
                    composer2.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composer2);
                CanvasKt.Canvas(modifierM1066height3ABfNKs5, (Function1) objRememberedValue, composer2, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                sliderColors3 = sliderColors8;
                modifier3 = companion;
                z5 = z3;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 4) != 0) {
                        SliderColors sliderColorsColors8 = colors(composerStartRestartGroup, (i3 >> 12) & 14);
                        i3 &= -897;
                        sliderColors2 = sliderColorsColors8;
                    }
                    if (i4 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                } else {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 4) != 0) {
                        SliderColors sliderColorsColors9 = colors(composerStartRestartGroup, (i3 >> 12) & 14);
                        i3 &= -897;
                        sliderColors2 = sliderColorsColors9;
                    }
                    if (i4 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                }
                SliderColors sliderColors9 = sliderColors2;
                i7 = i3;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1546713545, i7, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:999)");
                }
                jM2805trackColorWaAFU9c$material3_release = sliderColors9.m2805trackColorWaAFU9c$material3_release(z3, false);
                jM2805trackColorWaAFU9c$material3_release2 = sliderColors9.m2805trackColorWaAFU9c$material3_release(z3, true);
                jM2804tickColorWaAFU9c$material3_release = sliderColors9.m2804tickColorWaAFU9c$material3_release(z3, false);
                jM2804tickColorWaAFU9c$material3_release2 = sliderColors9.m2804tickColorWaAFU9c$material3_release(z3, true);
                Modifier modifierM1066height3ABfNKs6 = SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), SliderKt.getTrackHeight());
                composer2 = composerStartRestartGroup;
                ComposerKt.sourceInformationMarkerStart(composer2, -801023075, "CC(remember):Slider.kt#9igjgp");
                boolean zChanged7 = composer2.changed(jM2805trackColorWaAFU9c$material3_release);
                if ((i7 & 14) == 4) {
                    z4 = true;
                } else {
                    z4 = false;
                }
                zChanged = zChanged7 | z4 | composer2.changed(jM2805trackColorWaAFU9c$material3_release2) | composer2.changed(jM2804tickColorWaAFU9c$material3_release) | composer2.changed(jM2804tickColorWaAFU9c$material3_release2);
                objRememberedValue = composer2.rememberedValue();
                if (!zChanged) {
                    objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            boolean z6 = drawScope.getLayoutDirection() == LayoutDirection.Rtl;
                            long jOffset = OffsetKt.Offset(0.0f, Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()));
                            long jOffset2 = OffsetKt.Offset(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()));
                            long j = z6 ? jOffset2 : jOffset;
                            long j2 = z6 ? jOffset : jOffset2;
                            float f = drawScope.toPx-0680j_4(SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM());
                            float f2 = drawScope.toPx-0680j_4(SliderKt.getTrackHeight());
                            long j3 = j2;
                            long j4 = j;
                            DrawScope.CC.m5172drawLineNGM6Ib0$default(drawScope, jM2805trackColorWaAFU9c$material3_release, j, j2, f2, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                            DrawScope.CC.m5172drawLineNGM6Ib0$default(drawScope, jM2805trackColorWaAFU9c$material3_release2, OffsetKt.Offset(Offset.m4346getXimpl(j4) + ((Offset.m4346getXimpl(j3) - Offset.m4346getXimpl(j4)) * ((Number) sliderPositions.getActiveRange().getStart()).floatValue()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0())), OffsetKt.Offset(Offset.m4346getXimpl(j4) + ((Offset.m4346getXimpl(j3) - Offset.m4346getXimpl(j4)) * ((Number) sliderPositions.getActiveRange().getEndInclusive()).floatValue()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0())), f2, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                            float[] tickFractions = sliderPositions.getTickFractions();
                            SliderPositions sliderPositions2 = sliderPositions;
                            LinkedHashMap linkedHashMap = new LinkedHashMap();
                            int length = tickFractions.length;
                            for (int i10 = 0; i10 < length; i10++) {
                                float f3 = tickFractions[i10];
                                Boolean boolValueOf = Boolean.valueOf(f3 > ((Number) sliderPositions2.getActiveRange().getEndInclusive()).floatValue() || f3 < ((Number) sliderPositions2.getActiveRange().getStart()).floatValue());
                                Object obj = linkedHashMap.get(boolValueOf);
                                if (obj == null) {
                                    obj = (List) new ArrayList();
                                    linkedHashMap.put(boolValueOf, obj);
                                }
                                ((List) obj).add(Float.valueOf(f3));
                            }
                            long j5 = jM2804tickColorWaAFU9c$material3_release;
                            long j6 = jM2804tickColorWaAFU9c$material3_release2;
                            for (Map.Entry entry : linkedHashMap.entrySet()) {
                                boolean zBooleanValue = ((Boolean) entry.getKey()).booleanValue();
                                List list = (List) entry.getValue();
                                ArrayList arrayList = new ArrayList(list.size());
                                int size = list.size();
                                for (int i11 = 0; i11 < size; i11++) {
                                    arrayList.add(Offset.m4335boximpl(OffsetKt.Offset(Offset.m4346getXimpl(OffsetKt.m4369lerpWko1d7g(j4, j3, ((Number) list.get(i11)).floatValue())), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()))));
                                }
                                long j7 = j4;
                                j3 = j3;
                                DrawScope.CC.m5177drawPointsF8ZwMP8$default(drawScope, arrayList, PointMode.INSTANCE.m4904getPointsr_lszbg(), zBooleanValue ? j5 : j6, f, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                                j6 = j6;
                                j4 = j7;
                            }
                        }
                    };
                    composer2.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            boolean z6 = drawScope.getLayoutDirection() == LayoutDirection.Rtl;
                            long jOffset = OffsetKt.Offset(0.0f, Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()));
                            long jOffset2 = OffsetKt.Offset(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()));
                            long j = z6 ? jOffset2 : jOffset;
                            long j2 = z6 ? jOffset : jOffset2;
                            float f = drawScope.toPx-0680j_4(SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM());
                            float f2 = drawScope.toPx-0680j_4(SliderKt.getTrackHeight());
                            long j3 = j2;
                            long j4 = j;
                            DrawScope.CC.m5172drawLineNGM6Ib0$default(drawScope, jM2805trackColorWaAFU9c$material3_release, j, j2, f2, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                            DrawScope.CC.m5172drawLineNGM6Ib0$default(drawScope, jM2805trackColorWaAFU9c$material3_release2, OffsetKt.Offset(Offset.m4346getXimpl(j4) + ((Offset.m4346getXimpl(j3) - Offset.m4346getXimpl(j4)) * ((Number) sliderPositions.getActiveRange().getStart()).floatValue()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0())), OffsetKt.Offset(Offset.m4346getXimpl(j4) + ((Offset.m4346getXimpl(j3) - Offset.m4346getXimpl(j4)) * ((Number) sliderPositions.getActiveRange().getEndInclusive()).floatValue()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0())), f2, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                            float[] tickFractions = sliderPositions.getTickFractions();
                            SliderPositions sliderPositions2 = sliderPositions;
                            LinkedHashMap linkedHashMap = new LinkedHashMap();
                            int length = tickFractions.length;
                            for (int i10 = 0; i10 < length; i10++) {
                                float f3 = tickFractions[i10];
                                Boolean boolValueOf = Boolean.valueOf(f3 > ((Number) sliderPositions2.getActiveRange().getEndInclusive()).floatValue() || f3 < ((Number) sliderPositions2.getActiveRange().getStart()).floatValue());
                                Object obj = linkedHashMap.get(boolValueOf);
                                if (obj == null) {
                                    obj = (List) new ArrayList();
                                    linkedHashMap.put(boolValueOf, obj);
                                }
                                ((List) obj).add(Float.valueOf(f3));
                            }
                            long j5 = jM2804tickColorWaAFU9c$material3_release;
                            long j6 = jM2804tickColorWaAFU9c$material3_release2;
                            for (Map.Entry entry : linkedHashMap.entrySet()) {
                                boolean zBooleanValue = ((Boolean) entry.getKey()).booleanValue();
                                List list = (List) entry.getValue();
                                ArrayList arrayList = new ArrayList(list.size());
                                int size = list.size();
                                for (int i11 = 0; i11 < size; i11++) {
                                    arrayList.add(Offset.m4335boximpl(OffsetKt.Offset(Offset.m4346getXimpl(OffsetKt.m4369lerpWko1d7g(j4, j3, ((Number) list.get(i11)).floatValue())), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()))));
                                }
                                long j7 = j4;
                                j3 = j3;
                                DrawScope.CC.m5177drawPointsF8ZwMP8$default(drawScope, arrayList, PointMode.INSTANCE.m4904getPointsr_lszbg(), zBooleanValue ? j5 : j6, f, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                                j6 = j6;
                                j4 = j7;
                            }
                        }
                    };
                    composer2.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composer2);
                CanvasKt.Canvas(modifierM1066height3ABfNKs6, (Function1) objRememberedValue, composer2, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                sliderColors3 = sliderColors9;
                modifier3 = companion;
                z5 = z3;
            }
            scopeUpdateScopeEndRestartGroup = composer2.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer3, int i10) {
                        SliderDefaults.this.Track(sliderPositions, modifier3, sliderColors3, z5, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 3072;
        z2 = z;
        if ((i2 & 16) != 0) {
            i3 |= 24576;
        } else if ((i & 24576) == 0) {
            if (composerStartRestartGroup.changed(this)) {
                i6 = Fields.Clip;
            } else {
                i6 = Fields.Shape;
            }
            i3 |= i6;
        }
        if ((i3 & 9363) == 9362) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i9 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 4) != 0) {
                    SliderColors sliderColorsColors10 = colors(composerStartRestartGroup, (i3 >> 12) & 14);
                    i3 &= -897;
                    sliderColors2 = sliderColorsColors10;
                }
                if (i4 != 0) {
                    z3 = true;
                } else {
                    z3 = z2;
                }
            } else {
                if (i9 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 4) != 0) {
                    SliderColors sliderColorsColors11 = colors(composerStartRestartGroup, (i3 >> 12) & 14);
                    i3 &= -897;
                    sliderColors2 = sliderColorsColors11;
                }
                if (i4 != 0) {
                    z3 = true;
                } else {
                    z3 = z2;
                }
            }
            SliderColors sliderColors10 = sliderColors2;
            i7 = i3;
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1546713545, i7, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:999)");
            }
            jM2805trackColorWaAFU9c$material3_release = sliderColors10.m2805trackColorWaAFU9c$material3_release(z3, false);
            jM2805trackColorWaAFU9c$material3_release2 = sliderColors10.m2805trackColorWaAFU9c$material3_release(z3, true);
            jM2804tickColorWaAFU9c$material3_release = sliderColors10.m2804tickColorWaAFU9c$material3_release(z3, false);
            jM2804tickColorWaAFU9c$material3_release2 = sliderColors10.m2804tickColorWaAFU9c$material3_release(z3, true);
            Modifier modifierM1066height3ABfNKs7 = SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), SliderKt.getTrackHeight());
            composer2 = composerStartRestartGroup;
            ComposerKt.sourceInformationMarkerStart(composer2, -801023075, "CC(remember):Slider.kt#9igjgp");
            boolean zChanged8 = composer2.changed(jM2805trackColorWaAFU9c$material3_release);
            if ((i7 & 14) == 4) {
                z4 = true;
            } else {
                z4 = false;
            }
            zChanged = zChanged8 | z4 | composer2.changed(jM2805trackColorWaAFU9c$material3_release2) | composer2.changed(jM2804tickColorWaAFU9c$material3_release) | composer2.changed(jM2804tickColorWaAFU9c$material3_release2);
            objRememberedValue = composer2.rememberedValue();
            if (!zChanged) {
                objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((DrawScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(DrawScope drawScope) {
                        boolean z6 = drawScope.getLayoutDirection() == LayoutDirection.Rtl;
                        long jOffset = OffsetKt.Offset(0.0f, Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()));
                        long jOffset2 = OffsetKt.Offset(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()));
                        long j = z6 ? jOffset2 : jOffset;
                        long j2 = z6 ? jOffset : jOffset2;
                        float f = drawScope.toPx-0680j_4(SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM());
                        float f2 = drawScope.toPx-0680j_4(SliderKt.getTrackHeight());
                        long j3 = j2;
                        long j4 = j;
                        DrawScope.CC.m5172drawLineNGM6Ib0$default(drawScope, jM2805trackColorWaAFU9c$material3_release, j, j2, f2, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                        DrawScope.CC.m5172drawLineNGM6Ib0$default(drawScope, jM2805trackColorWaAFU9c$material3_release2, OffsetKt.Offset(Offset.m4346getXimpl(j4) + ((Offset.m4346getXimpl(j3) - Offset.m4346getXimpl(j4)) * ((Number) sliderPositions.getActiveRange().getStart()).floatValue()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0())), OffsetKt.Offset(Offset.m4346getXimpl(j4) + ((Offset.m4346getXimpl(j3) - Offset.m4346getXimpl(j4)) * ((Number) sliderPositions.getActiveRange().getEndInclusive()).floatValue()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0())), f2, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                        float[] tickFractions = sliderPositions.getTickFractions();
                        SliderPositions sliderPositions2 = sliderPositions;
                        LinkedHashMap linkedHashMap = new LinkedHashMap();
                        int length = tickFractions.length;
                        for (int i10 = 0; i10 < length; i10++) {
                            float f3 = tickFractions[i10];
                            Boolean boolValueOf = Boolean.valueOf(f3 > ((Number) sliderPositions2.getActiveRange().getEndInclusive()).floatValue() || f3 < ((Number) sliderPositions2.getActiveRange().getStart()).floatValue());
                            Object obj = linkedHashMap.get(boolValueOf);
                            if (obj == null) {
                                obj = (List) new ArrayList();
                                linkedHashMap.put(boolValueOf, obj);
                            }
                            ((List) obj).add(Float.valueOf(f3));
                        }
                        long j5 = jM2804tickColorWaAFU9c$material3_release;
                        long j6 = jM2804tickColorWaAFU9c$material3_release2;
                        for (Map.Entry entry : linkedHashMap.entrySet()) {
                            boolean zBooleanValue = ((Boolean) entry.getKey()).booleanValue();
                            List list = (List) entry.getValue();
                            ArrayList arrayList = new ArrayList(list.size());
                            int size = list.size();
                            for (int i11 = 0; i11 < size; i11++) {
                                arrayList.add(Offset.m4335boximpl(OffsetKt.Offset(Offset.m4346getXimpl(OffsetKt.m4369lerpWko1d7g(j4, j3, ((Number) list.get(i11)).floatValue())), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()))));
                            }
                            long j7 = j4;
                            j3 = j3;
                            DrawScope.CC.m5177drawPointsF8ZwMP8$default(drawScope, arrayList, PointMode.INSTANCE.m4904getPointsr_lszbg(), zBooleanValue ? j5 : j6, f, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                            j6 = j6;
                            j4 = j7;
                        }
                    }
                };
                composer2.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((DrawScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(DrawScope drawScope) {
                        boolean z6 = drawScope.getLayoutDirection() == LayoutDirection.Rtl;
                        long jOffset = OffsetKt.Offset(0.0f, Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()));
                        long jOffset2 = OffsetKt.Offset(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()));
                        long j = z6 ? jOffset2 : jOffset;
                        long j2 = z6 ? jOffset : jOffset2;
                        float f = drawScope.toPx-0680j_4(SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM());
                        float f2 = drawScope.toPx-0680j_4(SliderKt.getTrackHeight());
                        long j3 = j2;
                        long j4 = j;
                        DrawScope.CC.m5172drawLineNGM6Ib0$default(drawScope, jM2805trackColorWaAFU9c$material3_release, j, j2, f2, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                        DrawScope.CC.m5172drawLineNGM6Ib0$default(drawScope, jM2805trackColorWaAFU9c$material3_release2, OffsetKt.Offset(Offset.m4346getXimpl(j4) + ((Offset.m4346getXimpl(j3) - Offset.m4346getXimpl(j4)) * ((Number) sliderPositions.getActiveRange().getStart()).floatValue()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0())), OffsetKt.Offset(Offset.m4346getXimpl(j4) + ((Offset.m4346getXimpl(j3) - Offset.m4346getXimpl(j4)) * ((Number) sliderPositions.getActiveRange().getEndInclusive()).floatValue()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0())), f2, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                        float[] tickFractions = sliderPositions.getTickFractions();
                        SliderPositions sliderPositions2 = sliderPositions;
                        LinkedHashMap linkedHashMap = new LinkedHashMap();
                        int length = tickFractions.length;
                        for (int i10 = 0; i10 < length; i10++) {
                            float f3 = tickFractions[i10];
                            Boolean boolValueOf = Boolean.valueOf(f3 > ((Number) sliderPositions2.getActiveRange().getEndInclusive()).floatValue() || f3 < ((Number) sliderPositions2.getActiveRange().getStart()).floatValue());
                            Object obj = linkedHashMap.get(boolValueOf);
                            if (obj == null) {
                                obj = (List) new ArrayList();
                                linkedHashMap.put(boolValueOf, obj);
                            }
                            ((List) obj).add(Float.valueOf(f3));
                        }
                        long j5 = jM2804tickColorWaAFU9c$material3_release;
                        long j6 = jM2804tickColorWaAFU9c$material3_release2;
                        for (Map.Entry entry : linkedHashMap.entrySet()) {
                            boolean zBooleanValue = ((Boolean) entry.getKey()).booleanValue();
                            List list = (List) entry.getValue();
                            ArrayList arrayList = new ArrayList(list.size());
                            int size = list.size();
                            for (int i11 = 0; i11 < size; i11++) {
                                arrayList.add(Offset.m4335boximpl(OffsetKt.Offset(Offset.m4346getXimpl(OffsetKt.m4369lerpWko1d7g(j4, j3, ((Number) list.get(i11)).floatValue())), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()))));
                            }
                            long j7 = j4;
                            j3 = j3;
                            DrawScope.CC.m5177drawPointsF8ZwMP8$default(drawScope, arrayList, PointMode.INSTANCE.m4904getPointsr_lszbg(), zBooleanValue ? j5 : j6, f, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                            j6 = j6;
                            j4 = j7;
                        }
                    }
                };
                composer2.updateRememberedValue(objRememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composer2);
            CanvasKt.Canvas(modifierM1066height3ABfNKs7, (Function1) objRememberedValue, composer2, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            sliderColors3 = sliderColors10;
            modifier3 = companion;
            z5 = z3;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i9 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 4) != 0) {
                    SliderColors sliderColorsColors12 = colors(composerStartRestartGroup, (i3 >> 12) & 14);
                    i3 &= -897;
                    sliderColors2 = sliderColorsColors12;
                }
                if (i4 != 0) {
                    z3 = true;
                } else {
                    z3 = z2;
                }
            } else {
                if (i9 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 4) != 0) {
                    SliderColors sliderColorsColors13 = colors(composerStartRestartGroup, (i3 >> 12) & 14);
                    i3 &= -897;
                    sliderColors2 = sliderColorsColors13;
                }
                if (i4 != 0) {
                    z3 = true;
                } else {
                    z3 = z2;
                }
            }
            SliderColors sliderColors11 = sliderColors2;
            i7 = i3;
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1546713545, i7, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:999)");
            }
            jM2805trackColorWaAFU9c$material3_release = sliderColors11.m2805trackColorWaAFU9c$material3_release(z3, false);
            jM2805trackColorWaAFU9c$material3_release2 = sliderColors11.m2805trackColorWaAFU9c$material3_release(z3, true);
            jM2804tickColorWaAFU9c$material3_release = sliderColors11.m2804tickColorWaAFU9c$material3_release(z3, false);
            jM2804tickColorWaAFU9c$material3_release2 = sliderColors11.m2804tickColorWaAFU9c$material3_release(z3, true);
            Modifier modifierM1066height3ABfNKs8 = SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), SliderKt.getTrackHeight());
            composer2 = composerStartRestartGroup;
            ComposerKt.sourceInformationMarkerStart(composer2, -801023075, "CC(remember):Slider.kt#9igjgp");
            boolean zChanged9 = composer2.changed(jM2805trackColorWaAFU9c$material3_release);
            if ((i7 & 14) == 4) {
                z4 = true;
            } else {
                z4 = false;
            }
            zChanged = zChanged9 | z4 | composer2.changed(jM2805trackColorWaAFU9c$material3_release2) | composer2.changed(jM2804tickColorWaAFU9c$material3_release) | composer2.changed(jM2804tickColorWaAFU9c$material3_release2);
            objRememberedValue = composer2.rememberedValue();
            if (!zChanged) {
                objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((DrawScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(DrawScope drawScope) {
                        boolean z6 = drawScope.getLayoutDirection() == LayoutDirection.Rtl;
                        long jOffset = OffsetKt.Offset(0.0f, Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()));
                        long jOffset2 = OffsetKt.Offset(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()));
                        long j = z6 ? jOffset2 : jOffset;
                        long j2 = z6 ? jOffset : jOffset2;
                        float f = drawScope.toPx-0680j_4(SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM());
                        float f2 = drawScope.toPx-0680j_4(SliderKt.getTrackHeight());
                        long j3 = j2;
                        long j4 = j;
                        DrawScope.CC.m5172drawLineNGM6Ib0$default(drawScope, jM2805trackColorWaAFU9c$material3_release, j, j2, f2, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                        DrawScope.CC.m5172drawLineNGM6Ib0$default(drawScope, jM2805trackColorWaAFU9c$material3_release2, OffsetKt.Offset(Offset.m4346getXimpl(j4) + ((Offset.m4346getXimpl(j3) - Offset.m4346getXimpl(j4)) * ((Number) sliderPositions.getActiveRange().getStart()).floatValue()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0())), OffsetKt.Offset(Offset.m4346getXimpl(j4) + ((Offset.m4346getXimpl(j3) - Offset.m4346getXimpl(j4)) * ((Number) sliderPositions.getActiveRange().getEndInclusive()).floatValue()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0())), f2, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                        float[] tickFractions = sliderPositions.getTickFractions();
                        SliderPositions sliderPositions2 = sliderPositions;
                        LinkedHashMap linkedHashMap = new LinkedHashMap();
                        int length = tickFractions.length;
                        for (int i10 = 0; i10 < length; i10++) {
                            float f3 = tickFractions[i10];
                            Boolean boolValueOf = Boolean.valueOf(f3 > ((Number) sliderPositions2.getActiveRange().getEndInclusive()).floatValue() || f3 < ((Number) sliderPositions2.getActiveRange().getStart()).floatValue());
                            Object obj = linkedHashMap.get(boolValueOf);
                            if (obj == null) {
                                obj = (List) new ArrayList();
                                linkedHashMap.put(boolValueOf, obj);
                            }
                            ((List) obj).add(Float.valueOf(f3));
                        }
                        long j5 = jM2804tickColorWaAFU9c$material3_release;
                        long j6 = jM2804tickColorWaAFU9c$material3_release2;
                        for (Map.Entry entry : linkedHashMap.entrySet()) {
                            boolean zBooleanValue = ((Boolean) entry.getKey()).booleanValue();
                            List list = (List) entry.getValue();
                            ArrayList arrayList = new ArrayList(list.size());
                            int size = list.size();
                            for (int i11 = 0; i11 < size; i11++) {
                                arrayList.add(Offset.m4335boximpl(OffsetKt.Offset(Offset.m4346getXimpl(OffsetKt.m4369lerpWko1d7g(j4, j3, ((Number) list.get(i11)).floatValue())), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()))));
                            }
                            long j7 = j4;
                            j3 = j3;
                            DrawScope.CC.m5177drawPointsF8ZwMP8$default(drawScope, arrayList, PointMode.INSTANCE.m4904getPointsr_lszbg(), zBooleanValue ? j5 : j6, f, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                            j6 = j6;
                            j4 = j7;
                        }
                    }
                };
                composer2.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((DrawScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(DrawScope drawScope) {
                        boolean z6 = drawScope.getLayoutDirection() == LayoutDirection.Rtl;
                        long jOffset = OffsetKt.Offset(0.0f, Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()));
                        long jOffset2 = OffsetKt.Offset(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()));
                        long j = z6 ? jOffset2 : jOffset;
                        long j2 = z6 ? jOffset : jOffset2;
                        float f = drawScope.toPx-0680j_4(SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM());
                        float f2 = drawScope.toPx-0680j_4(SliderKt.getTrackHeight());
                        long j3 = j2;
                        long j4 = j;
                        DrawScope.CC.m5172drawLineNGM6Ib0$default(drawScope, jM2805trackColorWaAFU9c$material3_release, j, j2, f2, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                        DrawScope.CC.m5172drawLineNGM6Ib0$default(drawScope, jM2805trackColorWaAFU9c$material3_release2, OffsetKt.Offset(Offset.m4346getXimpl(j4) + ((Offset.m4346getXimpl(j3) - Offset.m4346getXimpl(j4)) * ((Number) sliderPositions.getActiveRange().getStart()).floatValue()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0())), OffsetKt.Offset(Offset.m4346getXimpl(j4) + ((Offset.m4346getXimpl(j3) - Offset.m4346getXimpl(j4)) * ((Number) sliderPositions.getActiveRange().getEndInclusive()).floatValue()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0())), f2, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                        float[] tickFractions = sliderPositions.getTickFractions();
                        SliderPositions sliderPositions2 = sliderPositions;
                        LinkedHashMap linkedHashMap = new LinkedHashMap();
                        int length = tickFractions.length;
                        for (int i10 = 0; i10 < length; i10++) {
                            float f3 = tickFractions[i10];
                            Boolean boolValueOf = Boolean.valueOf(f3 > ((Number) sliderPositions2.getActiveRange().getEndInclusive()).floatValue() || f3 < ((Number) sliderPositions2.getActiveRange().getStart()).floatValue());
                            Object obj = linkedHashMap.get(boolValueOf);
                            if (obj == null) {
                                obj = (List) new ArrayList();
                                linkedHashMap.put(boolValueOf, obj);
                            }
                            ((List) obj).add(Float.valueOf(f3));
                        }
                        long j5 = jM2804tickColorWaAFU9c$material3_release;
                        long j6 = jM2804tickColorWaAFU9c$material3_release2;
                        for (Map.Entry entry : linkedHashMap.entrySet()) {
                            boolean zBooleanValue = ((Boolean) entry.getKey()).booleanValue();
                            List list = (List) entry.getValue();
                            ArrayList arrayList = new ArrayList(list.size());
                            int size = list.size();
                            for (int i11 = 0; i11 < size; i11++) {
                                arrayList.add(Offset.m4335boximpl(OffsetKt.Offset(Offset.m4346getXimpl(OffsetKt.m4369lerpWko1d7g(j4, j3, ((Number) list.get(i11)).floatValue())), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()))));
                            }
                            long j7 = j4;
                            j3 = j3;
                            DrawScope.CC.m5177drawPointsF8ZwMP8$default(drawScope, arrayList, PointMode.INSTANCE.m4904getPointsr_lszbg(), zBooleanValue ? j5 : j6, f, StrokeCap.INSTANCE.m4964getRoundKaPHkGw(), null, 0.0f, null, 0, 480, null);
                            j6 = j6;
                            j4 = j7;
                        }
                    }
                };
                composer2.updateRememberedValue(objRememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composer2);
            CanvasKt.Canvas(modifierM1066height3ABfNKs8, (Function1) objRememberedValue, composer2, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            sliderColors3 = sliderColors11;
            modifier3 = companion;
            z5 = z3;
        }
        scopeUpdateScopeEndRestartGroup = composer2.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer3, int i10) {
                    SliderDefaults.this.Track(sliderPositions, modifier3, sliderColors3, z5, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Use the overload that takes `drawStopIndicator`, `drawTick`, `thumbTrackGapSize` and `trackInsideCornerSize`, see `LegacySliderSample` on how to restore the previous behavior", replaceWith = @ReplaceWith(expression = "Track(sliderState, modifier, enabled, colors, drawStopIndicator, drawTick, thumbTrackGapSize, trackInsideCornerSize)", imports = {}))
    public final void Track(final SliderState sliderState, Modifier modifier, SliderColors sliderColors, boolean z, Composer composer, final int i, final int i2) {
        int i3;
        final Modifier modifier2;
        final SliderColors sliderColors2;
        int i4;
        boolean z2;
        int i5;
        int i6;
        Modifier.Companion companion;
        SliderColors sliderColorsColors;
        Modifier modifier3;
        SliderColors sliderColors3;
        boolean z3;
        final boolean z4;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i7;
        Composer composerStartRestartGroup = composer.startRestartGroup(593554206);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(Track)P(3,2)1079@48295L8,1082@48353L213:Slider.kt#uh7d8r");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changedInstance(sliderState) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i8 = i2 & 2;
        if (i8 == 0) {
            if ((i & 48) == 0) {
                modifier2 = modifier;
                i3 |= composerStartRestartGroup.changed(modifier2) ? 32 : 16;
            }
            if ((i & 384) == 0) {
                if ((i2 & 4) == 0) {
                    sliderColors2 = sliderColors;
                    if (composerStartRestartGroup.changed(sliderColors2)) {
                        i7 = Fields.RotationX;
                    }
                    i3 |= i7;
                } else {
                    sliderColors2 = sliderColors;
                }
                i7 = Fields.SpotShadowColor;
                i3 |= i7;
            } else {
                sliderColors2 = sliderColors;
            }
            i4 = i2 & 8;
            if (i4 != 0) {
                if ((i & 3072) == 0) {
                    z2 = z;
                    if (composerStartRestartGroup.changed(z2)) {
                        i5 = Fields.CameraDistance;
                    } else {
                        i5 = Fields.RotationZ;
                    }
                    i3 |= i5;
                }
                if ((i2 & 16) != 0) {
                    i3 |= 24576;
                } else if ((i & 24576) == 0) {
                    if (composerStartRestartGroup.changed(this)) {
                        i6 = Fields.Clip;
                    } else {
                        i6 = Fields.Shape;
                    }
                    i3 |= i6;
                }
                if ((i3 & 9363) == 9362 || !composerStartRestartGroup.getSkipping()) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                        if (i8 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i2 & 4) != 0) {
                            sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 12) & 14);
                            i3 &= -897;
                        } else {
                            sliderColorsColors = sliderColors2;
                        }
                        if (i4 != 0) {
                            modifier3 = companion;
                            sliderColors3 = sliderColorsColors;
                            z3 = true;
                        } else {
                            modifier3 = companion;
                            sliderColors3 = sliderColorsColors;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(593554206, i3, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1081)");
                        }
                        m2813Track4EFweAY(sliderState, modifier3, z3, sliderColors3, (Function2<? super DrawScope, ? super Offset, Unit>) null, (Function3<? super DrawScope, ? super Offset, ? super Color, Unit>) null, SliderKt.ThumbTrackGapSize, SliderKt.TrackInsideCornerSize, composerStartRestartGroup, (i3 & 14) | 14155776 | (i3 & 112) | ((i3 >> 3) & 896) | ((i3 << 3) & 7168) | ((i3 << 12) & 234881024), 48);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier2 = modifier3;
                        sliderColors2 = sliderColors3;
                        z4 = z3;
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        if ((i2 & 4) != 0) {
                            i3 &= -897;
                        }
                        modifier3 = modifier2;
                        sliderColors3 = sliderColors2;
                    }
                    z3 = z2;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(593554206, i3, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1081)");
                    }
                    m2813Track4EFweAY(sliderState, modifier3, z3, sliderColors3, (Function2<? super DrawScope, ? super Offset, Unit>) null, (Function3<? super DrawScope, ? super Offset, ? super Color, Unit>) null, SliderKt.ThumbTrackGapSize, SliderKt.TrackInsideCornerSize, composerStartRestartGroup, (i3 & 14) | 14155776 | (i3 & 112) | ((i3 >> 3) & 896) | ((i3 << 3) & 7168) | ((i3 << 12) & 234881024), 48);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = modifier3;
                    sliderColors2 = sliderColors3;
                    z4 = z3;
                } else {
                    composerStartRestartGroup.skipToGroupEnd();
                    z4 = z2;
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

                        public final void invoke(Composer composer2, int i9) {
                            SliderDefaults.this.Track(sliderState, modifier2, sliderColors2, z4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            z2 = z;
            if ((i2 & 16) != 0) {
                i3 |= 24576;
            } else if ((i & 24576) == 0) {
                if (composerStartRestartGroup.changed(this)) {
                    i6 = Fields.Clip;
                } else {
                    i6 = Fields.Shape;
                }
                i3 |= i6;
            }
            if ((i3 & 9363) == 9362) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i8 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 4) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 12) & 14);
                        i3 &= -897;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if (i4 != 0) {
                        modifier3 = companion;
                        sliderColors3 = sliderColorsColors;
                        z3 = true;
                    } else {
                        modifier3 = companion;
                        sliderColors3 = sliderColorsColors;
                        z3 = z2;
                    }
                } else {
                    if (i8 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 4) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 12) & 14);
                        i3 &= -897;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if (i4 != 0) {
                        modifier3 = companion;
                        sliderColors3 = sliderColorsColors;
                        z3 = true;
                    } else {
                        modifier3 = companion;
                        sliderColors3 = sliderColorsColors;
                        z3 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(593554206, i3, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1081)");
                }
                m2813Track4EFweAY(sliderState, modifier3, z3, sliderColors3, (Function2<? super DrawScope, ? super Offset, Unit>) null, (Function3<? super DrawScope, ? super Offset, ? super Color, Unit>) null, SliderKt.ThumbTrackGapSize, SliderKt.TrackInsideCornerSize, composerStartRestartGroup, (i3 & 14) | 14155776 | (i3 & 112) | ((i3 >> 3) & 896) | ((i3 << 3) & 7168) | ((i3 << 12) & 234881024), 48);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = modifier3;
                sliderColors2 = sliderColors3;
                z4 = z3;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i8 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 4) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 12) & 14);
                        i3 &= -897;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if (i4 != 0) {
                        modifier3 = companion;
                        sliderColors3 = sliderColorsColors;
                        z3 = true;
                    } else {
                        modifier3 = companion;
                        sliderColors3 = sliderColorsColors;
                        z3 = z2;
                    }
                } else {
                    if (i8 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 4) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 12) & 14);
                        i3 &= -897;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if (i4 != 0) {
                        modifier3 = companion;
                        sliderColors3 = sliderColorsColors;
                        z3 = true;
                    } else {
                        modifier3 = companion;
                        sliderColors3 = sliderColorsColors;
                        z3 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(593554206, i3, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1081)");
                }
                m2813Track4EFweAY(sliderState, modifier3, z3, sliderColors3, (Function2<? super DrawScope, ? super Offset, Unit>) null, (Function3<? super DrawScope, ? super Offset, ? super Color, Unit>) null, SliderKt.ThumbTrackGapSize, SliderKt.TrackInsideCornerSize, composerStartRestartGroup, (i3 & 14) | 14155776 | (i3 & 112) | ((i3 >> 3) & 896) | ((i3 << 3) & 7168) | ((i3 << 12) & 234881024), 48);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = modifier3;
                sliderColors2 = sliderColors3;
                z4 = z3;
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

                    public final void invoke(Composer composer2, int i9) {
                        SliderDefaults.this.Track(sliderState, modifier2, sliderColors2, z4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        modifier2 = modifier;
        if ((i & 384) == 0) {
            if ((i2 & 4) == 0) {
                sliderColors2 = sliderColors;
                if (composerStartRestartGroup.changed(sliderColors2)) {
                    i7 = Fields.RotationX;
                }
                i3 |= i7;
            } else {
                sliderColors2 = sliderColors;
            }
            i7 = Fields.SpotShadowColor;
            i3 |= i7;
        } else {
            sliderColors2 = sliderColors;
        }
        i4 = i2 & 8;
        if (i4 != 0) {
            if ((i & 3072) == 0) {
                z2 = z;
                if (composerStartRestartGroup.changed(z2)) {
                    i5 = Fields.CameraDistance;
                } else {
                    i5 = Fields.RotationZ;
                }
                i3 |= i5;
            }
            if ((i2 & 16) != 0) {
                i3 |= 24576;
            } else if ((i & 24576) == 0) {
                if (composerStartRestartGroup.changed(this)) {
                    i6 = Fields.Clip;
                } else {
                    i6 = Fields.Shape;
                }
                i3 |= i6;
            }
            if ((i3 & 9363) == 9362) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i8 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 4) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 12) & 14);
                        i3 &= -897;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if (i4 != 0) {
                        modifier3 = companion;
                        sliderColors3 = sliderColorsColors;
                        z3 = true;
                    } else {
                        modifier3 = companion;
                        sliderColors3 = sliderColorsColors;
                        z3 = z2;
                    }
                } else {
                    if (i8 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 4) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 12) & 14);
                        i3 &= -897;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if (i4 != 0) {
                        modifier3 = companion;
                        sliderColors3 = sliderColorsColors;
                        z3 = true;
                    } else {
                        modifier3 = companion;
                        sliderColors3 = sliderColorsColors;
                        z3 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(593554206, i3, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1081)");
                }
                m2813Track4EFweAY(sliderState, modifier3, z3, sliderColors3, (Function2<? super DrawScope, ? super Offset, Unit>) null, (Function3<? super DrawScope, ? super Offset, ? super Color, Unit>) null, SliderKt.ThumbTrackGapSize, SliderKt.TrackInsideCornerSize, composerStartRestartGroup, (i3 & 14) | 14155776 | (i3 & 112) | ((i3 >> 3) & 896) | ((i3 << 3) & 7168) | ((i3 << 12) & 234881024), 48);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = modifier3;
                sliderColors2 = sliderColors3;
                z4 = z3;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i8 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 4) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 12) & 14);
                        i3 &= -897;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if (i4 != 0) {
                        modifier3 = companion;
                        sliderColors3 = sliderColorsColors;
                        z3 = true;
                    } else {
                        modifier3 = companion;
                        sliderColors3 = sliderColorsColors;
                        z3 = z2;
                    }
                } else {
                    if (i8 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 4) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 12) & 14);
                        i3 &= -897;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if (i4 != 0) {
                        modifier3 = companion;
                        sliderColors3 = sliderColorsColors;
                        z3 = true;
                    } else {
                        modifier3 = companion;
                        sliderColors3 = sliderColorsColors;
                        z3 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(593554206, i3, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1081)");
                }
                m2813Track4EFweAY(sliderState, modifier3, z3, sliderColors3, (Function2<? super DrawScope, ? super Offset, Unit>) null, (Function3<? super DrawScope, ? super Offset, ? super Color, Unit>) null, SliderKt.ThumbTrackGapSize, SliderKt.TrackInsideCornerSize, composerStartRestartGroup, (i3 & 14) | 14155776 | (i3 & 112) | ((i3 >> 3) & 896) | ((i3 << 3) & 7168) | ((i3 << 12) & 234881024), 48);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = modifier3;
                sliderColors2 = sliderColors3;
                z4 = z3;
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

                    public final void invoke(Composer composer2, int i9) {
                        SliderDefaults.this.Track(sliderState, modifier2, sliderColors2, z4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 3072;
        z2 = z;
        if ((i2 & 16) != 0) {
            i3 |= 24576;
        } else if ((i & 24576) == 0) {
            if (composerStartRestartGroup.changed(this)) {
                i6 = Fields.Clip;
            } else {
                i6 = Fields.Shape;
            }
            i3 |= i6;
        }
        if ((i3 & 9363) == 9362) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i8 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 4) != 0) {
                    sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 12) & 14);
                    i3 &= -897;
                } else {
                    sliderColorsColors = sliderColors2;
                }
                if (i4 != 0) {
                    modifier3 = companion;
                    sliderColors3 = sliderColorsColors;
                    z3 = true;
                } else {
                    modifier3 = companion;
                    sliderColors3 = sliderColorsColors;
                    z3 = z2;
                }
            } else {
                if (i8 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 4) != 0) {
                    sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 12) & 14);
                    i3 &= -897;
                } else {
                    sliderColorsColors = sliderColors2;
                }
                if (i4 != 0) {
                    modifier3 = companion;
                    sliderColors3 = sliderColorsColors;
                    z3 = true;
                } else {
                    modifier3 = companion;
                    sliderColors3 = sliderColorsColors;
                    z3 = z2;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(593554206, i3, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1081)");
            }
            m2813Track4EFweAY(sliderState, modifier3, z3, sliderColors3, (Function2<? super DrawScope, ? super Offset, Unit>) null, (Function3<? super DrawScope, ? super Offset, ? super Color, Unit>) null, SliderKt.ThumbTrackGapSize, SliderKt.TrackInsideCornerSize, composerStartRestartGroup, (i3 & 14) | 14155776 | (i3 & 112) | ((i3 >> 3) & 896) | ((i3 << 3) & 7168) | ((i3 << 12) & 234881024), 48);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier2 = modifier3;
            sliderColors2 = sliderColors3;
            z4 = z3;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i8 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 4) != 0) {
                    sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 12) & 14);
                    i3 &= -897;
                } else {
                    sliderColorsColors = sliderColors2;
                }
                if (i4 != 0) {
                    modifier3 = companion;
                    sliderColors3 = sliderColorsColors;
                    z3 = true;
                } else {
                    modifier3 = companion;
                    sliderColors3 = sliderColorsColors;
                    z3 = z2;
                }
            } else {
                if (i8 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 4) != 0) {
                    sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 12) & 14);
                    i3 &= -897;
                } else {
                    sliderColorsColors = sliderColors2;
                }
                if (i4 != 0) {
                    modifier3 = companion;
                    sliderColors3 = sliderColorsColors;
                    z3 = true;
                } else {
                    modifier3 = companion;
                    sliderColors3 = sliderColorsColors;
                    z3 = z2;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(593554206, i3, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1081)");
            }
            m2813Track4EFweAY(sliderState, modifier3, z3, sliderColors3, (Function2<? super DrawScope, ? super Offset, Unit>) null, (Function3<? super DrawScope, ? super Offset, ? super Color, Unit>) null, SliderKt.ThumbTrackGapSize, SliderKt.TrackInsideCornerSize, composerStartRestartGroup, (i3 & 14) | 14155776 | (i3 & 112) | ((i3 >> 3) & 896) | ((i3 << 3) & 7168) | ((i3 << 12) & 234881024), 48);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier2 = modifier3;
            sliderColors2 = sliderColors3;
            z4 = z3;
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

                public final void invoke(Composer composer2, int i9) {
                    SliderDefaults.this.Track(sliderState, modifier2, sliderColors2, z4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public final void m2813Track4EFweAY(final SliderState sliderState, Modifier modifier, boolean z, SliderColors sliderColors, Function2<? super DrawScope, ? super Offset, Unit> function2, Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function3, float f, float f2, Composer composer, final int i, final int i2) {
        int i3;
        int i4;
        final boolean z2;
        int i5;
        SliderColors sliderColors2;
        Function2<? super DrawScope, ? super Offset, Unit> function4;
        int i6;
        Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function5;
        int i7;
        int i8;
        int i9;
        int i10;
        float f3;
        int i11;
        int i12;
        Modifier.Companion companion;
        final SliderColors sliderColorsColors;
        Function2<? super DrawScope, ? super Offset, Unit> function6;
        C13385 c13385;
        float f4;
        float f5;
        int i13;
        float f6;
        boolean z3;
        boolean z4;
        Object objRememberedValue;
        long jM2805trackColorWaAFU9c$material3_release;
        final long jM2805trackColorWaAFU9c$material3_release2;
        Function2<? super DrawScope, ? super Offset, Unit> function7;
        final float f7;
        final long jM2804tickColorWaAFU9c$material3_release;
        final long jM2804tickColorWaAFU9c$material3_release2;
        Object objConsume;
        float f8;
        boolean z5;
        boolean z6;
        Function2<? super DrawScope, ? super Offset, Unit> function8;
        long j;
        boolean z7;
        boolean z8;
        boolean z9;
        Object objRememberedValue2;
        final SliderColors sliderColors3;
        final float f9;
        final Function2<? super DrawScope, ? super Offset, Unit> function9;
        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function10;
        final float f10;
        final boolean z10;
        final Modifier modifier2;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i14;
        int i15;
        Composer composerStartRestartGroup = composer.startRestartGroup(49984771);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(Track)P(5,4,3!3,6:c#ui.unit.Dp,7:c#ui.unit.Dp)1114@49756L8,1115@49825L232,1137@50806L7,1138@50862L595,1133@50659L798:Slider.kt#uh7d8r");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changedInstance(sliderState) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i16 = i2 & 2;
        if (i16 == 0) {
            if ((i & 48) == 0) {
                i3 |= composerStartRestartGroup.changed(modifier) ? 32 : 16;
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
                        sliderColors2 = sliderColors;
                        if (composerStartRestartGroup.changed(sliderColors2)) {
                            i15 = Fields.CameraDistance;
                        }
                        i3 |= i15;
                    } else {
                        sliderColors2 = sliderColors;
                    }
                    i15 = Fields.RotationZ;
                    i3 |= i15;
                } else {
                    sliderColors2 = sliderColors;
                }
                if ((i & 24576) == 0) {
                    if ((i2 & 16) == 0) {
                        function4 = function2;
                        if (composerStartRestartGroup.changedInstance(function4)) {
                            i14 = Fields.Clip;
                        }
                        i3 |= i14;
                    } else {
                        function4 = function2;
                    }
                    i14 = Fields.Shape;
                    i3 |= i14;
                } else {
                    function4 = function2;
                }
                i6 = i2 & 32;
                if (i6 != 0) {
                    i3 |= 196608;
                    function5 = function3;
                } else {
                    function5 = function3;
                    if ((i & 196608) == 0) {
                        if (composerStartRestartGroup.changedInstance(function5)) {
                            i7 = Fields.RenderEffect;
                        } else {
                            i7 = 65536;
                        }
                        i3 |= i7;
                    }
                }
                i8 = i2 & 64;
                if (i8 != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(f)) {
                        i9 = 1048576;
                    } else {
                        i9 = 524288;
                    }
                    i3 |= i9;
                }
                i10 = i2 & Fields.SpotShadowColor;
                if (i10 != 0) {
                    i3 |= 12582912;
                    f3 = f2;
                } else {
                    f3 = f2;
                    if ((i & 12582912) == 0) {
                        if (composerStartRestartGroup.changed(f3)) {
                            i11 = 8388608;
                        } else {
                            i11 = 4194304;
                        }
                        i3 |= i11;
                    }
                }
                if ((i2 & Fields.RotationX) != 0) {
                    if ((100663296 & i) == 0) {
                        if (composerStartRestartGroup.changed(this)) {
                            i12 = 67108864;
                        } else {
                            i12 = 33554432;
                        }
                    }
                    if ((38347923 & i3) == 38347922 || !composerStartRestartGroup.getSkipping()) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                            if (i16 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i4 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 8) != 0) {
                                sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                                i3 &= -7169;
                            } else {
                                sliderColorsColors = sliderColors2;
                            }
                            if ((i2 & 16) != 0) {
                                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800875397, "CC(remember):Slider.kt#9igjgp");
                                boolean z11 = (((i3 & 7168) ^ 3072) <= 2048 && composerStartRestartGroup.changed(sliderColorsColors)) || (i3 & 3072) == 2048;
                                if ((i3 & 896) == 256) {
                                    z3 = true;
                                } else {
                                    z3 = false;
                                }
                                z4 = z11 | z3;
                                objRememberedValue = composerStartRestartGroup.rememberedValue();
                                if (!z4 || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void m2818invokeUv8p0NA(DrawScope drawScope, long j2) {
                                            SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j2, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                        }
                                    };
                                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                                }
                                function6 = (Function2) objRememberedValue;
                                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                                i3 &= -57345;
                            } else {
                                function6 = function4;
                            }
                            if (i6 != 0) {
                                c13385 = new Function3<DrawScope, Offset, Color, Unit>() {
                                    public Object invoke(Object obj, Object obj2, Object obj3) {
                                        m2819invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2819invokewPWG1Vc(DrawScope drawScope, long j2, long j3) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j2, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j3);
                                    }
                                };
                            } else {
                                c13385 = function5;
                            }
                            if (i8 != 0) {
                                f4 = SliderKt.ThumbTrackGapSize;
                            } else {
                                f4 = f;
                            }
                            if (i10 != 0) {
                                f5 = SliderKt.TrackInsideCornerSize;
                            } else {
                                f5 = f3;
                            }
                            i13 = i3;
                            f6 = f4;
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            if ((i2 & 8) != 0) {
                                i3 &= -7169;
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                            }
                            companion = modifier;
                            sliderColorsColors = sliderColors2;
                            f5 = f3;
                            function6 = function4;
                            c13385 = function5;
                            i13 = i3;
                            f6 = f;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(49984771, i13, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1128)");
                        }
                        jM2805trackColorWaAFU9c$material3_release = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, false);
                        jM2805trackColorWaAFU9c$material3_release2 = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true);
                        function7 = function6;
                        f7 = f5;
                        jM2804tickColorWaAFU9c$material3_release = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, false);
                        jM2804tickColorWaAFU9c$material3_release2 = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, true);
                        SliderColors sliderColors4 = sliderColorsColors;
                        Modifier modifierM1066height3ABfNKs = SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), SliderKt.getTrackHeight());
                        ProvidableCompositionLocal<LayoutDirection> localLayoutDirection = CompositionLocalsKt.getLocalLayoutDirection();
                        Modifier modifier3 = companion;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        objConsume = composerStartRestartGroup.consume(localLayoutDirection);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        if (objConsume == LayoutDirection.Rtl) {
                            f8 = 180.0f;
                        } else {
                            f8 = 0.0f;
                        }
                        Modifier modifierRotate = RotateKt.rotate(modifierM1066height3ABfNKs, f8);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800841850, "CC(remember):Slider.kt#9igjgp");
                        boolean z12 = z2;
                        boolean zChangedInstance = composerStartRestartGroup.changedInstance(sliderState) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release2) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release2);
                        if ((i13 & 3670016) == 1048576) {
                            z5 = true;
                        } else {
                            z5 = false;
                        }
                        boolean z13 = z5 | zChangedInstance;
                        if ((29360128 & i13) == 8388608) {
                            z6 = true;
                        } else {
                            z6 = false;
                        }
                        boolean z14 = z13 | z6;
                        if (((57344 & i13) ^ 24576) > 16384) {
                            function8 = function7;
                            if (composerStartRestartGroup.changed(function8)) {
                                j = jM2805trackColorWaAFU9c$material3_release;
                            }
                            z7 = true;
                            boolean z15 = z14 | z7;
                            if ((458752 & i13) == 131072) {
                                z8 = true;
                            } else {
                                z8 = false;
                            }
                            z9 = z15 | z8;
                            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                            if (!z9 || objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                                final long j2 = j;
                                final float f11 = f6;
                                final Function2<? super DrawScope, ? super Offset, Unit> function11 = function8;
                                final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function12 = c13385;
                                objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((DrawScope) obj);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(DrawScope drawScope) {
                                        SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j2, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f11, f7, function11, function12, false);
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            CanvasKt.Canvas(modifierRotate, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            sliderColors3 = sliderColors4;
                            f9 = f6;
                            function9 = function8;
                            function10 = c13385;
                            f10 = f7;
                            z10 = z12;
                            modifier2 = modifier3;
                        } else {
                            function8 = function7;
                        }
                        j = jM2805trackColorWaAFU9c$material3_release;
                        if ((i13 & 24576) == 16384) {
                            z7 = true;
                        } else {
                            z7 = false;
                        }
                        boolean z16 = z14 | z7;
                        if ((458752 & i13) == 131072) {
                            z8 = true;
                        } else {
                            z8 = false;
                        }
                        z9 = z16 | z8;
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z9) {
                            final long j3 = j;
                            final float f12 = f6;
                            final Function2<? super DrawScope, ? super Offset, Unit> function13 = function8;
                            final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function14 = c13385;
                            objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j3, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f12, f7, function13, function14, false);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            final long j4 = j;
                            final float f13 = f6;
                            final Function2<? super DrawScope, ? super Offset, Unit> function15 = function8;
                            final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function16 = c13385;
                            objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j4, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f13, f7, function15, function16, false);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CanvasKt.Canvas(modifierRotate, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        sliderColors3 = sliderColors4;
                        f9 = f6;
                        function9 = function8;
                        function10 = c13385;
                        f10 = f7;
                        z10 = z12;
                        modifier2 = modifier3;
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        modifier2 = modifier;
                        z10 = z2;
                        sliderColors3 = sliderColors2;
                        f10 = f3;
                        function9 = function4;
                        function10 = function5;
                        f9 = f;
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

                            public final void invoke(Composer composer2, int i17) {
                                SliderDefaults.this.m2813Track4EFweAY(sliderState, modifier2, z10, sliderColors3, function9, function10, f9, f10, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i12 = 100663296;
                i3 |= i12;
                if ((38347923 & i3) == 38347922) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i16 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                            i3 &= -7169;
                        } else {
                            sliderColorsColors = sliderColors2;
                        }
                        if ((i2 & 16) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800875397, "CC(remember):Slider.kt#9igjgp");
                            if (((i3 & 7168) ^ 3072) <= 2048) {
                            }
                            if ((i3 & 896) == 256) {
                                z3 = true;
                            } else {
                                z3 = false;
                            }
                            z4 = z11 | z3;
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z4) {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2818invokeUv8p0NA(DrawScope drawScope, long j5) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j5, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            } else {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2818invokeUv8p0NA(DrawScope drawScope, long j5) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j5, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            function6 = (Function2) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -57345;
                        } else {
                            function6 = function4;
                        }
                        if (i6 != 0) {
                            c13385 = new Function3<DrawScope, Offset, Color, Unit>() {
                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    m2819invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                    return Unit.INSTANCE;
                                }

                                public final void m2819invokewPWG1Vc(DrawScope drawScope, long j5, long j6) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j5, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j6);
                                }
                            };
                        } else {
                            c13385 = function5;
                        }
                        if (i8 != 0) {
                            f4 = SliderKt.ThumbTrackGapSize;
                        } else {
                            f4 = f;
                        }
                        if (i10 != 0) {
                            f5 = SliderKt.TrackInsideCornerSize;
                        } else {
                            f5 = f3;
                        }
                        i13 = i3;
                        f6 = f4;
                    } else {
                        if (i16 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                            i3 &= -7169;
                        } else {
                            sliderColorsColors = sliderColors2;
                        }
                        if ((i2 & 16) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800875397, "CC(remember):Slider.kt#9igjgp");
                            if (((i3 & 7168) ^ 3072) <= 2048) {
                            }
                            if ((i3 & 896) == 256) {
                                z3 = true;
                            } else {
                                z3 = false;
                            }
                            z4 = z11 | z3;
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z4) {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2818invokeUv8p0NA(DrawScope drawScope, long j5) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j5, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            } else {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2818invokeUv8p0NA(DrawScope drawScope, long j5) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j5, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            function6 = (Function2) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -57345;
                        } else {
                            function6 = function4;
                        }
                        if (i6 != 0) {
                            c13385 = new Function3<DrawScope, Offset, Color, Unit>() {
                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    m2819invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                    return Unit.INSTANCE;
                                }

                                public final void m2819invokewPWG1Vc(DrawScope drawScope, long j5, long j6) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j5, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j6);
                                }
                            };
                        } else {
                            c13385 = function5;
                        }
                        if (i8 != 0) {
                            f4 = SliderKt.ThumbTrackGapSize;
                        } else {
                            f4 = f;
                        }
                        if (i10 != 0) {
                            f5 = SliderKt.TrackInsideCornerSize;
                        } else {
                            f5 = f3;
                        }
                        i13 = i3;
                        f6 = f4;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(49984771, i13, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1128)");
                    }
                    jM2805trackColorWaAFU9c$material3_release = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, false);
                    jM2805trackColorWaAFU9c$material3_release2 = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true);
                    function7 = function6;
                    f7 = f5;
                    jM2804tickColorWaAFU9c$material3_release = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, false);
                    jM2804tickColorWaAFU9c$material3_release2 = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, true);
                    SliderColors sliderColors5 = sliderColorsColors;
                    Modifier modifierM1066height3ABfNKs2 = SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), SliderKt.getTrackHeight());
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection2 = CompositionLocalsKt.getLocalLayoutDirection();
                    Modifier modifier4 = companion;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    objConsume = composerStartRestartGroup.consume(localLayoutDirection2);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (objConsume == LayoutDirection.Rtl) {
                        f8 = 180.0f;
                    } else {
                        f8 = 0.0f;
                    }
                    Modifier modifierRotate2 = RotateKt.rotate(modifierM1066height3ABfNKs2, f8);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800841850, "CC(remember):Slider.kt#9igjgp");
                    boolean z17 = z2;
                    boolean zChangedInstance2 = composerStartRestartGroup.changedInstance(sliderState) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release2) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release2);
                    if ((i13 & 3670016) == 1048576) {
                        z5 = true;
                    } else {
                        z5 = false;
                    }
                    boolean z18 = z5 | zChangedInstance2;
                    if ((29360128 & i13) == 8388608) {
                        z6 = true;
                    } else {
                        z6 = false;
                    }
                    boolean z19 = z18 | z6;
                    if (((57344 & i13) ^ 24576) > 16384) {
                        function8 = function7;
                        if (composerStartRestartGroup.changed(function8)) {
                            j = jM2805trackColorWaAFU9c$material3_release;
                        }
                        z7 = true;
                        boolean z110 = z19 | z7;
                        if ((458752 & i13) == 131072) {
                            z8 = true;
                        } else {
                            z8 = false;
                        }
                        z9 = z110 | z8;
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z9) {
                            final long j5 = j;
                            final float f14 = f6;
                            final Function2<? super DrawScope, ? super Offset, Unit> function17 = function8;
                            final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function18 = c13385;
                            objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j5, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f14, f7, function17, function18, false);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            final long j6 = j;
                            final float f15 = f6;
                            final Function2<? super DrawScope, ? super Offset, Unit> function19 = function8;
                            final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function110 = c13385;
                            objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j6, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f15, f7, function19, function110, false);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CanvasKt.Canvas(modifierRotate2, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        sliderColors3 = sliderColors5;
                        f9 = f6;
                        function9 = function8;
                        function10 = c13385;
                        f10 = f7;
                        z10 = z17;
                        modifier2 = modifier4;
                    } else {
                        function8 = function7;
                    }
                    j = jM2805trackColorWaAFU9c$material3_release;
                    if ((i13 & 24576) == 16384) {
                        z7 = true;
                    } else {
                        z7 = false;
                    }
                    boolean z111 = z19 | z7;
                    if ((458752 & i13) == 131072) {
                        z8 = true;
                    } else {
                        z8 = false;
                    }
                    z9 = z111 | z8;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z9) {
                        final long j7 = j;
                        final float f16 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function111 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function112 = c13385;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j7, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f16, f7, function111, function112, false);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        final long j8 = j;
                        final float f17 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function113 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function114 = c13385;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j8, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f17, f7, function113, function114, false);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CanvasKt.Canvas(modifierRotate2, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    sliderColors3 = sliderColors5;
                    f9 = f6;
                    function9 = function8;
                    function10 = c13385;
                    f10 = f7;
                    z10 = z17;
                    modifier2 = modifier4;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i16 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                            i3 &= -7169;
                        } else {
                            sliderColorsColors = sliderColors2;
                        }
                        if ((i2 & 16) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800875397, "CC(remember):Slider.kt#9igjgp");
                            if (((i3 & 7168) ^ 3072) <= 2048) {
                            }
                            if ((i3 & 896) == 256) {
                                z3 = true;
                            } else {
                                z3 = false;
                            }
                            z4 = z11 | z3;
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z4) {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2818invokeUv8p0NA(DrawScope drawScope, long j9) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j9, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            } else {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2818invokeUv8p0NA(DrawScope drawScope, long j9) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j9, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            function6 = (Function2) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -57345;
                        } else {
                            function6 = function4;
                        }
                        if (i6 != 0) {
                            c13385 = new Function3<DrawScope, Offset, Color, Unit>() {
                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    m2819invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                    return Unit.INSTANCE;
                                }

                                public final void m2819invokewPWG1Vc(DrawScope drawScope, long j9, long j10) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j9, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j10);
                                }
                            };
                        } else {
                            c13385 = function5;
                        }
                        if (i8 != 0) {
                            f4 = SliderKt.ThumbTrackGapSize;
                        } else {
                            f4 = f;
                        }
                        if (i10 != 0) {
                            f5 = SliderKt.TrackInsideCornerSize;
                        } else {
                            f5 = f3;
                        }
                        i13 = i3;
                        f6 = f4;
                    } else {
                        if (i16 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                            i3 &= -7169;
                        } else {
                            sliderColorsColors = sliderColors2;
                        }
                        if ((i2 & 16) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800875397, "CC(remember):Slider.kt#9igjgp");
                            if (((i3 & 7168) ^ 3072) <= 2048) {
                            }
                            if ((i3 & 896) == 256) {
                                z3 = true;
                            } else {
                                z3 = false;
                            }
                            z4 = z11 | z3;
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z4) {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2818invokeUv8p0NA(DrawScope drawScope, long j9) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j9, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            } else {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2818invokeUv8p0NA(DrawScope drawScope, long j9) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j9, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            function6 = (Function2) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -57345;
                        } else {
                            function6 = function4;
                        }
                        if (i6 != 0) {
                            c13385 = new Function3<DrawScope, Offset, Color, Unit>() {
                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    m2819invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                    return Unit.INSTANCE;
                                }

                                public final void m2819invokewPWG1Vc(DrawScope drawScope, long j9, long j10) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j9, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j10);
                                }
                            };
                        } else {
                            c13385 = function5;
                        }
                        if (i8 != 0) {
                            f4 = SliderKt.ThumbTrackGapSize;
                        } else {
                            f4 = f;
                        }
                        if (i10 != 0) {
                            f5 = SliderKt.TrackInsideCornerSize;
                        } else {
                            f5 = f3;
                        }
                        i13 = i3;
                        f6 = f4;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(49984771, i13, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1128)");
                    }
                    jM2805trackColorWaAFU9c$material3_release = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, false);
                    jM2805trackColorWaAFU9c$material3_release2 = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true);
                    function7 = function6;
                    f7 = f5;
                    jM2804tickColorWaAFU9c$material3_release = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, false);
                    jM2804tickColorWaAFU9c$material3_release2 = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, true);
                    SliderColors sliderColors6 = sliderColorsColors;
                    Modifier modifierM1066height3ABfNKs3 = SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), SliderKt.getTrackHeight());
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection3 = CompositionLocalsKt.getLocalLayoutDirection();
                    Modifier modifier5 = companion;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    objConsume = composerStartRestartGroup.consume(localLayoutDirection3);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (objConsume == LayoutDirection.Rtl) {
                        f8 = 180.0f;
                    } else {
                        f8 = 0.0f;
                    }
                    Modifier modifierRotate3 = RotateKt.rotate(modifierM1066height3ABfNKs3, f8);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800841850, "CC(remember):Slider.kt#9igjgp");
                    boolean z112 = z2;
                    boolean zChangedInstance3 = composerStartRestartGroup.changedInstance(sliderState) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release2) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release2);
                    if ((i13 & 3670016) == 1048576) {
                        z5 = true;
                    } else {
                        z5 = false;
                    }
                    boolean z113 = z5 | zChangedInstance3;
                    if ((29360128 & i13) == 8388608) {
                        z6 = true;
                    } else {
                        z6 = false;
                    }
                    boolean z114 = z113 | z6;
                    if (((57344 & i13) ^ 24576) > 16384) {
                        function8 = function7;
                        if (composerStartRestartGroup.changed(function8)) {
                            j = jM2805trackColorWaAFU9c$material3_release;
                        }
                        z7 = true;
                        boolean z115 = z114 | z7;
                        if ((458752 & i13) == 131072) {
                            z8 = true;
                        } else {
                            z8 = false;
                        }
                        z9 = z115 | z8;
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z9) {
                            final long j9 = j;
                            final float f18 = f6;
                            final Function2<? super DrawScope, ? super Offset, Unit> function115 = function8;
                            final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function116 = c13385;
                            objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j9, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f18, f7, function115, function116, false);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            final long j10 = j;
                            final float f19 = f6;
                            final Function2<? super DrawScope, ? super Offset, Unit> function117 = function8;
                            final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function118 = c13385;
                            objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j10, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f19, f7, function117, function118, false);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CanvasKt.Canvas(modifierRotate3, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        sliderColors3 = sliderColors6;
                        f9 = f6;
                        function9 = function8;
                        function10 = c13385;
                        f10 = f7;
                        z10 = z112;
                        modifier2 = modifier5;
                    } else {
                        function8 = function7;
                    }
                    j = jM2805trackColorWaAFU9c$material3_release;
                    if ((i13 & 24576) == 16384) {
                        z7 = true;
                    } else {
                        z7 = false;
                    }
                    boolean z116 = z114 | z7;
                    if ((458752 & i13) == 131072) {
                        z8 = true;
                    } else {
                        z8 = false;
                    }
                    z9 = z116 | z8;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z9) {
                        final long j11 = j;
                        final float f110 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function119 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1110 = c13385;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j11, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f110, f7, function119, function1110, false);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        final long j12 = j;
                        final float f111 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function1111 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1112 = c13385;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j12, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f111, f7, function1111, function1112, false);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CanvasKt.Canvas(modifierRotate3, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    sliderColors3 = sliderColors6;
                    f9 = f6;
                    function9 = function8;
                    function10 = c13385;
                    f10 = f7;
                    z10 = z112;
                    modifier2 = modifier5;
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

                        public final void invoke(Composer composer2, int i17) {
                            SliderDefaults.this.m2813Track4EFweAY(sliderState, modifier2, z10, sliderColors3, function9, function10, f9, f10, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 384;
            z2 = z;
            if ((i & 3072) == 0) {
                if ((i2 & 8) == 0) {
                    sliderColors2 = sliderColors;
                    if (composerStartRestartGroup.changed(sliderColors2)) {
                        i15 = Fields.CameraDistance;
                    }
                    i3 |= i15;
                } else {
                    sliderColors2 = sliderColors;
                }
                i15 = Fields.RotationZ;
                i3 |= i15;
            } else {
                sliderColors2 = sliderColors;
            }
            if ((i & 24576) == 0) {
                if ((i2 & 16) == 0) {
                    function4 = function2;
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i14 = Fields.Clip;
                    }
                    i3 |= i14;
                } else {
                    function4 = function2;
                }
                i14 = Fields.Shape;
                i3 |= i14;
            } else {
                function4 = function2;
            }
            i6 = i2 & 32;
            if (i6 != 0) {
                i3 |= 196608;
                function5 = function3;
            } else {
                function5 = function3;
                if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changedInstance(function5)) {
                        i7 = Fields.RenderEffect;
                    } else {
                        i7 = 65536;
                    }
                    i3 |= i7;
                }
            }
            i8 = i2 & 64;
            if (i8 != 0) {
                i3 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changed(f)) {
                    i9 = 1048576;
                } else {
                    i9 = 524288;
                }
                i3 |= i9;
            }
            i10 = i2 & Fields.SpotShadowColor;
            if (i10 != 0) {
                i3 |= 12582912;
                f3 = f2;
            } else {
                f3 = f2;
                if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(f3)) {
                        i11 = 8388608;
                    } else {
                        i11 = 4194304;
                    }
                    i3 |= i11;
                }
            }
            if ((i2 & Fields.RotationX) != 0) {
                if ((100663296 & i) == 0) {
                    if (composerStartRestartGroup.changed(this)) {
                        i12 = 67108864;
                    } else {
                        i12 = 33554432;
                    }
                }
                if ((38347923 & i3) == 38347922) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i16 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                            i3 &= -7169;
                        } else {
                            sliderColorsColors = sliderColors2;
                        }
                        if ((i2 & 16) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800875397, "CC(remember):Slider.kt#9igjgp");
                            if (((i3 & 7168) ^ 3072) <= 2048) {
                            }
                            if ((i3 & 896) == 256) {
                                z3 = true;
                            } else {
                                z3 = false;
                            }
                            z4 = z11 | z3;
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z4) {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2818invokeUv8p0NA(DrawScope drawScope, long j13) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j13, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            } else {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2818invokeUv8p0NA(DrawScope drawScope, long j13) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j13, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            function6 = (Function2) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -57345;
                        } else {
                            function6 = function4;
                        }
                        if (i6 != 0) {
                            c13385 = new Function3<DrawScope, Offset, Color, Unit>() {
                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    m2819invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                    return Unit.INSTANCE;
                                }

                                public final void m2819invokewPWG1Vc(DrawScope drawScope, long j13, long j14) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j13, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j14);
                                }
                            };
                        } else {
                            c13385 = function5;
                        }
                        if (i8 != 0) {
                            f4 = SliderKt.ThumbTrackGapSize;
                        } else {
                            f4 = f;
                        }
                        if (i10 != 0) {
                            f5 = SliderKt.TrackInsideCornerSize;
                        } else {
                            f5 = f3;
                        }
                        i13 = i3;
                        f6 = f4;
                    } else {
                        if (i16 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                            i3 &= -7169;
                        } else {
                            sliderColorsColors = sliderColors2;
                        }
                        if ((i2 & 16) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800875397, "CC(remember):Slider.kt#9igjgp");
                            if (((i3 & 7168) ^ 3072) <= 2048) {
                            }
                            if ((i3 & 896) == 256) {
                                z3 = true;
                            } else {
                                z3 = false;
                            }
                            z4 = z11 | z3;
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z4) {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2818invokeUv8p0NA(DrawScope drawScope, long j13) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j13, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            } else {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2818invokeUv8p0NA(DrawScope drawScope, long j13) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j13, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            function6 = (Function2) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -57345;
                        } else {
                            function6 = function4;
                        }
                        if (i6 != 0) {
                            c13385 = new Function3<DrawScope, Offset, Color, Unit>() {
                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    m2819invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                    return Unit.INSTANCE;
                                }

                                public final void m2819invokewPWG1Vc(DrawScope drawScope, long j13, long j14) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j13, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j14);
                                }
                            };
                        } else {
                            c13385 = function5;
                        }
                        if (i8 != 0) {
                            f4 = SliderKt.ThumbTrackGapSize;
                        } else {
                            f4 = f;
                        }
                        if (i10 != 0) {
                            f5 = SliderKt.TrackInsideCornerSize;
                        } else {
                            f5 = f3;
                        }
                        i13 = i3;
                        f6 = f4;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(49984771, i13, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1128)");
                    }
                    jM2805trackColorWaAFU9c$material3_release = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, false);
                    jM2805trackColorWaAFU9c$material3_release2 = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true);
                    function7 = function6;
                    f7 = f5;
                    jM2804tickColorWaAFU9c$material3_release = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, false);
                    jM2804tickColorWaAFU9c$material3_release2 = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, true);
                    SliderColors sliderColors7 = sliderColorsColors;
                    Modifier modifierM1066height3ABfNKs4 = SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), SliderKt.getTrackHeight());
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection4 = CompositionLocalsKt.getLocalLayoutDirection();
                    Modifier modifier6 = companion;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    objConsume = composerStartRestartGroup.consume(localLayoutDirection4);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (objConsume == LayoutDirection.Rtl) {
                        f8 = 180.0f;
                    } else {
                        f8 = 0.0f;
                    }
                    Modifier modifierRotate4 = RotateKt.rotate(modifierM1066height3ABfNKs4, f8);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800841850, "CC(remember):Slider.kt#9igjgp");
                    boolean z117 = z2;
                    boolean zChangedInstance4 = composerStartRestartGroup.changedInstance(sliderState) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release2) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release2);
                    if ((i13 & 3670016) == 1048576) {
                        z5 = true;
                    } else {
                        z5 = false;
                    }
                    boolean z118 = z5 | zChangedInstance4;
                    if ((29360128 & i13) == 8388608) {
                        z6 = true;
                    } else {
                        z6 = false;
                    }
                    boolean z119 = z118 | z6;
                    if (((57344 & i13) ^ 24576) > 16384) {
                        function8 = function7;
                        if (composerStartRestartGroup.changed(function8)) {
                            j = jM2805trackColorWaAFU9c$material3_release;
                        }
                        z7 = true;
                        boolean z1110 = z119 | z7;
                        if ((458752 & i13) == 131072) {
                            z8 = true;
                        } else {
                            z8 = false;
                        }
                        z9 = z1110 | z8;
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z9) {
                            final long j13 = j;
                            final float f112 = f6;
                            final Function2<? super DrawScope, ? super Offset, Unit> function1113 = function8;
                            final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1114 = c13385;
                            objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j13, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f112, f7, function1113, function1114, false);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            final long j14 = j;
                            final float f113 = f6;
                            final Function2<? super DrawScope, ? super Offset, Unit> function1115 = function8;
                            final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1116 = c13385;
                            objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j14, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f113, f7, function1115, function1116, false);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CanvasKt.Canvas(modifierRotate4, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        sliderColors3 = sliderColors7;
                        f9 = f6;
                        function9 = function8;
                        function10 = c13385;
                        f10 = f7;
                        z10 = z117;
                        modifier2 = modifier6;
                    } else {
                        function8 = function7;
                    }
                    j = jM2805trackColorWaAFU9c$material3_release;
                    if ((i13 & 24576) == 16384) {
                        z7 = true;
                    } else {
                        z7 = false;
                    }
                    boolean z1111 = z119 | z7;
                    if ((458752 & i13) == 131072) {
                        z8 = true;
                    } else {
                        z8 = false;
                    }
                    z9 = z1111 | z8;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z9) {
                        final long j15 = j;
                        final float f114 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function1117 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1118 = c13385;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j15, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f114, f7, function1117, function1118, false);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        final long j16 = j;
                        final float f115 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function1119 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function11110 = c13385;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j16, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f115, f7, function1119, function11110, false);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CanvasKt.Canvas(modifierRotate4, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    sliderColors3 = sliderColors7;
                    f9 = f6;
                    function9 = function8;
                    function10 = c13385;
                    f10 = f7;
                    z10 = z117;
                    modifier2 = modifier6;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i16 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                            i3 &= -7169;
                        } else {
                            sliderColorsColors = sliderColors2;
                        }
                        if ((i2 & 16) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800875397, "CC(remember):Slider.kt#9igjgp");
                            if (((i3 & 7168) ^ 3072) <= 2048) {
                            }
                            if ((i3 & 896) == 256) {
                                z3 = true;
                            } else {
                                z3 = false;
                            }
                            z4 = z11 | z3;
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z4) {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2818invokeUv8p0NA(DrawScope drawScope, long j17) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j17, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            } else {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2818invokeUv8p0NA(DrawScope drawScope, long j17) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j17, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            function6 = (Function2) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -57345;
                        } else {
                            function6 = function4;
                        }
                        if (i6 != 0) {
                            c13385 = new Function3<DrawScope, Offset, Color, Unit>() {
                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    m2819invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                    return Unit.INSTANCE;
                                }

                                public final void m2819invokewPWG1Vc(DrawScope drawScope, long j17, long j18) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j17, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j18);
                                }
                            };
                        } else {
                            c13385 = function5;
                        }
                        if (i8 != 0) {
                            f4 = SliderKt.ThumbTrackGapSize;
                        } else {
                            f4 = f;
                        }
                        if (i10 != 0) {
                            f5 = SliderKt.TrackInsideCornerSize;
                        } else {
                            f5 = f3;
                        }
                        i13 = i3;
                        f6 = f4;
                    } else {
                        if (i16 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                            i3 &= -7169;
                        } else {
                            sliderColorsColors = sliderColors2;
                        }
                        if ((i2 & 16) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800875397, "CC(remember):Slider.kt#9igjgp");
                            if (((i3 & 7168) ^ 3072) <= 2048) {
                            }
                            if ((i3 & 896) == 256) {
                                z3 = true;
                            } else {
                                z3 = false;
                            }
                            z4 = z11 | z3;
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z4) {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2818invokeUv8p0NA(DrawScope drawScope, long j17) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j17, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            } else {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2818invokeUv8p0NA(DrawScope drawScope, long j17) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j17, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            function6 = (Function2) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -57345;
                        } else {
                            function6 = function4;
                        }
                        if (i6 != 0) {
                            c13385 = new Function3<DrawScope, Offset, Color, Unit>() {
                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    m2819invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                    return Unit.INSTANCE;
                                }

                                public final void m2819invokewPWG1Vc(DrawScope drawScope, long j17, long j18) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j17, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j18);
                                }
                            };
                        } else {
                            c13385 = function5;
                        }
                        if (i8 != 0) {
                            f4 = SliderKt.ThumbTrackGapSize;
                        } else {
                            f4 = f;
                        }
                        if (i10 != 0) {
                            f5 = SliderKt.TrackInsideCornerSize;
                        } else {
                            f5 = f3;
                        }
                        i13 = i3;
                        f6 = f4;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(49984771, i13, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1128)");
                    }
                    jM2805trackColorWaAFU9c$material3_release = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, false);
                    jM2805trackColorWaAFU9c$material3_release2 = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true);
                    function7 = function6;
                    f7 = f5;
                    jM2804tickColorWaAFU9c$material3_release = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, false);
                    jM2804tickColorWaAFU9c$material3_release2 = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, true);
                    SliderColors sliderColors8 = sliderColorsColors;
                    Modifier modifierM1066height3ABfNKs5 = SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), SliderKt.getTrackHeight());
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection5 = CompositionLocalsKt.getLocalLayoutDirection();
                    Modifier modifier7 = companion;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    objConsume = composerStartRestartGroup.consume(localLayoutDirection5);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (objConsume == LayoutDirection.Rtl) {
                        f8 = 180.0f;
                    } else {
                        f8 = 0.0f;
                    }
                    Modifier modifierRotate5 = RotateKt.rotate(modifierM1066height3ABfNKs5, f8);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800841850, "CC(remember):Slider.kt#9igjgp");
                    boolean z1112 = z2;
                    boolean zChangedInstance5 = composerStartRestartGroup.changedInstance(sliderState) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release2) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release2);
                    if ((i13 & 3670016) == 1048576) {
                        z5 = true;
                    } else {
                        z5 = false;
                    }
                    boolean z1113 = z5 | zChangedInstance5;
                    if ((29360128 & i13) == 8388608) {
                        z6 = true;
                    } else {
                        z6 = false;
                    }
                    boolean z1114 = z1113 | z6;
                    if (((57344 & i13) ^ 24576) > 16384) {
                        function8 = function7;
                        if (composerStartRestartGroup.changed(function8)) {
                            j = jM2805trackColorWaAFU9c$material3_release;
                        }
                        z7 = true;
                        boolean z1115 = z1114 | z7;
                        if ((458752 & i13) == 131072) {
                            z8 = true;
                        } else {
                            z8 = false;
                        }
                        z9 = z1115 | z8;
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z9) {
                            final long j17 = j;
                            final float f116 = f6;
                            final Function2<? super DrawScope, ? super Offset, Unit> function11111 = function8;
                            final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function11112 = c13385;
                            objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j17, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f116, f7, function11111, function11112, false);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            final long j18 = j;
                            final float f117 = f6;
                            final Function2<? super DrawScope, ? super Offset, Unit> function11113 = function8;
                            final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function11114 = c13385;
                            objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j18, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f117, f7, function11113, function11114, false);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CanvasKt.Canvas(modifierRotate5, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        sliderColors3 = sliderColors8;
                        f9 = f6;
                        function9 = function8;
                        function10 = c13385;
                        f10 = f7;
                        z10 = z1112;
                        modifier2 = modifier7;
                    } else {
                        function8 = function7;
                    }
                    j = jM2805trackColorWaAFU9c$material3_release;
                    if ((i13 & 24576) == 16384) {
                        z7 = true;
                    } else {
                        z7 = false;
                    }
                    boolean z1116 = z1114 | z7;
                    if ((458752 & i13) == 131072) {
                        z8 = true;
                    } else {
                        z8 = false;
                    }
                    z9 = z1116 | z8;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z9) {
                        final long j19 = j;
                        final float f118 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function11115 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function11116 = c13385;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j19, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f118, f7, function11115, function11116, false);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        final long j110 = j;
                        final float f119 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function11117 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function11118 = c13385;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j110, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f119, f7, function11117, function11118, false);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CanvasKt.Canvas(modifierRotate5, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    sliderColors3 = sliderColors8;
                    f9 = f6;
                    function9 = function8;
                    function10 = c13385;
                    f10 = f7;
                    z10 = z1112;
                    modifier2 = modifier7;
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

                        public final void invoke(Composer composer2, int i17) {
                            SliderDefaults.this.m2813Track4EFweAY(sliderState, modifier2, z10, sliderColors3, function9, function10, f9, f10, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i12 = 100663296;
            i3 |= i12;
            if ((38347923 & i3) == 38347922) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                        i3 &= -7169;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if ((i2 & 16) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800875397, "CC(remember):Slider.kt#9igjgp");
                        if (((i3 & 7168) ^ 3072) <= 2048) {
                        }
                        if ((i3 & 896) == 256) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z11 | z3;
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2818invokeUv8p0NA(DrawScope drawScope, long j111) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j111, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2818invokeUv8p0NA(DrawScope drawScope, long j111) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j111, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        function6 = (Function2) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -57345;
                    } else {
                        function6 = function4;
                    }
                    if (i6 != 0) {
                        c13385 = new Function3<DrawScope, Offset, Color, Unit>() {
                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                m2819invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                return Unit.INSTANCE;
                            }

                            public final void m2819invokewPWG1Vc(DrawScope drawScope, long j111, long j112) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j111, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j112);
                            }
                        };
                    } else {
                        c13385 = function5;
                    }
                    if (i8 != 0) {
                        f4 = SliderKt.ThumbTrackGapSize;
                    } else {
                        f4 = f;
                    }
                    if (i10 != 0) {
                        f5 = SliderKt.TrackInsideCornerSize;
                    } else {
                        f5 = f3;
                    }
                    i13 = i3;
                    f6 = f4;
                } else {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                        i3 &= -7169;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if ((i2 & 16) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800875397, "CC(remember):Slider.kt#9igjgp");
                        if (((i3 & 7168) ^ 3072) <= 2048) {
                        }
                        if ((i3 & 896) == 256) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z11 | z3;
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2818invokeUv8p0NA(DrawScope drawScope, long j111) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j111, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2818invokeUv8p0NA(DrawScope drawScope, long j111) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j111, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        function6 = (Function2) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -57345;
                    } else {
                        function6 = function4;
                    }
                    if (i6 != 0) {
                        c13385 = new Function3<DrawScope, Offset, Color, Unit>() {
                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                m2819invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                return Unit.INSTANCE;
                            }

                            public final void m2819invokewPWG1Vc(DrawScope drawScope, long j111, long j112) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j111, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j112);
                            }
                        };
                    } else {
                        c13385 = function5;
                    }
                    if (i8 != 0) {
                        f4 = SliderKt.ThumbTrackGapSize;
                    } else {
                        f4 = f;
                    }
                    if (i10 != 0) {
                        f5 = SliderKt.TrackInsideCornerSize;
                    } else {
                        f5 = f3;
                    }
                    i13 = i3;
                    f6 = f4;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(49984771, i13, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1128)");
                }
                jM2805trackColorWaAFU9c$material3_release = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, false);
                jM2805trackColorWaAFU9c$material3_release2 = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true);
                function7 = function6;
                f7 = f5;
                jM2804tickColorWaAFU9c$material3_release = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, false);
                jM2804tickColorWaAFU9c$material3_release2 = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, true);
                SliderColors sliderColors9 = sliderColorsColors;
                Modifier modifierM1066height3ABfNKs6 = SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), SliderKt.getTrackHeight());
                ProvidableCompositionLocal<LayoutDirection> localLayoutDirection6 = CompositionLocalsKt.getLocalLayoutDirection();
                Modifier modifier8 = companion;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                objConsume = composerStartRestartGroup.consume(localLayoutDirection6);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (objConsume == LayoutDirection.Rtl) {
                    f8 = 180.0f;
                } else {
                    f8 = 0.0f;
                }
                Modifier modifierRotate6 = RotateKt.rotate(modifierM1066height3ABfNKs6, f8);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800841850, "CC(remember):Slider.kt#9igjgp");
                boolean z1117 = z2;
                boolean zChangedInstance6 = composerStartRestartGroup.changedInstance(sliderState) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release2) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release2);
                if ((i13 & 3670016) == 1048576) {
                    z5 = true;
                } else {
                    z5 = false;
                }
                boolean z1118 = z5 | zChangedInstance6;
                if ((29360128 & i13) == 8388608) {
                    z6 = true;
                } else {
                    z6 = false;
                }
                boolean z1119 = z1118 | z6;
                if (((57344 & i13) ^ 24576) > 16384) {
                    function8 = function7;
                    if (composerStartRestartGroup.changed(function8)) {
                        j = jM2805trackColorWaAFU9c$material3_release;
                    }
                    z7 = true;
                    boolean z11110 = z1119 | z7;
                    if ((458752 & i13) == 131072) {
                        z8 = true;
                    } else {
                        z8 = false;
                    }
                    z9 = z11110 | z8;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z9) {
                        final long j111 = j;
                        final float f1110 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function11119 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function111110 = c13385;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j111, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f1110, f7, function11119, function111110, false);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        final long j112 = j;
                        final float f1111 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function111111 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function111112 = c13385;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j112, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f1111, f7, function111111, function111112, false);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CanvasKt.Canvas(modifierRotate6, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    sliderColors3 = sliderColors9;
                    f9 = f6;
                    function9 = function8;
                    function10 = c13385;
                    f10 = f7;
                    z10 = z1117;
                    modifier2 = modifier8;
                } else {
                    function8 = function7;
                }
                j = jM2805trackColorWaAFU9c$material3_release;
                if ((i13 & 24576) == 16384) {
                    z7 = true;
                } else {
                    z7 = false;
                }
                boolean z11111 = z1119 | z7;
                if ((458752 & i13) == 131072) {
                    z8 = true;
                } else {
                    z8 = false;
                }
                z9 = z11111 | z8;
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z9) {
                    final long j113 = j;
                    final float f1112 = f6;
                    final Function2<? super DrawScope, ? super Offset, Unit> function111113 = function8;
                    final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function111114 = c13385;
                    objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j113, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f1112, f7, function111113, function111114, false);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    final long j114 = j;
                    final float f1113 = f6;
                    final Function2<? super DrawScope, ? super Offset, Unit> function111115 = function8;
                    final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function111116 = c13385;
                    objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j114, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f1113, f7, function111115, function111116, false);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CanvasKt.Canvas(modifierRotate6, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                sliderColors3 = sliderColors9;
                f9 = f6;
                function9 = function8;
                function10 = c13385;
                f10 = f7;
                z10 = z1117;
                modifier2 = modifier8;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                        i3 &= -7169;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if ((i2 & 16) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800875397, "CC(remember):Slider.kt#9igjgp");
                        if (((i3 & 7168) ^ 3072) <= 2048) {
                        }
                        if ((i3 & 896) == 256) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z11 | z3;
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2818invokeUv8p0NA(DrawScope drawScope, long j115) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j115, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2818invokeUv8p0NA(DrawScope drawScope, long j115) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j115, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        function6 = (Function2) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -57345;
                    } else {
                        function6 = function4;
                    }
                    if (i6 != 0) {
                        c13385 = new Function3<DrawScope, Offset, Color, Unit>() {
                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                m2819invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                return Unit.INSTANCE;
                            }

                            public final void m2819invokewPWG1Vc(DrawScope drawScope, long j115, long j116) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j115, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j116);
                            }
                        };
                    } else {
                        c13385 = function5;
                    }
                    if (i8 != 0) {
                        f4 = SliderKt.ThumbTrackGapSize;
                    } else {
                        f4 = f;
                    }
                    if (i10 != 0) {
                        f5 = SliderKt.TrackInsideCornerSize;
                    } else {
                        f5 = f3;
                    }
                    i13 = i3;
                    f6 = f4;
                } else {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                        i3 &= -7169;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if ((i2 & 16) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800875397, "CC(remember):Slider.kt#9igjgp");
                        if (((i3 & 7168) ^ 3072) <= 2048) {
                        }
                        if ((i3 & 896) == 256) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z11 | z3;
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2818invokeUv8p0NA(DrawScope drawScope, long j115) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j115, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2818invokeUv8p0NA(DrawScope drawScope, long j115) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j115, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        function6 = (Function2) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -57345;
                    } else {
                        function6 = function4;
                    }
                    if (i6 != 0) {
                        c13385 = new Function3<DrawScope, Offset, Color, Unit>() {
                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                m2819invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                return Unit.INSTANCE;
                            }

                            public final void m2819invokewPWG1Vc(DrawScope drawScope, long j115, long j116) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j115, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j116);
                            }
                        };
                    } else {
                        c13385 = function5;
                    }
                    if (i8 != 0) {
                        f4 = SliderKt.ThumbTrackGapSize;
                    } else {
                        f4 = f;
                    }
                    if (i10 != 0) {
                        f5 = SliderKt.TrackInsideCornerSize;
                    } else {
                        f5 = f3;
                    }
                    i13 = i3;
                    f6 = f4;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(49984771, i13, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1128)");
                }
                jM2805trackColorWaAFU9c$material3_release = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, false);
                jM2805trackColorWaAFU9c$material3_release2 = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true);
                function7 = function6;
                f7 = f5;
                jM2804tickColorWaAFU9c$material3_release = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, false);
                jM2804tickColorWaAFU9c$material3_release2 = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, true);
                SliderColors sliderColors10 = sliderColorsColors;
                Modifier modifierM1066height3ABfNKs7 = SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), SliderKt.getTrackHeight());
                ProvidableCompositionLocal<LayoutDirection> localLayoutDirection7 = CompositionLocalsKt.getLocalLayoutDirection();
                Modifier modifier9 = companion;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                objConsume = composerStartRestartGroup.consume(localLayoutDirection7);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (objConsume == LayoutDirection.Rtl) {
                    f8 = 180.0f;
                } else {
                    f8 = 0.0f;
                }
                Modifier modifierRotate7 = RotateKt.rotate(modifierM1066height3ABfNKs7, f8);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800841850, "CC(remember):Slider.kt#9igjgp");
                boolean z11112 = z2;
                boolean zChangedInstance7 = composerStartRestartGroup.changedInstance(sliderState) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release2) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release2);
                if ((i13 & 3670016) == 1048576) {
                    z5 = true;
                } else {
                    z5 = false;
                }
                boolean z11113 = z5 | zChangedInstance7;
                if ((29360128 & i13) == 8388608) {
                    z6 = true;
                } else {
                    z6 = false;
                }
                boolean z11114 = z11113 | z6;
                if (((57344 & i13) ^ 24576) > 16384) {
                    function8 = function7;
                    if (composerStartRestartGroup.changed(function8)) {
                        j = jM2805trackColorWaAFU9c$material3_release;
                    }
                    z7 = true;
                    boolean z11115 = z11114 | z7;
                    if ((458752 & i13) == 131072) {
                        z8 = true;
                    } else {
                        z8 = false;
                    }
                    z9 = z11115 | z8;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z9) {
                        final long j115 = j;
                        final float f1114 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function111117 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function111118 = c13385;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j115, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f1114, f7, function111117, function111118, false);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        final long j116 = j;
                        final float f1115 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function111119 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1111110 = c13385;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j116, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f1115, f7, function111119, function1111110, false);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CanvasKt.Canvas(modifierRotate7, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    sliderColors3 = sliderColors10;
                    f9 = f6;
                    function9 = function8;
                    function10 = c13385;
                    f10 = f7;
                    z10 = z11112;
                    modifier2 = modifier9;
                } else {
                    function8 = function7;
                }
                j = jM2805trackColorWaAFU9c$material3_release;
                if ((i13 & 24576) == 16384) {
                    z7 = true;
                } else {
                    z7 = false;
                }
                boolean z11116 = z11114 | z7;
                if ((458752 & i13) == 131072) {
                    z8 = true;
                } else {
                    z8 = false;
                }
                z9 = z11116 | z8;
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z9) {
                    final long j117 = j;
                    final float f1116 = f6;
                    final Function2<? super DrawScope, ? super Offset, Unit> function1111111 = function8;
                    final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1111112 = c13385;
                    objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j117, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f1116, f7, function1111111, function1111112, false);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    final long j118 = j;
                    final float f1117 = f6;
                    final Function2<? super DrawScope, ? super Offset, Unit> function1111113 = function8;
                    final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1111114 = c13385;
                    objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j118, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f1117, f7, function1111113, function1111114, false);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CanvasKt.Canvas(modifierRotate7, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                sliderColors3 = sliderColors10;
                f9 = f6;
                function9 = function8;
                function10 = c13385;
                f10 = f7;
                z10 = z11112;
                modifier2 = modifier9;
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

                    public final void invoke(Composer composer2, int i17) {
                        SliderDefaults.this.m2813Track4EFweAY(sliderState, modifier2, z10, sliderColors3, function9, function10, f9, f10, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
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
                    sliderColors2 = sliderColors;
                    if (composerStartRestartGroup.changed(sliderColors2)) {
                        i15 = Fields.CameraDistance;
                    }
                    i3 |= i15;
                } else {
                    sliderColors2 = sliderColors;
                }
                i15 = Fields.RotationZ;
                i3 |= i15;
            } else {
                sliderColors2 = sliderColors;
            }
            if ((i & 24576) == 0) {
                if ((i2 & 16) == 0) {
                    function4 = function2;
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i14 = Fields.Clip;
                    }
                    i3 |= i14;
                } else {
                    function4 = function2;
                }
                i14 = Fields.Shape;
                i3 |= i14;
            } else {
                function4 = function2;
            }
            i6 = i2 & 32;
            if (i6 != 0) {
                i3 |= 196608;
                function5 = function3;
            } else {
                function5 = function3;
                if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changedInstance(function5)) {
                        i7 = Fields.RenderEffect;
                    } else {
                        i7 = 65536;
                    }
                    i3 |= i7;
                }
            }
            i8 = i2 & 64;
            if (i8 != 0) {
                i3 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changed(f)) {
                    i9 = 1048576;
                } else {
                    i9 = 524288;
                }
                i3 |= i9;
            }
            i10 = i2 & Fields.SpotShadowColor;
            if (i10 != 0) {
                i3 |= 12582912;
                f3 = f2;
            } else {
                f3 = f2;
                if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(f3)) {
                        i11 = 8388608;
                    } else {
                        i11 = 4194304;
                    }
                    i3 |= i11;
                }
            }
            if ((i2 & Fields.RotationX) != 0) {
                if ((100663296 & i) == 0) {
                    if (composerStartRestartGroup.changed(this)) {
                        i12 = 67108864;
                    } else {
                        i12 = 33554432;
                    }
                }
                if ((38347923 & i3) == 38347922) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i16 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                            i3 &= -7169;
                        } else {
                            sliderColorsColors = sliderColors2;
                        }
                        if ((i2 & 16) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800875397, "CC(remember):Slider.kt#9igjgp");
                            if (((i3 & 7168) ^ 3072) <= 2048) {
                            }
                            if ((i3 & 896) == 256) {
                                z3 = true;
                            } else {
                                z3 = false;
                            }
                            z4 = z11 | z3;
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z4) {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2818invokeUv8p0NA(DrawScope drawScope, long j119) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j119, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            } else {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2818invokeUv8p0NA(DrawScope drawScope, long j119) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j119, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            function6 = (Function2) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -57345;
                        } else {
                            function6 = function4;
                        }
                        if (i6 != 0) {
                            c13385 = new Function3<DrawScope, Offset, Color, Unit>() {
                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    m2819invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                    return Unit.INSTANCE;
                                }

                                public final void m2819invokewPWG1Vc(DrawScope drawScope, long j119, long j1110) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j119, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j1110);
                                }
                            };
                        } else {
                            c13385 = function5;
                        }
                        if (i8 != 0) {
                            f4 = SliderKt.ThumbTrackGapSize;
                        } else {
                            f4 = f;
                        }
                        if (i10 != 0) {
                            f5 = SliderKt.TrackInsideCornerSize;
                        } else {
                            f5 = f3;
                        }
                        i13 = i3;
                        f6 = f4;
                    } else {
                        if (i16 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                            i3 &= -7169;
                        } else {
                            sliderColorsColors = sliderColors2;
                        }
                        if ((i2 & 16) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800875397, "CC(remember):Slider.kt#9igjgp");
                            if (((i3 & 7168) ^ 3072) <= 2048) {
                            }
                            if ((i3 & 896) == 256) {
                                z3 = true;
                            } else {
                                z3 = false;
                            }
                            z4 = z11 | z3;
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z4) {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2818invokeUv8p0NA(DrawScope drawScope, long j119) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j119, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            } else {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2818invokeUv8p0NA(DrawScope drawScope, long j119) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j119, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            function6 = (Function2) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -57345;
                        } else {
                            function6 = function4;
                        }
                        if (i6 != 0) {
                            c13385 = new Function3<DrawScope, Offset, Color, Unit>() {
                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    m2819invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                    return Unit.INSTANCE;
                                }

                                public final void m2819invokewPWG1Vc(DrawScope drawScope, long j119, long j1110) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j119, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j1110);
                                }
                            };
                        } else {
                            c13385 = function5;
                        }
                        if (i8 != 0) {
                            f4 = SliderKt.ThumbTrackGapSize;
                        } else {
                            f4 = f;
                        }
                        if (i10 != 0) {
                            f5 = SliderKt.TrackInsideCornerSize;
                        } else {
                            f5 = f3;
                        }
                        i13 = i3;
                        f6 = f4;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(49984771, i13, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1128)");
                    }
                    jM2805trackColorWaAFU9c$material3_release = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, false);
                    jM2805trackColorWaAFU9c$material3_release2 = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true);
                    function7 = function6;
                    f7 = f5;
                    jM2804tickColorWaAFU9c$material3_release = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, false);
                    jM2804tickColorWaAFU9c$material3_release2 = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, true);
                    SliderColors sliderColors11 = sliderColorsColors;
                    Modifier modifierM1066height3ABfNKs8 = SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), SliderKt.getTrackHeight());
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection8 = CompositionLocalsKt.getLocalLayoutDirection();
                    Modifier modifier10 = companion;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    objConsume = composerStartRestartGroup.consume(localLayoutDirection8);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (objConsume == LayoutDirection.Rtl) {
                        f8 = 180.0f;
                    } else {
                        f8 = 0.0f;
                    }
                    Modifier modifierRotate8 = RotateKt.rotate(modifierM1066height3ABfNKs8, f8);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800841850, "CC(remember):Slider.kt#9igjgp");
                    boolean z11117 = z2;
                    boolean zChangedInstance8 = composerStartRestartGroup.changedInstance(sliderState) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release2) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release2);
                    if ((i13 & 3670016) == 1048576) {
                        z5 = true;
                    } else {
                        z5 = false;
                    }
                    boolean z11118 = z5 | zChangedInstance8;
                    if ((29360128 & i13) == 8388608) {
                        z6 = true;
                    } else {
                        z6 = false;
                    }
                    boolean z11119 = z11118 | z6;
                    if (((57344 & i13) ^ 24576) > 16384) {
                        function8 = function7;
                        if (composerStartRestartGroup.changed(function8)) {
                            j = jM2805trackColorWaAFU9c$material3_release;
                        }
                        z7 = true;
                        boolean z111110 = z11119 | z7;
                        if ((458752 & i13) == 131072) {
                            z8 = true;
                        } else {
                            z8 = false;
                        }
                        z9 = z111110 | z8;
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z9) {
                            final long j119 = j;
                            final float f1118 = f6;
                            final Function2<? super DrawScope, ? super Offset, Unit> function1111115 = function8;
                            final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1111116 = c13385;
                            objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j119, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f1118, f7, function1111115, function1111116, false);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            final long j1110 = j;
                            final float f1119 = f6;
                            final Function2<? super DrawScope, ? super Offset, Unit> function1111117 = function8;
                            final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1111118 = c13385;
                            objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j1110, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f1119, f7, function1111117, function1111118, false);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CanvasKt.Canvas(modifierRotate8, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        sliderColors3 = sliderColors11;
                        f9 = f6;
                        function9 = function8;
                        function10 = c13385;
                        f10 = f7;
                        z10 = z11117;
                        modifier2 = modifier10;
                    } else {
                        function8 = function7;
                    }
                    j = jM2805trackColorWaAFU9c$material3_release;
                    if ((i13 & 24576) == 16384) {
                        z7 = true;
                    } else {
                        z7 = false;
                    }
                    boolean z111111 = z11119 | z7;
                    if ((458752 & i13) == 131072) {
                        z8 = true;
                    } else {
                        z8 = false;
                    }
                    z9 = z111111 | z8;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z9) {
                        final long j1111 = j;
                        final float f11110 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function1111119 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function11111110 = c13385;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j1111, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f11110, f7, function1111119, function11111110, false);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        final long j1112 = j;
                        final float f11111 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function11111111 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function11111112 = c13385;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j1112, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f11111, f7, function11111111, function11111112, false);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CanvasKt.Canvas(modifierRotate8, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    sliderColors3 = sliderColors11;
                    f9 = f6;
                    function9 = function8;
                    function10 = c13385;
                    f10 = f7;
                    z10 = z11117;
                    modifier2 = modifier10;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i16 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                            i3 &= -7169;
                        } else {
                            sliderColorsColors = sliderColors2;
                        }
                        if ((i2 & 16) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800875397, "CC(remember):Slider.kt#9igjgp");
                            if (((i3 & 7168) ^ 3072) <= 2048) {
                            }
                            if ((i3 & 896) == 256) {
                                z3 = true;
                            } else {
                                z3 = false;
                            }
                            z4 = z11 | z3;
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z4) {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2818invokeUv8p0NA(DrawScope drawScope, long j1113) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j1113, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            } else {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2818invokeUv8p0NA(DrawScope drawScope, long j1113) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j1113, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            function6 = (Function2) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -57345;
                        } else {
                            function6 = function4;
                        }
                        if (i6 != 0) {
                            c13385 = new Function3<DrawScope, Offset, Color, Unit>() {
                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    m2819invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                    return Unit.INSTANCE;
                                }

                                public final void m2819invokewPWG1Vc(DrawScope drawScope, long j1113, long j1114) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j1113, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j1114);
                                }
                            };
                        } else {
                            c13385 = function5;
                        }
                        if (i8 != 0) {
                            f4 = SliderKt.ThumbTrackGapSize;
                        } else {
                            f4 = f;
                        }
                        if (i10 != 0) {
                            f5 = SliderKt.TrackInsideCornerSize;
                        } else {
                            f5 = f3;
                        }
                        i13 = i3;
                        f6 = f4;
                    } else {
                        if (i16 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                            i3 &= -7169;
                        } else {
                            sliderColorsColors = sliderColors2;
                        }
                        if ((i2 & 16) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800875397, "CC(remember):Slider.kt#9igjgp");
                            if (((i3 & 7168) ^ 3072) <= 2048) {
                            }
                            if ((i3 & 896) == 256) {
                                z3 = true;
                            } else {
                                z3 = false;
                            }
                            z4 = z11 | z3;
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z4) {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2818invokeUv8p0NA(DrawScope drawScope, long j1113) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j1113, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            } else {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2818invokeUv8p0NA(DrawScope drawScope, long j1113) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j1113, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            function6 = (Function2) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -57345;
                        } else {
                            function6 = function4;
                        }
                        if (i6 != 0) {
                            c13385 = new Function3<DrawScope, Offset, Color, Unit>() {
                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    m2819invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                    return Unit.INSTANCE;
                                }

                                public final void m2819invokewPWG1Vc(DrawScope drawScope, long j1113, long j1114) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j1113, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j1114);
                                }
                            };
                        } else {
                            c13385 = function5;
                        }
                        if (i8 != 0) {
                            f4 = SliderKt.ThumbTrackGapSize;
                        } else {
                            f4 = f;
                        }
                        if (i10 != 0) {
                            f5 = SliderKt.TrackInsideCornerSize;
                        } else {
                            f5 = f3;
                        }
                        i13 = i3;
                        f6 = f4;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(49984771, i13, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1128)");
                    }
                    jM2805trackColorWaAFU9c$material3_release = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, false);
                    jM2805trackColorWaAFU9c$material3_release2 = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true);
                    function7 = function6;
                    f7 = f5;
                    jM2804tickColorWaAFU9c$material3_release = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, false);
                    jM2804tickColorWaAFU9c$material3_release2 = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, true);
                    SliderColors sliderColors12 = sliderColorsColors;
                    Modifier modifierM1066height3ABfNKs9 = SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), SliderKt.getTrackHeight());
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection9 = CompositionLocalsKt.getLocalLayoutDirection();
                    Modifier modifier11 = companion;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    objConsume = composerStartRestartGroup.consume(localLayoutDirection9);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (objConsume == LayoutDirection.Rtl) {
                        f8 = 180.0f;
                    } else {
                        f8 = 0.0f;
                    }
                    Modifier modifierRotate9 = RotateKt.rotate(modifierM1066height3ABfNKs9, f8);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800841850, "CC(remember):Slider.kt#9igjgp");
                    boolean z111112 = z2;
                    boolean zChangedInstance9 = composerStartRestartGroup.changedInstance(sliderState) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release2) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release2);
                    if ((i13 & 3670016) == 1048576) {
                        z5 = true;
                    } else {
                        z5 = false;
                    }
                    boolean z111113 = z5 | zChangedInstance9;
                    if ((29360128 & i13) == 8388608) {
                        z6 = true;
                    } else {
                        z6 = false;
                    }
                    boolean z111114 = z111113 | z6;
                    if (((57344 & i13) ^ 24576) > 16384) {
                        function8 = function7;
                        if (composerStartRestartGroup.changed(function8)) {
                            j = jM2805trackColorWaAFU9c$material3_release;
                        }
                        z7 = true;
                        boolean z111115 = z111114 | z7;
                        if ((458752 & i13) == 131072) {
                            z8 = true;
                        } else {
                            z8 = false;
                        }
                        z9 = z111115 | z8;
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z9) {
                            final long j1113 = j;
                            final float f11112 = f6;
                            final Function2<? super DrawScope, ? super Offset, Unit> function11111113 = function8;
                            final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function11111114 = c13385;
                            objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j1113, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f11112, f7, function11111113, function11111114, false);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            final long j1114 = j;
                            final float f11113 = f6;
                            final Function2<? super DrawScope, ? super Offset, Unit> function11111115 = function8;
                            final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function11111116 = c13385;
                            objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j1114, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f11113, f7, function11111115, function11111116, false);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CanvasKt.Canvas(modifierRotate9, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        sliderColors3 = sliderColors12;
                        f9 = f6;
                        function9 = function8;
                        function10 = c13385;
                        f10 = f7;
                        z10 = z111112;
                        modifier2 = modifier11;
                    } else {
                        function8 = function7;
                    }
                    j = jM2805trackColorWaAFU9c$material3_release;
                    if ((i13 & 24576) == 16384) {
                        z7 = true;
                    } else {
                        z7 = false;
                    }
                    boolean z111116 = z111114 | z7;
                    if ((458752 & i13) == 131072) {
                        z8 = true;
                    } else {
                        z8 = false;
                    }
                    z9 = z111116 | z8;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z9) {
                        final long j1115 = j;
                        final float f11114 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function11111117 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function11111118 = c13385;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j1115, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f11114, f7, function11111117, function11111118, false);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        final long j1116 = j;
                        final float f11115 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function11111119 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function111111110 = c13385;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j1116, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f11115, f7, function11111119, function111111110, false);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CanvasKt.Canvas(modifierRotate9, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    sliderColors3 = sliderColors12;
                    f9 = f6;
                    function9 = function8;
                    function10 = c13385;
                    f10 = f7;
                    z10 = z111112;
                    modifier2 = modifier11;
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

                        public final void invoke(Composer composer2, int i17) {
                            SliderDefaults.this.m2813Track4EFweAY(sliderState, modifier2, z10, sliderColors3, function9, function10, f9, f10, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i12 = 100663296;
            i3 |= i12;
            if ((38347923 & i3) == 38347922) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                        i3 &= -7169;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if ((i2 & 16) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800875397, "CC(remember):Slider.kt#9igjgp");
                        if (((i3 & 7168) ^ 3072) <= 2048) {
                        }
                        if ((i3 & 896) == 256) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z11 | z3;
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2818invokeUv8p0NA(DrawScope drawScope, long j1117) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j1117, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2818invokeUv8p0NA(DrawScope drawScope, long j1117) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j1117, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        function6 = (Function2) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -57345;
                    } else {
                        function6 = function4;
                    }
                    if (i6 != 0) {
                        c13385 = new Function3<DrawScope, Offset, Color, Unit>() {
                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                m2819invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                return Unit.INSTANCE;
                            }

                            public final void m2819invokewPWG1Vc(DrawScope drawScope, long j1117, long j1118) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j1117, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j1118);
                            }
                        };
                    } else {
                        c13385 = function5;
                    }
                    if (i8 != 0) {
                        f4 = SliderKt.ThumbTrackGapSize;
                    } else {
                        f4 = f;
                    }
                    if (i10 != 0) {
                        f5 = SliderKt.TrackInsideCornerSize;
                    } else {
                        f5 = f3;
                    }
                    i13 = i3;
                    f6 = f4;
                } else {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                        i3 &= -7169;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if ((i2 & 16) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800875397, "CC(remember):Slider.kt#9igjgp");
                        if (((i3 & 7168) ^ 3072) <= 2048) {
                        }
                        if ((i3 & 896) == 256) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z11 | z3;
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2818invokeUv8p0NA(DrawScope drawScope, long j1117) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j1117, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2818invokeUv8p0NA(DrawScope drawScope, long j1117) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j1117, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        function6 = (Function2) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -57345;
                    } else {
                        function6 = function4;
                    }
                    if (i6 != 0) {
                        c13385 = new Function3<DrawScope, Offset, Color, Unit>() {
                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                m2819invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                return Unit.INSTANCE;
                            }

                            public final void m2819invokewPWG1Vc(DrawScope drawScope, long j1117, long j1118) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j1117, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j1118);
                            }
                        };
                    } else {
                        c13385 = function5;
                    }
                    if (i8 != 0) {
                        f4 = SliderKt.ThumbTrackGapSize;
                    } else {
                        f4 = f;
                    }
                    if (i10 != 0) {
                        f5 = SliderKt.TrackInsideCornerSize;
                    } else {
                        f5 = f3;
                    }
                    i13 = i3;
                    f6 = f4;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(49984771, i13, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1128)");
                }
                jM2805trackColorWaAFU9c$material3_release = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, false);
                jM2805trackColorWaAFU9c$material3_release2 = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true);
                function7 = function6;
                f7 = f5;
                jM2804tickColorWaAFU9c$material3_release = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, false);
                jM2804tickColorWaAFU9c$material3_release2 = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, true);
                SliderColors sliderColors13 = sliderColorsColors;
                Modifier modifierM1066height3ABfNKs10 = SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), SliderKt.getTrackHeight());
                ProvidableCompositionLocal<LayoutDirection> localLayoutDirection10 = CompositionLocalsKt.getLocalLayoutDirection();
                Modifier modifier12 = companion;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                objConsume = composerStartRestartGroup.consume(localLayoutDirection10);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (objConsume == LayoutDirection.Rtl) {
                    f8 = 180.0f;
                } else {
                    f8 = 0.0f;
                }
                Modifier modifierRotate10 = RotateKt.rotate(modifierM1066height3ABfNKs10, f8);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800841850, "CC(remember):Slider.kt#9igjgp");
                boolean z111117 = z2;
                boolean zChangedInstance10 = composerStartRestartGroup.changedInstance(sliderState) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release2) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release2);
                if ((i13 & 3670016) == 1048576) {
                    z5 = true;
                } else {
                    z5 = false;
                }
                boolean z111118 = z5 | zChangedInstance10;
                if ((29360128 & i13) == 8388608) {
                    z6 = true;
                } else {
                    z6 = false;
                }
                boolean z111119 = z111118 | z6;
                if (((57344 & i13) ^ 24576) > 16384) {
                    function8 = function7;
                    if (composerStartRestartGroup.changed(function8)) {
                        j = jM2805trackColorWaAFU9c$material3_release;
                    }
                    z7 = true;
                    boolean z1111110 = z111119 | z7;
                    if ((458752 & i13) == 131072) {
                        z8 = true;
                    } else {
                        z8 = false;
                    }
                    z9 = z1111110 | z8;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z9) {
                        final long j1117 = j;
                        final float f11116 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function111111111 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function111111112 = c13385;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j1117, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f11116, f7, function111111111, function111111112, false);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        final long j1118 = j;
                        final float f11117 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function111111113 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function111111114 = c13385;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j1118, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f11117, f7, function111111113, function111111114, false);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CanvasKt.Canvas(modifierRotate10, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    sliderColors3 = sliderColors13;
                    f9 = f6;
                    function9 = function8;
                    function10 = c13385;
                    f10 = f7;
                    z10 = z111117;
                    modifier2 = modifier12;
                } else {
                    function8 = function7;
                }
                j = jM2805trackColorWaAFU9c$material3_release;
                if ((i13 & 24576) == 16384) {
                    z7 = true;
                } else {
                    z7 = false;
                }
                boolean z1111111 = z111119 | z7;
                if ((458752 & i13) == 131072) {
                    z8 = true;
                } else {
                    z8 = false;
                }
                z9 = z1111111 | z8;
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z9) {
                    final long j1119 = j;
                    final float f11118 = f6;
                    final Function2<? super DrawScope, ? super Offset, Unit> function111111115 = function8;
                    final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function111111116 = c13385;
                    objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j1119, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f11118, f7, function111111115, function111111116, false);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    final long j11110 = j;
                    final float f11119 = f6;
                    final Function2<? super DrawScope, ? super Offset, Unit> function111111117 = function8;
                    final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function111111118 = c13385;
                    objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j11110, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f11119, f7, function111111117, function111111118, false);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CanvasKt.Canvas(modifierRotate10, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                sliderColors3 = sliderColors13;
                f9 = f6;
                function9 = function8;
                function10 = c13385;
                f10 = f7;
                z10 = z111117;
                modifier2 = modifier12;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                        i3 &= -7169;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if ((i2 & 16) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800875397, "CC(remember):Slider.kt#9igjgp");
                        if (((i3 & 7168) ^ 3072) <= 2048) {
                        }
                        if ((i3 & 896) == 256) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z11 | z3;
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2818invokeUv8p0NA(DrawScope drawScope, long j11111) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j11111, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2818invokeUv8p0NA(DrawScope drawScope, long j11111) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j11111, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        function6 = (Function2) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -57345;
                    } else {
                        function6 = function4;
                    }
                    if (i6 != 0) {
                        c13385 = new Function3<DrawScope, Offset, Color, Unit>() {
                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                m2819invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                return Unit.INSTANCE;
                            }

                            public final void m2819invokewPWG1Vc(DrawScope drawScope, long j11111, long j11112) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j11111, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j11112);
                            }
                        };
                    } else {
                        c13385 = function5;
                    }
                    if (i8 != 0) {
                        f4 = SliderKt.ThumbTrackGapSize;
                    } else {
                        f4 = f;
                    }
                    if (i10 != 0) {
                        f5 = SliderKt.TrackInsideCornerSize;
                    } else {
                        f5 = f3;
                    }
                    i13 = i3;
                    f6 = f4;
                } else {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                        i3 &= -7169;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if ((i2 & 16) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800875397, "CC(remember):Slider.kt#9igjgp");
                        if (((i3 & 7168) ^ 3072) <= 2048) {
                        }
                        if ((i3 & 896) == 256) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z11 | z3;
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2818invokeUv8p0NA(DrawScope drawScope, long j11111) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j11111, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2818invokeUv8p0NA(DrawScope drawScope, long j11111) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j11111, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        function6 = (Function2) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -57345;
                    } else {
                        function6 = function4;
                    }
                    if (i6 != 0) {
                        c13385 = new Function3<DrawScope, Offset, Color, Unit>() {
                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                m2819invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                return Unit.INSTANCE;
                            }

                            public final void m2819invokewPWG1Vc(DrawScope drawScope, long j11111, long j11112) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j11111, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j11112);
                            }
                        };
                    } else {
                        c13385 = function5;
                    }
                    if (i8 != 0) {
                        f4 = SliderKt.ThumbTrackGapSize;
                    } else {
                        f4 = f;
                    }
                    if (i10 != 0) {
                        f5 = SliderKt.TrackInsideCornerSize;
                    } else {
                        f5 = f3;
                    }
                    i13 = i3;
                    f6 = f4;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(49984771, i13, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1128)");
                }
                jM2805trackColorWaAFU9c$material3_release = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, false);
                jM2805trackColorWaAFU9c$material3_release2 = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true);
                function7 = function6;
                f7 = f5;
                jM2804tickColorWaAFU9c$material3_release = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, false);
                jM2804tickColorWaAFU9c$material3_release2 = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, true);
                SliderColors sliderColors14 = sliderColorsColors;
                Modifier modifierM1066height3ABfNKs11 = SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), SliderKt.getTrackHeight());
                ProvidableCompositionLocal<LayoutDirection> localLayoutDirection11 = CompositionLocalsKt.getLocalLayoutDirection();
                Modifier modifier13 = companion;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                objConsume = composerStartRestartGroup.consume(localLayoutDirection11);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (objConsume == LayoutDirection.Rtl) {
                    f8 = 180.0f;
                } else {
                    f8 = 0.0f;
                }
                Modifier modifierRotate11 = RotateKt.rotate(modifierM1066height3ABfNKs11, f8);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800841850, "CC(remember):Slider.kt#9igjgp");
                boolean z1111112 = z2;
                boolean zChangedInstance11 = composerStartRestartGroup.changedInstance(sliderState) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release2) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release2);
                if ((i13 & 3670016) == 1048576) {
                    z5 = true;
                } else {
                    z5 = false;
                }
                boolean z1111113 = z5 | zChangedInstance11;
                if ((29360128 & i13) == 8388608) {
                    z6 = true;
                } else {
                    z6 = false;
                }
                boolean z1111114 = z1111113 | z6;
                if (((57344 & i13) ^ 24576) > 16384) {
                    function8 = function7;
                    if (composerStartRestartGroup.changed(function8)) {
                        j = jM2805trackColorWaAFU9c$material3_release;
                    }
                    z7 = true;
                    boolean z1111115 = z1111114 | z7;
                    if ((458752 & i13) == 131072) {
                        z8 = true;
                    } else {
                        z8 = false;
                    }
                    z9 = z1111115 | z8;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z9) {
                        final long j11111 = j;
                        final float f111110 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function111111119 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1111111110 = c13385;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j11111, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f111110, f7, function111111119, function1111111110, false);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        final long j11112 = j;
                        final float f111111 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function1111111111 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1111111112 = c13385;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j11112, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f111111, f7, function1111111111, function1111111112, false);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CanvasKt.Canvas(modifierRotate11, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    sliderColors3 = sliderColors14;
                    f9 = f6;
                    function9 = function8;
                    function10 = c13385;
                    f10 = f7;
                    z10 = z1111112;
                    modifier2 = modifier13;
                } else {
                    function8 = function7;
                }
                j = jM2805trackColorWaAFU9c$material3_release;
                if ((i13 & 24576) == 16384) {
                    z7 = true;
                } else {
                    z7 = false;
                }
                boolean z1111116 = z1111114 | z7;
                if ((458752 & i13) == 131072) {
                    z8 = true;
                } else {
                    z8 = false;
                }
                z9 = z1111116 | z8;
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z9) {
                    final long j11113 = j;
                    final float f111112 = f6;
                    final Function2<? super DrawScope, ? super Offset, Unit> function1111111113 = function8;
                    final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1111111114 = c13385;
                    objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j11113, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f111112, f7, function1111111113, function1111111114, false);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    final long j11114 = j;
                    final float f111113 = f6;
                    final Function2<? super DrawScope, ? super Offset, Unit> function1111111115 = function8;
                    final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1111111116 = c13385;
                    objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j11114, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f111113, f7, function1111111115, function1111111116, false);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CanvasKt.Canvas(modifierRotate11, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                sliderColors3 = sliderColors14;
                f9 = f6;
                function9 = function8;
                function10 = c13385;
                f10 = f7;
                z10 = z1111112;
                modifier2 = modifier13;
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

                    public final void invoke(Composer composer2, int i17) {
                        SliderDefaults.this.m2813Track4EFweAY(sliderState, modifier2, z10, sliderColors3, function9, function10, f9, f10, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 384;
        z2 = z;
        if ((i & 3072) == 0) {
            if ((i2 & 8) == 0) {
                sliderColors2 = sliderColors;
                if (composerStartRestartGroup.changed(sliderColors2)) {
                    i15 = Fields.CameraDistance;
                }
                i3 |= i15;
            } else {
                sliderColors2 = sliderColors;
            }
            i15 = Fields.RotationZ;
            i3 |= i15;
        } else {
            sliderColors2 = sliderColors;
        }
        if ((i & 24576) == 0) {
            if ((i2 & 16) == 0) {
                function4 = function2;
                if (composerStartRestartGroup.changedInstance(function4)) {
                    i14 = Fields.Clip;
                }
                i3 |= i14;
            } else {
                function4 = function2;
            }
            i14 = Fields.Shape;
            i3 |= i14;
        } else {
            function4 = function2;
        }
        i6 = i2 & 32;
        if (i6 != 0) {
            i3 |= 196608;
            function5 = function3;
        } else {
            function5 = function3;
            if ((i & 196608) == 0) {
                if (composerStartRestartGroup.changedInstance(function5)) {
                    i7 = Fields.RenderEffect;
                } else {
                    i7 = 65536;
                }
                i3 |= i7;
            }
        }
        i8 = i2 & 64;
        if (i8 != 0) {
            i3 |= 1572864;
        } else if ((i & 1572864) == 0) {
            if (composerStartRestartGroup.changed(f)) {
                i9 = 1048576;
            } else {
                i9 = 524288;
            }
            i3 |= i9;
        }
        i10 = i2 & Fields.SpotShadowColor;
        if (i10 != 0) {
            i3 |= 12582912;
            f3 = f2;
        } else {
            f3 = f2;
            if ((i & 12582912) == 0) {
                if (composerStartRestartGroup.changed(f3)) {
                    i11 = 8388608;
                } else {
                    i11 = 4194304;
                }
                i3 |= i11;
            }
        }
        if ((i2 & Fields.RotationX) != 0) {
            if ((100663296 & i) == 0) {
                if (composerStartRestartGroup.changed(this)) {
                    i12 = 67108864;
                } else {
                    i12 = 33554432;
                }
            }
            if ((38347923 & i3) == 38347922) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                        i3 &= -7169;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if ((i2 & 16) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800875397, "CC(remember):Slider.kt#9igjgp");
                        if (((i3 & 7168) ^ 3072) <= 2048) {
                        }
                        if ((i3 & 896) == 256) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z11 | z3;
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2818invokeUv8p0NA(DrawScope drawScope, long j11115) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j11115, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2818invokeUv8p0NA(DrawScope drawScope, long j11115) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j11115, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        function6 = (Function2) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -57345;
                    } else {
                        function6 = function4;
                    }
                    if (i6 != 0) {
                        c13385 = new Function3<DrawScope, Offset, Color, Unit>() {
                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                m2819invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                return Unit.INSTANCE;
                            }

                            public final void m2819invokewPWG1Vc(DrawScope drawScope, long j11115, long j11116) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j11115, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j11116);
                            }
                        };
                    } else {
                        c13385 = function5;
                    }
                    if (i8 != 0) {
                        f4 = SliderKt.ThumbTrackGapSize;
                    } else {
                        f4 = f;
                    }
                    if (i10 != 0) {
                        f5 = SliderKt.TrackInsideCornerSize;
                    } else {
                        f5 = f3;
                    }
                    i13 = i3;
                    f6 = f4;
                } else {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                        i3 &= -7169;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if ((i2 & 16) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800875397, "CC(remember):Slider.kt#9igjgp");
                        if (((i3 & 7168) ^ 3072) <= 2048) {
                        }
                        if ((i3 & 896) == 256) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z11 | z3;
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2818invokeUv8p0NA(DrawScope drawScope, long j11115) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j11115, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2818invokeUv8p0NA(DrawScope drawScope, long j11115) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j11115, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        function6 = (Function2) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -57345;
                    } else {
                        function6 = function4;
                    }
                    if (i6 != 0) {
                        c13385 = new Function3<DrawScope, Offset, Color, Unit>() {
                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                m2819invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                return Unit.INSTANCE;
                            }

                            public final void m2819invokewPWG1Vc(DrawScope drawScope, long j11115, long j11116) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j11115, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j11116);
                            }
                        };
                    } else {
                        c13385 = function5;
                    }
                    if (i8 != 0) {
                        f4 = SliderKt.ThumbTrackGapSize;
                    } else {
                        f4 = f;
                    }
                    if (i10 != 0) {
                        f5 = SliderKt.TrackInsideCornerSize;
                    } else {
                        f5 = f3;
                    }
                    i13 = i3;
                    f6 = f4;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(49984771, i13, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1128)");
                }
                jM2805trackColorWaAFU9c$material3_release = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, false);
                jM2805trackColorWaAFU9c$material3_release2 = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true);
                function7 = function6;
                f7 = f5;
                jM2804tickColorWaAFU9c$material3_release = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, false);
                jM2804tickColorWaAFU9c$material3_release2 = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, true);
                SliderColors sliderColors15 = sliderColorsColors;
                Modifier modifierM1066height3ABfNKs12 = SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), SliderKt.getTrackHeight());
                ProvidableCompositionLocal<LayoutDirection> localLayoutDirection12 = CompositionLocalsKt.getLocalLayoutDirection();
                Modifier modifier14 = companion;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                objConsume = composerStartRestartGroup.consume(localLayoutDirection12);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (objConsume == LayoutDirection.Rtl) {
                    f8 = 180.0f;
                } else {
                    f8 = 0.0f;
                }
                Modifier modifierRotate12 = RotateKt.rotate(modifierM1066height3ABfNKs12, f8);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800841850, "CC(remember):Slider.kt#9igjgp");
                boolean z1111117 = z2;
                boolean zChangedInstance12 = composerStartRestartGroup.changedInstance(sliderState) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release2) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release2);
                if ((i13 & 3670016) == 1048576) {
                    z5 = true;
                } else {
                    z5 = false;
                }
                boolean z1111118 = z5 | zChangedInstance12;
                if ((29360128 & i13) == 8388608) {
                    z6 = true;
                } else {
                    z6 = false;
                }
                boolean z1111119 = z1111118 | z6;
                if (((57344 & i13) ^ 24576) > 16384) {
                    function8 = function7;
                    if (composerStartRestartGroup.changed(function8)) {
                        j = jM2805trackColorWaAFU9c$material3_release;
                    }
                    z7 = true;
                    boolean z11111110 = z1111119 | z7;
                    if ((458752 & i13) == 131072) {
                        z8 = true;
                    } else {
                        z8 = false;
                    }
                    z9 = z11111110 | z8;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z9) {
                        final long j11115 = j;
                        final float f111114 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function1111111117 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1111111118 = c13385;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j11115, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f111114, f7, function1111111117, function1111111118, false);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        final long j11116 = j;
                        final float f111115 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function1111111119 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function11111111110 = c13385;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j11116, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f111115, f7, function1111111119, function11111111110, false);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CanvasKt.Canvas(modifierRotate12, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    sliderColors3 = sliderColors15;
                    f9 = f6;
                    function9 = function8;
                    function10 = c13385;
                    f10 = f7;
                    z10 = z1111117;
                    modifier2 = modifier14;
                } else {
                    function8 = function7;
                }
                j = jM2805trackColorWaAFU9c$material3_release;
                if ((i13 & 24576) == 16384) {
                    z7 = true;
                } else {
                    z7 = false;
                }
                boolean z11111111 = z1111119 | z7;
                if ((458752 & i13) == 131072) {
                    z8 = true;
                } else {
                    z8 = false;
                }
                z9 = z11111111 | z8;
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z9) {
                    final long j11117 = j;
                    final float f111116 = f6;
                    final Function2<? super DrawScope, ? super Offset, Unit> function11111111111 = function8;
                    final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function11111111112 = c13385;
                    objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j11117, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f111116, f7, function11111111111, function11111111112, false);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    final long j11118 = j;
                    final float f111117 = f6;
                    final Function2<? super DrawScope, ? super Offset, Unit> function11111111113 = function8;
                    final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function11111111114 = c13385;
                    objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j11118, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f111117, f7, function11111111113, function11111111114, false);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CanvasKt.Canvas(modifierRotate12, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                sliderColors3 = sliderColors15;
                f9 = f6;
                function9 = function8;
                function10 = c13385;
                f10 = f7;
                z10 = z1111117;
                modifier2 = modifier14;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                        i3 &= -7169;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if ((i2 & 16) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800875397, "CC(remember):Slider.kt#9igjgp");
                        if (((i3 & 7168) ^ 3072) <= 2048) {
                        }
                        if ((i3 & 896) == 256) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z11 | z3;
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2818invokeUv8p0NA(DrawScope drawScope, long j11119) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j11119, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2818invokeUv8p0NA(DrawScope drawScope, long j11119) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j11119, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        function6 = (Function2) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -57345;
                    } else {
                        function6 = function4;
                    }
                    if (i6 != 0) {
                        c13385 = new Function3<DrawScope, Offset, Color, Unit>() {
                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                m2819invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                return Unit.INSTANCE;
                            }

                            public final void m2819invokewPWG1Vc(DrawScope drawScope, long j11119, long j111110) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j11119, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j111110);
                            }
                        };
                    } else {
                        c13385 = function5;
                    }
                    if (i8 != 0) {
                        f4 = SliderKt.ThumbTrackGapSize;
                    } else {
                        f4 = f;
                    }
                    if (i10 != 0) {
                        f5 = SliderKt.TrackInsideCornerSize;
                    } else {
                        f5 = f3;
                    }
                    i13 = i3;
                    f6 = f4;
                } else {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                        i3 &= -7169;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if ((i2 & 16) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800875397, "CC(remember):Slider.kt#9igjgp");
                        if (((i3 & 7168) ^ 3072) <= 2048) {
                        }
                        if ((i3 & 896) == 256) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z11 | z3;
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2818invokeUv8p0NA(DrawScope drawScope, long j11119) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j11119, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2818invokeUv8p0NA(DrawScope drawScope, long j11119) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j11119, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        function6 = (Function2) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -57345;
                    } else {
                        function6 = function4;
                    }
                    if (i6 != 0) {
                        c13385 = new Function3<DrawScope, Offset, Color, Unit>() {
                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                m2819invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                return Unit.INSTANCE;
                            }

                            public final void m2819invokewPWG1Vc(DrawScope drawScope, long j11119, long j111110) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j11119, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j111110);
                            }
                        };
                    } else {
                        c13385 = function5;
                    }
                    if (i8 != 0) {
                        f4 = SliderKt.ThumbTrackGapSize;
                    } else {
                        f4 = f;
                    }
                    if (i10 != 0) {
                        f5 = SliderKt.TrackInsideCornerSize;
                    } else {
                        f5 = f3;
                    }
                    i13 = i3;
                    f6 = f4;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(49984771, i13, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1128)");
                }
                jM2805trackColorWaAFU9c$material3_release = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, false);
                jM2805trackColorWaAFU9c$material3_release2 = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true);
                function7 = function6;
                f7 = f5;
                jM2804tickColorWaAFU9c$material3_release = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, false);
                jM2804tickColorWaAFU9c$material3_release2 = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, true);
                SliderColors sliderColors16 = sliderColorsColors;
                Modifier modifierM1066height3ABfNKs13 = SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), SliderKt.getTrackHeight());
                ProvidableCompositionLocal<LayoutDirection> localLayoutDirection13 = CompositionLocalsKt.getLocalLayoutDirection();
                Modifier modifier15 = companion;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                objConsume = composerStartRestartGroup.consume(localLayoutDirection13);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (objConsume == LayoutDirection.Rtl) {
                    f8 = 180.0f;
                } else {
                    f8 = 0.0f;
                }
                Modifier modifierRotate13 = RotateKt.rotate(modifierM1066height3ABfNKs13, f8);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800841850, "CC(remember):Slider.kt#9igjgp");
                boolean z11111112 = z2;
                boolean zChangedInstance13 = composerStartRestartGroup.changedInstance(sliderState) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release2) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release2);
                if ((i13 & 3670016) == 1048576) {
                    z5 = true;
                } else {
                    z5 = false;
                }
                boolean z11111113 = z5 | zChangedInstance13;
                if ((29360128 & i13) == 8388608) {
                    z6 = true;
                } else {
                    z6 = false;
                }
                boolean z11111114 = z11111113 | z6;
                if (((57344 & i13) ^ 24576) > 16384) {
                    function8 = function7;
                    if (composerStartRestartGroup.changed(function8)) {
                        j = jM2805trackColorWaAFU9c$material3_release;
                    }
                    z7 = true;
                    boolean z11111115 = z11111114 | z7;
                    if ((458752 & i13) == 131072) {
                        z8 = true;
                    } else {
                        z8 = false;
                    }
                    z9 = z11111115 | z8;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z9) {
                        final long j11119 = j;
                        final float f111118 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function11111111115 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function11111111116 = c13385;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j11119, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f111118, f7, function11111111115, function11111111116, false);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        final long j111110 = j;
                        final float f111119 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function11111111117 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function11111111118 = c13385;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j111110, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f111119, f7, function11111111117, function11111111118, false);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CanvasKt.Canvas(modifierRotate13, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    sliderColors3 = sliderColors16;
                    f9 = f6;
                    function9 = function8;
                    function10 = c13385;
                    f10 = f7;
                    z10 = z11111112;
                    modifier2 = modifier15;
                } else {
                    function8 = function7;
                }
                j = jM2805trackColorWaAFU9c$material3_release;
                if ((i13 & 24576) == 16384) {
                    z7 = true;
                } else {
                    z7 = false;
                }
                boolean z11111116 = z11111114 | z7;
                if ((458752 & i13) == 131072) {
                    z8 = true;
                } else {
                    z8 = false;
                }
                z9 = z11111116 | z8;
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z9) {
                    final long j111111 = j;
                    final float f1111110 = f6;
                    final Function2<? super DrawScope, ? super Offset, Unit> function11111111119 = function8;
                    final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function111111111110 = c13385;
                    objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j111111, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f1111110, f7, function11111111119, function111111111110, false);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    final long j111112 = j;
                    final float f1111111 = f6;
                    final Function2<? super DrawScope, ? super Offset, Unit> function111111111111 = function8;
                    final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function111111111112 = c13385;
                    objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j111112, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f1111111, f7, function111111111111, function111111111112, false);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CanvasKt.Canvas(modifierRotate13, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                sliderColors3 = sliderColors16;
                f9 = f6;
                function9 = function8;
                function10 = c13385;
                f10 = f7;
                z10 = z11111112;
                modifier2 = modifier15;
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

                    public final void invoke(Composer composer2, int i17) {
                        SliderDefaults.this.m2813Track4EFweAY(sliderState, modifier2, z10, sliderColors3, function9, function10, f9, f10, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i12 = 100663296;
        i3 |= i12;
        if ((38347923 & i3) == 38347922) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i16 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i4 != 0) {
                    z2 = true;
                }
                if ((i2 & 8) != 0) {
                    sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                    i3 &= -7169;
                } else {
                    sliderColorsColors = sliderColors2;
                }
                if ((i2 & 16) != 0) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800875397, "CC(remember):Slider.kt#9igjgp");
                    if (((i3 & 7168) ^ 3072) <= 2048) {
                    }
                    if ((i3 & 896) == 256) {
                        z3 = true;
                    } else {
                        z3 = false;
                    }
                    z4 = z11 | z3;
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                return Unit.INSTANCE;
                            }

                            public final void m2818invokeUv8p0NA(DrawScope drawScope, long j111113) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j111113, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                return Unit.INSTANCE;
                            }

                            public final void m2818invokeUv8p0NA(DrawScope drawScope, long j111113) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j111113, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    function6 = (Function2) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    i3 &= -57345;
                } else {
                    function6 = function4;
                }
                if (i6 != 0) {
                    c13385 = new Function3<DrawScope, Offset, Color, Unit>() {
                        public Object invoke(Object obj, Object obj2, Object obj3) {
                            m2819invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                            return Unit.INSTANCE;
                        }

                        public final void m2819invokewPWG1Vc(DrawScope drawScope, long j111113, long j111114) {
                            SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j111113, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j111114);
                        }
                    };
                } else {
                    c13385 = function5;
                }
                if (i8 != 0) {
                    f4 = SliderKt.ThumbTrackGapSize;
                } else {
                    f4 = f;
                }
                if (i10 != 0) {
                    f5 = SliderKt.TrackInsideCornerSize;
                } else {
                    f5 = f3;
                }
                i13 = i3;
                f6 = f4;
            } else {
                if (i16 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i4 != 0) {
                    z2 = true;
                }
                if ((i2 & 8) != 0) {
                    sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                    i3 &= -7169;
                } else {
                    sliderColorsColors = sliderColors2;
                }
                if ((i2 & 16) != 0) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800875397, "CC(remember):Slider.kt#9igjgp");
                    if (((i3 & 7168) ^ 3072) <= 2048) {
                    }
                    if ((i3 & 896) == 256) {
                        z3 = true;
                    } else {
                        z3 = false;
                    }
                    z4 = z11 | z3;
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                return Unit.INSTANCE;
                            }

                            public final void m2818invokeUv8p0NA(DrawScope drawScope, long j111113) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j111113, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                return Unit.INSTANCE;
                            }

                            public final void m2818invokeUv8p0NA(DrawScope drawScope, long j111113) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j111113, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    function6 = (Function2) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    i3 &= -57345;
                } else {
                    function6 = function4;
                }
                if (i6 != 0) {
                    c13385 = new Function3<DrawScope, Offset, Color, Unit>() {
                        public Object invoke(Object obj, Object obj2, Object obj3) {
                            m2819invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                            return Unit.INSTANCE;
                        }

                        public final void m2819invokewPWG1Vc(DrawScope drawScope, long j111113, long j111114) {
                            SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j111113, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j111114);
                        }
                    };
                } else {
                    c13385 = function5;
                }
                if (i8 != 0) {
                    f4 = SliderKt.ThumbTrackGapSize;
                } else {
                    f4 = f;
                }
                if (i10 != 0) {
                    f5 = SliderKt.TrackInsideCornerSize;
                } else {
                    f5 = f3;
                }
                i13 = i3;
                f6 = f4;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(49984771, i13, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1128)");
            }
            jM2805trackColorWaAFU9c$material3_release = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, false);
            jM2805trackColorWaAFU9c$material3_release2 = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true);
            function7 = function6;
            f7 = f5;
            jM2804tickColorWaAFU9c$material3_release = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, false);
            jM2804tickColorWaAFU9c$material3_release2 = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, true);
            SliderColors sliderColors17 = sliderColorsColors;
            Modifier modifierM1066height3ABfNKs14 = SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), SliderKt.getTrackHeight());
            ProvidableCompositionLocal<LayoutDirection> localLayoutDirection14 = CompositionLocalsKt.getLocalLayoutDirection();
            Modifier modifier16 = companion;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            objConsume = composerStartRestartGroup.consume(localLayoutDirection14);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            if (objConsume == LayoutDirection.Rtl) {
                f8 = 180.0f;
            } else {
                f8 = 0.0f;
            }
            Modifier modifierRotate14 = RotateKt.rotate(modifierM1066height3ABfNKs14, f8);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800841850, "CC(remember):Slider.kt#9igjgp");
            boolean z11111117 = z2;
            boolean zChangedInstance14 = composerStartRestartGroup.changedInstance(sliderState) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release2) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release2);
            if ((i13 & 3670016) == 1048576) {
                z5 = true;
            } else {
                z5 = false;
            }
            boolean z11111118 = z5 | zChangedInstance14;
            if ((29360128 & i13) == 8388608) {
                z6 = true;
            } else {
                z6 = false;
            }
            boolean z11111119 = z11111118 | z6;
            if (((57344 & i13) ^ 24576) > 16384) {
                function8 = function7;
                if (composerStartRestartGroup.changed(function8)) {
                    j = jM2805trackColorWaAFU9c$material3_release;
                }
                z7 = true;
                boolean z111111110 = z11111119 | z7;
                if ((458752 & i13) == 131072) {
                    z8 = true;
                } else {
                    z8 = false;
                }
                z9 = z111111110 | z8;
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z9) {
                    final long j111113 = j;
                    final float f1111112 = f6;
                    final Function2<? super DrawScope, ? super Offset, Unit> function111111111113 = function8;
                    final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function111111111114 = c13385;
                    objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j111113, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f1111112, f7, function111111111113, function111111111114, false);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    final long j111114 = j;
                    final float f1111113 = f6;
                    final Function2<? super DrawScope, ? super Offset, Unit> function111111111115 = function8;
                    final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function111111111116 = c13385;
                    objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j111114, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f1111113, f7, function111111111115, function111111111116, false);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CanvasKt.Canvas(modifierRotate14, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                sliderColors3 = sliderColors17;
                f9 = f6;
                function9 = function8;
                function10 = c13385;
                f10 = f7;
                z10 = z11111117;
                modifier2 = modifier16;
            } else {
                function8 = function7;
            }
            j = jM2805trackColorWaAFU9c$material3_release;
            if ((i13 & 24576) == 16384) {
                z7 = true;
            } else {
                z7 = false;
            }
            boolean z111111111 = z11111119 | z7;
            if ((458752 & i13) == 131072) {
                z8 = true;
            } else {
                z8 = false;
            }
            z9 = z111111111 | z8;
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (!z9) {
                final long j111115 = j;
                final float f1111114 = f6;
                final Function2<? super DrawScope, ? super Offset, Unit> function111111111117 = function8;
                final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function111111111118 = c13385;
                objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((DrawScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(DrawScope drawScope) {
                        SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j111115, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f1111114, f7, function111111111117, function111111111118, false);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            } else {
                final long j111116 = j;
                final float f1111115 = f6;
                final Function2<? super DrawScope, ? super Offset, Unit> function111111111119 = function8;
                final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1111111111110 = c13385;
                objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((DrawScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(DrawScope drawScope) {
                        SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j111116, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f1111115, f7, function111111111119, function1111111111110, false);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            CanvasKt.Canvas(modifierRotate14, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            sliderColors3 = sliderColors17;
            f9 = f6;
            function9 = function8;
            function10 = c13385;
            f10 = f7;
            z10 = z11111117;
            modifier2 = modifier16;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i16 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i4 != 0) {
                    z2 = true;
                }
                if ((i2 & 8) != 0) {
                    sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                    i3 &= -7169;
                } else {
                    sliderColorsColors = sliderColors2;
                }
                if ((i2 & 16) != 0) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800875397, "CC(remember):Slider.kt#9igjgp");
                    if (((i3 & 7168) ^ 3072) <= 2048) {
                    }
                    if ((i3 & 896) == 256) {
                        z3 = true;
                    } else {
                        z3 = false;
                    }
                    z4 = z11 | z3;
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                return Unit.INSTANCE;
                            }

                            public final void m2818invokeUv8p0NA(DrawScope drawScope, long j111117) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j111117, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                return Unit.INSTANCE;
                            }

                            public final void m2818invokeUv8p0NA(DrawScope drawScope, long j111117) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j111117, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    function6 = (Function2) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    i3 &= -57345;
                } else {
                    function6 = function4;
                }
                if (i6 != 0) {
                    c13385 = new Function3<DrawScope, Offset, Color, Unit>() {
                        public Object invoke(Object obj, Object obj2, Object obj3) {
                            m2819invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                            return Unit.INSTANCE;
                        }

                        public final void m2819invokewPWG1Vc(DrawScope drawScope, long j111117, long j111118) {
                            SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j111117, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j111118);
                        }
                    };
                } else {
                    c13385 = function5;
                }
                if (i8 != 0) {
                    f4 = SliderKt.ThumbTrackGapSize;
                } else {
                    f4 = f;
                }
                if (i10 != 0) {
                    f5 = SliderKt.TrackInsideCornerSize;
                } else {
                    f5 = f3;
                }
                i13 = i3;
                f6 = f4;
            } else {
                if (i16 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i4 != 0) {
                    z2 = true;
                }
                if ((i2 & 8) != 0) {
                    sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                    i3 &= -7169;
                } else {
                    sliderColorsColors = sliderColors2;
                }
                if ((i2 & 16) != 0) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800875397, "CC(remember):Slider.kt#9igjgp");
                    if (((i3 & 7168) ^ 3072) <= 2048) {
                    }
                    if ((i3 & 896) == 256) {
                        z3 = true;
                    } else {
                        z3 = false;
                    }
                    z4 = z11 | z3;
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                return Unit.INSTANCE;
                            }

                            public final void m2818invokeUv8p0NA(DrawScope drawScope, long j111117) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j111117, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                m2818invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                return Unit.INSTANCE;
                            }

                            public final void m2818invokeUv8p0NA(DrawScope drawScope, long j111117) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j111117, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    function6 = (Function2) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    i3 &= -57345;
                } else {
                    function6 = function4;
                }
                if (i6 != 0) {
                    c13385 = new Function3<DrawScope, Offset, Color, Unit>() {
                        public Object invoke(Object obj, Object obj2, Object obj3) {
                            m2819invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                            return Unit.INSTANCE;
                        }

                        public final void m2819invokewPWG1Vc(DrawScope drawScope, long j111117, long j111118) {
                            SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j111117, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j111118);
                        }
                    };
                } else {
                    c13385 = function5;
                }
                if (i8 != 0) {
                    f4 = SliderKt.ThumbTrackGapSize;
                } else {
                    f4 = f;
                }
                if (i10 != 0) {
                    f5 = SliderKt.TrackInsideCornerSize;
                } else {
                    f5 = f3;
                }
                i13 = i3;
                f6 = f4;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(49984771, i13, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1128)");
            }
            jM2805trackColorWaAFU9c$material3_release = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, false);
            jM2805trackColorWaAFU9c$material3_release2 = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true);
            function7 = function6;
            f7 = f5;
            jM2804tickColorWaAFU9c$material3_release = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, false);
            jM2804tickColorWaAFU9c$material3_release2 = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, true);
            SliderColors sliderColors18 = sliderColorsColors;
            Modifier modifierM1066height3ABfNKs15 = SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), SliderKt.getTrackHeight());
            ProvidableCompositionLocal<LayoutDirection> localLayoutDirection15 = CompositionLocalsKt.getLocalLayoutDirection();
            Modifier modifier17 = companion;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            objConsume = composerStartRestartGroup.consume(localLayoutDirection15);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            if (objConsume == LayoutDirection.Rtl) {
                f8 = 180.0f;
            } else {
                f8 = 0.0f;
            }
            Modifier modifierRotate15 = RotateKt.rotate(modifierM1066height3ABfNKs15, f8);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800841850, "CC(remember):Slider.kt#9igjgp");
            boolean z111111112 = z2;
            boolean zChangedInstance15 = composerStartRestartGroup.changedInstance(sliderState) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release2) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release2);
            if ((i13 & 3670016) == 1048576) {
                z5 = true;
            } else {
                z5 = false;
            }
            boolean z111111113 = z5 | zChangedInstance15;
            if ((29360128 & i13) == 8388608) {
                z6 = true;
            } else {
                z6 = false;
            }
            boolean z111111114 = z111111113 | z6;
            if (((57344 & i13) ^ 24576) > 16384) {
                function8 = function7;
                if (composerStartRestartGroup.changed(function8)) {
                    j = jM2805trackColorWaAFU9c$material3_release;
                }
                z7 = true;
                boolean z111111115 = z111111114 | z7;
                if ((458752 & i13) == 131072) {
                    z8 = true;
                } else {
                    z8 = false;
                }
                z9 = z111111115 | z8;
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z9) {
                    final long j111117 = j;
                    final float f1111116 = f6;
                    final Function2<? super DrawScope, ? super Offset, Unit> function1111111111111 = function8;
                    final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1111111111112 = c13385;
                    objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j111117, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f1111116, f7, function1111111111111, function1111111111112, false);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    final long j111118 = j;
                    final float f1111117 = f6;
                    final Function2<? super DrawScope, ? super Offset, Unit> function1111111111113 = function8;
                    final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1111111111114 = c13385;
                    objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j111118, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f1111117, f7, function1111111111113, function1111111111114, false);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CanvasKt.Canvas(modifierRotate15, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                sliderColors3 = sliderColors18;
                f9 = f6;
                function9 = function8;
                function10 = c13385;
                f10 = f7;
                z10 = z111111112;
                modifier2 = modifier17;
            } else {
                function8 = function7;
            }
            j = jM2805trackColorWaAFU9c$material3_release;
            if ((i13 & 24576) == 16384) {
                z7 = true;
            } else {
                z7 = false;
            }
            boolean z111111116 = z111111114 | z7;
            if ((458752 & i13) == 131072) {
                z8 = true;
            } else {
                z8 = false;
            }
            z9 = z111111116 | z8;
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (!z9) {
                final long j111119 = j;
                final float f1111118 = f6;
                final Function2<? super DrawScope, ? super Offset, Unit> function1111111111115 = function8;
                final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1111111111116 = c13385;
                objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((DrawScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(DrawScope drawScope) {
                        SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j111119, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f1111118, f7, function1111111111115, function1111111111116, false);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            } else {
                final long j1111110 = j;
                final float f1111119 = f6;
                final Function2<? super DrawScope, ? super Offset, Unit> function1111111111117 = function8;
                final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1111111111118 = c13385;
                objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((DrawScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(DrawScope drawScope) {
                        SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, sliderState.getTickFractions(), 0.0f, sliderState.getCoercedValueAsFraction$material3_release(), j1111110, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(sliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(0), drawScope.toDp-u2uoSUM(sliderState.getThumbWidth$material3_release()), f1111119, f7, function1111111111117, function1111111111118, false);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            CanvasKt.Canvas(modifierRotate15, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            sliderColors3 = sliderColors18;
            f9 = f6;
            function9 = function8;
            function10 = c13385;
            f10 = f7;
            z10 = z111111112;
            modifier2 = modifier17;
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

                public final void invoke(Composer composer2, int i17) {
                    SliderDefaults.this.m2813Track4EFweAY(sliderState, modifier2, z10, sliderColors3, function9, function10, f9, f10, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Use the overload that takes `drawStopIndicator`, `drawTick`, `thumbTrackGapSize` and `trackInsideCornerSize`, see `LegacyRangeSliderSample` on how to restore the previous behavior", replaceWith = @ReplaceWith(expression = "Track(rangeSliderState, modifier, colors, enabled, drawStopIndicator, drawTick, thumbTrackGapSize, trackInsideCornerSize)", imports = {}))
    public final void Track(final RangeSliderState rangeSliderState, Modifier modifier, SliderColors sliderColors, boolean z, Composer composer, final int i, final int i2) {
        int i3;
        final Modifier modifier2;
        final SliderColors sliderColors2;
        int i4;
        boolean z2;
        int i5;
        int i6;
        Modifier.Companion companion;
        SliderColors sliderColorsColors;
        Modifier modifier3;
        SliderColors sliderColors3;
        boolean z3;
        final boolean z4;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i7;
        Composer composerStartRestartGroup = composer.startRestartGroup(-1617869097);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(Track)P(3,2)1187@52807L8,1190@52865L218:Slider.kt#uh7d8r");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changedInstance(rangeSliderState) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i8 = i2 & 2;
        if (i8 == 0) {
            if ((i & 48) == 0) {
                modifier2 = modifier;
                i3 |= composerStartRestartGroup.changed(modifier2) ? 32 : 16;
            }
            if ((i & 384) == 0) {
                if ((i2 & 4) == 0) {
                    sliderColors2 = sliderColors;
                    if (composerStartRestartGroup.changed(sliderColors2)) {
                        i7 = Fields.RotationX;
                    }
                    i3 |= i7;
                } else {
                    sliderColors2 = sliderColors;
                }
                i7 = Fields.SpotShadowColor;
                i3 |= i7;
            } else {
                sliderColors2 = sliderColors;
            }
            i4 = i2 & 8;
            if (i4 != 0) {
                if ((i & 3072) == 0) {
                    z2 = z;
                    if (composerStartRestartGroup.changed(z2)) {
                        i5 = Fields.CameraDistance;
                    } else {
                        i5 = Fields.RotationZ;
                    }
                    i3 |= i5;
                }
                if ((i2 & 16) != 0) {
                    i3 |= 24576;
                } else if ((i & 24576) == 0) {
                    if (composerStartRestartGroup.changed(this)) {
                        i6 = Fields.Clip;
                    } else {
                        i6 = Fields.Shape;
                    }
                    i3 |= i6;
                }
                if ((i3 & 9363) == 9362 || !composerStartRestartGroup.getSkipping()) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                        if (i8 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i2 & 4) != 0) {
                            sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 12) & 14);
                            i3 &= -897;
                        } else {
                            sliderColorsColors = sliderColors2;
                        }
                        if (i4 != 0) {
                            modifier3 = companion;
                            sliderColors3 = sliderColorsColors;
                            z3 = true;
                        } else {
                            modifier3 = companion;
                            sliderColors3 = sliderColorsColors;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1617869097, i3, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1189)");
                        }
                        m2812Track4EFweAY(rangeSliderState, modifier3, z3, sliderColors3, (Function2<? super DrawScope, ? super Offset, Unit>) null, (Function3<? super DrawScope, ? super Offset, ? super Color, Unit>) null, SliderKt.ThumbTrackGapSize, SliderKt.TrackInsideCornerSize, composerStartRestartGroup, (i3 & 14) | 14155776 | (i3 & 112) | ((i3 >> 3) & 896) | ((i3 << 3) & 7168) | ((i3 << 12) & 234881024), 48);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier2 = modifier3;
                        sliderColors2 = sliderColors3;
                        z4 = z3;
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        if ((i2 & 4) != 0) {
                            i3 &= -897;
                        }
                        modifier3 = modifier2;
                        sliderColors3 = sliderColors2;
                    }
                    z3 = z2;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1617869097, i3, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1189)");
                    }
                    m2812Track4EFweAY(rangeSliderState, modifier3, z3, sliderColors3, (Function2<? super DrawScope, ? super Offset, Unit>) null, (Function3<? super DrawScope, ? super Offset, ? super Color, Unit>) null, SliderKt.ThumbTrackGapSize, SliderKt.TrackInsideCornerSize, composerStartRestartGroup, (i3 & 14) | 14155776 | (i3 & 112) | ((i3 >> 3) & 896) | ((i3 << 3) & 7168) | ((i3 << 12) & 234881024), 48);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = modifier3;
                    sliderColors2 = sliderColors3;
                    z4 = z3;
                } else {
                    composerStartRestartGroup.skipToGroupEnd();
                    z4 = z2;
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

                        public final void invoke(Composer composer2, int i9) {
                            SliderDefaults.this.Track(rangeSliderState, modifier2, sliderColors2, z4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            z2 = z;
            if ((i2 & 16) != 0) {
                i3 |= 24576;
            } else if ((i & 24576) == 0) {
                if (composerStartRestartGroup.changed(this)) {
                    i6 = Fields.Clip;
                } else {
                    i6 = Fields.Shape;
                }
                i3 |= i6;
            }
            if ((i3 & 9363) == 9362) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i8 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 4) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 12) & 14);
                        i3 &= -897;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if (i4 != 0) {
                        modifier3 = companion;
                        sliderColors3 = sliderColorsColors;
                        z3 = true;
                    } else {
                        modifier3 = companion;
                        sliderColors3 = sliderColorsColors;
                        z3 = z2;
                    }
                } else {
                    if (i8 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 4) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 12) & 14);
                        i3 &= -897;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if (i4 != 0) {
                        modifier3 = companion;
                        sliderColors3 = sliderColorsColors;
                        z3 = true;
                    } else {
                        modifier3 = companion;
                        sliderColors3 = sliderColorsColors;
                        z3 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1617869097, i3, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1189)");
                }
                m2812Track4EFweAY(rangeSliderState, modifier3, z3, sliderColors3, (Function2<? super DrawScope, ? super Offset, Unit>) null, (Function3<? super DrawScope, ? super Offset, ? super Color, Unit>) null, SliderKt.ThumbTrackGapSize, SliderKt.TrackInsideCornerSize, composerStartRestartGroup, (i3 & 14) | 14155776 | (i3 & 112) | ((i3 >> 3) & 896) | ((i3 << 3) & 7168) | ((i3 << 12) & 234881024), 48);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = modifier3;
                sliderColors2 = sliderColors3;
                z4 = z3;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i8 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 4) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 12) & 14);
                        i3 &= -897;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if (i4 != 0) {
                        modifier3 = companion;
                        sliderColors3 = sliderColorsColors;
                        z3 = true;
                    } else {
                        modifier3 = companion;
                        sliderColors3 = sliderColorsColors;
                        z3 = z2;
                    }
                } else {
                    if (i8 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 4) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 12) & 14);
                        i3 &= -897;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if (i4 != 0) {
                        modifier3 = companion;
                        sliderColors3 = sliderColorsColors;
                        z3 = true;
                    } else {
                        modifier3 = companion;
                        sliderColors3 = sliderColorsColors;
                        z3 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1617869097, i3, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1189)");
                }
                m2812Track4EFweAY(rangeSliderState, modifier3, z3, sliderColors3, (Function2<? super DrawScope, ? super Offset, Unit>) null, (Function3<? super DrawScope, ? super Offset, ? super Color, Unit>) null, SliderKt.ThumbTrackGapSize, SliderKt.TrackInsideCornerSize, composerStartRestartGroup, (i3 & 14) | 14155776 | (i3 & 112) | ((i3 >> 3) & 896) | ((i3 << 3) & 7168) | ((i3 << 12) & 234881024), 48);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = modifier3;
                sliderColors2 = sliderColors3;
                z4 = z3;
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

                    public final void invoke(Composer composer2, int i9) {
                        SliderDefaults.this.Track(rangeSliderState, modifier2, sliderColors2, z4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        modifier2 = modifier;
        if ((i & 384) == 0) {
            if ((i2 & 4) == 0) {
                sliderColors2 = sliderColors;
                if (composerStartRestartGroup.changed(sliderColors2)) {
                    i7 = Fields.RotationX;
                }
                i3 |= i7;
            } else {
                sliderColors2 = sliderColors;
            }
            i7 = Fields.SpotShadowColor;
            i3 |= i7;
        } else {
            sliderColors2 = sliderColors;
        }
        i4 = i2 & 8;
        if (i4 != 0) {
            if ((i & 3072) == 0) {
                z2 = z;
                if (composerStartRestartGroup.changed(z2)) {
                    i5 = Fields.CameraDistance;
                } else {
                    i5 = Fields.RotationZ;
                }
                i3 |= i5;
            }
            if ((i2 & 16) != 0) {
                i3 |= 24576;
            } else if ((i & 24576) == 0) {
                if (composerStartRestartGroup.changed(this)) {
                    i6 = Fields.Clip;
                } else {
                    i6 = Fields.Shape;
                }
                i3 |= i6;
            }
            if ((i3 & 9363) == 9362) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i8 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 4) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 12) & 14);
                        i3 &= -897;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if (i4 != 0) {
                        modifier3 = companion;
                        sliderColors3 = sliderColorsColors;
                        z3 = true;
                    } else {
                        modifier3 = companion;
                        sliderColors3 = sliderColorsColors;
                        z3 = z2;
                    }
                } else {
                    if (i8 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 4) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 12) & 14);
                        i3 &= -897;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if (i4 != 0) {
                        modifier3 = companion;
                        sliderColors3 = sliderColorsColors;
                        z3 = true;
                    } else {
                        modifier3 = companion;
                        sliderColors3 = sliderColorsColors;
                        z3 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1617869097, i3, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1189)");
                }
                m2812Track4EFweAY(rangeSliderState, modifier3, z3, sliderColors3, (Function2<? super DrawScope, ? super Offset, Unit>) null, (Function3<? super DrawScope, ? super Offset, ? super Color, Unit>) null, SliderKt.ThumbTrackGapSize, SliderKt.TrackInsideCornerSize, composerStartRestartGroup, (i3 & 14) | 14155776 | (i3 & 112) | ((i3 >> 3) & 896) | ((i3 << 3) & 7168) | ((i3 << 12) & 234881024), 48);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = modifier3;
                sliderColors2 = sliderColors3;
                z4 = z3;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i8 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 4) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 12) & 14);
                        i3 &= -897;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if (i4 != 0) {
                        modifier3 = companion;
                        sliderColors3 = sliderColorsColors;
                        z3 = true;
                    } else {
                        modifier3 = companion;
                        sliderColors3 = sliderColorsColors;
                        z3 = z2;
                    }
                } else {
                    if (i8 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 4) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 12) & 14);
                        i3 &= -897;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if (i4 != 0) {
                        modifier3 = companion;
                        sliderColors3 = sliderColorsColors;
                        z3 = true;
                    } else {
                        modifier3 = companion;
                        sliderColors3 = sliderColorsColors;
                        z3 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1617869097, i3, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1189)");
                }
                m2812Track4EFweAY(rangeSliderState, modifier3, z3, sliderColors3, (Function2<? super DrawScope, ? super Offset, Unit>) null, (Function3<? super DrawScope, ? super Offset, ? super Color, Unit>) null, SliderKt.ThumbTrackGapSize, SliderKt.TrackInsideCornerSize, composerStartRestartGroup, (i3 & 14) | 14155776 | (i3 & 112) | ((i3 >> 3) & 896) | ((i3 << 3) & 7168) | ((i3 << 12) & 234881024), 48);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = modifier3;
                sliderColors2 = sliderColors3;
                z4 = z3;
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

                    public final void invoke(Composer composer2, int i9) {
                        SliderDefaults.this.Track(rangeSliderState, modifier2, sliderColors2, z4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 3072;
        z2 = z;
        if ((i2 & 16) != 0) {
            i3 |= 24576;
        } else if ((i & 24576) == 0) {
            if (composerStartRestartGroup.changed(this)) {
                i6 = Fields.Clip;
            } else {
                i6 = Fields.Shape;
            }
            i3 |= i6;
        }
        if ((i3 & 9363) == 9362) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i8 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 4) != 0) {
                    sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 12) & 14);
                    i3 &= -897;
                } else {
                    sliderColorsColors = sliderColors2;
                }
                if (i4 != 0) {
                    modifier3 = companion;
                    sliderColors3 = sliderColorsColors;
                    z3 = true;
                } else {
                    modifier3 = companion;
                    sliderColors3 = sliderColorsColors;
                    z3 = z2;
                }
            } else {
                if (i8 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 4) != 0) {
                    sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 12) & 14);
                    i3 &= -897;
                } else {
                    sliderColorsColors = sliderColors2;
                }
                if (i4 != 0) {
                    modifier3 = companion;
                    sliderColors3 = sliderColorsColors;
                    z3 = true;
                } else {
                    modifier3 = companion;
                    sliderColors3 = sliderColorsColors;
                    z3 = z2;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1617869097, i3, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1189)");
            }
            m2812Track4EFweAY(rangeSliderState, modifier3, z3, sliderColors3, (Function2<? super DrawScope, ? super Offset, Unit>) null, (Function3<? super DrawScope, ? super Offset, ? super Color, Unit>) null, SliderKt.ThumbTrackGapSize, SliderKt.TrackInsideCornerSize, composerStartRestartGroup, (i3 & 14) | 14155776 | (i3 & 112) | ((i3 >> 3) & 896) | ((i3 << 3) & 7168) | ((i3 << 12) & 234881024), 48);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier2 = modifier3;
            sliderColors2 = sliderColors3;
            z4 = z3;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i8 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 4) != 0) {
                    sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 12) & 14);
                    i3 &= -897;
                } else {
                    sliderColorsColors = sliderColors2;
                }
                if (i4 != 0) {
                    modifier3 = companion;
                    sliderColors3 = sliderColorsColors;
                    z3 = true;
                } else {
                    modifier3 = companion;
                    sliderColors3 = sliderColorsColors;
                    z3 = z2;
                }
            } else {
                if (i8 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 4) != 0) {
                    sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 12) & 14);
                    i3 &= -897;
                } else {
                    sliderColorsColors = sliderColors2;
                }
                if (i4 != 0) {
                    modifier3 = companion;
                    sliderColors3 = sliderColorsColors;
                    z3 = true;
                } else {
                    modifier3 = companion;
                    sliderColors3 = sliderColorsColors;
                    z3 = z2;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1617869097, i3, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1189)");
            }
            m2812Track4EFweAY(rangeSliderState, modifier3, z3, sliderColors3, (Function2<? super DrawScope, ? super Offset, Unit>) null, (Function3<? super DrawScope, ? super Offset, ? super Color, Unit>) null, SliderKt.ThumbTrackGapSize, SliderKt.TrackInsideCornerSize, composerStartRestartGroup, (i3 & 14) | 14155776 | (i3 & 112) | ((i3 >> 3) & 896) | ((i3 << 3) & 7168) | ((i3 << 12) & 234881024), 48);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier2 = modifier3;
            sliderColors2 = sliderColors3;
            z4 = z3;
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

                public final void invoke(Composer composer2, int i9) {
                    SliderDefaults.this.Track(rangeSliderState, modifier2, sliderColors2, z4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public final void m2812Track4EFweAY(final RangeSliderState rangeSliderState, Modifier modifier, boolean z, SliderColors sliderColors, Function2<? super DrawScope, ? super Offset, Unit> function2, Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function3, float f, float f2, Composer composer, final int i, final int i2) {
        int i3;
        int i4;
        final boolean z2;
        int i5;
        SliderColors sliderColors2;
        Function2<? super DrawScope, ? super Offset, Unit> function4;
        int i6;
        Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function5;
        int i7;
        int i8;
        int i9;
        int i10;
        float f3;
        int i11;
        int i12;
        Modifier.Companion companion;
        final SliderColors sliderColorsColors;
        Function2<? super DrawScope, ? super Offset, Unit> function6;
        C133410 c133410;
        float f4;
        float f5;
        int i13;
        float f6;
        boolean z3;
        boolean z4;
        Object objRememberedValue;
        long jM2805trackColorWaAFU9c$material3_release;
        final long jM2805trackColorWaAFU9c$material3_release2;
        Function2<? super DrawScope, ? super Offset, Unit> function7;
        final float f7;
        final long jM2804tickColorWaAFU9c$material3_release;
        final long jM2804tickColorWaAFU9c$material3_release2;
        Object objConsume;
        float f8;
        boolean z5;
        boolean z6;
        Function2<? super DrawScope, ? super Offset, Unit> function8;
        long j;
        boolean z7;
        boolean z8;
        boolean z9;
        Object objRememberedValue2;
        final SliderColors sliderColors3;
        final float f9;
        final Function2<? super DrawScope, ? super Offset, Unit> function9;
        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function10;
        final float f10;
        final boolean z10;
        final Modifier modifier2;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i14;
        int i15;
        Composer composerStartRestartGroup = composer.startRestartGroup(-541824132);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(Track)P(5,4,3!3,6:c#ui.unit.Dp,7:c#ui.unit.Dp)1222@54320L8,1223@54389L232,1245@55370L7,1246@55426L706,1241@55223L909:Slider.kt#uh7d8r");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changedInstance(rangeSliderState) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i16 = i2 & 2;
        if (i16 == 0) {
            if ((i & 48) == 0) {
                i3 |= composerStartRestartGroup.changed(modifier) ? 32 : 16;
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
                        sliderColors2 = sliderColors;
                        if (composerStartRestartGroup.changed(sliderColors2)) {
                            i15 = Fields.CameraDistance;
                        }
                        i3 |= i15;
                    } else {
                        sliderColors2 = sliderColors;
                    }
                    i15 = Fields.RotationZ;
                    i3 |= i15;
                } else {
                    sliderColors2 = sliderColors;
                }
                if ((i & 24576) == 0) {
                    if ((i2 & 16) == 0) {
                        function4 = function2;
                        if (composerStartRestartGroup.changedInstance(function4)) {
                            i14 = Fields.Clip;
                        }
                        i3 |= i14;
                    } else {
                        function4 = function2;
                    }
                    i14 = Fields.Shape;
                    i3 |= i14;
                } else {
                    function4 = function2;
                }
                i6 = i2 & 32;
                if (i6 != 0) {
                    i3 |= 196608;
                    function5 = function3;
                } else {
                    function5 = function3;
                    if ((i & 196608) == 0) {
                        if (composerStartRestartGroup.changedInstance(function5)) {
                            i7 = Fields.RenderEffect;
                        } else {
                            i7 = 65536;
                        }
                        i3 |= i7;
                    }
                }
                i8 = i2 & 64;
                if (i8 != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(f)) {
                        i9 = 1048576;
                    } else {
                        i9 = 524288;
                    }
                    i3 |= i9;
                }
                i10 = i2 & Fields.SpotShadowColor;
                if (i10 != 0) {
                    i3 |= 12582912;
                    f3 = f2;
                } else {
                    f3 = f2;
                    if ((i & 12582912) == 0) {
                        if (composerStartRestartGroup.changed(f3)) {
                            i11 = 8388608;
                        } else {
                            i11 = 4194304;
                        }
                        i3 |= i11;
                    }
                }
                if ((i2 & Fields.RotationX) != 0) {
                    if ((100663296 & i) == 0) {
                        if (composerStartRestartGroup.changed(this)) {
                            i12 = 67108864;
                        } else {
                            i12 = 33554432;
                        }
                    }
                    if ((38347923 & i3) == 38347922 || !composerStartRestartGroup.getSkipping()) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                            if (i16 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i4 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 8) != 0) {
                                sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                                i3 &= -7169;
                            } else {
                                sliderColorsColors = sliderColors2;
                            }
                            if ((i2 & 16) != 0) {
                                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800729349, "CC(remember):Slider.kt#9igjgp");
                                boolean z11 = (((i3 & 7168) ^ 3072) <= 2048 && composerStartRestartGroup.changed(sliderColorsColors)) || (i3 & 3072) == 2048;
                                if ((i3 & 896) == 256) {
                                    z3 = true;
                                } else {
                                    z3 = false;
                                }
                                z4 = z11 | z3;
                                objRememberedValue = composerStartRestartGroup.rememberedValue();
                                if (!z4 || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void m2820invokeUv8p0NA(DrawScope drawScope, long j2) {
                                            SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j2, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                        }
                                    };
                                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                                }
                                function6 = (Function2) objRememberedValue;
                                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                                i3 &= -57345;
                            } else {
                                function6 = function4;
                            }
                            if (i6 != 0) {
                                c133410 = new Function3<DrawScope, Offset, Color, Unit>() {
                                    public Object invoke(Object obj, Object obj2, Object obj3) {
                                        m2817invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2817invokewPWG1Vc(DrawScope drawScope, long j2, long j3) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j2, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j3);
                                    }
                                };
                            } else {
                                c133410 = function5;
                            }
                            if (i8 != 0) {
                                f4 = SliderKt.ThumbTrackGapSize;
                            } else {
                                f4 = f;
                            }
                            if (i10 != 0) {
                                f5 = SliderKt.TrackInsideCornerSize;
                            } else {
                                f5 = f3;
                            }
                            i13 = i3;
                            f6 = f4;
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            if ((i2 & 8) != 0) {
                                i3 &= -7169;
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                            }
                            companion = modifier;
                            sliderColorsColors = sliderColors2;
                            f5 = f3;
                            function6 = function4;
                            c133410 = function5;
                            i13 = i3;
                            f6 = f;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-541824132, i13, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1236)");
                        }
                        jM2805trackColorWaAFU9c$material3_release = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, false);
                        jM2805trackColorWaAFU9c$material3_release2 = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true);
                        function7 = function6;
                        f7 = f5;
                        jM2804tickColorWaAFU9c$material3_release = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, false);
                        jM2804tickColorWaAFU9c$material3_release2 = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, true);
                        SliderColors sliderColors4 = sliderColorsColors;
                        Modifier modifierM1066height3ABfNKs = SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), SliderKt.getTrackHeight());
                        ProvidableCompositionLocal<LayoutDirection> localLayoutDirection = CompositionLocalsKt.getLocalLayoutDirection();
                        Modifier modifier3 = companion;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        objConsume = composerStartRestartGroup.consume(localLayoutDirection);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        if (objConsume == LayoutDirection.Rtl) {
                            f8 = 180.0f;
                        } else {
                            f8 = 0.0f;
                        }
                        Modifier modifierRotate = RotateKt.rotate(modifierM1066height3ABfNKs, f8);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800695691, "CC(remember):Slider.kt#9igjgp");
                        boolean z12 = z2;
                        boolean zChangedInstance = composerStartRestartGroup.changedInstance(rangeSliderState) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release2) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release2);
                        if ((i13 & 3670016) == 1048576) {
                            z5 = true;
                        } else {
                            z5 = false;
                        }
                        boolean z13 = z5 | zChangedInstance;
                        if ((29360128 & i13) == 8388608) {
                            z6 = true;
                        } else {
                            z6 = false;
                        }
                        boolean z14 = z13 | z6;
                        if (((57344 & i13) ^ 24576) > 16384) {
                            function8 = function7;
                            if (composerStartRestartGroup.changed(function8)) {
                                j = jM2805trackColorWaAFU9c$material3_release;
                            }
                            z7 = true;
                            boolean z15 = z14 | z7;
                            if ((458752 & i13) == 131072) {
                                z8 = true;
                            } else {
                                z8 = false;
                            }
                            z9 = z15 | z8;
                            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                            if (!z9 || objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                                final long j2 = j;
                                final float f11 = f6;
                                final Function2<? super DrawScope, ? super Offset, Unit> function11 = function8;
                                final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function12 = c133410;
                                objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((DrawScope) obj);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(DrawScope drawScope) {
                                        SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j2, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f11, f7, function11, function12, true);
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            CanvasKt.Canvas(modifierRotate, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            sliderColors3 = sliderColors4;
                            f9 = f6;
                            function9 = function8;
                            function10 = c133410;
                            f10 = f7;
                            z10 = z12;
                            modifier2 = modifier3;
                        } else {
                            function8 = function7;
                        }
                        j = jM2805trackColorWaAFU9c$material3_release;
                        if ((i13 & 24576) == 16384) {
                            z7 = true;
                        } else {
                            z7 = false;
                        }
                        boolean z16 = z14 | z7;
                        if ((458752 & i13) == 131072) {
                            z8 = true;
                        } else {
                            z8 = false;
                        }
                        z9 = z16 | z8;
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z9) {
                            final long j3 = j;
                            final float f12 = f6;
                            final Function2<? super DrawScope, ? super Offset, Unit> function13 = function8;
                            final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function14 = c133410;
                            objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j3, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f12, f7, function13, function14, true);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            final long j4 = j;
                            final float f13 = f6;
                            final Function2<? super DrawScope, ? super Offset, Unit> function15 = function8;
                            final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function16 = c133410;
                            objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j4, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f13, f7, function15, function16, true);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CanvasKt.Canvas(modifierRotate, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        sliderColors3 = sliderColors4;
                        f9 = f6;
                        function9 = function8;
                        function10 = c133410;
                        f10 = f7;
                        z10 = z12;
                        modifier2 = modifier3;
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        modifier2 = modifier;
                        z10 = z2;
                        sliderColors3 = sliderColors2;
                        f10 = f3;
                        function9 = function4;
                        function10 = function5;
                        f9 = f;
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

                            public final void invoke(Composer composer2, int i17) {
                                SliderDefaults.this.m2812Track4EFweAY(rangeSliderState, modifier2, z10, sliderColors3, function9, function10, f9, f10, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i12 = 100663296;
                i3 |= i12;
                if ((38347923 & i3) == 38347922) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i16 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                            i3 &= -7169;
                        } else {
                            sliderColorsColors = sliderColors2;
                        }
                        if ((i2 & 16) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800729349, "CC(remember):Slider.kt#9igjgp");
                            if (((i3 & 7168) ^ 3072) <= 2048) {
                            }
                            if ((i3 & 896) == 256) {
                                z3 = true;
                            } else {
                                z3 = false;
                            }
                            z4 = z11 | z3;
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z4) {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2820invokeUv8p0NA(DrawScope drawScope, long j5) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j5, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            } else {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2820invokeUv8p0NA(DrawScope drawScope, long j5) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j5, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            function6 = (Function2) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -57345;
                        } else {
                            function6 = function4;
                        }
                        if (i6 != 0) {
                            c133410 = new Function3<DrawScope, Offset, Color, Unit>() {
                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    m2817invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                    return Unit.INSTANCE;
                                }

                                public final void m2817invokewPWG1Vc(DrawScope drawScope, long j5, long j6) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j5, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j6);
                                }
                            };
                        } else {
                            c133410 = function5;
                        }
                        if (i8 != 0) {
                            f4 = SliderKt.ThumbTrackGapSize;
                        } else {
                            f4 = f;
                        }
                        if (i10 != 0) {
                            f5 = SliderKt.TrackInsideCornerSize;
                        } else {
                            f5 = f3;
                        }
                        i13 = i3;
                        f6 = f4;
                    } else {
                        if (i16 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                            i3 &= -7169;
                        } else {
                            sliderColorsColors = sliderColors2;
                        }
                        if ((i2 & 16) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800729349, "CC(remember):Slider.kt#9igjgp");
                            if (((i3 & 7168) ^ 3072) <= 2048) {
                            }
                            if ((i3 & 896) == 256) {
                                z3 = true;
                            } else {
                                z3 = false;
                            }
                            z4 = z11 | z3;
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z4) {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2820invokeUv8p0NA(DrawScope drawScope, long j5) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j5, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            } else {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2820invokeUv8p0NA(DrawScope drawScope, long j5) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j5, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            function6 = (Function2) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -57345;
                        } else {
                            function6 = function4;
                        }
                        if (i6 != 0) {
                            c133410 = new Function3<DrawScope, Offset, Color, Unit>() {
                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    m2817invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                    return Unit.INSTANCE;
                                }

                                public final void m2817invokewPWG1Vc(DrawScope drawScope, long j5, long j6) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j5, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j6);
                                }
                            };
                        } else {
                            c133410 = function5;
                        }
                        if (i8 != 0) {
                            f4 = SliderKt.ThumbTrackGapSize;
                        } else {
                            f4 = f;
                        }
                        if (i10 != 0) {
                            f5 = SliderKt.TrackInsideCornerSize;
                        } else {
                            f5 = f3;
                        }
                        i13 = i3;
                        f6 = f4;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-541824132, i13, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1236)");
                    }
                    jM2805trackColorWaAFU9c$material3_release = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, false);
                    jM2805trackColorWaAFU9c$material3_release2 = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true);
                    function7 = function6;
                    f7 = f5;
                    jM2804tickColorWaAFU9c$material3_release = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, false);
                    jM2804tickColorWaAFU9c$material3_release2 = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, true);
                    SliderColors sliderColors5 = sliderColorsColors;
                    Modifier modifierM1066height3ABfNKs2 = SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), SliderKt.getTrackHeight());
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection2 = CompositionLocalsKt.getLocalLayoutDirection();
                    Modifier modifier4 = companion;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    objConsume = composerStartRestartGroup.consume(localLayoutDirection2);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (objConsume == LayoutDirection.Rtl) {
                        f8 = 180.0f;
                    } else {
                        f8 = 0.0f;
                    }
                    Modifier modifierRotate2 = RotateKt.rotate(modifierM1066height3ABfNKs2, f8);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800695691, "CC(remember):Slider.kt#9igjgp");
                    boolean z17 = z2;
                    boolean zChangedInstance2 = composerStartRestartGroup.changedInstance(rangeSliderState) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release2) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release2);
                    if ((i13 & 3670016) == 1048576) {
                        z5 = true;
                    } else {
                        z5 = false;
                    }
                    boolean z18 = z5 | zChangedInstance2;
                    if ((29360128 & i13) == 8388608) {
                        z6 = true;
                    } else {
                        z6 = false;
                    }
                    boolean z19 = z18 | z6;
                    if (((57344 & i13) ^ 24576) > 16384) {
                        function8 = function7;
                        if (composerStartRestartGroup.changed(function8)) {
                            j = jM2805trackColorWaAFU9c$material3_release;
                        }
                        z7 = true;
                        boolean z110 = z19 | z7;
                        if ((458752 & i13) == 131072) {
                            z8 = true;
                        } else {
                            z8 = false;
                        }
                        z9 = z110 | z8;
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z9) {
                            final long j5 = j;
                            final float f14 = f6;
                            final Function2<? super DrawScope, ? super Offset, Unit> function17 = function8;
                            final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function18 = c133410;
                            objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j5, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f14, f7, function17, function18, true);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            final long j6 = j;
                            final float f15 = f6;
                            final Function2<? super DrawScope, ? super Offset, Unit> function19 = function8;
                            final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function110 = c133410;
                            objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j6, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f15, f7, function19, function110, true);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CanvasKt.Canvas(modifierRotate2, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        sliderColors3 = sliderColors5;
                        f9 = f6;
                        function9 = function8;
                        function10 = c133410;
                        f10 = f7;
                        z10 = z17;
                        modifier2 = modifier4;
                    } else {
                        function8 = function7;
                    }
                    j = jM2805trackColorWaAFU9c$material3_release;
                    if ((i13 & 24576) == 16384) {
                        z7 = true;
                    } else {
                        z7 = false;
                    }
                    boolean z111 = z19 | z7;
                    if ((458752 & i13) == 131072) {
                        z8 = true;
                    } else {
                        z8 = false;
                    }
                    z9 = z111 | z8;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z9) {
                        final long j7 = j;
                        final float f16 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function111 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function112 = c133410;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j7, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f16, f7, function111, function112, true);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        final long j8 = j;
                        final float f17 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function113 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function114 = c133410;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j8, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f17, f7, function113, function114, true);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CanvasKt.Canvas(modifierRotate2, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    sliderColors3 = sliderColors5;
                    f9 = f6;
                    function9 = function8;
                    function10 = c133410;
                    f10 = f7;
                    z10 = z17;
                    modifier2 = modifier4;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i16 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                            i3 &= -7169;
                        } else {
                            sliderColorsColors = sliderColors2;
                        }
                        if ((i2 & 16) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800729349, "CC(remember):Slider.kt#9igjgp");
                            if (((i3 & 7168) ^ 3072) <= 2048) {
                            }
                            if ((i3 & 896) == 256) {
                                z3 = true;
                            } else {
                                z3 = false;
                            }
                            z4 = z11 | z3;
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z4) {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2820invokeUv8p0NA(DrawScope drawScope, long j9) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j9, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            } else {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2820invokeUv8p0NA(DrawScope drawScope, long j9) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j9, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            function6 = (Function2) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -57345;
                        } else {
                            function6 = function4;
                        }
                        if (i6 != 0) {
                            c133410 = new Function3<DrawScope, Offset, Color, Unit>() {
                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    m2817invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                    return Unit.INSTANCE;
                                }

                                public final void m2817invokewPWG1Vc(DrawScope drawScope, long j9, long j10) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j9, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j10);
                                }
                            };
                        } else {
                            c133410 = function5;
                        }
                        if (i8 != 0) {
                            f4 = SliderKt.ThumbTrackGapSize;
                        } else {
                            f4 = f;
                        }
                        if (i10 != 0) {
                            f5 = SliderKt.TrackInsideCornerSize;
                        } else {
                            f5 = f3;
                        }
                        i13 = i3;
                        f6 = f4;
                    } else {
                        if (i16 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                            i3 &= -7169;
                        } else {
                            sliderColorsColors = sliderColors2;
                        }
                        if ((i2 & 16) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800729349, "CC(remember):Slider.kt#9igjgp");
                            if (((i3 & 7168) ^ 3072) <= 2048) {
                            }
                            if ((i3 & 896) == 256) {
                                z3 = true;
                            } else {
                                z3 = false;
                            }
                            z4 = z11 | z3;
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z4) {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2820invokeUv8p0NA(DrawScope drawScope, long j9) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j9, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            } else {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2820invokeUv8p0NA(DrawScope drawScope, long j9) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j9, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            function6 = (Function2) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -57345;
                        } else {
                            function6 = function4;
                        }
                        if (i6 != 0) {
                            c133410 = new Function3<DrawScope, Offset, Color, Unit>() {
                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    m2817invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                    return Unit.INSTANCE;
                                }

                                public final void m2817invokewPWG1Vc(DrawScope drawScope, long j9, long j10) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j9, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j10);
                                }
                            };
                        } else {
                            c133410 = function5;
                        }
                        if (i8 != 0) {
                            f4 = SliderKt.ThumbTrackGapSize;
                        } else {
                            f4 = f;
                        }
                        if (i10 != 0) {
                            f5 = SliderKt.TrackInsideCornerSize;
                        } else {
                            f5 = f3;
                        }
                        i13 = i3;
                        f6 = f4;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-541824132, i13, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1236)");
                    }
                    jM2805trackColorWaAFU9c$material3_release = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, false);
                    jM2805trackColorWaAFU9c$material3_release2 = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true);
                    function7 = function6;
                    f7 = f5;
                    jM2804tickColorWaAFU9c$material3_release = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, false);
                    jM2804tickColorWaAFU9c$material3_release2 = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, true);
                    SliderColors sliderColors6 = sliderColorsColors;
                    Modifier modifierM1066height3ABfNKs3 = SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), SliderKt.getTrackHeight());
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection3 = CompositionLocalsKt.getLocalLayoutDirection();
                    Modifier modifier5 = companion;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    objConsume = composerStartRestartGroup.consume(localLayoutDirection3);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (objConsume == LayoutDirection.Rtl) {
                        f8 = 180.0f;
                    } else {
                        f8 = 0.0f;
                    }
                    Modifier modifierRotate3 = RotateKt.rotate(modifierM1066height3ABfNKs3, f8);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800695691, "CC(remember):Slider.kt#9igjgp");
                    boolean z112 = z2;
                    boolean zChangedInstance3 = composerStartRestartGroup.changedInstance(rangeSliderState) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release2) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release2);
                    if ((i13 & 3670016) == 1048576) {
                        z5 = true;
                    } else {
                        z5 = false;
                    }
                    boolean z113 = z5 | zChangedInstance3;
                    if ((29360128 & i13) == 8388608) {
                        z6 = true;
                    } else {
                        z6 = false;
                    }
                    boolean z114 = z113 | z6;
                    if (((57344 & i13) ^ 24576) > 16384) {
                        function8 = function7;
                        if (composerStartRestartGroup.changed(function8)) {
                            j = jM2805trackColorWaAFU9c$material3_release;
                        }
                        z7 = true;
                        boolean z115 = z114 | z7;
                        if ((458752 & i13) == 131072) {
                            z8 = true;
                        } else {
                            z8 = false;
                        }
                        z9 = z115 | z8;
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z9) {
                            final long j9 = j;
                            final float f18 = f6;
                            final Function2<? super DrawScope, ? super Offset, Unit> function115 = function8;
                            final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function116 = c133410;
                            objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j9, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f18, f7, function115, function116, true);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            final long j10 = j;
                            final float f19 = f6;
                            final Function2<? super DrawScope, ? super Offset, Unit> function117 = function8;
                            final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function118 = c133410;
                            objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j10, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f19, f7, function117, function118, true);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CanvasKt.Canvas(modifierRotate3, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        sliderColors3 = sliderColors6;
                        f9 = f6;
                        function9 = function8;
                        function10 = c133410;
                        f10 = f7;
                        z10 = z112;
                        modifier2 = modifier5;
                    } else {
                        function8 = function7;
                    }
                    j = jM2805trackColorWaAFU9c$material3_release;
                    if ((i13 & 24576) == 16384) {
                        z7 = true;
                    } else {
                        z7 = false;
                    }
                    boolean z116 = z114 | z7;
                    if ((458752 & i13) == 131072) {
                        z8 = true;
                    } else {
                        z8 = false;
                    }
                    z9 = z116 | z8;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z9) {
                        final long j11 = j;
                        final float f110 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function119 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1110 = c133410;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j11, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f110, f7, function119, function1110, true);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        final long j12 = j;
                        final float f111 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function1111 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1112 = c133410;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j12, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f111, f7, function1111, function1112, true);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CanvasKt.Canvas(modifierRotate3, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    sliderColors3 = sliderColors6;
                    f9 = f6;
                    function9 = function8;
                    function10 = c133410;
                    f10 = f7;
                    z10 = z112;
                    modifier2 = modifier5;
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

                        public final void invoke(Composer composer2, int i17) {
                            SliderDefaults.this.m2812Track4EFweAY(rangeSliderState, modifier2, z10, sliderColors3, function9, function10, f9, f10, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 384;
            z2 = z;
            if ((i & 3072) == 0) {
                if ((i2 & 8) == 0) {
                    sliderColors2 = sliderColors;
                    if (composerStartRestartGroup.changed(sliderColors2)) {
                        i15 = Fields.CameraDistance;
                    }
                    i3 |= i15;
                } else {
                    sliderColors2 = sliderColors;
                }
                i15 = Fields.RotationZ;
                i3 |= i15;
            } else {
                sliderColors2 = sliderColors;
            }
            if ((i & 24576) == 0) {
                if ((i2 & 16) == 0) {
                    function4 = function2;
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i14 = Fields.Clip;
                    }
                    i3 |= i14;
                } else {
                    function4 = function2;
                }
                i14 = Fields.Shape;
                i3 |= i14;
            } else {
                function4 = function2;
            }
            i6 = i2 & 32;
            if (i6 != 0) {
                i3 |= 196608;
                function5 = function3;
            } else {
                function5 = function3;
                if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changedInstance(function5)) {
                        i7 = Fields.RenderEffect;
                    } else {
                        i7 = 65536;
                    }
                    i3 |= i7;
                }
            }
            i8 = i2 & 64;
            if (i8 != 0) {
                i3 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changed(f)) {
                    i9 = 1048576;
                } else {
                    i9 = 524288;
                }
                i3 |= i9;
            }
            i10 = i2 & Fields.SpotShadowColor;
            if (i10 != 0) {
                i3 |= 12582912;
                f3 = f2;
            } else {
                f3 = f2;
                if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(f3)) {
                        i11 = 8388608;
                    } else {
                        i11 = 4194304;
                    }
                    i3 |= i11;
                }
            }
            if ((i2 & Fields.RotationX) != 0) {
                if ((100663296 & i) == 0) {
                    if (composerStartRestartGroup.changed(this)) {
                        i12 = 67108864;
                    } else {
                        i12 = 33554432;
                    }
                }
                if ((38347923 & i3) == 38347922) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i16 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                            i3 &= -7169;
                        } else {
                            sliderColorsColors = sliderColors2;
                        }
                        if ((i2 & 16) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800729349, "CC(remember):Slider.kt#9igjgp");
                            if (((i3 & 7168) ^ 3072) <= 2048) {
                            }
                            if ((i3 & 896) == 256) {
                                z3 = true;
                            } else {
                                z3 = false;
                            }
                            z4 = z11 | z3;
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z4) {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2820invokeUv8p0NA(DrawScope drawScope, long j13) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j13, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            } else {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2820invokeUv8p0NA(DrawScope drawScope, long j13) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j13, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            function6 = (Function2) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -57345;
                        } else {
                            function6 = function4;
                        }
                        if (i6 != 0) {
                            c133410 = new Function3<DrawScope, Offset, Color, Unit>() {
                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    m2817invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                    return Unit.INSTANCE;
                                }

                                public final void m2817invokewPWG1Vc(DrawScope drawScope, long j13, long j14) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j13, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j14);
                                }
                            };
                        } else {
                            c133410 = function5;
                        }
                        if (i8 != 0) {
                            f4 = SliderKt.ThumbTrackGapSize;
                        } else {
                            f4 = f;
                        }
                        if (i10 != 0) {
                            f5 = SliderKt.TrackInsideCornerSize;
                        } else {
                            f5 = f3;
                        }
                        i13 = i3;
                        f6 = f4;
                    } else {
                        if (i16 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                            i3 &= -7169;
                        } else {
                            sliderColorsColors = sliderColors2;
                        }
                        if ((i2 & 16) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800729349, "CC(remember):Slider.kt#9igjgp");
                            if (((i3 & 7168) ^ 3072) <= 2048) {
                            }
                            if ((i3 & 896) == 256) {
                                z3 = true;
                            } else {
                                z3 = false;
                            }
                            z4 = z11 | z3;
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z4) {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2820invokeUv8p0NA(DrawScope drawScope, long j13) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j13, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            } else {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2820invokeUv8p0NA(DrawScope drawScope, long j13) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j13, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            function6 = (Function2) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -57345;
                        } else {
                            function6 = function4;
                        }
                        if (i6 != 0) {
                            c133410 = new Function3<DrawScope, Offset, Color, Unit>() {
                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    m2817invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                    return Unit.INSTANCE;
                                }

                                public final void m2817invokewPWG1Vc(DrawScope drawScope, long j13, long j14) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j13, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j14);
                                }
                            };
                        } else {
                            c133410 = function5;
                        }
                        if (i8 != 0) {
                            f4 = SliderKt.ThumbTrackGapSize;
                        } else {
                            f4 = f;
                        }
                        if (i10 != 0) {
                            f5 = SliderKt.TrackInsideCornerSize;
                        } else {
                            f5 = f3;
                        }
                        i13 = i3;
                        f6 = f4;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-541824132, i13, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1236)");
                    }
                    jM2805trackColorWaAFU9c$material3_release = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, false);
                    jM2805trackColorWaAFU9c$material3_release2 = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true);
                    function7 = function6;
                    f7 = f5;
                    jM2804tickColorWaAFU9c$material3_release = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, false);
                    jM2804tickColorWaAFU9c$material3_release2 = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, true);
                    SliderColors sliderColors7 = sliderColorsColors;
                    Modifier modifierM1066height3ABfNKs4 = SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), SliderKt.getTrackHeight());
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection4 = CompositionLocalsKt.getLocalLayoutDirection();
                    Modifier modifier6 = companion;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    objConsume = composerStartRestartGroup.consume(localLayoutDirection4);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (objConsume == LayoutDirection.Rtl) {
                        f8 = 180.0f;
                    } else {
                        f8 = 0.0f;
                    }
                    Modifier modifierRotate4 = RotateKt.rotate(modifierM1066height3ABfNKs4, f8);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800695691, "CC(remember):Slider.kt#9igjgp");
                    boolean z117 = z2;
                    boolean zChangedInstance4 = composerStartRestartGroup.changedInstance(rangeSliderState) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release2) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release2);
                    if ((i13 & 3670016) == 1048576) {
                        z5 = true;
                    } else {
                        z5 = false;
                    }
                    boolean z118 = z5 | zChangedInstance4;
                    if ((29360128 & i13) == 8388608) {
                        z6 = true;
                    } else {
                        z6 = false;
                    }
                    boolean z119 = z118 | z6;
                    if (((57344 & i13) ^ 24576) > 16384) {
                        function8 = function7;
                        if (composerStartRestartGroup.changed(function8)) {
                            j = jM2805trackColorWaAFU9c$material3_release;
                        }
                        z7 = true;
                        boolean z1110 = z119 | z7;
                        if ((458752 & i13) == 131072) {
                            z8 = true;
                        } else {
                            z8 = false;
                        }
                        z9 = z1110 | z8;
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z9) {
                            final long j13 = j;
                            final float f112 = f6;
                            final Function2<? super DrawScope, ? super Offset, Unit> function1113 = function8;
                            final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1114 = c133410;
                            objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j13, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f112, f7, function1113, function1114, true);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            final long j14 = j;
                            final float f113 = f6;
                            final Function2<? super DrawScope, ? super Offset, Unit> function1115 = function8;
                            final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1116 = c133410;
                            objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j14, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f113, f7, function1115, function1116, true);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CanvasKt.Canvas(modifierRotate4, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        sliderColors3 = sliderColors7;
                        f9 = f6;
                        function9 = function8;
                        function10 = c133410;
                        f10 = f7;
                        z10 = z117;
                        modifier2 = modifier6;
                    } else {
                        function8 = function7;
                    }
                    j = jM2805trackColorWaAFU9c$material3_release;
                    if ((i13 & 24576) == 16384) {
                        z7 = true;
                    } else {
                        z7 = false;
                    }
                    boolean z1111 = z119 | z7;
                    if ((458752 & i13) == 131072) {
                        z8 = true;
                    } else {
                        z8 = false;
                    }
                    z9 = z1111 | z8;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z9) {
                        final long j15 = j;
                        final float f114 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function1117 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1118 = c133410;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j15, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f114, f7, function1117, function1118, true);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        final long j16 = j;
                        final float f115 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function1119 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function11110 = c133410;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j16, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f115, f7, function1119, function11110, true);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CanvasKt.Canvas(modifierRotate4, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    sliderColors3 = sliderColors7;
                    f9 = f6;
                    function9 = function8;
                    function10 = c133410;
                    f10 = f7;
                    z10 = z117;
                    modifier2 = modifier6;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i16 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                            i3 &= -7169;
                        } else {
                            sliderColorsColors = sliderColors2;
                        }
                        if ((i2 & 16) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800729349, "CC(remember):Slider.kt#9igjgp");
                            if (((i3 & 7168) ^ 3072) <= 2048) {
                            }
                            if ((i3 & 896) == 256) {
                                z3 = true;
                            } else {
                                z3 = false;
                            }
                            z4 = z11 | z3;
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z4) {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2820invokeUv8p0NA(DrawScope drawScope, long j17) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j17, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            } else {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2820invokeUv8p0NA(DrawScope drawScope, long j17) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j17, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            function6 = (Function2) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -57345;
                        } else {
                            function6 = function4;
                        }
                        if (i6 != 0) {
                            c133410 = new Function3<DrawScope, Offset, Color, Unit>() {
                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    m2817invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                    return Unit.INSTANCE;
                                }

                                public final void m2817invokewPWG1Vc(DrawScope drawScope, long j17, long j18) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j17, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j18);
                                }
                            };
                        } else {
                            c133410 = function5;
                        }
                        if (i8 != 0) {
                            f4 = SliderKt.ThumbTrackGapSize;
                        } else {
                            f4 = f;
                        }
                        if (i10 != 0) {
                            f5 = SliderKt.TrackInsideCornerSize;
                        } else {
                            f5 = f3;
                        }
                        i13 = i3;
                        f6 = f4;
                    } else {
                        if (i16 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                            i3 &= -7169;
                        } else {
                            sliderColorsColors = sliderColors2;
                        }
                        if ((i2 & 16) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800729349, "CC(remember):Slider.kt#9igjgp");
                            if (((i3 & 7168) ^ 3072) <= 2048) {
                            }
                            if ((i3 & 896) == 256) {
                                z3 = true;
                            } else {
                                z3 = false;
                            }
                            z4 = z11 | z3;
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z4) {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2820invokeUv8p0NA(DrawScope drawScope, long j17) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j17, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            } else {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2820invokeUv8p0NA(DrawScope drawScope, long j17) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j17, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            function6 = (Function2) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -57345;
                        } else {
                            function6 = function4;
                        }
                        if (i6 != 0) {
                            c133410 = new Function3<DrawScope, Offset, Color, Unit>() {
                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    m2817invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                    return Unit.INSTANCE;
                                }

                                public final void m2817invokewPWG1Vc(DrawScope drawScope, long j17, long j18) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j17, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j18);
                                }
                            };
                        } else {
                            c133410 = function5;
                        }
                        if (i8 != 0) {
                            f4 = SliderKt.ThumbTrackGapSize;
                        } else {
                            f4 = f;
                        }
                        if (i10 != 0) {
                            f5 = SliderKt.TrackInsideCornerSize;
                        } else {
                            f5 = f3;
                        }
                        i13 = i3;
                        f6 = f4;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-541824132, i13, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1236)");
                    }
                    jM2805trackColorWaAFU9c$material3_release = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, false);
                    jM2805trackColorWaAFU9c$material3_release2 = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true);
                    function7 = function6;
                    f7 = f5;
                    jM2804tickColorWaAFU9c$material3_release = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, false);
                    jM2804tickColorWaAFU9c$material3_release2 = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, true);
                    SliderColors sliderColors8 = sliderColorsColors;
                    Modifier modifierM1066height3ABfNKs5 = SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), SliderKt.getTrackHeight());
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection5 = CompositionLocalsKt.getLocalLayoutDirection();
                    Modifier modifier7 = companion;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    objConsume = composerStartRestartGroup.consume(localLayoutDirection5);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (objConsume == LayoutDirection.Rtl) {
                        f8 = 180.0f;
                    } else {
                        f8 = 0.0f;
                    }
                    Modifier modifierRotate5 = RotateKt.rotate(modifierM1066height3ABfNKs5, f8);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800695691, "CC(remember):Slider.kt#9igjgp");
                    boolean z1112 = z2;
                    boolean zChangedInstance5 = composerStartRestartGroup.changedInstance(rangeSliderState) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release2) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release2);
                    if ((i13 & 3670016) == 1048576) {
                        z5 = true;
                    } else {
                        z5 = false;
                    }
                    boolean z1113 = z5 | zChangedInstance5;
                    if ((29360128 & i13) == 8388608) {
                        z6 = true;
                    } else {
                        z6 = false;
                    }
                    boolean z1114 = z1113 | z6;
                    if (((57344 & i13) ^ 24576) > 16384) {
                        function8 = function7;
                        if (composerStartRestartGroup.changed(function8)) {
                            j = jM2805trackColorWaAFU9c$material3_release;
                        }
                        z7 = true;
                        boolean z1115 = z1114 | z7;
                        if ((458752 & i13) == 131072) {
                            z8 = true;
                        } else {
                            z8 = false;
                        }
                        z9 = z1115 | z8;
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z9) {
                            final long j17 = j;
                            final float f116 = f6;
                            final Function2<? super DrawScope, ? super Offset, Unit> function11111 = function8;
                            final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function11112 = c133410;
                            objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j17, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f116, f7, function11111, function11112, true);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            final long j18 = j;
                            final float f117 = f6;
                            final Function2<? super DrawScope, ? super Offset, Unit> function11113 = function8;
                            final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function11114 = c133410;
                            objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j18, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f117, f7, function11113, function11114, true);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CanvasKt.Canvas(modifierRotate5, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        sliderColors3 = sliderColors8;
                        f9 = f6;
                        function9 = function8;
                        function10 = c133410;
                        f10 = f7;
                        z10 = z1112;
                        modifier2 = modifier7;
                    } else {
                        function8 = function7;
                    }
                    j = jM2805trackColorWaAFU9c$material3_release;
                    if ((i13 & 24576) == 16384) {
                        z7 = true;
                    } else {
                        z7 = false;
                    }
                    boolean z1116 = z1114 | z7;
                    if ((458752 & i13) == 131072) {
                        z8 = true;
                    } else {
                        z8 = false;
                    }
                    z9 = z1116 | z8;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z9) {
                        final long j19 = j;
                        final float f118 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function11115 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function11116 = c133410;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j19, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f118, f7, function11115, function11116, true);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        final long j110 = j;
                        final float f119 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function11117 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function11118 = c133410;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j110, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f119, f7, function11117, function11118, true);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CanvasKt.Canvas(modifierRotate5, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    sliderColors3 = sliderColors8;
                    f9 = f6;
                    function9 = function8;
                    function10 = c133410;
                    f10 = f7;
                    z10 = z1112;
                    modifier2 = modifier7;
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

                        public final void invoke(Composer composer2, int i17) {
                            SliderDefaults.this.m2812Track4EFweAY(rangeSliderState, modifier2, z10, sliderColors3, function9, function10, f9, f10, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i12 = 100663296;
            i3 |= i12;
            if ((38347923 & i3) == 38347922) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                        i3 &= -7169;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if ((i2 & 16) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800729349, "CC(remember):Slider.kt#9igjgp");
                        if (((i3 & 7168) ^ 3072) <= 2048) {
                        }
                        if ((i3 & 896) == 256) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z11 | z3;
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2820invokeUv8p0NA(DrawScope drawScope, long j111) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j111, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2820invokeUv8p0NA(DrawScope drawScope, long j111) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j111, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        function6 = (Function2) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -57345;
                    } else {
                        function6 = function4;
                    }
                    if (i6 != 0) {
                        c133410 = new Function3<DrawScope, Offset, Color, Unit>() {
                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                m2817invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                return Unit.INSTANCE;
                            }

                            public final void m2817invokewPWG1Vc(DrawScope drawScope, long j111, long j112) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j111, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j112);
                            }
                        };
                    } else {
                        c133410 = function5;
                    }
                    if (i8 != 0) {
                        f4 = SliderKt.ThumbTrackGapSize;
                    } else {
                        f4 = f;
                    }
                    if (i10 != 0) {
                        f5 = SliderKt.TrackInsideCornerSize;
                    } else {
                        f5 = f3;
                    }
                    i13 = i3;
                    f6 = f4;
                } else {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                        i3 &= -7169;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if ((i2 & 16) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800729349, "CC(remember):Slider.kt#9igjgp");
                        if (((i3 & 7168) ^ 3072) <= 2048) {
                        }
                        if ((i3 & 896) == 256) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z11 | z3;
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2820invokeUv8p0NA(DrawScope drawScope, long j111) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j111, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2820invokeUv8p0NA(DrawScope drawScope, long j111) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j111, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        function6 = (Function2) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -57345;
                    } else {
                        function6 = function4;
                    }
                    if (i6 != 0) {
                        c133410 = new Function3<DrawScope, Offset, Color, Unit>() {
                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                m2817invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                return Unit.INSTANCE;
                            }

                            public final void m2817invokewPWG1Vc(DrawScope drawScope, long j111, long j112) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j111, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j112);
                            }
                        };
                    } else {
                        c133410 = function5;
                    }
                    if (i8 != 0) {
                        f4 = SliderKt.ThumbTrackGapSize;
                    } else {
                        f4 = f;
                    }
                    if (i10 != 0) {
                        f5 = SliderKt.TrackInsideCornerSize;
                    } else {
                        f5 = f3;
                    }
                    i13 = i3;
                    f6 = f4;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-541824132, i13, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1236)");
                }
                jM2805trackColorWaAFU9c$material3_release = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, false);
                jM2805trackColorWaAFU9c$material3_release2 = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true);
                function7 = function6;
                f7 = f5;
                jM2804tickColorWaAFU9c$material3_release = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, false);
                jM2804tickColorWaAFU9c$material3_release2 = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, true);
                SliderColors sliderColors9 = sliderColorsColors;
                Modifier modifierM1066height3ABfNKs6 = SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), SliderKt.getTrackHeight());
                ProvidableCompositionLocal<LayoutDirection> localLayoutDirection6 = CompositionLocalsKt.getLocalLayoutDirection();
                Modifier modifier8 = companion;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                objConsume = composerStartRestartGroup.consume(localLayoutDirection6);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (objConsume == LayoutDirection.Rtl) {
                    f8 = 180.0f;
                } else {
                    f8 = 0.0f;
                }
                Modifier modifierRotate6 = RotateKt.rotate(modifierM1066height3ABfNKs6, f8);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800695691, "CC(remember):Slider.kt#9igjgp");
                boolean z1117 = z2;
                boolean zChangedInstance6 = composerStartRestartGroup.changedInstance(rangeSliderState) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release2) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release2);
                if ((i13 & 3670016) == 1048576) {
                    z5 = true;
                } else {
                    z5 = false;
                }
                boolean z1118 = z5 | zChangedInstance6;
                if ((29360128 & i13) == 8388608) {
                    z6 = true;
                } else {
                    z6 = false;
                }
                boolean z1119 = z1118 | z6;
                if (((57344 & i13) ^ 24576) > 16384) {
                    function8 = function7;
                    if (composerStartRestartGroup.changed(function8)) {
                        j = jM2805trackColorWaAFU9c$material3_release;
                    }
                    z7 = true;
                    boolean z11110 = z1119 | z7;
                    if ((458752 & i13) == 131072) {
                        z8 = true;
                    } else {
                        z8 = false;
                    }
                    z9 = z11110 | z8;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z9) {
                        final long j111 = j;
                        final float f1110 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function11119 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function111110 = c133410;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j111, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f1110, f7, function11119, function111110, true);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        final long j112 = j;
                        final float f1111 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function111111 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function111112 = c133410;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j112, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f1111, f7, function111111, function111112, true);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CanvasKt.Canvas(modifierRotate6, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    sliderColors3 = sliderColors9;
                    f9 = f6;
                    function9 = function8;
                    function10 = c133410;
                    f10 = f7;
                    z10 = z1117;
                    modifier2 = modifier8;
                } else {
                    function8 = function7;
                }
                j = jM2805trackColorWaAFU9c$material3_release;
                if ((i13 & 24576) == 16384) {
                    z7 = true;
                } else {
                    z7 = false;
                }
                boolean z11111 = z1119 | z7;
                if ((458752 & i13) == 131072) {
                    z8 = true;
                } else {
                    z8 = false;
                }
                z9 = z11111 | z8;
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z9) {
                    final long j113 = j;
                    final float f1112 = f6;
                    final Function2<? super DrawScope, ? super Offset, Unit> function111113 = function8;
                    final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function111114 = c133410;
                    objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j113, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f1112, f7, function111113, function111114, true);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    final long j114 = j;
                    final float f1113 = f6;
                    final Function2<? super DrawScope, ? super Offset, Unit> function111115 = function8;
                    final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function111116 = c133410;
                    objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j114, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f1113, f7, function111115, function111116, true);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CanvasKt.Canvas(modifierRotate6, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                sliderColors3 = sliderColors9;
                f9 = f6;
                function9 = function8;
                function10 = c133410;
                f10 = f7;
                z10 = z1117;
                modifier2 = modifier8;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                        i3 &= -7169;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if ((i2 & 16) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800729349, "CC(remember):Slider.kt#9igjgp");
                        if (((i3 & 7168) ^ 3072) <= 2048) {
                        }
                        if ((i3 & 896) == 256) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z11 | z3;
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2820invokeUv8p0NA(DrawScope drawScope, long j115) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j115, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2820invokeUv8p0NA(DrawScope drawScope, long j115) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j115, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        function6 = (Function2) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -57345;
                    } else {
                        function6 = function4;
                    }
                    if (i6 != 0) {
                        c133410 = new Function3<DrawScope, Offset, Color, Unit>() {
                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                m2817invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                return Unit.INSTANCE;
                            }

                            public final void m2817invokewPWG1Vc(DrawScope drawScope, long j115, long j116) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j115, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j116);
                            }
                        };
                    } else {
                        c133410 = function5;
                    }
                    if (i8 != 0) {
                        f4 = SliderKt.ThumbTrackGapSize;
                    } else {
                        f4 = f;
                    }
                    if (i10 != 0) {
                        f5 = SliderKt.TrackInsideCornerSize;
                    } else {
                        f5 = f3;
                    }
                    i13 = i3;
                    f6 = f4;
                } else {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                        i3 &= -7169;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if ((i2 & 16) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800729349, "CC(remember):Slider.kt#9igjgp");
                        if (((i3 & 7168) ^ 3072) <= 2048) {
                        }
                        if ((i3 & 896) == 256) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z11 | z3;
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2820invokeUv8p0NA(DrawScope drawScope, long j115) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j115, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2820invokeUv8p0NA(DrawScope drawScope, long j115) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j115, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        function6 = (Function2) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -57345;
                    } else {
                        function6 = function4;
                    }
                    if (i6 != 0) {
                        c133410 = new Function3<DrawScope, Offset, Color, Unit>() {
                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                m2817invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                return Unit.INSTANCE;
                            }

                            public final void m2817invokewPWG1Vc(DrawScope drawScope, long j115, long j116) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j115, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j116);
                            }
                        };
                    } else {
                        c133410 = function5;
                    }
                    if (i8 != 0) {
                        f4 = SliderKt.ThumbTrackGapSize;
                    } else {
                        f4 = f;
                    }
                    if (i10 != 0) {
                        f5 = SliderKt.TrackInsideCornerSize;
                    } else {
                        f5 = f3;
                    }
                    i13 = i3;
                    f6 = f4;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-541824132, i13, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1236)");
                }
                jM2805trackColorWaAFU9c$material3_release = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, false);
                jM2805trackColorWaAFU9c$material3_release2 = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true);
                function7 = function6;
                f7 = f5;
                jM2804tickColorWaAFU9c$material3_release = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, false);
                jM2804tickColorWaAFU9c$material3_release2 = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, true);
                SliderColors sliderColors10 = sliderColorsColors;
                Modifier modifierM1066height3ABfNKs7 = SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), SliderKt.getTrackHeight());
                ProvidableCompositionLocal<LayoutDirection> localLayoutDirection7 = CompositionLocalsKt.getLocalLayoutDirection();
                Modifier modifier9 = companion;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                objConsume = composerStartRestartGroup.consume(localLayoutDirection7);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (objConsume == LayoutDirection.Rtl) {
                    f8 = 180.0f;
                } else {
                    f8 = 0.0f;
                }
                Modifier modifierRotate7 = RotateKt.rotate(modifierM1066height3ABfNKs7, f8);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800695691, "CC(remember):Slider.kt#9igjgp");
                boolean z11112 = z2;
                boolean zChangedInstance7 = composerStartRestartGroup.changedInstance(rangeSliderState) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release2) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release2);
                if ((i13 & 3670016) == 1048576) {
                    z5 = true;
                } else {
                    z5 = false;
                }
                boolean z11113 = z5 | zChangedInstance7;
                if ((29360128 & i13) == 8388608) {
                    z6 = true;
                } else {
                    z6 = false;
                }
                boolean z11114 = z11113 | z6;
                if (((57344 & i13) ^ 24576) > 16384) {
                    function8 = function7;
                    if (composerStartRestartGroup.changed(function8)) {
                        j = jM2805trackColorWaAFU9c$material3_release;
                    }
                    z7 = true;
                    boolean z11115 = z11114 | z7;
                    if ((458752 & i13) == 131072) {
                        z8 = true;
                    } else {
                        z8 = false;
                    }
                    z9 = z11115 | z8;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z9) {
                        final long j115 = j;
                        final float f1114 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function111117 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function111118 = c133410;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j115, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f1114, f7, function111117, function111118, true);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        final long j116 = j;
                        final float f1115 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function111119 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1111110 = c133410;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j116, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f1115, f7, function111119, function1111110, true);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CanvasKt.Canvas(modifierRotate7, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    sliderColors3 = sliderColors10;
                    f9 = f6;
                    function9 = function8;
                    function10 = c133410;
                    f10 = f7;
                    z10 = z11112;
                    modifier2 = modifier9;
                } else {
                    function8 = function7;
                }
                j = jM2805trackColorWaAFU9c$material3_release;
                if ((i13 & 24576) == 16384) {
                    z7 = true;
                } else {
                    z7 = false;
                }
                boolean z11116 = z11114 | z7;
                if ((458752 & i13) == 131072) {
                    z8 = true;
                } else {
                    z8 = false;
                }
                z9 = z11116 | z8;
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z9) {
                    final long j117 = j;
                    final float f1116 = f6;
                    final Function2<? super DrawScope, ? super Offset, Unit> function1111111 = function8;
                    final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1111112 = c133410;
                    objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j117, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f1116, f7, function1111111, function1111112, true);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    final long j118 = j;
                    final float f1117 = f6;
                    final Function2<? super DrawScope, ? super Offset, Unit> function1111113 = function8;
                    final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1111114 = c133410;
                    objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j118, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f1117, f7, function1111113, function1111114, true);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CanvasKt.Canvas(modifierRotate7, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                sliderColors3 = sliderColors10;
                f9 = f6;
                function9 = function8;
                function10 = c133410;
                f10 = f7;
                z10 = z11112;
                modifier2 = modifier9;
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

                    public final void invoke(Composer composer2, int i17) {
                        SliderDefaults.this.m2812Track4EFweAY(rangeSliderState, modifier2, z10, sliderColors3, function9, function10, f9, f10, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
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
                    sliderColors2 = sliderColors;
                    if (composerStartRestartGroup.changed(sliderColors2)) {
                        i15 = Fields.CameraDistance;
                    }
                    i3 |= i15;
                } else {
                    sliderColors2 = sliderColors;
                }
                i15 = Fields.RotationZ;
                i3 |= i15;
            } else {
                sliderColors2 = sliderColors;
            }
            if ((i & 24576) == 0) {
                if ((i2 & 16) == 0) {
                    function4 = function2;
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i14 = Fields.Clip;
                    }
                    i3 |= i14;
                } else {
                    function4 = function2;
                }
                i14 = Fields.Shape;
                i3 |= i14;
            } else {
                function4 = function2;
            }
            i6 = i2 & 32;
            if (i6 != 0) {
                i3 |= 196608;
                function5 = function3;
            } else {
                function5 = function3;
                if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changedInstance(function5)) {
                        i7 = Fields.RenderEffect;
                    } else {
                        i7 = 65536;
                    }
                    i3 |= i7;
                }
            }
            i8 = i2 & 64;
            if (i8 != 0) {
                i3 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changed(f)) {
                    i9 = 1048576;
                } else {
                    i9 = 524288;
                }
                i3 |= i9;
            }
            i10 = i2 & Fields.SpotShadowColor;
            if (i10 != 0) {
                i3 |= 12582912;
                f3 = f2;
            } else {
                f3 = f2;
                if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(f3)) {
                        i11 = 8388608;
                    } else {
                        i11 = 4194304;
                    }
                    i3 |= i11;
                }
            }
            if ((i2 & Fields.RotationX) != 0) {
                if ((100663296 & i) == 0) {
                    if (composerStartRestartGroup.changed(this)) {
                        i12 = 67108864;
                    } else {
                        i12 = 33554432;
                    }
                }
                if ((38347923 & i3) == 38347922) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i16 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                            i3 &= -7169;
                        } else {
                            sliderColorsColors = sliderColors2;
                        }
                        if ((i2 & 16) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800729349, "CC(remember):Slider.kt#9igjgp");
                            if (((i3 & 7168) ^ 3072) <= 2048) {
                            }
                            if ((i3 & 896) == 256) {
                                z3 = true;
                            } else {
                                z3 = false;
                            }
                            z4 = z11 | z3;
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z4) {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2820invokeUv8p0NA(DrawScope drawScope, long j119) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j119, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            } else {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2820invokeUv8p0NA(DrawScope drawScope, long j119) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j119, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            function6 = (Function2) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -57345;
                        } else {
                            function6 = function4;
                        }
                        if (i6 != 0) {
                            c133410 = new Function3<DrawScope, Offset, Color, Unit>() {
                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    m2817invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                    return Unit.INSTANCE;
                                }

                                public final void m2817invokewPWG1Vc(DrawScope drawScope, long j119, long j1110) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j119, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j1110);
                                }
                            };
                        } else {
                            c133410 = function5;
                        }
                        if (i8 != 0) {
                            f4 = SliderKt.ThumbTrackGapSize;
                        } else {
                            f4 = f;
                        }
                        if (i10 != 0) {
                            f5 = SliderKt.TrackInsideCornerSize;
                        } else {
                            f5 = f3;
                        }
                        i13 = i3;
                        f6 = f4;
                    } else {
                        if (i16 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                            i3 &= -7169;
                        } else {
                            sliderColorsColors = sliderColors2;
                        }
                        if ((i2 & 16) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800729349, "CC(remember):Slider.kt#9igjgp");
                            if (((i3 & 7168) ^ 3072) <= 2048) {
                            }
                            if ((i3 & 896) == 256) {
                                z3 = true;
                            } else {
                                z3 = false;
                            }
                            z4 = z11 | z3;
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z4) {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2820invokeUv8p0NA(DrawScope drawScope, long j119) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j119, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            } else {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2820invokeUv8p0NA(DrawScope drawScope, long j119) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j119, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            function6 = (Function2) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -57345;
                        } else {
                            function6 = function4;
                        }
                        if (i6 != 0) {
                            c133410 = new Function3<DrawScope, Offset, Color, Unit>() {
                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    m2817invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                    return Unit.INSTANCE;
                                }

                                public final void m2817invokewPWG1Vc(DrawScope drawScope, long j119, long j1110) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j119, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j1110);
                                }
                            };
                        } else {
                            c133410 = function5;
                        }
                        if (i8 != 0) {
                            f4 = SliderKt.ThumbTrackGapSize;
                        } else {
                            f4 = f;
                        }
                        if (i10 != 0) {
                            f5 = SliderKt.TrackInsideCornerSize;
                        } else {
                            f5 = f3;
                        }
                        i13 = i3;
                        f6 = f4;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-541824132, i13, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1236)");
                    }
                    jM2805trackColorWaAFU9c$material3_release = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, false);
                    jM2805trackColorWaAFU9c$material3_release2 = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true);
                    function7 = function6;
                    f7 = f5;
                    jM2804tickColorWaAFU9c$material3_release = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, false);
                    jM2804tickColorWaAFU9c$material3_release2 = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, true);
                    SliderColors sliderColors11 = sliderColorsColors;
                    Modifier modifierM1066height3ABfNKs8 = SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), SliderKt.getTrackHeight());
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection8 = CompositionLocalsKt.getLocalLayoutDirection();
                    Modifier modifier10 = companion;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    objConsume = composerStartRestartGroup.consume(localLayoutDirection8);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (objConsume == LayoutDirection.Rtl) {
                        f8 = 180.0f;
                    } else {
                        f8 = 0.0f;
                    }
                    Modifier modifierRotate8 = RotateKt.rotate(modifierM1066height3ABfNKs8, f8);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800695691, "CC(remember):Slider.kt#9igjgp");
                    boolean z11117 = z2;
                    boolean zChangedInstance8 = composerStartRestartGroup.changedInstance(rangeSliderState) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release2) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release2);
                    if ((i13 & 3670016) == 1048576) {
                        z5 = true;
                    } else {
                        z5 = false;
                    }
                    boolean z11118 = z5 | zChangedInstance8;
                    if ((29360128 & i13) == 8388608) {
                        z6 = true;
                    } else {
                        z6 = false;
                    }
                    boolean z11119 = z11118 | z6;
                    if (((57344 & i13) ^ 24576) > 16384) {
                        function8 = function7;
                        if (composerStartRestartGroup.changed(function8)) {
                            j = jM2805trackColorWaAFU9c$material3_release;
                        }
                        z7 = true;
                        boolean z111110 = z11119 | z7;
                        if ((458752 & i13) == 131072) {
                            z8 = true;
                        } else {
                            z8 = false;
                        }
                        z9 = z111110 | z8;
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z9) {
                            final long j119 = j;
                            final float f1118 = f6;
                            final Function2<? super DrawScope, ? super Offset, Unit> function1111115 = function8;
                            final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1111116 = c133410;
                            objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j119, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f1118, f7, function1111115, function1111116, true);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            final long j1110 = j;
                            final float f1119 = f6;
                            final Function2<? super DrawScope, ? super Offset, Unit> function1111117 = function8;
                            final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1111118 = c133410;
                            objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j1110, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f1119, f7, function1111117, function1111118, true);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CanvasKt.Canvas(modifierRotate8, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        sliderColors3 = sliderColors11;
                        f9 = f6;
                        function9 = function8;
                        function10 = c133410;
                        f10 = f7;
                        z10 = z11117;
                        modifier2 = modifier10;
                    } else {
                        function8 = function7;
                    }
                    j = jM2805trackColorWaAFU9c$material3_release;
                    if ((i13 & 24576) == 16384) {
                        z7 = true;
                    } else {
                        z7 = false;
                    }
                    boolean z111111 = z11119 | z7;
                    if ((458752 & i13) == 131072) {
                        z8 = true;
                    } else {
                        z8 = false;
                    }
                    z9 = z111111 | z8;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z9) {
                        final long j1111 = j;
                        final float f11110 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function1111119 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function11111110 = c133410;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j1111, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f11110, f7, function1111119, function11111110, true);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        final long j1112 = j;
                        final float f11111 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function11111111 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function11111112 = c133410;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j1112, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f11111, f7, function11111111, function11111112, true);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CanvasKt.Canvas(modifierRotate8, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    sliderColors3 = sliderColors11;
                    f9 = f6;
                    function9 = function8;
                    function10 = c133410;
                    f10 = f7;
                    z10 = z11117;
                    modifier2 = modifier10;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i16 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                            i3 &= -7169;
                        } else {
                            sliderColorsColors = sliderColors2;
                        }
                        if ((i2 & 16) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800729349, "CC(remember):Slider.kt#9igjgp");
                            if (((i3 & 7168) ^ 3072) <= 2048) {
                            }
                            if ((i3 & 896) == 256) {
                                z3 = true;
                            } else {
                                z3 = false;
                            }
                            z4 = z11 | z3;
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z4) {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2820invokeUv8p0NA(DrawScope drawScope, long j1113) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j1113, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            } else {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2820invokeUv8p0NA(DrawScope drawScope, long j1113) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j1113, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            function6 = (Function2) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -57345;
                        } else {
                            function6 = function4;
                        }
                        if (i6 != 0) {
                            c133410 = new Function3<DrawScope, Offset, Color, Unit>() {
                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    m2817invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                    return Unit.INSTANCE;
                                }

                                public final void m2817invokewPWG1Vc(DrawScope drawScope, long j1113, long j1114) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j1113, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j1114);
                                }
                            };
                        } else {
                            c133410 = function5;
                        }
                        if (i8 != 0) {
                            f4 = SliderKt.ThumbTrackGapSize;
                        } else {
                            f4 = f;
                        }
                        if (i10 != 0) {
                            f5 = SliderKt.TrackInsideCornerSize;
                        } else {
                            f5 = f3;
                        }
                        i13 = i3;
                        f6 = f4;
                    } else {
                        if (i16 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i4 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 8) != 0) {
                            sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                            i3 &= -7169;
                        } else {
                            sliderColorsColors = sliderColors2;
                        }
                        if ((i2 & 16) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800729349, "CC(remember):Slider.kt#9igjgp");
                            if (((i3 & 7168) ^ 3072) <= 2048) {
                            }
                            if ((i3 & 896) == 256) {
                                z3 = true;
                            } else {
                                z3 = false;
                            }
                            z4 = z11 | z3;
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z4) {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2820invokeUv8p0NA(DrawScope drawScope, long j1113) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j1113, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            } else {
                                objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2820invokeUv8p0NA(DrawScope drawScope, long j1113) {
                                        SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j1113, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            function6 = (Function2) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -57345;
                        } else {
                            function6 = function4;
                        }
                        if (i6 != 0) {
                            c133410 = new Function3<DrawScope, Offset, Color, Unit>() {
                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    m2817invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                    return Unit.INSTANCE;
                                }

                                public final void m2817invokewPWG1Vc(DrawScope drawScope, long j1113, long j1114) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j1113, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j1114);
                                }
                            };
                        } else {
                            c133410 = function5;
                        }
                        if (i8 != 0) {
                            f4 = SliderKt.ThumbTrackGapSize;
                        } else {
                            f4 = f;
                        }
                        if (i10 != 0) {
                            f5 = SliderKt.TrackInsideCornerSize;
                        } else {
                            f5 = f3;
                        }
                        i13 = i3;
                        f6 = f4;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-541824132, i13, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1236)");
                    }
                    jM2805trackColorWaAFU9c$material3_release = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, false);
                    jM2805trackColorWaAFU9c$material3_release2 = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true);
                    function7 = function6;
                    f7 = f5;
                    jM2804tickColorWaAFU9c$material3_release = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, false);
                    jM2804tickColorWaAFU9c$material3_release2 = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, true);
                    SliderColors sliderColors12 = sliderColorsColors;
                    Modifier modifierM1066height3ABfNKs9 = SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), SliderKt.getTrackHeight());
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection9 = CompositionLocalsKt.getLocalLayoutDirection();
                    Modifier modifier11 = companion;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    objConsume = composerStartRestartGroup.consume(localLayoutDirection9);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (objConsume == LayoutDirection.Rtl) {
                        f8 = 180.0f;
                    } else {
                        f8 = 0.0f;
                    }
                    Modifier modifierRotate9 = RotateKt.rotate(modifierM1066height3ABfNKs9, f8);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800695691, "CC(remember):Slider.kt#9igjgp");
                    boolean z111112 = z2;
                    boolean zChangedInstance9 = composerStartRestartGroup.changedInstance(rangeSliderState) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release2) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release2);
                    if ((i13 & 3670016) == 1048576) {
                        z5 = true;
                    } else {
                        z5 = false;
                    }
                    boolean z111113 = z5 | zChangedInstance9;
                    if ((29360128 & i13) == 8388608) {
                        z6 = true;
                    } else {
                        z6 = false;
                    }
                    boolean z111114 = z111113 | z6;
                    if (((57344 & i13) ^ 24576) > 16384) {
                        function8 = function7;
                        if (composerStartRestartGroup.changed(function8)) {
                            j = jM2805trackColorWaAFU9c$material3_release;
                        }
                        z7 = true;
                        boolean z111115 = z111114 | z7;
                        if ((458752 & i13) == 131072) {
                            z8 = true;
                        } else {
                            z8 = false;
                        }
                        z9 = z111115 | z8;
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z9) {
                            final long j1113 = j;
                            final float f11112 = f6;
                            final Function2<? super DrawScope, ? super Offset, Unit> function11111113 = function8;
                            final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function11111114 = c133410;
                            objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j1113, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f11112, f7, function11111113, function11111114, true);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            final long j1114 = j;
                            final float f11113 = f6;
                            final Function2<? super DrawScope, ? super Offset, Unit> function11111115 = function8;
                            final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function11111116 = c133410;
                            objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j1114, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f11113, f7, function11111115, function11111116, true);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CanvasKt.Canvas(modifierRotate9, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        sliderColors3 = sliderColors12;
                        f9 = f6;
                        function9 = function8;
                        function10 = c133410;
                        f10 = f7;
                        z10 = z111112;
                        modifier2 = modifier11;
                    } else {
                        function8 = function7;
                    }
                    j = jM2805trackColorWaAFU9c$material3_release;
                    if ((i13 & 24576) == 16384) {
                        z7 = true;
                    } else {
                        z7 = false;
                    }
                    boolean z111116 = z111114 | z7;
                    if ((458752 & i13) == 131072) {
                        z8 = true;
                    } else {
                        z8 = false;
                    }
                    z9 = z111116 | z8;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z9) {
                        final long j1115 = j;
                        final float f11114 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function11111117 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function11111118 = c133410;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j1115, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f11114, f7, function11111117, function11111118, true);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        final long j1116 = j;
                        final float f11115 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function11111119 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function111111110 = c133410;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j1116, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f11115, f7, function11111119, function111111110, true);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CanvasKt.Canvas(modifierRotate9, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    sliderColors3 = sliderColors12;
                    f9 = f6;
                    function9 = function8;
                    function10 = c133410;
                    f10 = f7;
                    z10 = z111112;
                    modifier2 = modifier11;
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

                        public final void invoke(Composer composer2, int i17) {
                            SliderDefaults.this.m2812Track4EFweAY(rangeSliderState, modifier2, z10, sliderColors3, function9, function10, f9, f10, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i12 = 100663296;
            i3 |= i12;
            if ((38347923 & i3) == 38347922) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                        i3 &= -7169;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if ((i2 & 16) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800729349, "CC(remember):Slider.kt#9igjgp");
                        if (((i3 & 7168) ^ 3072) <= 2048) {
                        }
                        if ((i3 & 896) == 256) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z11 | z3;
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2820invokeUv8p0NA(DrawScope drawScope, long j1117) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j1117, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2820invokeUv8p0NA(DrawScope drawScope, long j1117) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j1117, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        function6 = (Function2) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -57345;
                    } else {
                        function6 = function4;
                    }
                    if (i6 != 0) {
                        c133410 = new Function3<DrawScope, Offset, Color, Unit>() {
                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                m2817invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                return Unit.INSTANCE;
                            }

                            public final void m2817invokewPWG1Vc(DrawScope drawScope, long j1117, long j1118) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j1117, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j1118);
                            }
                        };
                    } else {
                        c133410 = function5;
                    }
                    if (i8 != 0) {
                        f4 = SliderKt.ThumbTrackGapSize;
                    } else {
                        f4 = f;
                    }
                    if (i10 != 0) {
                        f5 = SliderKt.TrackInsideCornerSize;
                    } else {
                        f5 = f3;
                    }
                    i13 = i3;
                    f6 = f4;
                } else {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                        i3 &= -7169;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if ((i2 & 16) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800729349, "CC(remember):Slider.kt#9igjgp");
                        if (((i3 & 7168) ^ 3072) <= 2048) {
                        }
                        if ((i3 & 896) == 256) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z11 | z3;
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2820invokeUv8p0NA(DrawScope drawScope, long j1117) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j1117, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2820invokeUv8p0NA(DrawScope drawScope, long j1117) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j1117, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        function6 = (Function2) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -57345;
                    } else {
                        function6 = function4;
                    }
                    if (i6 != 0) {
                        c133410 = new Function3<DrawScope, Offset, Color, Unit>() {
                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                m2817invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                return Unit.INSTANCE;
                            }

                            public final void m2817invokewPWG1Vc(DrawScope drawScope, long j1117, long j1118) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j1117, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j1118);
                            }
                        };
                    } else {
                        c133410 = function5;
                    }
                    if (i8 != 0) {
                        f4 = SliderKt.ThumbTrackGapSize;
                    } else {
                        f4 = f;
                    }
                    if (i10 != 0) {
                        f5 = SliderKt.TrackInsideCornerSize;
                    } else {
                        f5 = f3;
                    }
                    i13 = i3;
                    f6 = f4;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-541824132, i13, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1236)");
                }
                jM2805trackColorWaAFU9c$material3_release = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, false);
                jM2805trackColorWaAFU9c$material3_release2 = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true);
                function7 = function6;
                f7 = f5;
                jM2804tickColorWaAFU9c$material3_release = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, false);
                jM2804tickColorWaAFU9c$material3_release2 = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, true);
                SliderColors sliderColors13 = sliderColorsColors;
                Modifier modifierM1066height3ABfNKs10 = SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), SliderKt.getTrackHeight());
                ProvidableCompositionLocal<LayoutDirection> localLayoutDirection10 = CompositionLocalsKt.getLocalLayoutDirection();
                Modifier modifier12 = companion;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                objConsume = composerStartRestartGroup.consume(localLayoutDirection10);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (objConsume == LayoutDirection.Rtl) {
                    f8 = 180.0f;
                } else {
                    f8 = 0.0f;
                }
                Modifier modifierRotate10 = RotateKt.rotate(modifierM1066height3ABfNKs10, f8);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800695691, "CC(remember):Slider.kt#9igjgp");
                boolean z111117 = z2;
                boolean zChangedInstance10 = composerStartRestartGroup.changedInstance(rangeSliderState) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release2) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release2);
                if ((i13 & 3670016) == 1048576) {
                    z5 = true;
                } else {
                    z5 = false;
                }
                boolean z111118 = z5 | zChangedInstance10;
                if ((29360128 & i13) == 8388608) {
                    z6 = true;
                } else {
                    z6 = false;
                }
                boolean z111119 = z111118 | z6;
                if (((57344 & i13) ^ 24576) > 16384) {
                    function8 = function7;
                    if (composerStartRestartGroup.changed(function8)) {
                        j = jM2805trackColorWaAFU9c$material3_release;
                    }
                    z7 = true;
                    boolean z1111110 = z111119 | z7;
                    if ((458752 & i13) == 131072) {
                        z8 = true;
                    } else {
                        z8 = false;
                    }
                    z9 = z1111110 | z8;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z9) {
                        final long j1117 = j;
                        final float f11116 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function111111111 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function111111112 = c133410;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j1117, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f11116, f7, function111111111, function111111112, true);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        final long j1118 = j;
                        final float f11117 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function111111113 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function111111114 = c133410;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j1118, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f11117, f7, function111111113, function111111114, true);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CanvasKt.Canvas(modifierRotate10, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    sliderColors3 = sliderColors13;
                    f9 = f6;
                    function9 = function8;
                    function10 = c133410;
                    f10 = f7;
                    z10 = z111117;
                    modifier2 = modifier12;
                } else {
                    function8 = function7;
                }
                j = jM2805trackColorWaAFU9c$material3_release;
                if ((i13 & 24576) == 16384) {
                    z7 = true;
                } else {
                    z7 = false;
                }
                boolean z1111111 = z111119 | z7;
                if ((458752 & i13) == 131072) {
                    z8 = true;
                } else {
                    z8 = false;
                }
                z9 = z1111111 | z8;
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z9) {
                    final long j1119 = j;
                    final float f11118 = f6;
                    final Function2<? super DrawScope, ? super Offset, Unit> function111111115 = function8;
                    final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function111111116 = c133410;
                    objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j1119, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f11118, f7, function111111115, function111111116, true);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    final long j11110 = j;
                    final float f11119 = f6;
                    final Function2<? super DrawScope, ? super Offset, Unit> function111111117 = function8;
                    final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function111111118 = c133410;
                    objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j11110, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f11119, f7, function111111117, function111111118, true);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CanvasKt.Canvas(modifierRotate10, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                sliderColors3 = sliderColors13;
                f9 = f6;
                function9 = function8;
                function10 = c133410;
                f10 = f7;
                z10 = z111117;
                modifier2 = modifier12;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                        i3 &= -7169;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if ((i2 & 16) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800729349, "CC(remember):Slider.kt#9igjgp");
                        if (((i3 & 7168) ^ 3072) <= 2048) {
                        }
                        if ((i3 & 896) == 256) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z11 | z3;
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2820invokeUv8p0NA(DrawScope drawScope, long j11111) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j11111, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2820invokeUv8p0NA(DrawScope drawScope, long j11111) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j11111, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        function6 = (Function2) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -57345;
                    } else {
                        function6 = function4;
                    }
                    if (i6 != 0) {
                        c133410 = new Function3<DrawScope, Offset, Color, Unit>() {
                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                m2817invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                return Unit.INSTANCE;
                            }

                            public final void m2817invokewPWG1Vc(DrawScope drawScope, long j11111, long j11112) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j11111, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j11112);
                            }
                        };
                    } else {
                        c133410 = function5;
                    }
                    if (i8 != 0) {
                        f4 = SliderKt.ThumbTrackGapSize;
                    } else {
                        f4 = f;
                    }
                    if (i10 != 0) {
                        f5 = SliderKt.TrackInsideCornerSize;
                    } else {
                        f5 = f3;
                    }
                    i13 = i3;
                    f6 = f4;
                } else {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                        i3 &= -7169;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if ((i2 & 16) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800729349, "CC(remember):Slider.kt#9igjgp");
                        if (((i3 & 7168) ^ 3072) <= 2048) {
                        }
                        if ((i3 & 896) == 256) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z11 | z3;
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2820invokeUv8p0NA(DrawScope drawScope, long j11111) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j11111, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2820invokeUv8p0NA(DrawScope drawScope, long j11111) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j11111, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        function6 = (Function2) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -57345;
                    } else {
                        function6 = function4;
                    }
                    if (i6 != 0) {
                        c133410 = new Function3<DrawScope, Offset, Color, Unit>() {
                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                m2817invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                return Unit.INSTANCE;
                            }

                            public final void m2817invokewPWG1Vc(DrawScope drawScope, long j11111, long j11112) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j11111, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j11112);
                            }
                        };
                    } else {
                        c133410 = function5;
                    }
                    if (i8 != 0) {
                        f4 = SliderKt.ThumbTrackGapSize;
                    } else {
                        f4 = f;
                    }
                    if (i10 != 0) {
                        f5 = SliderKt.TrackInsideCornerSize;
                    } else {
                        f5 = f3;
                    }
                    i13 = i3;
                    f6 = f4;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-541824132, i13, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1236)");
                }
                jM2805trackColorWaAFU9c$material3_release = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, false);
                jM2805trackColorWaAFU9c$material3_release2 = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true);
                function7 = function6;
                f7 = f5;
                jM2804tickColorWaAFU9c$material3_release = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, false);
                jM2804tickColorWaAFU9c$material3_release2 = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, true);
                SliderColors sliderColors14 = sliderColorsColors;
                Modifier modifierM1066height3ABfNKs11 = SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), SliderKt.getTrackHeight());
                ProvidableCompositionLocal<LayoutDirection> localLayoutDirection11 = CompositionLocalsKt.getLocalLayoutDirection();
                Modifier modifier13 = companion;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                objConsume = composerStartRestartGroup.consume(localLayoutDirection11);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (objConsume == LayoutDirection.Rtl) {
                    f8 = 180.0f;
                } else {
                    f8 = 0.0f;
                }
                Modifier modifierRotate11 = RotateKt.rotate(modifierM1066height3ABfNKs11, f8);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800695691, "CC(remember):Slider.kt#9igjgp");
                boolean z1111112 = z2;
                boolean zChangedInstance11 = composerStartRestartGroup.changedInstance(rangeSliderState) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release2) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release2);
                if ((i13 & 3670016) == 1048576) {
                    z5 = true;
                } else {
                    z5 = false;
                }
                boolean z1111113 = z5 | zChangedInstance11;
                if ((29360128 & i13) == 8388608) {
                    z6 = true;
                } else {
                    z6 = false;
                }
                boolean z1111114 = z1111113 | z6;
                if (((57344 & i13) ^ 24576) > 16384) {
                    function8 = function7;
                    if (composerStartRestartGroup.changed(function8)) {
                        j = jM2805trackColorWaAFU9c$material3_release;
                    }
                    z7 = true;
                    boolean z1111115 = z1111114 | z7;
                    if ((458752 & i13) == 131072) {
                        z8 = true;
                    } else {
                        z8 = false;
                    }
                    z9 = z1111115 | z8;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z9) {
                        final long j11111 = j;
                        final float f111110 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function111111119 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1111111110 = c133410;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j11111, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f111110, f7, function111111119, function1111111110, true);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        final long j11112 = j;
                        final float f111111 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function1111111111 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1111111112 = c133410;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j11112, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f111111, f7, function1111111111, function1111111112, true);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CanvasKt.Canvas(modifierRotate11, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    sliderColors3 = sliderColors14;
                    f9 = f6;
                    function9 = function8;
                    function10 = c133410;
                    f10 = f7;
                    z10 = z1111112;
                    modifier2 = modifier13;
                } else {
                    function8 = function7;
                }
                j = jM2805trackColorWaAFU9c$material3_release;
                if ((i13 & 24576) == 16384) {
                    z7 = true;
                } else {
                    z7 = false;
                }
                boolean z1111116 = z1111114 | z7;
                if ((458752 & i13) == 131072) {
                    z8 = true;
                } else {
                    z8 = false;
                }
                z9 = z1111116 | z8;
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z9) {
                    final long j11113 = j;
                    final float f111112 = f6;
                    final Function2<? super DrawScope, ? super Offset, Unit> function1111111113 = function8;
                    final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1111111114 = c133410;
                    objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j11113, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f111112, f7, function1111111113, function1111111114, true);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    final long j11114 = j;
                    final float f111113 = f6;
                    final Function2<? super DrawScope, ? super Offset, Unit> function1111111115 = function8;
                    final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1111111116 = c133410;
                    objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j11114, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f111113, f7, function1111111115, function1111111116, true);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CanvasKt.Canvas(modifierRotate11, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                sliderColors3 = sliderColors14;
                f9 = f6;
                function9 = function8;
                function10 = c133410;
                f10 = f7;
                z10 = z1111112;
                modifier2 = modifier13;
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

                    public final void invoke(Composer composer2, int i17) {
                        SliderDefaults.this.m2812Track4EFweAY(rangeSliderState, modifier2, z10, sliderColors3, function9, function10, f9, f10, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 384;
        z2 = z;
        if ((i & 3072) == 0) {
            if ((i2 & 8) == 0) {
                sliderColors2 = sliderColors;
                if (composerStartRestartGroup.changed(sliderColors2)) {
                    i15 = Fields.CameraDistance;
                }
                i3 |= i15;
            } else {
                sliderColors2 = sliderColors;
            }
            i15 = Fields.RotationZ;
            i3 |= i15;
        } else {
            sliderColors2 = sliderColors;
        }
        if ((i & 24576) == 0) {
            if ((i2 & 16) == 0) {
                function4 = function2;
                if (composerStartRestartGroup.changedInstance(function4)) {
                    i14 = Fields.Clip;
                }
                i3 |= i14;
            } else {
                function4 = function2;
            }
            i14 = Fields.Shape;
            i3 |= i14;
        } else {
            function4 = function2;
        }
        i6 = i2 & 32;
        if (i6 != 0) {
            i3 |= 196608;
            function5 = function3;
        } else {
            function5 = function3;
            if ((i & 196608) == 0) {
                if (composerStartRestartGroup.changedInstance(function5)) {
                    i7 = Fields.RenderEffect;
                } else {
                    i7 = 65536;
                }
                i3 |= i7;
            }
        }
        i8 = i2 & 64;
        if (i8 != 0) {
            i3 |= 1572864;
        } else if ((i & 1572864) == 0) {
            if (composerStartRestartGroup.changed(f)) {
                i9 = 1048576;
            } else {
                i9 = 524288;
            }
            i3 |= i9;
        }
        i10 = i2 & Fields.SpotShadowColor;
        if (i10 != 0) {
            i3 |= 12582912;
            f3 = f2;
        } else {
            f3 = f2;
            if ((i & 12582912) == 0) {
                if (composerStartRestartGroup.changed(f3)) {
                    i11 = 8388608;
                } else {
                    i11 = 4194304;
                }
                i3 |= i11;
            }
        }
        if ((i2 & Fields.RotationX) != 0) {
            if ((100663296 & i) == 0) {
                if (composerStartRestartGroup.changed(this)) {
                    i12 = 67108864;
                } else {
                    i12 = 33554432;
                }
            }
            if ((38347923 & i3) == 38347922) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                        i3 &= -7169;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if ((i2 & 16) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800729349, "CC(remember):Slider.kt#9igjgp");
                        if (((i3 & 7168) ^ 3072) <= 2048) {
                        }
                        if ((i3 & 896) == 256) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z11 | z3;
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2820invokeUv8p0NA(DrawScope drawScope, long j11115) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j11115, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2820invokeUv8p0NA(DrawScope drawScope, long j11115) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j11115, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        function6 = (Function2) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -57345;
                    } else {
                        function6 = function4;
                    }
                    if (i6 != 0) {
                        c133410 = new Function3<DrawScope, Offset, Color, Unit>() {
                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                m2817invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                return Unit.INSTANCE;
                            }

                            public final void m2817invokewPWG1Vc(DrawScope drawScope, long j11115, long j11116) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j11115, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j11116);
                            }
                        };
                    } else {
                        c133410 = function5;
                    }
                    if (i8 != 0) {
                        f4 = SliderKt.ThumbTrackGapSize;
                    } else {
                        f4 = f;
                    }
                    if (i10 != 0) {
                        f5 = SliderKt.TrackInsideCornerSize;
                    } else {
                        f5 = f3;
                    }
                    i13 = i3;
                    f6 = f4;
                } else {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                        i3 &= -7169;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if ((i2 & 16) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800729349, "CC(remember):Slider.kt#9igjgp");
                        if (((i3 & 7168) ^ 3072) <= 2048) {
                        }
                        if ((i3 & 896) == 256) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z11 | z3;
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2820invokeUv8p0NA(DrawScope drawScope, long j11115) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j11115, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2820invokeUv8p0NA(DrawScope drawScope, long j11115) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j11115, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        function6 = (Function2) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -57345;
                    } else {
                        function6 = function4;
                    }
                    if (i6 != 0) {
                        c133410 = new Function3<DrawScope, Offset, Color, Unit>() {
                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                m2817invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                return Unit.INSTANCE;
                            }

                            public final void m2817invokewPWG1Vc(DrawScope drawScope, long j11115, long j11116) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j11115, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j11116);
                            }
                        };
                    } else {
                        c133410 = function5;
                    }
                    if (i8 != 0) {
                        f4 = SliderKt.ThumbTrackGapSize;
                    } else {
                        f4 = f;
                    }
                    if (i10 != 0) {
                        f5 = SliderKt.TrackInsideCornerSize;
                    } else {
                        f5 = f3;
                    }
                    i13 = i3;
                    f6 = f4;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-541824132, i13, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1236)");
                }
                jM2805trackColorWaAFU9c$material3_release = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, false);
                jM2805trackColorWaAFU9c$material3_release2 = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true);
                function7 = function6;
                f7 = f5;
                jM2804tickColorWaAFU9c$material3_release = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, false);
                jM2804tickColorWaAFU9c$material3_release2 = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, true);
                SliderColors sliderColors15 = sliderColorsColors;
                Modifier modifierM1066height3ABfNKs12 = SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), SliderKt.getTrackHeight());
                ProvidableCompositionLocal<LayoutDirection> localLayoutDirection12 = CompositionLocalsKt.getLocalLayoutDirection();
                Modifier modifier14 = companion;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                objConsume = composerStartRestartGroup.consume(localLayoutDirection12);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (objConsume == LayoutDirection.Rtl) {
                    f8 = 180.0f;
                } else {
                    f8 = 0.0f;
                }
                Modifier modifierRotate12 = RotateKt.rotate(modifierM1066height3ABfNKs12, f8);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800695691, "CC(remember):Slider.kt#9igjgp");
                boolean z1111117 = z2;
                boolean zChangedInstance12 = composerStartRestartGroup.changedInstance(rangeSliderState) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release2) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release2);
                if ((i13 & 3670016) == 1048576) {
                    z5 = true;
                } else {
                    z5 = false;
                }
                boolean z1111118 = z5 | zChangedInstance12;
                if ((29360128 & i13) == 8388608) {
                    z6 = true;
                } else {
                    z6 = false;
                }
                boolean z1111119 = z1111118 | z6;
                if (((57344 & i13) ^ 24576) > 16384) {
                    function8 = function7;
                    if (composerStartRestartGroup.changed(function8)) {
                        j = jM2805trackColorWaAFU9c$material3_release;
                    }
                    z7 = true;
                    boolean z11111110 = z1111119 | z7;
                    if ((458752 & i13) == 131072) {
                        z8 = true;
                    } else {
                        z8 = false;
                    }
                    z9 = z11111110 | z8;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z9) {
                        final long j11115 = j;
                        final float f111114 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function1111111117 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1111111118 = c133410;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j11115, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f111114, f7, function1111111117, function1111111118, true);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        final long j11116 = j;
                        final float f111115 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function1111111119 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function11111111110 = c133410;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j11116, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f111115, f7, function1111111119, function11111111110, true);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CanvasKt.Canvas(modifierRotate12, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    sliderColors3 = sliderColors15;
                    f9 = f6;
                    function9 = function8;
                    function10 = c133410;
                    f10 = f7;
                    z10 = z1111117;
                    modifier2 = modifier14;
                } else {
                    function8 = function7;
                }
                j = jM2805trackColorWaAFU9c$material3_release;
                if ((i13 & 24576) == 16384) {
                    z7 = true;
                } else {
                    z7 = false;
                }
                boolean z11111111 = z1111119 | z7;
                if ((458752 & i13) == 131072) {
                    z8 = true;
                } else {
                    z8 = false;
                }
                z9 = z11111111 | z8;
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z9) {
                    final long j11117 = j;
                    final float f111116 = f6;
                    final Function2<? super DrawScope, ? super Offset, Unit> function11111111111 = function8;
                    final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function11111111112 = c133410;
                    objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j11117, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f111116, f7, function11111111111, function11111111112, true);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    final long j11118 = j;
                    final float f111117 = f6;
                    final Function2<? super DrawScope, ? super Offset, Unit> function11111111113 = function8;
                    final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function11111111114 = c133410;
                    objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j11118, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f111117, f7, function11111111113, function11111111114, true);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CanvasKt.Canvas(modifierRotate12, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                sliderColors3 = sliderColors15;
                f9 = f6;
                function9 = function8;
                function10 = c133410;
                f10 = f7;
                z10 = z1111117;
                modifier2 = modifier14;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                        i3 &= -7169;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if ((i2 & 16) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800729349, "CC(remember):Slider.kt#9igjgp");
                        if (((i3 & 7168) ^ 3072) <= 2048) {
                        }
                        if ((i3 & 896) == 256) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z11 | z3;
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2820invokeUv8p0NA(DrawScope drawScope, long j11119) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j11119, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2820invokeUv8p0NA(DrawScope drawScope, long j11119) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j11119, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        function6 = (Function2) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -57345;
                    } else {
                        function6 = function4;
                    }
                    if (i6 != 0) {
                        c133410 = new Function3<DrawScope, Offset, Color, Unit>() {
                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                m2817invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                return Unit.INSTANCE;
                            }

                            public final void m2817invokewPWG1Vc(DrawScope drawScope, long j11119, long j111110) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j11119, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j111110);
                            }
                        };
                    } else {
                        c133410 = function5;
                    }
                    if (i8 != 0) {
                        f4 = SliderKt.ThumbTrackGapSize;
                    } else {
                        f4 = f;
                    }
                    if (i10 != 0) {
                        f5 = SliderKt.TrackInsideCornerSize;
                    } else {
                        f5 = f3;
                    }
                    i13 = i3;
                    f6 = f4;
                } else {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i4 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 8) != 0) {
                        sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                        i3 &= -7169;
                    } else {
                        sliderColorsColors = sliderColors2;
                    }
                    if ((i2 & 16) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800729349, "CC(remember):Slider.kt#9igjgp");
                        if (((i3 & 7168) ^ 3072) <= 2048) {
                        }
                        if ((i3 & 896) == 256) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z11 | z3;
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2820invokeUv8p0NA(DrawScope drawScope, long j11119) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j11119, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                    return Unit.INSTANCE;
                                }

                                public final void m2820invokeUv8p0NA(DrawScope drawScope, long j11119) {
                                    SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j11119, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        function6 = (Function2) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -57345;
                    } else {
                        function6 = function4;
                    }
                    if (i6 != 0) {
                        c133410 = new Function3<DrawScope, Offset, Color, Unit>() {
                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                m2817invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                                return Unit.INSTANCE;
                            }

                            public final void m2817invokewPWG1Vc(DrawScope drawScope, long j11119, long j111110) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j11119, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j111110);
                            }
                        };
                    } else {
                        c133410 = function5;
                    }
                    if (i8 != 0) {
                        f4 = SliderKt.ThumbTrackGapSize;
                    } else {
                        f4 = f;
                    }
                    if (i10 != 0) {
                        f5 = SliderKt.TrackInsideCornerSize;
                    } else {
                        f5 = f3;
                    }
                    i13 = i3;
                    f6 = f4;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-541824132, i13, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1236)");
                }
                jM2805trackColorWaAFU9c$material3_release = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, false);
                jM2805trackColorWaAFU9c$material3_release2 = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true);
                function7 = function6;
                f7 = f5;
                jM2804tickColorWaAFU9c$material3_release = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, false);
                jM2804tickColorWaAFU9c$material3_release2 = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, true);
                SliderColors sliderColors16 = sliderColorsColors;
                Modifier modifierM1066height3ABfNKs13 = SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), SliderKt.getTrackHeight());
                ProvidableCompositionLocal<LayoutDirection> localLayoutDirection13 = CompositionLocalsKt.getLocalLayoutDirection();
                Modifier modifier15 = companion;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                objConsume = composerStartRestartGroup.consume(localLayoutDirection13);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (objConsume == LayoutDirection.Rtl) {
                    f8 = 180.0f;
                } else {
                    f8 = 0.0f;
                }
                Modifier modifierRotate13 = RotateKt.rotate(modifierM1066height3ABfNKs13, f8);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800695691, "CC(remember):Slider.kt#9igjgp");
                boolean z11111112 = z2;
                boolean zChangedInstance13 = composerStartRestartGroup.changedInstance(rangeSliderState) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release2) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release2);
                if ((i13 & 3670016) == 1048576) {
                    z5 = true;
                } else {
                    z5 = false;
                }
                boolean z11111113 = z5 | zChangedInstance13;
                if ((29360128 & i13) == 8388608) {
                    z6 = true;
                } else {
                    z6 = false;
                }
                boolean z11111114 = z11111113 | z6;
                if (((57344 & i13) ^ 24576) > 16384) {
                    function8 = function7;
                    if (composerStartRestartGroup.changed(function8)) {
                        j = jM2805trackColorWaAFU9c$material3_release;
                    }
                    z7 = true;
                    boolean z11111115 = z11111114 | z7;
                    if ((458752 & i13) == 131072) {
                        z8 = true;
                    } else {
                        z8 = false;
                    }
                    z9 = z11111115 | z8;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z9) {
                        final long j11119 = j;
                        final float f111118 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function11111111115 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function11111111116 = c133410;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j11119, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f111118, f7, function11111111115, function11111111116, true);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        final long j111110 = j;
                        final float f111119 = f6;
                        final Function2<? super DrawScope, ? super Offset, Unit> function11111111117 = function8;
                        final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function11111111118 = c133410;
                        objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j111110, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f111119, f7, function11111111117, function11111111118, true);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CanvasKt.Canvas(modifierRotate13, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    sliderColors3 = sliderColors16;
                    f9 = f6;
                    function9 = function8;
                    function10 = c133410;
                    f10 = f7;
                    z10 = z11111112;
                    modifier2 = modifier15;
                } else {
                    function8 = function7;
                }
                j = jM2805trackColorWaAFU9c$material3_release;
                if ((i13 & 24576) == 16384) {
                    z7 = true;
                } else {
                    z7 = false;
                }
                boolean z11111116 = z11111114 | z7;
                if ((458752 & i13) == 131072) {
                    z8 = true;
                } else {
                    z8 = false;
                }
                z9 = z11111116 | z8;
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z9) {
                    final long j111111 = j;
                    final float f1111110 = f6;
                    final Function2<? super DrawScope, ? super Offset, Unit> function11111111119 = function8;
                    final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function111111111110 = c133410;
                    objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j111111, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f1111110, f7, function11111111119, function111111111110, true);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    final long j111112 = j;
                    final float f1111111 = f6;
                    final Function2<? super DrawScope, ? super Offset, Unit> function111111111111 = function8;
                    final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function111111111112 = c133410;
                    objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j111112, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f1111111, f7, function111111111111, function111111111112, true);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CanvasKt.Canvas(modifierRotate13, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                sliderColors3 = sliderColors16;
                f9 = f6;
                function9 = function8;
                function10 = c133410;
                f10 = f7;
                z10 = z11111112;
                modifier2 = modifier15;
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

                    public final void invoke(Composer composer2, int i17) {
                        SliderDefaults.this.m2812Track4EFweAY(rangeSliderState, modifier2, z10, sliderColors3, function9, function10, f9, f10, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i12 = 100663296;
        i3 |= i12;
        if ((38347923 & i3) == 38347922) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i16 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i4 != 0) {
                    z2 = true;
                }
                if ((i2 & 8) != 0) {
                    sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                    i3 &= -7169;
                } else {
                    sliderColorsColors = sliderColors2;
                }
                if ((i2 & 16) != 0) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800729349, "CC(remember):Slider.kt#9igjgp");
                    if (((i3 & 7168) ^ 3072) <= 2048) {
                    }
                    if ((i3 & 896) == 256) {
                        z3 = true;
                    } else {
                        z3 = false;
                    }
                    z4 = z11 | z3;
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                return Unit.INSTANCE;
                            }

                            public final void m2820invokeUv8p0NA(DrawScope drawScope, long j111113) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j111113, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                return Unit.INSTANCE;
                            }

                            public final void m2820invokeUv8p0NA(DrawScope drawScope, long j111113) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j111113, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    function6 = (Function2) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    i3 &= -57345;
                } else {
                    function6 = function4;
                }
                if (i6 != 0) {
                    c133410 = new Function3<DrawScope, Offset, Color, Unit>() {
                        public Object invoke(Object obj, Object obj2, Object obj3) {
                            m2817invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                            return Unit.INSTANCE;
                        }

                        public final void m2817invokewPWG1Vc(DrawScope drawScope, long j111113, long j111114) {
                            SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j111113, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j111114);
                        }
                    };
                } else {
                    c133410 = function5;
                }
                if (i8 != 0) {
                    f4 = SliderKt.ThumbTrackGapSize;
                } else {
                    f4 = f;
                }
                if (i10 != 0) {
                    f5 = SliderKt.TrackInsideCornerSize;
                } else {
                    f5 = f3;
                }
                i13 = i3;
                f6 = f4;
            } else {
                if (i16 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i4 != 0) {
                    z2 = true;
                }
                if ((i2 & 8) != 0) {
                    sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                    i3 &= -7169;
                } else {
                    sliderColorsColors = sliderColors2;
                }
                if ((i2 & 16) != 0) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800729349, "CC(remember):Slider.kt#9igjgp");
                    if (((i3 & 7168) ^ 3072) <= 2048) {
                    }
                    if ((i3 & 896) == 256) {
                        z3 = true;
                    } else {
                        z3 = false;
                    }
                    z4 = z11 | z3;
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                return Unit.INSTANCE;
                            }

                            public final void m2820invokeUv8p0NA(DrawScope drawScope, long j111113) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j111113, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                return Unit.INSTANCE;
                            }

                            public final void m2820invokeUv8p0NA(DrawScope drawScope, long j111113) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j111113, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    function6 = (Function2) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    i3 &= -57345;
                } else {
                    function6 = function4;
                }
                if (i6 != 0) {
                    c133410 = new Function3<DrawScope, Offset, Color, Unit>() {
                        public Object invoke(Object obj, Object obj2, Object obj3) {
                            m2817invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                            return Unit.INSTANCE;
                        }

                        public final void m2817invokewPWG1Vc(DrawScope drawScope, long j111113, long j111114) {
                            SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j111113, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j111114);
                        }
                    };
                } else {
                    c133410 = function5;
                }
                if (i8 != 0) {
                    f4 = SliderKt.ThumbTrackGapSize;
                } else {
                    f4 = f;
                }
                if (i10 != 0) {
                    f5 = SliderKt.TrackInsideCornerSize;
                } else {
                    f5 = f3;
                }
                i13 = i3;
                f6 = f4;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-541824132, i13, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1236)");
            }
            jM2805trackColorWaAFU9c$material3_release = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, false);
            jM2805trackColorWaAFU9c$material3_release2 = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true);
            function7 = function6;
            f7 = f5;
            jM2804tickColorWaAFU9c$material3_release = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, false);
            jM2804tickColorWaAFU9c$material3_release2 = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, true);
            SliderColors sliderColors17 = sliderColorsColors;
            Modifier modifierM1066height3ABfNKs14 = SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), SliderKt.getTrackHeight());
            ProvidableCompositionLocal<LayoutDirection> localLayoutDirection14 = CompositionLocalsKt.getLocalLayoutDirection();
            Modifier modifier16 = companion;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            objConsume = composerStartRestartGroup.consume(localLayoutDirection14);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            if (objConsume == LayoutDirection.Rtl) {
                f8 = 180.0f;
            } else {
                f8 = 0.0f;
            }
            Modifier modifierRotate14 = RotateKt.rotate(modifierM1066height3ABfNKs14, f8);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800695691, "CC(remember):Slider.kt#9igjgp");
            boolean z11111117 = z2;
            boolean zChangedInstance14 = composerStartRestartGroup.changedInstance(rangeSliderState) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release2) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release2);
            if ((i13 & 3670016) == 1048576) {
                z5 = true;
            } else {
                z5 = false;
            }
            boolean z11111118 = z5 | zChangedInstance14;
            if ((29360128 & i13) == 8388608) {
                z6 = true;
            } else {
                z6 = false;
            }
            boolean z11111119 = z11111118 | z6;
            if (((57344 & i13) ^ 24576) > 16384) {
                function8 = function7;
                if (composerStartRestartGroup.changed(function8)) {
                    j = jM2805trackColorWaAFU9c$material3_release;
                }
                z7 = true;
                boolean z111111110 = z11111119 | z7;
                if ((458752 & i13) == 131072) {
                    z8 = true;
                } else {
                    z8 = false;
                }
                z9 = z111111110 | z8;
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z9) {
                    final long j111113 = j;
                    final float f1111112 = f6;
                    final Function2<? super DrawScope, ? super Offset, Unit> function111111111113 = function8;
                    final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function111111111114 = c133410;
                    objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j111113, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f1111112, f7, function111111111113, function111111111114, true);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    final long j111114 = j;
                    final float f1111113 = f6;
                    final Function2<? super DrawScope, ? super Offset, Unit> function111111111115 = function8;
                    final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function111111111116 = c133410;
                    objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j111114, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f1111113, f7, function111111111115, function111111111116, true);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CanvasKt.Canvas(modifierRotate14, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                sliderColors3 = sliderColors17;
                f9 = f6;
                function9 = function8;
                function10 = c133410;
                f10 = f7;
                z10 = z11111117;
                modifier2 = modifier16;
            } else {
                function8 = function7;
            }
            j = jM2805trackColorWaAFU9c$material3_release;
            if ((i13 & 24576) == 16384) {
                z7 = true;
            } else {
                z7 = false;
            }
            boolean z111111111 = z11111119 | z7;
            if ((458752 & i13) == 131072) {
                z8 = true;
            } else {
                z8 = false;
            }
            z9 = z111111111 | z8;
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (!z9) {
                final long j111115 = j;
                final float f1111114 = f6;
                final Function2<? super DrawScope, ? super Offset, Unit> function111111111117 = function8;
                final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function111111111118 = c133410;
                objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((DrawScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(DrawScope drawScope) {
                        SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j111115, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f1111114, f7, function111111111117, function111111111118, true);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            } else {
                final long j111116 = j;
                final float f1111115 = f6;
                final Function2<? super DrawScope, ? super Offset, Unit> function111111111119 = function8;
                final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1111111111110 = c133410;
                objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((DrawScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(DrawScope drawScope) {
                        SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j111116, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f1111115, f7, function111111111119, function1111111111110, true);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            CanvasKt.Canvas(modifierRotate14, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            sliderColors3 = sliderColors17;
            f9 = f6;
            function9 = function8;
            function10 = c133410;
            f10 = f7;
            z10 = z11111117;
            modifier2 = modifier16;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i16 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i4 != 0) {
                    z2 = true;
                }
                if ((i2 & 8) != 0) {
                    sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                    i3 &= -7169;
                } else {
                    sliderColorsColors = sliderColors2;
                }
                if ((i2 & 16) != 0) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800729349, "CC(remember):Slider.kt#9igjgp");
                    if (((i3 & 7168) ^ 3072) <= 2048) {
                    }
                    if ((i3 & 896) == 256) {
                        z3 = true;
                    } else {
                        z3 = false;
                    }
                    z4 = z11 | z3;
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                return Unit.INSTANCE;
                            }

                            public final void m2820invokeUv8p0NA(DrawScope drawScope, long j111117) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j111117, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                return Unit.INSTANCE;
                            }

                            public final void m2820invokeUv8p0NA(DrawScope drawScope, long j111117) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j111117, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    function6 = (Function2) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    i3 &= -57345;
                } else {
                    function6 = function4;
                }
                if (i6 != 0) {
                    c133410 = new Function3<DrawScope, Offset, Color, Unit>() {
                        public Object invoke(Object obj, Object obj2, Object obj3) {
                            m2817invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                            return Unit.INSTANCE;
                        }

                        public final void m2817invokewPWG1Vc(DrawScope drawScope, long j111117, long j111118) {
                            SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j111117, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j111118);
                        }
                    };
                } else {
                    c133410 = function5;
                }
                if (i8 != 0) {
                    f4 = SliderKt.ThumbTrackGapSize;
                } else {
                    f4 = f;
                }
                if (i10 != 0) {
                    f5 = SliderKt.TrackInsideCornerSize;
                } else {
                    f5 = f3;
                }
                i13 = i3;
                f6 = f4;
            } else {
                if (i16 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i4 != 0) {
                    z2 = true;
                }
                if ((i2 & 8) != 0) {
                    sliderColorsColors = colors(composerStartRestartGroup, (i3 >> 24) & 14);
                    i3 &= -7169;
                } else {
                    sliderColorsColors = sliderColors2;
                }
                if ((i2 & 16) != 0) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800729349, "CC(remember):Slider.kt#9igjgp");
                    if (((i3 & 7168) ^ 3072) <= 2048) {
                    }
                    if ((i3 & 896) == 256) {
                        z3 = true;
                    } else {
                        z3 = false;
                    }
                    z4 = z11 | z3;
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                return Unit.INSTANCE;
                            }

                            public final void m2820invokeUv8p0NA(DrawScope drawScope, long j111117) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j111117, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function2) new Function2<DrawScope, Offset, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                m2820invokeUv8p0NA((DrawScope) obj, ((Offset) obj2).getPackedValue());
                                return Unit.INSTANCE;
                            }

                            public final void m2820invokeUv8p0NA(DrawScope drawScope, long j111117) {
                                SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j111117, SliderDefaults.INSTANCE.m2816getTrackStopIndicatorSizeD9Ej5fM(), sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    function6 = (Function2) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    i3 &= -57345;
                } else {
                    function6 = function4;
                }
                if (i6 != 0) {
                    c133410 = new Function3<DrawScope, Offset, Color, Unit>() {
                        public Object invoke(Object obj, Object obj2, Object obj3) {
                            m2817invokewPWG1Vc((DrawScope) obj, ((Offset) obj2).getPackedValue(), ((Color) obj3).m4600unboximpl());
                            return Unit.INSTANCE;
                        }

                        public final void m2817invokewPWG1Vc(DrawScope drawScope, long j111117, long j111118) {
                            SliderDefaults.INSTANCE.m2808drawStopIndicatorx3O1jOs(drawScope, j111117, SliderDefaults.INSTANCE.m2815getTickSizeD9Ej5fM(), j111118);
                        }
                    };
                } else {
                    c133410 = function5;
                }
                if (i8 != 0) {
                    f4 = SliderKt.ThumbTrackGapSize;
                } else {
                    f4 = f;
                }
                if (i10 != 0) {
                    f5 = SliderKt.TrackInsideCornerSize;
                } else {
                    f5 = f3;
                }
                i13 = i3;
                f6 = f4;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-541824132, i13, -1, "androidx.compose.material3.SliderDefaults.Track (Slider.kt:1236)");
            }
            jM2805trackColorWaAFU9c$material3_release = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, false);
            jM2805trackColorWaAFU9c$material3_release2 = sliderColorsColors.m2805trackColorWaAFU9c$material3_release(z2, true);
            function7 = function6;
            f7 = f5;
            jM2804tickColorWaAFU9c$material3_release = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, false);
            jM2804tickColorWaAFU9c$material3_release2 = sliderColorsColors.m2804tickColorWaAFU9c$material3_release(z2, true);
            SliderColors sliderColors18 = sliderColorsColors;
            Modifier modifierM1066height3ABfNKs15 = SizeKt.m1066height3ABfNKs(SizeKt.fillMaxWidth$default(companion, 0.0f, 1, null), SliderKt.getTrackHeight());
            ProvidableCompositionLocal<LayoutDirection> localLayoutDirection15 = CompositionLocalsKt.getLocalLayoutDirection();
            Modifier modifier17 = companion;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            objConsume = composerStartRestartGroup.consume(localLayoutDirection15);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            if (objConsume == LayoutDirection.Rtl) {
                f8 = 180.0f;
            } else {
                f8 = 0.0f;
            }
            Modifier modifierRotate15 = RotateKt.rotate(modifierM1066height3ABfNKs15, f8);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -800695691, "CC(remember):Slider.kt#9igjgp");
            boolean z111111112 = z2;
            boolean zChangedInstance15 = composerStartRestartGroup.changedInstance(rangeSliderState) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2805trackColorWaAFU9c$material3_release2) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release) | composerStartRestartGroup.changed(jM2804tickColorWaAFU9c$material3_release2);
            if ((i13 & 3670016) == 1048576) {
                z5 = true;
            } else {
                z5 = false;
            }
            boolean z111111113 = z5 | zChangedInstance15;
            if ((29360128 & i13) == 8388608) {
                z6 = true;
            } else {
                z6 = false;
            }
            boolean z111111114 = z111111113 | z6;
            if (((57344 & i13) ^ 24576) > 16384) {
                function8 = function7;
                if (composerStartRestartGroup.changed(function8)) {
                    j = jM2805trackColorWaAFU9c$material3_release;
                }
                z7 = true;
                boolean z111111115 = z111111114 | z7;
                if ((458752 & i13) == 131072) {
                    z8 = true;
                } else {
                    z8 = false;
                }
                z9 = z111111115 | z8;
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z9) {
                    final long j111117 = j;
                    final float f1111116 = f6;
                    final Function2<? super DrawScope, ? super Offset, Unit> function1111111111111 = function8;
                    final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1111111111112 = c133410;
                    objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j111117, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f1111116, f7, function1111111111111, function1111111111112, true);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    final long j111118 = j;
                    final float f1111117 = f6;
                    final Function2<? super DrawScope, ? super Offset, Unit> function1111111111113 = function8;
                    final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1111111111114 = c133410;
                    objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j111118, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f1111117, f7, function1111111111113, function1111111111114, true);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CanvasKt.Canvas(modifierRotate15, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                sliderColors3 = sliderColors18;
                f9 = f6;
                function9 = function8;
                function10 = c133410;
                f10 = f7;
                z10 = z111111112;
                modifier2 = modifier17;
            } else {
                function8 = function7;
            }
            j = jM2805trackColorWaAFU9c$material3_release;
            if ((i13 & 24576) == 16384) {
                z7 = true;
            } else {
                z7 = false;
            }
            boolean z111111116 = z111111114 | z7;
            if ((458752 & i13) == 131072) {
                z8 = true;
            } else {
                z8 = false;
            }
            z9 = z111111116 | z8;
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (!z9) {
                final long j111119 = j;
                final float f1111118 = f6;
                final Function2<? super DrawScope, ? super Offset, Unit> function1111111111115 = function8;
                final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1111111111116 = c133410;
                objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((DrawScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(DrawScope drawScope) {
                        SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j111119, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f1111118, f7, function1111111111115, function1111111111116, true);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            } else {
                final long j1111110 = j;
                final float f1111119 = f6;
                final Function2<? super DrawScope, ? super Offset, Unit> function1111111111117 = function8;
                final Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function1111111111118 = c133410;
                objRememberedValue2 = (Function1) new Function1<DrawScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((DrawScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(DrawScope drawScope) {
                        SliderDefaults.INSTANCE.m2809drawTrackngJ0SCU(drawScope, rangeSliderState.getTickFractions(), rangeSliderState.getCoercedActiveRangeStartAsFraction$material3_release(), rangeSliderState.getCoercedActiveRangeEndAsFraction$material3_release(), j1111110, jM2805trackColorWaAFU9c$material3_release2, jM2804tickColorWaAFU9c$material3_release, jM2804tickColorWaAFU9c$material3_release2, drawScope.toDp-u2uoSUM(rangeSliderState.getTrackHeight$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getStartThumbWidth$material3_release()), drawScope.toDp-u2uoSUM(rangeSliderState.getEndThumbWidth$material3_release()), f1111119, f7, function1111111111117, function1111111111118, true);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            CanvasKt.Canvas(modifierRotate15, (Function1) objRememberedValue2, composerStartRestartGroup, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            sliderColors3 = sliderColors18;
            f9 = f6;
            function9 = function8;
            function10 = c133410;
            f10 = f7;
            z10 = z111111112;
            modifier2 = modifier17;
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

                public final void invoke(Composer composer2, int i17) {
                    SliderDefaults.this.m2812Track4EFweAY(rangeSliderState, modifier2, z10, sliderColors3, function9, function10, f9, f10, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public final void m2809drawTrackngJ0SCU(DrawScope drawScope, float[] fArr, float f, float f2, long j, long j2, long j3, long j4, float f3, float f4, float f5, float f6, float f7, Function2<? super DrawScope, ? super Offset, Unit> function2, Function3<? super DrawScope, ? super Offset, ? super Color, Unit> function3, boolean z) {
        float f8;
        float f9;
        int i;
        float f10;
        float f11;
        long jOffset = OffsetKt.Offset(0.0f, Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()));
        long jOffset2 = OffsetKt.Offset(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()));
        float f12 = drawScope.toPx-0680j_4(f3);
        long jOffset3 = OffsetKt.Offset(Offset.m4346getXimpl(jOffset) + ((Offset.m4346getXimpl(jOffset2) - Offset.m4346getXimpl(jOffset)) * f2), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()));
        long jOffset4 = OffsetKt.Offset(Offset.m4346getXimpl(jOffset) + ((Offset.m4346getXimpl(jOffset2) - Offset.m4346getXimpl(jOffset)) * f), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()));
        float f13 = 2;
        float f14 = f12 / f13;
        float f15 = drawScope.toPx-0680j_4(f7);
        if (Dp.compareTo-0680j_4(f6, Dp.constructor-impl(0)) > 0) {
            f8 = (drawScope.toPx-0680j_4(f4) / f13) + drawScope.toPx-0680j_4(f6);
            f9 = (drawScope.toPx-0680j_4(f5) / f13) + drawScope.toPx-0680j_4(f6);
        } else {
            f8 = 0.0f;
            f9 = 0.0f;
        }
        if (!z || Offset.m4346getXimpl(jOffset4) <= Offset.m4346getXimpl(jOffset) + f8 + f14) {
            i = 0;
            f10 = f12;
        } else {
            float fM4346getXimpl = Offset.m4346getXimpl(jOffset);
            i = 0;
            f10 = f12;
            m2810drawTrackPathCx2C_VA(drawScope, Offset.INSTANCE.m4362getZeroF1C5BW0(), androidx.compose.p002ui.geometry.SizeKt.Size((Offset.m4346getXimpl(jOffset4) - f8) - fM4346getXimpl, f12), j, f14, f15);
            if (function2 != null) {
                function2.invoke(drawScope, Offset.m4335boximpl(OffsetKt.Offset(fM4346getXimpl + f14, Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()))));
            }
        }
        if (Offset.m4346getXimpl(jOffset3) < (Offset.m4346getXimpl(jOffset2) - f9) - f14) {
            float fM4346getXimpl2 = Offset.m4346getXimpl(jOffset3) + f9;
            float fM4346getXimpl3 = Offset.m4346getXimpl(jOffset2);
            float f16 = f10;
            f11 = f16;
            m2810drawTrackPathCx2C_VA(drawScope, OffsetKt.Offset(fM4346getXimpl2, 0.0f), androidx.compose.p002ui.geometry.SizeKt.Size(fM4346getXimpl3 - fM4346getXimpl2, f16), j, f15, f14);
            if (function2 != null) {
                function2.invoke(drawScope, Offset.m4335boximpl(OffsetKt.Offset(fM4346getXimpl3 - f14, Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()))));
            }
        } else {
            f11 = f10;
        }
        float fM4346getXimpl4 = z ? Offset.m4346getXimpl(jOffset4) + f8 : 0.0f;
        float fM4346getXimpl5 = Offset.m4346getXimpl(jOffset3) - f9;
        float f17 = z ? f15 : f14;
        float f18 = fM4346getXimpl5 - fM4346getXimpl4;
        if (f18 > f17) {
            m2810drawTrackPathCx2C_VA(drawScope, OffsetKt.Offset(fM4346getXimpl4, 0.0f), androidx.compose.p002ui.geometry.SizeKt.Size(f18, f11), j2, f17, f15);
        }
        long jOffset5 = OffsetKt.Offset(Offset.m4346getXimpl(jOffset) + f14, Offset.m4347getYimpl(jOffset));
        long jOffset6 = OffsetKt.Offset(Offset.m4346getXimpl(jOffset2) - f14, Offset.m4347getYimpl(jOffset2));
        ClosedFloatingPointRange closedFloatingPointRangeRangeTo = RangesKt.rangeTo(Offset.m4346getXimpl(jOffset4) - f8, Offset.m4346getXimpl(jOffset4) + f8);
        ClosedFloatingPointRange closedFloatingPointRangeRangeTo2 = RangesKt.rangeTo(Offset.m4346getXimpl(jOffset3) - f9, Offset.m4346getXimpl(jOffset3) + f9);
        int length = fArr.length;
        int i2 = i;
        int i3 = i2;
        while (i3 < length) {
            float f19 = fArr[i3];
            int i4 = i2 + 1;
            int i5 = 1;
            if (function2 == null || ((!z || i2 != 0) && i2 != fArr.length - 1)) {
                if (f19 <= f2 && f19 >= f) {
                    i5 = i;
                }
                long jOffset7 = OffsetKt.Offset(Offset.m4346getXimpl(OffsetKt.m4369lerpWko1d7g(jOffset5, jOffset6, f19)), Offset.m4347getYimpl(drawScope.mo5082getCenterF1C5BW0()));
                if ((!z || !closedFloatingPointRangeRangeTo.contains(Float.valueOf(Offset.m4346getXimpl(jOffset7)))) && !closedFloatingPointRangeRangeTo2.contains(Float.valueOf(Offset.m4346getXimpl(jOffset7)))) {
                    function3.invoke(drawScope, Offset.m4335boximpl(jOffset7), Color.m4580boximpl(i5 != 0 ? j3 : j4));
                }
            }
            i3++;
            i2 = i4;
        }
    }

    private final void m2810drawTrackPathCx2C_VA(DrawScope drawScope, long j, long j2, long j3, float f, float f2) {
        long jCornerRadius = CornerRadiusKt.CornerRadius(f, f);
        long jCornerRadius2 = CornerRadiusKt.CornerRadius(f2, f2);
        RoundRect roundRectM4398RoundRectZAM2FJo = RoundRectKt.m4398RoundRectZAM2FJo(RectKt.m4386Recttz77jQw(OffsetKt.Offset(Offset.m4346getXimpl(j), 0.0f), androidx.compose.p002ui.geometry.SizeKt.Size(Size.m4415getWidthimpl(j2), Size.m4412getHeightimpl(j2))), jCornerRadius, jCornerRadius2, jCornerRadius2, jCornerRadius);
        Path path = trackPath;
        Path.CC.addRoundRect$default(path, roundRectM4398RoundRectZAM2FJo, null, 2, null);
        DrawScope.CC.m5176drawPathLG529CI$default(drawScope, path, j3, 0.0f, null, null, 0, 60, null);
        path.rewind();
    }

    public final void m2808drawStopIndicatorx3O1jOs(DrawScope drawScope, long offset, float size, long color) {
        DrawScope.CC.m5167drawCircleVaOC9Bg$default(drawScope, color, drawScope.toPx-0680j_4(size) / 2.0f, offset, 0.0f, null, null, 0, MenuKt.InTransitionDuration, null);
    }

    public final float m2816getTrackStopIndicatorSizeD9Ej5fM() {
        return TrackStopIndicatorSize;
    }

    public final float m2815getTickSizeD9Ej5fM() {
        return TickSize;
    }
}
