package androidx.compose.material3.internal;

import androidx.compose.material3.C1305R;
import androidx.compose.p002ui.C1597R;
import kotlin.Metadata;
import kotlin.jvm.JvmInline;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0005\n\u0002\u0010\u000b\n\u0002\b\u0006\n\u0002\u0010\u000e\n\u0002\b\u0004\b\u0081@\u0018\u0000 \u00132\u00020\u0001:\u0001\u0013B\u000f\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0004\b\u0004\u0010\u0005J\u001a\u0010\b\u001a\u00020\t2\b\u0010\n\u001a\u0004\u0018\u00010\u0001HÖ\u0003¢\u0006\u0004\b\u000b\u0010\fJ\u0010\u0010\r\u001a\u00020\u0003HÖ\u0001¢\u0006\u0004\b\u000e\u0010\u0005J\u0010\u0010\u000f\u001a\u00020\u0010HÖ\u0001¢\u0006\u0004\b\u0011\u0010\u0012R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007\u0088\u0001\u0002¨\u0006\u0014"}, d2 = {"Landroidx/compose/material3/internal/Strings;", "", "value", "", "constructor-impl", "(I)I", "getValue", "()I", "equals", "", "other", "equals-impl", "(ILjava/lang/Object;)Z", "hashCode", "hashCode-impl", "toString", "", "toString-impl", "(I)Ljava/lang/String;", "Companion", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
@JvmInline
public final class Strings {

    public static final Companion INSTANCE = new Companion(null);
    private final int value;

    public static final Strings m3263boximpl(int i) {
        return new Strings(i);
    }

    public static int m3264constructorimpl(int i) {
        return i;
    }

    public static boolean m3265equalsimpl(int i, Object obj) {
        return (obj instanceof Strings) && i == ((Strings) obj).m3269unboximpl();
    }

    public static final boolean m3266equalsimpl0(int i, int i2) {
        return i == i2;
    }

    public static int m3267hashCodeimpl(int i) {
        return i;
    }

    public static String m3268toStringimpl(int i) {
        return "Strings(value=" + i + ')';
    }

    public boolean equals(Object obj) {
        return m3265equalsimpl(this.value, obj);
    }

    public int hashCode() {
        return m3267hashCodeimpl(this.value);
    }

    public String toString() {
        return m3268toStringimpl(this.value);
    }

    public final int m3269unboximpl() {
        return this.value;
    }

