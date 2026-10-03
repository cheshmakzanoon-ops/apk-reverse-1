package zendesk.core.android.internal;

import j$.time.Instant;
import j$.time.LocalDateTime;
import j$.time.ZoneId;
import j$.time.format.DateTimeFormatter;
import j$.time.format.DecimalStyle;
import j$.time.temporal.TemporalAccessor;
import j$.util.DateRetargetClass;
import java.util.Date;
import java.util.Locale;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u00002\n\u0002\u0010\u0006\n\u0002\b\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\t\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\b\n\u001a\u001d\u0010\u0004\u001a\u00020\u0003*\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0001H\u0007¢\u0006\u0004\b\u0004\u0010\u0005\u001a!\u0010\u0004\u001a\u0004\u0018\u00010\u0003*\u0004\u0018\u00010\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0001H\u0007¢\u0006\u0004\b\u0004\u0010\u0006\u001a\u001d\u0010\u0004\u001a\u00020\u0003*\u00020\u00072\b\b\u0002\u0010\u0002\u001a\u00020\u0001H\u0007¢\u0006\u0004\b\u0004\u0010\b\u001a\u001d\u0010\n\u001a\u00020\t*\u00020\u00032\b\b\u0002\u0010\u0002\u001a\u00020\u0001H\u0007¢\u0006\u0004\b\n\u0010\u000b\u001a\u001d\u0010\f\u001a\u00020\t*\u00020\u00032\b\b\u0002\u0010\u0002\u001a\u00020\u0001H\u0007¢\u0006\u0004\b\f\u0010\u000b\u001a#\u0010\u0012\u001a\u00020\u0011*\u00020\u00032\u0006\u0010\u000e\u001a\u00020\r2\u0006\u0010\u0010\u001a\u00020\u000fH\u0007¢\u0006\u0004\b\u0012\u0010\u0013\u001a#\u0010\u0016\u001a\u00020\u0011*\u00020\u00032\u0006\u0010\u0015\u001a\u00020\u00142\u0006\u0010\u000e\u001a\u00020\rH\u0007¢\u0006\u0004\b\u0016\u0010\u0017\u001a\u001b\u0010\u0018\u001a\u00020\u0011*\u00020\u00032\u0006\u0010\u000e\u001a\u00020\rH\u0007¢\u0006\u0004\b\u0018\u0010\u0019\u001a\u001b\u0010\u001a\u001a\u00020\u0011*\u00020\u00032\u0006\u0010\u000e\u001a\u00020\rH\u0007¢\u0006\u0004\b\u001a\u0010\u0019\u001a\u001b\u0010\u001b\u001a\u00020\u0011*\u00020\u00032\u0006\u0010\u000e\u001a\u00020\rH\u0007¢\u0006\u0004\b\u001b\u0010\u0019\u001a\u001b\u0010\u001c\u001a\u00020\u0011*\u00020\u00032\u0006\u0010\u000e\u001a\u00020\rH\u0007¢\u0006\u0004\b\u001c\u0010\u0019¨\u0006\u001d"}, m18d2 = {"", "j$/time/ZoneId", "zoneId", "j$/time/LocalDateTime", "toLocalDateTime", "(DLj$/time/ZoneId;)Lj$/time/LocalDateTime;", "(Ljava/lang/Double;Lj$/time/ZoneId;)Lj$/time/LocalDateTime;", "Ljava/util/Date;", "(Ljava/util/Date;Lj$/time/ZoneId;)Lj$/time/LocalDateTime;", "", "toTimestamp", "(Lj$/time/LocalDateTime;Lj$/time/ZoneId;)J", "toUnixTimeStamp", "Ljava/util/Locale;", "locale", "", "is24HourFormat", "", "timeOnly", "(Lj$/time/LocalDateTime;Ljava/util/Locale;Z)Ljava/lang/String;", "j$/time/format/DateTimeFormatter", "timeOnlyFormat", "formatToLocalisedNumbers", "(Lj$/time/LocalDateTime;Lj$/time/format/DateTimeFormatter;Ljava/util/Locale;)Ljava/lang/String;", "dayAndMonth", "(Lj$/time/LocalDateTime;Ljava/util/Locale;)Ljava/lang/String;", "fullMonthAndDay", "monthDayAndYear", "fullMonthDayAndYear", "zendesk.core_core-utilities"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class DateKtxKt {
    public static LocalDateTime toLocalDateTime$default(double d, ZoneId zoneId, int i, Object obj) {
        if ((i & 1) != 0) {
            zoneId = ZoneId.systemDefault();
            Intrinsics.checkNotNullExpressionValue(zoneId, "systemDefault(...)");
        }
        return toLocalDateTime(d, zoneId);
    }

    @InternalZendeskApi
    public static final LocalDateTime toLocalDateTime(double d, ZoneId zoneId) {
        Intrinsics.checkNotNullParameter(zoneId, "zoneId");
        LocalDateTime localDateTime = Instant.ofEpochSecond((long) d).atZone(zoneId).toLocalDateTime();
        Intrinsics.checkNotNullExpressionValue(localDateTime, "toLocalDateTime(...)");
        return localDateTime;
    }

    public static LocalDateTime toLocalDateTime$default(Double d, ZoneId zoneId, int i, Object obj) {
        if ((i & 1) != 0) {
            zoneId = ZoneId.systemDefault();
            Intrinsics.checkNotNullExpressionValue(zoneId, "systemDefault(...)");
        }
        return toLocalDateTime(d, zoneId);
    }

    @InternalZendeskApi
    public static final LocalDateTime toLocalDateTime(Double d, ZoneId zoneId) {
        Intrinsics.checkNotNullParameter(zoneId, "zoneId");
        if (d != null) {
            return toLocalDateTime(d.doubleValue(), zoneId);
        }
        return null;
    }

    @InternalZendeskApi
    public static final LocalDateTime toLocalDateTime(Date date, ZoneId zoneId) {
        Intrinsics.checkNotNullParameter(date, "<this>");
        Intrinsics.checkNotNullParameter(zoneId, "zoneId");
        LocalDateTime localDateTime = DateRetargetClass.toInstant(date).atZone(zoneId).toLocalDateTime();
        Intrinsics.checkNotNullExpressionValue(localDateTime, "toLocalDateTime(...)");
        return localDateTime;
    }

    public static LocalDateTime toLocalDateTime$default(Date date, ZoneId zoneId, int i, Object obj) {
        if ((i & 1) != 0) {
            zoneId = ZoneId.systemDefault();
            Intrinsics.checkNotNullExpressionValue(zoneId, "systemDefault(...)");
        }
        return toLocalDateTime(date, zoneId);
    }

    public static long toTimestamp$default(LocalDateTime localDateTime, ZoneId zoneId, int i, Object obj) {
        if ((i & 1) != 0) {
            zoneId = ZoneId.systemDefault();
            Intrinsics.checkNotNullExpressionValue(zoneId, "systemDefault(...)");
        }
        return toTimestamp(localDateTime, zoneId);
    }

    @InternalZendeskApi
    public static final long toTimestamp(LocalDateTime localDateTime, ZoneId zoneId) {
        Intrinsics.checkNotNullParameter(localDateTime, "<this>");
        Intrinsics.checkNotNullParameter(zoneId, "zoneId");
        return localDateTime.atZone(zoneId).toInstant().toEpochMilli();
    }

    public static long toUnixTimeStamp$default(LocalDateTime localDateTime, ZoneId zoneId, int i, Object obj) {
        if ((i & 1) != 0) {
            zoneId = ZoneId.systemDefault();
            Intrinsics.checkNotNullExpressionValue(zoneId, "systemDefault(...)");
        }
        return toUnixTimeStamp(localDateTime, zoneId);
    }

    @InternalZendeskApi
    public static final long toUnixTimeStamp(LocalDateTime localDateTime, ZoneId zoneId) {
        Intrinsics.checkNotNullParameter(localDateTime, "<this>");
        Intrinsics.checkNotNullParameter(zoneId, "zoneId");
        return localDateTime.atZone(zoneId).toInstant().getEpochSecond();
    }

    @InternalZendeskApi
    public static final String timeOnly(LocalDateTime localDateTime, Locale locale, boolean z) {
        Intrinsics.checkNotNullParameter(localDateTime, "<this>");
        Intrinsics.checkNotNullParameter(locale, "locale");
        DateTimeFormatter dateTimeFormatterOfPattern = DateTimeFormatter.ofPattern(z ? DateKtxConstants.TIME_24_FORMAT_PATTERN : DateKtxConstants.TIME_12_FORMAT_PATTERN, locale);
        Intrinsics.checkNotNull(dateTimeFormatterOfPattern);
        return formatToLocalisedNumbers(localDateTime, dateTimeFormatterOfPattern, locale);
    }

    @InternalZendeskApi
    public static final String formatToLocalisedNumbers(LocalDateTime localDateTime, DateTimeFormatter timeOnlyFormat, Locale locale) {
        Intrinsics.checkNotNullParameter(localDateTime, "<this>");
        Intrinsics.checkNotNullParameter(timeOnlyFormat, "timeOnlyFormat");
        Intrinsics.checkNotNullParameter(locale, "locale");
        String str = timeOnlyFormat.withDecimalStyle(DecimalStyle.of(locale)).format((TemporalAccessor) localDateTime);
        Intrinsics.checkNotNull(str);
        return str;
    }

    @InternalZendeskApi
    public static final String dayAndMonth(LocalDateTime localDateTime, Locale locale) {
        Intrinsics.checkNotNullParameter(localDateTime, "<this>");
        Intrinsics.checkNotNullParameter(locale, "locale");
        DateTimeFormatter dateTimeFormatterOfPattern = DateTimeFormatter.ofPattern(DateKtxConstants.DAY_MONTH_PATTERN, locale);
        Intrinsics.checkNotNull(dateTimeFormatterOfPattern);
        return formatToLocalisedNumbers(localDateTime, dateTimeFormatterOfPattern, locale);
    }

    @InternalZendeskApi
    public static final String fullMonthAndDay(LocalDateTime localDateTime, Locale locale) {
        Intrinsics.checkNotNullParameter(localDateTime, "<this>");
        Intrinsics.checkNotNullParameter(locale, "locale");
        String str = DateTimeFormatter.ofPattern(DateKtxConstants.FULL_MONTH_DAY_PATTERN, locale).format((TemporalAccessor) localDateTime);
        Intrinsics.checkNotNullExpressionValue(str, "format(...)");
        return str;
    }

    @InternalZendeskApi
    public static final String monthDayAndYear(LocalDateTime localDateTime, Locale locale) {
        Intrinsics.checkNotNullParameter(localDateTime, "<this>");
        Intrinsics.checkNotNullParameter(locale, "locale");
        DateTimeFormatter dateTimeFormatterOfPattern = DateTimeFormatter.ofPattern(DateKtxConstants.MONTH_DAY_YEAR_PATTERN, locale);
        Intrinsics.checkNotNull(dateTimeFormatterOfPattern);
        return formatToLocalisedNumbers(localDateTime, dateTimeFormatterOfPattern, locale);
    }

    @InternalZendeskApi
    public static final String fullMonthDayAndYear(LocalDateTime localDateTime, Locale locale) {
        Intrinsics.checkNotNullParameter(localDateTime, "<this>");
        Intrinsics.checkNotNullParameter(locale, "locale");
        String str = DateTimeFormatter.ofPattern(DateKtxConstants.FULL_MONTH_DAY_YEAR_PATTERN, locale).format((TemporalAccessor) localDateTime);
        Intrinsics.checkNotNullExpressionValue(str, "format(...)");
        return str;
    }
}
