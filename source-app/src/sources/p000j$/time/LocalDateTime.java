package p000j$.time;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.InvalidObjectException;
import java.io.ObjectInputStream;
import java.io.Serializable;
import p000j$.time.chrono.ChronoLocalDateTime;
import p000j$.time.chrono.Chronology;
import p000j$.time.format.DateTimeFormatter;
import p000j$.time.temporal.ChronoField;
import p000j$.time.temporal.ChronoUnit;
import p000j$.time.temporal.Temporal;
import p000j$.time.temporal.TemporalAccessor;
import p000j$.time.temporal.TemporalAdjuster;
import p000j$.time.temporal.TemporalAmount;
import p000j$.time.temporal.TemporalField;
import p000j$.time.temporal.TemporalQueries;
import p000j$.time.temporal.TemporalQuery;
import p000j$.time.temporal.TemporalUnit;
import p000j$.time.temporal.ValueRange;
import p000j$.util.Objects;

public final class LocalDateTime implements Temporal, TemporalAdjuster, ChronoLocalDateTime<LocalDate>, Serializable {
    private static final long serialVersionUID = 6207766400415563566L;
    private final LocalDate date;
    private final LocalTime time;
    public static final LocalDateTime MIN = m1646of(LocalDate.MIN, LocalTime.MIN);
    public static final LocalDateTime MAX = m1646of(LocalDate.MAX, LocalTime.MAX);

    @Override
    public Chronology getChronology() {
        return toLocalDate().getChronology();
    }

    @Override
    public long toEpochSecond(ZoneOffset zoneOffset) {
        return ChronoLocalDateTime.CC.$default$toEpochSecond(this, zoneOffset);
    }

    public static LocalDateTime now() {
        return now(Clock.systemDefaultZone());
    }

    public static LocalDateTime now(Clock clock) {
        Objects.requireNonNull(clock, "clock");
        Instant instant = clock.instant();
        return ofEpochSecond(instant.getEpochSecond(), instant.getNano(), clock.getZone().getRules().getOffset(instant));
    }

    public static LocalDateTime m1644of(int i, int i2, int i3, int i4, int i5) {
        return new LocalDateTime(LocalDate.m1633of(i, i2, i3), LocalTime.m1653of(i4, i5));
    }

    public static LocalDateTime m1645of(int i, int i2, int i3, int i4, int i5, int i6, int i7) {
        return new LocalDateTime(LocalDate.m1633of(i, i2, i3), LocalTime.m1654of(i4, i5, i6, i7));
    }

    public static LocalDateTime m1646of(LocalDate localDate, LocalTime localTime) {
        Objects.requireNonNull(localDate, "date");
        Objects.requireNonNull(localTime, "time");
        return new LocalDateTime(localDate, localTime);
    }

    public static LocalDateTime ofEpochSecond(long j, int i, ZoneOffset zoneOffset) {
        Objects.requireNonNull(zoneOffset, "offset");
        long j2 = i;
        ChronoField.NANO_OF_SECOND.checkValidValue(j2);
        long totalSeconds = j + ((long) zoneOffset.getTotalSeconds());
        return new LocalDateTime(LocalDate.ofEpochDay(DesugarLocalDate$$ExternalSyntheticBackport0.m1620m(totalSeconds, 86400)), LocalTime.ofNanoOfDay((((long) LocalDateTime$$ExternalSyntheticBackport5.m1652m(totalSeconds, 86400)) * 1000000000) + j2));
    }

    public static LocalDateTime from(TemporalAccessor temporalAccessor) {
        if (temporalAccessor instanceof LocalDateTime) {
            return (LocalDateTime) temporalAccessor;
        }
        if (temporalAccessor instanceof ZonedDateTime) {
            return ((ZonedDateTime) temporalAccessor).toLocalDateTime();
        }
        if (temporalAccessor instanceof OffsetDateTime) {
            return ((OffsetDateTime) temporalAccessor).toLocalDateTime();
        }
        try {
            return new LocalDateTime(LocalDate.from(temporalAccessor), LocalTime.from(temporalAccessor));
        } catch (DateTimeException e) {
            throw new DateTimeException("Unable to obtain LocalDateTime from TemporalAccessor: " + temporalAccessor + " of type " + temporalAccessor.getClass().getName(), e);
        }
    }

    public static LocalDateTime parse(CharSequence charSequence, DateTimeFormatter dateTimeFormatter) {
        Objects.requireNonNull(dateTimeFormatter, "formatter");
        return (LocalDateTime) dateTimeFormatter.parse(charSequence, new TemporalQuery() {
            @Override
            public final Object queryFrom(TemporalAccessor temporalAccessor) {
                return LocalDateTime.from(temporalAccessor);
            }
        });
    }

