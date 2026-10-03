package androidx.compose.material3;

import androidx.autofill.HintConstants;
import androidx.compose.animation.CrossfadeKt;
import androidx.compose.animation.core.AnimationSpecKt;
import androidx.compose.foundation.layout.Arrangement;
import androidx.compose.foundation.layout.ColumnKt;
import androidx.compose.foundation.layout.ColumnScopeInstance;
import androidx.compose.foundation.layout.PaddingKt;
import androidx.compose.foundation.layout.PaddingValues;
import androidx.compose.foundation.lazy.LazyDslKt;
import androidx.compose.foundation.lazy.LazyItemScope;
import androidx.compose.foundation.lazy.LazyListScope;
import androidx.compose.foundation.lazy.LazyListState;
import androidx.compose.foundation.lazy.LazyListStateKt;
import androidx.compose.material3.internal.CalendarDate;
import androidx.compose.material3.internal.CalendarModel;
import androidx.compose.material3.internal.CalendarModel_androidKt;
import androidx.compose.material3.internal.CalendarMonth;
import androidx.compose.material3.internal.Strings;
import androidx.compose.material3.internal.Strings_androidKt;
import androidx.compose.material3.tokens.DatePickerModalTokens;
import androidx.compose.p002ui.Alignment;
import androidx.compose.p002ui.ComposedModifierKt;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.geometry.OffsetKt;
import androidx.compose.p002ui.geometry.Size;
import androidx.compose.p002ui.geometry.SizeKt;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.graphics.drawscope.ContentDrawScope;
import androidx.compose.p002ui.graphics.drawscope.DrawScope;
import androidx.compose.p002ui.layout.MeasurePolicy;
import androidx.compose.p002ui.node.ComposeUiNode;
import androidx.compose.p002ui.semantics.CustomAccessibilityAction;
import androidx.compose.p002ui.semantics.ScrollAxisRange;
import androidx.compose.p002ui.semantics.SemanticsModifierKt;
import androidx.compose.p002ui.semantics.SemanticsPropertiesKt;
import androidx.compose.p002ui.semantics.SemanticsPropertyReceiver;
import androidx.compose.runtime.Applier;
import androidx.compose.runtime.ComposablesKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.CompositionLocalMap;
import androidx.compose.runtime.CompositionScopedCoroutineScopeCanceller;
import androidx.compose.runtime.EffectsKt;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.Updater;
import androidx.compose.runtime.internal.ComposableLambda;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import androidx.compose.runtime.saveable.RememberSaveableKt;
import androidx.compose.runtime.saveable.Saver;
import androidx.compose.ui.text.TextLayoutResult;
import androidx.compose.ui.text.TextStyle;
import androidx.compose.ui.text.font.FontFamily;
import androidx.compose.ui.text.font.FontStyle;
import androidx.compose.ui.text.font.FontWeight;
import androidx.compose.ui.text.style.TextAlign;
import androidx.compose.ui.text.style.TextDecoration;
import androidx.compose.ui.unit.Dp;
import androidx.compose.ui.unit.IntOffset;
import androidx.compose.ui.unit.LayoutDirection;
import java.util.List;
import java.util.Locale;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.EmptyCoroutineContext;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.functions.Function4;
import kotlin.jvm.internal.Intrinsics;
import kotlin.ranges.IntRange;
import kotlin.ranges.RangesKt;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.CoroutineStart;

