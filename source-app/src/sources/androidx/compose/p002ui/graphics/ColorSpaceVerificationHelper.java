package androidx.compose.p002ui.graphics;

import android.graphics.ColorSpace;
import androidx.compose.p002ui.graphics.colorspace.ColorSpaces;
import androidx.compose.p002ui.graphics.colorspace.DoubleFunction;
import androidx.compose.p002ui.graphics.colorspace.Rgb;
import androidx.compose.p002ui.graphics.colorspace.TransferParameters;
import androidx.compose.p002ui.graphics.colorspace.WhitePoint;
import androidx.compose.p002ui.platform.AndroidComposeView$$ExternalSyntheticApiModelOutline0;
import java.util.function.DoubleUnaryOperator;
import kotlin.Metadata;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÃ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\f\u0010\u0003\u001a\u00020\u0004*\u00020\u0005H\u0007J\f\u0010\u0006\u001a\u00020\u0005*\u00020\u0004H\u0007¨\u0006\u0007"}, d2 = {"Landroidx/compose/ui/graphics/ColorSpaceVerificationHelper;", "", "()V", "androidColorSpace", "Landroid/graphics/ColorSpace;", "Landroidx/compose/ui/graphics/colorspace/ColorSpace;", "composeColorSpace", "ui-graphics_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
final class ColorSpaceVerificationHelper {
    public static final ColorSpaceVerificationHelper INSTANCE = new ColorSpaceVerificationHelper();

    private ColorSpaceVerificationHelper() {
    }

