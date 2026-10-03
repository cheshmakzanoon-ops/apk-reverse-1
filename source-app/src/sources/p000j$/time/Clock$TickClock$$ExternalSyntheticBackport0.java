package p000j$.time;

public abstract class Clock$TickClock$$ExternalSyntheticBackport0 {
    public static long m1618m(long j, long j2) {
        long j3 = j % j2;
        if (j3 == 0) {
            return 0L;
        }
        return (((j ^ j2) >> 63) | 1) > 0 ? j3 : j3 + j2;
    }
}
