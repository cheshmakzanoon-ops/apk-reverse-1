package androidx.compose.p000ui.text.platform;

import android.graphics.Typeface;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.TextPaint;
import android.text.style.CharacterStyle;
import androidx.compose.p000ui.text.AnnotatedString;
import androidx.compose.p000ui.text.EmojiSupportMatch;
import androidx.compose.p000ui.text.Placeholder;
import androidx.compose.p000ui.text.PlatformParagraphStyle;
import androidx.compose.p000ui.text.PlatformTextStyle;
import androidx.compose.p000ui.text.SpanStyle;
import androidx.compose.p000ui.text.TextStyle;
import androidx.compose.p000ui.text.font.FontFamily;
import androidx.compose.p000ui.text.font.FontStyle;
import androidx.compose.p000ui.text.font.FontSynthesis;
import androidx.compose.p000ui.text.font.FontWeight;
import androidx.compose.p000ui.text.platform.extensions.PlaceholderExtensions_androidKt;
import androidx.compose.p000ui.text.platform.extensions.SpannableExtensions_androidKt;
import androidx.compose.p000ui.text.style.LineHeightStyle;
import androidx.compose.p000ui.text.style.TextDecoration;
import androidx.compose.p000ui.text.style.TextIndent;
import androidx.compose.p000ui.unit.Density;
import androidx.compose.p000ui.unit.TextUnitKt;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.emoji2.text.EmojiCompat;
import java.util.List;
import kotlin.Metadata;
import kotlin.jvm.functions.Function4;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000]\n\u0000\n\u0002\b\u0003\n\u0002\u0010\r\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u0007\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002*\u0001\u0001\u001a\u0080\u0001\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\n2\u0012\u0010\u000b\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u000e0\r0\f2\u0012\u0010\u000f\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00100\r0\f2\u0006\u0010\u0011\u001a\u00020\u00122&\u0010\u0013\u001a\"\u0012\u0006\u0012\u0004\u0018\u00010\u0015\u0012\u0004\u0012\u00020\u0016\u0012\u0004\u0012\u00020\u0017\u0012\u0004\u0012\u00020\u0018\u0012\u0004\u0012\u00020\u00190\u00142\u0006\u0010\u001a\u001a\u00020\u001bH\u0000\u001a\f\u0010\u001c\u001a\u00020\u001b*\u00020\nH\u0000\"\u0010\u0010\u0000\u001a\u00020\u0001X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0002¨\u0006\u001d"}, d2 = {"NoopSpan", "androidx/compose/ui/text/platform/AndroidParagraphHelper_androidKt$NoopSpan$1", "Landroidx/compose/ui/text/platform/AndroidParagraphHelper_androidKt$NoopSpan$1;", "createCharSequence", "", "text", "", "contextFontSize", "", "contextTextStyle", "Landroidx/compose/ui/text/TextStyle;", "spanStyles", "", "Landroidx/compose/ui/text/AnnotatedString$Range;", "Landroidx/compose/ui/text/SpanStyle;", "placeholders", "Landroidx/compose/ui/text/Placeholder;", "density", "Landroidx/compose/ui/unit/Density;", "resolveTypeface", "Lkotlin/Function4;", "Landroidx/compose/ui/text/font/FontFamily;", "Landroidx/compose/ui/text/font/FontWeight;", "Landroidx/compose/ui/text/font/FontStyle;", "Landroidx/compose/ui/text/font/FontSynthesis;", "Landroid/graphics/Typeface;", "useEmojiCompat", "", "isIncludeFontPaddingEnabled", "ui-text_release"}, k = 2, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class AndroidParagraphHelper_androidKt {
    private static final AndroidParagraphHelper_androidKt$NoopSpan$1 NoopSpan = new CharacterStyle() {
        @Override
        public void updateDrawState(TextPaint p0) {
        }
    };

    public static final CharSequence createCharSequence(String str, float f, TextStyle textStyle, List<AnnotatedString.Range<SpanStyle>> list, List<AnnotatedString.Range<Placeholder>> list2, Density density, Function4<? super FontFamily, ? super FontWeight, ? super FontStyle, ? super FontSynthesis, ? extends Typeface> function4, boolean z) {
        String strProcess;
        SpannableString spannableString;
        PlatformParagraphStyle paragraphStyle;
        if (z && EmojiCompat.isConfigured()) {
            PlatformTextStyle platformStyle = textStyle.getPlatformStyle();
            EmojiSupportMatch emojiSupportMatchM1118boximpl = (platformStyle == null || (paragraphStyle = platformStyle.getParagraphStyle()) == null) ? null : EmojiSupportMatch.m1118boximpl(paragraphStyle.getEmojiSupportMatch());
            strProcess = EmojiCompat.get().process(str, 0, str.length(), Integer.MAX_VALUE, emojiSupportMatchM1118boximpl == null ? 0 : EmojiSupportMatch.m1121equalsimpl0(emojiSupportMatchM1118boximpl.getValue(), EmojiSupportMatch.INSTANCE.m1125getAll_3YsG6Y()));
            Intrinsics.checkNotNull(strProcess);
        } else {
            strProcess = str;
        }
        if (list.isEmpty() && list2.isEmpty() && Intrinsics.areEqual(textStyle.getTextIndent(), TextIndent.INSTANCE.getNone()) && TextUnitKt.m2050isUnspecifiedR2X_6o(textStyle.m1325getLineHeightXSAIIZE())) {
            return strProcess;
        }
        if (strProcess instanceof Spannable) {
            spannableString = (Spannable) strProcess;
        } else {
            spannableString = new SpannableString(strProcess);
        }
        if (Intrinsics.areEqual(textStyle.getTextDecoration(), TextDecoration.INSTANCE.getUnderline())) {
            SpannableExtensions_androidKt.setSpan(spannableString, NoopSpan, 0, str.length());
        }
        if (isIncludeFontPaddingEnabled(textStyle) && textStyle.getLineHeightStyle() == null) {
            SpannableExtensions_androidKt.m1576setLineHeightr9BaKPg(spannableString, textStyle.m1325getLineHeightXSAIIZE(), f, density);
        } else {
            LineHeightStyle lineHeightStyle = textStyle.getLineHeightStyle();
            if (lineHeightStyle == null) {
                lineHeightStyle = LineHeightStyle.INSTANCE.getDefault();
            }
            SpannableExtensions_androidKt.m1575setLineHeightKmRG4DE(spannableString, textStyle.m1325getLineHeightXSAIIZE(), f, density, lineHeightStyle);
        }
        SpannableExtensions_androidKt.setTextIndent(spannableString, textStyle.getTextIndent(), f, density);
        SpannableExtensions_androidKt.setSpanStyles(spannableString, textStyle, list, density, function4);
        PlaceholderExtensions_androidKt.setPlaceholders(spannableString, list2, density);
        return spannableString;
    }

    public static final boolean isIncludeFontPaddingEnabled(TextStyle textStyle) {
        PlatformParagraphStyle paragraphStyle;
        PlatformTextStyle platformStyle = textStyle.getPlatformStyle();
        if (platformStyle == null || (paragraphStyle = platformStyle.getParagraphStyle()) == null) {
            return false;
        }
        return paragraphStyle.getIncludeFontPadding();
    }
}