    @JvmStatic
    public static final ColorSpace androidColorSpace(androidx.compose.p002ui.graphics.colorspace.ColorSpace colorSpace) {
        ColorSpace.Rgb.TransferParameters transferParametersM167m;
        ColorSpace.Rgb rgbM171m;
        if (Intrinsics.areEqual(colorSpace, ColorSpaces.INSTANCE.getSrgb())) {
            return ColorSpace.get(ColorSpace.Named.SRGB);
        }
        if (Intrinsics.areEqual(colorSpace, ColorSpaces.INSTANCE.getAces())) {
            return ColorSpace.get(ColorSpace.Named.ACES);
        }
        if (Intrinsics.areEqual(colorSpace, ColorSpaces.INSTANCE.getAcescg())) {
            return ColorSpace.get(ColorSpace.Named.ACESCG);
        }
        if (Intrinsics.areEqual(colorSpace, ColorSpaces.INSTANCE.getAdobeRgb())) {
            return ColorSpace.get(ColorSpace.Named.ADOBE_RGB);
        }
        if (Intrinsics.areEqual(colorSpace, ColorSpaces.INSTANCE.getBt2020())) {
            return ColorSpace.get(ColorSpace.Named.BT2020);
        }
        if (Intrinsics.areEqual(colorSpace, ColorSpaces.INSTANCE.getBt709())) {
            return ColorSpace.get(ColorSpace.Named.BT709);
        }
        if (Intrinsics.areEqual(colorSpace, ColorSpaces.INSTANCE.getCieLab())) {
            return ColorSpace.get(ColorSpace.Named.CIE_LAB);
        }
        if (Intrinsics.areEqual(colorSpace, ColorSpaces.INSTANCE.getCieXyz())) {
            return ColorSpace.get(ColorSpace.Named.CIE_XYZ);
        }
        if (Intrinsics.areEqual(colorSpace, ColorSpaces.INSTANCE.getDciP3())) {
            return ColorSpace.get(ColorSpace.Named.DCI_P3);
        }
        if (Intrinsics.areEqual(colorSpace, ColorSpaces.INSTANCE.getDisplayP3())) {
            return ColorSpace.get(ColorSpace.Named.DISPLAY_P3);
        }
        if (Intrinsics.areEqual(colorSpace, ColorSpaces.INSTANCE.getExtendedSrgb())) {
            return ColorSpace.get(ColorSpace.Named.EXTENDED_SRGB);
        }
        if (Intrinsics.areEqual(colorSpace, ColorSpaces.INSTANCE.getLinearExtendedSrgb())) {
            return ColorSpace.get(ColorSpace.Named.LINEAR_EXTENDED_SRGB);
        }
        if (Intrinsics.areEqual(colorSpace, ColorSpaces.INSTANCE.getLinearSrgb())) {
            return ColorSpace.get(ColorSpace.Named.LINEAR_SRGB);
        }
        if (Intrinsics.areEqual(colorSpace, ColorSpaces.INSTANCE.getNtsc1953())) {
            return ColorSpace.get(ColorSpace.Named.NTSC_1953);
        }
        if (Intrinsics.areEqual(colorSpace, ColorSpaces.INSTANCE.getProPhotoRgb())) {
            return ColorSpace.get(ColorSpace.Named.PRO_PHOTO_RGB);
        }
        if (Intrinsics.areEqual(colorSpace, ColorSpaces.INSTANCE.getSmpteC())) {
            return ColorSpace.get(ColorSpace.Named.SMPTE_C);
        }
        if (colorSpace instanceof Rgb) {
            Rgb rgb = (Rgb) colorSpace;
            float[] xyz$ui_graphics_release = rgb.getWhitePoint().toXyz$ui_graphics_release();
            TransferParameters transferParameters = rgb.getTransferParameters();
            if (transferParameters != null) {
                AndroidComposeView$$ExternalSyntheticApiModelOutline0.m184m();
                transferParametersM167m = AndroidComposeView$$ExternalSyntheticApiModelOutline0.m167m(transferParameters.getA(), transferParameters.getB(), transferParameters.getC(), transferParameters.getD(), transferParameters.getE(), transferParameters.getF(), transferParameters.getGamma());
            } else {
                transferParametersM167m = null;
            }
            if (transferParametersM167m != null) {
                AndroidComposeView$$ExternalSyntheticApiModelOutline0.m6457m$1();
                rgbM171m = AndroidComposeView$$ExternalSyntheticApiModelOutline0.m170m(colorSpace.getName(), rgb.getPrimaries(), xyz$ui_graphics_release, transferParametersM167m);
            } else {
                AndroidComposeView$$ExternalSyntheticApiModelOutline0.m6457m$1();
                String name = colorSpace.getName();
                float[] primaries = rgb.getPrimaries();
                final Function1<Double, Double> oetf = rgb.getOetf();
                DoubleUnaryOperator doubleUnaryOperator = new DoubleUnaryOperator() {
                    @Override
                    public DoubleUnaryOperator andThen(DoubleUnaryOperator doubleUnaryOperator2) {
                        return j$.util.function.DoubleUnaryOperator.-CC.$default$andThen(this, doubleUnaryOperator2);
                    }

                    @Override
                    public final double applyAsDouble(double d) {
                        return ColorSpaceVerificationHelper.androidColorSpace$lambda$0(oetf, d);
                    }

                    @Override
                    public DoubleUnaryOperator compose(DoubleUnaryOperator doubleUnaryOperator2) {
                        return j$.util.function.DoubleUnaryOperator.-CC.$default$compose(this, doubleUnaryOperator2);
                    }
                };
                final Function1<Double, Double> eotf = rgb.getEotf();
                rgbM171m = AndroidComposeView$$ExternalSyntheticApiModelOutline0.m171m(name, primaries, xyz$ui_graphics_release, doubleUnaryOperator, new DoubleUnaryOperator() {
                    @Override
                    public DoubleUnaryOperator andThen(DoubleUnaryOperator doubleUnaryOperator2) {
                        return j$.util.function.DoubleUnaryOperator.-CC.$default$andThen(this, doubleUnaryOperator2);
                    }

                    @Override
                    public final double applyAsDouble(double d) {
                        return ColorSpaceVerificationHelper.androidColorSpace$lambda$1(eotf, d);
                    }

                    @Override
                    public DoubleUnaryOperator compose(DoubleUnaryOperator doubleUnaryOperator2) {
                        return j$.util.function.DoubleUnaryOperator.-CC.$default$compose(this, doubleUnaryOperator2);
                    }
                }, colorSpace.getMinValue(0), colorSpace.getMaxValue(0));
            }
            return AndroidComposeView$$ExternalSyntheticApiModelOutline0.m173m((Object) rgbM171m);
        }
        return ColorSpace.get(ColorSpace.Named.SRGB);
    }

    public static final double androidColorSpace$lambda$0(Function1 function1, double d) {
        return ((Number) function1.invoke(Double.valueOf(d))).doubleValue();
    }

    public static final double androidColorSpace$lambda$1(Function1 function1, double d) {
        return ((Number) function1.invoke(Double.valueOf(d))).doubleValue();
    }

