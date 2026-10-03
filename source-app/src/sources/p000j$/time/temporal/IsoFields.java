package p000j$.time.temporal;

import java.util.Map;
import p000j$.time.Clock$OffsetClock$$ExternalSyntheticBackport0;
import p000j$.time.DateTimeException;
import p000j$.time.DayOfWeek;
import p000j$.time.Duration;
import p000j$.time.Duration$$ExternalSyntheticBackport1;
import p000j$.time.Instant$$ExternalSyntheticBackport6;
import p000j$.time.LocalDate;
import p000j$.time.chrono.ChronoLocalDate;
import p000j$.time.chrono.Chronology;
import p000j$.time.chrono.IsoChronology;
import p000j$.time.format.ResolverStyle;

public abstract class IsoFields {
    public static final TemporalField DAY_OF_QUARTER = Field.DAY_OF_QUARTER;
    public static final TemporalField QUARTER_OF_YEAR = Field.QUARTER_OF_YEAR;
    public static final TemporalField WEEK_OF_WEEK_BASED_YEAR = Field.WEEK_OF_WEEK_BASED_YEAR;
    public static final TemporalField WEEK_BASED_YEAR = Field.WEEK_BASED_YEAR;
    public static final TemporalUnit WEEK_BASED_YEARS = Unit.WEEK_BASED_YEARS;
    public static final TemporalUnit QUARTER_YEARS = Unit.QUARTER_YEARS;

    private static abstract class Field implements TemporalField {
        private static final Field[] $VALUES;
        public static final Field DAY_OF_QUARTER;
        private static final int[] QUARTER_DAYS;
        public static final Field QUARTER_OF_YEAR;
        public static final Field WEEK_BASED_YEAR;
        public static final Field WEEK_OF_WEEK_BASED_YEAR;

        @Override
        public boolean isDateBased() {
            return true;
        }

        @Override
        public boolean isTimeBased() {
            return false;
        }

        @Override
        public TemporalAccessor resolve(Map map, TemporalAccessor temporalAccessor, ResolverStyle resolverStyle) {
            return TemporalField.CC.$default$resolve(this, map, temporalAccessor, resolverStyle);
        }

        final enum C04991 extends Field {
            private C04991(String str, int i) {
                super(str, i);
            }

            @Override
            public ValueRange range() {
                return ValueRange.m1709of(1L, 90L, 92L);
            }

            @Override
            public boolean isSupportedBy(TemporalAccessor temporalAccessor) {
                return temporalAccessor.isSupported(ChronoField.DAY_OF_YEAR) && temporalAccessor.isSupported(ChronoField.MONTH_OF_YEAR) && temporalAccessor.isSupported(ChronoField.YEAR) && IsoFields.isIso(temporalAccessor);
            }

            @Override
            public ValueRange rangeRefinedBy(TemporalAccessor temporalAccessor) {
                if (!isSupportedBy(temporalAccessor)) {
                    throw new UnsupportedTemporalTypeException("Unsupported field: DayOfQuarter");
                }
                long j = temporalAccessor.getLong(Field.QUARTER_OF_YEAR);
                if (j == 1) {
                    return IsoChronology.INSTANCE.isLeapYear(temporalAccessor.getLong(ChronoField.YEAR)) ? ValueRange.m1708of(1L, 91L) : ValueRange.m1708of(1L, 90L);
                }
                if (j == 2) {
                    return ValueRange.m1708of(1L, 91L);
                }
                if (j == 3 || j == 4) {
                    return ValueRange.m1708of(1L, 92L);
                }
                return range();
            }

            @Override
            public long getFrom(TemporalAccessor temporalAccessor) {
                if (!isSupportedBy(temporalAccessor)) {
                    throw new UnsupportedTemporalTypeException("Unsupported field: DayOfQuarter");
                }
                return temporalAccessor.get(ChronoField.DAY_OF_YEAR) - Field.QUARTER_DAYS[((temporalAccessor.get(ChronoField.MONTH_OF_YEAR) - 1) / 3) + (IsoChronology.INSTANCE.isLeapYear(temporalAccessor.getLong(ChronoField.YEAR)) ? 4 : 0)];
            }

