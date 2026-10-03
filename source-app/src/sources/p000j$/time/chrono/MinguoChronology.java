package p000j$.time.chrono;

import java.io.InvalidObjectException;
import java.io.ObjectInputStream;
import java.io.Serializable;
import java.util.List;
import java.util.Map;
import p000j$.time.Clock;
import p000j$.time.Duration$DurationUnits$$ExternalSyntheticBackport0;
import p000j$.time.Instant;
import p000j$.time.LocalDate;
import p000j$.time.ZoneId;
import p000j$.time.format.ResolverStyle;
import p000j$.time.temporal.ChronoField;
import p000j$.time.temporal.TemporalAccessor;
import p000j$.time.temporal.ValueRange;

public final class MinguoChronology extends AbstractChronology implements Serializable {
    public static final MinguoChronology INSTANCE = new MinguoChronology();
    private static final long serialVersionUID = 1039765215346859963L;

    private MinguoChronology() {
    }

    @Override
    public String getId() {
        return "Minguo";
    }

    @Override
    public String getCalendarType() {
        return "roc";
    }

    @Override
    public MinguoDate date(int i, int i2, int i3) {
        return new MinguoDate(LocalDate.m1633of(i + 1911, i2, i3));
    }

    @Override
    public MinguoDate dateYearDay(int i, int i2) {
        return new MinguoDate(LocalDate.ofYearDay(i + 1911, i2));
    }

    @Override
    public MinguoDate dateEpochDay(long j) {
        return new MinguoDate(LocalDate.ofEpochDay(j));
    }

    @Override
    public MinguoDate dateNow() {
        return dateNow(Clock.systemDefaultZone());
    }

    public MinguoDate dateNow(Clock clock) {
        return date((TemporalAccessor) LocalDate.now(clock));
    }

    @Override
    public MinguoDate date(TemporalAccessor temporalAccessor) {
        if (temporalAccessor instanceof MinguoDate) {
            return (MinguoDate) temporalAccessor;
        }
        return new MinguoDate(LocalDate.from(temporalAccessor));
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
        return IsoChronology.INSTANCE.isLeapYear(j + 1911);
    }

    @Override
    public int prolepticYear(Era era, int i) {
        if (era instanceof MinguoEra) {
            return era == MinguoEra.ROC ? i : 1 - i;
        }
        throw new ClassCastException("Era must be MinguoEra");
    }

    @Override
    public MinguoEra eraOf(int i) {
        return MinguoEra.m1701of(i);
    }

    @Override
    public List eras() {
        return Duration$DurationUnits$$ExternalSyntheticBackport0.m1623m(MinguoEra.values());
    }

    static class C04861 {
        static final int[] $SwitchMap$java$time$temporal$ChronoField;

        static {
            int[] iArr = new int[ChronoField.values().length];
            $SwitchMap$java$time$temporal$ChronoField = iArr;
            try {
                iArr[ChronoField.PROLEPTIC_MONTH.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                $SwitchMap$java$time$temporal$ChronoField[ChronoField.YEAR_OF_ERA.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                $SwitchMap$java$time$temporal$ChronoField[ChronoField.YEAR.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
        }
    }

    @Override
    public ValueRange range(ChronoField chronoField) {
        int i = C04861.$SwitchMap$java$time$temporal$ChronoField[chronoField.ordinal()];
        if (i == 1) {
            ValueRange valueRangeRange = ChronoField.PROLEPTIC_MONTH.range();
            return ValueRange.m1708of(valueRangeRange.getMinimum() - 22932, valueRangeRange.getMaximum() - 22932);
        }
        if (i == 2) {
            ValueRange valueRangeRange2 = ChronoField.YEAR.range();
            return ValueRange.m1709of(1L, valueRangeRange2.getMaximum() - 1911, (-valueRangeRange2.getMinimum()) + 1912);
        }
        if (i == 3) {
            ValueRange valueRangeRange3 = ChronoField.YEAR.range();
            return ValueRange.m1708of(valueRangeRange3.getMinimum() - 1911, valueRangeRange3.getMaximum() - 1911);
        }
        return chronoField.range();
    }

    @Override
    public MinguoDate resolveDate(Map map, ResolverStyle resolverStyle) {
        return (MinguoDate) super.resolveDate(map, resolverStyle);
    }

    @Override
    Object writeReplace() {
        return super.writeReplace();
    }

    private void readObject(ObjectInputStream objectInputStream) throws InvalidObjectException {
        throw new InvalidObjectException("Deserialization via serialization delegate");
    }
}
