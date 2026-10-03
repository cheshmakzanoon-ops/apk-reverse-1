package androidx.compose.material3;

import androidx.compose.animation.core.AnimationSpecKt;
import androidx.compose.animation.core.CubicBezierEasing;
import androidx.compose.animation.core.EasingKt;
import androidx.compose.animation.core.InfiniteRepeatableSpec;
import androidx.compose.animation.core.InfiniteTransition;
import androidx.compose.animation.core.InfiniteTransitionKt;
import androidx.compose.animation.core.KeyframesSpec;
import androidx.compose.animation.core.VectorConvertersKt;
import androidx.compose.foundation.CanvasKt;
import androidx.compose.foundation.ProgressSemanticsKt;
import androidx.compose.foundation.layout.PaddingKt;
import androidx.compose.foundation.layout.SizeKt;
import androidx.compose.material3.tokens.ProgressIndicatorTokens;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.geometry.OffsetKt;
import androidx.compose.p002ui.geometry.Size;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.graphics.StrokeCap;
import androidx.compose.p002ui.graphics.drawscope.DrawScope;
import androidx.compose.p002ui.graphics.drawscope.Stroke;
import androidx.compose.p002ui.layout.LayoutModifierKt;
import androidx.compose.p002ui.layout.Measurable;
import androidx.compose.p002ui.layout.MeasureResult;
import androidx.compose.p002ui.layout.MeasureScope;
import androidx.compose.p002ui.layout.Placeable;
import androidx.compose.p002ui.platform.CompositionLocalsKt;
import androidx.compose.p002ui.semantics.ProgressBarRangeInfo;
import androidx.compose.p002ui.semantics.SemanticsModifierKt;
import androidx.compose.p002ui.semantics.SemanticsPropertiesKt;
import androidx.compose.p002ui.semantics.SemanticsPropertyReceiver;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.ProvidableCompositionLocal;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.State;
import androidx.compose.ui.unit.Constraints;
import androidx.compose.ui.unit.ConstraintsKt;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.Dp;
import androidx.compose.ui.unit.LayoutDirection;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.IntCompanionObject;
import kotlin.ranges.ClosedFloatingPointRange;
import kotlin.ranges.RangesKt;

@Metadata(d1 = {"\u0000\\\n\u0000\n\u0002\u0010\u0007\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\b\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\b\u0012\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0010\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u000f\n\u0002\u0018\u0002\n\u0002\b\u0010\u001aR\u0010%\u001a\u00020&2\f\u0010'\u001a\b\u0012\u0004\u0012\u00020\u00010(2\b\b\u0002\u0010)\u001a\u00020\u00132\b\b\u0002\u0010*\u001a\u00020+2\b\b\u0002\u0010,\u001a\u00020\u00052\b\b\u0002\u0010-\u001a\u00020+2\b\b\u0002\u0010.\u001a\u00020/H\u0007ø\u0001\u0000¢\u0006\u0004\b0\u00101\u001a\\\u0010%\u001a\u00020&2\f\u0010'\u001a\b\u0012\u0004\u0012\u00020\u00010(2\b\b\u0002\u0010)\u001a\u00020\u00132\b\b\u0002\u0010*\u001a\u00020+2\b\b\u0002\u0010,\u001a\u00020\u00052\b\b\u0002\u0010-\u001a\u00020+2\b\b\u0002\u0010.\u001a\u00020/2\b\b\u0002\u00102\u001a\u00020\u0005H\u0007ø\u0001\u0000¢\u0006\u0004\b3\u00104\u001a0\u0010%\u001a\u00020&2\b\b\u0002\u0010)\u001a\u00020\u00132\b\b\u0002\u0010*\u001a\u00020+2\b\b\u0002\u0010,\u001a\u00020\u0005H\u0007ø\u0001\u0000¢\u0006\u0004\b5\u00106\u001aD\u0010%\u001a\u00020&2\b\b\u0002\u0010)\u001a\u00020\u00132\b\b\u0002\u0010*\u001a\u00020+2\b\b\u0002\u0010,\u001a\u00020\u00052\b\b\u0002\u0010-\u001a\u00020+2\b\b\u0002\u0010.\u001a\u00020/H\u0007ø\u0001\u0000¢\u0006\u0004\b7\u00108\u001a8\u0010%\u001a\u00020&2\u0006\u0010'\u001a\u00020\u00012\b\b\u0002\u0010)\u001a\u00020\u00132\b\b\u0002\u0010*\u001a\u00020+2\b\b\u0002\u0010,\u001a\u00020\u0005H\u0007ø\u0001\u0000¢\u0006\u0004\b9\u0010:\u001aL\u0010%\u001a\u00020&2\u0006\u0010'\u001a\u00020\u00012\b\b\u0002\u0010)\u001a\u00020\u00132\b\b\u0002\u0010*\u001a\u00020+2\b\b\u0002\u0010,\u001a\u00020\u00052\b\b\u0002\u0010-\u001a\u00020+2\b\b\u0002\u0010.\u001a\u00020/H\u0007ø\u0001\u0000¢\u0006\u0004\b0\u0010;\u001aH\u0010<\u001a\u00020&2\f\u0010'\u001a\b\u0012\u0004\u0012\u00020\u00010(2\b\b\u0002\u0010)\u001a\u00020\u00132\b\b\u0002\u0010*\u001a\u00020+2\b\b\u0002\u0010-\u001a\u00020+2\b\b\u0002\u0010.\u001a\u00020/H\u0007ø\u0001\u0000¢\u0006\u0004\b=\u0010>\u001am\u0010<\u001a\u00020&2\f\u0010'\u001a\b\u0012\u0004\u0012\u00020\u00010(2\b\b\u0002\u0010)\u001a\u00020\u00132\b\b\u0002\u0010*\u001a\u00020+2\b\b\u0002\u0010-\u001a\u00020+2\b\b\u0002\u0010.\u001a\u00020/2\b\b\u0002\u00102\u001a\u00020\u00052\u0019\b\u0002\u0010?\u001a\u0013\u0012\u0004\u0012\u00020A\u0012\u0004\u0012\u00020&0@¢\u0006\u0002\bBH\u0007ø\u0001\u0000¢\u0006\u0004\bC\u0010D\u001a0\u0010<\u001a\u00020&2\b\b\u0002\u0010)\u001a\u00020\u00132\b\b\u0002\u0010*\u001a\u00020+2\b\b\u0002\u0010-\u001a\u00020+H\u0007ø\u0001\u0000¢\u0006\u0004\bE\u0010F\u001a:\u0010<\u001a\u00020&2\b\b\u0002\u0010)\u001a\u00020\u00132\b\b\u0002\u0010*\u001a\u00020+2\b\b\u0002\u0010-\u001a\u00020+2\b\b\u0002\u0010.\u001a\u00020/H\u0007ø\u0001\u0000¢\u0006\u0004\bG\u0010H\u001aD\u0010<\u001a\u00020&2\b\b\u0002\u0010)\u001a\u00020\u00132\b\b\u0002\u0010*\u001a\u00020+2\b\b\u0002\u0010-\u001a\u00020+2\b\b\u0002\u0010.\u001a\u00020/2\b\b\u0002\u00102\u001a\u00020\u0005H\u0007ø\u0001\u0000¢\u0006\u0004\bI\u0010J\u001a8\u0010<\u001a\u00020&2\u0006\u0010'\u001a\u00020\u00012\b\b\u0002\u0010)\u001a\u00020\u00132\b\b\u0002\u0010*\u001a\u00020+2\b\b\u0002\u0010-\u001a\u00020+H\u0007ø\u0001\u0000¢\u0006\u0004\bK\u0010L\u001aB\u0010<\u001a\u00020&2\u0006\u0010'\u001a\u00020\u00012\b\b\u0002\u0010)\u001a\u00020\u00132\b\b\u0002\u0010*\u001a\u00020+2\b\b\u0002\u0010-\u001a\u00020+2\b\b\u0002\u0010.\u001a\u00020/H\u0007ø\u0001\u0000¢\u0006\u0004\b=\u0010M\u001a6\u0010N\u001a\u00020&*\u00020A2\u0006\u0010O\u001a\u00020\u00012\u0006\u0010P\u001a\u00020\u00012\u0006\u0010*\u001a\u00020+2\u0006\u0010Q\u001a\u00020RH\u0002ø\u0001\u0000¢\u0006\u0004\bS\u0010T\u001a&\u0010U\u001a\u00020&*\u00020A2\u0006\u0010*\u001a\u00020+2\u0006\u0010Q\u001a\u00020RH\u0002ø\u0001\u0000¢\u0006\u0004\bV\u0010W\u001a6\u0010X\u001a\u00020&*\u00020A2\u0006\u0010O\u001a\u00020\u00012\u0006\u0010P\u001a\u00020\u00012\u0006\u0010*\u001a\u00020+2\u0006\u0010Q\u001a\u00020RH\u0002ø\u0001\u0000¢\u0006\u0004\bY\u0010T\u001a>\u0010Z\u001a\u00020&*\u00020A2\u0006\u0010O\u001a\u00020\u00012\u0006\u0010,\u001a\u00020\u00052\u0006\u0010P\u001a\u00020\u00012\u0006\u0010*\u001a\u00020+2\u0006\u0010Q\u001a\u00020RH\u0002ø\u0001\u0000¢\u0006\u0004\b[\u0010\\\u001a>\u0010]\u001a\u00020&*\u00020A2\u0006\u0010^\u001a\u00020\u00012\u0006\u0010_\u001a\u00020\u00012\u0006\u0010*\u001a\u00020+2\u0006\u0010,\u001a\u00020\u00012\u0006\u0010.\u001a\u00020/H\u0002ø\u0001\u0000¢\u0006\u0004\b`\u0010a\"\u000e\u0010\u0000\u001a\u00020\u0001X\u0082T¢\u0006\u0002\n\u0000\"\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000\"\u0016\u0010\u0004\u001a\u00020\u0005X\u0080\u0004¢\u0006\n\n\u0002\u0010\b\u001a\u0004\b\u0006\u0010\u0007\"\u000e\u0010\t\u001a\u00020\nX\u0082T¢\u0006\u0002\n\u0000\"\u000e\u0010\u000b\u001a\u00020\nX\u0082T¢\u0006\u0002\n\u0000\"\u000e\u0010\f\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000\"\u000e\u0010\r\u001a\u00020\nX\u0082T¢\u0006\u0002\n\u0000\"\u000e\u0010\u000e\u001a\u00020\nX\u0082T¢\u0006\u0002\n\u0000\"\u000e\u0010\u000f\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000\"\u000e\u0010\u0010\u001a\u00020\nX\u0082T¢\u0006\u0002\n\u0000\"\u000e\u0010\u0011\u001a\u00020\nX\u0082T¢\u0006\u0002\n\u0000\"\u000e\u0010\u0012\u001a\u00020\u0013X\u0082\u0004¢\u0006\u0002\n\u0000\"\u000e\u0010\u0014\u001a\u00020\u0001X\u0082T¢\u0006\u0002\n\u0000\"\u000e\u0010\u0015\u001a\u00020\nX\u0082T¢\u0006\u0002\n\u0000\"\u0016\u0010\u0016\u001a\u00020\u0005X\u0080\u0004¢\u0006\n\n\u0002\u0010\b\u001a\u0004\b\u0017\u0010\u0007\"\u0016\u0010\u0018\u001a\u00020\u0005X\u0080\u0004¢\u0006\n\n\u0002\u0010\b\u001a\u0004\b\u0019\u0010\u0007\"\u000e\u0010\u001a\u001a\u00020\u0001X\u0082T¢\u0006\u0002\n\u0000\"\u000e\u0010\u001b\u001a\u00020\nX\u0082T¢\u0006\u0002\n\u0000\"\u000e\u0010\u001c\u001a\u00020\nX\u0082T¢\u0006\u0002\n\u0000\"\u000e\u0010\u001d\u001a\u00020\nX\u0082T¢\u0006\u0002\n\u0000\"\u000e\u0010\u001e\u001a\u00020\nX\u0082T¢\u0006\u0002\n\u0000\"\u000e\u0010\u001f\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000\"\u000e\u0010 \u001a\u00020\nX\u0082T¢\u0006\u0002\n\u0000\"\u000e\u0010!\u001a\u00020\nX\u0082T¢\u0006\u0002\n\u0000\"\u000e\u0010\"\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000\"\u0010\u0010#\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\b\"\u000e\u0010$\u001a\u00020\u0001X\u0082T¢\u0006\u0002\n\u0000\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006b"}, d2 = {"BaseRotationAngle", "", "CircularEasing", "Landroidx/compose/animation/core/CubicBezierEasing;", "CircularIndicatorDiameter", "Landroidx/compose/ui/unit/Dp;", "getCircularIndicatorDiameter", "()F", "F", "FirstLineHeadDelay", "", "FirstLineHeadDuration", "FirstLineHeadEasing", "FirstLineTailDelay", "FirstLineTailDuration", "FirstLineTailEasing", "HeadAndTailAnimationDuration", "HeadAndTailDelayDuration", "IncreaseSemanticsBounds", "Landroidx/compose/ui/Modifier;", "JumpRotationAngle", "LinearAnimationDuration", "LinearIndicatorHeight", "getLinearIndicatorHeight", "LinearIndicatorWidth", "getLinearIndicatorWidth", "RotationAngleOffset", "RotationDuration", "RotationsPerCycle", "SecondLineHeadDelay", "SecondLineHeadDuration", "SecondLineHeadEasing", "SecondLineTailDelay", "SecondLineTailDuration", "SecondLineTailEasing", "SemanticsBoundsPadding", "StartAngleOffset", "CircularProgressIndicator", "", "progress", "Lkotlin/Function0;", "modifier", "color", "Landroidx/compose/ui/graphics/Color;", "strokeWidth", "trackColor", "strokeCap", "Landroidx/compose/ui/graphics/StrokeCap;", "CircularProgressIndicator-DUhRLBM", "(Lkotlin/jvm/functions/Function0;Landroidx/compose/ui/Modifier;JFJILandroidx/compose/runtime/Composer;II)V", "gapSize", "CircularProgressIndicator-IyT6zlY", "(Lkotlin/jvm/functions/Function0;Landroidx/compose/ui/Modifier;JFJIFLandroidx/compose/runtime/Composer;II)V", "CircularProgressIndicator-aM-cp0Q", "(Landroidx/compose/ui/Modifier;JFLandroidx/compose/runtime/Composer;II)V", "CircularProgressIndicator-LxG7B9w", "(Landroidx/compose/ui/Modifier;JFJILandroidx/compose/runtime/Composer;II)V", "CircularProgressIndicator-MBs18nI", "(FLandroidx/compose/ui/Modifier;JFLandroidx/compose/runtime/Composer;II)V", "(FLandroidx/compose/ui/Modifier;JFJILandroidx/compose/runtime/Composer;II)V", "LinearProgressIndicator", "LinearProgressIndicator-_5eSR-E", "(Lkotlin/jvm/functions/Function0;Landroidx/compose/ui/Modifier;JJILandroidx/compose/runtime/Composer;II)V", "drawStopIndicator", "Lkotlin/Function1;", "Landroidx/compose/ui/graphics/drawscope/DrawScope;", "Lkotlin/ExtensionFunctionType;", "LinearProgressIndicator-GJbTh5U", "(Lkotlin/jvm/functions/Function0;Landroidx/compose/ui/Modifier;JJIFLkotlin/jvm/functions/Function1;Landroidx/compose/runtime/Composer;II)V", "LinearProgressIndicator-RIQooxk", "(Landroidx/compose/ui/Modifier;JJLandroidx/compose/runtime/Composer;II)V", "LinearProgressIndicator-2cYBFYY", "(Landroidx/compose/ui/Modifier;JJILandroidx/compose/runtime/Composer;II)V", "LinearProgressIndicator-rIrjwxo", "(Landroidx/compose/ui/Modifier;JJIFLandroidx/compose/runtime/Composer;II)V", "LinearProgressIndicator-eaDK9VM", "(FLandroidx/compose/ui/Modifier;JJLandroidx/compose/runtime/Composer;II)V", "(FLandroidx/compose/ui/Modifier;JJILandroidx/compose/runtime/Composer;II)V", "drawCircularIndicator", "startAngle", "sweep", "stroke", "Landroidx/compose/ui/graphics/drawscope/Stroke;", "drawCircularIndicator-42QJj7c", "(Landroidx/compose/ui/graphics/drawscope/DrawScope;FFJLandroidx/compose/ui/graphics/drawscope/Stroke;)V", "drawCircularIndicatorTrack", "drawCircularIndicatorTrack-bw27NRU", "(Landroidx/compose/ui/graphics/drawscope/DrawScope;JLandroidx/compose/ui/graphics/drawscope/Stroke;)V", "drawDeterminateCircularIndicator", "drawDeterminateCircularIndicator-42QJj7c", "drawIndeterminateCircularIndicator", "drawIndeterminateCircularIndicator-hrjfTZI", "(Landroidx/compose/ui/graphics/drawscope/DrawScope;FFFJLandroidx/compose/ui/graphics/drawscope/Stroke;)V", "drawLinearIndicator", "startFraction", "endFraction", "drawLinearIndicator-qYKTg0g", "(Landroidx/compose/ui/graphics/drawscope/DrawScope;FFJFI)V", "material3_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class ProgressIndicatorKt {
    private static final float BaseRotationAngle = 286.0f;
    private static final CubicBezierEasing CircularEasing;
    private static final float CircularIndicatorDiameter;
    private static final int FirstLineHeadDelay = 0;
    private static final int FirstLineHeadDuration = 750;
    private static final CubicBezierEasing FirstLineHeadEasing;
    private static final int FirstLineTailDelay = 333;
    private static final int FirstLineTailDuration = 850;
    private static final CubicBezierEasing FirstLineTailEasing;
    private static final int HeadAndTailAnimationDuration = 666;
    private static final int HeadAndTailDelayDuration = 666;
    private static final Modifier IncreaseSemanticsBounds;
    private static final float JumpRotationAngle = 290.0f;
    private static final int LinearAnimationDuration = 1800;
    private static final float LinearIndicatorHeight;
    private static final float LinearIndicatorWidth;
    private static final float RotationAngleOffset = 216.0f;
    private static final int RotationDuration = 1332;
    private static final int RotationsPerCycle = 5;
    private static final int SecondLineHeadDelay = 1000;
    private static final int SecondLineHeadDuration = 567;
    private static final CubicBezierEasing SecondLineHeadEasing;
    private static final int SecondLineTailDelay = 1267;
    private static final int SecondLineTailDuration = 533;
    private static final CubicBezierEasing SecondLineTailEasing;
    private static final float SemanticsBoundsPadding;
    private static final float StartAngleOffset = -90.0f;

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Use the overload that takes `gapSize` and `drawStopIndicator`, see `LegacyLinearProgressIndicatorSample` on how to restore the previous behavior", replaceWith = @ReplaceWith(expression = "LinearProgressIndicator(progress, modifier, color, trackColor, strokeCap, gapSize, drawStopIndicator)", imports = {}))
    public static final void m2680LinearProgressIndicator_5eSRE(final Function0 function0, Modifier modifier, long j, long j2, int i, Composer composer, final int i2, final int i3) {
        int i4;
        Modifier modifier2;
        long linearColor;
        long linearTrackColor;
        int i5;
        int i6;
        int i7;
        Modifier.Companion companion;
        int iM2668getLinearStrokeCapKaPHkGw;
        long j3;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i8;
        int i9;
        Composer composerStartRestartGroup = composer.startRestartGroup(-1796992155);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(LinearProgressIndicator)P(2,1,0:c#ui.graphics.Color,4:c#ui.graphics.Color,3:c#ui.graphics.StrokeCap)96@4380L11,97@4443L16,100@4539L192:ProgressIndicator.kt#uh7d8r");
        if ((i3 & 1) != 0) {
            i4 = i2 | 6;
        } else if ((i2 & 6) == 0) {
            i4 = (composerStartRestartGroup.changedInstance(function0) ? 4 : 2) | i2;
        } else {
            i4 = i2;
        }
        int i10 = i3 & 2;
        if (i10 == 0) {
            if ((i2 & 48) == 0) {
                modifier2 = modifier;
                i4 |= composerStartRestartGroup.changed(modifier2) ? 32 : 16;
            }
            if ((i2 & 384) == 0) {
                if ((i3 & 4) == 0) {
                    linearColor = j;
                    if (composerStartRestartGroup.changed(linearColor)) {
                        i9 = Fields.RotationX;
                    }
                    i4 |= i9;
                } else {
                    linearColor = j;
                }
                i9 = Fields.SpotShadowColor;
                i4 |= i9;
            } else {
                linearColor = j;
            }
            if ((i2 & 3072) == 0) {
                if ((i3 & 8) == 0) {
                    linearTrackColor = j2;
                    if (composerStartRestartGroup.changed(linearTrackColor)) {
                        i8 = Fields.CameraDistance;
                    }
                    i4 |= i8;
                } else {
                    linearTrackColor = j2;
                }
                i8 = Fields.RotationZ;
                i4 |= i8;
            } else {
                linearTrackColor = j2;
            }
            i5 = i3 & 16;
            if (i5 != 0) {
                if ((i2 & 24576) == 0) {
                    i6 = i;
                    if (composerStartRestartGroup.changed(i6)) {
                        i7 = Fields.Clip;
                    } else {
                        i7 = Fields.Shape;
                    }
                    i4 |= i7;
                }
                if ((i4 & 9363) == 9362 || !composerStartRestartGroup.getSkipping()) {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) == 0 && !composerStartRestartGroup.getDefaultsInvalid()) {
                        composerStartRestartGroup.skipToGroupEnd();
                        if ((i3 & 4) != 0) {
                            i4 &= -897;
                        }
                        if ((i3 & 8) != 0) {
                            i4 &= -7169;
                        }
                        companion = modifier2;
                    } else {
                        if (i10 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 4) != 0) {
                            i4 &= -897;
                            linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                        }
                        if ((i3 & 8) != 0) {
                            linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                            i4 &= -7169;
                        }
                        if (i5 != 0) {
                            iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                            j3 = linearTrackColor;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1796992155, i4, -1, "androidx.compose.material3.LinearProgressIndicator (ProgressIndicator.kt:99)");
                        }
                        m2677LinearProgressIndicatorGJbTh5U(function0, companion, linearColor, j3, iM2668getLinearStrokeCapKaPHkGw, ProgressIndicatorDefaults.INSTANCE.m2667getLinearIndicatorTrackGapSizeD9Ej5fM(), null, composerStartRestartGroup, (i4 & 14) | 196608 | (i4 & 112) | (i4 & 896) | (i4 & 7168) | (i4 & 57344), 64);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        i6 = iM2668getLinearStrokeCapKaPHkGw;
                        linearTrackColor = j3;
                    }
                    j3 = linearTrackColor;
                    iM2668getLinearStrokeCapKaPHkGw = i6;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1796992155, i4, -1, "androidx.compose.material3.LinearProgressIndicator (ProgressIndicator.kt:99)");
                    }
                    m2677LinearProgressIndicatorGJbTh5U(function0, companion, linearColor, j3, iM2668getLinearStrokeCapKaPHkGw, ProgressIndicatorDefaults.INSTANCE.m2667getLinearIndicatorTrackGapSizeD9Ej5fM(), null, composerStartRestartGroup, (i4 & 14) | 196608 | (i4 & 112) | (i4 & 896) | (i4 & 7168) | (i4 & 57344), 64);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    i6 = iM2668getLinearStrokeCapKaPHkGw;
                    linearTrackColor = j3;
                } else {
                    composerStartRestartGroup.skipToGroupEnd();
                    companion = modifier2;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier3 = companion;
                    final long j4 = linearColor;
                    final long j5 = linearTrackColor;
                    final int i11 = i6;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i12) {
                            ProgressIndicatorKt.m2680LinearProgressIndicator_5eSRE(function0, modifier3, j4, j5, i11, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                        }
                    });
                }
            }
            i4 |= 24576;
            i6 = i;
            if ((i4 & 9363) == 9362) {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) == 0) {
                    if (i10 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 4) != 0) {
                        i4 &= -897;
                        linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                    }
                    if ((i3 & 8) != 0) {
                        linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                        i4 &= -7169;
                    }
                    if (i5 != 0) {
                        iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                        j3 = linearTrackColor;
                    } else {
                        j3 = linearTrackColor;
                        iM2668getLinearStrokeCapKaPHkGw = i6;
                    }
                } else {
                    if (i10 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 4) != 0) {
                        i4 &= -897;
                        linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                    }
                    if ((i3 & 8) != 0) {
                        linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                        i4 &= -7169;
                    }
                    if (i5 != 0) {
                        iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                        j3 = linearTrackColor;
                    } else {
                        j3 = linearTrackColor;
                        iM2668getLinearStrokeCapKaPHkGw = i6;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1796992155, i4, -1, "androidx.compose.material3.LinearProgressIndicator (ProgressIndicator.kt:99)");
                }
                m2677LinearProgressIndicatorGJbTh5U(function0, companion, linearColor, j3, iM2668getLinearStrokeCapKaPHkGw, ProgressIndicatorDefaults.INSTANCE.m2667getLinearIndicatorTrackGapSizeD9Ej5fM(), null, composerStartRestartGroup, (i4 & 14) | 196608 | (i4 & 112) | (i4 & 896) | (i4 & 7168) | (i4 & 57344), 64);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                i6 = iM2668getLinearStrokeCapKaPHkGw;
                linearTrackColor = j3;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) == 0) {
                    if (i10 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 4) != 0) {
                        i4 &= -897;
                        linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                    }
                    if ((i3 & 8) != 0) {
                        linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                        i4 &= -7169;
                    }
                    if (i5 != 0) {
                        iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                        j3 = linearTrackColor;
                    } else {
                        j3 = linearTrackColor;
                        iM2668getLinearStrokeCapKaPHkGw = i6;
                    }
                } else {
                    if (i10 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 4) != 0) {
                        i4 &= -897;
                        linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                    }
                    if ((i3 & 8) != 0) {
                        linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                        i4 &= -7169;
                    }
                    if (i5 != 0) {
                        iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                        j3 = linearTrackColor;
                    } else {
                        j3 = linearTrackColor;
                        iM2668getLinearStrokeCapKaPHkGw = i6;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1796992155, i4, -1, "androidx.compose.material3.LinearProgressIndicator (ProgressIndicator.kt:99)");
                }
                m2677LinearProgressIndicatorGJbTh5U(function0, companion, linearColor, j3, iM2668getLinearStrokeCapKaPHkGw, ProgressIndicatorDefaults.INSTANCE.m2667getLinearIndicatorTrackGapSizeD9Ej5fM(), null, composerStartRestartGroup, (i4 & 14) | 196608 | (i4 & 112) | (i4 & 896) | (i4 & 7168) | (i4 & 57344), 64);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                i6 = iM2668getLinearStrokeCapKaPHkGw;
                linearTrackColor = j3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier4 = companion;
                final long j6 = linearColor;
                final long j7 = linearTrackColor;
                final int i12 = i6;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i13) {
                        ProgressIndicatorKt.m2680LinearProgressIndicator_5eSRE(function0, modifier4, j6, j7, i12, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                    }
                });
            }
        }
        i4 |= 48;
        modifier2 = modifier;
        if ((i2 & 384) == 0) {
            if ((i3 & 4) == 0) {
                linearColor = j;
                if (composerStartRestartGroup.changed(linearColor)) {
                    i9 = Fields.RotationX;
                }
                i4 |= i9;
            } else {
                linearColor = j;
            }
            i9 = Fields.SpotShadowColor;
            i4 |= i9;
        } else {
            linearColor = j;
        }
        if ((i2 & 3072) == 0) {
            if ((i3 & 8) == 0) {
                linearTrackColor = j2;
                if (composerStartRestartGroup.changed(linearTrackColor)) {
                    i8 = Fields.CameraDistance;
                }
                i4 |= i8;
            } else {
                linearTrackColor = j2;
            }
            i8 = Fields.RotationZ;
            i4 |= i8;
        } else {
            linearTrackColor = j2;
        }
        i5 = i3 & 16;
        if (i5 != 0) {
            if ((i2 & 24576) == 0) {
                i6 = i;
                if (composerStartRestartGroup.changed(i6)) {
                    i7 = Fields.Clip;
                } else {
                    i7 = Fields.Shape;
                }
                i4 |= i7;
            }
            if ((i4 & 9363) == 9362) {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) == 0) {
                    if (i10 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 4) != 0) {
                        i4 &= -897;
                        linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                    }
                    if ((i3 & 8) != 0) {
                        linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                        i4 &= -7169;
                    }
                    if (i5 != 0) {
                        iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                        j3 = linearTrackColor;
                    } else {
                        j3 = linearTrackColor;
                        iM2668getLinearStrokeCapKaPHkGw = i6;
                    }
                } else {
                    if (i10 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 4) != 0) {
                        i4 &= -897;
                        linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                    }
                    if ((i3 & 8) != 0) {
                        linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                        i4 &= -7169;
                    }
                    if (i5 != 0) {
                        iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                        j3 = linearTrackColor;
                    } else {
                        j3 = linearTrackColor;
                        iM2668getLinearStrokeCapKaPHkGw = i6;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1796992155, i4, -1, "androidx.compose.material3.LinearProgressIndicator (ProgressIndicator.kt:99)");
                }
                m2677LinearProgressIndicatorGJbTh5U(function0, companion, linearColor, j3, iM2668getLinearStrokeCapKaPHkGw, ProgressIndicatorDefaults.INSTANCE.m2667getLinearIndicatorTrackGapSizeD9Ej5fM(), null, composerStartRestartGroup, (i4 & 14) | 196608 | (i4 & 112) | (i4 & 896) | (i4 & 7168) | (i4 & 57344), 64);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                i6 = iM2668getLinearStrokeCapKaPHkGw;
                linearTrackColor = j3;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) == 0) {
                    if (i10 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 4) != 0) {
                        i4 &= -897;
                        linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                    }
                    if ((i3 & 8) != 0) {
                        linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                        i4 &= -7169;
                    }
                    if (i5 != 0) {
                        iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                        j3 = linearTrackColor;
                    } else {
                        j3 = linearTrackColor;
                        iM2668getLinearStrokeCapKaPHkGw = i6;
                    }
                } else {
                    if (i10 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 4) != 0) {
                        i4 &= -897;
                        linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                    }
                    if ((i3 & 8) != 0) {
                        linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                        i4 &= -7169;
                    }
                    if (i5 != 0) {
                        iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                        j3 = linearTrackColor;
                    } else {
                        j3 = linearTrackColor;
                        iM2668getLinearStrokeCapKaPHkGw = i6;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1796992155, i4, -1, "androidx.compose.material3.LinearProgressIndicator (ProgressIndicator.kt:99)");
                }
                m2677LinearProgressIndicatorGJbTh5U(function0, companion, linearColor, j3, iM2668getLinearStrokeCapKaPHkGw, ProgressIndicatorDefaults.INSTANCE.m2667getLinearIndicatorTrackGapSizeD9Ej5fM(), null, composerStartRestartGroup, (i4 & 14) | 196608 | (i4 & 112) | (i4 & 896) | (i4 & 7168) | (i4 & 57344), 64);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                i6 = iM2668getLinearStrokeCapKaPHkGw;
                linearTrackColor = j3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier5 = companion;
                final long j8 = linearColor;
                final long j9 = linearTrackColor;
                final int i13 = i6;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i14) {
                        ProgressIndicatorKt.m2680LinearProgressIndicator_5eSRE(function0, modifier5, j8, j9, i13, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                    }
                });
            }
        }
        i4 |= 24576;
        i6 = i;
        if ((i4 & 9363) == 9362) {
            composerStartRestartGroup.startDefaults();
            if ((i2 & 1) == 0) {
                if (i10 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i3 & 4) != 0) {
                    i4 &= -897;
                    linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                }
                if ((i3 & 8) != 0) {
                    linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                    i4 &= -7169;
                }
                if (i5 != 0) {
                    iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                    j3 = linearTrackColor;
                } else {
                    j3 = linearTrackColor;
                    iM2668getLinearStrokeCapKaPHkGw = i6;
                }
            } else {
                if (i10 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i3 & 4) != 0) {
                    i4 &= -897;
                    linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                }
                if ((i3 & 8) != 0) {
                    linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                    i4 &= -7169;
                }
                if (i5 != 0) {
                    iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                    j3 = linearTrackColor;
                } else {
                    j3 = linearTrackColor;
                    iM2668getLinearStrokeCapKaPHkGw = i6;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1796992155, i4, -1, "androidx.compose.material3.LinearProgressIndicator (ProgressIndicator.kt:99)");
            }
            m2677LinearProgressIndicatorGJbTh5U(function0, companion, linearColor, j3, iM2668getLinearStrokeCapKaPHkGw, ProgressIndicatorDefaults.INSTANCE.m2667getLinearIndicatorTrackGapSizeD9Ej5fM(), null, composerStartRestartGroup, (i4 & 14) | 196608 | (i4 & 112) | (i4 & 896) | (i4 & 7168) | (i4 & 57344), 64);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            i6 = iM2668getLinearStrokeCapKaPHkGw;
            linearTrackColor = j3;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i2 & 1) == 0) {
                if (i10 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i3 & 4) != 0) {
                    i4 &= -897;
                    linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                }
                if ((i3 & 8) != 0) {
                    linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                    i4 &= -7169;
                }
                if (i5 != 0) {
                    iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                    j3 = linearTrackColor;
                } else {
                    j3 = linearTrackColor;
                    iM2668getLinearStrokeCapKaPHkGw = i6;
                }
            } else {
                if (i10 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i3 & 4) != 0) {
                    i4 &= -897;
                    linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                }
                if ((i3 & 8) != 0) {
                    linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                    i4 &= -7169;
                }
                if (i5 != 0) {
                    iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                    j3 = linearTrackColor;
                } else {
                    j3 = linearTrackColor;
                    iM2668getLinearStrokeCapKaPHkGw = i6;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1796992155, i4, -1, "androidx.compose.material3.LinearProgressIndicator (ProgressIndicator.kt:99)");
            }
            m2677LinearProgressIndicatorGJbTh5U(function0, companion, linearColor, j3, iM2668getLinearStrokeCapKaPHkGw, ProgressIndicatorDefaults.INSTANCE.m2667getLinearIndicatorTrackGapSizeD9Ej5fM(), null, composerStartRestartGroup, (i4 & 14) | 196608 | (i4 & 112) | (i4 & 896) | (i4 & 7168) | (i4 & 57344), 64);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            i6 = iM2668getLinearStrokeCapKaPHkGw;
            linearTrackColor = j3;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier6 = companion;
            final long j10 = linearColor;
            final long j11 = linearTrackColor;
            final int i14 = i6;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i15) {
                    ProgressIndicatorKt.m2680LinearProgressIndicator_5eSRE(function0, modifier6, j10, j11, i14, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                }
            });
        }
    }

    public static final void m2677LinearProgressIndicatorGJbTh5U(final Function0<Float> function0, Modifier modifier, long j, long j2, int i, float f, Function1<? super DrawScope, Unit> function1, Composer composer, final int i2, final int i3) {
        int i4;
        Modifier modifier2;
        final long linearColor;
        long linearTrackColor;
        int i5;
        int i6;
        int i7;
        int i8;
        float fM2667getLinearIndicatorTrackGapSizeD9Ej5fM;
        int i9;
        Function1<? super DrawScope, Unit> function2;
        Modifier.Companion companion;
        final int iM2668getLinearStrokeCapKaPHkGw;
        Function1<? super DrawScope, Unit> function3;
        boolean z;
        boolean z2;
        Object objRememberedValue;
        boolean z3;
        Object objRememberedValue2;
        final Function0 function4;
        boolean zChanged;
        Object objRememberedValue3;
        boolean z4;
        boolean z5;
        boolean zChanged2;
        Object objRememberedValue4;
        final float f2;
        final Function1<? super DrawScope, Unit> function5;
        final long j3;
        final int i10;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i11;
        int i12;
        int i13;
        Composer composerStartRestartGroup = composer.startRestartGroup(-339970038);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(LinearProgressIndicator)P(4,3,0:c#ui.graphics.Color,6:c#ui.graphics.Color,5:c#ui.graphics.StrokeCap,2:c#ui.unit.Dp)140@6419L11,141@6482L16,144@6689L214,153@6935L31,157@7087L102,161@7259L806,154@6971L1094:ProgressIndicator.kt#uh7d8r");
        if ((i3 & 1) != 0) {
            i4 = i2 | 6;
        } else if ((i2 & 6) == 0) {
            i4 = (composerStartRestartGroup.changedInstance(function0) ? 4 : 2) | i2;
        } else {
            i4 = i2;
        }
        int i14 = i3 & 2;
        if (i14 == 0) {
            if ((i2 & 48) == 0) {
                modifier2 = modifier;
                i4 |= composerStartRestartGroup.changed(modifier2) ? 32 : 16;
            }
            if ((i2 & 384) == 0) {
                linearColor = j;
                if ((i3 & 4) == 0 || !composerStartRestartGroup.changed(linearColor)) {
                    i13 = Fields.SpotShadowColor;
                } else {
                    i13 = Fields.RotationX;
                }
                i4 |= i13;
            } else {
                linearColor = j;
            }
            if ((i2 & 3072) == 0) {
                linearTrackColor = j2;
                if ((i3 & 8) == 0 || !composerStartRestartGroup.changed(linearTrackColor)) {
                    i12 = Fields.RotationZ;
                } else {
                    i12 = Fields.CameraDistance;
                }
                i4 |= i12;
            } else {
                linearTrackColor = j2;
            }
            i5 = i3 & 16;
            if (i5 != 0) {
                if ((i2 & 24576) == 0) {
                    i6 = i;
                    if (composerStartRestartGroup.changed(i6)) {
                        i7 = Fields.Clip;
                    } else {
                        i7 = Fields.Shape;
                    }
                    i4 |= i7;
                }
                i8 = i3 & 32;
                if (i8 != 0) {
                    i4 |= 196608;
                    fM2667getLinearIndicatorTrackGapSizeD9Ej5fM = f;
                } else {
                    fM2667getLinearIndicatorTrackGapSizeD9Ej5fM = f;
                    if ((i2 & 196608) == 0) {
                        if (composerStartRestartGroup.changed(fM2667getLinearIndicatorTrackGapSizeD9Ej5fM)) {
                            i9 = Fields.RenderEffect;
                        } else {
                            i9 = 65536;
                        }
                        i4 |= i9;
                    }
                }
                if ((i2 & 1572864) == 0) {
                    function2 = function1;
                    if ((i3 & 64) == 0 || !composerStartRestartGroup.changedInstance(function2)) {
                        i11 = 524288;
                    } else {
                        i11 = 1048576;
                    }
                    i4 |= i11;
                } else {
                    function2 = function1;
                }
                if ((i4 & 599187) == 599186 || !composerStartRestartGroup.getSkipping()) {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                        if (i14 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 4) != 0) {
                            linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                            i4 &= -897;
                        }
                        if ((i3 & 8) != 0) {
                            linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                            i4 &= -7169;
                        }
                        if (i5 != 0) {
                            iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                        } else {
                            iM2668getLinearStrokeCapKaPHkGw = i6;
                        }
                        if (i8 != 0) {
                            fM2667getLinearIndicatorTrackGapSizeD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2667getLinearIndicatorTrackGapSizeD9Ej5fM();
                        }
                        if ((i3 & 64) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1144997616, "CC(remember):ProgressIndicator.kt#9igjgp");
                            boolean z6 = (((i4 & 896) ^ 384) <= 256 && composerStartRestartGroup.changed(linearColor)) || (i4 & 384) == 256;
                            if ((57344 & i4) == 16384) {
                                z = true;
                            } else {
                                z = false;
                            }
                            z2 = z6 | z;
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (z2 || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((DrawScope) obj);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(DrawScope drawScope) {
                                        ProgressIndicatorDefaults.INSTANCE.m2662drawStopIndicatorEgI2THU(drawScope, ProgressIndicatorDefaults.INSTANCE.m2669getLinearTrackStopIndicatorSizeD9Ej5fM(), linearColor, iM2668getLinearStrokeCapKaPHkGw);
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            function3 = (Function1) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i4 &= -3670017;
                        } else {
                            function3 = function1;
                        }
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        if ((i3 & 4) != 0) {
                            i4 &= -897;
                        }
                        if ((i3 & 8) != 0) {
                            i4 &= -7169;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                        }
                        function3 = function1;
                        companion = modifier2;
                        iM2668getLinearStrokeCapKaPHkGw = i6;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-339970038, i4, -1, "androidx.compose.material3.LinearProgressIndicator (ProgressIndicator.kt:152)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1145005305, "CC(remember):ProgressIndicator.kt#9igjgp");
                    if ((i4 & 14) == 4) {
                        z3 = true;
                    } else {
                        z3 = false;
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (z3 || objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2697invoke() {
                                return Float.valueOf(RangesKt.coerceIn(((Number) function0.invoke()).floatValue(), 0.0f, 1.0f));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    function4 = (Function0) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier modifierThen = companion.then(IncreaseSemanticsBounds);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1145010240, "CC(remember):ProgressIndicator.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(function4);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (zChanged || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue3 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((SemanticsPropertyReceiver) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                SemanticsPropertiesKt.setProgressBarRangeInfo(semanticsPropertyReceiver, new ProgressBarRangeInfo(((Number) function4.invoke()).floatValue(), RangesKt.rangeTo(0.0f, 1.0f), 0, 4, null));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier modifierM1082sizeVpY3zN4 = SizeKt.m1082sizeVpY3zN4(SemanticsModifierKt.semantics(modifierThen, true, (Function1) objRememberedValue3), LinearIndicatorWidth, LinearIndicatorHeight);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1145016448, "CC(remember):ProgressIndicator.kt#9igjgp");
                    if ((57344 & i4) == 16384) {
                        z4 = true;
                    } else {
                        z4 = false;
                    }
                    if ((458752 & i4) == 131072) {
                        z5 = true;
                    } else {
                        z5 = false;
                    }
                    zChanged2 = z4 | z5 | composerStartRestartGroup.changed(function4) | ((((i4 & 7168) ^ 3072) <= 2048 && composerStartRestartGroup.changed(linearTrackColor)) || (i4 & 3072) == 2048) | ((((i4 & 896) ^ 384) <= 256 && composerStartRestartGroup.changed(linearColor)) || (i4 & 384) == 256) | ((((3670016 & i4) ^ 1572864) <= 1048576 && composerStartRestartGroup.changed(function3)) || (i4 & 1572864) == 1048576);
                    objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                    if (zChanged2 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                        final int i15 = iM2668getLinearStrokeCapKaPHkGw;
                        final float f3 = fM2667getLinearIndicatorTrackGapSizeD9Ej5fM;
                        final long j4 = linearTrackColor;
                        final long j5 = linearColor;
                        final Function1<? super DrawScope, Unit> function6 = function3;
                        objRememberedValue4 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                float f4;
                                float fM4412getHeightimpl = Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc());
                                if (StrokeCap.m4959equalsimpl0(i15, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc()) > Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc())) {
                                    f4 = f3;
                                } else {
                                    f4 = Dp.constructor-impl(f3 + drawScope.toDp-u2uoSUM(fM4412getHeightimpl));
                                }
                                float f5 = f4 / drawScope.toDp-u2uoSUM(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()));
                                float fFloatValue = ((Number) function4.invoke()).floatValue();
                                float fMin = fFloatValue + Math.min(fFloatValue, f5);
                                if (fMin <= 1.0f) {
                                    ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, fMin, 1.0f, j4, fM4412getHeightimpl, i15);
                                }
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, 0.0f, fFloatValue, j5, fM4412getHeightimpl, i15);
                                function6.invoke(drawScope);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CanvasKt.Canvas(modifierM1082sizeVpY3zN4, (Function1) objRememberedValue4, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    f2 = fM2667getLinearIndicatorTrackGapSizeD9Ej5fM;
                    function5 = function3;
                    j3 = linearColor;
                    i10 = iM2668getLinearStrokeCapKaPHkGw;
                } else {
                    composerStartRestartGroup.skipToGroupEnd();
                    f2 = fM2667getLinearIndicatorTrackGapSizeD9Ej5fM;
                    companion = modifier2;
                    i10 = i6;
                    j3 = linearColor;
                    function5 = function2;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier3 = companion;
                    final long j6 = linearTrackColor;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i16) {
                            ProgressIndicatorKt.m2677LinearProgressIndicatorGJbTh5U(function0, modifier3, j3, j6, i10, f2, function5, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                        }
                    });
                }
            }
            i4 |= 24576;
            i6 = i;
            i8 = i3 & 32;
            if (i8 != 0) {
                i4 |= 196608;
                fM2667getLinearIndicatorTrackGapSizeD9Ej5fM = f;
            } else {
                fM2667getLinearIndicatorTrackGapSizeD9Ej5fM = f;
                if ((i2 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(fM2667getLinearIndicatorTrackGapSizeD9Ej5fM)) {
                        i9 = Fields.RenderEffect;
                    } else {
                        i9 = 65536;
                    }
                    i4 |= i9;
                }
            }
            if ((i2 & 1572864) == 0) {
                function2 = function1;
                if ((i3 & 64) == 0) {
                    i11 = 524288;
                } else {
                    i11 = 524288;
                }
                i4 |= i11;
            } else {
                function2 = function1;
            }
            if ((i4 & 599187) == 599186) {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) != 0) {
                    if (i14 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 4) != 0) {
                        linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if ((i3 & 8) != 0) {
                        linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                        i4 &= -7169;
                    }
                    if (i5 != 0) {
                        iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                    } else {
                        iM2668getLinearStrokeCapKaPHkGw = i6;
                    }
                    if (i8 != 0) {
                        fM2667getLinearIndicatorTrackGapSizeD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2667getLinearIndicatorTrackGapSizeD9Ej5fM();
                    }
                    if ((i3 & 64) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1144997616, "CC(remember):ProgressIndicator.kt#9igjgp");
                        if (((i4 & 896) ^ 384) <= 256) {
                        }
                        if ((57344 & i4) == 16384) {
                            z = true;
                        } else {
                            z = false;
                        }
                        z2 = z6 | z;
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (z2) {
                            objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    ProgressIndicatorDefaults.INSTANCE.m2662drawStopIndicatorEgI2THU(drawScope, ProgressIndicatorDefaults.INSTANCE.m2669getLinearTrackStopIndicatorSizeD9Ej5fM(), linearColor, iM2668getLinearStrokeCapKaPHkGw);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
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
                                    ProgressIndicatorDefaults.INSTANCE.m2662drawStopIndicatorEgI2THU(drawScope, ProgressIndicatorDefaults.INSTANCE.m2669getLinearTrackStopIndicatorSizeD9Ej5fM(), linearColor, iM2668getLinearStrokeCapKaPHkGw);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        function3 = (Function1) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i4 &= -3670017;
                    } else {
                        function3 = function1;
                    }
                } else {
                    if (i14 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 4) != 0) {
                        linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if ((i3 & 8) != 0) {
                        linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                        i4 &= -7169;
                    }
                    if (i5 != 0) {
                        iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                    } else {
                        iM2668getLinearStrokeCapKaPHkGw = i6;
                    }
                    if (i8 != 0) {
                        fM2667getLinearIndicatorTrackGapSizeD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2667getLinearIndicatorTrackGapSizeD9Ej5fM();
                    }
                    if ((i3 & 64) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1144997616, "CC(remember):ProgressIndicator.kt#9igjgp");
                        if (((i4 & 896) ^ 384) <= 256) {
                        }
                        if ((57344 & i4) == 16384) {
                            z = true;
                        } else {
                            z = false;
                        }
                        z2 = z6 | z;
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (z2) {
                            objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    ProgressIndicatorDefaults.INSTANCE.m2662drawStopIndicatorEgI2THU(drawScope, ProgressIndicatorDefaults.INSTANCE.m2669getLinearTrackStopIndicatorSizeD9Ej5fM(), linearColor, iM2668getLinearStrokeCapKaPHkGw);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
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
                                    ProgressIndicatorDefaults.INSTANCE.m2662drawStopIndicatorEgI2THU(drawScope, ProgressIndicatorDefaults.INSTANCE.m2669getLinearTrackStopIndicatorSizeD9Ej5fM(), linearColor, iM2668getLinearStrokeCapKaPHkGw);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        function3 = (Function1) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i4 &= -3670017;
                    } else {
                        function3 = function1;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-339970038, i4, -1, "androidx.compose.material3.LinearProgressIndicator (ProgressIndicator.kt:152)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1145005305, "CC(remember):ProgressIndicator.kt#9igjgp");
                if ((i4 & 14) == 4) {
                    z3 = true;
                } else {
                    z3 = false;
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (z3) {
                    objRememberedValue2 = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2697invoke() {
                            return Float.valueOf(RangesKt.coerceIn(((Number) function0.invoke()).floatValue(), 0.0f, 1.0f));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2697invoke() {
                            return Float.valueOf(RangesKt.coerceIn(((Number) function0.invoke()).floatValue(), 0.0f, 1.0f));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                function4 = (Function0) objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierThen2 = companion.then(IncreaseSemanticsBounds);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1145010240, "CC(remember):ProgressIndicator.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(function4);
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (zChanged) {
                    objRememberedValue3 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SemanticsPropertyReceiver) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            SemanticsPropertiesKt.setProgressBarRangeInfo(semanticsPropertyReceiver, new ProgressBarRangeInfo(((Number) function4.invoke()).floatValue(), RangesKt.rangeTo(0.0f, 1.0f), 0, 4, null));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SemanticsPropertyReceiver) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            SemanticsPropertiesKt.setProgressBarRangeInfo(semanticsPropertyReceiver, new ProgressBarRangeInfo(((Number) function4.invoke()).floatValue(), RangesKt.rangeTo(0.0f, 1.0f), 0, 4, null));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierM1082sizeVpY3zN5 = SizeKt.m1082sizeVpY3zN4(SemanticsModifierKt.semantics(modifierThen2, true, (Function1) objRememberedValue3), LinearIndicatorWidth, LinearIndicatorHeight);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1145016448, "CC(remember):ProgressIndicator.kt#9igjgp");
                if ((57344 & i4) == 16384) {
                    z4 = true;
                } else {
                    z4 = false;
                }
                if ((458752 & i4) == 131072) {
                    z5 = true;
                } else {
                    z5 = false;
                }
                zChanged2 = z4 | z5 | composerStartRestartGroup.changed(function4) | ((((i4 & 7168) ^ 3072) <= 2048 && composerStartRestartGroup.changed(linearTrackColor)) || (i4 & 3072) == 2048) | ((((i4 & 896) ^ 384) <= 256 && composerStartRestartGroup.changed(linearColor)) || (i4 & 384) == 256) | ((((3670016 & i4) ^ 1572864) <= 1048576 && composerStartRestartGroup.changed(function3)) || (i4 & 1572864) == 1048576);
                objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                if (zChanged2) {
                    final int i16 = iM2668getLinearStrokeCapKaPHkGw;
                    final float f4 = fM2667getLinearIndicatorTrackGapSizeD9Ej5fM;
                    final long j7 = linearTrackColor;
                    final long j8 = linearColor;
                    final Function1<? super DrawScope, Unit> function7 = function3;
                    objRememberedValue4 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            float f5;
                            float fM4412getHeightimpl = Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc());
                            if (StrokeCap.m4959equalsimpl0(i16, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc()) > Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc())) {
                                f5 = f4;
                            } else {
                                f5 = Dp.constructor-impl(f4 + drawScope.toDp-u2uoSUM(fM4412getHeightimpl));
                            }
                            float f6 = f5 / drawScope.toDp-u2uoSUM(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()));
                            float fFloatValue = ((Number) function4.invoke()).floatValue();
                            float fMin = fFloatValue + Math.min(fFloatValue, f6);
                            if (fMin <= 1.0f) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, fMin, 1.0f, j7, fM4412getHeightimpl, i16);
                            }
                            ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, 0.0f, fFloatValue, j8, fM4412getHeightimpl, i16);
                            function7.invoke(drawScope);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                } else {
                    final int i17 = iM2668getLinearStrokeCapKaPHkGw;
                    final float f5 = fM2667getLinearIndicatorTrackGapSizeD9Ej5fM;
                    final long j9 = linearTrackColor;
                    final long j10 = linearColor;
                    final Function1<? super DrawScope, Unit> function8 = function3;
                    objRememberedValue4 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            float f6;
                            float fM4412getHeightimpl = Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc());
                            if (StrokeCap.m4959equalsimpl0(i17, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc()) > Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc())) {
                                f6 = f5;
                            } else {
                                f6 = Dp.constructor-impl(f5 + drawScope.toDp-u2uoSUM(fM4412getHeightimpl));
                            }
                            float f7 = f6 / drawScope.toDp-u2uoSUM(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()));
                            float fFloatValue = ((Number) function4.invoke()).floatValue();
                            float fMin = fFloatValue + Math.min(fFloatValue, f7);
                            if (fMin <= 1.0f) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, fMin, 1.0f, j9, fM4412getHeightimpl, i17);
                            }
                            ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, 0.0f, fFloatValue, j10, fM4412getHeightimpl, i17);
                            function8.invoke(drawScope);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CanvasKt.Canvas(modifierM1082sizeVpY3zN5, (Function1) objRememberedValue4, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                f2 = fM2667getLinearIndicatorTrackGapSizeD9Ej5fM;
                function5 = function3;
                j3 = linearColor;
                i10 = iM2668getLinearStrokeCapKaPHkGw;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) != 0) {
                    if (i14 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 4) != 0) {
                        linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if ((i3 & 8) != 0) {
                        linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                        i4 &= -7169;
                    }
                    if (i5 != 0) {
                        iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                    } else {
                        iM2668getLinearStrokeCapKaPHkGw = i6;
                    }
                    if (i8 != 0) {
                        fM2667getLinearIndicatorTrackGapSizeD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2667getLinearIndicatorTrackGapSizeD9Ej5fM();
                    }
                    if ((i3 & 64) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1144997616, "CC(remember):ProgressIndicator.kt#9igjgp");
                        if (((i4 & 896) ^ 384) <= 256) {
                        }
                        if ((57344 & i4) == 16384) {
                            z = true;
                        } else {
                            z = false;
                        }
                        z2 = z6 | z;
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (z2) {
                            objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    ProgressIndicatorDefaults.INSTANCE.m2662drawStopIndicatorEgI2THU(drawScope, ProgressIndicatorDefaults.INSTANCE.m2669getLinearTrackStopIndicatorSizeD9Ej5fM(), linearColor, iM2668getLinearStrokeCapKaPHkGw);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
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
                                    ProgressIndicatorDefaults.INSTANCE.m2662drawStopIndicatorEgI2THU(drawScope, ProgressIndicatorDefaults.INSTANCE.m2669getLinearTrackStopIndicatorSizeD9Ej5fM(), linearColor, iM2668getLinearStrokeCapKaPHkGw);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        function3 = (Function1) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i4 &= -3670017;
                    } else {
                        function3 = function1;
                    }
                } else {
                    if (i14 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 4) != 0) {
                        linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if ((i3 & 8) != 0) {
                        linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                        i4 &= -7169;
                    }
                    if (i5 != 0) {
                        iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                    } else {
                        iM2668getLinearStrokeCapKaPHkGw = i6;
                    }
                    if (i8 != 0) {
                        fM2667getLinearIndicatorTrackGapSizeD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2667getLinearIndicatorTrackGapSizeD9Ej5fM();
                    }
                    if ((i3 & 64) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1144997616, "CC(remember):ProgressIndicator.kt#9igjgp");
                        if (((i4 & 896) ^ 384) <= 256) {
                        }
                        if ((57344 & i4) == 16384) {
                            z = true;
                        } else {
                            z = false;
                        }
                        z2 = z6 | z;
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (z2) {
                            objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    ProgressIndicatorDefaults.INSTANCE.m2662drawStopIndicatorEgI2THU(drawScope, ProgressIndicatorDefaults.INSTANCE.m2669getLinearTrackStopIndicatorSizeD9Ej5fM(), linearColor, iM2668getLinearStrokeCapKaPHkGw);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
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
                                    ProgressIndicatorDefaults.INSTANCE.m2662drawStopIndicatorEgI2THU(drawScope, ProgressIndicatorDefaults.INSTANCE.m2669getLinearTrackStopIndicatorSizeD9Ej5fM(), linearColor, iM2668getLinearStrokeCapKaPHkGw);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        function3 = (Function1) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i4 &= -3670017;
                    } else {
                        function3 = function1;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-339970038, i4, -1, "androidx.compose.material3.LinearProgressIndicator (ProgressIndicator.kt:152)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1145005305, "CC(remember):ProgressIndicator.kt#9igjgp");
                if ((i4 & 14) == 4) {
                    z3 = true;
                } else {
                    z3 = false;
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (z3) {
                    objRememberedValue2 = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2697invoke() {
                            return Float.valueOf(RangesKt.coerceIn(((Number) function0.invoke()).floatValue(), 0.0f, 1.0f));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2697invoke() {
                            return Float.valueOf(RangesKt.coerceIn(((Number) function0.invoke()).floatValue(), 0.0f, 1.0f));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                function4 = (Function0) objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierThen3 = companion.then(IncreaseSemanticsBounds);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1145010240, "CC(remember):ProgressIndicator.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(function4);
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (zChanged) {
                    objRememberedValue3 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SemanticsPropertyReceiver) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            SemanticsPropertiesKt.setProgressBarRangeInfo(semanticsPropertyReceiver, new ProgressBarRangeInfo(((Number) function4.invoke()).floatValue(), RangesKt.rangeTo(0.0f, 1.0f), 0, 4, null));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SemanticsPropertyReceiver) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            SemanticsPropertiesKt.setProgressBarRangeInfo(semanticsPropertyReceiver, new ProgressBarRangeInfo(((Number) function4.invoke()).floatValue(), RangesKt.rangeTo(0.0f, 1.0f), 0, 4, null));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierM1082sizeVpY3zN6 = SizeKt.m1082sizeVpY3zN4(SemanticsModifierKt.semantics(modifierThen3, true, (Function1) objRememberedValue3), LinearIndicatorWidth, LinearIndicatorHeight);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1145016448, "CC(remember):ProgressIndicator.kt#9igjgp");
                if ((57344 & i4) == 16384) {
                    z4 = true;
                } else {
                    z4 = false;
                }
                if ((458752 & i4) == 131072) {
                    z5 = true;
                } else {
                    z5 = false;
                }
                zChanged2 = z4 | z5 | composerStartRestartGroup.changed(function4) | ((((i4 & 7168) ^ 3072) <= 2048 && composerStartRestartGroup.changed(linearTrackColor)) || (i4 & 3072) == 2048) | ((((i4 & 896) ^ 384) <= 256 && composerStartRestartGroup.changed(linearColor)) || (i4 & 384) == 256) | ((((3670016 & i4) ^ 1572864) <= 1048576 && composerStartRestartGroup.changed(function3)) || (i4 & 1572864) == 1048576);
                objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                if (zChanged2) {
                    final int i18 = iM2668getLinearStrokeCapKaPHkGw;
                    final float f6 = fM2667getLinearIndicatorTrackGapSizeD9Ej5fM;
                    final long j11 = linearTrackColor;
                    final long j12 = linearColor;
                    final Function1<? super DrawScope, Unit> function9 = function3;
                    objRememberedValue4 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            float f7;
                            float fM4412getHeightimpl = Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc());
                            if (StrokeCap.m4959equalsimpl0(i18, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc()) > Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc())) {
                                f7 = f6;
                            } else {
                                f7 = Dp.constructor-impl(f6 + drawScope.toDp-u2uoSUM(fM4412getHeightimpl));
                            }
                            float f8 = f7 / drawScope.toDp-u2uoSUM(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()));
                            float fFloatValue = ((Number) function4.invoke()).floatValue();
                            float fMin = fFloatValue + Math.min(fFloatValue, f8);
                            if (fMin <= 1.0f) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, fMin, 1.0f, j11, fM4412getHeightimpl, i18);
                            }
                            ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, 0.0f, fFloatValue, j12, fM4412getHeightimpl, i18);
                            function9.invoke(drawScope);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                } else {
                    final int i19 = iM2668getLinearStrokeCapKaPHkGw;
                    final float f7 = fM2667getLinearIndicatorTrackGapSizeD9Ej5fM;
                    final long j13 = linearTrackColor;
                    final long j14 = linearColor;
                    final Function1<? super DrawScope, Unit> function10 = function3;
                    objRememberedValue4 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            float f8;
                            float fM4412getHeightimpl = Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc());
                            if (StrokeCap.m4959equalsimpl0(i19, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc()) > Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc())) {
                                f8 = f7;
                            } else {
                                f8 = Dp.constructor-impl(f7 + drawScope.toDp-u2uoSUM(fM4412getHeightimpl));
                            }
                            float f9 = f8 / drawScope.toDp-u2uoSUM(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()));
                            float fFloatValue = ((Number) function4.invoke()).floatValue();
                            float fMin = fFloatValue + Math.min(fFloatValue, f9);
                            if (fMin <= 1.0f) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, fMin, 1.0f, j13, fM4412getHeightimpl, i19);
                            }
                            ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, 0.0f, fFloatValue, j14, fM4412getHeightimpl, i19);
                            function10.invoke(drawScope);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CanvasKt.Canvas(modifierM1082sizeVpY3zN6, (Function1) objRememberedValue4, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                f2 = fM2667getLinearIndicatorTrackGapSizeD9Ej5fM;
                function5 = function3;
                j3 = linearColor;
                i10 = iM2668getLinearStrokeCapKaPHkGw;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier4 = companion;
                final long j15 = linearTrackColor;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i110) {
                        ProgressIndicatorKt.m2677LinearProgressIndicatorGJbTh5U(function0, modifier4, j3, j15, i10, f2, function5, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                    }
                });
            }
        }
        i4 |= 48;
        modifier2 = modifier;
        if ((i2 & 384) == 0) {
            linearColor = j;
            if ((i3 & 4) == 0) {
                i13 = Fields.SpotShadowColor;
            } else {
                i13 = Fields.SpotShadowColor;
            }
            i4 |= i13;
        } else {
            linearColor = j;
        }
        if ((i2 & 3072) == 0) {
            linearTrackColor = j2;
            if ((i3 & 8) == 0) {
                i12 = Fields.RotationZ;
            } else {
                i12 = Fields.RotationZ;
            }
            i4 |= i12;
        } else {
            linearTrackColor = j2;
        }
        i5 = i3 & 16;
        if (i5 != 0) {
            if ((i2 & 24576) == 0) {
                i6 = i;
                if (composerStartRestartGroup.changed(i6)) {
                    i7 = Fields.Clip;
                } else {
                    i7 = Fields.Shape;
                }
                i4 |= i7;
            }
            i8 = i3 & 32;
            if (i8 != 0) {
                i4 |= 196608;
                fM2667getLinearIndicatorTrackGapSizeD9Ej5fM = f;
            } else {
                fM2667getLinearIndicatorTrackGapSizeD9Ej5fM = f;
                if ((i2 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(fM2667getLinearIndicatorTrackGapSizeD9Ej5fM)) {
                        i9 = Fields.RenderEffect;
                    } else {
                        i9 = 65536;
                    }
                    i4 |= i9;
                }
            }
            if ((i2 & 1572864) == 0) {
                function2 = function1;
                if ((i3 & 64) == 0) {
                    i11 = 524288;
                } else {
                    i11 = 524288;
                }
                i4 |= i11;
            } else {
                function2 = function1;
            }
            if ((i4 & 599187) == 599186) {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) != 0) {
                    if (i14 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 4) != 0) {
                        linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if ((i3 & 8) != 0) {
                        linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                        i4 &= -7169;
                    }
                    if (i5 != 0) {
                        iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                    } else {
                        iM2668getLinearStrokeCapKaPHkGw = i6;
                    }
                    if (i8 != 0) {
                        fM2667getLinearIndicatorTrackGapSizeD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2667getLinearIndicatorTrackGapSizeD9Ej5fM();
                    }
                    if ((i3 & 64) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1144997616, "CC(remember):ProgressIndicator.kt#9igjgp");
                        if (((i4 & 896) ^ 384) <= 256) {
                        }
                        if ((57344 & i4) == 16384) {
                            z = true;
                        } else {
                            z = false;
                        }
                        z2 = z6 | z;
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (z2) {
                            objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    ProgressIndicatorDefaults.INSTANCE.m2662drawStopIndicatorEgI2THU(drawScope, ProgressIndicatorDefaults.INSTANCE.m2669getLinearTrackStopIndicatorSizeD9Ej5fM(), linearColor, iM2668getLinearStrokeCapKaPHkGw);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
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
                                    ProgressIndicatorDefaults.INSTANCE.m2662drawStopIndicatorEgI2THU(drawScope, ProgressIndicatorDefaults.INSTANCE.m2669getLinearTrackStopIndicatorSizeD9Ej5fM(), linearColor, iM2668getLinearStrokeCapKaPHkGw);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        function3 = (Function1) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i4 &= -3670017;
                    } else {
                        function3 = function1;
                    }
                } else {
                    if (i14 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 4) != 0) {
                        linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if ((i3 & 8) != 0) {
                        linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                        i4 &= -7169;
                    }
                    if (i5 != 0) {
                        iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                    } else {
                        iM2668getLinearStrokeCapKaPHkGw = i6;
                    }
                    if (i8 != 0) {
                        fM2667getLinearIndicatorTrackGapSizeD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2667getLinearIndicatorTrackGapSizeD9Ej5fM();
                    }
                    if ((i3 & 64) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1144997616, "CC(remember):ProgressIndicator.kt#9igjgp");
                        if (((i4 & 896) ^ 384) <= 256) {
                        }
                        if ((57344 & i4) == 16384) {
                            z = true;
                        } else {
                            z = false;
                        }
                        z2 = z6 | z;
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (z2) {
                            objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    ProgressIndicatorDefaults.INSTANCE.m2662drawStopIndicatorEgI2THU(drawScope, ProgressIndicatorDefaults.INSTANCE.m2669getLinearTrackStopIndicatorSizeD9Ej5fM(), linearColor, iM2668getLinearStrokeCapKaPHkGw);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
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
                                    ProgressIndicatorDefaults.INSTANCE.m2662drawStopIndicatorEgI2THU(drawScope, ProgressIndicatorDefaults.INSTANCE.m2669getLinearTrackStopIndicatorSizeD9Ej5fM(), linearColor, iM2668getLinearStrokeCapKaPHkGw);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        function3 = (Function1) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i4 &= -3670017;
                    } else {
                        function3 = function1;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-339970038, i4, -1, "androidx.compose.material3.LinearProgressIndicator (ProgressIndicator.kt:152)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1145005305, "CC(remember):ProgressIndicator.kt#9igjgp");
                if ((i4 & 14) == 4) {
                    z3 = true;
                } else {
                    z3 = false;
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (z3) {
                    objRememberedValue2 = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2697invoke() {
                            return Float.valueOf(RangesKt.coerceIn(((Number) function0.invoke()).floatValue(), 0.0f, 1.0f));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2697invoke() {
                            return Float.valueOf(RangesKt.coerceIn(((Number) function0.invoke()).floatValue(), 0.0f, 1.0f));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                function4 = (Function0) objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierThen4 = companion.then(IncreaseSemanticsBounds);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1145010240, "CC(remember):ProgressIndicator.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(function4);
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (zChanged) {
                    objRememberedValue3 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SemanticsPropertyReceiver) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            SemanticsPropertiesKt.setProgressBarRangeInfo(semanticsPropertyReceiver, new ProgressBarRangeInfo(((Number) function4.invoke()).floatValue(), RangesKt.rangeTo(0.0f, 1.0f), 0, 4, null));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SemanticsPropertyReceiver) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            SemanticsPropertiesKt.setProgressBarRangeInfo(semanticsPropertyReceiver, new ProgressBarRangeInfo(((Number) function4.invoke()).floatValue(), RangesKt.rangeTo(0.0f, 1.0f), 0, 4, null));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierM1082sizeVpY3zN7 = SizeKt.m1082sizeVpY3zN4(SemanticsModifierKt.semantics(modifierThen4, true, (Function1) objRememberedValue3), LinearIndicatorWidth, LinearIndicatorHeight);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1145016448, "CC(remember):ProgressIndicator.kt#9igjgp");
                if ((57344 & i4) == 16384) {
                    z4 = true;
                } else {
                    z4 = false;
                }
                if ((458752 & i4) == 131072) {
                    z5 = true;
                } else {
                    z5 = false;
                }
                zChanged2 = z4 | z5 | composerStartRestartGroup.changed(function4) | ((((i4 & 7168) ^ 3072) <= 2048 && composerStartRestartGroup.changed(linearTrackColor)) || (i4 & 3072) == 2048) | ((((i4 & 896) ^ 384) <= 256 && composerStartRestartGroup.changed(linearColor)) || (i4 & 384) == 256) | ((((3670016 & i4) ^ 1572864) <= 1048576 && composerStartRestartGroup.changed(function3)) || (i4 & 1572864) == 1048576);
                objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                if (zChanged2) {
                    final int i110 = iM2668getLinearStrokeCapKaPHkGw;
                    final float f8 = fM2667getLinearIndicatorTrackGapSizeD9Ej5fM;
                    final long j16 = linearTrackColor;
                    final long j17 = linearColor;
                    final Function1<? super DrawScope, Unit> function11 = function3;
                    objRememberedValue4 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            float f9;
                            float fM4412getHeightimpl = Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc());
                            if (StrokeCap.m4959equalsimpl0(i110, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc()) > Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc())) {
                                f9 = f8;
                            } else {
                                f9 = Dp.constructor-impl(f8 + drawScope.toDp-u2uoSUM(fM4412getHeightimpl));
                            }
                            float f10 = f9 / drawScope.toDp-u2uoSUM(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()));
                            float fFloatValue = ((Number) function4.invoke()).floatValue();
                            float fMin = fFloatValue + Math.min(fFloatValue, f10);
                            if (fMin <= 1.0f) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, fMin, 1.0f, j16, fM4412getHeightimpl, i110);
                            }
                            ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, 0.0f, fFloatValue, j17, fM4412getHeightimpl, i110);
                            function11.invoke(drawScope);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                } else {
                    final int i111 = iM2668getLinearStrokeCapKaPHkGw;
                    final float f9 = fM2667getLinearIndicatorTrackGapSizeD9Ej5fM;
                    final long j18 = linearTrackColor;
                    final long j19 = linearColor;
                    final Function1<? super DrawScope, Unit> function12 = function3;
                    objRememberedValue4 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            float f10;
                            float fM4412getHeightimpl = Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc());
                            if (StrokeCap.m4959equalsimpl0(i111, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc()) > Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc())) {
                                f10 = f9;
                            } else {
                                f10 = Dp.constructor-impl(f9 + drawScope.toDp-u2uoSUM(fM4412getHeightimpl));
                            }
                            float f11 = f10 / drawScope.toDp-u2uoSUM(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()));
                            float fFloatValue = ((Number) function4.invoke()).floatValue();
                            float fMin = fFloatValue + Math.min(fFloatValue, f11);
                            if (fMin <= 1.0f) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, fMin, 1.0f, j18, fM4412getHeightimpl, i111);
                            }
                            ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, 0.0f, fFloatValue, j19, fM4412getHeightimpl, i111);
                            function12.invoke(drawScope);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CanvasKt.Canvas(modifierM1082sizeVpY3zN7, (Function1) objRememberedValue4, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                f2 = fM2667getLinearIndicatorTrackGapSizeD9Ej5fM;
                function5 = function3;
                j3 = linearColor;
                i10 = iM2668getLinearStrokeCapKaPHkGw;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) != 0) {
                    if (i14 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 4) != 0) {
                        linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if ((i3 & 8) != 0) {
                        linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                        i4 &= -7169;
                    }
                    if (i5 != 0) {
                        iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                    } else {
                        iM2668getLinearStrokeCapKaPHkGw = i6;
                    }
                    if (i8 != 0) {
                        fM2667getLinearIndicatorTrackGapSizeD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2667getLinearIndicatorTrackGapSizeD9Ej5fM();
                    }
                    if ((i3 & 64) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1144997616, "CC(remember):ProgressIndicator.kt#9igjgp");
                        if (((i4 & 896) ^ 384) <= 256) {
                        }
                        if ((57344 & i4) == 16384) {
                            z = true;
                        } else {
                            z = false;
                        }
                        z2 = z6 | z;
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (z2) {
                            objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    ProgressIndicatorDefaults.INSTANCE.m2662drawStopIndicatorEgI2THU(drawScope, ProgressIndicatorDefaults.INSTANCE.m2669getLinearTrackStopIndicatorSizeD9Ej5fM(), linearColor, iM2668getLinearStrokeCapKaPHkGw);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
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
                                    ProgressIndicatorDefaults.INSTANCE.m2662drawStopIndicatorEgI2THU(drawScope, ProgressIndicatorDefaults.INSTANCE.m2669getLinearTrackStopIndicatorSizeD9Ej5fM(), linearColor, iM2668getLinearStrokeCapKaPHkGw);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        function3 = (Function1) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i4 &= -3670017;
                    } else {
                        function3 = function1;
                    }
                } else {
                    if (i14 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 4) != 0) {
                        linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if ((i3 & 8) != 0) {
                        linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                        i4 &= -7169;
                    }
                    if (i5 != 0) {
                        iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                    } else {
                        iM2668getLinearStrokeCapKaPHkGw = i6;
                    }
                    if (i8 != 0) {
                        fM2667getLinearIndicatorTrackGapSizeD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2667getLinearIndicatorTrackGapSizeD9Ej5fM();
                    }
                    if ((i3 & 64) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1144997616, "CC(remember):ProgressIndicator.kt#9igjgp");
                        if (((i4 & 896) ^ 384) <= 256) {
                        }
                        if ((57344 & i4) == 16384) {
                            z = true;
                        } else {
                            z = false;
                        }
                        z2 = z6 | z;
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (z2) {
                            objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    ProgressIndicatorDefaults.INSTANCE.m2662drawStopIndicatorEgI2THU(drawScope, ProgressIndicatorDefaults.INSTANCE.m2669getLinearTrackStopIndicatorSizeD9Ej5fM(), linearColor, iM2668getLinearStrokeCapKaPHkGw);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
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
                                    ProgressIndicatorDefaults.INSTANCE.m2662drawStopIndicatorEgI2THU(drawScope, ProgressIndicatorDefaults.INSTANCE.m2669getLinearTrackStopIndicatorSizeD9Ej5fM(), linearColor, iM2668getLinearStrokeCapKaPHkGw);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        function3 = (Function1) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i4 &= -3670017;
                    } else {
                        function3 = function1;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-339970038, i4, -1, "androidx.compose.material3.LinearProgressIndicator (ProgressIndicator.kt:152)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1145005305, "CC(remember):ProgressIndicator.kt#9igjgp");
                if ((i4 & 14) == 4) {
                    z3 = true;
                } else {
                    z3 = false;
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (z3) {
                    objRememberedValue2 = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2697invoke() {
                            return Float.valueOf(RangesKt.coerceIn(((Number) function0.invoke()).floatValue(), 0.0f, 1.0f));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2697invoke() {
                            return Float.valueOf(RangesKt.coerceIn(((Number) function0.invoke()).floatValue(), 0.0f, 1.0f));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                function4 = (Function0) objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierThen5 = companion.then(IncreaseSemanticsBounds);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1145010240, "CC(remember):ProgressIndicator.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(function4);
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (zChanged) {
                    objRememberedValue3 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SemanticsPropertyReceiver) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            SemanticsPropertiesKt.setProgressBarRangeInfo(semanticsPropertyReceiver, new ProgressBarRangeInfo(((Number) function4.invoke()).floatValue(), RangesKt.rangeTo(0.0f, 1.0f), 0, 4, null));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SemanticsPropertyReceiver) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            SemanticsPropertiesKt.setProgressBarRangeInfo(semanticsPropertyReceiver, new ProgressBarRangeInfo(((Number) function4.invoke()).floatValue(), RangesKt.rangeTo(0.0f, 1.0f), 0, 4, null));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierM1082sizeVpY3zN8 = SizeKt.m1082sizeVpY3zN4(SemanticsModifierKt.semantics(modifierThen5, true, (Function1) objRememberedValue3), LinearIndicatorWidth, LinearIndicatorHeight);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1145016448, "CC(remember):ProgressIndicator.kt#9igjgp");
                if ((57344 & i4) == 16384) {
                    z4 = true;
                } else {
                    z4 = false;
                }
                if ((458752 & i4) == 131072) {
                    z5 = true;
                } else {
                    z5 = false;
                }
                zChanged2 = z4 | z5 | composerStartRestartGroup.changed(function4) | ((((i4 & 7168) ^ 3072) <= 2048 && composerStartRestartGroup.changed(linearTrackColor)) || (i4 & 3072) == 2048) | ((((i4 & 896) ^ 384) <= 256 && composerStartRestartGroup.changed(linearColor)) || (i4 & 384) == 256) | ((((3670016 & i4) ^ 1572864) <= 1048576 && composerStartRestartGroup.changed(function3)) || (i4 & 1572864) == 1048576);
                objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                if (zChanged2) {
                    final int i112 = iM2668getLinearStrokeCapKaPHkGw;
                    final float f10 = fM2667getLinearIndicatorTrackGapSizeD9Ej5fM;
                    final long j110 = linearTrackColor;
                    final long j111 = linearColor;
                    final Function1<? super DrawScope, Unit> function13 = function3;
                    objRememberedValue4 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            float f11;
                            float fM4412getHeightimpl = Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc());
                            if (StrokeCap.m4959equalsimpl0(i112, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc()) > Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc())) {
                                f11 = f10;
                            } else {
                                f11 = Dp.constructor-impl(f10 + drawScope.toDp-u2uoSUM(fM4412getHeightimpl));
                            }
                            float f12 = f11 / drawScope.toDp-u2uoSUM(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()));
                            float fFloatValue = ((Number) function4.invoke()).floatValue();
                            float fMin = fFloatValue + Math.min(fFloatValue, f12);
                            if (fMin <= 1.0f) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, fMin, 1.0f, j110, fM4412getHeightimpl, i112);
                            }
                            ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, 0.0f, fFloatValue, j111, fM4412getHeightimpl, i112);
                            function13.invoke(drawScope);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                } else {
                    final int i113 = iM2668getLinearStrokeCapKaPHkGw;
                    final float f11 = fM2667getLinearIndicatorTrackGapSizeD9Ej5fM;
                    final long j112 = linearTrackColor;
                    final long j113 = linearColor;
                    final Function1<? super DrawScope, Unit> function14 = function3;
                    objRememberedValue4 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            float f12;
                            float fM4412getHeightimpl = Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc());
                            if (StrokeCap.m4959equalsimpl0(i113, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc()) > Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc())) {
                                f12 = f11;
                            } else {
                                f12 = Dp.constructor-impl(f11 + drawScope.toDp-u2uoSUM(fM4412getHeightimpl));
                            }
                            float f13 = f12 / drawScope.toDp-u2uoSUM(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()));
                            float fFloatValue = ((Number) function4.invoke()).floatValue();
                            float fMin = fFloatValue + Math.min(fFloatValue, f13);
                            if (fMin <= 1.0f) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, fMin, 1.0f, j112, fM4412getHeightimpl, i113);
                            }
                            ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, 0.0f, fFloatValue, j113, fM4412getHeightimpl, i113);
                            function14.invoke(drawScope);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CanvasKt.Canvas(modifierM1082sizeVpY3zN8, (Function1) objRememberedValue4, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                f2 = fM2667getLinearIndicatorTrackGapSizeD9Ej5fM;
                function5 = function3;
                j3 = linearColor;
                i10 = iM2668getLinearStrokeCapKaPHkGw;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier5 = companion;
                final long j114 = linearTrackColor;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i114) {
                        ProgressIndicatorKt.m2677LinearProgressIndicatorGJbTh5U(function0, modifier5, j3, j114, i10, f2, function5, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                    }
                });
            }
        }
        i4 |= 24576;
        i6 = i;
        i8 = i3 & 32;
        if (i8 != 0) {
            i4 |= 196608;
            fM2667getLinearIndicatorTrackGapSizeD9Ej5fM = f;
        } else {
            fM2667getLinearIndicatorTrackGapSizeD9Ej5fM = f;
            if ((i2 & 196608) == 0) {
                if (composerStartRestartGroup.changed(fM2667getLinearIndicatorTrackGapSizeD9Ej5fM)) {
                    i9 = Fields.RenderEffect;
                } else {
                    i9 = 65536;
                }
                i4 |= i9;
            }
        }
        if ((i2 & 1572864) == 0) {
            function2 = function1;
            if ((i3 & 64) == 0) {
                i11 = 524288;
            } else {
                i11 = 524288;
            }
            i4 |= i11;
        } else {
            function2 = function1;
        }
        if ((i4 & 599187) == 599186) {
            composerStartRestartGroup.startDefaults();
            if ((i2 & 1) != 0) {
                if (i14 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i3 & 4) != 0) {
                    linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                    i4 &= -897;
                }
                if ((i3 & 8) != 0) {
                    linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                    i4 &= -7169;
                }
                if (i5 != 0) {
                    iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                } else {
                    iM2668getLinearStrokeCapKaPHkGw = i6;
                }
                if (i8 != 0) {
                    fM2667getLinearIndicatorTrackGapSizeD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2667getLinearIndicatorTrackGapSizeD9Ej5fM();
                }
                if ((i3 & 64) != 0) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1144997616, "CC(remember):ProgressIndicator.kt#9igjgp");
                    if (((i4 & 896) ^ 384) <= 256) {
                    }
                    if ((57344 & i4) == 16384) {
                        z = true;
                    } else {
                        z = false;
                    }
                    z2 = z6 | z;
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (z2) {
                        objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                ProgressIndicatorDefaults.INSTANCE.m2662drawStopIndicatorEgI2THU(drawScope, ProgressIndicatorDefaults.INSTANCE.m2669getLinearTrackStopIndicatorSizeD9Ej5fM(), linearColor, iM2668getLinearStrokeCapKaPHkGw);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
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
                                ProgressIndicatorDefaults.INSTANCE.m2662drawStopIndicatorEgI2THU(drawScope, ProgressIndicatorDefaults.INSTANCE.m2669getLinearTrackStopIndicatorSizeD9Ej5fM(), linearColor, iM2668getLinearStrokeCapKaPHkGw);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    function3 = (Function1) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    i4 &= -3670017;
                } else {
                    function3 = function1;
                }
            } else {
                if (i14 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i3 & 4) != 0) {
                    linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                    i4 &= -897;
                }
                if ((i3 & 8) != 0) {
                    linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                    i4 &= -7169;
                }
                if (i5 != 0) {
                    iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                } else {
                    iM2668getLinearStrokeCapKaPHkGw = i6;
                }
                if (i8 != 0) {
                    fM2667getLinearIndicatorTrackGapSizeD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2667getLinearIndicatorTrackGapSizeD9Ej5fM();
                }
                if ((i3 & 64) != 0) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1144997616, "CC(remember):ProgressIndicator.kt#9igjgp");
                    if (((i4 & 896) ^ 384) <= 256) {
                    }
                    if ((57344 & i4) == 16384) {
                        z = true;
                    } else {
                        z = false;
                    }
                    z2 = z6 | z;
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (z2) {
                        objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                ProgressIndicatorDefaults.INSTANCE.m2662drawStopIndicatorEgI2THU(drawScope, ProgressIndicatorDefaults.INSTANCE.m2669getLinearTrackStopIndicatorSizeD9Ej5fM(), linearColor, iM2668getLinearStrokeCapKaPHkGw);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
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
                                ProgressIndicatorDefaults.INSTANCE.m2662drawStopIndicatorEgI2THU(drawScope, ProgressIndicatorDefaults.INSTANCE.m2669getLinearTrackStopIndicatorSizeD9Ej5fM(), linearColor, iM2668getLinearStrokeCapKaPHkGw);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    function3 = (Function1) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    i4 &= -3670017;
                } else {
                    function3 = function1;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-339970038, i4, -1, "androidx.compose.material3.LinearProgressIndicator (ProgressIndicator.kt:152)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1145005305, "CC(remember):ProgressIndicator.kt#9igjgp");
            if ((i4 & 14) == 4) {
                z3 = true;
            } else {
                z3 = false;
            }
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (z3) {
                objRememberedValue2 = (Function0) new Function0<Float>() {
                    {
                        super(0);
                    }

                    public final Float m2697invoke() {
                        return Float.valueOf(RangesKt.coerceIn(((Number) function0.invoke()).floatValue(), 0.0f, 1.0f));
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            } else {
                objRememberedValue2 = (Function0) new Function0<Float>() {
                    {
                        super(0);
                    }

                    public final Float m2697invoke() {
                        return Float.valueOf(RangesKt.coerceIn(((Number) function0.invoke()).floatValue(), 0.0f, 1.0f));
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            }
            function4 = (Function0) objRememberedValue2;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            Modifier modifierThen6 = companion.then(IncreaseSemanticsBounds);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1145010240, "CC(remember):ProgressIndicator.kt#9igjgp");
            zChanged = composerStartRestartGroup.changed(function4);
            objRememberedValue3 = composerStartRestartGroup.rememberedValue();
            if (zChanged) {
                objRememberedValue3 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((SemanticsPropertyReceiver) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                        SemanticsPropertiesKt.setProgressBarRangeInfo(semanticsPropertyReceiver, new ProgressBarRangeInfo(((Number) function4.invoke()).floatValue(), RangesKt.rangeTo(0.0f, 1.0f), 0, 4, null));
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
            } else {
                objRememberedValue3 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((SemanticsPropertyReceiver) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                        SemanticsPropertiesKt.setProgressBarRangeInfo(semanticsPropertyReceiver, new ProgressBarRangeInfo(((Number) function4.invoke()).floatValue(), RangesKt.rangeTo(0.0f, 1.0f), 0, 4, null));
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            Modifier modifierM1082sizeVpY3zN9 = SizeKt.m1082sizeVpY3zN4(SemanticsModifierKt.semantics(modifierThen6, true, (Function1) objRememberedValue3), LinearIndicatorWidth, LinearIndicatorHeight);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1145016448, "CC(remember):ProgressIndicator.kt#9igjgp");
            if ((57344 & i4) == 16384) {
                z4 = true;
            } else {
                z4 = false;
            }
            if ((458752 & i4) == 131072) {
                z5 = true;
            } else {
                z5 = false;
            }
            zChanged2 = z4 | z5 | composerStartRestartGroup.changed(function4) | ((((i4 & 7168) ^ 3072) <= 2048 && composerStartRestartGroup.changed(linearTrackColor)) || (i4 & 3072) == 2048) | ((((i4 & 896) ^ 384) <= 256 && composerStartRestartGroup.changed(linearColor)) || (i4 & 384) == 256) | ((((3670016 & i4) ^ 1572864) <= 1048576 && composerStartRestartGroup.changed(function3)) || (i4 & 1572864) == 1048576);
            objRememberedValue4 = composerStartRestartGroup.rememberedValue();
            if (zChanged2) {
                final int i114 = iM2668getLinearStrokeCapKaPHkGw;
                final float f12 = fM2667getLinearIndicatorTrackGapSizeD9Ej5fM;
                final long j115 = linearTrackColor;
                final long j116 = linearColor;
                final Function1<? super DrawScope, Unit> function15 = function3;
                objRememberedValue4 = (Function1) new Function1<DrawScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((DrawScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(DrawScope drawScope) {
                        float f13;
                        float fM4412getHeightimpl = Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc());
                        if (StrokeCap.m4959equalsimpl0(i114, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc()) > Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc())) {
                            f13 = f12;
                        } else {
                            f13 = Dp.constructor-impl(f12 + drawScope.toDp-u2uoSUM(fM4412getHeightimpl));
                        }
                        float f14 = f13 / drawScope.toDp-u2uoSUM(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()));
                        float fFloatValue = ((Number) function4.invoke()).floatValue();
                        float fMin = fFloatValue + Math.min(fFloatValue, f14);
                        if (fMin <= 1.0f) {
                            ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, fMin, 1.0f, j115, fM4412getHeightimpl, i114);
                        }
                        ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, 0.0f, fFloatValue, j116, fM4412getHeightimpl, i114);
                        function15.invoke(drawScope);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
            } else {
                final int i115 = iM2668getLinearStrokeCapKaPHkGw;
                final float f13 = fM2667getLinearIndicatorTrackGapSizeD9Ej5fM;
                final long j117 = linearTrackColor;
                final long j118 = linearColor;
                final Function1<? super DrawScope, Unit> function16 = function3;
                objRememberedValue4 = (Function1) new Function1<DrawScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((DrawScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(DrawScope drawScope) {
                        float f14;
                        float fM4412getHeightimpl = Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc());
                        if (StrokeCap.m4959equalsimpl0(i115, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc()) > Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc())) {
                            f14 = f13;
                        } else {
                            f14 = Dp.constructor-impl(f13 + drawScope.toDp-u2uoSUM(fM4412getHeightimpl));
                        }
                        float f15 = f14 / drawScope.toDp-u2uoSUM(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()));
                        float fFloatValue = ((Number) function4.invoke()).floatValue();
                        float fMin = fFloatValue + Math.min(fFloatValue, f15);
                        if (fMin <= 1.0f) {
                            ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, fMin, 1.0f, j117, fM4412getHeightimpl, i115);
                        }
                        ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, 0.0f, fFloatValue, j118, fM4412getHeightimpl, i115);
                        function16.invoke(drawScope);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            CanvasKt.Canvas(modifierM1082sizeVpY3zN9, (Function1) objRememberedValue4, composerStartRestartGroup, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            f2 = fM2667getLinearIndicatorTrackGapSizeD9Ej5fM;
            function5 = function3;
            j3 = linearColor;
            i10 = iM2668getLinearStrokeCapKaPHkGw;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i2 & 1) != 0) {
                if (i14 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i3 & 4) != 0) {
                    linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                    i4 &= -897;
                }
                if ((i3 & 8) != 0) {
                    linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                    i4 &= -7169;
                }
                if (i5 != 0) {
                    iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                } else {
                    iM2668getLinearStrokeCapKaPHkGw = i6;
                }
                if (i8 != 0) {
                    fM2667getLinearIndicatorTrackGapSizeD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2667getLinearIndicatorTrackGapSizeD9Ej5fM();
                }
                if ((i3 & 64) != 0) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1144997616, "CC(remember):ProgressIndicator.kt#9igjgp");
                    if (((i4 & 896) ^ 384) <= 256) {
                    }
                    if ((57344 & i4) == 16384) {
                        z = true;
                    } else {
                        z = false;
                    }
                    z2 = z6 | z;
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (z2) {
                        objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                ProgressIndicatorDefaults.INSTANCE.m2662drawStopIndicatorEgI2THU(drawScope, ProgressIndicatorDefaults.INSTANCE.m2669getLinearTrackStopIndicatorSizeD9Ej5fM(), linearColor, iM2668getLinearStrokeCapKaPHkGw);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
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
                                ProgressIndicatorDefaults.INSTANCE.m2662drawStopIndicatorEgI2THU(drawScope, ProgressIndicatorDefaults.INSTANCE.m2669getLinearTrackStopIndicatorSizeD9Ej5fM(), linearColor, iM2668getLinearStrokeCapKaPHkGw);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    function3 = (Function1) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    i4 &= -3670017;
                } else {
                    function3 = function1;
                }
            } else {
                if (i14 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i3 & 4) != 0) {
                    linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                    i4 &= -897;
                }
                if ((i3 & 8) != 0) {
                    linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                    i4 &= -7169;
                }
                if (i5 != 0) {
                    iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                } else {
                    iM2668getLinearStrokeCapKaPHkGw = i6;
                }
                if (i8 != 0) {
                    fM2667getLinearIndicatorTrackGapSizeD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2667getLinearIndicatorTrackGapSizeD9Ej5fM();
                }
                if ((i3 & 64) != 0) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1144997616, "CC(remember):ProgressIndicator.kt#9igjgp");
                    if (((i4 & 896) ^ 384) <= 256) {
                    }
                    if ((57344 & i4) == 16384) {
                        z = true;
                    } else {
                        z = false;
                    }
                    z2 = z6 | z;
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (z2) {
                        objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                ProgressIndicatorDefaults.INSTANCE.m2662drawStopIndicatorEgI2THU(drawScope, ProgressIndicatorDefaults.INSTANCE.m2669getLinearTrackStopIndicatorSizeD9Ej5fM(), linearColor, iM2668getLinearStrokeCapKaPHkGw);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
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
                                ProgressIndicatorDefaults.INSTANCE.m2662drawStopIndicatorEgI2THU(drawScope, ProgressIndicatorDefaults.INSTANCE.m2669getLinearTrackStopIndicatorSizeD9Ej5fM(), linearColor, iM2668getLinearStrokeCapKaPHkGw);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    function3 = (Function1) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    i4 &= -3670017;
                } else {
                    function3 = function1;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-339970038, i4, -1, "androidx.compose.material3.LinearProgressIndicator (ProgressIndicator.kt:152)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1145005305, "CC(remember):ProgressIndicator.kt#9igjgp");
            if ((i4 & 14) == 4) {
                z3 = true;
            } else {
                z3 = false;
            }
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (z3) {
                objRememberedValue2 = (Function0) new Function0<Float>() {
                    {
                        super(0);
                    }

                    public final Float m2697invoke() {
                        return Float.valueOf(RangesKt.coerceIn(((Number) function0.invoke()).floatValue(), 0.0f, 1.0f));
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            } else {
                objRememberedValue2 = (Function0) new Function0<Float>() {
                    {
                        super(0);
                    }

                    public final Float m2697invoke() {
                        return Float.valueOf(RangesKt.coerceIn(((Number) function0.invoke()).floatValue(), 0.0f, 1.0f));
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            }
            function4 = (Function0) objRememberedValue2;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            Modifier modifierThen7 = companion.then(IncreaseSemanticsBounds);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1145010240, "CC(remember):ProgressIndicator.kt#9igjgp");
            zChanged = composerStartRestartGroup.changed(function4);
            objRememberedValue3 = composerStartRestartGroup.rememberedValue();
            if (zChanged) {
                objRememberedValue3 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((SemanticsPropertyReceiver) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                        SemanticsPropertiesKt.setProgressBarRangeInfo(semanticsPropertyReceiver, new ProgressBarRangeInfo(((Number) function4.invoke()).floatValue(), RangesKt.rangeTo(0.0f, 1.0f), 0, 4, null));
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
            } else {
                objRememberedValue3 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((SemanticsPropertyReceiver) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                        SemanticsPropertiesKt.setProgressBarRangeInfo(semanticsPropertyReceiver, new ProgressBarRangeInfo(((Number) function4.invoke()).floatValue(), RangesKt.rangeTo(0.0f, 1.0f), 0, 4, null));
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            Modifier modifierM1082sizeVpY3zN10 = SizeKt.m1082sizeVpY3zN4(SemanticsModifierKt.semantics(modifierThen7, true, (Function1) objRememberedValue3), LinearIndicatorWidth, LinearIndicatorHeight);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1145016448, "CC(remember):ProgressIndicator.kt#9igjgp");
            if ((57344 & i4) == 16384) {
                z4 = true;
            } else {
                z4 = false;
            }
            if ((458752 & i4) == 131072) {
                z5 = true;
            } else {
                z5 = false;
            }
            zChanged2 = z4 | z5 | composerStartRestartGroup.changed(function4) | ((((i4 & 7168) ^ 3072) <= 2048 && composerStartRestartGroup.changed(linearTrackColor)) || (i4 & 3072) == 2048) | ((((i4 & 896) ^ 384) <= 256 && composerStartRestartGroup.changed(linearColor)) || (i4 & 384) == 256) | ((((3670016 & i4) ^ 1572864) <= 1048576 && composerStartRestartGroup.changed(function3)) || (i4 & 1572864) == 1048576);
            objRememberedValue4 = composerStartRestartGroup.rememberedValue();
            if (zChanged2) {
                final int i116 = iM2668getLinearStrokeCapKaPHkGw;
                final float f14 = fM2667getLinearIndicatorTrackGapSizeD9Ej5fM;
                final long j119 = linearTrackColor;
                final long j1110 = linearColor;
                final Function1<? super DrawScope, Unit> function17 = function3;
                objRememberedValue4 = (Function1) new Function1<DrawScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((DrawScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(DrawScope drawScope) {
                        float f15;
                        float fM4412getHeightimpl = Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc());
                        if (StrokeCap.m4959equalsimpl0(i116, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc()) > Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc())) {
                            f15 = f14;
                        } else {
                            f15 = Dp.constructor-impl(f14 + drawScope.toDp-u2uoSUM(fM4412getHeightimpl));
                        }
                        float f16 = f15 / drawScope.toDp-u2uoSUM(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()));
                        float fFloatValue = ((Number) function4.invoke()).floatValue();
                        float fMin = fFloatValue + Math.min(fFloatValue, f16);
                        if (fMin <= 1.0f) {
                            ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, fMin, 1.0f, j119, fM4412getHeightimpl, i116);
                        }
                        ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, 0.0f, fFloatValue, j1110, fM4412getHeightimpl, i116);
                        function17.invoke(drawScope);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
            } else {
                final int i117 = iM2668getLinearStrokeCapKaPHkGw;
                final float f15 = fM2667getLinearIndicatorTrackGapSizeD9Ej5fM;
                final long j1111 = linearTrackColor;
                final long j1112 = linearColor;
                final Function1<? super DrawScope, Unit> function18 = function3;
                objRememberedValue4 = (Function1) new Function1<DrawScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((DrawScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(DrawScope drawScope) {
                        float f16;
                        float fM4412getHeightimpl = Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc());
                        if (StrokeCap.m4959equalsimpl0(i117, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc()) > Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc())) {
                            f16 = f15;
                        } else {
                            f16 = Dp.constructor-impl(f15 + drawScope.toDp-u2uoSUM(fM4412getHeightimpl));
                        }
                        float f17 = f16 / drawScope.toDp-u2uoSUM(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()));
                        float fFloatValue = ((Number) function4.invoke()).floatValue();
                        float fMin = fFloatValue + Math.min(fFloatValue, f17);
                        if (fMin <= 1.0f) {
                            ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, fMin, 1.0f, j1111, fM4412getHeightimpl, i117);
                        }
                        ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, 0.0f, fFloatValue, j1112, fM4412getHeightimpl, i117);
                        function18.invoke(drawScope);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            CanvasKt.Canvas(modifierM1082sizeVpY3zN10, (Function1) objRememberedValue4, composerStartRestartGroup, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            f2 = fM2667getLinearIndicatorTrackGapSizeD9Ej5fM;
            function5 = function3;
            j3 = linearColor;
            i10 = iM2668getLinearStrokeCapKaPHkGw;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier6 = companion;
            final long j1113 = linearTrackColor;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i118) {
                    ProgressIndicatorKt.m2677LinearProgressIndicatorGJbTh5U(function0, modifier6, j3, j1113, i10, f2, function5, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                }
            });
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Use the overload that takes `gapSize`, see `LegacyIndeterminateLinearProgressIndicatorSample` on how to restore the previous behavior", replaceWith = @ReplaceWith(expression = "LinearProgressIndicator(modifier, color, trackColor, strokeCap, gapSize)", imports = {}))
    public static final void m2676LinearProgressIndicator2cYBFYY(Modifier modifier, long j, long j2, int i, Composer composer, final int i2, final int i3) {
        Modifier modifier2;
        int i4;
        long linearColor;
        long linearTrackColor;
        int i5;
        Modifier.Companion companion;
        int iM2668getLinearStrokeCapKaPHkGw;
        int i6;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i7;
        Composer composerStartRestartGroup = composer.startRestartGroup(-476865359);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(LinearProgressIndicator)P(1,0:c#ui.graphics.Color,3:c#ui.graphics.Color,2:c#ui.graphics.StrokeCap)214@9497L11,215@9560L16,218@9656L175:ProgressIndicator.kt#uh7d8r");
        int i8 = i3 & 1;
        if (i8 != 0) {
            i4 = i2 | 6;
            modifier2 = modifier;
        } else if ((i2 & 6) == 0) {
            modifier2 = modifier;
            i4 = (composerStartRestartGroup.changed(modifier2) ? 4 : 2) | i2;
        } else {
            modifier2 = modifier;
            i4 = i2;
        }
        if ((i2 & 48) == 0) {
            if ((i3 & 2) == 0) {
                linearColor = j;
                int i9 = composerStartRestartGroup.changed(linearColor) ? 32 : 16;
                i4 |= i9;
            } else {
                linearColor = j;
            }
            i4 |= i9;
        } else {
            linearColor = j;
        }
        if ((i2 & 384) == 0) {
            if ((i3 & 4) == 0) {
                linearTrackColor = j2;
                if (composerStartRestartGroup.changed(linearTrackColor)) {
                    i7 = Fields.RotationX;
                }
                i4 |= i7;
            } else {
                linearTrackColor = j2;
            }
            i7 = Fields.SpotShadowColor;
            i4 |= i7;
        } else {
            linearTrackColor = j2;
        }
        int i10 = i3 & 8;
        if (i10 == 0) {
            if ((i2 & 3072) == 0) {
                i5 = i;
                i4 |= composerStartRestartGroup.changed(i5) ? Fields.CameraDistance : Fields.RotationZ;
            }
            if ((i4 & 1171) == 1170 || !composerStartRestartGroup.getSkipping()) {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) == 0 && !composerStartRestartGroup.getDefaultsInvalid()) {
                    composerStartRestartGroup.skipToGroupEnd();
                    if ((i3 & 2) != 0) {
                        i4 &= -113;
                    }
                    if ((i3 & 4) != 0) {
                        i4 &= -897;
                    }
                    companion = modifier2;
                } else {
                    if (i8 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 2) != 0) {
                        linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                        i4 &= -113;
                    }
                    if ((i3 & 4) != 0) {
                        linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i10 != 0) {
                        iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                    }
                    long j3 = linearTrackColor;
                    i6 = i4;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-476865359, i6, -1, "androidx.compose.material3.LinearProgressIndicator (ProgressIndicator.kt:217)");
                    }
                    m2682LinearProgressIndicatorrIrjwxo(companion, linearColor, j3, iM2668getLinearStrokeCapKaPHkGw, ProgressIndicatorDefaults.INSTANCE.m2667getLinearIndicatorTrackGapSizeD9Ej5fM(), composerStartRestartGroup, (i6 & 14) | 24576 | (i6 & 112) | (i6 & 896) | (i6 & 7168), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    linearTrackColor = j3;
                    i5 = iM2668getLinearStrokeCapKaPHkGw;
                }
                iM2668getLinearStrokeCapKaPHkGw = i5;
                long j4 = linearTrackColor;
                i6 = i4;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-476865359, i6, -1, "androidx.compose.material3.LinearProgressIndicator (ProgressIndicator.kt:217)");
                }
                m2682LinearProgressIndicatorrIrjwxo(companion, linearColor, j4, iM2668getLinearStrokeCapKaPHkGw, ProgressIndicatorDefaults.INSTANCE.m2667getLinearIndicatorTrackGapSizeD9Ej5fM(), composerStartRestartGroup, (i6 & 14) | 24576 | (i6 & 112) | (i6 & 896) | (i6 & 7168), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                linearTrackColor = j4;
                i5 = iM2668getLinearStrokeCapKaPHkGw;
            } else {
                composerStartRestartGroup.skipToGroupEnd();
                companion = modifier2;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier3 = companion;
                final long j5 = linearColor;
                final long j6 = linearTrackColor;
                final int i11 = i5;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i12) {
                        ProgressIndicatorKt.m2676LinearProgressIndicator2cYBFYY(modifier3, j5, j6, i11, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                    }
                });
            }
        }
        i4 |= 3072;
        i5 = i;
        if ((i4 & 1171) == 1170) {
            composerStartRestartGroup.startDefaults();
            if ((i2 & 1) == 0) {
                if (i8 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i3 & 2) != 0) {
                    linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                    i4 &= -113;
                }
                if ((i3 & 4) != 0) {
                    linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                    i4 &= -897;
                }
                if (i10 != 0) {
                    iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                } else {
                    iM2668getLinearStrokeCapKaPHkGw = i5;
                }
            } else {
                if (i8 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i3 & 2) != 0) {
                    linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                    i4 &= -113;
                }
                if ((i3 & 4) != 0) {
                    linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                    i4 &= -897;
                }
                if (i10 != 0) {
                    iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                } else {
                    iM2668getLinearStrokeCapKaPHkGw = i5;
                }
            }
            long j7 = linearTrackColor;
            i6 = i4;
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-476865359, i6, -1, "androidx.compose.material3.LinearProgressIndicator (ProgressIndicator.kt:217)");
            }
            m2682LinearProgressIndicatorrIrjwxo(companion, linearColor, j7, iM2668getLinearStrokeCapKaPHkGw, ProgressIndicatorDefaults.INSTANCE.m2667getLinearIndicatorTrackGapSizeD9Ej5fM(), composerStartRestartGroup, (i6 & 14) | 24576 | (i6 & 112) | (i6 & 896) | (i6 & 7168), 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            linearTrackColor = j7;
            i5 = iM2668getLinearStrokeCapKaPHkGw;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i2 & 1) == 0) {
                if (i8 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i3 & 2) != 0) {
                    linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                    i4 &= -113;
                }
                if ((i3 & 4) != 0) {
                    linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                    i4 &= -897;
                }
                if (i10 != 0) {
                    iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                } else {
                    iM2668getLinearStrokeCapKaPHkGw = i5;
                }
            } else {
                if (i8 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i3 & 2) != 0) {
                    linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                    i4 &= -113;
                }
                if ((i3 & 4) != 0) {
                    linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                    i4 &= -897;
                }
                if (i10 != 0) {
                    iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                } else {
                    iM2668getLinearStrokeCapKaPHkGw = i5;
                }
            }
            long j8 = linearTrackColor;
            i6 = i4;
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-476865359, i6, -1, "androidx.compose.material3.LinearProgressIndicator (ProgressIndicator.kt:217)");
            }
            m2682LinearProgressIndicatorrIrjwxo(companion, linearColor, j8, iM2668getLinearStrokeCapKaPHkGw, ProgressIndicatorDefaults.INSTANCE.m2667getLinearIndicatorTrackGapSizeD9Ej5fM(), composerStartRestartGroup, (i6 & 14) | 24576 | (i6 & 112) | (i6 & 896) | (i6 & 7168), 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            linearTrackColor = j8;
            i5 = iM2668getLinearStrokeCapKaPHkGw;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier4 = companion;
            final long j9 = linearColor;
            final long j10 = linearTrackColor;
            final int i12 = i5;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i13) {
                    ProgressIndicatorKt.m2676LinearProgressIndicator2cYBFYY(modifier4, j9, j10, i12, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                }
            });
        }
    }

    public static final void m2682LinearProgressIndicatorrIrjwxo(Modifier modifier, long j, long j2, int i, float f, Composer composer, final int i2, final int i3) {
        Modifier modifier2;
        int i4;
        long linearColor;
        long linearTrackColor;
        int iM2668getLinearStrokeCapKaPHkGw;
        int i5;
        final float fM2667getLinearIndicatorTrackGapSizeD9Ej5fM;
        int i6;
        Modifier.Companion companion;
        final State<Float> stateAnimateFloat;
        final State<Float> stateAnimateFloat2;
        final State<Float> stateAnimateFloat3;
        final State<Float> stateAnimateFloat4;
        boolean z;
        boolean z2;
        boolean zChanged;
        Object objRememberedValue;
        final long j3;
        final int i7;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        Composer composerStartRestartGroup = composer.startRestartGroup(567589233);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(LinearProgressIndicator)P(2,0:c#ui.graphics.Color,4:c#ui.graphics.Color,3:c#ui.graphics.StrokeCap,1:c#ui.unit.Dp)249@11000L11,250@11063L16,254@11257L28,259@11547L396,272@11995L396,285@12444L400,298@12897L400,315@13472L1839,310@13302L2009:ProgressIndicator.kt#uh7d8r");
        int i8 = i3 & 1;
        if (i8 != 0) {
            i4 = i2 | 6;
            modifier2 = modifier;
        } else if ((i2 & 6) == 0) {
            modifier2 = modifier;
            i4 = (composerStartRestartGroup.changed(modifier2) ? 4 : 2) | i2;
        } else {
            modifier2 = modifier;
            i4 = i2;
        }
        if ((i2 & 48) == 0) {
            linearColor = j;
            i4 |= ((i3 & 2) == 0 && composerStartRestartGroup.changed(linearColor)) ? 32 : 16;
        } else {
            linearColor = j;
        }
        if ((i2 & 384) == 0) {
            linearTrackColor = j2;
            i4 |= ((i3 & 4) == 0 && composerStartRestartGroup.changed(linearTrackColor)) ? Fields.RotationX : Fields.SpotShadowColor;
        } else {
            linearTrackColor = j2;
        }
        int i9 = i3 & 8;
        if (i9 == 0) {
            if ((i2 & 3072) == 0) {
                iM2668getLinearStrokeCapKaPHkGw = i;
                i4 |= composerStartRestartGroup.changed(iM2668getLinearStrokeCapKaPHkGw) ? Fields.CameraDistance : Fields.RotationZ;
            }
            i5 = i3 & 16;
            if (i5 != 0) {
                if ((i2 & 24576) == 0) {
                    fM2667getLinearIndicatorTrackGapSizeD9Ej5fM = f;
                    if (composerStartRestartGroup.changed(fM2667getLinearIndicatorTrackGapSizeD9Ej5fM)) {
                        i6 = Fields.Clip;
                    } else {
                        i6 = Fields.Shape;
                    }
                    i4 |= i6;
                }
                if ((i4 & 9363) == 9362 || !composerStartRestartGroup.getSkipping()) {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                        if (i8 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 2) != 0) {
                            linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                            i4 &= -113;
                        }
                        if ((i3 & 4) != 0) {
                            linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                            i4 &= -897;
                        }
                        if (i9 != 0) {
                            iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                        }
                        if (i5 != 0) {
                            fM2667getLinearIndicatorTrackGapSizeD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2667getLinearIndicatorTrackGapSizeD9Ej5fM();
                        }
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        if ((i3 & 2) != 0) {
                            i4 &= -113;
                        }
                        if ((i3 & 4) != 0) {
                            i4 &= -897;
                        }
                        companion = modifier2;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(567589233, i4, -1, "androidx.compose.material3.LinearProgressIndicator (ProgressIndicator.kt:253)");
                    }
                    InfiniteTransition infiniteTransitionRememberInfiniteTransition = InfiniteTransitionKt.rememberInfiniteTransition(null, composerStartRestartGroup, 0, 1);
                    stateAnimateFloat = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition, 0.0f, 1.0f, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                        public Object invoke(Object obj) {
                            invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                            keyframesSpecConfig.setDurationMillis(1800);
                            keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 0), ProgressIndicatorKt.FirstLineHeadEasing);
                            keyframesSpecConfig.mo80at(Float.valueOf(1.0f), 750);
                        }
                    }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
                    stateAnimateFloat2 = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition, 0.0f, 1.0f, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                        public Object invoke(Object obj) {
                            invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                            keyframesSpecConfig.setDurationMillis(1800);
                            keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 333), ProgressIndicatorKt.FirstLineTailEasing);
                            keyframesSpecConfig.mo80at(Float.valueOf(1.0f), 1183);
                        }
                    }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
                    stateAnimateFloat3 = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition, 0.0f, 1.0f, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                        public Object invoke(Object obj) {
                            invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                            keyframesSpecConfig.setDurationMillis(1800);
                            keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 1000), ProgressIndicatorKt.SecondLineHeadEasing);
                            keyframesSpecConfig.mo80at(Float.valueOf(1.0f), 1567);
                        }
                    }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
                    stateAnimateFloat4 = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition, 0.0f, 1.0f, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                        public Object invoke(Object obj) {
                            invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                            keyframesSpecConfig.setDurationMillis(1800);
                            keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 1267), ProgressIndicatorKt.SecondLineTailEasing);
                            keyframesSpecConfig.mo80at(Float.valueOf(1.0f), 1800);
                        }
                    }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
                    Modifier modifier3 = companion;
                    Modifier modifierM1082sizeVpY3zN4 = SizeKt.m1082sizeVpY3zN4(ProgressSemanticsKt.progressSemantics(companion.then(IncreaseSemanticsBounds)), LinearIndicatorWidth, LinearIndicatorHeight);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1145216297, "CC(remember):ProgressIndicator.kt#9igjgp");
                    if ((i4 & 7168) == 2048) {
                        z = true;
                    } else {
                        z = false;
                    }
                    if ((57344 & i4) == 16384) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    zChanged = z | z2 | composerStartRestartGroup.changed(stateAnimateFloat) | ((((i4 & 896) ^ 384) <= 256 && composerStartRestartGroup.changed(linearTrackColor)) || (i4 & 384) == 256) | composerStartRestartGroup.changed(stateAnimateFloat2) | ((((i4 & 112) ^ 48) <= 32 && composerStartRestartGroup.changed(linearColor)) || (i4 & 48) == 32) | composerStartRestartGroup.changed(stateAnimateFloat3) | composerStartRestartGroup.changed(stateAnimateFloat4);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        final int i10 = iM2668getLinearStrokeCapKaPHkGw;
                        final float f2 = fM2667getLinearIndicatorTrackGapSizeD9Ej5fM;
                        final long j4 = linearTrackColor;
                        final long j5 = linearColor;
                        objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                float f3;
                                float fM4412getHeightimpl = Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc());
                                if (StrokeCap.m4959equalsimpl0(i10, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc()) > Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc())) {
                                    f3 = f2;
                                } else {
                                    f3 = Dp.constructor-impl(f2 + drawScope.toDp-u2uoSUM(fM4412getHeightimpl));
                                }
                                float f4 = f3 / drawScope.toDp-u2uoSUM(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()));
                                if (stateAnimateFloat.getValue().floatValue() < 1.0f - f4) {
                                    ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat.getValue().floatValue() > 0.0f ? stateAnimateFloat.getValue().floatValue() + f4 : 0.0f, 1.0f, j4, fM4412getHeightimpl, i10);
                                }
                                if (stateAnimateFloat.getValue().floatValue() - stateAnimateFloat2.getValue().floatValue() > 0.0f) {
                                    ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat.getValue().floatValue(), stateAnimateFloat2.getValue().floatValue(), j5, fM4412getHeightimpl, i10);
                                }
                                if (stateAnimateFloat2.getValue().floatValue() > f4) {
                                    ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat3.getValue().floatValue() > 0.0f ? stateAnimateFloat3.getValue().floatValue() + f4 : 0.0f, stateAnimateFloat2.getValue().floatValue() < 1.0f ? stateAnimateFloat2.getValue().floatValue() - f4 : 1.0f, j4, fM4412getHeightimpl, i10);
                                }
                                if (stateAnimateFloat3.getValue().floatValue() - stateAnimateFloat4.getValue().floatValue() > 0.0f) {
                                    ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat3.getValue().floatValue(), stateAnimateFloat4.getValue().floatValue(), j5, fM4412getHeightimpl, i10);
                                }
                                if (stateAnimateFloat4.getValue().floatValue() > f4) {
                                    ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, 0.0f, stateAnimateFloat4.getValue().floatValue() < 1.0f ? stateAnimateFloat4.getValue().floatValue() - f4 : 1.0f, j4, fM4412getHeightimpl, i10);
                                }
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CanvasKt.Canvas(modifierM1082sizeVpY3zN4, (Function1) objRememberedValue, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = modifier3;
                } else {
                    composerStartRestartGroup.skipToGroupEnd();
                }
                j3 = linearTrackColor;
                i7 = iM2668getLinearStrokeCapKaPHkGw;
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier4 = modifier2;
                    final long j6 = linearColor;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11) {
                            ProgressIndicatorKt.m2682LinearProgressIndicatorrIrjwxo(modifier4, j6, j3, i7, fM2667getLinearIndicatorTrackGapSizeD9Ej5fM, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                        }
                    });
                }
            }
            i4 |= 24576;
            fM2667getLinearIndicatorTrackGapSizeD9Ej5fM = f;
            if ((i4 & 9363) == 9362) {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) != 0) {
                    if (i8 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 2) != 0) {
                        linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                        i4 &= -113;
                    }
                    if ((i3 & 4) != 0) {
                        linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i9 != 0) {
                        iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                    }
                    if (i5 != 0) {
                        fM2667getLinearIndicatorTrackGapSizeD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2667getLinearIndicatorTrackGapSizeD9Ej5fM();
                    }
                } else {
                    if (i8 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 2) != 0) {
                        linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                        i4 &= -113;
                    }
                    if ((i3 & 4) != 0) {
                        linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i9 != 0) {
                        iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                    }
                    if (i5 != 0) {
                        fM2667getLinearIndicatorTrackGapSizeD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2667getLinearIndicatorTrackGapSizeD9Ej5fM();
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(567589233, i4, -1, "androidx.compose.material3.LinearProgressIndicator (ProgressIndicator.kt:253)");
                }
                InfiniteTransition infiniteTransitionRememberInfiniteTransition2 = InfiniteTransitionKt.rememberInfiniteTransition(null, composerStartRestartGroup, 0, 1);
                stateAnimateFloat = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition2, 0.0f, 1.0f, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                    public Object invoke(Object obj) {
                        invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                        keyframesSpecConfig.setDurationMillis(1800);
                        keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 0), ProgressIndicatorKt.FirstLineHeadEasing);
                        keyframesSpecConfig.mo80at(Float.valueOf(1.0f), 750);
                    }
                }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
                stateAnimateFloat2 = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition2, 0.0f, 1.0f, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                    public Object invoke(Object obj) {
                        invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                        keyframesSpecConfig.setDurationMillis(1800);
                        keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 333), ProgressIndicatorKt.FirstLineTailEasing);
                        keyframesSpecConfig.mo80at(Float.valueOf(1.0f), 1183);
                    }
                }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
                stateAnimateFloat3 = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition2, 0.0f, 1.0f, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                    public Object invoke(Object obj) {
                        invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                        keyframesSpecConfig.setDurationMillis(1800);
                        keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 1000), ProgressIndicatorKt.SecondLineHeadEasing);
                        keyframesSpecConfig.mo80at(Float.valueOf(1.0f), 1567);
                    }
                }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
                stateAnimateFloat4 = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition2, 0.0f, 1.0f, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                    public Object invoke(Object obj) {
                        invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                        keyframesSpecConfig.setDurationMillis(1800);
                        keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 1267), ProgressIndicatorKt.SecondLineTailEasing);
                        keyframesSpecConfig.mo80at(Float.valueOf(1.0f), 1800);
                    }
                }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
                Modifier modifier5 = companion;
                Modifier modifierM1082sizeVpY3zN5 = SizeKt.m1082sizeVpY3zN4(ProgressSemanticsKt.progressSemantics(companion.then(IncreaseSemanticsBounds)), LinearIndicatorWidth, LinearIndicatorHeight);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1145216297, "CC(remember):ProgressIndicator.kt#9igjgp");
                if ((i4 & 7168) == 2048) {
                    z = true;
                } else {
                    z = false;
                }
                if ((57344 & i4) == 16384) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                zChanged = z | z2 | composerStartRestartGroup.changed(stateAnimateFloat) | ((((i4 & 896) ^ 384) <= 256 && composerStartRestartGroup.changed(linearTrackColor)) || (i4 & 384) == 256) | composerStartRestartGroup.changed(stateAnimateFloat2) | ((((i4 & 112) ^ 48) <= 32 && composerStartRestartGroup.changed(linearColor)) || (i4 & 48) == 32) | composerStartRestartGroup.changed(stateAnimateFloat3) | composerStartRestartGroup.changed(stateAnimateFloat4);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    final int i11 = iM2668getLinearStrokeCapKaPHkGw;
                    final float f3 = fM2667getLinearIndicatorTrackGapSizeD9Ej5fM;
                    final long j7 = linearTrackColor;
                    final long j8 = linearColor;
                    objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            float f4;
                            float fM4412getHeightimpl = Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc());
                            if (StrokeCap.m4959equalsimpl0(i11, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc()) > Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc())) {
                                f4 = f3;
                            } else {
                                f4 = Dp.constructor-impl(f3 + drawScope.toDp-u2uoSUM(fM4412getHeightimpl));
                            }
                            float f5 = f4 / drawScope.toDp-u2uoSUM(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()));
                            if (stateAnimateFloat.getValue().floatValue() < 1.0f - f5) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat.getValue().floatValue() > 0.0f ? stateAnimateFloat.getValue().floatValue() + f5 : 0.0f, 1.0f, j7, fM4412getHeightimpl, i11);
                            }
                            if (stateAnimateFloat.getValue().floatValue() - stateAnimateFloat2.getValue().floatValue() > 0.0f) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat.getValue().floatValue(), stateAnimateFloat2.getValue().floatValue(), j8, fM4412getHeightimpl, i11);
                            }
                            if (stateAnimateFloat2.getValue().floatValue() > f5) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat3.getValue().floatValue() > 0.0f ? stateAnimateFloat3.getValue().floatValue() + f5 : 0.0f, stateAnimateFloat2.getValue().floatValue() < 1.0f ? stateAnimateFloat2.getValue().floatValue() - f5 : 1.0f, j7, fM4412getHeightimpl, i11);
                            }
                            if (stateAnimateFloat3.getValue().floatValue() - stateAnimateFloat4.getValue().floatValue() > 0.0f) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat3.getValue().floatValue(), stateAnimateFloat4.getValue().floatValue(), j8, fM4412getHeightimpl, i11);
                            }
                            if (stateAnimateFloat4.getValue().floatValue() > f5) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, 0.0f, stateAnimateFloat4.getValue().floatValue() < 1.0f ? stateAnimateFloat4.getValue().floatValue() - f5 : 1.0f, j7, fM4412getHeightimpl, i11);
                            }
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    final int i12 = iM2668getLinearStrokeCapKaPHkGw;
                    final float f4 = fM2667getLinearIndicatorTrackGapSizeD9Ej5fM;
                    final long j9 = linearTrackColor;
                    final long j10 = linearColor;
                    objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            float f5;
                            float fM4412getHeightimpl = Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc());
                            if (StrokeCap.m4959equalsimpl0(i12, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc()) > Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc())) {
                                f5 = f4;
                            } else {
                                f5 = Dp.constructor-impl(f4 + drawScope.toDp-u2uoSUM(fM4412getHeightimpl));
                            }
                            float f6 = f5 / drawScope.toDp-u2uoSUM(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()));
                            if (stateAnimateFloat.getValue().floatValue() < 1.0f - f6) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat.getValue().floatValue() > 0.0f ? stateAnimateFloat.getValue().floatValue() + f6 : 0.0f, 1.0f, j9, fM4412getHeightimpl, i12);
                            }
                            if (stateAnimateFloat.getValue().floatValue() - stateAnimateFloat2.getValue().floatValue() > 0.0f) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat.getValue().floatValue(), stateAnimateFloat2.getValue().floatValue(), j10, fM4412getHeightimpl, i12);
                            }
                            if (stateAnimateFloat2.getValue().floatValue() > f6) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat3.getValue().floatValue() > 0.0f ? stateAnimateFloat3.getValue().floatValue() + f6 : 0.0f, stateAnimateFloat2.getValue().floatValue() < 1.0f ? stateAnimateFloat2.getValue().floatValue() - f6 : 1.0f, j9, fM4412getHeightimpl, i12);
                            }
                            if (stateAnimateFloat3.getValue().floatValue() - stateAnimateFloat4.getValue().floatValue() > 0.0f) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat3.getValue().floatValue(), stateAnimateFloat4.getValue().floatValue(), j10, fM4412getHeightimpl, i12);
                            }
                            if (stateAnimateFloat4.getValue().floatValue() > f6) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, 0.0f, stateAnimateFloat4.getValue().floatValue() < 1.0f ? stateAnimateFloat4.getValue().floatValue() - f6 : 1.0f, j9, fM4412getHeightimpl, i12);
                            }
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CanvasKt.Canvas(modifierM1082sizeVpY3zN5, (Function1) objRememberedValue, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = modifier5;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) != 0) {
                    if (i8 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 2) != 0) {
                        linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                        i4 &= -113;
                    }
                    if ((i3 & 4) != 0) {
                        linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i9 != 0) {
                        iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                    }
                    if (i5 != 0) {
                        fM2667getLinearIndicatorTrackGapSizeD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2667getLinearIndicatorTrackGapSizeD9Ej5fM();
                    }
                } else {
                    if (i8 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 2) != 0) {
                        linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                        i4 &= -113;
                    }
                    if ((i3 & 4) != 0) {
                        linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i9 != 0) {
                        iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                    }
                    if (i5 != 0) {
                        fM2667getLinearIndicatorTrackGapSizeD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2667getLinearIndicatorTrackGapSizeD9Ej5fM();
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(567589233, i4, -1, "androidx.compose.material3.LinearProgressIndicator (ProgressIndicator.kt:253)");
                }
                InfiniteTransition infiniteTransitionRememberInfiniteTransition3 = InfiniteTransitionKt.rememberInfiniteTransition(null, composerStartRestartGroup, 0, 1);
                stateAnimateFloat = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition3, 0.0f, 1.0f, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                    public Object invoke(Object obj) {
                        invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                        keyframesSpecConfig.setDurationMillis(1800);
                        keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 0), ProgressIndicatorKt.FirstLineHeadEasing);
                        keyframesSpecConfig.mo80at(Float.valueOf(1.0f), 750);
                    }
                }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
                stateAnimateFloat2 = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition3, 0.0f, 1.0f, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                    public Object invoke(Object obj) {
                        invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                        keyframesSpecConfig.setDurationMillis(1800);
                        keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 333), ProgressIndicatorKt.FirstLineTailEasing);
                        keyframesSpecConfig.mo80at(Float.valueOf(1.0f), 1183);
                    }
                }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
                stateAnimateFloat3 = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition3, 0.0f, 1.0f, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                    public Object invoke(Object obj) {
                        invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                        keyframesSpecConfig.setDurationMillis(1800);
                        keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 1000), ProgressIndicatorKt.SecondLineHeadEasing);
                        keyframesSpecConfig.mo80at(Float.valueOf(1.0f), 1567);
                    }
                }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
                stateAnimateFloat4 = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition3, 0.0f, 1.0f, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                    public Object invoke(Object obj) {
                        invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                        keyframesSpecConfig.setDurationMillis(1800);
                        keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 1267), ProgressIndicatorKt.SecondLineTailEasing);
                        keyframesSpecConfig.mo80at(Float.valueOf(1.0f), 1800);
                    }
                }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
                Modifier modifier6 = companion;
                Modifier modifierM1082sizeVpY3zN6 = SizeKt.m1082sizeVpY3zN4(ProgressSemanticsKt.progressSemantics(companion.then(IncreaseSemanticsBounds)), LinearIndicatorWidth, LinearIndicatorHeight);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1145216297, "CC(remember):ProgressIndicator.kt#9igjgp");
                if ((i4 & 7168) == 2048) {
                    z = true;
                } else {
                    z = false;
                }
                if ((57344 & i4) == 16384) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                zChanged = z | z2 | composerStartRestartGroup.changed(stateAnimateFloat) | ((((i4 & 896) ^ 384) <= 256 && composerStartRestartGroup.changed(linearTrackColor)) || (i4 & 384) == 256) | composerStartRestartGroup.changed(stateAnimateFloat2) | ((((i4 & 112) ^ 48) <= 32 && composerStartRestartGroup.changed(linearColor)) || (i4 & 48) == 32) | composerStartRestartGroup.changed(stateAnimateFloat3) | composerStartRestartGroup.changed(stateAnimateFloat4);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    final int i13 = iM2668getLinearStrokeCapKaPHkGw;
                    final float f5 = fM2667getLinearIndicatorTrackGapSizeD9Ej5fM;
                    final long j11 = linearTrackColor;
                    final long j12 = linearColor;
                    objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            float f6;
                            float fM4412getHeightimpl = Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc());
                            if (StrokeCap.m4959equalsimpl0(i13, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc()) > Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc())) {
                                f6 = f5;
                            } else {
                                f6 = Dp.constructor-impl(f5 + drawScope.toDp-u2uoSUM(fM4412getHeightimpl));
                            }
                            float f7 = f6 / drawScope.toDp-u2uoSUM(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()));
                            if (stateAnimateFloat.getValue().floatValue() < 1.0f - f7) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat.getValue().floatValue() > 0.0f ? stateAnimateFloat.getValue().floatValue() + f7 : 0.0f, 1.0f, j11, fM4412getHeightimpl, i13);
                            }
                            if (stateAnimateFloat.getValue().floatValue() - stateAnimateFloat2.getValue().floatValue() > 0.0f) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat.getValue().floatValue(), stateAnimateFloat2.getValue().floatValue(), j12, fM4412getHeightimpl, i13);
                            }
                            if (stateAnimateFloat2.getValue().floatValue() > f7) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat3.getValue().floatValue() > 0.0f ? stateAnimateFloat3.getValue().floatValue() + f7 : 0.0f, stateAnimateFloat2.getValue().floatValue() < 1.0f ? stateAnimateFloat2.getValue().floatValue() - f7 : 1.0f, j11, fM4412getHeightimpl, i13);
                            }
                            if (stateAnimateFloat3.getValue().floatValue() - stateAnimateFloat4.getValue().floatValue() > 0.0f) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat3.getValue().floatValue(), stateAnimateFloat4.getValue().floatValue(), j12, fM4412getHeightimpl, i13);
                            }
                            if (stateAnimateFloat4.getValue().floatValue() > f7) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, 0.0f, stateAnimateFloat4.getValue().floatValue() < 1.0f ? stateAnimateFloat4.getValue().floatValue() - f7 : 1.0f, j11, fM4412getHeightimpl, i13);
                            }
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    final int i14 = iM2668getLinearStrokeCapKaPHkGw;
                    final float f6 = fM2667getLinearIndicatorTrackGapSizeD9Ej5fM;
                    final long j13 = linearTrackColor;
                    final long j14 = linearColor;
                    objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            float f7;
                            float fM4412getHeightimpl = Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc());
                            if (StrokeCap.m4959equalsimpl0(i14, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc()) > Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc())) {
                                f7 = f6;
                            } else {
                                f7 = Dp.constructor-impl(f6 + drawScope.toDp-u2uoSUM(fM4412getHeightimpl));
                            }
                            float f8 = f7 / drawScope.toDp-u2uoSUM(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()));
                            if (stateAnimateFloat.getValue().floatValue() < 1.0f - f8) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat.getValue().floatValue() > 0.0f ? stateAnimateFloat.getValue().floatValue() + f8 : 0.0f, 1.0f, j13, fM4412getHeightimpl, i14);
                            }
                            if (stateAnimateFloat.getValue().floatValue() - stateAnimateFloat2.getValue().floatValue() > 0.0f) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat.getValue().floatValue(), stateAnimateFloat2.getValue().floatValue(), j14, fM4412getHeightimpl, i14);
                            }
                            if (stateAnimateFloat2.getValue().floatValue() > f8) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat3.getValue().floatValue() > 0.0f ? stateAnimateFloat3.getValue().floatValue() + f8 : 0.0f, stateAnimateFloat2.getValue().floatValue() < 1.0f ? stateAnimateFloat2.getValue().floatValue() - f8 : 1.0f, j13, fM4412getHeightimpl, i14);
                            }
                            if (stateAnimateFloat3.getValue().floatValue() - stateAnimateFloat4.getValue().floatValue() > 0.0f) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat3.getValue().floatValue(), stateAnimateFloat4.getValue().floatValue(), j14, fM4412getHeightimpl, i14);
                            }
                            if (stateAnimateFloat4.getValue().floatValue() > f8) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, 0.0f, stateAnimateFloat4.getValue().floatValue() < 1.0f ? stateAnimateFloat4.getValue().floatValue() - f8 : 1.0f, j13, fM4412getHeightimpl, i14);
                            }
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CanvasKt.Canvas(modifierM1082sizeVpY3zN6, (Function1) objRememberedValue, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = modifier6;
            }
            j3 = linearTrackColor;
            i7 = iM2668getLinearStrokeCapKaPHkGw;
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier7 = modifier2;
                final long j15 = linearColor;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i15) {
                        ProgressIndicatorKt.m2682LinearProgressIndicatorrIrjwxo(modifier7, j15, j3, i7, fM2667getLinearIndicatorTrackGapSizeD9Ej5fM, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                    }
                });
            }
        }
        i4 |= 3072;
        iM2668getLinearStrokeCapKaPHkGw = i;
        i5 = i3 & 16;
        if (i5 != 0) {
            if ((i2 & 24576) == 0) {
                fM2667getLinearIndicatorTrackGapSizeD9Ej5fM = f;
                if (composerStartRestartGroup.changed(fM2667getLinearIndicatorTrackGapSizeD9Ej5fM)) {
                    i6 = Fields.Clip;
                } else {
                    i6 = Fields.Shape;
                }
                i4 |= i6;
            }
            if ((i4 & 9363) == 9362) {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) != 0) {
                    if (i8 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 2) != 0) {
                        linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                        i4 &= -113;
                    }
                    if ((i3 & 4) != 0) {
                        linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i9 != 0) {
                        iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                    }
                    if (i5 != 0) {
                        fM2667getLinearIndicatorTrackGapSizeD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2667getLinearIndicatorTrackGapSizeD9Ej5fM();
                    }
                } else {
                    if (i8 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 2) != 0) {
                        linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                        i4 &= -113;
                    }
                    if ((i3 & 4) != 0) {
                        linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i9 != 0) {
                        iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                    }
                    if (i5 != 0) {
                        fM2667getLinearIndicatorTrackGapSizeD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2667getLinearIndicatorTrackGapSizeD9Ej5fM();
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(567589233, i4, -1, "androidx.compose.material3.LinearProgressIndicator (ProgressIndicator.kt:253)");
                }
                InfiniteTransition infiniteTransitionRememberInfiniteTransition4 = InfiniteTransitionKt.rememberInfiniteTransition(null, composerStartRestartGroup, 0, 1);
                stateAnimateFloat = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition4, 0.0f, 1.0f, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                    public Object invoke(Object obj) {
                        invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                        keyframesSpecConfig.setDurationMillis(1800);
                        keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 0), ProgressIndicatorKt.FirstLineHeadEasing);
                        keyframesSpecConfig.mo80at(Float.valueOf(1.0f), 750);
                    }
                }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
                stateAnimateFloat2 = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition4, 0.0f, 1.0f, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                    public Object invoke(Object obj) {
                        invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                        keyframesSpecConfig.setDurationMillis(1800);
                        keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 333), ProgressIndicatorKt.FirstLineTailEasing);
                        keyframesSpecConfig.mo80at(Float.valueOf(1.0f), 1183);
                    }
                }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
                stateAnimateFloat3 = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition4, 0.0f, 1.0f, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                    public Object invoke(Object obj) {
                        invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                        keyframesSpecConfig.setDurationMillis(1800);
                        keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 1000), ProgressIndicatorKt.SecondLineHeadEasing);
                        keyframesSpecConfig.mo80at(Float.valueOf(1.0f), 1567);
                    }
                }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
                stateAnimateFloat4 = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition4, 0.0f, 1.0f, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                    public Object invoke(Object obj) {
                        invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                        keyframesSpecConfig.setDurationMillis(1800);
                        keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 1267), ProgressIndicatorKt.SecondLineTailEasing);
                        keyframesSpecConfig.mo80at(Float.valueOf(1.0f), 1800);
                    }
                }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
                Modifier modifier8 = companion;
                Modifier modifierM1082sizeVpY3zN7 = SizeKt.m1082sizeVpY3zN4(ProgressSemanticsKt.progressSemantics(companion.then(IncreaseSemanticsBounds)), LinearIndicatorWidth, LinearIndicatorHeight);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1145216297, "CC(remember):ProgressIndicator.kt#9igjgp");
                if ((i4 & 7168) == 2048) {
                    z = true;
                } else {
                    z = false;
                }
                if ((57344 & i4) == 16384) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                zChanged = z | z2 | composerStartRestartGroup.changed(stateAnimateFloat) | ((((i4 & 896) ^ 384) <= 256 && composerStartRestartGroup.changed(linearTrackColor)) || (i4 & 384) == 256) | composerStartRestartGroup.changed(stateAnimateFloat2) | ((((i4 & 112) ^ 48) <= 32 && composerStartRestartGroup.changed(linearColor)) || (i4 & 48) == 32) | composerStartRestartGroup.changed(stateAnimateFloat3) | composerStartRestartGroup.changed(stateAnimateFloat4);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    final int i15 = iM2668getLinearStrokeCapKaPHkGw;
                    final float f7 = fM2667getLinearIndicatorTrackGapSizeD9Ej5fM;
                    final long j16 = linearTrackColor;
                    final long j17 = linearColor;
                    objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            float f8;
                            float fM4412getHeightimpl = Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc());
                            if (StrokeCap.m4959equalsimpl0(i15, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc()) > Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc())) {
                                f8 = f7;
                            } else {
                                f8 = Dp.constructor-impl(f7 + drawScope.toDp-u2uoSUM(fM4412getHeightimpl));
                            }
                            float f9 = f8 / drawScope.toDp-u2uoSUM(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()));
                            if (stateAnimateFloat.getValue().floatValue() < 1.0f - f9) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat.getValue().floatValue() > 0.0f ? stateAnimateFloat.getValue().floatValue() + f9 : 0.0f, 1.0f, j16, fM4412getHeightimpl, i15);
                            }
                            if (stateAnimateFloat.getValue().floatValue() - stateAnimateFloat2.getValue().floatValue() > 0.0f) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat.getValue().floatValue(), stateAnimateFloat2.getValue().floatValue(), j17, fM4412getHeightimpl, i15);
                            }
                            if (stateAnimateFloat2.getValue().floatValue() > f9) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat3.getValue().floatValue() > 0.0f ? stateAnimateFloat3.getValue().floatValue() + f9 : 0.0f, stateAnimateFloat2.getValue().floatValue() < 1.0f ? stateAnimateFloat2.getValue().floatValue() - f9 : 1.0f, j16, fM4412getHeightimpl, i15);
                            }
                            if (stateAnimateFloat3.getValue().floatValue() - stateAnimateFloat4.getValue().floatValue() > 0.0f) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat3.getValue().floatValue(), stateAnimateFloat4.getValue().floatValue(), j17, fM4412getHeightimpl, i15);
                            }
                            if (stateAnimateFloat4.getValue().floatValue() > f9) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, 0.0f, stateAnimateFloat4.getValue().floatValue() < 1.0f ? stateAnimateFloat4.getValue().floatValue() - f9 : 1.0f, j16, fM4412getHeightimpl, i15);
                            }
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    final int i16 = iM2668getLinearStrokeCapKaPHkGw;
                    final float f8 = fM2667getLinearIndicatorTrackGapSizeD9Ej5fM;
                    final long j18 = linearTrackColor;
                    final long j19 = linearColor;
                    objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            float f9;
                            float fM4412getHeightimpl = Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc());
                            if (StrokeCap.m4959equalsimpl0(i16, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc()) > Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc())) {
                                f9 = f8;
                            } else {
                                f9 = Dp.constructor-impl(f8 + drawScope.toDp-u2uoSUM(fM4412getHeightimpl));
                            }
                            float f10 = f9 / drawScope.toDp-u2uoSUM(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()));
                            if (stateAnimateFloat.getValue().floatValue() < 1.0f - f10) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat.getValue().floatValue() > 0.0f ? stateAnimateFloat.getValue().floatValue() + f10 : 0.0f, 1.0f, j18, fM4412getHeightimpl, i16);
                            }
                            if (stateAnimateFloat.getValue().floatValue() - stateAnimateFloat2.getValue().floatValue() > 0.0f) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat.getValue().floatValue(), stateAnimateFloat2.getValue().floatValue(), j19, fM4412getHeightimpl, i16);
                            }
                            if (stateAnimateFloat2.getValue().floatValue() > f10) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat3.getValue().floatValue() > 0.0f ? stateAnimateFloat3.getValue().floatValue() + f10 : 0.0f, stateAnimateFloat2.getValue().floatValue() < 1.0f ? stateAnimateFloat2.getValue().floatValue() - f10 : 1.0f, j18, fM4412getHeightimpl, i16);
                            }
                            if (stateAnimateFloat3.getValue().floatValue() - stateAnimateFloat4.getValue().floatValue() > 0.0f) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat3.getValue().floatValue(), stateAnimateFloat4.getValue().floatValue(), j19, fM4412getHeightimpl, i16);
                            }
                            if (stateAnimateFloat4.getValue().floatValue() > f10) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, 0.0f, stateAnimateFloat4.getValue().floatValue() < 1.0f ? stateAnimateFloat4.getValue().floatValue() - f10 : 1.0f, j18, fM4412getHeightimpl, i16);
                            }
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CanvasKt.Canvas(modifierM1082sizeVpY3zN7, (Function1) objRememberedValue, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = modifier8;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) != 0) {
                    if (i8 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 2) != 0) {
                        linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                        i4 &= -113;
                    }
                    if ((i3 & 4) != 0) {
                        linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i9 != 0) {
                        iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                    }
                    if (i5 != 0) {
                        fM2667getLinearIndicatorTrackGapSizeD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2667getLinearIndicatorTrackGapSizeD9Ej5fM();
                    }
                } else {
                    if (i8 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 2) != 0) {
                        linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                        i4 &= -113;
                    }
                    if ((i3 & 4) != 0) {
                        linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i9 != 0) {
                        iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                    }
                    if (i5 != 0) {
                        fM2667getLinearIndicatorTrackGapSizeD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2667getLinearIndicatorTrackGapSizeD9Ej5fM();
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(567589233, i4, -1, "androidx.compose.material3.LinearProgressIndicator (ProgressIndicator.kt:253)");
                }
                InfiniteTransition infiniteTransitionRememberInfiniteTransition5 = InfiniteTransitionKt.rememberInfiniteTransition(null, composerStartRestartGroup, 0, 1);
                stateAnimateFloat = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition5, 0.0f, 1.0f, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                    public Object invoke(Object obj) {
                        invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                        keyframesSpecConfig.setDurationMillis(1800);
                        keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 0), ProgressIndicatorKt.FirstLineHeadEasing);
                        keyframesSpecConfig.mo80at(Float.valueOf(1.0f), 750);
                    }
                }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
                stateAnimateFloat2 = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition5, 0.0f, 1.0f, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                    public Object invoke(Object obj) {
                        invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                        keyframesSpecConfig.setDurationMillis(1800);
                        keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 333), ProgressIndicatorKt.FirstLineTailEasing);
                        keyframesSpecConfig.mo80at(Float.valueOf(1.0f), 1183);
                    }
                }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
                stateAnimateFloat3 = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition5, 0.0f, 1.0f, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                    public Object invoke(Object obj) {
                        invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                        keyframesSpecConfig.setDurationMillis(1800);
                        keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 1000), ProgressIndicatorKt.SecondLineHeadEasing);
                        keyframesSpecConfig.mo80at(Float.valueOf(1.0f), 1567);
                    }
                }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
                stateAnimateFloat4 = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition5, 0.0f, 1.0f, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                    public Object invoke(Object obj) {
                        invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                        keyframesSpecConfig.setDurationMillis(1800);
                        keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 1267), ProgressIndicatorKt.SecondLineTailEasing);
                        keyframesSpecConfig.mo80at(Float.valueOf(1.0f), 1800);
                    }
                }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
                Modifier modifier9 = companion;
                Modifier modifierM1082sizeVpY3zN8 = SizeKt.m1082sizeVpY3zN4(ProgressSemanticsKt.progressSemantics(companion.then(IncreaseSemanticsBounds)), LinearIndicatorWidth, LinearIndicatorHeight);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1145216297, "CC(remember):ProgressIndicator.kt#9igjgp");
                if ((i4 & 7168) == 2048) {
                    z = true;
                } else {
                    z = false;
                }
                if ((57344 & i4) == 16384) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                zChanged = z | z2 | composerStartRestartGroup.changed(stateAnimateFloat) | ((((i4 & 896) ^ 384) <= 256 && composerStartRestartGroup.changed(linearTrackColor)) || (i4 & 384) == 256) | composerStartRestartGroup.changed(stateAnimateFloat2) | ((((i4 & 112) ^ 48) <= 32 && composerStartRestartGroup.changed(linearColor)) || (i4 & 48) == 32) | composerStartRestartGroup.changed(stateAnimateFloat3) | composerStartRestartGroup.changed(stateAnimateFloat4);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    final int i17 = iM2668getLinearStrokeCapKaPHkGw;
                    final float f9 = fM2667getLinearIndicatorTrackGapSizeD9Ej5fM;
                    final long j110 = linearTrackColor;
                    final long j111 = linearColor;
                    objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            float f10;
                            float fM4412getHeightimpl = Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc());
                            if (StrokeCap.m4959equalsimpl0(i17, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc()) > Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc())) {
                                f10 = f9;
                            } else {
                                f10 = Dp.constructor-impl(f9 + drawScope.toDp-u2uoSUM(fM4412getHeightimpl));
                            }
                            float f11 = f10 / drawScope.toDp-u2uoSUM(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()));
                            if (stateAnimateFloat.getValue().floatValue() < 1.0f - f11) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat.getValue().floatValue() > 0.0f ? stateAnimateFloat.getValue().floatValue() + f11 : 0.0f, 1.0f, j110, fM4412getHeightimpl, i17);
                            }
                            if (stateAnimateFloat.getValue().floatValue() - stateAnimateFloat2.getValue().floatValue() > 0.0f) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat.getValue().floatValue(), stateAnimateFloat2.getValue().floatValue(), j111, fM4412getHeightimpl, i17);
                            }
                            if (stateAnimateFloat2.getValue().floatValue() > f11) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat3.getValue().floatValue() > 0.0f ? stateAnimateFloat3.getValue().floatValue() + f11 : 0.0f, stateAnimateFloat2.getValue().floatValue() < 1.0f ? stateAnimateFloat2.getValue().floatValue() - f11 : 1.0f, j110, fM4412getHeightimpl, i17);
                            }
                            if (stateAnimateFloat3.getValue().floatValue() - stateAnimateFloat4.getValue().floatValue() > 0.0f) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat3.getValue().floatValue(), stateAnimateFloat4.getValue().floatValue(), j111, fM4412getHeightimpl, i17);
                            }
                            if (stateAnimateFloat4.getValue().floatValue() > f11) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, 0.0f, stateAnimateFloat4.getValue().floatValue() < 1.0f ? stateAnimateFloat4.getValue().floatValue() - f11 : 1.0f, j110, fM4412getHeightimpl, i17);
                            }
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    final int i18 = iM2668getLinearStrokeCapKaPHkGw;
                    final float f10 = fM2667getLinearIndicatorTrackGapSizeD9Ej5fM;
                    final long j112 = linearTrackColor;
                    final long j113 = linearColor;
                    objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            float f11;
                            float fM4412getHeightimpl = Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc());
                            if (StrokeCap.m4959equalsimpl0(i18, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc()) > Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc())) {
                                f11 = f10;
                            } else {
                                f11 = Dp.constructor-impl(f10 + drawScope.toDp-u2uoSUM(fM4412getHeightimpl));
                            }
                            float f12 = f11 / drawScope.toDp-u2uoSUM(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()));
                            if (stateAnimateFloat.getValue().floatValue() < 1.0f - f12) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat.getValue().floatValue() > 0.0f ? stateAnimateFloat.getValue().floatValue() + f12 : 0.0f, 1.0f, j112, fM4412getHeightimpl, i18);
                            }
                            if (stateAnimateFloat.getValue().floatValue() - stateAnimateFloat2.getValue().floatValue() > 0.0f) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat.getValue().floatValue(), stateAnimateFloat2.getValue().floatValue(), j113, fM4412getHeightimpl, i18);
                            }
                            if (stateAnimateFloat2.getValue().floatValue() > f12) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat3.getValue().floatValue() > 0.0f ? stateAnimateFloat3.getValue().floatValue() + f12 : 0.0f, stateAnimateFloat2.getValue().floatValue() < 1.0f ? stateAnimateFloat2.getValue().floatValue() - f12 : 1.0f, j112, fM4412getHeightimpl, i18);
                            }
                            if (stateAnimateFloat3.getValue().floatValue() - stateAnimateFloat4.getValue().floatValue() > 0.0f) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat3.getValue().floatValue(), stateAnimateFloat4.getValue().floatValue(), j113, fM4412getHeightimpl, i18);
                            }
                            if (stateAnimateFloat4.getValue().floatValue() > f12) {
                                ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, 0.0f, stateAnimateFloat4.getValue().floatValue() < 1.0f ? stateAnimateFloat4.getValue().floatValue() - f12 : 1.0f, j112, fM4412getHeightimpl, i18);
                            }
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CanvasKt.Canvas(modifierM1082sizeVpY3zN8, (Function1) objRememberedValue, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = modifier9;
            }
            j3 = linearTrackColor;
            i7 = iM2668getLinearStrokeCapKaPHkGw;
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier10 = modifier2;
                final long j114 = linearColor;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i19) {
                        ProgressIndicatorKt.m2682LinearProgressIndicatorrIrjwxo(modifier10, j114, j3, i7, fM2667getLinearIndicatorTrackGapSizeD9Ej5fM, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                    }
                });
            }
        }
        i4 |= 24576;
        fM2667getLinearIndicatorTrackGapSizeD9Ej5fM = f;
        if ((i4 & 9363) == 9362) {
            composerStartRestartGroup.startDefaults();
            if ((i2 & 1) != 0) {
                if (i8 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i3 & 2) != 0) {
                    linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                    i4 &= -113;
                }
                if ((i3 & 4) != 0) {
                    linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                    i4 &= -897;
                }
                if (i9 != 0) {
                    iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                }
                if (i5 != 0) {
                    fM2667getLinearIndicatorTrackGapSizeD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2667getLinearIndicatorTrackGapSizeD9Ej5fM();
                }
            } else {
                if (i8 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i3 & 2) != 0) {
                    linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                    i4 &= -113;
                }
                if ((i3 & 4) != 0) {
                    linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                    i4 &= -897;
                }
                if (i9 != 0) {
                    iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                }
                if (i5 != 0) {
                    fM2667getLinearIndicatorTrackGapSizeD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2667getLinearIndicatorTrackGapSizeD9Ej5fM();
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(567589233, i4, -1, "androidx.compose.material3.LinearProgressIndicator (ProgressIndicator.kt:253)");
            }
            InfiniteTransition infiniteTransitionRememberInfiniteTransition6 = InfiniteTransitionKt.rememberInfiniteTransition(null, composerStartRestartGroup, 0, 1);
            stateAnimateFloat = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition6, 0.0f, 1.0f, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                public Object invoke(Object obj) {
                    invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                    return Unit.INSTANCE;
                }

                public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                    keyframesSpecConfig.setDurationMillis(1800);
                    keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 0), ProgressIndicatorKt.FirstLineHeadEasing);
                    keyframesSpecConfig.mo80at(Float.valueOf(1.0f), 750);
                }
            }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
            stateAnimateFloat2 = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition6, 0.0f, 1.0f, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                public Object invoke(Object obj) {
                    invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                    return Unit.INSTANCE;
                }

                public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                    keyframesSpecConfig.setDurationMillis(1800);
                    keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 333), ProgressIndicatorKt.FirstLineTailEasing);
                    keyframesSpecConfig.mo80at(Float.valueOf(1.0f), 1183);
                }
            }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
            stateAnimateFloat3 = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition6, 0.0f, 1.0f, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                public Object invoke(Object obj) {
                    invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                    return Unit.INSTANCE;
                }

                public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                    keyframesSpecConfig.setDurationMillis(1800);
                    keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 1000), ProgressIndicatorKt.SecondLineHeadEasing);
                    keyframesSpecConfig.mo80at(Float.valueOf(1.0f), 1567);
                }
            }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
            stateAnimateFloat4 = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition6, 0.0f, 1.0f, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                public Object invoke(Object obj) {
                    invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                    return Unit.INSTANCE;
                }

                public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                    keyframesSpecConfig.setDurationMillis(1800);
                    keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 1267), ProgressIndicatorKt.SecondLineTailEasing);
                    keyframesSpecConfig.mo80at(Float.valueOf(1.0f), 1800);
                }
            }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
            Modifier modifier11 = companion;
            Modifier modifierM1082sizeVpY3zN9 = SizeKt.m1082sizeVpY3zN4(ProgressSemanticsKt.progressSemantics(companion.then(IncreaseSemanticsBounds)), LinearIndicatorWidth, LinearIndicatorHeight);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1145216297, "CC(remember):ProgressIndicator.kt#9igjgp");
            if ((i4 & 7168) == 2048) {
                z = true;
            } else {
                z = false;
            }
            if ((57344 & i4) == 16384) {
                z2 = true;
            } else {
                z2 = false;
            }
            zChanged = z | z2 | composerStartRestartGroup.changed(stateAnimateFloat) | ((((i4 & 896) ^ 384) <= 256 && composerStartRestartGroup.changed(linearTrackColor)) || (i4 & 384) == 256) | composerStartRestartGroup.changed(stateAnimateFloat2) | ((((i4 & 112) ^ 48) <= 32 && composerStartRestartGroup.changed(linearColor)) || (i4 & 48) == 32) | composerStartRestartGroup.changed(stateAnimateFloat3) | composerStartRestartGroup.changed(stateAnimateFloat4);
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (!zChanged) {
                final int i19 = iM2668getLinearStrokeCapKaPHkGw;
                final float f11 = fM2667getLinearIndicatorTrackGapSizeD9Ej5fM;
                final long j115 = linearTrackColor;
                final long j116 = linearColor;
                objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((DrawScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(DrawScope drawScope) {
                        float f12;
                        float fM4412getHeightimpl = Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc());
                        if (StrokeCap.m4959equalsimpl0(i19, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc()) > Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc())) {
                            f12 = f11;
                        } else {
                            f12 = Dp.constructor-impl(f11 + drawScope.toDp-u2uoSUM(fM4412getHeightimpl));
                        }
                        float f13 = f12 / drawScope.toDp-u2uoSUM(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()));
                        if (stateAnimateFloat.getValue().floatValue() < 1.0f - f13) {
                            ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat.getValue().floatValue() > 0.0f ? stateAnimateFloat.getValue().floatValue() + f13 : 0.0f, 1.0f, j115, fM4412getHeightimpl, i19);
                        }
                        if (stateAnimateFloat.getValue().floatValue() - stateAnimateFloat2.getValue().floatValue() > 0.0f) {
                            ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat.getValue().floatValue(), stateAnimateFloat2.getValue().floatValue(), j116, fM4412getHeightimpl, i19);
                        }
                        if (stateAnimateFloat2.getValue().floatValue() > f13) {
                            ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat3.getValue().floatValue() > 0.0f ? stateAnimateFloat3.getValue().floatValue() + f13 : 0.0f, stateAnimateFloat2.getValue().floatValue() < 1.0f ? stateAnimateFloat2.getValue().floatValue() - f13 : 1.0f, j115, fM4412getHeightimpl, i19);
                        }
                        if (stateAnimateFloat3.getValue().floatValue() - stateAnimateFloat4.getValue().floatValue() > 0.0f) {
                            ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat3.getValue().floatValue(), stateAnimateFloat4.getValue().floatValue(), j116, fM4412getHeightimpl, i19);
                        }
                        if (stateAnimateFloat4.getValue().floatValue() > f13) {
                            ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, 0.0f, stateAnimateFloat4.getValue().floatValue() < 1.0f ? stateAnimateFloat4.getValue().floatValue() - f13 : 1.0f, j115, fM4412getHeightimpl, i19);
                        }
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                final int i110 = iM2668getLinearStrokeCapKaPHkGw;
                final float f12 = fM2667getLinearIndicatorTrackGapSizeD9Ej5fM;
                final long j117 = linearTrackColor;
                final long j118 = linearColor;
                objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((DrawScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(DrawScope drawScope) {
                        float f13;
                        float fM4412getHeightimpl = Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc());
                        if (StrokeCap.m4959equalsimpl0(i110, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc()) > Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc())) {
                            f13 = f12;
                        } else {
                            f13 = Dp.constructor-impl(f12 + drawScope.toDp-u2uoSUM(fM4412getHeightimpl));
                        }
                        float f14 = f13 / drawScope.toDp-u2uoSUM(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()));
                        if (stateAnimateFloat.getValue().floatValue() < 1.0f - f14) {
                            ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat.getValue().floatValue() > 0.0f ? stateAnimateFloat.getValue().floatValue() + f14 : 0.0f, 1.0f, j117, fM4412getHeightimpl, i110);
                        }
                        if (stateAnimateFloat.getValue().floatValue() - stateAnimateFloat2.getValue().floatValue() > 0.0f) {
                            ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat.getValue().floatValue(), stateAnimateFloat2.getValue().floatValue(), j118, fM4412getHeightimpl, i110);
                        }
                        if (stateAnimateFloat2.getValue().floatValue() > f14) {
                            ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat3.getValue().floatValue() > 0.0f ? stateAnimateFloat3.getValue().floatValue() + f14 : 0.0f, stateAnimateFloat2.getValue().floatValue() < 1.0f ? stateAnimateFloat2.getValue().floatValue() - f14 : 1.0f, j117, fM4412getHeightimpl, i110);
                        }
                        if (stateAnimateFloat3.getValue().floatValue() - stateAnimateFloat4.getValue().floatValue() > 0.0f) {
                            ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat3.getValue().floatValue(), stateAnimateFloat4.getValue().floatValue(), j118, fM4412getHeightimpl, i110);
                        }
                        if (stateAnimateFloat4.getValue().floatValue() > f14) {
                            ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, 0.0f, stateAnimateFloat4.getValue().floatValue() < 1.0f ? stateAnimateFloat4.getValue().floatValue() - f14 : 1.0f, j117, fM4412getHeightimpl, i110);
                        }
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            CanvasKt.Canvas(modifierM1082sizeVpY3zN9, (Function1) objRememberedValue, composerStartRestartGroup, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier2 = modifier11;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i2 & 1) != 0) {
                if (i8 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i3 & 2) != 0) {
                    linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                    i4 &= -113;
                }
                if ((i3 & 4) != 0) {
                    linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                    i4 &= -897;
                }
                if (i9 != 0) {
                    iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                }
                if (i5 != 0) {
                    fM2667getLinearIndicatorTrackGapSizeD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2667getLinearIndicatorTrackGapSizeD9Ej5fM();
                }
            } else {
                if (i8 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i3 & 2) != 0) {
                    linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                    i4 &= -113;
                }
                if ((i3 & 4) != 0) {
                    linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                    i4 &= -897;
                }
                if (i9 != 0) {
                    iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                }
                if (i5 != 0) {
                    fM2667getLinearIndicatorTrackGapSizeD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2667getLinearIndicatorTrackGapSizeD9Ej5fM();
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(567589233, i4, -1, "androidx.compose.material3.LinearProgressIndicator (ProgressIndicator.kt:253)");
            }
            InfiniteTransition infiniteTransitionRememberInfiniteTransition7 = InfiniteTransitionKt.rememberInfiniteTransition(null, composerStartRestartGroup, 0, 1);
            stateAnimateFloat = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition7, 0.0f, 1.0f, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                public Object invoke(Object obj) {
                    invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                    return Unit.INSTANCE;
                }

                public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                    keyframesSpecConfig.setDurationMillis(1800);
                    keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 0), ProgressIndicatorKt.FirstLineHeadEasing);
                    keyframesSpecConfig.mo80at(Float.valueOf(1.0f), 750);
                }
            }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
            stateAnimateFloat2 = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition7, 0.0f, 1.0f, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                public Object invoke(Object obj) {
                    invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                    return Unit.INSTANCE;
                }

                public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                    keyframesSpecConfig.setDurationMillis(1800);
                    keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 333), ProgressIndicatorKt.FirstLineTailEasing);
                    keyframesSpecConfig.mo80at(Float.valueOf(1.0f), 1183);
                }
            }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
            stateAnimateFloat3 = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition7, 0.0f, 1.0f, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                public Object invoke(Object obj) {
                    invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                    return Unit.INSTANCE;
                }

                public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                    keyframesSpecConfig.setDurationMillis(1800);
                    keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 1000), ProgressIndicatorKt.SecondLineHeadEasing);
                    keyframesSpecConfig.mo80at(Float.valueOf(1.0f), 1567);
                }
            }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
            stateAnimateFloat4 = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition7, 0.0f, 1.0f, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                public Object invoke(Object obj) {
                    invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                    return Unit.INSTANCE;
                }

                public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                    keyframesSpecConfig.setDurationMillis(1800);
                    keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 1267), ProgressIndicatorKt.SecondLineTailEasing);
                    keyframesSpecConfig.mo80at(Float.valueOf(1.0f), 1800);
                }
            }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
            Modifier modifier12 = companion;
            Modifier modifierM1082sizeVpY3zN10 = SizeKt.m1082sizeVpY3zN4(ProgressSemanticsKt.progressSemantics(companion.then(IncreaseSemanticsBounds)), LinearIndicatorWidth, LinearIndicatorHeight);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1145216297, "CC(remember):ProgressIndicator.kt#9igjgp");
            if ((i4 & 7168) == 2048) {
                z = true;
            } else {
                z = false;
            }
            if ((57344 & i4) == 16384) {
                z2 = true;
            } else {
                z2 = false;
            }
            zChanged = z | z2 | composerStartRestartGroup.changed(stateAnimateFloat) | ((((i4 & 896) ^ 384) <= 256 && composerStartRestartGroup.changed(linearTrackColor)) || (i4 & 384) == 256) | composerStartRestartGroup.changed(stateAnimateFloat2) | ((((i4 & 112) ^ 48) <= 32 && composerStartRestartGroup.changed(linearColor)) || (i4 & 48) == 32) | composerStartRestartGroup.changed(stateAnimateFloat3) | composerStartRestartGroup.changed(stateAnimateFloat4);
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (!zChanged) {
                final int i111 = iM2668getLinearStrokeCapKaPHkGw;
                final float f13 = fM2667getLinearIndicatorTrackGapSizeD9Ej5fM;
                final long j119 = linearTrackColor;
                final long j1110 = linearColor;
                objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((DrawScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(DrawScope drawScope) {
                        float f14;
                        float fM4412getHeightimpl = Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc());
                        if (StrokeCap.m4959equalsimpl0(i111, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc()) > Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc())) {
                            f14 = f13;
                        } else {
                            f14 = Dp.constructor-impl(f13 + drawScope.toDp-u2uoSUM(fM4412getHeightimpl));
                        }
                        float f15 = f14 / drawScope.toDp-u2uoSUM(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()));
                        if (stateAnimateFloat.getValue().floatValue() < 1.0f - f15) {
                            ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat.getValue().floatValue() > 0.0f ? stateAnimateFloat.getValue().floatValue() + f15 : 0.0f, 1.0f, j119, fM4412getHeightimpl, i111);
                        }
                        if (stateAnimateFloat.getValue().floatValue() - stateAnimateFloat2.getValue().floatValue() > 0.0f) {
                            ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat.getValue().floatValue(), stateAnimateFloat2.getValue().floatValue(), j1110, fM4412getHeightimpl, i111);
                        }
                        if (stateAnimateFloat2.getValue().floatValue() > f15) {
                            ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat3.getValue().floatValue() > 0.0f ? stateAnimateFloat3.getValue().floatValue() + f15 : 0.0f, stateAnimateFloat2.getValue().floatValue() < 1.0f ? stateAnimateFloat2.getValue().floatValue() - f15 : 1.0f, j119, fM4412getHeightimpl, i111);
                        }
                        if (stateAnimateFloat3.getValue().floatValue() - stateAnimateFloat4.getValue().floatValue() > 0.0f) {
                            ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat3.getValue().floatValue(), stateAnimateFloat4.getValue().floatValue(), j1110, fM4412getHeightimpl, i111);
                        }
                        if (stateAnimateFloat4.getValue().floatValue() > f15) {
                            ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, 0.0f, stateAnimateFloat4.getValue().floatValue() < 1.0f ? stateAnimateFloat4.getValue().floatValue() - f15 : 1.0f, j119, fM4412getHeightimpl, i111);
                        }
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                final int i112 = iM2668getLinearStrokeCapKaPHkGw;
                final float f14 = fM2667getLinearIndicatorTrackGapSizeD9Ej5fM;
                final long j1111 = linearTrackColor;
                final long j1112 = linearColor;
                objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((DrawScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(DrawScope drawScope) {
                        float f15;
                        float fM4412getHeightimpl = Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc());
                        if (StrokeCap.m4959equalsimpl0(i112, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc()) > Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc())) {
                            f15 = f14;
                        } else {
                            f15 = Dp.constructor-impl(f14 + drawScope.toDp-u2uoSUM(fM4412getHeightimpl));
                        }
                        float f16 = f15 / drawScope.toDp-u2uoSUM(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()));
                        if (stateAnimateFloat.getValue().floatValue() < 1.0f - f16) {
                            ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat.getValue().floatValue() > 0.0f ? stateAnimateFloat.getValue().floatValue() + f16 : 0.0f, 1.0f, j1111, fM4412getHeightimpl, i112);
                        }
                        if (stateAnimateFloat.getValue().floatValue() - stateAnimateFloat2.getValue().floatValue() > 0.0f) {
                            ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat.getValue().floatValue(), stateAnimateFloat2.getValue().floatValue(), j1112, fM4412getHeightimpl, i112);
                        }
                        if (stateAnimateFloat2.getValue().floatValue() > f16) {
                            ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat3.getValue().floatValue() > 0.0f ? stateAnimateFloat3.getValue().floatValue() + f16 : 0.0f, stateAnimateFloat2.getValue().floatValue() < 1.0f ? stateAnimateFloat2.getValue().floatValue() - f16 : 1.0f, j1111, fM4412getHeightimpl, i112);
                        }
                        if (stateAnimateFloat3.getValue().floatValue() - stateAnimateFloat4.getValue().floatValue() > 0.0f) {
                            ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, stateAnimateFloat3.getValue().floatValue(), stateAnimateFloat4.getValue().floatValue(), j1112, fM4412getHeightimpl, i112);
                        }
                        if (stateAnimateFloat4.getValue().floatValue() > f16) {
                            ProgressIndicatorKt.m2692drawLinearIndicatorqYKTg0g(drawScope, 0.0f, stateAnimateFloat4.getValue().floatValue() < 1.0f ? stateAnimateFloat4.getValue().floatValue() - f16 : 1.0f, j1111, fM4412getHeightimpl, i112);
                        }
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            CanvasKt.Canvas(modifierM1082sizeVpY3zN10, (Function1) objRememberedValue, composerStartRestartGroup, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier2 = modifier12;
        }
        j3 = linearTrackColor;
        i7 = iM2668getLinearStrokeCapKaPHkGw;
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier13 = modifier2;
            final long j1113 = linearColor;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i113) {
                    ProgressIndicatorKt.m2682LinearProgressIndicatorrIrjwxo(modifier13, j1113, j3, i7, fM2667getLinearIndicatorTrackGapSizeD9Ej5fM, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                }
            });
        }
    }

    @Deprecated(message = "Use the overload that takes `progress` as a lambda", replaceWith = @ReplaceWith(expression = "LinearProgressIndicator(\nprogress = { progress },\nmodifier = modifier,\ncolor = color,\ntrackColor = trackColor,\nstrokeCap = strokeCap,\n)", imports = {}))
    public static final void m2679LinearProgressIndicator_5eSRE(final float f, Modifier modifier, long j, long j2, int i, Composer composer, final int i2, final int i3) {
        int i4;
        Modifier modifier2;
        long linearColor;
        long linearTrackColor;
        int i5;
        int i6;
        int i7;
        int iM2668getLinearStrokeCapKaPHkGw;
        long j3;
        long j4;
        boolean z;
        Object objRememberedValue;
        final int i8;
        final long j5;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i9;
        int i10;
        Composer composerStartRestartGroup = composer.startRestartGroup(905419617);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(LinearProgressIndicator)P(2,1,0:c#ui.graphics.Color,4:c#ui.graphics.Color,3:c#ui.graphics.StrokeCap)385@15871L11,386@15934L16,390@16074L12,389@16030L179:ProgressIndicator.kt#uh7d8r");
        if ((i3 & 1) != 0) {
            i4 = i2 | 6;
        } else if ((i2 & 6) == 0) {
            i4 = (composerStartRestartGroup.changed(f) ? 4 : 2) | i2;
        } else {
            i4 = i2;
        }
        int i11 = i3 & 2;
        if (i11 == 0) {
            if ((i2 & 48) == 0) {
                modifier2 = modifier;
                i4 |= composerStartRestartGroup.changed(modifier2) ? 32 : 16;
            }
            if ((i2 & 384) == 0) {
                linearColor = j;
                if ((i3 & 4) == 0 || !composerStartRestartGroup.changed(linearColor)) {
                    i10 = Fields.SpotShadowColor;
                } else {
                    i10 = Fields.RotationX;
                }
                i4 |= i10;
            } else {
                linearColor = j;
            }
            if ((i2 & 3072) == 0) {
                linearTrackColor = j2;
                if ((i3 & 8) == 0 || !composerStartRestartGroup.changed(linearTrackColor)) {
                    i9 = Fields.RotationZ;
                } else {
                    i9 = Fields.CameraDistance;
                }
                i4 |= i9;
            } else {
                linearTrackColor = j2;
            }
            i5 = i3 & 16;
            if (i5 != 0) {
                if ((i2 & 24576) == 0) {
                    i6 = i;
                    if (composerStartRestartGroup.changed(i6)) {
                        i7 = Fields.Clip;
                    } else {
                        i7 = Fields.Shape;
                    }
                    i4 |= i7;
                }
                if ((i4 & 9363) == 9362 || !composerStartRestartGroup.getSkipping()) {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                        if (i11 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i3 & 4) != 0) {
                            linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                            i4 &= -897;
                        }
                        if ((i3 & 8) != 0) {
                            linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                            i4 &= -7169;
                        }
                        if (i5 != 0) {
                            iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                            j3 = linearColor;
                            j4 = linearTrackColor;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(905419617, i4, -1, "androidx.compose.material3.LinearProgressIndicator (ProgressIndicator.kt:389)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1145297734, "CC(remember):ProgressIndicator.kt#9igjgp");
                        if ((i4 & 14) == 4) {
                            z = true;
                        } else {
                            z = false;
                        }
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (z || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue = (Function0) new Function0<Float>() {
                                {
                                    super(0);
                                }

                                public final Float m2696invoke() {
                                    return Float.valueOf(f);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        m2677LinearProgressIndicatorGJbTh5U((Function0) objRememberedValue, modifier2, j3, j4, iM2668getLinearStrokeCapKaPHkGw, 0.0f, null, composerStartRestartGroup, i4 & 65520, 96);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        i8 = iM2668getLinearStrokeCapKaPHkGw;
                        j5 = j3;
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        if ((i3 & 4) != 0) {
                            i4 &= -897;
                        }
                        if ((i3 & 8) != 0) {
                            i4 &= -7169;
                        }
                    }
                    j3 = linearColor;
                    j4 = linearTrackColor;
                    iM2668getLinearStrokeCapKaPHkGw = i6;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(905419617, i4, -1, "androidx.compose.material3.LinearProgressIndicator (ProgressIndicator.kt:389)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1145297734, "CC(remember):ProgressIndicator.kt#9igjgp");
                    if ((i4 & 14) == 4) {
                        z = true;
                    } else {
                        z = false;
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (z) {
                        objRememberedValue = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2696invoke() {
                                return Float.valueOf(f);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2696invoke() {
                                return Float.valueOf(f);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    m2677LinearProgressIndicatorGJbTh5U((Function0) objRememberedValue, modifier2, j3, j4, iM2668getLinearStrokeCapKaPHkGw, 0.0f, null, composerStartRestartGroup, i4 & 65520, 96);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    i8 = iM2668getLinearStrokeCapKaPHkGw;
                    j5 = j3;
                } else {
                    composerStartRestartGroup.skipToGroupEnd();
                    j5 = linearColor;
                    j4 = linearTrackColor;
                    i8 = i6;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier3 = modifier2;
                    final long j6 = j4;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i12) {
                            ProgressIndicatorKt.m2679LinearProgressIndicator_5eSRE(f, modifier3, j5, j6, i8, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                        }
                    });
                }
            }
            i4 |= 24576;
            i6 = i;
            if ((i4 & 9363) == 9362) {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) != 0) {
                    if (i11 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if ((i3 & 8) != 0) {
                        linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                        i4 &= -7169;
                    }
                    if (i5 != 0) {
                        iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                        j3 = linearColor;
                        j4 = linearTrackColor;
                    } else {
                        j3 = linearColor;
                        j4 = linearTrackColor;
                        iM2668getLinearStrokeCapKaPHkGw = i6;
                    }
                } else {
                    if (i11 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if ((i3 & 8) != 0) {
                        linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                        i4 &= -7169;
                    }
                    if (i5 != 0) {
                        iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                        j3 = linearColor;
                        j4 = linearTrackColor;
                    } else {
                        j3 = linearColor;
                        j4 = linearTrackColor;
                        iM2668getLinearStrokeCapKaPHkGw = i6;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(905419617, i4, -1, "androidx.compose.material3.LinearProgressIndicator (ProgressIndicator.kt:389)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1145297734, "CC(remember):ProgressIndicator.kt#9igjgp");
                if ((i4 & 14) == 4) {
                    z = true;
                } else {
                    z = false;
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (z) {
                    objRememberedValue = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2696invoke() {
                            return Float.valueOf(f);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2696invoke() {
                            return Float.valueOf(f);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                m2677LinearProgressIndicatorGJbTh5U((Function0) objRememberedValue, modifier2, j3, j4, iM2668getLinearStrokeCapKaPHkGw, 0.0f, null, composerStartRestartGroup, i4 & 65520, 96);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                i8 = iM2668getLinearStrokeCapKaPHkGw;
                j5 = j3;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) != 0) {
                    if (i11 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if ((i3 & 8) != 0) {
                        linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                        i4 &= -7169;
                    }
                    if (i5 != 0) {
                        iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                        j3 = linearColor;
                        j4 = linearTrackColor;
                    } else {
                        j3 = linearColor;
                        j4 = linearTrackColor;
                        iM2668getLinearStrokeCapKaPHkGw = i6;
                    }
                } else {
                    if (i11 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if ((i3 & 8) != 0) {
                        linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                        i4 &= -7169;
                    }
                    if (i5 != 0) {
                        iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                        j3 = linearColor;
                        j4 = linearTrackColor;
                    } else {
                        j3 = linearColor;
                        j4 = linearTrackColor;
                        iM2668getLinearStrokeCapKaPHkGw = i6;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(905419617, i4, -1, "androidx.compose.material3.LinearProgressIndicator (ProgressIndicator.kt:389)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1145297734, "CC(remember):ProgressIndicator.kt#9igjgp");
                if ((i4 & 14) == 4) {
                    z = true;
                } else {
                    z = false;
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (z) {
                    objRememberedValue = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2696invoke() {
                            return Float.valueOf(f);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2696invoke() {
                            return Float.valueOf(f);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                m2677LinearProgressIndicatorGJbTh5U((Function0) objRememberedValue, modifier2, j3, j4, iM2668getLinearStrokeCapKaPHkGw, 0.0f, null, composerStartRestartGroup, i4 & 65520, 96);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                i8 = iM2668getLinearStrokeCapKaPHkGw;
                j5 = j3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier4 = modifier2;
                final long j7 = j4;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i12) {
                        ProgressIndicatorKt.m2679LinearProgressIndicator_5eSRE(f, modifier4, j5, j7, i8, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                    }
                });
            }
        }
        i4 |= 48;
        modifier2 = modifier;
        if ((i2 & 384) == 0) {
            linearColor = j;
            if ((i3 & 4) == 0) {
                i10 = Fields.SpotShadowColor;
            } else {
                i10 = Fields.SpotShadowColor;
            }
            i4 |= i10;
        } else {
            linearColor = j;
        }
        if ((i2 & 3072) == 0) {
            linearTrackColor = j2;
            if ((i3 & 8) == 0) {
                i9 = Fields.RotationZ;
            } else {
                i9 = Fields.RotationZ;
            }
            i4 |= i9;
        } else {
            linearTrackColor = j2;
        }
        i5 = i3 & 16;
        if (i5 != 0) {
            if ((i2 & 24576) == 0) {
                i6 = i;
                if (composerStartRestartGroup.changed(i6)) {
                    i7 = Fields.Clip;
                } else {
                    i7 = Fields.Shape;
                }
                i4 |= i7;
            }
            if ((i4 & 9363) == 9362) {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) != 0) {
                    if (i11 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if ((i3 & 8) != 0) {
                        linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                        i4 &= -7169;
                    }
                    if (i5 != 0) {
                        iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                        j3 = linearColor;
                        j4 = linearTrackColor;
                    } else {
                        j3 = linearColor;
                        j4 = linearTrackColor;
                        iM2668getLinearStrokeCapKaPHkGw = i6;
                    }
                } else {
                    if (i11 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if ((i3 & 8) != 0) {
                        linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                        i4 &= -7169;
                    }
                    if (i5 != 0) {
                        iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                        j3 = linearColor;
                        j4 = linearTrackColor;
                    } else {
                        j3 = linearColor;
                        j4 = linearTrackColor;
                        iM2668getLinearStrokeCapKaPHkGw = i6;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(905419617, i4, -1, "androidx.compose.material3.LinearProgressIndicator (ProgressIndicator.kt:389)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1145297734, "CC(remember):ProgressIndicator.kt#9igjgp");
                if ((i4 & 14) == 4) {
                    z = true;
                } else {
                    z = false;
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (z) {
                    objRememberedValue = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2696invoke() {
                            return Float.valueOf(f);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2696invoke() {
                            return Float.valueOf(f);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                m2677LinearProgressIndicatorGJbTh5U((Function0) objRememberedValue, modifier2, j3, j4, iM2668getLinearStrokeCapKaPHkGw, 0.0f, null, composerStartRestartGroup, i4 & 65520, 96);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                i8 = iM2668getLinearStrokeCapKaPHkGw;
                j5 = j3;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) != 0) {
                    if (i11 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if ((i3 & 8) != 0) {
                        linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                        i4 &= -7169;
                    }
                    if (i5 != 0) {
                        iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                        j3 = linearColor;
                        j4 = linearTrackColor;
                    } else {
                        j3 = linearColor;
                        j4 = linearTrackColor;
                        iM2668getLinearStrokeCapKaPHkGw = i6;
                    }
                } else {
                    if (i11 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if ((i3 & 8) != 0) {
                        linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                        i4 &= -7169;
                    }
                    if (i5 != 0) {
                        iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                        j3 = linearColor;
                        j4 = linearTrackColor;
                    } else {
                        j3 = linearColor;
                        j4 = linearTrackColor;
                        iM2668getLinearStrokeCapKaPHkGw = i6;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(905419617, i4, -1, "androidx.compose.material3.LinearProgressIndicator (ProgressIndicator.kt:389)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1145297734, "CC(remember):ProgressIndicator.kt#9igjgp");
                if ((i4 & 14) == 4) {
                    z = true;
                } else {
                    z = false;
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (z) {
                    objRememberedValue = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2696invoke() {
                            return Float.valueOf(f);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2696invoke() {
                            return Float.valueOf(f);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                m2677LinearProgressIndicatorGJbTh5U((Function0) objRememberedValue, modifier2, j3, j4, iM2668getLinearStrokeCapKaPHkGw, 0.0f, null, composerStartRestartGroup, i4 & 65520, 96);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                i8 = iM2668getLinearStrokeCapKaPHkGw;
                j5 = j3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier5 = modifier2;
                final long j8 = j4;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i12) {
                        ProgressIndicatorKt.m2679LinearProgressIndicator_5eSRE(f, modifier5, j5, j8, i8, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                    }
                });
            }
        }
        i4 |= 24576;
        i6 = i;
        if ((i4 & 9363) == 9362) {
            composerStartRestartGroup.startDefaults();
            if ((i2 & 1) != 0) {
                if (i11 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if ((i3 & 4) != 0) {
                    linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                    i4 &= -897;
                }
                if ((i3 & 8) != 0) {
                    linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                    i4 &= -7169;
                }
                if (i5 != 0) {
                    iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                    j3 = linearColor;
                    j4 = linearTrackColor;
                } else {
                    j3 = linearColor;
                    j4 = linearTrackColor;
                    iM2668getLinearStrokeCapKaPHkGw = i6;
                }
            } else {
                if (i11 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if ((i3 & 4) != 0) {
                    linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                    i4 &= -897;
                }
                if ((i3 & 8) != 0) {
                    linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                    i4 &= -7169;
                }
                if (i5 != 0) {
                    iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                    j3 = linearColor;
                    j4 = linearTrackColor;
                } else {
                    j3 = linearColor;
                    j4 = linearTrackColor;
                    iM2668getLinearStrokeCapKaPHkGw = i6;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(905419617, i4, -1, "androidx.compose.material3.LinearProgressIndicator (ProgressIndicator.kt:389)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1145297734, "CC(remember):ProgressIndicator.kt#9igjgp");
            if ((i4 & 14) == 4) {
                z = true;
            } else {
                z = false;
            }
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (z) {
                objRememberedValue = (Function0) new Function0<Float>() {
                    {
                        super(0);
                    }

                    public final Float m2696invoke() {
                        return Float.valueOf(f);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = (Function0) new Function0<Float>() {
                    {
                        super(0);
                    }

                    public final Float m2696invoke() {
                        return Float.valueOf(f);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            m2677LinearProgressIndicatorGJbTh5U((Function0) objRememberedValue, modifier2, j3, j4, iM2668getLinearStrokeCapKaPHkGw, 0.0f, null, composerStartRestartGroup, i4 & 65520, 96);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            i8 = iM2668getLinearStrokeCapKaPHkGw;
            j5 = j3;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i2 & 1) != 0) {
                if (i11 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if ((i3 & 4) != 0) {
                    linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                    i4 &= -897;
                }
                if ((i3 & 8) != 0) {
                    linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                    i4 &= -7169;
                }
                if (i5 != 0) {
                    iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                    j3 = linearColor;
                    j4 = linearTrackColor;
                } else {
                    j3 = linearColor;
                    j4 = linearTrackColor;
                    iM2668getLinearStrokeCapKaPHkGw = i6;
                }
            } else {
                if (i11 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if ((i3 & 4) != 0) {
                    linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                    i4 &= -897;
                }
                if ((i3 & 8) != 0) {
                    linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                    i4 &= -7169;
                }
                if (i5 != 0) {
                    iM2668getLinearStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw();
                    j3 = linearColor;
                    j4 = linearTrackColor;
                } else {
                    j3 = linearColor;
                    j4 = linearTrackColor;
                    iM2668getLinearStrokeCapKaPHkGw = i6;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(905419617, i4, -1, "androidx.compose.material3.LinearProgressIndicator (ProgressIndicator.kt:389)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1145297734, "CC(remember):ProgressIndicator.kt#9igjgp");
            if ((i4 & 14) == 4) {
                z = true;
            } else {
                z = false;
            }
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (z) {
                objRememberedValue = (Function0) new Function0<Float>() {
                    {
                        super(0);
                    }

                    public final Float m2696invoke() {
                        return Float.valueOf(f);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = (Function0) new Function0<Float>() {
                    {
                        super(0);
                    }

                    public final Float m2696invoke() {
                        return Float.valueOf(f);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            m2677LinearProgressIndicatorGJbTh5U((Function0) objRememberedValue, modifier2, j3, j4, iM2668getLinearStrokeCapKaPHkGw, 0.0f, null, composerStartRestartGroup, i4 & 65520, 96);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            i8 = iM2668getLinearStrokeCapKaPHkGw;
            j5 = j3;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier6 = modifier2;
            final long j9 = j4;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i12) {
                    ProgressIndicatorKt.m2679LinearProgressIndicator_5eSRE(f, modifier6, j5, j9, i8, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                }
            });
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Maintained for binary compatibility")
    public static final void m2681LinearProgressIndicatoreaDK9VM(final float f, Modifier modifier, long j, long j2, Composer composer, final int i, final int i2) {
        int i3;
        Modifier modifier2;
        long linearColor;
        long j3;
        Modifier.Companion companion;
        long linearTrackColor;
        long j4;
        final long j5;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i4;
        int i5;
        Composer composerStartRestartGroup = composer.startRestartGroup(-372717133);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(LinearProgressIndicator)P(2,1,0:c#ui.graphics.Color,3:c#ui.graphics.Color)403@16462L11,404@16525L16,406@16551L164:ProgressIndicator.kt#uh7d8r");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changed(f) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i6 = i2 & 2;
        if (i6 == 0) {
            if ((i & 48) == 0) {
                modifier2 = modifier;
                i3 |= composerStartRestartGroup.changed(modifier2) ? 32 : 16;
            }
            if ((i & 384) == 0) {
                linearColor = j;
                if ((i2 & 4) == 0 || !composerStartRestartGroup.changed(linearColor)) {
                    i5 = Fields.SpotShadowColor;
                } else {
                    i5 = Fields.RotationX;
                }
                i3 |= i5;
            } else {
                linearColor = j;
            }
            if ((i & 3072) == 0) {
                j3 = j2;
                if ((i2 & 8) == 0 || !composerStartRestartGroup.changed(j3)) {
                    i4 = Fields.RotationZ;
                } else {
                    i4 = Fields.CameraDistance;
                }
                i3 |= i4;
            } else {
                j3 = j2;
            }
            if ((i3 & 1171) == 1170 || !composerStartRestartGroup.getSkipping()) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                    if (i6 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 4) != 0) {
                        linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                        i3 &= -897;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                        j4 = linearColor;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-372717133, i3, -1, "androidx.compose.material3.LinearProgressIndicator (ProgressIndicator.kt:406)");
                    }
                    m2679LinearProgressIndicator_5eSRE(f, companion, j4, linearTrackColor, ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw(), composerStartRestartGroup, (i3 & 14) | 24576 | (i3 & 112) | (i3 & 896) | (i3 & 7168), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    linearColor = j4;
                    j5 = linearTrackColor;
                } else {
                    composerStartRestartGroup.skipToGroupEnd();
                    if ((i2 & 4) != 0) {
                        i3 &= -897;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                    }
                    companion = modifier2;
                }
                j4 = linearColor;
                linearTrackColor = j3;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-372717133, i3, -1, "androidx.compose.material3.LinearProgressIndicator (ProgressIndicator.kt:406)");
                }
                m2679LinearProgressIndicator_5eSRE(f, companion, j4, linearTrackColor, ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw(), composerStartRestartGroup, (i3 & 14) | 24576 | (i3 & 112) | (i3 & 896) | (i3 & 7168), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                linearColor = j4;
                j5 = linearTrackColor;
            } else {
                composerStartRestartGroup.skipToGroupEnd();
                companion = modifier2;
                j5 = j3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier3 = companion;
                final long j6 = linearColor;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i7) {
                        ProgressIndicatorKt.m2681LinearProgressIndicatoreaDK9VM(f, modifier3, j6, j5, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        modifier2 = modifier;
        if ((i & 384) == 0) {
            linearColor = j;
            if ((i2 & 4) == 0) {
                i5 = Fields.SpotShadowColor;
            } else {
                i5 = Fields.SpotShadowColor;
            }
            i3 |= i5;
        } else {
            linearColor = j;
        }
        if ((i & 3072) == 0) {
            j3 = j2;
            if ((i2 & 8) == 0) {
                i4 = Fields.RotationZ;
            } else {
                i4 = Fields.RotationZ;
            }
            i3 |= i4;
        } else {
            j3 = j2;
        }
        if ((i3 & 1171) == 1170) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i6 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 4) != 0) {
                    linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                    i3 &= -897;
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                    linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                    j4 = linearColor;
                } else {
                    j4 = linearColor;
                    linearTrackColor = j3;
                }
            } else {
                if (i6 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 4) != 0) {
                    linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                    i3 &= -897;
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                    linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                    j4 = linearColor;
                } else {
                    j4 = linearColor;
                    linearTrackColor = j3;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-372717133, i3, -1, "androidx.compose.material3.LinearProgressIndicator (ProgressIndicator.kt:406)");
            }
            m2679LinearProgressIndicator_5eSRE(f, companion, j4, linearTrackColor, ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw(), composerStartRestartGroup, (i3 & 14) | 24576 | (i3 & 112) | (i3 & 896) | (i3 & 7168), 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            linearColor = j4;
            j5 = linearTrackColor;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i6 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 4) != 0) {
                    linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                    i3 &= -897;
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                    linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                    j4 = linearColor;
                } else {
                    j4 = linearColor;
                    linearTrackColor = j3;
                }
            } else {
                if (i6 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 4) != 0) {
                    linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                    i3 &= -897;
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                    linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                    j4 = linearColor;
                } else {
                    j4 = linearColor;
                    linearTrackColor = j3;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-372717133, i3, -1, "androidx.compose.material3.LinearProgressIndicator (ProgressIndicator.kt:406)");
            }
            m2679LinearProgressIndicator_5eSRE(f, companion, j4, linearTrackColor, ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw(), composerStartRestartGroup, (i3 & 14) | 24576 | (i3 & 112) | (i3 & 896) | (i3 & 7168), 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            linearColor = j4;
            j5 = linearTrackColor;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier4 = companion;
            final long j7 = linearColor;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i7) {
                    ProgressIndicatorKt.m2681LinearProgressIndicatoreaDK9VM(f, modifier4, j7, j5, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Maintained for binary compatibility")
    public static final void m2678LinearProgressIndicatorRIQooxk(Modifier modifier, long j, long j2, Composer composer, final int i, final int i2) {
        Modifier modifier2;
        int i3;
        long linearColor;
        long linearTrackColor;
        Modifier.Companion companion;
        long j3;
        Composer composerStartRestartGroup = composer.startRestartGroup(585576195);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(LinearProgressIndicator)P(1,0:c#ui.graphics.Color,2:c#ui.graphics.Color)418@16922L11,419@16985L16,421@17011L146:ProgressIndicator.kt#uh7d8r");
        int i4 = i2 & 1;
        if (i4 != 0) {
            i3 = i | 6;
            modifier2 = modifier;
        } else if ((i & 6) == 0) {
            modifier2 = modifier;
            i3 = (composerStartRestartGroup.changed(modifier2) ? 4 : 2) | i;
        } else {
            modifier2 = modifier;
            i3 = i;
        }
        if ((i & 48) == 0) {
            linearColor = j;
            i3 |= ((i2 & 2) == 0 && composerStartRestartGroup.changed(linearColor)) ? 32 : 16;
        } else {
            linearColor = j;
        }
        if ((i & 384) == 0) {
            linearTrackColor = j2;
            i3 |= ((i2 & 4) == 0 && composerStartRestartGroup.changed(linearTrackColor)) ? Fields.RotationX : Fields.SpotShadowColor;
        } else {
            linearTrackColor = j2;
        }
        if ((i3 & 147) == 146 && composerStartRestartGroup.getSkipping()) {
            composerStartRestartGroup.skipToGroupEnd();
            companion = modifier2;
            j3 = linearColor;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) == 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                companion = i4 != 0 ? Modifier.INSTANCE : modifier2;
                if ((i2 & 2) != 0) {
                    linearColor = ProgressIndicatorDefaults.INSTANCE.getLinearColor(composerStartRestartGroup, 6);
                    i3 &= -113;
                }
                if ((i2 & 4) != 0) {
                    linearTrackColor = ProgressIndicatorDefaults.INSTANCE.getLinearTrackColor(composerStartRestartGroup, 6);
                    i3 &= -897;
                }
            } else {
                composerStartRestartGroup.skipToGroupEnd();
                if ((i2 & 2) != 0) {
                    i3 &= -113;
                }
                if ((i2 & 4) != 0) {
                    i3 &= -897;
                }
                companion = modifier2;
            }
            int i5 = i3;
            j3 = linearColor;
            long j4 = linearTrackColor;
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(585576195, i5, -1, "androidx.compose.material3.LinearProgressIndicator (ProgressIndicator.kt:421)");
            }
            m2682LinearProgressIndicatorrIrjwxo(companion, j3, j4, ProgressIndicatorDefaults.INSTANCE.m2668getLinearStrokeCapKaPHkGw(), 0.0f, composerStartRestartGroup, (i5 & 14) | 3072 | (i5 & 112) | (i5 & 896), 16);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            linearTrackColor = j4;
        }
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier3 = companion;
            final long j5 = j3;
            final long j6 = linearTrackColor;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i6) {
                    ProgressIndicatorKt.m2678LinearProgressIndicatorRIQooxk(modifier3, j5, j6, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void m2692drawLinearIndicatorqYKTg0g(DrawScope drawScope, float f, float f2, long j, float f3, int i) {
        float fM4415getWidthimpl = Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc());
        float fM4412getHeightimpl = Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc());
        float f4 = 2;
        float f5 = fM4412getHeightimpl / f4;
        boolean z = drawScope.getLayoutDirection() == LayoutDirection.Ltr;
        float f6 = (z ? f : 1.0f - f2) * fM4415getWidthimpl;
        float f7 = (z ? f2 : 1.0f - f) * fM4415getWidthimpl;
        if (StrokeCap.m4959equalsimpl0(i, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || fM4412getHeightimpl > fM4415getWidthimpl) {
            DrawScope.CC.m5172drawLineNGM6Ib0$default(drawScope, j, OffsetKt.Offset(f6, f5), OffsetKt.Offset(f7, f5), f3, 0, null, 0.0f, null, 0, 496, null);
            return;
        }
        float f8 = f3 / f4;
        ClosedFloatingPointRange closedFloatingPointRangeRangeTo = RangesKt.rangeTo(f8, fM4415getWidthimpl - f8);
        float fFloatValue = ((Number) RangesKt.coerceIn(Float.valueOf(f6), closedFloatingPointRangeRangeTo)).floatValue();
        float fFloatValue2 = ((Number) RangesKt.coerceIn(Float.valueOf(f7), closedFloatingPointRangeRangeTo)).floatValue();
        if (Math.abs(f2 - f) > 0.0f) {
            DrawScope.CC.m5172drawLineNGM6Ib0$default(drawScope, j, OffsetKt.Offset(fFloatValue, f5), OffsetKt.Offset(fFloatValue2, f5), f3, i, null, 0.0f, null, 0, 480, null);
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Use the overload that takes `gapSize`, see `LegacyCircularProgressIndicatorSample` on how to restore the previous behavior", replaceWith = @ReplaceWith(expression = "CircularProgressIndicator(progress, modifier, color, strokeWidth, trackColor, strokeCap, gapSize)", imports = {}))
    public static final void m2671CircularProgressIndicatorDUhRLBM(final Function0 function0, Modifier modifier, long j, float f, long j2, int i, Composer composer, final int i2, final int i3) {
        int i4;
        Modifier modifier2;
        long circularColor;
        int i5;
        float fM2666getCircularStrokeWidthD9Ej5fM;
        int i6;
        long circularDeterminateTrackColor;
        int i7;
        int i8;
        int i9;
        final int iM2663getCircularDeterminateStrokeCapKaPHkGw;
        float f2;
        int i10;
        final long j3;
        final long j4;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i11;
        int i12;
        Composer composerStartRestartGroup = composer.startRestartGroup(-761680467);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(CircularProgressIndicator)P(2,1,0:c#ui.graphics.Color,4:c#ui.unit.Dp,5:c#ui.graphics.Color,3:c#ui.graphics.StrokeCap)529@21735L13,531@21869L29,534@21991L217:ProgressIndicator.kt#uh7d8r");
        if ((i3 & 1) != 0) {
            i4 = i2 | 6;
        } else if ((i2 & 6) == 0) {
            i4 = (composerStartRestartGroup.changedInstance(function0) ? 4 : 2) | i2;
        } else {
            i4 = i2;
        }
        int i13 = i3 & 2;
        if (i13 == 0) {
            if ((i2 & 48) == 0) {
                modifier2 = modifier;
                i4 |= composerStartRestartGroup.changed(modifier2) ? 32 : 16;
            }
            if ((i2 & 384) == 0) {
                if ((i3 & 4) == 0) {
                    circularColor = j;
                    if (composerStartRestartGroup.changed(circularColor)) {
                        i12 = Fields.RotationX;
                    }
                    i4 |= i12;
                } else {
                    circularColor = j;
                }
                i12 = Fields.SpotShadowColor;
                i4 |= i12;
            } else {
                circularColor = j;
            }
            i5 = i3 & 8;
            if (i5 != 0) {
                if ((i2 & 3072) == 0) {
                    fM2666getCircularStrokeWidthD9Ej5fM = f;
                    if (composerStartRestartGroup.changed(fM2666getCircularStrokeWidthD9Ej5fM)) {
                        i6 = Fields.CameraDistance;
                    } else {
                        i6 = Fields.RotationZ;
                    }
                    i4 |= i6;
                }
                if ((i2 & 24576) == 0) {
                    if ((i3 & 16) == 0) {
                        circularDeterminateTrackColor = j2;
                        if (composerStartRestartGroup.changed(circularDeterminateTrackColor)) {
                            i11 = Fields.Clip;
                        }
                        i4 |= i11;
                    } else {
                        circularDeterminateTrackColor = j2;
                    }
                    i11 = Fields.Shape;
                    i4 |= i11;
                } else {
                    circularDeterminateTrackColor = j2;
                }
                i7 = i3 & 32;
                if (i7 != 0) {
                    if ((196608 & i2) == 0) {
                        i8 = i;
                        if (composerStartRestartGroup.changed(i8)) {
                            i9 = Fields.RenderEffect;
                        } else {
                            i9 = 65536;
                        }
                        i4 |= i9;
                    }
                    if ((74899 & i4) == 74898 || !composerStartRestartGroup.getSkipping()) {
                        composerStartRestartGroup.startDefaults();
                        if ((i2 & 1) == 0 && !composerStartRestartGroup.getDefaultsInvalid()) {
                            composerStartRestartGroup.skipToGroupEnd();
                            if ((i3 & 4) != 0) {
                                i4 &= -897;
                            }
                            if ((i3 & 16) != 0) {
                                i4 &= -57345;
                            }
                        } else {
                            if (i13 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if ((i3 & 4) != 0) {
                                circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                                i4 &= -897;
                            }
                            if (i5 != 0) {
                                fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                            }
                            if ((i3 & 16) != 0) {
                                circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                                i4 &= -57345;
                            }
                            if (i7 != 0) {
                                iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                                f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                            }
                            i10 = i4;
                            long j5 = circularDeterminateTrackColor;
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-761680467, i10, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:533)");
                            }
                            m2672CircularProgressIndicatorIyT6zlY(function0, modifier2, circularColor, f2, j5, iM2663getCircularDeterminateStrokeCapKaPHkGw, ProgressIndicatorDefaults.INSTANCE.m2665getCircularIndicatorTrackGapSizeD9Ej5fM(), composerStartRestartGroup, (i10 & 14) | 1572864 | (i10 & 112) | (i10 & 896) | (i10 & 7168) | (57344 & i10) | (i10 & 458752), 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            fM2666getCircularStrokeWidthD9Ej5fM = f2;
                            j3 = circularColor;
                            j4 = j5;
                        }
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                        i10 = i4;
                        long j6 = circularDeterminateTrackColor;
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-761680467, i10, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:533)");
                        }
                        m2672CircularProgressIndicatorIyT6zlY(function0, modifier2, circularColor, f2, j6, iM2663getCircularDeterminateStrokeCapKaPHkGw, ProgressIndicatorDefaults.INSTANCE.m2665getCircularIndicatorTrackGapSizeD9Ej5fM(), composerStartRestartGroup, (i10 & 14) | 1572864 | (i10 & 112) | (i10 & 896) | (i10 & 7168) | (57344 & i10) | (i10 & 458752), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        fM2666getCircularStrokeWidthD9Ej5fM = f2;
                        j3 = circularColor;
                        j4 = j6;
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        j3 = circularColor;
                        j4 = circularDeterminateTrackColor;
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier3 = modifier2;
                        final float f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i14) {
                                ProgressIndicatorKt.m2671CircularProgressIndicatorDUhRLBM(function0, modifier3, j3, f3, j4, iM2663getCircularDeterminateStrokeCapKaPHkGw, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                            }
                        });
                    }
                }
                i4 |= 196608;
                i8 = i;
                if ((74899 & i4) == 74898) {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) == 0) {
                        if (i13 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i3 & 4) != 0) {
                            circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                            i4 &= -897;
                        }
                        if (i5 != 0) {
                            fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                        }
                        if ((i3 & 16) != 0) {
                            circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                            i4 &= -57345;
                        }
                        if (i7 != 0) {
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                            f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        } else {
                            f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                        }
                    } else {
                        if (i13 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i3 & 4) != 0) {
                            circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                            i4 &= -897;
                        }
                        if (i5 != 0) {
                            fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                        }
                        if ((i3 & 16) != 0) {
                            circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                            i4 &= -57345;
                        }
                        if (i7 != 0) {
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                            f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        } else {
                            f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                        }
                    }
                    i10 = i4;
                    long j7 = circularDeterminateTrackColor;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-761680467, i10, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:533)");
                    }
                    m2672CircularProgressIndicatorIyT6zlY(function0, modifier2, circularColor, f2, j7, iM2663getCircularDeterminateStrokeCapKaPHkGw, ProgressIndicatorDefaults.INSTANCE.m2665getCircularIndicatorTrackGapSizeD9Ej5fM(), composerStartRestartGroup, (i10 & 14) | 1572864 | (i10 & 112) | (i10 & 896) | (i10 & 7168) | (57344 & i10) | (i10 & 458752), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    fM2666getCircularStrokeWidthD9Ej5fM = f2;
                    j3 = circularColor;
                    j4 = j7;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) == 0) {
                        if (i13 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i3 & 4) != 0) {
                            circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                            i4 &= -897;
                        }
                        if (i5 != 0) {
                            fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                        }
                        if ((i3 & 16) != 0) {
                            circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                            i4 &= -57345;
                        }
                        if (i7 != 0) {
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                            f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        } else {
                            f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                        }
                    } else {
                        if (i13 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i3 & 4) != 0) {
                            circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                            i4 &= -897;
                        }
                        if (i5 != 0) {
                            fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                        }
                        if ((i3 & 16) != 0) {
                            circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                            i4 &= -57345;
                        }
                        if (i7 != 0) {
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                            f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        } else {
                            f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                        }
                    }
                    i10 = i4;
                    long j8 = circularDeterminateTrackColor;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-761680467, i10, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:533)");
                    }
                    m2672CircularProgressIndicatorIyT6zlY(function0, modifier2, circularColor, f2, j8, iM2663getCircularDeterminateStrokeCapKaPHkGw, ProgressIndicatorDefaults.INSTANCE.m2665getCircularIndicatorTrackGapSizeD9Ej5fM(), composerStartRestartGroup, (i10 & 14) | 1572864 | (i10 & 112) | (i10 & 896) | (i10 & 7168) | (57344 & i10) | (i10 & 458752), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    fM2666getCircularStrokeWidthD9Ej5fM = f2;
                    j3 = circularColor;
                    j4 = j8;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier4 = modifier2;
                    final float f4 = fM2666getCircularStrokeWidthD9Ej5fM;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i14) {
                            ProgressIndicatorKt.m2671CircularProgressIndicatorDUhRLBM(function0, modifier4, j3, f4, j4, iM2663getCircularDeterminateStrokeCapKaPHkGw, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                        }
                    });
                }
            }
            i4 |= 3072;
            fM2666getCircularStrokeWidthD9Ej5fM = f;
            if ((i2 & 24576) == 0) {
                if ((i3 & 16) == 0) {
                    circularDeterminateTrackColor = j2;
                    if (composerStartRestartGroup.changed(circularDeterminateTrackColor)) {
                        i11 = Fields.Clip;
                    }
                    i4 |= i11;
                } else {
                    circularDeterminateTrackColor = j2;
                }
                i11 = Fields.Shape;
                i4 |= i11;
            } else {
                circularDeterminateTrackColor = j2;
            }
            i7 = i3 & 32;
            if (i7 != 0) {
                if ((196608 & i2) == 0) {
                    i8 = i;
                    if (composerStartRestartGroup.changed(i8)) {
                        i9 = Fields.RenderEffect;
                    } else {
                        i9 = 65536;
                    }
                    i4 |= i9;
                }
                if ((74899 & i4) == 74898) {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) == 0) {
                        if (i13 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i3 & 4) != 0) {
                            circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                            i4 &= -897;
                        }
                        if (i5 != 0) {
                            fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                        }
                        if ((i3 & 16) != 0) {
                            circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                            i4 &= -57345;
                        }
                        if (i7 != 0) {
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                            f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        } else {
                            f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                        }
                    } else {
                        if (i13 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i3 & 4) != 0) {
                            circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                            i4 &= -897;
                        }
                        if (i5 != 0) {
                            fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                        }
                        if ((i3 & 16) != 0) {
                            circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                            i4 &= -57345;
                        }
                        if (i7 != 0) {
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                            f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        } else {
                            f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                        }
                    }
                    i10 = i4;
                    long j9 = circularDeterminateTrackColor;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-761680467, i10, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:533)");
                    }
                    m2672CircularProgressIndicatorIyT6zlY(function0, modifier2, circularColor, f2, j9, iM2663getCircularDeterminateStrokeCapKaPHkGw, ProgressIndicatorDefaults.INSTANCE.m2665getCircularIndicatorTrackGapSizeD9Ej5fM(), composerStartRestartGroup, (i10 & 14) | 1572864 | (i10 & 112) | (i10 & 896) | (i10 & 7168) | (57344 & i10) | (i10 & 458752), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    fM2666getCircularStrokeWidthD9Ej5fM = f2;
                    j3 = circularColor;
                    j4 = j9;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) == 0) {
                        if (i13 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i3 & 4) != 0) {
                            circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                            i4 &= -897;
                        }
                        if (i5 != 0) {
                            fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                        }
                        if ((i3 & 16) != 0) {
                            circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                            i4 &= -57345;
                        }
                        if (i7 != 0) {
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                            f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        } else {
                            f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                        }
                    } else {
                        if (i13 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i3 & 4) != 0) {
                            circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                            i4 &= -897;
                        }
                        if (i5 != 0) {
                            fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                        }
                        if ((i3 & 16) != 0) {
                            circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                            i4 &= -57345;
                        }
                        if (i7 != 0) {
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                            f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        } else {
                            f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                        }
                    }
                    i10 = i4;
                    long j10 = circularDeterminateTrackColor;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-761680467, i10, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:533)");
                    }
                    m2672CircularProgressIndicatorIyT6zlY(function0, modifier2, circularColor, f2, j10, iM2663getCircularDeterminateStrokeCapKaPHkGw, ProgressIndicatorDefaults.INSTANCE.m2665getCircularIndicatorTrackGapSizeD9Ej5fM(), composerStartRestartGroup, (i10 & 14) | 1572864 | (i10 & 112) | (i10 & 896) | (i10 & 7168) | (57344 & i10) | (i10 & 458752), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    fM2666getCircularStrokeWidthD9Ej5fM = f2;
                    j3 = circularColor;
                    j4 = j10;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier5 = modifier2;
                    final float f5 = fM2666getCircularStrokeWidthD9Ej5fM;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i14) {
                            ProgressIndicatorKt.m2671CircularProgressIndicatorDUhRLBM(function0, modifier5, j3, f5, j4, iM2663getCircularDeterminateStrokeCapKaPHkGw, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                        }
                    });
                }
            }
            i4 |= 196608;
            i8 = i;
            if ((74899 & i4) == 74898) {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) == 0) {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i5 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 16) != 0) {
                        circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    }
                    if (i7 != 0) {
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                    } else {
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                    }
                } else {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i5 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 16) != 0) {
                        circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    }
                    if (i7 != 0) {
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                    } else {
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                    }
                }
                i10 = i4;
                long j11 = circularDeterminateTrackColor;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-761680467, i10, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:533)");
                }
                m2672CircularProgressIndicatorIyT6zlY(function0, modifier2, circularColor, f2, j11, iM2663getCircularDeterminateStrokeCapKaPHkGw, ProgressIndicatorDefaults.INSTANCE.m2665getCircularIndicatorTrackGapSizeD9Ej5fM(), composerStartRestartGroup, (i10 & 14) | 1572864 | (i10 & 112) | (i10 & 896) | (i10 & 7168) | (57344 & i10) | (i10 & 458752), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                fM2666getCircularStrokeWidthD9Ej5fM = f2;
                j3 = circularColor;
                j4 = j11;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) == 0) {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i5 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 16) != 0) {
                        circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    }
                    if (i7 != 0) {
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                    } else {
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                    }
                } else {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i5 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 16) != 0) {
                        circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    }
                    if (i7 != 0) {
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                    } else {
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                    }
                }
                i10 = i4;
                long j12 = circularDeterminateTrackColor;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-761680467, i10, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:533)");
                }
                m2672CircularProgressIndicatorIyT6zlY(function0, modifier2, circularColor, f2, j12, iM2663getCircularDeterminateStrokeCapKaPHkGw, ProgressIndicatorDefaults.INSTANCE.m2665getCircularIndicatorTrackGapSizeD9Ej5fM(), composerStartRestartGroup, (i10 & 14) | 1572864 | (i10 & 112) | (i10 & 896) | (i10 & 7168) | (57344 & i10) | (i10 & 458752), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                fM2666getCircularStrokeWidthD9Ej5fM = f2;
                j3 = circularColor;
                j4 = j12;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier6 = modifier2;
                final float f6 = fM2666getCircularStrokeWidthD9Ej5fM;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i14) {
                        ProgressIndicatorKt.m2671CircularProgressIndicatorDUhRLBM(function0, modifier6, j3, f6, j4, iM2663getCircularDeterminateStrokeCapKaPHkGw, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                    }
                });
            }
        }
        i4 |= 48;
        modifier2 = modifier;
        if ((i2 & 384) == 0) {
            if ((i3 & 4) == 0) {
                circularColor = j;
                if (composerStartRestartGroup.changed(circularColor)) {
                    i12 = Fields.RotationX;
                }
                i4 |= i12;
            } else {
                circularColor = j;
            }
            i12 = Fields.SpotShadowColor;
            i4 |= i12;
        } else {
            circularColor = j;
        }
        i5 = i3 & 8;
        if (i5 != 0) {
            if ((i2 & 3072) == 0) {
                fM2666getCircularStrokeWidthD9Ej5fM = f;
                if (composerStartRestartGroup.changed(fM2666getCircularStrokeWidthD9Ej5fM)) {
                    i6 = Fields.CameraDistance;
                } else {
                    i6 = Fields.RotationZ;
                }
                i4 |= i6;
            }
            if ((i2 & 24576) == 0) {
                if ((i3 & 16) == 0) {
                    circularDeterminateTrackColor = j2;
                    if (composerStartRestartGroup.changed(circularDeterminateTrackColor)) {
                        i11 = Fields.Clip;
                    }
                    i4 |= i11;
                } else {
                    circularDeterminateTrackColor = j2;
                }
                i11 = Fields.Shape;
                i4 |= i11;
            } else {
                circularDeterminateTrackColor = j2;
            }
            i7 = i3 & 32;
            if (i7 != 0) {
                if ((196608 & i2) == 0) {
                    i8 = i;
                    if (composerStartRestartGroup.changed(i8)) {
                        i9 = Fields.RenderEffect;
                    } else {
                        i9 = 65536;
                    }
                    i4 |= i9;
                }
                if ((74899 & i4) == 74898) {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) == 0) {
                        if (i13 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i3 & 4) != 0) {
                            circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                            i4 &= -897;
                        }
                        if (i5 != 0) {
                            fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                        }
                        if ((i3 & 16) != 0) {
                            circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                            i4 &= -57345;
                        }
                        if (i7 != 0) {
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                            f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        } else {
                            f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                        }
                    } else {
                        if (i13 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i3 & 4) != 0) {
                            circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                            i4 &= -897;
                        }
                        if (i5 != 0) {
                            fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                        }
                        if ((i3 & 16) != 0) {
                            circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                            i4 &= -57345;
                        }
                        if (i7 != 0) {
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                            f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        } else {
                            f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                        }
                    }
                    i10 = i4;
                    long j13 = circularDeterminateTrackColor;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-761680467, i10, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:533)");
                    }
                    m2672CircularProgressIndicatorIyT6zlY(function0, modifier2, circularColor, f2, j13, iM2663getCircularDeterminateStrokeCapKaPHkGw, ProgressIndicatorDefaults.INSTANCE.m2665getCircularIndicatorTrackGapSizeD9Ej5fM(), composerStartRestartGroup, (i10 & 14) | 1572864 | (i10 & 112) | (i10 & 896) | (i10 & 7168) | (57344 & i10) | (i10 & 458752), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    fM2666getCircularStrokeWidthD9Ej5fM = f2;
                    j3 = circularColor;
                    j4 = j13;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) == 0) {
                        if (i13 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i3 & 4) != 0) {
                            circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                            i4 &= -897;
                        }
                        if (i5 != 0) {
                            fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                        }
                        if ((i3 & 16) != 0) {
                            circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                            i4 &= -57345;
                        }
                        if (i7 != 0) {
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                            f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        } else {
                            f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                        }
                    } else {
                        if (i13 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i3 & 4) != 0) {
                            circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                            i4 &= -897;
                        }
                        if (i5 != 0) {
                            fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                        }
                        if ((i3 & 16) != 0) {
                            circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                            i4 &= -57345;
                        }
                        if (i7 != 0) {
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                            f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        } else {
                            f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                        }
                    }
                    i10 = i4;
                    long j14 = circularDeterminateTrackColor;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-761680467, i10, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:533)");
                    }
                    m2672CircularProgressIndicatorIyT6zlY(function0, modifier2, circularColor, f2, j14, iM2663getCircularDeterminateStrokeCapKaPHkGw, ProgressIndicatorDefaults.INSTANCE.m2665getCircularIndicatorTrackGapSizeD9Ej5fM(), composerStartRestartGroup, (i10 & 14) | 1572864 | (i10 & 112) | (i10 & 896) | (i10 & 7168) | (57344 & i10) | (i10 & 458752), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    fM2666getCircularStrokeWidthD9Ej5fM = f2;
                    j3 = circularColor;
                    j4 = j14;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier7 = modifier2;
                    final float f7 = fM2666getCircularStrokeWidthD9Ej5fM;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i14) {
                            ProgressIndicatorKt.m2671CircularProgressIndicatorDUhRLBM(function0, modifier7, j3, f7, j4, iM2663getCircularDeterminateStrokeCapKaPHkGw, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                        }
                    });
                }
            }
            i4 |= 196608;
            i8 = i;
            if ((74899 & i4) == 74898) {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) == 0) {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i5 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 16) != 0) {
                        circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    }
                    if (i7 != 0) {
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                    } else {
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                    }
                } else {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i5 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 16) != 0) {
                        circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    }
                    if (i7 != 0) {
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                    } else {
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                    }
                }
                i10 = i4;
                long j15 = circularDeterminateTrackColor;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-761680467, i10, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:533)");
                }
                m2672CircularProgressIndicatorIyT6zlY(function0, modifier2, circularColor, f2, j15, iM2663getCircularDeterminateStrokeCapKaPHkGw, ProgressIndicatorDefaults.INSTANCE.m2665getCircularIndicatorTrackGapSizeD9Ej5fM(), composerStartRestartGroup, (i10 & 14) | 1572864 | (i10 & 112) | (i10 & 896) | (i10 & 7168) | (57344 & i10) | (i10 & 458752), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                fM2666getCircularStrokeWidthD9Ej5fM = f2;
                j3 = circularColor;
                j4 = j15;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) == 0) {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i5 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 16) != 0) {
                        circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    }
                    if (i7 != 0) {
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                    } else {
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                    }
                } else {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i5 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 16) != 0) {
                        circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    }
                    if (i7 != 0) {
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                    } else {
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                    }
                }
                i10 = i4;
                long j16 = circularDeterminateTrackColor;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-761680467, i10, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:533)");
                }
                m2672CircularProgressIndicatorIyT6zlY(function0, modifier2, circularColor, f2, j16, iM2663getCircularDeterminateStrokeCapKaPHkGw, ProgressIndicatorDefaults.INSTANCE.m2665getCircularIndicatorTrackGapSizeD9Ej5fM(), composerStartRestartGroup, (i10 & 14) | 1572864 | (i10 & 112) | (i10 & 896) | (i10 & 7168) | (57344 & i10) | (i10 & 458752), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                fM2666getCircularStrokeWidthD9Ej5fM = f2;
                j3 = circularColor;
                j4 = j16;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier8 = modifier2;
                final float f8 = fM2666getCircularStrokeWidthD9Ej5fM;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i14) {
                        ProgressIndicatorKt.m2671CircularProgressIndicatorDUhRLBM(function0, modifier8, j3, f8, j4, iM2663getCircularDeterminateStrokeCapKaPHkGw, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                    }
                });
            }
        }
        i4 |= 3072;
        fM2666getCircularStrokeWidthD9Ej5fM = f;
        if ((i2 & 24576) == 0) {
            if ((i3 & 16) == 0) {
                circularDeterminateTrackColor = j2;
                if (composerStartRestartGroup.changed(circularDeterminateTrackColor)) {
                    i11 = Fields.Clip;
                }
                i4 |= i11;
            } else {
                circularDeterminateTrackColor = j2;
            }
            i11 = Fields.Shape;
            i4 |= i11;
        } else {
            circularDeterminateTrackColor = j2;
        }
        i7 = i3 & 32;
        if (i7 != 0) {
            if ((196608 & i2) == 0) {
                i8 = i;
                if (composerStartRestartGroup.changed(i8)) {
                    i9 = Fields.RenderEffect;
                } else {
                    i9 = 65536;
                }
                i4 |= i9;
            }
            if ((74899 & i4) == 74898) {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) == 0) {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i5 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 16) != 0) {
                        circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    }
                    if (i7 != 0) {
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                    } else {
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                    }
                } else {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i5 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 16) != 0) {
                        circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    }
                    if (i7 != 0) {
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                    } else {
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                    }
                }
                i10 = i4;
                long j17 = circularDeterminateTrackColor;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-761680467, i10, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:533)");
                }
                m2672CircularProgressIndicatorIyT6zlY(function0, modifier2, circularColor, f2, j17, iM2663getCircularDeterminateStrokeCapKaPHkGw, ProgressIndicatorDefaults.INSTANCE.m2665getCircularIndicatorTrackGapSizeD9Ej5fM(), composerStartRestartGroup, (i10 & 14) | 1572864 | (i10 & 112) | (i10 & 896) | (i10 & 7168) | (57344 & i10) | (i10 & 458752), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                fM2666getCircularStrokeWidthD9Ej5fM = f2;
                j3 = circularColor;
                j4 = j17;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) == 0) {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i5 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 16) != 0) {
                        circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    }
                    if (i7 != 0) {
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                    } else {
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                    }
                } else {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i5 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 16) != 0) {
                        circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    }
                    if (i7 != 0) {
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                    } else {
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                    }
                }
                i10 = i4;
                long j18 = circularDeterminateTrackColor;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-761680467, i10, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:533)");
                }
                m2672CircularProgressIndicatorIyT6zlY(function0, modifier2, circularColor, f2, j18, iM2663getCircularDeterminateStrokeCapKaPHkGw, ProgressIndicatorDefaults.INSTANCE.m2665getCircularIndicatorTrackGapSizeD9Ej5fM(), composerStartRestartGroup, (i10 & 14) | 1572864 | (i10 & 112) | (i10 & 896) | (i10 & 7168) | (57344 & i10) | (i10 & 458752), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                fM2666getCircularStrokeWidthD9Ej5fM = f2;
                j3 = circularColor;
                j4 = j18;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier9 = modifier2;
                final float f9 = fM2666getCircularStrokeWidthD9Ej5fM;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i14) {
                        ProgressIndicatorKt.m2671CircularProgressIndicatorDUhRLBM(function0, modifier9, j3, f9, j4, iM2663getCircularDeterminateStrokeCapKaPHkGw, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                    }
                });
            }
        }
        i4 |= 196608;
        i8 = i;
        if ((74899 & i4) == 74898) {
            composerStartRestartGroup.startDefaults();
            if ((i2 & 1) == 0) {
                if (i13 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if ((i3 & 4) != 0) {
                    circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                    i4 &= -897;
                }
                if (i5 != 0) {
                    fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                }
                if ((i3 & 16) != 0) {
                    circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                    i4 &= -57345;
                }
                if (i7 != 0) {
                    iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                    f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                } else {
                    f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                    iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                }
            } else {
                if (i13 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if ((i3 & 4) != 0) {
                    circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                    i4 &= -897;
                }
                if (i5 != 0) {
                    fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                }
                if ((i3 & 16) != 0) {
                    circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                    i4 &= -57345;
                }
                if (i7 != 0) {
                    iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                    f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                } else {
                    f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                    iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                }
            }
            i10 = i4;
            long j19 = circularDeterminateTrackColor;
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-761680467, i10, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:533)");
            }
            m2672CircularProgressIndicatorIyT6zlY(function0, modifier2, circularColor, f2, j19, iM2663getCircularDeterminateStrokeCapKaPHkGw, ProgressIndicatorDefaults.INSTANCE.m2665getCircularIndicatorTrackGapSizeD9Ej5fM(), composerStartRestartGroup, (i10 & 14) | 1572864 | (i10 & 112) | (i10 & 896) | (i10 & 7168) | (57344 & i10) | (i10 & 458752), 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            fM2666getCircularStrokeWidthD9Ej5fM = f2;
            j3 = circularColor;
            j4 = j19;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i2 & 1) == 0) {
                if (i13 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if ((i3 & 4) != 0) {
                    circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                    i4 &= -897;
                }
                if (i5 != 0) {
                    fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                }
                if ((i3 & 16) != 0) {
                    circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                    i4 &= -57345;
                }
                if (i7 != 0) {
                    iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                    f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                } else {
                    f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                    iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                }
            } else {
                if (i13 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if ((i3 & 4) != 0) {
                    circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                    i4 &= -897;
                }
                if (i5 != 0) {
                    fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                }
                if ((i3 & 16) != 0) {
                    circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                    i4 &= -57345;
                }
                if (i7 != 0) {
                    iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                    f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                } else {
                    f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                    iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                }
            }
            i10 = i4;
            long j110 = circularDeterminateTrackColor;
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-761680467, i10, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:533)");
            }
            m2672CircularProgressIndicatorIyT6zlY(function0, modifier2, circularColor, f2, j110, iM2663getCircularDeterminateStrokeCapKaPHkGw, ProgressIndicatorDefaults.INSTANCE.m2665getCircularIndicatorTrackGapSizeD9Ej5fM(), composerStartRestartGroup, (i10 & 14) | 1572864 | (i10 & 112) | (i10 & 896) | (i10 & 7168) | (57344 & i10) | (i10 & 458752), 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            fM2666getCircularStrokeWidthD9Ej5fM = f2;
            j3 = circularColor;
            j4 = j110;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier10 = modifier2;
            final float f10 = fM2666getCircularStrokeWidthD9Ej5fM;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i14) {
                    ProgressIndicatorKt.m2671CircularProgressIndicatorDUhRLBM(function0, modifier10, j3, f10, j4, iM2663getCircularDeterminateStrokeCapKaPHkGw, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                }
            });
        }
    }

    public static final void m2672CircularProgressIndicatorIyT6zlY(final Function0<Float> function0, Modifier modifier, long j, float f, long j2, int i, float f2, Composer composer, final int i2, final int i3) {
        int i4;
        Modifier modifier2;
        long circularColor;
        int i5;
        float fM2666getCircularStrokeWidthD9Ej5fM;
        int i6;
        long j3;
        int i7;
        int iM2663getCircularDeterminateStrokeCapKaPHkGw;
        int i8;
        int i9;
        float fM2665getCircularIndicatorTrackGapSizeD9Ej5fM;
        int i10;
        long circularDeterminateTrackColor;
        boolean z;
        Object objRememberedValue;
        final Function0 function1;
        final Stroke stroke;
        boolean zChanged;
        Object objRememberedValue2;
        boolean z2;
        boolean z3;
        boolean z4;
        boolean zChangedInstance;
        Object objRememberedValue3;
        final long j4;
        final float f3;
        final float f4;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i11;
        int i12;
        Composer composerStartRestartGroup = composer.startRestartGroup(-1798883595);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(CircularProgressIndicator)P(3,2,0:c#ui.graphics.Color,5:c#ui.unit.Dp,6:c#ui.graphics.Color,4:c#ui.graphics.StrokeCap,1:c#ui.unit.Dp)575@23884L13,577@24018L29,581@24237L31,*582@24304L7,585@24446L102,589@24600L709,583@24373L936:ProgressIndicator.kt#uh7d8r");
        if ((i3 & 1) != 0) {
            i4 = i2 | 6;
        } else if ((i2 & 6) == 0) {
            i4 = (composerStartRestartGroup.changedInstance(function0) ? 4 : 2) | i2;
        } else {
            i4 = i2;
        }
        int i13 = i3 & 2;
        if (i13 == 0) {
            if ((i2 & 48) == 0) {
                modifier2 = modifier;
                i4 |= composerStartRestartGroup.changed(modifier2) ? 32 : 16;
            }
            if ((i2 & 384) == 0) {
                circularColor = j;
                if ((i3 & 4) == 0 || !composerStartRestartGroup.changed(circularColor)) {
                    i12 = Fields.SpotShadowColor;
                } else {
                    i12 = Fields.RotationX;
                }
                i4 |= i12;
            } else {
                circularColor = j;
            }
            i5 = i3 & 8;
            if (i5 != 0) {
                if ((i2 & 3072) == 0) {
                    fM2666getCircularStrokeWidthD9Ej5fM = f;
                    if (composerStartRestartGroup.changed(fM2666getCircularStrokeWidthD9Ej5fM)) {
                        i6 = Fields.CameraDistance;
                    } else {
                        i6 = Fields.RotationZ;
                    }
                    i4 |= i6;
                }
                if ((i2 & 24576) == 0) {
                    j3 = j2;
                    if ((i3 & 16) == 0 || !composerStartRestartGroup.changed(j3)) {
                        i11 = Fields.Shape;
                    } else {
                        i11 = Fields.Clip;
                    }
                    i4 |= i11;
                } else {
                    j3 = j2;
                }
                i7 = i3 & 32;
                if (i7 != 0) {
                    i4 |= 196608;
                    iM2663getCircularDeterminateStrokeCapKaPHkGw = i;
                } else {
                    iM2663getCircularDeterminateStrokeCapKaPHkGw = i;
                    if ((i2 & 196608) == 0) {
                        if (composerStartRestartGroup.changed(iM2663getCircularDeterminateStrokeCapKaPHkGw)) {
                            i8 = Fields.RenderEffect;
                        } else {
                            i8 = 65536;
                        }
                        i4 |= i8;
                    }
                }
                i9 = i3 & 64;
                if (i9 != 0) {
                    i4 |= 1572864;
                    fM2665getCircularIndicatorTrackGapSizeD9Ej5fM = f2;
                } else {
                    fM2665getCircularIndicatorTrackGapSizeD9Ej5fM = f2;
                    if ((i2 & 1572864) == 0) {
                        if (composerStartRestartGroup.changed(fM2665getCircularIndicatorTrackGapSizeD9Ej5fM)) {
                            i10 = 1048576;
                        } else {
                            i10 = 524288;
                        }
                        i4 |= i10;
                    }
                }
                if ((i4 & 599187) == 599186 || !composerStartRestartGroup.getSkipping()) {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                        if (i13 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i3 & 4) != 0) {
                            circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                            i4 &= -897;
                        }
                        if (i5 != 0) {
                            fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                        }
                        if ((i3 & 16) != 0) {
                            circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                            i4 &= -57345;
                        } else {
                            circularDeterminateTrackColor = j3;
                        }
                        if (i7 != 0) {
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                        }
                        if (i9 != 0) {
                            fM2665getCircularIndicatorTrackGapSizeD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2665getCircularIndicatorTrackGapSizeD9Ej5fM();
                        }
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        if ((i3 & 4) != 0) {
                            i4 &= -897;
                        }
                        if ((i3 & 16) != 0) {
                            i4 &= -57345;
                        }
                        circularDeterminateTrackColor = j3;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1798883595, i4, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:580)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291619137, "CC(remember):ProgressIndicator.kt#9igjgp");
                    if ((i4 & 14) == 4) {
                        z = true;
                    } else {
                        z = false;
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2694invoke() {
                                return Float.valueOf(RangesKt.coerceIn(((Number) function0.invoke()).floatValue(), 0.0f, 1.0f));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    function1 = (Function0) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ProvidableCompositionLocal<Density> localDensity = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume = composerStartRestartGroup.consume(localDensity);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    stroke = new Stroke(((Density) objConsume).toPx-0680j_4(fM2666getCircularStrokeWidthD9Ej5fM), 0.0f, iM2663getCircularDeterminateStrokeCapKaPHkGw, 0, null, 26, null);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291612378, "CC(remember):ProgressIndicator.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(function1);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged || objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((SemanticsPropertyReceiver) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                SemanticsPropertiesKt.setProgressBarRangeInfo(semanticsPropertyReceiver, new ProgressBarRangeInfo(((Number) function1.invoke()).floatValue(), RangesKt.rangeTo(0.0f, 1.0f), 0, 4, null));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Modifier modifierM1080size3ABfNKs = SizeKt.m1080size3ABfNKs(SemanticsModifierKt.semantics(modifier2, true, (Function1) objRememberedValue2), CircularIndicatorDiameter);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291606843, "CC(remember):ProgressIndicator.kt#9igjgp");
                    boolean zChanged2 = composerStartRestartGroup.changed(function1);
                    Modifier modifier3 = modifier2;
                    if ((458752 & i4) == 131072) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    boolean z5 = zChanged2 | z2;
                    if ((3670016 & i4) == 1048576) {
                        z3 = true;
                    } else {
                        z3 = false;
                    }
                    boolean z6 = z5 | z3;
                    if ((i4 & 7168) == 2048) {
                        z4 = true;
                    } else {
                        z4 = false;
                    }
                    zChangedInstance = z6 | z4 | ((((57344 & i4) ^ 24576) <= 16384 && composerStartRestartGroup.changed(circularDeterminateTrackColor)) || (i4 & 24576) == 16384) | composerStartRestartGroup.changedInstance(stroke) | ((((i4 & 896) ^ 384) <= 256 && composerStartRestartGroup.changed(circularColor)) || (i4 & 384) == 256);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChangedInstance || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                        final int i14 = iM2663getCircularDeterminateStrokeCapKaPHkGw;
                        final float f5 = fM2665getCircularIndicatorTrackGapSizeD9Ej5fM;
                        final float f6 = fM2666getCircularStrokeWidthD9Ej5fM;
                        final long j5 = circularDeterminateTrackColor;
                        final long j6 = circularColor;
                        objRememberedValue3 = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                float f7;
                                float fFloatValue = ((Number) function1.invoke()).floatValue() * 360.0f;
                                if (StrokeCap.m4959equalsimpl0(i14, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc()) > Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc())) {
                                    f7 = f5;
                                } else {
                                    f7 = Dp.constructor-impl(f5 + f6);
                                }
                                float f8 = (f7 / ((float) (((double) drawScope.toDp-u2uoSUM(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()))) * 3.141592653589793d))) * 360.0f;
                                ProgressIndicatorKt.m2688drawCircularIndicator42QJj7c(drawScope, 270.0f + fFloatValue + Math.min(fFloatValue, f8), (360.0f - fFloatValue) - (Math.min(fFloatValue, f8) * 2), j5, stroke);
                                ProgressIndicatorKt.m2690drawDeterminateCircularIndicator42QJj7c(drawScope, 270.0f, fFloatValue, j6, stroke);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CanvasKt.Canvas(modifierM1080size3ABfNKs, (Function1) objRememberedValue3, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    j4 = circularColor;
                    f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                    f4 = fM2665getCircularIndicatorTrackGapSizeD9Ej5fM;
                    modifier2 = modifier3;
                } else {
                    composerStartRestartGroup.skipToGroupEnd();
                    circularDeterminateTrackColor = j3;
                    j4 = circularColor;
                    f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                    f4 = fM2665getCircularIndicatorTrackGapSizeD9Ej5fM;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier4 = modifier2;
                    final long j7 = circularDeterminateTrackColor;
                    final int i15 = iM2663getCircularDeterminateStrokeCapKaPHkGw;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i16) {
                            ProgressIndicatorKt.m2672CircularProgressIndicatorIyT6zlY(function0, modifier4, j4, f3, j7, i15, f4, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                        }
                    });
                }
            }
            i4 |= 3072;
            fM2666getCircularStrokeWidthD9Ej5fM = f;
            if ((i2 & 24576) == 0) {
                j3 = j2;
                if ((i3 & 16) == 0) {
                    i11 = Fields.Shape;
                } else {
                    i11 = Fields.Shape;
                }
                i4 |= i11;
            } else {
                j3 = j2;
            }
            i7 = i3 & 32;
            if (i7 != 0) {
                i4 |= 196608;
                iM2663getCircularDeterminateStrokeCapKaPHkGw = i;
            } else {
                iM2663getCircularDeterminateStrokeCapKaPHkGw = i;
                if ((i2 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(iM2663getCircularDeterminateStrokeCapKaPHkGw)) {
                        i8 = Fields.RenderEffect;
                    } else {
                        i8 = 65536;
                    }
                    i4 |= i8;
                }
            }
            i9 = i3 & 64;
            if (i9 != 0) {
                i4 |= 1572864;
                fM2665getCircularIndicatorTrackGapSizeD9Ej5fM = f2;
            } else {
                fM2665getCircularIndicatorTrackGapSizeD9Ej5fM = f2;
                if ((i2 & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(fM2665getCircularIndicatorTrackGapSizeD9Ej5fM)) {
                        i10 = 1048576;
                    } else {
                        i10 = 524288;
                    }
                    i4 |= i10;
                }
            }
            if ((i4 & 599187) == 599186) {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) != 0) {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i5 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 16) != 0) {
                        circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    } else {
                        circularDeterminateTrackColor = j3;
                    }
                    if (i7 != 0) {
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                    }
                    if (i9 != 0) {
                        fM2665getCircularIndicatorTrackGapSizeD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2665getCircularIndicatorTrackGapSizeD9Ej5fM();
                    }
                } else {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i5 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 16) != 0) {
                        circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    } else {
                        circularDeterminateTrackColor = j3;
                    }
                    if (i7 != 0) {
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                    }
                    if (i9 != 0) {
                        fM2665getCircularIndicatorTrackGapSizeD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2665getCircularIndicatorTrackGapSizeD9Ej5fM();
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1798883595, i4, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:580)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291619137, "CC(remember):ProgressIndicator.kt#9igjgp");
                if ((i4 & 14) == 4) {
                    z = true;
                } else {
                    z = false;
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z) {
                    objRememberedValue = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2694invoke() {
                            return Float.valueOf(RangesKt.coerceIn(((Number) function0.invoke()).floatValue(), 0.0f, 1.0f));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2694invoke() {
                            return Float.valueOf(RangesKt.coerceIn(((Number) function0.invoke()).floatValue(), 0.0f, 1.0f));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                function1 = (Function0) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ProvidableCompositionLocal<Density> localDensity2 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume2 = composerStartRestartGroup.consume(localDensity2);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                stroke = new Stroke(((Density) objConsume2).toPx-0680j_4(fM2666getCircularStrokeWidthD9Ej5fM), 0.0f, iM2663getCircularDeterminateStrokeCapKaPHkGw, 0, null, 26, null);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291612378, "CC(remember):ProgressIndicator.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(function1);
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue2 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SemanticsPropertyReceiver) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            SemanticsPropertiesKt.setProgressBarRangeInfo(semanticsPropertyReceiver, new ProgressBarRangeInfo(((Number) function1.invoke()).floatValue(), RangesKt.rangeTo(0.0f, 1.0f), 0, 4, null));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SemanticsPropertyReceiver) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            SemanticsPropertiesKt.setProgressBarRangeInfo(semanticsPropertyReceiver, new ProgressBarRangeInfo(((Number) function1.invoke()).floatValue(), RangesKt.rangeTo(0.0f, 1.0f), 0, 4, null));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierM1080size3ABfNKs2 = SizeKt.m1080size3ABfNKs(SemanticsModifierKt.semantics(modifier2, true, (Function1) objRememberedValue2), CircularIndicatorDiameter);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291606843, "CC(remember):ProgressIndicator.kt#9igjgp");
                boolean zChanged3 = composerStartRestartGroup.changed(function1);
                Modifier modifier5 = modifier2;
                if ((458752 & i4) == 131072) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                boolean z7 = zChanged3 | z2;
                if ((3670016 & i4) == 1048576) {
                    z3 = true;
                } else {
                    z3 = false;
                }
                boolean z8 = z7 | z3;
                if ((i4 & 7168) == 2048) {
                    z4 = true;
                } else {
                    z4 = false;
                }
                zChangedInstance = z8 | z4 | ((((57344 & i4) ^ 24576) <= 16384 && composerStartRestartGroup.changed(circularDeterminateTrackColor)) || (i4 & 24576) == 16384) | composerStartRestartGroup.changedInstance(stroke) | ((((i4 & 896) ^ 384) <= 256 && composerStartRestartGroup.changed(circularColor)) || (i4 & 384) == 256);
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!zChangedInstance) {
                    final int i16 = iM2663getCircularDeterminateStrokeCapKaPHkGw;
                    final float f7 = fM2665getCircularIndicatorTrackGapSizeD9Ej5fM;
                    final float f8 = fM2666getCircularStrokeWidthD9Ej5fM;
                    final long j8 = circularDeterminateTrackColor;
                    final long j9 = circularColor;
                    objRememberedValue3 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            float f9;
                            float fFloatValue = ((Number) function1.invoke()).floatValue() * 360.0f;
                            if (StrokeCap.m4959equalsimpl0(i16, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc()) > Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc())) {
                                f9 = f7;
                            } else {
                                f9 = Dp.constructor-impl(f7 + f8);
                            }
                            float f10 = (f9 / ((float) (((double) drawScope.toDp-u2uoSUM(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()))) * 3.141592653589793d))) * 360.0f;
                            ProgressIndicatorKt.m2688drawCircularIndicator42QJj7c(drawScope, 270.0f + fFloatValue + Math.min(fFloatValue, f10), (360.0f - fFloatValue) - (Math.min(fFloatValue, f10) * 2), j8, stroke);
                            ProgressIndicatorKt.m2690drawDeterminateCircularIndicator42QJj7c(drawScope, 270.0f, fFloatValue, j9, stroke);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    final int i17 = iM2663getCircularDeterminateStrokeCapKaPHkGw;
                    final float f9 = fM2665getCircularIndicatorTrackGapSizeD9Ej5fM;
                    final float f10 = fM2666getCircularStrokeWidthD9Ej5fM;
                    final long j10 = circularDeterminateTrackColor;
                    final long j11 = circularColor;
                    objRememberedValue3 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            float f11;
                            float fFloatValue = ((Number) function1.invoke()).floatValue() * 360.0f;
                            if (StrokeCap.m4959equalsimpl0(i17, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc()) > Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc())) {
                                f11 = f9;
                            } else {
                                f11 = Dp.constructor-impl(f9 + f10);
                            }
                            float f12 = (f11 / ((float) (((double) drawScope.toDp-u2uoSUM(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()))) * 3.141592653589793d))) * 360.0f;
                            ProgressIndicatorKt.m2688drawCircularIndicator42QJj7c(drawScope, 270.0f + fFloatValue + Math.min(fFloatValue, f12), (360.0f - fFloatValue) - (Math.min(fFloatValue, f12) * 2), j10, stroke);
                            ProgressIndicatorKt.m2690drawDeterminateCircularIndicator42QJj7c(drawScope, 270.0f, fFloatValue, j11, stroke);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CanvasKt.Canvas(modifierM1080size3ABfNKs2, (Function1) objRememberedValue3, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                j4 = circularColor;
                f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                f4 = fM2665getCircularIndicatorTrackGapSizeD9Ej5fM;
                modifier2 = modifier5;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) != 0) {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i5 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 16) != 0) {
                        circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    } else {
                        circularDeterminateTrackColor = j3;
                    }
                    if (i7 != 0) {
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                    }
                    if (i9 != 0) {
                        fM2665getCircularIndicatorTrackGapSizeD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2665getCircularIndicatorTrackGapSizeD9Ej5fM();
                    }
                } else {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i5 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 16) != 0) {
                        circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    } else {
                        circularDeterminateTrackColor = j3;
                    }
                    if (i7 != 0) {
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                    }
                    if (i9 != 0) {
                        fM2665getCircularIndicatorTrackGapSizeD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2665getCircularIndicatorTrackGapSizeD9Ej5fM();
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1798883595, i4, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:580)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291619137, "CC(remember):ProgressIndicator.kt#9igjgp");
                if ((i4 & 14) == 4) {
                    z = true;
                } else {
                    z = false;
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z) {
                    objRememberedValue = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2694invoke() {
                            return Float.valueOf(RangesKt.coerceIn(((Number) function0.invoke()).floatValue(), 0.0f, 1.0f));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2694invoke() {
                            return Float.valueOf(RangesKt.coerceIn(((Number) function0.invoke()).floatValue(), 0.0f, 1.0f));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                function1 = (Function0) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ProvidableCompositionLocal<Density> localDensity3 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume3 = composerStartRestartGroup.consume(localDensity3);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                stroke = new Stroke(((Density) objConsume3).toPx-0680j_4(fM2666getCircularStrokeWidthD9Ej5fM), 0.0f, iM2663getCircularDeterminateStrokeCapKaPHkGw, 0, null, 26, null);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291612378, "CC(remember):ProgressIndicator.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(function1);
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue2 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SemanticsPropertyReceiver) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            SemanticsPropertiesKt.setProgressBarRangeInfo(semanticsPropertyReceiver, new ProgressBarRangeInfo(((Number) function1.invoke()).floatValue(), RangesKt.rangeTo(0.0f, 1.0f), 0, 4, null));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SemanticsPropertyReceiver) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            SemanticsPropertiesKt.setProgressBarRangeInfo(semanticsPropertyReceiver, new ProgressBarRangeInfo(((Number) function1.invoke()).floatValue(), RangesKt.rangeTo(0.0f, 1.0f), 0, 4, null));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierM1080size3ABfNKs3 = SizeKt.m1080size3ABfNKs(SemanticsModifierKt.semantics(modifier2, true, (Function1) objRememberedValue2), CircularIndicatorDiameter);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291606843, "CC(remember):ProgressIndicator.kt#9igjgp");
                boolean zChanged4 = composerStartRestartGroup.changed(function1);
                Modifier modifier6 = modifier2;
                if ((458752 & i4) == 131072) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                boolean z9 = zChanged4 | z2;
                if ((3670016 & i4) == 1048576) {
                    z3 = true;
                } else {
                    z3 = false;
                }
                boolean z10 = z9 | z3;
                if ((i4 & 7168) == 2048) {
                    z4 = true;
                } else {
                    z4 = false;
                }
                zChangedInstance = z10 | z4 | ((((57344 & i4) ^ 24576) <= 16384 && composerStartRestartGroup.changed(circularDeterminateTrackColor)) || (i4 & 24576) == 16384) | composerStartRestartGroup.changedInstance(stroke) | ((((i4 & 896) ^ 384) <= 256 && composerStartRestartGroup.changed(circularColor)) || (i4 & 384) == 256);
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!zChangedInstance) {
                    final int i18 = iM2663getCircularDeterminateStrokeCapKaPHkGw;
                    final float f11 = fM2665getCircularIndicatorTrackGapSizeD9Ej5fM;
                    final float f12 = fM2666getCircularStrokeWidthD9Ej5fM;
                    final long j12 = circularDeterminateTrackColor;
                    final long j13 = circularColor;
                    objRememberedValue3 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            float f13;
                            float fFloatValue = ((Number) function1.invoke()).floatValue() * 360.0f;
                            if (StrokeCap.m4959equalsimpl0(i18, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc()) > Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc())) {
                                f13 = f11;
                            } else {
                                f13 = Dp.constructor-impl(f11 + f12);
                            }
                            float f14 = (f13 / ((float) (((double) drawScope.toDp-u2uoSUM(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()))) * 3.141592653589793d))) * 360.0f;
                            ProgressIndicatorKt.m2688drawCircularIndicator42QJj7c(drawScope, 270.0f + fFloatValue + Math.min(fFloatValue, f14), (360.0f - fFloatValue) - (Math.min(fFloatValue, f14) * 2), j12, stroke);
                            ProgressIndicatorKt.m2690drawDeterminateCircularIndicator42QJj7c(drawScope, 270.0f, fFloatValue, j13, stroke);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    final int i19 = iM2663getCircularDeterminateStrokeCapKaPHkGw;
                    final float f13 = fM2665getCircularIndicatorTrackGapSizeD9Ej5fM;
                    final float f14 = fM2666getCircularStrokeWidthD9Ej5fM;
                    final long j14 = circularDeterminateTrackColor;
                    final long j15 = circularColor;
                    objRememberedValue3 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            float f15;
                            float fFloatValue = ((Number) function1.invoke()).floatValue() * 360.0f;
                            if (StrokeCap.m4959equalsimpl0(i19, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc()) > Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc())) {
                                f15 = f13;
                            } else {
                                f15 = Dp.constructor-impl(f13 + f14);
                            }
                            float f16 = (f15 / ((float) (((double) drawScope.toDp-u2uoSUM(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()))) * 3.141592653589793d))) * 360.0f;
                            ProgressIndicatorKt.m2688drawCircularIndicator42QJj7c(drawScope, 270.0f + fFloatValue + Math.min(fFloatValue, f16), (360.0f - fFloatValue) - (Math.min(fFloatValue, f16) * 2), j14, stroke);
                            ProgressIndicatorKt.m2690drawDeterminateCircularIndicator42QJj7c(drawScope, 270.0f, fFloatValue, j15, stroke);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CanvasKt.Canvas(modifierM1080size3ABfNKs3, (Function1) objRememberedValue3, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                j4 = circularColor;
                f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                f4 = fM2665getCircularIndicatorTrackGapSizeD9Ej5fM;
                modifier2 = modifier6;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier7 = modifier2;
                final long j16 = circularDeterminateTrackColor;
                final int i110 = iM2663getCircularDeterminateStrokeCapKaPHkGw;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i111) {
                        ProgressIndicatorKt.m2672CircularProgressIndicatorIyT6zlY(function0, modifier7, j4, f3, j16, i110, f4, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                    }
                });
            }
        }
        i4 |= 48;
        modifier2 = modifier;
        if ((i2 & 384) == 0) {
            circularColor = j;
            if ((i3 & 4) == 0) {
                i12 = Fields.SpotShadowColor;
            } else {
                i12 = Fields.SpotShadowColor;
            }
            i4 |= i12;
        } else {
            circularColor = j;
        }
        i5 = i3 & 8;
        if (i5 != 0) {
            if ((i2 & 3072) == 0) {
                fM2666getCircularStrokeWidthD9Ej5fM = f;
                if (composerStartRestartGroup.changed(fM2666getCircularStrokeWidthD9Ej5fM)) {
                    i6 = Fields.CameraDistance;
                } else {
                    i6 = Fields.RotationZ;
                }
                i4 |= i6;
            }
            if ((i2 & 24576) == 0) {
                j3 = j2;
                if ((i3 & 16) == 0) {
                    i11 = Fields.Shape;
                } else {
                    i11 = Fields.Shape;
                }
                i4 |= i11;
            } else {
                j3 = j2;
            }
            i7 = i3 & 32;
            if (i7 != 0) {
                i4 |= 196608;
                iM2663getCircularDeterminateStrokeCapKaPHkGw = i;
            } else {
                iM2663getCircularDeterminateStrokeCapKaPHkGw = i;
                if ((i2 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(iM2663getCircularDeterminateStrokeCapKaPHkGw)) {
                        i8 = Fields.RenderEffect;
                    } else {
                        i8 = 65536;
                    }
                    i4 |= i8;
                }
            }
            i9 = i3 & 64;
            if (i9 != 0) {
                i4 |= 1572864;
                fM2665getCircularIndicatorTrackGapSizeD9Ej5fM = f2;
            } else {
                fM2665getCircularIndicatorTrackGapSizeD9Ej5fM = f2;
                if ((i2 & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(fM2665getCircularIndicatorTrackGapSizeD9Ej5fM)) {
                        i10 = 1048576;
                    } else {
                        i10 = 524288;
                    }
                    i4 |= i10;
                }
            }
            if ((i4 & 599187) == 599186) {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) != 0) {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i5 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 16) != 0) {
                        circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    } else {
                        circularDeterminateTrackColor = j3;
                    }
                    if (i7 != 0) {
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                    }
                    if (i9 != 0) {
                        fM2665getCircularIndicatorTrackGapSizeD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2665getCircularIndicatorTrackGapSizeD9Ej5fM();
                    }
                } else {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i5 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 16) != 0) {
                        circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    } else {
                        circularDeterminateTrackColor = j3;
                    }
                    if (i7 != 0) {
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                    }
                    if (i9 != 0) {
                        fM2665getCircularIndicatorTrackGapSizeD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2665getCircularIndicatorTrackGapSizeD9Ej5fM();
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1798883595, i4, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:580)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291619137, "CC(remember):ProgressIndicator.kt#9igjgp");
                if ((i4 & 14) == 4) {
                    z = true;
                } else {
                    z = false;
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z) {
                    objRememberedValue = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2694invoke() {
                            return Float.valueOf(RangesKt.coerceIn(((Number) function0.invoke()).floatValue(), 0.0f, 1.0f));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2694invoke() {
                            return Float.valueOf(RangesKt.coerceIn(((Number) function0.invoke()).floatValue(), 0.0f, 1.0f));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                function1 = (Function0) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ProvidableCompositionLocal<Density> localDensity4 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume4 = composerStartRestartGroup.consume(localDensity4);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                stroke = new Stroke(((Density) objConsume4).toPx-0680j_4(fM2666getCircularStrokeWidthD9Ej5fM), 0.0f, iM2663getCircularDeterminateStrokeCapKaPHkGw, 0, null, 26, null);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291612378, "CC(remember):ProgressIndicator.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(function1);
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue2 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SemanticsPropertyReceiver) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            SemanticsPropertiesKt.setProgressBarRangeInfo(semanticsPropertyReceiver, new ProgressBarRangeInfo(((Number) function1.invoke()).floatValue(), RangesKt.rangeTo(0.0f, 1.0f), 0, 4, null));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SemanticsPropertyReceiver) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            SemanticsPropertiesKt.setProgressBarRangeInfo(semanticsPropertyReceiver, new ProgressBarRangeInfo(((Number) function1.invoke()).floatValue(), RangesKt.rangeTo(0.0f, 1.0f), 0, 4, null));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierM1080size3ABfNKs4 = SizeKt.m1080size3ABfNKs(SemanticsModifierKt.semantics(modifier2, true, (Function1) objRememberedValue2), CircularIndicatorDiameter);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291606843, "CC(remember):ProgressIndicator.kt#9igjgp");
                boolean zChanged5 = composerStartRestartGroup.changed(function1);
                Modifier modifier8 = modifier2;
                if ((458752 & i4) == 131072) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                boolean z11 = zChanged5 | z2;
                if ((3670016 & i4) == 1048576) {
                    z3 = true;
                } else {
                    z3 = false;
                }
                boolean z12 = z11 | z3;
                if ((i4 & 7168) == 2048) {
                    z4 = true;
                } else {
                    z4 = false;
                }
                zChangedInstance = z12 | z4 | ((((57344 & i4) ^ 24576) <= 16384 && composerStartRestartGroup.changed(circularDeterminateTrackColor)) || (i4 & 24576) == 16384) | composerStartRestartGroup.changedInstance(stroke) | ((((i4 & 896) ^ 384) <= 256 && composerStartRestartGroup.changed(circularColor)) || (i4 & 384) == 256);
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!zChangedInstance) {
                    final int i111 = iM2663getCircularDeterminateStrokeCapKaPHkGw;
                    final float f15 = fM2665getCircularIndicatorTrackGapSizeD9Ej5fM;
                    final float f16 = fM2666getCircularStrokeWidthD9Ej5fM;
                    final long j17 = circularDeterminateTrackColor;
                    final long j18 = circularColor;
                    objRememberedValue3 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            float f17;
                            float fFloatValue = ((Number) function1.invoke()).floatValue() * 360.0f;
                            if (StrokeCap.m4959equalsimpl0(i111, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc()) > Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc())) {
                                f17 = f15;
                            } else {
                                f17 = Dp.constructor-impl(f15 + f16);
                            }
                            float f18 = (f17 / ((float) (((double) drawScope.toDp-u2uoSUM(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()))) * 3.141592653589793d))) * 360.0f;
                            ProgressIndicatorKt.m2688drawCircularIndicator42QJj7c(drawScope, 270.0f + fFloatValue + Math.min(fFloatValue, f18), (360.0f - fFloatValue) - (Math.min(fFloatValue, f18) * 2), j17, stroke);
                            ProgressIndicatorKt.m2690drawDeterminateCircularIndicator42QJj7c(drawScope, 270.0f, fFloatValue, j18, stroke);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    final int i112 = iM2663getCircularDeterminateStrokeCapKaPHkGw;
                    final float f17 = fM2665getCircularIndicatorTrackGapSizeD9Ej5fM;
                    final float f18 = fM2666getCircularStrokeWidthD9Ej5fM;
                    final long j19 = circularDeterminateTrackColor;
                    final long j110 = circularColor;
                    objRememberedValue3 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            float f19;
                            float fFloatValue = ((Number) function1.invoke()).floatValue() * 360.0f;
                            if (StrokeCap.m4959equalsimpl0(i112, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc()) > Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc())) {
                                f19 = f17;
                            } else {
                                f19 = Dp.constructor-impl(f17 + f18);
                            }
                            float f110 = (f19 / ((float) (((double) drawScope.toDp-u2uoSUM(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()))) * 3.141592653589793d))) * 360.0f;
                            ProgressIndicatorKt.m2688drawCircularIndicator42QJj7c(drawScope, 270.0f + fFloatValue + Math.min(fFloatValue, f110), (360.0f - fFloatValue) - (Math.min(fFloatValue, f110) * 2), j19, stroke);
                            ProgressIndicatorKt.m2690drawDeterminateCircularIndicator42QJj7c(drawScope, 270.0f, fFloatValue, j110, stroke);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CanvasKt.Canvas(modifierM1080size3ABfNKs4, (Function1) objRememberedValue3, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                j4 = circularColor;
                f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                f4 = fM2665getCircularIndicatorTrackGapSizeD9Ej5fM;
                modifier2 = modifier8;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) != 0) {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i5 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 16) != 0) {
                        circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    } else {
                        circularDeterminateTrackColor = j3;
                    }
                    if (i7 != 0) {
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                    }
                    if (i9 != 0) {
                        fM2665getCircularIndicatorTrackGapSizeD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2665getCircularIndicatorTrackGapSizeD9Ej5fM();
                    }
                } else {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i5 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 16) != 0) {
                        circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    } else {
                        circularDeterminateTrackColor = j3;
                    }
                    if (i7 != 0) {
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                    }
                    if (i9 != 0) {
                        fM2665getCircularIndicatorTrackGapSizeD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2665getCircularIndicatorTrackGapSizeD9Ej5fM();
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1798883595, i4, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:580)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291619137, "CC(remember):ProgressIndicator.kt#9igjgp");
                if ((i4 & 14) == 4) {
                    z = true;
                } else {
                    z = false;
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z) {
                    objRememberedValue = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2694invoke() {
                            return Float.valueOf(RangesKt.coerceIn(((Number) function0.invoke()).floatValue(), 0.0f, 1.0f));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2694invoke() {
                            return Float.valueOf(RangesKt.coerceIn(((Number) function0.invoke()).floatValue(), 0.0f, 1.0f));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                function1 = (Function0) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ProvidableCompositionLocal<Density> localDensity5 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume5 = composerStartRestartGroup.consume(localDensity5);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                stroke = new Stroke(((Density) objConsume5).toPx-0680j_4(fM2666getCircularStrokeWidthD9Ej5fM), 0.0f, iM2663getCircularDeterminateStrokeCapKaPHkGw, 0, null, 26, null);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291612378, "CC(remember):ProgressIndicator.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(function1);
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue2 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SemanticsPropertyReceiver) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            SemanticsPropertiesKt.setProgressBarRangeInfo(semanticsPropertyReceiver, new ProgressBarRangeInfo(((Number) function1.invoke()).floatValue(), RangesKt.rangeTo(0.0f, 1.0f), 0, 4, null));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SemanticsPropertyReceiver) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            SemanticsPropertiesKt.setProgressBarRangeInfo(semanticsPropertyReceiver, new ProgressBarRangeInfo(((Number) function1.invoke()).floatValue(), RangesKt.rangeTo(0.0f, 1.0f), 0, 4, null));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifierM1080size3ABfNKs5 = SizeKt.m1080size3ABfNKs(SemanticsModifierKt.semantics(modifier2, true, (Function1) objRememberedValue2), CircularIndicatorDiameter);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291606843, "CC(remember):ProgressIndicator.kt#9igjgp");
                boolean zChanged6 = composerStartRestartGroup.changed(function1);
                Modifier modifier9 = modifier2;
                if ((458752 & i4) == 131072) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                boolean z13 = zChanged6 | z2;
                if ((3670016 & i4) == 1048576) {
                    z3 = true;
                } else {
                    z3 = false;
                }
                boolean z14 = z13 | z3;
                if ((i4 & 7168) == 2048) {
                    z4 = true;
                } else {
                    z4 = false;
                }
                zChangedInstance = z14 | z4 | ((((57344 & i4) ^ 24576) <= 16384 && composerStartRestartGroup.changed(circularDeterminateTrackColor)) || (i4 & 24576) == 16384) | composerStartRestartGroup.changedInstance(stroke) | ((((i4 & 896) ^ 384) <= 256 && composerStartRestartGroup.changed(circularColor)) || (i4 & 384) == 256);
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!zChangedInstance) {
                    final int i113 = iM2663getCircularDeterminateStrokeCapKaPHkGw;
                    final float f19 = fM2665getCircularIndicatorTrackGapSizeD9Ej5fM;
                    final float f110 = fM2666getCircularStrokeWidthD9Ej5fM;
                    final long j111 = circularDeterminateTrackColor;
                    final long j112 = circularColor;
                    objRememberedValue3 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            float f111;
                            float fFloatValue = ((Number) function1.invoke()).floatValue() * 360.0f;
                            if (StrokeCap.m4959equalsimpl0(i113, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc()) > Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc())) {
                                f111 = f19;
                            } else {
                                f111 = Dp.constructor-impl(f19 + f110);
                            }
                            float f112 = (f111 / ((float) (((double) drawScope.toDp-u2uoSUM(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()))) * 3.141592653589793d))) * 360.0f;
                            ProgressIndicatorKt.m2688drawCircularIndicator42QJj7c(drawScope, 270.0f + fFloatValue + Math.min(fFloatValue, f112), (360.0f - fFloatValue) - (Math.min(fFloatValue, f112) * 2), j111, stroke);
                            ProgressIndicatorKt.m2690drawDeterminateCircularIndicator42QJj7c(drawScope, 270.0f, fFloatValue, j112, stroke);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    final int i114 = iM2663getCircularDeterminateStrokeCapKaPHkGw;
                    final float f111 = fM2665getCircularIndicatorTrackGapSizeD9Ej5fM;
                    final float f112 = fM2666getCircularStrokeWidthD9Ej5fM;
                    final long j113 = circularDeterminateTrackColor;
                    final long j114 = circularColor;
                    objRememberedValue3 = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            float f113;
                            float fFloatValue = ((Number) function1.invoke()).floatValue() * 360.0f;
                            if (StrokeCap.m4959equalsimpl0(i114, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc()) > Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc())) {
                                f113 = f111;
                            } else {
                                f113 = Dp.constructor-impl(f111 + f112);
                            }
                            float f114 = (f113 / ((float) (((double) drawScope.toDp-u2uoSUM(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()))) * 3.141592653589793d))) * 360.0f;
                            ProgressIndicatorKt.m2688drawCircularIndicator42QJj7c(drawScope, 270.0f + fFloatValue + Math.min(fFloatValue, f114), (360.0f - fFloatValue) - (Math.min(fFloatValue, f114) * 2), j113, stroke);
                            ProgressIndicatorKt.m2690drawDeterminateCircularIndicator42QJj7c(drawScope, 270.0f, fFloatValue, j114, stroke);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CanvasKt.Canvas(modifierM1080size3ABfNKs5, (Function1) objRememberedValue3, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                j4 = circularColor;
                f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                f4 = fM2665getCircularIndicatorTrackGapSizeD9Ej5fM;
                modifier2 = modifier9;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier10 = modifier2;
                final long j115 = circularDeterminateTrackColor;
                final int i115 = iM2663getCircularDeterminateStrokeCapKaPHkGw;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i116) {
                        ProgressIndicatorKt.m2672CircularProgressIndicatorIyT6zlY(function0, modifier10, j4, f3, j115, i115, f4, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                    }
                });
            }
        }
        i4 |= 3072;
        fM2666getCircularStrokeWidthD9Ej5fM = f;
        if ((i2 & 24576) == 0) {
            j3 = j2;
            if ((i3 & 16) == 0) {
                i11 = Fields.Shape;
            } else {
                i11 = Fields.Shape;
            }
            i4 |= i11;
        } else {
            j3 = j2;
        }
        i7 = i3 & 32;
        if (i7 != 0) {
            i4 |= 196608;
            iM2663getCircularDeterminateStrokeCapKaPHkGw = i;
        } else {
            iM2663getCircularDeterminateStrokeCapKaPHkGw = i;
            if ((i2 & 196608) == 0) {
                if (composerStartRestartGroup.changed(iM2663getCircularDeterminateStrokeCapKaPHkGw)) {
                    i8 = Fields.RenderEffect;
                } else {
                    i8 = 65536;
                }
                i4 |= i8;
            }
        }
        i9 = i3 & 64;
        if (i9 != 0) {
            i4 |= 1572864;
            fM2665getCircularIndicatorTrackGapSizeD9Ej5fM = f2;
        } else {
            fM2665getCircularIndicatorTrackGapSizeD9Ej5fM = f2;
            if ((i2 & 1572864) == 0) {
                if (composerStartRestartGroup.changed(fM2665getCircularIndicatorTrackGapSizeD9Ej5fM)) {
                    i10 = 1048576;
                } else {
                    i10 = 524288;
                }
                i4 |= i10;
            }
        }
        if ((i4 & 599187) == 599186) {
            composerStartRestartGroup.startDefaults();
            if ((i2 & 1) != 0) {
                if (i13 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if ((i3 & 4) != 0) {
                    circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                    i4 &= -897;
                }
                if (i5 != 0) {
                    fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                }
                if ((i3 & 16) != 0) {
                    circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                    i4 &= -57345;
                } else {
                    circularDeterminateTrackColor = j3;
                }
                if (i7 != 0) {
                    iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                }
                if (i9 != 0) {
                    fM2665getCircularIndicatorTrackGapSizeD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2665getCircularIndicatorTrackGapSizeD9Ej5fM();
                }
            } else {
                if (i13 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if ((i3 & 4) != 0) {
                    circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                    i4 &= -897;
                }
                if (i5 != 0) {
                    fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                }
                if ((i3 & 16) != 0) {
                    circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                    i4 &= -57345;
                } else {
                    circularDeterminateTrackColor = j3;
                }
                if (i7 != 0) {
                    iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                }
                if (i9 != 0) {
                    fM2665getCircularIndicatorTrackGapSizeD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2665getCircularIndicatorTrackGapSizeD9Ej5fM();
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1798883595, i4, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:580)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291619137, "CC(remember):ProgressIndicator.kt#9igjgp");
            if ((i4 & 14) == 4) {
                z = true;
            } else {
                z = false;
            }
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (!z) {
                objRememberedValue = (Function0) new Function0<Float>() {
                    {
                        super(0);
                    }

                    public final Float m2694invoke() {
                        return Float.valueOf(RangesKt.coerceIn(((Number) function0.invoke()).floatValue(), 0.0f, 1.0f));
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = (Function0) new Function0<Float>() {
                    {
                        super(0);
                    }

                    public final Float m2694invoke() {
                        return Float.valueOf(RangesKt.coerceIn(((Number) function0.invoke()).floatValue(), 0.0f, 1.0f));
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            function1 = (Function0) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ProvidableCompositionLocal<Density> localDensity6 = CompositionLocalsKt.getLocalDensity();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume6 = composerStartRestartGroup.consume(localDensity6);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            stroke = new Stroke(((Density) objConsume6).toPx-0680j_4(fM2666getCircularStrokeWidthD9Ej5fM), 0.0f, iM2663getCircularDeterminateStrokeCapKaPHkGw, 0, null, 26, null);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291612378, "CC(remember):ProgressIndicator.kt#9igjgp");
            zChanged = composerStartRestartGroup.changed(function1);
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (!zChanged) {
                objRememberedValue2 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((SemanticsPropertyReceiver) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                        SemanticsPropertiesKt.setProgressBarRangeInfo(semanticsPropertyReceiver, new ProgressBarRangeInfo(((Number) function1.invoke()).floatValue(), RangesKt.rangeTo(0.0f, 1.0f), 0, 4, null));
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            } else {
                objRememberedValue2 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((SemanticsPropertyReceiver) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                        SemanticsPropertiesKt.setProgressBarRangeInfo(semanticsPropertyReceiver, new ProgressBarRangeInfo(((Number) function1.invoke()).floatValue(), RangesKt.rangeTo(0.0f, 1.0f), 0, 4, null));
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            Modifier modifierM1080size3ABfNKs6 = SizeKt.m1080size3ABfNKs(SemanticsModifierKt.semantics(modifier2, true, (Function1) objRememberedValue2), CircularIndicatorDiameter);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291606843, "CC(remember):ProgressIndicator.kt#9igjgp");
            boolean zChanged7 = composerStartRestartGroup.changed(function1);
            Modifier modifier11 = modifier2;
            if ((458752 & i4) == 131072) {
                z2 = true;
            } else {
                z2 = false;
            }
            boolean z15 = zChanged7 | z2;
            if ((3670016 & i4) == 1048576) {
                z3 = true;
            } else {
                z3 = false;
            }
            boolean z16 = z15 | z3;
            if ((i4 & 7168) == 2048) {
                z4 = true;
            } else {
                z4 = false;
            }
            zChangedInstance = z16 | z4 | ((((57344 & i4) ^ 24576) <= 16384 && composerStartRestartGroup.changed(circularDeterminateTrackColor)) || (i4 & 24576) == 16384) | composerStartRestartGroup.changedInstance(stroke) | ((((i4 & 896) ^ 384) <= 256 && composerStartRestartGroup.changed(circularColor)) || (i4 & 384) == 256);
            objRememberedValue3 = composerStartRestartGroup.rememberedValue();
            if (!zChangedInstance) {
                final int i116 = iM2663getCircularDeterminateStrokeCapKaPHkGw;
                final float f113 = fM2665getCircularIndicatorTrackGapSizeD9Ej5fM;
                final float f114 = fM2666getCircularStrokeWidthD9Ej5fM;
                final long j116 = circularDeterminateTrackColor;
                final long j117 = circularColor;
                objRememberedValue3 = (Function1) new Function1<DrawScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((DrawScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(DrawScope drawScope) {
                        float f115;
                        float fFloatValue = ((Number) function1.invoke()).floatValue() * 360.0f;
                        if (StrokeCap.m4959equalsimpl0(i116, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc()) > Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc())) {
                            f115 = f113;
                        } else {
                            f115 = Dp.constructor-impl(f113 + f114);
                        }
                        float f116 = (f115 / ((float) (((double) drawScope.toDp-u2uoSUM(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()))) * 3.141592653589793d))) * 360.0f;
                        ProgressIndicatorKt.m2688drawCircularIndicator42QJj7c(drawScope, 270.0f + fFloatValue + Math.min(fFloatValue, f116), (360.0f - fFloatValue) - (Math.min(fFloatValue, f116) * 2), j116, stroke);
                        ProgressIndicatorKt.m2690drawDeterminateCircularIndicator42QJj7c(drawScope, 270.0f, fFloatValue, j117, stroke);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
            } else {
                final int i117 = iM2663getCircularDeterminateStrokeCapKaPHkGw;
                final float f115 = fM2665getCircularIndicatorTrackGapSizeD9Ej5fM;
                final float f116 = fM2666getCircularStrokeWidthD9Ej5fM;
                final long j118 = circularDeterminateTrackColor;
                final long j119 = circularColor;
                objRememberedValue3 = (Function1) new Function1<DrawScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((DrawScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(DrawScope drawScope) {
                        float f117;
                        float fFloatValue = ((Number) function1.invoke()).floatValue() * 360.0f;
                        if (StrokeCap.m4959equalsimpl0(i117, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc()) > Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc())) {
                            f117 = f115;
                        } else {
                            f117 = Dp.constructor-impl(f115 + f116);
                        }
                        float f118 = (f117 / ((float) (((double) drawScope.toDp-u2uoSUM(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()))) * 3.141592653589793d))) * 360.0f;
                        ProgressIndicatorKt.m2688drawCircularIndicator42QJj7c(drawScope, 270.0f + fFloatValue + Math.min(fFloatValue, f118), (360.0f - fFloatValue) - (Math.min(fFloatValue, f118) * 2), j118, stroke);
                        ProgressIndicatorKt.m2690drawDeterminateCircularIndicator42QJj7c(drawScope, 270.0f, fFloatValue, j119, stroke);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            CanvasKt.Canvas(modifierM1080size3ABfNKs6, (Function1) objRememberedValue3, composerStartRestartGroup, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            j4 = circularColor;
            f3 = fM2666getCircularStrokeWidthD9Ej5fM;
            f4 = fM2665getCircularIndicatorTrackGapSizeD9Ej5fM;
            modifier2 = modifier11;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i2 & 1) != 0) {
                if (i13 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if ((i3 & 4) != 0) {
                    circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                    i4 &= -897;
                }
                if (i5 != 0) {
                    fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                }
                if ((i3 & 16) != 0) {
                    circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                    i4 &= -57345;
                } else {
                    circularDeterminateTrackColor = j3;
                }
                if (i7 != 0) {
                    iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                }
                if (i9 != 0) {
                    fM2665getCircularIndicatorTrackGapSizeD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2665getCircularIndicatorTrackGapSizeD9Ej5fM();
                }
            } else {
                if (i13 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if ((i3 & 4) != 0) {
                    circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                    i4 &= -897;
                }
                if (i5 != 0) {
                    fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                }
                if ((i3 & 16) != 0) {
                    circularDeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularDeterminateTrackColor(composerStartRestartGroup, 6);
                    i4 &= -57345;
                } else {
                    circularDeterminateTrackColor = j3;
                }
                if (i7 != 0) {
                    iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                }
                if (i9 != 0) {
                    fM2665getCircularIndicatorTrackGapSizeD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2665getCircularIndicatorTrackGapSizeD9Ej5fM();
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1798883595, i4, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:580)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291619137, "CC(remember):ProgressIndicator.kt#9igjgp");
            if ((i4 & 14) == 4) {
                z = true;
            } else {
                z = false;
            }
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (!z) {
                objRememberedValue = (Function0) new Function0<Float>() {
                    {
                        super(0);
                    }

                    public final Float m2694invoke() {
                        return Float.valueOf(RangesKt.coerceIn(((Number) function0.invoke()).floatValue(), 0.0f, 1.0f));
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = (Function0) new Function0<Float>() {
                    {
                        super(0);
                    }

                    public final Float m2694invoke() {
                        return Float.valueOf(RangesKt.coerceIn(((Number) function0.invoke()).floatValue(), 0.0f, 1.0f));
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            function1 = (Function0) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ProvidableCompositionLocal<Density> localDensity7 = CompositionLocalsKt.getLocalDensity();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume7 = composerStartRestartGroup.consume(localDensity7);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            stroke = new Stroke(((Density) objConsume7).toPx-0680j_4(fM2666getCircularStrokeWidthD9Ej5fM), 0.0f, iM2663getCircularDeterminateStrokeCapKaPHkGw, 0, null, 26, null);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291612378, "CC(remember):ProgressIndicator.kt#9igjgp");
            zChanged = composerStartRestartGroup.changed(function1);
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (!zChanged) {
                objRememberedValue2 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((SemanticsPropertyReceiver) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                        SemanticsPropertiesKt.setProgressBarRangeInfo(semanticsPropertyReceiver, new ProgressBarRangeInfo(((Number) function1.invoke()).floatValue(), RangesKt.rangeTo(0.0f, 1.0f), 0, 4, null));
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            } else {
                objRememberedValue2 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((SemanticsPropertyReceiver) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                        SemanticsPropertiesKt.setProgressBarRangeInfo(semanticsPropertyReceiver, new ProgressBarRangeInfo(((Number) function1.invoke()).floatValue(), RangesKt.rangeTo(0.0f, 1.0f), 0, 4, null));
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            Modifier modifierM1080size3ABfNKs7 = SizeKt.m1080size3ABfNKs(SemanticsModifierKt.semantics(modifier2, true, (Function1) objRememberedValue2), CircularIndicatorDiameter);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291606843, "CC(remember):ProgressIndicator.kt#9igjgp");
            boolean zChanged8 = composerStartRestartGroup.changed(function1);
            Modifier modifier12 = modifier2;
            if ((458752 & i4) == 131072) {
                z2 = true;
            } else {
                z2 = false;
            }
            boolean z17 = zChanged8 | z2;
            if ((3670016 & i4) == 1048576) {
                z3 = true;
            } else {
                z3 = false;
            }
            boolean z18 = z17 | z3;
            if ((i4 & 7168) == 2048) {
                z4 = true;
            } else {
                z4 = false;
            }
            zChangedInstance = z18 | z4 | ((((57344 & i4) ^ 24576) <= 16384 && composerStartRestartGroup.changed(circularDeterminateTrackColor)) || (i4 & 24576) == 16384) | composerStartRestartGroup.changedInstance(stroke) | ((((i4 & 896) ^ 384) <= 256 && composerStartRestartGroup.changed(circularColor)) || (i4 & 384) == 256);
            objRememberedValue3 = composerStartRestartGroup.rememberedValue();
            if (!zChangedInstance) {
                final int i118 = iM2663getCircularDeterminateStrokeCapKaPHkGw;
                final float f117 = fM2665getCircularIndicatorTrackGapSizeD9Ej5fM;
                final float f118 = fM2666getCircularStrokeWidthD9Ej5fM;
                final long j1110 = circularDeterminateTrackColor;
                final long j1111 = circularColor;
                objRememberedValue3 = (Function1) new Function1<DrawScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((DrawScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(DrawScope drawScope) {
                        float f119;
                        float fFloatValue = ((Number) function1.invoke()).floatValue() * 360.0f;
                        if (StrokeCap.m4959equalsimpl0(i118, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc()) > Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc())) {
                            f119 = f117;
                        } else {
                            f119 = Dp.constructor-impl(f117 + f118);
                        }
                        float f1110 = (f119 / ((float) (((double) drawScope.toDp-u2uoSUM(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()))) * 3.141592653589793d))) * 360.0f;
                        ProgressIndicatorKt.m2688drawCircularIndicator42QJj7c(drawScope, 270.0f + fFloatValue + Math.min(fFloatValue, f1110), (360.0f - fFloatValue) - (Math.min(fFloatValue, f1110) * 2), j1110, stroke);
                        ProgressIndicatorKt.m2690drawDeterminateCircularIndicator42QJj7c(drawScope, 270.0f, fFloatValue, j1111, stroke);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
            } else {
                final int i119 = iM2663getCircularDeterminateStrokeCapKaPHkGw;
                final float f119 = fM2665getCircularIndicatorTrackGapSizeD9Ej5fM;
                final float f1110 = fM2666getCircularStrokeWidthD9Ej5fM;
                final long j1112 = circularDeterminateTrackColor;
                final long j1113 = circularColor;
                objRememberedValue3 = (Function1) new Function1<DrawScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((DrawScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(DrawScope drawScope) {
                        float f1111;
                        float fFloatValue = ((Number) function1.invoke()).floatValue() * 360.0f;
                        if (StrokeCap.m4959equalsimpl0(i119, StrokeCap.INSTANCE.m4963getButtKaPHkGw()) || Size.m4412getHeightimpl(drawScope.mo5083getSizeNHjbRc()) > Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc())) {
                            f1111 = f119;
                        } else {
                            f1111 = Dp.constructor-impl(f119 + f1110);
                        }
                        float f1112 = (f1111 / ((float) (((double) drawScope.toDp-u2uoSUM(Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()))) * 3.141592653589793d))) * 360.0f;
                        ProgressIndicatorKt.m2688drawCircularIndicator42QJj7c(drawScope, 270.0f + fFloatValue + Math.min(fFloatValue, f1112), (360.0f - fFloatValue) - (Math.min(fFloatValue, f1112) * 2), j1112, stroke);
                        ProgressIndicatorKt.m2690drawDeterminateCircularIndicator42QJj7c(drawScope, 270.0f, fFloatValue, j1113, stroke);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            CanvasKt.Canvas(modifierM1080size3ABfNKs7, (Function1) objRememberedValue3, composerStartRestartGroup, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            j4 = circularColor;
            f3 = fM2666getCircularStrokeWidthD9Ej5fM;
            f4 = fM2665getCircularIndicatorTrackGapSizeD9Ej5fM;
            modifier2 = modifier12;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier13 = modifier2;
            final long j1114 = circularDeterminateTrackColor;
            final int i1110 = iM2663getCircularDeterminateStrokeCapKaPHkGw;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i1111) {
                    ProgressIndicatorKt.m2672CircularProgressIndicatorIyT6zlY(function0, modifier13, j4, f3, j1114, i1110, f4, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                }
            });
        }
    }

    public static final void m2673CircularProgressIndicatorLxG7B9w(Modifier modifier, long j, float f, long j2, int i, Composer composer, final int i2, final int i3) {
        Modifier modifier2;
        int i4;
        long circularColor;
        float fM2666getCircularStrokeWidthD9Ej5fM;
        final long j3;
        int i5;
        int i6;
        int i7;
        Modifier.Companion companion;
        long circularIndeterminateTrackColor;
        int i8;
        long j4;
        float f2;
        int iM2664getCircularIndeterminateStrokeCapKaPHkGw;
        long j5;
        final Stroke stroke;
        int i9;
        final State stateAnimateValue;
        final State<Float> stateAnimateFloat;
        final State<Float> stateAnimateFloat2;
        final State<Float> stateAnimateFloat3;
        Modifier modifier3;
        int i10;
        boolean z;
        boolean z2;
        boolean z3;
        Object objRememberedValue;
        final int i11;
        final long j6;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i12;
        Composer composerStartRestartGroup = composer.startRestartGroup(-115871647);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(CircularProgressIndicator)P(1,0:c#ui.graphics.Color,3:c#ui.unit.Dp,4:c#ui.graphics.Color,2:c#ui.graphics.StrokeCap)633@26429L13,635@26563L31,*638@26720L7,640@26807L28,643@26972L350,657@27444L208,666@27777L422,679@28240L431,691@28745L628,691@28676L697:ProgressIndicator.kt#uh7d8r");
        int i13 = i3 & 1;
        if (i13 != 0) {
            i4 = i2 | 6;
            modifier2 = modifier;
        } else if ((i2 & 6) == 0) {
            modifier2 = modifier;
            i4 = (composerStartRestartGroup.changed(modifier2) ? 4 : 2) | i2;
        } else {
            modifier2 = modifier;
            i4 = i2;
        }
        if ((i2 & 48) == 0) {
            circularColor = j;
            i4 |= ((i3 & 2) == 0 && composerStartRestartGroup.changed(circularColor)) ? 32 : 16;
        } else {
            circularColor = j;
        }
        int i14 = i3 & 4;
        if (i14 == 0) {
            if ((i2 & 384) == 0) {
                fM2666getCircularStrokeWidthD9Ej5fM = f;
                i4 |= composerStartRestartGroup.changed(fM2666getCircularStrokeWidthD9Ej5fM) ? Fields.RotationX : Fields.SpotShadowColor;
            }
            if ((i2 & 3072) == 0) {
                if ((i3 & 8) == 0) {
                    j3 = j2;
                    if (composerStartRestartGroup.changed(j3)) {
                        i12 = Fields.CameraDistance;
                    }
                    i4 |= i12;
                } else {
                    j3 = j2;
                }
                i12 = Fields.RotationZ;
                i4 |= i12;
            } else {
                j3 = j2;
            }
            i5 = i3 & 16;
            if (i5 != 0) {
                if ((i2 & 24576) == 0) {
                    i6 = i;
                    if (composerStartRestartGroup.changed(i6)) {
                        i7 = Fields.Clip;
                    } else {
                        i7 = Fields.Shape;
                    }
                    i4 |= i7;
                }
                if ((i4 & 9363) == 9362 || !composerStartRestartGroup.getSkipping()) {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) == 0 && !composerStartRestartGroup.getDefaultsInvalid()) {
                        composerStartRestartGroup.skipToGroupEnd();
                        if ((i3 & 2) != 0) {
                            i4 &= -113;
                        }
                        if ((i3 & 8) != 0) {
                            i4 &= -7169;
                        }
                        companion = modifier2;
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        iM2664getCircularIndeterminateStrokeCapKaPHkGw = i6;
                        j5 = j3;
                        i8 = i4;
                    } else {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 2) != 0) {
                            circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                            i4 &= -113;
                        }
                        if (i14 != 0) {
                            fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                        }
                        if ((i3 & 8) != 0) {
                            circularIndeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularIndeterminateTrackColor(composerStartRestartGroup, 6);
                            i4 &= -7169;
                        } else {
                            circularIndeterminateTrackColor = j3;
                        }
                        if (i5 != 0) {
                            i8 = i4;
                            j5 = circularIndeterminateTrackColor;
                            f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                            iM2664getCircularIndeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2664getCircularIndeterminateStrokeCapKaPHkGw();
                        } else {
                            i8 = i4;
                            j4 = circularColor;
                            long j7 = circularIndeterminateTrackColor;
                            f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                            iM2664getCircularIndeterminateStrokeCapKaPHkGw = i6;
                            j5 = j7;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-115871647, i8, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:637)");
                        }
                        ProvidableCompositionLocal<Density> localDensity = CompositionLocalsKt.getLocalDensity();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume = composerStartRestartGroup.consume(localDensity);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        stroke = new Stroke(((Density) objConsume).toPx-0680j_4(f2), 0.0f, iM2664getCircularIndeterminateStrokeCapKaPHkGw, 0, null, 26, null);
                        InfiniteTransition infiniteTransitionRememberInfiniteTransition = InfiniteTransitionKt.rememberInfiniteTransition(null, composerStartRestartGroup, 0, 1);
                        boolean z4 = true;
                        i9 = i8;
                        stateAnimateValue = InfiniteTransitionKt.animateValue(infiniteTransitionRememberInfiniteTransition, 0, 5, VectorConvertersKt.getVectorConverter(IntCompanionObject.INSTANCE), AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.tween$default(6660, 0, EasingKt.getLinearEasing(), 2, null), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 12), 16);
                        stateAnimateFloat = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition, 0.0f, BaseRotationAngle, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.tween$default(RotationDuration, 0, EasingKt.getLinearEasing(), 2, null), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
                        stateAnimateFloat2 = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition, 0.0f, JumpRotationAngle, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                            public Object invoke(Object obj) {
                                invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                                keyframesSpecConfig.setDurationMillis(1332);
                                keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 0), ProgressIndicatorKt.CircularEasing);
                                keyframesSpecConfig.mo80at(Float.valueOf(290.0f), 666);
                            }
                        }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
                        stateAnimateFloat3 = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition, 0.0f, JumpRotationAngle, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                            public Object invoke(Object obj) {
                                invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                                keyframesSpecConfig.setDurationMillis(1332);
                                keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 666), ProgressIndicatorKt.CircularEasing);
                                keyframesSpecConfig.mo80at(Float.valueOf(290.0f), keyframesSpecConfig.getDurationMillis());
                            }
                        }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
                        Modifier modifierM1080size3ABfNKs = SizeKt.m1080size3ABfNKs(ProgressSemanticsKt.progressSemantics(companion), CircularIndicatorDiameter);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291474284, "CC(remember):ProgressIndicator.kt#9igjgp");
                        j3 = j5;
                        if (((i9 & 7168) ^ 3072) > 2048 || !composerStartRestartGroup.changed(j3)) {
                            modifier3 = companion;
                            i10 = i9;
                            if ((i10 & 3072) != 2048) {
                                z = false;
                            }
                            boolean zChangedInstance = z | composerStartRestartGroup.changedInstance(r29) | composerStartRestartGroup.changed(stateAnimateValue) | composerStartRestartGroup.changed(stateAnimateFloat2) | composerStartRestartGroup.changed(stateAnimateFloat3) | composerStartRestartGroup.changed(stateAnimateFloat);
                            int i15 = iM2664getCircularIndeterminateStrokeCapKaPHkGw;
                            if ((i10 & 896) == 256) {
                                z2 = true;
                            } else {
                                z2 = false;
                            }
                            boolean z5 = zChangedInstance | z2;
                            if ((((i10 & 112) ^ 48) > 32 || !composerStartRestartGroup.changed(j4)) && (i10 & 48) != 32) {
                            }
                            z3 = z5 | z4;
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z3 || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                final float f3 = f2;
                                final long j8 = j4;
                                objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((DrawScope) obj);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(DrawScope drawScope) {
                                        ProgressIndicatorKt.m2689drawCircularIndicatorTrackbw27NRU(drawScope, j3, stroke);
                                        ProgressIndicatorKt.m2691drawIndeterminateCircularIndicatorhrjfTZI(drawScope, stateAnimateFloat3.getValue().floatValue() + (((stateAnimateValue.getValue().floatValue() * 216.0f) % 360.0f) - 90.0f) + stateAnimateFloat.getValue().floatValue(), f3, Math.abs(stateAnimateFloat2.getValue().floatValue() - stateAnimateFloat3.getValue().floatValue()), j8, stroke);
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            CanvasKt.Canvas(modifierM1080size3ABfNKs, (Function1) objRememberedValue, composerStartRestartGroup, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            i11 = i15;
                            j6 = j4;
                            modifier2 = modifier3;
                        } else {
                            modifier3 = companion;
                            i10 = i9;
                        }
                        z = true;
                        boolean zChangedInstance2 = z | composerStartRestartGroup.changedInstance(r29) | composerStartRestartGroup.changed(stateAnimateValue) | composerStartRestartGroup.changed(stateAnimateFloat2) | composerStartRestartGroup.changed(stateAnimateFloat3) | composerStartRestartGroup.changed(stateAnimateFloat);
                        int i16 = iM2664getCircularIndeterminateStrokeCapKaPHkGw;
                        if ((i10 & 896) == 256) {
                            z2 = true;
                        } else {
                            z2 = false;
                        }
                        boolean z6 = zChangedInstance2 | z2;
                        z4 = ((i10 & 112) ^ 48) > 32 ? false : false;
                        z3 = z6 | z4;
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z3) {
                            final float f4 = f2;
                            final long j9 = j4;
                            objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    ProgressIndicatorKt.m2689drawCircularIndicatorTrackbw27NRU(drawScope, j3, stroke);
                                    ProgressIndicatorKt.m2691drawIndeterminateCircularIndicatorhrjfTZI(drawScope, stateAnimateFloat3.getValue().floatValue() + (((stateAnimateValue.getValue().floatValue() * 216.0f) % 360.0f) - 90.0f) + stateAnimateFloat.getValue().floatValue(), f4, Math.abs(stateAnimateFloat2.getValue().floatValue() - stateAnimateFloat3.getValue().floatValue()), j9, stroke);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            final float f5 = f2;
                            final long j10 = j4;
                            objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((DrawScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(DrawScope drawScope) {
                                    ProgressIndicatorKt.m2689drawCircularIndicatorTrackbw27NRU(drawScope, j3, stroke);
                                    ProgressIndicatorKt.m2691drawIndeterminateCircularIndicatorhrjfTZI(drawScope, stateAnimateFloat3.getValue().floatValue() + (((stateAnimateValue.getValue().floatValue() * 216.0f) % 360.0f) - 90.0f) + stateAnimateFloat.getValue().floatValue(), f5, Math.abs(stateAnimateFloat2.getValue().floatValue() - stateAnimateFloat3.getValue().floatValue()), j10, stroke);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CanvasKt.Canvas(modifierM1080size3ABfNKs, (Function1) objRememberedValue, composerStartRestartGroup, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        i11 = i16;
                        j6 = j4;
                        modifier2 = modifier3;
                    }
                    j4 = circularColor;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-115871647, i8, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:637)");
                    }
                    ProvidableCompositionLocal<Density> localDensity2 = CompositionLocalsKt.getLocalDensity();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume2 = composerStartRestartGroup.consume(localDensity2);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    stroke = new Stroke(((Density) objConsume2).toPx-0680j_4(f2), 0.0f, iM2664getCircularIndeterminateStrokeCapKaPHkGw, 0, null, 26, null);
                    InfiniteTransition infiniteTransitionRememberInfiniteTransition2 = InfiniteTransitionKt.rememberInfiniteTransition(null, composerStartRestartGroup, 0, 1);
                    boolean z7 = true;
                    i9 = i8;
                    stateAnimateValue = InfiniteTransitionKt.animateValue(infiniteTransitionRememberInfiniteTransition2, 0, 5, VectorConvertersKt.getVectorConverter(IntCompanionObject.INSTANCE), AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.tween$default(6660, 0, EasingKt.getLinearEasing(), 2, null), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 12), 16);
                    stateAnimateFloat = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition2, 0.0f, BaseRotationAngle, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.tween$default(RotationDuration, 0, EasingKt.getLinearEasing(), 2, null), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
                    stateAnimateFloat2 = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition2, 0.0f, JumpRotationAngle, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                        public Object invoke(Object obj) {
                            invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                            keyframesSpecConfig.setDurationMillis(1332);
                            keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 0), ProgressIndicatorKt.CircularEasing);
                            keyframesSpecConfig.mo80at(Float.valueOf(290.0f), 666);
                        }
                    }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
                    stateAnimateFloat3 = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition2, 0.0f, JumpRotationAngle, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                        public Object invoke(Object obj) {
                            invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                            keyframesSpecConfig.setDurationMillis(1332);
                            keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 666), ProgressIndicatorKt.CircularEasing);
                            keyframesSpecConfig.mo80at(Float.valueOf(290.0f), keyframesSpecConfig.getDurationMillis());
                        }
                    }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
                    Modifier modifierM1080size3ABfNKs2 = SizeKt.m1080size3ABfNKs(ProgressSemanticsKt.progressSemantics(companion), CircularIndicatorDiameter);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291474284, "CC(remember):ProgressIndicator.kt#9igjgp");
                    j3 = j5;
                    if (((i9 & 7168) ^ 3072) > 2048) {
                        modifier3 = companion;
                        i10 = i9;
                        if ((i10 & 3072) != 2048) {
                            z = true;
                        } else {
                            z = false;
                        }
                    } else {
                        modifier3 = companion;
                        i10 = i9;
                        if ((i10 & 3072) != 2048) {
                            z = true;
                        } else {
                            z = false;
                        }
                    }
                    boolean zChangedInstance3 = z | composerStartRestartGroup.changedInstance(r29) | composerStartRestartGroup.changed(stateAnimateValue) | composerStartRestartGroup.changed(stateAnimateFloat2) | composerStartRestartGroup.changed(stateAnimateFloat3) | composerStartRestartGroup.changed(stateAnimateFloat);
                    int i17 = iM2664getCircularIndeterminateStrokeCapKaPHkGw;
                    if ((i10 & 896) == 256) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    boolean z8 = zChangedInstance3 | z2;
                    if (((i10 & 112) ^ 48) > 32) {
                    }
                    z3 = z8 | z7;
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z3) {
                        final float f6 = f2;
                        final long j11 = j4;
                        objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                ProgressIndicatorKt.m2689drawCircularIndicatorTrackbw27NRU(drawScope, j3, stroke);
                                ProgressIndicatorKt.m2691drawIndeterminateCircularIndicatorhrjfTZI(drawScope, stateAnimateFloat3.getValue().floatValue() + (((stateAnimateValue.getValue().floatValue() * 216.0f) % 360.0f) - 90.0f) + stateAnimateFloat.getValue().floatValue(), f6, Math.abs(stateAnimateFloat2.getValue().floatValue() - stateAnimateFloat3.getValue().floatValue()), j11, stroke);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        final float f7 = f2;
                        final long j12 = j4;
                        objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((DrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(DrawScope drawScope) {
                                ProgressIndicatorKt.m2689drawCircularIndicatorTrackbw27NRU(drawScope, j3, stroke);
                                ProgressIndicatorKt.m2691drawIndeterminateCircularIndicatorhrjfTZI(drawScope, stateAnimateFloat3.getValue().floatValue() + (((stateAnimateValue.getValue().floatValue() * 216.0f) % 360.0f) - 90.0f) + stateAnimateFloat.getValue().floatValue(), f7, Math.abs(stateAnimateFloat2.getValue().floatValue() - stateAnimateFloat3.getValue().floatValue()), j12, stroke);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CanvasKt.Canvas(modifierM1080size3ABfNKs2, (Function1) objRememberedValue, composerStartRestartGroup, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    i11 = i17;
                    j6 = j4;
                    modifier2 = modifier3;
                } else {
                    composerStartRestartGroup.skipToGroupEnd();
                    j6 = circularColor;
                    f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                    i11 = i6;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier4 = modifier2;
                    final float f8 = f2;
                    final long j13 = j3;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i18) {
                            ProgressIndicatorKt.m2673CircularProgressIndicatorLxG7B9w(modifier4, j6, f8, j13, i11, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                        }
                    });
                }
            }
            i4 |= 24576;
            i6 = i;
            if ((i4 & 9363) == 9362) {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) == 0) {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 2) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -113;
                    }
                    if (i14 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 8) != 0) {
                        circularIndeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularIndeterminateTrackColor(composerStartRestartGroup, 6);
                        i4 &= -7169;
                    } else {
                        circularIndeterminateTrackColor = j3;
                    }
                    if (i5 != 0) {
                        i8 = i4;
                        j5 = circularIndeterminateTrackColor;
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        iM2664getCircularIndeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2664getCircularIndeterminateStrokeCapKaPHkGw();
                        j4 = circularColor;
                    } else {
                        i8 = i4;
                        j4 = circularColor;
                        long j14 = circularIndeterminateTrackColor;
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        iM2664getCircularIndeterminateStrokeCapKaPHkGw = i6;
                        j5 = j14;
                    }
                } else {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 2) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -113;
                    }
                    if (i14 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 8) != 0) {
                        circularIndeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularIndeterminateTrackColor(composerStartRestartGroup, 6);
                        i4 &= -7169;
                    } else {
                        circularIndeterminateTrackColor = j3;
                    }
                    if (i5 != 0) {
                        i8 = i4;
                        j5 = circularIndeterminateTrackColor;
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        iM2664getCircularIndeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2664getCircularIndeterminateStrokeCapKaPHkGw();
                        j4 = circularColor;
                    } else {
                        i8 = i4;
                        j4 = circularColor;
                        long j15 = circularIndeterminateTrackColor;
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        iM2664getCircularIndeterminateStrokeCapKaPHkGw = i6;
                        j5 = j15;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-115871647, i8, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:637)");
                }
                ProvidableCompositionLocal<Density> localDensity3 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume3 = composerStartRestartGroup.consume(localDensity3);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                stroke = new Stroke(((Density) objConsume3).toPx-0680j_4(f2), 0.0f, iM2664getCircularIndeterminateStrokeCapKaPHkGw, 0, null, 26, null);
                InfiniteTransition infiniteTransitionRememberInfiniteTransition3 = InfiniteTransitionKt.rememberInfiniteTransition(null, composerStartRestartGroup, 0, 1);
                boolean z9 = true;
                i9 = i8;
                stateAnimateValue = InfiniteTransitionKt.animateValue(infiniteTransitionRememberInfiniteTransition3, 0, 5, VectorConvertersKt.getVectorConverter(IntCompanionObject.INSTANCE), AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.tween$default(6660, 0, EasingKt.getLinearEasing(), 2, null), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 12), 16);
                stateAnimateFloat = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition3, 0.0f, BaseRotationAngle, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.tween$default(RotationDuration, 0, EasingKt.getLinearEasing(), 2, null), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
                stateAnimateFloat2 = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition3, 0.0f, JumpRotationAngle, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                    public Object invoke(Object obj) {
                        invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                        keyframesSpecConfig.setDurationMillis(1332);
                        keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 0), ProgressIndicatorKt.CircularEasing);
                        keyframesSpecConfig.mo80at(Float.valueOf(290.0f), 666);
                    }
                }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
                stateAnimateFloat3 = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition3, 0.0f, JumpRotationAngle, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                    public Object invoke(Object obj) {
                        invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                        keyframesSpecConfig.setDurationMillis(1332);
                        keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 666), ProgressIndicatorKt.CircularEasing);
                        keyframesSpecConfig.mo80at(Float.valueOf(290.0f), keyframesSpecConfig.getDurationMillis());
                    }
                }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
                Modifier modifierM1080size3ABfNKs3 = SizeKt.m1080size3ABfNKs(ProgressSemanticsKt.progressSemantics(companion), CircularIndicatorDiameter);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291474284, "CC(remember):ProgressIndicator.kt#9igjgp");
                j3 = j5;
                if (((i9 & 7168) ^ 3072) > 2048) {
                    modifier3 = companion;
                    i10 = i9;
                    if ((i10 & 3072) != 2048) {
                        z = true;
                    } else {
                        z = false;
                    }
                } else {
                    modifier3 = companion;
                    i10 = i9;
                    if ((i10 & 3072) != 2048) {
                        z = true;
                    } else {
                        z = false;
                    }
                }
                boolean zChangedInstance4 = z | composerStartRestartGroup.changedInstance(r29) | composerStartRestartGroup.changed(stateAnimateValue) | composerStartRestartGroup.changed(stateAnimateFloat2) | composerStartRestartGroup.changed(stateAnimateFloat3) | composerStartRestartGroup.changed(stateAnimateFloat);
                int i18 = iM2664getCircularIndeterminateStrokeCapKaPHkGw;
                if ((i10 & 896) == 256) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                boolean z10 = zChangedInstance4 | z2;
                if (((i10 & 112) ^ 48) > 32) {
                }
                z3 = z10 | z9;
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z3) {
                    final float f9 = f2;
                    final long j16 = j4;
                    objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            ProgressIndicatorKt.m2689drawCircularIndicatorTrackbw27NRU(drawScope, j3, stroke);
                            ProgressIndicatorKt.m2691drawIndeterminateCircularIndicatorhrjfTZI(drawScope, stateAnimateFloat3.getValue().floatValue() + (((stateAnimateValue.getValue().floatValue() * 216.0f) % 360.0f) - 90.0f) + stateAnimateFloat.getValue().floatValue(), f9, Math.abs(stateAnimateFloat2.getValue().floatValue() - stateAnimateFloat3.getValue().floatValue()), j16, stroke);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    final float f10 = f2;
                    final long j17 = j4;
                    objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            ProgressIndicatorKt.m2689drawCircularIndicatorTrackbw27NRU(drawScope, j3, stroke);
                            ProgressIndicatorKt.m2691drawIndeterminateCircularIndicatorhrjfTZI(drawScope, stateAnimateFloat3.getValue().floatValue() + (((stateAnimateValue.getValue().floatValue() * 216.0f) % 360.0f) - 90.0f) + stateAnimateFloat.getValue().floatValue(), f10, Math.abs(stateAnimateFloat2.getValue().floatValue() - stateAnimateFloat3.getValue().floatValue()), j17, stroke);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CanvasKt.Canvas(modifierM1080size3ABfNKs3, (Function1) objRememberedValue, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                i11 = i18;
                j6 = j4;
                modifier2 = modifier3;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) == 0) {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 2) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -113;
                    }
                    if (i14 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 8) != 0) {
                        circularIndeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularIndeterminateTrackColor(composerStartRestartGroup, 6);
                        i4 &= -7169;
                    } else {
                        circularIndeterminateTrackColor = j3;
                    }
                    if (i5 != 0) {
                        i8 = i4;
                        j5 = circularIndeterminateTrackColor;
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        iM2664getCircularIndeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2664getCircularIndeterminateStrokeCapKaPHkGw();
                        j4 = circularColor;
                    } else {
                        i8 = i4;
                        j4 = circularColor;
                        long j18 = circularIndeterminateTrackColor;
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        iM2664getCircularIndeterminateStrokeCapKaPHkGw = i6;
                        j5 = j18;
                    }
                } else {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 2) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -113;
                    }
                    if (i14 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 8) != 0) {
                        circularIndeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularIndeterminateTrackColor(composerStartRestartGroup, 6);
                        i4 &= -7169;
                    } else {
                        circularIndeterminateTrackColor = j3;
                    }
                    if (i5 != 0) {
                        i8 = i4;
                        j5 = circularIndeterminateTrackColor;
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        iM2664getCircularIndeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2664getCircularIndeterminateStrokeCapKaPHkGw();
                        j4 = circularColor;
                    } else {
                        i8 = i4;
                        j4 = circularColor;
                        long j19 = circularIndeterminateTrackColor;
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        iM2664getCircularIndeterminateStrokeCapKaPHkGw = i6;
                        j5 = j19;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-115871647, i8, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:637)");
                }
                ProvidableCompositionLocal<Density> localDensity4 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume4 = composerStartRestartGroup.consume(localDensity4);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                stroke = new Stroke(((Density) objConsume4).toPx-0680j_4(f2), 0.0f, iM2664getCircularIndeterminateStrokeCapKaPHkGw, 0, null, 26, null);
                InfiniteTransition infiniteTransitionRememberInfiniteTransition4 = InfiniteTransitionKt.rememberInfiniteTransition(null, composerStartRestartGroup, 0, 1);
                boolean z11 = true;
                i9 = i8;
                stateAnimateValue = InfiniteTransitionKt.animateValue(infiniteTransitionRememberInfiniteTransition4, 0, 5, VectorConvertersKt.getVectorConverter(IntCompanionObject.INSTANCE), AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.tween$default(6660, 0, EasingKt.getLinearEasing(), 2, null), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 12), 16);
                stateAnimateFloat = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition4, 0.0f, BaseRotationAngle, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.tween$default(RotationDuration, 0, EasingKt.getLinearEasing(), 2, null), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
                stateAnimateFloat2 = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition4, 0.0f, JumpRotationAngle, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                    public Object invoke(Object obj) {
                        invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                        keyframesSpecConfig.setDurationMillis(1332);
                        keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 0), ProgressIndicatorKt.CircularEasing);
                        keyframesSpecConfig.mo80at(Float.valueOf(290.0f), 666);
                    }
                }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
                stateAnimateFloat3 = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition4, 0.0f, JumpRotationAngle, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                    public Object invoke(Object obj) {
                        invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                        keyframesSpecConfig.setDurationMillis(1332);
                        keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 666), ProgressIndicatorKt.CircularEasing);
                        keyframesSpecConfig.mo80at(Float.valueOf(290.0f), keyframesSpecConfig.getDurationMillis());
                    }
                }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
                Modifier modifierM1080size3ABfNKs4 = SizeKt.m1080size3ABfNKs(ProgressSemanticsKt.progressSemantics(companion), CircularIndicatorDiameter);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291474284, "CC(remember):ProgressIndicator.kt#9igjgp");
                j3 = j5;
                if (((i9 & 7168) ^ 3072) > 2048) {
                    modifier3 = companion;
                    i10 = i9;
                    if ((i10 & 3072) != 2048) {
                        z = true;
                    } else {
                        z = false;
                    }
                } else {
                    modifier3 = companion;
                    i10 = i9;
                    if ((i10 & 3072) != 2048) {
                        z = true;
                    } else {
                        z = false;
                    }
                }
                boolean zChangedInstance5 = z | composerStartRestartGroup.changedInstance(r29) | composerStartRestartGroup.changed(stateAnimateValue) | composerStartRestartGroup.changed(stateAnimateFloat2) | composerStartRestartGroup.changed(stateAnimateFloat3) | composerStartRestartGroup.changed(stateAnimateFloat);
                int i19 = iM2664getCircularIndeterminateStrokeCapKaPHkGw;
                if ((i10 & 896) == 256) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                boolean z12 = zChangedInstance5 | z2;
                if (((i10 & 112) ^ 48) > 32) {
                }
                z3 = z12 | z11;
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z3) {
                    final float f11 = f2;
                    final long j110 = j4;
                    objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            ProgressIndicatorKt.m2689drawCircularIndicatorTrackbw27NRU(drawScope, j3, stroke);
                            ProgressIndicatorKt.m2691drawIndeterminateCircularIndicatorhrjfTZI(drawScope, stateAnimateFloat3.getValue().floatValue() + (((stateAnimateValue.getValue().floatValue() * 216.0f) % 360.0f) - 90.0f) + stateAnimateFloat.getValue().floatValue(), f11, Math.abs(stateAnimateFloat2.getValue().floatValue() - stateAnimateFloat3.getValue().floatValue()), j110, stroke);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    final float f12 = f2;
                    final long j111 = j4;
                    objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            ProgressIndicatorKt.m2689drawCircularIndicatorTrackbw27NRU(drawScope, j3, stroke);
                            ProgressIndicatorKt.m2691drawIndeterminateCircularIndicatorhrjfTZI(drawScope, stateAnimateFloat3.getValue().floatValue() + (((stateAnimateValue.getValue().floatValue() * 216.0f) % 360.0f) - 90.0f) + stateAnimateFloat.getValue().floatValue(), f12, Math.abs(stateAnimateFloat2.getValue().floatValue() - stateAnimateFloat3.getValue().floatValue()), j111, stroke);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CanvasKt.Canvas(modifierM1080size3ABfNKs4, (Function1) objRememberedValue, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                i11 = i19;
                j6 = j4;
                modifier2 = modifier3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier5 = modifier2;
                final float f13 = f2;
                final long j112 = j3;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i110) {
                        ProgressIndicatorKt.m2673CircularProgressIndicatorLxG7B9w(modifier5, j6, f13, j112, i11, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                    }
                });
            }
        }
        i4 |= 384;
        fM2666getCircularStrokeWidthD9Ej5fM = f;
        if ((i2 & 3072) == 0) {
            if ((i3 & 8) == 0) {
                j3 = j2;
                if (composerStartRestartGroup.changed(j3)) {
                    i12 = Fields.CameraDistance;
                }
                i4 |= i12;
            } else {
                j3 = j2;
            }
            i12 = Fields.RotationZ;
            i4 |= i12;
        } else {
            j3 = j2;
        }
        i5 = i3 & 16;
        if (i5 != 0) {
            if ((i2 & 24576) == 0) {
                i6 = i;
                if (composerStartRestartGroup.changed(i6)) {
                    i7 = Fields.Clip;
                } else {
                    i7 = Fields.Shape;
                }
                i4 |= i7;
            }
            if ((i4 & 9363) == 9362) {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) == 0) {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 2) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -113;
                    }
                    if (i14 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 8) != 0) {
                        circularIndeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularIndeterminateTrackColor(composerStartRestartGroup, 6);
                        i4 &= -7169;
                    } else {
                        circularIndeterminateTrackColor = j3;
                    }
                    if (i5 != 0) {
                        i8 = i4;
                        j5 = circularIndeterminateTrackColor;
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        iM2664getCircularIndeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2664getCircularIndeterminateStrokeCapKaPHkGw();
                        j4 = circularColor;
                    } else {
                        i8 = i4;
                        j4 = circularColor;
                        long j113 = circularIndeterminateTrackColor;
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        iM2664getCircularIndeterminateStrokeCapKaPHkGw = i6;
                        j5 = j113;
                    }
                } else {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 2) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -113;
                    }
                    if (i14 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 8) != 0) {
                        circularIndeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularIndeterminateTrackColor(composerStartRestartGroup, 6);
                        i4 &= -7169;
                    } else {
                        circularIndeterminateTrackColor = j3;
                    }
                    if (i5 != 0) {
                        i8 = i4;
                        j5 = circularIndeterminateTrackColor;
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        iM2664getCircularIndeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2664getCircularIndeterminateStrokeCapKaPHkGw();
                        j4 = circularColor;
                    } else {
                        i8 = i4;
                        j4 = circularColor;
                        long j114 = circularIndeterminateTrackColor;
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        iM2664getCircularIndeterminateStrokeCapKaPHkGw = i6;
                        j5 = j114;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-115871647, i8, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:637)");
                }
                ProvidableCompositionLocal<Density> localDensity5 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume5 = composerStartRestartGroup.consume(localDensity5);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                stroke = new Stroke(((Density) objConsume5).toPx-0680j_4(f2), 0.0f, iM2664getCircularIndeterminateStrokeCapKaPHkGw, 0, null, 26, null);
                InfiniteTransition infiniteTransitionRememberInfiniteTransition5 = InfiniteTransitionKt.rememberInfiniteTransition(null, composerStartRestartGroup, 0, 1);
                boolean z13 = true;
                i9 = i8;
                stateAnimateValue = InfiniteTransitionKt.animateValue(infiniteTransitionRememberInfiniteTransition5, 0, 5, VectorConvertersKt.getVectorConverter(IntCompanionObject.INSTANCE), AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.tween$default(6660, 0, EasingKt.getLinearEasing(), 2, null), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 12), 16);
                stateAnimateFloat = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition5, 0.0f, BaseRotationAngle, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.tween$default(RotationDuration, 0, EasingKt.getLinearEasing(), 2, null), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
                stateAnimateFloat2 = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition5, 0.0f, JumpRotationAngle, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                    public Object invoke(Object obj) {
                        invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                        keyframesSpecConfig.setDurationMillis(1332);
                        keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 0), ProgressIndicatorKt.CircularEasing);
                        keyframesSpecConfig.mo80at(Float.valueOf(290.0f), 666);
                    }
                }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
                stateAnimateFloat3 = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition5, 0.0f, JumpRotationAngle, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                    public Object invoke(Object obj) {
                        invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                        keyframesSpecConfig.setDurationMillis(1332);
                        keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 666), ProgressIndicatorKt.CircularEasing);
                        keyframesSpecConfig.mo80at(Float.valueOf(290.0f), keyframesSpecConfig.getDurationMillis());
                    }
                }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
                Modifier modifierM1080size3ABfNKs5 = SizeKt.m1080size3ABfNKs(ProgressSemanticsKt.progressSemantics(companion), CircularIndicatorDiameter);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291474284, "CC(remember):ProgressIndicator.kt#9igjgp");
                j3 = j5;
                if (((i9 & 7168) ^ 3072) > 2048) {
                    modifier3 = companion;
                    i10 = i9;
                    if ((i10 & 3072) != 2048) {
                        z = true;
                    } else {
                        z = false;
                    }
                } else {
                    modifier3 = companion;
                    i10 = i9;
                    if ((i10 & 3072) != 2048) {
                        z = true;
                    } else {
                        z = false;
                    }
                }
                boolean zChangedInstance6 = z | composerStartRestartGroup.changedInstance(r29) | composerStartRestartGroup.changed(stateAnimateValue) | composerStartRestartGroup.changed(stateAnimateFloat2) | composerStartRestartGroup.changed(stateAnimateFloat3) | composerStartRestartGroup.changed(stateAnimateFloat);
                int i110 = iM2664getCircularIndeterminateStrokeCapKaPHkGw;
                if ((i10 & 896) == 256) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                boolean z14 = zChangedInstance6 | z2;
                if (((i10 & 112) ^ 48) > 32) {
                }
                z3 = z14 | z13;
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z3) {
                    final float f14 = f2;
                    final long j115 = j4;
                    objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            ProgressIndicatorKt.m2689drawCircularIndicatorTrackbw27NRU(drawScope, j3, stroke);
                            ProgressIndicatorKt.m2691drawIndeterminateCircularIndicatorhrjfTZI(drawScope, stateAnimateFloat3.getValue().floatValue() + (((stateAnimateValue.getValue().floatValue() * 216.0f) % 360.0f) - 90.0f) + stateAnimateFloat.getValue().floatValue(), f14, Math.abs(stateAnimateFloat2.getValue().floatValue() - stateAnimateFloat3.getValue().floatValue()), j115, stroke);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    final float f15 = f2;
                    final long j116 = j4;
                    objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            ProgressIndicatorKt.m2689drawCircularIndicatorTrackbw27NRU(drawScope, j3, stroke);
                            ProgressIndicatorKt.m2691drawIndeterminateCircularIndicatorhrjfTZI(drawScope, stateAnimateFloat3.getValue().floatValue() + (((stateAnimateValue.getValue().floatValue() * 216.0f) % 360.0f) - 90.0f) + stateAnimateFloat.getValue().floatValue(), f15, Math.abs(stateAnimateFloat2.getValue().floatValue() - stateAnimateFloat3.getValue().floatValue()), j116, stroke);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CanvasKt.Canvas(modifierM1080size3ABfNKs5, (Function1) objRememberedValue, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                i11 = i110;
                j6 = j4;
                modifier2 = modifier3;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) == 0) {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 2) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -113;
                    }
                    if (i14 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 8) != 0) {
                        circularIndeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularIndeterminateTrackColor(composerStartRestartGroup, 6);
                        i4 &= -7169;
                    } else {
                        circularIndeterminateTrackColor = j3;
                    }
                    if (i5 != 0) {
                        i8 = i4;
                        j5 = circularIndeterminateTrackColor;
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        iM2664getCircularIndeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2664getCircularIndeterminateStrokeCapKaPHkGw();
                        j4 = circularColor;
                    } else {
                        i8 = i4;
                        j4 = circularColor;
                        long j117 = circularIndeterminateTrackColor;
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        iM2664getCircularIndeterminateStrokeCapKaPHkGw = i6;
                        j5 = j117;
                    }
                } else {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 2) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -113;
                    }
                    if (i14 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 8) != 0) {
                        circularIndeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularIndeterminateTrackColor(composerStartRestartGroup, 6);
                        i4 &= -7169;
                    } else {
                        circularIndeterminateTrackColor = j3;
                    }
                    if (i5 != 0) {
                        i8 = i4;
                        j5 = circularIndeterminateTrackColor;
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        iM2664getCircularIndeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2664getCircularIndeterminateStrokeCapKaPHkGw();
                        j4 = circularColor;
                    } else {
                        i8 = i4;
                        j4 = circularColor;
                        long j118 = circularIndeterminateTrackColor;
                        f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                        iM2664getCircularIndeterminateStrokeCapKaPHkGw = i6;
                        j5 = j118;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-115871647, i8, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:637)");
                }
                ProvidableCompositionLocal<Density> localDensity6 = CompositionLocalsKt.getLocalDensity();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume6 = composerStartRestartGroup.consume(localDensity6);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                stroke = new Stroke(((Density) objConsume6).toPx-0680j_4(f2), 0.0f, iM2664getCircularIndeterminateStrokeCapKaPHkGw, 0, null, 26, null);
                InfiniteTransition infiniteTransitionRememberInfiniteTransition6 = InfiniteTransitionKt.rememberInfiniteTransition(null, composerStartRestartGroup, 0, 1);
                boolean z15 = true;
                i9 = i8;
                stateAnimateValue = InfiniteTransitionKt.animateValue(infiniteTransitionRememberInfiniteTransition6, 0, 5, VectorConvertersKt.getVectorConverter(IntCompanionObject.INSTANCE), AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.tween$default(6660, 0, EasingKt.getLinearEasing(), 2, null), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 12), 16);
                stateAnimateFloat = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition6, 0.0f, BaseRotationAngle, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.tween$default(RotationDuration, 0, EasingKt.getLinearEasing(), 2, null), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
                stateAnimateFloat2 = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition6, 0.0f, JumpRotationAngle, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                    public Object invoke(Object obj) {
                        invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                        keyframesSpecConfig.setDurationMillis(1332);
                        keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 0), ProgressIndicatorKt.CircularEasing);
                        keyframesSpecConfig.mo80at(Float.valueOf(290.0f), 666);
                    }
                }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
                stateAnimateFloat3 = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition6, 0.0f, JumpRotationAngle, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                    public Object invoke(Object obj) {
                        invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                        keyframesSpecConfig.setDurationMillis(1332);
                        keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 666), ProgressIndicatorKt.CircularEasing);
                        keyframesSpecConfig.mo80at(Float.valueOf(290.0f), keyframesSpecConfig.getDurationMillis());
                    }
                }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
                Modifier modifierM1080size3ABfNKs6 = SizeKt.m1080size3ABfNKs(ProgressSemanticsKt.progressSemantics(companion), CircularIndicatorDiameter);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291474284, "CC(remember):ProgressIndicator.kt#9igjgp");
                j3 = j5;
                if (((i9 & 7168) ^ 3072) > 2048) {
                    modifier3 = companion;
                    i10 = i9;
                    if ((i10 & 3072) != 2048) {
                        z = true;
                    } else {
                        z = false;
                    }
                } else {
                    modifier3 = companion;
                    i10 = i9;
                    if ((i10 & 3072) != 2048) {
                        z = true;
                    } else {
                        z = false;
                    }
                }
                boolean zChangedInstance7 = z | composerStartRestartGroup.changedInstance(r29) | composerStartRestartGroup.changed(stateAnimateValue) | composerStartRestartGroup.changed(stateAnimateFloat2) | composerStartRestartGroup.changed(stateAnimateFloat3) | composerStartRestartGroup.changed(stateAnimateFloat);
                int i111 = iM2664getCircularIndeterminateStrokeCapKaPHkGw;
                if ((i10 & 896) == 256) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                boolean z16 = zChangedInstance7 | z2;
                if (((i10 & 112) ^ 48) > 32) {
                }
                z3 = z16 | z15;
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z3) {
                    final float f16 = f2;
                    final long j119 = j4;
                    objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            ProgressIndicatorKt.m2689drawCircularIndicatorTrackbw27NRU(drawScope, j3, stroke);
                            ProgressIndicatorKt.m2691drawIndeterminateCircularIndicatorhrjfTZI(drawScope, stateAnimateFloat3.getValue().floatValue() + (((stateAnimateValue.getValue().floatValue() * 216.0f) % 360.0f) - 90.0f) + stateAnimateFloat.getValue().floatValue(), f16, Math.abs(stateAnimateFloat2.getValue().floatValue() - stateAnimateFloat3.getValue().floatValue()), j119, stroke);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    final float f17 = f2;
                    final long j1110 = j4;
                    objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((DrawScope) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(DrawScope drawScope) {
                            ProgressIndicatorKt.m2689drawCircularIndicatorTrackbw27NRU(drawScope, j3, stroke);
                            ProgressIndicatorKt.m2691drawIndeterminateCircularIndicatorhrjfTZI(drawScope, stateAnimateFloat3.getValue().floatValue() + (((stateAnimateValue.getValue().floatValue() * 216.0f) % 360.0f) - 90.0f) + stateAnimateFloat.getValue().floatValue(), f17, Math.abs(stateAnimateFloat2.getValue().floatValue() - stateAnimateFloat3.getValue().floatValue()), j1110, stroke);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CanvasKt.Canvas(modifierM1080size3ABfNKs6, (Function1) objRememberedValue, composerStartRestartGroup, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                i11 = i111;
                j6 = j4;
                modifier2 = modifier3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier6 = modifier2;
                final float f18 = f2;
                final long j1111 = j3;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i112) {
                        ProgressIndicatorKt.m2673CircularProgressIndicatorLxG7B9w(modifier6, j6, f18, j1111, i11, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                    }
                });
            }
        }
        i4 |= 24576;
        i6 = i;
        if ((i4 & 9363) == 9362) {
            composerStartRestartGroup.startDefaults();
            if ((i2 & 1) == 0) {
                if (i13 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i3 & 2) != 0) {
                    circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                    i4 &= -113;
                }
                if (i14 != 0) {
                    fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                }
                if ((i3 & 8) != 0) {
                    circularIndeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularIndeterminateTrackColor(composerStartRestartGroup, 6);
                    i4 &= -7169;
                } else {
                    circularIndeterminateTrackColor = j3;
                }
                if (i5 != 0) {
                    i8 = i4;
                    j5 = circularIndeterminateTrackColor;
                    f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                    iM2664getCircularIndeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2664getCircularIndeterminateStrokeCapKaPHkGw();
                    j4 = circularColor;
                } else {
                    i8 = i4;
                    j4 = circularColor;
                    long j1112 = circularIndeterminateTrackColor;
                    f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                    iM2664getCircularIndeterminateStrokeCapKaPHkGw = i6;
                    j5 = j1112;
                }
            } else {
                if (i13 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i3 & 2) != 0) {
                    circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                    i4 &= -113;
                }
                if (i14 != 0) {
                    fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                }
                if ((i3 & 8) != 0) {
                    circularIndeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularIndeterminateTrackColor(composerStartRestartGroup, 6);
                    i4 &= -7169;
                } else {
                    circularIndeterminateTrackColor = j3;
                }
                if (i5 != 0) {
                    i8 = i4;
                    j5 = circularIndeterminateTrackColor;
                    f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                    iM2664getCircularIndeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2664getCircularIndeterminateStrokeCapKaPHkGw();
                    j4 = circularColor;
                } else {
                    i8 = i4;
                    j4 = circularColor;
                    long j1113 = circularIndeterminateTrackColor;
                    f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                    iM2664getCircularIndeterminateStrokeCapKaPHkGw = i6;
                    j5 = j1113;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-115871647, i8, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:637)");
            }
            ProvidableCompositionLocal<Density> localDensity7 = CompositionLocalsKt.getLocalDensity();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume7 = composerStartRestartGroup.consume(localDensity7);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            stroke = new Stroke(((Density) objConsume7).toPx-0680j_4(f2), 0.0f, iM2664getCircularIndeterminateStrokeCapKaPHkGw, 0, null, 26, null);
            InfiniteTransition infiniteTransitionRememberInfiniteTransition7 = InfiniteTransitionKt.rememberInfiniteTransition(null, composerStartRestartGroup, 0, 1);
            boolean z17 = true;
            i9 = i8;
            stateAnimateValue = InfiniteTransitionKt.animateValue(infiniteTransitionRememberInfiniteTransition7, 0, 5, VectorConvertersKt.getVectorConverter(IntCompanionObject.INSTANCE), AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.tween$default(6660, 0, EasingKt.getLinearEasing(), 2, null), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 12), 16);
            stateAnimateFloat = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition7, 0.0f, BaseRotationAngle, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.tween$default(RotationDuration, 0, EasingKt.getLinearEasing(), 2, null), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
            stateAnimateFloat2 = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition7, 0.0f, JumpRotationAngle, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                public Object invoke(Object obj) {
                    invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                    return Unit.INSTANCE;
                }

                public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                    keyframesSpecConfig.setDurationMillis(1332);
                    keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 0), ProgressIndicatorKt.CircularEasing);
                    keyframesSpecConfig.mo80at(Float.valueOf(290.0f), 666);
                }
            }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
            stateAnimateFloat3 = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition7, 0.0f, JumpRotationAngle, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                public Object invoke(Object obj) {
                    invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                    return Unit.INSTANCE;
                }

                public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                    keyframesSpecConfig.setDurationMillis(1332);
                    keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 666), ProgressIndicatorKt.CircularEasing);
                    keyframesSpecConfig.mo80at(Float.valueOf(290.0f), keyframesSpecConfig.getDurationMillis());
                }
            }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
            Modifier modifierM1080size3ABfNKs7 = SizeKt.m1080size3ABfNKs(ProgressSemanticsKt.progressSemantics(companion), CircularIndicatorDiameter);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291474284, "CC(remember):ProgressIndicator.kt#9igjgp");
            j3 = j5;
            if (((i9 & 7168) ^ 3072) > 2048) {
                modifier3 = companion;
                i10 = i9;
                if ((i10 & 3072) != 2048) {
                    z = true;
                } else {
                    z = false;
                }
            } else {
                modifier3 = companion;
                i10 = i9;
                if ((i10 & 3072) != 2048) {
                    z = true;
                } else {
                    z = false;
                }
            }
            boolean zChangedInstance8 = z | composerStartRestartGroup.changedInstance(r29) | composerStartRestartGroup.changed(stateAnimateValue) | composerStartRestartGroup.changed(stateAnimateFloat2) | composerStartRestartGroup.changed(stateAnimateFloat3) | composerStartRestartGroup.changed(stateAnimateFloat);
            int i112 = iM2664getCircularIndeterminateStrokeCapKaPHkGw;
            if ((i10 & 896) == 256) {
                z2 = true;
            } else {
                z2 = false;
            }
            boolean z18 = zChangedInstance8 | z2;
            if (((i10 & 112) ^ 48) > 32) {
            }
            z3 = z18 | z17;
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (!z3) {
                final float f19 = f2;
                final long j1114 = j4;
                objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((DrawScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(DrawScope drawScope) {
                        ProgressIndicatorKt.m2689drawCircularIndicatorTrackbw27NRU(drawScope, j3, stroke);
                        ProgressIndicatorKt.m2691drawIndeterminateCircularIndicatorhrjfTZI(drawScope, stateAnimateFloat3.getValue().floatValue() + (((stateAnimateValue.getValue().floatValue() * 216.0f) % 360.0f) - 90.0f) + stateAnimateFloat.getValue().floatValue(), f19, Math.abs(stateAnimateFloat2.getValue().floatValue() - stateAnimateFloat3.getValue().floatValue()), j1114, stroke);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                final float f110 = f2;
                final long j1115 = j4;
                objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((DrawScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(DrawScope drawScope) {
                        ProgressIndicatorKt.m2689drawCircularIndicatorTrackbw27NRU(drawScope, j3, stroke);
                        ProgressIndicatorKt.m2691drawIndeterminateCircularIndicatorhrjfTZI(drawScope, stateAnimateFloat3.getValue().floatValue() + (((stateAnimateValue.getValue().floatValue() * 216.0f) % 360.0f) - 90.0f) + stateAnimateFloat.getValue().floatValue(), f110, Math.abs(stateAnimateFloat2.getValue().floatValue() - stateAnimateFloat3.getValue().floatValue()), j1115, stroke);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            CanvasKt.Canvas(modifierM1080size3ABfNKs7, (Function1) objRememberedValue, composerStartRestartGroup, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            i11 = i112;
            j6 = j4;
            modifier2 = modifier3;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i2 & 1) == 0) {
                if (i13 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i3 & 2) != 0) {
                    circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                    i4 &= -113;
                }
                if (i14 != 0) {
                    fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                }
                if ((i3 & 8) != 0) {
                    circularIndeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularIndeterminateTrackColor(composerStartRestartGroup, 6);
                    i4 &= -7169;
                } else {
                    circularIndeterminateTrackColor = j3;
                }
                if (i5 != 0) {
                    i8 = i4;
                    j5 = circularIndeterminateTrackColor;
                    f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                    iM2664getCircularIndeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2664getCircularIndeterminateStrokeCapKaPHkGw();
                    j4 = circularColor;
                } else {
                    i8 = i4;
                    j4 = circularColor;
                    long j1116 = circularIndeterminateTrackColor;
                    f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                    iM2664getCircularIndeterminateStrokeCapKaPHkGw = i6;
                    j5 = j1116;
                }
            } else {
                if (i13 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i3 & 2) != 0) {
                    circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                    i4 &= -113;
                }
                if (i14 != 0) {
                    fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                }
                if ((i3 & 8) != 0) {
                    circularIndeterminateTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularIndeterminateTrackColor(composerStartRestartGroup, 6);
                    i4 &= -7169;
                } else {
                    circularIndeterminateTrackColor = j3;
                }
                if (i5 != 0) {
                    i8 = i4;
                    j5 = circularIndeterminateTrackColor;
                    f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                    iM2664getCircularIndeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2664getCircularIndeterminateStrokeCapKaPHkGw();
                    j4 = circularColor;
                } else {
                    i8 = i4;
                    j4 = circularColor;
                    long j1117 = circularIndeterminateTrackColor;
                    f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                    iM2664getCircularIndeterminateStrokeCapKaPHkGw = i6;
                    j5 = j1117;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-115871647, i8, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:637)");
            }
            ProvidableCompositionLocal<Density> localDensity8 = CompositionLocalsKt.getLocalDensity();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume8 = composerStartRestartGroup.consume(localDensity8);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            stroke = new Stroke(((Density) objConsume8).toPx-0680j_4(f2), 0.0f, iM2664getCircularIndeterminateStrokeCapKaPHkGw, 0, null, 26, null);
            InfiniteTransition infiniteTransitionRememberInfiniteTransition8 = InfiniteTransitionKt.rememberInfiniteTransition(null, composerStartRestartGroup, 0, 1);
            boolean z19 = true;
            i9 = i8;
            stateAnimateValue = InfiniteTransitionKt.animateValue(infiniteTransitionRememberInfiniteTransition8, 0, 5, VectorConvertersKt.getVectorConverter(IntCompanionObject.INSTANCE), AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.tween$default(6660, 0, EasingKt.getLinearEasing(), 2, null), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 12), 16);
            stateAnimateFloat = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition8, 0.0f, BaseRotationAngle, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.tween$default(RotationDuration, 0, EasingKt.getLinearEasing(), 2, null), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
            stateAnimateFloat2 = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition8, 0.0f, JumpRotationAngle, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                public Object invoke(Object obj) {
                    invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                    return Unit.INSTANCE;
                }

                public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                    keyframesSpecConfig.setDurationMillis(1332);
                    keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 0), ProgressIndicatorKt.CircularEasing);
                    keyframesSpecConfig.mo80at(Float.valueOf(290.0f), 666);
                }
            }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
            stateAnimateFloat3 = InfiniteTransitionKt.animateFloat(infiniteTransitionRememberInfiniteTransition8, 0.0f, JumpRotationAngle, AnimationSpecKt.m413infiniteRepeatable9IiC70o$default(AnimationSpecKt.keyframes(new Function1<KeyframesSpec.KeyframesSpecConfig<Float>, Unit>() {
                public Object invoke(Object obj) {
                    invoke((KeyframesSpec.KeyframesSpecConfig<Float>) obj);
                    return Unit.INSTANCE;
                }

                public final void invoke(KeyframesSpec.KeyframesSpecConfig<Float> keyframesSpecConfig) {
                    keyframesSpecConfig.setDurationMillis(1332);
                    keyframesSpecConfig.using(keyframesSpecConfig.mo80at(Float.valueOf(0.0f), 666), ProgressIndicatorKt.CircularEasing);
                    keyframesSpecConfig.mo80at(Float.valueOf(290.0f), keyframesSpecConfig.getDurationMillis());
                }
            }), null, 0L, 6, null), null, composerStartRestartGroup, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9), 8);
            Modifier modifierM1080size3ABfNKs8 = SizeKt.m1080size3ABfNKs(ProgressSemanticsKt.progressSemantics(companion), CircularIndicatorDiameter);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291474284, "CC(remember):ProgressIndicator.kt#9igjgp");
            j3 = j5;
            if (((i9 & 7168) ^ 3072) > 2048) {
                modifier3 = companion;
                i10 = i9;
                if ((i10 & 3072) != 2048) {
                    z = true;
                } else {
                    z = false;
                }
            } else {
                modifier3 = companion;
                i10 = i9;
                if ((i10 & 3072) != 2048) {
                    z = true;
                } else {
                    z = false;
                }
            }
            boolean zChangedInstance9 = z | composerStartRestartGroup.changedInstance(r29) | composerStartRestartGroup.changed(stateAnimateValue) | composerStartRestartGroup.changed(stateAnimateFloat2) | composerStartRestartGroup.changed(stateAnimateFloat3) | composerStartRestartGroup.changed(stateAnimateFloat);
            int i113 = iM2664getCircularIndeterminateStrokeCapKaPHkGw;
            if ((i10 & 896) == 256) {
                z2 = true;
            } else {
                z2 = false;
            }
            boolean z110 = zChangedInstance9 | z2;
            if (((i10 & 112) ^ 48) > 32) {
            }
            z3 = z110 | z19;
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (!z3) {
                final float f111 = f2;
                final long j1118 = j4;
                objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((DrawScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(DrawScope drawScope) {
                        ProgressIndicatorKt.m2689drawCircularIndicatorTrackbw27NRU(drawScope, j3, stroke);
                        ProgressIndicatorKt.m2691drawIndeterminateCircularIndicatorhrjfTZI(drawScope, stateAnimateFloat3.getValue().floatValue() + (((stateAnimateValue.getValue().floatValue() * 216.0f) % 360.0f) - 90.0f) + stateAnimateFloat.getValue().floatValue(), f111, Math.abs(stateAnimateFloat2.getValue().floatValue() - stateAnimateFloat3.getValue().floatValue()), j1118, stroke);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                final float f112 = f2;
                final long j1119 = j4;
                objRememberedValue = (Function1) new Function1<DrawScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((DrawScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(DrawScope drawScope) {
                        ProgressIndicatorKt.m2689drawCircularIndicatorTrackbw27NRU(drawScope, j3, stroke);
                        ProgressIndicatorKt.m2691drawIndeterminateCircularIndicatorhrjfTZI(drawScope, stateAnimateFloat3.getValue().floatValue() + (((stateAnimateValue.getValue().floatValue() * 216.0f) % 360.0f) - 90.0f) + stateAnimateFloat.getValue().floatValue(), f112, Math.abs(stateAnimateFloat2.getValue().floatValue() - stateAnimateFloat3.getValue().floatValue()), j1119, stroke);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            CanvasKt.Canvas(modifierM1080size3ABfNKs8, (Function1) objRememberedValue, composerStartRestartGroup, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            i11 = i113;
            j6 = j4;
            modifier2 = modifier3;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier7 = modifier2;
            final float f113 = f2;
            final long j11110 = j3;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i114) {
                    ProgressIndicatorKt.m2673CircularProgressIndicatorLxG7B9w(modifier7, j6, f113, j11110, i11, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                }
            });
        }
    }

    @Deprecated(message = "Use the overload that takes `progress` as a lambda", replaceWith = @ReplaceWith(expression = "CircularProgressIndicator(\nprogress = { progress },\nmodifier = modifier,\ncolor = color,\nstrokeWidth = strokeWidth,\ntrackColor = trackColor,\nstrokeCap = strokeCap,\n)", imports = {}))
    public static final void m2670CircularProgressIndicatorDUhRLBM(final float f, Modifier modifier, long j, float f2, long j2, int i, Composer composer, final int i2, final int i3) {
        int i4;
        Modifier modifier2;
        long circularColor;
        int i5;
        float fM2666getCircularStrokeWidthD9Ej5fM;
        int i6;
        long circularTrackColor;
        int i7;
        int i8;
        int i9;
        int iM2663getCircularDeterminateStrokeCapKaPHkGw;
        int i10;
        float f3;
        long j3;
        boolean z;
        Object objRememberedValue;
        final long j4;
        final int i11;
        final float f4;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i12;
        int i13;
        Composer composerStartRestartGroup = composer.startRestartGroup(-1472321743);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(CircularProgressIndicator)P(2,1,0:c#ui.graphics.Color,4:c#ui.unit.Dp,5:c#ui.graphics.Color,3:c#ui.graphics.StrokeCap)730@30011L13,732@30145L18,736@30302L12,735@30256L216:ProgressIndicator.kt#uh7d8r");
        if ((i3 & 1) != 0) {
            i4 = i2 | 6;
        } else if ((i2 & 6) == 0) {
            i4 = (composerStartRestartGroup.changed(f) ? 4 : 2) | i2;
        } else {
            i4 = i2;
        }
        int i14 = i3 & 2;
        if (i14 == 0) {
            if ((i2 & 48) == 0) {
                modifier2 = modifier;
                i4 |= composerStartRestartGroup.changed(modifier2) ? 32 : 16;
            }
            if ((i2 & 384) == 0) {
                if ((i3 & 4) == 0) {
                    circularColor = j;
                    if (composerStartRestartGroup.changed(circularColor)) {
                        i13 = Fields.RotationX;
                    }
                    i4 |= i13;
                } else {
                    circularColor = j;
                }
                i13 = Fields.SpotShadowColor;
                i4 |= i13;
            } else {
                circularColor = j;
            }
            i5 = i3 & 8;
            if (i5 != 0) {
                if ((i2 & 3072) == 0) {
                    fM2666getCircularStrokeWidthD9Ej5fM = f2;
                    if (composerStartRestartGroup.changed(fM2666getCircularStrokeWidthD9Ej5fM)) {
                        i6 = Fields.CameraDistance;
                    } else {
                        i6 = Fields.RotationZ;
                    }
                    i4 |= i6;
                }
                if ((i2 & 24576) == 0) {
                    if ((i3 & 16) == 0) {
                        circularTrackColor = j2;
                        if (composerStartRestartGroup.changed(circularTrackColor)) {
                            i12 = Fields.Clip;
                        }
                        i4 |= i12;
                    } else {
                        circularTrackColor = j2;
                    }
                    i12 = Fields.Shape;
                    i4 |= i12;
                } else {
                    circularTrackColor = j2;
                }
                i7 = i3 & 32;
                if (i7 != 0) {
                    if ((196608 & i2) == 0) {
                        i8 = i;
                        if (composerStartRestartGroup.changed(i8)) {
                            i9 = Fields.RenderEffect;
                        } else {
                            i9 = 65536;
                        }
                        i4 |= i9;
                    }
                    if ((i4 & 74899) == 74898 || !composerStartRestartGroup.getSkipping()) {
                        composerStartRestartGroup.startDefaults();
                        if ((i2 & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                            if (i14 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if ((i3 & 4) != 0) {
                                circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                                i4 &= -897;
                            }
                            if (i5 != 0) {
                                fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                            }
                            if ((i3 & 16) != 0) {
                                circularTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6);
                                i4 &= -57345;
                            }
                            if (i7 != 0) {
                                iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                                i10 = i4;
                                f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                                j3 = circularTrackColor;
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1472321743, i10, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:735)");
                            }
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291425076, "CC(remember):ProgressIndicator.kt#9igjgp");
                            if ((i10 & 14) == 4) {
                                z = true;
                            } else {
                                z = false;
                            }
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (z || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue = (Function0) new Function0<Float>() {
                                    {
                                        super(0);
                                    }

                                    public final Float m2693invoke() {
                                        return Float.valueOf(f);
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            m2672CircularProgressIndicatorIyT6zlY((Function0) objRememberedValue, modifier2, circularColor, f3, j3, iM2663getCircularDeterminateStrokeCapKaPHkGw, 0.0f, composerStartRestartGroup, i10 & 524272, 64);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            circularTrackColor = j3;
                            j4 = circularColor;
                            i11 = iM2663getCircularDeterminateStrokeCapKaPHkGw;
                            f4 = f3;
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            if ((i3 & 4) != 0) {
                                i4 &= -897;
                            }
                            if ((i3 & 16) != 0) {
                                i4 &= -57345;
                            }
                        }
                        i10 = i4;
                        f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                        j3 = circularTrackColor;
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1472321743, i10, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:735)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291425076, "CC(remember):ProgressIndicator.kt#9igjgp");
                        if ((i10 & 14) == 4) {
                            z = true;
                        } else {
                            z = false;
                        }
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (z) {
                            objRememberedValue = (Function0) new Function0<Float>() {
                                {
                                    super(0);
                                }

                                public final Float m2693invoke() {
                                    return Float.valueOf(f);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = (Function0) new Function0<Float>() {
                                {
                                    super(0);
                                }

                                public final Float m2693invoke() {
                                    return Float.valueOf(f);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        m2672CircularProgressIndicatorIyT6zlY((Function0) objRememberedValue, modifier2, circularColor, f3, j3, iM2663getCircularDeterminateStrokeCapKaPHkGw, 0.0f, composerStartRestartGroup, i10 & 524272, 64);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        circularTrackColor = j3;
                        j4 = circularColor;
                        i11 = iM2663getCircularDeterminateStrokeCapKaPHkGw;
                        f4 = f3;
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        j4 = circularColor;
                        f4 = fM2666getCircularStrokeWidthD9Ej5fM;
                        i11 = i8;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier3 = modifier2;
                        final long j5 = circularTrackColor;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i15) {
                                ProgressIndicatorKt.m2670CircularProgressIndicatorDUhRLBM(f, modifier3, j4, f4, j5, i11, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                            }
                        });
                    }
                }
                i4 |= 196608;
                i8 = i;
                if ((i4 & 74899) == 74898) {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) != 0) {
                        if (i14 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i3 & 4) != 0) {
                            circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                            i4 &= -897;
                        }
                        if (i5 != 0) {
                            fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                        }
                        if ((i3 & 16) != 0) {
                            circularTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6);
                            i4 &= -57345;
                        }
                        if (i7 != 0) {
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                            i10 = i4;
                            f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                            j3 = circularTrackColor;
                        } else {
                            i10 = i4;
                            f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                            j3 = circularTrackColor;
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                        }
                    } else {
                        if (i14 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i3 & 4) != 0) {
                            circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                            i4 &= -897;
                        }
                        if (i5 != 0) {
                            fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                        }
                        if ((i3 & 16) != 0) {
                            circularTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6);
                            i4 &= -57345;
                        }
                        if (i7 != 0) {
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                            i10 = i4;
                            f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                            j3 = circularTrackColor;
                        } else {
                            i10 = i4;
                            f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                            j3 = circularTrackColor;
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1472321743, i10, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:735)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291425076, "CC(remember):ProgressIndicator.kt#9igjgp");
                    if ((i10 & 14) == 4) {
                        z = true;
                    } else {
                        z = false;
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (z) {
                        objRememberedValue = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2693invoke() {
                                return Float.valueOf(f);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2693invoke() {
                                return Float.valueOf(f);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    m2672CircularProgressIndicatorIyT6zlY((Function0) objRememberedValue, modifier2, circularColor, f3, j3, iM2663getCircularDeterminateStrokeCapKaPHkGw, 0.0f, composerStartRestartGroup, i10 & 524272, 64);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    circularTrackColor = j3;
                    j4 = circularColor;
                    i11 = iM2663getCircularDeterminateStrokeCapKaPHkGw;
                    f4 = f3;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) != 0) {
                        if (i14 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i3 & 4) != 0) {
                            circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                            i4 &= -897;
                        }
                        if (i5 != 0) {
                            fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                        }
                        if ((i3 & 16) != 0) {
                            circularTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6);
                            i4 &= -57345;
                        }
                        if (i7 != 0) {
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                            i10 = i4;
                            f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                            j3 = circularTrackColor;
                        } else {
                            i10 = i4;
                            f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                            j3 = circularTrackColor;
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                        }
                    } else {
                        if (i14 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i3 & 4) != 0) {
                            circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                            i4 &= -897;
                        }
                        if (i5 != 0) {
                            fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                        }
                        if ((i3 & 16) != 0) {
                            circularTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6);
                            i4 &= -57345;
                        }
                        if (i7 != 0) {
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                            i10 = i4;
                            f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                            j3 = circularTrackColor;
                        } else {
                            i10 = i4;
                            f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                            j3 = circularTrackColor;
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1472321743, i10, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:735)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291425076, "CC(remember):ProgressIndicator.kt#9igjgp");
                    if ((i10 & 14) == 4) {
                        z = true;
                    } else {
                        z = false;
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (z) {
                        objRememberedValue = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2693invoke() {
                                return Float.valueOf(f);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2693invoke() {
                                return Float.valueOf(f);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    m2672CircularProgressIndicatorIyT6zlY((Function0) objRememberedValue, modifier2, circularColor, f3, j3, iM2663getCircularDeterminateStrokeCapKaPHkGw, 0.0f, composerStartRestartGroup, i10 & 524272, 64);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    circularTrackColor = j3;
                    j4 = circularColor;
                    i11 = iM2663getCircularDeterminateStrokeCapKaPHkGw;
                    f4 = f3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier4 = modifier2;
                    final long j6 = circularTrackColor;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i15) {
                            ProgressIndicatorKt.m2670CircularProgressIndicatorDUhRLBM(f, modifier4, j4, f4, j6, i11, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                        }
                    });
                }
            }
            i4 |= 3072;
            fM2666getCircularStrokeWidthD9Ej5fM = f2;
            if ((i2 & 24576) == 0) {
                if ((i3 & 16) == 0) {
                    circularTrackColor = j2;
                    if (composerStartRestartGroup.changed(circularTrackColor)) {
                        i12 = Fields.Clip;
                    }
                    i4 |= i12;
                } else {
                    circularTrackColor = j2;
                }
                i12 = Fields.Shape;
                i4 |= i12;
            } else {
                circularTrackColor = j2;
            }
            i7 = i3 & 32;
            if (i7 != 0) {
                if ((196608 & i2) == 0) {
                    i8 = i;
                    if (composerStartRestartGroup.changed(i8)) {
                        i9 = Fields.RenderEffect;
                    } else {
                        i9 = 65536;
                    }
                    i4 |= i9;
                }
                if ((i4 & 74899) == 74898) {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) != 0) {
                        if (i14 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i3 & 4) != 0) {
                            circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                            i4 &= -897;
                        }
                        if (i5 != 0) {
                            fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                        }
                        if ((i3 & 16) != 0) {
                            circularTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6);
                            i4 &= -57345;
                        }
                        if (i7 != 0) {
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                            i10 = i4;
                            f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                            j3 = circularTrackColor;
                        } else {
                            i10 = i4;
                            f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                            j3 = circularTrackColor;
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                        }
                    } else {
                        if (i14 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i3 & 4) != 0) {
                            circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                            i4 &= -897;
                        }
                        if (i5 != 0) {
                            fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                        }
                        if ((i3 & 16) != 0) {
                            circularTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6);
                            i4 &= -57345;
                        }
                        if (i7 != 0) {
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                            i10 = i4;
                            f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                            j3 = circularTrackColor;
                        } else {
                            i10 = i4;
                            f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                            j3 = circularTrackColor;
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1472321743, i10, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:735)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291425076, "CC(remember):ProgressIndicator.kt#9igjgp");
                    if ((i10 & 14) == 4) {
                        z = true;
                    } else {
                        z = false;
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (z) {
                        objRememberedValue = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2693invoke() {
                                return Float.valueOf(f);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2693invoke() {
                                return Float.valueOf(f);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    m2672CircularProgressIndicatorIyT6zlY((Function0) objRememberedValue, modifier2, circularColor, f3, j3, iM2663getCircularDeterminateStrokeCapKaPHkGw, 0.0f, composerStartRestartGroup, i10 & 524272, 64);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    circularTrackColor = j3;
                    j4 = circularColor;
                    i11 = iM2663getCircularDeterminateStrokeCapKaPHkGw;
                    f4 = f3;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) != 0) {
                        if (i14 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i3 & 4) != 0) {
                            circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                            i4 &= -897;
                        }
                        if (i5 != 0) {
                            fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                        }
                        if ((i3 & 16) != 0) {
                            circularTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6);
                            i4 &= -57345;
                        }
                        if (i7 != 0) {
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                            i10 = i4;
                            f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                            j3 = circularTrackColor;
                        } else {
                            i10 = i4;
                            f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                            j3 = circularTrackColor;
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                        }
                    } else {
                        if (i14 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i3 & 4) != 0) {
                            circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                            i4 &= -897;
                        }
                        if (i5 != 0) {
                            fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                        }
                        if ((i3 & 16) != 0) {
                            circularTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6);
                            i4 &= -57345;
                        }
                        if (i7 != 0) {
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                            i10 = i4;
                            f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                            j3 = circularTrackColor;
                        } else {
                            i10 = i4;
                            f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                            j3 = circularTrackColor;
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1472321743, i10, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:735)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291425076, "CC(remember):ProgressIndicator.kt#9igjgp");
                    if ((i10 & 14) == 4) {
                        z = true;
                    } else {
                        z = false;
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (z) {
                        objRememberedValue = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2693invoke() {
                                return Float.valueOf(f);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2693invoke() {
                                return Float.valueOf(f);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    m2672CircularProgressIndicatorIyT6zlY((Function0) objRememberedValue, modifier2, circularColor, f3, j3, iM2663getCircularDeterminateStrokeCapKaPHkGw, 0.0f, composerStartRestartGroup, i10 & 524272, 64);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    circularTrackColor = j3;
                    j4 = circularColor;
                    i11 = iM2663getCircularDeterminateStrokeCapKaPHkGw;
                    f4 = f3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier5 = modifier2;
                    final long j7 = circularTrackColor;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i15) {
                            ProgressIndicatorKt.m2670CircularProgressIndicatorDUhRLBM(f, modifier5, j4, f4, j7, i11, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                        }
                    });
                }
            }
            i4 |= 196608;
            i8 = i;
            if ((i4 & 74899) == 74898) {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) != 0) {
                    if (i14 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i5 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 16) != 0) {
                        circularTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    }
                    if (i7 != 0) {
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                        i10 = i4;
                        f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                        j3 = circularTrackColor;
                    } else {
                        i10 = i4;
                        f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                        j3 = circularTrackColor;
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                    }
                } else {
                    if (i14 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i5 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 16) != 0) {
                        circularTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    }
                    if (i7 != 0) {
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                        i10 = i4;
                        f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                        j3 = circularTrackColor;
                    } else {
                        i10 = i4;
                        f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                        j3 = circularTrackColor;
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1472321743, i10, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:735)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291425076, "CC(remember):ProgressIndicator.kt#9igjgp");
                if ((i10 & 14) == 4) {
                    z = true;
                } else {
                    z = false;
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (z) {
                    objRememberedValue = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2693invoke() {
                            return Float.valueOf(f);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2693invoke() {
                            return Float.valueOf(f);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                m2672CircularProgressIndicatorIyT6zlY((Function0) objRememberedValue, modifier2, circularColor, f3, j3, iM2663getCircularDeterminateStrokeCapKaPHkGw, 0.0f, composerStartRestartGroup, i10 & 524272, 64);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                circularTrackColor = j3;
                j4 = circularColor;
                i11 = iM2663getCircularDeterminateStrokeCapKaPHkGw;
                f4 = f3;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) != 0) {
                    if (i14 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i5 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 16) != 0) {
                        circularTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    }
                    if (i7 != 0) {
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                        i10 = i4;
                        f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                        j3 = circularTrackColor;
                    } else {
                        i10 = i4;
                        f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                        j3 = circularTrackColor;
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                    }
                } else {
                    if (i14 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i5 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 16) != 0) {
                        circularTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    }
                    if (i7 != 0) {
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                        i10 = i4;
                        f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                        j3 = circularTrackColor;
                    } else {
                        i10 = i4;
                        f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                        j3 = circularTrackColor;
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1472321743, i10, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:735)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291425076, "CC(remember):ProgressIndicator.kt#9igjgp");
                if ((i10 & 14) == 4) {
                    z = true;
                } else {
                    z = false;
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (z) {
                    objRememberedValue = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2693invoke() {
                            return Float.valueOf(f);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2693invoke() {
                            return Float.valueOf(f);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                m2672CircularProgressIndicatorIyT6zlY((Function0) objRememberedValue, modifier2, circularColor, f3, j3, iM2663getCircularDeterminateStrokeCapKaPHkGw, 0.0f, composerStartRestartGroup, i10 & 524272, 64);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                circularTrackColor = j3;
                j4 = circularColor;
                i11 = iM2663getCircularDeterminateStrokeCapKaPHkGw;
                f4 = f3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier6 = modifier2;
                final long j8 = circularTrackColor;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i15) {
                        ProgressIndicatorKt.m2670CircularProgressIndicatorDUhRLBM(f, modifier6, j4, f4, j8, i11, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                    }
                });
            }
        }
        i4 |= 48;
        modifier2 = modifier;
        if ((i2 & 384) == 0) {
            if ((i3 & 4) == 0) {
                circularColor = j;
                if (composerStartRestartGroup.changed(circularColor)) {
                    i13 = Fields.RotationX;
                }
                i4 |= i13;
            } else {
                circularColor = j;
            }
            i13 = Fields.SpotShadowColor;
            i4 |= i13;
        } else {
            circularColor = j;
        }
        i5 = i3 & 8;
        if (i5 != 0) {
            if ((i2 & 3072) == 0) {
                fM2666getCircularStrokeWidthD9Ej5fM = f2;
                if (composerStartRestartGroup.changed(fM2666getCircularStrokeWidthD9Ej5fM)) {
                    i6 = Fields.CameraDistance;
                } else {
                    i6 = Fields.RotationZ;
                }
                i4 |= i6;
            }
            if ((i2 & 24576) == 0) {
                if ((i3 & 16) == 0) {
                    circularTrackColor = j2;
                    if (composerStartRestartGroup.changed(circularTrackColor)) {
                        i12 = Fields.Clip;
                    }
                    i4 |= i12;
                } else {
                    circularTrackColor = j2;
                }
                i12 = Fields.Shape;
                i4 |= i12;
            } else {
                circularTrackColor = j2;
            }
            i7 = i3 & 32;
            if (i7 != 0) {
                if ((196608 & i2) == 0) {
                    i8 = i;
                    if (composerStartRestartGroup.changed(i8)) {
                        i9 = Fields.RenderEffect;
                    } else {
                        i9 = 65536;
                    }
                    i4 |= i9;
                }
                if ((i4 & 74899) == 74898) {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) != 0) {
                        if (i14 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i3 & 4) != 0) {
                            circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                            i4 &= -897;
                        }
                        if (i5 != 0) {
                            fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                        }
                        if ((i3 & 16) != 0) {
                            circularTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6);
                            i4 &= -57345;
                        }
                        if (i7 != 0) {
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                            i10 = i4;
                            f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                            j3 = circularTrackColor;
                        } else {
                            i10 = i4;
                            f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                            j3 = circularTrackColor;
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                        }
                    } else {
                        if (i14 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i3 & 4) != 0) {
                            circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                            i4 &= -897;
                        }
                        if (i5 != 0) {
                            fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                        }
                        if ((i3 & 16) != 0) {
                            circularTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6);
                            i4 &= -57345;
                        }
                        if (i7 != 0) {
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                            i10 = i4;
                            f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                            j3 = circularTrackColor;
                        } else {
                            i10 = i4;
                            f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                            j3 = circularTrackColor;
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1472321743, i10, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:735)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291425076, "CC(remember):ProgressIndicator.kt#9igjgp");
                    if ((i10 & 14) == 4) {
                        z = true;
                    } else {
                        z = false;
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (z) {
                        objRememberedValue = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2693invoke() {
                                return Float.valueOf(f);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2693invoke() {
                                return Float.valueOf(f);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    m2672CircularProgressIndicatorIyT6zlY((Function0) objRememberedValue, modifier2, circularColor, f3, j3, iM2663getCircularDeterminateStrokeCapKaPHkGw, 0.0f, composerStartRestartGroup, i10 & 524272, 64);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    circularTrackColor = j3;
                    j4 = circularColor;
                    i11 = iM2663getCircularDeterminateStrokeCapKaPHkGw;
                    f4 = f3;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) != 0) {
                        if (i14 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i3 & 4) != 0) {
                            circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                            i4 &= -897;
                        }
                        if (i5 != 0) {
                            fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                        }
                        if ((i3 & 16) != 0) {
                            circularTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6);
                            i4 &= -57345;
                        }
                        if (i7 != 0) {
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                            i10 = i4;
                            f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                            j3 = circularTrackColor;
                        } else {
                            i10 = i4;
                            f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                            j3 = circularTrackColor;
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                        }
                    } else {
                        if (i14 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i3 & 4) != 0) {
                            circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                            i4 &= -897;
                        }
                        if (i5 != 0) {
                            fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                        }
                        if ((i3 & 16) != 0) {
                            circularTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6);
                            i4 &= -57345;
                        }
                        if (i7 != 0) {
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                            i10 = i4;
                            f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                            j3 = circularTrackColor;
                        } else {
                            i10 = i4;
                            f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                            j3 = circularTrackColor;
                            iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1472321743, i10, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:735)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291425076, "CC(remember):ProgressIndicator.kt#9igjgp");
                    if ((i10 & 14) == 4) {
                        z = true;
                    } else {
                        z = false;
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (z) {
                        objRememberedValue = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2693invoke() {
                                return Float.valueOf(f);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = (Function0) new Function0<Float>() {
                            {
                                super(0);
                            }

                            public final Float m2693invoke() {
                                return Float.valueOf(f);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    m2672CircularProgressIndicatorIyT6zlY((Function0) objRememberedValue, modifier2, circularColor, f3, j3, iM2663getCircularDeterminateStrokeCapKaPHkGw, 0.0f, composerStartRestartGroup, i10 & 524272, 64);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    circularTrackColor = j3;
                    j4 = circularColor;
                    i11 = iM2663getCircularDeterminateStrokeCapKaPHkGw;
                    f4 = f3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier7 = modifier2;
                    final long j9 = circularTrackColor;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i15) {
                            ProgressIndicatorKt.m2670CircularProgressIndicatorDUhRLBM(f, modifier7, j4, f4, j9, i11, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                        }
                    });
                }
            }
            i4 |= 196608;
            i8 = i;
            if ((i4 & 74899) == 74898) {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) != 0) {
                    if (i14 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i5 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 16) != 0) {
                        circularTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    }
                    if (i7 != 0) {
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                        i10 = i4;
                        f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                        j3 = circularTrackColor;
                    } else {
                        i10 = i4;
                        f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                        j3 = circularTrackColor;
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                    }
                } else {
                    if (i14 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i5 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 16) != 0) {
                        circularTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    }
                    if (i7 != 0) {
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                        i10 = i4;
                        f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                        j3 = circularTrackColor;
                    } else {
                        i10 = i4;
                        f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                        j3 = circularTrackColor;
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1472321743, i10, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:735)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291425076, "CC(remember):ProgressIndicator.kt#9igjgp");
                if ((i10 & 14) == 4) {
                    z = true;
                } else {
                    z = false;
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (z) {
                    objRememberedValue = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2693invoke() {
                            return Float.valueOf(f);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2693invoke() {
                            return Float.valueOf(f);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                m2672CircularProgressIndicatorIyT6zlY((Function0) objRememberedValue, modifier2, circularColor, f3, j3, iM2663getCircularDeterminateStrokeCapKaPHkGw, 0.0f, composerStartRestartGroup, i10 & 524272, 64);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                circularTrackColor = j3;
                j4 = circularColor;
                i11 = iM2663getCircularDeterminateStrokeCapKaPHkGw;
                f4 = f3;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) != 0) {
                    if (i14 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i5 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 16) != 0) {
                        circularTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    }
                    if (i7 != 0) {
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                        i10 = i4;
                        f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                        j3 = circularTrackColor;
                    } else {
                        i10 = i4;
                        f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                        j3 = circularTrackColor;
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                    }
                } else {
                    if (i14 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i5 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 16) != 0) {
                        circularTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    }
                    if (i7 != 0) {
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                        i10 = i4;
                        f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                        j3 = circularTrackColor;
                    } else {
                        i10 = i4;
                        f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                        j3 = circularTrackColor;
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1472321743, i10, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:735)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291425076, "CC(remember):ProgressIndicator.kt#9igjgp");
                if ((i10 & 14) == 4) {
                    z = true;
                } else {
                    z = false;
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (z) {
                    objRememberedValue = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2693invoke() {
                            return Float.valueOf(f);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2693invoke() {
                            return Float.valueOf(f);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                m2672CircularProgressIndicatorIyT6zlY((Function0) objRememberedValue, modifier2, circularColor, f3, j3, iM2663getCircularDeterminateStrokeCapKaPHkGw, 0.0f, composerStartRestartGroup, i10 & 524272, 64);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                circularTrackColor = j3;
                j4 = circularColor;
                i11 = iM2663getCircularDeterminateStrokeCapKaPHkGw;
                f4 = f3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier8 = modifier2;
                final long j10 = circularTrackColor;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i15) {
                        ProgressIndicatorKt.m2670CircularProgressIndicatorDUhRLBM(f, modifier8, j4, f4, j10, i11, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                    }
                });
            }
        }
        i4 |= 3072;
        fM2666getCircularStrokeWidthD9Ej5fM = f2;
        if ((i2 & 24576) == 0) {
            if ((i3 & 16) == 0) {
                circularTrackColor = j2;
                if (composerStartRestartGroup.changed(circularTrackColor)) {
                    i12 = Fields.Clip;
                }
                i4 |= i12;
            } else {
                circularTrackColor = j2;
            }
            i12 = Fields.Shape;
            i4 |= i12;
        } else {
            circularTrackColor = j2;
        }
        i7 = i3 & 32;
        if (i7 != 0) {
            if ((196608 & i2) == 0) {
                i8 = i;
                if (composerStartRestartGroup.changed(i8)) {
                    i9 = Fields.RenderEffect;
                } else {
                    i9 = 65536;
                }
                i4 |= i9;
            }
            if ((i4 & 74899) == 74898) {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) != 0) {
                    if (i14 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i5 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 16) != 0) {
                        circularTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    }
                    if (i7 != 0) {
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                        i10 = i4;
                        f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                        j3 = circularTrackColor;
                    } else {
                        i10 = i4;
                        f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                        j3 = circularTrackColor;
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                    }
                } else {
                    if (i14 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i5 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 16) != 0) {
                        circularTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    }
                    if (i7 != 0) {
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                        i10 = i4;
                        f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                        j3 = circularTrackColor;
                    } else {
                        i10 = i4;
                        f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                        j3 = circularTrackColor;
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1472321743, i10, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:735)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291425076, "CC(remember):ProgressIndicator.kt#9igjgp");
                if ((i10 & 14) == 4) {
                    z = true;
                } else {
                    z = false;
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (z) {
                    objRememberedValue = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2693invoke() {
                            return Float.valueOf(f);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2693invoke() {
                            return Float.valueOf(f);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                m2672CircularProgressIndicatorIyT6zlY((Function0) objRememberedValue, modifier2, circularColor, f3, j3, iM2663getCircularDeterminateStrokeCapKaPHkGw, 0.0f, composerStartRestartGroup, i10 & 524272, 64);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                circularTrackColor = j3;
                j4 = circularColor;
                i11 = iM2663getCircularDeterminateStrokeCapKaPHkGw;
                f4 = f3;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) != 0) {
                    if (i14 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i5 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 16) != 0) {
                        circularTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    }
                    if (i7 != 0) {
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                        i10 = i4;
                        f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                        j3 = circularTrackColor;
                    } else {
                        i10 = i4;
                        f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                        j3 = circularTrackColor;
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                    }
                } else {
                    if (i14 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i3 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i4 &= -897;
                    }
                    if (i5 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    if ((i3 & 16) != 0) {
                        circularTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    }
                    if (i7 != 0) {
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                        i10 = i4;
                        f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                        j3 = circularTrackColor;
                    } else {
                        i10 = i4;
                        f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                        j3 = circularTrackColor;
                        iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1472321743, i10, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:735)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291425076, "CC(remember):ProgressIndicator.kt#9igjgp");
                if ((i10 & 14) == 4) {
                    z = true;
                } else {
                    z = false;
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (z) {
                    objRememberedValue = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2693invoke() {
                            return Float.valueOf(f);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function0) new Function0<Float>() {
                        {
                            super(0);
                        }

                        public final Float m2693invoke() {
                            return Float.valueOf(f);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                m2672CircularProgressIndicatorIyT6zlY((Function0) objRememberedValue, modifier2, circularColor, f3, j3, iM2663getCircularDeterminateStrokeCapKaPHkGw, 0.0f, composerStartRestartGroup, i10 & 524272, 64);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                circularTrackColor = j3;
                j4 = circularColor;
                i11 = iM2663getCircularDeterminateStrokeCapKaPHkGw;
                f4 = f3;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier9 = modifier2;
                final long j11 = circularTrackColor;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i15) {
                        ProgressIndicatorKt.m2670CircularProgressIndicatorDUhRLBM(f, modifier9, j4, f4, j11, i11, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                    }
                });
            }
        }
        i4 |= 196608;
        i8 = i;
        if ((i4 & 74899) == 74898) {
            composerStartRestartGroup.startDefaults();
            if ((i2 & 1) != 0) {
                if (i14 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if ((i3 & 4) != 0) {
                    circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                    i4 &= -897;
                }
                if (i5 != 0) {
                    fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                }
                if ((i3 & 16) != 0) {
                    circularTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6);
                    i4 &= -57345;
                }
                if (i7 != 0) {
                    iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                    i10 = i4;
                    f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                    j3 = circularTrackColor;
                } else {
                    i10 = i4;
                    f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                    j3 = circularTrackColor;
                    iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                }
            } else {
                if (i14 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if ((i3 & 4) != 0) {
                    circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                    i4 &= -897;
                }
                if (i5 != 0) {
                    fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                }
                if ((i3 & 16) != 0) {
                    circularTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6);
                    i4 &= -57345;
                }
                if (i7 != 0) {
                    iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                    i10 = i4;
                    f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                    j3 = circularTrackColor;
                } else {
                    i10 = i4;
                    f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                    j3 = circularTrackColor;
                    iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1472321743, i10, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:735)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291425076, "CC(remember):ProgressIndicator.kt#9igjgp");
            if ((i10 & 14) == 4) {
                z = true;
            } else {
                z = false;
            }
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (z) {
                objRememberedValue = (Function0) new Function0<Float>() {
                    {
                        super(0);
                    }

                    public final Float m2693invoke() {
                        return Float.valueOf(f);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = (Function0) new Function0<Float>() {
                    {
                        super(0);
                    }

                    public final Float m2693invoke() {
                        return Float.valueOf(f);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            m2672CircularProgressIndicatorIyT6zlY((Function0) objRememberedValue, modifier2, circularColor, f3, j3, iM2663getCircularDeterminateStrokeCapKaPHkGw, 0.0f, composerStartRestartGroup, i10 & 524272, 64);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            circularTrackColor = j3;
            j4 = circularColor;
            i11 = iM2663getCircularDeterminateStrokeCapKaPHkGw;
            f4 = f3;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i2 & 1) != 0) {
                if (i14 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if ((i3 & 4) != 0) {
                    circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                    i4 &= -897;
                }
                if (i5 != 0) {
                    fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                }
                if ((i3 & 16) != 0) {
                    circularTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6);
                    i4 &= -57345;
                }
                if (i7 != 0) {
                    iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                    i10 = i4;
                    f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                    j3 = circularTrackColor;
                } else {
                    i10 = i4;
                    f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                    j3 = circularTrackColor;
                    iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                }
            } else {
                if (i14 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if ((i3 & 4) != 0) {
                    circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                    i4 &= -897;
                }
                if (i5 != 0) {
                    fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                }
                if ((i3 & 16) != 0) {
                    circularTrackColor = ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6);
                    i4 &= -57345;
                }
                if (i7 != 0) {
                    iM2663getCircularDeterminateStrokeCapKaPHkGw = ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw();
                    i10 = i4;
                    f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                    j3 = circularTrackColor;
                } else {
                    i10 = i4;
                    f3 = fM2666getCircularStrokeWidthD9Ej5fM;
                    j3 = circularTrackColor;
                    iM2663getCircularDeterminateStrokeCapKaPHkGw = i8;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1472321743, i10, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:735)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -291425076, "CC(remember):ProgressIndicator.kt#9igjgp");
            if ((i10 & 14) == 4) {
                z = true;
            } else {
                z = false;
            }
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (z) {
                objRememberedValue = (Function0) new Function0<Float>() {
                    {
                        super(0);
                    }

                    public final Float m2693invoke() {
                        return Float.valueOf(f);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = (Function0) new Function0<Float>() {
                    {
                        super(0);
                    }

                    public final Float m2693invoke() {
                        return Float.valueOf(f);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            m2672CircularProgressIndicatorIyT6zlY((Function0) objRememberedValue, modifier2, circularColor, f3, j3, iM2663getCircularDeterminateStrokeCapKaPHkGw, 0.0f, composerStartRestartGroup, i10 & 524272, 64);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            circularTrackColor = j3;
            j4 = circularColor;
            i11 = iM2663getCircularDeterminateStrokeCapKaPHkGw;
            f4 = f3;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier10 = modifier2;
            final long j12 = circularTrackColor;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i15) {
                    ProgressIndicatorKt.m2670CircularProgressIndicatorDUhRLBM(f, modifier10, j4, f4, j12, i11, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                }
            });
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Maintained for binary compatibility")
    public static final void m2674CircularProgressIndicatorMBs18nI(final float f, Modifier modifier, long j, float f2, Composer composer, final int i, final int i2) {
        int i3;
        Modifier modifier2;
        long circularColor;
        int i4;
        float f3;
        int i5;
        Modifier.Companion companion;
        final float fM2666getCircularStrokeWidthD9Ej5fM;
        long j2;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i6;
        Composer composerStartRestartGroup = composer.startRestartGroup(402841196);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(CircularProgressIndicator)P(2,1,0:c#ui.graphics.Color,3:c#ui.unit.Dp)750@30727L13,758@30964L18,753@30818L247:ProgressIndicator.kt#uh7d8r");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changed(f) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i7 = i2 & 2;
        if (i7 == 0) {
            if ((i & 48) == 0) {
                modifier2 = modifier;
                i3 |= composerStartRestartGroup.changed(modifier2) ? 32 : 16;
            }
            if ((i & 384) == 0) {
                if ((i2 & 4) == 0) {
                    circularColor = j;
                    if (composerStartRestartGroup.changed(circularColor)) {
                        i6 = Fields.RotationX;
                    }
                    i3 |= i6;
                } else {
                    circularColor = j;
                }
                i6 = Fields.SpotShadowColor;
                i3 |= i6;
            } else {
                circularColor = j;
            }
            i4 = i2 & 8;
            if (i4 != 0) {
                if ((i & 3072) == 0) {
                    f3 = f2;
                    if (composerStartRestartGroup.changed(f3)) {
                        i5 = Fields.CameraDistance;
                    } else {
                        i5 = Fields.RotationZ;
                    }
                    i3 |= i5;
                }
                if ((i3 & 1171) == 1170 || !composerStartRestartGroup.getSkipping()) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                        if (i7 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i2 & 4) != 0) {
                            circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                            i3 &= -897;
                        }
                        if (i4 != 0) {
                            fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                            j2 = circularColor;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(402841196, i3, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:753)");
                        }
                        m2670CircularProgressIndicatorDUhRLBM(f, companion, j2, fM2666getCircularStrokeWidthD9Ej5fM, ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6), ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw(), composerStartRestartGroup, (i3 & 14) | 196608 | (i3 & 112) | (i3 & 896) | (i3 & 7168), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        if ((i2 & 4) != 0) {
                            i3 &= -897;
                        }
                        companion = modifier2;
                    }
                    j2 = circularColor;
                    fM2666getCircularStrokeWidthD9Ej5fM = f3;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(402841196, i3, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:753)");
                    }
                    m2670CircularProgressIndicatorDUhRLBM(f, companion, j2, fM2666getCircularStrokeWidthD9Ej5fM, ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6), ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw(), composerStartRestartGroup, (i3 & 14) | 196608 | (i3 & 112) | (i3 & 896) | (i3 & 7168), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                } else {
                    composerStartRestartGroup.skipToGroupEnd();
                    companion = modifier2;
                    j2 = circularColor;
                    fM2666getCircularStrokeWidthD9Ej5fM = f3;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier3 = companion;
                    final long j3 = j2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i8) {
                            ProgressIndicatorKt.m2674CircularProgressIndicatorMBs18nI(f, modifier3, j3, fM2666getCircularStrokeWidthD9Ej5fM, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            f3 = f2;
            if ((i3 & 1171) == 1170) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i7 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i3 &= -897;
                    }
                    if (i4 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                        j2 = circularColor;
                    } else {
                        j2 = circularColor;
                        fM2666getCircularStrokeWidthD9Ej5fM = f3;
                    }
                } else {
                    if (i7 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i3 &= -897;
                    }
                    if (i4 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                        j2 = circularColor;
                    } else {
                        j2 = circularColor;
                        fM2666getCircularStrokeWidthD9Ej5fM = f3;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(402841196, i3, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:753)");
                }
                m2670CircularProgressIndicatorDUhRLBM(f, companion, j2, fM2666getCircularStrokeWidthD9Ej5fM, ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6), ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw(), composerStartRestartGroup, (i3 & 14) | 196608 | (i3 & 112) | (i3 & 896) | (i3 & 7168), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i7 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i3 &= -897;
                    }
                    if (i4 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                        j2 = circularColor;
                    } else {
                        j2 = circularColor;
                        fM2666getCircularStrokeWidthD9Ej5fM = f3;
                    }
                } else {
                    if (i7 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i3 &= -897;
                    }
                    if (i4 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                        j2 = circularColor;
                    } else {
                        j2 = circularColor;
                        fM2666getCircularStrokeWidthD9Ej5fM = f3;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(402841196, i3, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:753)");
                }
                m2670CircularProgressIndicatorDUhRLBM(f, companion, j2, fM2666getCircularStrokeWidthD9Ej5fM, ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6), ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw(), composerStartRestartGroup, (i3 & 14) | 196608 | (i3 & 112) | (i3 & 896) | (i3 & 7168), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier4 = companion;
                final long j4 = j2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i8) {
                        ProgressIndicatorKt.m2674CircularProgressIndicatorMBs18nI(f, modifier4, j4, fM2666getCircularStrokeWidthD9Ej5fM, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        modifier2 = modifier;
        if ((i & 384) == 0) {
            if ((i2 & 4) == 0) {
                circularColor = j;
                if (composerStartRestartGroup.changed(circularColor)) {
                    i6 = Fields.RotationX;
                }
                i3 |= i6;
            } else {
                circularColor = j;
            }
            i6 = Fields.SpotShadowColor;
            i3 |= i6;
        } else {
            circularColor = j;
        }
        i4 = i2 & 8;
        if (i4 != 0) {
            if ((i & 3072) == 0) {
                f3 = f2;
                if (composerStartRestartGroup.changed(f3)) {
                    i5 = Fields.CameraDistance;
                } else {
                    i5 = Fields.RotationZ;
                }
                i3 |= i5;
            }
            if ((i3 & 1171) == 1170) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i7 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i3 &= -897;
                    }
                    if (i4 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                        j2 = circularColor;
                    } else {
                        j2 = circularColor;
                        fM2666getCircularStrokeWidthD9Ej5fM = f3;
                    }
                } else {
                    if (i7 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i3 &= -897;
                    }
                    if (i4 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                        j2 = circularColor;
                    } else {
                        j2 = circularColor;
                        fM2666getCircularStrokeWidthD9Ej5fM = f3;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(402841196, i3, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:753)");
                }
                m2670CircularProgressIndicatorDUhRLBM(f, companion, j2, fM2666getCircularStrokeWidthD9Ej5fM, ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6), ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw(), composerStartRestartGroup, (i3 & 14) | 196608 | (i3 & 112) | (i3 & 896) | (i3 & 7168), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i7 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i3 &= -897;
                    }
                    if (i4 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                        j2 = circularColor;
                    } else {
                        j2 = circularColor;
                        fM2666getCircularStrokeWidthD9Ej5fM = f3;
                    }
                } else {
                    if (i7 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 4) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i3 &= -897;
                    }
                    if (i4 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                        j2 = circularColor;
                    } else {
                        j2 = circularColor;
                        fM2666getCircularStrokeWidthD9Ej5fM = f3;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(402841196, i3, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:753)");
                }
                m2670CircularProgressIndicatorDUhRLBM(f, companion, j2, fM2666getCircularStrokeWidthD9Ej5fM, ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6), ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw(), composerStartRestartGroup, (i3 & 14) | 196608 | (i3 & 112) | (i3 & 896) | (i3 & 7168), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier5 = companion;
                final long j5 = j2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i8) {
                        ProgressIndicatorKt.m2674CircularProgressIndicatorMBs18nI(f, modifier5, j5, fM2666getCircularStrokeWidthD9Ej5fM, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 3072;
        f3 = f2;
        if ((i3 & 1171) == 1170) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i7 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 4) != 0) {
                    circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                    i3 &= -897;
                }
                if (i4 != 0) {
                    fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    j2 = circularColor;
                } else {
                    j2 = circularColor;
                    fM2666getCircularStrokeWidthD9Ej5fM = f3;
                }
            } else {
                if (i7 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 4) != 0) {
                    circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                    i3 &= -897;
                }
                if (i4 != 0) {
                    fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    j2 = circularColor;
                } else {
                    j2 = circularColor;
                    fM2666getCircularStrokeWidthD9Ej5fM = f3;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(402841196, i3, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:753)");
            }
            m2670CircularProgressIndicatorDUhRLBM(f, companion, j2, fM2666getCircularStrokeWidthD9Ej5fM, ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6), ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw(), composerStartRestartGroup, (i3 & 14) | 196608 | (i3 & 112) | (i3 & 896) | (i3 & 7168), 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i7 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 4) != 0) {
                    circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                    i3 &= -897;
                }
                if (i4 != 0) {
                    fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    j2 = circularColor;
                } else {
                    j2 = circularColor;
                    fM2666getCircularStrokeWidthD9Ej5fM = f3;
                }
            } else {
                if (i7 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 4) != 0) {
                    circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                    i3 &= -897;
                }
                if (i4 != 0) {
                    fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    j2 = circularColor;
                } else {
                    j2 = circularColor;
                    fM2666getCircularStrokeWidthD9Ej5fM = f3;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(402841196, i3, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:753)");
            }
            m2670CircularProgressIndicatorDUhRLBM(f, companion, j2, fM2666getCircularStrokeWidthD9Ej5fM, ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6), ProgressIndicatorDefaults.INSTANCE.m2663getCircularDeterminateStrokeCapKaPHkGw(), composerStartRestartGroup, (i3 & 14) | 196608 | (i3 & 112) | (i3 & 896) | (i3 & 7168), 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier6 = companion;
            final long j6 = j2;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i8) {
                    ProgressIndicatorKt.m2674CircularProgressIndicatorMBs18nI(f, modifier6, j6, fM2666getCircularStrokeWidthD9Ej5fM, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Maintained for binary compatibility")
    public static final void m2675CircularProgressIndicatoraMcp0Q(Modifier modifier, long j, float f, Composer composer, final int i, final int i2) {
        Modifier modifier2;
        int i3;
        long circularColor;
        float f2;
        Modifier.Companion companion;
        float fM2666getCircularStrokeWidthD9Ej5fM;
        int i4;
        long j2;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        Composer composerStartRestartGroup = composer.startRestartGroup(947193756);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(CircularProgressIndicator)P(1,0:c#ui.graphics.Color,2:c#ui.unit.Dp)767@31299L13,774@31518L18,770@31390L231:ProgressIndicator.kt#uh7d8r");
        int i5 = i2 & 1;
        if (i5 != 0) {
            i3 = i | 6;
            modifier2 = modifier;
        } else if ((i & 6) == 0) {
            modifier2 = modifier;
            i3 = (composerStartRestartGroup.changed(modifier2) ? 4 : 2) | i;
        } else {
            modifier2 = modifier;
            i3 = i;
        }
        if ((i & 48) == 0) {
            if ((i2 & 2) == 0) {
                circularColor = j;
                int i6 = composerStartRestartGroup.changed(circularColor) ? 32 : 16;
                i3 |= i6;
            } else {
                circularColor = j;
            }
            i3 |= i6;
        } else {
            circularColor = j;
        }
        int i7 = i2 & 4;
        if (i7 == 0) {
            if ((i & 384) == 0) {
                f2 = f;
                i3 |= composerStartRestartGroup.changed(f2) ? Fields.RotationX : Fields.SpotShadowColor;
            }
            if ((i3 & 147) == 146 || !composerStartRestartGroup.getSkipping()) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                    if (i5 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 2) != 0) {
                        circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                        i3 &= -113;
                    }
                    if (i7 != 0) {
                        fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                    }
                    long j3 = circularColor;
                    i4 = i3;
                    j2 = j3;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(947193756, i4, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:770)");
                    }
                    m2673CircularProgressIndicatorLxG7B9w(companion, j2, fM2666getCircularStrokeWidthD9Ej5fM, ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6), ProgressIndicatorDefaults.INSTANCE.m2664getCircularIndeterminateStrokeCapKaPHkGw(), composerStartRestartGroup, (i4 & 14) | 24576 | (i4 & 112) | (i4 & 896), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    f2 = fM2666getCircularStrokeWidthD9Ej5fM;
                } else {
                    composerStartRestartGroup.skipToGroupEnd();
                    if ((i2 & 2) != 0) {
                        i3 &= -113;
                    }
                    companion = modifier2;
                }
                fM2666getCircularStrokeWidthD9Ej5fM = f2;
                long j4 = circularColor;
                i4 = i3;
                j2 = j4;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(947193756, i4, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:770)");
                }
                m2673CircularProgressIndicatorLxG7B9w(companion, j2, fM2666getCircularStrokeWidthD9Ej5fM, ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6), ProgressIndicatorDefaults.INSTANCE.m2664getCircularIndeterminateStrokeCapKaPHkGw(), composerStartRestartGroup, (i4 & 14) | 24576 | (i4 & 112) | (i4 & 896), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                f2 = fM2666getCircularStrokeWidthD9Ej5fM;
            } else {
                composerStartRestartGroup.skipToGroupEnd();
                companion = modifier2;
                j2 = circularColor;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier3 = companion;
                final long j5 = j2;
                final float f3 = f2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i8) {
                        ProgressIndicatorKt.m2675CircularProgressIndicatoraMcp0Q(modifier3, j5, f3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 384;
        f2 = f;
        if ((i3 & 147) == 146) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i5 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 2) != 0) {
                    circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                    i3 &= -113;
                }
                if (i7 != 0) {
                    fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                } else {
                    fM2666getCircularStrokeWidthD9Ej5fM = f2;
                }
            } else {
                if (i5 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 2) != 0) {
                    circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                    i3 &= -113;
                }
                if (i7 != 0) {
                    fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                } else {
                    fM2666getCircularStrokeWidthD9Ej5fM = f2;
                }
            }
            long j6 = circularColor;
            i4 = i3;
            j2 = j6;
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(947193756, i4, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:770)");
            }
            m2673CircularProgressIndicatorLxG7B9w(companion, j2, fM2666getCircularStrokeWidthD9Ej5fM, ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6), ProgressIndicatorDefaults.INSTANCE.m2664getCircularIndeterminateStrokeCapKaPHkGw(), composerStartRestartGroup, (i4 & 14) | 24576 | (i4 & 112) | (i4 & 896), 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            f2 = fM2666getCircularStrokeWidthD9Ej5fM;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i5 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 2) != 0) {
                    circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                    i3 &= -113;
                }
                if (i7 != 0) {
                    fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                } else {
                    fM2666getCircularStrokeWidthD9Ej5fM = f2;
                }
            } else {
                if (i5 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 2) != 0) {
                    circularColor = ProgressIndicatorDefaults.INSTANCE.getCircularColor(composerStartRestartGroup, 6);
                    i3 &= -113;
                }
                if (i7 != 0) {
                    fM2666getCircularStrokeWidthD9Ej5fM = ProgressIndicatorDefaults.INSTANCE.m2666getCircularStrokeWidthD9Ej5fM();
                } else {
                    fM2666getCircularStrokeWidthD9Ej5fM = f2;
                }
            }
            long j7 = circularColor;
            i4 = i3;
            j2 = j7;
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(947193756, i4, -1, "androidx.compose.material3.CircularProgressIndicator (ProgressIndicator.kt:770)");
            }
            m2673CircularProgressIndicatorLxG7B9w(companion, j2, fM2666getCircularStrokeWidthD9Ej5fM, ProgressIndicatorDefaults.INSTANCE.getCircularTrackColor(composerStartRestartGroup, 6), ProgressIndicatorDefaults.INSTANCE.m2664getCircularIndeterminateStrokeCapKaPHkGw(), composerStartRestartGroup, (i4 & 14) | 24576 | (i4 & 112) | (i4 & 896), 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            f2 = fM2666getCircularStrokeWidthD9Ej5fM;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier4 = companion;
            final long j8 = j2;
            final float f4 = f2;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i8) {
                    ProgressIndicatorKt.m2675CircularProgressIndicatoraMcp0Q(modifier4, j8, f4, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void m2688drawCircularIndicator42QJj7c(DrawScope drawScope, float f, float f2, long j, Stroke stroke) {
        float f3 = 2;
        float width = stroke.getWidth() / f3;
        float fM4415getWidthimpl = Size.m4415getWidthimpl(drawScope.mo5083getSizeNHjbRc()) - (f3 * width);
        DrawScope.CC.m5165drawArcyD3GUKo$default(drawScope, j, f, f2, false, OffsetKt.Offset(width, width), androidx.compose.p002ui.geometry.SizeKt.Size(fM4415getWidthimpl, fM4415getWidthimpl), 0.0f, stroke, null, 0, 832, null);
    }

    public static final void m2689drawCircularIndicatorTrackbw27NRU(DrawScope drawScope, long j, Stroke stroke) {
        m2688drawCircularIndicator42QJj7c(drawScope, 0.0f, 360.0f, j, stroke);
    }

    public static final void m2690drawDeterminateCircularIndicator42QJj7c(DrawScope drawScope, float f, float f2, long j, Stroke stroke) {
        m2688drawCircularIndicator42QJj7c(drawScope, f, f2, j, stroke);
    }

    public static final void m2691drawIndeterminateCircularIndicatorhrjfTZI(DrawScope drawScope, float f, float f2, float f3, long j, Stroke stroke) {
        m2688drawCircularIndicator42QJj7c(drawScope, f + (StrokeCap.m4959equalsimpl0(stroke.getCap(), StrokeCap.INSTANCE.m4963getButtKaPHkGw()) ? 0.0f : ((f2 / Dp.constructor-impl(CircularIndicatorDiameter / 2)) * 57.29578f) / 2.0f), Math.max(f3, 0.1f), j, stroke);
    }

    public static final float getLinearIndicatorWidth() {
        return LinearIndicatorWidth;
    }

    public static final float getLinearIndicatorHeight() {
        return LinearIndicatorHeight;
    }

    public static final float getCircularIndicatorDiameter() {
        return CircularIndicatorDiameter;
    }

    static {
        float f = Dp.constructor-impl(10);
        SemanticsBoundsPadding = f;
        IncreaseSemanticsBounds = PaddingKt.m1037paddingVpY3zN4$default(SemanticsModifierKt.semantics(LayoutModifierKt.layout(Modifier.INSTANCE, new Function3<MeasureScope, Measurable, Constraints, MeasureResult>() {
            public Object invoke(Object obj, Object obj2, Object obj3) {
                return m2695invoke3p2s80s((MeasureScope) obj, (Measurable) obj2, ((Constraints) obj3).unbox-impl());
            }

            public final MeasureResult m2695invoke3p2s80s(MeasureScope measureScope, Measurable measurable, long j) {
                final int i = measureScope.roundToPx-0680j_4(ProgressIndicatorKt.SemanticsBoundsPadding);
                int i2 = i * 2;
                final Placeable placeableMo6026measureBRTryo0 = measurable.mo6026measureBRTryo0(ConstraintsKt.offset-NN6Ew-U(j, 0, i2));
                return MeasureScope.CC.layout$default(measureScope, placeableMo6026measureBRTryo0.getWidth(), placeableMo6026measureBRTryo0.getHeight() - i2, null, new Function1<Placeable.PlacementScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((Placeable.PlacementScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Placeable.PlacementScope placementScope) {
                        Placeable.PlacementScope.place$default(placementScope, placeableMo6026measureBRTryo0, 0, -i, 0.0f, 4, null);
                    }
                }, 4, null);
            }
        }), true, new Function1<SemanticsPropertyReceiver, Unit>() {
            public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
            }

            public Object invoke(Object obj) {
                invoke((SemanticsPropertyReceiver) obj);
                return Unit.INSTANCE;
            }
        }), 0.0f, f, 1, null);
        LinearIndicatorWidth = Dp.constructor-impl(240);
        LinearIndicatorHeight = ProgressIndicatorTokens.INSTANCE.m3832getTrackThicknessD9Ej5fM();
        CircularIndicatorDiameter = Dp.constructor-impl(ProgressIndicatorTokens.INSTANCE.m3829getSizeD9Ej5fM() - Dp.constructor-impl(ProgressIndicatorTokens.INSTANCE.m3832getTrackThicknessD9Ej5fM() * 2));
        FirstLineHeadEasing = new CubicBezierEasing(0.2f, 0.0f, 0.8f, 1.0f);
        FirstLineTailEasing = new CubicBezierEasing(0.4f, 0.0f, 1.0f, 1.0f);
        SecondLineHeadEasing = new CubicBezierEasing(0.0f, 0.0f, 0.65f, 1.0f);
        SecondLineTailEasing = new CubicBezierEasing(0.1f, 0.0f, 0.45f, 1.0f);
        CircularEasing = new CubicBezierEasing(0.4f, 0.0f, 0.2f, 1.0f);
    }
}
