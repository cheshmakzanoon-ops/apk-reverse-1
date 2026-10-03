package androidx.compose.p002ui.platform;

import android.os.Parcel;
import android.util.Base64;
import androidx.compose.p002ui.geometry.OffsetKt;
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
import androidx.compose.ui.unit.TextUnitKt;
import androidx.compose.ui.unit.TextUnitType;
import kotlin.Metadata;
import kotlin.ULong;
import kotlin.collections.CollectionsKt;

@Metadata(d1 = {"\u0000|\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0005\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0007\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0000\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\b\u0010\u0007\u001a\u00020\bH\u0002J\u0015\u0010\t\u001a\u00020\nH\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\b\u000b\u0010\fJ\b\u0010\r\u001a\u00020\u000eH\u0002J\u0013\u0010\u000f\u001a\u00020\u0010ø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\b\u0011\u0010\u0012J\b\u0010\u0013\u001a\u00020\u0014H\u0002J\u0013\u0010\u0015\u001a\u00020\u0016ø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\b\u0017\u0010\u0018J\u0013\u0010\u0019\u001a\u00020\u001aø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\b\u001b\u0010\u0018J\u0006\u0010\u001c\u001a\u00020\u001dJ\b\u0010\u001e\u001a\u00020\bH\u0002J\b\u0010\u001f\u001a\u00020 H\u0002J\u0006\u0010!\u001a\u00020\"J\n\u0010#\u001a\u0004\u0018\u00010\u0003H\u0002J\b\u0010$\u001a\u00020%H\u0002J\b\u0010&\u001a\u00020'H\u0002J\u0013\u0010(\u001a\u00020)ø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\b*\u0010\u0012J\u0015\u0010+\u001a\u00020,H\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\b-\u0010\u0012R\u000e\u0010\u0005\u001a\u00020\u0006X\u0082\u0004¢\u0006\u0002\n\u0000\u0082\u0002\u000b\n\u0002\b!\n\u0005\b¡\u001e0\u0001¨\u0006."}, d2 = {"Landroidx/compose/ui/platform/DecodeHelper;", "", "string", "", "(Ljava/lang/String;)V", "parcel", "Landroid/os/Parcel;", "dataAvailable", "", "decodeBaselineShift", "Landroidx/compose/ui/text/style/BaselineShift;", "decodeBaselineShift-y9eOQZs", "()F", "decodeByte", "", "decodeColor", "Landroidx/compose/ui/graphics/Color;", "decodeColor-0d7_KjU", "()J", "decodeFloat", "", "decodeFontStyle", "Landroidx/compose/ui/text/font/FontStyle;", "decodeFontStyle-_-LCdwA", "()I", "decodeFontSynthesis", "Landroidx/compose/ui/text/font/FontSynthesis;", "decodeFontSynthesis-GVVA2EU", "decodeFontWeight", "Landroidx/compose/ui/text/font/FontWeight;", "decodeInt", "decodeShadow", "Landroidx/compose/ui/graphics/Shadow;", "decodeSpanStyle", "Landroidx/compose/ui/text/SpanStyle;", "decodeString", "decodeTextDecoration", "Landroidx/compose/ui/text/style/TextDecoration;", "decodeTextGeometricTransform", "Landroidx/compose/ui/text/style/TextGeometricTransform;", "decodeTextUnit", "Landroidx/compose/ui/unit/TextUnit;", "decodeTextUnit-XSAIIZE", "decodeULong", "Lkotlin/ULong;", "decodeULong-s-VKNKU", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class DecodeHelper {
    public static final int $stable = 8;
    private final Parcel parcel;

    public DecodeHelper(String str) {
        Parcel parcelObtain = Parcel.obtain();
        this.parcel = parcelObtain;
        byte[] bArrDecode = Base64.decode(str, 0);
        parcelObtain.unmarshall(bArrDecode, 0, bArrDecode.length);
        parcelObtain.setDataPosition(0);
    }

    public final SpanStyle decodeSpanStyle() {
        MutableSpanStyle mutableSpanStyle;
        MutableSpanStyle mutableSpanStyle2 = mutableSpanStyle;
        MutableSpanStyle mutableSpanStyle3 = new MutableSpanStyle(0L, 0L, null, null, null, null, null, 0L, null, null, null, 0L, null, null, 16383, null);
        while (this.parcel.dataAvail() > 1) {
            byte bDecodeByte = decodeByte();
            if (bDecodeByte != 1) {
                mutableSpanStyle = mutableSpanStyle2;
                if (bDecodeByte == 2) {
                    if (dataAvailable() >= 5) {
                        mutableSpanStyle.m6560setFontSizeR2X_6o(m6526decodeTextUnitXSAIIZE());
                        mutableSpanStyle2 = mutableSpanStyle;
                    } else {
                        return mutableSpanStyle.toSpanStyle();
                    }
                } else if (bDecodeByte == 3) {
                    if (dataAvailable() >= 4) {
                        mutableSpanStyle.setFontWeight(decodeFontWeight());
                        mutableSpanStyle2 = mutableSpanStyle;
                    } else {
                        return mutableSpanStyle.toSpanStyle();
                    }
                } else if (bDecodeByte == 4) {
                    if (dataAvailable() >= 1) {
                        mutableSpanStyle.m6561setFontStylemLjRB2g(FontStyle.box-impl(m6524decodeFontStyle_LCdwA()));
                        mutableSpanStyle2 = mutableSpanStyle;
                    } else {
                        return mutableSpanStyle.toSpanStyle();
                    }
                } else if (bDecodeByte != 5) {
                    if (bDecodeByte == 6) {
                        mutableSpanStyle.setFontFeatureSettings(decodeString());
                    } else if (bDecodeByte == 7) {
                        if (dataAvailable() >= 5) {
                            mutableSpanStyle.m6563setLetterSpacingR2X_6o(m6526decodeTextUnitXSAIIZE());
                        } else {
                            return mutableSpanStyle.toSpanStyle();
                        }
                    } else if (bDecodeByte == 8) {
                        if (dataAvailable() >= 4) {
                            mutableSpanStyle.m6558setBaselineShift_isdbwI(BaselineShift.box-impl(m6521decodeBaselineShifty9eOQZs()));
                        } else {
                            return mutableSpanStyle.toSpanStyle();
                        }
                    } else if (bDecodeByte == 9) {
                        if (dataAvailable() >= 8) {
                            mutableSpanStyle.setTextGeometricTransform(decodeTextGeometricTransform());
                        } else {
                            return mutableSpanStyle.toSpanStyle();
                        }
                    } else if (bDecodeByte == 10) {
                        if (dataAvailable() >= 8) {
                            mutableSpanStyle.m6557setBackground8_81llA(m6523decodeColor0d7_KjU());
                        } else {
                            return mutableSpanStyle.toSpanStyle();
                        }
                    } else if (bDecodeByte == 11) {
                        if (dataAvailable() >= 4) {
                            mutableSpanStyle.setTextDecoration(decodeTextDecoration());
                        } else {
                            return mutableSpanStyle.toSpanStyle();
                        }
                    } else if (bDecodeByte == 12) {
                        if (dataAvailable() >= 20) {
                            mutableSpanStyle.setShadow(decodeShadow());
                        } else {
                            return mutableSpanStyle.toSpanStyle();
                        }
                    }
                    mutableSpanStyle2 = mutableSpanStyle;
                } else if (dataAvailable() >= 1) {
                    mutableSpanStyle.m6562setFontSynthesistDdu0R4(FontSynthesis.box-impl(m6525decodeFontSynthesisGVVA2EU()));
                    mutableSpanStyle2 = mutableSpanStyle;
                } else {
                    return mutableSpanStyle.toSpanStyle();
                }
            } else {
                if (dataAvailable() < 8) {
                    break;
                }
                mutableSpanStyle2.m6559setColor8_81llA(m6523decodeColor0d7_KjU());
            }
        }
        mutableSpanStyle = mutableSpanStyle2;
        return mutableSpanStyle.toSpanStyle();
    }

    public final long m6523decodeColor0d7_KjU() {
        return Color.m4586constructorimpl(m6522decodeULongsVKNKU());
    }

    public final long m6526decodeTextUnitXSAIIZE() {
        long j;
        byte bDecodeByte = decodeByte();
        if (bDecodeByte == 1) {
            j = TextUnitType.Companion.getSp-UIouoOA();
        } else if (bDecodeByte == 2) {
            j = TextUnitType.Companion.getEm-UIouoOA();
        } else {
            j = TextUnitType.Companion.getUnspecified-UIouoOA();
        }
        if (TextUnitType.equals-impl0(j, TextUnitType.Companion.getUnspecified-UIouoOA())) {
            return TextUnit.Companion.getUnspecified-XSAIIZE();
        }
        return TextUnitKt.TextUnit-anM5pPY(decodeFloat(), j);
    }

    public final FontWeight decodeFontWeight() {
        return new FontWeight(decodeInt());
    }

    public final int m6524decodeFontStyle_LCdwA() {
        byte bDecodeByte = decodeByte();
        if (bDecodeByte == 0) {
            return FontStyle.Companion.getNormal-_-LCdwA();
        }
        if (bDecodeByte == 1) {
            return FontStyle.Companion.getItalic-_-LCdwA();
        }
        return FontStyle.Companion.getNormal-_-LCdwA();
    }

    public final int m6525decodeFontSynthesisGVVA2EU() {
        byte bDecodeByte = decodeByte();
        if (bDecodeByte == 0) {
            return FontSynthesis.Companion.getNone-GVVA2EU();
        }
        if (bDecodeByte == 1) {
            return FontSynthesis.Companion.getAll-GVVA2EU();
        }
        if (bDecodeByte == 3) {
            return FontSynthesis.Companion.getStyle-GVVA2EU();
        }
        if (bDecodeByte == 2) {
            return FontSynthesis.Companion.getWeight-GVVA2EU();
        }
        return FontSynthesis.Companion.getNone-GVVA2EU();
    }

    private final float m6521decodeBaselineShifty9eOQZs() {
        return BaselineShift.constructor-impl(decodeFloat());
    }

    private final TextGeometricTransform decodeTextGeometricTransform() {
        return new TextGeometricTransform(decodeFloat(), decodeFloat());
    }

    private final TextDecoration decodeTextDecoration() {
        int iDecodeInt = decodeInt();
        boolean z = (TextDecoration.Companion.getLineThrough().getMask() & iDecodeInt) != 0;
        boolean z2 = (iDecodeInt & TextDecoration.Companion.getUnderline().getMask()) != 0;
        if (z && z2) {
            return TextDecoration.Companion.combine(CollectionsKt.listOf(new TextDecoration[]{TextDecoration.Companion.getLineThrough(), TextDecoration.Companion.getUnderline()}));
        }
        if (z) {
            return TextDecoration.Companion.getLineThrough();
        }
        if (z2) {
            return TextDecoration.Companion.getUnderline();
        }
        return TextDecoration.Companion.getNone();
    }

    private final Shadow decodeShadow() {
        return new Shadow(m6523decodeColor0d7_KjU(), OffsetKt.Offset(decodeFloat(), decodeFloat()), decodeFloat(), null);
    }

    private final byte decodeByte() {
        return this.parcel.readByte();
    }

    private final int decodeInt() {
        return this.parcel.readInt();
    }

    private final long m6522decodeULongsVKNKU() {
        return ULong.constructor-impl(this.parcel.readLong());
    }

    private final float decodeFloat() {
        return this.parcel.readFloat();
    }

    private final String decodeString() {
        return this.parcel.readString();
    }

    private final int dataAvailable() {
        return this.parcel.dataAvail();
    }
}
