package p000j$.time.chrono;

import java.io.InvalidObjectException;
import java.io.ObjectInputStream;
import java.io.Serializable;
import java.util.List;
import java.util.Map;
import p000j$.time.Clock;
import p000j$.time.DateTimeException;
import p000j$.time.DesugarLocalDate$$ExternalSyntheticBackport0;
import p000j$.time.Duration$DurationUnits$$ExternalSyntheticBackport0;
import p000j$.time.Instant;
import p000j$.time.Instant$$ExternalSyntheticBackport6;
import p000j$.time.LocalDate;
import p000j$.time.LocalDateTime;
import p000j$.time.Month;
import p000j$.time.Year;
import p000j$.time.ZoneId;
import p000j$.time.ZonedDateTime;
import p000j$.time.format.ResolverStyle;
import p000j$.time.temporal.ChronoField;
import p000j$.time.temporal.TemporalAccessor;
import p000j$.time.temporal.ValueRange;
import p000j$.util.Objects;

public final class IsoChronology extends AbstractChronology implements Serializable {
    public static final IsoChronology INSTANCE = new IsoChronology();
    private static final long serialVersionUID = -1440403870442975015L;

    private IsoChronology() {
    }

    @Override
    public String getId() {
        return "ISO";
    }

    @Override
    public String getCalendarType() {
        return "iso8601";
    }

    @Override
    public LocalDate date(int i, int i2, int i3) {
        return LocalDate.m1633of(i, i2, i3);
    }

    @Override
    public LocalDate dateYearDay(int i, int i2) {
        return LocalDate.ofYearDay(i, i2);
    }

    @Override
    public LocalDate dateEpochDay(long j) {
        return LocalDate.ofEpochDay(j);
    }

    @Override
    public LocalDate date(TemporalAccessor temporalAccessor) {
        return LocalDate.from(temporalAccessor);
    }

    @Override
    public LocalDateTime localDateTime(TemporalAccessor temporalAccessor) {
        return LocalDateTime.from(temporalAccessor);
    }

    @Override
    public ZonedDateTime zonedDateTime(TemporalAccessor temporalAccessor) {
        return ZonedDateTime.from(temporalAccessor);
    }

    @Override
    public ZonedDateTime zonedDateTime(Instant instant, ZoneId zoneId) {
        return ZonedDateTime.ofInstant(instant, zoneId);
    }

    @Override
    public LocalDate dateNow() {
        return dateNow(Clock.systemDefaultZone());
    }

    public LocalDate dateNow(Clock clock) {
        Objects.requireNonNull(clock, "clock");
        return date((TemporalAccessor) LocalDate.now(clock));
    }

    @Override
    public boolean isLeapYear(long j) {
        return (3 & j) == 0 && (j % 100 != 0 || j % 400 == 0);
    }

    @Override
    public int prolepticYear(Era era, int i) {
        if (era instanceof IsoEra) {
            return era == IsoEra.CE ? i : 1 - i;
        }
        throw new ClassCastException("Era must be IsoEra");
    }

    @Override
    public IsoEra eraOf(int i) {
        return IsoEra.m1698of(i);
    }

    @Override
    public List eras() {
        return Duration$DurationUnits$$ExternalSyntheticBackport0.m1623m(IsoEra.values());
    }

    @Override
    public LocalDate resolveDate(Map map, ResolverStyle resolverStyle) {
        return (LocalDate) super.resolveDate(map, resolverStyle);
    }

    @Override
    void resolveProlepticMonth(Map map, ResolverStyle resolverStyle) {
        ChronoField chronoField = ChronoField.PROLEPTIC_MONTH;
        Long l = (Long) map.remove(chronoField);
        if (l != null) {
            if (resolverStyle != ResolverStyle.LENIENT) {
                chronoField.checkValidValue(l.longValue());
            }
            addFieldValue(map, ChronoField.MONTH_OF_YEAR, IsoChronology$$ExternalSyntheticBackport0.m1696m(l.longValue(), 12) + 1);
            addFieldValue(map, ChronoField.YEAR, DesugarLocalDate$$ExternalSyntheticBackport0.m1620m(l.longValue(), 12));
        }
    }

