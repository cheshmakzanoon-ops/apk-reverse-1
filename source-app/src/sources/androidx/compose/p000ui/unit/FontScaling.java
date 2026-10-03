package androidx.compose.p000ui.unit;

import androidx.compose.p000ui.unit.fontscaling.FontScaleConverter;
import androidx.compose.p000ui.unit.fontscaling.FontScaleConverterFactory;
import androidx.constraintlayout.widget.ConstraintLayout;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000\u001e\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u0007\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\bg\u0018\u00002\u00020\u0001J\u0016\u0010\b\u001a\u00020\t*\u00020\nH\u0017ø\u0001\u0000¢\u0006\u0004\b\u000b\u0010\fJ\u0016\u0010\r\u001a\u00020\n*\u00020\tH\u0017ø\u0001\u0000¢\u0006\u0004\b\u000e\u0010\u000fR\u001a\u0010\u0002\u001a\u00020\u00038&X§\u0004¢\u0006\f\u0012\u0004\b\u0004\u0010\u0005\u001a\u0004\b\u0006\u0010\u0007ø\u0001\u0001\u0082\u0002\r\n\u0005\b¡\u001e0\u0001\n\u0004\b!0\u0001¨\u0006\u0010À\u0006\u0003"}, d2 = {"Landroidx/compose/ui/unit/FontScaling;", "", "fontScale", "", "getFontScale$annotations", "()V", "getFontScale", "()F", "toDp", "Landroidx/compose/ui/unit/Dp;", "Landroidx/compose/ui/unit/TextUnit;", "toDp-GaN1DYA", "(J)F", "toSp", "toSp-0xMU5do", "(F)J", "ui-unit_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public interface FontScaling {
    float getFontScale();

    float mo1831toDpGaN1DYA(long j);

    long mo1832toSp0xMU5do(float f);

    public final class CC {
        public static long m1945$default$toSp0xMU5do(FontScaling _this, float f) {
            if (!FontScaleConverterFactory.INSTANCE.isNonLinearFontScalingActive(_this.getFontScale())) {
                return TextUnitKt.getSp(f / _this.getFontScale());
            }
            FontScaleConverter fontScaleConverterForScale = FontScaleConverterFactory.INSTANCE.forScale(_this.getFontScale());
            return TextUnitKt.getSp(fontScaleConverterForScale != null ? fontScaleConverterForScale.convertDpToSp(f) : f / _this.getFontScale());
        }

        public static float m1944$default$toDpGaN1DYA(FontScaling _this, long j) {
            if (!TextUnitType.m2060equalsimpl0(TextUnit.m2031getTypeUIouoOA(j), TextUnitType.INSTANCE.m2065getSpUIouoOA())) {
                InlineClassHelperKt.throwIllegalStateException("Only Sp can convert to Px");
            }
            if (!FontScaleConverterFactory.INSTANCE.isNonLinearFontScalingActive(_this.getFontScale())) {
                return C0027Dp.m1835constructorimpl(TextUnit.m2032getValueimpl(j) * _this.getFontScale());
            }
            FontScaleConverter fontScaleConverterForScale = FontScaleConverterFactory.INSTANCE.forScale(_this.getFontScale());
            float fM2032getValueimpl = TextUnit.m2032getValueimpl(j);
            return C0027Dp.m1835constructorimpl(fontScaleConverterForScale == null ? fM2032getValueimpl * _this.getFontScale() : fontScaleConverterForScale.convertSpToDp(fM2032getValueimpl));
        }
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class DefaultImpls {
        public static void getFontScale$annotations() {
        }

        @Deprecated
        public static long m1949toSp0xMU5do(FontScaling fontScaling, float f) {
            return CC.m1945$default$toSp0xMU5do(fontScaling, f);
        }

        @Deprecated
        public static float m1948toDpGaN1DYA(FontScaling fontScaling, long j) {
            return CC.m1944$default$toDpGaN1DYA(fontScaling, j);
        }
    }
}
