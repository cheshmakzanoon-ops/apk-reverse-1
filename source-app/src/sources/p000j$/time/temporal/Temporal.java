package p000j$.time.temporal;

public interface Temporal extends TemporalAccessor {
    Temporal minus(long j, TemporalUnit temporalUnit);

    Temporal plus(long j, TemporalUnit temporalUnit);

    long until(Temporal temporal, TemporalUnit temporalUnit);

    Temporal with(TemporalAdjuster temporalAdjuster);

    Temporal with(TemporalField temporalField, long j);

    public abstract class CC {
        public static Temporal $default$minus(Temporal temporal, long j, TemporalUnit temporalUnit) {
            long j2;
            if (j == Long.MIN_VALUE) {
                temporal = temporal.plus(Long.MAX_VALUE, temporalUnit);
                j2 = 1;
            } else {
                j2 = -j;
            }
            return temporal.plus(j2, temporalUnit);
        }
    }
}
