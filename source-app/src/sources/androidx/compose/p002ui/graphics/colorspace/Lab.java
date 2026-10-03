package androidx.compose.p002ui.graphics.colorspace;

import androidx.autofill.HintConstants;
import androidx.compose.p002ui.graphics.ColorKt;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000@\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\u0014\n\u0002\b\u0002\n\u0002\u0010\u0007\n\u0002\b\u0003\n\u0002\u0010\t\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\b\t\b\u0000\u0018\u0000 #2\u00020\u0001:\u0001#B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\u0010\u0010\n\u001a\u00020\u000b2\u0006\u0010\f\u001a\u00020\u000bH\u0016J\u0010\u0010\r\u001a\u00020\u000e2\u0006\u0010\u000f\u001a\u00020\u0005H\u0016J\u0010\u0010\u0010\u001a\u00020\u000e2\u0006\u0010\u000f\u001a\u00020\u0005H\u0016J%\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u000e2\u0006\u0010\u0014\u001a\u00020\u000e2\u0006\u0010\u0015\u001a\u00020\u000eH\u0010¢\u0006\u0002\b\u0016J\u0010\u0010\u0017\u001a\u00020\u000b2\u0006\u0010\f\u001a\u00020\u000bH\u0016J%\u0010\u0018\u001a\u00020\u000e2\u0006\u0010\u0013\u001a\u00020\u000e2\u0006\u0010\u0014\u001a\u00020\u000e2\u0006\u0010\u0015\u001a\u00020\u000eH\u0010¢\u0006\u0002\b\u0019J=\u0010\u001a\u001a\u00020\u001b2\u0006\u0010\u001c\u001a\u00020\u000e2\u0006\u0010\u001d\u001a\u00020\u000e2\u0006\u0010\u001e\u001a\u00020\u000e2\u0006\u0010\u001f\u001a\u00020\u000e2\u0006\u0010 \u001a\u00020\u0001H\u0010ø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\b!\u0010\"R\u0014\u0010\u0007\u001a\u00020\b8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u0007\u0010\t\u0082\u0002\u000b\n\u0002\b!\n\u0005\b¡\u001e0\u0001¨\u0006$"}, d2 = {"Landroidx/compose/ui/graphics/colorspace/Lab;", "Landroidx/compose/ui/graphics/colorspace/ColorSpace;", HintConstants.AUTOFILL_HINT_NAME, "", "id", "", "(Ljava/lang/String;I)V", "isWideGamut", "", "()Z", "fromXyz", "", "v", "getMaxValue", "", "component", "getMinValue", "toXy", "", "v0", "v1", "v2", "toXy$ui_graphics_release", "toXyz", "toZ", "toZ$ui_graphics_release", "xyzaToColor", "Landroidx/compose/ui/graphics/Color;", "x", "y", "z", "a", "colorSpace", "xyzaToColor-JlNiLsg$ui_graphics_release", "(FFFFLandroidx/compose/ui/graphics/colorspace/ColorSpace;)J", "Companion", "ui-graphics_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class Lab extends ColorSpace {

    private static final float f69A = 0.008856452f;

    private static final float f70B = 7.787037f;

    private static final float f71C = 0.13793103f;

    private static final float f72D = 0.20689656f;

    @Override
    public float getMaxValue(int component) {
        return component == 0 ? 100.0f : 128.0f;
    }

    @Override
    public float getMinValue(int component) {
        return component == 0 ? 0.0f : -128.0f;
    }

    @Override
    public boolean getIsWideGamut() {
        return true;
    }

    public Lab(String str, int i) {
        super(str, ColorModel.INSTANCE.m5023getLabxdoWZVw(), i, null);
    }

    @Override
    public float[] toXyz(float[] v) {
        float f = v[0];
        if (f < 0.0f) {
            f = 0.0f;
        }
        if (f > 100.0f) {
            f = 100.0f;
        }
        v[0] = f;
        float f2 = v[1];
        if (f2 < -128.0f) {
            f2 = -128.0f;
        }
        if (f2 > 128.0f) {
            f2 = 128.0f;
        }
        v[1] = f2;
        float f3 = v[2];
        float f4 = f3 >= -128.0f ? f3 : -128.0f;
        float f5 = f4 <= 128.0f ? f4 : 128.0f;
        v[2] = f5;
        float f6 = (f + 16.0f) / 116.0f;
        float f7 = (f2 * 0.002f) + f6;
        float f8 = f6 - (f5 * 0.005f);
        float f9 = f7 > f72D ? f7 * f7 * f7 : (f7 - f71C) * 0.12841855f;
        float f10 = f6 > f72D ? f6 * f6 * f6 : (f6 - f71C) * 0.12841855f;
        float f11 = f8 > f72D ? f8 * f8 * f8 : (f8 - f71C) * 0.12841855f;
        v[0] = f9 * Illuminant.INSTANCE.getD50Xyz$ui_graphics_release()[0];
        v[1] = f10 * Illuminant.INSTANCE.getD50Xyz$ui_graphics_release()[1];
        v[2] = f11 * Illuminant.INSTANCE.getD50Xyz$ui_graphics_release()[2];
        return v;
    }

    @Override
    public long toXy$ui_graphics_release(float v0, float v1, float v2) {
        if (v0 < 0.0f) {
            v0 = 0.0f;
        }
        if (v0 > 100.0f) {
            v0 = 100.0f;
        }
        if (v1 < -128.0f) {
            v1 = -128.0f;
        }
        if (v1 > 128.0f) {
            v1 = 128.0f;
        }
        float f = (v0 + 16.0f) / 116.0f;
        float f2 = (v1 * 0.002f) + f;
        float f3 = f2 > f72D ? f2 * f2 * f2 : (f2 - f71C) * 0.12841855f;
        return (((long) Float.floatToRawIntBits((f > f72D ? f * f * f : (f - f71C) * 0.12841855f) * Illuminant.INSTANCE.getD50Xyz$ui_graphics_release()[1])) & 4294967295L) | (((long) Float.floatToRawIntBits(f3 * Illuminant.INSTANCE.getD50Xyz$ui_graphics_release()[0])) << 32);
    }

    @Override
    public float toZ$ui_graphics_release(float v0, float v1, float v2) {
        if (v0 < 0.0f) {
            v0 = 0.0f;
        }
        if (v0 > 100.0f) {
            v0 = 100.0f;
        }
        if (v2 < -128.0f) {
            v2 = -128.0f;
        }
        if (v2 > 128.0f) {
            v2 = 128.0f;
        }
        float f = ((v0 + 16.0f) / 116.0f) - (v2 * 0.005f);
        return (f > f72D ? f * f * f : 0.12841855f * (f - f71C)) * Illuminant.INSTANCE.getD50Xyz$ui_graphics_release()[2];
    }

    @Override
    public long mo5027xyzaToColorJlNiLsg$ui_graphics_release(float x, float y, float z, float a2, ColorSpace colorSpace) {
        float f = x / Illuminant.INSTANCE.getD50Xyz$ui_graphics_release()[0];
        float f2 = y / Illuminant.INSTANCE.getD50Xyz$ui_graphics_release()[1];
        float f3 = z / Illuminant.INSTANCE.getD50Xyz$ui_graphics_release()[2];
        float fCbrt = f > f69A ? (float) Math.cbrt(f) : (f * f70B) + f71C;
        float fCbrt2 = f2 > f69A ? (float) Math.cbrt(f2) : (f2 * f70B) + f71C;
        float f4 = (116.0f * fCbrt2) - 16.0f;
        float f5 = (fCbrt - fCbrt2) * 500.0f;
        float fCbrt3 = (fCbrt2 - (f3 > f69A ? (float) Math.cbrt(f3) : (f3 * f70B) + f71C)) * 200.0f;
        if (f4 < 0.0f) {
            f4 = 0.0f;
        }
        if (f4 > 100.0f) {
            f4 = 100.0f;
        }
        if (f5 < -128.0f) {
            f5 = -128.0f;
        }
        if (f5 > 128.0f) {
            f5 = 128.0f;
        }
        if (fCbrt3 < -128.0f) {
            fCbrt3 = -128.0f;
        }
        return ColorKt.Color(f4, f5, fCbrt3 <= 128.0f ? fCbrt3 : 128.0f, a2, colorSpace);
    }

    @Override
    public float[] fromXyz(float[] v) {
        float f = v[0] / Illuminant.INSTANCE.getD50Xyz$ui_graphics_release()[0];
        float f2 = v[1] / Illuminant.INSTANCE.getD50Xyz$ui_graphics_release()[1];
        float f3 = v[2] / Illuminant.INSTANCE.getD50Xyz$ui_graphics_release()[2];
        float fCbrt = f > f69A ? (float) Math.cbrt(f) : (f * f70B) + f71C;
        float fCbrt2 = f2 > f69A ? (float) Math.cbrt(f2) : (f2 * f70B) + f71C;
        float f4 = (116.0f * fCbrt2) - 16.0f;
        float f5 = (fCbrt - fCbrt2) * 500.0f;
        float fCbrt3 = (fCbrt2 - (f3 > f69A ? (float) Math.cbrt(f3) : (f3 * f70B) + f71C)) * 200.0f;
        if (f4 < 0.0f) {
            f4 = 0.0f;
        }
        if (f4 > 100.0f) {
            f4 = 100.0f;
        }
        v[0] = f4;
        if (f5 < -128.0f) {
            f5 = -128.0f;
        }
        if (f5 > 128.0f) {
            f5 = 128.0f;
        }
        v[1] = f5;
        if (fCbrt3 < -128.0f) {
            fCbrt3 = -128.0f;
        }
        v[2] = fCbrt3 <= 128.0f ? fCbrt3 : 128.0f;
        return v;
    }
}
