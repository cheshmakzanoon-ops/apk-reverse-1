package androidx.compose.p000ui.text.platform;

import android.text.style.ClickableSpan;
import android.text.style.URLSpan;
import androidx.compose.p000ui.text.AnnotatedString;
import androidx.compose.p000ui.text.LinkAnnotation;
import androidx.compose.p000ui.text.UrlAnnotation;
import androidx.constraintlayout.widget.ConstraintLayout;
import java.util.WeakHashMap;
import kotlin.Metadata;

@Metadata(d1 = {"\u00006\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0007\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J\u0016\u0010\r\u001a\u0004\u0018\u00010\u000e2\f\u0010\u000f\u001a\b\u0012\u0004\u0012\u00020\u00060\u0005J\u0014\u0010\u0010\u001a\u00020\n2\f\u0010\u0011\u001a\b\u0012\u0004\u0012\u00020\f0\u0005J\u000e\u0010\u0010\u001a\u00020\n2\u0006\u0010\u0012\u001a\u00020\tR \u0010\u0003\u001a\u0014\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00060\u0005\u0012\u0004\u0012\u00020\u00070\u0004X\u0082\u0004¢\u0006\u0002\n\u0000R\u001a\u0010\b\u001a\u000e\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\n0\u0004X\u0082\u0004¢\u0006\u0002\n\u0000R \u0010\u000b\u001a\u0014\u0012\n\u0012\b\u0012\u0004\u0012\u00020\f0\u0005\u0012\u0004\u0012\u00020\n0\u0004X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0013"}, d2 = {"Landroidx/compose/ui/text/platform/URLSpanCache;", "", "()V", "linkSpansWithListenerByAnnotation", "Ljava/util/WeakHashMap;", "Landroidx/compose/ui/text/AnnotatedString$Range;", "Landroidx/compose/ui/text/LinkAnnotation;", "Landroidx/compose/ui/text/platform/ComposeClickableSpan;", "spansByAnnotation", "Landroidx/compose/ui/text/UrlAnnotation;", "Landroid/text/style/URLSpan;", "urlSpansByAnnotation", "Landroidx/compose/ui/text/LinkAnnotation$Url;", "toClickableSpan", "Landroid/text/style/ClickableSpan;", "linkRange", "toURLSpan", "urlRange", "urlAnnotation", "ui-text_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class URLSpanCache {
    public static final int $stable = 8;
    private final WeakHashMap<UrlAnnotation, URLSpan> spansByAnnotation = new WeakHashMap<>();
    private final WeakHashMap<AnnotatedString.Range<LinkAnnotation.Url>, URLSpan> urlSpansByAnnotation = new WeakHashMap<>();
    private final WeakHashMap<AnnotatedString.Range<LinkAnnotation>, ComposeClickableSpan> linkSpansWithListenerByAnnotation = new WeakHashMap<>();

    public final URLSpan toURLSpan(UrlAnnotation urlAnnotation) {
        WeakHashMap<UrlAnnotation, URLSpan> weakHashMap = this.spansByAnnotation;
        URLSpan uRLSpan = weakHashMap.get(urlAnnotation);
        if (uRLSpan == null) {
            uRLSpan = new URLSpan(urlAnnotation.getUrl());
            weakHashMap.put(urlAnnotation, uRLSpan);
        }
        return uRLSpan;
    }

    public final URLSpan toURLSpan(AnnotatedString.Range<LinkAnnotation.Url> urlRange) {
        WeakHashMap<AnnotatedString.Range<LinkAnnotation.Url>, URLSpan> weakHashMap = this.urlSpansByAnnotation;
        URLSpan uRLSpan = weakHashMap.get(urlRange);
        if (uRLSpan == null) {
            uRLSpan = new URLSpan(urlRange.getItem().getUrl());
            weakHashMap.put(urlRange, uRLSpan);
        }
        return uRLSpan;
    }

    public final ClickableSpan toClickableSpan(AnnotatedString.Range<LinkAnnotation> linkRange) {
        WeakHashMap<AnnotatedString.Range<LinkAnnotation>, ComposeClickableSpan> weakHashMap = this.linkSpansWithListenerByAnnotation;
        ComposeClickableSpan composeClickableSpan = weakHashMap.get(linkRange);
        if (composeClickableSpan == null) {
            composeClickableSpan = new ComposeClickableSpan(linkRange.getItem());
            weakHashMap.put(linkRange, composeClickableSpan);
        }
        return composeClickableSpan;
    }
}
