package p000j$.time.chrono;

import java.io.IOException;
import java.io.InvalidObjectException;
import java.io.ObjectInput;
import java.io.ObjectInputStream;
import java.io.ObjectOutput;
import java.io.Serializable;
import p000j$.time.Clock$OffsetClock$$ExternalSyntheticBackport0;
import p000j$.time.Clock$TickClock$$ExternalSyntheticBackport0;
import p000j$.time.DesugarLocalDate$$ExternalSyntheticBackport0;
import p000j$.time.Duration$$ExternalSyntheticBackport1;
import p000j$.time.Instant;
import p000j$.time.LocalTime;
import p000j$.time.ZoneId;
import p000j$.time.ZoneOffset;
import p000j$.time.temporal.ChronoField;
import p000j$.time.temporal.ChronoUnit;
import p000j$.time.temporal.Temporal;
import p000j$.time.temporal.TemporalAdjuster;
import p000j$.time.temporal.TemporalField;
import p000j$.time.temporal.TemporalQuery;
import p000j$.time.temporal.TemporalUnit;
import p000j$.time.temporal.ValueRange;
import p000j$.util.Objects;

final class ChronoLocalDateTimeImpl implements ChronoLocalDateTime, Temporal, TemporalAdjuster, Serializable {
    private static final long serialVersionUID = 4556003607393004514L;
    private final transient ChronoLocalDate date;
    private final transient LocalTime time;

    @Override
    public Temporal adjustInto(Temporal temporal) {
        return temporal.with(ChronoField.EPOCH_DAY, toLocalDate().toEpochDay()).with(ChronoField.NANO_OF_DAY, toLocalTime().toNanoOfDay());
    }

    @Override
    public int compareTo(ChronoLocalDateTime chronoLocalDateTime) {
        return ChronoLocalDateTime.CC.$default$compareTo((ChronoLocalDateTime) this, chronoLocalDateTime);
    }

    @Override
    public int compareTo(ChronoLocalDateTime<?> chronoLocalDateTime) {
        return compareTo((ChronoLocalDateTime) chronoLocalDateTime);
    }

    @Override
    public Chronology getChronology() {
        return toLocalDate().getChronology();
    }

    @Override
    public ChronoLocalDateTime minus(long j, TemporalUnit temporalUnit) {
        return ensureValid(getChronology(), Temporal.CC.$default$minus(this, j, temporalUnit));
    }

    @Override
    public Temporal minus(long j, TemporalUnit temporalUnit) {
        return minus(j, temporalUnit);
    }

    @Override
    public Object query(TemporalQuery temporalQuery) {
        return ChronoLocalDateTime.CC.$default$query(this, temporalQuery);
    }

    @Override
    public long toEpochSecond(ZoneOffset zoneOffset) {
        return ChronoLocalDateTime.CC.$default$toEpochSecond(this, zoneOffset);
    }

    public Instant toInstant(ZoneOffset zoneOffset) {
        return Instant.ofEpochSecond(toEpochSecond(zoneOffset), toLocalTime().getNano());
    }

    public static ChronoLocalDateTimeImpl m1687of(ChronoLocalDate chronoLocalDate, LocalTime localTime) {
        return new ChronoLocalDateTimeImpl(chronoLocalDate, localTime);
    }

    public static ChronoLocalDateTimeImpl ensureValid(Chronology chronology, Temporal temporal) {
        ChronoLocalDateTimeImpl chronoLocalDateTimeImpl = (ChronoLocalDateTimeImpl) temporal;
        if (chronology.equals(chronoLocalDateTimeImpl.getChronology())) {
            return chronoLocalDateTimeImpl;
        }
        throw new ClassCastException("Chronology mismatch, required: " + chronology.getId() + ", actual: " + chronoLocalDateTimeImpl.getChronology().getId());
    }

    private ChronoLocalDateTimeImpl(ChronoLocalDate chronoLocalDate, LocalTime localTime) {
        Objects.requireNonNull(chronoLocalDate, "date");
        Objects.requireNonNull(localTime, "time");
        this.date = chronoLocalDate;
        this.time = localTime;
    }

