package p000j$.time;

public abstract class Clock$OffsetClock$$ExternalSyntheticBackport0 {
    public static long m1617m(long j, long j2) {
        long j3 = j + j2;
        if (((j2 ^ j) < 0) || ((j ^ j3) >= 0)) {
            return j3;
        }
        throw new ArithmeticException();
    }
}
