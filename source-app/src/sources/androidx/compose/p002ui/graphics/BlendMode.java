package androidx.compose.p002ui.graphics;

import kotlin.Metadata;
import kotlin.jvm.JvmInline;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0006\n\u0002\u0010\u000e\n\u0002\b\u0004\b\u0087@\u0018\u0000 \u00112\u00020\u0001:\u0001\u0011B\u0011\b\u0000\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0004\b\u0004\u0010\u0005J\u001a\u0010\u0006\u001a\u00020\u00072\b\u0010\b\u001a\u0004\u0018\u00010\u0001HÖ\u0003¢\u0006\u0004\b\t\u0010\nJ\u0010\u0010\u000b\u001a\u00020\u0003HÖ\u0001¢\u0006\u0004\b\f\u0010\u0005J\u000f\u0010\r\u001a\u00020\u000eH\u0016¢\u0006\u0004\b\u000f\u0010\u0010R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000\u0088\u0001\u0002\u0092\u0001\u00020\u0003¨\u0006\u0012"}, d2 = {"Landroidx/compose/ui/graphics/BlendMode;", "", "value", "", "constructor-impl", "(I)I", "equals", "", "other", "equals-impl", "(ILjava/lang/Object;)Z", "hashCode", "hashCode-impl", "toString", "", "toString-impl", "(I)Ljava/lang/String;", "Companion", "ui-graphics_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
@JvmInline
public final class BlendMode {
    private final int value;

    public static final Companion INSTANCE = new Companion(null);
    private static final int Clear = m4499constructorimpl(0);
    private static final int Src = m4499constructorimpl(1);
    private static final int Dst = m4499constructorimpl(2);
    private static final int SrcOver = m4499constructorimpl(3);
    private static final int DstOver = m4499constructorimpl(4);
    private static final int SrcIn = m4499constructorimpl(5);
    private static final int DstIn = m4499constructorimpl(6);
    private static final int SrcOut = m4499constructorimpl(7);
    private static final int DstOut = m4499constructorimpl(8);
    private static final int SrcAtop = m4499constructorimpl(9);
    private static final int DstAtop = m4499constructorimpl(10);
    private static final int Xor = m4499constructorimpl(11);
    private static final int Plus = m4499constructorimpl(12);
    private static final int Modulate = m4499constructorimpl(13);
    private static final int Screen = m4499constructorimpl(14);
    private static final int Overlay = m4499constructorimpl(15);
    private static final int Darken = m4499constructorimpl(16);
    private static final int Lighten = m4499constructorimpl(17);
    private static final int ColorDodge = m4499constructorimpl(18);
    private static final int ColorBurn = m4499constructorimpl(19);
    private static final int Hardlight = m4499constructorimpl(20);
    private static final int Softlight = m4499constructorimpl(21);
    private static final int Difference = m4499constructorimpl(22);
    private static final int Exclusion = m4499constructorimpl(23);
    private static final int Multiply = m4499constructorimpl(24);
    private static final int Hue = m4499constructorimpl(25);
    private static final int Saturation = m4499constructorimpl(26);
    private static final int Color = m4499constructorimpl(27);
    private static final int Luminosity = m4499constructorimpl(28);

    public static final BlendMode m4498boximpl(int i) {
        return new BlendMode(i);
    }

    public static int m4499constructorimpl(int i) {
        return i;
    }

    public static boolean m4500equalsimpl(int i, Object obj) {
        return (obj instanceof BlendMode) && i == ((BlendMode) obj).getValue();
    }

    public static final boolean m4501equalsimpl0(int i, int i2) {
        return i == i2;
    }

    public static int m4502hashCodeimpl(int i) {
        return i;
    }

    public boolean equals(Object obj) {
        return m4500equalsimpl(this.value, obj);
    }

    public int hashCode() {
        return m4502hashCodeimpl(this.value);
    }

    public final int getValue() {
        return this.value;
    }

    private BlendMode(int i) {
        this.value = i;
    }