@Metadata(d1 = {"\u0000¼\u0001\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\t\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\n\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\u001ak\u0010\t\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\f2\b\b\u0002\u0010\r\u001a\u00020\u000e2\b\b\u0002\u0010\u000f\u001a\u00020\u00102\u0015\b\u0002\u0010\u0011\u001a\u000f\u0012\u0004\u0012\u00020\n\u0018\u00010\u0012¢\u0006\u0002\b\u00132\u0015\b\u0002\u0010\u0014\u001a\u000f\u0012\u0004\u0012\u00020\n\u0018\u00010\u0012¢\u0006\u0002\b\u00132\b\b\u0002\u0010\u0015\u001a\u00020\u00162\b\b\u0002\u0010\u0017\u001a\u00020\u0018H\u0007¢\u0006\u0002\u0010\u0019\u001a°\u0001\u0010\u001a\u001a\u00020\n2\b\u0010\u001b\u001a\u0004\u0018\u00010\u001c2\b\u0010\u001d\u001a\u0004\u0018\u00010\u001c2\u0006\u0010\u001e\u001a\u00020\u001c2:\u0010\u001f\u001a6\u0012\u0015\u0012\u0013\u0018\u00010\u001c¢\u0006\f\b!\u0012\b\b\"\u0012\u0004\b\b(#\u0012\u0015\u0012\u0013\u0018\u00010\u001c¢\u0006\f\b!\u0012\b\b\"\u0012\u0004\b\b($\u0012\u0004\u0012\u00020\n0 2!\u0010%\u001a\u001d\u0012\u0013\u0012\u00110\u001c¢\u0006\f\b!\u0012\b\b\"\u0012\u0004\b\b('\u0012\u0004\u0012\u00020\n0&2\u0006\u0010(\u001a\u00020)2\u0006\u0010*\u001a\u00020+2\u0006\u0010\u000f\u001a\u00020\u00102\u0006\u0010,\u001a\u00020-2\u0006\u0010\u0017\u001a\u00020\u0018H\u0003¢\u0006\u0002\u0010.\u001a`\u0010/\u001a\u00020\f2\n\u00100\u001a\u000601j\u0002`22\n\b\u0002\u00103\u001a\u0004\u0018\u00010\u001c2\n\b\u0002\u00104\u001a\u0004\u0018\u00010\u001c2\n\b\u0002\u00105\u001a\u0004\u0018\u00010\u001c2\b\b\u0002\u0010*\u001a\u00020+2\b\b\u0002\u00106\u001a\u0002072\b\b\u0002\u0010,\u001a\u00020-H\u0007ø\u0001\u0000¢\u0006\u0004\b8\u00109\u001a½\u0001\u0010:\u001a\u00020\n2\b\u0010\u001b\u001a\u0004\u0018\u00010\u001c2\b\u0010\u001d\u001a\u0004\u0018\u00010\u001c2\u0006\u0010\u001e\u001a\u00020\u001c2\u0006\u0010;\u001a\u0002072:\u0010\u001f\u001a6\u0012\u0015\u0012\u0013\u0018\u00010\u001c¢\u0006\f\b!\u0012\b\b\"\u0012\u0004\b\b(#\u0012\u0015\u0012\u0013\u0018\u00010\u001c¢\u0006\f\b!\u0012\b\b\"\u0012\u0004\b\b($\u0012\u0004\u0012\u00020\n0 2!\u0010%\u001a\u001d\u0012\u0013\u0012\u00110\u001c¢\u0006\f\b!\u0012\b\b\"\u0012\u0004\b\b('\u0012\u0004\u0012\u00020\n0&2\u0006\u0010(\u001a\u00020)2\u0006\u0010*\u001a\u00020+2\u0006\u0010\u000f\u001a\u00020\u00102\u0006\u0010,\u001a\u00020-2\u0006\u0010\u0017\u001a\u00020\u0018H\u0003ø\u0001\u0000¢\u0006\u0004\b<\u0010=\u001a°\u0001\u0010>\u001a\u00020\n2\u0006\u0010?\u001a\u00020@2\b\u0010\u001b\u001a\u0004\u0018\u00010\u001c2\b\u0010\u001d\u001a\u0004\u0018\u00010\u001c2:\u0010\u001f\u001a6\u0012\u0015\u0012\u0013\u0018\u00010\u001c¢\u0006\f\b!\u0012\b\b\"\u0012\u0004\b\b(#\u0012\u0015\u0012\u0013\u0018\u00010\u001c¢\u0006\f\b!\u0012\b\b\"\u0012\u0004\b\b($\u0012\u0004\u0012\u00020\n0 2!\u0010%\u001a\u001d\u0012\u0013\u0012\u00110\u001c¢\u0006\f\b!\u0012\b\b\"\u0012\u0004\b\b('\u0012\u0004\u0012\u00020\n0&2\u0006\u0010(\u001a\u00020)2\u0006\u0010*\u001a\u00020+2\u0006\u0010\u000f\u001a\u00020\u00102\u0006\u0010,\u001a\u00020-2\u0006\u0010\u0017\u001a\u00020\u0018H\u0003¢\u0006\u0002\u0010A\u001a.\u0010B\u001a\b\u0012\u0004\u0012\u00020D0C2\u0006\u0010\u000b\u001a\u00020@2\u0006\u0010E\u001a\u00020F2\u0006\u0010G\u001a\u00020H2\u0006\u0010I\u001a\u00020HH\u0002\u001aT\u0010J\u001a\u00020\f2\n\b\u0002\u00103\u001a\u0004\u0018\u00010\u001c2\n\b\u0002\u00104\u001a\u0004\u0018\u00010\u001c2\n\b\u0002\u00105\u001a\u0004\u0018\u00010\u001c2\b\b\u0002\u0010*\u001a\u00020+2\b\b\u0002\u00106\u001a\u0002072\b\b\u0002\u0010,\u001a\u00020-H\u0007ø\u0001\u0000¢\u0006\u0004\bK\u0010L\u001ae\u0010M\u001a\u00020\n2\u0006\u0010N\u001a\u00020\u001c2\b\u0010O\u001a\u0004\u0018\u00010\u001c2\b\u0010P\u001a\u0004\u0018\u00010\u001c2:\u0010\u001f\u001a6\u0012\u0015\u0012\u0013\u0018\u00010\u001c¢\u0006\f\b!\u0012\b\b\"\u0012\u0004\b\b(#\u0012\u0015\u0012\u0013\u0018\u00010\u001c¢\u0006\f\b!\u0012\b\b\"\u0012\u0004\b\b($\u0012\u0004\u0012\u00020\n0 H\u0002¢\u0006\u0002\u0010Q\u001a&\u0010R\u001a\u00020\n*\u00020S2\u0006\u0010T\u001a\u00020U2\u0006\u0010V\u001a\u00020WH\u0000ø\u0001\u0000¢\u0006\u0004\bX\u0010Y\"\u0014\u0010\u0000\u001a\u00020\u0001X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0002\u0010\u0003\"\u000e\u0010\u0004\u001a\u00020\u0001X\u0082\u0004¢\u0006\u0002\n\u0000\"\u000e\u0010\u0005\u001a\u00020\u0001X\u0082\u0004¢\u0006\u0002\n\u0000\"\u0010\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\b\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006Z"}, d2 = {"CalendarMonthSubheadPadding", "Landroidx/compose/foundation/layout/PaddingValues;", "getCalendarMonthSubheadPadding", "()Landroidx/compose/foundation/layout/PaddingValues;", "DateRangePickerHeadlinePadding", "DateRangePickerTitlePadding", "HeaderHeightOffset", "Landroidx/compose/ui/unit/Dp;", "F", "DateRangePicker", "", "state", "Landroidx/compose/material3/DateRangePickerState;", "modifier", "Landroidx/compose/ui/Modifier;", "dateFormatter", "Landroidx/compose/material3/DatePickerFormatter;", "title", "Lkotlin/Function0;", "Landroidx/compose/runtime/Composable;", "headline", "showModeToggle", "", "colors", "Landroidx/compose/material3/DatePickerColors;", "(Landroidx/compose/material3/DateRangePickerState;Landroidx/compose/ui/Modifier;Landroidx/compose/material3/DatePickerFormatter;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function2;ZLandroidx/compose/material3/DatePickerColors;Landroidx/compose/runtime/Composer;II)V", "DateRangePickerContent", "selectedStartDateMillis", "", "selectedEndDateMillis", "displayedMonthMillis", "onDatesSelectionChange", "Lkotlin/Function2;", "Lkotlin/ParameterName;", HintConstants.AUTOFILL_HINT_NAME, "startDateMillis", "endDateMillis", "onDisplayedMonthChange", "Lkotlin/Function1;", "monthInMillis", "calendarModel", "Landroidx/compose/material3/internal/CalendarModel;", "yearRange", "Lkotlin/ranges/IntRange;", "selectableDates", "Landroidx/compose/material3/SelectableDates;", "(Ljava/lang/Long;Ljava/lang/Long;JLkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function1;Landroidx/compose/material3/internal/CalendarModel;Lkotlin/ranges/IntRange;Landroidx/compose/material3/DatePickerFormatter;Landroidx/compose/material3/SelectableDates;Landroidx/compose/material3/DatePickerColors;Landroidx/compose/runtime/Composer;I)V", "DateRangePickerState", "locale", "Ljava/util/Locale;", "Landroidx/compose/material3/CalendarLocale;", "initialSelectedStartDateMillis", "initialSelectedEndDateMillis", "initialDisplayedMonthMillis", "initialDisplayMode", "Landroidx/compose/material3/DisplayMode;", "DateRangePickerState-HVP43zI", "(Ljava/util/Locale;Ljava/lang/Long;Ljava/lang/Long;Ljava/lang/Long;Lkotlin/ranges/IntRange;ILandroidx/compose/material3/SelectableDates;)Landroidx/compose/material3/DateRangePickerState;", "SwitchableDateEntryContent", "displayMode", "SwitchableDateEntryContent-RN-2D1Q", "(Ljava/lang/Long;Ljava/lang/Long;JILkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function1;Landroidx/compose/material3/internal/CalendarModel;Lkotlin/ranges/IntRange;Landroidx/compose/material3/DatePickerFormatter;Landroidx/compose/material3/SelectableDates;Landroidx/compose/material3/DatePickerColors;Landroidx/compose/runtime/Composer;II)V", "VerticalMonthsList", "lazyListState", "Landroidx/compose/foundation/lazy/LazyListState;", "(Landroidx/compose/foundation/lazy/LazyListState;Ljava/lang/Long;Ljava/lang/Long;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function1;Landroidx/compose/material3/internal/CalendarModel;Lkotlin/ranges/IntRange;Landroidx/compose/material3/DatePickerFormatter;Landroidx/compose/material3/SelectableDates;Landroidx/compose/material3/DatePickerColors;Landroidx/compose/runtime/Composer;I)V", "customScrollActions", "", "Landroidx/compose/ui/semantics/CustomAccessibilityAction;", "coroutineScope", "Lkotlinx/coroutines/CoroutineScope;", "scrollUpLabel", "", "scrollDownLabel", "rememberDateRangePickerState", "rememberDateRangePickerState-IlFM19s", "(Ljava/lang/Long;Ljava/lang/Long;Ljava/lang/Long;Lkotlin/ranges/IntRange;ILandroidx/compose/material3/SelectableDates;Landroidx/compose/runtime/Composer;II)Landroidx/compose/material3/DateRangePickerState;", "updateDateSelection", "dateInMillis", "currentStartDateMillis", "currentEndDateMillis", "(JLjava/lang/Long;Ljava/lang/Long;Lkotlin/jvm/functions/Function2;)V", "drawRangeBackground", "Landroidx/compose/ui/graphics/drawscope/ContentDrawScope;", "selectedRangeInfo", "Landroidx/compose/material3/SelectedRangeInfo;", "color", "Landroidx/compose/ui/graphics/Color;", "drawRangeBackground-mxwnekA", "(Landroidx/compose/ui/graphics/drawscope/ContentDrawScope;Landroidx/compose/material3/SelectedRangeInfo;J)V", "material3_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class DateRangePickerKt {
    private static final PaddingValues DateRangePickerHeadlinePadding;
    private static final PaddingValues DateRangePickerTitlePadding;
    private static final PaddingValues CalendarMonthSubheadPadding = PaddingKt.m1032PaddingValuesa9UjIt4$default(Dp.constructor-impl(24), Dp.constructor-impl(20), 0.0f, Dp.constructor-impl(8), 4, null);
    private static final float HeaderHeightOffset = Dp.constructor-impl(60);

    public static final void DateRangePicker(final DateRangePickerState dateRangePickerState, Modifier modifier, DatePickerFormatter datePickerFormatter, Function2<? super Composer, ? super Integer, Unit> function2, Function2<? super Composer, ? super Integer, Unit> function3, boolean z, DatePickerColors datePickerColors, Composer composer, final int i, final int i2) {
        int i3;
        Modifier modifier2;
        int i4;
        Function2<? super Composer, ? super Integer, Unit> function2RememberComposableLambda;
        int i5;
        int i6;
        Function2<? super Composer, ? super Integer, Unit> function2RememberComposableLambda2;
        int i7;
        int i8;
        boolean z2;
        int i9;
        final DatePickerColors datePickerColorsColors;
        final DatePickerFormatter datePickerFormatter2;
        int i10;
        Object objRememberedValue;
        final Function2<? super Composer, ? super Integer, Unit> function4;
        boolean z3;
        int i11;
        Locale localeDefaultLocale;
        boolean zChanged;
        Object objRememberedValue2;
        ComposableLambda composableLambdaRememberComposableLambda;
        DatePickerFormatter datePickerFormatter3;
        final Modifier modifier3;
        final boolean z4;
        final DatePickerColors datePickerColors2;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i12;
        boolean zChangedInstance;
        Composer composerStartRestartGroup = composer.startRestartGroup(650830774);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(DateRangePicker)P(5,3,1,6,2,4)95@4412L47,96@4500L185,102@4729L352,112@5169L8,114@5206L15,115@5246L62,132@5955L5,136@6111L1139,116@5313L1937:DateRangePicker.kt#uh7d8r");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changed(dateRangePickerState) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i13 = i2 & 2;
        if (i13 == 0) {
            if ((i & 48) == 0) {
                modifier2 = modifier;
                i3 |= composerStartRestartGroup.changed(modifier2) ? 32 : 16;
            }
            if ((i & 384) == 0) {
                if ((i2 & 4) != 0) {
                    i12 = Fields.SpotShadowColor;
                } else {
                    if ((i & Fields.RotationY) == 0) {
                        zChangedInstance = composerStartRestartGroup.changed(datePickerFormatter);
                    } else {
                        zChangedInstance = composerStartRestartGroup.changedInstance(datePickerFormatter);
                    }
                    if (zChangedInstance) {
                        i12 = Fields.RotationX;
                    } else {
                        i12 = Fields.SpotShadowColor;
                    }
                }
                i3 |= i12;
            }
            i4 = i2 & 8;
            if (i4 != 0) {
                if ((i & 3072) == 0) {
                    function2RememberComposableLambda = function2;
                    if (composerStartRestartGroup.changedInstance(function2RememberComposableLambda)) {
                        i5 = Fields.CameraDistance;
                    } else {
                        i5 = Fields.RotationZ;
                    }
                    i3 |= i5;
                }
                i6 = i2 & 16;
                if (i6 != 0) {
                    if ((i & 24576) == 0) {
                        function2RememberComposableLambda2 = function3;
                        if (composerStartRestartGroup.changedInstance(function2RememberComposableLambda2)) {
                            i7 = Fields.Clip;
                        } else {
                            i7 = Fields.Shape;
                        }
                        i3 |= i7;
                    }
                    i8 = i2 & 32;
                    if (i8 != 0) {
                        if ((196608 & i) == 0) {
                            z2 = z;
                            if (composerStartRestartGroup.changed(z2)) {
                                i9 = Fields.RenderEffect;
                            } else {
                                i9 = 65536;
                            }
                            i3 |= i9;
                        }
                        if ((1572864 & i) == 0) {
                            if ((i2 & 64) == 0) {
                                datePickerColorsColors = datePickerColors;
                                int i14 = composerStartRestartGroup.changed(datePickerColorsColors) ? 1048576 : 524288;
                                i3 |= i14;
                            } else {
                                datePickerColorsColors = datePickerColors;
                            }
                            i3 |= i14;
                        } else {
                            datePickerColorsColors = datePickerColors;
                        }
                        if ((599187 & i3) == 599186 || !composerStartRestartGroup.getSkipping()) {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                                if (i13 != 0) {
                                    modifier2 = Modifier.INSTANCE;
                                }
                                if ((i2 & 4) != 0) {
                                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                        objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                                    }
                                    datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                                    i3 &= -897;
                                } else {
                                    datePickerFormatter2 = datePickerFormatter;
                                }
                                if (i4 != 0) {
                                    function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer2, int i15) {
                                            ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                            if ((i15 & 3) != 2 || !composer2.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(-162164694, i15, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                                }
                                                DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer2.skipToGroupEnd();
                                        }
                                    }, composerStartRestartGroup, 54);
                                    i10 = 54;
                                } else {
                                    i10 = 54;
                                }
                                if (i6 != 0) {
                                    function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer2, int i15) {
                                            ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                            if ((i15 & 3) != 2 || !composer2.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(-185279404, i15, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                                }
                                                DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer2.skipToGroupEnd();
                                        }
                                    }, composerStartRestartGroup, i10);
                                }
                                if (i8 != 0) {
                                    z2 = true;
                                }
                                if ((i2 & 64) != 0) {
                                    i3 &= -3670017;
                                    datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                                }
                            } else {
                                composerStartRestartGroup.skipToGroupEnd();
                                if ((i2 & 4) != 0) {
                                    i3 &= -897;
                                }
                                if ((i2 & 64) != 0) {
                                    i3 &= -3670017;
                                }
                                datePickerFormatter2 = datePickerFormatter;
                            }
                            function4 = function2RememberComposableLambda2;
                            z3 = z2;
                            Function2<? super Composer, ? super Integer, Unit> function5 = function2RememberComposableLambda;
                            i11 = i3;
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(650830774, i11, -1, "androidx.compose.material3.DateRangePicker (DateRangePicker.kt:113)");
                            }
                            localeDefaultLocale = CalendarLocale_androidKt.defaultLocale(composerStartRestartGroup, 0);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454754600, "CC(remember):DateRangePicker.kt#9igjgp");
                            zChanged = composerStartRestartGroup.changed(localeDefaultLocale);
                            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                            if (!zChanged || objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                            }
                            final CalendarModel calendarModel = (CalendarModel) objRememberedValue2;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            composerStartRestartGroup.startReplaceGroup(-1454747621);
                            ComposerKt.sourceInformation(composerStartRestartGroup, "122@5491L323");
                            if (z3) {
                                composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-1490010652, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i15) {
                                        ComposerKt.sourceInformation(composer2, "C126@5723L50,123@5513L283:DateRangePicker.kt#uh7d8r");
                                        if ((i15 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1490010652, i15, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:123)");
                                            }
                                            Modifier modifierPadding = PaddingKt.padding(Modifier.INSTANCE, DatePickerKt.getDatePickerModeTogglePadding());
                                            int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                            ComposerKt.sourceInformationMarkerStart(composer2, 1752251243, "CC(remember):DateRangePicker.kt#9igjgp");
                                            boolean zChanged2 = composer2.changed(dateRangePickerState);
                                            final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                            Object objRememberedValue3 = composer2.rememberedValue();
                                            if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                                objRememberedValue3 = (Function1) new Function1<DisplayMode, Unit>() {
                                                    {
                                                        super(1);
                                                    }

                                                    public Object invoke(Object obj) {
                                                        m2313invokevCnGnXg(((DisplayMode) obj).getValue());
                                                        return Unit.INSTANCE;
                                                    }

                                                    public final void m2313invokevCnGnXg(int i16) {
                                                        dateRangePickerState2.mo2321setDisplayModevCnGnXg(i16);
                                                    }
                                                };
                                                composer2.updateRememberedValue(objRememberedValue3);
                                            }
                                            ComposerKt.sourceInformationMarkerEnd(composer2);
                                            DatePickerKt.m2278DisplayModeToggleButtontER2X8s(modifierPadding, iMo2320getDisplayModejFl4v0, (Function1) objRememberedValue3, composer2, 6);
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
                                composableLambdaRememberComposableLambda = null;
                            }
                            composerStartRestartGroup.endReplaceGroup();
                            int i15 = ((i11 >> 3) & 14) | 14155776;
                            int i16 = i11 >> 6;
                            DatePickerColors datePickerColors3 = datePickerColorsColors;
                            DatePickerKt.m2274DateEntryContainerau3_HiA(modifier2, function5, function4, composableLambdaRememberComposableLambda, datePickerColorsColors, TypographyKt.getValue(DatePickerModalTokens.INSTANCE.getRangeSelectionHeaderHeadlineFont(), composerStartRestartGroup, 6), Dp.constructor-impl(DatePickerModalTokens.INSTANCE.m3515getRangeSelectionHeaderContainerHeightD9Ej5fM() - HeaderHeightOffset), ComposableLambdaKt.rememberComposableLambda(-57534331, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i17) {
                                    ComposerKt.sourceInformation(composer2, "C142@6428L467,153@6934L91,137@6121L1123:DateRangePicker.kt#uh7d8r");
                                    if ((i17 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-57534331, i17, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:137)");
                                        }
                                        Long selectedStartDateMillis = dateRangePickerState.getSelectedStartDateMillis();
                                        Long selectedEndDateMillis = dateRangePickerState.getSelectedEndDateMillis();
                                        long displayedMonthMillis = dateRangePickerState.getDisplayedMonthMillis();
                                        int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                        ComposerKt.sourceInformationMarkerStart(composer2, 1752274220, "CC(remember):DateRangePicker.kt#9igjgp");
                                        boolean zChanged2 = composer2.changed(dateRangePickerState);
                                        final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                        Object objRememberedValue3 = composer2.rememberedValue();
                                        if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                            objRememberedValue3 = (Function2) new Function2<Long, Long, Unit>() {
                                                {
                                                    super(2);
                                                }

                                                public Object invoke(Object obj, Object obj2) {
                                                    invoke((Long) obj, (Long) obj2);
                                                    return Unit.INSTANCE;
                                                }

                                                public final void invoke(Long l, Long l2) {
                                                    try {
                                                        dateRangePickerState2.setSelection(l, l2);
                                                    } catch (IllegalArgumentException unused) {
                                                    }
                                                }
                                            };
                                            composer2.updateRememberedValue(objRememberedValue3);
                                        }
                                        Function2 function6 = (Function2) objRememberedValue3;
                                        ComposerKt.sourceInformationMarkerEnd(composer2);
                                        ComposerKt.sourceInformationMarkerStart(composer2, 1752290036, "CC(remember):DateRangePicker.kt#9igjgp");
                                        boolean zChanged3 = composer2.changed(dateRangePickerState);
                                        final DateRangePickerState dateRangePickerState3 = dateRangePickerState;
                                        Object objRememberedValue4 = composer2.rememberedValue();
                                        if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                            objRememberedValue4 = (Function1) new Function1<Long, Unit>() {
                                                {
                                                    super(1);
                                                }

                                                public Object invoke(Object obj) {
                                                    invoke(((Number) obj).longValue());
                                                    return Unit.INSTANCE;
                                                }

                                                public final void invoke(long j) {
                                                    dateRangePickerState3.setDisplayedMonthMillis(j);
                                                }
                                            };
                                            composer2.updateRememberedValue(objRememberedValue4);
                                        }
                                        ComposerKt.sourceInformationMarkerEnd(composer2);
                                        DateRangePickerKt.m2309SwitchableDateEntryContentRN2D1Q(selectedStartDateMillis, selectedEndDateMillis, displayedMonthMillis, iMo2320getDisplayModejFl4v0, function6, (Function1) objRememberedValue4, calendarModel, dateRangePickerState.getYearRange(), datePickerFormatter2, dateRangePickerState.getSelectableDates(), datePickerColorsColors, composer2, 0, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54), composerStartRestartGroup, i15 | (i16 & 112) | (i16 & 896) | (i16 & 57344));
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            function2RememberComposableLambda = function5;
                            datePickerFormatter3 = datePickerFormatter2;
                            modifier3 = modifier2;
                            z4 = z3;
                            datePickerColors2 = datePickerColors3;
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            datePickerFormatter3 = datePickerFormatter;
                            modifier3 = modifier2;
                            function4 = function2RememberComposableLambda2;
                            z4 = z2;
                            datePickerColors2 = datePickerColorsColors;
                        }
                        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                        if (scopeUpdateScopeEndRestartGroup != null) {
                            final DatePickerFormatter datePickerFormatter4 = datePickerFormatter3;
                            final Function2<? super Composer, ? super Integer, Unit> function6 = function2RememberComposableLambda;
                            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i17) {
                                    DateRangePickerKt.DateRangePicker(dateRangePickerState, modifier3, datePickerFormatter4, function6, function4, z4, datePickerColors2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                                }
                            });
                        }
                    }
                    i3 |= 196608;
                    z2 = z;
                    if ((1572864 & i) == 0) {
                        if ((i2 & 64) == 0) {
                            datePickerColorsColors = datePickerColors;
                            if (composerStartRestartGroup.changed(datePickerColorsColors)) {
                            }
                            i3 |= i14;
                        } else {
                            datePickerColorsColors = datePickerColors;
                        }
                        i3 |= i14;
                    } else {
                        datePickerColorsColors = datePickerColors;
                    }
                    if ((599187 & i3) == 599186) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if ((i2 & 4) != 0) {
                                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                                objRememberedValue = composerStartRestartGroup.rememberedValue();
                                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                                }
                                datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                                i3 &= -897;
                            } else {
                                datePickerFormatter2 = datePickerFormatter;
                            }
                            if (i4 != 0) {
                                function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i17) {
                                        ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                        if ((i17 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-162164694, i17, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                            }
                                            DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                i10 = 54;
                            } else {
                                i10 = 54;
                            }
                            if (i6 != 0) {
                                function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i17) {
                                        ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                        if ((i17 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-185279404, i17, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                            }
                                            DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, i10);
                            }
                            if (i8 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 64) != 0) {
                                i3 &= -3670017;
                                datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            }
                        } else {
                            if (i13 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if ((i2 & 4) != 0) {
                                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                                objRememberedValue = composerStartRestartGroup.rememberedValue();
                                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                                }
                                datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                                i3 &= -897;
                            } else {
                                datePickerFormatter2 = datePickerFormatter;
                            }
                            if (i4 != 0) {
                                function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i17) {
                                        ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                        if ((i17 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-162164694, i17, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                            }
                                            DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                i10 = 54;
                            } else {
                                i10 = 54;
                            }
                            if (i6 != 0) {
                                function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i17) {
                                        ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                        if ((i17 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-185279404, i17, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                            }
                                            DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, i10);
                            }
                            if (i8 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 64) != 0) {
                                i3 &= -3670017;
                                datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            }
                        }
                        function4 = function2RememberComposableLambda2;
                        z3 = z2;
                        Function2<? super Composer, ? super Integer, Unit> function7 = function2RememberComposableLambda;
                        i11 = i3;
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(650830774, i11, -1, "androidx.compose.material3.DateRangePicker (DateRangePicker.kt:113)");
                        }
                        localeDefaultLocale = CalendarLocale_androidKt.defaultLocale(composerStartRestartGroup, 0);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454754600, "CC(remember):DateRangePicker.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(localeDefaultLocale);
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        final CalendarModel calendarModel2 = (CalendarModel) objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.startReplaceGroup(-1454747621);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "122@5491L323");
                        if (z3) {
                            composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-1490010652, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i17) {
                                    ComposerKt.sourceInformation(composer2, "C126@5723L50,123@5513L283:DateRangePicker.kt#uh7d8r");
                                    if ((i17 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1490010652, i17, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:123)");
                                        }
                                        Modifier modifierPadding = PaddingKt.padding(Modifier.INSTANCE, DatePickerKt.getDatePickerModeTogglePadding());
                                        int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                        ComposerKt.sourceInformationMarkerStart(composer2, 1752251243, "CC(remember):DateRangePicker.kt#9igjgp");
                                        boolean zChanged2 = composer2.changed(dateRangePickerState);
                                        final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                        Object objRememberedValue3 = composer2.rememberedValue();
                                        if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                            objRememberedValue3 = (Function1) new Function1<DisplayMode, Unit>() {
                                                {
                                                    super(1);
                                                }

                                                public Object invoke(Object obj) {
                                                    m2313invokevCnGnXg(((DisplayMode) obj).getValue());
                                                    return Unit.INSTANCE;
                                                }

                                                public final void m2313invokevCnGnXg(int i18) {
                                                    dateRangePickerState2.mo2321setDisplayModevCnGnXg(i18);
                                                }
                                            };
                                            composer2.updateRememberedValue(objRememberedValue3);
                                        }
                                        ComposerKt.sourceInformationMarkerEnd(composer2);
                                        DatePickerKt.m2278DisplayModeToggleButtontER2X8s(modifierPadding, iMo2320getDisplayModejFl4v0, (Function1) objRememberedValue3, composer2, 6);
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
                            composableLambdaRememberComposableLambda = null;
                        }
                        composerStartRestartGroup.endReplaceGroup();
                        int i17 = ((i11 >> 3) & 14) | 14155776;
                        int i18 = i11 >> 6;
                        DatePickerColors datePickerColors4 = datePickerColorsColors;
                        DatePickerKt.m2274DateEntryContainerau3_HiA(modifier2, function7, function4, composableLambdaRememberComposableLambda, datePickerColorsColors, TypographyKt.getValue(DatePickerModalTokens.INSTANCE.getRangeSelectionHeaderHeadlineFont(), composerStartRestartGroup, 6), Dp.constructor-impl(DatePickerModalTokens.INSTANCE.m3515getRangeSelectionHeaderContainerHeightD9Ej5fM() - HeaderHeightOffset), ComposableLambdaKt.rememberComposableLambda(-57534331, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i19) {
                                ComposerKt.sourceInformation(composer2, "C142@6428L467,153@6934L91,137@6121L1123:DateRangePicker.kt#uh7d8r");
                                if ((i19 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-57534331, i19, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:137)");
                                    }
                                    Long selectedStartDateMillis = dateRangePickerState.getSelectedStartDateMillis();
                                    Long selectedEndDateMillis = dateRangePickerState.getSelectedEndDateMillis();
                                    long displayedMonthMillis = dateRangePickerState.getDisplayedMonthMillis();
                                    int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1752274220, "CC(remember):DateRangePicker.kt#9igjgp");
                                    boolean zChanged2 = composer2.changed(dateRangePickerState);
                                    final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                    Object objRememberedValue3 = composer2.rememberedValue();
                                    if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                        objRememberedValue3 = (Function2) new Function2<Long, Long, Unit>() {
                                            {
                                                super(2);
                                            }

                                            public Object invoke(Object obj, Object obj2) {
                                                invoke((Long) obj, (Long) obj2);
                                                return Unit.INSTANCE;
                                            }

                                            public final void invoke(Long l, Long l2) {
                                                try {
                                                    dateRangePickerState2.setSelection(l, l2);
                                                } catch (IllegalArgumentException unused) {
                                                }
                                            }
                                        };
                                        composer2.updateRememberedValue(objRememberedValue3);
                                    }
                                    Function2 function8 = (Function2) objRememberedValue3;
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1752290036, "CC(remember):DateRangePicker.kt#9igjgp");
                                    boolean zChanged3 = composer2.changed(dateRangePickerState);
                                    final DateRangePickerState dateRangePickerState3 = dateRangePickerState;
                                    Object objRememberedValue4 = composer2.rememberedValue();
                                    if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                        objRememberedValue4 = (Function1) new Function1<Long, Unit>() {
                                            {
                                                super(1);
                                            }

                                            public Object invoke(Object obj) {
                                                invoke(((Number) obj).longValue());
                                                return Unit.INSTANCE;
                                            }

                                            public final void invoke(long j) {
                                                dateRangePickerState3.setDisplayedMonthMillis(j);
                                            }
                                        };
                                        composer2.updateRememberedValue(objRememberedValue4);
                                    }
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    DateRangePickerKt.m2309SwitchableDateEntryContentRN2D1Q(selectedStartDateMillis, selectedEndDateMillis, displayedMonthMillis, iMo2320getDisplayModejFl4v0, function8, (Function1) objRememberedValue4, calendarModel2, dateRangePickerState.getYearRange(), datePickerFormatter2, dateRangePickerState.getSelectableDates(), datePickerColorsColors, composer2, 0, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, i17 | (i18 & 112) | (i18 & 896) | (i18 & 57344));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        function2RememberComposableLambda = function7;
                        datePickerFormatter3 = datePickerFormatter2;
                        modifier3 = modifier2;
                        z4 = z3;
                        datePickerColors2 = datePickerColors4;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if ((i2 & 4) != 0) {
                                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                                objRememberedValue = composerStartRestartGroup.rememberedValue();
                                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                                }
                                datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                                i3 &= -897;
                            } else {
                                datePickerFormatter2 = datePickerFormatter;
                            }
                            if (i4 != 0) {
                                function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i19) {
                                        ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                        if ((i19 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-162164694, i19, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                            }
                                            DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                i10 = 54;
                            } else {
                                i10 = 54;
                            }
                            if (i6 != 0) {
                                function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i19) {
                                        ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                        if ((i19 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-185279404, i19, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                            }
                                            DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, i10);
                            }
                            if (i8 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 64) != 0) {
                                i3 &= -3670017;
                                datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            }
                        } else {
                            if (i13 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if ((i2 & 4) != 0) {
                                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                                objRememberedValue = composerStartRestartGroup.rememberedValue();
                                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                                }
                                datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                                i3 &= -897;
                            } else {
                                datePickerFormatter2 = datePickerFormatter;
                            }
                            if (i4 != 0) {
                                function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i19) {
                                        ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                        if ((i19 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-162164694, i19, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                            }
                                            DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                i10 = 54;
                            } else {
                                i10 = 54;
                            }
                            if (i6 != 0) {
                                function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i19) {
                                        ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                        if ((i19 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-185279404, i19, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                            }
                                            DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, i10);
                            }
                            if (i8 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 64) != 0) {
                                i3 &= -3670017;
                                datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            }
                        }
                        function4 = function2RememberComposableLambda2;
                        z3 = z2;
                        Function2<? super Composer, ? super Integer, Unit> function8 = function2RememberComposableLambda;
                        i11 = i3;
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(650830774, i11, -1, "androidx.compose.material3.DateRangePicker (DateRangePicker.kt:113)");
                        }
                        localeDefaultLocale = CalendarLocale_androidKt.defaultLocale(composerStartRestartGroup, 0);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454754600, "CC(remember):DateRangePicker.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(localeDefaultLocale);
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        final CalendarModel calendarModel3 = (CalendarModel) objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.startReplaceGroup(-1454747621);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "122@5491L323");
                        if (z3) {
                            composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-1490010652, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i19) {
                                    ComposerKt.sourceInformation(composer2, "C126@5723L50,123@5513L283:DateRangePicker.kt#uh7d8r");
                                    if ((i19 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1490010652, i19, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:123)");
                                        }
                                        Modifier modifierPadding = PaddingKt.padding(Modifier.INSTANCE, DatePickerKt.getDatePickerModeTogglePadding());
                                        int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                        ComposerKt.sourceInformationMarkerStart(composer2, 1752251243, "CC(remember):DateRangePicker.kt#9igjgp");
                                        boolean zChanged2 = composer2.changed(dateRangePickerState);
                                        final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                        Object objRememberedValue3 = composer2.rememberedValue();
                                        if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                            objRememberedValue3 = (Function1) new Function1<DisplayMode, Unit>() {
                                                {
                                                    super(1);
                                                }

                                                public Object invoke(Object obj) {
                                                    m2313invokevCnGnXg(((DisplayMode) obj).getValue());
                                                    return Unit.INSTANCE;
                                                }

                                                public final void m2313invokevCnGnXg(int i110) {
                                                    dateRangePickerState2.mo2321setDisplayModevCnGnXg(i110);
                                                }
                                            };
                                            composer2.updateRememberedValue(objRememberedValue3);
                                        }
                                        ComposerKt.sourceInformationMarkerEnd(composer2);
                                        DatePickerKt.m2278DisplayModeToggleButtontER2X8s(modifierPadding, iMo2320getDisplayModejFl4v0, (Function1) objRememberedValue3, composer2, 6);
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
                            composableLambdaRememberComposableLambda = null;
                        }
                        composerStartRestartGroup.endReplaceGroup();
                        int i19 = ((i11 >> 3) & 14) | 14155776;
                        int i110 = i11 >> 6;
                        DatePickerColors datePickerColors5 = datePickerColorsColors;
                        DatePickerKt.m2274DateEntryContainerau3_HiA(modifier2, function8, function4, composableLambdaRememberComposableLambda, datePickerColorsColors, TypographyKt.getValue(DatePickerModalTokens.INSTANCE.getRangeSelectionHeaderHeadlineFont(), composerStartRestartGroup, 6), Dp.constructor-impl(DatePickerModalTokens.INSTANCE.m3515getRangeSelectionHeaderContainerHeightD9Ej5fM() - HeaderHeightOffset), ComposableLambdaKt.rememberComposableLambda(-57534331, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i111) {
                                ComposerKt.sourceInformation(composer2, "C142@6428L467,153@6934L91,137@6121L1123:DateRangePicker.kt#uh7d8r");
                                if ((i111 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-57534331, i111, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:137)");
                                    }
                                    Long selectedStartDateMillis = dateRangePickerState.getSelectedStartDateMillis();
                                    Long selectedEndDateMillis = dateRangePickerState.getSelectedEndDateMillis();
                                    long displayedMonthMillis = dateRangePickerState.getDisplayedMonthMillis();
                                    int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1752274220, "CC(remember):DateRangePicker.kt#9igjgp");
                                    boolean zChanged2 = composer2.changed(dateRangePickerState);
                                    final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                    Object objRememberedValue3 = composer2.rememberedValue();
                                    if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                        objRememberedValue3 = (Function2) new Function2<Long, Long, Unit>() {
                                            {
                                                super(2);
                                            }

                                            public Object invoke(Object obj, Object obj2) {
                                                invoke((Long) obj, (Long) obj2);
                                                return Unit.INSTANCE;
                                            }

                                            public final void invoke(Long l, Long l2) {
                                                try {
                                                    dateRangePickerState2.setSelection(l, l2);
                                                } catch (IllegalArgumentException unused) {
                                                }
                                            }
                                        };
                                        composer2.updateRememberedValue(objRememberedValue3);
                                    }
                                    Function2 function9 = (Function2) objRememberedValue3;
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1752290036, "CC(remember):DateRangePicker.kt#9igjgp");
                                    boolean zChanged3 = composer2.changed(dateRangePickerState);
                                    final DateRangePickerState dateRangePickerState3 = dateRangePickerState;
                                    Object objRememberedValue4 = composer2.rememberedValue();
                                    if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                        objRememberedValue4 = (Function1) new Function1<Long, Unit>() {
                                            {
                                                super(1);
                                            }

                                            public Object invoke(Object obj) {
                                                invoke(((Number) obj).longValue());
                                                return Unit.INSTANCE;
                                            }

                                            public final void invoke(long j) {
                                                dateRangePickerState3.setDisplayedMonthMillis(j);
                                            }
                                        };
                                        composer2.updateRememberedValue(objRememberedValue4);
                                    }
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    DateRangePickerKt.m2309SwitchableDateEntryContentRN2D1Q(selectedStartDateMillis, selectedEndDateMillis, displayedMonthMillis, iMo2320getDisplayModejFl4v0, function9, (Function1) objRememberedValue4, calendarModel3, dateRangePickerState.getYearRange(), datePickerFormatter2, dateRangePickerState.getSelectableDates(), datePickerColorsColors, composer2, 0, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, i19 | (i110 & 112) | (i110 & 896) | (i110 & 57344));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        function2RememberComposableLambda = function8;
                        datePickerFormatter3 = datePickerFormatter2;
                        modifier3 = modifier2;
                        z4 = z3;
                        datePickerColors2 = datePickerColors5;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final DatePickerFormatter datePickerFormatter5 = datePickerFormatter3;
                        final Function2<? super Composer, ? super Integer, Unit> function9 = function2RememberComposableLambda;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i111) {
                                DateRangePickerKt.DateRangePicker(dateRangePickerState, modifier3, datePickerFormatter5, function9, function4, z4, datePickerColors2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 24576;
                function2RememberComposableLambda2 = function3;
                i8 = i2 & 32;
                if (i8 != 0) {
                    if ((196608 & i) == 0) {
                        z2 = z;
                        if (composerStartRestartGroup.changed(z2)) {
                            i9 = Fields.RenderEffect;
                        } else {
                            i9 = 65536;
                        }
                        i3 |= i9;
                    }
                    if ((1572864 & i) == 0) {
                        if ((i2 & 64) == 0) {
                            datePickerColorsColors = datePickerColors;
                            if (composerStartRestartGroup.changed(datePickerColorsColors)) {
                            }
                            i3 |= i14;
                        } else {
                            datePickerColorsColors = datePickerColors;
                        }
                        i3 |= i14;
                    } else {
                        datePickerColorsColors = datePickerColors;
                    }
                    if ((599187 & i3) == 599186) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if ((i2 & 4) != 0) {
                                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                                objRememberedValue = composerStartRestartGroup.rememberedValue();
                                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                                }
                                datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                                i3 &= -897;
                            } else {
                                datePickerFormatter2 = datePickerFormatter;
                            }
                            if (i4 != 0) {
                                function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i111) {
                                        ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                        if ((i111 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-162164694, i111, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                            }
                                            DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                i10 = 54;
                            } else {
                                i10 = 54;
                            }
                            if (i6 != 0) {
                                function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i111) {
                                        ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                        if ((i111 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-185279404, i111, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                            }
                                            DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, i10);
                            }
                            if (i8 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 64) != 0) {
                                i3 &= -3670017;
                                datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            }
                        } else {
                            if (i13 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if ((i2 & 4) != 0) {
                                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                                objRememberedValue = composerStartRestartGroup.rememberedValue();
                                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                                }
                                datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                                i3 &= -897;
                            } else {
                                datePickerFormatter2 = datePickerFormatter;
                            }
                            if (i4 != 0) {
                                function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i111) {
                                        ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                        if ((i111 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-162164694, i111, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                            }
                                            DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                i10 = 54;
                            } else {
                                i10 = 54;
                            }
                            if (i6 != 0) {
                                function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i111) {
                                        ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                        if ((i111 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-185279404, i111, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                            }
                                            DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, i10);
                            }
                            if (i8 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 64) != 0) {
                                i3 &= -3670017;
                                datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            }
                        }
                        function4 = function2RememberComposableLambda2;
                        z3 = z2;
                        Function2<? super Composer, ? super Integer, Unit> function10 = function2RememberComposableLambda;
                        i11 = i3;
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(650830774, i11, -1, "androidx.compose.material3.DateRangePicker (DateRangePicker.kt:113)");
                        }
                        localeDefaultLocale = CalendarLocale_androidKt.defaultLocale(composerStartRestartGroup, 0);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454754600, "CC(remember):DateRangePicker.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(localeDefaultLocale);
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        final CalendarModel calendarModel4 = (CalendarModel) objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.startReplaceGroup(-1454747621);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "122@5491L323");
                        if (z3) {
                            composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-1490010652, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i111) {
                                    ComposerKt.sourceInformation(composer2, "C126@5723L50,123@5513L283:DateRangePicker.kt#uh7d8r");
                                    if ((i111 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1490010652, i111, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:123)");
                                        }
                                        Modifier modifierPadding = PaddingKt.padding(Modifier.INSTANCE, DatePickerKt.getDatePickerModeTogglePadding());
                                        int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                        ComposerKt.sourceInformationMarkerStart(composer2, 1752251243, "CC(remember):DateRangePicker.kt#9igjgp");
                                        boolean zChanged2 = composer2.changed(dateRangePickerState);
                                        final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                        Object objRememberedValue3 = composer2.rememberedValue();
                                        if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                            objRememberedValue3 = (Function1) new Function1<DisplayMode, Unit>() {
                                                {
                                                    super(1);
                                                }

                                                public Object invoke(Object obj) {
                                                    m2313invokevCnGnXg(((DisplayMode) obj).getValue());
                                                    return Unit.INSTANCE;
                                                }

                                                public final void m2313invokevCnGnXg(int i112) {
                                                    dateRangePickerState2.mo2321setDisplayModevCnGnXg(i112);
                                                }
                                            };
                                            composer2.updateRememberedValue(objRememberedValue3);
                                        }
                                        ComposerKt.sourceInformationMarkerEnd(composer2);
                                        DatePickerKt.m2278DisplayModeToggleButtontER2X8s(modifierPadding, iMo2320getDisplayModejFl4v0, (Function1) objRememberedValue3, composer2, 6);
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
                            composableLambdaRememberComposableLambda = null;
                        }
                        composerStartRestartGroup.endReplaceGroup();
                        int i111 = ((i11 >> 3) & 14) | 14155776;
                        int i112 = i11 >> 6;
                        DatePickerColors datePickerColors6 = datePickerColorsColors;
                        DatePickerKt.m2274DateEntryContainerau3_HiA(modifier2, function10, function4, composableLambdaRememberComposableLambda, datePickerColorsColors, TypographyKt.getValue(DatePickerModalTokens.INSTANCE.getRangeSelectionHeaderHeadlineFont(), composerStartRestartGroup, 6), Dp.constructor-impl(DatePickerModalTokens.INSTANCE.m3515getRangeSelectionHeaderContainerHeightD9Ej5fM() - HeaderHeightOffset), ComposableLambdaKt.rememberComposableLambda(-57534331, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i113) {
                                ComposerKt.sourceInformation(composer2, "C142@6428L467,153@6934L91,137@6121L1123:DateRangePicker.kt#uh7d8r");
                                if ((i113 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-57534331, i113, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:137)");
                                    }
                                    Long selectedStartDateMillis = dateRangePickerState.getSelectedStartDateMillis();
                                    Long selectedEndDateMillis = dateRangePickerState.getSelectedEndDateMillis();
                                    long displayedMonthMillis = dateRangePickerState.getDisplayedMonthMillis();
                                    int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1752274220, "CC(remember):DateRangePicker.kt#9igjgp");
                                    boolean zChanged2 = composer2.changed(dateRangePickerState);
                                    final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                    Object objRememberedValue3 = composer2.rememberedValue();
                                    if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                        objRememberedValue3 = (Function2) new Function2<Long, Long, Unit>() {
                                            {
                                                super(2);
                                            }

                                            public Object invoke(Object obj, Object obj2) {
                                                invoke((Long) obj, (Long) obj2);
                                                return Unit.INSTANCE;
                                            }

                                            public final void invoke(Long l, Long l2) {
                                                try {
                                                    dateRangePickerState2.setSelection(l, l2);
                                                } catch (IllegalArgumentException unused) {
                                                }
                                            }
                                        };
                                        composer2.updateRememberedValue(objRememberedValue3);
                                    }
                                    Function2 function11 = (Function2) objRememberedValue3;
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1752290036, "CC(remember):DateRangePicker.kt#9igjgp");
                                    boolean zChanged3 = composer2.changed(dateRangePickerState);
                                    final DateRangePickerState dateRangePickerState3 = dateRangePickerState;
                                    Object objRememberedValue4 = composer2.rememberedValue();
                                    if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                        objRememberedValue4 = (Function1) new Function1<Long, Unit>() {
                                            {
                                                super(1);
                                            }

                                            public Object invoke(Object obj) {
                                                invoke(((Number) obj).longValue());
                                                return Unit.INSTANCE;
                                            }

                                            public final void invoke(long j) {
                                                dateRangePickerState3.setDisplayedMonthMillis(j);
                                            }
                                        };
                                        composer2.updateRememberedValue(objRememberedValue4);
                                    }
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    DateRangePickerKt.m2309SwitchableDateEntryContentRN2D1Q(selectedStartDateMillis, selectedEndDateMillis, displayedMonthMillis, iMo2320getDisplayModejFl4v0, function11, (Function1) objRememberedValue4, calendarModel4, dateRangePickerState.getYearRange(), datePickerFormatter2, dateRangePickerState.getSelectableDates(), datePickerColorsColors, composer2, 0, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, i111 | (i112 & 112) | (i112 & 896) | (i112 & 57344));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        function2RememberComposableLambda = function10;
                        datePickerFormatter3 = datePickerFormatter2;
                        modifier3 = modifier2;
                        z4 = z3;
                        datePickerColors2 = datePickerColors6;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if ((i2 & 4) != 0) {
                                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                                objRememberedValue = composerStartRestartGroup.rememberedValue();
                                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                                }
                                datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                                i3 &= -897;
                            } else {
                                datePickerFormatter2 = datePickerFormatter;
                            }
                            if (i4 != 0) {
                                function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i113) {
                                        ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                        if ((i113 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-162164694, i113, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                            }
                                            DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                i10 = 54;
                            } else {
                                i10 = 54;
                            }
                            if (i6 != 0) {
                                function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i113) {
                                        ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                        if ((i113 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-185279404, i113, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                            }
                                            DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, i10);
                            }
                            if (i8 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 64) != 0) {
                                i3 &= -3670017;
                                datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            }
                        } else {
                            if (i13 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if ((i2 & 4) != 0) {
                                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                                objRememberedValue = composerStartRestartGroup.rememberedValue();
                                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                                }
                                datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                                i3 &= -897;
                            } else {
                                datePickerFormatter2 = datePickerFormatter;
                            }
                            if (i4 != 0) {
                                function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i113) {
                                        ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                        if ((i113 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-162164694, i113, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                            }
                                            DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                i10 = 54;
                            } else {
                                i10 = 54;
                            }
                            if (i6 != 0) {
                                function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i113) {
                                        ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                        if ((i113 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-185279404, i113, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                            }
                                            DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, i10);
                            }
                            if (i8 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 64) != 0) {
                                i3 &= -3670017;
                                datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            }
                        }
                        function4 = function2RememberComposableLambda2;
                        z3 = z2;
                        Function2<? super Composer, ? super Integer, Unit> function11 = function2RememberComposableLambda;
                        i11 = i3;
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(650830774, i11, -1, "androidx.compose.material3.DateRangePicker (DateRangePicker.kt:113)");
                        }
                        localeDefaultLocale = CalendarLocale_androidKt.defaultLocale(composerStartRestartGroup, 0);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454754600, "CC(remember):DateRangePicker.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(localeDefaultLocale);
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        final CalendarModel calendarModel5 = (CalendarModel) objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.startReplaceGroup(-1454747621);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "122@5491L323");
                        if (z3) {
                            composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-1490010652, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i113) {
                                    ComposerKt.sourceInformation(composer2, "C126@5723L50,123@5513L283:DateRangePicker.kt#uh7d8r");
                                    if ((i113 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1490010652, i113, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:123)");
                                        }
                                        Modifier modifierPadding = PaddingKt.padding(Modifier.INSTANCE, DatePickerKt.getDatePickerModeTogglePadding());
                                        int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                        ComposerKt.sourceInformationMarkerStart(composer2, 1752251243, "CC(remember):DateRangePicker.kt#9igjgp");
                                        boolean zChanged2 = composer2.changed(dateRangePickerState);
                                        final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                        Object objRememberedValue3 = composer2.rememberedValue();
                                        if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                            objRememberedValue3 = (Function1) new Function1<DisplayMode, Unit>() {
                                                {
                                                    super(1);
                                                }

                                                public Object invoke(Object obj) {
                                                    m2313invokevCnGnXg(((DisplayMode) obj).getValue());
                                                    return Unit.INSTANCE;
                                                }

                                                public final void m2313invokevCnGnXg(int i114) {
                                                    dateRangePickerState2.mo2321setDisplayModevCnGnXg(i114);
                                                }
                                            };
                                            composer2.updateRememberedValue(objRememberedValue3);
                                        }
                                        ComposerKt.sourceInformationMarkerEnd(composer2);
                                        DatePickerKt.m2278DisplayModeToggleButtontER2X8s(modifierPadding, iMo2320getDisplayModejFl4v0, (Function1) objRememberedValue3, composer2, 6);
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
                            composableLambdaRememberComposableLambda = null;
                        }
                        composerStartRestartGroup.endReplaceGroup();
                        int i113 = ((i11 >> 3) & 14) | 14155776;
                        int i114 = i11 >> 6;
                        DatePickerColors datePickerColors7 = datePickerColorsColors;
                        DatePickerKt.m2274DateEntryContainerau3_HiA(modifier2, function11, function4, composableLambdaRememberComposableLambda, datePickerColorsColors, TypographyKt.getValue(DatePickerModalTokens.INSTANCE.getRangeSelectionHeaderHeadlineFont(), composerStartRestartGroup, 6), Dp.constructor-impl(DatePickerModalTokens.INSTANCE.m3515getRangeSelectionHeaderContainerHeightD9Ej5fM() - HeaderHeightOffset), ComposableLambdaKt.rememberComposableLambda(-57534331, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i115) {
                                ComposerKt.sourceInformation(composer2, "C142@6428L467,153@6934L91,137@6121L1123:DateRangePicker.kt#uh7d8r");
                                if ((i115 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-57534331, i115, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:137)");
                                    }
                                    Long selectedStartDateMillis = dateRangePickerState.getSelectedStartDateMillis();
                                    Long selectedEndDateMillis = dateRangePickerState.getSelectedEndDateMillis();
                                    long displayedMonthMillis = dateRangePickerState.getDisplayedMonthMillis();
                                    int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1752274220, "CC(remember):DateRangePicker.kt#9igjgp");
                                    boolean zChanged2 = composer2.changed(dateRangePickerState);
                                    final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                    Object objRememberedValue3 = composer2.rememberedValue();
                                    if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                        objRememberedValue3 = (Function2) new Function2<Long, Long, Unit>() {
                                            {
                                                super(2);
                                            }

                                            public Object invoke(Object obj, Object obj2) {
                                                invoke((Long) obj, (Long) obj2);
                                                return Unit.INSTANCE;
                                            }

                                            public final void invoke(Long l, Long l2) {
                                                try {
                                                    dateRangePickerState2.setSelection(l, l2);
                                                } catch (IllegalArgumentException unused) {
                                                }
                                            }
                                        };
                                        composer2.updateRememberedValue(objRememberedValue3);
                                    }
                                    Function2 function12 = (Function2) objRememberedValue3;
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1752290036, "CC(remember):DateRangePicker.kt#9igjgp");
                                    boolean zChanged3 = composer2.changed(dateRangePickerState);
                                    final DateRangePickerState dateRangePickerState3 = dateRangePickerState;
                                    Object objRememberedValue4 = composer2.rememberedValue();
                                    if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                        objRememberedValue4 = (Function1) new Function1<Long, Unit>() {
                                            {
                                                super(1);
                                            }

                                            public Object invoke(Object obj) {
                                                invoke(((Number) obj).longValue());
                                                return Unit.INSTANCE;
                                            }

                                            public final void invoke(long j) {
                                                dateRangePickerState3.setDisplayedMonthMillis(j);
                                            }
                                        };
                                        composer2.updateRememberedValue(objRememberedValue4);
                                    }
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    DateRangePickerKt.m2309SwitchableDateEntryContentRN2D1Q(selectedStartDateMillis, selectedEndDateMillis, displayedMonthMillis, iMo2320getDisplayModejFl4v0, function12, (Function1) objRememberedValue4, calendarModel5, dateRangePickerState.getYearRange(), datePickerFormatter2, dateRangePickerState.getSelectableDates(), datePickerColorsColors, composer2, 0, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, i113 | (i114 & 112) | (i114 & 896) | (i114 & 57344));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        function2RememberComposableLambda = function11;
                        datePickerFormatter3 = datePickerFormatter2;
                        modifier3 = modifier2;
                        z4 = z3;
                        datePickerColors2 = datePickerColors7;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final DatePickerFormatter datePickerFormatter6 = datePickerFormatter3;
                        final Function2<? super Composer, ? super Integer, Unit> function12 = function2RememberComposableLambda;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i115) {
                                DateRangePickerKt.DateRangePicker(dateRangePickerState, modifier3, datePickerFormatter6, function12, function4, z4, datePickerColors2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 196608;
                z2 = z;
                if ((1572864 & i) == 0) {
                    if ((i2 & 64) == 0) {
                        datePickerColorsColors = datePickerColors;
                        if (composerStartRestartGroup.changed(datePickerColorsColors)) {
                        }
                        i3 |= i14;
                    } else {
                        datePickerColorsColors = datePickerColors;
                    }
                    i3 |= i14;
                } else {
                    datePickerColorsColors = datePickerColors;
                }
                if ((599187 & i3) == 599186) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i2 & 4) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -897;
                        } else {
                            datePickerFormatter2 = datePickerFormatter;
                        }
                        if (i4 != 0) {
                            function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i115) {
                                    ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                    if ((i115 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-162164694, i115, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            i10 = 54;
                        } else {
                            i10 = 54;
                        }
                        if (i6 != 0) {
                            function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i115) {
                                    ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                    if ((i115 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-185279404, i115, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, i10);
                        }
                        if (i8 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                    } else {
                        if (i13 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i2 & 4) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -897;
                        } else {
                            datePickerFormatter2 = datePickerFormatter;
                        }
                        if (i4 != 0) {
                            function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i115) {
                                    ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                    if ((i115 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-162164694, i115, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            i10 = 54;
                        } else {
                            i10 = 54;
                        }
                        if (i6 != 0) {
                            function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i115) {
                                    ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                    if ((i115 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-185279404, i115, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, i10);
                        }
                        if (i8 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                    }
                    function4 = function2RememberComposableLambda2;
                    z3 = z2;
                    Function2<? super Composer, ? super Integer, Unit> function13 = function2RememberComposableLambda;
                    i11 = i3;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(650830774, i11, -1, "androidx.compose.material3.DateRangePicker (DateRangePicker.kt:113)");
                    }
                    localeDefaultLocale = CalendarLocale_androidKt.defaultLocale(composerStartRestartGroup, 0);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454754600, "CC(remember):DateRangePicker.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(localeDefaultLocale);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    final CalendarModel calendarModel6 = (CalendarModel) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.startReplaceGroup(-1454747621);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "122@5491L323");
                    if (z3) {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-1490010652, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i115) {
                                ComposerKt.sourceInformation(composer2, "C126@5723L50,123@5513L283:DateRangePicker.kt#uh7d8r");
                                if ((i115 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1490010652, i115, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:123)");
                                    }
                                    Modifier modifierPadding = PaddingKt.padding(Modifier.INSTANCE, DatePickerKt.getDatePickerModeTogglePadding());
                                    int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1752251243, "CC(remember):DateRangePicker.kt#9igjgp");
                                    boolean zChanged2 = composer2.changed(dateRangePickerState);
                                    final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                    Object objRememberedValue3 = composer2.rememberedValue();
                                    if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                        objRememberedValue3 = (Function1) new Function1<DisplayMode, Unit>() {
                                            {
                                                super(1);
                                            }

                                            public Object invoke(Object obj) {
                                                m2313invokevCnGnXg(((DisplayMode) obj).getValue());
                                                return Unit.INSTANCE;
                                            }

                                            public final void m2313invokevCnGnXg(int i116) {
                                                dateRangePickerState2.mo2321setDisplayModevCnGnXg(i116);
                                            }
                                        };
                                        composer2.updateRememberedValue(objRememberedValue3);
                                    }
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    DatePickerKt.m2278DisplayModeToggleButtontER2X8s(modifierPadding, iMo2320getDisplayModejFl4v0, (Function1) objRememberedValue3, composer2, 6);
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
                        composableLambdaRememberComposableLambda = null;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    int i115 = ((i11 >> 3) & 14) | 14155776;
                    int i116 = i11 >> 6;
                    DatePickerColors datePickerColors8 = datePickerColorsColors;
                    DatePickerKt.m2274DateEntryContainerau3_HiA(modifier2, function13, function4, composableLambdaRememberComposableLambda, datePickerColorsColors, TypographyKt.getValue(DatePickerModalTokens.INSTANCE.getRangeSelectionHeaderHeadlineFont(), composerStartRestartGroup, 6), Dp.constructor-impl(DatePickerModalTokens.INSTANCE.m3515getRangeSelectionHeaderContainerHeightD9Ej5fM() - HeaderHeightOffset), ComposableLambdaKt.rememberComposableLambda(-57534331, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i117) {
                            ComposerKt.sourceInformation(composer2, "C142@6428L467,153@6934L91,137@6121L1123:DateRangePicker.kt#uh7d8r");
                            if ((i117 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-57534331, i117, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:137)");
                                }
                                Long selectedStartDateMillis = dateRangePickerState.getSelectedStartDateMillis();
                                Long selectedEndDateMillis = dateRangePickerState.getSelectedEndDateMillis();
                                long displayedMonthMillis = dateRangePickerState.getDisplayedMonthMillis();
                                int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                ComposerKt.sourceInformationMarkerStart(composer2, 1752274220, "CC(remember):DateRangePicker.kt#9igjgp");
                                boolean zChanged2 = composer2.changed(dateRangePickerState);
                                final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                Object objRememberedValue3 = composer2.rememberedValue();
                                if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue3 = (Function2) new Function2<Long, Long, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Long) obj, (Long) obj2);
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Long l, Long l2) {
                                            try {
                                                dateRangePickerState2.setSelection(l, l2);
                                            } catch (IllegalArgumentException unused) {
                                            }
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue3);
                                }
                                Function2 function14 = (Function2) objRememberedValue3;
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerStart(composer2, 1752290036, "CC(remember):DateRangePicker.kt#9igjgp");
                                boolean zChanged3 = composer2.changed(dateRangePickerState);
                                final DateRangePickerState dateRangePickerState3 = dateRangePickerState;
                                Object objRememberedValue4 = composer2.rememberedValue();
                                if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue4 = (Function1) new Function1<Long, Unit>() {
                                        {
                                            super(1);
                                        }

                                        public Object invoke(Object obj) {
                                            invoke(((Number) obj).longValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(long j) {
                                            dateRangePickerState3.setDisplayedMonthMillis(j);
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue4);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                DateRangePickerKt.m2309SwitchableDateEntryContentRN2D1Q(selectedStartDateMillis, selectedEndDateMillis, displayedMonthMillis, iMo2320getDisplayModejFl4v0, function14, (Function1) objRememberedValue4, calendarModel6, dateRangePickerState.getYearRange(), datePickerFormatter2, dateRangePickerState.getSelectableDates(), datePickerColorsColors, composer2, 0, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, i115 | (i116 & 112) | (i116 & 896) | (i116 & 57344));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function2RememberComposableLambda = function13;
                    datePickerFormatter3 = datePickerFormatter2;
                    modifier3 = modifier2;
                    z4 = z3;
                    datePickerColors2 = datePickerColors8;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i2 & 4) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -897;
                        } else {
                            datePickerFormatter2 = datePickerFormatter;
                        }
                        if (i4 != 0) {
                            function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i117) {
                                    ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                    if ((i117 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-162164694, i117, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            i10 = 54;
                        } else {
                            i10 = 54;
                        }
                        if (i6 != 0) {
                            function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i117) {
                                    ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                    if ((i117 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-185279404, i117, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, i10);
                        }
                        if (i8 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                    } else {
                        if (i13 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i2 & 4) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -897;
                        } else {
                            datePickerFormatter2 = datePickerFormatter;
                        }
                        if (i4 != 0) {
                            function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i117) {
                                    ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                    if ((i117 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-162164694, i117, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            i10 = 54;
                        } else {
                            i10 = 54;
                        }
                        if (i6 != 0) {
                            function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i117) {
                                    ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                    if ((i117 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-185279404, i117, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, i10);
                        }
                        if (i8 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                    }
                    function4 = function2RememberComposableLambda2;
                    z3 = z2;
                    Function2<? super Composer, ? super Integer, Unit> function14 = function2RememberComposableLambda;
                    i11 = i3;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(650830774, i11, -1, "androidx.compose.material3.DateRangePicker (DateRangePicker.kt:113)");
                    }
                    localeDefaultLocale = CalendarLocale_androidKt.defaultLocale(composerStartRestartGroup, 0);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454754600, "CC(remember):DateRangePicker.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(localeDefaultLocale);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    final CalendarModel calendarModel7 = (CalendarModel) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.startReplaceGroup(-1454747621);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "122@5491L323");
                    if (z3) {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-1490010652, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i117) {
                                ComposerKt.sourceInformation(composer2, "C126@5723L50,123@5513L283:DateRangePicker.kt#uh7d8r");
                                if ((i117 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1490010652, i117, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:123)");
                                    }
                                    Modifier modifierPadding = PaddingKt.padding(Modifier.INSTANCE, DatePickerKt.getDatePickerModeTogglePadding());
                                    int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1752251243, "CC(remember):DateRangePicker.kt#9igjgp");
                                    boolean zChanged2 = composer2.changed(dateRangePickerState);
                                    final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                    Object objRememberedValue3 = composer2.rememberedValue();
                                    if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                        objRememberedValue3 = (Function1) new Function1<DisplayMode, Unit>() {
                                            {
                                                super(1);
                                            }

                                            public Object invoke(Object obj) {
                                                m2313invokevCnGnXg(((DisplayMode) obj).getValue());
                                                return Unit.INSTANCE;
                                            }

                                            public final void m2313invokevCnGnXg(int i118) {
                                                dateRangePickerState2.mo2321setDisplayModevCnGnXg(i118);
                                            }
                                        };
                                        composer2.updateRememberedValue(objRememberedValue3);
                                    }
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    DatePickerKt.m2278DisplayModeToggleButtontER2X8s(modifierPadding, iMo2320getDisplayModejFl4v0, (Function1) objRememberedValue3, composer2, 6);
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
                        composableLambdaRememberComposableLambda = null;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    int i117 = ((i11 >> 3) & 14) | 14155776;
                    int i118 = i11 >> 6;
                    DatePickerColors datePickerColors9 = datePickerColorsColors;
                    DatePickerKt.m2274DateEntryContainerau3_HiA(modifier2, function14, function4, composableLambdaRememberComposableLambda, datePickerColorsColors, TypographyKt.getValue(DatePickerModalTokens.INSTANCE.getRangeSelectionHeaderHeadlineFont(), composerStartRestartGroup, 6), Dp.constructor-impl(DatePickerModalTokens.INSTANCE.m3515getRangeSelectionHeaderContainerHeightD9Ej5fM() - HeaderHeightOffset), ComposableLambdaKt.rememberComposableLambda(-57534331, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i119) {
                            ComposerKt.sourceInformation(composer2, "C142@6428L467,153@6934L91,137@6121L1123:DateRangePicker.kt#uh7d8r");
                            if ((i119 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-57534331, i119, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:137)");
                                }
                                Long selectedStartDateMillis = dateRangePickerState.getSelectedStartDateMillis();
                                Long selectedEndDateMillis = dateRangePickerState.getSelectedEndDateMillis();
                                long displayedMonthMillis = dateRangePickerState.getDisplayedMonthMillis();
                                int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                ComposerKt.sourceInformationMarkerStart(composer2, 1752274220, "CC(remember):DateRangePicker.kt#9igjgp");
                                boolean zChanged2 = composer2.changed(dateRangePickerState);
                                final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                Object objRememberedValue3 = composer2.rememberedValue();
                                if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue3 = (Function2) new Function2<Long, Long, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Long) obj, (Long) obj2);
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Long l, Long l2) {
                                            try {
                                                dateRangePickerState2.setSelection(l, l2);
                                            } catch (IllegalArgumentException unused) {
                                            }
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue3);
                                }
                                Function2 function15 = (Function2) objRememberedValue3;
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerStart(composer2, 1752290036, "CC(remember):DateRangePicker.kt#9igjgp");
                                boolean zChanged3 = composer2.changed(dateRangePickerState);
                                final DateRangePickerState dateRangePickerState3 = dateRangePickerState;
                                Object objRememberedValue4 = composer2.rememberedValue();
                                if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue4 = (Function1) new Function1<Long, Unit>() {
                                        {
                                            super(1);
                                        }

                                        public Object invoke(Object obj) {
                                            invoke(((Number) obj).longValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(long j) {
                                            dateRangePickerState3.setDisplayedMonthMillis(j);
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue4);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                DateRangePickerKt.m2309SwitchableDateEntryContentRN2D1Q(selectedStartDateMillis, selectedEndDateMillis, displayedMonthMillis, iMo2320getDisplayModejFl4v0, function15, (Function1) objRememberedValue4, calendarModel7, dateRangePickerState.getYearRange(), datePickerFormatter2, dateRangePickerState.getSelectableDates(), datePickerColorsColors, composer2, 0, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, i117 | (i118 & 112) | (i118 & 896) | (i118 & 57344));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function2RememberComposableLambda = function14;
                    datePickerFormatter3 = datePickerFormatter2;
                    modifier3 = modifier2;
                    z4 = z3;
                    datePickerColors2 = datePickerColors9;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final DatePickerFormatter datePickerFormatter7 = datePickerFormatter3;
                    final Function2<? super Composer, ? super Integer, Unit> function15 = function2RememberComposableLambda;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i119) {
                            DateRangePickerKt.DateRangePicker(dateRangePickerState, modifier3, datePickerFormatter7, function15, function4, z4, datePickerColors2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            function2RememberComposableLambda = function2;
            i6 = i2 & 16;
            if (i6 != 0) {
                if ((i & 24576) == 0) {
                    function2RememberComposableLambda2 = function3;
                    if (composerStartRestartGroup.changedInstance(function2RememberComposableLambda2)) {
                        i7 = Fields.Clip;
                    } else {
                        i7 = Fields.Shape;
                    }
                    i3 |= i7;
                }
                i8 = i2 & 32;
                if (i8 != 0) {
                    if ((196608 & i) == 0) {
                        z2 = z;
                        if (composerStartRestartGroup.changed(z2)) {
                            i9 = Fields.RenderEffect;
                        } else {
                            i9 = 65536;
                        }
                        i3 |= i9;
                    }
                    if ((1572864 & i) == 0) {
                        if ((i2 & 64) == 0) {
                            datePickerColorsColors = datePickerColors;
                            if (composerStartRestartGroup.changed(datePickerColorsColors)) {
                            }
                            i3 |= i14;
                        } else {
                            datePickerColorsColors = datePickerColors;
                        }
                        i3 |= i14;
                    } else {
                        datePickerColorsColors = datePickerColors;
                    }
                    if ((599187 & i3) == 599186) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if ((i2 & 4) != 0) {
                                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                                objRememberedValue = composerStartRestartGroup.rememberedValue();
                                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                                }
                                datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                                i3 &= -897;
                            } else {
                                datePickerFormatter2 = datePickerFormatter;
                            }
                            if (i4 != 0) {
                                function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i119) {
                                        ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                        if ((i119 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-162164694, i119, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                            }
                                            DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                i10 = 54;
                            } else {
                                i10 = 54;
                            }
                            if (i6 != 0) {
                                function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i119) {
                                        ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                        if ((i119 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-185279404, i119, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                            }
                                            DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, i10);
                            }
                            if (i8 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 64) != 0) {
                                i3 &= -3670017;
                                datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            }
                        } else {
                            if (i13 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if ((i2 & 4) != 0) {
                                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                                objRememberedValue = composerStartRestartGroup.rememberedValue();
                                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                                }
                                datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                                i3 &= -897;
                            } else {
                                datePickerFormatter2 = datePickerFormatter;
                            }
                            if (i4 != 0) {
                                function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i119) {
                                        ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                        if ((i119 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-162164694, i119, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                            }
                                            DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                i10 = 54;
                            } else {
                                i10 = 54;
                            }
                            if (i6 != 0) {
                                function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i119) {
                                        ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                        if ((i119 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-185279404, i119, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                            }
                                            DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, i10);
                            }
                            if (i8 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 64) != 0) {
                                i3 &= -3670017;
                                datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            }
                        }
                        function4 = function2RememberComposableLambda2;
                        z3 = z2;
                        Function2<? super Composer, ? super Integer, Unit> function16 = function2RememberComposableLambda;
                        i11 = i3;
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(650830774, i11, -1, "androidx.compose.material3.DateRangePicker (DateRangePicker.kt:113)");
                        }
                        localeDefaultLocale = CalendarLocale_androidKt.defaultLocale(composerStartRestartGroup, 0);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454754600, "CC(remember):DateRangePicker.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(localeDefaultLocale);
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        final CalendarModel calendarModel8 = (CalendarModel) objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.startReplaceGroup(-1454747621);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "122@5491L323");
                        if (z3) {
                            composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-1490010652, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i119) {
                                    ComposerKt.sourceInformation(composer2, "C126@5723L50,123@5513L283:DateRangePicker.kt#uh7d8r");
                                    if ((i119 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1490010652, i119, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:123)");
                                        }
                                        Modifier modifierPadding = PaddingKt.padding(Modifier.INSTANCE, DatePickerKt.getDatePickerModeTogglePadding());
                                        int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                        ComposerKt.sourceInformationMarkerStart(composer2, 1752251243, "CC(remember):DateRangePicker.kt#9igjgp");
                                        boolean zChanged2 = composer2.changed(dateRangePickerState);
                                        final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                        Object objRememberedValue3 = composer2.rememberedValue();
                                        if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                            objRememberedValue3 = (Function1) new Function1<DisplayMode, Unit>() {
                                                {
                                                    super(1);
                                                }

                                                public Object invoke(Object obj) {
                                                    m2313invokevCnGnXg(((DisplayMode) obj).getValue());
                                                    return Unit.INSTANCE;
                                                }

                                                public final void m2313invokevCnGnXg(int i1110) {
                                                    dateRangePickerState2.mo2321setDisplayModevCnGnXg(i1110);
                                                }
                                            };
                                            composer2.updateRememberedValue(objRememberedValue3);
                                        }
                                        ComposerKt.sourceInformationMarkerEnd(composer2);
                                        DatePickerKt.m2278DisplayModeToggleButtontER2X8s(modifierPadding, iMo2320getDisplayModejFl4v0, (Function1) objRememberedValue3, composer2, 6);
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
                            composableLambdaRememberComposableLambda = null;
                        }
                        composerStartRestartGroup.endReplaceGroup();
                        int i119 = ((i11 >> 3) & 14) | 14155776;
                        int i1110 = i11 >> 6;
                        DatePickerColors datePickerColors10 = datePickerColorsColors;
                        DatePickerKt.m2274DateEntryContainerau3_HiA(modifier2, function16, function4, composableLambdaRememberComposableLambda, datePickerColorsColors, TypographyKt.getValue(DatePickerModalTokens.INSTANCE.getRangeSelectionHeaderHeadlineFont(), composerStartRestartGroup, 6), Dp.constructor-impl(DatePickerModalTokens.INSTANCE.m3515getRangeSelectionHeaderContainerHeightD9Ej5fM() - HeaderHeightOffset), ComposableLambdaKt.rememberComposableLambda(-57534331, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i1111) {
                                ComposerKt.sourceInformation(composer2, "C142@6428L467,153@6934L91,137@6121L1123:DateRangePicker.kt#uh7d8r");
                                if ((i1111 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-57534331, i1111, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:137)");
                                    }
                                    Long selectedStartDateMillis = dateRangePickerState.getSelectedStartDateMillis();
                                    Long selectedEndDateMillis = dateRangePickerState.getSelectedEndDateMillis();
                                    long displayedMonthMillis = dateRangePickerState.getDisplayedMonthMillis();
                                    int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1752274220, "CC(remember):DateRangePicker.kt#9igjgp");
                                    boolean zChanged2 = composer2.changed(dateRangePickerState);
                                    final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                    Object objRememberedValue3 = composer2.rememberedValue();
                                    if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                        objRememberedValue3 = (Function2) new Function2<Long, Long, Unit>() {
                                            {
                                                super(2);
                                            }

                                            public Object invoke(Object obj, Object obj2) {
                                                invoke((Long) obj, (Long) obj2);
                                                return Unit.INSTANCE;
                                            }

                                            public final void invoke(Long l, Long l2) {
                                                try {
                                                    dateRangePickerState2.setSelection(l, l2);
                                                } catch (IllegalArgumentException unused) {
                                                }
                                            }
                                        };
                                        composer2.updateRememberedValue(objRememberedValue3);
                                    }
                                    Function2 function17 = (Function2) objRememberedValue3;
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1752290036, "CC(remember):DateRangePicker.kt#9igjgp");
                                    boolean zChanged3 = composer2.changed(dateRangePickerState);
                                    final DateRangePickerState dateRangePickerState3 = dateRangePickerState;
                                    Object objRememberedValue4 = composer2.rememberedValue();
                                    if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                        objRememberedValue4 = (Function1) new Function1<Long, Unit>() {
                                            {
                                                super(1);
                                            }

                                            public Object invoke(Object obj) {
                                                invoke(((Number) obj).longValue());
                                                return Unit.INSTANCE;
                                            }

                                            public final void invoke(long j) {
                                                dateRangePickerState3.setDisplayedMonthMillis(j);
                                            }
                                        };
                                        composer2.updateRememberedValue(objRememberedValue4);
                                    }
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    DateRangePickerKt.m2309SwitchableDateEntryContentRN2D1Q(selectedStartDateMillis, selectedEndDateMillis, displayedMonthMillis, iMo2320getDisplayModejFl4v0, function17, (Function1) objRememberedValue4, calendarModel8, dateRangePickerState.getYearRange(), datePickerFormatter2, dateRangePickerState.getSelectableDates(), datePickerColorsColors, composer2, 0, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, i119 | (i1110 & 112) | (i1110 & 896) | (i1110 & 57344));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        function2RememberComposableLambda = function16;
                        datePickerFormatter3 = datePickerFormatter2;
                        modifier3 = modifier2;
                        z4 = z3;
                        datePickerColors2 = datePickerColors10;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if ((i2 & 4) != 0) {
                                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                                objRememberedValue = composerStartRestartGroup.rememberedValue();
                                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                                }
                                datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                                i3 &= -897;
                            } else {
                                datePickerFormatter2 = datePickerFormatter;
                            }
                            if (i4 != 0) {
                                function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i1111) {
                                        ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                        if ((i1111 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-162164694, i1111, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                            }
                                            DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                i10 = 54;
                            } else {
                                i10 = 54;
                            }
                            if (i6 != 0) {
                                function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i1111) {
                                        ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                        if ((i1111 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-185279404, i1111, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                            }
                                            DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, i10);
                            }
                            if (i8 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 64) != 0) {
                                i3 &= -3670017;
                                datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            }
                        } else {
                            if (i13 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if ((i2 & 4) != 0) {
                                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                                objRememberedValue = composerStartRestartGroup.rememberedValue();
                                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                                }
                                datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                                i3 &= -897;
                            } else {
                                datePickerFormatter2 = datePickerFormatter;
                            }
                            if (i4 != 0) {
                                function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i1111) {
                                        ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                        if ((i1111 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-162164694, i1111, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                            }
                                            DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                i10 = 54;
                            } else {
                                i10 = 54;
                            }
                            if (i6 != 0) {
                                function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i1111) {
                                        ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                        if ((i1111 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-185279404, i1111, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                            }
                                            DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, i10);
                            }
                            if (i8 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 64) != 0) {
                                i3 &= -3670017;
                                datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            }
                        }
                        function4 = function2RememberComposableLambda2;
                        z3 = z2;
                        Function2<? super Composer, ? super Integer, Unit> function17 = function2RememberComposableLambda;
                        i11 = i3;
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(650830774, i11, -1, "androidx.compose.material3.DateRangePicker (DateRangePicker.kt:113)");
                        }
                        localeDefaultLocale = CalendarLocale_androidKt.defaultLocale(composerStartRestartGroup, 0);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454754600, "CC(remember):DateRangePicker.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(localeDefaultLocale);
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        final CalendarModel calendarModel9 = (CalendarModel) objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.startReplaceGroup(-1454747621);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "122@5491L323");
                        if (z3) {
                            composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-1490010652, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i1111) {
                                    ComposerKt.sourceInformation(composer2, "C126@5723L50,123@5513L283:DateRangePicker.kt#uh7d8r");
                                    if ((i1111 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1490010652, i1111, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:123)");
                                        }
                                        Modifier modifierPadding = PaddingKt.padding(Modifier.INSTANCE, DatePickerKt.getDatePickerModeTogglePadding());
                                        int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                        ComposerKt.sourceInformationMarkerStart(composer2, 1752251243, "CC(remember):DateRangePicker.kt#9igjgp");
                                        boolean zChanged2 = composer2.changed(dateRangePickerState);
                                        final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                        Object objRememberedValue3 = composer2.rememberedValue();
                                        if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                            objRememberedValue3 = (Function1) new Function1<DisplayMode, Unit>() {
                                                {
                                                    super(1);
                                                }

                                                public Object invoke(Object obj) {
                                                    m2313invokevCnGnXg(((DisplayMode) obj).getValue());
                                                    return Unit.INSTANCE;
                                                }

                                                public final void m2313invokevCnGnXg(int i1112) {
                                                    dateRangePickerState2.mo2321setDisplayModevCnGnXg(i1112);
                                                }
                                            };
                                            composer2.updateRememberedValue(objRememberedValue3);
                                        }
                                        ComposerKt.sourceInformationMarkerEnd(composer2);
                                        DatePickerKt.m2278DisplayModeToggleButtontER2X8s(modifierPadding, iMo2320getDisplayModejFl4v0, (Function1) objRememberedValue3, composer2, 6);
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
                            composableLambdaRememberComposableLambda = null;
                        }
                        composerStartRestartGroup.endReplaceGroup();
                        int i1111 = ((i11 >> 3) & 14) | 14155776;
                        int i1112 = i11 >> 6;
                        DatePickerColors datePickerColors11 = datePickerColorsColors;
                        DatePickerKt.m2274DateEntryContainerau3_HiA(modifier2, function17, function4, composableLambdaRememberComposableLambda, datePickerColorsColors, TypographyKt.getValue(DatePickerModalTokens.INSTANCE.getRangeSelectionHeaderHeadlineFont(), composerStartRestartGroup, 6), Dp.constructor-impl(DatePickerModalTokens.INSTANCE.m3515getRangeSelectionHeaderContainerHeightD9Ej5fM() - HeaderHeightOffset), ComposableLambdaKt.rememberComposableLambda(-57534331, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i1113) {
                                ComposerKt.sourceInformation(composer2, "C142@6428L467,153@6934L91,137@6121L1123:DateRangePicker.kt#uh7d8r");
                                if ((i1113 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-57534331, i1113, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:137)");
                                    }
                                    Long selectedStartDateMillis = dateRangePickerState.getSelectedStartDateMillis();
                                    Long selectedEndDateMillis = dateRangePickerState.getSelectedEndDateMillis();
                                    long displayedMonthMillis = dateRangePickerState.getDisplayedMonthMillis();
                                    int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1752274220, "CC(remember):DateRangePicker.kt#9igjgp");
                                    boolean zChanged2 = composer2.changed(dateRangePickerState);
                                    final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                    Object objRememberedValue3 = composer2.rememberedValue();
                                    if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                        objRememberedValue3 = (Function2) new Function2<Long, Long, Unit>() {
                                            {
                                                super(2);
                                            }

                                            public Object invoke(Object obj, Object obj2) {
                                                invoke((Long) obj, (Long) obj2);
                                                return Unit.INSTANCE;
                                            }

                                            public final void invoke(Long l, Long l2) {
                                                try {
                                                    dateRangePickerState2.setSelection(l, l2);
                                                } catch (IllegalArgumentException unused) {
                                                }
                                            }
                                        };
                                        composer2.updateRememberedValue(objRememberedValue3);
                                    }
                                    Function2 function18 = (Function2) objRememberedValue3;
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1752290036, "CC(remember):DateRangePicker.kt#9igjgp");
                                    boolean zChanged3 = composer2.changed(dateRangePickerState);
                                    final DateRangePickerState dateRangePickerState3 = dateRangePickerState;
                                    Object objRememberedValue4 = composer2.rememberedValue();
                                    if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                        objRememberedValue4 = (Function1) new Function1<Long, Unit>() {
                                            {
                                                super(1);
                                            }

                                            public Object invoke(Object obj) {
                                                invoke(((Number) obj).longValue());
                                                return Unit.INSTANCE;
                                            }

                                            public final void invoke(long j) {
                                                dateRangePickerState3.setDisplayedMonthMillis(j);
                                            }
                                        };
                                        composer2.updateRememberedValue(objRememberedValue4);
                                    }
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    DateRangePickerKt.m2309SwitchableDateEntryContentRN2D1Q(selectedStartDateMillis, selectedEndDateMillis, displayedMonthMillis, iMo2320getDisplayModejFl4v0, function18, (Function1) objRememberedValue4, calendarModel9, dateRangePickerState.getYearRange(), datePickerFormatter2, dateRangePickerState.getSelectableDates(), datePickerColorsColors, composer2, 0, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, i1111 | (i1112 & 112) | (i1112 & 896) | (i1112 & 57344));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        function2RememberComposableLambda = function17;
                        datePickerFormatter3 = datePickerFormatter2;
                        modifier3 = modifier2;
                        z4 = z3;
                        datePickerColors2 = datePickerColors11;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final DatePickerFormatter datePickerFormatter8 = datePickerFormatter3;
                        final Function2<? super Composer, ? super Integer, Unit> function18 = function2RememberComposableLambda;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i1113) {
                                DateRangePickerKt.DateRangePicker(dateRangePickerState, modifier3, datePickerFormatter8, function18, function4, z4, datePickerColors2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 196608;
                z2 = z;
                if ((1572864 & i) == 0) {
                    if ((i2 & 64) == 0) {
                        datePickerColorsColors = datePickerColors;
                        if (composerStartRestartGroup.changed(datePickerColorsColors)) {
                        }
                        i3 |= i14;
                    } else {
                        datePickerColorsColors = datePickerColors;
                    }
                    i3 |= i14;
                } else {
                    datePickerColorsColors = datePickerColors;
                }
                if ((599187 & i3) == 599186) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i2 & 4) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -897;
                        } else {
                            datePickerFormatter2 = datePickerFormatter;
                        }
                        if (i4 != 0) {
                            function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i1113) {
                                    ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                    if ((i1113 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-162164694, i1113, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            i10 = 54;
                        } else {
                            i10 = 54;
                        }
                        if (i6 != 0) {
                            function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i1113) {
                                    ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                    if ((i1113 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-185279404, i1113, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, i10);
                        }
                        if (i8 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                    } else {
                        if (i13 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i2 & 4) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -897;
                        } else {
                            datePickerFormatter2 = datePickerFormatter;
                        }
                        if (i4 != 0) {
                            function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i1113) {
                                    ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                    if ((i1113 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-162164694, i1113, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            i10 = 54;
                        } else {
                            i10 = 54;
                        }
                        if (i6 != 0) {
                            function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i1113) {
                                    ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                    if ((i1113 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-185279404, i1113, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, i10);
                        }
                        if (i8 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                    }
                    function4 = function2RememberComposableLambda2;
                    z3 = z2;
                    Function2<? super Composer, ? super Integer, Unit> function19 = function2RememberComposableLambda;
                    i11 = i3;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(650830774, i11, -1, "androidx.compose.material3.DateRangePicker (DateRangePicker.kt:113)");
                    }
                    localeDefaultLocale = CalendarLocale_androidKt.defaultLocale(composerStartRestartGroup, 0);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454754600, "CC(remember):DateRangePicker.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(localeDefaultLocale);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    final CalendarModel calendarModel10 = (CalendarModel) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.startReplaceGroup(-1454747621);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "122@5491L323");
                    if (z3) {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-1490010652, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i1113) {
                                ComposerKt.sourceInformation(composer2, "C126@5723L50,123@5513L283:DateRangePicker.kt#uh7d8r");
                                if ((i1113 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1490010652, i1113, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:123)");
                                    }
                                    Modifier modifierPadding = PaddingKt.padding(Modifier.INSTANCE, DatePickerKt.getDatePickerModeTogglePadding());
                                    int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1752251243, "CC(remember):DateRangePicker.kt#9igjgp");
                                    boolean zChanged2 = composer2.changed(dateRangePickerState);
                                    final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                    Object objRememberedValue3 = composer2.rememberedValue();
                                    if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                        objRememberedValue3 = (Function1) new Function1<DisplayMode, Unit>() {
                                            {
                                                super(1);
                                            }

                                            public Object invoke(Object obj) {
                                                m2313invokevCnGnXg(((DisplayMode) obj).getValue());
                                                return Unit.INSTANCE;
                                            }

                                            public final void m2313invokevCnGnXg(int i1114) {
                                                dateRangePickerState2.mo2321setDisplayModevCnGnXg(i1114);
                                            }
                                        };
                                        composer2.updateRememberedValue(objRememberedValue3);
                                    }
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    DatePickerKt.m2278DisplayModeToggleButtontER2X8s(modifierPadding, iMo2320getDisplayModejFl4v0, (Function1) objRememberedValue3, composer2, 6);
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
                        composableLambdaRememberComposableLambda = null;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    int i1113 = ((i11 >> 3) & 14) | 14155776;
                    int i1114 = i11 >> 6;
                    DatePickerColors datePickerColors12 = datePickerColorsColors;
                    DatePickerKt.m2274DateEntryContainerau3_HiA(modifier2, function19, function4, composableLambdaRememberComposableLambda, datePickerColorsColors, TypographyKt.getValue(DatePickerModalTokens.INSTANCE.getRangeSelectionHeaderHeadlineFont(), composerStartRestartGroup, 6), Dp.constructor-impl(DatePickerModalTokens.INSTANCE.m3515getRangeSelectionHeaderContainerHeightD9Ej5fM() - HeaderHeightOffset), ComposableLambdaKt.rememberComposableLambda(-57534331, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1115) {
                            ComposerKt.sourceInformation(composer2, "C142@6428L467,153@6934L91,137@6121L1123:DateRangePicker.kt#uh7d8r");
                            if ((i1115 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-57534331, i1115, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:137)");
                                }
                                Long selectedStartDateMillis = dateRangePickerState.getSelectedStartDateMillis();
                                Long selectedEndDateMillis = dateRangePickerState.getSelectedEndDateMillis();
                                long displayedMonthMillis = dateRangePickerState.getDisplayedMonthMillis();
                                int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                ComposerKt.sourceInformationMarkerStart(composer2, 1752274220, "CC(remember):DateRangePicker.kt#9igjgp");
                                boolean zChanged2 = composer2.changed(dateRangePickerState);
                                final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                Object objRememberedValue3 = composer2.rememberedValue();
                                if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue3 = (Function2) new Function2<Long, Long, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Long) obj, (Long) obj2);
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Long l, Long l2) {
                                            try {
                                                dateRangePickerState2.setSelection(l, l2);
                                            } catch (IllegalArgumentException unused) {
                                            }
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue3);
                                }
                                Function2 function110 = (Function2) objRememberedValue3;
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerStart(composer2, 1752290036, "CC(remember):DateRangePicker.kt#9igjgp");
                                boolean zChanged3 = composer2.changed(dateRangePickerState);
                                final DateRangePickerState dateRangePickerState3 = dateRangePickerState;
                                Object objRememberedValue4 = composer2.rememberedValue();
                                if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue4 = (Function1) new Function1<Long, Unit>() {
                                        {
                                            super(1);
                                        }

                                        public Object invoke(Object obj) {
                                            invoke(((Number) obj).longValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(long j) {
                                            dateRangePickerState3.setDisplayedMonthMillis(j);
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue4);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                DateRangePickerKt.m2309SwitchableDateEntryContentRN2D1Q(selectedStartDateMillis, selectedEndDateMillis, displayedMonthMillis, iMo2320getDisplayModejFl4v0, function110, (Function1) objRememberedValue4, calendarModel10, dateRangePickerState.getYearRange(), datePickerFormatter2, dateRangePickerState.getSelectableDates(), datePickerColorsColors, composer2, 0, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, i1113 | (i1114 & 112) | (i1114 & 896) | (i1114 & 57344));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function2RememberComposableLambda = function19;
                    datePickerFormatter3 = datePickerFormatter2;
                    modifier3 = modifier2;
                    z4 = z3;
                    datePickerColors2 = datePickerColors12;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i2 & 4) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -897;
                        } else {
                            datePickerFormatter2 = datePickerFormatter;
                        }
                        if (i4 != 0) {
                            function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i1115) {
                                    ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                    if ((i1115 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-162164694, i1115, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            i10 = 54;
                        } else {
                            i10 = 54;
                        }
                        if (i6 != 0) {
                            function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i1115) {
                                    ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                    if ((i1115 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-185279404, i1115, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, i10);
                        }
                        if (i8 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                    } else {
                        if (i13 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i2 & 4) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -897;
                        } else {
                            datePickerFormatter2 = datePickerFormatter;
                        }
                        if (i4 != 0) {
                            function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i1115) {
                                    ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                    if ((i1115 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-162164694, i1115, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            i10 = 54;
                        } else {
                            i10 = 54;
                        }
                        if (i6 != 0) {
                            function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i1115) {
                                    ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                    if ((i1115 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-185279404, i1115, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, i10);
                        }
                        if (i8 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                    }
                    function4 = function2RememberComposableLambda2;
                    z3 = z2;
                    Function2<? super Composer, ? super Integer, Unit> function110 = function2RememberComposableLambda;
                    i11 = i3;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(650830774, i11, -1, "androidx.compose.material3.DateRangePicker (DateRangePicker.kt:113)");
                    }
                    localeDefaultLocale = CalendarLocale_androidKt.defaultLocale(composerStartRestartGroup, 0);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454754600, "CC(remember):DateRangePicker.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(localeDefaultLocale);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    final CalendarModel calendarModel11 = (CalendarModel) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.startReplaceGroup(-1454747621);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "122@5491L323");
                    if (z3) {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-1490010652, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i1115) {
                                ComposerKt.sourceInformation(composer2, "C126@5723L50,123@5513L283:DateRangePicker.kt#uh7d8r");
                                if ((i1115 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1490010652, i1115, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:123)");
                                    }
                                    Modifier modifierPadding = PaddingKt.padding(Modifier.INSTANCE, DatePickerKt.getDatePickerModeTogglePadding());
                                    int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1752251243, "CC(remember):DateRangePicker.kt#9igjgp");
                                    boolean zChanged2 = composer2.changed(dateRangePickerState);
                                    final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                    Object objRememberedValue3 = composer2.rememberedValue();
                                    if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                        objRememberedValue3 = (Function1) new Function1<DisplayMode, Unit>() {
                                            {
                                                super(1);
                                            }

                                            public Object invoke(Object obj) {
                                                m2313invokevCnGnXg(((DisplayMode) obj).getValue());
                                                return Unit.INSTANCE;
                                            }

                                            public final void m2313invokevCnGnXg(int i1116) {
                                                dateRangePickerState2.mo2321setDisplayModevCnGnXg(i1116);
                                            }
                                        };
                                        composer2.updateRememberedValue(objRememberedValue3);
                                    }
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    DatePickerKt.m2278DisplayModeToggleButtontER2X8s(modifierPadding, iMo2320getDisplayModejFl4v0, (Function1) objRememberedValue3, composer2, 6);
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
                        composableLambdaRememberComposableLambda = null;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    int i1115 = ((i11 >> 3) & 14) | 14155776;
                    int i1116 = i11 >> 6;
                    DatePickerColors datePickerColors13 = datePickerColorsColors;
                    DatePickerKt.m2274DateEntryContainerau3_HiA(modifier2, function110, function4, composableLambdaRememberComposableLambda, datePickerColorsColors, TypographyKt.getValue(DatePickerModalTokens.INSTANCE.getRangeSelectionHeaderHeadlineFont(), composerStartRestartGroup, 6), Dp.constructor-impl(DatePickerModalTokens.INSTANCE.m3515getRangeSelectionHeaderContainerHeightD9Ej5fM() - HeaderHeightOffset), ComposableLambdaKt.rememberComposableLambda(-57534331, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1117) {
                            ComposerKt.sourceInformation(composer2, "C142@6428L467,153@6934L91,137@6121L1123:DateRangePicker.kt#uh7d8r");
                            if ((i1117 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-57534331, i1117, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:137)");
                                }
                                Long selectedStartDateMillis = dateRangePickerState.getSelectedStartDateMillis();
                                Long selectedEndDateMillis = dateRangePickerState.getSelectedEndDateMillis();
                                long displayedMonthMillis = dateRangePickerState.getDisplayedMonthMillis();
                                int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                ComposerKt.sourceInformationMarkerStart(composer2, 1752274220, "CC(remember):DateRangePicker.kt#9igjgp");
                                boolean zChanged2 = composer2.changed(dateRangePickerState);
                                final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                Object objRememberedValue3 = composer2.rememberedValue();
                                if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue3 = (Function2) new Function2<Long, Long, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Long) obj, (Long) obj2);
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Long l, Long l2) {
                                            try {
                                                dateRangePickerState2.setSelection(l, l2);
                                            } catch (IllegalArgumentException unused) {
                                            }
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue3);
                                }
                                Function2 function111 = (Function2) objRememberedValue3;
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerStart(composer2, 1752290036, "CC(remember):DateRangePicker.kt#9igjgp");
                                boolean zChanged3 = composer2.changed(dateRangePickerState);
                                final DateRangePickerState dateRangePickerState3 = dateRangePickerState;
                                Object objRememberedValue4 = composer2.rememberedValue();
                                if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue4 = (Function1) new Function1<Long, Unit>() {
                                        {
                                            super(1);
                                        }

                                        public Object invoke(Object obj) {
                                            invoke(((Number) obj).longValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(long j) {
                                            dateRangePickerState3.setDisplayedMonthMillis(j);
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue4);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                DateRangePickerKt.m2309SwitchableDateEntryContentRN2D1Q(selectedStartDateMillis, selectedEndDateMillis, displayedMonthMillis, iMo2320getDisplayModejFl4v0, function111, (Function1) objRememberedValue4, calendarModel11, dateRangePickerState.getYearRange(), datePickerFormatter2, dateRangePickerState.getSelectableDates(), datePickerColorsColors, composer2, 0, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, i1115 | (i1116 & 112) | (i1116 & 896) | (i1116 & 57344));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function2RememberComposableLambda = function110;
                    datePickerFormatter3 = datePickerFormatter2;
                    modifier3 = modifier2;
                    z4 = z3;
                    datePickerColors2 = datePickerColors13;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final DatePickerFormatter datePickerFormatter9 = datePickerFormatter3;
                    final Function2<? super Composer, ? super Integer, Unit> function111 = function2RememberComposableLambda;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1117) {
                            DateRangePickerKt.DateRangePicker(dateRangePickerState, modifier3, datePickerFormatter9, function111, function4, z4, datePickerColors2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            function2RememberComposableLambda2 = function3;
            i8 = i2 & 32;
            if (i8 != 0) {
                if ((196608 & i) == 0) {
                    z2 = z;
                    if (composerStartRestartGroup.changed(z2)) {
                        i9 = Fields.RenderEffect;
                    } else {
                        i9 = 65536;
                    }
                    i3 |= i9;
                }
                if ((1572864 & i) == 0) {
                    if ((i2 & 64) == 0) {
                        datePickerColorsColors = datePickerColors;
                        if (composerStartRestartGroup.changed(datePickerColorsColors)) {
                        }
                        i3 |= i14;
                    } else {
                        datePickerColorsColors = datePickerColors;
                    }
                    i3 |= i14;
                } else {
                    datePickerColorsColors = datePickerColors;
                }
                if ((599187 & i3) == 599186) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i2 & 4) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -897;
                        } else {
                            datePickerFormatter2 = datePickerFormatter;
                        }
                        if (i4 != 0) {
                            function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i1117) {
                                    ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                    if ((i1117 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-162164694, i1117, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            i10 = 54;
                        } else {
                            i10 = 54;
                        }
                        if (i6 != 0) {
                            function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i1117) {
                                    ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                    if ((i1117 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-185279404, i1117, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, i10);
                        }
                        if (i8 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                    } else {
                        if (i13 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i2 & 4) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -897;
                        } else {
                            datePickerFormatter2 = datePickerFormatter;
                        }
                        if (i4 != 0) {
                            function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i1117) {
                                    ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                    if ((i1117 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-162164694, i1117, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            i10 = 54;
                        } else {
                            i10 = 54;
                        }
                        if (i6 != 0) {
                            function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i1117) {
                                    ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                    if ((i1117 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-185279404, i1117, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, i10);
                        }
                        if (i8 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                    }
                    function4 = function2RememberComposableLambda2;
                    z3 = z2;
                    Function2<? super Composer, ? super Integer, Unit> function112 = function2RememberComposableLambda;
                    i11 = i3;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(650830774, i11, -1, "androidx.compose.material3.DateRangePicker (DateRangePicker.kt:113)");
                    }
                    localeDefaultLocale = CalendarLocale_androidKt.defaultLocale(composerStartRestartGroup, 0);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454754600, "CC(remember):DateRangePicker.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(localeDefaultLocale);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    final CalendarModel calendarModel12 = (CalendarModel) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.startReplaceGroup(-1454747621);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "122@5491L323");
                    if (z3) {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-1490010652, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i1117) {
                                ComposerKt.sourceInformation(composer2, "C126@5723L50,123@5513L283:DateRangePicker.kt#uh7d8r");
                                if ((i1117 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1490010652, i1117, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:123)");
                                    }
                                    Modifier modifierPadding = PaddingKt.padding(Modifier.INSTANCE, DatePickerKt.getDatePickerModeTogglePadding());
                                    int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1752251243, "CC(remember):DateRangePicker.kt#9igjgp");
                                    boolean zChanged2 = composer2.changed(dateRangePickerState);
                                    final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                    Object objRememberedValue3 = composer2.rememberedValue();
                                    if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                        objRememberedValue3 = (Function1) new Function1<DisplayMode, Unit>() {
                                            {
                                                super(1);
                                            }

                                            public Object invoke(Object obj) {
                                                m2313invokevCnGnXg(((DisplayMode) obj).getValue());
                                                return Unit.INSTANCE;
                                            }

                                            public final void m2313invokevCnGnXg(int i1118) {
                                                dateRangePickerState2.mo2321setDisplayModevCnGnXg(i1118);
                                            }
                                        };
                                        composer2.updateRememberedValue(objRememberedValue3);
                                    }
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    DatePickerKt.m2278DisplayModeToggleButtontER2X8s(modifierPadding, iMo2320getDisplayModejFl4v0, (Function1) objRememberedValue3, composer2, 6);
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
                        composableLambdaRememberComposableLambda = null;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    int i1117 = ((i11 >> 3) & 14) | 14155776;
                    int i1118 = i11 >> 6;
                    DatePickerColors datePickerColors14 = datePickerColorsColors;
                    DatePickerKt.m2274DateEntryContainerau3_HiA(modifier2, function112, function4, composableLambdaRememberComposableLambda, datePickerColorsColors, TypographyKt.getValue(DatePickerModalTokens.INSTANCE.getRangeSelectionHeaderHeadlineFont(), composerStartRestartGroup, 6), Dp.constructor-impl(DatePickerModalTokens.INSTANCE.m3515getRangeSelectionHeaderContainerHeightD9Ej5fM() - HeaderHeightOffset), ComposableLambdaKt.rememberComposableLambda(-57534331, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1119) {
                            ComposerKt.sourceInformation(composer2, "C142@6428L467,153@6934L91,137@6121L1123:DateRangePicker.kt#uh7d8r");
                            if ((i1119 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-57534331, i1119, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:137)");
                                }
                                Long selectedStartDateMillis = dateRangePickerState.getSelectedStartDateMillis();
                                Long selectedEndDateMillis = dateRangePickerState.getSelectedEndDateMillis();
                                long displayedMonthMillis = dateRangePickerState.getDisplayedMonthMillis();
                                int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                ComposerKt.sourceInformationMarkerStart(composer2, 1752274220, "CC(remember):DateRangePicker.kt#9igjgp");
                                boolean zChanged2 = composer2.changed(dateRangePickerState);
                                final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                Object objRememberedValue3 = composer2.rememberedValue();
                                if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue3 = (Function2) new Function2<Long, Long, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Long) obj, (Long) obj2);
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Long l, Long l2) {
                                            try {
                                                dateRangePickerState2.setSelection(l, l2);
                                            } catch (IllegalArgumentException unused) {
                                            }
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue3);
                                }
                                Function2 function113 = (Function2) objRememberedValue3;
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerStart(composer2, 1752290036, "CC(remember):DateRangePicker.kt#9igjgp");
                                boolean zChanged3 = composer2.changed(dateRangePickerState);
                                final DateRangePickerState dateRangePickerState3 = dateRangePickerState;
                                Object objRememberedValue4 = composer2.rememberedValue();
                                if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue4 = (Function1) new Function1<Long, Unit>() {
                                        {
                                            super(1);
                                        }

                                        public Object invoke(Object obj) {
                                            invoke(((Number) obj).longValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(long j) {
                                            dateRangePickerState3.setDisplayedMonthMillis(j);
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue4);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                DateRangePickerKt.m2309SwitchableDateEntryContentRN2D1Q(selectedStartDateMillis, selectedEndDateMillis, displayedMonthMillis, iMo2320getDisplayModejFl4v0, function113, (Function1) objRememberedValue4, calendarModel12, dateRangePickerState.getYearRange(), datePickerFormatter2, dateRangePickerState.getSelectableDates(), datePickerColorsColors, composer2, 0, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, i1117 | (i1118 & 112) | (i1118 & 896) | (i1118 & 57344));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function2RememberComposableLambda = function112;
                    datePickerFormatter3 = datePickerFormatter2;
                    modifier3 = modifier2;
                    z4 = z3;
                    datePickerColors2 = datePickerColors14;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i2 & 4) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -897;
                        } else {
                            datePickerFormatter2 = datePickerFormatter;
                        }
                        if (i4 != 0) {
                            function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i1119) {
                                    ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                    if ((i1119 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-162164694, i1119, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            i10 = 54;
                        } else {
                            i10 = 54;
                        }
                        if (i6 != 0) {
                            function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i1119) {
                                    ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                    if ((i1119 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-185279404, i1119, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, i10);
                        }
                        if (i8 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                    } else {
                        if (i13 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i2 & 4) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -897;
                        } else {
                            datePickerFormatter2 = datePickerFormatter;
                        }
                        if (i4 != 0) {
                            function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i1119) {
                                    ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                    if ((i1119 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-162164694, i1119, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            i10 = 54;
                        } else {
                            i10 = 54;
                        }
                        if (i6 != 0) {
                            function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i1119) {
                                    ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                    if ((i1119 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-185279404, i1119, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, i10);
                        }
                        if (i8 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                    }
                    function4 = function2RememberComposableLambda2;
                    z3 = z2;
                    Function2<? super Composer, ? super Integer, Unit> function113 = function2RememberComposableLambda;
                    i11 = i3;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(650830774, i11, -1, "androidx.compose.material3.DateRangePicker (DateRangePicker.kt:113)");
                    }
                    localeDefaultLocale = CalendarLocale_androidKt.defaultLocale(composerStartRestartGroup, 0);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454754600, "CC(remember):DateRangePicker.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(localeDefaultLocale);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    final CalendarModel calendarModel13 = (CalendarModel) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.startReplaceGroup(-1454747621);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "122@5491L323");
                    if (z3) {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-1490010652, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i1119) {
                                ComposerKt.sourceInformation(composer2, "C126@5723L50,123@5513L283:DateRangePicker.kt#uh7d8r");
                                if ((i1119 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1490010652, i1119, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:123)");
                                    }
                                    Modifier modifierPadding = PaddingKt.padding(Modifier.INSTANCE, DatePickerKt.getDatePickerModeTogglePadding());
                                    int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1752251243, "CC(remember):DateRangePicker.kt#9igjgp");
                                    boolean zChanged2 = composer2.changed(dateRangePickerState);
                                    final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                    Object objRememberedValue3 = composer2.rememberedValue();
                                    if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                        objRememberedValue3 = (Function1) new Function1<DisplayMode, Unit>() {
                                            {
                                                super(1);
                                            }

                                            public Object invoke(Object obj) {
                                                m2313invokevCnGnXg(((DisplayMode) obj).getValue());
                                                return Unit.INSTANCE;
                                            }

                                            public final void m2313invokevCnGnXg(int i11110) {
                                                dateRangePickerState2.mo2321setDisplayModevCnGnXg(i11110);
                                            }
                                        };
                                        composer2.updateRememberedValue(objRememberedValue3);
                                    }
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    DatePickerKt.m2278DisplayModeToggleButtontER2X8s(modifierPadding, iMo2320getDisplayModejFl4v0, (Function1) objRememberedValue3, composer2, 6);
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
                        composableLambdaRememberComposableLambda = null;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    int i1119 = ((i11 >> 3) & 14) | 14155776;
                    int i11110 = i11 >> 6;
                    DatePickerColors datePickerColors15 = datePickerColorsColors;
                    DatePickerKt.m2274DateEntryContainerau3_HiA(modifier2, function113, function4, composableLambdaRememberComposableLambda, datePickerColorsColors, TypographyKt.getValue(DatePickerModalTokens.INSTANCE.getRangeSelectionHeaderHeadlineFont(), composerStartRestartGroup, 6), Dp.constructor-impl(DatePickerModalTokens.INSTANCE.m3515getRangeSelectionHeaderContainerHeightD9Ej5fM() - HeaderHeightOffset), ComposableLambdaKt.rememberComposableLambda(-57534331, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11111) {
                            ComposerKt.sourceInformation(composer2, "C142@6428L467,153@6934L91,137@6121L1123:DateRangePicker.kt#uh7d8r");
                            if ((i11111 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-57534331, i11111, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:137)");
                                }
                                Long selectedStartDateMillis = dateRangePickerState.getSelectedStartDateMillis();
                                Long selectedEndDateMillis = dateRangePickerState.getSelectedEndDateMillis();
                                long displayedMonthMillis = dateRangePickerState.getDisplayedMonthMillis();
                                int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                ComposerKt.sourceInformationMarkerStart(composer2, 1752274220, "CC(remember):DateRangePicker.kt#9igjgp");
                                boolean zChanged2 = composer2.changed(dateRangePickerState);
                                final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                Object objRememberedValue3 = composer2.rememberedValue();
                                if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue3 = (Function2) new Function2<Long, Long, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Long) obj, (Long) obj2);
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Long l, Long l2) {
                                            try {
                                                dateRangePickerState2.setSelection(l, l2);
                                            } catch (IllegalArgumentException unused) {
                                            }
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue3);
                                }
                                Function2 function114 = (Function2) objRememberedValue3;
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerStart(composer2, 1752290036, "CC(remember):DateRangePicker.kt#9igjgp");
                                boolean zChanged3 = composer2.changed(dateRangePickerState);
                                final DateRangePickerState dateRangePickerState3 = dateRangePickerState;
                                Object objRememberedValue4 = composer2.rememberedValue();
                                if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue4 = (Function1) new Function1<Long, Unit>() {
                                        {
                                            super(1);
                                        }

                                        public Object invoke(Object obj) {
                                            invoke(((Number) obj).longValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(long j) {
                                            dateRangePickerState3.setDisplayedMonthMillis(j);
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue4);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                DateRangePickerKt.m2309SwitchableDateEntryContentRN2D1Q(selectedStartDateMillis, selectedEndDateMillis, displayedMonthMillis, iMo2320getDisplayModejFl4v0, function114, (Function1) objRememberedValue4, calendarModel13, dateRangePickerState.getYearRange(), datePickerFormatter2, dateRangePickerState.getSelectableDates(), datePickerColorsColors, composer2, 0, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, i1119 | (i11110 & 112) | (i11110 & 896) | (i11110 & 57344));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function2RememberComposableLambda = function113;
                    datePickerFormatter3 = datePickerFormatter2;
                    modifier3 = modifier2;
                    z4 = z3;
                    datePickerColors2 = datePickerColors15;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final DatePickerFormatter datePickerFormatter10 = datePickerFormatter3;
                    final Function2<? super Composer, ? super Integer, Unit> function114 = function2RememberComposableLambda;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11111) {
                            DateRangePickerKt.DateRangePicker(dateRangePickerState, modifier3, datePickerFormatter10, function114, function4, z4, datePickerColors2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            z2 = z;
            if ((1572864 & i) == 0) {
                if ((i2 & 64) == 0) {
                    datePickerColorsColors = datePickerColors;
                    if (composerStartRestartGroup.changed(datePickerColorsColors)) {
                    }
                    i3 |= i14;
                } else {
                    datePickerColorsColors = datePickerColors;
                }
                i3 |= i14;
            } else {
                datePickerColorsColors = datePickerColors;
            }
            if ((599187 & i3) == 599186) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i2 & 4) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -897;
                    } else {
                        datePickerFormatter2 = datePickerFormatter;
                    }
                    if (i4 != 0) {
                        function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11111) {
                                ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                if ((i11111 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-162164694, i11111, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                    }
                                    DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        i10 = 54;
                    } else {
                        i10 = 54;
                    }
                    if (i6 != 0) {
                        function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11111) {
                                ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                if ((i11111 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-185279404, i11111, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                    }
                                    DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, i10);
                    }
                    if (i8 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 64) != 0) {
                        i3 &= -3670017;
                        datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                } else {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i2 & 4) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -897;
                    } else {
                        datePickerFormatter2 = datePickerFormatter;
                    }
                    if (i4 != 0) {
                        function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11111) {
                                ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                if ((i11111 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-162164694, i11111, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                    }
                                    DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        i10 = 54;
                    } else {
                        i10 = 54;
                    }
                    if (i6 != 0) {
                        function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11111) {
                                ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                if ((i11111 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-185279404, i11111, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                    }
                                    DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, i10);
                    }
                    if (i8 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 64) != 0) {
                        i3 &= -3670017;
                        datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                }
                function4 = function2RememberComposableLambda2;
                z3 = z2;
                Function2<? super Composer, ? super Integer, Unit> function115 = function2RememberComposableLambda;
                i11 = i3;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(650830774, i11, -1, "androidx.compose.material3.DateRangePicker (DateRangePicker.kt:113)");
                }
                localeDefaultLocale = CalendarLocale_androidKt.defaultLocale(composerStartRestartGroup, 0);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454754600, "CC(remember):DateRangePicker.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(localeDefaultLocale);
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                final CalendarModel calendarModel14 = (CalendarModel) objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.startReplaceGroup(-1454747621);
                ComposerKt.sourceInformation(composerStartRestartGroup, "122@5491L323");
                if (z3) {
                    composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-1490010652, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11111) {
                            ComposerKt.sourceInformation(composer2, "C126@5723L50,123@5513L283:DateRangePicker.kt#uh7d8r");
                            if ((i11111 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1490010652, i11111, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:123)");
                                }
                                Modifier modifierPadding = PaddingKt.padding(Modifier.INSTANCE, DatePickerKt.getDatePickerModeTogglePadding());
                                int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                ComposerKt.sourceInformationMarkerStart(composer2, 1752251243, "CC(remember):DateRangePicker.kt#9igjgp");
                                boolean zChanged2 = composer2.changed(dateRangePickerState);
                                final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                Object objRememberedValue3 = composer2.rememberedValue();
                                if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue3 = (Function1) new Function1<DisplayMode, Unit>() {
                                        {
                                            super(1);
                                        }

                                        public Object invoke(Object obj) {
                                            m2313invokevCnGnXg(((DisplayMode) obj).getValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void m2313invokevCnGnXg(int i11112) {
                                            dateRangePickerState2.mo2321setDisplayModevCnGnXg(i11112);
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue3);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                DatePickerKt.m2278DisplayModeToggleButtontER2X8s(modifierPadding, iMo2320getDisplayModejFl4v0, (Function1) objRememberedValue3, composer2, 6);
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
                    composableLambdaRememberComposableLambda = null;
                }
                composerStartRestartGroup.endReplaceGroup();
                int i11111 = ((i11 >> 3) & 14) | 14155776;
                int i11112 = i11 >> 6;
                DatePickerColors datePickerColors16 = datePickerColorsColors;
                DatePickerKt.m2274DateEntryContainerau3_HiA(modifier2, function115, function4, composableLambdaRememberComposableLambda, datePickerColorsColors, TypographyKt.getValue(DatePickerModalTokens.INSTANCE.getRangeSelectionHeaderHeadlineFont(), composerStartRestartGroup, 6), Dp.constructor-impl(DatePickerModalTokens.INSTANCE.m3515getRangeSelectionHeaderContainerHeightD9Ej5fM() - HeaderHeightOffset), ComposableLambdaKt.rememberComposableLambda(-57534331, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11113) {
                        ComposerKt.sourceInformation(composer2, "C142@6428L467,153@6934L91,137@6121L1123:DateRangePicker.kt#uh7d8r");
                        if ((i11113 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-57534331, i11113, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:137)");
                            }
                            Long selectedStartDateMillis = dateRangePickerState.getSelectedStartDateMillis();
                            Long selectedEndDateMillis = dateRangePickerState.getSelectedEndDateMillis();
                            long displayedMonthMillis = dateRangePickerState.getDisplayedMonthMillis();
                            int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                            ComposerKt.sourceInformationMarkerStart(composer2, 1752274220, "CC(remember):DateRangePicker.kt#9igjgp");
                            boolean zChanged2 = composer2.changed(dateRangePickerState);
                            final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                            Object objRememberedValue3 = composer2.rememberedValue();
                            if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue3 = (Function2) new Function2<Long, Long, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Long) obj, (Long) obj2);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Long l, Long l2) {
                                        try {
                                            dateRangePickerState2.setSelection(l, l2);
                                        } catch (IllegalArgumentException unused) {
                                        }
                                    }
                                };
                                composer2.updateRememberedValue(objRememberedValue3);
                            }
                            Function2 function116 = (Function2) objRememberedValue3;
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerStart(composer2, 1752290036, "CC(remember):DateRangePicker.kt#9igjgp");
                            boolean zChanged3 = composer2.changed(dateRangePickerState);
                            final DateRangePickerState dateRangePickerState3 = dateRangePickerState;
                            Object objRememberedValue4 = composer2.rememberedValue();
                            if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue4 = (Function1) new Function1<Long, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke(((Number) obj).longValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(long j) {
                                        dateRangePickerState3.setDisplayedMonthMillis(j);
                                    }
                                };
                                composer2.updateRememberedValue(objRememberedValue4);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            DateRangePickerKt.m2309SwitchableDateEntryContentRN2D1Q(selectedStartDateMillis, selectedEndDateMillis, displayedMonthMillis, iMo2320getDisplayModejFl4v0, function116, (Function1) objRememberedValue4, calendarModel14, dateRangePickerState.getYearRange(), datePickerFormatter2, dateRangePickerState.getSelectableDates(), datePickerColorsColors, composer2, 0, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, i11111 | (i11112 & 112) | (i11112 & 896) | (i11112 & 57344));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function2RememberComposableLambda = function115;
                datePickerFormatter3 = datePickerFormatter2;
                modifier3 = modifier2;
                z4 = z3;
                datePickerColors2 = datePickerColors16;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i2 & 4) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -897;
                    } else {
                        datePickerFormatter2 = datePickerFormatter;
                    }
                    if (i4 != 0) {
                        function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11113) {
                                ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                if ((i11113 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-162164694, i11113, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                    }
                                    DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        i10 = 54;
                    } else {
                        i10 = 54;
                    }
                    if (i6 != 0) {
                        function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11113) {
                                ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                if ((i11113 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-185279404, i11113, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                    }
                                    DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, i10);
                    }
                    if (i8 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 64) != 0) {
                        i3 &= -3670017;
                        datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                } else {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i2 & 4) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -897;
                    } else {
                        datePickerFormatter2 = datePickerFormatter;
                    }
                    if (i4 != 0) {
                        function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11113) {
                                ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                if ((i11113 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-162164694, i11113, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                    }
                                    DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        i10 = 54;
                    } else {
                        i10 = 54;
                    }
                    if (i6 != 0) {
                        function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11113) {
                                ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                if ((i11113 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-185279404, i11113, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                    }
                                    DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, i10);
                    }
                    if (i8 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 64) != 0) {
                        i3 &= -3670017;
                        datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                }
                function4 = function2RememberComposableLambda2;
                z3 = z2;
                Function2<? super Composer, ? super Integer, Unit> function116 = function2RememberComposableLambda;
                i11 = i3;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(650830774, i11, -1, "androidx.compose.material3.DateRangePicker (DateRangePicker.kt:113)");
                }
                localeDefaultLocale = CalendarLocale_androidKt.defaultLocale(composerStartRestartGroup, 0);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454754600, "CC(remember):DateRangePicker.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(localeDefaultLocale);
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                final CalendarModel calendarModel15 = (CalendarModel) objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.startReplaceGroup(-1454747621);
                ComposerKt.sourceInformation(composerStartRestartGroup, "122@5491L323");
                if (z3) {
                    composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-1490010652, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11113) {
                            ComposerKt.sourceInformation(composer2, "C126@5723L50,123@5513L283:DateRangePicker.kt#uh7d8r");
                            if ((i11113 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1490010652, i11113, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:123)");
                                }
                                Modifier modifierPadding = PaddingKt.padding(Modifier.INSTANCE, DatePickerKt.getDatePickerModeTogglePadding());
                                int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                ComposerKt.sourceInformationMarkerStart(composer2, 1752251243, "CC(remember):DateRangePicker.kt#9igjgp");
                                boolean zChanged2 = composer2.changed(dateRangePickerState);
                                final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                Object objRememberedValue3 = composer2.rememberedValue();
                                if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue3 = (Function1) new Function1<DisplayMode, Unit>() {
                                        {
                                            super(1);
                                        }

                                        public Object invoke(Object obj) {
                                            m2313invokevCnGnXg(((DisplayMode) obj).getValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void m2313invokevCnGnXg(int i11114) {
                                            dateRangePickerState2.mo2321setDisplayModevCnGnXg(i11114);
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue3);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                DatePickerKt.m2278DisplayModeToggleButtontER2X8s(modifierPadding, iMo2320getDisplayModejFl4v0, (Function1) objRememberedValue3, composer2, 6);
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
                    composableLambdaRememberComposableLambda = null;
                }
                composerStartRestartGroup.endReplaceGroup();
                int i11113 = ((i11 >> 3) & 14) | 14155776;
                int i11114 = i11 >> 6;
                DatePickerColors datePickerColors17 = datePickerColorsColors;
                DatePickerKt.m2274DateEntryContainerau3_HiA(modifier2, function116, function4, composableLambdaRememberComposableLambda, datePickerColorsColors, TypographyKt.getValue(DatePickerModalTokens.INSTANCE.getRangeSelectionHeaderHeadlineFont(), composerStartRestartGroup, 6), Dp.constructor-impl(DatePickerModalTokens.INSTANCE.m3515getRangeSelectionHeaderContainerHeightD9Ej5fM() - HeaderHeightOffset), ComposableLambdaKt.rememberComposableLambda(-57534331, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11115) {
                        ComposerKt.sourceInformation(composer2, "C142@6428L467,153@6934L91,137@6121L1123:DateRangePicker.kt#uh7d8r");
                        if ((i11115 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-57534331, i11115, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:137)");
                            }
                            Long selectedStartDateMillis = dateRangePickerState.getSelectedStartDateMillis();
                            Long selectedEndDateMillis = dateRangePickerState.getSelectedEndDateMillis();
                            long displayedMonthMillis = dateRangePickerState.getDisplayedMonthMillis();
                            int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                            ComposerKt.sourceInformationMarkerStart(composer2, 1752274220, "CC(remember):DateRangePicker.kt#9igjgp");
                            boolean zChanged2 = composer2.changed(dateRangePickerState);
                            final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                            Object objRememberedValue3 = composer2.rememberedValue();
                            if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue3 = (Function2) new Function2<Long, Long, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Long) obj, (Long) obj2);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Long l, Long l2) {
                                        try {
                                            dateRangePickerState2.setSelection(l, l2);
                                        } catch (IllegalArgumentException unused) {
                                        }
                                    }
                                };
                                composer2.updateRememberedValue(objRememberedValue3);
                            }
                            Function2 function117 = (Function2) objRememberedValue3;
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerStart(composer2, 1752290036, "CC(remember):DateRangePicker.kt#9igjgp");
                            boolean zChanged3 = composer2.changed(dateRangePickerState);
                            final DateRangePickerState dateRangePickerState3 = dateRangePickerState;
                            Object objRememberedValue4 = composer2.rememberedValue();
                            if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue4 = (Function1) new Function1<Long, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke(((Number) obj).longValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(long j) {
                                        dateRangePickerState3.setDisplayedMonthMillis(j);
                                    }
                                };
                                composer2.updateRememberedValue(objRememberedValue4);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            DateRangePickerKt.m2309SwitchableDateEntryContentRN2D1Q(selectedStartDateMillis, selectedEndDateMillis, displayedMonthMillis, iMo2320getDisplayModejFl4v0, function117, (Function1) objRememberedValue4, calendarModel15, dateRangePickerState.getYearRange(), datePickerFormatter2, dateRangePickerState.getSelectableDates(), datePickerColorsColors, composer2, 0, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, i11113 | (i11114 & 112) | (i11114 & 896) | (i11114 & 57344));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function2RememberComposableLambda = function116;
                datePickerFormatter3 = datePickerFormatter2;
                modifier3 = modifier2;
                z4 = z3;
                datePickerColors2 = datePickerColors17;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final DatePickerFormatter datePickerFormatter11 = datePickerFormatter3;
                final Function2<? super Composer, ? super Integer, Unit> function117 = function2RememberComposableLambda;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11115) {
                        DateRangePickerKt.DateRangePicker(dateRangePickerState, modifier3, datePickerFormatter11, function117, function4, z4, datePickerColors2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        modifier2 = modifier;
        if ((i & 384) == 0) {
            if ((i2 & 4) != 0) {
                i12 = Fields.SpotShadowColor;
            } else {
                if ((i & Fields.RotationY) == 0) {
                    zChangedInstance = composerStartRestartGroup.changed(datePickerFormatter);
                } else {
                    zChangedInstance = composerStartRestartGroup.changedInstance(datePickerFormatter);
                }
                if (zChangedInstance) {
                    i12 = Fields.RotationX;
                } else {
                    i12 = Fields.SpotShadowColor;
                }
            }
            i3 |= i12;
        }
        i4 = i2 & 8;
        if (i4 != 0) {
            if ((i & 3072) == 0) {
                function2RememberComposableLambda = function2;
                if (composerStartRestartGroup.changedInstance(function2RememberComposableLambda)) {
                    i5 = Fields.CameraDistance;
                } else {
                    i5 = Fields.RotationZ;
                }
                i3 |= i5;
            }
            i6 = i2 & 16;
            if (i6 != 0) {
                if ((i & 24576) == 0) {
                    function2RememberComposableLambda2 = function3;
                    if (composerStartRestartGroup.changedInstance(function2RememberComposableLambda2)) {
                        i7 = Fields.Clip;
                    } else {
                        i7 = Fields.Shape;
                    }
                    i3 |= i7;
                }
                i8 = i2 & 32;
                if (i8 != 0) {
                    if ((196608 & i) == 0) {
                        z2 = z;
                        if (composerStartRestartGroup.changed(z2)) {
                            i9 = Fields.RenderEffect;
                        } else {
                            i9 = 65536;
                        }
                        i3 |= i9;
                    }
                    if ((1572864 & i) == 0) {
                        if ((i2 & 64) == 0) {
                            datePickerColorsColors = datePickerColors;
                            if (composerStartRestartGroup.changed(datePickerColorsColors)) {
                            }
                            i3 |= i14;
                        } else {
                            datePickerColorsColors = datePickerColors;
                        }
                        i3 |= i14;
                    } else {
                        datePickerColorsColors = datePickerColors;
                    }
                    if ((599187 & i3) == 599186) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if ((i2 & 4) != 0) {
                                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                                objRememberedValue = composerStartRestartGroup.rememberedValue();
                                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                                }
                                datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                                i3 &= -897;
                            } else {
                                datePickerFormatter2 = datePickerFormatter;
                            }
                            if (i4 != 0) {
                                function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i11115) {
                                        ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                        if ((i11115 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-162164694, i11115, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                            }
                                            DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                i10 = 54;
                            } else {
                                i10 = 54;
                            }
                            if (i6 != 0) {
                                function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i11115) {
                                        ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                        if ((i11115 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-185279404, i11115, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                            }
                                            DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, i10);
                            }
                            if (i8 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 64) != 0) {
                                i3 &= -3670017;
                                datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            }
                        } else {
                            if (i13 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if ((i2 & 4) != 0) {
                                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                                objRememberedValue = composerStartRestartGroup.rememberedValue();
                                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                                }
                                datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                                i3 &= -897;
                            } else {
                                datePickerFormatter2 = datePickerFormatter;
                            }
                            if (i4 != 0) {
                                function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i11115) {
                                        ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                        if ((i11115 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-162164694, i11115, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                            }
                                            DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                i10 = 54;
                            } else {
                                i10 = 54;
                            }
                            if (i6 != 0) {
                                function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i11115) {
                                        ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                        if ((i11115 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-185279404, i11115, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                            }
                                            DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, i10);
                            }
                            if (i8 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 64) != 0) {
                                i3 &= -3670017;
                                datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            }
                        }
                        function4 = function2RememberComposableLambda2;
                        z3 = z2;
                        Function2<? super Composer, ? super Integer, Unit> function118 = function2RememberComposableLambda;
                        i11 = i3;
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(650830774, i11, -1, "androidx.compose.material3.DateRangePicker (DateRangePicker.kt:113)");
                        }
                        localeDefaultLocale = CalendarLocale_androidKt.defaultLocale(composerStartRestartGroup, 0);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454754600, "CC(remember):DateRangePicker.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(localeDefaultLocale);
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        final CalendarModel calendarModel16 = (CalendarModel) objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.startReplaceGroup(-1454747621);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "122@5491L323");
                        if (z3) {
                            composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-1490010652, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i11115) {
                                    ComposerKt.sourceInformation(composer2, "C126@5723L50,123@5513L283:DateRangePicker.kt#uh7d8r");
                                    if ((i11115 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1490010652, i11115, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:123)");
                                        }
                                        Modifier modifierPadding = PaddingKt.padding(Modifier.INSTANCE, DatePickerKt.getDatePickerModeTogglePadding());
                                        int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                        ComposerKt.sourceInformationMarkerStart(composer2, 1752251243, "CC(remember):DateRangePicker.kt#9igjgp");
                                        boolean zChanged2 = composer2.changed(dateRangePickerState);
                                        final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                        Object objRememberedValue3 = composer2.rememberedValue();
                                        if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                            objRememberedValue3 = (Function1) new Function1<DisplayMode, Unit>() {
                                                {
                                                    super(1);
                                                }

                                                public Object invoke(Object obj) {
                                                    m2313invokevCnGnXg(((DisplayMode) obj).getValue());
                                                    return Unit.INSTANCE;
                                                }

                                                public final void m2313invokevCnGnXg(int i11116) {
                                                    dateRangePickerState2.mo2321setDisplayModevCnGnXg(i11116);
                                                }
                                            };
                                            composer2.updateRememberedValue(objRememberedValue3);
                                        }
                                        ComposerKt.sourceInformationMarkerEnd(composer2);
                                        DatePickerKt.m2278DisplayModeToggleButtontER2X8s(modifierPadding, iMo2320getDisplayModejFl4v0, (Function1) objRememberedValue3, composer2, 6);
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
                            composableLambdaRememberComposableLambda = null;
                        }
                        composerStartRestartGroup.endReplaceGroup();
                        int i11115 = ((i11 >> 3) & 14) | 14155776;
                        int i11116 = i11 >> 6;
                        DatePickerColors datePickerColors18 = datePickerColorsColors;
                        DatePickerKt.m2274DateEntryContainerau3_HiA(modifier2, function118, function4, composableLambdaRememberComposableLambda, datePickerColorsColors, TypographyKt.getValue(DatePickerModalTokens.INSTANCE.getRangeSelectionHeaderHeadlineFont(), composerStartRestartGroup, 6), Dp.constructor-impl(DatePickerModalTokens.INSTANCE.m3515getRangeSelectionHeaderContainerHeightD9Ej5fM() - HeaderHeightOffset), ComposableLambdaKt.rememberComposableLambda(-57534331, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11117) {
                                ComposerKt.sourceInformation(composer2, "C142@6428L467,153@6934L91,137@6121L1123:DateRangePicker.kt#uh7d8r");
                                if ((i11117 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-57534331, i11117, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:137)");
                                    }
                                    Long selectedStartDateMillis = dateRangePickerState.getSelectedStartDateMillis();
                                    Long selectedEndDateMillis = dateRangePickerState.getSelectedEndDateMillis();
                                    long displayedMonthMillis = dateRangePickerState.getDisplayedMonthMillis();
                                    int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1752274220, "CC(remember):DateRangePicker.kt#9igjgp");
                                    boolean zChanged2 = composer2.changed(dateRangePickerState);
                                    final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                    Object objRememberedValue3 = composer2.rememberedValue();
                                    if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                        objRememberedValue3 = (Function2) new Function2<Long, Long, Unit>() {
                                            {
                                                super(2);
                                            }

                                            public Object invoke(Object obj, Object obj2) {
                                                invoke((Long) obj, (Long) obj2);
                                                return Unit.INSTANCE;
                                            }

                                            public final void invoke(Long l, Long l2) {
                                                try {
                                                    dateRangePickerState2.setSelection(l, l2);
                                                } catch (IllegalArgumentException unused) {
                                                }
                                            }
                                        };
                                        composer2.updateRememberedValue(objRememberedValue3);
                                    }
                                    Function2 function119 = (Function2) objRememberedValue3;
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1752290036, "CC(remember):DateRangePicker.kt#9igjgp");
                                    boolean zChanged3 = composer2.changed(dateRangePickerState);
                                    final DateRangePickerState dateRangePickerState3 = dateRangePickerState;
                                    Object objRememberedValue4 = composer2.rememberedValue();
                                    if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                        objRememberedValue4 = (Function1) new Function1<Long, Unit>() {
                                            {
                                                super(1);
                                            }

                                            public Object invoke(Object obj) {
                                                invoke(((Number) obj).longValue());
                                                return Unit.INSTANCE;
                                            }

                                            public final void invoke(long j) {
                                                dateRangePickerState3.setDisplayedMonthMillis(j);
                                            }
                                        };
                                        composer2.updateRememberedValue(objRememberedValue4);
                                    }
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    DateRangePickerKt.m2309SwitchableDateEntryContentRN2D1Q(selectedStartDateMillis, selectedEndDateMillis, displayedMonthMillis, iMo2320getDisplayModejFl4v0, function119, (Function1) objRememberedValue4, calendarModel16, dateRangePickerState.getYearRange(), datePickerFormatter2, dateRangePickerState.getSelectableDates(), datePickerColorsColors, composer2, 0, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, i11115 | (i11116 & 112) | (i11116 & 896) | (i11116 & 57344));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        function2RememberComposableLambda = function118;
                        datePickerFormatter3 = datePickerFormatter2;
                        modifier3 = modifier2;
                        z4 = z3;
                        datePickerColors2 = datePickerColors18;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if ((i2 & 4) != 0) {
                                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                                objRememberedValue = composerStartRestartGroup.rememberedValue();
                                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                                }
                                datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                                i3 &= -897;
                            } else {
                                datePickerFormatter2 = datePickerFormatter;
                            }
                            if (i4 != 0) {
                                function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i11117) {
                                        ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                        if ((i11117 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-162164694, i11117, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                            }
                                            DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                i10 = 54;
                            } else {
                                i10 = 54;
                            }
                            if (i6 != 0) {
                                function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i11117) {
                                        ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                        if ((i11117 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-185279404, i11117, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                            }
                                            DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, i10);
                            }
                            if (i8 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 64) != 0) {
                                i3 &= -3670017;
                                datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            }
                        } else {
                            if (i13 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if ((i2 & 4) != 0) {
                                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                                objRememberedValue = composerStartRestartGroup.rememberedValue();
                                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                                }
                                datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                                i3 &= -897;
                            } else {
                                datePickerFormatter2 = datePickerFormatter;
                            }
                            if (i4 != 0) {
                                function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i11117) {
                                        ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                        if ((i11117 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-162164694, i11117, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                            }
                                            DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54);
                                i10 = 54;
                            } else {
                                i10 = 54;
                            }
                            if (i6 != 0) {
                                function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i11117) {
                                        ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                        if ((i11117 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-185279404, i11117, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                            }
                                            DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, i10);
                            }
                            if (i8 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 64) != 0) {
                                i3 &= -3670017;
                                datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            }
                        }
                        function4 = function2RememberComposableLambda2;
                        z3 = z2;
                        Function2<? super Composer, ? super Integer, Unit> function119 = function2RememberComposableLambda;
                        i11 = i3;
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(650830774, i11, -1, "androidx.compose.material3.DateRangePicker (DateRangePicker.kt:113)");
                        }
                        localeDefaultLocale = CalendarLocale_androidKt.defaultLocale(composerStartRestartGroup, 0);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454754600, "CC(remember):DateRangePicker.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(localeDefaultLocale);
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        final CalendarModel calendarModel17 = (CalendarModel) objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composerStartRestartGroup.startReplaceGroup(-1454747621);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "122@5491L323");
                        if (z3) {
                            composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-1490010652, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i11117) {
                                    ComposerKt.sourceInformation(composer2, "C126@5723L50,123@5513L283:DateRangePicker.kt#uh7d8r");
                                    if ((i11117 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1490010652, i11117, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:123)");
                                        }
                                        Modifier modifierPadding = PaddingKt.padding(Modifier.INSTANCE, DatePickerKt.getDatePickerModeTogglePadding());
                                        int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                        ComposerKt.sourceInformationMarkerStart(composer2, 1752251243, "CC(remember):DateRangePicker.kt#9igjgp");
                                        boolean zChanged2 = composer2.changed(dateRangePickerState);
                                        final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                        Object objRememberedValue3 = composer2.rememberedValue();
                                        if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                            objRememberedValue3 = (Function1) new Function1<DisplayMode, Unit>() {
                                                {
                                                    super(1);
                                                }

                                                public Object invoke(Object obj) {
                                                    m2313invokevCnGnXg(((DisplayMode) obj).getValue());
                                                    return Unit.INSTANCE;
                                                }

                                                public final void m2313invokevCnGnXg(int i11118) {
                                                    dateRangePickerState2.mo2321setDisplayModevCnGnXg(i11118);
                                                }
                                            };
                                            composer2.updateRememberedValue(objRememberedValue3);
                                        }
                                        ComposerKt.sourceInformationMarkerEnd(composer2);
                                        DatePickerKt.m2278DisplayModeToggleButtontER2X8s(modifierPadding, iMo2320getDisplayModejFl4v0, (Function1) objRememberedValue3, composer2, 6);
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
                            composableLambdaRememberComposableLambda = null;
                        }
                        composerStartRestartGroup.endReplaceGroup();
                        int i11117 = ((i11 >> 3) & 14) | 14155776;
                        int i11118 = i11 >> 6;
                        DatePickerColors datePickerColors19 = datePickerColorsColors;
                        DatePickerKt.m2274DateEntryContainerau3_HiA(modifier2, function119, function4, composableLambdaRememberComposableLambda, datePickerColorsColors, TypographyKt.getValue(DatePickerModalTokens.INSTANCE.getRangeSelectionHeaderHeadlineFont(), composerStartRestartGroup, 6), Dp.constructor-impl(DatePickerModalTokens.INSTANCE.m3515getRangeSelectionHeaderContainerHeightD9Ej5fM() - HeaderHeightOffset), ComposableLambdaKt.rememberComposableLambda(-57534331, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11119) {
                                ComposerKt.sourceInformation(composer2, "C142@6428L467,153@6934L91,137@6121L1123:DateRangePicker.kt#uh7d8r");
                                if ((i11119 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-57534331, i11119, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:137)");
                                    }
                                    Long selectedStartDateMillis = dateRangePickerState.getSelectedStartDateMillis();
                                    Long selectedEndDateMillis = dateRangePickerState.getSelectedEndDateMillis();
                                    long displayedMonthMillis = dateRangePickerState.getDisplayedMonthMillis();
                                    int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1752274220, "CC(remember):DateRangePicker.kt#9igjgp");
                                    boolean zChanged2 = composer2.changed(dateRangePickerState);
                                    final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                    Object objRememberedValue3 = composer2.rememberedValue();
                                    if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                        objRememberedValue3 = (Function2) new Function2<Long, Long, Unit>() {
                                            {
                                                super(2);
                                            }

                                            public Object invoke(Object obj, Object obj2) {
                                                invoke((Long) obj, (Long) obj2);
                                                return Unit.INSTANCE;
                                            }

                                            public final void invoke(Long l, Long l2) {
                                                try {
                                                    dateRangePickerState2.setSelection(l, l2);
                                                } catch (IllegalArgumentException unused) {
                                                }
                                            }
                                        };
                                        composer2.updateRememberedValue(objRememberedValue3);
                                    }
                                    Function2 function1110 = (Function2) objRememberedValue3;
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1752290036, "CC(remember):DateRangePicker.kt#9igjgp");
                                    boolean zChanged3 = composer2.changed(dateRangePickerState);
                                    final DateRangePickerState dateRangePickerState3 = dateRangePickerState;
                                    Object objRememberedValue4 = composer2.rememberedValue();
                                    if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                        objRememberedValue4 = (Function1) new Function1<Long, Unit>() {
                                            {
                                                super(1);
                                            }

                                            public Object invoke(Object obj) {
                                                invoke(((Number) obj).longValue());
                                                return Unit.INSTANCE;
                                            }

                                            public final void invoke(long j) {
                                                dateRangePickerState3.setDisplayedMonthMillis(j);
                                            }
                                        };
                                        composer2.updateRememberedValue(objRememberedValue4);
                                    }
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    DateRangePickerKt.m2309SwitchableDateEntryContentRN2D1Q(selectedStartDateMillis, selectedEndDateMillis, displayedMonthMillis, iMo2320getDisplayModejFl4v0, function1110, (Function1) objRememberedValue4, calendarModel17, dateRangePickerState.getYearRange(), datePickerFormatter2, dateRangePickerState.getSelectableDates(), datePickerColorsColors, composer2, 0, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, i11117 | (i11118 & 112) | (i11118 & 896) | (i11118 & 57344));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        function2RememberComposableLambda = function119;
                        datePickerFormatter3 = datePickerFormatter2;
                        modifier3 = modifier2;
                        z4 = z3;
                        datePickerColors2 = datePickerColors19;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final DatePickerFormatter datePickerFormatter12 = datePickerFormatter3;
                        final Function2<? super Composer, ? super Integer, Unit> function1110 = function2RememberComposableLambda;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11119) {
                                DateRangePickerKt.DateRangePicker(dateRangePickerState, modifier3, datePickerFormatter12, function1110, function4, z4, datePickerColors2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 196608;
                z2 = z;
                if ((1572864 & i) == 0) {
                    if ((i2 & 64) == 0) {
                        datePickerColorsColors = datePickerColors;
                        if (composerStartRestartGroup.changed(datePickerColorsColors)) {
                        }
                        i3 |= i14;
                    } else {
                        datePickerColorsColors = datePickerColors;
                    }
                    i3 |= i14;
                } else {
                    datePickerColorsColors = datePickerColors;
                }
                if ((599187 & i3) == 599186) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i2 & 4) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -897;
                        } else {
                            datePickerFormatter2 = datePickerFormatter;
                        }
                        if (i4 != 0) {
                            function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i11119) {
                                    ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                    if ((i11119 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-162164694, i11119, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            i10 = 54;
                        } else {
                            i10 = 54;
                        }
                        if (i6 != 0) {
                            function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i11119) {
                                    ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                    if ((i11119 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-185279404, i11119, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, i10);
                        }
                        if (i8 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                    } else {
                        if (i13 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i2 & 4) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -897;
                        } else {
                            datePickerFormatter2 = datePickerFormatter;
                        }
                        if (i4 != 0) {
                            function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i11119) {
                                    ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                    if ((i11119 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-162164694, i11119, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            i10 = 54;
                        } else {
                            i10 = 54;
                        }
                        if (i6 != 0) {
                            function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i11119) {
                                    ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                    if ((i11119 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-185279404, i11119, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, i10);
                        }
                        if (i8 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                    }
                    function4 = function2RememberComposableLambda2;
                    z3 = z2;
                    Function2<? super Composer, ? super Integer, Unit> function1111 = function2RememberComposableLambda;
                    i11 = i3;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(650830774, i11, -1, "androidx.compose.material3.DateRangePicker (DateRangePicker.kt:113)");
                    }
                    localeDefaultLocale = CalendarLocale_androidKt.defaultLocale(composerStartRestartGroup, 0);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454754600, "CC(remember):DateRangePicker.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(localeDefaultLocale);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    final CalendarModel calendarModel18 = (CalendarModel) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.startReplaceGroup(-1454747621);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "122@5491L323");
                    if (z3) {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-1490010652, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11119) {
                                ComposerKt.sourceInformation(composer2, "C126@5723L50,123@5513L283:DateRangePicker.kt#uh7d8r");
                                if ((i11119 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1490010652, i11119, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:123)");
                                    }
                                    Modifier modifierPadding = PaddingKt.padding(Modifier.INSTANCE, DatePickerKt.getDatePickerModeTogglePadding());
                                    int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1752251243, "CC(remember):DateRangePicker.kt#9igjgp");
                                    boolean zChanged2 = composer2.changed(dateRangePickerState);
                                    final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                    Object objRememberedValue3 = composer2.rememberedValue();
                                    if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                        objRememberedValue3 = (Function1) new Function1<DisplayMode, Unit>() {
                                            {
                                                super(1);
                                            }

                                            public Object invoke(Object obj) {
                                                m2313invokevCnGnXg(((DisplayMode) obj).getValue());
                                                return Unit.INSTANCE;
                                            }

                                            public final void m2313invokevCnGnXg(int i111110) {
                                                dateRangePickerState2.mo2321setDisplayModevCnGnXg(i111110);
                                            }
                                        };
                                        composer2.updateRememberedValue(objRememberedValue3);
                                    }
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    DatePickerKt.m2278DisplayModeToggleButtontER2X8s(modifierPadding, iMo2320getDisplayModejFl4v0, (Function1) objRememberedValue3, composer2, 6);
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
                        composableLambdaRememberComposableLambda = null;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    int i11119 = ((i11 >> 3) & 14) | 14155776;
                    int i111110 = i11 >> 6;
                    DatePickerColors datePickerColors110 = datePickerColorsColors;
                    DatePickerKt.m2274DateEntryContainerau3_HiA(modifier2, function1111, function4, composableLambdaRememberComposableLambda, datePickerColorsColors, TypographyKt.getValue(DatePickerModalTokens.INSTANCE.getRangeSelectionHeaderHeadlineFont(), composerStartRestartGroup, 6), Dp.constructor-impl(DatePickerModalTokens.INSTANCE.m3515getRangeSelectionHeaderContainerHeightD9Ej5fM() - HeaderHeightOffset), ComposableLambdaKt.rememberComposableLambda(-57534331, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i111111) {
                            ComposerKt.sourceInformation(composer2, "C142@6428L467,153@6934L91,137@6121L1123:DateRangePicker.kt#uh7d8r");
                            if ((i111111 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-57534331, i111111, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:137)");
                                }
                                Long selectedStartDateMillis = dateRangePickerState.getSelectedStartDateMillis();
                                Long selectedEndDateMillis = dateRangePickerState.getSelectedEndDateMillis();
                                long displayedMonthMillis = dateRangePickerState.getDisplayedMonthMillis();
                                int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                ComposerKt.sourceInformationMarkerStart(composer2, 1752274220, "CC(remember):DateRangePicker.kt#9igjgp");
                                boolean zChanged2 = composer2.changed(dateRangePickerState);
                                final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                Object objRememberedValue3 = composer2.rememberedValue();
                                if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue3 = (Function2) new Function2<Long, Long, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Long) obj, (Long) obj2);
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Long l, Long l2) {
                                            try {
                                                dateRangePickerState2.setSelection(l, l2);
                                            } catch (IllegalArgumentException unused) {
                                            }
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue3);
                                }
                                Function2 function1112 = (Function2) objRememberedValue3;
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerStart(composer2, 1752290036, "CC(remember):DateRangePicker.kt#9igjgp");
                                boolean zChanged3 = composer2.changed(dateRangePickerState);
                                final DateRangePickerState dateRangePickerState3 = dateRangePickerState;
                                Object objRememberedValue4 = composer2.rememberedValue();
                                if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue4 = (Function1) new Function1<Long, Unit>() {
                                        {
                                            super(1);
                                        }

                                        public Object invoke(Object obj) {
                                            invoke(((Number) obj).longValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(long j) {
                                            dateRangePickerState3.setDisplayedMonthMillis(j);
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue4);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                DateRangePickerKt.m2309SwitchableDateEntryContentRN2D1Q(selectedStartDateMillis, selectedEndDateMillis, displayedMonthMillis, iMo2320getDisplayModejFl4v0, function1112, (Function1) objRememberedValue4, calendarModel18, dateRangePickerState.getYearRange(), datePickerFormatter2, dateRangePickerState.getSelectableDates(), datePickerColorsColors, composer2, 0, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, i11119 | (i111110 & 112) | (i111110 & 896) | (i111110 & 57344));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function2RememberComposableLambda = function1111;
                    datePickerFormatter3 = datePickerFormatter2;
                    modifier3 = modifier2;
                    z4 = z3;
                    datePickerColors2 = datePickerColors110;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i2 & 4) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -897;
                        } else {
                            datePickerFormatter2 = datePickerFormatter;
                        }
                        if (i4 != 0) {
                            function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i111111) {
                                    ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                    if ((i111111 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-162164694, i111111, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            i10 = 54;
                        } else {
                            i10 = 54;
                        }
                        if (i6 != 0) {
                            function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i111111) {
                                    ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                    if ((i111111 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-185279404, i111111, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, i10);
                        }
                        if (i8 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                    } else {
                        if (i13 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i2 & 4) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -897;
                        } else {
                            datePickerFormatter2 = datePickerFormatter;
                        }
                        if (i4 != 0) {
                            function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i111111) {
                                    ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                    if ((i111111 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-162164694, i111111, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            i10 = 54;
                        } else {
                            i10 = 54;
                        }
                        if (i6 != 0) {
                            function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i111111) {
                                    ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                    if ((i111111 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-185279404, i111111, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, i10);
                        }
                        if (i8 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                    }
                    function4 = function2RememberComposableLambda2;
                    z3 = z2;
                    Function2<? super Composer, ? super Integer, Unit> function1112 = function2RememberComposableLambda;
                    i11 = i3;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(650830774, i11, -1, "androidx.compose.material3.DateRangePicker (DateRangePicker.kt:113)");
                    }
                    localeDefaultLocale = CalendarLocale_androidKt.defaultLocale(composerStartRestartGroup, 0);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454754600, "CC(remember):DateRangePicker.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(localeDefaultLocale);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    final CalendarModel calendarModel19 = (CalendarModel) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.startReplaceGroup(-1454747621);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "122@5491L323");
                    if (z3) {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-1490010652, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i111111) {
                                ComposerKt.sourceInformation(composer2, "C126@5723L50,123@5513L283:DateRangePicker.kt#uh7d8r");
                                if ((i111111 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1490010652, i111111, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:123)");
                                    }
                                    Modifier modifierPadding = PaddingKt.padding(Modifier.INSTANCE, DatePickerKt.getDatePickerModeTogglePadding());
                                    int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1752251243, "CC(remember):DateRangePicker.kt#9igjgp");
                                    boolean zChanged2 = composer2.changed(dateRangePickerState);
                                    final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                    Object objRememberedValue3 = composer2.rememberedValue();
                                    if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                        objRememberedValue3 = (Function1) new Function1<DisplayMode, Unit>() {
                                            {
                                                super(1);
                                            }

                                            public Object invoke(Object obj) {
                                                m2313invokevCnGnXg(((DisplayMode) obj).getValue());
                                                return Unit.INSTANCE;
                                            }

                                            public final void m2313invokevCnGnXg(int i111112) {
                                                dateRangePickerState2.mo2321setDisplayModevCnGnXg(i111112);
                                            }
                                        };
                                        composer2.updateRememberedValue(objRememberedValue3);
                                    }
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    DatePickerKt.m2278DisplayModeToggleButtontER2X8s(modifierPadding, iMo2320getDisplayModejFl4v0, (Function1) objRememberedValue3, composer2, 6);
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
                        composableLambdaRememberComposableLambda = null;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    int i111111 = ((i11 >> 3) & 14) | 14155776;
                    int i111112 = i11 >> 6;
                    DatePickerColors datePickerColors111 = datePickerColorsColors;
                    DatePickerKt.m2274DateEntryContainerau3_HiA(modifier2, function1112, function4, composableLambdaRememberComposableLambda, datePickerColorsColors, TypographyKt.getValue(DatePickerModalTokens.INSTANCE.getRangeSelectionHeaderHeadlineFont(), composerStartRestartGroup, 6), Dp.constructor-impl(DatePickerModalTokens.INSTANCE.m3515getRangeSelectionHeaderContainerHeightD9Ej5fM() - HeaderHeightOffset), ComposableLambdaKt.rememberComposableLambda(-57534331, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i111113) {
                            ComposerKt.sourceInformation(composer2, "C142@6428L467,153@6934L91,137@6121L1123:DateRangePicker.kt#uh7d8r");
                            if ((i111113 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-57534331, i111113, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:137)");
                                }
                                Long selectedStartDateMillis = dateRangePickerState.getSelectedStartDateMillis();
                                Long selectedEndDateMillis = dateRangePickerState.getSelectedEndDateMillis();
                                long displayedMonthMillis = dateRangePickerState.getDisplayedMonthMillis();
                                int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                ComposerKt.sourceInformationMarkerStart(composer2, 1752274220, "CC(remember):DateRangePicker.kt#9igjgp");
                                boolean zChanged2 = composer2.changed(dateRangePickerState);
                                final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                Object objRememberedValue3 = composer2.rememberedValue();
                                if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue3 = (Function2) new Function2<Long, Long, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Long) obj, (Long) obj2);
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Long l, Long l2) {
                                            try {
                                                dateRangePickerState2.setSelection(l, l2);
                                            } catch (IllegalArgumentException unused) {
                                            }
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue3);
                                }
                                Function2 function1113 = (Function2) objRememberedValue3;
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerStart(composer2, 1752290036, "CC(remember):DateRangePicker.kt#9igjgp");
                                boolean zChanged3 = composer2.changed(dateRangePickerState);
                                final DateRangePickerState dateRangePickerState3 = dateRangePickerState;
                                Object objRememberedValue4 = composer2.rememberedValue();
                                if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue4 = (Function1) new Function1<Long, Unit>() {
                                        {
                                            super(1);
                                        }

                                        public Object invoke(Object obj) {
                                            invoke(((Number) obj).longValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(long j) {
                                            dateRangePickerState3.setDisplayedMonthMillis(j);
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue4);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                DateRangePickerKt.m2309SwitchableDateEntryContentRN2D1Q(selectedStartDateMillis, selectedEndDateMillis, displayedMonthMillis, iMo2320getDisplayModejFl4v0, function1113, (Function1) objRememberedValue4, calendarModel19, dateRangePickerState.getYearRange(), datePickerFormatter2, dateRangePickerState.getSelectableDates(), datePickerColorsColors, composer2, 0, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, i111111 | (i111112 & 112) | (i111112 & 896) | (i111112 & 57344));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function2RememberComposableLambda = function1112;
                    datePickerFormatter3 = datePickerFormatter2;
                    modifier3 = modifier2;
                    z4 = z3;
                    datePickerColors2 = datePickerColors111;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final DatePickerFormatter datePickerFormatter13 = datePickerFormatter3;
                    final Function2<? super Composer, ? super Integer, Unit> function1113 = function2RememberComposableLambda;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i111113) {
                            DateRangePickerKt.DateRangePicker(dateRangePickerState, modifier3, datePickerFormatter13, function1113, function4, z4, datePickerColors2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            function2RememberComposableLambda2 = function3;
            i8 = i2 & 32;
            if (i8 != 0) {
                if ((196608 & i) == 0) {
                    z2 = z;
                    if (composerStartRestartGroup.changed(z2)) {
                        i9 = Fields.RenderEffect;
                    } else {
                        i9 = 65536;
                    }
                    i3 |= i9;
                }
                if ((1572864 & i) == 0) {
                    if ((i2 & 64) == 0) {
                        datePickerColorsColors = datePickerColors;
                        if (composerStartRestartGroup.changed(datePickerColorsColors)) {
                        }
                        i3 |= i14;
                    } else {
                        datePickerColorsColors = datePickerColors;
                    }
                    i3 |= i14;
                } else {
                    datePickerColorsColors = datePickerColors;
                }
                if ((599187 & i3) == 599186) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i2 & 4) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -897;
                        } else {
                            datePickerFormatter2 = datePickerFormatter;
                        }
                        if (i4 != 0) {
                            function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i111113) {
                                    ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                    if ((i111113 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-162164694, i111113, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            i10 = 54;
                        } else {
                            i10 = 54;
                        }
                        if (i6 != 0) {
                            function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i111113) {
                                    ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                    if ((i111113 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-185279404, i111113, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, i10);
                        }
                        if (i8 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                    } else {
                        if (i13 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i2 & 4) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -897;
                        } else {
                            datePickerFormatter2 = datePickerFormatter;
                        }
                        if (i4 != 0) {
                            function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i111113) {
                                    ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                    if ((i111113 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-162164694, i111113, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            i10 = 54;
                        } else {
                            i10 = 54;
                        }
                        if (i6 != 0) {
                            function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i111113) {
                                    ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                    if ((i111113 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-185279404, i111113, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, i10);
                        }
                        if (i8 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                    }
                    function4 = function2RememberComposableLambda2;
                    z3 = z2;
                    Function2<? super Composer, ? super Integer, Unit> function1114 = function2RememberComposableLambda;
                    i11 = i3;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(650830774, i11, -1, "androidx.compose.material3.DateRangePicker (DateRangePicker.kt:113)");
                    }
                    localeDefaultLocale = CalendarLocale_androidKt.defaultLocale(composerStartRestartGroup, 0);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454754600, "CC(remember):DateRangePicker.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(localeDefaultLocale);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    final CalendarModel calendarModel110 = (CalendarModel) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.startReplaceGroup(-1454747621);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "122@5491L323");
                    if (z3) {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-1490010652, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i111113) {
                                ComposerKt.sourceInformation(composer2, "C126@5723L50,123@5513L283:DateRangePicker.kt#uh7d8r");
                                if ((i111113 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1490010652, i111113, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:123)");
                                    }
                                    Modifier modifierPadding = PaddingKt.padding(Modifier.INSTANCE, DatePickerKt.getDatePickerModeTogglePadding());
                                    int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1752251243, "CC(remember):DateRangePicker.kt#9igjgp");
                                    boolean zChanged2 = composer2.changed(dateRangePickerState);
                                    final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                    Object objRememberedValue3 = composer2.rememberedValue();
                                    if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                        objRememberedValue3 = (Function1) new Function1<DisplayMode, Unit>() {
                                            {
                                                super(1);
                                            }

                                            public Object invoke(Object obj) {
                                                m2313invokevCnGnXg(((DisplayMode) obj).getValue());
                                                return Unit.INSTANCE;
                                            }

                                            public final void m2313invokevCnGnXg(int i111114) {
                                                dateRangePickerState2.mo2321setDisplayModevCnGnXg(i111114);
                                            }
                                        };
                                        composer2.updateRememberedValue(objRememberedValue3);
                                    }
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    DatePickerKt.m2278DisplayModeToggleButtontER2X8s(modifierPadding, iMo2320getDisplayModejFl4v0, (Function1) objRememberedValue3, composer2, 6);
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
                        composableLambdaRememberComposableLambda = null;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    int i111113 = ((i11 >> 3) & 14) | 14155776;
                    int i111114 = i11 >> 6;
                    DatePickerColors datePickerColors112 = datePickerColorsColors;
                    DatePickerKt.m2274DateEntryContainerau3_HiA(modifier2, function1114, function4, composableLambdaRememberComposableLambda, datePickerColorsColors, TypographyKt.getValue(DatePickerModalTokens.INSTANCE.getRangeSelectionHeaderHeadlineFont(), composerStartRestartGroup, 6), Dp.constructor-impl(DatePickerModalTokens.INSTANCE.m3515getRangeSelectionHeaderContainerHeightD9Ej5fM() - HeaderHeightOffset), ComposableLambdaKt.rememberComposableLambda(-57534331, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i111115) {
                            ComposerKt.sourceInformation(composer2, "C142@6428L467,153@6934L91,137@6121L1123:DateRangePicker.kt#uh7d8r");
                            if ((i111115 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-57534331, i111115, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:137)");
                                }
                                Long selectedStartDateMillis = dateRangePickerState.getSelectedStartDateMillis();
                                Long selectedEndDateMillis = dateRangePickerState.getSelectedEndDateMillis();
                                long displayedMonthMillis = dateRangePickerState.getDisplayedMonthMillis();
                                int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                ComposerKt.sourceInformationMarkerStart(composer2, 1752274220, "CC(remember):DateRangePicker.kt#9igjgp");
                                boolean zChanged2 = composer2.changed(dateRangePickerState);
                                final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                Object objRememberedValue3 = composer2.rememberedValue();
                                if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue3 = (Function2) new Function2<Long, Long, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Long) obj, (Long) obj2);
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Long l, Long l2) {
                                            try {
                                                dateRangePickerState2.setSelection(l, l2);
                                            } catch (IllegalArgumentException unused) {
                                            }
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue3);
                                }
                                Function2 function1115 = (Function2) objRememberedValue3;
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerStart(composer2, 1752290036, "CC(remember):DateRangePicker.kt#9igjgp");
                                boolean zChanged3 = composer2.changed(dateRangePickerState);
                                final DateRangePickerState dateRangePickerState3 = dateRangePickerState;
                                Object objRememberedValue4 = composer2.rememberedValue();
                                if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue4 = (Function1) new Function1<Long, Unit>() {
                                        {
                                            super(1);
                                        }

                                        public Object invoke(Object obj) {
                                            invoke(((Number) obj).longValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(long j) {
                                            dateRangePickerState3.setDisplayedMonthMillis(j);
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue4);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                DateRangePickerKt.m2309SwitchableDateEntryContentRN2D1Q(selectedStartDateMillis, selectedEndDateMillis, displayedMonthMillis, iMo2320getDisplayModejFl4v0, function1115, (Function1) objRememberedValue4, calendarModel110, dateRangePickerState.getYearRange(), datePickerFormatter2, dateRangePickerState.getSelectableDates(), datePickerColorsColors, composer2, 0, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, i111113 | (i111114 & 112) | (i111114 & 896) | (i111114 & 57344));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function2RememberComposableLambda = function1114;
                    datePickerFormatter3 = datePickerFormatter2;
                    modifier3 = modifier2;
                    z4 = z3;
                    datePickerColors2 = datePickerColors112;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i2 & 4) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -897;
                        } else {
                            datePickerFormatter2 = datePickerFormatter;
                        }
                        if (i4 != 0) {
                            function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i111115) {
                                    ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                    if ((i111115 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-162164694, i111115, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            i10 = 54;
                        } else {
                            i10 = 54;
                        }
                        if (i6 != 0) {
                            function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i111115) {
                                    ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                    if ((i111115 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-185279404, i111115, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, i10);
                        }
                        if (i8 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                    } else {
                        if (i13 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i2 & 4) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -897;
                        } else {
                            datePickerFormatter2 = datePickerFormatter;
                        }
                        if (i4 != 0) {
                            function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i111115) {
                                    ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                    if ((i111115 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-162164694, i111115, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            i10 = 54;
                        } else {
                            i10 = 54;
                        }
                        if (i6 != 0) {
                            function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i111115) {
                                    ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                    if ((i111115 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-185279404, i111115, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, i10);
                        }
                        if (i8 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                    }
                    function4 = function2RememberComposableLambda2;
                    z3 = z2;
                    Function2<? super Composer, ? super Integer, Unit> function1115 = function2RememberComposableLambda;
                    i11 = i3;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(650830774, i11, -1, "androidx.compose.material3.DateRangePicker (DateRangePicker.kt:113)");
                    }
                    localeDefaultLocale = CalendarLocale_androidKt.defaultLocale(composerStartRestartGroup, 0);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454754600, "CC(remember):DateRangePicker.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(localeDefaultLocale);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    final CalendarModel calendarModel111 = (CalendarModel) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.startReplaceGroup(-1454747621);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "122@5491L323");
                    if (z3) {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-1490010652, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i111115) {
                                ComposerKt.sourceInformation(composer2, "C126@5723L50,123@5513L283:DateRangePicker.kt#uh7d8r");
                                if ((i111115 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1490010652, i111115, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:123)");
                                    }
                                    Modifier modifierPadding = PaddingKt.padding(Modifier.INSTANCE, DatePickerKt.getDatePickerModeTogglePadding());
                                    int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1752251243, "CC(remember):DateRangePicker.kt#9igjgp");
                                    boolean zChanged2 = composer2.changed(dateRangePickerState);
                                    final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                    Object objRememberedValue3 = composer2.rememberedValue();
                                    if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                        objRememberedValue3 = (Function1) new Function1<DisplayMode, Unit>() {
                                            {
                                                super(1);
                                            }

                                            public Object invoke(Object obj) {
                                                m2313invokevCnGnXg(((DisplayMode) obj).getValue());
                                                return Unit.INSTANCE;
                                            }

                                            public final void m2313invokevCnGnXg(int i111116) {
                                                dateRangePickerState2.mo2321setDisplayModevCnGnXg(i111116);
                                            }
                                        };
                                        composer2.updateRememberedValue(objRememberedValue3);
                                    }
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    DatePickerKt.m2278DisplayModeToggleButtontER2X8s(modifierPadding, iMo2320getDisplayModejFl4v0, (Function1) objRememberedValue3, composer2, 6);
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
                        composableLambdaRememberComposableLambda = null;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    int i111115 = ((i11 >> 3) & 14) | 14155776;
                    int i111116 = i11 >> 6;
                    DatePickerColors datePickerColors113 = datePickerColorsColors;
                    DatePickerKt.m2274DateEntryContainerau3_HiA(modifier2, function1115, function4, composableLambdaRememberComposableLambda, datePickerColorsColors, TypographyKt.getValue(DatePickerModalTokens.INSTANCE.getRangeSelectionHeaderHeadlineFont(), composerStartRestartGroup, 6), Dp.constructor-impl(DatePickerModalTokens.INSTANCE.m3515getRangeSelectionHeaderContainerHeightD9Ej5fM() - HeaderHeightOffset), ComposableLambdaKt.rememberComposableLambda(-57534331, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i111117) {
                            ComposerKt.sourceInformation(composer2, "C142@6428L467,153@6934L91,137@6121L1123:DateRangePicker.kt#uh7d8r");
                            if ((i111117 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-57534331, i111117, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:137)");
                                }
                                Long selectedStartDateMillis = dateRangePickerState.getSelectedStartDateMillis();
                                Long selectedEndDateMillis = dateRangePickerState.getSelectedEndDateMillis();
                                long displayedMonthMillis = dateRangePickerState.getDisplayedMonthMillis();
                                int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                ComposerKt.sourceInformationMarkerStart(composer2, 1752274220, "CC(remember):DateRangePicker.kt#9igjgp");
                                boolean zChanged2 = composer2.changed(dateRangePickerState);
                                final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                Object objRememberedValue3 = composer2.rememberedValue();
                                if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue3 = (Function2) new Function2<Long, Long, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Long) obj, (Long) obj2);
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Long l, Long l2) {
                                            try {
                                                dateRangePickerState2.setSelection(l, l2);
                                            } catch (IllegalArgumentException unused) {
                                            }
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue3);
                                }
                                Function2 function1116 = (Function2) objRememberedValue3;
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerStart(composer2, 1752290036, "CC(remember):DateRangePicker.kt#9igjgp");
                                boolean zChanged3 = composer2.changed(dateRangePickerState);
                                final DateRangePickerState dateRangePickerState3 = dateRangePickerState;
                                Object objRememberedValue4 = composer2.rememberedValue();
                                if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue4 = (Function1) new Function1<Long, Unit>() {
                                        {
                                            super(1);
                                        }

                                        public Object invoke(Object obj) {
                                            invoke(((Number) obj).longValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(long j) {
                                            dateRangePickerState3.setDisplayedMonthMillis(j);
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue4);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                DateRangePickerKt.m2309SwitchableDateEntryContentRN2D1Q(selectedStartDateMillis, selectedEndDateMillis, displayedMonthMillis, iMo2320getDisplayModejFl4v0, function1116, (Function1) objRememberedValue4, calendarModel111, dateRangePickerState.getYearRange(), datePickerFormatter2, dateRangePickerState.getSelectableDates(), datePickerColorsColors, composer2, 0, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, i111115 | (i111116 & 112) | (i111116 & 896) | (i111116 & 57344));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function2RememberComposableLambda = function1115;
                    datePickerFormatter3 = datePickerFormatter2;
                    modifier3 = modifier2;
                    z4 = z3;
                    datePickerColors2 = datePickerColors113;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final DatePickerFormatter datePickerFormatter14 = datePickerFormatter3;
                    final Function2<? super Composer, ? super Integer, Unit> function1116 = function2RememberComposableLambda;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i111117) {
                            DateRangePickerKt.DateRangePicker(dateRangePickerState, modifier3, datePickerFormatter14, function1116, function4, z4, datePickerColors2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            z2 = z;
            if ((1572864 & i) == 0) {
                if ((i2 & 64) == 0) {
                    datePickerColorsColors = datePickerColors;
                    if (composerStartRestartGroup.changed(datePickerColorsColors)) {
                    }
                    i3 |= i14;
                } else {
                    datePickerColorsColors = datePickerColors;
                }
                i3 |= i14;
            } else {
                datePickerColorsColors = datePickerColors;
            }
            if ((599187 & i3) == 599186) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i2 & 4) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -897;
                    } else {
                        datePickerFormatter2 = datePickerFormatter;
                    }
                    if (i4 != 0) {
                        function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i111117) {
                                ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                if ((i111117 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-162164694, i111117, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                    }
                                    DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        i10 = 54;
                    } else {
                        i10 = 54;
                    }
                    if (i6 != 0) {
                        function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i111117) {
                                ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                if ((i111117 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-185279404, i111117, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                    }
                                    DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, i10);
                    }
                    if (i8 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 64) != 0) {
                        i3 &= -3670017;
                        datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                } else {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i2 & 4) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -897;
                    } else {
                        datePickerFormatter2 = datePickerFormatter;
                    }
                    if (i4 != 0) {
                        function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i111117) {
                                ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                if ((i111117 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-162164694, i111117, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                    }
                                    DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        i10 = 54;
                    } else {
                        i10 = 54;
                    }
                    if (i6 != 0) {
                        function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i111117) {
                                ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                if ((i111117 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-185279404, i111117, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                    }
                                    DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, i10);
                    }
                    if (i8 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 64) != 0) {
                        i3 &= -3670017;
                        datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                }
                function4 = function2RememberComposableLambda2;
                z3 = z2;
                Function2<? super Composer, ? super Integer, Unit> function1117 = function2RememberComposableLambda;
                i11 = i3;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(650830774, i11, -1, "androidx.compose.material3.DateRangePicker (DateRangePicker.kt:113)");
                }
                localeDefaultLocale = CalendarLocale_androidKt.defaultLocale(composerStartRestartGroup, 0);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454754600, "CC(remember):DateRangePicker.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(localeDefaultLocale);
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                final CalendarModel calendarModel112 = (CalendarModel) objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.startReplaceGroup(-1454747621);
                ComposerKt.sourceInformation(composerStartRestartGroup, "122@5491L323");
                if (z3) {
                    composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-1490010652, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i111117) {
                            ComposerKt.sourceInformation(composer2, "C126@5723L50,123@5513L283:DateRangePicker.kt#uh7d8r");
                            if ((i111117 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1490010652, i111117, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:123)");
                                }
                                Modifier modifierPadding = PaddingKt.padding(Modifier.INSTANCE, DatePickerKt.getDatePickerModeTogglePadding());
                                int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                ComposerKt.sourceInformationMarkerStart(composer2, 1752251243, "CC(remember):DateRangePicker.kt#9igjgp");
                                boolean zChanged2 = composer2.changed(dateRangePickerState);
                                final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                Object objRememberedValue3 = composer2.rememberedValue();
                                if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue3 = (Function1) new Function1<DisplayMode, Unit>() {
                                        {
                                            super(1);
                                        }

                                        public Object invoke(Object obj) {
                                            m2313invokevCnGnXg(((DisplayMode) obj).getValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void m2313invokevCnGnXg(int i111118) {
                                            dateRangePickerState2.mo2321setDisplayModevCnGnXg(i111118);
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue3);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                DatePickerKt.m2278DisplayModeToggleButtontER2X8s(modifierPadding, iMo2320getDisplayModejFl4v0, (Function1) objRememberedValue3, composer2, 6);
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
                    composableLambdaRememberComposableLambda = null;
                }
                composerStartRestartGroup.endReplaceGroup();
                int i111117 = ((i11 >> 3) & 14) | 14155776;
                int i111118 = i11 >> 6;
                DatePickerColors datePickerColors114 = datePickerColorsColors;
                DatePickerKt.m2274DateEntryContainerau3_HiA(modifier2, function1117, function4, composableLambdaRememberComposableLambda, datePickerColorsColors, TypographyKt.getValue(DatePickerModalTokens.INSTANCE.getRangeSelectionHeaderHeadlineFont(), composerStartRestartGroup, 6), Dp.constructor-impl(DatePickerModalTokens.INSTANCE.m3515getRangeSelectionHeaderContainerHeightD9Ej5fM() - HeaderHeightOffset), ComposableLambdaKt.rememberComposableLambda(-57534331, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i111119) {
                        ComposerKt.sourceInformation(composer2, "C142@6428L467,153@6934L91,137@6121L1123:DateRangePicker.kt#uh7d8r");
                        if ((i111119 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-57534331, i111119, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:137)");
                            }
                            Long selectedStartDateMillis = dateRangePickerState.getSelectedStartDateMillis();
                            Long selectedEndDateMillis = dateRangePickerState.getSelectedEndDateMillis();
                            long displayedMonthMillis = dateRangePickerState.getDisplayedMonthMillis();
                            int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                            ComposerKt.sourceInformationMarkerStart(composer2, 1752274220, "CC(remember):DateRangePicker.kt#9igjgp");
                            boolean zChanged2 = composer2.changed(dateRangePickerState);
                            final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                            Object objRememberedValue3 = composer2.rememberedValue();
                            if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue3 = (Function2) new Function2<Long, Long, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Long) obj, (Long) obj2);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Long l, Long l2) {
                                        try {
                                            dateRangePickerState2.setSelection(l, l2);
                                        } catch (IllegalArgumentException unused) {
                                        }
                                    }
                                };
                                composer2.updateRememberedValue(objRememberedValue3);
                            }
                            Function2 function1118 = (Function2) objRememberedValue3;
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerStart(composer2, 1752290036, "CC(remember):DateRangePicker.kt#9igjgp");
                            boolean zChanged3 = composer2.changed(dateRangePickerState);
                            final DateRangePickerState dateRangePickerState3 = dateRangePickerState;
                            Object objRememberedValue4 = composer2.rememberedValue();
                            if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue4 = (Function1) new Function1<Long, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke(((Number) obj).longValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(long j) {
                                        dateRangePickerState3.setDisplayedMonthMillis(j);
                                    }
                                };
                                composer2.updateRememberedValue(objRememberedValue4);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            DateRangePickerKt.m2309SwitchableDateEntryContentRN2D1Q(selectedStartDateMillis, selectedEndDateMillis, displayedMonthMillis, iMo2320getDisplayModejFl4v0, function1118, (Function1) objRememberedValue4, calendarModel112, dateRangePickerState.getYearRange(), datePickerFormatter2, dateRangePickerState.getSelectableDates(), datePickerColorsColors, composer2, 0, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, i111117 | (i111118 & 112) | (i111118 & 896) | (i111118 & 57344));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function2RememberComposableLambda = function1117;
                datePickerFormatter3 = datePickerFormatter2;
                modifier3 = modifier2;
                z4 = z3;
                datePickerColors2 = datePickerColors114;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i2 & 4) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -897;
                    } else {
                        datePickerFormatter2 = datePickerFormatter;
                    }
                    if (i4 != 0) {
                        function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i111119) {
                                ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                if ((i111119 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-162164694, i111119, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                    }
                                    DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        i10 = 54;
                    } else {
                        i10 = 54;
                    }
                    if (i6 != 0) {
                        function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i111119) {
                                ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                if ((i111119 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-185279404, i111119, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                    }
                                    DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, i10);
                    }
                    if (i8 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 64) != 0) {
                        i3 &= -3670017;
                        datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                } else {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i2 & 4) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -897;
                    } else {
                        datePickerFormatter2 = datePickerFormatter;
                    }
                    if (i4 != 0) {
                        function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i111119) {
                                ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                if ((i111119 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-162164694, i111119, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                    }
                                    DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        i10 = 54;
                    } else {
                        i10 = 54;
                    }
                    if (i6 != 0) {
                        function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i111119) {
                                ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                if ((i111119 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-185279404, i111119, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                    }
                                    DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, i10);
                    }
                    if (i8 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 64) != 0) {
                        i3 &= -3670017;
                        datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                }
                function4 = function2RememberComposableLambda2;
                z3 = z2;
                Function2<? super Composer, ? super Integer, Unit> function1118 = function2RememberComposableLambda;
                i11 = i3;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(650830774, i11, -1, "androidx.compose.material3.DateRangePicker (DateRangePicker.kt:113)");
                }
                localeDefaultLocale = CalendarLocale_androidKt.defaultLocale(composerStartRestartGroup, 0);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454754600, "CC(remember):DateRangePicker.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(localeDefaultLocale);
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                final CalendarModel calendarModel113 = (CalendarModel) objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.startReplaceGroup(-1454747621);
                ComposerKt.sourceInformation(composerStartRestartGroup, "122@5491L323");
                if (z3) {
                    composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-1490010652, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i111119) {
                            ComposerKt.sourceInformation(composer2, "C126@5723L50,123@5513L283:DateRangePicker.kt#uh7d8r");
                            if ((i111119 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1490010652, i111119, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:123)");
                                }
                                Modifier modifierPadding = PaddingKt.padding(Modifier.INSTANCE, DatePickerKt.getDatePickerModeTogglePadding());
                                int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                ComposerKt.sourceInformationMarkerStart(composer2, 1752251243, "CC(remember):DateRangePicker.kt#9igjgp");
                                boolean zChanged2 = composer2.changed(dateRangePickerState);
                                final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                Object objRememberedValue3 = composer2.rememberedValue();
                                if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue3 = (Function1) new Function1<DisplayMode, Unit>() {
                                        {
                                            super(1);
                                        }

                                        public Object invoke(Object obj) {
                                            m2313invokevCnGnXg(((DisplayMode) obj).getValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void m2313invokevCnGnXg(int i1111110) {
                                            dateRangePickerState2.mo2321setDisplayModevCnGnXg(i1111110);
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue3);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                DatePickerKt.m2278DisplayModeToggleButtontER2X8s(modifierPadding, iMo2320getDisplayModejFl4v0, (Function1) objRememberedValue3, composer2, 6);
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
                    composableLambdaRememberComposableLambda = null;
                }
                composerStartRestartGroup.endReplaceGroup();
                int i111119 = ((i11 >> 3) & 14) | 14155776;
                int i1111110 = i11 >> 6;
                DatePickerColors datePickerColors115 = datePickerColorsColors;
                DatePickerKt.m2274DateEntryContainerau3_HiA(modifier2, function1118, function4, composableLambdaRememberComposableLambda, datePickerColorsColors, TypographyKt.getValue(DatePickerModalTokens.INSTANCE.getRangeSelectionHeaderHeadlineFont(), composerStartRestartGroup, 6), Dp.constructor-impl(DatePickerModalTokens.INSTANCE.m3515getRangeSelectionHeaderContainerHeightD9Ej5fM() - HeaderHeightOffset), ComposableLambdaKt.rememberComposableLambda(-57534331, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i1111111) {
                        ComposerKt.sourceInformation(composer2, "C142@6428L467,153@6934L91,137@6121L1123:DateRangePicker.kt#uh7d8r");
                        if ((i1111111 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-57534331, i1111111, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:137)");
                            }
                            Long selectedStartDateMillis = dateRangePickerState.getSelectedStartDateMillis();
                            Long selectedEndDateMillis = dateRangePickerState.getSelectedEndDateMillis();
                            long displayedMonthMillis = dateRangePickerState.getDisplayedMonthMillis();
                            int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                            ComposerKt.sourceInformationMarkerStart(composer2, 1752274220, "CC(remember):DateRangePicker.kt#9igjgp");
                            boolean zChanged2 = composer2.changed(dateRangePickerState);
                            final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                            Object objRememberedValue3 = composer2.rememberedValue();
                            if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue3 = (Function2) new Function2<Long, Long, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Long) obj, (Long) obj2);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Long l, Long l2) {
                                        try {
                                            dateRangePickerState2.setSelection(l, l2);
                                        } catch (IllegalArgumentException unused) {
                                        }
                                    }
                                };
                                composer2.updateRememberedValue(objRememberedValue3);
                            }
                            Function2 function1119 = (Function2) objRememberedValue3;
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerStart(composer2, 1752290036, "CC(remember):DateRangePicker.kt#9igjgp");
                            boolean zChanged3 = composer2.changed(dateRangePickerState);
                            final DateRangePickerState dateRangePickerState3 = dateRangePickerState;
                            Object objRememberedValue4 = composer2.rememberedValue();
                            if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue4 = (Function1) new Function1<Long, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke(((Number) obj).longValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(long j) {
                                        dateRangePickerState3.setDisplayedMonthMillis(j);
                                    }
                                };
                                composer2.updateRememberedValue(objRememberedValue4);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            DateRangePickerKt.m2309SwitchableDateEntryContentRN2D1Q(selectedStartDateMillis, selectedEndDateMillis, displayedMonthMillis, iMo2320getDisplayModejFl4v0, function1119, (Function1) objRememberedValue4, calendarModel113, dateRangePickerState.getYearRange(), datePickerFormatter2, dateRangePickerState.getSelectableDates(), datePickerColorsColors, composer2, 0, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, i111119 | (i1111110 & 112) | (i1111110 & 896) | (i1111110 & 57344));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function2RememberComposableLambda = function1118;
                datePickerFormatter3 = datePickerFormatter2;
                modifier3 = modifier2;
                z4 = z3;
                datePickerColors2 = datePickerColors115;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final DatePickerFormatter datePickerFormatter15 = datePickerFormatter3;
                final Function2<? super Composer, ? super Integer, Unit> function1119 = function2RememberComposableLambda;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i1111111) {
                        DateRangePickerKt.DateRangePicker(dateRangePickerState, modifier3, datePickerFormatter15, function1119, function4, z4, datePickerColors2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 3072;
        function2RememberComposableLambda = function2;
        i6 = i2 & 16;
        if (i6 != 0) {
            if ((i & 24576) == 0) {
                function2RememberComposableLambda2 = function3;
                if (composerStartRestartGroup.changedInstance(function2RememberComposableLambda2)) {
                    i7 = Fields.Clip;
                } else {
                    i7 = Fields.Shape;
                }
                i3 |= i7;
            }
            i8 = i2 & 32;
            if (i8 != 0) {
                if ((196608 & i) == 0) {
                    z2 = z;
                    if (composerStartRestartGroup.changed(z2)) {
                        i9 = Fields.RenderEffect;
                    } else {
                        i9 = 65536;
                    }
                    i3 |= i9;
                }
                if ((1572864 & i) == 0) {
                    if ((i2 & 64) == 0) {
                        datePickerColorsColors = datePickerColors;
                        if (composerStartRestartGroup.changed(datePickerColorsColors)) {
                        }
                        i3 |= i14;
                    } else {
                        datePickerColorsColors = datePickerColors;
                    }
                    i3 |= i14;
                } else {
                    datePickerColorsColors = datePickerColors;
                }
                if ((599187 & i3) == 599186) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i2 & 4) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -897;
                        } else {
                            datePickerFormatter2 = datePickerFormatter;
                        }
                        if (i4 != 0) {
                            function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i1111111) {
                                    ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                    if ((i1111111 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-162164694, i1111111, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            i10 = 54;
                        } else {
                            i10 = 54;
                        }
                        if (i6 != 0) {
                            function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i1111111) {
                                    ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                    if ((i1111111 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-185279404, i1111111, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, i10);
                        }
                        if (i8 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                    } else {
                        if (i13 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i2 & 4) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -897;
                        } else {
                            datePickerFormatter2 = datePickerFormatter;
                        }
                        if (i4 != 0) {
                            function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i1111111) {
                                    ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                    if ((i1111111 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-162164694, i1111111, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            i10 = 54;
                        } else {
                            i10 = 54;
                        }
                        if (i6 != 0) {
                            function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i1111111) {
                                    ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                    if ((i1111111 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-185279404, i1111111, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, i10);
                        }
                        if (i8 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                    }
                    function4 = function2RememberComposableLambda2;
                    z3 = z2;
                    Function2<? super Composer, ? super Integer, Unit> function11110 = function2RememberComposableLambda;
                    i11 = i3;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(650830774, i11, -1, "androidx.compose.material3.DateRangePicker (DateRangePicker.kt:113)");
                    }
                    localeDefaultLocale = CalendarLocale_androidKt.defaultLocale(composerStartRestartGroup, 0);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454754600, "CC(remember):DateRangePicker.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(localeDefaultLocale);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    final CalendarModel calendarModel114 = (CalendarModel) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.startReplaceGroup(-1454747621);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "122@5491L323");
                    if (z3) {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-1490010652, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i1111111) {
                                ComposerKt.sourceInformation(composer2, "C126@5723L50,123@5513L283:DateRangePicker.kt#uh7d8r");
                                if ((i1111111 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1490010652, i1111111, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:123)");
                                    }
                                    Modifier modifierPadding = PaddingKt.padding(Modifier.INSTANCE, DatePickerKt.getDatePickerModeTogglePadding());
                                    int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1752251243, "CC(remember):DateRangePicker.kt#9igjgp");
                                    boolean zChanged2 = composer2.changed(dateRangePickerState);
                                    final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                    Object objRememberedValue3 = composer2.rememberedValue();
                                    if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                        objRememberedValue3 = (Function1) new Function1<DisplayMode, Unit>() {
                                            {
                                                super(1);
                                            }

                                            public Object invoke(Object obj) {
                                                m2313invokevCnGnXg(((DisplayMode) obj).getValue());
                                                return Unit.INSTANCE;
                                            }

                                            public final void m2313invokevCnGnXg(int i1111112) {
                                                dateRangePickerState2.mo2321setDisplayModevCnGnXg(i1111112);
                                            }
                                        };
                                        composer2.updateRememberedValue(objRememberedValue3);
                                    }
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    DatePickerKt.m2278DisplayModeToggleButtontER2X8s(modifierPadding, iMo2320getDisplayModejFl4v0, (Function1) objRememberedValue3, composer2, 6);
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
                        composableLambdaRememberComposableLambda = null;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    int i1111111 = ((i11 >> 3) & 14) | 14155776;
                    int i1111112 = i11 >> 6;
                    DatePickerColors datePickerColors116 = datePickerColorsColors;
                    DatePickerKt.m2274DateEntryContainerau3_HiA(modifier2, function11110, function4, composableLambdaRememberComposableLambda, datePickerColorsColors, TypographyKt.getValue(DatePickerModalTokens.INSTANCE.getRangeSelectionHeaderHeadlineFont(), composerStartRestartGroup, 6), Dp.constructor-impl(DatePickerModalTokens.INSTANCE.m3515getRangeSelectionHeaderContainerHeightD9Ej5fM() - HeaderHeightOffset), ComposableLambdaKt.rememberComposableLambda(-57534331, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1111113) {
                            ComposerKt.sourceInformation(composer2, "C142@6428L467,153@6934L91,137@6121L1123:DateRangePicker.kt#uh7d8r");
                            if ((i1111113 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-57534331, i1111113, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:137)");
                                }
                                Long selectedStartDateMillis = dateRangePickerState.getSelectedStartDateMillis();
                                Long selectedEndDateMillis = dateRangePickerState.getSelectedEndDateMillis();
                                long displayedMonthMillis = dateRangePickerState.getDisplayedMonthMillis();
                                int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                ComposerKt.sourceInformationMarkerStart(composer2, 1752274220, "CC(remember):DateRangePicker.kt#9igjgp");
                                boolean zChanged2 = composer2.changed(dateRangePickerState);
                                final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                Object objRememberedValue3 = composer2.rememberedValue();
                                if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue3 = (Function2) new Function2<Long, Long, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Long) obj, (Long) obj2);
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Long l, Long l2) {
                                            try {
                                                dateRangePickerState2.setSelection(l, l2);
                                            } catch (IllegalArgumentException unused) {
                                            }
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue3);
                                }
                                Function2 function11111 = (Function2) objRememberedValue3;
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerStart(composer2, 1752290036, "CC(remember):DateRangePicker.kt#9igjgp");
                                boolean zChanged3 = composer2.changed(dateRangePickerState);
                                final DateRangePickerState dateRangePickerState3 = dateRangePickerState;
                                Object objRememberedValue4 = composer2.rememberedValue();
                                if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue4 = (Function1) new Function1<Long, Unit>() {
                                        {
                                            super(1);
                                        }

                                        public Object invoke(Object obj) {
                                            invoke(((Number) obj).longValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(long j) {
                                            dateRangePickerState3.setDisplayedMonthMillis(j);
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue4);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                DateRangePickerKt.m2309SwitchableDateEntryContentRN2D1Q(selectedStartDateMillis, selectedEndDateMillis, displayedMonthMillis, iMo2320getDisplayModejFl4v0, function11111, (Function1) objRememberedValue4, calendarModel114, dateRangePickerState.getYearRange(), datePickerFormatter2, dateRangePickerState.getSelectableDates(), datePickerColorsColors, composer2, 0, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, i1111111 | (i1111112 & 112) | (i1111112 & 896) | (i1111112 & 57344));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function2RememberComposableLambda = function11110;
                    datePickerFormatter3 = datePickerFormatter2;
                    modifier3 = modifier2;
                    z4 = z3;
                    datePickerColors2 = datePickerColors116;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i2 & 4) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -897;
                        } else {
                            datePickerFormatter2 = datePickerFormatter;
                        }
                        if (i4 != 0) {
                            function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i1111113) {
                                    ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                    if ((i1111113 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-162164694, i1111113, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            i10 = 54;
                        } else {
                            i10 = 54;
                        }
                        if (i6 != 0) {
                            function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i1111113) {
                                    ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                    if ((i1111113 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-185279404, i1111113, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, i10);
                        }
                        if (i8 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                    } else {
                        if (i13 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if ((i2 & 4) != 0) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            i3 &= -897;
                        } else {
                            datePickerFormatter2 = datePickerFormatter;
                        }
                        if (i4 != 0) {
                            function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i1111113) {
                                    ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                    if ((i1111113 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-162164694, i1111113, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54);
                            i10 = 54;
                        } else {
                            i10 = 54;
                        }
                        if (i6 != 0) {
                            function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i1111113) {
                                    ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                    if ((i1111113 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-185279404, i1111113, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                        }
                                        DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, i10);
                        }
                        if (i8 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 64) != 0) {
                            i3 &= -3670017;
                            datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        }
                    }
                    function4 = function2RememberComposableLambda2;
                    z3 = z2;
                    Function2<? super Composer, ? super Integer, Unit> function11111 = function2RememberComposableLambda;
                    i11 = i3;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(650830774, i11, -1, "androidx.compose.material3.DateRangePicker (DateRangePicker.kt:113)");
                    }
                    localeDefaultLocale = CalendarLocale_androidKt.defaultLocale(composerStartRestartGroup, 0);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454754600, "CC(remember):DateRangePicker.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(localeDefaultLocale);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    final CalendarModel calendarModel115 = (CalendarModel) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composerStartRestartGroup.startReplaceGroup(-1454747621);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "122@5491L323");
                    if (z3) {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-1490010652, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i1111113) {
                                ComposerKt.sourceInformation(composer2, "C126@5723L50,123@5513L283:DateRangePicker.kt#uh7d8r");
                                if ((i1111113 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1490010652, i1111113, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:123)");
                                    }
                                    Modifier modifierPadding = PaddingKt.padding(Modifier.INSTANCE, DatePickerKt.getDatePickerModeTogglePadding());
                                    int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1752251243, "CC(remember):DateRangePicker.kt#9igjgp");
                                    boolean zChanged2 = composer2.changed(dateRangePickerState);
                                    final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                    Object objRememberedValue3 = composer2.rememberedValue();
                                    if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                        objRememberedValue3 = (Function1) new Function1<DisplayMode, Unit>() {
                                            {
                                                super(1);
                                            }

                                            public Object invoke(Object obj) {
                                                m2313invokevCnGnXg(((DisplayMode) obj).getValue());
                                                return Unit.INSTANCE;
                                            }

                                            public final void m2313invokevCnGnXg(int i1111114) {
                                                dateRangePickerState2.mo2321setDisplayModevCnGnXg(i1111114);
                                            }
                                        };
                                        composer2.updateRememberedValue(objRememberedValue3);
                                    }
                                    ComposerKt.sourceInformationMarkerEnd(composer2);
                                    DatePickerKt.m2278DisplayModeToggleButtontER2X8s(modifierPadding, iMo2320getDisplayModejFl4v0, (Function1) objRememberedValue3, composer2, 6);
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
                        composableLambdaRememberComposableLambda = null;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    int i1111113 = ((i11 >> 3) & 14) | 14155776;
                    int i1111114 = i11 >> 6;
                    DatePickerColors datePickerColors117 = datePickerColorsColors;
                    DatePickerKt.m2274DateEntryContainerau3_HiA(modifier2, function11111, function4, composableLambdaRememberComposableLambda, datePickerColorsColors, TypographyKt.getValue(DatePickerModalTokens.INSTANCE.getRangeSelectionHeaderHeadlineFont(), composerStartRestartGroup, 6), Dp.constructor-impl(DatePickerModalTokens.INSTANCE.m3515getRangeSelectionHeaderContainerHeightD9Ej5fM() - HeaderHeightOffset), ComposableLambdaKt.rememberComposableLambda(-57534331, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1111115) {
                            ComposerKt.sourceInformation(composer2, "C142@6428L467,153@6934L91,137@6121L1123:DateRangePicker.kt#uh7d8r");
                            if ((i1111115 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-57534331, i1111115, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:137)");
                                }
                                Long selectedStartDateMillis = dateRangePickerState.getSelectedStartDateMillis();
                                Long selectedEndDateMillis = dateRangePickerState.getSelectedEndDateMillis();
                                long displayedMonthMillis = dateRangePickerState.getDisplayedMonthMillis();
                                int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                ComposerKt.sourceInformationMarkerStart(composer2, 1752274220, "CC(remember):DateRangePicker.kt#9igjgp");
                                boolean zChanged2 = composer2.changed(dateRangePickerState);
                                final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                Object objRememberedValue3 = composer2.rememberedValue();
                                if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue3 = (Function2) new Function2<Long, Long, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Long) obj, (Long) obj2);
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Long l, Long l2) {
                                            try {
                                                dateRangePickerState2.setSelection(l, l2);
                                            } catch (IllegalArgumentException unused) {
                                            }
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue3);
                                }
                                Function2 function11112 = (Function2) objRememberedValue3;
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                ComposerKt.sourceInformationMarkerStart(composer2, 1752290036, "CC(remember):DateRangePicker.kt#9igjgp");
                                boolean zChanged3 = composer2.changed(dateRangePickerState);
                                final DateRangePickerState dateRangePickerState3 = dateRangePickerState;
                                Object objRememberedValue4 = composer2.rememberedValue();
                                if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue4 = (Function1) new Function1<Long, Unit>() {
                                        {
                                            super(1);
                                        }

                                        public Object invoke(Object obj) {
                                            invoke(((Number) obj).longValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(long j) {
                                            dateRangePickerState3.setDisplayedMonthMillis(j);
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue4);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                DateRangePickerKt.m2309SwitchableDateEntryContentRN2D1Q(selectedStartDateMillis, selectedEndDateMillis, displayedMonthMillis, iMo2320getDisplayModejFl4v0, function11112, (Function1) objRememberedValue4, calendarModel115, dateRangePickerState.getYearRange(), datePickerFormatter2, dateRangePickerState.getSelectableDates(), datePickerColorsColors, composer2, 0, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, i1111113 | (i1111114 & 112) | (i1111114 & 896) | (i1111114 & 57344));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function2RememberComposableLambda = function11111;
                    datePickerFormatter3 = datePickerFormatter2;
                    modifier3 = modifier2;
                    z4 = z3;
                    datePickerColors2 = datePickerColors117;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final DatePickerFormatter datePickerFormatter16 = datePickerFormatter3;
                    final Function2<? super Composer, ? super Integer, Unit> function11112 = function2RememberComposableLambda;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1111115) {
                            DateRangePickerKt.DateRangePicker(dateRangePickerState, modifier3, datePickerFormatter16, function11112, function4, z4, datePickerColors2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            z2 = z;
            if ((1572864 & i) == 0) {
                if ((i2 & 64) == 0) {
                    datePickerColorsColors = datePickerColors;
                    if (composerStartRestartGroup.changed(datePickerColorsColors)) {
                    }
                    i3 |= i14;
                } else {
                    datePickerColorsColors = datePickerColors;
                }
                i3 |= i14;
            } else {
                datePickerColorsColors = datePickerColors;
            }
            if ((599187 & i3) == 599186) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i2 & 4) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -897;
                    } else {
                        datePickerFormatter2 = datePickerFormatter;
                    }
                    if (i4 != 0) {
                        function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i1111115) {
                                ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                if ((i1111115 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-162164694, i1111115, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                    }
                                    DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        i10 = 54;
                    } else {
                        i10 = 54;
                    }
                    if (i6 != 0) {
                        function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i1111115) {
                                ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                if ((i1111115 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-185279404, i1111115, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                    }
                                    DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, i10);
                    }
                    if (i8 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 64) != 0) {
                        i3 &= -3670017;
                        datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                } else {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i2 & 4) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -897;
                    } else {
                        datePickerFormatter2 = datePickerFormatter;
                    }
                    if (i4 != 0) {
                        function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i1111115) {
                                ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                if ((i1111115 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-162164694, i1111115, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                    }
                                    DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        i10 = 54;
                    } else {
                        i10 = 54;
                    }
                    if (i6 != 0) {
                        function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i1111115) {
                                ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                if ((i1111115 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-185279404, i1111115, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                    }
                                    DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, i10);
                    }
                    if (i8 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 64) != 0) {
                        i3 &= -3670017;
                        datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                }
                function4 = function2RememberComposableLambda2;
                z3 = z2;
                Function2<? super Composer, ? super Integer, Unit> function11113 = function2RememberComposableLambda;
                i11 = i3;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(650830774, i11, -1, "androidx.compose.material3.DateRangePicker (DateRangePicker.kt:113)");
                }
                localeDefaultLocale = CalendarLocale_androidKt.defaultLocale(composerStartRestartGroup, 0);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454754600, "CC(remember):DateRangePicker.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(localeDefaultLocale);
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                final CalendarModel calendarModel116 = (CalendarModel) objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.startReplaceGroup(-1454747621);
                ComposerKt.sourceInformation(composerStartRestartGroup, "122@5491L323");
                if (z3) {
                    composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-1490010652, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1111115) {
                            ComposerKt.sourceInformation(composer2, "C126@5723L50,123@5513L283:DateRangePicker.kt#uh7d8r");
                            if ((i1111115 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1490010652, i1111115, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:123)");
                                }
                                Modifier modifierPadding = PaddingKt.padding(Modifier.INSTANCE, DatePickerKt.getDatePickerModeTogglePadding());
                                int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                ComposerKt.sourceInformationMarkerStart(composer2, 1752251243, "CC(remember):DateRangePicker.kt#9igjgp");
                                boolean zChanged2 = composer2.changed(dateRangePickerState);
                                final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                Object objRememberedValue3 = composer2.rememberedValue();
                                if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue3 = (Function1) new Function1<DisplayMode, Unit>() {
                                        {
                                            super(1);
                                        }

                                        public Object invoke(Object obj) {
                                            m2313invokevCnGnXg(((DisplayMode) obj).getValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void m2313invokevCnGnXg(int i1111116) {
                                            dateRangePickerState2.mo2321setDisplayModevCnGnXg(i1111116);
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue3);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                DatePickerKt.m2278DisplayModeToggleButtontER2X8s(modifierPadding, iMo2320getDisplayModejFl4v0, (Function1) objRememberedValue3, composer2, 6);
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
                    composableLambdaRememberComposableLambda = null;
                }
                composerStartRestartGroup.endReplaceGroup();
                int i1111115 = ((i11 >> 3) & 14) | 14155776;
                int i1111116 = i11 >> 6;
                DatePickerColors datePickerColors118 = datePickerColorsColors;
                DatePickerKt.m2274DateEntryContainerau3_HiA(modifier2, function11113, function4, composableLambdaRememberComposableLambda, datePickerColorsColors, TypographyKt.getValue(DatePickerModalTokens.INSTANCE.getRangeSelectionHeaderHeadlineFont(), composerStartRestartGroup, 6), Dp.constructor-impl(DatePickerModalTokens.INSTANCE.m3515getRangeSelectionHeaderContainerHeightD9Ej5fM() - HeaderHeightOffset), ComposableLambdaKt.rememberComposableLambda(-57534331, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i1111117) {
                        ComposerKt.sourceInformation(composer2, "C142@6428L467,153@6934L91,137@6121L1123:DateRangePicker.kt#uh7d8r");
                        if ((i1111117 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-57534331, i1111117, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:137)");
                            }
                            Long selectedStartDateMillis = dateRangePickerState.getSelectedStartDateMillis();
                            Long selectedEndDateMillis = dateRangePickerState.getSelectedEndDateMillis();
                            long displayedMonthMillis = dateRangePickerState.getDisplayedMonthMillis();
                            int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                            ComposerKt.sourceInformationMarkerStart(composer2, 1752274220, "CC(remember):DateRangePicker.kt#9igjgp");
                            boolean zChanged2 = composer2.changed(dateRangePickerState);
                            final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                            Object objRememberedValue3 = composer2.rememberedValue();
                            if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue3 = (Function2) new Function2<Long, Long, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Long) obj, (Long) obj2);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Long l, Long l2) {
                                        try {
                                            dateRangePickerState2.setSelection(l, l2);
                                        } catch (IllegalArgumentException unused) {
                                        }
                                    }
                                };
                                composer2.updateRememberedValue(objRememberedValue3);
                            }
                            Function2 function11114 = (Function2) objRememberedValue3;
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerStart(composer2, 1752290036, "CC(remember):DateRangePicker.kt#9igjgp");
                            boolean zChanged3 = composer2.changed(dateRangePickerState);
                            final DateRangePickerState dateRangePickerState3 = dateRangePickerState;
                            Object objRememberedValue4 = composer2.rememberedValue();
                            if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue4 = (Function1) new Function1<Long, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke(((Number) obj).longValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(long j) {
                                        dateRangePickerState3.setDisplayedMonthMillis(j);
                                    }
                                };
                                composer2.updateRememberedValue(objRememberedValue4);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            DateRangePickerKt.m2309SwitchableDateEntryContentRN2D1Q(selectedStartDateMillis, selectedEndDateMillis, displayedMonthMillis, iMo2320getDisplayModejFl4v0, function11114, (Function1) objRememberedValue4, calendarModel116, dateRangePickerState.getYearRange(), datePickerFormatter2, dateRangePickerState.getSelectableDates(), datePickerColorsColors, composer2, 0, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, i1111115 | (i1111116 & 112) | (i1111116 & 896) | (i1111116 & 57344));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function2RememberComposableLambda = function11113;
                datePickerFormatter3 = datePickerFormatter2;
                modifier3 = modifier2;
                z4 = z3;
                datePickerColors2 = datePickerColors118;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i2 & 4) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -897;
                    } else {
                        datePickerFormatter2 = datePickerFormatter;
                    }
                    if (i4 != 0) {
                        function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i1111117) {
                                ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                if ((i1111117 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-162164694, i1111117, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                    }
                                    DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        i10 = 54;
                    } else {
                        i10 = 54;
                    }
                    if (i6 != 0) {
                        function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i1111117) {
                                ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                if ((i1111117 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-185279404, i1111117, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                    }
                                    DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, i10);
                    }
                    if (i8 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 64) != 0) {
                        i3 &= -3670017;
                        datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                } else {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i2 & 4) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -897;
                    } else {
                        datePickerFormatter2 = datePickerFormatter;
                    }
                    if (i4 != 0) {
                        function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i1111117) {
                                ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                if ((i1111117 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-162164694, i1111117, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                    }
                                    DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        i10 = 54;
                    } else {
                        i10 = 54;
                    }
                    if (i6 != 0) {
                        function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i1111117) {
                                ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                if ((i1111117 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-185279404, i1111117, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                    }
                                    DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, i10);
                    }
                    if (i8 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 64) != 0) {
                        i3 &= -3670017;
                        datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                }
                function4 = function2RememberComposableLambda2;
                z3 = z2;
                Function2<? super Composer, ? super Integer, Unit> function11114 = function2RememberComposableLambda;
                i11 = i3;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(650830774, i11, -1, "androidx.compose.material3.DateRangePicker (DateRangePicker.kt:113)");
                }
                localeDefaultLocale = CalendarLocale_androidKt.defaultLocale(composerStartRestartGroup, 0);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454754600, "CC(remember):DateRangePicker.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(localeDefaultLocale);
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                final CalendarModel calendarModel117 = (CalendarModel) objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.startReplaceGroup(-1454747621);
                ComposerKt.sourceInformation(composerStartRestartGroup, "122@5491L323");
                if (z3) {
                    composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-1490010652, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1111117) {
                            ComposerKt.sourceInformation(composer2, "C126@5723L50,123@5513L283:DateRangePicker.kt#uh7d8r");
                            if ((i1111117 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1490010652, i1111117, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:123)");
                                }
                                Modifier modifierPadding = PaddingKt.padding(Modifier.INSTANCE, DatePickerKt.getDatePickerModeTogglePadding());
                                int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                ComposerKt.sourceInformationMarkerStart(composer2, 1752251243, "CC(remember):DateRangePicker.kt#9igjgp");
                                boolean zChanged2 = composer2.changed(dateRangePickerState);
                                final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                Object objRememberedValue3 = composer2.rememberedValue();
                                if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue3 = (Function1) new Function1<DisplayMode, Unit>() {
                                        {
                                            super(1);
                                        }

                                        public Object invoke(Object obj) {
                                            m2313invokevCnGnXg(((DisplayMode) obj).getValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void m2313invokevCnGnXg(int i1111118) {
                                            dateRangePickerState2.mo2321setDisplayModevCnGnXg(i1111118);
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue3);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                DatePickerKt.m2278DisplayModeToggleButtontER2X8s(modifierPadding, iMo2320getDisplayModejFl4v0, (Function1) objRememberedValue3, composer2, 6);
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
                    composableLambdaRememberComposableLambda = null;
                }
                composerStartRestartGroup.endReplaceGroup();
                int i1111117 = ((i11 >> 3) & 14) | 14155776;
                int i1111118 = i11 >> 6;
                DatePickerColors datePickerColors119 = datePickerColorsColors;
                DatePickerKt.m2274DateEntryContainerau3_HiA(modifier2, function11114, function4, composableLambdaRememberComposableLambda, datePickerColorsColors, TypographyKt.getValue(DatePickerModalTokens.INSTANCE.getRangeSelectionHeaderHeadlineFont(), composerStartRestartGroup, 6), Dp.constructor-impl(DatePickerModalTokens.INSTANCE.m3515getRangeSelectionHeaderContainerHeightD9Ej5fM() - HeaderHeightOffset), ComposableLambdaKt.rememberComposableLambda(-57534331, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i1111119) {
                        ComposerKt.sourceInformation(composer2, "C142@6428L467,153@6934L91,137@6121L1123:DateRangePicker.kt#uh7d8r");
                        if ((i1111119 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-57534331, i1111119, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:137)");
                            }
                            Long selectedStartDateMillis = dateRangePickerState.getSelectedStartDateMillis();
                            Long selectedEndDateMillis = dateRangePickerState.getSelectedEndDateMillis();
                            long displayedMonthMillis = dateRangePickerState.getDisplayedMonthMillis();
                            int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                            ComposerKt.sourceInformationMarkerStart(composer2, 1752274220, "CC(remember):DateRangePicker.kt#9igjgp");
                            boolean zChanged2 = composer2.changed(dateRangePickerState);
                            final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                            Object objRememberedValue3 = composer2.rememberedValue();
                            if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue3 = (Function2) new Function2<Long, Long, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Long) obj, (Long) obj2);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Long l, Long l2) {
                                        try {
                                            dateRangePickerState2.setSelection(l, l2);
                                        } catch (IllegalArgumentException unused) {
                                        }
                                    }
                                };
                                composer2.updateRememberedValue(objRememberedValue3);
                            }
                            Function2 function11115 = (Function2) objRememberedValue3;
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerStart(composer2, 1752290036, "CC(remember):DateRangePicker.kt#9igjgp");
                            boolean zChanged3 = composer2.changed(dateRangePickerState);
                            final DateRangePickerState dateRangePickerState3 = dateRangePickerState;
                            Object objRememberedValue4 = composer2.rememberedValue();
                            if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue4 = (Function1) new Function1<Long, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke(((Number) obj).longValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(long j) {
                                        dateRangePickerState3.setDisplayedMonthMillis(j);
                                    }
                                };
                                composer2.updateRememberedValue(objRememberedValue4);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            DateRangePickerKt.m2309SwitchableDateEntryContentRN2D1Q(selectedStartDateMillis, selectedEndDateMillis, displayedMonthMillis, iMo2320getDisplayModejFl4v0, function11115, (Function1) objRememberedValue4, calendarModel117, dateRangePickerState.getYearRange(), datePickerFormatter2, dateRangePickerState.getSelectableDates(), datePickerColorsColors, composer2, 0, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, i1111117 | (i1111118 & 112) | (i1111118 & 896) | (i1111118 & 57344));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function2RememberComposableLambda = function11114;
                datePickerFormatter3 = datePickerFormatter2;
                modifier3 = modifier2;
                z4 = z3;
                datePickerColors2 = datePickerColors119;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final DatePickerFormatter datePickerFormatter17 = datePickerFormatter3;
                final Function2<? super Composer, ? super Integer, Unit> function11115 = function2RememberComposableLambda;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i1111119) {
                        DateRangePickerKt.DateRangePicker(dateRangePickerState, modifier3, datePickerFormatter17, function11115, function4, z4, datePickerColors2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 24576;
        function2RememberComposableLambda2 = function3;
        i8 = i2 & 32;
        if (i8 != 0) {
            if ((196608 & i) == 0) {
                z2 = z;
                if (composerStartRestartGroup.changed(z2)) {
                    i9 = Fields.RenderEffect;
                } else {
                    i9 = 65536;
                }
                i3 |= i9;
            }
            if ((1572864 & i) == 0) {
                if ((i2 & 64) == 0) {
                    datePickerColorsColors = datePickerColors;
                    if (composerStartRestartGroup.changed(datePickerColorsColors)) {
                    }
                    i3 |= i14;
                } else {
                    datePickerColorsColors = datePickerColors;
                }
                i3 |= i14;
            } else {
                datePickerColorsColors = datePickerColors;
            }
            if ((599187 & i3) == 599186) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i2 & 4) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -897;
                    } else {
                        datePickerFormatter2 = datePickerFormatter;
                    }
                    if (i4 != 0) {
                        function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i1111119) {
                                ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                if ((i1111119 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-162164694, i1111119, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                    }
                                    DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        i10 = 54;
                    } else {
                        i10 = 54;
                    }
                    if (i6 != 0) {
                        function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i1111119) {
                                ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                if ((i1111119 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-185279404, i1111119, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                    }
                                    DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, i10);
                    }
                    if (i8 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 64) != 0) {
                        i3 &= -3670017;
                        datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                } else {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i2 & 4) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -897;
                    } else {
                        datePickerFormatter2 = datePickerFormatter;
                    }
                    if (i4 != 0) {
                        function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i1111119) {
                                ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                if ((i1111119 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-162164694, i1111119, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                    }
                                    DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        i10 = 54;
                    } else {
                        i10 = 54;
                    }
                    if (i6 != 0) {
                        function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i1111119) {
                                ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                if ((i1111119 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-185279404, i1111119, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                    }
                                    DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, i10);
                    }
                    if (i8 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 64) != 0) {
                        i3 &= -3670017;
                        datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                }
                function4 = function2RememberComposableLambda2;
                z3 = z2;
                Function2<? super Composer, ? super Integer, Unit> function11116 = function2RememberComposableLambda;
                i11 = i3;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(650830774, i11, -1, "androidx.compose.material3.DateRangePicker (DateRangePicker.kt:113)");
                }
                localeDefaultLocale = CalendarLocale_androidKt.defaultLocale(composerStartRestartGroup, 0);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454754600, "CC(remember):DateRangePicker.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(localeDefaultLocale);
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                final CalendarModel calendarModel118 = (CalendarModel) objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.startReplaceGroup(-1454747621);
                ComposerKt.sourceInformation(composerStartRestartGroup, "122@5491L323");
                if (z3) {
                    composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-1490010652, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1111119) {
                            ComposerKt.sourceInformation(composer2, "C126@5723L50,123@5513L283:DateRangePicker.kt#uh7d8r");
                            if ((i1111119 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1490010652, i1111119, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:123)");
                                }
                                Modifier modifierPadding = PaddingKt.padding(Modifier.INSTANCE, DatePickerKt.getDatePickerModeTogglePadding());
                                int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                ComposerKt.sourceInformationMarkerStart(composer2, 1752251243, "CC(remember):DateRangePicker.kt#9igjgp");
                                boolean zChanged2 = composer2.changed(dateRangePickerState);
                                final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                Object objRememberedValue3 = composer2.rememberedValue();
                                if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue3 = (Function1) new Function1<DisplayMode, Unit>() {
                                        {
                                            super(1);
                                        }

                                        public Object invoke(Object obj) {
                                            m2313invokevCnGnXg(((DisplayMode) obj).getValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void m2313invokevCnGnXg(int i11111110) {
                                            dateRangePickerState2.mo2321setDisplayModevCnGnXg(i11111110);
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue3);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                DatePickerKt.m2278DisplayModeToggleButtontER2X8s(modifierPadding, iMo2320getDisplayModejFl4v0, (Function1) objRememberedValue3, composer2, 6);
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
                    composableLambdaRememberComposableLambda = null;
                }
                composerStartRestartGroup.endReplaceGroup();
                int i1111119 = ((i11 >> 3) & 14) | 14155776;
                int i11111110 = i11 >> 6;
                DatePickerColors datePickerColors1110 = datePickerColorsColors;
                DatePickerKt.m2274DateEntryContainerau3_HiA(modifier2, function11116, function4, composableLambdaRememberComposableLambda, datePickerColorsColors, TypographyKt.getValue(DatePickerModalTokens.INSTANCE.getRangeSelectionHeaderHeadlineFont(), composerStartRestartGroup, 6), Dp.constructor-impl(DatePickerModalTokens.INSTANCE.m3515getRangeSelectionHeaderContainerHeightD9Ej5fM() - HeaderHeightOffset), ComposableLambdaKt.rememberComposableLambda(-57534331, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11111111) {
                        ComposerKt.sourceInformation(composer2, "C142@6428L467,153@6934L91,137@6121L1123:DateRangePicker.kt#uh7d8r");
                        if ((i11111111 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-57534331, i11111111, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:137)");
                            }
                            Long selectedStartDateMillis = dateRangePickerState.getSelectedStartDateMillis();
                            Long selectedEndDateMillis = dateRangePickerState.getSelectedEndDateMillis();
                            long displayedMonthMillis = dateRangePickerState.getDisplayedMonthMillis();
                            int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                            ComposerKt.sourceInformationMarkerStart(composer2, 1752274220, "CC(remember):DateRangePicker.kt#9igjgp");
                            boolean zChanged2 = composer2.changed(dateRangePickerState);
                            final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                            Object objRememberedValue3 = composer2.rememberedValue();
                            if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue3 = (Function2) new Function2<Long, Long, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Long) obj, (Long) obj2);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Long l, Long l2) {
                                        try {
                                            dateRangePickerState2.setSelection(l, l2);
                                        } catch (IllegalArgumentException unused) {
                                        }
                                    }
                                };
                                composer2.updateRememberedValue(objRememberedValue3);
                            }
                            Function2 function11117 = (Function2) objRememberedValue3;
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerStart(composer2, 1752290036, "CC(remember):DateRangePicker.kt#9igjgp");
                            boolean zChanged3 = composer2.changed(dateRangePickerState);
                            final DateRangePickerState dateRangePickerState3 = dateRangePickerState;
                            Object objRememberedValue4 = composer2.rememberedValue();
                            if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue4 = (Function1) new Function1<Long, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke(((Number) obj).longValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(long j) {
                                        dateRangePickerState3.setDisplayedMonthMillis(j);
                                    }
                                };
                                composer2.updateRememberedValue(objRememberedValue4);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            DateRangePickerKt.m2309SwitchableDateEntryContentRN2D1Q(selectedStartDateMillis, selectedEndDateMillis, displayedMonthMillis, iMo2320getDisplayModejFl4v0, function11117, (Function1) objRememberedValue4, calendarModel118, dateRangePickerState.getYearRange(), datePickerFormatter2, dateRangePickerState.getSelectableDates(), datePickerColorsColors, composer2, 0, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, i1111119 | (i11111110 & 112) | (i11111110 & 896) | (i11111110 & 57344));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function2RememberComposableLambda = function11116;
                datePickerFormatter3 = datePickerFormatter2;
                modifier3 = modifier2;
                z4 = z3;
                datePickerColors2 = datePickerColors1110;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i2 & 4) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -897;
                    } else {
                        datePickerFormatter2 = datePickerFormatter;
                    }
                    if (i4 != 0) {
                        function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11111111) {
                                ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                if ((i11111111 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-162164694, i11111111, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                    }
                                    DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        i10 = 54;
                    } else {
                        i10 = 54;
                    }
                    if (i6 != 0) {
                        function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11111111) {
                                ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                if ((i11111111 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-185279404, i11111111, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                    }
                                    DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, i10);
                    }
                    if (i8 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 64) != 0) {
                        i3 &= -3670017;
                        datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                } else {
                    if (i13 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if ((i2 & 4) != 0) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        i3 &= -897;
                    } else {
                        datePickerFormatter2 = datePickerFormatter;
                    }
                    if (i4 != 0) {
                        function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11111111) {
                                ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                                if ((i11111111 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-162164694, i11111111, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                    }
                                    DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54);
                        i10 = 54;
                    } else {
                        i10 = 54;
                    }
                    if (i6 != 0) {
                        function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11111111) {
                                ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                                if ((i11111111 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-185279404, i11111111, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                    }
                                    DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, i10);
                    }
                    if (i8 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 64) != 0) {
                        i3 &= -3670017;
                        datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    }
                }
                function4 = function2RememberComposableLambda2;
                z3 = z2;
                Function2<? super Composer, ? super Integer, Unit> function11117 = function2RememberComposableLambda;
                i11 = i3;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(650830774, i11, -1, "androidx.compose.material3.DateRangePicker (DateRangePicker.kt:113)");
                }
                localeDefaultLocale = CalendarLocale_androidKt.defaultLocale(composerStartRestartGroup, 0);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454754600, "CC(remember):DateRangePicker.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(localeDefaultLocale);
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                final CalendarModel calendarModel119 = (CalendarModel) objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composerStartRestartGroup.startReplaceGroup(-1454747621);
                ComposerKt.sourceInformation(composerStartRestartGroup, "122@5491L323");
                if (z3) {
                    composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-1490010652, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11111111) {
                            ComposerKt.sourceInformation(composer2, "C126@5723L50,123@5513L283:DateRangePicker.kt#uh7d8r");
                            if ((i11111111 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1490010652, i11111111, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:123)");
                                }
                                Modifier modifierPadding = PaddingKt.padding(Modifier.INSTANCE, DatePickerKt.getDatePickerModeTogglePadding());
                                int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                                ComposerKt.sourceInformationMarkerStart(composer2, 1752251243, "CC(remember):DateRangePicker.kt#9igjgp");
                                boolean zChanged2 = composer2.changed(dateRangePickerState);
                                final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                                Object objRememberedValue3 = composer2.rememberedValue();
                                if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                    objRememberedValue3 = (Function1) new Function1<DisplayMode, Unit>() {
                                        {
                                            super(1);
                                        }

                                        public Object invoke(Object obj) {
                                            m2313invokevCnGnXg(((DisplayMode) obj).getValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void m2313invokevCnGnXg(int i11111112) {
                                            dateRangePickerState2.mo2321setDisplayModevCnGnXg(i11111112);
                                        }
                                    };
                                    composer2.updateRememberedValue(objRememberedValue3);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composer2);
                                DatePickerKt.m2278DisplayModeToggleButtontER2X8s(modifierPadding, iMo2320getDisplayModejFl4v0, (Function1) objRememberedValue3, composer2, 6);
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
                    composableLambdaRememberComposableLambda = null;
                }
                composerStartRestartGroup.endReplaceGroup();
                int i11111111 = ((i11 >> 3) & 14) | 14155776;
                int i11111112 = i11 >> 6;
                DatePickerColors datePickerColors1111 = datePickerColorsColors;
                DatePickerKt.m2274DateEntryContainerau3_HiA(modifier2, function11117, function4, composableLambdaRememberComposableLambda, datePickerColorsColors, TypographyKt.getValue(DatePickerModalTokens.INSTANCE.getRangeSelectionHeaderHeadlineFont(), composerStartRestartGroup, 6), Dp.constructor-impl(DatePickerModalTokens.INSTANCE.m3515getRangeSelectionHeaderContainerHeightD9Ej5fM() - HeaderHeightOffset), ComposableLambdaKt.rememberComposableLambda(-57534331, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11111113) {
                        ComposerKt.sourceInformation(composer2, "C142@6428L467,153@6934L91,137@6121L1123:DateRangePicker.kt#uh7d8r");
                        if ((i11111113 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-57534331, i11111113, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:137)");
                            }
                            Long selectedStartDateMillis = dateRangePickerState.getSelectedStartDateMillis();
                            Long selectedEndDateMillis = dateRangePickerState.getSelectedEndDateMillis();
                            long displayedMonthMillis = dateRangePickerState.getDisplayedMonthMillis();
                            int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                            ComposerKt.sourceInformationMarkerStart(composer2, 1752274220, "CC(remember):DateRangePicker.kt#9igjgp");
                            boolean zChanged2 = composer2.changed(dateRangePickerState);
                            final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                            Object objRememberedValue3 = composer2.rememberedValue();
                            if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue3 = (Function2) new Function2<Long, Long, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Long) obj, (Long) obj2);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Long l, Long l2) {
                                        try {
                                            dateRangePickerState2.setSelection(l, l2);
                                        } catch (IllegalArgumentException unused) {
                                        }
                                    }
                                };
                                composer2.updateRememberedValue(objRememberedValue3);
                            }
                            Function2 function11118 = (Function2) objRememberedValue3;
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerStart(composer2, 1752290036, "CC(remember):DateRangePicker.kt#9igjgp");
                            boolean zChanged3 = composer2.changed(dateRangePickerState);
                            final DateRangePickerState dateRangePickerState3 = dateRangePickerState;
                            Object objRememberedValue4 = composer2.rememberedValue();
                            if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue4 = (Function1) new Function1<Long, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke(((Number) obj).longValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(long j) {
                                        dateRangePickerState3.setDisplayedMonthMillis(j);
                                    }
                                };
                                composer2.updateRememberedValue(objRememberedValue4);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            DateRangePickerKt.m2309SwitchableDateEntryContentRN2D1Q(selectedStartDateMillis, selectedEndDateMillis, displayedMonthMillis, iMo2320getDisplayModejFl4v0, function11118, (Function1) objRememberedValue4, calendarModel119, dateRangePickerState.getYearRange(), datePickerFormatter2, dateRangePickerState.getSelectableDates(), datePickerColorsColors, composer2, 0, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, i11111111 | (i11111112 & 112) | (i11111112 & 896) | (i11111112 & 57344));
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function2RememberComposableLambda = function11117;
                datePickerFormatter3 = datePickerFormatter2;
                modifier3 = modifier2;
                z4 = z3;
                datePickerColors2 = datePickerColors1111;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final DatePickerFormatter datePickerFormatter18 = datePickerFormatter3;
                final Function2<? super Composer, ? super Integer, Unit> function11118 = function2RememberComposableLambda;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11111113) {
                        DateRangePickerKt.DateRangePicker(dateRangePickerState, modifier3, datePickerFormatter18, function11118, function4, z4, datePickerColors2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 196608;
        z2 = z;
        if ((1572864 & i) == 0) {
            if ((i2 & 64) == 0) {
                datePickerColorsColors = datePickerColors;
                if (composerStartRestartGroup.changed(datePickerColorsColors)) {
                }
                i3 |= i14;
            } else {
                datePickerColorsColors = datePickerColors;
            }
            i3 |= i14;
        } else {
            datePickerColorsColors = datePickerColors;
        }
        if ((599187 & i3) == 599186) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i13 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if ((i2 & 4) != 0) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    i3 &= -897;
                } else {
                    datePickerFormatter2 = datePickerFormatter;
                }
                if (i4 != 0) {
                    function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11111113) {
                            ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                            if ((i11111113 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-162164694, i11111113, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                }
                                DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                    i10 = 54;
                } else {
                    i10 = 54;
                }
                if (i6 != 0) {
                    function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11111113) {
                            ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                            if ((i11111113 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-185279404, i11111113, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                }
                                DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, i10);
                }
                if (i8 != 0) {
                    z2 = true;
                }
                if ((i2 & 64) != 0) {
                    i3 &= -3670017;
                    datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                }
            } else {
                if (i13 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if ((i2 & 4) != 0) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    i3 &= -897;
                } else {
                    datePickerFormatter2 = datePickerFormatter;
                }
                if (i4 != 0) {
                    function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11111113) {
                            ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                            if ((i11111113 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-162164694, i11111113, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                }
                                DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                    i10 = 54;
                } else {
                    i10 = 54;
                }
                if (i6 != 0) {
                    function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11111113) {
                            ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                            if ((i11111113 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-185279404, i11111113, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                }
                                DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, i10);
                }
                if (i8 != 0) {
                    z2 = true;
                }
                if ((i2 & 64) != 0) {
                    i3 &= -3670017;
                    datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                }
            }
            function4 = function2RememberComposableLambda2;
            z3 = z2;
            Function2<? super Composer, ? super Integer, Unit> function11119 = function2RememberComposableLambda;
            i11 = i3;
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(650830774, i11, -1, "androidx.compose.material3.DateRangePicker (DateRangePicker.kt:113)");
            }
            localeDefaultLocale = CalendarLocale_androidKt.defaultLocale(composerStartRestartGroup, 0);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454754600, "CC(remember):DateRangePicker.kt#9igjgp");
            zChanged = composerStartRestartGroup.changed(localeDefaultLocale);
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (!zChanged) {
                objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            } else {
                objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            }
            final CalendarModel calendarModel1110 = (CalendarModel) objRememberedValue2;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composerStartRestartGroup.startReplaceGroup(-1454747621);
            ComposerKt.sourceInformation(composerStartRestartGroup, "122@5491L323");
            if (z3) {
                composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-1490010652, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11111113) {
                        ComposerKt.sourceInformation(composer2, "C126@5723L50,123@5513L283:DateRangePicker.kt#uh7d8r");
                        if ((i11111113 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1490010652, i11111113, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:123)");
                            }
                            Modifier modifierPadding = PaddingKt.padding(Modifier.INSTANCE, DatePickerKt.getDatePickerModeTogglePadding());
                            int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                            ComposerKt.sourceInformationMarkerStart(composer2, 1752251243, "CC(remember):DateRangePicker.kt#9igjgp");
                            boolean zChanged2 = composer2.changed(dateRangePickerState);
                            final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                            Object objRememberedValue3 = composer2.rememberedValue();
                            if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue3 = (Function1) new Function1<DisplayMode, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        m2313invokevCnGnXg(((DisplayMode) obj).getValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2313invokevCnGnXg(int i11111114) {
                                        dateRangePickerState2.mo2321setDisplayModevCnGnXg(i11111114);
                                    }
                                };
                                composer2.updateRememberedValue(objRememberedValue3);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            DatePickerKt.m2278DisplayModeToggleButtontER2X8s(modifierPadding, iMo2320getDisplayModejFl4v0, (Function1) objRememberedValue3, composer2, 6);
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
                composableLambdaRememberComposableLambda = null;
            }
            composerStartRestartGroup.endReplaceGroup();
            int i11111113 = ((i11 >> 3) & 14) | 14155776;
            int i11111114 = i11 >> 6;
            DatePickerColors datePickerColors1112 = datePickerColorsColors;
            DatePickerKt.m2274DateEntryContainerau3_HiA(modifier2, function11119, function4, composableLambdaRememberComposableLambda, datePickerColorsColors, TypographyKt.getValue(DatePickerModalTokens.INSTANCE.getRangeSelectionHeaderHeadlineFont(), composerStartRestartGroup, 6), Dp.constructor-impl(DatePickerModalTokens.INSTANCE.m3515getRangeSelectionHeaderContainerHeightD9Ej5fM() - HeaderHeightOffset), ComposableLambdaKt.rememberComposableLambda(-57534331, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i11111115) {
                    ComposerKt.sourceInformation(composer2, "C142@6428L467,153@6934L91,137@6121L1123:DateRangePicker.kt#uh7d8r");
                    if ((i11111115 & 3) != 2 || !composer2.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-57534331, i11111115, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:137)");
                        }
                        Long selectedStartDateMillis = dateRangePickerState.getSelectedStartDateMillis();
                        Long selectedEndDateMillis = dateRangePickerState.getSelectedEndDateMillis();
                        long displayedMonthMillis = dateRangePickerState.getDisplayedMonthMillis();
                        int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                        ComposerKt.sourceInformationMarkerStart(composer2, 1752274220, "CC(remember):DateRangePicker.kt#9igjgp");
                        boolean zChanged2 = composer2.changed(dateRangePickerState);
                        final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                        Object objRememberedValue3 = composer2.rememberedValue();
                        if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue3 = (Function2) new Function2<Long, Long, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Long) obj, (Long) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Long l, Long l2) {
                                    try {
                                        dateRangePickerState2.setSelection(l, l2);
                                    } catch (IllegalArgumentException unused) {
                                    }
                                }
                            };
                            composer2.updateRememberedValue(objRememberedValue3);
                        }
                        Function2 function111110 = (Function2) objRememberedValue3;
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerStart(composer2, 1752290036, "CC(remember):DateRangePicker.kt#9igjgp");
                        boolean zChanged3 = composer2.changed(dateRangePickerState);
                        final DateRangePickerState dateRangePickerState3 = dateRangePickerState;
                        Object objRememberedValue4 = composer2.rememberedValue();
                        if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue4 = (Function1) new Function1<Long, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke(((Number) obj).longValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(long j) {
                                    dateRangePickerState3.setDisplayedMonthMillis(j);
                                }
                            };
                            composer2.updateRememberedValue(objRememberedValue4);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        DateRangePickerKt.m2309SwitchableDateEntryContentRN2D1Q(selectedStartDateMillis, selectedEndDateMillis, displayedMonthMillis, iMo2320getDisplayModejFl4v0, function111110, (Function1) objRememberedValue4, calendarModel1110, dateRangePickerState.getYearRange(), datePickerFormatter2, dateRangePickerState.getSelectableDates(), datePickerColorsColors, composer2, 0, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                            return;
                        }
                        return;
                    }
                    composer2.skipToGroupEnd();
                }
            }, composerStartRestartGroup, 54), composerStartRestartGroup, i11111113 | (i11111114 & 112) | (i11111114 & 896) | (i11111114 & 57344));
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            function2RememberComposableLambda = function11119;
            datePickerFormatter3 = datePickerFormatter2;
            modifier3 = modifier2;
            z4 = z3;
            datePickerColors2 = datePickerColors1112;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i13 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if ((i2 & 4) != 0) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    i3 &= -897;
                } else {
                    datePickerFormatter2 = datePickerFormatter;
                }
                if (i4 != 0) {
                    function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11111115) {
                            ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                            if ((i11111115 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-162164694, i11111115, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                }
                                DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                    i10 = 54;
                } else {
                    i10 = 54;
                }
                if (i6 != 0) {
                    function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11111115) {
                            ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                            if ((i11111115 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-185279404, i11111115, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                }
                                DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, i10);
                }
                if (i8 != 0) {
                    z2 = true;
                }
                if ((i2 & 64) != 0) {
                    i3 &= -3670017;
                    datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                }
            } else {
                if (i13 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if ((i2 & 4) != 0) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454781303, "CC(remember):DateRangePicker.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = DatePickerDefaults.dateFormatter$default(DatePickerDefaults.INSTANCE, null, null, null, 7, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    datePickerFormatter2 = (DatePickerFormatter) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    i3 &= -897;
                } else {
                    datePickerFormatter2 = datePickerFormatter;
                }
                if (i4 != 0) {
                    function2RememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-162164694, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11111115) {
                            ComposerKt.sourceInformation(composer2, "C97@4534L145:DateRangePicker.kt#uh7d8r");
                            if ((i11111115 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-162164694, i11111115, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:97)");
                                }
                                DateRangePickerDefaults.INSTANCE.m2306DateRangePickerTitlehOD91z4(dateRangePickerState.mo2320getDisplayModejFl4v0(), PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerTitlePadding), composer2, 432, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54);
                    i10 = 54;
                } else {
                    i10 = 54;
                }
                if (i6 != 0) {
                    function2RememberComposableLambda2 = ComposableLambdaKt.rememberComposableLambda(-185279404, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11111115) {
                            ComposerKt.sourceInformation(composer2, "C103@4763L312:DateRangePicker.kt#uh7d8r");
                            if ((i11111115 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-185279404, i11111115, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:103)");
                                }
                                DateRangePickerDefaults.INSTANCE.m2305DateRangePickerHeadlinev84Udv0(dateRangePickerState.getSelectedStartDateMillis(), dateRangePickerState.getSelectedEndDateMillis(), dateRangePickerState.mo2320getDisplayModejFl4v0(), datePickerFormatter2, PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.DateRangePickerHeadlinePadding), composer2, 221184, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, i10);
                }
                if (i8 != 0) {
                    z2 = true;
                }
                if ((i2 & 64) != 0) {
                    i3 &= -3670017;
                    datePickerColorsColors = DatePickerDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                }
            }
            function4 = function2RememberComposableLambda2;
            z3 = z2;
            Function2<? super Composer, ? super Integer, Unit> function111110 = function2RememberComposableLambda;
            i11 = i3;
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(650830774, i11, -1, "androidx.compose.material3.DateRangePicker (DateRangePicker.kt:113)");
            }
            localeDefaultLocale = CalendarLocale_androidKt.defaultLocale(composerStartRestartGroup, 0);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1454754600, "CC(remember):DateRangePicker.kt#9igjgp");
            zChanged = composerStartRestartGroup.changed(localeDefaultLocale);
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (!zChanged) {
                objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            } else {
                objRememberedValue2 = CalendarModel_androidKt.createCalendarModel(localeDefaultLocale);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            }
            final CalendarModel calendarModel1111 = (CalendarModel) objRememberedValue2;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composerStartRestartGroup.startReplaceGroup(-1454747621);
            ComposerKt.sourceInformation(composerStartRestartGroup, "122@5491L323");
            if (z3) {
                composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(-1490010652, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11111115) {
                        ComposerKt.sourceInformation(composer2, "C126@5723L50,123@5513L283:DateRangePicker.kt#uh7d8r");
                        if ((i11111115 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1490010652, i11111115, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:123)");
                            }
                            Modifier modifierPadding = PaddingKt.padding(Modifier.INSTANCE, DatePickerKt.getDatePickerModeTogglePadding());
                            int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                            ComposerKt.sourceInformationMarkerStart(composer2, 1752251243, "CC(remember):DateRangePicker.kt#9igjgp");
                            boolean zChanged2 = composer2.changed(dateRangePickerState);
                            final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                            Object objRememberedValue3 = composer2.rememberedValue();
                            if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue3 = (Function1) new Function1<DisplayMode, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        m2313invokevCnGnXg(((DisplayMode) obj).getValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2313invokevCnGnXg(int i11111116) {
                                        dateRangePickerState2.mo2321setDisplayModevCnGnXg(i11111116);
                                    }
                                };
                                composer2.updateRememberedValue(objRememberedValue3);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            DatePickerKt.m2278DisplayModeToggleButtontER2X8s(modifierPadding, iMo2320getDisplayModejFl4v0, (Function1) objRememberedValue3, composer2, 6);
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
                composableLambdaRememberComposableLambda = null;
            }
            composerStartRestartGroup.endReplaceGroup();
            int i11111115 = ((i11 >> 3) & 14) | 14155776;
            int i11111116 = i11 >> 6;
            DatePickerColors datePickerColors1113 = datePickerColorsColors;
            DatePickerKt.m2274DateEntryContainerau3_HiA(modifier2, function111110, function4, composableLambdaRememberComposableLambda, datePickerColorsColors, TypographyKt.getValue(DatePickerModalTokens.INSTANCE.getRangeSelectionHeaderHeadlineFont(), composerStartRestartGroup, 6), Dp.constructor-impl(DatePickerModalTokens.INSTANCE.m3515getRangeSelectionHeaderContainerHeightD9Ej5fM() - HeaderHeightOffset), ComposableLambdaKt.rememberComposableLambda(-57534331, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i11111117) {
                    ComposerKt.sourceInformation(composer2, "C142@6428L467,153@6934L91,137@6121L1123:DateRangePicker.kt#uh7d8r");
                    if ((i11111117 & 3) != 2 || !composer2.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-57534331, i11111117, -1, "androidx.compose.material3.DateRangePicker.<anonymous> (DateRangePicker.kt:137)");
                        }
                        Long selectedStartDateMillis = dateRangePickerState.getSelectedStartDateMillis();
                        Long selectedEndDateMillis = dateRangePickerState.getSelectedEndDateMillis();
                        long displayedMonthMillis = dateRangePickerState.getDisplayedMonthMillis();
                        int iMo2320getDisplayModejFl4v0 = dateRangePickerState.mo2320getDisplayModejFl4v0();
                        ComposerKt.sourceInformationMarkerStart(composer2, 1752274220, "CC(remember):DateRangePicker.kt#9igjgp");
                        boolean zChanged2 = composer2.changed(dateRangePickerState);
                        final DateRangePickerState dateRangePickerState2 = dateRangePickerState;
                        Object objRememberedValue3 = composer2.rememberedValue();
                        if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue3 = (Function2) new Function2<Long, Long, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Long) obj, (Long) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Long l, Long l2) {
                                    try {
                                        dateRangePickerState2.setSelection(l, l2);
                                    } catch (IllegalArgumentException unused) {
                                    }
                                }
                            };
                            composer2.updateRememberedValue(objRememberedValue3);
                        }
                        Function2 function111111 = (Function2) objRememberedValue3;
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerStart(composer2, 1752290036, "CC(remember):DateRangePicker.kt#9igjgp");
                        boolean zChanged3 = composer2.changed(dateRangePickerState);
                        final DateRangePickerState dateRangePickerState3 = dateRangePickerState;
                        Object objRememberedValue4 = composer2.rememberedValue();
                        if (zChanged3 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue4 = (Function1) new Function1<Long, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke(((Number) obj).longValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(long j) {
                                    dateRangePickerState3.setDisplayedMonthMillis(j);
                                }
                            };
                            composer2.updateRememberedValue(objRememberedValue4);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        DateRangePickerKt.m2309SwitchableDateEntryContentRN2D1Q(selectedStartDateMillis, selectedEndDateMillis, displayedMonthMillis, iMo2320getDisplayModejFl4v0, function111111, (Function1) objRememberedValue4, calendarModel1111, dateRangePickerState.getYearRange(), datePickerFormatter2, dateRangePickerState.getSelectableDates(), datePickerColorsColors, composer2, 0, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                            return;
                        }
                        return;
                    }
                    composer2.skipToGroupEnd();
                }
            }, composerStartRestartGroup, 54), composerStartRestartGroup, i11111115 | (i11111116 & 112) | (i11111116 & 896) | (i11111116 & 57344));
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            function2RememberComposableLambda = function111110;
            datePickerFormatter3 = datePickerFormatter2;
            modifier3 = modifier2;
            z4 = z3;
            datePickerColors2 = datePickerColors1113;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final DatePickerFormatter datePickerFormatter19 = datePickerFormatter3;
            final Function2<? super Composer, ? super Integer, Unit> function111111 = function2RememberComposableLambda;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i11111117) {
                    DateRangePickerKt.DateRangePicker(dateRangePickerState, modifier3, datePickerFormatter19, function111111, function4, z4, datePickerColors2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final DateRangePickerState m2312rememberDateRangePickerStateIlFM19s(Long l, Long l2, Long l3, IntRange intRange, int i, SelectableDates selectableDates, Composer composer, int i2, int i3) {
        ComposerKt.sourceInformationMarkerStart(composer, -2012087461, "C(rememberDateRangePickerState)P(3,2,1,5,0:c#material3.DisplayMode)262@11757L15,*263@11866L475,263@11784L557:DateRangePicker.kt#uh7d8r");
        final Long l4 = (i3 & 1) != 0 ? null : l;
        final Long l5 = (i3 & 2) != 0 ? null : l2;
        final Long l6 = (i3 & 4) != 0 ? l4 : l3;
        final IntRange yearRange = (i3 & 8) != 0 ? DatePickerDefaults.INSTANCE.getYearRange() : intRange;
        final int iM2341getPickerjFl4v0 = (i3 & 16) != 0 ? DisplayMode.INSTANCE.m2341getPickerjFl4v0() : i;
        SelectableDates allDates = (i3 & 32) != 0 ? DatePickerDefaults.INSTANCE.getAllDates() : selectableDates;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-2012087461, i2, -1, "androidx.compose.material3.rememberDateRangePickerState (DateRangePicker.kt:261)");
        }
        final Locale localeDefaultLocale = CalendarLocale_androidKt.defaultLocale(composer, 0);
        Object[] objArr = new Object[0];
        Saver<DateRangePickerStateImpl, Object> Saver = DateRangePickerStateImpl.INSTANCE.Saver(allDates, localeDefaultLocale);
        ComposerKt.sourceInformationMarkerStart(composer, -250595201, "CC(remember):DateRangePicker.kt#9igjgp");
        boolean zChangedInstance = ((((i2 & 112) ^ 48) > 32 && composer.changed(l5)) || (i2 & 48) == 32) | ((((i2 & 14) ^ 6) > 4 && composer.changed(l4)) || (i2 & 6) == 4) | ((((i2 & 896) ^ 384) > 256 && composer.changed(l6)) || (i2 & 384) == 256) | composer.changedInstance(yearRange) | ((((57344 & i2) ^ 24576) > 16384 && composer.changed(iM2341getPickerjFl4v0)) || (i2 & 24576) == 16384) | ((((458752 & i2) ^ 196608) > 131072 && composer.changed(allDates)) || (i2 & 196608) == 131072) | composer.changedInstance(localeDefaultLocale);
        Object objRememberedValue = composer.rememberedValue();
        if (zChangedInstance || objRememberedValue == Composer.INSTANCE.getEmpty()) {
            final SelectableDates selectableDates2 = allDates;
            objRememberedValue = (Function0) new Function0<DateRangePickerStateImpl>() {
                {
                    super(0);
                }

                public final DateRangePickerStateImpl m2319invoke() {
                    return new DateRangePickerStateImpl(l4, l5, l6, yearRange, iM2341getPickerjFl4v0, selectableDates2, localeDefaultLocale, null);
                }
            };
            composer.updateRememberedValue(objRememberedValue);
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        DateRangePickerStateImpl dateRangePickerStateImpl = (DateRangePickerStateImpl) RememberSaveableKt.m4142rememberSaveable(objArr, (Saver) Saver, (String) null, (Function0) objRememberedValue, composer, 0, 4);
        dateRangePickerStateImpl.setSelectableDates(allDates);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return dateRangePickerStateImpl;
    }

    public static DateRangePickerState m2308DateRangePickerStateHVP43zI$default(Locale locale, Long l, Long l2, Long l3, IntRange intRange, int i, SelectableDates selectableDates, int i2, Object obj) {
        if ((i2 & 2) != 0) {
            l = null;
        }
        if ((i2 & 4) != 0) {
            l2 = null;
        }
        if ((i2 & 8) != 0) {
            l3 = l;
        }
        if ((i2 & 16) != 0) {
            intRange = DatePickerDefaults.INSTANCE.getYearRange();
        }
        if ((i2 & 32) != 0) {
            i = DisplayMode.INSTANCE.m2341getPickerjFl4v0();
        }
        if ((i2 & 64) != 0) {
            selectableDates = DatePickerDefaults.INSTANCE.getAllDates();
        }
        return m2307DateRangePickerStateHVP43zI(locale, l, l2, l3, intRange, i, selectableDates);
    }

    public static final DateRangePickerState m2307DateRangePickerStateHVP43zI(Locale locale, Long l, Long l2, Long l3, IntRange intRange, int i, SelectableDates selectableDates) {
        return new DateRangePickerStateImpl(l, l2, l3, intRange, i, selectableDates, locale, null);
    }

    public static final void m2309SwitchableDateEntryContentRN2D1Q(final Long l, final Long l2, final long j, final int i, final Function2<? super Long, ? super Long, Unit> function2, final Function1<? super Long, Unit> function1, final CalendarModel calendarModel, final IntRange intRange, final DatePickerFormatter datePickerFormatter, final SelectableDates selectableDates, final DatePickerColors datePickerColors, Composer composer, final int i2, final int i3) {
        int i4;
        int i5;
        Composer composerStartRestartGroup = composer.startRestartGroup(-532789335);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(SwitchableDateEntryContent)P(9,8,4,3:c#material3.DisplayMode,5,6!1,10,2,7)676@30273L1249,668@30045L1477:DateRangePicker.kt#uh7d8r");
        if ((i2 & 6) == 0) {
            i4 = (composerStartRestartGroup.changed(l) ? 4 : 2) | i2;
        } else {
            i4 = i2;
        }
        if ((i2 & 48) == 0) {
            i4 |= composerStartRestartGroup.changed(l2) ? 32 : 16;
        }
        if ((i2 & 384) == 0) {
            i4 |= composerStartRestartGroup.changed(j) ? Fields.RotationX : Fields.SpotShadowColor;
        }
        if ((i2 & 3072) == 0) {
            i4 |= composerStartRestartGroup.changed(i) ? Fields.CameraDistance : Fields.RotationZ;
        }
        if ((i2 & 24576) == 0) {
            i4 |= composerStartRestartGroup.changedInstance(function2) ? Fields.Clip : Fields.Shape;
        }
        if ((196608 & i2) == 0) {
            i4 |= composerStartRestartGroup.changedInstance(function1) ? Fields.RenderEffect : 65536;
        }
        if ((1572864 & i2) == 0) {
            i4 |= composerStartRestartGroup.changedInstance(calendarModel) ? 1048576 : 524288;
        }
        if ((12582912 & i2) == 0) {
            i4 |= composerStartRestartGroup.changedInstance(intRange) ? 8388608 : 4194304;
        }
        if ((i2 & 100663296) == 0) {
            i4 |= (i2 & 134217728) == 0 ? composerStartRestartGroup.changed(datePickerFormatter) : composerStartRestartGroup.changedInstance(datePickerFormatter) ? 67108864 : 33554432;
        }
        if ((i2 & 805306368) == 0) {
            i4 |= composerStartRestartGroup.changed(selectableDates) ? 536870912 : 268435456;
        }
        if ((i3 & 6) == 0) {
            i5 = i3 | (composerStartRestartGroup.changed(datePickerColors) ? 4 : 2);
        } else {
            i5 = i3;
        }
        if ((i4 & 306783379) != 306783378 || (i5 & 3) != 2 || !composerStartRestartGroup.getSkipping()) {
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-532789335, i4, i5, "androidx.compose.material3.SwitchableDateEntryContent (DateRangePicker.kt:665)");
            }
            CrossfadeKt.Crossfade(DisplayMode.m2333boximpl(i), SemanticsModifierKt.semantics$default(Modifier.INSTANCE, false, new Function1<SemanticsPropertyReceiver, Unit>() {
                public Object invoke(Object obj) {
                    invoke((SemanticsPropertyReceiver) obj);
                    return Unit.INSTANCE;
                }

                public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                    SemanticsPropertiesKt.setContainer(semanticsPropertyReceiver, true);
                }
            }, 1, null), AnimationSpecKt.spring$default(0.0f, 0.0f, null, 7, null), (String) null, ComposableLambdaKt.rememberComposableLambda(-1026642619, true, new Function3<DisplayMode, Composer, Integer, Unit>() {
                {
                    super(3);
                }

                public Object invoke(Object obj, Object obj2, Object obj3) {
                    m2314invokeQujVXRc(((DisplayMode) obj).getValue(), (Composer) obj2, ((Number) obj3).intValue());
                    return Unit.INSTANCE;
                }

                public final void m2314invokeQujVXRc(int i6, Composer composer2, int i7) {
                    int i8;
                    ComposerKt.sourceInformation(composer2, "CP(0:c#material3.DisplayMode):DateRangePicker.kt#uh7d8r");
                    if ((i7 & 6) == 0) {
                        i8 = i7 | (composer2.changed(i6) ? 4 : 2);
                    } else {
                        i8 = i7;
                    }
                    if ((i8 & 19) != 18 || !composer2.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1026642619, i8, -1, "androidx.compose.material3.SwitchableDateEntryContent.<anonymous> (DateRangePicker.kt:677)");
                        }
                        if (DisplayMode.m2336equalsimpl0(i6, DisplayMode.INSTANCE.m2341getPickerjFl4v0())) {
                            composer2.startReplaceGroup(-1871299185);
                            ComposerKt.sourceInformation(composer2, "679@30355L618");
                            DateRangePickerKt.DateRangePickerContent(l, l2, j, function2, function1, calendarModel, intRange, datePickerFormatter, selectableDates, datePickerColors, composer2, 0);
                            composer2.endReplaceGroup();
                        } else if (DisplayMode.m2336equalsimpl0(i6, DisplayMode.INSTANCE.m2340getInputjFl4v0())) {
                            composer2.startReplaceGroup(-1871277944);
                            ComposerKt.sourceInformation(composer2, "692@31023L483");
                            DateRangeInputKt.DateRangeInputContent(l, l2, function2, calendarModel, intRange, datePickerFormatter, selectableDates, datePickerColors, composer2, 0);
                            composer2.endReplaceGroup();
                        } else {
                            composer2.startReplaceGroup(2120399965);
                            composer2.endReplaceGroup();
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                            return;
                        }
                        return;
                    }
                    composer2.skipToGroupEnd();
                }
            }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i4 >> 9) & 14) | 24960, 8);
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

                public final void invoke(Composer composer2, int i6) {
                    DateRangePickerKt.m2309SwitchableDateEntryContentRN2D1Q(l, l2, j, i, function2, function1, calendarModel, intRange, datePickerFormatter, selectableDates, datePickerColors, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), RecomposeScopeImplKt.updateChangedFlags(i3));
                }
            });
        }
    }

    public static final void DateRangePickerContent(final Long l, final Long l2, final long j, final Function2<? super Long, ? super Long, Unit> function2, final Function1<? super Long, Unit> function1, final CalendarModel calendarModel, final IntRange intRange, final DatePickerFormatter datePickerFormatter, final SelectableDates selectableDates, final DatePickerColors datePickerColors, Composer composer, final int i) {
        int i2;
        Composer composer2;
        Composer composerStartRestartGroup = composer.startRestartGroup(-787063721);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(DateRangePickerContent)P(8,7,3,4,5!1,9,2,6)722@32197L64,725@32351L309,725@32324L336,733@32666L648:DateRangePicker.kt#uh7d8r");
        if ((i & 6) == 0) {
            i2 = (composerStartRestartGroup.changed(l) ? 4 : 2) | i;
        } else {
            i2 = i;
        }
        if ((i & 48) == 0) {
            i2 |= composerStartRestartGroup.changed(l2) ? 32 : 16;
        }
        if ((i & 384) == 0) {
            i2 |= composerStartRestartGroup.changed(j) ? Fields.RotationX : Fields.SpotShadowColor;
        }
        if ((i & 3072) == 0) {
            i2 |= composerStartRestartGroup.changedInstance(function2) ? Fields.CameraDistance : Fields.RotationZ;
        }
        if ((i & 24576) == 0) {
            i2 |= composerStartRestartGroup.changedInstance(function1) ? Fields.Clip : Fields.Shape;
        }
        if ((196608 & i) == 0) {
            i2 |= composerStartRestartGroup.changedInstance(calendarModel) ? Fields.RenderEffect : 65536;
        }
        if ((1572864 & i) == 0) {
            i2 |= composerStartRestartGroup.changedInstance(intRange) ? 1048576 : 524288;
        }
        if ((12582912 & i) == 0) {
            i2 |= (16777216 & i) == 0 ? composerStartRestartGroup.changed(datePickerFormatter) : composerStartRestartGroup.changedInstance(datePickerFormatter) ? 8388608 : 4194304;
        }
        if ((100663296 & i) == 0) {
            i2 |= composerStartRestartGroup.changed(selectableDates) ? 67108864 : 33554432;
        }
        if ((i & 805306368) == 0) {
            i2 |= composerStartRestartGroup.changed(datePickerColors) ? 536870912 : 268435456;
        }
        if ((i2 & 306783379) != 306783378 || !composerStartRestartGroup.getSkipping()) {
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-787063721, i2, -1, "androidx.compose.material3.DateRangePickerContent (DateRangePicker.kt:719)");
            }
            int iCoerceAtLeast = RangesKt.coerceAtLeast(calendarModel.getMonth(j).indexIn(intRange), 0);
            LazyListState lazyListStateRememberLazyListState = LazyListStateKt.rememberLazyListState(iCoerceAtLeast, 0, composerStartRestartGroup, 0, 2);
            Integer numValueOf = Integer.valueOf(iCoerceAtLeast);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1097467628, "CC(remember):DateRangePicker.kt#9igjgp");
            boolean zChanged = composerStartRestartGroup.changed(lazyListStateRememberLazyListState) | composerStartRestartGroup.changed(iCoerceAtLeast);
            DateRangePickerKt$DateRangePickerContent$1$1 dateRangePickerKt$DateRangePickerContent$1$1RememberedValue = composerStartRestartGroup.rememberedValue();
            if (zChanged || dateRangePickerKt$DateRangePickerContent$1$1RememberedValue == Composer.INSTANCE.getEmpty()) {
                dateRangePickerKt$DateRangePickerContent$1$1RememberedValue = new DateRangePickerKt$DateRangePickerContent$1$1(lazyListStateRememberLazyListState, iCoerceAtLeast, null);
                composerStartRestartGroup.updateRememberedValue(dateRangePickerKt$DateRangePickerContent$1$1RememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            EffectsKt.LaunchedEffect(numValueOf, (Function2<? super CoroutineScope, ? super Continuation<? super Unit>, ? extends Object>) dateRangePickerKt$DateRangePickerContent$1$1RememberedValue, composerStartRestartGroup, 0);
            Modifier modifierM1037paddingVpY3zN4$default = PaddingKt.m1037paddingVpY3zN4$default(Modifier.INSTANCE, DatePickerKt.getDatePickerHorizontalPadding(), 0.0f, 2, null);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
            MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(Arrangement.INSTANCE.getTop(), Alignment.INSTANCE.getStart(), composerStartRestartGroup, 0);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
            CompositionLocalMap currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierM1037paddingVpY3zN4$default);
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
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 556963099, "C734@32754L31,735@32794L514:DateRangePicker.kt#uh7d8r");
            DatePickerKt.WeekDays(datePickerColors, calendarModel, composerStartRestartGroup, ((i2 >> 27) & 14) | ((i2 >> 12) & 112));
            composer2 = composerStartRestartGroup;
            VerticalMonthsList(lazyListStateRememberLazyListState, l, l2, function2, function1, calendarModel, intRange, datePickerFormatter, selectableDates, datePickerColors, composer2, ((i2 << 3) & 1008) | (i2 & 7168) | (57344 & i2) | (458752 & i2) | (3670016 & i2) | (29360128 & i2) | (234881024 & i2) | (1879048192 & i2));
            ComposerKt.sourceInformationMarkerEnd(composer2);
            ComposerKt.sourceInformationMarkerEnd(composer2);
            composer2.endNode();
            ComposerKt.sourceInformationMarkerEnd(composer2);
            ComposerKt.sourceInformationMarkerEnd(composer2);
            ComposerKt.sourceInformationMarkerEnd(composer2);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        } else {
            composerStartRestartGroup.skipToGroupEnd();
            composer2 = composerStartRestartGroup;
        }
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup = composer2.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer3, int i3) {
                    DateRangePickerKt.DateRangePickerContent(l, l2, j, function2, function1, calendarModel, intRange, datePickerFormatter, selectableDates, datePickerColors, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1));
                }
            });
        }
    }

    public static final void VerticalMonthsList(final LazyListState lazyListState, final Long l, final Long l2, final Function2<? super Long, ? super Long, Unit> function2, final Function1<? super Long, Unit> function1, final CalendarModel calendarModel, final IntRange intRange, final DatePickerFormatter datePickerFormatter, final SelectableDates selectableDates, final DatePickerColors datePickerColors, Composer composer, final int i) {
        int i2;
        Composer composer2;
        Composer composerStartRestartGroup = composer.startRestartGroup(1257365001);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(VerticalMonthsList)P(3,8,7,4,5!1,9,2,6)770@34042L158,776@34262L5,776@34269L3748,776@34205L3812,853@38052L228,853@38022L258:DateRangePicker.kt#uh7d8r");
        if ((i & 6) == 0) {
            i2 = (composerStartRestartGroup.changed(lazyListState) ? 4 : 2) | i;
        } else {
            i2 = i;
        }
        if ((i & 48) == 0) {
            i2 |= composerStartRestartGroup.changed(l) ? 32 : 16;
        }
        if ((i & 384) == 0) {
            i2 |= composerStartRestartGroup.changed(l2) ? Fields.RotationX : Fields.SpotShadowColor;
        }
        if ((i & 3072) == 0) {
            i2 |= composerStartRestartGroup.changedInstance(function2) ? Fields.CameraDistance : Fields.RotationZ;
        }
        if ((i & 24576) == 0) {
            i2 |= composerStartRestartGroup.changedInstance(function1) ? Fields.Clip : Fields.Shape;
        }
        if ((196608 & i) == 0) {
            i2 |= composerStartRestartGroup.changedInstance(calendarModel) ? Fields.RenderEffect : 65536;
        }
        if ((1572864 & i) == 0) {
            i2 |= composerStartRestartGroup.changedInstance(intRange) ? 1048576 : 524288;
        }
        if ((12582912 & i) == 0) {
            i2 |= (16777216 & i) == 0 ? composerStartRestartGroup.changed(datePickerFormatter) : composerStartRestartGroup.changedInstance(datePickerFormatter) ? 8388608 : 4194304;
        }
        if ((100663296 & i) == 0) {
            i2 |= composerStartRestartGroup.changed(selectableDates) ? 67108864 : 33554432;
        }
        if ((805306368 & i) == 0) {
            i2 |= composerStartRestartGroup.changed(datePickerColors) ? 536870912 : 268435456;
        }
        if ((i2 & 306783379) != 306783378 || !composerStartRestartGroup.getSkipping()) {
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1257365001, i2, -1, "androidx.compose.material3.VerticalMonthsList (DateRangePicker.kt:767)");
            }
            final CalendarDate today = calendarModel.getToday();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2140145208, "CC(remember):DateRangePicker.kt#9igjgp");
            boolean zChanged = composerStartRestartGroup.changed(intRange);
            Object objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                objRememberedValue = calendarModel.getMonth(intRange.getFirst(), 1);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            final CalendarMonth calendarMonth = (CalendarMonth) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            int i3 = i2;
            TextKt.ProvideTextStyle(TypographyKt.getValue(DatePickerModalTokens.INSTANCE.getDateLabelTextFont(), composerStartRestartGroup, 6), ComposableLambdaKt.rememberComposableLambda(1090773432, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer3, int i4) {
                    ComposerKt.sourceInformation(composer3, "C777@34300L24,778@34366L59,779@34463L55,783@34699L317,808@35694L2317,800@35319L2692:DateRangePicker.kt#uh7d8r");
                    if ((i4 & 3) != 2 || !composer3.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1090773432, i4, -1, "androidx.compose.material3.VerticalMonthsList.<anonymous> (DateRangePicker.kt:777)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composer3, 773894976, "CC(rememberCoroutineScope)489@20472L144:Effects.kt#9igjgp");
                        ComposerKt.sourceInformationMarkerStart(composer3, -954363344, "CC(remember):Effects.kt#9igjgp");
                        Object objRememberedValue2 = composer3.rememberedValue();
                        if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                            Object compositionScopedCoroutineScopeCanceller = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composer3));
                            composer3.updateRememberedValue(compositionScopedCoroutineScopeCanceller);
                            objRememberedValue2 = compositionScopedCoroutineScopeCanceller;
                        }
                        ComposerKt.sourceInformationMarkerEnd(composer3);
                        CoroutineScope coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue2).getCoroutineScope();
                        ComposerKt.sourceInformationMarkerEnd(composer3);
                        Strings.Companion companion = Strings.INSTANCE;
                        String strM3334getString2EP1pXo = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_range_picker_scroll_to_previous_month), composer3, 0);
                        Strings.Companion companion2 = Strings.INSTANCE;
                        String strM3334getString2EP1pXo2 = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_range_picker_scroll_to_next_month), composer3, 0);
                        ComposerKt.sourceInformationMarkerStart(composer3, -522190970, "CC(remember):DateRangePicker.kt#9igjgp");
                        boolean zChanged2 = composer3.changed(l) | composer3.changed(l2) | composer3.changed(function2);
                        final Long l3 = l;
                        final Long l4 = l2;
                        final Function2<Long, Long, Unit> function3 = function2;
                        Object objRememberedValue3 = composer3.rememberedValue();
                        if (zChanged2 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue3 = (Function1) new Function1<Long, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke(((Number) obj).longValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(long j) {
                                    DateRangePickerKt.updateDateSelection(j, l3, l4, function3);
                                }
                            };
                            composer3.updateRememberedValue(objRememberedValue3);
                        }
                        final Function1 function4 = (Function1) objRememberedValue3;
                        ComposerKt.sourceInformationMarkerEnd(composer3);
                        final List listCustomScrollActions = DateRangePickerKt.customScrollActions(lazyListState, coroutineScope, strM3334getString2EP1pXo, strM3334getString2EP1pXo2);
                        Modifier modifierSemantics$default = SemanticsModifierKt.semantics$default(Modifier.INSTANCE, false, new Function1<SemanticsPropertyReceiver, Unit>() {
                            public Object invoke(Object obj) {
                                invoke((SemanticsPropertyReceiver) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                SemanticsPropertiesKt.setVerticalScrollAxisRange(semanticsPropertyReceiver, new ScrollAxisRange(new Function0<Float>() {
                                    public final Float m2315invoke() {
                                        return Float.valueOf(0.0f);
                                    }
                                }, new Function0<Float>() {
                                    public final Float m2316invoke() {
                                        return Float.valueOf(0.0f);
                                    }
                                }, false, 4, null));
                            }
                        }, 1, null);
                        LazyListState lazyListState2 = lazyListState;
                        ComposerKt.sourceInformationMarkerStart(composer3, -522157130, "CC(remember):DateRangePicker.kt#9igjgp");
                        boolean zChangedInstance = composer3.changedInstance(intRange) | composer3.changedInstance(calendarModel) | composer3.changed(calendarMonth) | composer3.changedInstance(datePickerFormatter) | composer3.changedInstance(listCustomScrollActions) | composer3.changed(datePickerColors) | composer3.changed(l) | composer3.changed(l2) | composer3.changed(function4) | composer3.changed(today) | composer3.changed(selectableDates);
                        final IntRange intRange2 = intRange;
                        final CalendarModel calendarModel2 = calendarModel;
                        final CalendarMonth calendarMonth2 = calendarMonth;
                        final Long l5 = l;
                        final Long l6 = l2;
                        final CalendarDate calendarDate = today;
                        final DatePickerFormatter datePickerFormatter2 = datePickerFormatter;
                        final SelectableDates selectableDates2 = selectableDates;
                        final DatePickerColors datePickerColors2 = datePickerColors;
                        Object objRememberedValue4 = composer3.rememberedValue();
                        if (zChangedInstance || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue4 = (Function1) new Function1<LazyListScope, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((LazyListScope) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(LazyListScope lazyListScope) {
                                    int iNumberOfMonthsInRange = DatePickerKt.numberOfMonthsInRange(intRange2);
                                    final CalendarModel calendarModel3 = calendarModel2;
                                    final CalendarMonth calendarMonth3 = calendarMonth2;
                                    final Long l7 = l5;
                                    final Long l8 = l6;
                                    final Function1<Long, Unit> function5 = function4;
                                    final CalendarDate calendarDate2 = calendarDate;
                                    final DatePickerFormatter datePickerFormatter3 = datePickerFormatter2;
                                    final SelectableDates selectableDates3 = selectableDates2;
                                    final DatePickerColors datePickerColors3 = datePickerColors2;
                                    final List<CustomAccessibilityAction> list = listCustomScrollActions;
                                    LazyListScope.CC.items$default(lazyListScope, iNumberOfMonthsInRange, null, null, ComposableLambdaKt.composableLambdaInstance(-1413501381, true, new Function4<LazyItemScope, Integer, Composer, Integer, Unit>() {
                                        {
                                            super(4);
                                        }

                                        public Object invoke(Object obj, Object obj2, Object obj3, Object obj4) {
                                            invoke((LazyItemScope) obj, ((Number) obj2).intValue(), (Composer) obj3, ((Number) obj4).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(LazyItemScope lazyItemScope, int i5, Composer composer4, int i6) {
                                            int i7;
                                            SelectedRangeInfo selectedRangeInfo;
                                            ComposerKt.sourceInformation(composer4, "C811@35861L2126:DateRangePicker.kt#uh7d8r");
                                            if ((i6 & 6) == 0) {
                                                i7 = i6 | (composer4.changed(lazyItemScope) ? 4 : 2);
                                            } else {
                                                i7 = i6;
                                            }
                                            if ((i6 & 48) == 0) {
                                                i7 |= composer4.changed(i5) ? 32 : 16;
                                            }
                                            if ((i7 & 147) != 146 || !composer4.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(-1413501381, i7, -1, "androidx.compose.material3.VerticalMonthsList.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DateRangePicker.kt:810)");
                                                }
                                                final CalendarMonth calendarMonthPlusMonths = calendarModel3.plusMonths(calendarMonth3, i5);
                                                Modifier modifierFillParentMaxWidth$default = LazyItemScope.CC.fillParentMaxWidth$default(lazyItemScope, Modifier.INSTANCE, 0.0f, 1, null);
                                                Long l9 = l7;
                                                Long l10 = l8;
                                                Function1<Long, Unit> function6 = function5;
                                                CalendarDate calendarDate3 = calendarDate2;
                                                final DatePickerFormatter datePickerFormatter4 = datePickerFormatter3;
                                                SelectableDates selectableDates4 = selectableDates3;
                                                final DatePickerColors datePickerColors4 = datePickerColors3;
                                                final List<CustomAccessibilityAction> list2 = list;
                                                CalendarModel calendarModel4 = calendarModel3;
                                                ComposerKt.sourceInformationMarkerStart(composer4, -483455358, "CC(Column)P(2,3,1)85@4251L61,86@4317L133:Column.kt#2w3rfo");
                                                MeasurePolicy measurePolicyColumnMeasurePolicy = ColumnKt.columnMeasurePolicy(Arrangement.INSTANCE.getTop(), Alignment.INSTANCE.getStart(), composer4, 0);
                                                ComposerKt.sourceInformationMarkerStart(composer4, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer4, 0);
                                                CompositionLocalMap currentCompositionLocalMap = composer4.getCurrentCompositionLocalMap();
                                                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer4, modifierFillParentMaxWidth$default);
                                                Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                                ComposerKt.sourceInformationMarkerStart(composer4, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                                if (!(composer4.getApplier() instanceof Applier)) {
                                                    ComposablesKt.invalidApplier();
                                                }
                                                composer4.startReusableNode();
                                                if (composer4.getInserting()) {
                                                    composer4.createNode(constructor);
                                                } else {
                                                    composer4.useNode();
                                                }
                                                Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer4);
                                                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyColumnMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                                if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                                }
                                                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                                ComposerKt.sourceInformationMarkerStart(composer4, -384862393, "C87@4365L9:Column.kt#2w3rfo");
                                                ColumnScopeInstance columnScopeInstance = ColumnScopeInstance.INSTANCE;
                                                ComposerKt.sourceInformationMarkerStart(composer4, 1460125673, "C812@36002L5,812@36009L623,812@35932L700,838@37423L546:DateRangePicker.kt#uh7d8r");
                                                TextKt.ProvideTextStyle(TypographyKt.getValue(DatePickerModalTokens.INSTANCE.getRangeSelectionMonthSubheadFont(), composer4, 6), ComposableLambdaKt.rememberComposableLambda(1622100276, true, new Function2<Composer, Integer, Unit>() {
                                                    {
                                                        super(2);
                                                    }

                                                    public Object invoke(Object obj, Object obj2) {
                                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                                        return Unit.INSTANCE;
                                                    }

                                                    public final void invoke(Composer composer5, int i8) {
                                                        ComposerKt.sourceInformation(composer5, "C817@36237L15,821@36475L45,813@36035L575:DateRangePicker.kt#uh7d8r");
                                                        if ((i8 & 3) != 2 || !composer5.getSkipping()) {
                                                            if (ComposerKt.isTraceInProgress()) {
                                                                ComposerKt.traceEventStart(1622100276, i8, -1, "androidx.compose.material3.VerticalMonthsList.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous>.<anonymous> (DateRangePicker.kt:813)");
                                                            }
                                                            String monthYear = datePickerFormatter4.formatMonthYear(Long.valueOf(calendarMonthPlusMonths.getStartUtcTimeMillis()), CalendarLocale_androidKt.defaultLocale(composer5, 0));
                                                            if (monthYear == null) {
                                                                monthYear = "-";
                                                            }
                                                            String str = monthYear;
                                                            Modifier modifierPadding = PaddingKt.padding(Modifier.INSTANCE, DateRangePickerKt.getCalendarMonthSubheadPadding());
                                                            ComposerKt.sourceInformationMarkerStart(composer5, -77497871, "CC(remember):DateRangePicker.kt#9igjgp");
                                                            boolean zChangedInstance2 = composer5.changedInstance(list2);
                                                            final List<CustomAccessibilityAction> list3 = list2;
                                                            Object objRememberedValue5 = composer5.rememberedValue();
                                                            if (zChangedInstance2 || objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                                                                objRememberedValue5 = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                                                                    {
                                                                        super(1);
                                                                    }

                                                                    public Object invoke(Object obj) {
                                                                        invoke((SemanticsPropertyReceiver) obj);
                                                                        return Unit.INSTANCE;
                                                                    }

                                                                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                                                        SemanticsPropertiesKt.setCustomActions(semanticsPropertyReceiver, list3);
                                                                    }
                                                                };
                                                                composer5.updateRememberedValue(objRememberedValue5);
                                                            }
                                                            ComposerKt.sourceInformationMarkerEnd(composer5);
                                                            TextKt.m3021Text4IGK_g(str, SemanticsModifierKt.semantics$default(modifierPadding, false, (Function1) objRememberedValue5, 1, null), datePickerColors4.getSubheadContentColor(), 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1<? super TextLayoutResult, Unit>) null, (TextStyle) null, composer5, 0, 0, 131064);
                                                            if (ComposerKt.isTraceInProgress()) {
                                                                ComposerKt.traceEventEnd();
                                                                return;
                                                            }
                                                            return;
                                                        }
                                                        composer5.skipToGroupEnd();
                                                    }
                                                }, composer4, 54), composer4, 48);
                                                composer4.startReplaceGroup(2125334733);
                                                ComposerKt.sourceInformation(composer4, "827@36822L488");
                                                if (l9 == null || l10 == null) {
                                                    selectedRangeInfo = null;
                                                } else {
                                                    ComposerKt.sourceInformationMarkerStart(composer4, 2125337741, "CC(remember):DateRangePicker.kt#9igjgp");
                                                    boolean zChanged3 = composer4.changed(l9) | composer4.changed(l10);
                                                    Object objRememberedValue5 = composer4.rememberedValue();
                                                    if (zChanged3 || objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                                                        objRememberedValue5 = SelectedRangeInfo.INSTANCE.calculateRangeInfo(calendarMonthPlusMonths, calendarModel4.getCanonicalDate(l9.longValue()), calendarModel4.getCanonicalDate(l10.longValue()));
                                                        composer4.updateRememberedValue(objRememberedValue5);
                                                    }
                                                    ComposerKt.sourceInformationMarkerEnd(composer4);
                                                    selectedRangeInfo = (SelectedRangeInfo) objRememberedValue5;
                                                }
                                                composer4.endReplaceGroup();
                                                DatePickerKt.Month(calendarMonthPlusMonths, function6, calendarDate3.getUtcTimeMillis(), l9, l10, selectedRangeInfo, datePickerFormatter4, selectableDates4, datePickerColors4, composer4, 0);
                                                ComposerKt.sourceInformationMarkerEnd(composer4);
                                                ComposerKt.sourceInformationMarkerEnd(composer4);
                                                composer4.endNode();
                                                ComposerKt.sourceInformationMarkerEnd(composer4);
                                                ComposerKt.sourceInformationMarkerEnd(composer4);
                                                ComposerKt.sourceInformationMarkerEnd(composer4);
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer4.skipToGroupEnd();
                                        }
                                    }), 6, null);
                                }
                            };
                            composer3.updateRememberedValue(objRememberedValue4);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composer3);
                        LazyDslKt.LazyColumn(modifierSemantics$default, lazyListState2, null, false, null, null, null, false, (Function1) objRememberedValue4, composer3, 0, 252);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                            return;
                        }
                        return;
                    }
                    composer3.skipToGroupEnd();
                }
            }, composerStartRestartGroup, 54), composerStartRestartGroup, 48);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2140016818, "CC(remember):DateRangePicker.kt#9igjgp");
            int i4 = i3 & 14;
            boolean zChangedInstance = (i4 == 4) | ((i3 & 57344) == 16384) | composerStartRestartGroup.changedInstance(calendarModel) | composerStartRestartGroup.changedInstance(intRange);
            DateRangePickerKt$VerticalMonthsList$2$1 dateRangePickerKt$VerticalMonthsList$2$1RememberedValue = composerStartRestartGroup.rememberedValue();
            if (zChangedInstance || dateRangePickerKt$VerticalMonthsList$2$1RememberedValue == Composer.INSTANCE.getEmpty()) {
                dateRangePickerKt$VerticalMonthsList$2$1RememberedValue = new DateRangePickerKt$VerticalMonthsList$2$1(lazyListState, function1, calendarModel, intRange, null);
                composerStartRestartGroup.updateRememberedValue(dateRangePickerKt$VerticalMonthsList$2$1RememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composer2 = composerStartRestartGroup;
            EffectsKt.LaunchedEffect(lazyListState, (Function2<? super CoroutineScope, ? super Continuation<? super Unit>, ? extends Object>) dateRangePickerKt$VerticalMonthsList$2$1RememberedValue, composer2, i4);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        } else {
            composerStartRestartGroup.skipToGroupEnd();
            composer2 = composerStartRestartGroup;
        }
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup = composer2.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer3, int i5) {
                    DateRangePickerKt.VerticalMonthsList(lazyListState, l, l2, function2, function1, calendarModel, intRange, datePickerFormatter, selectableDates, datePickerColors, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1));
                }
            });
        }
    }

    public static final void updateDateSelection(long j, Long l, Long l2, Function2<? super Long, ? super Long, Unit> function2) {
        if ((l == null && l2 == null) || (l != null && l2 != null)) {
            function2.invoke(Long.valueOf(j), (Object) null);
        } else if (l != null && j >= l.longValue()) {
            function2.invoke(l, Long.valueOf(j));
        } else {
            function2.invoke(Long.valueOf(j), (Object) null);
        }
    }

    public static final PaddingValues getCalendarMonthSubheadPadding() {
        return CalendarMonthSubheadPadding;
    }

    public static final void m2311drawRangeBackgroundmxwnekA(ContentDrawScope contentDrawScope, SelectedRangeInfo selectedRangeInfo, long j) {
        float fM4415getWidthimpl;
        float f = contentDrawScope.toPx-0680j_4(DatePickerKt.getRecommendedSizeForAccessibility());
        float f2 = contentDrawScope.toPx-0680j_4(DatePickerKt.getRecommendedSizeForAccessibility());
        float f3 = contentDrawScope.toPx-0680j_4(DatePickerModalTokens.INSTANCE.m3508getDateStateLayerHeightD9Ej5fM());
        float f4 = 2;
        float f5 = (f2 - f3) / f4;
        float f6 = 7;
        float fM4415getWidthimpl2 = (Size.m4415getWidthimpl(contentDrawScope.mo5083getSizeNHjbRc()) - (f6 * f)) / f6;
        long gridStartCoordinates = selectedRangeInfo.getGridStartCoordinates();
        int i = IntOffset.getX-impl(gridStartCoordinates);
        int i2 = IntOffset.getY-impl(gridStartCoordinates);
        long gridEndCoordinates = selectedRangeInfo.getGridEndCoordinates();
        int i3 = IntOffset.getX-impl(gridEndCoordinates);
        int i4 = IntOffset.getY-impl(gridEndCoordinates);
        float f7 = f + fM4415getWidthimpl2;
        float f8 = fM4415getWidthimpl2 / f4;
        float fM4415getWidthimpl3 = (i * f7) + (selectedRangeInfo.getFirstIsSelectionStart() ? f / f4 : 0.0f) + f8;
        float f9 = (i2 * f2) + f5;
        float f10 = i3 * f7;
        if (selectedRangeInfo.getLastIsSelectionEnd()) {
            f /= f4;
        }
        float fM4415getWidthimpl4 = f10 + f + f8;
        float f11 = (i4 * f2) + f5;
        boolean z = contentDrawScope.getLayoutDirection() == LayoutDirection.Rtl;
        if (z) {
            fM4415getWidthimpl3 = Size.m4415getWidthimpl(contentDrawScope.mo5083getSizeNHjbRc()) - fM4415getWidthimpl3;
            fM4415getWidthimpl4 = Size.m4415getWidthimpl(contentDrawScope.mo5083getSizeNHjbRc()) - fM4415getWidthimpl4;
        }
        ContentDrawScope contentDrawScope2 = contentDrawScope;
        long jOffset = OffsetKt.Offset(fM4415getWidthimpl3, f9);
        if (i2 == i4) {
            fM4415getWidthimpl = fM4415getWidthimpl4 - fM4415getWidthimpl3;
        } else {
            fM4415getWidthimpl = z ? -fM4415getWidthimpl3 : Size.m4415getWidthimpl(contentDrawScope.mo5083getSizeNHjbRc()) - fM4415getWidthimpl3;
        }
        DrawScope.CC.m5180drawRectnJ9OG0$default(contentDrawScope2, j, jOffset, SizeKt.Size(fM4415getWidthimpl, f3), 0.0f, null, null, 0, MenuKt.InTransitionDuration, null);
        if (i2 != i4) {
            for (int i5 = (i4 - i2) - 1; i5 > 0; i5--) {
                DrawScope.CC.m5180drawRectnJ9OG0$default(contentDrawScope2, j, OffsetKt.Offset(0.0f, (i5 * f2) + f9), SizeKt.Size(Size.m4415getWidthimpl(contentDrawScope.mo5083getSizeNHjbRc()), f3), 0.0f, null, null, 0, MenuKt.InTransitionDuration, null);
            }
            long jOffset2 = OffsetKt.Offset(contentDrawScope.getLayoutDirection() != LayoutDirection.Ltr ? Size.m4415getWidthimpl(contentDrawScope.mo5083getSizeNHjbRc()) : 0.0f, f11);
            if (z) {
                fM4415getWidthimpl4 -= Size.m4415getWidthimpl(contentDrawScope.mo5083getSizeNHjbRc());
            }
            DrawScope.CC.m5180drawRectnJ9OG0$default(contentDrawScope2, j, jOffset2, SizeKt.Size(fM4415getWidthimpl4, f3), 0.0f, null, null, 0, MenuKt.InTransitionDuration, null);
        }
    }

    public static final List<CustomAccessibilityAction> customScrollActions(final LazyListState lazyListState, final CoroutineScope coroutineScope, String str, String str2) {
        return CollectionsKt.listOf(new CustomAccessibilityAction[]{new CustomAccessibilityAction(str, new Function0<Boolean>() {
            {
                super(0);
            }

            public final Boolean m2318invoke() {
                boolean z;
                if (lazyListState.getCanScrollBackward()) {
                    BuildersKt.launch$default(coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new C11651(lazyListState, null), 3, (Object) null);
                    z = true;
                } else {
                    z = false;
                }
                return Boolean.valueOf(z);
            }

            @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
            @DebugMetadata(c = "androidx.compose.material3.DateRangePickerKt$customScrollActions$scrollUpAction$1$1", f = "DateRangePicker.kt", i = {}, l = {1046}, m = "invokeSuspend", n = {}, s = {})
            static final class C11651 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                final LazyListState $state;
                int label;

                C11651(LazyListState lazyListState, Continuation<? super C11651> continuation) {
                    super(2, continuation);
                    this.$state = lazyListState;
                }

                public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                    return new C11651(this.$state, continuation);
                }

                public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                    return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
                }

                public final Object invokeSuspend(Object obj) {
                    Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                    int i = this.label;
                    if (i == 0) {
                        ResultKt.throwOnFailure(obj);
                        LazyListState lazyListState = this.$state;
                        this.label = 1;
                        if (LazyListState.scrollToItem$default(lazyListState, lazyListState.getFirstVisibleItemIndex() - 1, 0, (Continuation) this, 2, null) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                    } else {
                        if (i != 1) {
                            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                        }
                        ResultKt.throwOnFailure(obj);
                    }
                    return Unit.INSTANCE;
                }
            }
        }), new CustomAccessibilityAction(str2, new Function0<Boolean>() {
            {
                super(0);
            }

            public final Boolean m2317invoke() {
                boolean z;
                if (lazyListState.getCanScrollForward()) {
                    BuildersKt.launch$default(coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new C11641(lazyListState, null), 3, (Object) null);
                    z = true;
                } else {
                    z = false;
                }
                return Boolean.valueOf(z);
            }

            @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
            @DebugMetadata(c = "androidx.compose.material3.DateRangePickerKt$customScrollActions$scrollDownAction$1$1", f = "DateRangePicker.kt", i = {}, l = {1054}, m = "invokeSuspend", n = {}, s = {})
            static final class C11641 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                final LazyListState $state;
                int label;

                C11641(LazyListState lazyListState, Continuation<? super C11641> continuation) {
                    super(2, continuation);
                    this.$state = lazyListState;
                }

                public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                    return new C11641(this.$state, continuation);
                }

                public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                    return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
                }

                public final Object invokeSuspend(Object obj) {
                    Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                    int i = this.label;
                    if (i == 0) {
                        ResultKt.throwOnFailure(obj);
                        LazyListState lazyListState = this.$state;
                        this.label = 1;
                        if (LazyListState.scrollToItem$default(lazyListState, lazyListState.getFirstVisibleItemIndex() + 1, 0, (Continuation) this, 2, null) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                    } else {
                        if (i != 1) {
                            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                        }
                        ResultKt.throwOnFailure(obj);
                    }
                    return Unit.INSTANCE;
                }
            }
        })});
    }

    static {
        float f = 64;
        float f2 = 12;
        DateRangePickerTitlePadding = PaddingKt.m1032PaddingValuesa9UjIt4$default(Dp.constructor-impl(f), 0.0f, Dp.constructor-impl(f2), 0.0f, 10, null);
        DateRangePickerHeadlinePadding = PaddingKt.m1032PaddingValuesa9UjIt4$default(Dp.constructor-impl(f), 0.0f, Dp.constructor-impl(f2), Dp.constructor-impl(f2), 2, null);
    }
}
