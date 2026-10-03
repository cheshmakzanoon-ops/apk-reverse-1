package p000j$.time.temporal;

import java.util.Map;
import p000j$.time.format.ResolverStyle;

public interface TemporalField {

    public abstract class CC {
        public static TemporalAccessor $default$resolve(TemporalField temporalField, Map map, TemporalAccessor temporalAccessor, ResolverStyle resolverStyle) {
            return null;
        }
    }

    Temporal adjustInto(Temporal temporal, long j);

    long getFrom(TemporalAccessor temporalAccessor);

    boolean isDateBased();

    boolean isSupportedBy(TemporalAccessor temporalAccessor);

    boolean isTimeBased();

    ValueRange range();

    ValueRange rangeRefinedBy(TemporalAccessor temporalAccessor);

    TemporalAccessor resolve(Map map, TemporalAccessor temporalAccessor, ResolverStyle resolverStyle);
}