    @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b<\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u0019\u0010\u0003\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0005\u0010\u0006R\u0019\u0010\b\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\t\u0010\u0006R\u0019\u0010\n\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u000b\u0010\u0006R\u0019\u0010\f\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\r\u0010\u0006R\u0019\u0010\u000e\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u000f\u0010\u0006R\u0019\u0010\u0010\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0011\u0010\u0006R\u0019\u0010\u0012\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0013\u0010\u0006R\u0019\u0010\u0014\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0015\u0010\u0006R\u0019\u0010\u0016\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0017\u0010\u0006R\u0019\u0010\u0018\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0019\u0010\u0006R\u0019\u0010\u001a\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u001b\u0010\u0006R\u0019\u0010\u001c\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u001d\u0010\u0006R\u0019\u0010\u001e\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u001f\u0010\u0006R\u0019\u0010 \u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b!\u0010\u0006R\u0019\u0010\"\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b#\u0010\u0006R\u0019\u0010$\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b%\u0010\u0006R\u0019\u0010&\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b'\u0010\u0006R\u0019\u0010(\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b)\u0010\u0006R\u0019\u0010*\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b+\u0010\u0006R\u0019\u0010,\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b-\u0010\u0006R\u0019\u0010.\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b/\u0010\u0006R\u0019\u00100\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b1\u0010\u0006R\u0019\u00102\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b3\u0010\u0006R\u0019\u00104\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b5\u0010\u0006R\u0019\u00106\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b7\u0010\u0006R\u0019\u00108\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b9\u0010\u0006R\u0019\u0010:\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b;\u0010\u0006R\u0019\u0010<\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b=\u0010\u0006R\u0019\u0010>\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b?\u0010\u0006\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006@"}, d2 = {"Landroidx/compose/ui/graphics/BlendMode$Companion;", "", "()V", "Clear", "Landroidx/compose/ui/graphics/BlendMode;", "getClear-0nO6VwU", "()I", "I", "Color", "getColor-0nO6VwU", "ColorBurn", "getColorBurn-0nO6VwU", "ColorDodge", "getColorDodge-0nO6VwU", "Darken", "getDarken-0nO6VwU", "Difference", "getDifference-0nO6VwU", "Dst", "getDst-0nO6VwU", "DstAtop", "getDstAtop-0nO6VwU", "DstIn", "getDstIn-0nO6VwU", "DstOut", "getDstOut-0nO6VwU", "DstOver", "getDstOver-0nO6VwU", "Exclusion", "getExclusion-0nO6VwU", "Hardlight", "getHardlight-0nO6VwU", "Hue", "getHue-0nO6VwU", "Lighten", "getLighten-0nO6VwU", "Luminosity", "getLuminosity-0nO6VwU", "Modulate", "getModulate-0nO6VwU", "Multiply", "getMultiply-0nO6VwU", "Overlay", "getOverlay-0nO6VwU", "Plus", "getPlus-0nO6VwU", "Saturation", "getSaturation-0nO6VwU", "Screen", "getScreen-0nO6VwU", "Softlight", "getSoftlight-0nO6VwU", "Src", "getSrc-0nO6VwU", "SrcAtop", "getSrcAtop-0nO6VwU", "SrcIn", "getSrcIn-0nO6VwU", "SrcOut", "getSrcOut-0nO6VwU", "SrcOver", "getSrcOver-0nO6VwU", "Xor", "getXor-0nO6VwU", "ui-graphics_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final int m4505getClear0nO6VwU() {
            return BlendMode.Clear;
        }

        public final int m4528getSrc0nO6VwU() {
            return BlendMode.Src;
        }

        public final int m4511getDst0nO6VwU() {
            return BlendMode.Dst;
        }

        public final int m4532getSrcOver0nO6VwU() {
            return BlendMode.SrcOver;
        }

        public final int m4515getDstOver0nO6VwU() {
            return BlendMode.DstOver;
        }

        public final int m4530getSrcIn0nO6VwU() {
            return BlendMode.SrcIn;
        }

        public final int m4513getDstIn0nO6VwU() {
            return BlendMode.DstIn;
        }

        public final int m4531getSrcOut0nO6VwU() {
            return BlendMode.SrcOut;
        }

        public final int m4514getDstOut0nO6VwU() {
            return BlendMode.DstOut;
        }

        public final int m4529getSrcAtop0nO6VwU() {
            return BlendMode.SrcAtop;
        }

        public final int m4512getDstAtop0nO6VwU() {
            return BlendMode.DstAtop;
        }

        public final int m4533getXor0nO6VwU() {
            return BlendMode.Xor;
        }

        public final int m4524getPlus0nO6VwU() {
            return BlendMode.Plus;
        }

        public final int m4521getModulate0nO6VwU() {
            return BlendMode.Modulate;
        }

        public final int m4526getScreen0nO6VwU() {
            return BlendMode.Screen;
        }

        public final int m4523getOverlay0nO6VwU() {
            return BlendMode.Overlay;
        }

        public final int m4509getDarken0nO6VwU() {
            return BlendMode.Darken;
        }

        public final int m4519getLighten0nO6VwU() {
            return BlendMode.Lighten;
        }

        public final int m4508getColorDodge0nO6VwU() {
            return BlendMode.ColorDodge;
        }

        public final int m4507getColorBurn0nO6VwU() {
            return BlendMode.ColorBurn;
        }

        public final int m4517getHardlight0nO6VwU() {
            return BlendMode.Hardlight;
        }

        public final int m4527getSoftlight0nO6VwU() {
            return BlendMode.Softlight;
        }

        public final int m4510getDifference0nO6VwU() {
            return BlendMode.Difference;
        }

        public final int m4516getExclusion0nO6VwU() {
            return BlendMode.Exclusion;
        }

        public final int m4522getMultiply0nO6VwU() {
            return BlendMode.Multiply;
        }

        public final int m4518getHue0nO6VwU() {
            return BlendMode.Hue;
        }

        public final int m4525getSaturation0nO6VwU() {
            return BlendMode.Saturation;
        }

        public final int m4506getColor0nO6VwU() {
            return BlendMode.Color;
        }

        public final int m4520getLuminosity0nO6VwU() {
            return BlendMode.Luminosity;
        }
    }

    public String toString() {
        return m4503toStringimpl(this.value);
    }

    public static String m4503toStringimpl(int i) {
        if (m4501equalsimpl0(i, Clear)) {
            return "Clear";
        }
        if (m4501equalsimpl0(i, Src)) {
            return "Src";
        }
        if (m4501equalsimpl0(i, Dst)) {
            return "Dst";
        }
        if (m4501equalsimpl0(i, SrcOver)) {
            return "SrcOver";
        }
        if (m4501equalsimpl0(i, DstOver)) {
            return "DstOver";
        }
        if (m4501equalsimpl0(i, SrcIn)) {
            return "SrcIn";
        }
        if (m4501equalsimpl0(i, DstIn)) {
            return "DstIn";
        }
        if (m4501equalsimpl0(i, SrcOut)) {
            return "SrcOut";
        }
        if (m4501equalsimpl0(i, DstOut)) {
            return "DstOut";
        }
        if (m4501equalsimpl0(i, SrcAtop)) {
            return "SrcAtop";
        }
        if (m4501equalsimpl0(i, DstAtop)) {
            return "DstAtop";
        }
        if (m4501equalsimpl0(i, Xor)) {
            return "Xor";
        }
        if (m4501equalsimpl0(i, Plus)) {
            return "Plus";
        }
        if (m4501equalsimpl0(i, Modulate)) {
            return "Modulate";
        }
        if (m4501equalsimpl0(i, Screen)) {
            return "Screen";
        }
        if (m4501equalsimpl0(i, Overlay)) {
            return "Overlay";
        }
        if (m4501equalsimpl0(i, Darken)) {
            return "Darken";
        }
        if (m4501equalsimpl0(i, Lighten)) {
            return "Lighten";
        }
        if (m4501equalsimpl0(i, ColorDodge)) {
            return "ColorDodge";
        }
        if (m4501equalsimpl0(i, ColorBurn)) {
            return "ColorBurn";
        }
        if (m4501equalsimpl0(i, Hardlight)) {
            return "HardLight";
        }
        if (m4501equalsimpl0(i, Softlight)) {
            return "Softlight";
        }
        if (m4501equalsimpl0(i, Difference)) {
            return "Difference";
        }
        if (m4501equalsimpl0(i, Exclusion)) {
            return "Exclusion";
        }
        if (m4501equalsimpl0(i, Multiply)) {
            return "Multiply";
        }
        if (m4501equalsimpl0(i, Hue)) {
            return "Hue";
        }
        if (m4501equalsimpl0(i, Saturation)) {
            return "Saturation";
        }
        if (m4501equalsimpl0(i, Color)) {
            return "Color";
        }
        return m4501equalsimpl0(i, Luminosity) ? "Luminosity" : "Unknown";
    }
}
