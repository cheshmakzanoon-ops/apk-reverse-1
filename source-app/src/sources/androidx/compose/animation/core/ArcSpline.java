package androidx.compose.animation.core;

import kotlin.Metadata;
import kotlin.collections.ArraysKt;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000:\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u0015\n\u0000\n\u0002\u0010\u0014\n\u0000\n\u0002\u0010\u0011\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u0007\n\u0002\b\u0005\b\u0001\u0018\u0000 \u00152\u00020\u0001:\u0002\u0014\u0015B#\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\f\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\u00050\u0007¢\u0006\u0002\u0010\bJ\u0016\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u00112\u0006\u0010\u0012\u001a\u00020\u0005J\u0016\u0010\u0013\u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u00112\u0006\u0010\u0012\u001a\u00020\u0005R\u001c\u0010\t\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\n0\u00070\u0007X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u000bR\u000e\u0010\f\u001a\u00020\rX\u0082D¢\u0006\u0002\n\u0000¨\u0006\u0016"}, d2 = {"Landroidx/compose/animation/core/ArcSpline;", "", "arcModes", "", "timePoints", "", "y", "", "([I[F[[F)V", "arcs", "Landroidx/compose/animation/core/ArcSpline$Arc;", "[[Landroidx/compose/animation/core/ArcSpline$Arc;", "isExtrapolate", "", "getPos", "", "time", "", "v", "getSlope", "Arc", "Companion", "animation-core_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class ArcSpline {
    public static final int ArcAbove = 5;
    public static final int ArcBelow = 4;
    public static final int ArcStartFlip = 3;
    public static final int ArcStartHorizontal = 2;
    public static final int ArcStartLinear = 0;
    public static final int ArcStartVertical = 1;
    private static final int DownArc = 4;
    private static final int StartHorizontal = 2;
    private static final int StartLinear = 3;
    private static final int StartVertical = 1;
    private static final int UpArc = 5;
    private final Arc[][] arcs;
    private final boolean isExtrapolate = true;
    public static final int $stable = 8;

    public ArcSpline(int[] iArr, float[] fArr, float[][] fArr2) {
        int length = fArr.length - 1;
        Arc[][] arcArr = new Arc[length][];
        int i = 1;
        int i2 = 1;
        for (int i3 = 0; i3 < length; i3++) {
            int i4 = iArr[i3];
            int i5 = 3;
            if (i4 == 0) {
                i2 = i5;
            } else if (i4 == 1) {
                i = 1;
                i2 = i;
            } else {
                if (i4 != 2) {
                    if (i4 != 3) {
                        i5 = 4;
                        if (i4 != 4) {
                            i5 = 5;
                            if (i4 == 5) {
                                i2 = i5;
                            }
                        } else {
                            i2 = i5;
                        }
                    } else {
                        if (i != 1) {
                            i = 1;
                        }
                        i2 = i;
                    }
                }
                i = 2;
                i2 = i;
            }
            float[] fArr3 = fArr2[i3];
            int length2 = (fArr3.length / 2) + (fArr3.length % 2);
            Arc[] arcArr2 = new Arc[length2];
            for (int i6 = 0; i6 < length2; i6++) {
                int i7 = i6 * 2;
                float f = fArr[i3];
                int i8 = i3 + 1;
                float f2 = fArr[i8];
                float[] fArr4 = fArr2[i3];
                float f3 = fArr4[i7];
                int i9 = i7 + 1;
                float f4 = fArr4[i9];
                float[] fArr5 = fArr2[i8];
                arcArr2[i6] = new Arc(i2, f, f2, f3, f4, fArr5[i7], fArr5[i9]);
            }
            arcArr[i3] = arcArr2;
        }
        this.arcs = arcArr;
    }

    public final void getPos(float r9, float[] r10) {
        throw new UnsupportedOperationException("Method not decompiled: androidx.compose.animation.core.ArcSpline.getPos(float, float[]):void");
    }

    public final void getSlope(float time, float[] v) {
        if (time < this.arcs[0][0].getTime1()) {
            time = this.arcs[0][0].getTime1();
        } else {
            Arc[][] arcArr = this.arcs;
            if (time > arcArr[arcArr.length - 1][0].getTime2()) {
                Arc[][] arcArr2 = this.arcs;
                time = arcArr2[arcArr2.length - 1][0].getTime2();
            }
        }
        int length = this.arcs.length;
        boolean z = false;
        for (int i = 0; i < length; i++) {
            int i2 = 0;
            int i3 = 0;
            while (i2 < v.length) {
                if (time <= this.arcs[i][i3].getTime2()) {
                    if (this.arcs[i][i3].getIsLinear()) {
                        v[i2] = this.arcs[i][i3].getEllipseCenterX();
                        v[i2 + 1] = this.arcs[i][i3].getEllipseCenterY();
                    } else {
                        this.arcs[i][i3].setPoint(time);
                        v[i2] = this.arcs[i][i3].calcDX();
                        v[i2 + 1] = this.arcs[i][i3].calcDY();
                    }
                    z = true;
                }
                i2 += 2;
                i3++;
            }
            if (z) {
                return;
            }
        }
    }

    @Metadata(d1 = {"\u00000\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u0007\n\u0002\b\r\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0010\u0014\n\u0002\b\u0007\n\u0002\u0010\u0002\n\u0002\b\u000e\b\u0007\u0018\u0000 ,2\u00020\u0001:\u0001,B?\b\u0000\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0005\u0012\u0006\u0010\u0007\u001a\u00020\u0005\u0012\u0006\u0010\b\u001a\u00020\u0005\u0012\u0006\u0010\t\u001a\u00020\u0005\u0012\u0006\u0010\n\u001a\u00020\u0005¢\u0006\u0002\u0010\u000bJ(\u0010\u001e\u001a\u00020\u001f2\u0006\u0010\u0007\u001a\u00020\u00052\u0006\u0010\b\u001a\u00020\u00052\u0006\u0010\t\u001a\u00020\u00052\u0006\u0010\n\u001a\u00020\u0005H\u0002J\u0006\u0010 \u001a\u00020\u0005J\u0006\u0010!\u001a\u00020\u0005J\u0006\u0010\"\u001a\u00020\u0005J\u0006\u0010#\u001a\u00020\u0005J\u0006\u0010$\u001a\u00020\u0005J\u0006\u0010%\u001a\u00020\u0005J\u000e\u0010&\u001a\u00020\u00052\u0006\u0010'\u001a\u00020\u0005J\u000e\u0010(\u001a\u00020\u00052\u0006\u0010'\u001a\u00020\u0005J\u0010\u0010)\u001a\u00020\u00052\u0006\u0010*\u001a\u00020\u0005H\u0002J\u000e\u0010+\u001a\u00020\u001f2\u0006\u0010'\u001a\u00020\u0005R\u000e\u0010\f\u001a\u00020\u0005X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\r\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000e\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000f\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0010\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0011\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u0011\u0010\u0012\u001a\u00020\u0013¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0014R\u000e\u0010\u0015\u001a\u00020\u0013X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0016\u001a\u00020\u0017X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0018\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u001aR\u0011\u0010\u0006\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u001aR\u000e\u0010\u001c\u001a\u00020\u0005X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u001d\u001a\u00020\u0005X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0007\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\t\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\n\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006-"}, d2 = {"Landroidx/compose/animation/core/ArcSpline$Arc;", "", "mode", "", "time1", "", "time2", "x1", "y1", "x2", "y2", "(IFFFFFF)V", "arcDistance", "arcVelocity", "ellipseA", "ellipseB", "ellipseCenterX", "ellipseCenterY", "isLinear", "", "()Z", "isVertical", "lut", "", "oneOverDeltaTime", "getTime1", "()F", "getTime2", "tmpCosAngle", "tmpSinAngle", "buildTable", "", "calcDX", "calcDY", "calcX", "calcY", "getLinearDX", "getLinearDY", "getLinearX", "time", "getLinearY", "lookup", "v", "setPoint", "Companion", "animation-core_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class Arc {
        private static final float Epsilon = 0.001f;
        private static float[] _ourPercent;
        private float arcDistance;
        private final float arcVelocity;
        private final float ellipseA;
        private final float ellipseB;
        private final float ellipseCenterX;
        private final float ellipseCenterY;
        private final boolean isLinear;
        private final boolean isVertical;
        private final float[] lut;
        private final float oneOverDeltaTime;
        private final float time1;
        private final float time2;
        private float tmpCosAngle;
        private float tmpSinAngle;
        private final float x1;
        private final float x2;
        private final float y1;
        private final float y2;

        public static final Companion INSTANCE = new Companion(null);
        public static final int $stable = 8;

        public Arc(int i, float f, float f2, float f3, float f4, float f5, float f6) {
            this.time1 = f;
            this.time2 = f2;
            this.x1 = f3;
            this.y1 = f4;
            this.x2 = f5;
            this.y2 = f6;
            float f7 = f5 - f3;
            float f8 = f6 - f4;
            boolean z = true;
            boolean z2 = i == 1 || (i == 4 ? f8 > 0.0f : !(i != 5 || f8 >= 0.0f));
            this.isVertical = z2;
            float f9 = 1 / (f2 - f);
            this.oneOverDeltaTime = f9;
            boolean z3 = 3 == i;
            if (z3 || Math.abs(f7) < Epsilon || Math.abs(f8) < Epsilon) {
                float fHypot = (float) Math.hypot(f8, f7);
                this.arcDistance = fHypot;
                this.arcVelocity = fHypot * f9;
                this.ellipseCenterX = f7 / (f2 - f);
                this.ellipseCenterY = f8 / (f2 - f);
                this.lut = new float[101];
                this.ellipseA = Float.NaN;
                this.ellipseB = Float.NaN;
            } else {
                this.lut = new float[101];
                this.ellipseA = f7 * (z2 ? -1 : 1);
                this.ellipseB = f8 * (z2 ? 1 : -1);
                this.ellipseCenterX = z2 ? f5 : f3;
                this.ellipseCenterY = z2 ? f4 : f6;
                buildTable(f3, f4, f5, f6);
                this.arcVelocity = this.arcDistance * f9;
                z = z3;
            }
            this.isLinear = z;
        }

        public final float getTime1() {
            return this.time1;
        }

        public final float getTime2() {
            return this.time2;
        }

        public final boolean getIsLinear() {
            return this.isLinear;
        }

        public final void setPoint(float time) {
            double dLookup = lookup((this.isVertical ? this.time2 - time : time - this.time1) * this.oneOverDeltaTime) * 1.5707964f;
            this.tmpSinAngle = (float) Math.sin(dLookup);
            this.tmpCosAngle = (float) Math.cos(dLookup);
        }

        public final float calcX() {
            return this.ellipseCenterX + (this.ellipseA * this.tmpSinAngle);
        }

        public final float calcY() {
            return this.ellipseCenterY + (this.ellipseB * this.tmpCosAngle);
        }

        public final float calcDX() {
            float f = this.ellipseA * this.tmpCosAngle;
            float fHypot = this.arcVelocity / ((float) Math.hypot(f, (-this.ellipseB) * this.tmpSinAngle));
            if (this.isVertical) {
                f = -f;
            }
            return f * fHypot;
        }

        public final float calcDY() {
            float f = this.ellipseA * this.tmpCosAngle;
            float f2 = (-this.ellipseB) * this.tmpSinAngle;
            float fHypot = this.arcVelocity / ((float) Math.hypot(f, f2));
            return this.isVertical ? (-f2) * fHypot : f2 * fHypot;
        }

        public final float getLinearX(float time) {
            float f = (time - this.time1) * this.oneOverDeltaTime;
            float f2 = this.x1;
            return f2 + (f * (this.x2 - f2));
        }

        public final float getLinearY(float time) {
            float f = (time - this.time1) * this.oneOverDeltaTime;
            float f2 = this.y1;
            return f2 + (f * (this.y2 - f2));
        }

        public final float getEllipseCenterX() {
            return this.ellipseCenterX;
        }

        public final float getEllipseCenterY() {
            return this.ellipseCenterY;
        }

        private final float lookup(float v) {
            if (v <= 0.0f) {
                return 0.0f;
            }
            if (v >= 1.0f) {
                return 1.0f;
            }
            float[] fArr = this.lut;
            float length = v * (fArr.length - 1);
            int i = (int) length;
            float f = length - i;
            float f2 = fArr[i];
            return f2 + (f * (fArr[i + 1] - f2));
        }

        private final void buildTable(float x1, float y1, float x2, float y2) {
            float f = x2 - x1;
            float f2 = y1 - y2;
            int length = INSTANCE.getOurPercent().length;
            float fHypot = 0.0f;
            float f3 = 0.0f;
            float f4 = 0.0f;
            int i = 0;
            while (i < length) {
                Companion companion = INSTANCE;
                double radians = (float) Math.toRadians((((double) i) * 90.0d) / ((double) (companion.getOurPercent().length - 1)));
                float fSin = ((float) Math.sin(radians)) * f;
                float fCos = ((float) Math.cos(radians)) * f2;
                if (i > 0) {
                    fHypot += (float) Math.hypot(fSin - f3, fCos - f4);
                    companion.getOurPercent()[i] = fHypot;
                }
                i++;
                f4 = fCos;
                f3 = fSin;
            }
            this.arcDistance = fHypot;
            int length2 = INSTANCE.getOurPercent().length;
            for (int i2 = 0; i2 < length2; i2++) {
                float[] ourPercent = INSTANCE.getOurPercent();
                ourPercent[i2] = ourPercent[i2] / fHypot;
            }
            int length3 = this.lut.length;
            for (int i3 = 0; i3 < length3; i3++) {
                float length4 = i3 / (this.lut.length - 1);
                Companion companion2 = INSTANCE;
                int iBinarySearch$default = ArraysKt.binarySearch$default(companion2.getOurPercent(), length4, 0, 0, 6, (Object) null);
                if (iBinarySearch$default >= 0) {
                    this.lut[i3] = iBinarySearch$default / (companion2.getOurPercent().length - 1);
                } else if (iBinarySearch$default == -1) {
                    this.lut[i3] = 0.0f;
                } else {
                    int i4 = -iBinarySearch$default;
                    int i5 = i4 - 2;
                    this.lut[i3] = (i5 + ((length4 - companion2.getOurPercent()[i5]) / (companion2.getOurPercent()[i4 - 1] - companion2.getOurPercent()[i5]))) / (companion2.getOurPercent().length - 1);
                }
            }
        }

        @Metadata(d1 = {"\u0000\u001a\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u0007\n\u0000\n\u0002\u0010\u0014\n\u0002\b\u0004\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u0010\u0010\u0005\u001a\u0004\u0018\u00010\u0006X\u0082\u000e¢\u0006\u0002\n\u0000R\u0014\u0010\u0007\u001a\u00020\u00068BX\u0082\u0004¢\u0006\u0006\u001a\u0004\b\b\u0010\t¨\u0006\n"}, d2 = {"Landroidx/compose/animation/core/ArcSpline$Arc$Companion;", "", "()V", "Epsilon", "", "_ourPercent", "", "ourPercent", "getOurPercent", "()[F", "animation-core_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            public final float[] getOurPercent() {
                if (Arc._ourPercent != null) {
                    float[] fArr = Arc._ourPercent;
                    Intrinsics.checkNotNull(fArr);
                    return fArr;
                }
                Arc._ourPercent = new float[91];
                float[] fArr2 = Arc._ourPercent;
                Intrinsics.checkNotNull(fArr2);
                return fArr2;
            }
        }
    }
}
