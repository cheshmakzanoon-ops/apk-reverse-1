package androidx.compose.material3;

import androidx.compose.animation.core.AnimationSpecKt;
import androidx.compose.animation.core.DecayAnimationSpec;
import androidx.compose.animation.core.DecayAnimationSpecKt;
import androidx.compose.foundation.gestures.FlingBehavior;
import androidx.compose.foundation.gestures.TargetedFlingBehavior;
import androidx.compose.foundation.gestures.snapping.LazyListSnapLayoutInfoProviderKt;
import androidx.compose.foundation.gestures.snapping.SnapFlingBehaviorKt;
import androidx.compose.foundation.gestures.snapping.SnapLayoutInfoProvider;
import androidx.compose.foundation.lazy.LazyListState;
import androidx.compose.material3.internal.Strings;
import androidx.compose.material3.internal.Strings_androidKt;
import androidx.compose.material3.tokens.DatePickerModalTokens;
import androidx.compose.material3.tokens.DividerTokens;
import androidx.compose.material3.tokens.ElevationTokens;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.graphics.Color;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.graphics.Shape;
import androidx.compose.p002ui.semantics.LiveRegionMode;
import androidx.compose.p002ui.semantics.SemanticsModifierKt;
import androidx.compose.p002ui.semantics.SemanticsPropertiesKt;
import androidx.compose.p002ui.semantics.SemanticsPropertyReceiver;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.ui.text.TextLayoutResult;
import androidx.compose.ui.text.TextStyle;
import androidx.compose.ui.text.font.FontFamily;
import androidx.compose.ui.text.font.FontStyle;
import androidx.compose.ui.text.font.FontWeight;
import androidx.compose.ui.text.style.TextAlign;
import androidx.compose.ui.text.style.TextDecoration;
import java.util.Arrays;
import java.util.Locale;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;
import kotlin.ranges.IntRange;