    private LocalDateTime(LocalDate localDate, LocalTime localTime) {
        this.date = localDate;
        this.time = localTime;
    }

    private LocalDateTime with(LocalDate localDate, LocalTime localTime) {
        return (this.date == localDate && this.time == localTime) ? this : new LocalDateTime(localDate, localTime);
    }

    @Override
    public boolean isSupported(TemporalField temporalField) {
        if (!(temporalField instanceof ChronoField)) {
            return temporalField != null && temporalField.isSupportedBy(this);
        }
        ChronoField chronoField = (ChronoField) temporalField;
        return chronoField.isDateBased() || chronoField.isTimeBased();
    }

    @Override
    public ValueRange range(TemporalField temporalField) {
        if (temporalField instanceof ChronoField) {
            return ((ChronoField) temporalField).isTimeBased() ? this.time.range(temporalField) : this.date.range(temporalField);
        }
        return temporalField.rangeRefinedBy(this);
    }

    @Override
    public int get(TemporalField temporalField) {
        if (temporalField instanceof ChronoField) {
            return ((ChronoField) temporalField).isTimeBased() ? this.time.get(temporalField) : this.date.get(temporalField);
        }
        return TemporalAccessor.CC.$default$get(this, temporalField);
    }

    @Override
    public long getLong(TemporalField temporalField) {
        if (temporalField instanceof ChronoField) {
            return ((ChronoField) temporalField).isTimeBased() ? this.time.getLong(temporalField) : this.date.getLong(temporalField);
        }
        return temporalField.getFrom(this);
    }

    @Override
    public LocalDate toLocalDate() {
        return this.date;
    }

    public int getYear() {
        return this.date.getYear();
    }

    public int getMonthValue() {
        return this.date.getMonthValue();
    }

    public int getDayOfMonth() {
        return this.date.getDayOfMonth();
    }

    public int getDayOfYear() {
        return this.date.getDayOfYear();
    }

    @Override
    public LocalTime toLocalTime() {
        return this.time;
    }

    public int getSecond() {
        return this.time.getSecond();
    }

    public int getNano() {
        return this.time.getNano();
    }

    @Override
    public LocalDateTime with(TemporalAdjuster temporalAdjuster) {
        if (temporalAdjuster instanceof LocalDate) {
            return with((LocalDate) temporalAdjuster, this.time);
        }
        if (temporalAdjuster instanceof LocalTime) {
            return with(this.date, (LocalTime) temporalAdjuster);
        }
        if (temporalAdjuster instanceof LocalDateTime) {
            return (LocalDateTime) temporalAdjuster;
        }
        return (LocalDateTime) temporalAdjuster.adjustInto(this);
    }

    @Override
    public LocalDateTime with(TemporalField temporalField, long j) {
        if (temporalField instanceof ChronoField) {
            if (((ChronoField) temporalField).isTimeBased()) {
                return with(this.date, this.time.with(temporalField, j));
            }
            return with(this.date.with(temporalField, j), this.time);
        }
        return (LocalDateTime) temporalField.adjustInto(this, j);
    }

    public LocalDateTime withDayOfMonth(int i) {
        return with(this.date.withDayOfMonth(i), this.time);
    }

    public LocalDateTime plus(TemporalAmount temporalAmount) {
        if (temporalAmount instanceof Period) {
            return with(this.date.plus(temporalAmount), this.time);
        }
        Objects.requireNonNull(temporalAmount, "amountToAdd");
        return (LocalDateTime) temporalAmount.addTo(this);
    }

    @Override
    public LocalDateTime plus(long j, TemporalUnit temporalUnit) {
        if (temporalUnit instanceof ChronoUnit) {
            switch (C04691.$SwitchMap$java$time$temporal$ChronoUnit[((ChronoUnit) temporalUnit).ordinal()]) {
                case 1:
                    return plusNanos(j);
                case 2:
                    return plusDays(j / 86400000000L).plusNanos((j % 86400000000L) * 1000);
                case 3:
                    return plusDays(j / 86400000).plusNanos((j % 86400000) * 1000000);
                case 4:
                    return plusSeconds(j);
                case 5:
                    return plusMinutes(j);
                case 6:
                    return plusHours(j);
                case 7:
                    return plusDays(j / 256).plusHours((j % 256) * 12);
                default:
                    return with(this.date.plus(j, temporalUnit), this.time);
            }
        }
        return (LocalDateTime) temporalUnit.addTo(this, j);
    }

    static class C04691 {
        static final int[] $SwitchMap$java$time$temporal$ChronoUnit;

