package p000j$.time.chrono;

import p000j$.time.LocalTime;
import p000j$.time.temporal.ChronoField;
import p000j$.time.temporal.ChronoUnit;
import p000j$.time.temporal.Temporal;
import p000j$.time.temporal.TemporalAdjuster;
import p000j$.time.temporal.TemporalAmount;
import p000j$.time.temporal.TemporalField;
import p000j$.time.temporal.TemporalQueries;
import p000j$.time.temporal.TemporalQuery;
import p000j$.time.temporal.TemporalUnit;
import p000j$.time.temporal.UnsupportedTemporalTypeException;

public interface ChronoLocalDate extends Temporal, TemporalAdjuster, Comparable {
    ChronoLocalDateTime atTime(LocalTime localTime);

    int compareTo(ChronoLocalDate chronoLocalDate);

    boolean equals(Object obj);

    Chronology getChronology();

    Era getEra();

    int hashCode();

    boolean isLeapYear();

    @Override
    boolean isSupported(TemporalField temporalField);

    int lengthOfYear();

    @Override
    ChronoLocalDate minus(long j, TemporalUnit temporalUnit);

    @Override
    ChronoLocalDate plus(long j, TemporalUnit temporalUnit);

    ChronoLocalDate plus(TemporalAmount temporalAmount);

    long toEpochDay();

    String toString();

    @Override
    long until(Temporal temporal, TemporalUnit temporalUnit);

    @Override
    ChronoLocalDate with(TemporalAdjuster temporalAdjuster);

    @Override
    ChronoLocalDate with(TemporalField temporalField, long j);

    public abstract class CC {
        public static int $default$lengthOfYear(ChronoLocalDate chronoLocalDate) {
            return chronoLocalDate.isLeapYear() ? 366 : 365;
        }

        public static boolean $default$isSupported(ChronoLocalDate chronoLocalDate, TemporalField temporalField) {
            if (temporalField instanceof ChronoField) {
                return temporalField.isDateBased();
            }
            return temporalField != null && temporalField.isSupportedBy(chronoLocalDate);
        }

        public static ChronoLocalDate $default$with(ChronoLocalDate chronoLocalDate, TemporalField temporalField, long j) {
            if (temporalField instanceof ChronoField) {
                throw new UnsupportedTemporalTypeException("Unsupported field: " + temporalField);
            }
            return ChronoLocalDateImpl.ensureValid(chronoLocalDate.getChronology(), temporalField.adjustInto(chronoLocalDate, j));
        }

        public static ChronoLocalDate $default$plus(ChronoLocalDate chronoLocalDate, long j, TemporalUnit temporalUnit) {
            if (temporalUnit instanceof ChronoUnit) {
                throw new UnsupportedTemporalTypeException("Unsupported unit: " + temporalUnit);
            }
            return ChronoLocalDateImpl.ensureValid(chronoLocalDate.getChronology(), temporalUnit.addTo(chronoLocalDate, j));
        }

        public static Object $default$query(ChronoLocalDate chronoLocalDate, TemporalQuery temporalQuery) {
            if (temporalQuery == TemporalQueries.zoneId() || temporalQuery == TemporalQueries.zone() || temporalQuery == TemporalQueries.offset() || temporalQuery == TemporalQueries.localTime()) {
                return null;
            }
            if (temporalQuery == TemporalQueries.chronology()) {
                return chronoLocalDate.getChronology();
            }
            if (temporalQuery == TemporalQueries.precision()) {
                return ChronoUnit.DAYS;
            }
            return temporalQuery.queryFrom(chronoLocalDate);
        }

        public static int $default$compareTo(ChronoLocalDate chronoLocalDate, ChronoLocalDate chronoLocalDate2) {
            int iCompare = Long.compare(chronoLocalDate.toEpochDay(), chronoLocalDate2.toEpochDay());
            return iCompare == 0 ? chronoLocalDate.getChronology().compareTo(chronoLocalDate2.getChronology()) : iCompare;
        }

        public static boolean $default$isAfter(ChronoLocalDate chronoLocalDate, ChronoLocalDate chronoLocalDate2) {
            return chronoLocalDate.toEpochDay() > chronoLocalDate2.toEpochDay();
        }

        public static boolean $default$isBefore(ChronoLocalDate chronoLocalDate, ChronoLocalDate chronoLocalDate2) {
            return chronoLocalDate.toEpochDay() < chronoLocalDate2.toEpochDay();
        }
    }
}
