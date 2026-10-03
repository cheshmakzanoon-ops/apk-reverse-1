package androidx.compose.p002ui.graphics;

import kotlin.Metadata;
import kotlin.jvm.JvmInline;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0005\n\u0002\u0010\u000b\n\u0002\b\u0006\n\u0002\u0010\u000e\n\u0002\b\u0004\b\u0087@\u0018\u0000 \u00132\u00020\u0001:\u0001\u0013B\u0011\b\u0000\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0004\b\u0004\u0010\u0005J\u001a\u0010\b\u001a\u00020\t2\b\u0010\n\u001a\u0004\u0018\u00010\u0001HÖ\u0003¢\u0006\u0004\b\u000b\u0010\fJ\u0010\u0010\r\u001a\u00020\u0003HÖ\u0001¢\u0006\u0004\b\u000e\u0010\u0005J\u000f\u0010\u000f\u001a\u00020\u0010H\u0016¢\u0006\u0004\b\u0011\u0010\u0012R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007\u0088\u0001\u0002¨\u0006\u0014"}, d2 = {"Landroidx/compose/ui/graphics/ImageBitmapConfig;", "", "value", "", "constructor-impl", "(I)I", "getValue", "()I", "equals", "", "other", "equals-impl", "(ILjava/lang/Object;)Z", "hashCode", "hashCode-impl", "toString", "", "toString-impl", "(I)Ljava/lang/String;", "Companion", "ui-graphics_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
@JvmInline
public final class ImageBitmapConfig {
    private final int value;

    public static final Companion INSTANCE = new Companion(null);
    private static final int Argb8888 = m4811constructorimpl(0);
    private static final int Alpha8 = m4811constructorimpl(1);
    private static final int Rgb565 = m4811constructorimpl(2);
    private static final int F16 = m4811constructorimpl(3);
    private static final int Gpu = m4811constructorimpl(4);

    public static final ImageBitmapConfig m4810boximpl(int i) {
        return new ImageBitmapConfig(i);
    }

    public static int m4811constructorimpl(int i) {
        return i;
    }

    public static boolean m4812equalsimpl(int i, Object obj) {
        return (obj instanceof ImageBitmapConfig) && i == ((ImageBitmapConfig) obj).m4816unboximpl();
    }

    public static final boolean m4813equalsimpl0(int i, int i2) {
        return i == i2;
    }

    public static int m4814hashCodeimpl(int i) {
        return i;
    }

    public boolean equals(Object obj) {
        return m4812equalsimpl(this.value, obj);
    }

    public int hashCode() {
        return m4814hashCodeimpl(this.value);
    }

    public final int m4816unboximpl() {
        return this.value;
    }

    @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\f\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u0019\u0010\u0003\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0005\u0010\u0006R\u0019\u0010\b\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\t\u0010\u0006R\u0019\u0010\n\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u000b\u0010\u0006R\u0019\u0010\f\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\r\u0010\u0006R\u0019\u0010\u000e\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u000f\u0010\u0006\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u0010"}, d2 = {"Landroidx/compose/ui/graphics/ImageBitmapConfig$Companion;", "", "()V", "Alpha8", "Landroidx/compose/ui/graphics/ImageBitmapConfig;", "getAlpha8-_sVssgQ", "()I", "I", "Argb8888", "getArgb8888-_sVssgQ", "F16", "getF16-_sVssgQ", "Gpu", "getGpu-_sVssgQ", "Rgb565", "getRgb565-_sVssgQ", "ui-graphics_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final int m4818getArgb8888_sVssgQ() {
            return ImageBitmapConfig.Argb8888;
        }

        public final int m4817getAlpha8_sVssgQ() {
            return ImageBitmapConfig.Alpha8;
        }

        public final int m4821getRgb565_sVssgQ() {
            return ImageBitmapConfig.Rgb565;
        }

        public final int m4819getF16_sVssgQ() {
            return ImageBitmapConfig.F16;
        }

        public final int m4820getGpu_sVssgQ() {
            return ImageBitmapConfig.Gpu;
        }
    }

    private ImageBitmapConfig(int i) {
        this.value = i;
    }

    public final int getValue() {
        return this.value;
    }

    public String toString() {
        return m4815toStringimpl(this.value);
    }

    public static String m4815toStringimpl(int i) {
        if (m4813equalsimpl0(i, Argb8888)) {
            return "Argb8888";
        }
        if (m4813equalsimpl0(i, Alpha8)) {
            return "Alpha8";
        }
        if (m4813equalsimpl0(i, Rgb565)) {
            return "Rgb565";
        }
        if (m4813equalsimpl0(i, F16)) {
            return "F16";
        }
        return m4813equalsimpl0(i, Gpu) ? "Gpu" : "Unknown";
    }
}