            @Override
            public Temporal adjustInto(Temporal temporal, long j) {
                long from = getFrom(temporal);
                range().checkValidValue(j, this);
                ChronoField chronoField = ChronoField.DAY_OF_YEAR;
                return temporal.with(chronoField, temporal.getLong(chronoField) + (j - from));
            }

            @Override
            public ChronoLocalDate resolve(Map map, TemporalAccessor temporalAccessor, ResolverStyle resolverStyle) {
                LocalDate localDateM1633of;
                long jM1630m;
                ChronoField chronoField = ChronoField.YEAR;
                Long l = (Long) map.get(chronoField);
                TemporalField temporalField = Field.QUARTER_OF_YEAR;
                Long l2 = (Long) map.get(temporalField);
                if (l == null || l2 == null) {
                    return null;
                }
                int iCheckValidIntValue = chronoField.checkValidIntValue(l.longValue());
                long jLongValue = ((Long) map.get(Field.DAY_OF_QUARTER)).longValue();
                Field.ensureIso(temporalAccessor);
                if (resolverStyle == ResolverStyle.LENIENT) {
                    localDateM1633of = LocalDate.m1633of(iCheckValidIntValue, 1, 1).plusMonths(Duration$$ExternalSyntheticBackport1.m1621m(Instant$$ExternalSyntheticBackport6.m1630m(l2.longValue(), 1L), 3));
                    jM1630m = Instant$$ExternalSyntheticBackport6.m1630m(jLongValue, 1L);
                } else {
                    localDateM1633of = LocalDate.m1633of(iCheckValidIntValue, ((temporalField.range().checkValidIntValue(l2.longValue(), temporalField) - 1) * 3) + 1, 1);
                    if (jLongValue < 1 || jLongValue > 90) {
                        if (resolverStyle == ResolverStyle.STRICT) {
                            rangeRefinedBy(localDateM1633of).checkValidValue(jLongValue, this);
                        } else {
                            range().checkValidValue(jLongValue, this);
                        }
                    }
                    jM1630m = jLongValue - 1;
                }
                map.remove(this);
                map.remove(chronoField);
                map.remove(temporalField);
                return localDateM1633of.plusDays(jM1630m);
            }

            @Override
            public String toString() {
                return "DayOfQuarter";
            }
        }

        private Field(String str, int i) {
            super(str, i);
        }

        public static Field valueOf(String str) {
            return (Field) Enum.valueOf(Field.class, str);
        }

        public static Field[] values() {
            return (Field[]) $VALUES.clone();
        }

        static {
            C04991 c04991 = new C04991("DAY_OF_QUARTER", 0);
            DAY_OF_QUARTER = c04991;
            C05002 c05002 = new C05002("QUARTER_OF_YEAR", 1);
            QUARTER_OF_YEAR = c05002;
            C05013 c05013 = new C05013("WEEK_OF_WEEK_BASED_YEAR", 2);
            WEEK_OF_WEEK_BASED_YEAR = c05013;
            C05024 c05024 = new C05024("WEEK_BASED_YEAR", 3);
            WEEK_BASED_YEAR = c05024;
            $VALUES = new Field[]{c04991, c05002, c05013, c05024};
            QUARTER_DAYS = new int[]{0, 90, 181, 273, 0, 91, 182, 274};
        }

        final enum C05002 extends Field {
            private C05002(String str, int i) {
                super(str, i);
            }

            @Override
            public ValueRange range() {
                return ValueRange.m1708of(1L, 4L);
            }

            @Override
            public boolean isSupportedBy(TemporalAccessor temporalAccessor) {
                return temporalAccessor.isSupported(ChronoField.MONTH_OF_YEAR) && IsoFields.isIso(temporalAccessor);
            }