    private ChronoLocalDateTimeImpl with(Temporal temporal, LocalTime localTime) {
        ChronoLocalDate chronoLocalDate = this.date;
        return (chronoLocalDate == temporal && this.time == localTime) ? this : new ChronoLocalDateTimeImpl(ChronoLocalDateImpl.ensureValid(chronoLocalDate.getChronology(), temporal), localTime);
    }

    @Override
    public ChronoLocalDate toLocalDate() {
        return this.date;
    }

    @Override
    public LocalTime toLocalTime() {
        return this.time;
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
        return range(temporalField).checkValidIntValue(getLong(temporalField), temporalField);
    }

    @Override
    public long getLong(TemporalField temporalField) {
        if (temporalField instanceof ChronoField) {
            return ((ChronoField) temporalField).isTimeBased() ? this.time.getLong(temporalField) : this.date.getLong(temporalField);
        }
        return temporalField.getFrom(this);
    }

    @Override
    public ChronoLocalDateTimeImpl with(TemporalAdjuster temporalAdjuster) {
        if (temporalAdjuster instanceof ChronoLocalDate) {
            return with((ChronoLocalDate) temporalAdjuster, this.time);
        }
        if (temporalAdjuster instanceof LocalTime) {
            return with(this.date, (LocalTime) temporalAdjuster);
        }
        if (temporalAdjuster instanceof ChronoLocalDateTimeImpl) {
            return ensureValid(this.date.getChronology(), (ChronoLocalDateTimeImpl) temporalAdjuster);
        }
        return ensureValid(this.date.getChronology(), (ChronoLocalDateTimeImpl) temporalAdjuster.adjustInto(this));
    }

    @Override
    public ChronoLocalDateTimeImpl with(TemporalField temporalField, long j) {
        if (temporalField instanceof ChronoField) {
            if (((ChronoField) temporalField).isTimeBased()) {
                return with(this.date, this.time.with(temporalField, j));
            }
            return with(this.date.with(temporalField, j), this.time);
        }
        return ensureValid(this.date.getChronology(), temporalField.adjustInto(this, j));
    }

