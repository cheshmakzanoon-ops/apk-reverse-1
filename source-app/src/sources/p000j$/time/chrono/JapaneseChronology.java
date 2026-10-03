package p000j$.time.chrono;

import java.io.InvalidObjectException;
import java.io.ObjectInputStream;
import java.io.Serializable;
import java.util.List;
import java.util.Map;
import p000j$.time.Clock;
import p000j$.time.DateTimeException;
import p000j$.time.Duration$DurationUnits$$ExternalSyntheticBackport0;
import p000j$.time.Instant;
import p000j$.time.Instant$$ExternalSyntheticBackport6;
import p000j$.time.LocalDate;
import p000j$.time.ZoneId;
import p000j$.time.format.ResolverStyle;
import p000j$.time.temporal.ChronoField;
import p000j$.time.temporal.ChronoUnit;
import p000j$.time.temporal.TemporalAccessor;
import p000j$.time.temporal.TemporalAdjusters;
import p000j$.time.temporal.TemporalUnit;
import p000j$.time.temporal.UnsupportedTemporalTypeException;
import p000j$.time.temporal.ValueRange;

public final class JapaneseChronology extends AbstractChronology implements Serializable {
    public static final JapaneseChronology INSTANCE = new JapaneseChronology();
    private static final long serialVersionUID = 459996390165777884L;

    private JapaneseChronology() {
    }

    @Override
    public String getId() {
        return "Japanese";
    }

    @Override
    public String getCalendarType() {
        return "japanese";
    }

    public JapaneseDate date(Era era, int i, int i2, int i3) {
        if (!(era instanceof JapaneseEra)) {
            throw new ClassCastException("Era must be JapaneseEra");
        }
        return JapaneseDate.m1699of((JapaneseEra) era, i, i2, i3);
    }

    @Override
    public JapaneseDate date(int i, int i2, int i3) {
        return new JapaneseDate(LocalDate.m1633of(i, i2, i3));
    }

    public JapaneseDate dateYearDay(Era era, int i, int i2) {
        return JapaneseDate.ofYearDay((JapaneseEra) era, i, i2);
    }

    @Override
    public JapaneseDate dateYearDay(int i, int i2) {
        return new JapaneseDate(LocalDate.ofYearDay(i, i2));
    }

    @Override
    public JapaneseDate dateEpochDay(long j) {
        return new JapaneseDate(LocalDate.ofEpochDay(j));
    }

    @Override
    public JapaneseDate dateNow() {
        return dateNow(Clock.systemDefaultZone());
    }

    public JapaneseDate dateNow(Clock clock) {
        return date((TemporalAccessor) LocalDate.now(clock));
    }

    @Override
    public JapaneseDate date(TemporalAccessor temporalAccessor) {
        if (temporalAccessor instanceof JapaneseDate) {
            return (JapaneseDate) temporalAccessor;
        }
        return new JapaneseDate(LocalDate.from(temporalAccessor));
    }

    @Override
    public ChronoLocalDateTime localDateTime(TemporalAccessor temporalAccessor) {
        return super.localDateTime(temporalAccessor);
    }

    @Override
    public ChronoZonedDateTime zonedDateTime(TemporalAccessor temporalAccessor) {
        return super.zonedDateTime(temporalAccessor);
    }

    @Override
    public ChronoZonedDateTime zonedDateTime(Instant instant, ZoneId zoneId) {
        return super.zonedDateTime(instant, zoneId);
    }

    @Override
    public boolean isLeapYear(long j) {
        return IsoChronology.INSTANCE.isLeapYear(j);
    }

    @Override
    public int prolepticYear(Era era, int i) {
        if (!(era instanceof JapaneseEra)) {
            throw new ClassCastException("Era must be JapaneseEra");
        }
        JapaneseEra japaneseEra = (JapaneseEra) era;
        int year = (japaneseEra.getSince().getYear() + i) - 1;
        if (i == 1) {
            return year;
        }
        if (year < -999999999 || year > 999999999 || year < japaneseEra.getSince().getYear() || era != JapaneseEra.from(LocalDate.m1633of(year, 1, 1))) {
            throw new DateTimeException("Invalid yearOfEra value");
        }
        return year;
    }

