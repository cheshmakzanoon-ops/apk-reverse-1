package androidx.compose.animation.core;

import kotlin.Metadata;

@Metadata(d1 = {"\u0000:\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u0014\n\u0000\n\u0002\u0010\u0011\n\u0000\n\u0002\u0010\u0007\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\r\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\t\b\u0001\u0018\u00002\u00020\u0001B#\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\f\u0010\u0004\u001a\b\u0012\u0004\u0012\u00020\u00030\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\bJ8\u0010\u0010\u001a\u00020\u00072\u0006\u0010\u0011\u001a\u00020\u00072\u0006\u0010\u0012\u001a\u00020\u00072\u0006\u0010\u0013\u001a\u00020\u00072\u0006\u0010\u0014\u001a\u00020\u00072\u0006\u0010\u0015\u001a\u00020\u00072\u0006\u0010\u0016\u001a\u00020\u0007H\u0002J \u0010\u0017\u001a\u00020\u00182\u0006\u0010\u0002\u001a\u00020\u00072\u0006\u0010\u0019\u001a\u00020\u001a2\b\b\u0002\u0010\u001b\u001a\u00020\u001cJ\u0016\u0010\u0017\u001a\u00020\u00072\u0006\u0010\u001d\u001a\u00020\u00072\u0006\u0010\u001e\u001a\u00020\u001cJ \u0010\u001f\u001a\u00020\u00182\u0006\u0010\u0002\u001a\u00020\u00072\u0006\u0010\u0019\u001a\u00020\u001a2\b\b\u0002\u0010\u001b\u001a\u00020\u001cJ\u0016\u0010\u001f\u001a\u00020\u00182\u0006\u0010\u0002\u001a\u00020\u00072\u0006\u0010\u0019\u001a\u00020\u0003J\u0018\u0010\u001f\u001a\u00020\u00072\u0006\u0010\u0002\u001a\u00020\u00072\u0006\u0010\u001e\u001a\u00020\u001cH\u0002J8\u0010 \u001a\u00020\u00072\u0006\u0010\u0011\u001a\u00020\u00072\u0006\u0010\u0012\u001a\u00020\u00072\u0006\u0010\u0013\u001a\u00020\u00072\u0006\u0010\u0014\u001a\u00020\u00072\u0006\u0010\u0015\u001a\u00020\u00072\u0006\u0010\u0016\u001a\u00020\u0007H\u0002J#\u0010!\u001a\b\u0012\u0004\u0012\u00020\u00030\u00052\u0006\u0010\"\u001a\u00020\u001c2\u0006\u0010#\u001a\u00020\u001cH\u0002¢\u0006\u0002\u0010$R\u000e\u0010\t\u001a\u00020\nX\u0082D¢\u0006\u0002\n\u0000R\u000e\u0010\u000b\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u0016\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u00030\u0005X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\rR\u000e\u0010\u000e\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u0016\u0010\u000f\u001a\b\u0012\u0004\u0012\u00020\u00030\u0005X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\r¨\u0006%"}, d2 = {"Landroidx/compose/animation/core/MonoSpline;", "", "time", "", "y", "", "periodicBias", "", "([F[[FF)V", "isExtrapolate", "", "slopeTemp", "tangents", "[[F", "timePoints", "values", "diff", "h", "x", "y1", "y2", "t1", "t2", "getPos", "", "v", "Landroidx/compose/animation/core/AnimationVector;", "index", "", "t", "j", "getSlope", "interpolate", "makeFloatArray", "a", "b", "(II)[[F", "animation-core_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class MonoSpline {
    public static final int $stable = 8;
    private final boolean isExtrapolate = true;
    private final float[] slopeTemp;
    private final float[][] tangents;
    private final float[] timePoints;
    private final float[][] values;

    private final float diff(float h, float x, float y1, float y2, float t1, float t2) {
        float f = x * x;
        float f2 = 6;
        float f3 = f2 * x;
        float f4 = (((((-6) * f) * y2) + (y2 * f3)) + ((f2 * f) * y1)) - (f3 * y1);
        float f5 = 3 * h;
        return ((((f4 + ((f5 * t2) * f)) + ((f5 * t1) * f)) - (((2 * h) * t2) * x)) - (((4 * h) * t1) * x)) + (h * t1);
    }

    private final float interpolate(float h, float x, float y1, float y2, float t1, float t2) {
        float f = x * x;
        float f2 = f * x;
        float f3 = 3 * f;
        float f4 = ((-2) * f2 * y2) + (y2 * f3);
        float f5 = 2;
        float f6 = t2 * h;
        float f7 = ((f4 + ((f5 * f2) * y1)) - (f3 * y1)) + y1 + (f6 * f2);
        float f8 = h * t1;
        return (((f7 + (f2 * f8)) - (f6 * f)) - (((f5 * h) * t1) * f)) + (f8 * x);
    }

    public MonoSpline(float[] fArr, float[][] fArr2, float f) {
        int i;
        int length = fArr.length;
        int i2 = 0;
        int length2 = fArr2[0].length;
        this.slopeTemp = new float[length2];
        int i3 = length - 1;
        float[][] fArrMakeFloatArray = makeFloatArray(i3, length2);
        float[][] fArrMakeFloatArray2 = makeFloatArray(length, length2);
        for (int i4 = 0; i4 < length2; i4++) {
            int i5 = 0;
            while (i5 < i3) {
                int i6 = i5 + 1;
                float f2 = fArr[i6] - fArr[i5];
                float[] fArr3 = fArrMakeFloatArray[i5];
                float f3 = (fArr2[i6][i4] - fArr2[i5][i4]) / f2;
                fArr3[i4] = f3;
                if (i5 == 0) {
                    fArrMakeFloatArray2[i5][i4] = f3;
                } else {
                    fArrMakeFloatArray2[i5][i4] = (fArrMakeFloatArray[i5 - 1][i4] + f3) * 0.5f;
                }
                i5 = i6;
            }
            fArrMakeFloatArray2[i3][i4] = fArrMakeFloatArray[length - 2][i4];
        }
        if (!Float.isNaN(f)) {
            for (int i7 = 0; i7 < length2; i7++) {
                float[] fArr4 = fArrMakeFloatArray[length - 2];
                float f4 = fArr4[i7] * (1 - f);
                float[] fArr5 = fArrMakeFloatArray[0];
                float f5 = f4 + (fArr5[i7] * f);
                fArr5[i7] = f5;
                fArr4[i7] = f5;
                fArrMakeFloatArray2[i3][i7] = f5;
                fArrMakeFloatArray2[0][i7] = f5;
            }
        }
        int i8 = 0;
        while (i8 < i3) {
            int i9 = i2;
            while (i9 < length2) {
                float f6 = fArrMakeFloatArray[i8][i9];
                if (f6 == 0.0f) {
                    fArrMakeFloatArray2[i8][i9] = 0.0f;
                    fArrMakeFloatArray2[i8 + 1][i9] = 0.0f;
                    i = length2;
                } else {
                    float f7 = fArrMakeFloatArray2[i8][i9] / f6;
                    int i10 = i8 + 1;
                    float f8 = fArrMakeFloatArray2[i10][i9] / f6;
                    i = length2;
                    float fHypot = (float) Math.hypot(f7, f8);
                    if (fHypot > 9.0d) {
                        float f9 = 3.0f / fHypot;
                        float[] fArr6 = fArrMakeFloatArray2[i8];
                        float[] fArr7 = fArrMakeFloatArray[i8];
                        fArr6[i9] = f7 * f9 * fArr7[i9];
                        fArrMakeFloatArray2[i10][i9] = f9 * f8 * fArr7[i9];
                    }
                }
                i9++;
                length2 = i;
            }
            i8++;
            i2 = 0;
        }
        this.timePoints = fArr;
        this.values = fArr2;
        this.tangents = fArrMakeFloatArray2;
    }

    private final float[][] makeFloatArray(int a2, int b) {
        float[][] fArr = new float[a2][];
        for (int i = 0; i < a2; i++) {
            fArr[i] = new float[b];
        }
        return fArr;
    }

    public final float getPos(float t, int j) {
        float[] fArr = this.timePoints;
        int length = fArr.length;
        int i = 0;
        if (this.isExtrapolate) {
            float f = fArr[0];
            if (t <= f) {
                return this.values[0][j] + ((t - f) * getSlope(f, j));
            }
            int i2 = length - 1;
            float f2 = fArr[i2];
            if (t >= f2) {
                return this.values[i2][j] + ((t - f2) * getSlope(f2, j));
            }
        } else {
            if (t <= fArr[0]) {
                return this.values[0][j];
            }
            int i3 = length - 1;
            if (t >= fArr[i3]) {
                return this.values[i3][j];
            }
        }
        int i4 = length - 1;
        while (i < i4) {
            float[] fArr2 = this.timePoints;
            float f3 = fArr2[i];
            if (t == f3) {
                return this.values[i][j];
            }
            int i5 = i + 1;
            float f4 = fArr2[i5];
            if (t < f4) {
                float f5 = f4 - f3;
                float f6 = (t - f3) / f5;
                float[][] fArr3 = this.values;
                float f7 = fArr3[i][j];
                float f8 = fArr3[i5][j];
                float[][] fArr4 = this.tangents;
                return interpolate(f5, f6, f7, f8, fArr4[i][j], fArr4[i5][j]);
            }
            i = i5;
        }
        return 0.0f;
    }

    public static void getPos$default(MonoSpline monoSpline, float f, AnimationVector animationVector, int i, int i2, Object obj) {
        if ((i2 & 4) != 0) {
            i = 0;
        }
        monoSpline.getPos(f, animationVector, i);
    }

    public final void getPos(float time, AnimationVector v, int index) {
        float[] fArr = this.timePoints;
        int length = fArr.length;
        int i = 0;
        int length2 = this.values[0].length;
        if (this.isExtrapolate) {
            float f = fArr[0];
            if (time <= f) {
                getSlope(f, this.slopeTemp);
                for (int i2 = 0; i2 < length2; i2++) {
                    v.set$animation_core_release(i2, this.values[0][i2] + ((time - this.timePoints[0]) * this.slopeTemp[i2]));
                }
                return;
            }
            int i3 = length - 1;
            float f2 = fArr[i3];
            if (time >= f2) {
                getSlope(f2, this.slopeTemp);
                while (i < length2) {
                    v.set$animation_core_release(i, this.values[i3][i] + ((time - this.timePoints[i3]) * this.slopeTemp[i]));
                    i++;
                }
                return;
            }
        } else {
            if (time <= fArr[0]) {
                for (int i4 = 0; i4 < length2; i4++) {
                    v.set$animation_core_release(i4, this.values[0][i4]);
                }
                return;
            }
            int i5 = length - 1;
            if (time >= fArr[i5]) {
                while (i < length2) {
                    v.set$animation_core_release(i, this.values[i5][i]);
                    i++;
                }
                return;
            }
        }
        int i6 = length - 1;
        int i7 = index;
        while (i7 < i6) {
            if (time == this.timePoints[i7]) {
                for (int i8 = 0; i8 < length2; i8++) {
                    v.set$animation_core_release(i8, this.values[i7][i8]);
                }
            }
            float[] fArr2 = this.timePoints;
            int i9 = i7 + 1;
            float f3 = fArr2[i9];
            if (time < f3) {
                float f4 = fArr2[i7];
                float f5 = f3 - f4;
                float f6 = (time - f4) / f5;
                for (int i10 = 0; i10 < length2; i10++) {
                    float[][] fArr3 = this.values;
                    float f7 = fArr3[i7][i10];
                    float f8 = fArr3[i9][i10];
                    float[][] fArr4 = this.tangents;
                    v.set$animation_core_release(i10, interpolate(f5, f6, f7, f8, fArr4[i7][i10], fArr4[i9][i10]));
                }
                return;
            }
            i7 = i9;
        }
    }

    public final void getSlope(float time, float[] v) {
        float f;
        float[] fArr = this.timePoints;
        int length = fArr.length;
        int length2 = this.values[0].length;
        float f2 = fArr[0];
        if (time <= f2) {
            f = f2;
        } else {
            f = fArr[length - 1];
            if (time < f) {
                f = time;
            }
        }
        int i = length - 1;
        int i2 = 0;
        while (i2 < i) {
            float[] fArr2 = this.timePoints;
            int i3 = i2 + 1;
            float f3 = fArr2[i3];
            if (f <= f3) {
                float f4 = fArr2[i2];
                float f5 = f3 - f4;
                float f6 = (f - f4) / f5;
                for (int i4 = 0; i4 < length2; i4++) {
                    float[][] fArr3 = this.values;
                    float f7 = fArr3[i2][i4];
                    float f8 = fArr3[i3][i4];
                    float[][] fArr4 = this.tangents;
                    v[i4] = diff(f5, f6, f7, f8, fArr4[i2][i4], fArr4[i3][i4]) / f5;
                }
                return;
            }
            i2 = i3;
        }
    }

    public static void getSlope$default(MonoSpline monoSpline, float f, AnimationVector animationVector, int i, int i2, Object obj) {
        if ((i2 & 4) != 0) {
            i = 0;
        }
        monoSpline.getSlope(f, animationVector, i);
    }

    public final void getSlope(float time, AnimationVector v, int index) {
        float[] fArr = this.timePoints;
        int length = fArr.length;
        int length2 = this.values[0].length;
        if (time <= fArr[0]) {
            for (int i = 0; i < length2; i++) {
                v.set$animation_core_release(i, this.tangents[0][i]);
            }
            return;
        }
        int i2 = length - 1;
        if (time >= fArr[i2]) {
            for (int i3 = 0; i3 < length2; i3++) {
                v.set$animation_core_release(i3, this.tangents[i2][i3]);
            }
            return;
        }
        int i4 = index;
        while (i4 < i2) {
            float[] fArr2 = this.timePoints;
            int i5 = i4 + 1;
            float f = fArr2[i5];
            if (time <= f) {
                float f2 = fArr2[i4];
                float f3 = f - f2;
                float f4 = (time - f2) / f3;
                for (int i6 = 0; i6 < length2; i6++) {
                    float[][] fArr3 = this.values;
                    float f5 = fArr3[i4][i6];
                    float f6 = fArr3[i5][i6];
                    float[][] fArr4 = this.tangents;
                    v.set$animation_core_release(i6, diff(f3, f4, f5, f6, fArr4[i4][i6], fArr4[i5][i6]) / f3);
                }
                return;
            }
            i4 = i5;
        }
    }

    private final float getSlope(float time, int j) {
        float[] fArr = this.timePoints;
        int length = fArr.length;
        int i = 0;
        float f = fArr[0];
        if (time < f) {
            time = f;
        } else {
            float f2 = fArr[length - 1];
            if (time >= f2) {
                time = f2;
            }
        }
        int i2 = length - 1;
        while (i < i2) {
            float[] fArr2 = this.timePoints;
            int i3 = i + 1;
            float f3 = fArr2[i3];
            if (time <= f3) {
                float f4 = fArr2[i];
                float f5 = f3 - f4;
                float f6 = (time - f4) / f5;
                float[][] fArr3 = this.values;
                float f7 = fArr3[i][j];
                float f8 = fArr3[i3][j];
                float[][] fArr4 = this.tangents;
                return diff(f5, f6, f7, f8, fArr4[i][j], fArr4[i3][j]) / f5;
            }
            i = i3;
        }
        return 0.0f;
    }
}
