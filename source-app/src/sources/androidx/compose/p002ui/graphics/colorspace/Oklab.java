package androidx.compose.p002ui.graphics.colorspace;

import androidx.autofill.HintConstants;
import androidx.compose.p002ui.graphics.ColorKt;
import androidx.compose.ui.util.MathHelpersKt;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000@\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\u0014\n\u0002\b\u0002\n\u0002\u0010\u0007\n\u0002\b\u0003\n\u0002\u0010\t\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\b\t\b\u0000\u0018\u0000 #2\u00020\u0001:\u0001#B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\u0010\u0010\n\u001a\u00020\u000b2\u0006\u0010\f\u001a\u00020\u000bH\u0016J\u0010\u0010\r\u001a\u00020\u000e2\u0006\u0010\u000f\u001a\u00020\u0005H\u0016J\u0010\u0010\u0010\u001a\u00020\u000e2\u0006\u0010\u000f\u001a\u00020\u0005H\u0016J%\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u000e2\u0006\u0010\u0014\u001a\u00020\u000e2\u0006\u0010\u0015\u001a\u00020\u000eH\u0010¢\u0006\u0002\b\u0016J\u0010\u0010\u0017\u001a\u00020\u000b2\u0006\u0010\f\u001a\u00020\u000bH\u0016J%\u0010\u0018\u001a\u00020\u000e2\u0006\u0010\u0013\u001a\u00020\u000e2\u0006\u0010\u0014\u001a\u00020\u000e2\u0006\u0010\u0015\u001a\u00020\u000eH\u0010¢\u0006\u0002\b\u0019J=\u0010\u001a\u001a\u00020\u001b2\u0006\u0010\u001c\u001a\u00020\u000e2\u0006\u0010\u001d\u001a\u00020\u000e2\u0006\u0010\u001e\u001a\u00020\u000e2\u0006\u0010\u001f\u001a\u00020\u000e2\u0006\u0010 \u001a\u00020\u0001H\u0010ø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\b!\u0010\"R\u0014\u0010\u0007\u001a\u00020\b8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u0007\u0010\t\u0082\u0002\u000b\n\u0002\b!\n\u0005\b¡\u001e0\u0001¨\u0006$"}, d2 = {"Landroidx/compose/ui/graphics/colorspace/Oklab;", "Landroidx/compose/ui/graphics/colorspace/ColorSpace;", HintConstants.AUTOFILL_HINT_NAME, "", "id", "", "(Ljava/lang/String;I)V", "isWideGamut", "", "()Z", "fromXyz", "", "v", "getMaxValue", "", "component", "getMinValue", "toXy", "", "v0", "v1", "v2", "toXy$ui_graphics_release", "toXyz", "toZ", "toZ$ui_graphics_release", "xyzaToColor", "Landroidx/compose/ui/graphics/Color;", "x", "y", "z", "a", "colorSpace", "xyzaToColor-JlNiLsg$ui_graphics_release", "(FFFFLandroidx/compose/ui/graphics/colorspace/ColorSpace;)J", "Companion", "ui-graphics_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class Oklab extends ColorSpace {
    private static final float[] InverseM1;
    private static final float[] InverseM2;

    private static final float[] f73M1;

    private static final float[] f74M2;

    @Override
    public float getMaxValue(int component) {
        return component == 0 ? 1.0f : 0.5f;
    }

    @Override
    public float getMinValue(int component) {
        return component == 0 ? 0.0f : -0.5f;
    }

    @Override
    public boolean getIsWideGamut() {
        return true;
    }

    public Oklab(String str, int i) {
        super(str, ColorModel.INSTANCE.m5023getLabxdoWZVw(), i, null);
    }

    @Override
    public float[] toXyz(float[] v) {
        float f = v[0];
        if (f < 0.0f) {
            f = 0.0f;
        }
        if (f > 1.0f) {
            f = 1.0f;
        }
        v[0] = f;
        float f2 = v[1];
        if (f2 < -0.5f) {
            f2 = -0.5f;
        }
        if (f2 > 0.5f) {
            f2 = 0.5f;
        }
        v[1] = f2;
        float f3 = v[2];
        float f4 = f3 >= -0.5f ? f3 : -0.5f;
        v[2] = f4 <= 0.5f ? f4 : 0.5f;
        ColorSpaceKt.mul3x3Float3(InverseM2, v);
        float f5 = v[0];
        v[0] = f5 * f5 * f5;
        float f6 = v[1];
        v[1] = f6 * f6 * f6;
        float f7 = v[2];
        v[2] = f7 * f7 * f7;
        ColorSpaceKt.mul3x3Float3(InverseM1, v);
        return v;
    }

    @Override
    public long toXy$ui_graphics_release(float v0, float v1, float v2) {
        if (v0 < 0.0f) {
            v0 = 0.0f;
        }
        if (v0 > 1.0f) {
            v0 = 1.0f;
        }
        if (v1 < -0.5f) {
            v1 = -0.5f;
        }
        if (v1 > 0.5f) {
            v1 = 0.5f;
        }
        if (v2 < -0.5f) {
            v2 = -0.5f;
        }
        float f = v2 <= 0.5f ? v2 : 0.5f;
        float[] fArr = InverseM2;
        float f2 = (fArr[0] * v0) + (fArr[3] * v1) + (fArr[6] * f);
        float f3 = (fArr[1] * v0) + (fArr[4] * v1) + (fArr[7] * f);
        float f4 = (fArr[2] * v0) + (fArr[5] * v1) + (fArr[8] * f);
        float f5 = f2 * f2 * f2;
        float f6 = f3 * f3 * f3;
        float f7 = f4 * f4 * f4;
        float[] fArr2 = InverseM1;
        return (((long) Float.floatToRawIntBits(((fArr2[0] * f5) + (fArr2[3] * f6)) + (fArr2[6] * f7))) << 32) | (((long) Float.floatToRawIntBits((fArr2[1] * f5) + (fArr2[4] * f6) + (fArr2[7] * f7))) & 4294967295L);
    }

    @Override
    public float toZ$ui_graphics_release(float v0, float v1, float v2) {
        if (v0 < 0.0f) {
            v0 = 0.0f;
        }
        if (v0 > 1.0f) {
            v0 = 1.0f;
        }
        if (v1 < -0.5f) {
            v1 = -0.5f;
        }
        if (v1 > 0.5f) {
            v1 = 0.5f;
        }
        if (v2 < -0.5f) {
            v2 = -0.5f;
        }
        float f = v2 <= 0.5f ? v2 : 0.5f;
        float[] fArr = InverseM2;
        float f2 = (fArr[0] * v0) + (fArr[3] * v1) + (fArr[6] * f);
        float f3 = (fArr[1] * v0) + (fArr[4] * v1) + (fArr[7] * f);
        float f4 = (fArr[2] * v0) + (fArr[5] * v1) + (fArr[8] * f);
        float f5 = f2 * f2 * f2;
        float f6 = f3 * f3 * f3;
        float[] fArr2 = InverseM1;
        return (fArr2[2] * f5) + (fArr2[5] * f6) + (fArr2[8] * f4 * f4 * f4);
    }

    @Override
    public long mo5027xyzaToColorJlNiLsg$ui_graphics_release(float x, float y, float z, float a2, ColorSpace colorSpace) {
        float[] fArr = f73M1;
        float f = (fArr[0] * x) + (fArr[3] * y) + (fArr[6] * z);
        float f2 = (fArr[1] * x) + (fArr[4] * y) + (fArr[7] * z);
        float f3 = (fArr[2] * x) + (fArr[5] * y) + (fArr[8] * z);
        float fFastCbrt = MathHelpersKt.fastCbrt(f);
        float fFastCbrt2 = MathHelpersKt.fastCbrt(f2);
        float fFastCbrt3 = MathHelpersKt.fastCbrt(f3);
        float[] fArr2 = f74M2;
        return ColorKt.Color((fArr2[0] * fFastCbrt) + (fArr2[3] * fFastCbrt2) + (fArr2[6] * fFastCbrt3), (fArr2[1] * fFastCbrt) + (fArr2[4] * fFastCbrt2) + (fArr2[7] * fFastCbrt3), (fArr2[2] * fFastCbrt) + (fArr2[5] * fFastCbrt2) + (fArr2[8] * fFastCbrt3), a2, colorSpace);
    }

    @Override
    public float[] fromXyz(float[] v) {
        ColorSpaceKt.mul3x3Float3(f73M1, v);
        v[0] = MathHelpersKt.fastCbrt(v[0]);
        v[1] = MathHelpersKt.fastCbrt(v[1]);
        v[2] = MathHelpersKt.fastCbrt(v[2]);
        ColorSpaceKt.mul3x3Float3(f74M2, v);
        return v;
    }

    static {
        float[] fArrMul3x3 = ColorSpaceKt.mul3x3(new float[]{0.818933f, 0.032984544f, 0.0482003f, 0.36186674f, 0.9293119f, 0.26436627f, -0.12885971f, 0.03614564f, 0.6338517f}, ColorSpaceKt.chromaticAdaptation(Adaptation.INSTANCE.getBradford().getTransform(), Illuminant.INSTANCE.getD50().toXyz$ui_graphics_release(), Illuminant.INSTANCE.getD65().toXyz$ui_graphics_release()));
        f73M1 = fArrMul3x3;
        float[] fArr = {0.21045426f, 1.9779985f, 0.025904037f, 0.7936178f, -2.4285922f, 0.78277177f, -0.004072047f, 0.4505937f, -0.80867577f};
        f74M2 = fArr;
        InverseM1 = ColorSpaceKt.inverse3x3(fArrMul3x3);
        InverseM2 = ColorSpaceKt.inverse3x3(fArr);
    }
}