            @Override
            public long getFrom(TemporalAccessor temporalAccessor) {
                if (!isSupportedBy(temporalAccessor)) {
                    throw new UnsupportedTemporalTypeException("Unsupported field: QuarterOfYear");
                }
                return (temporalAccessor.getLong(ChronoField.MONTH_OF_YEAR) + 2) / 3;
            }

            @Override
            public ValueRange rangeRefinedBy(TemporalAccessor temporalAccessor) {
                if (!isSupportedBy(temporalAccessor)) {
                    throw new UnsupportedTemporalTypeException("Unsupported field: QuarterOfYear");
                }
                return super.rangeRefinedBy(temporalAccessor);
            }

            @Override
            public Temporal adjustInto(Temporal temporal, long j) {
                long from = getFrom(temporal);
                range().checkValidValue(j, this);
                ChronoField chronoField = ChronoField.MONTH_OF_YEAR;
                return temporal.with(chronoField, temporal.getLong(chronoField) + ((j - from) * 3));
            }

            @Override
            public String toString() {
                return "QuarterOfYear";
            }
        }

        final enum C05013 extends Field {
            private C05013(String str, int i) {
                super(str, i);
            }

            @Override
            public ValueRange range() {
                return ValueRange.m1709of(1L, 52L, 53L);
            }

            @Override
            public boolean isSupportedBy(TemporalAccessor temporalAccessor) {
                return temporalAccessor.isSupported(ChronoField.EPOCH_DAY) && IsoFields.isIso(temporalAccessor);
            }

            @Override
            public ValueRange rangeRefinedBy(TemporalAccessor temporalAccessor) {
                if (!isSupportedBy(temporalAccessor)) {
                    throw new UnsupportedTemporalTypeException("Unsupported field: WeekOfWeekBasedYear");
                }
                return Field.getWeekRange(LocalDate.from(temporalAccessor));
            }

            @Override
            public long getFrom(TemporalAccessor temporalAccessor) {
                if (!isSupportedBy(temporalAccessor)) {
                    throw new UnsupportedTemporalTypeException("Unsupported field: WeekOfWeekBasedYear");
                }
                return Field.getWeek(LocalDate.from(temporalAccessor));
            }

            @Override
            public Temporal adjustInto(Temporal temporal, long j) {
                range().checkValidValue(j, this);
                return temporal.plus(Instant$$ExternalSyntheticBackport6.m1630m(j, getFrom(temporal)), ChronoUnit.WEEKS);
            }

            @Override
            public ChronoLocalDate resolve(Map map, TemporalAccessor temporalAccessor, ResolverStyle resolverStyle) {
                LocalDate localDateWith;
                long j;
                long j2;
                TemporalField temporalField = Field.WEEK_BASED_YEAR;
                Long l = (Long) map.get(temporalField);
                ChronoField chronoField = ChronoField.DAY_OF_WEEK;
                Long l2 = (Long) map.get(chronoField);
                if (l == null || l2 == null) {
                    return null;
                }
                int iCheckValidIntValue = temporalField.range().checkValidIntValue(l.longValue(), temporalField);
                long jLongValue = ((Long) map.get(Field.WEEK_OF_WEEK_BASED_YEAR)).longValue();
                Field.ensureIso(temporalAccessor);
                LocalDate localDateM1633of = LocalDate.m1633of(iCheckValidIntValue, 1, 4);
                if (resolverStyle == ResolverStyle.LENIENT) {
                    long jLongValue2 = l2.longValue();
                    if (jLongValue2 > 7) {
                        long j3 = jLongValue2 - 1;
                        localDateM1633of = localDateM1633of.plusWeeks(j3 / 7);
                        j2 = j3 % 7;
                    } else {
                        j = 1;
                        if (jLongValue2 < 1) {
                            localDateM1633of = localDateM1633of.plusWeeks(Instant$$ExternalSyntheticBackport6.m1630m(jLongValue2, 7L) / 7);
                            j2 = (jLongValue2 + 6) % 7;
                        }
                        localDateWith = localDateM1633of.plusWeeks(Instant$$ExternalSyntheticBackport6.m1630m(jLongValue, j)).with((TemporalField) chronoField, jLongValue2);
                    }
                    j = 1;
                    jLongValue2 = j2 + 1;
                    localDateWith = localDateM1633of.plusWeeks(Instant$$ExternalSyntheticBackport6.m1630m(jLongValue, j)).with((TemporalField) chronoField, jLongValue2);
                } else {
                    int iCheckValidIntValue2 = chronoField.checkValidIntValue(l2.longValue());
                    if (jLongValue < 1 || jLongValue > 52) {
                        if (resolverStyle == ResolverStyle.STRICT) {
                            Field.getWeekRange(localDateM1633of).checkValidValue(jLongValue, this);
                        } else {
                            range().checkValidValue(jLongValue, this);
                        }
                    }
                    localDateWith = localDateM1633of.plusWeeks(jLongValue - 1).with((TemporalField) chronoField, iCheckValidIntValue2);
                }
                map.remove(this);
                map.remove(temporalField);
                map.remove(chronoField);
                return localDateWith;
            }