@Metadata(d1 = {"\u0000\u0088\u0001\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\t\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\b\u0018\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0007\n\u0002\b\u0003\bÇ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J6\u0010\u001d\u001a\u00020\u001e2\b\u0010\u001f\u001a\u0004\u0018\u00010 2\u0006\u0010!\u001a\u00020\"2\u0006\u0010#\u001a\u00020$2\b\b\u0002\u0010%\u001a\u00020&H\u0007ø\u0001\u0000¢\u0006\u0004\b'\u0010(J$\u0010)\u001a\u00020\u001e2\u0006\u0010!\u001a\u00020\"2\b\b\u0002\u0010%\u001a\u00020&H\u0007ø\u0001\u0000¢\u0006\u0004\b*\u0010+J\r\u0010,\u001a\u00020\u0019H\u0007¢\u0006\u0002\u0010-J\u008e\u0002\u0010,\u001a\u00020\u00192\b\b\u0002\u0010.\u001a\u00020/2\b\b\u0002\u00100\u001a\u00020/2\b\b\u0002\u00101\u001a\u00020/2\b\b\u0002\u00102\u001a\u00020/2\b\b\u0002\u00103\u001a\u00020/2\b\b\u0002\u00104\u001a\u00020/2\b\b\u0002\u00105\u001a\u00020/2\b\b\u0002\u00106\u001a\u00020/2\b\b\u0002\u00107\u001a\u00020/2\b\b\u0002\u00108\u001a\u00020/2\b\b\u0002\u00109\u001a\u00020/2\b\b\u0002\u0010:\u001a\u00020/2\b\b\u0002\u0010;\u001a\u00020/2\b\b\u0002\u0010<\u001a\u00020/2\b\b\u0002\u0010=\u001a\u00020/2\b\b\u0002\u0010>\u001a\u00020/2\b\b\u0002\u0010?\u001a\u00020/2\b\b\u0002\u0010@\u001a\u00020/2\b\b\u0002\u0010A\u001a\u00020/2\b\b\u0002\u0010B\u001a\u00020/2\b\b\u0002\u0010C\u001a\u00020/2\b\b\u0002\u0010D\u001a\u00020/2\b\b\u0002\u0010E\u001a\u00020/2\b\b\u0002\u0010F\u001a\u00020/2\n\b\u0002\u0010G\u001a\u0004\u0018\u00010HH\u0007ø\u0001\u0000¢\u0006\u0004\bI\u0010JJ$\u0010#\u001a\u00020$2\b\b\u0002\u0010K\u001a\u00020\r2\b\b\u0002\u0010L\u001a\u00020\r2\b\b\u0002\u0010M\u001a\u00020\rJ'\u0010N\u001a\u00020O2\u0006\u0010P\u001a\u00020Q2\u000e\b\u0002\u0010R\u001a\b\u0012\u0004\u0012\u00020T0SH\u0001¢\u0006\u0004\bU\u0010VR\u0011\u0010\u0003\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006R\u0019\u0010\u0007\u001a\u00020\bø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u000b\u001a\u0004\b\t\u0010\nR\u000e\u0010\f\u001a\u00020\rX\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u000e\u001a\u00020\rX\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u000f\u001a\u00020\rX\u0086T¢\u0006\u0002\n\u0000R\u0011\u0010\u0010\u001a\u00020\u0011¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0013R\u0011\u0010\u0014\u001a\u00020\u00158G¢\u0006\u0006\u001a\u0004\b\u0016\u0010\u0017R\u0018\u0010\u0018\u001a\u00020\u0019*\u00020\u001a8AX\u0080\u0004¢\u0006\u0006\u001a\u0004\b\u001b\u0010\u001c\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006W"}, d2 = {"Landroidx/compose/material3/DatePickerDefaults;", "", "()V", "AllDates", "Landroidx/compose/material3/SelectableDates;", "getAllDates", "()Landroidx/compose/material3/SelectableDates;", "TonalElevation", "Landroidx/compose/ui/unit/Dp;", "getTonalElevation-D9Ej5fM", "()F", "F", "YearAbbrMonthDaySkeleton", "", "YearMonthSkeleton", "YearMonthWeekdayDaySkeleton", "YearRange", "Lkotlin/ranges/IntRange;", "getYearRange", "()Lkotlin/ranges/IntRange;", "shape", "Landroidx/compose/ui/graphics/Shape;", "getShape", "(Landroidx/compose/runtime/Composer;I)Landroidx/compose/ui/graphics/Shape;", "defaultDatePickerColors", "Landroidx/compose/material3/DatePickerColors;", "Landroidx/compose/material3/ColorScheme;", "getDefaultDatePickerColors", "(Landroidx/compose/material3/ColorScheme;Landroidx/compose/runtime/Composer;I)Landroidx/compose/material3/DatePickerColors;", "DatePickerHeadline", "", "selectedDateMillis", "", "displayMode", "Landroidx/compose/material3/DisplayMode;", "dateFormatter", "Landroidx/compose/material3/DatePickerFormatter;", "modifier", "Landroidx/compose/ui/Modifier;", "DatePickerHeadline-3kbWawI", "(Ljava/lang/Long;ILandroidx/compose/material3/DatePickerFormatter;Landroidx/compose/ui/Modifier;Landroidx/compose/runtime/Composer;II)V", "DatePickerTitle", "DatePickerTitle-hOD91z4", "(ILandroidx/compose/ui/Modifier;Landroidx/compose/runtime/Composer;II)V", "colors", "(Landroidx/compose/runtime/Composer;I)Landroidx/compose/material3/DatePickerColors;", "containerColor", "Landroidx/compose/ui/graphics/Color;", "titleContentColor", "headlineContentColor", "weekdayContentColor", "subheadContentColor", "navigationContentColor", "yearContentColor", "disabledYearContentColor", "currentYearContentColor", "selectedYearContentColor", "disabledSelectedYearContentColor", "selectedYearContainerColor", "disabledSelectedYearContainerColor", "dayContentColor", "disabledDayContentColor", "selectedDayContentColor", "disabledSelectedDayContentColor", "selectedDayContainerColor", "disabledSelectedDayContainerColor", "todayContentColor", "todayDateBorderColor", "dayInSelectionRangeContentColor", "dayInSelectionRangeContainerColor", "dividerColor", "dateTextFieldColors", "Landroidx/compose/material3/TextFieldColors;", "colors-bSRYm20", "(JJJJJJJJJJJJJJJJJJJJJJJJLandroidx/compose/material3/TextFieldColors;Landroidx/compose/runtime/Composer;IIII)Landroidx/compose/material3/DatePickerColors;", "yearSelectionSkeleton", "selectedDateSkeleton", "selectedDateDescriptionSkeleton", "rememberSnapFlingBehavior", "Landroidx/compose/foundation/gestures/FlingBehavior;", "lazyListState", "Landroidx/compose/foundation/lazy/LazyListState;", "decayAnimationSpec", "Landroidx/compose/animation/core/DecayAnimationSpec;", "", "rememberSnapFlingBehavior$material3_release", "(Landroidx/compose/foundation/lazy/LazyListState;Landroidx/compose/animation/core/DecayAnimationSpec;Landroidx/compose/runtime/Composer;II)Landroidx/compose/foundation/gestures/FlingBehavior;", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class DatePickerDefaults {
    public static final int $stable = 0;
    public static final String YearAbbrMonthDaySkeleton = "yMMMd";
    public static final String YearMonthSkeleton = "yMMMM";
    public static final String YearMonthWeekdayDaySkeleton = "yMMMMEEEEd";
    public static final DatePickerDefaults INSTANCE = new DatePickerDefaults();
    private static final IntRange YearRange = new IntRange(1900, 2100);
    private static final float TonalElevation = ElevationTokens.INSTANCE.m3537getLevel0D9Ej5fM();
    private static final SelectableDates AllDates = new SelectableDates() {
        @Override
        public boolean isSelectableDate(long j) {
            return SelectableDates.CC.$default$isSelectableDate(this, j);
        }

        @Override
        public boolean isSelectableYear(int i) {
            return SelectableDates.CC.$default$isSelectableYear(this, i);
        }
    };

    private DatePickerDefaults() {
    }

    public final DatePickerColors colors(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, -275219611, "C(colors)432@18805L11,432@18817L23:DatePicker.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-275219611, i, -1, "androidx.compose.material3.DatePickerDefaults.colors (DatePicker.kt:432)");
        }
        DatePickerColors defaultDatePickerColors = getDefaultDatePickerColors(MaterialTheme.INSTANCE.getColorScheme(composer, 6), composer, (i << 3) & 112);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return defaultDatePickerColors;
    }

    public final DatePickerColors m2271colorsbSRYm20(long j, long j2, long j3, long j4, long j5, long j6, long j7, long j8, long j9, long j10, long j11, long j12, long j13, long j14, long j15, long j16, long j17, long j18, long j19, long j20, long j21, long j22, long j23, long j24, TextFieldColors textFieldColors, Composer composer, int i, int i2, int i3, int i4) {
        ComposerKt.sourceInformationMarkerStart(composer, 1991626358, "C(colors)P(0:c#ui.graphics.Color,20:c#ui.graphics.Color,13:c#ui.graphics.Color,23:c#ui.graphics.Color,19:c#ui.graphics.Color,14:c#ui.graphics.Color,24:c#ui.graphics.Color,11:c#ui.graphics.Color,1:c#ui.graphics.Color,18:c#ui.graphics.Color,10:c#ui.graphics.Color,17:c#ui.graphics.Color,9:c#ui.graphics.Color,3:c#ui.graphics.Color,6:c#ui.graphics.Color,16:c#ui.graphics.Color,8:c#ui.graphics.Color,15:c#ui.graphics.Color,7:c#ui.graphics.Color,21:c#ui.graphics.Color,22:c#ui.graphics.Color,5:c#ui.graphics.Color,4:c#ui.graphics.Color,12:c#ui.graphics.Color)501@23101L11,501@23113L23:DatePicker.kt#uh7d8r");
        long jM4626getUnspecified0d7_KjU = (i4 & 1) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j;
        long jM4626getUnspecified0d7_KjU2 = (i4 & 2) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j2;
        long jM4626getUnspecified0d7_KjU3 = (i4 & 4) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j3;
        long jM4626getUnspecified0d7_KjU4 = (i4 & 8) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j4;
        long jM4626getUnspecified0d7_KjU5 = (i4 & 16) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j5;
        long jM4626getUnspecified0d7_KjU6 = (i4 & 32) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j6;
        long jM4626getUnspecified0d7_KjU7 = (i4 & 64) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j7;
        long jM4626getUnspecified0d7_KjU8 = (i4 & Fields.SpotShadowColor) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j8;
        long jM4626getUnspecified0d7_KjU9 = (i4 & Fields.RotationX) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j9;
        long jM4626getUnspecified0d7_KjU10 = (i4 & Fields.RotationY) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j10;
        long jM4626getUnspecified0d7_KjU11 = (i4 & Fields.RotationZ) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j11;
        long jM4626getUnspecified0d7_KjU12 = (i4 & Fields.CameraDistance) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j12;
        long jM4626getUnspecified0d7_KjU13 = (i4 & Fields.TransformOrigin) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j13;
        long jM4626getUnspecified0d7_KjU14 = (i4 & Fields.Shape) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j14;
        long jM4626getUnspecified0d7_KjU15 = (i4 & Fields.Clip) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j15;
        long jM4626getUnspecified0d7_KjU16 = (32768 & i4) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j16;
        long jM4626getUnspecified0d7_KjU17 = (65536 & i4) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j17;
        long jM4626getUnspecified0d7_KjU18 = (131072 & i4) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j18;
        long jM4626getUnspecified0d7_KjU19 = (262144 & i4) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j19;
        long jM4626getUnspecified0d7_KjU20 = (524288 & i4) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j20;
        long jM4626getUnspecified0d7_KjU21 = (1048576 & i4) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j21;
        long jM4626getUnspecified0d7_KjU22 = (2097152 & i4) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j22;
        long jM4626getUnspecified0d7_KjU23 = (4194304 & i4) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j23;
        long jM4626getUnspecified0d7_KjU24 = (8388608 & i4) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j24;
        TextFieldColors textFieldColors2 = (i4 & 16777216) != 0 ? null : textFieldColors;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1991626358, i, i2, "androidx.compose.material3.DatePickerDefaults.colors (DatePicker.kt:501)");
        }
        DatePickerColors datePickerColorsM2243copytNwlRmA = getDefaultDatePickerColors(MaterialTheme.INSTANCE.getColorScheme(composer, 6), composer, (i3 >> 12) & 112).m2243copytNwlRmA(jM4626getUnspecified0d7_KjU, jM4626getUnspecified0d7_KjU2, jM4626getUnspecified0d7_KjU3, jM4626getUnspecified0d7_KjU4, jM4626getUnspecified0d7_KjU5, jM4626getUnspecified0d7_KjU6, jM4626getUnspecified0d7_KjU7, jM4626getUnspecified0d7_KjU8, jM4626getUnspecified0d7_KjU9, jM4626getUnspecified0d7_KjU10, jM4626getUnspecified0d7_KjU11, jM4626getUnspecified0d7_KjU12, jM4626getUnspecified0d7_KjU13, jM4626getUnspecified0d7_KjU14, jM4626getUnspecified0d7_KjU15, jM4626getUnspecified0d7_KjU16, jM4626getUnspecified0d7_KjU17, jM4626getUnspecified0d7_KjU18, jM4626getUnspecified0d7_KjU19, jM4626getUnspecified0d7_KjU20, jM4626getUnspecified0d7_KjU21, jM4626getUnspecified0d7_KjU23, jM4626getUnspecified0d7_KjU22, jM4626getUnspecified0d7_KjU24, textFieldColors2);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return datePickerColorsM2243copytNwlRmA;
    }

    public final DatePickerColors getDefaultDatePickerColors(ColorScheme colorScheme, Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 1180555308, "C:DatePicker.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1180555308, i, -1, "androidx.compose.material3.DatePickerDefaults.<get-defaultDatePickerColors> (DatePicker.kt:531)");
        }
        DatePickerColors defaultDatePickerColorsCached = colorScheme.getDefaultDatePickerColorsCached();
        composer.startReplaceGroup(-653681037);
        ComposerKt.sourceInformation(composer, "*589@28839L30");
        if (defaultDatePickerColorsCached == null) {
            defaultDatePickerColorsCached = new DatePickerColors(ColorSchemeKt.fromToken(colorScheme, DatePickerModalTokens.INSTANCE.getContainerColor()), ColorSchemeKt.fromToken(colorScheme, DatePickerModalTokens.INSTANCE.getHeaderSupportingTextColor()), ColorSchemeKt.fromToken(colorScheme, DatePickerModalTokens.INSTANCE.getHeaderHeadlineColor()), ColorSchemeKt.fromToken(colorScheme, DatePickerModalTokens.INSTANCE.getWeekdaysLabelTextColor()), ColorSchemeKt.fromToken(colorScheme, DatePickerModalTokens.INSTANCE.getRangeSelectionMonthSubheadColor()), colorScheme.getOnSurfaceVariant(), ColorSchemeKt.fromToken(colorScheme, DatePickerModalTokens.INSTANCE.getSelectionYearUnselectedLabelTextColor()), Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, DatePickerModalTokens.INSTANCE.getSelectionYearUnselectedLabelTextColor()), 0.38f, 0.0f, 0.0f, 0.0f, 14, null), ColorSchemeKt.fromToken(colorScheme, DatePickerModalTokens.INSTANCE.getDateTodayLabelTextColor()), ColorSchemeKt.fromToken(colorScheme, DatePickerModalTokens.INSTANCE.getSelectionYearSelectedLabelTextColor()), Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, DatePickerModalTokens.INSTANCE.getSelectionYearSelectedLabelTextColor()), 0.38f, 0.0f, 0.0f, 0.0f, 14, null), ColorSchemeKt.fromToken(colorScheme, DatePickerModalTokens.INSTANCE.getSelectionYearSelectedContainerColor()), Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, DatePickerModalTokens.INSTANCE.getSelectionYearSelectedContainerColor()), 0.38f, 0.0f, 0.0f, 0.0f, 14, null), ColorSchemeKt.fromToken(colorScheme, DatePickerModalTokens.INSTANCE.getDateUnselectedLabelTextColor()), Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, DatePickerModalTokens.INSTANCE.getDateUnselectedLabelTextColor()), 0.38f, 0.0f, 0.0f, 0.0f, 14, null), ColorSchemeKt.fromToken(colorScheme, DatePickerModalTokens.INSTANCE.getDateSelectedLabelTextColor()), Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, DatePickerModalTokens.INSTANCE.getDateSelectedLabelTextColor()), 0.38f, 0.0f, 0.0f, 0.0f, 14, null), ColorSchemeKt.fromToken(colorScheme, DatePickerModalTokens.INSTANCE.getDateSelectedContainerColor()), Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, DatePickerModalTokens.INSTANCE.getDateSelectedContainerColor()), 0.38f, 0.0f, 0.0f, 0.0f, 14, null), ColorSchemeKt.fromToken(colorScheme, DatePickerModalTokens.INSTANCE.getDateTodayLabelTextColor()), ColorSchemeKt.fromToken(colorScheme, DatePickerModalTokens.INSTANCE.getDateTodayContainerOutlineColor()), ColorSchemeKt.fromToken(colorScheme, DatePickerModalTokens.INSTANCE.getRangeSelectionActiveIndicatorContainerColor()), ColorSchemeKt.fromToken(colorScheme, DatePickerModalTokens.INSTANCE.getSelectionDateInRangeLabelTextColor()), ColorSchemeKt.fromToken(colorScheme, DividerTokens.INSTANCE.getColor()), OutlinedTextFieldDefaults.INSTANCE.getDefaultOutlinedTextFieldColors(colorScheme, composer, (i & 14) | 48), null);
            colorScheme.setDefaultDatePickerColorsCached$material3_release(defaultDatePickerColorsCached);
        }
        composer.endReplaceGroup();
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return defaultDatePickerColorsCached;
    }

    public static DatePickerFormatter dateFormatter$default(DatePickerDefaults datePickerDefaults, String str, String str2, String str3, int i, Object obj) {
        if ((i & 1) != 0) {
            str = YearMonthSkeleton;
        }
        if ((i & 2) != 0) {
            str2 = YearAbbrMonthDaySkeleton;
        }
        if ((i & 4) != 0) {
            str3 = YearMonthWeekdayDaySkeleton;
        }
        return datePickerDefaults.dateFormatter(str, str2, str3);
    }

    public final DatePickerFormatter dateFormatter(String yearSelectionSkeleton, String selectedDateSkeleton, String selectedDateDescriptionSkeleton) {
        return new DatePickerFormatterImpl(yearSelectionSkeleton, selectedDateSkeleton, selectedDateDescriptionSkeleton);
    }

    public final void m2270DatePickerTitlehOD91z4(final int i, Modifier modifier, Composer composer, final int i2, final int i3) {
        int i4;
        Modifier modifier2;
        int i5;
        Modifier modifier3;
        final Modifier modifier4;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        Composer composerStartRestartGroup = composer.startRestartGroup(327413563);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(DatePickerTitle)P(0:c#material3.DisplayMode):DatePicker.kt#uh7d8r");
        if ((i3 & 1) != 0) {
            i4 = i2 | 6;
        } else if ((i2 & 6) == 0) {
            i4 = i2 | (composerStartRestartGroup.changed(i) ? 4 : 2);
        } else {
            i4 = i2;
        }
        int i6 = i3 & 2;
        if (i6 == 0) {
            if ((i2 & 48) == 0) {
                modifier2 = modifier;
                i4 |= composerStartRestartGroup.changed(modifier2) ? 32 : 16;
            }
            i5 = i4;
            if ((i5 & 19) == 18 || !composerStartRestartGroup.getSkipping()) {
                if (i6 != 0) {
                    modifier3 = Modifier.INSTANCE;
                } else {
                    modifier3 = modifier2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(327413563, i5, -1, "androidx.compose.material3.DatePickerDefaults.DatePickerTitle (DatePicker.kt:629)");
                }
                if (DisplayMode.m2336equalsimpl0(i, DisplayMode.INSTANCE.m2341getPickerjFl4v0())) {
                    composerStartRestartGroup.startReplaceGroup(406439148);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "632@30821L43,632@30809L77");
                    Strings.Companion companion = Strings.INSTANCE;
                    TextKt.m3021Text4IGK_g(Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_picker_title), composerStartRestartGroup, 0), modifier3, 0L, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1<? super TextLayoutResult, Unit>) null, (TextStyle) null, composerStartRestartGroup, i5 & 112, 0, 131068);
                    composerStartRestartGroup.endReplaceGroup();
                } else if (DisplayMode.m2336equalsimpl0(i, DisplayMode.INSTANCE.m2340getInputjFl4v0())) {
                    composerStartRestartGroup.startReplaceGroup(406443211);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "634@30948L42,634@30936L76");
                    Strings.Companion companion2 = Strings.INSTANCE;
                    TextKt.m3021Text4IGK_g(Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_input_title), composerStartRestartGroup, 0), modifier3, 0L, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1<? super TextLayoutResult, Unit>) null, (TextStyle) null, composerStartRestartGroup, i5 & 112, 0, 131068);
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(-285079389);
                    composerStartRestartGroup.endReplaceGroup();
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier4 = modifier3;
            } else {
                composerStartRestartGroup.skipToGroupEnd();
                modifier4 = modifier2;
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

                    public final void invoke(Composer composer2, int i7) {
                        this.$tmp0_rcvr.m2270DatePickerTitlehOD91z4(i, modifier4, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                    }
                });
            }
        }
        i4 |= 48;
        modifier2 = modifier;
        i5 = i4;
        if ((i5 & 19) == 18) {
            if (i6 != 0) {
                modifier3 = Modifier.INSTANCE;
            } else {
                modifier3 = modifier2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(327413563, i5, -1, "androidx.compose.material3.DatePickerDefaults.DatePickerTitle (DatePicker.kt:629)");
            }
            if (DisplayMode.m2336equalsimpl0(i, DisplayMode.INSTANCE.m2341getPickerjFl4v0())) {
                composerStartRestartGroup.startReplaceGroup(406439148);
                ComposerKt.sourceInformation(composerStartRestartGroup, "632@30821L43,632@30809L77");
                Strings.Companion companion3 = Strings.INSTANCE;
                TextKt.m3021Text4IGK_g(Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_picker_title), composerStartRestartGroup, 0), modifier3, 0L, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1<? super TextLayoutResult, Unit>) null, (TextStyle) null, composerStartRestartGroup, i5 & 112, 0, 131068);
                composerStartRestartGroup.endReplaceGroup();
            } else if (DisplayMode.m2336equalsimpl0(i, DisplayMode.INSTANCE.m2340getInputjFl4v0())) {
                composerStartRestartGroup.startReplaceGroup(406443211);
                ComposerKt.sourceInformation(composerStartRestartGroup, "634@30948L42,634@30936L76");
                Strings.Companion companion4 = Strings.INSTANCE;
                TextKt.m3021Text4IGK_g(Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_input_title), composerStartRestartGroup, 0), modifier3, 0L, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1<? super TextLayoutResult, Unit>) null, (TextStyle) null, composerStartRestartGroup, i5 & 112, 0, 131068);
                composerStartRestartGroup.endReplaceGroup();
            } else {
                composerStartRestartGroup.startReplaceGroup(-285079389);
                composerStartRestartGroup.endReplaceGroup();
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier4 = modifier3;
        } else {
            if (i6 != 0) {
                modifier3 = Modifier.INSTANCE;
            } else {
                modifier3 = modifier2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(327413563, i5, -1, "androidx.compose.material3.DatePickerDefaults.DatePickerTitle (DatePicker.kt:629)");
            }
            if (DisplayMode.m2336equalsimpl0(i, DisplayMode.INSTANCE.m2341getPickerjFl4v0())) {
                composerStartRestartGroup.startReplaceGroup(406439148);
                ComposerKt.sourceInformation(composerStartRestartGroup, "632@30821L43,632@30809L77");
                Strings.Companion companion5 = Strings.INSTANCE;
                TextKt.m3021Text4IGK_g(Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_picker_title), composerStartRestartGroup, 0), modifier3, 0L, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1<? super TextLayoutResult, Unit>) null, (TextStyle) null, composerStartRestartGroup, i5 & 112, 0, 131068);
                composerStartRestartGroup.endReplaceGroup();
            } else if (DisplayMode.m2336equalsimpl0(i, DisplayMode.INSTANCE.m2340getInputjFl4v0())) {
                composerStartRestartGroup.startReplaceGroup(406443211);
                ComposerKt.sourceInformation(composerStartRestartGroup, "634@30948L42,634@30936L76");
                Strings.Companion companion6 = Strings.INSTANCE;
                TextKt.m3021Text4IGK_g(Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_input_title), composerStartRestartGroup, 0), modifier3, 0L, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1<? super TextLayoutResult, Unit>) null, (TextStyle) null, composerStartRestartGroup, i5 & 112, 0, 131068);
                composerStartRestartGroup.endReplaceGroup();
            } else {
                composerStartRestartGroup.startReplaceGroup(-285079389);
                composerStartRestartGroup.endReplaceGroup();
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier4 = modifier3;
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

                public final void invoke(Composer composer2, int i7) {
                    this.$tmp0_rcvr.m2270DatePickerTitlehOD91z4(i, modifier4, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                }
            });
        }
    }

    public final void m2269DatePickerHeadline3kbWawI(final Long l, final int i, final DatePickerFormatter datePickerFormatter, Modifier modifier, Composer composer, final int i2, final int i3) {
        int i4;
        Modifier modifier2;
        Modifier modifier3;
        String date$default;
        String date;
        String strM3334getString2EP1pXo;
        final String str;
        boolean zChanged;
        Object objRememberedValue;
        Composer composer2;
        final Modifier modifier4;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        Composer composerStartRestartGroup = composer.startRestartGroup(1502835813);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(DatePickerHeadline)P(3,1:c#material3.DisplayMode)655@31791L15,688@33142L135,685@33045L268:DatePicker.kt#uh7d8r");
        if ((i3 & 1) != 0) {
            i4 = i2 | 6;
        } else if ((i2 & 6) == 0) {
            i4 = (composerStartRestartGroup.changed(l) ? 4 : 2) | i2;
        } else {
            i4 = i2;
        }
        if ((i3 & 2) != 0) {
            i4 |= 48;
        } else if ((i2 & 48) == 0) {
            i4 |= composerStartRestartGroup.changed(i) ? 32 : 16;
        }
        if ((i3 & 4) != 0) {
            i4 |= 384;
        } else if ((i2 & 384) == 0) {
            i4 |= (i2 & Fields.RotationY) == 0 ? composerStartRestartGroup.changed(datePickerFormatter) : composerStartRestartGroup.changedInstance(datePickerFormatter) ? Fields.RotationX : Fields.SpotShadowColor;
        }
        int i5 = i3 & 8;
        if (i5 == 0) {
            if ((i2 & 3072) == 0) {
                modifier2 = modifier;
                i4 |= composerStartRestartGroup.changed(modifier2) ? Fields.CameraDistance : Fields.RotationZ;
            }
            if ((i4 & 1171) == 1170 || !composerStartRestartGroup.getSkipping()) {
                if (i5 != 0) {
                    modifier3 = Modifier.INSTANCE;
                } else {
                    modifier3 = modifier2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1502835813, i4, -1, "androidx.compose.material3.DatePickerDefaults.DatePickerHeadline (DatePicker.kt:654)");
                }
                Locale localeDefaultLocale = CalendarLocale_androidKt.defaultLocale(composerStartRestartGroup, 0);
                date$default = DatePickerFormatter.CC.formatDate$default(datePickerFormatter, l, localeDefaultLocale, false, 4, null);
                date = datePickerFormatter.formatDate(l, localeDefaultLocale, true);
                composerStartRestartGroup.startReplaceGroup(1148835145);
                strM3334getString2EP1pXo = "";
                ComposerKt.sourceInformation(composerStartRestartGroup, "");
                if (date == null) {
                    if (DisplayMode.m2336equalsimpl0(i, DisplayMode.INSTANCE.m2341getPickerjFl4v0())) {
                        composerStartRestartGroup.startReplaceGroup(1148842944);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "665@32234L51");
                        Strings.Companion companion = Strings.INSTANCE;
                        date = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_picker_no_selection_description), composerStartRestartGroup, 0);
                        composerStartRestartGroup.endReplaceGroup();
                    } else if (DisplayMode.m2336equalsimpl0(i, DisplayMode.INSTANCE.m2340getInputjFl4v0())) {
                        composerStartRestartGroup.startReplaceGroup(1148845915);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "666@32327L46");
                        Strings.Companion companion2 = Strings.INSTANCE;
                        date = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_input_no_input_description), composerStartRestartGroup, 0);
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(1254558033);
                        composerStartRestartGroup.endReplaceGroup();
                        date = "";
                    }
                }
                composerStartRestartGroup.endReplaceGroup();
                composerStartRestartGroup.startReplaceGroup(1148850481);
                ComposerKt.sourceInformation(composerStartRestartGroup, "");
                if (date$default == null) {
                    if (DisplayMode.m2336equalsimpl0(i, DisplayMode.INSTANCE.m2341getPickerjFl4v0())) {
                        composerStartRestartGroup.startReplaceGroup(1148853330);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "673@32559L37");
                        Strings.Companion companion3 = Strings.INSTANCE;
                        date$default = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_picker_headline), composerStartRestartGroup, 0);
                        composerStartRestartGroup.endReplaceGroup();
                    } else if (DisplayMode.m2336equalsimpl0(i, DisplayMode.INSTANCE.m2340getInputjFl4v0())) {
                        composerStartRestartGroup.startReplaceGroup(1148855857);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "674@32638L36");
                        Strings.Companion companion4 = Strings.INSTANCE;
                        date$default = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_input_headline), composerStartRestartGroup, 0);
                        composerStartRestartGroup.endReplaceGroup();
                    } else {
                        composerStartRestartGroup.startReplaceGroup(1254856625);
                        composerStartRestartGroup.endReplaceGroup();
                        date$default = "";
                    }
                }
                composerStartRestartGroup.endReplaceGroup();
                if (DisplayMode.m2336equalsimpl0(i, DisplayMode.INSTANCE.m2341getPickerjFl4v0())) {
                    composerStartRestartGroup.startReplaceGroup(1148862013);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "680@32830L48");
                    Strings.Companion companion5 = Strings.INSTANCE;
                    strM3334getString2EP1pXo = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_picker_headline_description), composerStartRestartGroup, 0);
                    composerStartRestartGroup.endReplaceGroup();
                } else if (DisplayMode.m2336equalsimpl0(i, DisplayMode.INSTANCE.m2340getInputjFl4v0())) {
                    composerStartRestartGroup.startReplaceGroup(1148864764);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "681@32916L47");
                    Strings.Companion companion6 = Strings.INSTANCE;
                    strM3334getString2EP1pXo = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_input_headline_description), composerStartRestartGroup, 0);
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(1255139345);
                    composerStartRestartGroup.endReplaceGroup();
                }
                str = String.format(strM3334getString2EP1pXo, Arrays.copyOf(new Object[]{date}, 1));
                Intrinsics.checkNotNullExpressionValue(str, "format(this, *args)");
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1148872084, "CC(remember):DatePicker.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(str);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SemanticsPropertyReceiver) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            SemanticsPropertiesKt.m6629setLiveRegionhR3wRGc(semanticsPropertyReceiver, LiveRegionMode.INSTANCE.m6603getPolite0phEisY());
                            SemanticsPropertiesKt.setContentDescription(semanticsPropertyReceiver, str);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Modifier modifier5 = modifier3;
                composer2 = composerStartRestartGroup;
                TextKt.m3021Text4IGK_g(date$default, SemanticsModifierKt.semantics$default(modifier3, false, (Function1) objRememberedValue, 1, null), 0L, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 1, 0, (Function1<? super TextLayoutResult, Unit>) null, (TextStyle) null, composer2, 0, 3072, 122876);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier4 = modifier5;
            } else {
                composerStartRestartGroup.skipToGroupEnd();
                modifier4 = modifier2;
                composer2 = composerStartRestartGroup;
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

                    public final void invoke(Composer composer3, int i6) {
                        this.$tmp9_rcvr.m2269DatePickerHeadline3kbWawI(l, i, datePickerFormatter, modifier4, composer3, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                    }
                });
            }
        }
        i4 |= 3072;
        modifier2 = modifier;
        if ((i4 & 1171) == 1170) {
            if (i5 != 0) {
                modifier3 = Modifier.INSTANCE;
            } else {
                modifier3 = modifier2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1502835813, i4, -1, "androidx.compose.material3.DatePickerDefaults.DatePickerHeadline (DatePicker.kt:654)");
            }
            Locale localeDefaultLocale2 = CalendarLocale_androidKt.defaultLocale(composerStartRestartGroup, 0);
            date$default = DatePickerFormatter.CC.formatDate$default(datePickerFormatter, l, localeDefaultLocale2, false, 4, null);
            date = datePickerFormatter.formatDate(l, localeDefaultLocale2, true);
            composerStartRestartGroup.startReplaceGroup(1148835145);
            strM3334getString2EP1pXo = "";
            ComposerKt.sourceInformation(composerStartRestartGroup, "");
            if (date == null) {
                if (DisplayMode.m2336equalsimpl0(i, DisplayMode.INSTANCE.m2341getPickerjFl4v0())) {
                    composerStartRestartGroup.startReplaceGroup(1148842944);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "665@32234L51");
                    Strings.Companion companion7 = Strings.INSTANCE;
                    date = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_picker_no_selection_description), composerStartRestartGroup, 0);
                    composerStartRestartGroup.endReplaceGroup();
                } else if (DisplayMode.m2336equalsimpl0(i, DisplayMode.INSTANCE.m2340getInputjFl4v0())) {
                    composerStartRestartGroup.startReplaceGroup(1148845915);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "666@32327L46");
                    Strings.Companion companion8 = Strings.INSTANCE;
                    date = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_input_no_input_description), composerStartRestartGroup, 0);
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(1254558033);
                    composerStartRestartGroup.endReplaceGroup();
                    date = "";
                }
            }
            composerStartRestartGroup.endReplaceGroup();
            composerStartRestartGroup.startReplaceGroup(1148850481);
            ComposerKt.sourceInformation(composerStartRestartGroup, "");
            if (date$default == null) {
                if (DisplayMode.m2336equalsimpl0(i, DisplayMode.INSTANCE.m2341getPickerjFl4v0())) {
                    composerStartRestartGroup.startReplaceGroup(1148853330);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "673@32559L37");
                    Strings.Companion companion9 = Strings.INSTANCE;
                    date$default = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_picker_headline), composerStartRestartGroup, 0);
                    composerStartRestartGroup.endReplaceGroup();
                } else if (DisplayMode.m2336equalsimpl0(i, DisplayMode.INSTANCE.m2340getInputjFl4v0())) {
                    composerStartRestartGroup.startReplaceGroup(1148855857);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "674@32638L36");
                    Strings.Companion companion10 = Strings.INSTANCE;
                    date$default = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_input_headline), composerStartRestartGroup, 0);
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(1254856625);
                    composerStartRestartGroup.endReplaceGroup();
                    date$default = "";
                }
            }
            composerStartRestartGroup.endReplaceGroup();
            if (DisplayMode.m2336equalsimpl0(i, DisplayMode.INSTANCE.m2341getPickerjFl4v0())) {
                composerStartRestartGroup.startReplaceGroup(1148862013);
                ComposerKt.sourceInformation(composerStartRestartGroup, "680@32830L48");
                Strings.Companion companion11 = Strings.INSTANCE;
                strM3334getString2EP1pXo = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_picker_headline_description), composerStartRestartGroup, 0);
                composerStartRestartGroup.endReplaceGroup();
            } else if (DisplayMode.m2336equalsimpl0(i, DisplayMode.INSTANCE.m2340getInputjFl4v0())) {
                composerStartRestartGroup.startReplaceGroup(1148864764);
                ComposerKt.sourceInformation(composerStartRestartGroup, "681@32916L47");
                Strings.Companion companion12 = Strings.INSTANCE;
                strM3334getString2EP1pXo = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_input_headline_description), composerStartRestartGroup, 0);
                composerStartRestartGroup.endReplaceGroup();
            } else {
                composerStartRestartGroup.startReplaceGroup(1255139345);
                composerStartRestartGroup.endReplaceGroup();
            }
            str = String.format(strM3334getString2EP1pXo, Arrays.copyOf(new Object[]{date}, 1));
            Intrinsics.checkNotNullExpressionValue(str, "format(this, *args)");
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1148872084, "CC(remember):DatePicker.kt#9igjgp");
            zChanged = composerStartRestartGroup.changed(str);
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (!zChanged) {
                objRememberedValue = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((SemanticsPropertyReceiver) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                        SemanticsPropertiesKt.m6629setLiveRegionhR3wRGc(semanticsPropertyReceiver, LiveRegionMode.INSTANCE.m6603getPolite0phEisY());
                        SemanticsPropertiesKt.setContentDescription(semanticsPropertyReceiver, str);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((SemanticsPropertyReceiver) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                        SemanticsPropertiesKt.m6629setLiveRegionhR3wRGc(semanticsPropertyReceiver, LiveRegionMode.INSTANCE.m6603getPolite0phEisY());
                        SemanticsPropertiesKt.setContentDescription(semanticsPropertyReceiver, str);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            Modifier modifier6 = modifier3;
            composer2 = composerStartRestartGroup;
            TextKt.m3021Text4IGK_g(date$default, SemanticsModifierKt.semantics$default(modifier3, false, (Function1) objRememberedValue, 1, null), 0L, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 1, 0, (Function1<? super TextLayoutResult, Unit>) null, (TextStyle) null, composer2, 0, 3072, 122876);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier4 = modifier6;
        } else {
            if (i5 != 0) {
                modifier3 = Modifier.INSTANCE;
            } else {
                modifier3 = modifier2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1502835813, i4, -1, "androidx.compose.material3.DatePickerDefaults.DatePickerHeadline (DatePicker.kt:654)");
            }
            Locale localeDefaultLocale3 = CalendarLocale_androidKt.defaultLocale(composerStartRestartGroup, 0);
            date$default = DatePickerFormatter.CC.formatDate$default(datePickerFormatter, l, localeDefaultLocale3, false, 4, null);
            date = datePickerFormatter.formatDate(l, localeDefaultLocale3, true);
            composerStartRestartGroup.startReplaceGroup(1148835145);
            strM3334getString2EP1pXo = "";
            ComposerKt.sourceInformation(composerStartRestartGroup, "");
            if (date == null) {
                if (DisplayMode.m2336equalsimpl0(i, DisplayMode.INSTANCE.m2341getPickerjFl4v0())) {
                    composerStartRestartGroup.startReplaceGroup(1148842944);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "665@32234L51");
                    Strings.Companion companion13 = Strings.INSTANCE;
                    date = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_picker_no_selection_description), composerStartRestartGroup, 0);
                    composerStartRestartGroup.endReplaceGroup();
                } else if (DisplayMode.m2336equalsimpl0(i, DisplayMode.INSTANCE.m2340getInputjFl4v0())) {
                    composerStartRestartGroup.startReplaceGroup(1148845915);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "666@32327L46");
                    Strings.Companion companion14 = Strings.INSTANCE;
                    date = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_input_no_input_description), composerStartRestartGroup, 0);
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(1254558033);
                    composerStartRestartGroup.endReplaceGroup();
                    date = "";
                }
            }
            composerStartRestartGroup.endReplaceGroup();
            composerStartRestartGroup.startReplaceGroup(1148850481);
            ComposerKt.sourceInformation(composerStartRestartGroup, "");
            if (date$default == null) {
                if (DisplayMode.m2336equalsimpl0(i, DisplayMode.INSTANCE.m2341getPickerjFl4v0())) {
                    composerStartRestartGroup.startReplaceGroup(1148853330);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "673@32559L37");
                    Strings.Companion companion15 = Strings.INSTANCE;
                    date$default = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_picker_headline), composerStartRestartGroup, 0);
                    composerStartRestartGroup.endReplaceGroup();
                } else if (DisplayMode.m2336equalsimpl0(i, DisplayMode.INSTANCE.m2340getInputjFl4v0())) {
                    composerStartRestartGroup.startReplaceGroup(1148855857);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "674@32638L36");
                    Strings.Companion companion16 = Strings.INSTANCE;
                    date$default = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_input_headline), composerStartRestartGroup, 0);
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(1254856625);
                    composerStartRestartGroup.endReplaceGroup();
                    date$default = "";
                }
            }
            composerStartRestartGroup.endReplaceGroup();
            if (DisplayMode.m2336equalsimpl0(i, DisplayMode.INSTANCE.m2341getPickerjFl4v0())) {
                composerStartRestartGroup.startReplaceGroup(1148862013);
                ComposerKt.sourceInformation(composerStartRestartGroup, "680@32830L48");
                Strings.Companion companion17 = Strings.INSTANCE;
                strM3334getString2EP1pXo = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_picker_headline_description), composerStartRestartGroup, 0);
                composerStartRestartGroup.endReplaceGroup();
            } else if (DisplayMode.m2336equalsimpl0(i, DisplayMode.INSTANCE.m2340getInputjFl4v0())) {
                composerStartRestartGroup.startReplaceGroup(1148864764);
                ComposerKt.sourceInformation(composerStartRestartGroup, "681@32916L47");
                Strings.Companion companion18 = Strings.INSTANCE;
                strM3334getString2EP1pXo = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_input_headline_description), composerStartRestartGroup, 0);
                composerStartRestartGroup.endReplaceGroup();
            } else {
                composerStartRestartGroup.startReplaceGroup(1255139345);
                composerStartRestartGroup.endReplaceGroup();
            }
            str = String.format(strM3334getString2EP1pXo, Arrays.copyOf(new Object[]{date}, 1));
            Intrinsics.checkNotNullExpressionValue(str, "format(this, *args)");
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1148872084, "CC(remember):DatePicker.kt#9igjgp");
            zChanged = composerStartRestartGroup.changed(str);
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (!zChanged) {
                objRememberedValue = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((SemanticsPropertyReceiver) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                        SemanticsPropertiesKt.m6629setLiveRegionhR3wRGc(semanticsPropertyReceiver, LiveRegionMode.INSTANCE.m6603getPolite0phEisY());
                        SemanticsPropertiesKt.setContentDescription(semanticsPropertyReceiver, str);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((SemanticsPropertyReceiver) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                        SemanticsPropertiesKt.m6629setLiveRegionhR3wRGc(semanticsPropertyReceiver, LiveRegionMode.INSTANCE.m6603getPolite0phEisY());
                        SemanticsPropertiesKt.setContentDescription(semanticsPropertyReceiver, str);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            Modifier modifier7 = modifier3;
            composer2 = composerStartRestartGroup;
            TextKt.m3021Text4IGK_g(date$default, SemanticsModifierKt.semantics$default(modifier3, false, (Function1) objRememberedValue, 1, null), 0L, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 1, 0, (Function1<? super TextLayoutResult, Unit>) null, (TextStyle) null, composer2, 0, 3072, 122876);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier4 = modifier7;
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

                public final void invoke(Composer composer3, int i6) {
                    this.$tmp9_rcvr.m2269DatePickerHeadline3kbWawI(l, i, datePickerFormatter, modifier4, composer3, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                }
            });
        }
    }

    public final FlingBehavior rememberSnapFlingBehavior$material3_release(LazyListState lazyListState, DecayAnimationSpec<Float> decayAnimationSpec, Composer composer, int i, int i2) {
        ComposerKt.sourceInformationMarkerStart(composer, -2036003494, "C(rememberSnapFlingBehavior)P(1)708@33801L669:DatePicker.kt#uh7d8r");
        if ((i2 & 2) != 0) {
            decayAnimationSpec = DecayAnimationSpecKt.exponentialDecay$default(0.0f, 0.0f, 3, null);
        }
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-2036003494, i, -1, "androidx.compose.material3.DatePickerDefaults.rememberSnapFlingBehavior (DatePicker.kt:707)");
        }
        ComposerKt.sourceInformationMarkerStart(composer, 2078676503, "CC(remember):DatePicker.kt#9igjgp");
        boolean zChanged = ((((i & 14) ^ 6) > 4 && composer.changed(lazyListState)) || (i & 6) == 4) | composer.changed(decayAnimationSpec);
        Object objRememberedValue = composer.rememberedValue();
        if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
            final SnapLayoutInfoProvider snapLayoutInfoProviderSnapLayoutInfoProvider$default = LazyListSnapLayoutInfoProviderKt.SnapLayoutInfoProvider$default(lazyListState, null, 2, null);
            objRememberedValue = SnapFlingBehaviorKt.snapFlingBehavior(new SnapLayoutInfoProvider() {
                @Override
                public float calculateApproachOffset(float velocity, float decayOffset) {
                    return 0.0f;
                }

                @Override
                public float calculateSnapOffset(float velocity) {
                    return snapLayoutInfoProviderSnapLayoutInfoProvider$default.calculateSnapOffset(velocity);
                }
            }, decayAnimationSpec, AnimationSpecKt.spring$default(0.0f, 400.0f, null, 5, null));
            composer.updateRememberedValue(objRememberedValue);
        }
        TargetedFlingBehavior targetedFlingBehavior = (TargetedFlingBehavior) objRememberedValue;
        ComposerKt.sourceInformationMarkerEnd(composer);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return targetedFlingBehavior;
    }

    public final IntRange getYearRange() {
        return YearRange;
    }

    public final float m2272getTonalElevationD9Ej5fM() {
        return TonalElevation;
    }

    public final Shape getShape(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 700927667, "C734@34850L5:DatePicker.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(700927667, i, -1, "androidx.compose.material3.DatePickerDefaults.<get-shape> (DatePicker.kt:734)");
        }
        Shape value = ShapesKt.getValue(DatePickerModalTokens.INSTANCE.getContainerShape(), composer, 6);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return value;
    }

    public final SelectableDates getAllDates() {
        return AllDates;
    }
}
