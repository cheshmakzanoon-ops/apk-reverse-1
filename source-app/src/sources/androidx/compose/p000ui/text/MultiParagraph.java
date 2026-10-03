package androidx.compose.p000ui.text;

import androidx.compose.p000ui.text.font.DelegatingFontLoaderForDeprecatedUsage_androidKt;
import androidx.compose.p000ui.text.font.Font;
import androidx.compose.p000ui.text.font.FontFamily;
import androidx.compose.p000ui.text.platform.AndroidMultiParagraphDraw_androidKt;
import androidx.compose.p000ui.text.style.ResolvedTextDirection;
import androidx.compose.p000ui.text.style.TextDecoration;
import androidx.compose.p000ui.unit.Constraints;
import androidx.compose.p000ui.unit.ConstraintsKt;
import androidx.compose.p000ui.unit.Density;
import androidx.compose.ui.geometry.Offset;
import androidx.compose.ui.geometry.Rect;
import androidx.compose.ui.graphics.AndroidPath_androidKt;
import androidx.compose.ui.graphics.Brush;
import androidx.compose.ui.graphics.Canvas;
import androidx.compose.ui.graphics.Color;
import androidx.compose.ui.graphics.Path;
import androidx.compose.ui.graphics.Shadow;
import androidx.compose.ui.graphics.drawscope.DrawStyle;
import androidx.constraintlayout.core.motion.utils.TypedValues;
import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.appevents.internal.ViewHierarchyConstants;
import com.facebook.internal.AnalyticsEvents;
import java.util.ArrayList;
import java.util.List;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Ref;
import kotlin.ranges.RangesKt;

