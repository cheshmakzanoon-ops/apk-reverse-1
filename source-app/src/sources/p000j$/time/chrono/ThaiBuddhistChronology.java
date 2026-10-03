package p000j$.time.chrono;

import java.io.InvalidObjectException;
import java.io.ObjectInputStream;
import java.io.Serializable;
import java.util.HashMap;
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

public final class ThaiBuddhistChronology extends AbstractChronology implements Serializable {
    private static final HashMap ERA_FULL_NAMES;
    private static final HashMap ERA_NARROW_NAMES;
    private static final HashMap ERA_SHORT_NAMES;
    public static final ThaiBuddhistChronology INSTANCE = new ThaiBuddhistChronology();
    private static final long serialVersionUID = 2775954514031616474L;

    static {
        HashMap map = new HashMap();
        ERA_NARROW_NAMES = map;
        HashMap map2 = new HashMap();
        ERA_SHORT_NAMES = map2;
        HashMap map3 = new HashMap();
        ERA_FULL_NAMES = map3;
        map.put("en", new String[]{"BB", "BE"});
        map.put("th", new String[]{"BB", "BE"});
        map2.put("en", new String[]{"B.B.", "B.E."});
        map2.put("th", new String[]{"พ.ศ.", "ปีก่อนคริสต์กาลที่"});
        map3.put("en", new String[]{"Before Buddhist", "Budhhist Era"});
        map3.put("th", new String[]{"พุทธศักราช", "ปีก่อนคริสต์กาลที่"});
    }

    private ThaiBuddhistChronology() {
    }

    @Override
    public String getId() {
        return "ThaiBuddhist";
    }

    @Override
    public String getCalendarType() {
        return "buddhist";
    }

    @Override
    public ThaiBuddhistDate date(int i, int i2, int i3) {
        return new ThaiBuddhistDate(LocalDate.m1633of(i - 543, i2, i3));
    }

    @Override
    public ThaiBuddhistDate dateYearDay(int i, int i2) {
        return new ThaiBuddhistDate(LocalDate.ofYearDay(i - 543, i2));
    }

    @Override
    public ThaiBuddhistDate dateEpochDay(long j) {
        return new ThaiBuddhistDate(LocalDate.ofEpochDay(j));
    }

    @Override
    public ThaiBuddhistDate dateNow() {
        return dateNow(Clock.systemDefaultZone());
    }

    public ThaiBuddhistDate dateNow(Clock clock) {
        return date((TemporalAccessor) LocalDate.now(clock));
    }

    @Override
    public ThaiBuddhistDate date(TemporalAccessor temporalAccessor) {
        if (temporalAccessor instanceof ThaiBuddhistDate) {
            return (ThaiBuddhistDate) temporalAccessor;
        }
        return new ThaiBuddhistDate(LocalDate.from(temporalAccessor));
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
        return IsoChronology.INSTANCE.isLeapYear(j - 543);
    }

    @Override
    public int prolepticYear(Era era, int i) {
        if (era instanceof ThaiBuddhistEra) {
            return era == ThaiBuddhistEra.BE ? i : 1 - i;
        }
        throw new ClassCastException("Era must be BuddhistEra");
    }

    @Override
    public ThaiBuddhistEra eraOf(int i) {
        return ThaiBuddhistEra.m1702of(i);
    }

    @Override
    public List eras() {
        return Duration$DurationUnits$$ExternalSyntheticBackport0.m1623m(ThaiBuddhistEra.values());
    }

    static class C04881 {
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
        int i = C04881.$SwitchMap$java$time$temporal$ChronoField[chronoField.ordinal()];
        if (i == 1) {
            ValueRange valueRangeRange = ChronoField.PROLEPTIC_MONTH.range();
            return ValueRange.m1708of(valueRangeRange.getMinimum() + 6516, valueRangeRange.getMaximum() + 6516);
        }
        if (i == 2) {
            ValueRange valueRangeRange2 = ChronoField.YEAR.range();
            return ValueRange.m1709of(1L, (-(valueRangeRange2.getMinimum() + 543)) + 1, valueRangeRange2.getMaximum() + 543);
        }
        if (i == 3) {
            ValueRange valueRangeRange3 = ChronoField.YEAR.range();
            return ValueRange.m1708of(valueRangeRange3.getMinimum() + 543, valueRangeRange3.getMaximum() + 543);
        }
        return chronoField.range();
    }

    @Override
    public ThaiBuddhistDate resolveDate(Map map, ResolverStyle resolverStyle) {
        return (ThaiBuddhistDate) super.resolveDate(map, resolverStyle);
    }

    @Override
    Object writeReplace() {
        return super.writeReplace();
    }

    private void readObject(ObjectInputStream objectInputStream) throws InvalidObjectException {
        throw new InvalidObjectException("Deserialization via serialization delegate");
    }
}
