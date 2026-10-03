package p000j$.time.temporal;

public abstract class WeekFields$ComputedDayOfField$$ExternalSyntheticBackport0 {
    public static int m1713m(int i, int i2) {
        int i3 = i % i2;
        if (i3 == 0) {
            return 0;
        }
        return (((i ^ i2) >> 31) | 1) > 0 ? i3 : i3 + i2;
    }
}