            @Override
            public String toString() {
                return "WeekOfWeekBasedYear";
            }
        }

        final enum C05024 extends Field {
            private C05024(String str, int i) {
                super(str, i);
            }

            @Override
            public ValueRange range() {
                return ChronoField.YEAR.range();
            }

            @Override
            public boolean isSupportedBy(TemporalAccessor temporalAccessor) {
                return temporalAccessor.isSupported(ChronoField.EPOCH_DAY) && IsoFields.isIso(temporalAccessor);
            }

            @Override
            public long getFrom(TemporalAccessor temporalAccessor) {
                if (!isSupportedBy(temporalAccessor)) {
                    throw new UnsupportedTemporalTypeException("Unsupported field: WeekBasedYear");
                }
                return Field.getWeekBasedYear(LocalDate.from(temporalAccessor));
            }

            @Override
            public ValueRange rangeRefinedBy(TemporalAccessor temporalAccessor) {
                if (!isSupportedBy(temporalAccessor)) {
                    throw new UnsupportedTemporalTypeException("Unsupported field: WeekBasedYear");
                }
                return super.rangeRefinedBy(temporalAccessor);
            }

            @Override
            public Temporal adjustInto(Temporal temporal, long j) {
                if (!isSupportedBy(temporal)) {
                    throw new UnsupportedTemporalTypeException("Unsupported field: WeekBasedYear");
                }
                int iCheckValidIntValue = range().checkValidIntValue(j, Field.WEEK_BASED_YEAR);
                LocalDate localDateFrom = LocalDate.from(temporal);
                ChronoField chronoField = ChronoField.DAY_OF_WEEK;
                int i = localDateFrom.get(chronoField);
                int week = Field.getWeek(localDateFrom);
                if (week == 53 && Field.getWeekRange(iCheckValidIntValue) == 52) {
                    week = 52;
                }
                LocalDate localDateM1633of = LocalDate.m1633of(iCheckValidIntValue, 1, 4);
                return temporal.with(localDateM1633of.plusDays((i - localDateM1633of.get(chronoField)) + ((week - 1) * 7)));
            }

            @Override
            public String toString() {
                return "WeekBasedYear";
            }
        }

        @Override
        public ValueRange rangeRefinedBy(TemporalAccessor temporalAccessor) {
            return range();
        }

        public static void ensureIso(TemporalAccessor temporalAccessor) {
            if (!IsoFields.isIso(temporalAccessor)) {
                throw new DateTimeException("Resolve requires IsoChronology");
            }
        }

        public static ValueRange getWeekRange(LocalDate localDate) {
            return ValueRange.m1708of(1L, getWeekRange(getWeekBasedYear(localDate)));
        }

        public static int getWeekRange(int i) {
            LocalDate localDateM1633of = LocalDate.m1633of(i, 1, 1);
            if (localDateM1633of.getDayOfWeek() != DayOfWeek.THURSDAY) {
                return (localDateM1633of.getDayOfWeek() == DayOfWeek.WEDNESDAY && localDateM1633of.isLeapYear()) ? 53 : 52;
            }
            return 53;
        }