@Metadata(d1 = {"\u0000Ö\u0001\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0007\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0019\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0014\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0015\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\b\b\u0007\u0018\u00002\u00020\u0001B+\b\u0017\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0005\u0012\b\b\u0002\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\t¢\u0006\u0002\u0010\nBY\b\u0017\u0012\u0006\u0010\u000b\u001a\u00020\f\u0012\u0006\u0010\r\u001a\u00020\u000e\u0012\u0014\b\u0002\u0010\u000f\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00120\u00110\u0010\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0005\u0012\b\b\u0002\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\t\u0012\u0006\u0010\u0013\u001a\u00020\u0014\u0012\u0006\u0010\u0015\u001a\u00020\u0016¢\u0006\u0002\u0010\u0017BY\b\u0017\u0012\u0006\u0010\u000b\u001a\u00020\f\u0012\u0006\u0010\r\u001a\u00020\u000e\u0012\u0006\u0010\b\u001a\u00020\t\u0012\u0006\u0010\u0013\u001a\u00020\u0014\u0012\u0006\u0010\u0018\u001a\u00020\u0019\u0012\u0014\b\u0002\u0010\u000f\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00120\u00110\u0010\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0005\u0012\b\b\u0002\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\u001aBY\b\u0016\u0012\u0006\u0010\u000b\u001a\u00020\f\u0012\u0006\u0010\r\u001a\u00020\u000e\u0012\u0006\u0010\u001b\u001a\u00020\u001c\u0012\u0006\u0010\u0013\u001a\u00020\u0014\u0012\u0006\u0010\u0018\u001a\u00020\u0019\u0012\u0014\b\u0002\u0010\u000f\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00120\u00110\u0010\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0005\u0012\b\b\u0002\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\u001dB)\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u001b\u001a\u00020\u001c\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0005\u0012\b\b\u0002\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\u001eJ*\u0010=\u001a\u00020>2\u0006\u0010?\u001a\u00020@2\u0006\u0010A\u001a\u00020>2\b\b\u0001\u0010B\u001a\u00020\u0005ø\u0001\u0000¢\u0006\u0004\bC\u0010DJ\u000e\u0010E\u001a\u00020F2\u0006\u0010G\u001a\u00020\u0005J\u000e\u0010H\u001a\u00020:2\u0006\u0010G\u001a\u00020\u0005J\u000e\u0010I\u001a\u00020:2\u0006\u0010G\u001a\u00020\u0005J\u0016\u0010J\u001a\u00020\t2\u0006\u0010G\u001a\u00020\u00052\u0006\u0010K\u001a\u00020\u0007J\u000e\u0010L\u001a\u00020\t2\u0006\u0010M\u001a\u00020\u0005J\u000e\u0010N\u001a\u00020\t2\u0006\u0010M\u001a\u00020\u0005J\u0018\u0010O\u001a\u00020\u00052\u0006\u0010M\u001a\u00020\u00052\b\b\u0002\u0010P\u001a\u00020\u0007J\u000e\u0010Q\u001a\u00020\u00052\u0006\u0010G\u001a\u00020\u0005J\u000e\u0010R\u001a\u00020\u00052\u0006\u0010S\u001a\u00020\tJ\u000e\u0010T\u001a\u00020\t2\u0006\u0010M\u001a\u00020\u0005J\u000e\u0010U\u001a\u00020\t2\u0006\u0010M\u001a\u00020\u0005J\u000e\u0010V\u001a\u00020\t2\u0006\u0010M\u001a\u00020\u0005J\u000e\u0010W\u001a\u00020\u00052\u0006\u0010M\u001a\u00020\u0005J\u000e\u0010X\u001a\u00020\t2\u0006\u0010M\u001a\u00020\u0005J\u000e\u0010Y\u001a\u00020\t2\u0006\u0010M\u001a\u00020\u0005J\u0018\u0010Z\u001a\u00020\u00052\u0006\u0010[\u001a\u00020\\ø\u0001\u0000¢\u0006\u0004\b]\u0010^J\u000e\u0010_\u001a\u00020F2\u0006\u0010G\u001a\u00020\u0005J\u0016\u0010`\u001a\u00020a2\u0006\u0010b\u001a\u00020\u00052\u0006\u0010c\u001a\u00020\u0005J(\u0010d\u001a\u00020@2\u0006\u0010e\u001a\u00020:2\u0006\u0010f\u001a\u00020g2\u0006\u0010h\u001a\u00020iø\u0001\u0000¢\u0006\u0004\bj\u0010kJ\u001b\u0010l\u001a\u00020@2\u0006\u0010G\u001a\u00020\u0005ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\bm\u0010nJ\u000e\u0010o\u001a\u00020\u00072\u0006\u0010M\u001a\u00020\u0005JY\u0010p\u001a\u00020q2\u0006\u0010r\u001a\u00020s2\u0006\u0010t\u001a\u00020u2\b\b\u0002\u0010v\u001a\u00020\t2\n\b\u0002\u0010w\u001a\u0004\u0018\u00010x2\n\b\u0002\u0010y\u001a\u0004\u0018\u00010z2\n\b\u0002\u0010{\u001a\u0004\u0018\u00010|2\b\b\u0002\u0010}\u001a\u00020~ø\u0001\u0000¢\u0006\u0005\b\u007f\u0010\u0080\u0001J@\u0010p\u001a\u00020q2\u0006\u0010r\u001a\u00020s2\n\b\u0002\u0010\u0081\u0001\u001a\u00030\u0082\u00012\n\b\u0002\u0010w\u001a\u0004\u0018\u00010x2\n\b\u0002\u0010y\u001a\u0004\u0018\u00010zH\u0007ø\u0001\u0000¢\u0006\u0006\b\u0083\u0001\u0010\u0084\u0001JT\u0010p\u001a\u00020q2\u0006\u0010r\u001a\u00020s2\n\b\u0002\u0010\u0081\u0001\u001a\u00030\u0082\u00012\n\b\u0002\u0010w\u001a\u0004\u0018\u00010x2\n\b\u0002\u0010y\u001a\u0004\u0018\u00010z2\n\b\u0002\u0010{\u001a\u0004\u0018\u00010|2\b\b\u0002\u0010}\u001a\u00020~ø\u0001\u0000¢\u0006\u0006\b\u0085\u0001\u0010\u0086\u0001J\u0011\u0010\u0087\u0001\u001a\u00020q2\u0006\u0010G\u001a\u00020\u0005H\u0002J\u0011\u0010\u0088\u0001\u001a\u00020q2\u0006\u0010G\u001a\u00020\u0005H\u0002J\u0011\u0010\u0089\u0001\u001a\u00020q2\u0006\u0010M\u001a\u00020\u0005H\u0002R\u0014\u0010\u000b\u001a\u00020\f8BX\u0082\u0004¢\u0006\u0006\u001a\u0004\b\u001f\u0010 R\u0011\u0010!\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\"\u0010#R\u0011\u0010$\u001a\u00020\t8F¢\u0006\u0006\u001a\u0004\b%\u0010&R\u0011\u0010'\u001a\u00020\t¢\u0006\b\n\u0000\u001a\u0004\b(\u0010&R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b)\u0010*R\u0011\u0010+\u001a\u00020\t8F¢\u0006\u0006\u001a\u0004\b,\u0010&R\u0011\u0010-\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b.\u0010/R\u0011\u00100\u001a\u00020\t8F¢\u0006\u0006\u001a\u0004\b1\u0010&R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b2\u0010/R\u0011\u00103\u001a\u00020\t8F¢\u0006\u0006\u001a\u0004\b4\u0010&R\u001a\u00105\u001a\b\u0012\u0004\u0012\u0002060\u0010X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b7\u00108R\u0019\u00109\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010:0\u0010¢\u0006\b\n\u0000\u001a\u0004\b;\u00108R\u0011\u0010\b\u001a\u00020\t¢\u0006\b\n\u0000\u001a\u0004\b<\u0010&\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u008a\u0001"}, d2 = {"Landroidx/compose/ui/text/MultiParagraph;", "", "intrinsics", "Landroidx/compose/ui/text/MultiParagraphIntrinsics;", "maxLines", "", "ellipsis", "", ViewHierarchyConstants.DIMENSION_WIDTH_KEY, "", "(Landroidx/compose/ui/text/MultiParagraphIntrinsics;IZF)V", "annotatedString", "Landroidx/compose/ui/text/AnnotatedString;", AnalyticsEvents.PARAMETER_LIKE_VIEW_STYLE, "Landroidx/compose/ui/text/TextStyle;", "placeholders", "", "Landroidx/compose/ui/text/AnnotatedString$Range;", "Landroidx/compose/ui/text/Placeholder;", "density", "Landroidx/compose/ui/unit/Density;", "resourceLoader", "Landroidx/compose/ui/text/font/Font$ResourceLoader;", "(Landroidx/compose/ui/text/AnnotatedString;Landroidx/compose/ui/text/TextStyle;Ljava/util/List;IZFLandroidx/compose/ui/unit/Density;Landroidx/compose/ui/text/font/Font$ResourceLoader;)V", "fontFamilyResolver", "Landroidx/compose/ui/text/font/FontFamily$Resolver;", "(Landroidx/compose/ui/text/AnnotatedString;Landroidx/compose/ui/text/TextStyle;FLandroidx/compose/ui/unit/Density;Landroidx/compose/ui/text/font/FontFamily$Resolver;Ljava/util/List;IZ)V", "constraints", "Landroidx/compose/ui/unit/Constraints;", "(Landroidx/compose/ui/text/AnnotatedString;Landroidx/compose/ui/text/TextStyle;JLandroidx/compose/ui/unit/Density;Landroidx/compose/ui/text/font/FontFamily$Resolver;Ljava/util/List;IZLkotlin/jvm/internal/DefaultConstructorMarker;)V", "(Landroidx/compose/ui/text/MultiParagraphIntrinsics;JIZLkotlin/jvm/internal/DefaultConstructorMarker;)V", "getAnnotatedString", "()Landroidx/compose/ui/text/AnnotatedString;", "didExceedMaxLines", "getDidExceedMaxLines", "()Z", "firstBaseline", "getFirstBaseline", "()F", ViewHierarchyConstants.DIMENSION_HEIGHT_KEY, "getHeight", "getIntrinsics", "()Landroidx/compose/ui/text/MultiParagraphIntrinsics;", "lastBaseline", "getLastBaseline", "lineCount", "getLineCount", "()I", "maxIntrinsicWidth", "getMaxIntrinsicWidth", "getMaxLines", "minIntrinsicWidth", "getMinIntrinsicWidth", "paragraphInfoList", "Landroidx/compose/ui/text/ParagraphInfo;", "getParagraphInfoList$ui_text_release", "()Ljava/util/List;", "placeholderRects", "Landroidx/compose/ui/geometry/Rect;", "getPlaceholderRects", "getWidth", "fillBoundingBoxes", "", "range", "Landroidx/compose/ui/text/TextRange;", "array", "arrayStart", "fillBoundingBoxes-8ffj60Q", "(J[FI)[F", "getBidiRunDirection", "Landroidx/compose/ui/text/style/ResolvedTextDirection;", TypedValues.CycleType.S_WAVE_OFFSET, "getBoundingBox", "getCursorRect", "getHorizontalPosition", "usePrimaryDirection", "getLineBaseline", "lineIndex", "getLineBottom", "getLineEnd", "visibleEnd", "getLineForOffset", "getLineForVerticalPosition", "vertical", "getLineHeight", "getLineLeft", "getLineRight", "getLineStart", "getLineTop", "getLineWidth", "getOffsetForPosition", "position", "Landroidx/compose/ui/geometry/Offset;", "getOffsetForPosition-k-4lQ0M", "(J)I", "getParagraphDirection", "getPathForRange", "Landroidx/compose/ui/graphics/Path;", "start", "end", "getRangeForRect", "rect", "granularity", "Landroidx/compose/ui/text/TextGranularity;", "inclusionStrategy", "Landroidx/compose/ui/text/TextInclusionStrategy;", "getRangeForRect-8-6BmAI", "(Landroidx/compose/ui/geometry/Rect;ILandroidx/compose/ui/text/TextInclusionStrategy;)J", "getWordBoundary", "getWordBoundary--jx7JFs", "(I)J", "isLineEllipsized", "paint", "", "canvas", "Landroidx/compose/ui/graphics/Canvas;", "brush", "Landroidx/compose/ui/graphics/Brush;", "alpha", "shadow", "Landroidx/compose/ui/graphics/Shadow;", "decoration", "Landroidx/compose/ui/text/style/TextDecoration;", "drawStyle", "Landroidx/compose/ui/graphics/drawscope/DrawStyle;", "blendMode", "Landroidx/compose/ui/graphics/BlendMode;", "paint-hn5TExg", "(Landroidx/compose/ui/graphics/Canvas;Landroidx/compose/ui/graphics/Brush;FLandroidx/compose/ui/graphics/Shadow;Landroidx/compose/ui/text/style/TextDecoration;Landroidx/compose/ui/graphics/drawscope/DrawStyle;I)V", TypedValues.Custom.S_COLOR, "Landroidx/compose/ui/graphics/Color;", "paint-RPmYEkk", "(Landroidx/compose/ui/graphics/Canvas;JLandroidx/compose/ui/graphics/Shadow;Landroidx/compose/ui/text/style/TextDecoration;)V", "paint-LG529CI", "(Landroidx/compose/ui/graphics/Canvas;JLandroidx/compose/ui/graphics/Shadow;Landroidx/compose/ui/text/style/TextDecoration;Landroidx/compose/ui/graphics/drawscope/DrawStyle;I)V", "requireIndexInRange", "requireIndexInRangeInclusiveEnd", "requireLineIndexInRange", "ui-text_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class MultiParagraph {
    public static final int $stable = 8;
    private final boolean didExceedMaxLines;
    private final float height;
    private final MultiParagraphIntrinsics intrinsics;
    private final int lineCount;
    private final int maxLines;
    private final List<ParagraphInfo> paragraphInfoList;
    private final List<Rect> placeholderRects;
    private final float width;

    public MultiParagraph(AnnotatedString annotatedString, TextStyle textStyle, long j, Density density, FontFamily.Resolver resolver, List list, int i, boolean z, DefaultConstructorMarker defaultConstructorMarker) {
        this(annotatedString, textStyle, j, density, resolver, (List<AnnotatedString.Range<Placeholder>>) list, i, z);
    }

    public MultiParagraph(MultiParagraphIntrinsics multiParagraphIntrinsics, long j, int i, boolean z, DefaultConstructorMarker defaultConstructorMarker) {
        this(multiParagraphIntrinsics, j, i, z);
    }

    private MultiParagraph(MultiParagraphIntrinsics multiParagraphIntrinsics, long j, int i, boolean z) {
        boolean z2;
        int iM1765getMaxHeightimpl;
        this.intrinsics = multiParagraphIntrinsics;
        this.maxLines = i;
        if (Constraints.m1768getMinWidthimpl(j) != 0 || Constraints.m1767getMinHeightimpl(j) != 0) {
            throw new IllegalArgumentException("Setting Constraints.minWidth and Constraints.minHeight is not supported, these should be the default zero values instead.".toString());
        }
        ArrayList arrayList = new ArrayList();
        List<ParagraphIntrinsicInfo> infoList$ui_text_release = multiParagraphIntrinsics.getInfoList$ui_text_release();
        int size = infoList$ui_text_release.size();
        int i2 = 0;
        int i3 = 0;
        float f = 0.0f;
        int i4 = 0;
        while (true) {
            if (i4 >= size) {
                z2 = false;
                break;
            }
            ParagraphIntrinsicInfo paragraphIntrinsicInfo = infoList$ui_text_release.get(i4);
            ParagraphIntrinsics intrinsics = paragraphIntrinsicInfo.getIntrinsics();
            int iM1766getMaxWidthimpl = Constraints.m1766getMaxWidthimpl(j);
            if (Constraints.m1761getHasBoundedHeightimpl(j)) {
                iM1765getMaxHeightimpl = RangesKt.coerceAtLeast(Constraints.m1765getMaxHeightimpl(j) - ParagraphKt.ceilToInt(f), i2);
            } else {
                iM1765getMaxHeightimpl = Constraints.m1765getMaxHeightimpl(j);
            }
            Paragraph paragraphM1152Paragraph_EkL_Y = ParagraphKt.m1152Paragraph_EkL_Y(intrinsics, ConstraintsKt.Constraints$default(0, iM1766getMaxWidthimpl, 0, iM1765getMaxHeightimpl, 5, null), this.maxLines - i3, z);
            float height = f + paragraphM1152Paragraph_EkL_Y.getHeight();
            int lineCount = i3 + paragraphM1152Paragraph_EkL_Y.getLineCount();
            List<ParagraphIntrinsicInfo> list = infoList$ui_text_release;
            arrayList.add(new ParagraphInfo(paragraphM1152Paragraph_EkL_Y, paragraphIntrinsicInfo.getStartIndex(), paragraphIntrinsicInfo.getEndIndex(), i3, lineCount, f, height));
            if (paragraphM1152Paragraph_EkL_Y.getDidExceedMaxLines() || (lineCount == this.maxLines && i4 != CollectionsKt.getLastIndex(this.intrinsics.getInfoList$ui_text_release()))) {
                z2 = true;
                i3 = lineCount;
                f = height;
                break;
            } else {
                i4++;
                i3 = lineCount;
                f = height;
                i2 = 0;
                infoList$ui_text_release = list;
            }
        }
        this.height = f;
        this.lineCount = i3;
        this.didExceedMaxLines = z2;
        this.paragraphInfoList = arrayList;
        this.width = Constraints.m1766getMaxWidthimpl(j);
        ArrayList arrayList2 = new ArrayList(arrayList.size());
        int size2 = arrayList.size();
        for (int i5 = 0; i5 < size2; i5++) {
            ParagraphInfo paragraphInfo = (ParagraphInfo) arrayList.get(i5);
            List<Rect> placeholderRects = paragraphInfo.getParagraph().getPlaceholderRects();
            ArrayList arrayList3 = new ArrayList(placeholderRects.size());
            int size3 = placeholderRects.size();
            for (int i6 = 0; i6 < size3; i6++) {
                ArrayList arrayList4 = arrayList3;
                Rect rect = placeholderRects.get(i6);
                arrayList4.add(rect != null ? paragraphInfo.toGlobal(rect) : null);
            }
            CollectionsKt.addAll(arrayList2, arrayList3);
        }
        ArrayList arrayListPlus = arrayList2;
        if (arrayListPlus.size() < this.intrinsics.getPlaceholders().size()) {
            ArrayList arrayList5 = arrayListPlus;
            int size4 = this.intrinsics.getPlaceholders().size() - arrayListPlus.size();
            ArrayList arrayList6 = new ArrayList(size4);
            for (int i7 = 0; i7 < size4; i7++) {
                arrayList6.add(null);
            }
            arrayListPlus = CollectionsKt.plus(arrayList5, arrayList6);
        }
        this.placeholderRects = arrayListPlus;
    }

    public MultiParagraph(MultiParagraphIntrinsics multiParagraphIntrinsics, long j, int i, boolean z, int i2, DefaultConstructorMarker defaultConstructorMarker) {
        this(multiParagraphIntrinsics, j, (i2 & 4) != 0 ? Integer.MAX_VALUE : i, (i2 & 8) != 0 ? false : z, null);
    }

    public final MultiParagraphIntrinsics getIntrinsics() {
        return this.intrinsics;
    }

    public final int getMaxLines() {
        return this.maxLines;
    }

    public MultiParagraph(MultiParagraphIntrinsics multiParagraphIntrinsics, int i, boolean z, float f, int i2, DefaultConstructorMarker defaultConstructorMarker) {
        this(multiParagraphIntrinsics, (i2 & 2) != 0 ? Integer.MAX_VALUE : i, (i2 & 4) != 0 ? false : z, f);
    }

    @Deprecated(message = "MultiParagraph that takes maximum allowed width is deprecated, pass constraints instead.", replaceWith = @ReplaceWith(expression = "MultiParagraph(intrinsics, Constraints(maxWidth = ceil(width).toInt()), maxLines, ellipsis)", imports = {"kotlin.math.ceil", "androidx.compose.ui.unit.Constraints"}))
    public MultiParagraph(MultiParagraphIntrinsics multiParagraphIntrinsics, int i, boolean z, float f) {
        this(multiParagraphIntrinsics, ConstraintsKt.Constraints$default(0, ParagraphKt.ceilToInt(f), 0, 0, 13, null), i, z, null);
    }

    public MultiParagraph(AnnotatedString annotatedString, TextStyle textStyle, List list, int i, boolean z, float f, Density density, Font.ResourceLoader resourceLoader, int i2, DefaultConstructorMarker defaultConstructorMarker) {
        this(annotatedString, textStyle, (List<AnnotatedString.Range<Placeholder>>) ((i2 & 4) != 0 ? CollectionsKt.emptyList() : list), (i2 & 8) != 0 ? Integer.MAX_VALUE : i, (i2 & 16) != 0 ? false : z, f, density, resourceLoader);
    }

    @Deprecated(message = "Font.ResourceLoader is deprecated, use fontFamilyResolver instead", replaceWith = @ReplaceWith(expression = "MultiParagraph(annotatedString, style, placeholders, maxLines, ellipsis, width, density, fontFamilyResolver)", imports = {}))
    public MultiParagraph(AnnotatedString annotatedString, TextStyle textStyle, List<AnnotatedString.Range<Placeholder>> list, int i, boolean z, float f, Density density, Font.ResourceLoader resourceLoader) {
        this(new MultiParagraphIntrinsics(annotatedString, textStyle, list, density, DelegatingFontLoaderForDeprecatedUsage_androidKt.createFontFamilyResolver(resourceLoader)), ConstraintsKt.Constraints$default(0, ParagraphKt.ceilToInt(f), 0, 0, 13, null), i, z, null);
    }

    public MultiParagraph(AnnotatedString annotatedString, TextStyle textStyle, float f, Density density, FontFamily.Resolver resolver, List list, int i, boolean z, int i2, DefaultConstructorMarker defaultConstructorMarker) {
        this(annotatedString, textStyle, f, density, resolver, (List<AnnotatedString.Range<Placeholder>>) ((i2 & 32) != 0 ? CollectionsKt.emptyList() : list), (i2 & 64) != 0 ? Integer.MAX_VALUE : i, (i2 & 128) != 0 ? false : z);
    }

    @Deprecated(message = "MultiParagraph that takes maximum allowed width is deprecated, pass constraints instead.", replaceWith = @ReplaceWith(expression = "MultiParagraph(annotatedString, style, Constraints(maxWidth = ceil(width).toInt()), density, fontFamilyResolver, placeholders, maxLines, ellipsis)", imports = {"kotlin.math.ceil", "androidx.compose.ui.unit.Constraints"}))
    public MultiParagraph(AnnotatedString annotatedString, TextStyle textStyle, float f, Density density, FontFamily.Resolver resolver, List<AnnotatedString.Range<Placeholder>> list, int i, boolean z) {
        this(new MultiParagraphIntrinsics(annotatedString, textStyle, list, density, resolver), ConstraintsKt.Constraints$default(0, ParagraphKt.ceilToInt(f), 0, 0, 13, null), i, z, null);
    }

    public MultiParagraph(AnnotatedString annotatedString, TextStyle textStyle, long j, Density density, FontFamily.Resolver resolver, List list, int i, boolean z, int i2, DefaultConstructorMarker defaultConstructorMarker) {
        this(annotatedString, textStyle, j, density, resolver, (i2 & 32) != 0 ? CollectionsKt.emptyList() : list, (i2 & 64) != 0 ? Integer.MAX_VALUE : i, (i2 & 128) != 0 ? false : z, null);
    }

    private MultiParagraph(AnnotatedString annotatedString, TextStyle textStyle, long j, Density density, FontFamily.Resolver resolver, List<AnnotatedString.Range<Placeholder>> list, int i, boolean z) {
        this(new MultiParagraphIntrinsics(annotatedString, textStyle, list, density, resolver), j, i, z, null);
    }

    private final AnnotatedString getAnnotatedString() {
        return this.intrinsics.getAnnotatedString();
    }

    public final float getMinIntrinsicWidth() {
        return this.intrinsics.getMinIntrinsicWidth();
    }

    public final float getMaxIntrinsicWidth() {
        return this.intrinsics.getMaxIntrinsicWidth();
    }

    public final boolean getDidExceedMaxLines() {
        return this.didExceedMaxLines;
    }

    public final float getWidth() {
        return this.width;
    }

    public final float getHeight() {
        return this.height;
    }

    public final float getFirstBaseline() {
        if (this.paragraphInfoList.isEmpty()) {
            return 0.0f;
        }
        return this.paragraphInfoList.get(0).getParagraph().getFirstBaseline();
    }

    public final float getLastBaseline() {
        if (this.paragraphInfoList.isEmpty()) {
            return 0.0f;
        }
        ParagraphInfo paragraphInfo = (ParagraphInfo) CollectionsKt.last(this.paragraphInfoList);
        return paragraphInfo.toGlobalYPosition(paragraphInfo.getParagraph().getLastBaseline());
    }

    public final int getLineCount() {
        return this.lineCount;
    }

    public final List<Rect> getPlaceholderRects() {
        return this.placeholderRects;
    }

    public final List<ParagraphInfo> getParagraphInfoList$ui_text_release() {
        return this.paragraphInfoList;
    }

    public static void m1129paintRPmYEkk$default(MultiParagraph multiParagraph, Canvas canvas, long j, Shadow shadow, TextDecoration textDecoration, int i, Object obj) {
        if ((i & 2) != 0) {
            j = Color.Companion.getUnspecified-0d7_KjU();
        }
        multiParagraph.m1136paintRPmYEkk(canvas, j, (i & 4) != 0 ? null : shadow, (i & 8) != 0 ? null : textDecoration);
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Use the new paint function that takes canvas as the only required parameter.")
    public final void m1136paintRPmYEkk(Canvas canvas, long color, Shadow shadow, TextDecoration decoration) {
        canvas.save();
        List<ParagraphInfo> list = this.paragraphInfoList;
        int size = list.size();
        for (int i = 0; i < size; i++) {
            ParagraphInfo paragraphInfo = list.get(i);
            paragraphInfo.getParagraph().mo1103paintRPmYEkk(canvas, color, shadow, decoration);
            canvas.translate(0.0f, paragraphInfo.getParagraph().getHeight());
        }
        canvas.restore();
    }

    public final void m1135paintLG529CI(Canvas canvas, long color, Shadow shadow, TextDecoration decoration, DrawStyle drawStyle, int blendMode) {
        canvas.save();
        List<ParagraphInfo> list = this.paragraphInfoList;
        int size = list.size();
        for (int i = 0; i < size; i++) {
            ParagraphInfo paragraphInfo = list.get(i);
            paragraphInfo.getParagraph().mo1102paintLG529CI(canvas, color, shadow, decoration, drawStyle, blendMode);
            canvas.translate(0.0f, paragraphInfo.getParagraph().getHeight());
        }
        canvas.restore();
    }

    public final void m1137painthn5TExg(Canvas canvas, Brush brush, float alpha, Shadow shadow, TextDecoration decoration, DrawStyle drawStyle, int blendMode) {
        AndroidMultiParagraphDraw_androidKt.m1546drawMultiParagraph7AXcY_I(this, canvas, brush, alpha, shadow, decoration, drawStyle, blendMode);
    }

    public final Path getPathForRange(final int start, final int end) {
        if (start >= 0 && start <= end && end <= getAnnotatedString().getText().length()) {
            if (start == end) {
                return AndroidPath_androidKt.Path();
            }
            final Path Path = AndroidPath_androidKt.Path();
            MultiParagraphKt.m1140findParagraphsByRangeSbBc2M(this.paragraphInfoList, TextRangeKt.TextRange(start, end), new Function1<ParagraphInfo, Unit>() {
                {
                    super(1);
                }

                public Object invoke(Object obj) {
                    invoke((ParagraphInfo) obj);
                    return Unit.INSTANCE;
                }

                public final void invoke(ParagraphInfo paragraphInfo) {
                    Path.-CC.addPath-Uv8p0NA$default(Path, paragraphInfo.toGlobal(paragraphInfo.getParagraph().getPathForRange(paragraphInfo.toLocalIndex(start), paragraphInfo.toLocalIndex(end))), 0L, 2, (Object) null);
                }
            });
            return Path;
        }
        throw new IllegalArgumentException(("Start(" + start + ") or End(" + end + ") is out of range [0.." + getAnnotatedString().getText().length() + "), or start > end!").toString());
    }

    public final int getLineForVerticalPosition(float vertical) {
        ParagraphInfo paragraphInfo = this.paragraphInfoList.get(MultiParagraphKt.findParagraphByY(this.paragraphInfoList, vertical));
        if (paragraphInfo.getLength() == 0) {
            return paragraphInfo.getStartLineIndex();
        }
        return paragraphInfo.toGlobalLineIndex(paragraphInfo.getParagraph().getLineForVerticalPosition(paragraphInfo.toLocalYPosition(vertical)));
    }

    public final int m1132getOffsetForPositionk4lQ0M(long position) {
        ParagraphInfo paragraphInfo = this.paragraphInfoList.get(MultiParagraphKt.findParagraphByY(this.paragraphInfoList, Offset.getY-impl(position)));
        if (paragraphInfo.getLength() == 0) {
            return paragraphInfo.getStartIndex();
        }
        return paragraphInfo.toGlobalIndex(paragraphInfo.getParagraph().mo1099getOffsetForPositionk4lQ0M(paragraphInfo.m1149toLocalMKHz9U(position)));
    }

    public final long m1133getRangeForRect86BmAI(Rect rect, int granularity, TextInclusionStrategy inclusionStrategy) {
        int iFindParagraphByY = MultiParagraphKt.findParagraphByY(this.paragraphInfoList, rect.getTop());
        if (this.paragraphInfoList.get(iFindParagraphByY).getBottom() >= rect.getBottom() || iFindParagraphByY == CollectionsKt.getLastIndex(this.paragraphInfoList)) {
            ParagraphInfo paragraphInfo = this.paragraphInfoList.get(iFindParagraphByY);
            return ParagraphInfo.m1147toGlobalxdX6G0$default(paragraphInfo, paragraphInfo.getParagraph().mo1100getRangeForRect86BmAI(paragraphInfo.toLocal(rect), granularity, inclusionStrategy), false, 1, null);
        }
        int iFindParagraphByY2 = MultiParagraphKt.findParagraphByY(this.paragraphInfoList, rect.getBottom());
        long jM1291getZerod9O1mEE = TextRange.INSTANCE.m1291getZerod9O1mEE();
        while (TextRange.m1279equalsimpl0(jM1291getZerod9O1mEE, TextRange.INSTANCE.m1291getZerod9O1mEE()) && iFindParagraphByY <= iFindParagraphByY2) {
            ParagraphInfo paragraphInfo2 = this.paragraphInfoList.get(iFindParagraphByY);
            jM1291getZerod9O1mEE = ParagraphInfo.m1147toGlobalxdX6G0$default(paragraphInfo2, paragraphInfo2.getParagraph().mo1100getRangeForRect86BmAI(paragraphInfo2.toLocal(rect), granularity, inclusionStrategy), false, 1, null);
            iFindParagraphByY++;
        }
        if (TextRange.m1279equalsimpl0(jM1291getZerod9O1mEE, TextRange.INSTANCE.m1291getZerod9O1mEE())) {
            return TextRange.INSTANCE.m1291getZerod9O1mEE();
        }
        long jM1291getZerod9O1mEE2 = TextRange.INSTANCE.m1291getZerod9O1mEE();
        while (TextRange.m1279equalsimpl0(jM1291getZerod9O1mEE2, TextRange.INSTANCE.m1291getZerod9O1mEE()) && iFindParagraphByY <= iFindParagraphByY2) {
            ParagraphInfo paragraphInfo3 = this.paragraphInfoList.get(iFindParagraphByY2);
            jM1291getZerod9O1mEE2 = ParagraphInfo.m1147toGlobalxdX6G0$default(paragraphInfo3, paragraphInfo3.getParagraph().mo1100getRangeForRect86BmAI(paragraphInfo3.toLocal(rect), granularity, inclusionStrategy), false, 1, null);
            iFindParagraphByY2--;
        }
        return TextRange.m1279equalsimpl0(jM1291getZerod9O1mEE2, TextRange.INSTANCE.m1291getZerod9O1mEE()) ? jM1291getZerod9O1mEE : TextRangeKt.TextRange(TextRange.m1286getStartimpl(jM1291getZerod9O1mEE), TextRange.m1281getEndimpl(jM1291getZerod9O1mEE2));
    }

    public final Rect getBoundingBox(int offset) {
        requireIndexInRange(offset);
        ParagraphInfo paragraphInfo = this.paragraphInfoList.get(MultiParagraphKt.findParagraphByIndex(this.paragraphInfoList, offset));
        return paragraphInfo.toGlobal(paragraphInfo.getParagraph().getBoundingBox(paragraphInfo.toLocalIndex(offset)));
    }

    public final float[] m1131fillBoundingBoxes8ffj60Q(final long range, final float[] array, int arrayStart) {
        requireIndexInRange(TextRange.m1284getMinimpl(range));
        requireIndexInRangeInclusiveEnd(TextRange.m1283getMaximpl(range));
        final Ref.IntRef intRef = new Ref.IntRef();
        intRef.element = arrayStart;
        final Ref.FloatRef floatRef = new Ref.FloatRef();
        MultiParagraphKt.m1140findParagraphsByRangeSbBc2M(this.paragraphInfoList, range, new Function1<ParagraphInfo, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((ParagraphInfo) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(ParagraphInfo paragraphInfo) {
                long j = range;
                float[] fArr = array;
                Ref.IntRef intRef2 = intRef;
                Ref.FloatRef floatRef2 = floatRef;
                long jTextRange = TextRangeKt.TextRange(paragraphInfo.toLocalIndex(paragraphInfo.getStartIndex() > TextRange.m1284getMinimpl(j) ? paragraphInfo.getStartIndex() : TextRange.m1284getMinimpl(j)), paragraphInfo.toLocalIndex(paragraphInfo.getEndIndex() < TextRange.m1283getMaximpl(j) ? paragraphInfo.getEndIndex() : TextRange.m1283getMaximpl(j)));
                paragraphInfo.getParagraph().mo1097fillBoundingBoxes8ffj60Q(jTextRange, fArr, intRef2.element);
                int iM1282getLengthimpl = intRef2.element + (TextRange.m1282getLengthimpl(jTextRange) * 4);
                for (int i = intRef2.element; i < iM1282getLengthimpl; i += 4) {
                    int i2 = i + 1;
                    fArr[i2] = fArr[i2] + floatRef2.element;
                    int i3 = i + 3;
                    fArr[i3] = fArr[i3] + floatRef2.element;
                }
                intRef2.element = iM1282getLengthimpl;
                floatRef2.element += paragraphInfo.getParagraph().getHeight();
            }
        });
        return array;
    }

    public final float getHorizontalPosition(int offset, boolean usePrimaryDirection) {
        int iFindParagraphByIndex;
        requireIndexInRangeInclusiveEnd(offset);
        if (offset == getAnnotatedString().length()) {
            iFindParagraphByIndex = CollectionsKt.getLastIndex(this.paragraphInfoList);
        } else {
            iFindParagraphByIndex = MultiParagraphKt.findParagraphByIndex(this.paragraphInfoList, offset);
        }
        ParagraphInfo paragraphInfo = this.paragraphInfoList.get(iFindParagraphByIndex);
        return paragraphInfo.getParagraph().getHorizontalPosition(paragraphInfo.toLocalIndex(offset), usePrimaryDirection);
    }

    public final ResolvedTextDirection getParagraphDirection(int offset) {
        int iFindParagraphByIndex;
        requireIndexInRangeInclusiveEnd(offset);
        if (offset == getAnnotatedString().length()) {
            iFindParagraphByIndex = CollectionsKt.getLastIndex(this.paragraphInfoList);
        } else {
            iFindParagraphByIndex = MultiParagraphKt.findParagraphByIndex(this.paragraphInfoList, offset);
        }
        ParagraphInfo paragraphInfo = this.paragraphInfoList.get(iFindParagraphByIndex);
        return paragraphInfo.getParagraph().getParagraphDirection(paragraphInfo.toLocalIndex(offset));
    }

    public final ResolvedTextDirection getBidiRunDirection(int offset) {
        int iFindParagraphByIndex;
        requireIndexInRangeInclusiveEnd(offset);
        if (offset == getAnnotatedString().length()) {
            iFindParagraphByIndex = CollectionsKt.getLastIndex(this.paragraphInfoList);
        } else {
            iFindParagraphByIndex = MultiParagraphKt.findParagraphByIndex(this.paragraphInfoList, offset);
        }
        ParagraphInfo paragraphInfo = this.paragraphInfoList.get(iFindParagraphByIndex);
        return paragraphInfo.getParagraph().getBidiRunDirection(paragraphInfo.toLocalIndex(offset));
    }

    public final long m1134getWordBoundaryjx7JFs(int offset) {
        int iFindParagraphByIndex;
        requireIndexInRangeInclusiveEnd(offset);
        if (offset == getAnnotatedString().length()) {
            iFindParagraphByIndex = CollectionsKt.getLastIndex(this.paragraphInfoList);
        } else {
            iFindParagraphByIndex = MultiParagraphKt.findParagraphByIndex(this.paragraphInfoList, offset);
        }
        ParagraphInfo paragraphInfo = this.paragraphInfoList.get(iFindParagraphByIndex);
        return paragraphInfo.m1148toGlobalxdX6G0(paragraphInfo.getParagraph().mo1101getWordBoundaryjx7JFs(paragraphInfo.toLocalIndex(offset)), false);
    }

    public final Rect getCursorRect(int offset) {
        int iFindParagraphByIndex;
        requireIndexInRangeInclusiveEnd(offset);
        if (offset == getAnnotatedString().length()) {
            iFindParagraphByIndex = CollectionsKt.getLastIndex(this.paragraphInfoList);
        } else {
            iFindParagraphByIndex = MultiParagraphKt.findParagraphByIndex(this.paragraphInfoList, offset);
        }
        ParagraphInfo paragraphInfo = this.paragraphInfoList.get(iFindParagraphByIndex);
        return paragraphInfo.toGlobal(paragraphInfo.getParagraph().getCursorRect(paragraphInfo.toLocalIndex(offset)));
    }

    public final int getLineForOffset(int offset) {
        int iFindParagraphByIndex;
        if (offset >= getAnnotatedString().length()) {
            iFindParagraphByIndex = CollectionsKt.getLastIndex(this.paragraphInfoList);
        } else {
            iFindParagraphByIndex = offset < 0 ? 0 : MultiParagraphKt.findParagraphByIndex(this.paragraphInfoList, offset);
        }
        ParagraphInfo paragraphInfo = this.paragraphInfoList.get(iFindParagraphByIndex);
        return paragraphInfo.toGlobalLineIndex(paragraphInfo.getParagraph().getLineForOffset(paragraphInfo.toLocalIndex(offset)));
    }

    public final float getLineLeft(int lineIndex) {
        requireLineIndexInRange(lineIndex);
        ParagraphInfo paragraphInfo = this.paragraphInfoList.get(MultiParagraphKt.findParagraphByLineIndex(this.paragraphInfoList, lineIndex));
        return paragraphInfo.getParagraph().getLineLeft(paragraphInfo.toLocalLineIndex(lineIndex));
    }

    public final float getLineRight(int lineIndex) {
        requireLineIndexInRange(lineIndex);
        ParagraphInfo paragraphInfo = this.paragraphInfoList.get(MultiParagraphKt.findParagraphByLineIndex(this.paragraphInfoList, lineIndex));
        return paragraphInfo.getParagraph().getLineRight(paragraphInfo.toLocalLineIndex(lineIndex));
    }

    public final float getLineTop(int lineIndex) {
        requireLineIndexInRange(lineIndex);
        ParagraphInfo paragraphInfo = this.paragraphInfoList.get(MultiParagraphKt.findParagraphByLineIndex(this.paragraphInfoList, lineIndex));
        return paragraphInfo.toGlobalYPosition(paragraphInfo.getParagraph().getLineTop(paragraphInfo.toLocalLineIndex(lineIndex)));
    }

    public final float getLineBaseline(int lineIndex) {
        requireLineIndexInRange(lineIndex);
        ParagraphInfo paragraphInfo = this.paragraphInfoList.get(MultiParagraphKt.findParagraphByLineIndex(this.paragraphInfoList, lineIndex));
        return paragraphInfo.toGlobalYPosition(paragraphInfo.getParagraph().getLineBaseline(paragraphInfo.toLocalLineIndex(lineIndex)));
    }

    public final float getLineBottom(int lineIndex) {
        requireLineIndexInRange(lineIndex);
        ParagraphInfo paragraphInfo = this.paragraphInfoList.get(MultiParagraphKt.findParagraphByLineIndex(this.paragraphInfoList, lineIndex));
        return paragraphInfo.toGlobalYPosition(paragraphInfo.getParagraph().getLineBottom(paragraphInfo.toLocalLineIndex(lineIndex)));
    }

    public final float getLineHeight(int lineIndex) {
        requireLineIndexInRange(lineIndex);
        ParagraphInfo paragraphInfo = this.paragraphInfoList.get(MultiParagraphKt.findParagraphByLineIndex(this.paragraphInfoList, lineIndex));
        return paragraphInfo.getParagraph().getLineHeight(paragraphInfo.toLocalLineIndex(lineIndex));
    }

    public final float getLineWidth(int lineIndex) {
        requireLineIndexInRange(lineIndex);
        ParagraphInfo paragraphInfo = this.paragraphInfoList.get(MultiParagraphKt.findParagraphByLineIndex(this.paragraphInfoList, lineIndex));
        return paragraphInfo.getParagraph().getLineWidth(paragraphInfo.toLocalLineIndex(lineIndex));
    }

    public final int getLineStart(int lineIndex) {
        requireLineIndexInRange(lineIndex);
        ParagraphInfo paragraphInfo = this.paragraphInfoList.get(MultiParagraphKt.findParagraphByLineIndex(this.paragraphInfoList, lineIndex));
        return paragraphInfo.toGlobalIndex(paragraphInfo.getParagraph().getLineStart(paragraphInfo.toLocalLineIndex(lineIndex)));
    }

    public static int getLineEnd$default(MultiParagraph multiParagraph, int i, boolean z, int i2, Object obj) {
        if ((i2 & 2) != 0) {
            z = false;
        }
        return multiParagraph.getLineEnd(i, z);
    }

    public final int getLineEnd(int lineIndex, boolean visibleEnd) {
        requireLineIndexInRange(lineIndex);
        ParagraphInfo paragraphInfo = this.paragraphInfoList.get(MultiParagraphKt.findParagraphByLineIndex(this.paragraphInfoList, lineIndex));
        return paragraphInfo.toGlobalIndex(paragraphInfo.getParagraph().getLineEnd(paragraphInfo.toLocalLineIndex(lineIndex), visibleEnd));
    }

    public final boolean isLineEllipsized(int lineIndex) {
        requireLineIndexInRange(lineIndex);
        return this.paragraphInfoList.get(MultiParagraphKt.findParagraphByLineIndex(this.paragraphInfoList, lineIndex)).getParagraph().isLineEllipsized(lineIndex);
    }

    private final void requireIndexInRange(int offset) {
        if (offset < 0 || offset >= getAnnotatedString().getText().length()) {
            throw new IllegalArgumentException(("offset(" + offset + ") is out of bounds [0, " + getAnnotatedString().length() + ')').toString());
        }
    }

    private final void requireIndexInRangeInclusiveEnd(int offset) {
        if (offset < 0 || offset > getAnnotatedString().getText().length()) {
            throw new IllegalArgumentException(("offset(" + offset + ") is out of bounds [0, " + getAnnotatedString().length() + ']').toString());
        }
    }

    private final void requireLineIndexInRange(int lineIndex) {
        if (lineIndex < 0 || lineIndex >= this.lineCount) {
            throw new IllegalArgumentException(("lineIndex(" + lineIndex + ") is out of bounds [0, " + this.lineCount + ')').toString());
        }
    }
}
