package androidx.compose.animation.core;

import kotlin.Metadata;
import kotlin.jvm.functions.Function1;

@Metadata(d1 = {"\u00000\n\u0000\n\u0002\u0010\t\n\u0002\b\u0002\n\u0002\u0010\u0006\n\u0002\b\u0007\n\u0002\u0010\u0007\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\u001a0\u0010\u0002\u001a\u00020\u00012\u0006\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00042\u0006\u0010\u0006\u001a\u00020\u00042\u0006\u0010\u0007\u001a\u00020\u00042\u0006\u0010\b\u001a\u00020\u0004H\u0007\u001a8\u0010\u0002\u001a\u00020\u00012\u0006\u0010\t\u001a\u00020\u00042\u0006\u0010\n\u001a\u00020\u00042\u0006\u0010\u000b\u001a\u00020\u00042\u0006\u0010\u0006\u001a\u00020\u00042\u0006\u0010\u0007\u001a\u00020\u00042\u0006\u0010\b\u001a\u00020\u0004H\u0007\u001a0\u0010\u0002\u001a\u00020\u00012\u0006\u0010\u0003\u001a\u00020\f2\u0006\u0010\u0005\u001a\u00020\f2\u0006\u0010\u0006\u001a\u00020\f2\u0006\u0010\u0007\u001a\u00020\f2\u0006\u0010\b\u001a\u00020\fH\u0007\u001a(\u0010\r\u001a\u00020\u00042\u0006\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u00042\u0006\u0010\u0011\u001a\u00020\u00042\u0006\u0010\b\u001a\u00020\u0004H\u0002\u001a8\u0010\u0012\u001a\u00020\u00012\u0006\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\u0013\u001a\u00020\u000f2\u0006\u0010\u0005\u001a\u00020\u00042\u0006\u0010\u0006\u001a\u00020\u00042\u0006\u0010\u0014\u001a\u00020\u00042\u0006\u0010\b\u001a\u00020\u0004H\u0002\u001a0\u0010\u0015\u001a\u00020\u00042\u0006\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\u0013\u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u00042\u0006\u0010\u0011\u001a\u00020\u00042\u0006\u0010\b\u001a\u00020\u0004H\u0002\u001a(\u0010\u0016\u001a\u00020\u00042\u0006\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u00042\u0006\u0010\u0011\u001a\u00020\u00042\u0006\u0010\b\u001a\u00020\u0004H\u0002\u001a9\u0010\u0017\u001a\u00020\u00042\u0006\u0010\u0018\u001a\u00020\u00042\u0012\u0010\u0019\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00040\u001a2\u0012\u0010\u001b\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00040\u001aH\u0082\b\u001a\r\u0010\u001c\u001a\u00020\u001d*\u00020\u0004H\u0082\b\"\u000e\u0010\u0000\u001a\u00020\u0001X\u0082T¢\u0006\u0002\n\u0000¨\u0006\u001e"}, d2 = {"MAX_LONG_MILLIS", "", "estimateAnimationDurationMillis", "stiffness", "", "dampingRatio", "initialVelocity", "initialDisplacement", "delta", "springConstant", "dampingCoefficient", "mass", "", "estimateCriticallyDamped", "firstRoot", "Landroidx/compose/animation/core/ComplexDouble;", "p0", "v0", "estimateDurationInternal", "secondRoot", "initialPosition", "estimateOverDamped", "estimateUnderDamped", "iterateNewtonsMethod", "x", "fn", "Lkotlin/Function1;", "fnPrime", "isNotFinite", "", "animation-core_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class SpringEstimationKt {
    private static final long MAX_LONG_MILLIS = 9223372036854L;

    public static final long estimateAnimationDurationMillis(float f, float f2, float f3, float f4, float f5) {
        return f2 == 0.0f ? MAX_LONG_MILLIS : estimateAnimationDurationMillis(f, f2, f3, f4, f5);
    }

    public static final long estimateAnimationDurationMillis(double d, double d2, double d3, double d4, double d5) {
        double dSqrt = 2.0d * d2 * Math.sqrt(d);
        double d6 = (dSqrt * dSqrt) - (4.0d * d);
        double d7 = -dSqrt;
        ComplexDouble complexDoubleComplexSqrt = ComplexDoubleKt.complexSqrt(d6);
        complexDoubleComplexSqrt._real += d7;
        complexDoubleComplexSqrt._real *= 0.5d;
        complexDoubleComplexSqrt._imaginary *= 0.5d;
        ComplexDouble complexDoubleComplexSqrt2 = ComplexDoubleKt.complexSqrt(d6);
        double d8 = -1;
        complexDoubleComplexSqrt2._real *= d8;
        complexDoubleComplexSqrt2._imaginary *= d8;
        complexDoubleComplexSqrt2._real += d7;
        complexDoubleComplexSqrt2._real *= 0.5d;
        complexDoubleComplexSqrt2._imaginary *= 0.5d;
        return estimateDurationInternal(complexDoubleComplexSqrt, complexDoubleComplexSqrt2, d2, d3, d4, d5);
    }

    public static final long estimateAnimationDurationMillis(double d, double d2, double d3, double d4, double d5, double d6) {
        double dSqrt = d2 / (Math.sqrt(d * d3) * 2.0d);
        double d7 = (d2 * d2) - ((4.0d * d3) * d);
        double d8 = 1.0d / (2.0d * d3);
        double d9 = -d2;
        ComplexDouble complexDoubleComplexSqrt = ComplexDoubleKt.complexSqrt(d7);
        complexDoubleComplexSqrt._real += d9;
        complexDoubleComplexSqrt._real *= d8;
        complexDoubleComplexSqrt._imaginary *= d8;
        ComplexDouble complexDoubleComplexSqrt2 = ComplexDoubleKt.complexSqrt(d7);
        double d10 = -1;
        complexDoubleComplexSqrt2._real *= d10;
        complexDoubleComplexSqrt2._imaginary *= d10;
        complexDoubleComplexSqrt2._real += d9;
        complexDoubleComplexSqrt2._real *= d8;
        complexDoubleComplexSqrt2._imaginary *= d8;
        return estimateDurationInternal(complexDoubleComplexSqrt, complexDoubleComplexSqrt2, dSqrt, d4, d5, d6);
    }

    private static final double estimateUnderDamped(ComplexDouble complexDouble, double d, double d2, double d3) {
        double real = complexDouble.getReal();
        double imaginary = (d2 - (real * d)) / complexDouble.getImaginary();
        return Math.log(d3 / Math.sqrt((d * d) + (imaginary * imaginary))) / real;
    }

    private static final double estimateCriticallyDamped(ComplexDouble complexDouble, double d, double d2, double d3) {
        double d4 = d3;
        double real = complexDouble.getReal();
        double d5 = real * d;
        double d6 = d2 - d5;
        double dLog = Math.log(Math.abs(d4 / d)) / real;
        double dLog2 = Math.log(Math.abs(d4 / d6));
        double dLog3 = dLog2;
        for (int i = 0; i < 6; i++) {
            dLog3 = dLog2 - Math.log(Math.abs(dLog3 / real));
        }
        double d7 = dLog3 / real;
        if (!((Double.isInfinite(dLog) || Double.isNaN(dLog)) ? false : true)) {
            dLog = d7;
        } else if ((Double.isInfinite(d7) || Double.isNaN(d7)) ? false : true) {
            dLog = Math.max(dLog, d7);
        }
        double d8 = (-(d5 + d6)) / (real * d6);
        double d9 = real * d8;
        double dExp = (Math.exp(d9) * d) + (d6 * d8 * Math.exp(d9));
        if (Double.isNaN(d8) || d8 <= 0.0d) {
            d4 = -d4;
        } else if (d8 <= 0.0d || (-dExp) >= d4) {
            dLog = (-(2.0d / real)) - (d / d6);
        } else {
            if (d6 < 0.0d && d > 0.0d) {
                dLog = 0.0d;
            }
            d4 = -d4;
        }
        double dAbs = Double.MAX_VALUE;
        int i2 = 0;
        while (dAbs > 0.001d && i2 < 100) {
            i2++;
            double d10 = real * dLog;
            double d11 = d4;
            double dExp2 = dLog - ((((d + (d6 * dLog)) * Math.exp(d10)) + d4) / ((((((double) 1) + d10) * d6) + d5) * Math.exp(d10)));
            dAbs = Math.abs(dLog - dExp2);
            dLog = dExp2;
            d4 = d11;
        }
        return dLog;
    }

    private static final double estimateOverDamped(ComplexDouble complexDouble, ComplexDouble complexDouble2, double d, double d2, double d3) {
        double dLog;
        double d4;
        double d5;
        double d6;
        int i;
        double d7 = d3;
        double real = complexDouble.getReal();
        double real2 = complexDouble2.getReal();
        double d8 = real - real2;
        double d9 = ((real * d) - d2) / d8;
        double d10 = d - d9;
        double dLog2 = Math.log(Math.abs(d7 / d10)) / real;
        double dLog3 = Math.log(Math.abs(d7 / d9)) / real2;
        if ((Double.isInfinite(dLog2) || Double.isNaN(dLog2)) ? false : true) {
            if ((Double.isInfinite(dLog3) || Double.isNaN(dLog3)) ? false : true) {
                dLog2 = Math.max(dLog2, dLog3);
            }
            dLog = dLog2;
        } else {
            dLog = dLog3;
        }
        double d11 = d10 * real;
        double dLog4 = Math.log(d11 / ((-d9) * real2)) / (real2 - real);
        if (!Double.isNaN(dLog4) && dLog4 > 0.0d) {
            if (dLog4 > 0.0d) {
                d4 = d9;
                if ((-estimateOverDamped$xInflection(d10, real, dLog4, d9, real2)) < d7) {
                    if (d4 > 0.0d && d10 < 0.0d) {
                        dLog = 0.0d;
                    }
                }
                d5 = d4 * real2;
                if (Math.abs((Math.exp(real * dLog) * d11) + (Math.exp(real2 * dLog) * d5)) < 1.0E-4d) {
                    return dLog;
                }
                d6 = Double.MAX_VALUE;
                i = 0;
                while (d6 > 0.001d && i < 100) {
                    i++;
                    double d12 = real * dLog;
                    double d13 = real2 * dLog;
                    double dExp = dLog - ((((Math.exp(d12) * d10) + (Math.exp(d13) * d4)) + d7) / ((Math.exp(d12) * d11) + (Math.exp(d13) * d5)));
                    double dAbs = Math.abs(dLog - dExp);
                    dLog = dExp;
                    d6 = dAbs;
                }
                return dLog;
            }
            d4 = d9;
            dLog = Math.log((-((d4 * real2) * real2)) / (d11 * real)) / d8;
            d5 = d4 * real2;
            if (Math.abs((Math.exp(real * dLog) * d11) + (Math.exp(real2 * dLog) * d5)) < 1.0E-4d) {
                return dLog;
            }
            d6 = Double.MAX_VALUE;
            i = 0;
            while (d6 > 0.001d) {
                i++;
                double d14 = real * dLog;
                double d15 = real2 * dLog;
                double dExp2 = dLog - ((((Math.exp(d14) * d10) + (Math.exp(d15) * d4)) + d7) / ((Math.exp(d14) * d11) + (Math.exp(d15) * d5)));
                double dAbs2 = Math.abs(dLog - dExp2);
                dLog = dExp2;
                d6 = dAbs2;
            }
            return dLog;
        }
        d4 = d9;
        d7 = -d7;
        d5 = d4 * real2;
        if (Math.abs((Math.exp(real * dLog) * d11) + (Math.exp(real2 * dLog) * d5)) < 1.0E-4d) {
            return dLog;
        }
        d6 = Double.MAX_VALUE;
        i = 0;
        while (d6 > 0.001d) {
            i++;
            double d16 = real * dLog;
            double d17 = real2 * dLog;
            double dExp3 = dLog - ((((Math.exp(d16) * d10) + (Math.exp(d17) * d4)) + d7) / ((Math.exp(d16) * d11) + (Math.exp(d17) * d5)));
            double dAbs3 = Math.abs(dLog - dExp3);
            dLog = dExp3;
            d6 = dAbs3;
        }
        return dLog;
    }

    private static final double estimateOverDamped$xInflection(double d, double d2, double d3, double d4, double d5) {
        return (d * Math.exp(d2 * d3)) + (d4 * Math.exp(d5 * d3));
    }

    private static final long estimateDurationInternal(ComplexDouble complexDouble, ComplexDouble complexDouble2, double d, double d2, double d3, double d4) {
        double dEstimateCriticallyDamped;
        double d5 = d2;
        if (d3 == 0.0d && d5 == 0.0d) {
            return 0L;
        }
        if (d3 < 0.0d) {
            d5 = -d5;
        }
        double dAbs = Math.abs(d3);
        if (d > 1.0d) {
            dEstimateCriticallyDamped = estimateOverDamped(complexDouble, complexDouble2, dAbs, d5, d4);
        } else if (d < 1.0d) {
            dEstimateCriticallyDamped = estimateUnderDamped(complexDouble, dAbs, d5, d4);
        } else {
            dEstimateCriticallyDamped = estimateCriticallyDamped(complexDouble, dAbs, d5, d4);
        }
        return (long) (dEstimateCriticallyDamped * 1000.0d);
    }

    private static final double iterateNewtonsMethod(double d, Function1<? super Double, Double> function1, Function1<? super Double, Double> function2) {
        return d - (((Number) function1.invoke(Double.valueOf(d))).doubleValue() / ((Number) function2.invoke(Double.valueOf(d))).doubleValue());
    }

    private static final boolean isNotFinite(double d) {
        return !((Double.isInfinite(d) || Double.isNaN(d)) ? false : true);
    }
}
