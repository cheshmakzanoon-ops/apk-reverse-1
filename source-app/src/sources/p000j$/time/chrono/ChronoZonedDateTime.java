package p000j$.time.chrono;

import p000j$.time.LocalTime;
import p000j$.time.ZoneId;
import p000j$.time.ZoneOffset;
import p000j$.time.temporal.ChronoField;
import p000j$.time.temporal.ChronoUnit;
import p000j$.time.temporal.Temporal;
import p000j$.time.temporal.TemporalAccessor;
import p000j$.time.temporal.TemporalAdjuster;
import p000j$.time.temporal.TemporalField;
import p000j$.time.temporal.TemporalQueries;
import p000j$.time.temporal.TemporalQuery;
import p000j$.time.temporal.TemporalUnit;
import p000j$.time.temporal.UnsupportedTemporalTypeException;
import p000j$.time.temporal.ValueRange;

public interface ChronoZonedDateTime extends Temporal, Comparable {
    int compareTo(ChronoZonedDateTime chronoZonedDateTime);

    Chronology getChronology();

    ZoneOffset getOffset();

    ZoneId getZone();

    @Override
    ChronoZonedDateTime minus(long j, TemporalUnit temporalUnit);

    long toEpochSecond();

    ChronoLocalDate toLocalDate();

    ChronoLocalDateTime toLocalDateTime();

    LocalTime toLocalTime();

    @Override
    ChronoZonedDateTime with(TemporalAdjuster temporalAdjuster);

    ChronoZonedDateTime withZoneSameInstant(ZoneId zoneId);

    ChronoZonedDateTime withZoneSameLocal(ZoneId zoneId);

    public abstract class CC {
        public static ValueRange $default$range(ChronoZonedDateTime chronoZonedDateTime, TemporalField temporalField) {
            if (temporalField instanceof ChronoField) {
                if (temporalField == ChronoField.INSTANT_SECONDS || temporalField == ChronoField.OFFSET_SECONDS) {
                    return temporalField.range();
                }
                return chronoZonedDateTime.toLocalDateTime().range(temporalField);
            }
            return temporalField.rangeRefinedBy(chronoZonedDateTime);
        }

        public static int $default$get(ChronoZonedDateTime chronoZonedDateTime, TemporalField temporalField) {
            if (temporalField instanceof ChronoField) {
                int i = C04801.$SwitchMap$java$time$temporal$ChronoField[((ChronoField) temporalField).ordinal()];
                if (i == 1) {
                    throw new UnsupportedTemporalTypeException("Invalid field 'InstantSeconds' for get() method, use getLong() instead");
                }
                if (i == 2) {
                    return chronoZonedDateTime.getOffset().getTotalSeconds();
                }
                return chronoZonedDateTime.toLocalDateTime().get(temporalField);
            }
            return TemporalAccessor.CC.$default$get(chronoZonedDateTime, temporalField);
        }

        public static long $default$getLong(ChronoZonedDateTime chronoZonedDateTime, TemporalField temporalField) {
            if (temporalField instanceof ChronoField) {
                int i = C04801.$SwitchMap$java$time$temporal$ChronoField[((ChronoField) temporalField).ordinal()];
                if (i == 1) {
                    return chronoZonedDateTime.toEpochSecond();
                }
                if (i == 2) {
                    return chronoZonedDateTime.getOffset().getTotalSeconds();
                }
                return chronoZonedDateTime.toLocalDateTime().getLong(temporalField);
            }
            return temporalField.getFrom(chronoZonedDateTime);
        }

        public static Object $default$query(ChronoZonedDateTime chronoZonedDateTime, TemporalQuery temporalQuery) {
            if (temporalQuery == TemporalQueries.zone() || temporalQuery == TemporalQueries.zoneId()) {
                return chronoZonedDateTime.getZone();
            }
            if (temporalQuery == TemporalQueries.offset()) {
                return chronoZonedDateTime.getOffset();
            }
            if (temporalQuery == TemporalQueries.localTime()) {
                return chronoZonedDateTime.toLocalTime();
            }
            if (temporalQuery == TemporalQueries.chronology()) {
                return chronoZonedDateTime.getChronology();
            }
            if (temporalQuery == TemporalQueries.precision()) {
                return ChronoUnit.NANOS;
            }
            return temporalQuery.queryFrom(chronoZonedDateTime);
        }

        public static long $default$toEpochSecond(ChronoZonedDateTime chronoZonedDateTime) {
            return ((chronoZonedDateTime.toLocalDate().toEpochDay() * 86400) + ((long) chronoZonedDateTime.toLocalTime().toSecondOfDay())) - ((long) chronoZonedDateTime.getOffset().getTotalSeconds());
        }

        public static int $default$compareTo(ChronoZonedDateTime chronoZonedDateTime, ChronoZonedDateTime chronoZonedDateTime2) {
            int iCompare = Long.compare(chronoZonedDateTime.toEpochSecond(), chronoZonedDateTime2.toEpochSecond());
            if (iCompare != 0) {
                return iCompare;
            }
            int nano = chronoZonedDateTime.toLocalTime().getNano() - chronoZonedDateTime2.toLocalTime().getNano();
            if (nano != 0) {
                return nano;
            }
            int iCompareTo = chronoZonedDateTime.toLocalDateTime().compareTo(chronoZonedDateTime2.toLocalDateTime());
            if (iCompareTo != 0) {
                return iCompareTo;
            }
            int iCompareTo2 = chronoZonedDateTime.getZone().getId().compareTo(chronoZonedDateTime2.getZone().getId());
            return iCompareTo2 == 0 ? chronoZonedDateTime.getChronology().compareTo(chronoZonedDateTime2.getChronology()) : iCompareTo2;
        }
    }

    protected static class C04801 {
        static final int[] $SwitchMap$java$time$temporal$ChronoField;

        static {
            int[] iArr = new int[ChronoField.values().length];
            $SwitchMap$java$time$temporal$ChronoField = iArr;
            try {
                iArr[ChronoField.INSTANT_SECONDS.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                $SwitchMap$java$time$temporal$ChronoField[ChronoField.OFFSET_SECONDS.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
        }
    }
}
