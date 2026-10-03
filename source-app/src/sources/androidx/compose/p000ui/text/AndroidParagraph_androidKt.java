package androidx.compose.p000ui.text;

import android.os.Build;
import android.text.Spannable;
import android.text.SpannableString;
import androidx.compose.p000ui.text.android.TextLayout;
import androidx.compose.p000ui.text.android.style.IndentationFixSpan;
import androidx.compose.p000ui.text.platform.extensions.SpannableExtensions_androidKt;
import androidx.compose.p000ui.text.style.Hyphens;
import androidx.compose.p000ui.text.style.LineBreak;
import androidx.compose.p000ui.text.style.TextAlign;
import androidx.compose.p000ui.unit.TextUnit;
import androidx.compose.p000ui.unit.TextUnitKt;
import androidx.constraintlayout.widget.ConstraintLayout;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000T\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\r\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\u001a\u0018\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0001H\u0002\u001a\u001a\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\bH\u0002ø\u0001\u0000¢\u0006\u0004\b\t\u0010\n\u001a\u001a\u0010\u000b\u001a\u00020\u00062\u0006\u0010\f\u001a\u00020\rH\u0002ø\u0001\u0000¢\u0006\u0004\b\u000e\u0010\n\u001a\u001a\u0010\u000f\u001a\u00020\u00062\u0006\u0010\u0010\u001a\u00020\u0011H\u0002ø\u0001\u0000¢\u0006\u0004\b\u0012\u0010\n\u001a\u001a\u0010\u0013\u001a\u00020\u00062\u0006\u0010\u0014\u001a\u00020\u0015H\u0002ø\u0001\u0000¢\u0006\u0004\b\u0016\u0010\n\u001a\u001a\u0010\u0017\u001a\u00020\u00062\u0006\u0010\u0018\u001a\u00020\u0019H\u0002ø\u0001\u0000¢\u0006\u0004\b\u001a\u0010\n\u001a\f\u0010\u001b\u001a\u00020\u001c*\u00020\u001cH\u0002\u001a\u0014\u0010\u001d\u001a\u00020\u0006*\u00020\u001e2\u0006\u0010\u001f\u001a\u00020\u0006H\u0002\u001a\u0016\u0010 \u001a\u00020\u0006*\u00020!H\u0002ø\u0001\u0000¢\u0006\u0004\b\"\u0010\n\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006#"}, d2 = {"shouldAttachIndentationFixSpan", "", "textStyle", "Landroidx/compose/ui/text/TextStyle;", "ellipsis", "toLayoutAlign", "", "align", "Landroidx/compose/ui/text/style/TextAlign;", "toLayoutAlign-aXe7zB0", "(I)I", "toLayoutBreakStrategy", "breakStrategy", "Landroidx/compose/ui/text/style/LineBreak$Strategy;", "toLayoutBreakStrategy-xImikfE", "toLayoutHyphenationFrequency", "hyphens", "Landroidx/compose/ui/text/style/Hyphens;", "toLayoutHyphenationFrequency--3fSNIE", "toLayoutLineBreakStyle", "lineBreakStrictness", "Landroidx/compose/ui/text/style/LineBreak$Strictness;", "toLayoutLineBreakStyle-hpcqdu8", "toLayoutLineBreakWordStyle", "lineBreakWordStyle", "Landroidx/compose/ui/text/style/LineBreak$WordBreak;", "toLayoutLineBreakWordStyle-wPN0Rpw", "attachIndentationFixSpan", "", "numberOfLinesThatFitMaxHeight", "Landroidx/compose/ui/text/android/TextLayout;", "maxHeight", "toLayoutTextGranularity", "Landroidx/compose/ui/text/TextGranularity;", "toLayoutTextGranularity-duNsdkg", "ui-text_release"}, k = 2, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class AndroidParagraph_androidKt {
    public static final int m1111toLayoutAlignaXe7zB0(int i) {
        if (TextAlign.m1695equalsimpl0(i, TextAlign.INSTANCE.m1702getLefte0LSkKk())) {
            return 3;
        }
        if (TextAlign.m1695equalsimpl0(i, TextAlign.INSTANCE.m1703getRighte0LSkKk())) {
            return 4;
        }
        if (TextAlign.m1695equalsimpl0(i, TextAlign.INSTANCE.m1699getCentere0LSkKk())) {
            return 2;
        }
        return (!TextAlign.m1695equalsimpl0(i, TextAlign.INSTANCE.m1704getStarte0LSkKk()) && TextAlign.m1695equalsimpl0(i, TextAlign.INSTANCE.m1700getEnde0LSkKk())) ? 1 : 0;
    }

    public static final int m1113toLayoutHyphenationFrequency3fSNIE(int i) {
        if (Hyphens.m1605equalsimpl0(i, Hyphens.INSTANCE.m1609getAutovmbZdU8())) {
            return Build.VERSION.SDK_INT <= 32 ? 2 : 4;
        }
        Hyphens.m1605equalsimpl0(i, Hyphens.INSTANCE.m1610getNonevmbZdU8());
        return 0;
    }

    public static final int m1112toLayoutBreakStrategyxImikfE(int i) {
        if (LineBreak.Strategy.m1636equalsimpl0(i, LineBreak.Strategy.INSTANCE.m1642getSimplefcGXIks())) {
            return 0;
        }
        if (LineBreak.Strategy.m1636equalsimpl0(i, LineBreak.Strategy.INSTANCE.m1641getHighQualityfcGXIks())) {
            return 1;
        }
        return LineBreak.Strategy.m1636equalsimpl0(i, LineBreak.Strategy.INSTANCE.m1640getBalancedfcGXIks()) ? 2 : 0;
    }

    public static final int m1114toLayoutLineBreakStylehpcqdu8(int i) {
        if (LineBreak.Strictness.m1647equalsimpl0(i, LineBreak.Strictness.INSTANCE.m1651getDefaultusljTpc())) {
            return 0;
        }
        if (LineBreak.Strictness.m1647equalsimpl0(i, LineBreak.Strictness.INSTANCE.m1652getLooseusljTpc())) {
            return 1;
        }
        if (LineBreak.Strictness.m1647equalsimpl0(i, LineBreak.Strictness.INSTANCE.m1653getNormalusljTpc())) {
            return 2;
        }
        return LineBreak.Strictness.m1647equalsimpl0(i, LineBreak.Strictness.INSTANCE.m1654getStrictusljTpc()) ? 3 : 0;
    }

    public static final int m1115toLayoutLineBreakWordStylewPN0Rpw(int i) {
        return (!LineBreak.WordBreak.m1659equalsimpl0(i, LineBreak.WordBreak.INSTANCE.m1663getDefaultjp8hJ3c()) && LineBreak.WordBreak.m1659equalsimpl0(i, LineBreak.WordBreak.INSTANCE.m1664getPhrasejp8hJ3c())) ? 1 : 0;
    }

    public static final int numberOfLinesThatFitMaxHeight(TextLayout textLayout, int i) {
        int lineCount = textLayout.getLineCount();
        for (int i2 = 0; i2 < lineCount; i2++) {
            if (textLayout.getLineBottom(i2) > i) {
                return i2;
            }
        }
        return textLayout.getLineCount();
    }

    public static final boolean shouldAttachIndentationFixSpan(TextStyle textStyle, boolean z) {
        return (!z || TextUnit.m2029equalsimpl0(textStyle.m1322getLetterSpacingXSAIIZE(), TextUnitKt.getSp(0)) || TextUnit.m2029equalsimpl0(textStyle.m1322getLetterSpacingXSAIIZE(), TextUnit.INSTANCE.m2043getUnspecifiedXSAIIZE()) || TextAlign.m1695equalsimpl0(textStyle.m1327getTextAligne0LSkKk(), TextAlign.INSTANCE.m1705getUnspecifiede0LSkKk()) || TextAlign.m1695equalsimpl0(textStyle.m1327getTextAligne0LSkKk(), TextAlign.INSTANCE.m1704getStarte0LSkKk()) || TextAlign.m1695equalsimpl0(textStyle.m1327getTextAligne0LSkKk(), TextAlign.INSTANCE.m1701getJustifye0LSkKk())) ? false : true;
    }

    public static final CharSequence attachIndentationFixSpan(CharSequence charSequence) {
        if (charSequence.length() == 0) {
            return charSequence;
        }
        SpannableString spannableString = charSequence instanceof Spannable ? (Spannable) charSequence : new SpannableString(charSequence);
        SpannableExtensions_androidKt.setSpan(spannableString, new IndentationFixSpan(), spannableString.length() - 1, spannableString.length() - 1);
        return spannableString;
    }

    public static final int m1116toLayoutTextGranularityduNsdkg(int i) {
        return (!TextGranularity.m1246equalsimpl0(i, TextGranularity.INSTANCE.m1250getCharacterDRrd7Zo()) && TextGranularity.m1246equalsimpl0(i, TextGranularity.INSTANCE.m1251getWordDRrd7Zo())) ? 1 : 0;
    }
}