    @Override
    public ChronoLocalDateTimeImpl plus(long j, TemporalUnit temporalUnit) {
        if (temporalUnit instanceof ChronoUnit) {
            switch (C04791.$SwitchMap$java$time$temporal$ChronoUnit[((ChronoUnit) temporalUnit).ordinal()]) {
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
        return ensureValid(this.date.getChronology(), temporalUnit.addTo(this, j));
    }

    static class C04791 {
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

    private ChronoLocalDateTimeImpl plusDays(long j) {
        return with(this.date.plus(j, (TemporalUnit) ChronoUnit.DAYS), this.time);
    }

    private ChronoLocalDateTimeImpl plusHours(long j) {
        return plusWithOverflow(this.date, j, 0L, 0L, 0L);
    }

    private ChronoLocalDateTimeImpl plusMinutes(long j) {
        return plusWithOverflow(this.date, 0L, j, 0L, 0L);
    }

    ChronoLocalDateTimeImpl plusSeconds(long j) {
        return plusWithOverflow(this.date, 0L, 0L, j, 0L);
    }

    private ChronoLocalDateTimeImpl plusNanos(long j) {
        return plusWithOverflow(this.date, 0L, 0L, 0L, j);
    }

    private ChronoLocalDateTimeImpl plusWithOverflow(ChronoLocalDate chronoLocalDate, long j, long j2, long j3, long j4) {
        if ((j | j2 | j3 | j4) == 0) {
            return with(chronoLocalDate, this.time);
        }
        long nanoOfDay = this.time.toNanoOfDay();
        long j5 = (j4 % 86400000000000L) + ((j3 % 86400) * 1000000000) + ((j2 % 1440) * 60000000000L) + ((j % 24) * 3600000000000L) + nanoOfDay;
        long jM1620m = (j4 / 86400000000000L) + (j3 / 86400) + (j2 / 1440) + (j / 24) + DesugarLocalDate$$ExternalSyntheticBackport0.m1620m(j5, 86400000000000L);
        long jM1618m = Clock$TickClock$$ExternalSyntheticBackport0.m1618m(j5, 86400000000000L);
        return with(chronoLocalDate.plus(jM1620m, (TemporalUnit) ChronoUnit.DAYS), jM1618m == nanoOfDay ? this.time : LocalTime.ofNanoOfDay(jM1618m));
    }

    @Override
    public ChronoZonedDateTime atZone(ZoneId zoneId) {
        return ChronoZonedDateTimeImpl.ofBest(this, zoneId, null);
    }

    @Override
    public long until(Temporal temporal, TemporalUnit temporalUnit) {
        Objects.requireNonNull(temporal, "endExclusive");
        ChronoLocalDateTime chronoLocalDateTimeLocalDateTime = getChronology().localDateTime(temporal);
        if (temporalUnit instanceof ChronoUnit) {
            if (temporalUnit.isTimeBased()) {
                ChronoField chronoField = ChronoField.EPOCH_DAY;
                long jM1621m = chronoLocalDateTimeLocalDateTime.getLong(chronoField) - this.date.getLong(chronoField);
                switch (C04791.$SwitchMap$java$time$temporal$ChronoUnit[((ChronoUnit) temporalUnit).ordinal()]) {
                    case 1:
                        jM1621m = Duration$$ExternalSyntheticBackport1.m1621m(jM1621m, 86400000000000L);
                        break;
                    case 2:
                        jM1621m = Duration$$ExternalSyntheticBackport1.m1621m(jM1621m, 86400000000L);
                        break;
                    case 3:
                        jM1621m = Duration$$ExternalSyntheticBackport1.m1621m(jM1621m, 86400000L);
                        break;
                    case 4:
                        jM1621m = Duration$$ExternalSyntheticBackport1.m1621m(jM1621m, 86400);
                        break;
                    case 5:
                        jM1621m = Duration$$ExternalSyntheticBackport1.m1621m(jM1621m, 1440);
                        break;
                    case 6:
                        jM1621m = Duration$$ExternalSyntheticBackport1.m1621m(jM1621m, 24);
                        break;
                    case 7:
                        jM1621m = Duration$$ExternalSyntheticBackport1.m1621m(jM1621m, 2);
                        break;
                }
                return Clock$OffsetClock$$ExternalSyntheticBackport0.m1617m(jM1621m, this.time.until(chronoLocalDateTimeLocalDateTime.toLocalTime(), temporalUnit));
            }
            ChronoLocalDate localDate = chronoLocalDateTimeLocalDateTime.toLocalDate();
            if (chronoLocalDateTimeLocalDateTime.toLocalTime().isBefore(this.time)) {
                localDate = localDate.minus(1L, (TemporalUnit) ChronoUnit.DAYS);
            }
            return this.date.until(localDate, temporalUnit);
        }
        Objects.requireNonNull(temporalUnit, "unit");
        return temporalUnit.between(this, chronoLocalDateTimeLocalDateTime);
    }

    private Object writeReplace() {
        return new Ser((byte) 2, this);
    }

    private void readObject(ObjectInputStream objectInputStream) throws InvalidObjectException {
        throw new InvalidObjectException("Deserialization via serialization delegate");
    }

    void writeExternal(ObjectOutput objectOutput) throws IOException {
        objectOutput.writeObject(this.date);
        objectOutput.writeObject(this.time);
    }

    static ChronoLocalDateTime readExternal(ObjectInput objectInput) {
        return ((ChronoLocalDate) objectInput.readObject()).atTime((LocalTime) objectInput.readObject());
    }

    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        return (obj instanceof ChronoLocalDateTime) && compareTo((ChronoLocalDateTime) obj) == 0;
    }

    @Override
    public int hashCode() {
        return toLocalDate().hashCode() ^ toLocalTime().hashCode();
    }

    @Override
    public String toString() {
        return toLocalDate().toString() + "T" + toLocalTime().toString();
    }
}
