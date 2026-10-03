package zendesk.p009ui.android.compose.utils;

import androidx.compose.p000ui.text.PlatformTextStyle;
import androidx.compose.p000ui.text.TextStyle;
import androidx.constraintlayout.widget.ConstraintLayout;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000\b\n\u0000\n\u0002\u0018\u0002\n\u0000\u001a\f\u0010\u0000\u001a\u00020\u0001*\u00020\u0001H\u0000¨\u0006\u0002"}, d2 = {"applyFontPadding", "Landroidx/compose/ui/text/TextStyle;", "zendesk.ui_ui-android"}, k = 2, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class FontUtilsKt {
    public static final TextStyle applyFontPadding(TextStyle textStyle) {
        Intrinsics.checkNotNullParameter(textStyle, "<this>");
        return textStyle.m1312copyp1EtxEg((16252927 & 1) != 0 ? textStyle.spanStyle.m1235getColor0d7_KjU() : 0L, (16252927 & 2) != 0 ? textStyle.spanStyle.getFontSize() : 0L, (16252927 & 4) != 0 ? textStyle.spanStyle.getFontWeight() : null, (16252927 & 8) != 0 ? textStyle.spanStyle.getFontStyle() : null, (16252927 & 16) != 0 ? textStyle.spanStyle.getFontSynthesis() : null, (16252927 & 32) != 0 ? textStyle.spanStyle.getFontFamily() : null, (16252927 & 64) != 0 ? textStyle.spanStyle.getFontFeatureSettings() : null, (16252927 & 128) != 0 ? textStyle.spanStyle.getLetterSpacing() : 0L, (16252927 & 256) != 0 ? textStyle.spanStyle.getBaselineShift() : null, (16252927 & 512) != 0 ? textStyle.spanStyle.getTextGeometricTransform() : null, (16252927 & 1024) != 0 ? textStyle.spanStyle.getLocaleList() : null, (16252927 & 2048) != 0 ? textStyle.spanStyle.getBackground() : 0L, (16252927 & 4096) != 0 ? textStyle.spanStyle.getTextDecoration() : null, (16252927 & 8192) != 0 ? textStyle.spanStyle.getShadow() : null, (16252927 & 16384) != 0 ? textStyle.spanStyle.getDrawStyle() : null, (16252927 & 32768) != 0 ? textStyle.paragraphStyle.getTextAlign() : 0, (16252927 & 65536) != 0 ? textStyle.paragraphStyle.getTextDirection() : 0, (16252927 & 131072) != 0 ? textStyle.paragraphStyle.getLineHeight() : 0L, (16252927 & 262144) != 0 ? textStyle.paragraphStyle.getTextIndent() : null, (16252927 & 524288) != 0 ? textStyle.platformStyle : new PlatformTextStyle(true), (16252927 & 1048576) != 0 ? textStyle.paragraphStyle.getLineHeightStyle() : null, (16252927 & 2097152) != 0 ? textStyle.paragraphStyle.getLineBreak() : 0, (16252927 & 4194304) != 0 ? textStyle.paragraphStyle.getHyphens() : 0, (16252927 & 8388608) != 0 ? textStyle.paragraphStyle.getTextMotion() : null);
    }
}
