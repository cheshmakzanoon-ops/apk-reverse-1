package p000j$.time.temporal;

import p000j$.time.LocalDate;
import p000j$.time.LocalTime;
import p000j$.time.ZoneId;
import p000j$.time.ZoneOffset;
import p000j$.time.chrono.Chronology;

public abstract class TemporalQueries {
    static final TemporalQuery ZONE_ID = new TemporalQuery() {
        @Override
        public ZoneId queryFrom(TemporalAccessor temporalAccessor) {
            return (ZoneId) temporalAccessor.query(TemporalQueries.ZONE_ID);
        }

        public String toString() {
            return "ZoneId";
        }
    };
    static final TemporalQuery CHRONO = new TemporalQuery() {
        @Override
        public Chronology queryFrom(TemporalAccessor temporalAccessor) {
            return (Chronology) temporalAccessor.query(TemporalQueries.CHRONO);
        }

        public String toString() {
            return "Chronology";
        }
    };
    static final TemporalQuery PRECISION = new TemporalQuery() {
        @Override
        public TemporalUnit queryFrom(TemporalAccessor temporalAccessor) {
            return (TemporalUnit) temporalAccessor.query(TemporalQueries.PRECISION);
        }

        public String toString() {
            return "Precision";
        }
    };
    static final TemporalQuery OFFSET = new TemporalQuery() {
        @Override
        public ZoneOffset queryFrom(TemporalAccessor temporalAccessor) {
            ChronoField chronoField = ChronoField.OFFSET_SECONDS;
            if (temporalAccessor.isSupported(chronoField)) {
                return ZoneOffset.ofTotalSeconds(temporalAccessor.get(chronoField));
            }
            return null;
        }

        public String toString() {
            return "ZoneOffset";
        }
    };
    static final TemporalQuery ZONE = new TemporalQuery() {
        @Override
        public ZoneId queryFrom(TemporalAccessor temporalAccessor) {
            ZoneId zoneId = (ZoneId) temporalAccessor.query(TemporalQueries.ZONE_ID);
            return zoneId != null ? zoneId : (ZoneId) temporalAccessor.query(TemporalQueries.OFFSET);
        }

        public String toString() {
            return "Zone";
        }
    };
    static final TemporalQuery LOCAL_DATE = new TemporalQuery() {
        @Override
        public LocalDate queryFrom(TemporalAccessor temporalAccessor) {
            ChronoField chronoField = ChronoField.EPOCH_DAY;
            if (temporalAccessor.isSupported(chronoField)) {
                return LocalDate.ofEpochDay(temporalAccessor.getLong(chronoField));
            }
            return null;
        }

        public String toString() {
            return "LocalDate";
        }
    };
    static final TemporalQuery LOCAL_TIME = new TemporalQuery() {
        @Override
        public LocalTime queryFrom(TemporalAccessor temporalAccessor) {
            ChronoField chronoField = ChronoField.NANO_OF_DAY;
            if (temporalAccessor.isSupported(chronoField)) {
                return LocalTime.ofNanoOfDay(temporalAccessor.getLong(chronoField));
            }
            return null;
        }

        public String toString() {
            return "LocalTime";
        }
    };

    public static TemporalQuery zoneId() {
        return ZONE_ID;
    }

    public static TemporalQuery chronology() {
        return CHRONO;
    }

    public static TemporalQuery precision() {
        return PRECISION;
    }

    public static TemporalQuery zone() {
        return ZONE;
    }

    public static TemporalQuery offset() {
        return OFFSET;
    }

    public static TemporalQuery localDate() {
        return LOCAL_DATE;
    }

    public static TemporalQuery localTime() {
        return LOCAL_TIME;
    }
}