    @Metadata(d1 = {"\u0000\u0015\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0003\b\u0081\u0001\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u0018\u0010\u0003\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\u0005\u0010\u0006R\u0018\u0010\u0007\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\b\u0010\u0006R\u0018\u0010\t\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\n\u0010\u0006R\u0018\u0010\u000b\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\f\u0010\u0006R\u0018\u0010\r\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\u000e\u0010\u0006R\u0018\u0010\u000f\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\u0010\u0010\u0006R\u0018\u0010\u0011\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\u0012\u0010\u0006R\u0018\u0010\u0013\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\u0014\u0010\u0006R\u0018\u0010\u0015\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\u0016\u0010\u0006R\u0018\u0010\u0017\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\u0018\u0010\u0006R\u0018\u0010\u0019\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\u001a\u0010\u0006R\u0018\u0010\u001b\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\u001c\u0010\u0006R\u0018\u0010\u001d\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\u001e\u0010\u0006R\u0018\u0010\u001f\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b \u0010\u0006R\u0018\u0010!\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\"\u0010\u0006R\u0018\u0010#\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b$\u0010\u0006R\u0018\u0010%\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b&\u0010\u0006R\u0018\u0010'\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b(\u0010\u0006R\u0018\u0010)\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b*\u0010\u0006R\u0018\u0010+\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b,\u0010\u0006R\u0018\u0010-\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b.\u0010\u0006R\u0018\u0010/\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b0\u0010\u0006R\u0018\u00101\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b2\u0010\u0006R\u0018\u00103\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b4\u0010\u0006R\u0018\u00105\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b6\u0010\u0006R\u0018\u00107\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b8\u0010\u0006R\u0018\u00109\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b:\u0010\u0006R\u0018\u0010;\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b<\u0010\u0006R\u0018\u0010=\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b>\u0010\u0006R\u0018\u0010?\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b@\u0010\u0006R\u0018\u0010A\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\bB\u0010\u0006R\u0018\u0010C\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\bD\u0010\u0006R\u0018\u0010E\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\bF\u0010\u0006R\u0018\u0010G\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\bH\u0010\u0006R\u0018\u0010I\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\bJ\u0010\u0006R\u0018\u0010K\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\bL\u0010\u0006R\u0018\u0010M\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\bN\u0010\u0006R\u0018\u0010O\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\bP\u0010\u0006R\u0018\u0010Q\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\bR\u0010\u0006R\u0018\u0010S\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\bT\u0010\u0006R\u0018\u0010U\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\bV\u0010\u0006R\u0018\u0010W\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\bX\u0010\u0006R\u0018\u0010Y\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\bZ\u0010\u0006R\u0018\u0010[\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\\\u0010\u0006R\u0018\u0010]\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b^\u0010\u0006R\u0018\u0010_\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b`\u0010\u0006R\u0018\u0010a\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\bb\u0010\u0006R\u0018\u0010c\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\bd\u0010\u0006R\u0018\u0010e\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\bf\u0010\u0006R\u0018\u0010g\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\bh\u0010\u0006R\u0018\u0010i\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\bj\u0010\u0006R\u0018\u0010k\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\bl\u0010\u0006R\u0018\u0010m\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\bn\u0010\u0006R\u0018\u0010o\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\bp\u0010\u0006R\u0018\u0010q\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\br\u0010\u0006R\u0018\u0010s\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\bt\u0010\u0006R\u0018\u0010u\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\bv\u0010\u0006R\u0018\u0010w\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\bx\u0010\u0006R\u0018\u0010y\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\bz\u0010\u0006R\u0018\u0010{\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b|\u0010\u0006R\u0018\u0010}\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b~\u0010\u0006R\u0019\u0010\u007f\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0007\u001a\u0005\b\u0080\u0001\u0010\u0006R\u001a\u0010\u0081\u0001\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0007\u001a\u0005\b\u0082\u0001\u0010\u0006R\u001a\u0010\u0083\u0001\u001a\u00020\u00048Æ\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0007\u001a\u0005\b\u0084\u0001\u0010\u0006\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u0085\u0001"}, d2 = {"Landroidx/compose/material3/internal/Strings$Companion;", "", "()V", "BottomSheetDismissDescription", "Landroidx/compose/material3/internal/Strings;", "getBottomSheetDismissDescription-8iCLdWM", "()I", "BottomSheetDragHandleDescription", "getBottomSheetDragHandleDescription-8iCLdWM", "BottomSheetExpandDescription", "getBottomSheetExpandDescription-8iCLdWM", "BottomSheetPaneTitle", "getBottomSheetPaneTitle-8iCLdWM", "BottomSheetPartialExpandDescription", "getBottomSheetPartialExpandDescription-8iCLdWM", "CloseDrawer", "getCloseDrawer-8iCLdWM", "CloseSheet", "getCloseSheet-8iCLdWM", "DateInputHeadline", "getDateInputHeadline-8iCLdWM", "DateInputHeadlineDescription", "getDateInputHeadlineDescription-8iCLdWM", "DateInputInvalidForPattern", "getDateInputInvalidForPattern-8iCLdWM", "DateInputInvalidNotAllowed", "getDateInputInvalidNotAllowed-8iCLdWM", "DateInputInvalidYearRange", "getDateInputInvalidYearRange-8iCLdWM", "DateInputLabel", "getDateInputLabel-8iCLdWM", "DateInputNoInputDescription", "getDateInputNoInputDescription-8iCLdWM", "DateInputTitle", "getDateInputTitle-8iCLdWM", "DatePickerHeadline", "getDatePickerHeadline-8iCLdWM", "DatePickerHeadlineDescription", "getDatePickerHeadlineDescription-8iCLdWM", "DatePickerNavigateToYearDescription", "getDatePickerNavigateToYearDescription-8iCLdWM", "DatePickerNoSelectionDescription", "getDatePickerNoSelectionDescription-8iCLdWM", "DatePickerScrollToShowEarlierYears", "getDatePickerScrollToShowEarlierYears-8iCLdWM", "DatePickerScrollToShowLaterYears", "getDatePickerScrollToShowLaterYears-8iCLdWM", "DatePickerSwitchToCalendarMode", "getDatePickerSwitchToCalendarMode-8iCLdWM", "DatePickerSwitchToDaySelection", "getDatePickerSwitchToDaySelection-8iCLdWM", "DatePickerSwitchToInputMode", "getDatePickerSwitchToInputMode-8iCLdWM", "DatePickerSwitchToNextMonth", "getDatePickerSwitchToNextMonth-8iCLdWM", "DatePickerSwitchToPreviousMonth", "getDatePickerSwitchToPreviousMonth-8iCLdWM", "DatePickerSwitchToYearSelection", "getDatePickerSwitchToYearSelection-8iCLdWM", "DatePickerTitle", "getDatePickerTitle-8iCLdWM", "DatePickerTodayDescription", "getDatePickerTodayDescription-8iCLdWM", "DatePickerYearPickerPaneTitle", "getDatePickerYearPickerPaneTitle-8iCLdWM", "DateRangeInputInvalidRangeInput", "getDateRangeInputInvalidRangeInput-8iCLdWM", "DateRangeInputTitle", "getDateRangeInputTitle-8iCLdWM", "DateRangePickerDayInRange", "getDateRangePickerDayInRange-8iCLdWM", "DateRangePickerEndHeadline", "getDateRangePickerEndHeadline-8iCLdWM", "DateRangePickerScrollToShowNextMonth", "getDateRangePickerScrollToShowNextMonth-8iCLdWM", "DateRangePickerScrollToShowPreviousMonth", "getDateRangePickerScrollToShowPreviousMonth-8iCLdWM", "DateRangePickerStartHeadline", "getDateRangePickerStartHeadline-8iCLdWM", "DateRangePickerTitle", "getDateRangePickerTitle-8iCLdWM", "DefaultErrorMessage", "getDefaultErrorMessage-8iCLdWM", "Dialog", "getDialog-8iCLdWM", "ExposedDropdownMenu", "getExposedDropdownMenu-8iCLdWM", "MenuCollapsed", "getMenuCollapsed-8iCLdWM", "MenuExpanded", "getMenuExpanded-8iCLdWM", "NavigationMenu", "getNavigationMenu-8iCLdWM", "SearchBarSearch", "getSearchBarSearch-8iCLdWM", "SliderRangeEnd", "getSliderRangeEnd-8iCLdWM", "SliderRangeStart", "getSliderRangeStart-8iCLdWM", "SnackbarDismiss", "getSnackbarDismiss-8iCLdWM", "SuggestionsAvailable", "getSuggestionsAvailable-8iCLdWM", "TimePicker24HourSuffix", "getTimePicker24HourSuffix-8iCLdWM", "TimePickerAM", "getTimePickerAM-8iCLdWM", "TimePickerHour", "getTimePickerHour-8iCLdWM", "TimePickerHourSelection", "getTimePickerHourSelection-8iCLdWM", "TimePickerHourSuffix", "getTimePickerHourSuffix-8iCLdWM", "TimePickerHourTextField", "getTimePickerHourTextField-8iCLdWM", "TimePickerMinute", "getTimePickerMinute-8iCLdWM", "TimePickerMinuteSelection", "getTimePickerMinuteSelection-8iCLdWM", "TimePickerMinuteSuffix", "getTimePickerMinuteSuffix-8iCLdWM", "TimePickerMinuteTextField", "getTimePickerMinuteTextField-8iCLdWM", "TimePickerPM", "getTimePickerPM-8iCLdWM", "TimePickerPeriodToggle", "getTimePickerPeriodToggle-8iCLdWM", "ToggleDropdownMenu", "getToggleDropdownMenu-8iCLdWM", "TooltipLongPressLabel", "getTooltipLongPressLabel-8iCLdWM", "TooltipPaneDescription", "getTooltipPaneDescription-8iCLdWM", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final int m3308getDefaultErrorMessage8iCLdWM() {
            return Strings.m3264constructorimpl(C1597R.string.default_error_message);
        }

        public final int m3310getExposedDropdownMenu8iCLdWM() {
            return Strings.m3264constructorimpl(C1597R.string.dropdown_menu);
        }

        public final int m3316getSliderRangeStart8iCLdWM() {
            return Strings.m3264constructorimpl(C1597R.string.range_start);
        }

        public final int m3315getSliderRangeEnd8iCLdWM() {
            return Strings.m3264constructorimpl(C1597R.string.range_end);
        }

        public final int m3309getDialog8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_dialog);
        }

