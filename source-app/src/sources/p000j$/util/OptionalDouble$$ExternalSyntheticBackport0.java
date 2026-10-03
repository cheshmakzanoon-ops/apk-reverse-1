package p000j$.util;

public abstract class OptionalDouble$$ExternalSyntheticBackport0 {
    public static int m1722m(double d) {
        long jDoubleToLongBits = Double.doubleToLongBits(d);
        return (int) (jDoubleToLongBits ^ (jDoubleToLongBits >>> 32));
    }
}