        public static int getWeek(LocalDate localDate) {
            int iOrdinal = localDate.getDayOfWeek().ordinal();
            int dayOfYear = localDate.getDayOfYear() - 1;
            int i = (3 - iOrdinal) + dayOfYear;
            int i2 = i - ((i / 7) * 7);
            int i3 = i2 - 3;
            if (i3 < -3) {
                i3 = i2 + 4;
            }
            if (dayOfYear < i3) {
                return (int) getWeekRange(localDate.withDayOfYear(180).minusYears(1L)).getMaximum();
            }
            int i4 = ((dayOfYear - i3) / 7) + 1;
            if (i4 != 53 || i3 == -3 || (i3 == -2 && localDate.isLeapYear())) {
                return i4;
            }
            return 1;
        }

        public static int getWeekBasedYear(LocalDate localDate) {
            int year = localDate.getYear();
            int dayOfYear = localDate.getDayOfYear();
            if (dayOfYear <= 3) {
                return dayOfYear - localDate.getDayOfWeek().ordinal() < -2 ? year - 1 : year;
            }
            if (dayOfYear >= 363) {
                return ((dayOfYear - 363) - (localDate.isLeapYear() ? 1 : 0)) - localDate.getDayOfWeek().ordinal() >= 0 ? year + 1 : year;
            }
            return year;
        }
    }

    private enum Unit implements TemporalUnit {
        WEEK_BASED_YEARS("WeekBasedYears", Duration.ofSeconds(31556952)),
        QUARTER_YEARS("QuarterYears", Duration.ofSeconds(7889238));

        private final Duration duration;
        private final String name;

        @Override
        public boolean isDateBased() {
            return true;
        }

        @Override
        public boolean isTimeBased() {
            return false;
        }

        Unit(String str, Duration duration) {
            this.name = str;
            this.duration = duration;
        }

        @Override
        public Temporal addTo(Temporal temporal, long j) {
            int i = C04981.$SwitchMap$java$time$temporal$IsoFields$Unit[ordinal()];
            if (i == 1) {
                TemporalField temporalField = IsoFields.WEEK_BASED_YEAR;
                return temporal.with(temporalField, Clock$OffsetClock$$ExternalSyntheticBackport0.m1617m(temporal.get(temporalField), j));
            }
            if (i == 2) {
                return temporal.plus(j / 4, ChronoUnit.YEARS).plus((j % 4) * 3, ChronoUnit.MONTHS);
            }
            throw new IllegalStateException("Unreachable");
        }

        @Override
        public long between(Temporal temporal, Temporal temporal2) {
            if (temporal.getClass() != temporal2.getClass()) {
                return temporal.until(temporal2, this);
            }
            int i = C04981.$SwitchMap$java$time$temporal$IsoFields$Unit[ordinal()];
            if (i == 1) {
                TemporalField temporalField = IsoFields.WEEK_BASED_YEAR;
                return Instant$$ExternalSyntheticBackport6.m1630m(temporal2.getLong(temporalField), temporal.getLong(temporalField));
            }
            if (i == 2) {
                return temporal.until(temporal2, ChronoUnit.MONTHS) / 3;
            }
            throw new IllegalStateException("Unreachable");
        }

        @Override
        public String toString() {
            return this.name;
        }
    }

    static class C04981 {
        static final int[] $SwitchMap$java$time$temporal$IsoFields$Unit;

        static {
            int[] iArr = new int[Unit.values().length];
            $SwitchMap$java$time$temporal$IsoFields$Unit = iArr;
            try {
                iArr[Unit.WEEK_BASED_YEARS.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                $SwitchMap$java$time$temporal$IsoFields$Unit[Unit.QUARTER_YEARS.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
        }
    }

    static boolean isIso(TemporalAccessor temporalAccessor) {
        return Chronology.CC.from(temporalAccessor).equals(IsoChronology.INSTANCE);
    }
}