        public final int m3312getMenuExpanded8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_dropdown_menu_expanded);
        }

        public final int m3311getMenuCollapsed8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_dropdown_menu_collapsed);
        }

        public final int m3331getToggleDropdownMenu8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_dropdown_menu_toggle);
        }

        public final int m3317getSnackbarDismiss8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_snackbar_dismiss);
        }

        public final int m3314getSearchBarSearch8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_search_bar_search);
        }

        public final int m3318getSuggestionsAvailable8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_suggestions_available);
        }

        public final int m3297getDatePickerTitle8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_date_picker_title);
        }

        public final int m3285getDatePickerHeadline8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_date_picker_headline);
        }

        public final int m3299getDatePickerYearPickerPaneTitle8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_date_picker_year_picker_pane_title);
        }

        public final int m3296getDatePickerSwitchToYearSelection8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_date_picker_switch_to_year_selection);
        }

        public final int m3292getDatePickerSwitchToDaySelection8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_date_picker_switch_to_day_selection);
        }

        public final int m3294getDatePickerSwitchToNextMonth8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_date_picker_switch_to_next_month);
        }

        public final int m3295getDatePickerSwitchToPreviousMonth8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_date_picker_switch_to_previous_month);
        }

        public final int m3287getDatePickerNavigateToYearDescription8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_date_picker_navigate_to_year_description);
        }

        public final int m3286getDatePickerHeadlineDescription8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_date_picker_headline_description);
        }

        public final int m3288getDatePickerNoSelectionDescription8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_date_picker_no_selection_description);
        }

        public final int m3298getDatePickerTodayDescription8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_date_picker_today_description);
        }

        public final int m3290getDatePickerScrollToShowLaterYears8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_date_picker_scroll_to_later_years);
        }

        public final int m3289getDatePickerScrollToShowEarlierYears8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_date_picker_scroll_to_earlier_years);
        }

        public final int m3284getDateInputTitle8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_date_input_title);
        }

        public final int m3277getDateInputHeadline8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_date_input_headline);
        }

        public final int m3282getDateInputLabel8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_date_input_label);
        }

        public final int m3278getDateInputHeadlineDescription8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_date_input_headline_description);
        }

        public final int m3283getDateInputNoInputDescription8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_date_input_no_input_description);
        }

        public final int m3280getDateInputInvalidNotAllowed8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_date_input_invalid_not_allowed);
        }

        public final int m3279getDateInputInvalidForPattern8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_date_input_invalid_for_pattern);
        }

        public final int m3281getDateInputInvalidYearRange8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_date_input_invalid_year_range);
        }

        public final int m3291getDatePickerSwitchToCalendarMode8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_date_picker_switch_to_calendar_mode);
        }

        public final int m3293getDatePickerSwitchToInputMode8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_date_picker_switch_to_input_mode);
        }

        public final int m3307getDateRangePickerTitle8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_date_range_picker_title);
        }

        public final int m3306getDateRangePickerStartHeadline8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_date_range_picker_start_headline);
        }

        public final int m3303getDateRangePickerEndHeadline8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_date_range_picker_end_headline);
        }

        public final int m3304getDateRangePickerScrollToShowNextMonth8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_date_range_picker_scroll_to_next_month);
        }

        public final int m3305getDateRangePickerScrollToShowPreviousMonth8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_date_range_picker_scroll_to_previous_month);
        }

        public final int m3302getDateRangePickerDayInRange8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_date_range_picker_day_in_range);
        }

        public final int m3301getDateRangeInputTitle8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_date_range_input_title);
        }

        public final int m3300getDateRangeInputInvalidRangeInput8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_date_range_input_invalid_range_input);
        }

        public final int m3273getBottomSheetPaneTitle8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_bottom_sheet_pane_title);
        }

        public final int m3271getBottomSheetDragHandleDescription8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_bottom_sheet_drag_handle_description);
        }

        public final int m3274getBottomSheetPartialExpandDescription8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_bottom_sheet_collapse_description);
        }

        public final int m3270getBottomSheetDismissDescription8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_bottom_sheet_dismiss_description);
        }

        public final int m3272getBottomSheetExpandDescription8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_bottom_sheet_expand_description);
        }

        public final int m3332getTooltipLongPressLabel8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_tooltip_long_press_label);
        }

        public final int m3320getTimePickerAM8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_time_picker_am);
        }

        public final int m3329getTimePickerPM8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_time_picker_pm);
        }

        public final int m3330getTimePickerPeriodToggle8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_time_picker_period_toggle_description);
        }

        public final int m3326getTimePickerMinuteSelection8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_time_picker_minute_selection);
        }

        public final int m3322getTimePickerHourSelection8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_time_picker_hour_selection);
        }

        public final int m3323getTimePickerHourSuffix8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_time_picker_hour_suffix);
        }

        public final int m3327getTimePickerMinuteSuffix8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_time_picker_minute_suffix);
        }

        public final int m3319getTimePicker24HourSuffix8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_time_picker_hour_24h_suffix);
        }

        public final int m3321getTimePickerHour8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_time_picker_hour);
        }

        public final int m3325getTimePickerMinute8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_time_picker_minute);
        }

        public final int m3324getTimePickerHourTextField8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_time_picker_hour_text_field);
        }

        public final int m3328getTimePickerMinuteTextField8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_time_picker_minute_text_field);
        }

        public final int m3333getTooltipPaneDescription8iCLdWM() {
            return Strings.m3264constructorimpl(C1305R.string.m3c_tooltip_pane_description);
        }

        public final int m3313getNavigationMenu8iCLdWM() {
            return Strings.m3264constructorimpl(C1597R.string.navigation_menu);
        }

        public final int m3275getCloseDrawer8iCLdWM() {
            return Strings.m3264constructorimpl(C1597R.string.close_drawer);
        }

        public final int m3276getCloseSheet8iCLdWM() {
            return Strings.m3264constructorimpl(C1597R.string.close_sheet);
        }
    }

    private Strings(int i) {
        this.value = i;
    }

    public final int getValue() {
        return this.value;
    }
}