        static {
            int[] iArr = new int[ChronoUnit.values().length];
            $SwitchMap$java$time$temporal$ChronoUnit = iArr;
            try {
                iArr[ChronoUnit.NANOS.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                $SwitchMap$java$time$temporal$ChronoUnit[ChronoUnit.MICROS.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                $SwitchMap$java$time$temporal$ChronoUnit[ChronoUnit.MILLIS.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            try {
                $SwitchMap$java$time$temporal$ChronoUnit[ChronoUnit.SECONDS.ordinal()] = 4;
            } catch (NoSuchFieldError unused4) {
            }
            try {
                $SwitchMap$java$time$temporal$ChronoUnit[ChronoUnit.MINUTES.ordinal()] = 5;
            } catch (NoSuchFieldError unused5) {
            }
            try {
                $SwitchMap$java$time$temporal$ChronoUnit[ChronoUnit.HOURS.ordinal()] = 6;
            } catch (NoSuchFieldError unused6) {
            }
            try {
                $SwitchMap$java$time$temporal$ChronoUnit[ChronoUnit.HALF_DAYS.ordinal()] = 7;
            } catch (NoSuchFieldError unused7) {
            }
        }
    }

    public LocalDateTime plusDays(long j) {
        return with(this.date.plusDays(j), this.time);
    }

    public LocalDateTime plusHours(long j) {
        return plusWithOverflow(this.date, j, 0L, 0L, 0L, 1);
    }

    public LocalDateTime plusMinutes(long j) {
        return plusWithOverflow(this.date, 0L, j, 0L, 0L, 1);
    }

    public LocalDateTime plusSeconds(long j) {
        return plusWithOverflow(this.date, 0L, 0L, j, 0L, 1);
    }

    public LocalDateTime plusNanos(long j) {
        return plusWithOverflow(this.date, 0L, 0L, 0L, j, 1);
    }

    @Override
    public LocalDateTime minus(long j, TemporalUnit temporalUnit) {
        return j == Long.MIN_VALUE ? plus(Long.MAX_VALUE, temporalUnit).plus(1L, temporalUnit) : plus(-j, temporalUnit);
    }

    private LocalDateTime plusWithOverflow(LocalDate localDate, long j, long j2, long j3, long j4, int i) {
        if ((j | j2 | j3 | j4) == 0) {
            return with(localDate, this.time);
        }
        long j5 = i;
        long nanoOfDay = this.time.toNanoOfDay();
        long j6 = (((j4 % 86400000000000L) + ((j3 % 86400) * 1000000000) + ((j2 % 1440) * 60000000000L) + ((j % 24) * 3600000000000L)) * j5) + nanoOfDay;
        long jM1620m = (((j4 / 86400000000000L) + (j3 / 86400) + (j2 / 1440) + (j / 24)) * j5) + DesugarLocalDate$$ExternalSyntheticBackport0.m1620m(j6, 86400000000000L);
        long jM1618m = Clock$TickClock$$ExternalSyntheticBackport0.m1618m(j6, 86400000000000L);
        return with(localDate.plusDays(jM1620m), jM1618m == nanoOfDay ? this.time : LocalTime.ofNanoOfDay(jM1618m));
    }

    @Override
    public Object query(TemporalQuery temporalQuery) {
        if (temporalQuery == TemporalQueries.localDate()) {
            return this.date;
        }
        return ChronoLocalDateTime.CC.$default$query(this, temporalQuery);
    }

    @Override
    public Temporal adjustInto(Temporal temporal) {
        return temporal.with(ChronoField.EPOCH_DAY, toLocalDate().toEpochDay()).with(ChronoField.NANO_OF_DAY, toLocalTime().toNanoOfDay());
    }

    @Override
    public long until(Temporal temporal, TemporalUnit temporalUnit) {
        long jM1621m;
        long j;
        LocalDateTime localDateTimeFrom = from(temporal);
        if (temporalUnit instanceof ChronoUnit) {
            if (temporalUnit.isTimeBased()) {
                long jDaysUntil = this.date.daysUntil(localDateTimeFrom.date);
                if (jDaysUntil == 0) {
                    return this.time.until(localDateTimeFrom.time, temporalUnit);
                }
                long nanoOfDay = localDateTimeFrom.time.toNanoOfDay() - this.time.toNanoOfDay();
                if (jDaysUntil > 0) {
                    jM1621m = jDaysUntil - 1;
                    j = nanoOfDay + 86400000000000L;
                } else {
                    jM1621m = jDaysUntil + 1;
                    j = nanoOfDay - 86400000000000L;
                }
                switch (C04691.$SwitchMap$java$time$temporal$ChronoUnit[((ChronoUnit) temporalUnit).ordinal()]) {
                    case 1:
                        jM1621m = Duration$$ExternalSyntheticBackport1.m1621m(jM1621m, 86400000000000L);
                        break;
                    case 2:
                        jM1621m = Duration$$ExternalSyntheticBackport1.m1621m(jM1621m, 86400000000L);
                        j /= 1000;
                        break;
                    case 3:
                        jM1621m = Duration$$ExternalSyntheticBackport1.m1621m(jM1621m, 86400000L);
                        j /= 1000000;
                        break;
                    case 4:
                        jM1621m = Duration$$ExternalSyntheticBackport1.m1621m(jM1621m, 86400);
                        j /= 1000000000;
                        break;
                    case 5:
                        jM1621m = Duration$$ExternalSyntheticBackport1.m1621m(jM1621m, 1440);
                        j /= 60000000000L;
                        break;
                    case 6:
                        jM1621m = Duration$$ExternalSyntheticBackport1.m1621m(jM1621m, 24);
                        j /= 3600000000000L;
                        break;
                    case 7:
                        jM1621m = Duration$$ExternalSyntheticBackport1.m1621m(jM1621m, 2);
                        j /= 43200000000000L;
                        break;
                }
                return Clock$OffsetClock$$ExternalSyntheticBackport0.m1617m(jM1621m, j);
            }
            LocalDate localDatePlusDays = localDateTimeFrom.date;
            if (localDatePlusDays.isAfter(this.date) && localDateTimeFrom.time.isBefore(this.time)) {
                localDatePlusDays = localDatePlusDays.minusDays(1L);
            } else if (localDatePlusDays.isBefore(this.date) && localDateTimeFrom.time.isAfter(this.time)) {
                localDatePlusDays = localDatePlusDays.plusDays(1L);
            }
            return this.date.until(localDatePlusDays, temporalUnit);
        }
        return temporalUnit.between(this, localDateTimeFrom);
    }

    public String format(DateTimeFormatter dateTimeFormatter) {
        Objects.requireNonNull(dateTimeFormatter, "formatter");
        return dateTimeFormatter.format(this);
    }

    public OffsetDateTime atOffset(ZoneOffset zoneOffset) {
        return OffsetDateTime.m1659of(this, zoneOffset);
    }

    @Override
    public ZonedDateTime atZone(ZoneId zoneId) {
        return ZonedDateTime.m1681of(this, zoneId);
    }

    @Override
    public int compareTo(ChronoLocalDateTime<?> chronoLocalDateTime) {
        if (chronoLocalDateTime instanceof LocalDateTime) {
            return compareTo0((LocalDateTime) chronoLocalDateTime);
        }
        return ChronoLocalDateTime.CC.$default$compareTo((ChronoLocalDateTime) this, (ChronoLocalDateTime) chronoLocalDateTime);
    }

    private int compareTo0(LocalDateTime localDateTime) {
        int iCompareTo0 = this.date.compareTo0(localDateTime.toLocalDate());
        return iCompareTo0 == 0 ? this.time.compareTo(localDateTime.toLocalTime()) : iCompareTo0;
    }

    public boolean isAfter(ChronoLocalDateTime chronoLocalDateTime) {
        if (chronoLocalDateTime instanceof LocalDateTime) {
            return compareTo0((LocalDateTime) chronoLocalDateTime) > 0;
        }
        return ChronoLocalDateTime.CC.$default$isAfter(this, chronoLocalDateTime);
    }

    public boolean isBefore(ChronoLocalDateTime chronoLocalDateTime) {
        if (chronoLocalDateTime instanceof LocalDateTime) {
            return compareTo0((LocalDateTime) chronoLocalDateTime) < 0;
        }
        return ChronoLocalDateTime.CC.$default$isBefore(this, chronoLocalDateTime);
    }

    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (!(obj instanceof LocalDateTime)) {
            return false;
        }
        LocalDateTime localDateTime = (LocalDateTime) obj;
        return this.date.equals(localDateTime.date) && this.time.equals(localDateTime.time);
    }

    @Override
    public int hashCode() {
        return this.date.hashCode() ^ this.time.hashCode();
    }

    @Override
    public String toString() {
        return this.date.toString() + "T" + this.time.toString();
    }

    private Object writeReplace() {
        return new Ser((byte) 5, this);
    }

    private void readObject(ObjectInputStream objectInputStream) throws InvalidObjectException {
        throw new InvalidObjectException("Deserialization via serialization delegate");
    }

    void writeExternal(DataOutput dataOutput) {
        this.date.writeExternal(dataOutput);
        this.time.writeExternal(dataOutput);
    }

    static LocalDateTime readExternal(DataInput dataInput) {
        return m1646of(LocalDate.readExternal(dataInput), LocalTime.readExternal(dataInput));
    }
}
