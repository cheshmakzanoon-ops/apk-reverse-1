package androidx.compose.p000ui.text;

import androidx.compose.p000ui.text.font.FontFamily;
import androidx.compose.p000ui.text.font.FontStyle;
import androidx.compose.p000ui.text.font.FontSynthesis;
import androidx.compose.p000ui.text.font.FontWeight;
import androidx.compose.p000ui.text.intl.Locale;
import androidx.compose.p000ui.text.intl.LocaleList;
import androidx.compose.p000ui.text.style.BaselineShift;
import androidx.compose.p000ui.text.style.LineHeightStyle;
import androidx.compose.p000ui.text.style.TextAlign;
import androidx.compose.p000ui.text.style.TextDecoration;
import androidx.compose.p000ui.text.style.TextDirection;
import androidx.compose.p000ui.text.style.TextGeometricTransform;
import androidx.compose.p000ui.text.style.TextIndent;
import androidx.compose.p000ui.text.style.TextMotion;
import androidx.compose.p000ui.unit.TextUnit;
import androidx.compose.p000ui.unit.TextUnitKt;
import androidx.compose.p000ui.unit.TextUnitType;
import androidx.compose.runtime.saveable.Saver;
import androidx.compose.runtime.saveable.SaverKt;
import androidx.compose.runtime.saveable.SaverScope;
import androidx.compose.ui.geometry.Offset;
import androidx.compose.ui.geometry.OffsetKt;
import androidx.compose.ui.graphics.Color;
import androidx.compose.ui.graphics.ColorKt;
import androidx.compose.ui.graphics.Shadow;
import androidx.compose.ui.graphics.drawscope.DrawStyle;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.exifinterface.media.ExifInterface;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000\u0086\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0003\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\b\u001ay\u0010Q\u001a\u000e\u0012\u0004\u0012\u0002HR\u0012\u0004\u0012\u0002HS0\u0011\"\u0004\b\u0000\u0010R\"\b\b\u0001\u0010S*\u00020\u00032.\u0010T\u001a*\u0012\u0004\u0012\u00020V\u0012\u0013\u0012\u0011HR¢\u0006\f\bW\u0012\b\bX\u0012\u0004\b\b(Y\u0012\u0006\u0012\u0004\u0018\u0001HS0U¢\u0006\u0002\bZ2#\u0010[\u001a\u001f\u0012\u0013\u0012\u0011HS¢\u0006\f\bW\u0012\b\bX\u0012\u0004\b\b(Y\u0012\u0006\u0012\u0004\u0018\u0001HR0\\H\u0002\u001aL\u0010[\u001a\u0004\u0018\u0001H]\"\u0014\b\u0000\u0010^*\u000e\u0012\u0004\u0012\u0002HR\u0012\u0004\u0012\u0002HS0\u0001\"\u0004\b\u0001\u0010R\"\u0004\b\u0002\u0010S\"\u0006\b\u0003\u0010]\u0018\u00012\b\u0010Y\u001a\u0004\u0018\u0001HS2\u0006\u0010_\u001a\u0002H^H\u0080\b¢\u0006\u0002\u0010`\u001a\"\u0010[\u001a\u0004\u0018\u0001H]\"\u0006\b\u0000\u0010]\u0018\u00012\b\u0010Y\u001a\u0004\u0018\u00010\u0003H\u0080\b¢\u0006\u0002\u0010a\u001aI\u0010T\u001a\u00020\u0003\"\u0014\b\u0000\u0010^*\u000e\u0012\u0004\u0012\u0002HR\u0012\u0004\u0012\u0002HS0\u0001\"\u0004\b\u0001\u0010R\"\u0004\b\u0002\u0010S2\b\u0010Y\u001a\u0004\u0018\u0001HR2\u0006\u0010_\u001a\u0002H^2\u0006\u0010b\u001a\u00020VH\u0000¢\u0006\u0002\u0010c\u001a\u001f\u0010T\u001a\u0004\u0018\u0001H^\"\u0004\b\u0000\u0010^2\b\u0010Y\u001a\u0004\u0018\u0001H^H\u0000¢\u0006\u0002\u0010a\" \u0010\u0000\u001a\u000e\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u00030\u0001X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0004\u0010\u0005\"(\u0010\u0006\u001a\u001c\u0012\u0012\u0012\u0010\u0012\f\u0012\n\u0012\u0006\b\u0001\u0012\u00020\u00030\b0\u0007\u0012\u0004\u0012\u00020\u00030\u0001X\u0082\u0004¢\u0006\u0002\n\u0000\"(\u0010\t\u001a\u0016\u0012\f\u0012\n\u0012\u0006\b\u0001\u0012\u00020\u00030\b\u0012\u0004\u0012\u00020\u00030\u0001X\u0082\u0004¢\u0006\b\n\u0000\u0012\u0004\b\n\u0010\u000b\"\u001a\u0010\f\u001a\u000e\u0012\u0004\u0012\u00020\r\u0012\u0004\u0012\u00020\u00030\u0001X\u0082\u0004¢\u0006\u0002\n\u0000\"\u001a\u0010\u000e\u001a\u000e\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00020\u00030\u0001X\u0082\u0004¢\u0006\u0002\n\u0000\"\u001a\u0010\u0010\u001a\u000e\u0012\u0004\u0012\u00020\u0012\u0012\u0004\u0012\u00020\u00030\u0011X\u0082\u0004¢\u0006\u0002\n\u0000\"\u001a\u0010\u0013\u001a\u000e\u0012\u0004\u0012\u00020\u0014\u0012\u0004\u0012\u00020\u00030\u0001X\u0082\u0004¢\u0006\u0002\n\u0000\"\u001a\u0010\u0015\u001a\u000e\u0012\u0004\u0012\u00020\u0016\u0012\u0004\u0012\u00020\u00030\u0001X\u0082\u0004¢\u0006\u0002\n\u0000\"\u001a\u0010\u0017\u001a\u000e\u0012\u0004\u0012\u00020\u0018\u0012\u0004\u0012\u00020\u00030\u0001X\u0082\u0004¢\u0006\u0002\n\u0000\"\u001a\u0010\u0019\u001a\u000e\u0012\u0004\u0012\u00020\u001a\u0012\u0004\u0012\u00020\u00030\u0001X\u0082\u0004¢\u0006\u0002\n\u0000\"\u001a\u0010\u001b\u001a\u000e\u0012\u0004\u0012\u00020\u001c\u0012\u0004\u0012\u00020\u00030\u0011X\u0082\u0004¢\u0006\u0002\n\u0000\" \u0010\u001d\u001a\u000e\u0012\u0004\u0012\u00020\u001e\u0012\u0004\u0012\u00020\u00030\u0001X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001f\u0010\u0005\"\u001a\u0010 \u001a\u000e\u0012\u0004\u0012\u00020!\u0012\u0004\u0012\u00020\u00030\u0001X\u0082\u0004¢\u0006\u0002\n\u0000\" \u0010\"\u001a\u000e\u0012\u0004\u0012\u00020#\u0012\u0004\u0012\u00020\u00030\u0001X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b$\u0010\u0005\"\u001a\u0010%\u001a\u000e\u0012\u0004\u0012\u00020&\u0012\u0004\u0012\u00020\u00030\u0001X\u0082\u0004¢\u0006\u0002\n\u0000\"\u001a\u0010'\u001a\u000e\u0012\u0004\u0012\u00020(\u0012\u0004\u0012\u00020\u00030\u0001X\u0082\u0004¢\u0006\u0002\n\u0000\"\u001a\u0010)\u001a\u000e\u0012\u0004\u0012\u00020*\u0012\u0004\u0012\u00020\u00030\u0001X\u0082\u0004¢\u0006\u0002\n\u0000\" \u0010+\u001a\u000e\u0012\u0004\u0012\u00020,\u0012\u0004\u0012\u00020\u00030\u0001X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b-\u0010\u0005\"\u001a\u0010.\u001a\u000e\u0012\u0004\u0012\u00020/\u0012\u0004\u0012\u00020\u00030\u0001X\u0082\u0004¢\u0006\u0002\n\u0000\"\u001a\u00100\u001a\u000e\u0012\u0004\u0012\u000201\u0012\u0004\u0012\u00020\u00030\u0011X\u0082\u0004¢\u0006\u0002\n\u0000\" \u00102\u001a\u000e\u0012\u0004\u0012\u000203\u0012\u0004\u0012\u00020\u00030\u0001X\u0082\u0004¢\u0006\b\n\u0000\u0012\u0004\b4\u0010\u000b\"\u001a\u00105\u001a\u000e\u0012\u0004\u0012\u000206\u0012\u0004\u0012\u00020\u00030\u0001X\u0082\u0004¢\u0006\u0002\n\u0000\"$\u00107\u001a\u000e\u0012\u0004\u0012\u00020\u001c\u0012\u0004\u0012\u00020\u00030\u0001*\u0002088@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b9\u0010:\"$\u00107\u001a\u000e\u0012\u0004\u0012\u00020\u0012\u0012\u0004\u0012\u00020\u00030\u0001*\u00020;8@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b9\u0010<\"$\u00107\u001a\u000e\u0012\u0004\u0012\u00020!\u0012\u0004\u0012\u00020\u00030\u0001*\u00020=8@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b9\u0010>\"$\u00107\u001a\u000e\u0012\u0004\u0012\u00020/\u0012\u0004\u0012\u00020\u00030\u0001*\u00020?8@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b9\u0010@\"$\u00107\u001a\u000e\u0012\u0004\u0012\u00020\u0014\u0012\u0004\u0012\u00020\u00030\u0001*\u00020A8@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b9\u0010B\"$\u00107\u001a\u000e\u0012\u0004\u0012\u00020\u001a\u0012\u0004\u0012\u00020\u00030\u0001*\u00020C8@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b9\u0010D\"$\u00107\u001a\u000e\u0012\u0004\u0012\u00020\u0018\u0012\u0004\u0012\u00020\u00030\u0001*\u00020E8@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b9\u0010F\"$\u00107\u001a\u000e\u0012\u0004\u0012\u00020\r\u0012\u0004\u0012\u00020\u00030\u0001*\u00020G8@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b9\u0010H\"$\u00107\u001a\u000e\u0012\u0004\u0012\u00020&\u0012\u0004\u0012\u00020\u00030\u0001*\u00020I8@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b9\u0010J\"$\u00107\u001a\u000e\u0012\u0004\u0012\u00020(\u0012\u0004\u0012\u00020\u00030\u0001*\u00020K8@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b9\u0010L\"$\u00107\u001a\u000e\u0012\u0004\u0012\u00020*\u0012\u0004\u0012\u00020\u00030\u0001*\u00020M8@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b9\u0010N\"$\u00107\u001a\u000e\u0012\u0004\u0012\u000201\u0012\u0004\u0012\u00020\u00030\u0001*\u00020O8@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b9\u0010P¨\u0006d"}, d2 = {"AnnotatedStringSaver", "Landroidx/compose/runtime/saveable/Saver;", "Landroidx/compose/ui/text/AnnotatedString;", "", "getAnnotatedStringSaver", "()Landroidx/compose/runtime/saveable/Saver;", "AnnotationRangeListSaver", "", "Landroidx/compose/ui/text/AnnotatedString$Range;", "AnnotationRangeSaver", "getAnnotationRangeSaver$annotations", "()V", "BaselineShiftSaver", "Landroidx/compose/ui/text/style/BaselineShift;", "ClickableSaver", "Landroidx/compose/ui/text/LinkAnnotation$Clickable;", "ColorSaver", "Landroidx/compose/ui/text/NonNullValueClassSaver;", "Landroidx/compose/ui/graphics/Color;", "FontWeightSaver", "Landroidx/compose/ui/text/font/FontWeight;", "LinkSaver", "Landroidx/compose/ui/text/LinkAnnotation$Url;", "LocaleListSaver", "Landroidx/compose/ui/text/intl/LocaleList;", "LocaleSaver", "Landroidx/compose/ui/text/intl/Locale;", "OffsetSaver", "Landroidx/compose/ui/geometry/Offset;", "ParagraphStyleSaver", "Landroidx/compose/ui/text/ParagraphStyle;", "getParagraphStyleSaver", "ShadowSaver", "Landroidx/compose/ui/graphics/Shadow;", "SpanStyleSaver", "Landroidx/compose/ui/text/SpanStyle;", "getSpanStyleSaver", "TextDecorationSaver", "Landroidx/compose/ui/text/style/TextDecoration;", "TextGeometricTransformSaver", "Landroidx/compose/ui/text/style/TextGeometricTransform;", "TextIndentSaver", "Landroidx/compose/ui/text/style/TextIndent;", "TextLinkStylesSaver", "Landroidx/compose/ui/text/TextLinkStyles;", "getTextLinkStylesSaver", "TextRangeSaver", "Landroidx/compose/ui/text/TextRange;", "TextUnitSaver", "Landroidx/compose/ui/unit/TextUnit;", "UrlAnnotationSaver", "Landroidx/compose/ui/text/UrlAnnotation;", "getUrlAnnotationSaver$annotations", "VerbatimTtsAnnotationSaver", "Landroidx/compose/ui/text/VerbatimTtsAnnotation;", "Saver", "Landroidx/compose/ui/geometry/Offset$Companion;", "getSaver", "(Landroidx/compose/ui/geometry/Offset$Companion;)Landroidx/compose/runtime/saveable/Saver;", "Landroidx/compose/ui/graphics/Color$Companion;", "(Landroidx/compose/ui/graphics/Color$Companion;)Landroidx/compose/runtime/saveable/Saver;", "Landroidx/compose/ui/graphics/Shadow$Companion;", "(Landroidx/compose/ui/graphics/Shadow$Companion;)Landroidx/compose/runtime/saveable/Saver;", "Landroidx/compose/ui/text/TextRange$Companion;", "(Landroidx/compose/ui/text/TextRange$Companion;)Landroidx/compose/runtime/saveable/Saver;", "Landroidx/compose/ui/text/font/FontWeight$Companion;", "(Landroidx/compose/ui/text/font/FontWeight$Companion;)Landroidx/compose/runtime/saveable/Saver;", "Landroidx/compose/ui/text/intl/Locale$Companion;", "(Landroidx/compose/ui/text/intl/Locale$Companion;)Landroidx/compose/runtime/saveable/Saver;", "Landroidx/compose/ui/text/intl/LocaleList$Companion;", "(Landroidx/compose/ui/text/intl/LocaleList$Companion;)Landroidx/compose/runtime/saveable/Saver;", "Landroidx/compose/ui/text/style/BaselineShift$Companion;", "(Landroidx/compose/ui/text/style/BaselineShift$Companion;)Landroidx/compose/runtime/saveable/Saver;", "Landroidx/compose/ui/text/style/TextDecoration$Companion;", "(Landroidx/compose/ui/text/style/TextDecoration$Companion;)Landroidx/compose/runtime/saveable/Saver;", "Landroidx/compose/ui/text/style/TextGeometricTransform$Companion;", "(Landroidx/compose/ui/text/style/TextGeometricTransform$Companion;)Landroidx/compose/runtime/saveable/Saver;", "Landroidx/compose/ui/text/style/TextIndent$Companion;", "(Landroidx/compose/ui/text/style/TextIndent$Companion;)Landroidx/compose/runtime/saveable/Saver;", "Landroidx/compose/ui/unit/TextUnit$Companion;", "(Landroidx/compose/ui/unit/TextUnit$Companion;)Landroidx/compose/runtime/saveable/Saver;", "NonNullValueClassSaver", "Original", "Saveable", "save", "Lkotlin/Function2;", "Landroidx/compose/runtime/saveable/SaverScope;", "Lkotlin/ParameterName;", "name", SDKConstants.PARAM_VALUE, "Lkotlin/ExtensionFunctionType;", "restore", "Lkotlin/Function1;", "Result", ExifInterface.GPS_DIRECTION_TRUE, "saver", "(Ljava/lang/Object;Landroidx/compose/runtime/saveable/Saver;)Ljava/lang/Object;", "(Ljava/lang/Object;)Ljava/lang/Object;", "scope", "(Ljava/lang/Object;Landroidx/compose/runtime/saveable/Saver;Landroidx/compose/runtime/saveable/SaverScope;)Ljava/lang/Object;", "ui-text_release"}, k = 2, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class SaversKt {
    private static final Saver<AnnotatedString, Object> AnnotatedStringSaver = SaverKt.Saver(new Function2<SaverScope, AnnotatedString, Object>() {
        public final Object invoke(SaverScope saverScope, AnnotatedString annotatedString) {
            return CollectionsKt.arrayListOf(new Object[]{SaversKt.save(annotatedString.getText()), SaversKt.save(annotatedString.getSpanStyles(), SaversKt.AnnotationRangeListSaver, saverScope), SaversKt.save(annotatedString.getParagraphStyles(), SaversKt.AnnotationRangeListSaver, saverScope), SaversKt.save(annotatedString.getAnnotations$ui_text_release(), SaversKt.AnnotationRangeListSaver, saverScope)});
        }
    }, new Function1<Object, AnnotatedString>() {
        public final AnnotatedString m1198invoke(Object obj) {
            List list;
            List list2;
            Intrinsics.checkNotNull(obj, "null cannot be cast to non-null type kotlin.collections.List<kotlin.Any?>");
            List list3 = (List) obj;
            Object obj2 = list3.get(1);
            Saver saver = SaversKt.AnnotationRangeListSaver;
            List list4 = null;
            List list5 = ((!Intrinsics.areEqual(obj2, false) || (saver instanceof NonNullValueClassSaver)) && obj2 != null) ? (List) saver.restore(obj2) : null;
            Object obj3 = list3.get(2);
            Saver saver2 = SaversKt.AnnotationRangeListSaver;
            List list6 = ((!Intrinsics.areEqual(obj3, false) || (saver2 instanceof NonNullValueClassSaver)) && obj3 != null) ? (List) saver2.restore(obj3) : null;
            Object obj4 = list3.get(0);
            String str = obj4 != null ? (String) obj4 : null;
            Intrinsics.checkNotNull(str);
            if (list5 != null) {
                List list7 = list5;
                if (list7.isEmpty()) {
                    list7 = null;
                }
                list = list7;
            } else {
                list = null;
            }
            if (list6 != null) {
                List list8 = list6;
                if (list8.isEmpty()) {
                    list8 = null;
                }
                list2 = list8;
            } else {
                list2 = null;
            }
            Object obj5 = list3.get(3);
            Saver saver3 = SaversKt.AnnotationRangeListSaver;
            if ((!Intrinsics.areEqual(obj5, false) || (saver3 instanceof NonNullValueClassSaver)) && obj5 != null) {
                list4 = (List) saver3.restore(obj5);
            }
            return new AnnotatedString(str, list, list2, list4);
        }
    });
    private static final Saver<List<AnnotatedString.Range<? extends Object>>, Object> AnnotationRangeListSaver = SaverKt.Saver(new Function2<SaverScope, List<? extends AnnotatedString.Range<? extends Object>>, Object>() {
        public final Object invoke(SaverScope saverScope, List<? extends AnnotatedString.Range<? extends Object>> list) {
            ArrayList arrayList = new ArrayList(list.size());
            int size = list.size();
            for (int i = 0; i < size; i++) {
                arrayList.add(SaversKt.save(list.get(i), SaversKt.AnnotationRangeSaver, saverScope));
            }
            return arrayList;
        }
    }, new Function1<Object, List<? extends AnnotatedString.Range<? extends Object>>>() {
        public final List<AnnotatedString.Range<? extends Object>> invoke(Object obj) {
            Intrinsics.checkNotNull(obj, "null cannot be cast to non-null type kotlin.collections.List<kotlin.Any>");
            List list = (List) obj;
            ArrayList arrayList = new ArrayList(list.size());
            int size = list.size();
            for (int i = 0; i < size; i++) {
                Object obj2 = list.get(i);
                ArrayList arrayList2 = arrayList;
                Saver saver = SaversKt.AnnotationRangeSaver;
                AnnotatedString.Range range = null;
                if ((!Intrinsics.areEqual(obj2, false) || (saver instanceof NonNullValueClassSaver)) && obj2 != null) {
                    range = (AnnotatedString.Range) saver.restore(obj2);
                }
                Intrinsics.checkNotNull(range);
                arrayList2.add(range);
            }
            return arrayList;
        }
    });
    private static final Saver<AnnotatedString.Range<? extends Object>, Object> AnnotationRangeSaver = SaverKt.Saver(new Function2<SaverScope, AnnotatedString.Range<? extends Object>, Object>() {

        @Metadata(k = 3, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
        public class WhenMappings {
            public static final int[] $EnumSwitchMapping$0;

            static {
                int[] iArr = new int[AnnotationType.values().length];
                try {
                    iArr[AnnotationType.Paragraph.ordinal()] = 1;
                } catch (NoSuchFieldError unused) {
                }
                try {
                    iArr[AnnotationType.Span.ordinal()] = 2;
                } catch (NoSuchFieldError unused2) {
                }
                try {
                    iArr[AnnotationType.VerbatimTts.ordinal()] = 3;
                } catch (NoSuchFieldError unused3) {
                }
                try {
                    iArr[AnnotationType.Url.ordinal()] = 4;
                } catch (NoSuchFieldError unused4) {
                }
                try {
                    iArr[AnnotationType.Link.ordinal()] = 5;
                } catch (NoSuchFieldError unused5) {
                }
                try {
                    iArr[AnnotationType.Clickable.ordinal()] = 6;
                } catch (NoSuchFieldError unused6) {
                }
                try {
                    iArr[AnnotationType.String.ordinal()] = 7;
                } catch (NoSuchFieldError unused7) {
                }
                $EnumSwitchMapping$0 = iArr;
            }
        }

        public final Object invoke(SaverScope saverScope, AnnotatedString.Range<? extends Object> range) throws NoWhenBranchMatchedException {
            AnnotationType annotationType;
            Object objSave;
            Object item = range.getItem();
            if (item instanceof ParagraphStyle) {
                annotationType = AnnotationType.Paragraph;
            } else if (item instanceof SpanStyle) {
                annotationType = AnnotationType.Span;
            } else if (item instanceof VerbatimTtsAnnotation) {
                annotationType = AnnotationType.VerbatimTts;
            } else if (item instanceof UrlAnnotation) {
                annotationType = AnnotationType.Url;
            } else if (item instanceof LinkAnnotation.Url) {
                annotationType = AnnotationType.Link;
            } else {
                annotationType = item instanceof LinkAnnotation.Clickable ? AnnotationType.Clickable : AnnotationType.String;
            }
            switch (WhenMappings.$EnumSwitchMapping$0[annotationType.ordinal()]) {
                case 1:
                    Object item2 = range.getItem();
                    Intrinsics.checkNotNull(item2, "null cannot be cast to non-null type androidx.compose.ui.text.ParagraphStyle");
                    objSave = SaversKt.save((ParagraphStyle) item2, SaversKt.getParagraphStyleSaver(), saverScope);
                    break;
                case 2:
                    Object item3 = range.getItem();
                    Intrinsics.checkNotNull(item3, "null cannot be cast to non-null type androidx.compose.ui.text.SpanStyle");
                    objSave = SaversKt.save((SpanStyle) item3, SaversKt.getSpanStyleSaver(), saverScope);
                    break;
                case 3:
                    Object item4 = range.getItem();
                    Intrinsics.checkNotNull(item4, "null cannot be cast to non-null type androidx.compose.ui.text.VerbatimTtsAnnotation");
                    objSave = SaversKt.save((VerbatimTtsAnnotation) item4, SaversKt.VerbatimTtsAnnotationSaver, saverScope);
                    break;
                case 4:
                    Object item5 = range.getItem();
                    Intrinsics.checkNotNull(item5, "null cannot be cast to non-null type androidx.compose.ui.text.UrlAnnotation");
                    objSave = SaversKt.save((UrlAnnotation) item5, SaversKt.UrlAnnotationSaver, saverScope);
                    break;
                case 5:
                    Object item6 = range.getItem();
                    Intrinsics.checkNotNull(item6, "null cannot be cast to non-null type androidx.compose.ui.text.LinkAnnotation.Url");
                    objSave = SaversKt.save((LinkAnnotation.Url) item6, SaversKt.LinkSaver, saverScope);
                    break;
                case 6:
                    Object item7 = range.getItem();
                    Intrinsics.checkNotNull(item7, "null cannot be cast to non-null type androidx.compose.ui.text.LinkAnnotation.Clickable");
                    objSave = SaversKt.save((LinkAnnotation.Clickable) item7, SaversKt.ClickableSaver, saverScope);
                    break;
                case 7:
                    objSave = SaversKt.save(range.getItem());
                    break;
                default:
                    throw new NoWhenBranchMatchedException();
            }
            return CollectionsKt.arrayListOf(new Object[]{SaversKt.save(annotationType), objSave, SaversKt.save(Integer.valueOf(range.getStart())), SaversKt.save(Integer.valueOf(range.getEnd())), SaversKt.save(range.getTag())});
        }
    }, new Function1<Object, AnnotatedString.Range<? extends Object>>() {

        @Metadata(k = 3, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
        public class WhenMappings {
            public static final int[] $EnumSwitchMapping$0;

            static {
                int[] iArr = new int[AnnotationType.values().length];
                try {
                    iArr[AnnotationType.Paragraph.ordinal()] = 1;
                } catch (NoSuchFieldError unused) {
                }
                try {
                    iArr[AnnotationType.Span.ordinal()] = 2;
                } catch (NoSuchFieldError unused2) {
                }
                try {
                    iArr[AnnotationType.VerbatimTts.ordinal()] = 3;
                } catch (NoSuchFieldError unused3) {
                }
                try {
                    iArr[AnnotationType.Url.ordinal()] = 4;
                } catch (NoSuchFieldError unused4) {
                }
                try {
                    iArr[AnnotationType.Link.ordinal()] = 5;
                } catch (NoSuchFieldError unused5) {
                }
                try {
                    iArr[AnnotationType.Clickable.ordinal()] = 6;
                } catch (NoSuchFieldError unused6) {
                }
                try {
                    iArr[AnnotationType.String.ordinal()] = 7;
                } catch (NoSuchFieldError unused7) {
                }
                $EnumSwitchMapping$0 = iArr;
            }
        }

        public final AnnotatedString.Range<? extends Object> m1200invoke(Object obj) throws NoWhenBranchMatchedException {
            Intrinsics.checkNotNull(obj, "null cannot be cast to non-null type kotlin.collections.List<kotlin.Any>");
            List list = (List) obj;
            Object obj2 = list.get(0);
            Object obj3 = null;
            AnnotationType annotationType = obj2 != null ? (AnnotationType) obj2 : null;
            Intrinsics.checkNotNull(annotationType);
            Object obj4 = list.get(2);
            Integer num = obj4 != null ? (Integer) obj4 : null;
            Intrinsics.checkNotNull(num);
            int iIntValue = num.intValue();
            Object obj5 = list.get(3);
            Integer num2 = obj5 != null ? (Integer) obj5 : null;
            Intrinsics.checkNotNull(num2);
            int iIntValue2 = num2.intValue();
            Object obj6 = list.get(4);
            String str = obj6 != null ? (String) obj6 : null;
            Intrinsics.checkNotNull(str);
            switch (WhenMappings.$EnumSwitchMapping$0[annotationType.ordinal()]) {
                case 1:
                    Object obj7 = list.get(1);
                    Saver<ParagraphStyle, Object> paragraphStyleSaver = SaversKt.getParagraphStyleSaver();
                    if ((!Intrinsics.areEqual(obj7, false) || (paragraphStyleSaver instanceof NonNullValueClassSaver)) && obj7 != null) {
                        obj3 = (ParagraphStyle) paragraphStyleSaver.restore(obj7);
                    }
                    Intrinsics.checkNotNull(obj3);
                    return new AnnotatedString.Range<>(obj3, iIntValue, iIntValue2, str);
                case 2:
                    Object obj8 = list.get(1);
                    Saver<SpanStyle, Object> spanStyleSaver = SaversKt.getSpanStyleSaver();
                    if ((!Intrinsics.areEqual(obj8, false) || (spanStyleSaver instanceof NonNullValueClassSaver)) && obj8 != null) {
                        obj3 = (SpanStyle) spanStyleSaver.restore(obj8);
                    }
                    Intrinsics.checkNotNull(obj3);
                    return new AnnotatedString.Range<>(obj3, iIntValue, iIntValue2, str);
                case 3:
                    Object obj9 = list.get(1);
                    Saver saver = SaversKt.VerbatimTtsAnnotationSaver;
                    if ((!Intrinsics.areEqual(obj9, false) || (saver instanceof NonNullValueClassSaver)) && obj9 != null) {
                        obj3 = (VerbatimTtsAnnotation) saver.restore(obj9);
                    }
                    Intrinsics.checkNotNull(obj3);
                    return new AnnotatedString.Range<>(obj3, iIntValue, iIntValue2, str);
                case 4:
                    Object obj10 = list.get(1);
                    Saver saver2 = SaversKt.UrlAnnotationSaver;
                    if ((!Intrinsics.areEqual(obj10, false) || (saver2 instanceof NonNullValueClassSaver)) && obj10 != null) {
                        obj3 = (UrlAnnotation) saver2.restore(obj10);
                    }
                    Intrinsics.checkNotNull(obj3);
                    return new AnnotatedString.Range<>(obj3, iIntValue, iIntValue2, str);
                case 5:
                    Object obj11 = list.get(1);
                    Saver saver3 = SaversKt.LinkSaver;
                    if ((!Intrinsics.areEqual(obj11, false) || (saver3 instanceof NonNullValueClassSaver)) && obj11 != null) {
                        obj3 = (LinkAnnotation.Url) saver3.restore(obj11);
                    }
                    Intrinsics.checkNotNull(obj3);
                    return new AnnotatedString.Range<>(obj3, iIntValue, iIntValue2, str);
                case 6:
                    Object obj12 = list.get(1);
                    Saver saver4 = SaversKt.ClickableSaver;
                    if ((!Intrinsics.areEqual(obj12, false) || (saver4 instanceof NonNullValueClassSaver)) && obj12 != null) {
                        obj3 = (LinkAnnotation.Clickable) saver4.restore(obj12);
                    }
                    Intrinsics.checkNotNull(obj3);
                    return new AnnotatedString.Range<>(obj3, iIntValue, iIntValue2, str);
                case 7:
                    Object obj13 = list.get(1);
                    obj3 = obj13 != null ? (String) obj13 : null;
                    Intrinsics.checkNotNull(obj3);
                    return new AnnotatedString.Range<>(obj3, iIntValue, iIntValue2, str);
                default:
                    throw new NoWhenBranchMatchedException();
            }
        }
    });
    private static final Saver<VerbatimTtsAnnotation, Object> VerbatimTtsAnnotationSaver = SaverKt.Saver(new Function2<SaverScope, VerbatimTtsAnnotation, Object>() {
        public final Object invoke(SaverScope saverScope, VerbatimTtsAnnotation verbatimTtsAnnotation) {
            return SaversKt.save(verbatimTtsAnnotation.getVerbatim());
        }
    }, new Function1<Object, VerbatimTtsAnnotation>() {
        public final VerbatimTtsAnnotation m1224invoke(Object obj) {
            String str = obj != null ? (String) obj : null;
            Intrinsics.checkNotNull(str);
            return new VerbatimTtsAnnotation(str);
        }
    });
    private static final Saver<UrlAnnotation, Object> UrlAnnotationSaver = SaverKt.Saver(new Function2<SaverScope, UrlAnnotation, Object>() {
        public final Object invoke(SaverScope saverScope, UrlAnnotation urlAnnotation) {
            return SaversKt.save(urlAnnotation.getUrl());
        }
    }, new Function1<Object, UrlAnnotation>() {
        public final UrlAnnotation m1223invoke(Object obj) {
            String str = obj != null ? (String) obj : null;
            Intrinsics.checkNotNull(str);
            return new UrlAnnotation(str);
        }
    });
    private static final Saver<LinkAnnotation.Url, Object> LinkSaver = SaverKt.Saver(new Function2<SaverScope, LinkAnnotation.Url, Object>() {
        public final Object invoke(SaverScope saverScope, LinkAnnotation.Url url) {
            return CollectionsKt.arrayListOf(new Object[]{SaversKt.save(url.getUrl()), SaversKt.save(url.getStyles(), SaversKt.getTextLinkStylesSaver(), saverScope)});
        }
    }, new Function1<Object, LinkAnnotation.Url>() {
        public final LinkAnnotation.Url m1207invoke(Object obj) {
            Intrinsics.checkNotNull(obj, "null cannot be cast to non-null type kotlin.collections.List<kotlin.Any?>");
            List list = (List) obj;
            Object obj2 = list.get(0);
            TextLinkStyles textLinkStyles = null;
            String str = obj2 != null ? (String) obj2 : null;
            Intrinsics.checkNotNull(str);
            Object obj3 = list.get(1);
            Saver<TextLinkStyles, Object> textLinkStylesSaver = SaversKt.getTextLinkStylesSaver();
            if ((!Intrinsics.areEqual(obj3, false) || (textLinkStylesSaver instanceof NonNullValueClassSaver)) && obj3 != null) {
                textLinkStyles = (TextLinkStyles) textLinkStylesSaver.restore(obj3);
            }
            return new LinkAnnotation.Url(str, textLinkStyles, null, 4, null);
        }
    });
    private static final Saver<LinkAnnotation.Clickable, Object> ClickableSaver = SaverKt.Saver(new Function2<SaverScope, LinkAnnotation.Clickable, Object>() {
        public final Object invoke(SaverScope saverScope, LinkAnnotation.Clickable clickable) {
            return CollectionsKt.arrayListOf(new Object[]{SaversKt.save(clickable.getTag()), SaversKt.save(clickable.getStyles(), SaversKt.getTextLinkStylesSaver(), saverScope)});
        }
    }, new Function1<Object, LinkAnnotation.Clickable>() {
        public final LinkAnnotation.Clickable m1203invoke(Object obj) {
            Intrinsics.checkNotNull(obj, "null cannot be cast to non-null type kotlin.collections.List<kotlin.Any?>");
            List list = (List) obj;
            Object obj2 = list.get(0);
            String str = obj2 != null ? (String) obj2 : null;
            Intrinsics.checkNotNull(str);
            Object obj3 = list.get(1);
            Saver<TextLinkStyles, Object> textLinkStylesSaver = SaversKt.getTextLinkStylesSaver();
            return new LinkAnnotation.Clickable(str, ((!Intrinsics.areEqual(obj3, false) || (textLinkStylesSaver instanceof NonNullValueClassSaver)) && obj3 != null) ? (TextLinkStyles) textLinkStylesSaver.restore(obj3) : null, null);
        }
    });
    private static final Saver<ParagraphStyle, Object> ParagraphStyleSaver = SaverKt.Saver(new Function2<SaverScope, ParagraphStyle, Object>() {
        public final Object invoke(SaverScope saverScope, ParagraphStyle paragraphStyle) {
            return CollectionsKt.arrayListOf(new Object[]{SaversKt.save(TextAlign.m1692boximpl(paragraphStyle.getTextAlign())), SaversKt.save(TextDirection.m1706boximpl(paragraphStyle.getTextDirection())), SaversKt.save(TextUnit.m2022boximpl(paragraphStyle.getLineHeight()), SaversKt.getSaver(TextUnit.INSTANCE), saverScope), SaversKt.save(paragraphStyle.getTextIndent(), SaversKt.getSaver(TextIndent.INSTANCE), saverScope)});
        }
    }, new Function1<Object, ParagraphStyle>() {
        public final ParagraphStyle m1212invoke(Object obj) {
            Intrinsics.checkNotNull(obj, "null cannot be cast to non-null type kotlin.collections.List<kotlin.Any?>");
            List list = (List) obj;
            Object obj2 = list.get(0);
            TextAlign textAlign = obj2 != null ? (TextAlign) obj2 : null;
            Intrinsics.checkNotNull(textAlign);
            int value = textAlign.getValue();
            Object obj3 = list.get(1);
            TextDirection textDirection = obj3 != null ? (TextDirection) obj3 : null;
            Intrinsics.checkNotNull(textDirection);
            int value2 = textDirection.getValue();
            Object obj4 = list.get(2);
            Saver<TextUnit, Object> saver = SaversKt.getSaver(TextUnit.INSTANCE);
            TextUnit textUnit = ((!Intrinsics.areEqual(obj4, false) || (saver instanceof NonNullValueClassSaver)) && obj4 != null) ? (TextUnit) saver.restore(obj4) : null;
            Intrinsics.checkNotNull(textUnit);
            long packedValue = textUnit.getPackedValue();
            Object obj5 = list.get(3);
            Saver<TextIndent, Object> saver2 = SaversKt.getSaver(TextIndent.INSTANCE);
            return new ParagraphStyle(value, value2, packedValue, ((!Intrinsics.areEqual(obj5, false) || (saver2 instanceof NonNullValueClassSaver)) && obj5 != null) ? (TextIndent) saver2.restore(obj5) : null, (PlatformParagraphStyle) null, (LineHeightStyle) null, 0, 0, (TextMotion) null, 496, (DefaultConstructorMarker) null);
        }
    });
    private static final Saver<SpanStyle, Object> SpanStyleSaver = SaverKt.Saver(new Function2<SaverScope, SpanStyle, Object>() {
        public final Object invoke(SaverScope saverScope, SpanStyle spanStyle) {
            return CollectionsKt.arrayListOf(new Object[]{SaversKt.save(Color.box-impl(spanStyle.m1235getColor0d7_KjU()), SaversKt.getSaver(Color.Companion), saverScope), SaversKt.save(TextUnit.m2022boximpl(spanStyle.getFontSize()), SaversKt.getSaver(TextUnit.INSTANCE), saverScope), SaversKt.save(spanStyle.getFontWeight(), SaversKt.getSaver(FontWeight.INSTANCE), saverScope), SaversKt.save(spanStyle.getFontStyle()), SaversKt.save(spanStyle.getFontSynthesis()), SaversKt.save(-1), SaversKt.save(spanStyle.getFontFeatureSettings()), SaversKt.save(TextUnit.m2022boximpl(spanStyle.getLetterSpacing()), SaversKt.getSaver(TextUnit.INSTANCE), saverScope), SaversKt.save(spanStyle.getBaselineShift(), SaversKt.getSaver(BaselineShift.INSTANCE), saverScope), SaversKt.save(spanStyle.getTextGeometricTransform(), SaversKt.getSaver(TextGeometricTransform.INSTANCE), saverScope), SaversKt.save(spanStyle.getLocaleList(), SaversKt.getSaver(LocaleList.INSTANCE), saverScope), SaversKt.save(Color.box-impl(spanStyle.getBackground()), SaversKt.getSaver(Color.Companion), saverScope), SaversKt.save(spanStyle.getTextDecoration(), SaversKt.getSaver(TextDecoration.INSTANCE), saverScope), SaversKt.save(spanStyle.getShadow(), SaversKt.getSaver(Shadow.Companion), saverScope)});
        }
    }, new Function1<Object, SpanStyle>() {
        public final SpanStyle m1214invoke(Object obj) {
            Intrinsics.checkNotNull(obj, "null cannot be cast to non-null type kotlin.collections.List<kotlin.Any?>");
            List list = (List) obj;
            Object obj2 = list.get(0);
            Saver<Color, Object> saver = SaversKt.getSaver(Color.Companion);
            Color color = ((!Intrinsics.areEqual(obj2, false) || (saver instanceof NonNullValueClassSaver)) && obj2 != null) ? (Color) saver.restore(obj2) : null;
            Intrinsics.checkNotNull(color);
            long j = color.unbox-impl();
            Object obj3 = list.get(1);
            Saver<TextUnit, Object> saver2 = SaversKt.getSaver(TextUnit.INSTANCE);
            TextUnit textUnit = ((!Intrinsics.areEqual(obj3, false) || (saver2 instanceof NonNullValueClassSaver)) && obj3 != null) ? (TextUnit) saver2.restore(obj3) : null;
            Intrinsics.checkNotNull(textUnit);
            long packedValue = textUnit.getPackedValue();
            Object obj4 = list.get(2);
            Saver<FontWeight, Object> saver3 = SaversKt.getSaver(FontWeight.INSTANCE);
            FontWeight fontWeight = ((!Intrinsics.areEqual(obj4, false) || (saver3 instanceof NonNullValueClassSaver)) && obj4 != null) ? (FontWeight) saver3.restore(obj4) : null;
            Object obj5 = list.get(3);
            FontStyle fontStyle = obj5 != null ? (FontStyle) obj5 : null;
            Object obj6 = list.get(4);
            FontSynthesis fontSynthesis = obj6 != null ? (FontSynthesis) obj6 : null;
            Object obj7 = list.get(6);
            String str = obj7 != null ? (String) obj7 : null;
            Object obj8 = list.get(7);
            Saver<TextUnit, Object> saver4 = SaversKt.getSaver(TextUnit.INSTANCE);
            TextUnit textUnit2 = ((!Intrinsics.areEqual(obj8, false) || (saver4 instanceof NonNullValueClassSaver)) && obj8 != null) ? (TextUnit) saver4.restore(obj8) : null;
            Intrinsics.checkNotNull(textUnit2);
            long packedValue2 = textUnit2.getPackedValue();
            Object obj9 = list.get(8);
            Saver<BaselineShift, Object> saver5 = SaversKt.getSaver(BaselineShift.INSTANCE);
            BaselineShift baselineShift = ((!Intrinsics.areEqual(obj9, false) || (saver5 instanceof NonNullValueClassSaver)) && obj9 != null) ? (BaselineShift) saver5.restore(obj9) : null;
            Object obj10 = list.get(9);
            Saver<TextGeometricTransform, Object> saver6 = SaversKt.getSaver(TextGeometricTransform.INSTANCE);
            TextGeometricTransform textGeometricTransform = ((!Intrinsics.areEqual(obj10, false) || (saver6 instanceof NonNullValueClassSaver)) && obj10 != null) ? (TextGeometricTransform) saver6.restore(obj10) : null;
            Object obj11 = list.get(10);
            Saver<LocaleList, Object> saver7 = SaversKt.getSaver(LocaleList.INSTANCE);
            LocaleList localeList = ((!Intrinsics.areEqual(obj11, false) || (saver7 instanceof NonNullValueClassSaver)) && obj11 != null) ? (LocaleList) saver7.restore(obj11) : null;
            Object obj12 = list.get(11);
            Saver<Color, Object> saver8 = SaversKt.getSaver(Color.Companion);
            Color color2 = ((!Intrinsics.areEqual(obj12, false) || (saver8 instanceof NonNullValueClassSaver)) && obj12 != null) ? (Color) saver8.restore(obj12) : null;
            Intrinsics.checkNotNull(color2);
            long j2 = color2.unbox-impl();
            Object obj13 = list.get(12);
            Saver<TextDecoration, Object> saver9 = SaversKt.getSaver(TextDecoration.INSTANCE);
            TextDecoration textDecoration = ((!Intrinsics.areEqual(obj13, false) || (saver9 instanceof NonNullValueClassSaver)) && obj13 != null) ? (TextDecoration) saver9.restore(obj13) : null;
            Object obj14 = list.get(13);
            Saver<Shadow, Object> saver10 = SaversKt.getSaver(Shadow.Companion);
            return new SpanStyle(j, packedValue, fontWeight, fontStyle, fontSynthesis, (FontFamily) null, str, packedValue2, baselineShift, textGeometricTransform, localeList, j2, textDecoration, ((!Intrinsics.areEqual(obj14, false) || (saver10 instanceof NonNullValueClassSaver)) && obj14 != null) ? (Shadow) saver10.restore(obj14) : null, (PlatformSpanStyle) null, (DrawStyle) null, 49184, (DefaultConstructorMarker) null);
        }
    });
    private static final Saver<TextLinkStyles, Object> TextLinkStylesSaver = SaverKt.Saver(new Function2<SaverScope, TextLinkStyles, Object>() {
        public final Object invoke(SaverScope saverScope, TextLinkStyles textLinkStyles) {
            return CollectionsKt.arrayListOf(new Object[]{SaversKt.save(textLinkStyles.getStyle(), SaversKt.getSpanStyleSaver(), saverScope), SaversKt.save(textLinkStyles.getFocusedStyle(), SaversKt.getSpanStyleSaver(), saverScope), SaversKt.save(textLinkStyles.getHoveredStyle(), SaversKt.getSpanStyleSaver(), saverScope), SaversKt.save(textLinkStyles.getPressedStyle(), SaversKt.getSpanStyleSaver(), saverScope)});
        }
    }, new Function1<Object, TextLinkStyles>() {
        public final TextLinkStyles m1218invoke(Object obj) {
            Intrinsics.checkNotNull(obj, "null cannot be cast to non-null type kotlin.collections.List<kotlin.Any?>");
            List list = (List) obj;
            Object obj2 = list.get(0);
            Saver<SpanStyle, Object> spanStyleSaver = SaversKt.getSpanStyleSaver();
            SpanStyle spanStyle = null;
            SpanStyle spanStyle2 = ((!Intrinsics.areEqual(obj2, false) || (spanStyleSaver instanceof NonNullValueClassSaver)) && obj2 != null) ? (SpanStyle) spanStyleSaver.restore(obj2) : null;
            Object obj3 = list.get(1);
            Saver<SpanStyle, Object> spanStyleSaver2 = SaversKt.getSpanStyleSaver();
            SpanStyle spanStyle3 = ((!Intrinsics.areEqual(obj3, false) || (spanStyleSaver2 instanceof NonNullValueClassSaver)) && obj3 != null) ? (SpanStyle) spanStyleSaver2.restore(obj3) : null;
            Object obj4 = list.get(2);
            Saver<SpanStyle, Object> spanStyleSaver3 = SaversKt.getSpanStyleSaver();
            SpanStyle spanStyle4 = ((!Intrinsics.areEqual(obj4, false) || (spanStyleSaver3 instanceof NonNullValueClassSaver)) && obj4 != null) ? (SpanStyle) spanStyleSaver3.restore(obj4) : null;
            Object obj5 = list.get(3);
            Saver<SpanStyle, Object> spanStyleSaver4 = SaversKt.getSpanStyleSaver();
            if ((!Intrinsics.areEqual(obj5, false) || (spanStyleSaver4 instanceof NonNullValueClassSaver)) && obj5 != null) {
                spanStyle = (SpanStyle) spanStyleSaver4.restore(obj5);
            }
            return new TextLinkStyles(spanStyle2, spanStyle3, spanStyle4, spanStyle);
        }
    });
    private static final Saver<TextDecoration, Object> TextDecorationSaver = SaverKt.Saver(new Function2<SaverScope, TextDecoration, Object>() {
        public final Object invoke(SaverScope saverScope, TextDecoration textDecoration) {
            return Integer.valueOf(textDecoration.getMask());
        }
    }, new Function1<Object, TextDecoration>() {
        public final TextDecoration m1215invoke(Object obj) {
            Intrinsics.checkNotNull(obj, "null cannot be cast to non-null type kotlin.Int");
            return new TextDecoration(((Integer) obj).intValue());
        }
    });
    private static final Saver<TextGeometricTransform, Object> TextGeometricTransformSaver = SaverKt.Saver(new Function2<SaverScope, TextGeometricTransform, Object>() {
        public final Object invoke(SaverScope saverScope, TextGeometricTransform textGeometricTransform) {
            return CollectionsKt.arrayListOf(new Float[]{Float.valueOf(textGeometricTransform.getScaleX()), Float.valueOf(textGeometricTransform.getSkewX())});
        }
    }, new Function1<Object, TextGeometricTransform>() {
        public final TextGeometricTransform m1216invoke(Object obj) {
            Intrinsics.checkNotNull(obj, "null cannot be cast to non-null type kotlin.collections.List<kotlin.Float>");
            List list = (List) obj;
            return new TextGeometricTransform(((Number) list.get(0)).floatValue(), ((Number) list.get(1)).floatValue());
        }
    });
    private static final Saver<TextIndent, Object> TextIndentSaver = SaverKt.Saver(new Function2<SaverScope, TextIndent, Object>() {
        public final Object invoke(SaverScope saverScope, TextIndent textIndent) {
            return CollectionsKt.arrayListOf(new Object[]{SaversKt.save(TextUnit.m2022boximpl(textIndent.getFirstLine()), SaversKt.getSaver(TextUnit.INSTANCE), saverScope), SaversKt.save(TextUnit.m2022boximpl(textIndent.getRestLine()), SaversKt.getSaver(TextUnit.INSTANCE), saverScope)});
        }
    }, new Function1<Object, TextIndent>() {
        public final TextIndent m1217invoke(Object obj) {
            Intrinsics.checkNotNull(obj, "null cannot be cast to non-null type kotlin.collections.List<kotlin.Any>");
            List list = (List) obj;
            Object obj2 = list.get(0);
            Saver<TextUnit, Object> saver = SaversKt.getSaver(TextUnit.INSTANCE);
            TextUnit textUnit = null;
            TextUnit textUnit2 = ((!Intrinsics.areEqual(obj2, false) || (saver instanceof NonNullValueClassSaver)) && obj2 != null) ? (TextUnit) saver.restore(obj2) : null;
            Intrinsics.checkNotNull(textUnit2);
            long packedValue = textUnit2.getPackedValue();
            Object obj3 = list.get(1);
            Saver<TextUnit, Object> saver2 = SaversKt.getSaver(TextUnit.INSTANCE);
            if ((!Intrinsics.areEqual(obj3, false) || (saver2 instanceof NonNullValueClassSaver)) && obj3 != null) {
                textUnit = (TextUnit) saver2.restore(obj3);
            }
            Intrinsics.checkNotNull(textUnit);
            return new TextIndent(packedValue, textUnit.getPackedValue(), null);
        }
    });
    private static final Saver<FontWeight, Object> FontWeightSaver = SaverKt.Saver(new Function2<SaverScope, FontWeight, Object>() {
        public final Object invoke(SaverScope saverScope, FontWeight fontWeight) {
            return Integer.valueOf(fontWeight.getWeight());
        }
    }, new Function1<Object, FontWeight>() {
        public final FontWeight m1206invoke(Object obj) {
            Intrinsics.checkNotNull(obj, "null cannot be cast to non-null type kotlin.Int");
            return new FontWeight(((Integer) obj).intValue());
        }
    });
    private static final Saver<BaselineShift, Object> BaselineShiftSaver = SaverKt.Saver(new Function2<SaverScope, BaselineShift, Object>() {
        public Object invoke(Object obj, Object obj2) {
            return m1201invoke8a2Sb4w((SaverScope) obj, ((BaselineShift) obj2).m1589unboximpl());
        }

        public final Object m1201invoke8a2Sb4w(SaverScope saverScope, float f) {
            return Float.valueOf(f);
        }
    }, new Function1<Object, BaselineShift>() {
        public final BaselineShift invoke(Object obj) {
            Intrinsics.checkNotNull(obj, "null cannot be cast to non-null type kotlin.Float");
            return BaselineShift.m1583boximpl(BaselineShift.m1584constructorimpl(((Float) obj).floatValue()));
        }
    });
    private static final Saver<TextRange, Object> TextRangeSaver = SaverKt.Saver(new Function2<SaverScope, TextRange, Object>() {
        public Object invoke(Object obj, Object obj2) {
            return m1219invokeFDrldGo((SaverScope) obj, ((TextRange) obj2).getPackedValue());
        }

        public final Object m1219invokeFDrldGo(SaverScope saverScope, long j) {
            return CollectionsKt.arrayListOf(new Integer[]{SaversKt.save(Integer.valueOf(TextRange.m1286getStartimpl(j))), SaversKt.save(Integer.valueOf(TextRange.m1281getEndimpl(j)))});
        }
    }, new Function1<Object, TextRange>() {
        public final TextRange invoke(Object obj) {
            Intrinsics.checkNotNull(obj, "null cannot be cast to non-null type kotlin.collections.List<kotlin.Any>");
            List list = (List) obj;
            Object obj2 = list.get(0);
            Integer num = obj2 != null ? (Integer) obj2 : null;
            Intrinsics.checkNotNull(num);
            int iIntValue = num.intValue();
            Object obj3 = list.get(1);
            Integer num2 = obj3 != null ? (Integer) obj3 : null;
            Intrinsics.checkNotNull(num2);
            return TextRange.m1274boximpl(TextRangeKt.TextRange(iIntValue, num2.intValue()));
        }
    });
    private static final Saver<Shadow, Object> ShadowSaver = SaverKt.Saver(new Function2<SaverScope, Shadow, Object>() {
        public final Object invoke(SaverScope saverScope, Shadow shadow) {
            return CollectionsKt.arrayListOf(new Object[]{SaversKt.save(Color.box-impl(shadow.getColor-0d7_KjU()), SaversKt.getSaver(Color.Companion), saverScope), SaversKt.save(Offset.box-impl(shadow.getOffset-F1C5BW0()), SaversKt.getSaver(Offset.Companion), saverScope), SaversKt.save(Float.valueOf(shadow.getBlurRadius()))});
        }
    }, new Function1<Object, Shadow>() {
        public final Shadow m1213invoke(Object obj) {
            Intrinsics.checkNotNull(obj, "null cannot be cast to non-null type kotlin.collections.List<kotlin.Any>");
            List list = (List) obj;
            Object obj2 = list.get(0);
            Saver<Color, Object> saver = SaversKt.getSaver(Color.Companion);
            Color color = ((!Intrinsics.areEqual(obj2, false) || (saver instanceof NonNullValueClassSaver)) && obj2 != null) ? (Color) saver.restore(obj2) : null;
            Intrinsics.checkNotNull(color);
            long j = color.unbox-impl();
            Object obj3 = list.get(1);
            Saver<Offset, Object> saver2 = SaversKt.getSaver(Offset.Companion);
            Offset offset = ((!Intrinsics.areEqual(obj3, false) || (saver2 instanceof NonNullValueClassSaver)) && obj3 != null) ? (Offset) saver2.restore(obj3) : null;
            Intrinsics.checkNotNull(offset);
            long j2 = offset.unbox-impl();
            Object obj4 = list.get(2);
            Float f = obj4 != null ? (Float) obj4 : null;
            Intrinsics.checkNotNull(f);
            return new Shadow(j, j2, f.floatValue(), (DefaultConstructorMarker) null);
        }
    });
    private static final NonNullValueClassSaver<Color, Object> ColorSaver = NonNullValueClassSaver(new Function2<SaverScope, Color, Object>() {
        public Object invoke(Object obj, Object obj2) {
            return m1204invoke4WTKRHQ((SaverScope) obj, ((Color) obj2).unbox-impl());
        }

        public final Object m1204invoke4WTKRHQ(SaverScope saverScope, long j) {
            if (j == 16) {
                return false;
            }
            return Integer.valueOf(ColorKt.toArgb-8_81llA(j));
        }
    }, new Function1<Object, Color>() {
        public final Color invoke(Object obj) {
            long jColor;
            if (Intrinsics.areEqual(obj, false)) {
                jColor = Color.Companion.getUnspecified-0d7_KjU();
            } else {
                Intrinsics.checkNotNull(obj, "null cannot be cast to non-null type kotlin.Int");
                jColor = ColorKt.Color(((Integer) obj).intValue());
            }
            return Color.box-impl(jColor);
        }
    });
    private static final NonNullValueClassSaver<TextUnit, Object> TextUnitSaver = NonNullValueClassSaver(new Function2<SaverScope, TextUnit, Object>() {
        public Object invoke(Object obj, Object obj2) {
            return m1221invokempE4wyQ((SaverScope) obj, ((TextUnit) obj2).getPackedValue());
        }

        public final Object m1221invokempE4wyQ(SaverScope saverScope, long j) {
            return TextUnit.m2029equalsimpl0(j, TextUnit.INSTANCE.m2043getUnspecifiedXSAIIZE()) ? (Serializable) false : CollectionsKt.arrayListOf(new Object[]{SaversKt.save(Float.valueOf(TextUnit.m2032getValueimpl(j))), SaversKt.save(TextUnitType.m2057boximpl(TextUnit.m2031getTypeUIouoOA(j)))});
        }
    }, new Function1<Object, TextUnit>() {
        public final TextUnit invoke(Object obj) {
            if (Intrinsics.areEqual(obj, false)) {
                return TextUnit.m2022boximpl(TextUnit.INSTANCE.m2043getUnspecifiedXSAIIZE());
            }
            Intrinsics.checkNotNull(obj, "null cannot be cast to non-null type kotlin.collections.List<kotlin.Any>");
            List list = (List) obj;
            Object obj2 = list.get(0);
            Float f = obj2 != null ? (Float) obj2 : null;
            Intrinsics.checkNotNull(f);
            float fFloatValue = f.floatValue();
            Object obj3 = list.get(1);
            TextUnitType textUnitType = obj3 != null ? (TextUnitType) obj3 : null;
            Intrinsics.checkNotNull(textUnitType);
            return TextUnit.m2022boximpl(TextUnitKt.m2044TextUnitanM5pPY(fFloatValue, textUnitType.getType()));
        }
    });
    private static final NonNullValueClassSaver<Offset, Object> OffsetSaver = NonNullValueClassSaver(new Function2<SaverScope, Offset, Object>() {
        public Object invoke(Object obj, Object obj2) {
            return m1210invokeUv8p0NA((SaverScope) obj, ((Offset) obj2).unbox-impl());
        }

        public final Object m1210invokeUv8p0NA(SaverScope saverScope, long j) {
            return Offset.equals-impl0(j, Offset.Companion.getUnspecified-F1C5BW0()) ? (Serializable) false : CollectionsKt.arrayListOf(new Float[]{SaversKt.save(Float.valueOf(Offset.getX-impl(j))), SaversKt.save(Float.valueOf(Offset.getY-impl(j)))});
        }
    }, new Function1<Object, Offset>() {
        public final Offset invoke(Object obj) {
            if (Intrinsics.areEqual(obj, false)) {
                return Offset.box-impl(Offset.Companion.getUnspecified-F1C5BW0());
            }
            Intrinsics.checkNotNull(obj, "null cannot be cast to non-null type kotlin.collections.List<kotlin.Any?>");
            List list = (List) obj;
            Object obj2 = list.get(0);
            Float f = obj2 != null ? (Float) obj2 : null;
            Intrinsics.checkNotNull(f);
            float fFloatValue = f.floatValue();
            Object obj3 = list.get(1);
            Float f2 = obj3 != null ? (Float) obj3 : null;
            Intrinsics.checkNotNull(f2);
            return Offset.box-impl(OffsetKt.Offset(fFloatValue, f2.floatValue()));
        }
    });
    private static final Saver<LocaleList, Object> LocaleListSaver = SaverKt.Saver(new Function2<SaverScope, LocaleList, Object>() {
        public final Object invoke(SaverScope saverScope, LocaleList localeList) {
            List<Locale> localeList2 = localeList.getLocaleList();
            ArrayList arrayList = new ArrayList(localeList2.size());
            int size = localeList2.size();
            for (int i = 0; i < size; i++) {
                arrayList.add(SaversKt.save(localeList2.get(i), SaversKt.getSaver(Locale.INSTANCE), saverScope));
            }
            return arrayList;
        }
    }, new Function1<Object, LocaleList>() {
        public final LocaleList m1208invoke(Object obj) {
            Intrinsics.checkNotNull(obj, "null cannot be cast to non-null type kotlin.collections.List<kotlin.Any>");
            List list = (List) obj;
            ArrayList arrayList = new ArrayList(list.size());
            int size = list.size();
            for (int i = 0; i < size; i++) {
                Object obj2 = list.get(i);
                ArrayList arrayList2 = arrayList;
                Saver<Locale, Object> saver = SaversKt.getSaver(Locale.INSTANCE);
                Locale locale = null;
                if ((!Intrinsics.areEqual(obj2, false) || (saver instanceof NonNullValueClassSaver)) && obj2 != null) {
                    locale = (Locale) saver.restore(obj2);
                }
                Intrinsics.checkNotNull(locale);
                arrayList2.add(locale);
            }
            return new LocaleList(arrayList);
        }
    });
    private static final Saver<Locale, Object> LocaleSaver = SaverKt.Saver(new Function2<SaverScope, Locale, Object>() {
        public final Object invoke(SaverScope saverScope, Locale locale) {
            return locale.toLanguageTag();
        }
    }, new Function1<Object, Locale>() {
        public final Locale m1209invoke(Object obj) {
            Intrinsics.checkNotNull(obj, "null cannot be cast to non-null type kotlin.String");
            return new Locale((String) obj);
        }
    });

    private static void getAnnotationRangeSaver$annotations() {
    }

    private static void getUrlAnnotationSaver$annotations() {
    }

    public static final <T> T save(T t) {
        return t;
    }

    public static final <T extends Saver<Original, Saveable>, Original, Saveable> Object save(Original original, T t, SaverScope saverScope) {
        Object objSave;
        if (original == null || (objSave = t.save(saverScope, original)) == null) {
            return false;
        }
        return objSave;
    }

    public static final <T extends Saver<Original, Saveable>, Original, Saveable, Result> Result restore(Saveable saveable, T t) {
        if ((Intrinsics.areEqual(saveable, false) && !(t instanceof NonNullValueClassSaver)) || saveable == null) {
            return null;
        }
        Result result = (Result) t.restore(saveable);
        Intrinsics.reifiedOperationMarker(1, "Result");
        return result;
    }

    private static final <Original, Saveable> NonNullValueClassSaver<Original, Saveable> NonNullValueClassSaver(final Function2<? super SaverScope, ? super Original, ? extends Saveable> function2, final Function1<? super Saveable, ? extends Original> function1) {
        return new NonNullValueClassSaver<Original, Saveable>() {
            public Saveable save(SaverScope saverScope, Original original) {
                return (Saveable) function2.invoke(saverScope, original);
            }

            public Original restore(Saveable value) {
                return (Original) function1.invoke(value);
            }
        };
    }

    public static final <Result> Result restore(Object obj) {
        if (obj == 0) {
            return null;
        }
        Intrinsics.reifiedOperationMarker(1, "Result");
        return obj;
    }

    public static final Saver<AnnotatedString, Object> getAnnotatedStringSaver() {
        return AnnotatedStringSaver;
    }

    public static final Saver<ParagraphStyle, Object> getParagraphStyleSaver() {
        return ParagraphStyleSaver;
    }

    public static final Saver<SpanStyle, Object> getSpanStyleSaver() {
        return SpanStyleSaver;
    }

    public static final Saver<TextLinkStyles, Object> getTextLinkStylesSaver() {
        return TextLinkStylesSaver;
    }

    public static final Saver<TextDecoration, Object> getSaver(TextDecoration.Companion companion) {
        return TextDecorationSaver;
    }

    public static final Saver<TextGeometricTransform, Object> getSaver(TextGeometricTransform.Companion companion) {
        return TextGeometricTransformSaver;
    }

    public static final Saver<TextIndent, Object> getSaver(TextIndent.Companion companion) {
        return TextIndentSaver;
    }

    public static final Saver<FontWeight, Object> getSaver(FontWeight.Companion companion) {
        return FontWeightSaver;
    }

    public static final Saver<BaselineShift, Object> getSaver(BaselineShift.Companion companion) {
        return BaselineShiftSaver;
    }

    public static final Saver<TextRange, Object> getSaver(TextRange.Companion companion) {
        return TextRangeSaver;
    }

    public static final Saver<Shadow, Object> getSaver(Shadow.Companion companion) {
        return ShadowSaver;
    }

    public static final Saver<Color, Object> getSaver(Color.Companion companion) {
        return ColorSaver;
    }

    public static final Saver<TextUnit, Object> getSaver(TextUnit.Companion companion) {
        return TextUnitSaver;
    }

    public static final Saver<Offset, Object> getSaver(Offset.Companion companion) {
        return OffsetSaver;
    }

    public static final Saver<LocaleList, Object> getSaver(LocaleList.Companion companion) {
        return LocaleListSaver;
    }

    public static final Saver<Locale, Object> getSaver(Locale.Companion companion) {
        return LocaleSaver;
    }
}
