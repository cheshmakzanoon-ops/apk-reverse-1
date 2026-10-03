package com.google.common.math;

import java.math.BigDecimal;
import java.math.RoundingMode;

@ElementTypesAreNonnullByDefault
public class BigDecimalMath {
    private BigDecimalMath() {
    }

    public static double roundToDouble(BigDecimal bigDecimal, RoundingMode roundingMode) {
        return BigDecimalToDoubleRounder.INSTANCE.roundToDouble(bigDecimal, roundingMode);
    }

    private static class BigDecimalToDoubleRounder extends ToDoubleRounder<BigDecimal> {
        static final BigDecimalToDoubleRounder INSTANCE = new BigDecimalToDoubleRounder();

        private BigDecimalToDoubleRounder() {
        }

        @Override
        public double roundToDoubleArbitrarily(BigDecimal bigDecimal) {
            return bigDecimal.doubleValue();
        }

        @Override
        public int sign(BigDecimal bigDecimal) {
            return bigDecimal.signum();
        }

        @Override
        public BigDecimal toX(double d, RoundingMode roundingMode) {
            return new BigDecimal(d);
        }

        @Override
        public BigDecimal minus(BigDecimal bigDecimal, BigDecimal bigDecimal2) {
            return bigDecimal.subtract(bigDecimal2);
        }
    }
}
