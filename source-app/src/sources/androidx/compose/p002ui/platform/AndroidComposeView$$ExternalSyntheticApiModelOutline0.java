package androidx.compose.p002ui.platform;

import android.graphics.ColorSpace;
import android.view.translation.ViewTranslationCallback;
import java.util.function.DoubleUnaryOperator;

public final class AndroidComposeView$$ExternalSyntheticApiModelOutline0 {
    public static ColorSpace.Rgb.TransferParameters m167m(double d, double d2, double d3, double d4, double d5, double d6, double d7) {
        return new ColorSpace.Rgb.TransferParameters(d, d2, d3, d4, d5, d6, d7);
    }

    public static ColorSpace.Rgb m169m(Object obj) {
        return (ColorSpace.Rgb) obj;
    }

    public static ColorSpace.Rgb m170m(String str, float[] fArr, float[] fArr2, ColorSpace.Rgb.TransferParameters transferParameters) {
        return new ColorSpace.Rgb(str, fArr, fArr2, transferParameters);
    }

    public static ColorSpace.Rgb m171m(String str, float[] fArr, float[] fArr2, DoubleUnaryOperator doubleUnaryOperator, DoubleUnaryOperator doubleUnaryOperator2, float f, float f2) {
        return new ColorSpace.Rgb(str, fArr, fArr2, doubleUnaryOperator, doubleUnaryOperator2, f, f2);
    }

    public static ColorSpace m173m(Object obj) {
        return (ColorSpace) obj;
    }

    public static ViewTranslationCallback m181m(Object obj) {
        return (ViewTranslationCallback) obj;
    }

    public static void m184m() {
    }

    public static boolean m206m(Object obj) {
        return obj instanceof ColorSpace.Rgb;
    }

    public static void m6457m$1() {
    }
}
