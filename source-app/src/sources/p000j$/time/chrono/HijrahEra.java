package p000j$.time.chrono;

import p000j$.time.temporal.ChronoField;
import p000j$.time.temporal.Temporal;
import p000j$.time.temporal.TemporalAccessor;
import p000j$.time.temporal.TemporalField;
import p000j$.time.temporal.TemporalQuery;
import p000j$.time.temporal.ValueRange;

public enum HijrahEra implements Era {
    AH;

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
    public int getValue() {
        return 1;
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
        if (temporalField == ChronoField.ERA) {
            return ValueRange.m1708of(1L, 1L);
        }
        return TemporalAccessor.CC.$default$range(this, temporalField);
    }
}
