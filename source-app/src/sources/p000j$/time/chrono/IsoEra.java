package p000j$.time.chrono;

import p000j$.time.DateTimeException;
import p000j$.time.temporal.ChronoField;
import p000j$.time.temporal.Temporal;
import p000j$.time.temporal.TemporalAccessor;
import p000j$.time.temporal.TemporalField;
import p000j$.time.temporal.TemporalQuery;
import p000j$.time.temporal.ValueRange;

public enum IsoEra implements Era {
    BCE,
    CE;

    @Override
    public Temporal adjustInto(Temporal temporal) {
        return temporal.with(ChronoField.ERA, getValue());
    }

    @Override
    public int get(TemporalField temporalField) {
        return Era.CC.$default$get(this, temporalField);
    }

    @Override
    public long getLong(TemporalField temporalField) {
        return Era.CC.$default$getLong(this, temporalField);
    }

    @Override
    public boolean isSupported(TemporalField temporalField) {
        return Era.CC.$default$isSupported(this, temporalField);
    }

    @Override
    public Object query(TemporalQuery temporalQuery) {
        return Era.CC.$default$query(this, temporalQuery);
    }

    @Override
    public ValueRange range(TemporalField temporalField) {
        return TemporalAccessor.CC.$default$range(this, temporalField);
    }

    public static IsoEra m1698of(int i) {
        if (i == 0) {
            return BCE;
        }
        if (i == 1) {
            return CE;
        }
        throw new DateTimeException("Invalid era: " + i);
    }

    @Override
    public int getValue() {
        return ordinal();
    }
}
