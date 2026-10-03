package androidx.compose.material3;

import androidx.compose.animation.SingleValueAnimationKt;
import androidx.compose.animation.core.AnimationSpecKt;
import androidx.compose.p002ui.graphics.Color;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.SnapshotStateKt;
import androidx.compose.runtime.State;
import kotlin.Metadata;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u00008\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0018\n\u0002\u0018\u0002\n\u0002\b!\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u000b\n\u0002\u0010\b\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0007\u0018\u00002\u00020\u0001BÍ\u0001\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0003\u0012\u0006\u0010\u0006\u001a\u00020\u0003\u0012\u0006\u0010\u0007\u001a\u00020\u0003\u0012\u0006\u0010\b\u001a\u00020\u0003\u0012\u0006\u0010\t\u001a\u00020\u0003\u0012\u0006\u0010\n\u001a\u00020\u0003\u0012\u0006\u0010\u000b\u001a\u00020\u0003\u0012\u0006\u0010\f\u001a\u00020\u0003\u0012\u0006\u0010\r\u001a\u00020\u0003\u0012\u0006\u0010\u000e\u001a\u00020\u0003\u0012\u0006\u0010\u000f\u001a\u00020\u0003\u0012\u0006\u0010\u0010\u001a\u00020\u0003\u0012\u0006\u0010\u0011\u001a\u00020\u0003\u0012\u0006\u0010\u0012\u001a\u00020\u0003\u0012\u0006\u0010\u0013\u001a\u00020\u0003\u0012\u0006\u0010\u0014\u001a\u00020\u0003\u0012\u0006\u0010\u0015\u001a\u00020\u0003\u0012\u0006\u0010\u0016\u001a\u00020\u0003\u0012\u0006\u0010\u0017\u001a\u00020\u0003\u0012\u0006\u0010\u0018\u001a\u00020\u0003\u0012\u0006\u0010\u0019\u001a\u00020\u0003\u0012\u0006\u0010\u001a\u001a\u00020\u0003\u0012\u0006\u0010\u001b\u001a\u00020\u001c¢\u0006\u0002\u0010\u001dJ\u008c\u0002\u0010:\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u00032\b\b\u0002\u0010\u0006\u001a\u00020\u00032\b\b\u0002\u0010\u0007\u001a\u00020\u00032\b\b\u0002\u0010\b\u001a\u00020\u00032\b\b\u0002\u0010\t\u001a\u00020\u00032\b\b\u0002\u0010\n\u001a\u00020\u00032\b\b\u0002\u0010\u000b\u001a\u00020\u00032\b\b\u0002\u0010\f\u001a\u00020\u00032\b\b\u0002\u0010\r\u001a\u00020\u00032\b\b\u0002\u0010\u000e\u001a\u00020\u00032\b\b\u0002\u0010\u000f\u001a\u00020\u00032\b\b\u0002\u0010\u0010\u001a\u00020\u00032\b\b\u0002\u0010\u0011\u001a\u00020\u00032\b\b\u0002\u0010\u0012\u001a\u00020\u00032\b\b\u0002\u0010\u0013\u001a\u00020\u00032\b\b\u0002\u0010\u0014\u001a\u00020\u00032\b\b\u0002\u0010\u0015\u001a\u00020\u00032\b\b\u0002\u0010\u0016\u001a\u00020\u00032\b\b\u0002\u0010\u0017\u001a\u00020\u00032\b\b\u0002\u0010\u0018\u001a\u00020\u00032\b\b\u0002\u0010\u0019\u001a\u00020\u00032\b\b\u0002\u0010\u001a\u001a\u00020\u00032\n\b\u0002\u0010\u001b\u001a\u0004\u0018\u00010\u001cø\u0001\u0000¢\u0006\u0004\b;\u0010<J-\u0010=\u001a\b\u0012\u0004\u0012\u00020\u00030>2\u0006\u0010?\u001a\u00020@2\u0006\u0010A\u001a\u00020@2\u0006\u0010B\u001a\u00020@H\u0001¢\u0006\u0004\bC\u0010DJ5\u0010\u0010\u001a\b\u0012\u0004\u0012\u00020\u00030>2\u0006\u0010E\u001a\u00020@2\u0006\u0010?\u001a\u00020@2\u0006\u0010F\u001a\u00020@2\u0006\u0010A\u001a\u00020@H\u0001¢\u0006\u0004\bG\u0010HJ\u0013\u0010I\u001a\u00020@2\b\u0010J\u001a\u0004\u0018\u00010\u0001H\u0096\u0002J\b\u0010K\u001a\u00020LH\u0016J%\u0010M\u001a\b\u0012\u0004\u0012\u00020\u00030>2\u0006\u0010?\u001a\u00020@2\u0006\u0010A\u001a\u00020@H\u0001¢\u0006\u0004\bN\u0010OJ-\u0010\t\u001a\b\u0012\u0004\u0012\u00020\u00030>2\u0006\u0010P\u001a\u00020@2\u0006\u0010?\u001a\u00020@2\u0006\u0010A\u001a\u00020@H\u0001¢\u0006\u0004\bQ\u0010DJ!\u0010R\u001a\u00020\u001c*\u0004\u0018\u00010\u001c2\f\u0010S\u001a\b\u0012\u0004\u0012\u00020\u001c0TH\u0000¢\u0006\u0002\bUR\u0019\u0010\u0002\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010 \u001a\u0004\b\u001e\u0010\u001fR\u0019\u0010\u000b\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010 \u001a\u0004\b!\u0010\u001fR\u0011\u0010\u001b\u001a\u00020\u001c¢\u0006\b\n\u0000\u001a\u0004\b\"\u0010#R\u0019\u0010\u0010\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010 \u001a\u0004\b$\u0010\u001fR\u0019\u0010\u0018\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010 \u001a\u0004\b%\u0010\u001fR\u0019\u0010\u0019\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010 \u001a\u0004\b&\u0010\u001fR\u0019\u0010\u0011\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010 \u001a\u0004\b'\u0010\u001fR\u0019\u0010\u0015\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010 \u001a\u0004\b(\u0010\u001fR\u0019\u0010\u0013\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010 \u001a\u0004\b)\u0010\u001fR\u0019\u0010\u000f\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010 \u001a\u0004\b*\u0010\u001fR\u0019\u0010\r\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010 \u001a\u0004\b+\u0010\u001fR\u0019\u0010\n\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010 \u001a\u0004\b,\u0010\u001fR\u0019\u0010\u001a\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010 \u001a\u0004\b-\u0010\u001fR\u0019\u0010\u0005\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010 \u001a\u0004\b.\u0010\u001fR\u0019\u0010\b\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010 \u001a\u0004\b/\u0010\u001fR\u0019\u0010\u0014\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010 \u001a\u0004\b0\u0010\u001fR\u0019\u0010\u0012\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010 \u001a\u0004\b1\u0010\u001fR\u0019\u0010\u000e\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010 \u001a\u0004\b2\u0010\u001fR\u0019\u0010\f\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010 \u001a\u0004\b3\u0010\u001fR\u0019\u0010\u0007\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010 \u001a\u0004\b4\u0010\u001fR\u0019\u0010\u0004\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010 \u001a\u0004\b5\u0010\u001fR\u0019\u0010\u0016\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010 \u001a\u0004\b6\u0010\u001fR\u0019\u0010\u0017\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010 \u001a\u0004\b7\u0010\u001fR\u0019\u0010\u0006\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010 \u001a\u0004\b8\u0010\u001fR\u0019\u0010\t\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010 \u001a\u0004\b9\u0010\u001f\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006V"}, d2 = {"Landroidx/compose/material3/DatePickerColors;", "", "containerColor", "Landroidx/compose/ui/graphics/Color;", "titleContentColor", "headlineContentColor", "weekdayContentColor", "subheadContentColor", "navigationContentColor", "yearContentColor", "disabledYearContentColor", "currentYearContentColor", "selectedYearContentColor", "disabledSelectedYearContentColor", "selectedYearContainerColor", "disabledSelectedYearContainerColor", "dayContentColor", "disabledDayContentColor", "selectedDayContentColor", "disabledSelectedDayContentColor", "selectedDayContainerColor", "disabledSelectedDayContainerColor", "todayContentColor", "todayDateBorderColor", "dayInSelectionRangeContainerColor", "dayInSelectionRangeContentColor", "dividerColor", "dateTextFieldColors", "Landroidx/compose/material3/TextFieldColors;", "(JJJJJJJJJJJJJJJJJJJJJJJJLandroidx/compose/material3/TextFieldColors;Lkotlin/jvm/internal/DefaultConstructorMarker;)V", "getContainerColor-0d7_KjU", "()J", "J", "getCurrentYearContentColor-0d7_KjU", "getDateTextFieldColors", "()Landroidx/compose/material3/TextFieldColors;", "getDayContentColor-0d7_KjU", "getDayInSelectionRangeContainerColor-0d7_KjU", "getDayInSelectionRangeContentColor-0d7_KjU", "getDisabledDayContentColor-0d7_KjU", "getDisabledSelectedDayContainerColor-0d7_KjU", "getDisabledSelectedDayContentColor-0d7_KjU", "getDisabledSelectedYearContainerColor-0d7_KjU", "getDisabledSelectedYearContentColor-0d7_KjU", "getDisabledYearContentColor-0d7_KjU", "getDividerColor-0d7_KjU", "getHeadlineContentColor-0d7_KjU", "getNavigationContentColor-0d7_KjU", "getSelectedDayContainerColor-0d7_KjU", "getSelectedDayContentColor-0d7_KjU", "getSelectedYearContainerColor-0d7_KjU", "getSelectedYearContentColor-0d7_KjU", "getSubheadContentColor-0d7_KjU", "getTitleContentColor-0d7_KjU", "getTodayContentColor-0d7_KjU", "getTodayDateBorderColor-0d7_KjU", "getWeekdayContentColor-0d7_KjU", "getYearContentColor-0d7_KjU", "copy", "copy-tNwlRmA", "(JJJJJJJJJJJJJJJJJJJJJJJJLandroidx/compose/material3/TextFieldColors;)Landroidx/compose/material3/DatePickerColors;", "dayContainerColor", "Landroidx/compose/runtime/State;", "selected", "", "enabled", "animate", "dayContainerColor$material3_release", "(ZZZLandroidx/compose/runtime/Composer;I)Landroidx/compose/runtime/State;", "isToday", "inRange", "dayContentColor$material3_release", "(ZZZZLandroidx/compose/runtime/Composer;I)Landroidx/compose/runtime/State;", "equals", "other", "hashCode", "", "yearContainerColor", "yearContainerColor$material3_release", "(ZZLandroidx/compose/runtime/Composer;I)Landroidx/compose/runtime/State;", "currentYear", "yearContentColor$material3_release", "takeOrElse", "block", "Lkotlin/Function0;", "takeOrElse$material3_release", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class DatePickerColors {
    public static final int $stable = 0;
    private final long containerColor;
    private final long currentYearContentColor;
    private final TextFieldColors dateTextFieldColors;
    private final long dayContentColor;
    private final long dayInSelectionRangeContainerColor;
    private final long dayInSelectionRangeContentColor;
    private final long disabledDayContentColor;
    private final long disabledSelectedDayContainerColor;
    private final long disabledSelectedDayContentColor;
    private final long disabledSelectedYearContainerColor;
    private final long disabledSelectedYearContentColor;
    private final long disabledYearContentColor;
    private final long dividerColor;
    private final long headlineContentColor;
    private final long navigationContentColor;
    private final long selectedDayContainerColor;
    private final long selectedDayContentColor;
    private final long selectedYearContainerColor;
    private final long selectedYearContentColor;
    private final long subheadContentColor;
    private final long titleContentColor;
    private final long todayContentColor;
    private final long todayDateBorderColor;
    private final long weekdayContentColor;
    private final long yearContentColor;

    public DatePickerColors(long j, long j2, long j3, long j4, long j5, long j6, long j7, long j8, long j9, long j10, long j11, long j12, long j13, long j14, long j15, long j16, long j17, long j18, long j19, long j20, long j21, long j22, long j23, long j24, TextFieldColors textFieldColors, DefaultConstructorMarker defaultConstructorMarker) {
        this(j, j2, j3, j4, j5, j6, j7, j8, j9, j10, j11, j12, j13, j14, j15, j16, j17, j18, j19, j20, j21, j22, j23, j24, textFieldColors);
    }

    private DatePickerColors(long j, long j2, long j3, long j4, long j5, long j6, long j7, long j8, long j9, long j10, long j11, long j12, long j13, long j14, long j15, long j16, long j17, long j18, long j19, long j20, long j21, long j22, long j23, long j24, TextFieldColors textFieldColors) {
        this.containerColor = j;
        this.titleContentColor = j2;
        this.headlineContentColor = j3;
        this.weekdayContentColor = j4;
        this.subheadContentColor = j5;
        this.navigationContentColor = j6;
        this.yearContentColor = j7;
        this.disabledYearContentColor = j8;
        this.currentYearContentColor = j9;
        this.selectedYearContentColor = j10;
        this.disabledSelectedYearContentColor = j11;
        this.selectedYearContainerColor = j12;
        this.disabledSelectedYearContainerColor = j13;
        this.dayContentColor = j14;
        this.disabledDayContentColor = j15;
        this.selectedDayContentColor = j16;
        this.disabledSelectedDayContentColor = j17;
        this.selectedDayContainerColor = j18;
        this.disabledSelectedDayContainerColor = j19;
        this.todayContentColor = j20;
        this.todayDateBorderColor = j21;
        this.dayInSelectionRangeContainerColor = j22;
        this.dayInSelectionRangeContentColor = j23;
        this.dividerColor = j24;
        this.dateTextFieldColors = textFieldColors;
    }

    public final long getContainerColor() {
        return this.containerColor;
    }

    public final long getTitleContentColor() {
        return this.titleContentColor;
    }

    public final long getHeadlineContentColor() {
        return this.headlineContentColor;
    }

    public final long getWeekdayContentColor() {
        return this.weekdayContentColor;
    }

    public final long getSubheadContentColor() {
        return this.subheadContentColor;
    }

    public final long getNavigationContentColor() {
        return this.navigationContentColor;
    }

    public final long getYearContentColor() {
        return this.yearContentColor;
    }

    public final long getDisabledYearContentColor() {
        return this.disabledYearContentColor;
    }

    public final long getCurrentYearContentColor() {
        return this.currentYearContentColor;
    }

    public final long getSelectedYearContentColor() {
        return this.selectedYearContentColor;
    }

    public final long getDisabledSelectedYearContentColor() {
        return this.disabledSelectedYearContentColor;
    }

    public final long getSelectedYearContainerColor() {
        return this.selectedYearContainerColor;
    }

    public final long getDisabledSelectedYearContainerColor() {
        return this.disabledSelectedYearContainerColor;
    }

    public final long getDayContentColor() {
        return this.dayContentColor;
    }

    public final long getDisabledDayContentColor() {
        return this.disabledDayContentColor;
    }

    public final long getSelectedDayContentColor() {
        return this.selectedDayContentColor;
    }

    public final long getDisabledSelectedDayContentColor() {
        return this.disabledSelectedDayContentColor;
    }

    public final long getSelectedDayContainerColor() {
        return this.selectedDayContainerColor;
    }

    public final long getDisabledSelectedDayContainerColor() {
        return this.disabledSelectedDayContainerColor;
    }

    public final long getTodayContentColor() {
        return this.todayContentColor;
    }

    public final long getTodayDateBorderColor() {
        return this.todayDateBorderColor;
    }

    public final long getDayInSelectionRangeContainerColor() {
        return this.dayInSelectionRangeContainerColor;
    }

    public final long getDayInSelectionRangeContentColor() {
        return this.dayInSelectionRangeContentColor;
    }

    public final long getDividerColor() {
        return this.dividerColor;
    }

    public final TextFieldColors getDateTextFieldColors() {
        return this.dateTextFieldColors;
    }

    public final DatePickerColors m2243copytNwlRmA(long containerColor, long titleContentColor, long headlineContentColor, long weekdayContentColor, long subheadContentColor, long navigationContentColor, long yearContentColor, long disabledYearContentColor, long currentYearContentColor, long selectedYearContentColor, long disabledSelectedYearContentColor, long selectedYearContainerColor, long disabledSelectedYearContainerColor, long dayContentColor, long disabledDayContentColor, long selectedDayContentColor, long disabledSelectedDayContentColor, long selectedDayContainerColor, long disabledSelectedDayContainerColor, long todayContentColor, long todayDateBorderColor, long dayInSelectionRangeContainerColor, long dayInSelectionRangeContentColor, long dividerColor, TextFieldColors dateTextFieldColors) {
        return new DatePickerColors(containerColor != 16 ? containerColor : this.containerColor, titleContentColor != 16 ? titleContentColor : this.titleContentColor, headlineContentColor != 16 ? headlineContentColor : this.headlineContentColor, weekdayContentColor != 16 ? weekdayContentColor : this.weekdayContentColor, subheadContentColor != 16 ? subheadContentColor : this.subheadContentColor, navigationContentColor != 16 ? navigationContentColor : this.navigationContentColor, yearContentColor != 16 ? yearContentColor : this.yearContentColor, disabledYearContentColor != 16 ? disabledYearContentColor : this.disabledYearContentColor, currentYearContentColor != 16 ? currentYearContentColor : this.currentYearContentColor, selectedYearContentColor != 16 ? selectedYearContentColor : this.selectedYearContentColor, disabledSelectedYearContentColor != 16 ? disabledSelectedYearContentColor : this.disabledSelectedYearContentColor, selectedYearContainerColor != 16 ? selectedYearContainerColor : this.selectedYearContainerColor, disabledSelectedYearContainerColor != 16 ? disabledSelectedYearContainerColor : this.disabledSelectedYearContainerColor, dayContentColor != 16 ? dayContentColor : this.dayContentColor, disabledDayContentColor != 16 ? disabledDayContentColor : this.disabledDayContentColor, selectedDayContentColor != 16 ? selectedDayContentColor : this.selectedDayContentColor, disabledSelectedDayContentColor != 16 ? disabledSelectedDayContentColor : this.disabledSelectedDayContentColor, selectedDayContainerColor != 16 ? selectedDayContainerColor : this.selectedDayContainerColor, disabledSelectedDayContainerColor != 16 ? disabledSelectedDayContainerColor : this.disabledSelectedDayContainerColor, todayContentColor != 16 ? todayContentColor : this.todayContentColor, todayDateBorderColor != 16 ? todayDateBorderColor : this.todayDateBorderColor, dayInSelectionRangeContainerColor != 16 ? dayInSelectionRangeContainerColor : this.dayInSelectionRangeContainerColor, dayInSelectionRangeContentColor != 16 ? dayInSelectionRangeContentColor : this.dayInSelectionRangeContentColor, dividerColor != 16 ? dividerColor : this.dividerColor, takeOrElse$material3_release(dateTextFieldColors, new Function0<TextFieldColors>() {
            {
                super(0);
            }

            public final TextFieldColors m2268invoke() {
                return this.this$0.getDateTextFieldColors();
            }
        }), null);
    }

    public final TextFieldColors takeOrElse$material3_release(TextFieldColors textFieldColors, Function0<TextFieldColors> function0) {
        return textFieldColors == null ? (TextFieldColors) function0.invoke() : textFieldColors;
    }

    public final State<Color> dayContentColor$material3_release(boolean z, boolean z2, boolean z3, boolean z4, Composer composer, int i) {
        long j;
        State<Color> stateM387animateColorAsStateeuL9pac;
        ComposerKt.sourceInformationMarkerStart(composer, -1233694918, "C(dayContentColor)P(2,3,1):DatePicker.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-1233694918, i, -1, "androidx.compose.material3.DatePickerColors.dayContentColor (DatePicker.kt:901)");
        }
        if (z2 && z4) {
            j = this.selectedDayContentColor;
        } else if (z2 && !z4) {
            j = this.disabledSelectedDayContentColor;
        } else if (z3 && z4) {
            j = this.dayInSelectionRangeContentColor;
        } else if (z3 && !z4) {
            j = this.disabledDayContentColor;
        } else if (z) {
            j = this.todayContentColor;
        } else if (z4) {
            j = this.dayContentColor;
        } else {
            j = this.disabledDayContentColor;
        }
        long j2 = j;
        if (z3) {
            composer.startReplaceGroup(-828303257);
            ComposerKt.sourceInformation(composer, "914@44574L28");
            stateM387animateColorAsStateeuL9pac = SnapshotStateKt.rememberUpdatedState(Color.m4580boximpl(j2), composer, 0);
            composer.endReplaceGroup();
        } else {
            composer.startReplaceGroup(-828241443);
            ComposerKt.sourceInformation(composer, "917@44710L88");
            stateM387animateColorAsStateeuL9pac = SingleValueAnimationKt.m387animateColorAsStateeuL9pac(j2, AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composer, 0, 12);
            composer.endReplaceGroup();
        }
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return stateM387animateColorAsStateeuL9pac;
    }

    public final State<Color> dayContainerColor$material3_release(boolean z, boolean z2, boolean z3, Composer composer, int i) {
        long jM4625getTransparent0d7_KjU;
        State<Color> stateRememberUpdatedState;
        ComposerKt.sourceInformationMarkerStart(composer, -1240482658, "C(dayContainerColor)P(2,1):DatePicker.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-1240482658, i, -1, "androidx.compose.material3.DatePickerColors.dayContainerColor (DatePicker.kt:933)");
        }
        if (z) {
            jM4625getTransparent0d7_KjU = z2 ? this.selectedDayContainerColor : this.disabledSelectedDayContainerColor;
        } else {
            jM4625getTransparent0d7_KjU = Color.INSTANCE.m4625getTransparent0d7_KjU();
        }
        long j = jM4625getTransparent0d7_KjU;
        if (z3) {
            composer.startReplaceGroup(-217363149);
            ComposerKt.sourceInformation(composer, "941@45516L88");
            stateRememberUpdatedState = SingleValueAnimationKt.m387animateColorAsStateeuL9pac(j, AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composer, 0, 12);
            composer.endReplaceGroup();
        } else {
            composer.startReplaceGroup(-217247953);
            ComposerKt.sourceInformation(composer, "943@45634L28");
            stateRememberUpdatedState = SnapshotStateKt.rememberUpdatedState(Color.m4580boximpl(j), composer, 0);
            composer.endReplaceGroup();
        }
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return stateRememberUpdatedState;
    }

    public final State<Color> yearContentColor$material3_release(boolean z, boolean z2, boolean z3, Composer composer, int i) {
        long j;
        ComposerKt.sourceInformationMarkerStart(composer, 874111097, "C(yearContentColor)P(!1,2)969@46510L122:DatePicker.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(874111097, i, -1, "androidx.compose.material3.DatePickerColors.yearContentColor (DatePicker.kt:959)");
        }
        if (z2 && z3) {
            j = this.selectedYearContentColor;
        } else if (z2 && !z3) {
            j = this.disabledSelectedYearContentColor;
        } else if (z) {
            j = this.currentYearContentColor;
        } else if (z3) {
            j = this.yearContentColor;
        } else {
            j = this.disabledYearContentColor;
        }
        State<Color> stateM387animateColorAsStateeuL9pac = SingleValueAnimationKt.m387animateColorAsStateeuL9pac(j, AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composer, 0, 12);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return stateM387animateColorAsStateeuL9pac;
    }

    public final State<Color> yearContainerColor$material3_release(boolean z, boolean z2, Composer composer, int i) {
        long jM4625getTransparent0d7_KjU;
        ComposerKt.sourceInformationMarkerStart(composer, -1306331107, "C(yearContainerColor)P(1)989@47197L122:DatePicker.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-1306331107, i, -1, "androidx.compose.material3.DatePickerColors.yearContainerColor (DatePicker.kt:982)");
        }
        if (z) {
            jM4625getTransparent0d7_KjU = z2 ? this.selectedYearContainerColor : this.disabledSelectedYearContainerColor;
        } else {
            jM4625getTransparent0d7_KjU = Color.INSTANCE.m4625getTransparent0d7_KjU();
        }
        State<Color> stateM387animateColorAsStateeuL9pac = SingleValueAnimationKt.m387animateColorAsStateeuL9pac(jM4625getTransparent0d7_KjU, AnimationSpecKt.tween$default(100, 0, null, 6, null), null, null, composer, 0, 12);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return stateM387animateColorAsStateeuL9pac;
    }

    public boolean equals(Object other) {
        if (!(other instanceof DatePickerColors)) {
            return false;
        }
        DatePickerColors datePickerColors = (DatePickerColors) other;
        return Color.m4591equalsimpl0(this.containerColor, datePickerColors.containerColor) && Color.m4591equalsimpl0(this.titleContentColor, datePickerColors.titleContentColor) && Color.m4591equalsimpl0(this.headlineContentColor, datePickerColors.headlineContentColor) && Color.m4591equalsimpl0(this.weekdayContentColor, datePickerColors.weekdayContentColor) && Color.m4591equalsimpl0(this.subheadContentColor, datePickerColors.subheadContentColor) && Color.m4591equalsimpl0(this.yearContentColor, datePickerColors.yearContentColor) && Color.m4591equalsimpl0(this.disabledYearContentColor, datePickerColors.disabledYearContentColor) && Color.m4591equalsimpl0(this.currentYearContentColor, datePickerColors.currentYearContentColor) && Color.m4591equalsimpl0(this.selectedYearContentColor, datePickerColors.selectedYearContentColor) && Color.m4591equalsimpl0(this.disabledSelectedYearContentColor, datePickerColors.disabledSelectedYearContentColor) && Color.m4591equalsimpl0(this.selectedYearContainerColor, datePickerColors.selectedYearContainerColor) && Color.m4591equalsimpl0(this.disabledSelectedYearContainerColor, datePickerColors.disabledSelectedYearContainerColor) && Color.m4591equalsimpl0(this.dayContentColor, datePickerColors.dayContentColor) && Color.m4591equalsimpl0(this.disabledDayContentColor, datePickerColors.disabledDayContentColor) && Color.m4591equalsimpl0(this.selectedDayContentColor, datePickerColors.selectedDayContentColor) && Color.m4591equalsimpl0(this.disabledSelectedDayContentColor, datePickerColors.disabledSelectedDayContentColor) && Color.m4591equalsimpl0(this.selectedDayContainerColor, datePickerColors.selectedDayContainerColor) && Color.m4591equalsimpl0(this.disabledSelectedDayContainerColor, datePickerColors.disabledSelectedDayContainerColor) && Color.m4591equalsimpl0(this.todayContentColor, datePickerColors.todayContentColor) && Color.m4591equalsimpl0(this.todayDateBorderColor, datePickerColors.todayDateBorderColor) && Color.m4591equalsimpl0(this.dayInSelectionRangeContainerColor, datePickerColors.dayInSelectionRangeContainerColor) && Color.m4591equalsimpl0(this.dayInSelectionRangeContentColor, datePickerColors.dayInSelectionRangeContentColor);
    }

    public int hashCode() {
        return (((((((((((((((((((((((((((((((((((((((((Color.m4597hashCodeimpl(this.containerColor) * 31) + Color.m4597hashCodeimpl(this.titleContentColor)) * 31) + Color.m4597hashCodeimpl(this.headlineContentColor)) * 31) + Color.m4597hashCodeimpl(this.weekdayContentColor)) * 31) + Color.m4597hashCodeimpl(this.subheadContentColor)) * 31) + Color.m4597hashCodeimpl(this.yearContentColor)) * 31) + Color.m4597hashCodeimpl(this.disabledYearContentColor)) * 31) + Color.m4597hashCodeimpl(this.currentYearContentColor)) * 31) + Color.m4597hashCodeimpl(this.selectedYearContentColor)) * 31) + Color.m4597hashCodeimpl(this.disabledSelectedYearContentColor)) * 31) + Color.m4597hashCodeimpl(this.selectedYearContainerColor)) * 31) + Color.m4597hashCodeimpl(this.disabledSelectedYearContainerColor)) * 31) + Color.m4597hashCodeimpl(this.dayContentColor)) * 31) + Color.m4597hashCodeimpl(this.disabledDayContentColor)) * 31) + Color.m4597hashCodeimpl(this.selectedDayContentColor)) * 31) + Color.m4597hashCodeimpl(this.disabledSelectedDayContentColor)) * 31) + Color.m4597hashCodeimpl(this.selectedDayContainerColor)) * 31) + Color.m4597hashCodeimpl(this.disabledSelectedDayContainerColor)) * 31) + Color.m4597hashCodeimpl(this.todayContentColor)) * 31) + Color.m4597hashCodeimpl(this.todayDateBorderColor)) * 31) + Color.m4597hashCodeimpl(this.dayInSelectionRangeContainerColor)) * 31) + Color.m4597hashCodeimpl(this.dayInSelectionRangeContentColor);
    }
}
