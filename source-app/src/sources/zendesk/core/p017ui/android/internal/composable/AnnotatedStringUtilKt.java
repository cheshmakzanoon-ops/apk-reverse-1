package zendesk.core.p017ui.android.internal.composable;

import android.util.Patterns;
import androidx.compose.ui.graphics.Shadow;
import androidx.compose.ui.graphics.drawscope.DrawStyle;
import androidx.compose.ui.text.AnnotatedString;
import androidx.compose.ui.text.PlatformSpanStyle;
import androidx.compose.ui.text.SpanStyle;
import androidx.compose.ui.text.font.FontFamily;
import androidx.compose.ui.text.font.FontStyle;
import androidx.compose.ui.text.font.FontSynthesis;
import androidx.compose.ui.text.font.FontWeight;
import androidx.compose.ui.text.intl.LocaleList;
import androidx.compose.ui.text.style.BaselineShift;
import androidx.compose.ui.text.style.TextDecoration;
import androidx.compose.ui.text.style.TextGeometricTransform;
import java.util.regex.Matcher;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u00006\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\u001a(\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u00072\u0006\u0010\b\u001a\u00020\u0007ø\u0001\u0000¢\u0006\u0004\b\t\u0010\n\u001a,\u0010\u000b\u001a\u00020\f*\u00020\r2\u0006\u0010\u000e\u001a\u00020\u00052\u0006\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0005H\u0002\"\u000e\u0010\u0000\u001a\u00020\u0001X\u0082T¢\u0006\u0002\n\u0000\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\u0014"}, m18d2 = {"MINIMUM_PHONE_NUMBER_DIGITS", "", "formatTextAsAnnotatedString", "Landroidx/compose/ui/text/AnnotatedString;", "text", "", "defaultTextColor", "Landroidx/compose/ui/graphics/Color;", "linkTextColor", "formatTextAsAnnotatedString-WkMS-hQ", "(Ljava/lang/String;JJ)Landroidx/compose/ui/text/AnnotatedString;", "addStyleAndAnnotation", "", "Landroidx/compose/ui/text/AnnotatedString$Builder;", "annotation", "matcher", "Ljava/util/regex/Matcher;", "spanStyle", "Landroidx/compose/ui/text/SpanStyle;", "tag", "zendesk.core.ui_core-ui"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class AnnotatedStringUtilKt {
    private static final int MINIMUM_PHONE_NUMBER_DIGITS = 6;

    private static final void addStyleAndAnnotation(AnnotatedString.Builder builder, String str, Matcher matcher, SpanStyle spanStyle, String str2) {
        int iStart = matcher.start();
        int iEnd = matcher.end();
        builder.addStyle(spanStyle, iStart, iEnd);
        builder.addStringAnnotation(str2, str, iStart, iEnd);
    }

    public static final AnnotatedString m2106formatTextAsAnnotatedStringWkMShQ(String text, long j, long j2) {
        Intrinsics.checkNotNullParameter(text, "text");
        AnnotatedString.Builder builder = new AnnotatedString.Builder(0, 1, (DefaultConstructorMarker) null);
        SpanStyle spanStyle = new SpanStyle(j, 0L, (FontWeight) null, (FontStyle) null, (FontSynthesis) null, (FontFamily) null, (String) null, 0L, (BaselineShift) null, (TextGeometricTransform) null, (LocaleList) null, 0L, (TextDecoration) null, (Shadow) null, (PlatformSpanStyle) null, (DrawStyle) null, 65534, (DefaultConstructorMarker) null);
        SpanStyle spanStyle2 = spanStyle;
        SpanStyle spanStyle3 = new SpanStyle(j2, 0L, (FontWeight) null, (FontStyle) null, (FontSynthesis) null, (FontFamily) null, (String) null, 0L, (BaselineShift) null, (TextGeometricTransform) null, (LocaleList) null, 0L, TextDecoration.Companion.getUnderline(), (Shadow) null, (PlatformSpanStyle) null, (DrawStyle) null, 61438, (DefaultConstructorMarker) null);
        String str = text;
        Matcher matcher = Patterns.WEB_URL.matcher(str);
        Matcher matcher2 = Patterns.EMAIL_ADDRESS.matcher(str);
        Matcher matcher3 = Patterns.PHONE.matcher(str);
        int iPushStyle = builder.pushStyle(spanStyle);
        try {
            builder.append(text);
            while (matcher.find()) {
                String strGroup = matcher.group();
                Intrinsics.checkNotNullExpressionValue(strGroup, "group(...)");
                Intrinsics.checkNotNull(matcher);
                SpanStyle spanStyle4 = spanStyle2;
                addStyleAndAnnotation(builder, strGroup, matcher, spanStyle4, "URL");
                spanStyle2 = spanStyle4;
            }
            SpanStyle spanStyle5 = spanStyle2;
            while (matcher2.find()) {
                String strGroup2 = matcher2.group();
                Intrinsics.checkNotNullExpressionValue(strGroup2, "group(...)");
                Intrinsics.checkNotNull(matcher2);
                addStyleAndAnnotation(builder, strGroup2, matcher2, spanStyle5, "EMAIL");
            }
            while (matcher3.find()) {
                String strGroup3 = matcher3.group();
                if (strGroup3.length() >= 6) {
                    Intrinsics.checkNotNull(strGroup3);
                    Intrinsics.checkNotNull(matcher3);
                    addStyleAndAnnotation(builder, strGroup3, matcher3, spanStyle5, "PHONE");
                }
            }
            Unit unit = Unit.INSTANCE;
            return builder.toAnnotatedString();
        } finally {
            builder.pop(iPushStyle);
        }
    }
}
