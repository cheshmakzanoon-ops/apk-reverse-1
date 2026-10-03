package androidx.compose.p000ui.text;

import androidx.constraintlayout.core.motion.utils.TypedValues;
import androidx.constraintlayout.widget.ConstraintLayout;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.SortedSet;
import java.util.TreeSet;
import kotlin.Metadata;
import kotlin.Pair;
import kotlin.TuplesKt;
import kotlin.collections.CollectionsKt;
import kotlin.collections.MapsKt;
import kotlin.collections.SetsKt;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.Ref;

@Metadata(d1 = {"\u0000*\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0000\u001a*\u0010\u0000\u001a\u00020\u00012\u0012\u0010\u0002\u001a\u000e\u0012\b\u0012\u0006\u0012\u0002\b\u00030\u0004\u0018\u00010\u00032\f\u0010\u0005\u001a\b\u0012\u0004\u0012\u00020\u00070\u0006H\u0002\u001a,\u0010\b\u001a\u00020\t*\u00020\t2\u001e\u0010\b\u001a\u001a\u0012\u0004\u0012\u00020\u000b\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\u000b0\nH\u0000¨\u0006\f"}, d2 = {"collectRangeTransitions", "", "ranges", "", "Landroidx/compose/ui/text/AnnotatedString$Range;", TypedValues.AttributesType.S_TARGET, "Ljava/util/SortedSet;", "", "transform", "Landroidx/compose/ui/text/AnnotatedString;", "Lkotlin/Function3;", "", "ui-text_release"}, k = 2, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class JvmAnnotatedString_jvmKt {
    public static final AnnotatedString transform(final AnnotatedString annotatedString, final Function3<? super String, ? super Integer, ? super Integer, String> function3) {
        ArrayList arrayList;
        ArrayList arrayList2;
        TreeSet treeSetSortedSetOf = SetsKt.sortedSetOf(new Integer[]{0, Integer.valueOf(annotatedString.getText().length())});
        TreeSet treeSet = treeSetSortedSetOf;
        collectRangeTransitions(annotatedString.getSpanStylesOrNull$ui_text_release(), treeSet);
        collectRangeTransitions(annotatedString.getParagraphStylesOrNull$ui_text_release(), treeSet);
        collectRangeTransitions(annotatedString.getAnnotations$ui_text_release(), treeSet);
        final Ref.ObjectRef objectRef = new Ref.ObjectRef();
        objectRef.element = "";
        final Map mapMutableMapOf = MapsKt.mutableMapOf(new Pair[]{TuplesKt.to(0, 0)});
        CollectionsKt.windowed$default(treeSetSortedSetOf, 2, 0, false, new Function1<List<? extends Integer>, Integer>() {
            {
                super(1);
            }

            public final Integer invoke(List<Integer> list) {
                int iIntValue = list.get(0).intValue();
                int iIntValue2 = list.get(1).intValue();
                objectRef.element = ((String) objectRef.element) + ((String) function3.invoke(annotatedString.getText(), Integer.valueOf(iIntValue), Integer.valueOf(iIntValue2)));
                return mapMutableMapOf.put(Integer.valueOf(iIntValue2), Integer.valueOf(((String) objectRef.element).length()));
            }
        }, 6, (Object) null);
        List<AnnotatedString.Range<SpanStyle>> spanStylesOrNull$ui_text_release = annotatedString.getSpanStylesOrNull$ui_text_release();
        ArrayList arrayList3 = null;
        if (spanStylesOrNull$ui_text_release != null) {
            ArrayList arrayList4 = new ArrayList(spanStylesOrNull$ui_text_release.size());
            int size = spanStylesOrNull$ui_text_release.size();
            for (int i = 0; i < size; i++) {
                AnnotatedString.Range<SpanStyle> range = spanStylesOrNull$ui_text_release.get(i);
                SpanStyle item = range.getItem();
                Object obj = mapMutableMapOf.get(Integer.valueOf(range.getStart()));
                Intrinsics.checkNotNull(obj);
                int iIntValue = ((Number) obj).intValue();
                Object obj2 = mapMutableMapOf.get(Integer.valueOf(range.getEnd()));
                Intrinsics.checkNotNull(obj2);
                arrayList4.add(new AnnotatedString.Range(item, iIntValue, ((Number) obj2).intValue()));
            }
            arrayList = arrayList4;
        } else {
            arrayList = null;
        }
        List<AnnotatedString.Range<ParagraphStyle>> paragraphStylesOrNull$ui_text_release = annotatedString.getParagraphStylesOrNull$ui_text_release();
        if (paragraphStylesOrNull$ui_text_release != null) {
            ArrayList arrayList5 = new ArrayList(paragraphStylesOrNull$ui_text_release.size());
            int size2 = paragraphStylesOrNull$ui_text_release.size();
            for (int i2 = 0; i2 < size2; i2++) {
                AnnotatedString.Range<ParagraphStyle> range2 = paragraphStylesOrNull$ui_text_release.get(i2);
                ParagraphStyle item2 = range2.getItem();
                Object obj3 = mapMutableMapOf.get(Integer.valueOf(range2.getStart()));
                Intrinsics.checkNotNull(obj3);
                int iIntValue2 = ((Number) obj3).intValue();
                Object obj4 = mapMutableMapOf.get(Integer.valueOf(range2.getEnd()));
                Intrinsics.checkNotNull(obj4);
                arrayList5.add(new AnnotatedString.Range(item2, iIntValue2, ((Number) obj4).intValue()));
            }
            arrayList2 = arrayList5;
        } else {
            arrayList2 = null;
        }
        List<AnnotatedString.Range<? extends Object>> annotations$ui_text_release = annotatedString.getAnnotations$ui_text_release();
        if (annotations$ui_text_release != null) {
            ArrayList arrayList6 = new ArrayList(annotations$ui_text_release.size());
            int size3 = annotations$ui_text_release.size();
            for (int i3 = 0; i3 < size3; i3++) {
                AnnotatedString.Range<? extends Object> range3 = annotations$ui_text_release.get(i3);
                Object item3 = range3.getItem();
                Object obj5 = mapMutableMapOf.get(Integer.valueOf(range3.getStart()));
                Intrinsics.checkNotNull(obj5);
                int iIntValue3 = ((Number) obj5).intValue();
                Object obj6 = mapMutableMapOf.get(Integer.valueOf(range3.getEnd()));
                Intrinsics.checkNotNull(obj6);
                arrayList6.add(new AnnotatedString.Range(item3, iIntValue3, ((Number) obj6).intValue()));
            }
            arrayList3 = arrayList6;
        }
        return new AnnotatedString((String) objectRef.element, arrayList, arrayList2, arrayList3);
    }

    private static final void collectRangeTransitions(List<? extends AnnotatedString.Range<?>> list, SortedSet<Integer> sortedSet) {
        if (list != null) {
            int size = list.size();
            for (int i = 0; i < size; i++) {
                AnnotatedString.Range<?> range = list.get(i);
                sortedSet.add(Integer.valueOf(range.getStart()));
                sortedSet.add(Integer.valueOf(range.getEnd()));
            }
        }
    }
}