    @JvmStatic
    public static final androidx.compose.p002ui.graphics.colorspace.ColorSpace composeColorSpace(final ColorSpace colorSpace) {
        Rgb srgb;
        WhitePoint whitePoint;
        int id = colorSpace.getId();
        if (id == ColorSpace.Named.SRGB.ordinal()) {
            return ColorSpaces.INSTANCE.getSrgb();
        }
        if (id == ColorSpace.Named.ACES.ordinal()) {
            return ColorSpaces.INSTANCE.getAces();
        }
        if (id == ColorSpace.Named.ACESCG.ordinal()) {
            return ColorSpaces.INSTANCE.getAcescg();
        }
        if (id == ColorSpace.Named.ADOBE_RGB.ordinal()) {
            return ColorSpaces.INSTANCE.getAdobeRgb();
        }
        if (id == ColorSpace.Named.BT2020.ordinal()) {
            return ColorSpaces.INSTANCE.getBt2020();
        }
        if (id == ColorSpace.Named.BT709.ordinal()) {
            return ColorSpaces.INSTANCE.getBt709();
        }
        if (id == ColorSpace.Named.CIE_LAB.ordinal()) {
            return ColorSpaces.INSTANCE.getCieLab();
        }
        if (id == ColorSpace.Named.CIE_XYZ.ordinal()) {
            return ColorSpaces.INSTANCE.getCieXyz();
        }
        if (id == ColorSpace.Named.DCI_P3.ordinal()) {
            return ColorSpaces.INSTANCE.getDciP3();
        }
        if (id == ColorSpace.Named.DISPLAY_P3.ordinal()) {
            return ColorSpaces.INSTANCE.getDisplayP3();
        }
        if (id == ColorSpace.Named.EXTENDED_SRGB.ordinal()) {
            return ColorSpaces.INSTANCE.getExtendedSrgb();
        }
        if (id == ColorSpace.Named.LINEAR_EXTENDED_SRGB.ordinal()) {
            return ColorSpaces.INSTANCE.getLinearExtendedSrgb();
        }
        if (id == ColorSpace.Named.LINEAR_SRGB.ordinal()) {
            return ColorSpaces.INSTANCE.getLinearSrgb();
        }
        if (id == ColorSpace.Named.NTSC_1953.ordinal()) {
            return ColorSpaces.INSTANCE.getNtsc1953();
        }
        if (id == ColorSpace.Named.PRO_PHOTO_RGB.ordinal()) {
            return ColorSpaces.INSTANCE.getProPhotoRgb();
        }
        if (id == ColorSpace.Named.SMPTE_C.ordinal()) {
            return ColorSpaces.INSTANCE.getSmpteC();
        }
        if (AndroidComposeView$$ExternalSyntheticApiModelOutline0.m206m((Object) colorSpace)) {
            ColorSpace.Rgb.TransferParameters transferParameters = AndroidComposeView$$ExternalSyntheticApiModelOutline0.m169m((Object) colorSpace).getTransferParameters();
            if (AndroidComposeView$$ExternalSyntheticApiModelOutline0.m169m((Object) colorSpace).getWhitePoint().length == 3) {
                whitePoint = new WhitePoint(AndroidComposeView$$ExternalSyntheticApiModelOutline0.m169m((Object) colorSpace).getWhitePoint()[0], AndroidComposeView$$ExternalSyntheticApiModelOutline0.m169m((Object) colorSpace).getWhitePoint()[1], AndroidComposeView$$ExternalSyntheticApiModelOutline0.m169m((Object) colorSpace).getWhitePoint()[2]);
            } else {
                whitePoint = new WhitePoint(AndroidComposeView$$ExternalSyntheticApiModelOutline0.m169m((Object) colorSpace).getWhitePoint()[0], AndroidComposeView$$ExternalSyntheticApiModelOutline0.m169m((Object) colorSpace).getWhitePoint()[1]);
            }
            srgb = new Rgb(AndroidComposeView$$ExternalSyntheticApiModelOutline0.m169m((Object) colorSpace).getName(), AndroidComposeView$$ExternalSyntheticApiModelOutline0.m169m((Object) colorSpace).getPrimaries(), whitePoint, AndroidComposeView$$ExternalSyntheticApiModelOutline0.m169m((Object) colorSpace).getTransform(), new DoubleFunction() {
                @Override
                public final double invoke(double d) {
                    return ColorSpaceVerificationHelper.composeColorSpace$lambda$2(colorSpace, d);
                }
            }, new DoubleFunction() {
                @Override
                public final double invoke(double d) {
                    return ColorSpaceVerificationHelper.composeColorSpace$lambda$3(colorSpace, d);
                }
            }, colorSpace.getMinValue(0), colorSpace.getMaxValue(0), transferParameters != null ? new TransferParameters(transferParameters.g, transferParameters.a, transferParameters.b, transferParameters.c, transferParameters.d, transferParameters.e, transferParameters.f) : null, AndroidComposeView$$ExternalSyntheticApiModelOutline0.m169m((Object) colorSpace).getId());
        } else {
            srgb = ColorSpaces.INSTANCE.getSrgb();
        }
        return srgb;
    }

    public static final double composeColorSpace$lambda$2(ColorSpace colorSpace, double d) {
        return AndroidComposeView$$ExternalSyntheticApiModelOutline0.m169m((Object) colorSpace).getOetf().applyAsDouble(d);
    }

    public static final double composeColorSpace$lambda$3(ColorSpace colorSpace, double d) {
        return AndroidComposeView$$ExternalSyntheticApiModelOutline0.m169m((Object) colorSpace).getEotf().applyAsDouble(d);
    }
}
