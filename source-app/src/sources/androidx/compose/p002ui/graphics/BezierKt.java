package androidx.compose.p002ui.graphics;

import androidx.collection.FloatFloatPair;
import androidx.compose.ui.util.MathHelpersKt;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.collections.ArraysKt;

@Metadata(d1 = {"\u0000>\n\u0000\n\u0002\u0010\u0006\n\u0000\n\u0002\u0010\u0007\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u000b\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u0014\n\u0000\n\u0002\u0010\b\n\u0002\b&\n\u0002\u0010\u000b\n\u0002\b\u0011\n\u0002\u0010\u0002\n\u0002\b\t\u001a\u0011\u0010\u000f\u001a\u00020\u00032\u0006\u0010\u0010\u001a\u00020\u0003H\u0082\b\u001a?\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u00032\u0006\u0010\u0014\u001a\u00020\u00032\u0006\u0010\u0015\u001a\u00020\u00032\u0006\u0010\u0016\u001a\u00020\u00032\u0006\u0010\u0017\u001a\u00020\u00182\b\b\u0002\u0010\u0019\u001a\u00020\u001aH\u0007¢\u0006\u0002\u0010\u001b\u001a'\u0010\u001c\u001a\u00020\u00122\u0006\u0010\u001d\u001a\u00020\u00062\u0006\u0010\u0017\u001a\u00020\u00182\b\b\u0002\u0010\u0019\u001a\u00020\u001aH\u0007¢\u0006\u0002\u0010\u001e\u001a'\u0010\u001f\u001a\u00020\u00122\u0006\u0010\u001d\u001a\u00020\u00062\u0006\u0010\u0017\u001a\u00020\u00182\b\b\u0002\u0010\u0019\u001a\u00020\u001aH\u0000¢\u0006\u0002\u0010\u001e\u001aH\u0010 \u001a\u00020\u00032\u0006\u0010!\u001a\u00020\u00032\u0006\u0010\"\u001a\u00020\u00032\u0006\u0010#\u001a\u00020\u00032\u0006\u0010$\u001a\u00020\u00032\u0006\u0010%\u001a\u00020\u00032\u0006\u0010&\u001a\u00020\u00032\u0006\u0010'\u001a\u00020\u00032\u0006\u0010(\u001a\u00020\u0003H\u0000\u001a \u0010)\u001a\u00020\u001a2\u0006\u0010*\u001a\u00020\u00182\u0006\u0010+\u001a\u00020\u00182\u0006\u0010,\u001a\u00020\u0018H\u0002\u001a0\u0010-\u001a\u00020\u001a2\u0006\u0010.\u001a\u00020\u00182\u0006\u0010/\u001a\u00020\u00032\u0006\u00100\u001a\u00020\u00032\u0006\u00101\u001a\u00020\u00182\u0006\u00102\u001a\u00020\u0018H\u0000\u001a \u00103\u001a\u00020\u00032\u0006\u00104\u001a\u00020\u00032\u0006\u00105\u001a\u00020\u00032\u0006\u00106\u001a\u00020\u0003H\u0007\u001a0\u00103\u001a\u00020\u00032\u0006\u00107\u001a\u00020\u00032\u0006\u00104\u001a\u00020\u00032\u0006\u00105\u001a\u00020\u00032\u0006\u00108\u001a\u00020\u00032\u0006\u00106\u001a\u00020\u0003H\u0002\u001a \u00109\u001a\u00020\u00032\u0006\u0010\u0013\u001a\u00020\u00032\u0006\u0010\u0014\u001a\u00020\u00032\u0006\u00106\u001a\u00020\u0003H\u0002\u001a(\u0010:\u001a\u00020\u00032\u0006\u00107\u001a\u00020\u00032\u0006\u00104\u001a\u00020\u00032\u0006\u00105\u001a\u00020\u00032\u0006\u00106\u001a\u00020\u0003H\u0002\u001a\u0018\u0010;\u001a\u00020\u00032\u0006\u0010\u001d\u001a\u00020\u00062\u0006\u00106\u001a\u00020\u0003H\u0002\u001a\u0018\u0010<\u001a\u00020\u00032\u0006\u0010\u001d\u001a\u00020\u00062\u0006\u00106\u001a\u00020\u0003H\u0007\u001a\u0018\u0010=\u001a\u00020\u001a2\u0006\u0010*\u001a\u00020\u00182\u0006\u0010>\u001a\u00020\u0018H\u0002\u001a(\u0010?\u001a\u00020\u001a2\u0006\u0010\u001d\u001a\u00020\u00062\u0006\u0010@\u001a\u00020A2\u0006\u0010\u0017\u001a\u00020\u00182\u0006\u0010\u0019\u001a\u00020\u001aH\u0002\u001a(\u0010B\u001a\u00020\u00032\u0006\u00107\u001a\u00020\u00032\u0006\u00104\u001a\u00020\u00032\u0006\u00105\u001a\u00020\u00032\u0006\u00108\u001a\u00020\u0003H\u0007\u001a\u0019\u0010C\u001a\u00020\u00032\u0006\u00107\u001a\u00020\u00032\u0006\u00104\u001a\u00020\u0003H\u0082\b\u001a \u0010D\u001a\u00020\u00032\u0006\u00107\u001a\u00020\u00032\u0006\u00104\u001a\u00020\u00032\u0006\u00105\u001a\u00020\u0003H\u0002\u001a\u0018\u0010E\u001a\u00020\u00032\u0006\u0010\u001d\u001a\u00020\u00062\u0006\u0010F\u001a\u00020\u0003H\u0007\u001a+\u0010G\u001a\u00020\u001a2\u0006\u00107\u001a\u00020\u00032\u0006\u00104\u001a\u00020\u00032\u0006\u0010\u0017\u001a\u00020\u00182\b\b\u0002\u0010\u0019\u001a\u00020\u001aH\u0082\b\u001a2\u0010H\u001a\u00020\u001a2\u0006\u00107\u001a\u00020\u00032\u0006\u00104\u001a\u00020\u00032\u0006\u00105\u001a\u00020\u00032\u0006\u0010\u0017\u001a\u00020\u00182\b\b\u0002\u0010\u0019\u001a\u00020\u001aH\u0002\u001a \u0010I\u001a\u00020A2\u0006\u0010\"\u001a\u00020\u00032\u0006\u0010$\u001a\u00020\u00032\u0006\u0010&\u001a\u00020\u0003H\u0002\u001a \u0010J\u001a\u00020\u001a2\u0006\u0010.\u001a\u00020\u00182\u0006\u0010/\u001a\u00020\u00032\u0006\u00100\u001a\u00020\u0003H\u0000\u001a(\u0010K\u001a\u00020\u001a2\u0006\u0010.\u001a\u00020\u00182\u0006\u0010L\u001a\u00020\u001a2\u0006\u0010/\u001a\u00020\u00032\u0006\u00100\u001a\u00020\u0003H\u0002\u001a0\u0010M\u001a\u00020\u001a2\u0006\u0010.\u001a\u00020\u00182\u0006\u0010L\u001a\u00020\u001a2\u0006\u0010/\u001a\u00020\u00032\u0006\u00100\u001a\u00020\u00032\u0006\u00102\u001a\u00020\u0018H\u0002\u001a\u0018\u0010N\u001a\u00020\u001a2\u0006\u0010O\u001a\u00020\u00182\u0006\u0010+\u001a\u00020\u0018H\u0002\u001a0\u0010P\u001a\u00020\u001a2\u0006\u0010.\u001a\u00020\u00182\u0006\u0010/\u001a\u00020\u00032\u0006\u00100\u001a\u00020\u00032\u0006\u0010Q\u001a\u00020\u00182\u0006\u00102\u001a\u00020\u0018H\u0000\u001a0\u0010R\u001a\u00020S2\u0006\u0010T\u001a\u00020\u00182\u0006\u0010U\u001a\u00020\u001a2\u0006\u0010+\u001a\u00020\u00182\u0006\u0010V\u001a\u00020\u001a2\u0006\u00106\u001a\u00020\u0003H\u0002\u001a \u0010W\u001a\u00020S2\u0006\u0010T\u001a\u00020\u00182\u0006\u0010+\u001a\u00020\u00182\u0006\u00106\u001a\u00020\u0003H\u0002\u001a\u0018\u0010X\u001a\u00020\u00032\u0006\u0010/\u001a\u00020\u00032\u0006\u00100\u001a\u00020\u0003H\u0002\u001a \u0010Y\u001a\u00020\u001a2\u0006\u0010\u0010\u001a\u00020\u00032\u0006\u0010\u0017\u001a\u00020\u00182\u0006\u0010\u0019\u001a\u00020\u001aH\u0002\u001a\u0015\u0010Z\u001a\u00020A*\u00020\u00012\u0006\u0010[\u001a\u00020\u0001H\u0080\b\u001a\u0015\u0010Z\u001a\u00020A*\u00020\u00032\u0006\u0010[\u001a\u00020\u0003H\u0080\b\"\u000e\u0010\u0000\u001a\u00020\u0001X\u0082T¢\u0006\u0002\n\u0000\"\u000e\u0010\u0002\u001a\u00020\u0003X\u0082T¢\u0006\u0002\n\u0000\"\u000e\u0010\u0004\u001a\u00020\u0001X\u0082T¢\u0006\u0002\n\u0000\"\u0018\u0010\u0005\u001a\u00020\u0003*\u00020\u00068BX\u0082\u0004¢\u0006\u0006\u001a\u0004\b\u0007\u0010\b\"\u0018\u0010\t\u001a\u00020\u0003*\u00020\u00068BX\u0082\u0004¢\u0006\u0006\u001a\u0004\b\n\u0010\b\"\u0019\u0010\u000b\u001a\u00020\u0003*\u00020\u00068Â\u0002X\u0082\u0004¢\u0006\u0006\u001a\u0004\b\f\u0010\b\"\u0019\u0010\r\u001a\u00020\u0003*\u00020\u00068Â\u0002X\u0082\u0004¢\u0006\u0006\u001a\u0004\b\u000e\u0010\b¨\u0006\\"}, d2 = {"Epsilon", "", "FloatEpsilon", "", "Tau", "endX", "Landroidx/compose/ui/graphics/PathSegment;", "getEndX", "(Landroidx/compose/ui/graphics/PathSegment;)F", "endY", "getEndY", "startX", "getStartX", "startY", "getStartY", "clampValidRootInUnitRange", "r", "computeCubicVerticalBounds", "Landroidx/collection/FloatFloatPair;", "p0y", "p1y", "p2y", "p3y", "roots", "", "index", "", "(FFFF[FI)J", "computeHorizontalBounds", "segment", "(Landroidx/compose/ui/graphics/PathSegment;[FI)J", "computeVerticalBounds", "cubicArea", "x0", "y0", "x1", "y1", "x2", "y2", "x3", "y3", "cubicToMonotonicCubics", "cubic", "dst", "tmpRoot", "cubicWinding", "points", "x", "y", "tmpCubics", "tmpRoots", "evaluateCubic", "p1", "p2", "t", "p0", "p3", "evaluateLine", "evaluateQuadratic", "evaluateX", "evaluateY", "findCubicExtremaY", "dstRoots", "findDerivativeRoots", "horizontal", "", "findFirstCubicRoot", "findFirstLineRoot", "findFirstQuadraticRoot", "findFirstRoot", "fraction", "findLineRoot", "findQuadraticRoots", "isQuadraticMonotonic", "lineWinding", "monotonicCubicWinding", "offset", "monotonicQuadraticWinding", "quadraticToMonotonicQuadratics", "quadratic", "quadraticWinding", "tmpQuadratics", "splitCubicAt", "", "src", "srcOffset", "dstOffset", "splitQuadraticAt", "unitDivide", "writeValidRootInUnitRange", "closeTo", "b", "ui-graphics_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class BezierKt {
    private static final double Epsilon = 1.0E-7d;
    private static final float FloatEpsilon = 8.34465E-7f;
    private static final double Tau = 6.283185307179586d;

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[PathSegment.Type.values().length];
            try {
                iArr[PathSegment.Type.Move.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[PathSegment.Type.Line.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                iArr[PathSegment.Type.Quadratic.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            try {
                iArr[PathSegment.Type.Conic.ordinal()] = 4;
            } catch (NoSuchFieldError unused4) {
            }
            try {
                iArr[PathSegment.Type.Cubic.ordinal()] = 5;
            } catch (NoSuchFieldError unused5) {
            }
            try {
                iArr[PathSegment.Type.Close.ordinal()] = 6;
            } catch (NoSuchFieldError unused6) {
            }
            try {
                iArr[PathSegment.Type.Done.ordinal()] = 7;
            } catch (NoSuchFieldError unused7) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    private static final float clampValidRootInUnitRange(float r3) {
        throw new UnsupportedOperationException("Method not decompiled: androidx.compose.p002ui.graphics.BezierKt.clampValidRootInUnitRange(float):float");
    }

    public static final float cubicArea(float f, float f2, float f3, float f4, float f5, float f6, float f7, float f8) {
        return ((((((((f8 - f2) * (f3 + f5)) - ((f7 - f) * (f4 + f6))) + (f4 * (f - f5))) - (f3 * (f2 - f6))) + (f8 * (f5 + (f / 3.0f)))) - (f7 * (f6 + (f2 / 3.0f)))) * 3.0f) / 20.0f;
    }

    public static final float evaluateCubic(float f, float f2, float f3) {
        return ((((((f - f2) + 0.33333334f) * f3) + (f2 - (2.0f * f))) * f3) + f) * 3.0f * f3;
    }

    private static final float evaluateCubic(float f, float f2, float f3, float f4, float f5) {
        float f6 = (f4 + ((f2 - f3) * 3.0f)) - f;
        return (((((f6 * f5) + (((f3 - (2.0f * f2)) + f) * 3.0f)) * f5) + ((f2 - f) * 3.0f)) * f5) + f;
    }

    private static final float evaluateLine(float f, float f2, float f3) {
        return ((f2 - f) * f3) + f;
    }

    private static final float evaluateQuadratic(float f, float f2, float f3, float f4) {
        return (((((f3 - (f2 * 2.0f)) + f) * f4) + ((f2 - f) * 2.0f)) * f4) + f;
    }

    private static final float findFirstLineRoot(float r2, float r3) {
        throw new UnsupportedOperationException("Method not decompiled: androidx.compose.p002ui.graphics.BezierKt.findFirstLineRoot(float, float):float");
    }

    private static final float unitDivide(float f, float f2) {
        if (f < 0.0f) {
            f = -f;
            f2 = -f2;
        }
        if (f2 == 0.0f || f == 0.0f || f >= f2) {
            return Float.NaN;
        }
        float f3 = f / f2;
        if (f3 == 0.0f) {
            return Float.NaN;
        }
        return f3;
    }

    private static final float evaluateX(PathSegment pathSegment, float f) throws NoWhenBranchMatchedException {
        float[] points = pathSegment.getPoints();
        switch (WhenMappings.$EnumSwitchMapping$0[pathSegment.getType().ordinal()]) {
            case 1:
                return points[0];
            case 2:
                return evaluateLine(points[0], points[2], f);
            case 3:
                return evaluateQuadratic(points[0], points[2], points[4], f);
            case 4:
            case 6:
            case 7:
                return Float.NaN;
            case 5:
                return evaluateCubic(points[0], points[2], points[4], points[6], f);
            default:
                throw new NoWhenBranchMatchedException();
        }
    }

    public static final float evaluateY(PathSegment pathSegment, float f) throws NoWhenBranchMatchedException {
        float[] points = pathSegment.getPoints();
        switch (WhenMappings.$EnumSwitchMapping$0[pathSegment.getType().ordinal()]) {
            case 1:
                return points[1];
            case 2:
                return evaluateLine(points[1], points[3], f);
            case 3:
                return evaluateQuadratic(points[1], points[3], points[5], f);
            case 4:
            case 6:
            case 7:
                return Float.NaN;
            case 5:
                return evaluateCubic(points[1], points[3], points[5], points[7], f);
            default:
                throw new NoWhenBranchMatchedException();
        }
    }

    public static final float findFirstRoot(PathSegment pathSegment, float f) throws NoWhenBranchMatchedException {
        float[] points = pathSegment.getPoints();
        switch (WhenMappings.$EnumSwitchMapping$0[pathSegment.getType().ordinal()]) {
            case 1:
            case 4:
            case 6:
            case 7:
                return Float.NaN;
            case 2:
                float f2 = points[0] - f;
                float f3 = (-f2) / ((points[2] - f) - f2);
                float f4 = 0.0f;
                if (f3 >= 0.0f) {
                    f4 = 1.0f;
                    if (f3 <= 1.0f) {
                        return f3;
                    }
                    if (f3 > 1.0000008f) {
                        return Float.NaN;
                    }
                } else if (f3 < -8.34465E-7f) {
                    return Float.NaN;
                }
                return f4;
            case 3:
                return findFirstQuadraticRoot(points[0] - f, points[2] - f, points[4] - f);
            case 5:
                return findFirstCubicRoot(points[0] - f, points[2] - f, points[4] - f, points[6] - f);
            default:
                throw new NoWhenBranchMatchedException();
        }
    }

    private static final float findFirstQuadraticRoot(float f, float f2, float f3) {
        double d = f;
        double d2 = f2;
        double d3 = f3;
        double d4 = d2 * 2.0d;
        double d5 = (d - d4) + d3;
        if (d5 == 0.0d) {
            if (d2 == d3) {
                return Float.NaN;
            }
            float f4 = (float) ((d4 - d3) / (d4 - (d3 * 2.0d)));
            if (f4 < 0.0f) {
                if (f4 >= -8.34465E-7f) {
                    return 0.0f;
                }
            } else {
                if (f4 <= 1.0f) {
                    return f4;
                }
                if (f4 <= 1.0000008f) {
                    return 1.0f;
                }
            }
            return Float.NaN;
        }
        double d6 = -Math.sqrt((d2 * d2) - (d3 * d));
        double d7 = (-d) + d2;
        float f5 = (float) ((-(d6 + d7)) / d5);
        if (f5 < 0.0f) {
            if (f5 >= -8.34465E-7f) {
                f5 = 0.0f;
            } else {
                f5 = Float.NaN;
            }
        } else if (f5 > 1.0f) {
            if (f5 <= 1.0000008f) {
                f5 = 1.0f;
            } else {
                f5 = Float.NaN;
            }
        }
        if (!Float.isNaN(f5)) {
            return f5;
        }
        float f6 = (float) ((d6 - d7) / d5);
        if (f6 < 0.0f) {
            if (f6 >= -8.34465E-7f) {
                return 0.0f;
            }
        } else {
            if (f6 <= 1.0f) {
                return f6;
            }
            if (f6 <= 1.0000008f) {
                return 1.0f;
            }
        }
        return Float.NaN;
    }

    private static final int findLineRoot(float f, float f2, float[] fArr, int i) {
        return writeValidRootInUnitRange((-f) / (f2 - f), fArr, i);
    }

    static int findLineRoot$default(float f, float f2, float[] fArr, int i, int i2, Object obj) {
        if ((i2 & 8) != 0) {
            i = 0;
        }
        return writeValidRootInUnitRange((-f) / (f2 - f), fArr, i);
    }

    static int findQuadraticRoots$default(float f, float f2, float f3, float[] fArr, int i, int i2, Object obj) {
        if ((i2 & 16) != 0) {
            i = 0;
        }
        return findQuadraticRoots(f, f2, f3, fArr, i);
    }

    private static final int findQuadraticRoots(float f, float f2, float f3, float[] fArr, int i) {
        double d = f;
        double d2 = f2;
        double d3 = f3;
        double d4 = d2 * 2.0d;
        double d5 = (d - d4) + d3;
        if (d5 == 0.0d) {
            if (d2 == d3) {
                return 0;
            }
            return writeValidRootInUnitRange((float) ((d4 - d3) / (d4 - (d3 * 2.0d))), fArr, i);
        }
        double d6 = -Math.sqrt((d2 * d2) - (d3 * d));
        double d7 = (-d) + d2;
        int iWriteValidRootInUnitRange = writeValidRootInUnitRange((float) ((-(d6 + d7)) / d5), fArr, i);
        int iWriteValidRootInUnitRange2 = iWriteValidRootInUnitRange + writeValidRootInUnitRange((float) ((d6 - d7) / d5), fArr, i + iWriteValidRootInUnitRange);
        if (iWriteValidRootInUnitRange2 > 1) {
            float f4 = fArr[i];
            int i2 = i + 1;
            float f5 = fArr[i2];
            if (f4 > f5) {
                fArr[i] = f5;
                fArr[i2] = f4;
            } else if (f4 == f5) {
                return iWriteValidRootInUnitRange2 - 1;
            }
        }
        return iWriteValidRootInUnitRange2;
    }

    private static final int findDerivativeRoots(PathSegment pathSegment, boolean z, float[] fArr, int i) throws NoWhenBranchMatchedException {
        int i2 = !z ? 1 : 0;
        float[] points = pathSegment.getPoints();
        switch (WhenMappings.$EnumSwitchMapping$0[pathSegment.getType().ordinal()]) {
            case 1:
            case 2:
            case 4:
            case 6:
            case 7:
                return 0;
            case 3:
                float f = 2;
                float f2 = points[i2 + 2];
                float f3 = (f2 - points[i2]) * f;
                return writeValidRootInUnitRange((-f3) / ((f * (points[i2 + 4] - f2)) - f3), fArr, i);
            case 5:
                float f4 = points[i2 + 2];
                float f5 = (f4 - points[i2]) * 3.0f;
                float f6 = points[i2 + 4];
                float f7 = (f6 - f4) * 3.0f;
                float f8 = (points[i2 + 6] - f6) * 3.0f;
                int iFindQuadraticRoots = findQuadraticRoots(f5, f7, f8, fArr, i);
                float f9 = (f7 - f5) * 2.0f;
                return iFindQuadraticRoots + writeValidRootInUnitRange((-f9) / (((f8 - f7) * 2.0f) - f9), fArr, i + iFindQuadraticRoots);
            default:
                throw new NoWhenBranchMatchedException();
        }
    }

    public static long computeHorizontalBounds$default(PathSegment pathSegment, float[] fArr, int i, int i2, Object obj) {
        if ((i2 & 4) != 0) {
            i = 0;
        }
        return computeHorizontalBounds(pathSegment, fArr, i);
    }

    public static final long computeHorizontalBounds(PathSegment pathSegment, float[] fArr, int i) throws NoWhenBranchMatchedException {
        int iFindDerivativeRoots = findDerivativeRoots(pathSegment, true, fArr, i);
        float fMin = Math.min(pathSegment.getPoints()[0], getEndX(pathSegment));
        float fMax = Math.max(pathSegment.getPoints()[0], getEndX(pathSegment));
        for (int i2 = 0; i2 < iFindDerivativeRoots; i2++) {
            float fEvaluateX = evaluateX(pathSegment, fArr[i2]);
            fMin = Math.min(fMin, fEvaluateX);
            fMax = Math.max(fMax, fEvaluateX);
        }
        return FloatFloatPair.m266constructorimpl(fMin, fMax);
    }

    public static long computeVerticalBounds$default(PathSegment pathSegment, float[] fArr, int i, int i2, Object obj) {
        if ((i2 & 4) != 0) {
            i = 0;
        }
        return computeVerticalBounds(pathSegment, fArr, i);
    }

    public static final long computeVerticalBounds(PathSegment pathSegment, float[] fArr, int i) throws NoWhenBranchMatchedException {
        int iFindDerivativeRoots = findDerivativeRoots(pathSegment, false, fArr, i);
        float fMin = Math.min(pathSegment.getPoints()[1], getEndY(pathSegment));
        float fMax = Math.max(pathSegment.getPoints()[1], getEndY(pathSegment));
        for (int i2 = 0; i2 < iFindDerivativeRoots; i2++) {
            float fEvaluateY = evaluateY(pathSegment, fArr[i2]);
            fMin = Math.min(fMin, fEvaluateY);
            fMax = Math.max(fMax, fEvaluateY);
        }
        return FloatFloatPair.m266constructorimpl(fMin, fMax);
    }

    public static long computeCubicVerticalBounds$default(float f, float f2, float f3, float f4, float[] fArr, int i, int i2, Object obj) {
        if ((i2 & 32) != 0) {
            i = 0;
        }
        return computeCubicVerticalBounds(f, f2, f3, f4, fArr, i);
    }

    public static final long computeCubicVerticalBounds(float f, float f2, float f3, float f4, float[] fArr, int i) {
        float f5 = (f2 - f) * 3.0f;
        float f6 = (f3 - f2) * 3.0f;
        float f7 = (f4 - f3) * 3.0f;
        int iFindQuadraticRoots = findQuadraticRoots(f5, f6, f7, fArr, i);
        float f8 = (f6 - f5) * 2.0f;
        int iWriteValidRootInUnitRange = iFindQuadraticRoots + writeValidRootInUnitRange((-f8) / (((f7 - f6) * 2.0f) - f8), fArr, i + iFindQuadraticRoots);
        float fMin = Math.min(f, f4);
        float fMax = Math.max(f, f4);
        for (int i2 = 0; i2 < iWriteValidRootInUnitRange; i2++) {
            float fEvaluateCubic = evaluateCubic(f, f2, f3, f4, fArr[i2]);
            fMin = Math.min(fMin, fEvaluateCubic);
            fMax = Math.max(fMax, fEvaluateCubic);
        }
        return FloatFloatPair.m266constructorimpl(fMin, fMax);
    }

    public static final boolean closeTo(double d, double d2) {
        return Math.abs(d - d2) < Epsilon;
    }

    public static final boolean closeTo(float f, float f2) {
        return Math.abs(f - f2) < FloatEpsilon;
    }

    public static final int writeValidRootInUnitRange(float f, float[] fArr, int i) {
        float f2 = 0.0f;
        if (f >= 0.0f) {
            f2 = 1.0f;
            if (f > 1.0f) {
                if (f <= 1.0000008f) {
                    f = f2;
                } else {
                    f = Float.NaN;
                }
            }
        } else if (f >= -8.34465E-7f) {
            f = f2;
        } else {
            f = Float.NaN;
        }
        fArr[i] = f;
        return !Float.isNaN(f) ? 1 : 0;
    }

    public static final int lineWinding(float[] fArr, float f, float f2) {
        int i;
        float f3;
        float f4 = fArr[0];
        float f5 = fArr[1];
        float f6 = fArr[2];
        float f7 = fArr[3];
        float f8 = f7 - f5;
        if (f5 > f7) {
            i = -1;
            f3 = f5;
        } else {
            i = 1;
            f3 = f7;
            f7 = f5;
        }
        if (f2 < f7 || f2 >= f3) {
            return 0;
        }
        float f9 = ((f6 - f4) * (f2 - f5)) - (f8 * (f - f4));
        if (f9 == 0.0f || ((int) Math.signum(f9)) == i) {
            return 0;
        }
        return i;
    }

    private static final boolean isQuadraticMonotonic(float f, float f2, float f3) {
        return !(Math.signum(f - f2) + Math.signum(f2 - f3) == 0.0f);
    }

    public static final int quadraticWinding(float[] fArr, float f, float f2, float[] fArr2, float[] fArr3) {
        if (isQuadraticMonotonic(fArr[1], fArr[3], fArr[5])) {
            return monotonicQuadraticWinding(fArr, 0, f, f2, fArr3);
        }
        int iQuadraticToMonotonicQuadratics = quadraticToMonotonicQuadratics(fArr, fArr2);
        int iMonotonicQuadraticWinding = monotonicQuadraticWinding(fArr2, 0, f, f2, fArr3);
        return iQuadraticToMonotonicQuadratics > 0 ? iMonotonicQuadraticWinding + monotonicQuadraticWinding(fArr2, 4, f, f2, fArr3) : iMonotonicQuadraticWinding;
    }

    private static final int monotonicQuadraticWinding(float[] fArr, int i, float f, float f2, float[] fArr2) {
        int i2;
        float f3;
        float f4;
        float fEvaluateQuadratic;
        float f5 = fArr[i + 1];
        float f6 = fArr[i + 5];
        if (f5 > f6) {
            i2 = -1;
            f4 = f5;
            f3 = f6;
        } else {
            i2 = 1;
            f3 = f5;
            f4 = f6;
        }
        if (f2 < f3 || f2 >= f4) {
            return 0;
        }
        float f7 = fArr[i + 3];
        if (findQuadraticRoots$default((f5 - (f7 * 2.0f)) + f6, (f7 - f5) * 2.0f, f5 - f2, fArr2, 0, 16, null) == 0) {
            fEvaluateQuadratic = fArr[(1 - i2) * 2];
        } else {
            fEvaluateQuadratic = evaluateQuadratic(fArr[0], fArr[2], fArr[4], fArr2[0]);
        }
        if ((Math.abs(fEvaluateQuadratic - f) >= FloatEpsilon || (f == fArr[4] && f2 == f6)) && fEvaluateQuadratic < f) {
            return i2;
        }
        return 0;
    }

    private static final int quadraticToMonotonicQuadratics(float[] fArr, float[] fArr2) {
        float f = fArr[1];
        float f2 = fArr[3];
        float f3 = fArr[5];
        if (!isQuadraticMonotonic(f, f2, f3)) {
            float f4 = f - f2;
            float fUnitDivide = unitDivide(f4, (f4 - f2) + f3);
            if (!Float.isNaN(fUnitDivide)) {
                splitQuadraticAt(fArr, fArr2, fUnitDivide);
                return 1;
            }
            if (Math.abs(f4) >= Math.abs(f2 - f3)) {
                f = f3;
            }
            f2 = f;
        }
        ArraysKt.copyInto(fArr, fArr2, 0, 0, 6);
        fArr2[3] = f2;
        return 0;
    }

    private static final void splitQuadraticAt(float[] fArr, float[] fArr2, float f) {
        float f2 = fArr[0];
        float f3 = fArr[1];
        float f4 = fArr[2];
        float f5 = fArr[3];
        float f6 = fArr[4];
        float f7 = fArr[5];
        float fLerp = MathHelpersKt.lerp(f2, f4, f);
        float fLerp2 = MathHelpersKt.lerp(f3, f5, f);
        fArr2[0] = f2;
        fArr2[1] = f3;
        fArr2[2] = fLerp;
        fArr2[3] = fLerp2;
        float fLerp3 = MathHelpersKt.lerp(f4, f6, f);
        float fLerp4 = MathHelpersKt.lerp(f5, f7, f);
        float fLerp5 = MathHelpersKt.lerp(fLerp, fLerp3, f);
        float fLerp6 = MathHelpersKt.lerp(fLerp2, fLerp4, f);
        fArr2[4] = fLerp5;
        fArr2[5] = fLerp6;
        fArr2[6] = fLerp3;
        fArr2[7] = fLerp4;
        fArr2[8] = f6;
        fArr2[9] = f7;
    }

    public static final int cubicWinding(float[] fArr, float f, float f2, float[] fArr2, float[] fArr3) {
        int iCubicToMonotonicCubics = cubicToMonotonicCubics(fArr, fArr2, fArr3);
        int iMonotonicCubicWinding = 0;
        if (iCubicToMonotonicCubics >= 0) {
            int i = 0;
            while (true) {
                iMonotonicCubicWinding += monotonicCubicWinding(fArr2, i * 6, f, f2);
                if (i == iCubicToMonotonicCubics) {
                    break;
                }
                i++;
            }
        }
        return iMonotonicCubicWinding;
    }

    private static final int monotonicCubicWinding(float[] fArr, int i, float f, float f2) {
        int i2;
        int i3 = i + 1;
        float f3 = fArr[i3];
        int i4 = i + 7;
        float f4 = fArr[i4];
        if (f3 > f4) {
            i2 = -1;
            f4 = f3;
            f3 = f4;
        } else {
            i2 = 1;
        }
        if (f2 < f3 || f2 >= f4) {
            return 0;
        }
        float f5 = fArr[i];
        float f6 = fArr[i + 2];
        float f7 = fArr[i + 4];
        float f8 = fArr[i + 6];
        if (f < Math.min(f5, Math.min(f6, Math.min(f7, f8)))) {
            return 0;
        }
        if (f > Math.max(f5, Math.max(f6, Math.max(f7, f8)))) {
            return i2;
        }
        float f9 = fArr[i3];
        float f10 = fArr[i + 3];
        float f11 = fArr[i + 5];
        float f12 = fArr[i4];
        float fFindFirstCubicRoot = findFirstCubicRoot(f9 - f2, f10 - f2, f11 - f2, f12 - f2);
        if (Float.isNaN(fFindFirstCubicRoot)) {
            return 0;
        }
        float fEvaluateCubic = evaluateCubic(f5, f6, f7, f8, fFindFirstCubicRoot);
        if ((Math.abs(fEvaluateCubic - f) >= FloatEpsilon || (f == f8 && f2 == f12)) && fEvaluateCubic < f) {
            return i2;
        }
        return 0;
    }

    private static final int cubicToMonotonicCubics(float[] fArr, float[] fArr2, float[] fArr3) {
        int iFindCubicExtremaY = findCubicExtremaY(fArr, fArr3);
        int i = 0;
        if (iFindCubicExtremaY == 0) {
            ArraysKt.copyInto(fArr, fArr2, 0, 0, 8);
        } else {
            int i2 = 0;
            float f = 0.0f;
            while (i < iFindCubicExtremaY) {
                float f2 = (fArr3[i] - f) / (1.0f - f);
                if (f2 < 0.0f) {
                    f2 = 0.0f;
                }
                f = f2 > 1.0f ? 1.0f : f2;
                splitCubicAt(fArr, i2, fArr2, i2, f);
                i2 += 6;
                i++;
                fArr = fArr2;
            }
        }
        return iFindCubicExtremaY;
    }

    private static final int findCubicExtremaY(float[] fArr, float[] fArr2) {
        float f = fArr[1];
        float f2 = fArr[3];
        float f3 = fArr[5];
        return findQuadraticRoots((fArr[7] - f) + ((f2 - f3) * 3.0f), (((f - f2) - f2) - f3) * 2.0f, f2 - f, fArr2, 0);
    }

    private static final void splitCubicAt(float[] fArr, int i, float[] fArr2, int i2, float f) {
        if (f >= 1.0f) {
            ArraysKt.copyInto(fArr, fArr2, i2, i, 8);
            float f2 = fArr[i + 6];
            float f3 = fArr[i + 7];
            fArr2[i2 + 8] = f2;
            fArr2[i2 + 9] = f3;
            fArr2[i2 + 10] = f2;
            fArr2[i2 + 11] = f3;
            fArr2[i2 + 12] = f2;
            fArr2[i2 + 13] = f3;
            return;
        }
        float f4 = fArr[i];
        float f5 = fArr[i + 1];
        fArr2[i2] = f4;
        fArr2[i2 + 1] = f5;
        float f6 = fArr[i + 2];
        float f7 = fArr[i + 3];
        float fLerp = MathHelpersKt.lerp(f4, f6, f);
        float fLerp2 = MathHelpersKt.lerp(f5, f7, f);
        fArr2[i2 + 2] = fLerp;
        fArr2[i2 + 3] = fLerp2;
        float f8 = fArr[i + 4];
        float f9 = fArr[i + 5];
        float fLerp3 = MathHelpersKt.lerp(f6, f8, f);
        float fLerp4 = MathHelpersKt.lerp(f7, f9, f);
        float fLerp5 = MathHelpersKt.lerp(fLerp, fLerp3, f);
        float fLerp6 = MathHelpersKt.lerp(fLerp2, fLerp4, f);
        fArr2[i2 + 4] = fLerp5;
        fArr2[i2 + 5] = fLerp6;
        float f10 = fArr[i + 6];
        float f11 = fArr[i + 7];
        float fLerp7 = MathHelpersKt.lerp(f8, f10, f);
        float fLerp8 = MathHelpersKt.lerp(f9, f11, f);
        float fLerp9 = MathHelpersKt.lerp(fLerp3, fLerp7, f);
        float fLerp10 = MathHelpersKt.lerp(fLerp4, fLerp8, f);
        float fLerp11 = MathHelpersKt.lerp(fLerp5, fLerp9, f);
        float fLerp12 = MathHelpersKt.lerp(fLerp6, fLerp10, f);
        fArr2[i2 + 6] = fLerp11;
        fArr2[i2 + 7] = fLerp12;
        fArr2[i2 + 8] = fLerp9;
        fArr2[i2 + 9] = fLerp10;
        fArr2[i2 + 10] = fLerp7;
        fArr2[i2 + 11] = fLerp8;
        fArr2[i2 + 12] = f10;
        fArr2[i2 + 13] = f11;
    }

    private static final float getStartX(PathSegment pathSegment) {
        return pathSegment.getPoints()[0];
    }

    private static final float getEndX(PathSegment pathSegment) throws NoWhenBranchMatchedException {
        float[] points = pathSegment.getPoints();
        char c = 4;
        switch (WhenMappings.$EnumSwitchMapping$0[pathSegment.getType().ordinal()]) {
            case 1:
            case 6:
            case 7:
                c = 0;
                break;
            case 2:
                c = 2;
                break;
            case 3:
            case 4:
                break;
            case 5:
                c = 6;
                break;
            default:
                throw new NoWhenBranchMatchedException();
        }
        return points[c];
    }

    private static final float getStartY(PathSegment pathSegment) {
        return pathSegment.getPoints()[1];
    }

    private static final float getEndY(PathSegment pathSegment) throws NoWhenBranchMatchedException {
        float[] points = pathSegment.getPoints();
        char c = 5;
        switch (WhenMappings.$EnumSwitchMapping$0[pathSegment.getType().ordinal()]) {
            case 1:
            case 6:
            case 7:
                c = 0;
                break;
            case 2:
                c = 3;
                break;
            case 3:
            case 4:
                break;
            case 5:
                c = 7;
                break;
            default:
                throw new NoWhenBranchMatchedException();
        }
        return points[c];
    }

    public static final float findFirstCubicRoot(float f, float f2, float f3, float f4) {
        double d = f;
        double d2 = ((d - (((double) f2) * 2.0d)) + ((double) f3)) * 3.0d;
        double d3 = ((double) (f2 - f)) * 3.0d;
        double d4 = ((double) (-f)) + (((double) (f2 - f3)) * 3.0d) + ((double) f4);
        if (Math.abs(d4 - 0.0d) < Epsilon) {
            if (Math.abs(d2 - 0.0d) < Epsilon) {
                if (Math.abs(d3 - 0.0d) < Epsilon) {
                    return Float.NaN;
                }
                float f5 = (float) ((-d) / d3);
                if (f5 < 0.0f) {
                    if (f5 >= -8.34465E-7f) {
                        return 0.0f;
                    }
                } else {
                    if (f5 <= 1.0f) {
                        return f5;
                    }
                    if (f5 <= 1.0000008f) {
                        return 1.0f;
                    }
                }
                return Float.NaN;
            }
            double dSqrt = Math.sqrt((d3 * d3) - ((4.0d * d2) * d));
            double d5 = d2 * 2.0d;
            float f6 = (float) ((dSqrt - d3) / d5);
            if (f6 < 0.0f) {
                if (f6 >= -8.34465E-7f) {
                    f6 = 0.0f;
                } else {
                    f6 = Float.NaN;
                }
            } else if (f6 > 1.0f) {
                if (f6 <= 1.0000008f) {
                    f6 = 1.0f;
                } else {
                    f6 = Float.NaN;
                }
            }
            if (!Float.isNaN(f6)) {
                return f6;
            }
            float f7 = (float) (((-d3) - dSqrt) / d5);
            if (f7 < 0.0f) {
                if (f7 >= -8.34465E-7f) {
                    return 0.0f;
                }
            } else {
                if (f7 <= 1.0f) {
                    return f7;
                }
                if (f7 <= 1.0000008f) {
                    return 1.0f;
                }
            }
            return Float.NaN;
        }
        double d6 = d2 / d4;
        double d7 = d3 / d4;
        double d8 = d / d4;
        double d9 = ((d7 * 3.0d) - (d6 * d6)) / 9.0d;
        double d10 = (((((2.0d * d6) * d6) * d6) - ((9.0d * d6) * d7)) + (d8 * 27.0d)) / 54.0d;
        double d11 = d9 * d9 * d9;
        double d12 = (d10 * d10) + d11;
        double d13 = d6 / 3.0d;
        if (d12 >= 0.0d) {
            if (d12 == 0.0d) {
                float f8 = -MathHelpersKt.fastCbrt((float) d10);
                float f9 = (float) d13;
                float f10 = (2.0f * f8) - f9;
                if (f10 < 0.0f) {
                    if (f10 >= -8.34465E-7f) {
                        f10 = 0.0f;
                    } else {
                        f10 = Float.NaN;
                    }
                } else if (f10 > 1.0f) {
                    if (f10 <= 1.0000008f) {
                        f10 = 1.0f;
                    } else {
                        f10 = Float.NaN;
                    }
                }
                if (!Float.isNaN(f10)) {
                    return f10;
                }
                float f11 = (-f8) - f9;
                if (f11 < 0.0f) {
                    if (f11 >= -8.34465E-7f) {
                        return 0.0f;
                    }
                } else {
                    if (f11 <= 1.0f) {
                        return f11;
                    }
                    if (f11 <= 1.0000008f) {
                        return 1.0f;
                    }
                }
                return Float.NaN;
            }
            double dSqrt2 = Math.sqrt(d12);
            float fFastCbrt = (float) (((double) (MathHelpersKt.fastCbrt((float) ((-d10) + dSqrt2)) - MathHelpersKt.fastCbrt((float) (d10 + dSqrt2)))) - d13);
            if (fFastCbrt < 0.0f) {
                if (fFastCbrt >= -8.34465E-7f) {
                    return 0.0f;
                }
            } else {
                if (fFastCbrt <= 1.0f) {
                    return fFastCbrt;
                }
                if (fFastCbrt <= 1.0000008f) {
                    return 1.0f;
                }
            }
            return Float.NaN;
        }
        double dSqrt3 = Math.sqrt(-d11);
        double d14 = (-d10) / dSqrt3;
        if (d14 < -1.0d) {
            d14 = -1.0d;
        }
        if (d14 > 1.0d) {
            d14 = 1.0d;
        }
        double dAcos = Math.acos(d14);
        double dFastCbrt = MathHelpersKt.fastCbrt((float) dSqrt3) * 2.0f;
        float fCos = (float) ((Math.cos(dAcos / 3.0d) * dFastCbrt) - d13);
        if (fCos < 0.0f) {
            if (fCos >= -8.34465E-7f) {
                fCos = 0.0f;
            } else {
                fCos = Float.NaN;
            }
        } else if (fCos > 1.0f) {
            if (fCos <= 1.0000008f) {
                fCos = 1.0f;
            } else {
                fCos = Float.NaN;
            }
        }
        if (!Float.isNaN(fCos)) {
            return fCos;
        }
        float fCos2 = (float) ((Math.cos((Tau + dAcos) / 3.0d) * dFastCbrt) - d13);
        if (fCos2 < 0.0f) {
            if (fCos2 >= -8.34465E-7f) {
                fCos2 = 0.0f;
            } else {
                fCos2 = Float.NaN;
            }
        } else if (fCos2 > 1.0f) {
            if (fCos2 <= 1.0000008f) {
                fCos2 = 1.0f;
            } else {
                fCos2 = Float.NaN;
            }
        }
        if (!Float.isNaN(fCos2)) {
            return fCos2;
        }
        float fCos3 = (float) ((dFastCbrt * Math.cos((dAcos + 12.566370614359172d) / 3.0d)) - d13);
        if (fCos3 < 0.0f) {
            if (fCos3 >= -8.34465E-7f) {
                return 0.0f;
            }
        } else {
            if (fCos3 <= 1.0f) {
                return fCos3;
            }
            if (fCos3 <= 1.0000008f) {
                return 1.0f;
            }
        }
        return Float.NaN;
    }
}
