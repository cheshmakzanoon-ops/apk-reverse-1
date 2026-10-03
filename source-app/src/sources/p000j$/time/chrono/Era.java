package p000j$.time.chrono;

import p000j$.time.temporal.ChronoField;
import p000j$.time.temporal.ChronoUnit;
import p000j$.time.temporal.TemporalAccessor;
import p000j$.time.temporal.TemporalAdjuster;
import p000j$.time.temporal.TemporalField;
import p000j$.time.temporal.TemporalQueries;
import p000j$.time.temporal.TemporalQuery;
import p000j$.time.temporal.UnsupportedTemporalTypeException;

public interface Era extends TemporalAccessor, TemporalAdjuster {
    int getValue();

    public abstract class CC {
        public static boolean $default$isSupported(Era era, TemporalField temporalField) {
            if (temporalField instanceof ChronoField) {
                return temporalField == ChronoField.ERA;
            }
            return temporalField != null && temporalField.isSupportedBy(era);
        }

        public static int $default$get(Era era, TemporalField temporalField) {
            if (temporalField == ChronoField.ERA) {
                return era.getValue();
            }
            return TemporalAccessor.CC.$default$get(era, temporalField);
        }

        public static long $default$getLong(Era era, TemporalField temporalField) {
            if (temporalField == ChronoField.ERA) {
                return era.getValue();
            }
            if (temporalField instanceof ChronoField) {
                throw new UnsupportedTemporalTypeException("Unsupported field: " + temporalField);
            }
            return temporalField.getFrom(era);
        }

        public static Object $default$query(Era era, TemporalQuery temporalQuery) {
            if (temporalQuery == TemporalQueries.precision()) {
                return ChronoUnit.ERAS;
            }
            return TemporalAccessor.CC.$default$query(era, temporalQuery);
        }
    }
}