    @Override
    public LocalDate resolveYearOfEra(Map map, ResolverStyle resolverStyle) {
        ChronoField chronoField = ChronoField.YEAR_OF_ERA;
        Long l = (Long) map.remove(chronoField);
        if (l != null) {
            if (resolverStyle != ResolverStyle.LENIENT) {
                chronoField.checkValidValue(l.longValue());
            }
            Long l2 = (Long) map.remove(ChronoField.ERA);
            if (l2 != null) {
                if (l2.longValue() == 1) {
                    addFieldValue(map, ChronoField.YEAR, l.longValue());
                    return null;
                }
                if (l2.longValue() == 0) {
                    addFieldValue(map, ChronoField.YEAR, Instant$$ExternalSyntheticBackport6.m1630m(1L, l.longValue()));
                    return null;
                }
                throw new DateTimeException("Invalid value for era: " + l2);
            }
            ChronoField chronoField2 = ChronoField.YEAR;
            Long l3 = (Long) map.get(chronoField2);
            if (resolverStyle != ResolverStyle.STRICT) {
                addFieldValue(map, chronoField2, (l3 == null || l3.longValue() > 0) ? l.longValue() : Instant$$ExternalSyntheticBackport6.m1630m(1L, l.longValue()));
                return null;
            }
            if (l3 != null) {
                long jLongValue = l3.longValue();
                long jLongValue2 = l.longValue();
                if (jLongValue <= 0) {
                    jLongValue2 = Instant$$ExternalSyntheticBackport6.m1630m(1L, jLongValue2);
                }
                addFieldValue(map, chronoField2, jLongValue2);
                return null;
            }
            map.put(chronoField, l);
            return null;
        }
        ChronoField chronoField3 = ChronoField.ERA;
        if (!map.containsKey(chronoField3)) {
            return null;
        }
        chronoField3.checkValidValue(((Long) map.get(chronoField3)).longValue());
        return null;
    }

    @Override
    public LocalDate resolveYMD(Map map, ResolverStyle resolverStyle) {
        ChronoField chronoField = ChronoField.YEAR;
        int iCheckValidIntValue = chronoField.checkValidIntValue(((Long) map.remove(chronoField)).longValue());
        if (resolverStyle == ResolverStyle.LENIENT) {
            return LocalDate.m1633of(iCheckValidIntValue, 1, 1).plusMonths(Instant$$ExternalSyntheticBackport6.m1630m(((Long) map.remove(ChronoField.MONTH_OF_YEAR)).longValue(), 1L)).plusDays(Instant$$ExternalSyntheticBackport6.m1630m(((Long) map.remove(ChronoField.DAY_OF_MONTH)).longValue(), 1L));
        }
        ChronoField chronoField2 = ChronoField.MONTH_OF_YEAR;
        int iCheckValidIntValue2 = chronoField2.checkValidIntValue(((Long) map.remove(chronoField2)).longValue());
        ChronoField chronoField3 = ChronoField.DAY_OF_MONTH;
        int iCheckValidIntValue3 = chronoField3.checkValidIntValue(((Long) map.remove(chronoField3)).longValue());
        if (resolverStyle == ResolverStyle.SMART) {
            if (iCheckValidIntValue2 == 4 || iCheckValidIntValue2 == 6 || iCheckValidIntValue2 == 9 || iCheckValidIntValue2 == 11) {
                iCheckValidIntValue3 = Math.min(iCheckValidIntValue3, 30);
            } else if (iCheckValidIntValue2 == 2) {
                iCheckValidIntValue3 = Math.min(iCheckValidIntValue3, Month.FEBRUARY.length(Year.isLeap(iCheckValidIntValue)));
            }
        }
        return LocalDate.m1633of(iCheckValidIntValue, iCheckValidIntValue2, iCheckValidIntValue3);
    }

    @Override
    public ValueRange range(ChronoField chronoField) {
        return chronoField.range();
    }

    @Override
    Object writeReplace() {
        return super.writeReplace();
    }

    private void readObject(ObjectInputStream objectInputStream) throws InvalidObjectException {
        throw new InvalidObjectException("Deserialization via serialization delegate");
    }
}
