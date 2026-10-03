package androidx.compose.p000ui.text.platform;

import androidx.compose.p000ui.text.AnnotatedString;
import androidx.compose.p000ui.text.EmojiSupportMatch;
import androidx.compose.p000ui.text.ParagraphIntrinsics;
import androidx.compose.p000ui.text.Placeholder;
import androidx.compose.p000ui.text.PlatformParagraphStyle;
import androidx.compose.p000ui.text.PlatformTextStyle;
import androidx.compose.p000ui.text.SpanStyle;
import androidx.compose.p000ui.text.TextStyle;
import androidx.compose.p000ui.text.font.FontFamily;
import androidx.compose.p000ui.text.intl.LocaleList;
import androidx.compose.p000ui.text.style.TextDirection;
import androidx.compose.p000ui.unit.Density;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.core.text.TextUtilsCompat;
import com.facebook.internal.AnalyticsEvents;
import java.util.List;
import java.util.Locale;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000P\n\u0000\n\u0002\u0010\u000b\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\u001aP\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\u00022\u0012\u0010\n\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\r0\f0\u000b2\u0012\u0010\u000e\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u000f0\f0\u000b2\u0006\u0010\u0010\u001a\u00020\u00112\u0006\u0010\u0012\u001a\u00020\u0013H\u0000\u001a&\u0010\u0014\u001a\u00020\u00152\u0006\u0010\u0016\u001a\u00020\u00172\n\b\u0002\u0010\u0018\u001a\u0004\u0018\u00010\u0019H\u0000ø\u0001\u0000¢\u0006\u0004\b\u001a\u0010\u001b\"\u0018\u0010\u0000\u001a\u00020\u0001*\u00020\u00028BX\u0082\u0004¢\u0006\u0006\u001a\u0004\b\u0003\u0010\u0004\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\u001c"}, d2 = {"hasEmojiCompat", "", "Landroidx/compose/ui/text/TextStyle;", "getHasEmojiCompat", "(Landroidx/compose/ui/text/TextStyle;)Z", "ActualParagraphIntrinsics", "Landroidx/compose/ui/text/ParagraphIntrinsics;", "text", "", AnalyticsEvents.PARAMETER_LIKE_VIEW_STYLE, "spanStyles", "", "Landroidx/compose/ui/text/AnnotatedString$Range;", "Landroidx/compose/ui/text/SpanStyle;", "placeholders", "Landroidx/compose/ui/text/Placeholder;", "density", "Landroidx/compose/ui/unit/Density;", "fontFamilyResolver", "Landroidx/compose/ui/text/font/FontFamily$Resolver;", "resolveTextDirectionHeuristics", "", "textDirection", "Landroidx/compose/ui/text/style/TextDirection;", "localeList", "Landroidx/compose/ui/text/intl/LocaleList;", "resolveTextDirectionHeuristics-HklW4sA", "(ILandroidx/compose/ui/text/intl/LocaleList;)I", "ui-text_release"}, k = 2, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class AndroidParagraphIntrinsics_androidKt {
    public static int m1551resolveTextDirectionHeuristicsHklW4sA$default(int i, LocaleList localeList, int i2, Object obj) {
        if ((i2 & 2) != 0) {
            localeList = null;
        }
        return m1550resolveTextDirectionHeuristicsHklW4sA(i, localeList);
    }

    public static final int m1550resolveTextDirectionHeuristicsHklW4sA(int i, LocaleList localeList) {
        Locale platformLocale;
        if (TextDirection.m1709equalsimpl0(i, TextDirection.INSTANCE.m1714getContentOrLtrs_7Xco())) {
            return 2;
        }
        if (!TextDirection.m1709equalsimpl0(i, TextDirection.INSTANCE.m1715getContentOrRtls_7Xco())) {
            if (TextDirection.m1709equalsimpl0(i, TextDirection.INSTANCE.m1716getLtrs_7Xco())) {
                return 0;
            }
            if (TextDirection.m1709equalsimpl0(i, TextDirection.INSTANCE.m1717getRtls_7Xco())) {
                return 1;
            }
            if (TextDirection.m1709equalsimpl0(i, TextDirection.INSTANCE.m1713getContents_7Xco()) ? true : TextDirection.m1709equalsimpl0(i, TextDirection.INSTANCE.m1718getUnspecifieds_7Xco())) {
                if (localeList == null || (platformLocale = localeList.get(0).getPlatformLocale()) == null) {
                    platformLocale = Locale.getDefault();
                }
                int layoutDirectionFromLocale = TextUtilsCompat.getLayoutDirectionFromLocale(platformLocale);
                if (layoutDirectionFromLocale == 0 || layoutDirectionFromLocale != 1) {
                    return 2;
                }
            } else {
                throw new IllegalStateException("Invalid TextDirection.".toString());
            }
        }
        return 3;
    }

    public static final ParagraphIntrinsics ActualParagraphIntrinsics(String str, TextStyle textStyle, List<AnnotatedString.Range<SpanStyle>> list, List<AnnotatedString.Range<Placeholder>> list2, Density density, FontFamily.Resolver resolver) {
        return new AndroidParagraphIntrinsics(str, textStyle, list, list2, resolver, density);
    }

    public static final boolean getHasEmojiCompat(TextStyle textStyle) {
        PlatformParagraphStyle paragraphStyle;
        PlatformTextStyle platformStyle = textStyle.getPlatformStyle();
        EmojiSupportMatch emojiSupportMatchM1118boximpl = (platformStyle == null || (paragraphStyle = platformStyle.getParagraphStyle()) == null) ? null : EmojiSupportMatch.m1118boximpl(paragraphStyle.getEmojiSupportMatch());
        return !(emojiSupportMatchM1118boximpl == null ? false : EmojiSupportMatch.m1121equalsimpl0(emojiSupportMatchM1118boximpl.getValue(), EmojiSupportMatch.INSTANCE.m1127getNone_3YsG6Y()));
    }
}
