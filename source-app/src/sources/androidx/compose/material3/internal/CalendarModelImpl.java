package androidx.compose.material3.internal;

import j$.time.DayOfWeek;
import j$.time.Instant;
import j$.time.LocalDate;
import j$.time.LocalTime;
import j$.time.ZoneId;
import j$.time.ZoneOffset;
import j$.time.chrono.Chronology;
import j$.time.format.DateTimeFormatter;
import j$.time.format.DateTimeFormatterBuilder;
import j$.time.format.DateTimeParseException;
import j$.time.format.DecimalStyle;
import j$.time.format.FormatStyle;
import j$.time.format.TextStyle;
import j$.time.temporal.WeekFields;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import kotlin.Metadata;
import kotlin.Pair;
import kotlin.TuplesKt;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000R\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\t\n\u0002\b\u0006\n\u0002\u0010\b\n\u0002\b\f\n\u0002\u0010\u000e\n\u0002\b\u000b\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\t\b\u0001\u0018\u0000 <2\u00020\u0001:\u0001<B\u0013\u0012\n\u0010\u0004\u001a\u00060\u0002j\u0002`\u0003¢\u0006\u0004\b\u0005\u0010\u0006J\u0017\u0010\n\u001a\u00020\t2\u0006\u0010\b\u001a\u00020\u0007H\u0002¢\u0006\u0004\b\n\u0010\u000bJ\u0013\u0010\f\u001a\u00020\u0007*\u00020\tH\u0002¢\u0006\u0004\b\f\u0010\rJ\u0013\u0010\f\u001a\u00020\u0007*\u00020\u000eH\u0002¢\u0006\u0004\b\f\u0010\u000fJ\u001b\u0010\u0011\u001a\u00020\u00102\n\u0010\u0004\u001a\u00060\u0002j\u0002`\u0003H\u0016¢\u0006\u0004\b\u0011\u0010\u0012J\u0017\u0010\u0015\u001a\u00020\u000e2\u0006\u0010\u0014\u001a\u00020\u0013H\u0016¢\u0006\u0004\b\u0015\u0010\u0016J\u0017\u0010\n\u001a\u00020\t2\u0006\u0010\u0014\u001a\u00020\u0013H\u0016¢\u0006\u0004\b\n\u0010\u0017J\u0017\u0010\n\u001a\u00020\t2\u0006\u0010\u0018\u001a\u00020\u000eH\u0016¢\u0006\u0004\b\n\u0010\u0019J\u001f\u0010\n\u001a\u00020\t2\u0006\u0010\u001b\u001a\u00020\u001a2\u0006\u0010\u001c\u001a\u00020\u001aH\u0016¢\u0006\u0004\b\n\u0010\u001dJ\u0017\u0010\u001e\u001a\u00020\u001a2\u0006\u0010\u0018\u001a\u00020\u000eH\u0016¢\u0006\u0004\b\u001e\u0010\u001fJ\u001f\u0010\"\u001a\u00020\t2\u0006\u0010 \u001a\u00020\t2\u0006\u0010!\u001a\u00020\u001aH\u0016¢\u0006\u0004\b\"\u0010#J\u001f\u0010%\u001a\u00020\t2\u0006\u0010 \u001a\u00020\t2\u0006\u0010$\u001a\u00020\u001aH\u0016¢\u0006\u0004\b%\u0010#J+\u0010)\u001a\u00020'2\u0006\u0010&\u001a\u00020\u00132\u0006\u0010(\u001a\u00020'2\n\u0010\u0004\u001a\u00060\u0002j\u0002`\u0003H\u0016¢\u0006\u0004\b)\u0010*J!\u0010+\u001a\u0004\u0018\u00010\u000e2\u0006\u0010\u0018\u001a\u00020'2\u0006\u0010(\u001a\u00020'H\u0016¢\u0006\u0004\b+\u0010,J\u000f\u0010-\u001a\u00020'H\u0016¢\u0006\u0004\b-\u0010.R\u001a\u0010/\u001a\u00020\u001a8\u0016X\u0096\u0004¢\u0006\f\n\u0004\b/\u00100\u001a\u0004\b1\u00102R,\u00105\u001a\u0014\u0012\u0010\u0012\u000e\u0012\u0004\u0012\u00020'\u0012\u0004\u0012\u00020'04038\u0016X\u0096\u0004¢\u0006\f\n\u0004\b5\u00106\u001a\u0004\b7\u00108R\u0014\u0010;\u001a\u00020\u000e8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b9\u0010:¨\u0006="}, d2 = {"Landroidx/compose/material3/internal/CalendarModelImpl;", "Landroidx/compose/material3/internal/CalendarModel;", "Ljava/util/Locale;", "Landroidx/compose/material3/CalendarLocale;", "locale", "<init>", "(Ljava/util/Locale;)V", "j$/time/LocalDate", "firstDayLocalDate", "Landroidx/compose/material3/internal/CalendarMonth;", "getMonth", "(Lj$/time/LocalDate;)Landroidx/compose/material3/internal/CalendarMonth;", "toLocalDate", "(Landroidx/compose/material3/internal/CalendarMonth;)Lj$/time/LocalDate;", "Landroidx/compose/material3/internal/CalendarDate;", "(Landroidx/compose/material3/internal/CalendarDate;)Lj$/time/LocalDate;", "Landroidx/compose/material3/internal/DateInputFormat;", "getDateInputFormat", "(Ljava/util/Locale;)Landroidx/compose/material3/internal/DateInputFormat;", "", "timeInMillis", "getCanonicalDate", "(J)Landroidx/compose/material3/internal/CalendarDate;", "(J)Landroidx/compose/material3/internal/CalendarMonth;", "date", "(Landroidx/compose/material3/internal/CalendarDate;)Landroidx/compose/material3/internal/CalendarMonth;", "", "year", "month", "(II)Landroidx/compose/material3/internal/CalendarMonth;", "getDayOfWeek", "(Landroidx/compose/material3/internal/CalendarDate;)I", "from", "addedMonthsCount", "plusMonths", "(Landroidx/compose/material3/internal/CalendarMonth;I)Landroidx/compose/material3/internal/CalendarMonth;", "subtractedMonthsCount", "minusMonths", "utcTimeMillis", "", "pattern", "formatWithPattern", "(JLjava/lang/String;Ljava/util/Locale;)Ljava/lang/String;", "parse", "(Ljava/lang/String;Ljava/lang/String;)Landroidx/compose/material3/internal/CalendarDate;", "toString", "()Ljava/lang/String;", "firstDayOfWeek", "I", "getFirstDayOfWeek", "()I", "", "Lkotlin/Pair;", "weekdayNames", "Ljava/util/List;", "getWeekdayNames", "()Ljava/util/List;", "getToday", "()Landroidx/compose/material3/internal/CalendarDate;", "today", "Companion", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class CalendarModelImpl extends CalendarModel {
    private final int firstDayOfWeek;
    private final List<Pair<String, String>> weekdayNames;

    public static final Companion INSTANCE = new Companion(null);
    public static final int $stable = 8;
    private static final ZoneId utcTimeZoneId = ZoneId.of("UTC");

    public CalendarModelImpl(Locale locale) {
        super(locale);
        this.firstDayOfWeek = WeekFields.of(locale).getFirstDayOfWeek().getValue();
        DayOfWeek[] dayOfWeekArrValues = DayOfWeek.values();
        ArrayList arrayList = new ArrayList(dayOfWeekArrValues.length);
        for (DayOfWeek dayOfWeek : dayOfWeekArrValues) {
            arrayList.add(TuplesKt.to(dayOfWeek.getDisplayName(TextStyle.FULL, locale), dayOfWeek.getDisplayName(TextStyle.NARROW, locale)));
        }
        this.weekdayNames = arrayList;
    }

    @Override
    public CalendarDate getToday() {
        LocalDate localDateNow = LocalDate.now();
        return new CalendarDate(localDateNow.getYear(), localDateNow.getMonthValue(), localDateNow.getDayOfMonth(), localDateNow.atTime(LocalTime.MIDNIGHT).atZone(utcTimeZoneId).toInstant().toEpochMilli());
    }

    @Override
    public int getFirstDayOfWeek() {
        return this.firstDayOfWeek;
    }

    @Override
    public List<Pair<String, String>> getWeekdayNames() {
        return this.weekdayNames;
    }

    @Override
    public DateInputFormat getDateInputFormat(Locale locale) {
        return CalendarModelKt.datePatternAsInputFormat(DateTimeFormatterBuilder.getLocalizedDateTimePattern(FormatStyle.SHORT, (FormatStyle) null, Chronology.-CC.ofLocale(locale), locale));
    }

    @Override
    public CalendarDate getCanonicalDate(long timeInMillis) {
        LocalDate localDate = Instant.ofEpochMilli(timeInMillis).atZone(utcTimeZoneId).toLocalDate();
        return new CalendarDate(localDate.getYear(), localDate.getMonthValue(), localDate.getDayOfMonth(), localDate.atStartOfDay().toEpochSecond(ZoneOffset.UTC) * ((long) 1000));
    }

    @Override
    public CalendarMonth getMonth(long timeInMillis) {
        return getMonth(Instant.ofEpochMilli(timeInMillis).atZone(utcTimeZoneId).withDayOfMonth(1).toLocalDate());
    }

    @Override
    public CalendarMonth getMonth(CalendarDate date) {
        return getMonth(LocalDate.of(date.getYear(), date.getMonth(), 1));
    }

    @Override
    public CalendarMonth getMonth(int year, int month) {
        return getMonth(LocalDate.of(year, month, 1));
    }

    @Override
    public int getDayOfWeek(CalendarDate date) {
        return toLocalDate(date).getDayOfWeek().getValue();
    }

    @Override
    public CalendarMonth plusMonths(CalendarMonth from, int addedMonthsCount) {
        return addedMonthsCount <= 0 ? from : getMonth(toLocalDate(from).plusMonths(addedMonthsCount));
    }

    @Override
    public CalendarMonth minusMonths(CalendarMonth from, int subtractedMonthsCount) {
        return subtractedMonthsCount <= 0 ? from : getMonth(toLocalDate(from).minusMonths(subtractedMonthsCount));
    }

    @Override
    public String formatWithPattern(long utcTimeMillis, String pattern, Locale locale) {
        return INSTANCE.formatWithPattern(utcTimeMillis, pattern, locale, getFormatterCache$material3_release());
    }

    @Override
    public CalendarDate parse(String date, String pattern) {
        try {
            LocalDate localDate = LocalDate.parse(date, DateTimeFormatter.ofPattern(pattern));
            return new CalendarDate(localDate.getYear(), localDate.getMonth().getValue(), localDate.getDayOfMonth(), localDate.atTime(LocalTime.MIDNIGHT).atZone(utcTimeZoneId).toInstant().toEpochMilli());
        } catch (DateTimeParseException unused) {
            return null;
        }
    }

    public String toString() {
        return "CalendarModel";
    }

    @Metadata(d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010%\n\u0000\n\u0002\b\u0003\n\u0002\u0010\t\n\u0002\b\u0003\n\u0002\b\u0006\b\u0086\u0003\u0018\u00002\u00020\u0001B\t\b\u0002¢\u0006\u0004\b\u0002\u0010\u0003J7\u0010\f\u001a\u00020\u000b2\u0006\u0010\u0005\u001a\u00020\u00042\n\u0010\b\u001a\u00060\u0006j\u0002`\u00072\u0012\u0010\n\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00010\tH\u0002¢\u0006\u0004\b\f\u0010\rJ=\u0010\u0010\u001a\u00020\u00042\u0006\u0010\u000f\u001a\u00020\u000e2\u0006\u0010\u0005\u001a\u00020\u00042\n\u0010\b\u001a\u00060\u0006j\u0002`\u00072\u0012\u0010\n\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00010\t¢\u0006\u0004\b\u0010\u0010\u0011R\u001a\u0010\u0013\u001a\u00020\u00128\u0000X\u0080\u0004¢\u0006\f\n\u0004\b\u0013\u0010\u0014\u001a\u0004\b\u0015\u0010\u0016¨\u0006\u0017"}, d2 = {"Landroidx/compose/material3/internal/CalendarModelImpl$Companion;", "", "<init>", "()V", "", "pattern", "Ljava/util/Locale;", "Landroidx/compose/material3/CalendarLocale;", "locale", "", "cache", "j$/time/format/DateTimeFormatter", "getCachedDateTimeFormatter", "(Ljava/lang/String;Ljava/util/Locale;Ljava/util/Map;)Lj$/time/format/DateTimeFormatter;", "", "utcTimeMillis", "formatWithPattern", "(JLjava/lang/String;Ljava/util/Locale;Ljava/util/Map;)Ljava/lang/String;", "j$/time/ZoneId", "utcTimeZoneId", "Lj$/time/ZoneId;", "getUtcTimeZoneId$material3_release", "()Lj$/time/ZoneId;", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final String formatWithPattern(long utcTimeMillis, String pattern, Locale locale, Map<String, Object> cache) {
            return Instant.ofEpochMilli(utcTimeMillis).atZone(getUtcTimeZoneId$material3_release()).toLocalDate().format(getCachedDateTimeFormatter(pattern, locale, cache));
        }

        public final ZoneId getUtcTimeZoneId$material3_release() {
            return CalendarModelImpl.utcTimeZoneId;
        }

        private final DateTimeFormatter getCachedDateTimeFormatter(String pattern, Locale locale, Map<String, Object> cache) {
            String str = "P:" + pattern + locale.toLanguageTag();
            Object objWithDecimalStyle = cache.get(str);
            if (objWithDecimalStyle == null) {
                objWithDecimalStyle = DateTimeFormatter.ofPattern(pattern, locale).withDecimalStyle(DecimalStyle.of(locale));
                cache.put(str, objWithDecimalStyle);
            }
            Intrinsics.checkNotNull(objWithDecimalStyle, "null cannot be cast to non-null type java.time.format.DateTimeFormatter");
            return (DateTimeFormatter) objWithDecimalStyle;
        }
    }

    private final CalendarMonth getMonth(LocalDate firstDayLocalDate) {
        int value = firstDayLocalDate.getDayOfWeek().getValue() - getFirstDayOfWeek();
        if (value < 0) {
            value += 7;
        }
        return new CalendarMonth(firstDayLocalDate.getYear(), firstDayLocalDate.getMonthValue(), firstDayLocalDate.lengthOfMonth(), value, firstDayLocalDate.atTime(LocalTime.MIDNIGHT).atZone(utcTimeZoneId).toInstant().toEpochMilli());
    }

    private final LocalDate toLocalDate(CalendarMonth calendarMonth) {
        return Instant.ofEpochMilli(calendarMonth.getStartUtcTimeMillis()).atZone(utcTimeZoneId).toLocalDate();
    }

    private final LocalDate toLocalDate(CalendarDate calendarDate) {
        return LocalDate.of(calendarDate.getYear(), calendarDate.getMonth(), calendarDate.getDayOfMonth());
    }
}
