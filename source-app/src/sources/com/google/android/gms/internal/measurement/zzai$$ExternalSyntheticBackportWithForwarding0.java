package com.google.android.gms.internal.measurement;

import java.math.BigDecimal;
import java.math.BigInteger;

public final class zzai$$ExternalSyntheticBackportWithForwarding0 {
    public static BigDecimal m22m(BigDecimal bigDecimal) {
        return bigDecimal.signum() == 0 ? new BigDecimal(BigInteger.ZERO, 0) : bigDecimal.stripTrailingZeros();
    }
}