    @Override
    public JapaneseEra eraOf(int i) {
        return JapaneseEra.m1700of(i);
    }

    @Override
    public List eras() {
        return Duration$DurationUnits$$ExternalSyntheticBackport0.m1623m(JapaneseEra.values());
    }

    static class C04841 {
        static final int[] $SwitchMap$java$time$temporal$ChronoField;

        static {
            int[] iArr = new int[ChronoField.values().length];
            $SwitchMap$java$time$temporal$ChronoField = iArr;
            try {
                iArr[ChronoField.ALIGNED_DAY_OF_WEEK_IN_MONTH.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                $SwitchMap$java$time$temporal$ChronoField[ChronoField.ALIGNED_DAY_OF_WEEK_IN_YEAR.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                $SwitchMap$java$time$temporal$ChronoField[ChronoField.ALIGNED_WEEK_OF_MONTH.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            try {
                $SwitchMap$java$time$temporal$ChronoField[ChronoField.ALIGNED_WEEK_OF_YEAR.ordinal()] = 4;
            } catch (NoSuchFieldError unused4) {
            }
            try {
                $SwitchMap$java$time$temporal$ChronoField[ChronoField.YEAR_OF_ERA.ordinal()] = 5;
            } catch (NoSuchFieldError unused5) {
            }
            try {
                $SwitchMap$java$time$temporal$ChronoField[ChronoField.DAY_OF_YEAR.ordinal()] = 6;
            } catch (NoSuchFieldError unused6) {
            }
            try {
                $SwitchMap$java$time$temporal$ChronoField[ChronoField.YEAR.ordinal()] = 7;
            } catch (NoSuchFieldError unused7) {
            }
            try {
                $SwitchMap$java$time$temporal$ChronoField[ChronoField.ERA.ordinal()] = 8;
            } catch (NoSuchFieldError unused8) {
            }
        }
    }

    @Override
    public ValueRange range(ChronoField chronoField) {
        switch (C04841.$SwitchMap$java$time$temporal$ChronoField[chronoField.ordinal()]) {
            case 1:
            case 2:
            case 3:
            case 4:
                throw new UnsupportedTemporalTypeException("Unsupported field: " + chronoField);
            case 5:
                return ValueRange.m1709of(1L, JapaneseEra.shortestYearsOfEra(), 999999999 - JapaneseEra.getCurrentEra().getSince().getYear());
            case 6:
                return ValueRange.m1709of(1L, JapaneseEra.shortestDaysOfYear(), ChronoField.DAY_OF_YEAR.range().getMaximum());
            case 7:
                return ValueRange.m1708of(JapaneseDate.MEIJI_6_ISODATE.getYear(), 999999999L);
            case 8:
                return ValueRange.m1708of(JapaneseEra.MEIJI.getValue(), JapaneseEra.getCurrentEra().getValue());
            default:
                return chronoField.range();
        }
    }

    @Override
    public JapaneseDate resolveDate(Map map, ResolverStyle resolverStyle) {
        return (JapaneseDate) super.resolveDate(map, resolverStyle);
    }

    @Override
    ChronoLocalDate resolveYearOfEra(Map map, ResolverStyle resolverStyle) {
        ChronoField chronoField = ChronoField.ERA;
        Long l = (Long) map.get(chronoField);
        JapaneseEra japaneseEraEraOf = l != null ? eraOf(range(chronoField).checkValidIntValue(l.longValue(), chronoField)) : null;
        ChronoField chronoField2 = ChronoField.YEAR_OF_ERA;
        Long l2 = (Long) map.get(chronoField2);
        int iCheckValidIntValue = l2 != null ? range(chronoField2).checkValidIntValue(l2.longValue(), chronoField2) : 0;
        if (japaneseEraEraOf == null && l2 != null && !map.containsKey(ChronoField.YEAR) && resolverStyle != ResolverStyle.STRICT) {
            japaneseEraEraOf = JapaneseEra.values()[JapaneseEra.values().length - 1];
        }
        if (l2 != null && japaneseEraEraOf != null) {
            if (map.containsKey(ChronoField.MONTH_OF_YEAR) && map.containsKey(ChronoField.DAY_OF_MONTH)) {
                return resolveYMD(japaneseEraEraOf, iCheckValidIntValue, map, resolverStyle);
            }
            if (map.containsKey(ChronoField.DAY_OF_YEAR)) {
                return resolveYD(japaneseEraEraOf, iCheckValidIntValue, map, resolverStyle);
            }
        }
        return null;
    }

    private int prolepticYearLenient(JapaneseEra japaneseEra, int i) {
        return (japaneseEra.getSince().getYear() + i) - 1;
    }

    private ChronoLocalDate resolveYMD(JapaneseEra japaneseEra, int i, Map map, ResolverStyle resolverStyle) {
        JapaneseDate japaneseDateWith;
        map.remove(ChronoField.ERA);
        map.remove(ChronoField.YEAR_OF_ERA);
        if (resolverStyle == ResolverStyle.LENIENT) {
            int iProlepticYearLenient = prolepticYearLenient(japaneseEra, i);
            return date(iProlepticYearLenient, 1, 1).plus(Instant$$ExternalSyntheticBackport6.m1630m(((Long) map.remove(ChronoField.MONTH_OF_YEAR)).longValue(), 1L), (TemporalUnit) ChronoUnit.MONTHS).plus(Instant$$ExternalSyntheticBackport6.m1630m(((Long) map.remove(ChronoField.DAY_OF_MONTH)).longValue(), 1L), (TemporalUnit) ChronoUnit.DAYS);
        }
        ChronoField chronoField = ChronoField.MONTH_OF_YEAR;
        int iCheckValidIntValue = range(chronoField).checkValidIntValue(((Long) map.remove(chronoField)).longValue(), chronoField);
        ChronoField chronoField2 = ChronoField.DAY_OF_MONTH;
        int iCheckValidIntValue2 = range(chronoField2).checkValidIntValue(((Long) map.remove(chronoField2)).longValue(), chronoField2);
        if (resolverStyle != ResolverStyle.SMART) {
            return date(japaneseEra, i, iCheckValidIntValue, iCheckValidIntValue2);
        }
        if (i < 1) {
            throw new DateTimeException("Invalid YearOfEra: " + i);
        }
        int iProlepticYearLenient2 = prolepticYearLenient(japaneseEra, i);
        try {
            japaneseDateWith = date(iProlepticYearLenient2, iCheckValidIntValue, iCheckValidIntValue2);
        } catch (DateTimeException unused) {
            japaneseDateWith = date(iProlepticYearLenient2, iCheckValidIntValue, 1).with(TemporalAdjusters.lastDayOfMonth());
        }
        if (japaneseDateWith.getEra() == japaneseEra || japaneseDateWith.get(ChronoField.YEAR_OF_ERA) <= 1 || i <= 1) {
            return japaneseDateWith;
        }
        throw new DateTimeException("Invalid YearOfEra for Era: " + japaneseEra + " " + i);
    }

    private ChronoLocalDate resolveYD(JapaneseEra japaneseEra, int i, Map map, ResolverStyle resolverStyle) {
        map.remove(ChronoField.ERA);
        map.remove(ChronoField.YEAR_OF_ERA);
        if (resolverStyle == ResolverStyle.LENIENT) {
            int iProlepticYearLenient = prolepticYearLenient(japaneseEra, i);
            return dateYearDay(iProlepticYearLenient, 1).plus(Instant$$ExternalSyntheticBackport6.m1630m(((Long) map.remove(ChronoField.DAY_OF_YEAR)).longValue(), 1L), (TemporalUnit) ChronoUnit.DAYS);
        }
        ChronoField chronoField = ChronoField.DAY_OF_YEAR;
        return dateYearDay(japaneseEra, i, range(chronoField).checkValidIntValue(((Long) map.remove(chronoField)).longValue(), chronoField));
    }

    @Override
    Object writeReplace() {
        return super.writeReplace();
    }

    private void readObject(ObjectInputStream objectInputStream) throws InvalidObjectException {
        throw new InvalidObjectException("Deserialization via serialization delegate");
    }
}
