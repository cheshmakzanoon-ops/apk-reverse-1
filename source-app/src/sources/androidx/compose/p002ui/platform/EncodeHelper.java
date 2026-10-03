package androidx.compose.p002ui.platform;

import android.os.Parcel;
import android.util.Base64;
import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.graphics.Color;
import androidx.compose.p002ui.graphics.Shadow;
import androidx.compose.ui.text.SpanStyle;
import androidx.compose.ui.text.font.FontStyle;
import androidx.compose.ui.text.font.FontSynthesis;
import androidx.compose.ui.text.font.FontWeight;
import androidx.compose.ui.text.style.BaselineShift;
import androidx.compose.ui.text.style.TextDecoration;
import androidx.compose.ui.text.style.TextGeometricTransform;
import androidx.compose.ui.unit.TextUnit;
import androidx.compose.ui.unit.TextUnitType;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000~\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0005\n\u0000\n\u0002\u0010\u0007\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0000\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J\u0018\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\bø\u0001\u0000¢\u0006\u0004\b\t\u0010\nJ\u000e\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u000b\u001a\u00020\fJ\u000e\u0010\u0005\u001a\u00020\u00062\u0006\u0010\r\u001a\u00020\u000eJ\u0018\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u000f\u001a\u00020\u0010ø\u0001\u0000¢\u0006\u0004\b\u0011\u0010\u0012J\u0018\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0013\u001a\u00020\u0014ø\u0001\u0000¢\u0006\u0004\b\u0015\u0010\u0012J\u000e\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0016\u001a\u00020\u0017J\u0018\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0018\u001a\u00020\u0019ø\u0001\u0000¢\u0006\u0004\b\u001a\u0010\u001bJ\u000e\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u001c\u001a\u00020\u001dJ\u000e\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u001e\u001a\u00020\u001fJ\u0018\u0010\u0005\u001a\u00020\u00062\u0006\u0010 \u001a\u00020!ø\u0001\u0000¢\u0006\u0004\b\"\u0010\nJ\u000e\u0010\u0005\u001a\u00020\u00062\u0006\u0010#\u001a\u00020$J\u000e\u0010\u0005\u001a\u00020\u00062\u0006\u0010%\u001a\u00020&J\u000e\u0010\u0005\u001a\u00020\u00062\u0006\u0010'\u001a\u00020(J\u000e\u0010\u0005\u001a\u00020\u00062\u0006\u0010)\u001a\u00020*J\u0018\u0010\u0005\u001a\u00020\u00062\u0006\u0010+\u001a\u00020,ø\u0001\u0000¢\u0006\u0004\b-\u0010\nJ\u0006\u0010.\u001a\u00020*J\u0006\u0010/\u001a\u00020\u0006R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082\u000e¢\u0006\u0002\n\u0000\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u00060"}, d2 = {"Landroidx/compose/ui/platform/EncodeHelper;", "", "()V", "parcel", "Landroid/os/Parcel;", "encode", "", "color", "Landroidx/compose/ui/graphics/Color;", "encode-8_81llA", "(J)V", "shadow", "Landroidx/compose/ui/graphics/Shadow;", "spanStyle", "Landroidx/compose/ui/text/SpanStyle;", "fontStyle", "Landroidx/compose/ui/text/font/FontStyle;", "encode-nzbMABs", "(I)V", "fontSynthesis", "Landroidx/compose/ui/text/font/FontSynthesis;", "encode-6p3vJLY", "fontWeight", "Landroidx/compose/ui/text/font/FontWeight;", "baselineShift", "Landroidx/compose/ui/text/style/BaselineShift;", "encode-4Dl_Bck", "(F)V", "textDecoration", "Landroidx/compose/ui/text/style/TextDecoration;", "textGeometricTransform", "Landroidx/compose/ui/text/style/TextGeometricTransform;", "textUnit", "Landroidx/compose/ui/unit/TextUnit;", "encode--R2X_6o", "byte", "", "float", "", "int", "", "string", "", "uLong", "Lkotlin/ULong;", "encode-VKZWuLQ", "encodedString", "reset", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class EncodeHelper {
    public static final int $stable = 8;
    private Parcel parcel = Parcel.obtain();

    public final void reset() {
        this.parcel.recycle();
        this.parcel = Parcel.obtain();
    }

    public final String encodedString() {
        return Base64.encodeToString(this.parcel.marshall(), 0);
    }

    public final void encode(SpanStyle spanStyle) {
        if (!Color.m4591equalsimpl0(spanStyle.getColor-0d7_KjU(), Color.INSTANCE.m4626getUnspecified0d7_KjU())) {
            encode((byte) 1);
            m6539encode8_81llA(spanStyle.getColor-0d7_KjU());
        }
        if (!TextUnit.equals-impl0(spanStyle.getFontSize-XSAIIZE(), TextUnit.Companion.getUnspecified-XSAIIZE())) {
            encode((byte) 2);
            m6536encodeR2X_6o(spanStyle.getFontSize-XSAIIZE());
        }
        FontWeight fontWeight = spanStyle.getFontWeight();
        if (fontWeight != null) {
            encode((byte) 3);
            encode(fontWeight);
        }
        FontStyle fontStyle = spanStyle.getFontStyle-4Lr2A7w();
        if (fontStyle != null) {
            int i = fontStyle.unbox-impl();
            encode((byte) 4);
            m6541encodenzbMABs(i);
        }
        FontSynthesis fontSynthesis = spanStyle.getFontSynthesis-ZQGJjVo();
        if (fontSynthesis != null) {
            int i2 = fontSynthesis.unbox-impl();
            encode((byte) 5);
            m6538encode6p3vJLY(i2);
        }
        String fontFeatureSettings = spanStyle.getFontFeatureSettings();
        if (fontFeatureSettings != null) {
            encode((byte) 6);
            encode(fontFeatureSettings);
        }
        if (!TextUnit.equals-impl0(spanStyle.getLetterSpacing-XSAIIZE(), TextUnit.Companion.getUnspecified-XSAIIZE())) {
            encode((byte) 7);
            m6536encodeR2X_6o(spanStyle.getLetterSpacing-XSAIIZE());
        }
        BaselineShift baselineShift = spanStyle.getBaselineShift-5SSeXJ0();
        if (baselineShift != null) {
            float f = baselineShift.unbox-impl();
            encode((byte) 8);
            m6537encode4Dl_Bck(f);
        }
        TextGeometricTransform textGeometricTransform = spanStyle.getTextGeometricTransform();
        if (textGeometricTransform != null) {
            encode((byte) 9);
            encode(textGeometricTransform);
        }
        if (!Color.m4591equalsimpl0(spanStyle.getBackground-0d7_KjU(), Color.INSTANCE.m4626getUnspecified0d7_KjU())) {
            encode((byte) 10);
            m6539encode8_81llA(spanStyle.getBackground-0d7_KjU());
        }
        TextDecoration textDecoration = spanStyle.getTextDecoration();
        if (textDecoration != null) {
            encode((byte) 11);
            encode(textDecoration);
        }
        Shadow shadow = spanStyle.getShadow();
        if (shadow != null) {
            encode((byte) 12);
            encode(shadow);
        }
    }

    public final void m6539encode8_81llA(long color) {
        m6540encodeVKZWuLQ(color);
    }

    public final void m6536encodeR2X_6o(long textUnit) {
        long j = TextUnit.getType-UIouoOA(textUnit);
        byte b = 0;
        if (!TextUnitType.equals-impl0(j, TextUnitType.Companion.getUnspecified-UIouoOA())) {
            if (TextUnitType.equals-impl0(j, TextUnitType.Companion.getSp-UIouoOA())) {
                b = 1;
            } else if (TextUnitType.equals-impl0(j, TextUnitType.Companion.getEm-UIouoOA())) {
                b = 2;
            }
        }
        encode(b);
        if (TextUnitType.equals-impl0(TextUnit.getType-UIouoOA(textUnit), TextUnitType.Companion.getUnspecified-UIouoOA())) {
            return;
        }
        encode(TextUnit.getValue-impl(textUnit));
    }

    public final void encode(FontWeight fontWeight) {
        encode(fontWeight.getWeight());
    }

    public final void m6541encodenzbMABs(int fontStyle) {
        byte b = 0;
        if (!FontStyle.equals-impl0(fontStyle, FontStyle.Companion.getNormal-_-LCdwA()) && FontStyle.equals-impl0(fontStyle, FontStyle.Companion.getItalic-_-LCdwA())) {
            b = 1;
        }
        encode(b);
    }

    public final void m6538encode6p3vJLY(int fontSynthesis) {
        byte b = 0;
        if (!FontSynthesis.equals-impl0(fontSynthesis, FontSynthesis.Companion.getNone-GVVA2EU())) {
            if (FontSynthesis.equals-impl0(fontSynthesis, FontSynthesis.Companion.getAll-GVVA2EU())) {
                b = 1;
            } else if (FontSynthesis.equals-impl0(fontSynthesis, FontSynthesis.Companion.getWeight-GVVA2EU())) {
                b = 2;
            } else if (FontSynthesis.equals-impl0(fontSynthesis, FontSynthesis.Companion.getStyle-GVVA2EU())) {
                b = 3;
            }
        }
        encode(b);
    }

    public final void m6537encode4Dl_Bck(float baselineShift) {
        encode(baselineShift);
    }

    public final void encode(TextGeometricTransform textGeometricTransform) {
        encode(textGeometricTransform.getScaleX());
        encode(textGeometricTransform.getSkewX());
    }

    public final void encode(TextDecoration textDecoration) {
        encode(textDecoration.getMask());
    }

    public final void encode(Shadow shadow) {
        m6539encode8_81llA(shadow.getColor());
        encode(Offset.m4346getXimpl(shadow.getOffset()));
        encode(Offset.m4347getYimpl(shadow.getOffset()));
        encode(shadow.getBlurRadius());
    }

    public final void encode(byte b) {
        this.parcel.writeByte(b);
    }

    public final void encode(int i) {
        this.parcel.writeInt(i);
    }

    public final void encode(float f) {
        this.parcel.writeFloat(f);
    }

    public final void m6540encodeVKZWuLQ(long uLong) {
        this.parcel.writeLong(uLong);
    }

    public final void encode(String string) {
        this.parcel.writeString(string);
    }
}
