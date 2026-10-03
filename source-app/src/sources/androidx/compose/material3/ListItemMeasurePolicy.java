package androidx.compose.material3;

import androidx.autofill.HintConstants;
import androidx.compose.material3.internal.TextFieldImplKt;
import androidx.compose.p002ui.layout.AlignmentLineKt;
import androidx.compose.p002ui.layout.IntrinsicMeasurable;
import androidx.compose.p002ui.layout.IntrinsicMeasureScope;
import androidx.compose.p002ui.layout.Measurable;
import androidx.compose.p002ui.layout.MeasureResult;
import androidx.compose.p002ui.layout.MeasureScope;
import androidx.compose.p002ui.layout.MultiContentMeasurePolicy;
import androidx.compose.p002ui.layout.Placeable;
import androidx.compose.ui.unit.Constraints;
import androidx.compose.ui.unit.ConstraintsKt;
import androidx.compose.ui.unit.Dp;
import java.util.List;
import kotlin.Metadata;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.FunctionReferenceImpl;

@Metadata(d1 = {"\u0000J\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0002\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002JV\u0010\u0003\u001a\u00020\u0004*\u00020\u00052\u0012\u0010\u0006\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\b0\u00070\u00072\u0006\u0010\t\u001a\u00020\u00042,\u0010\n\u001a(\u0012\u0004\u0012\u00020\b\u0012\u0013\u0012\u00110\u0004¢\u0006\f\b\f\u0012\b\b\r\u0012\u0004\b\b(\t\u0012\u0004\u0012\u00020\u00040\u000b¢\u0006\u0002\b\u000eH\u0002JV\u0010\u000f\u001a\u00020\u0004*\u00020\u00052\u0012\u0010\u0006\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\b0\u00070\u00072\u0006\u0010\u0010\u001a\u00020\u00042,\u0010\n\u001a(\u0012\u0004\u0012\u00020\b\u0012\u0013\u0012\u00110\u0004¢\u0006\f\b\f\u0012\b\b\r\u0012\u0004\b\b(\u0010\u0012\u0004\u0012\u00020\u00040\u000b¢\u0006\u0002\b\u000eH\u0002J(\u0010\u0011\u001a\u00020\u0004*\u00020\u00052\u0012\u0010\u0006\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\b0\u00070\u00072\u0006\u0010\t\u001a\u00020\u0004H\u0016J(\u0010\u0012\u001a\u00020\u0004*\u00020\u00052\u0012\u0010\u0006\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\b0\u00070\u00072\u0006\u0010\u0010\u001a\u00020\u0004H\u0016J2\u0010\u0013\u001a\u00020\u0014*\u00020\u00152\u0012\u0010\u0006\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00160\u00070\u00072\u0006\u0010\u0017\u001a\u00020\u0018H\u0016ø\u0001\u0000¢\u0006\u0004\b\u0019\u0010\u001aJ(\u0010\u001b\u001a\u00020\u0004*\u00020\u00052\u0012\u0010\u0006\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\b0\u00070\u00072\u0006\u0010\t\u001a\u00020\u0004H\u0016J(\u0010\u001c\u001a\u00020\u0004*\u00020\u00052\u0012\u0010\u0006\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\b0\u00070\u00072\u0006\u0010\u0010\u001a\u00020\u0004H\u0016\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\u001d"}, d2 = {"Landroidx/compose/material3/ListItemMeasurePolicy;", "Landroidx/compose/ui/layout/MultiContentMeasurePolicy;", "()V", "calculateIntrinsicHeight", "", "Landroidx/compose/ui/layout/IntrinsicMeasureScope;", "measurables", "", "Landroidx/compose/ui/layout/IntrinsicMeasurable;", "width", "intrinsicMeasure", "Lkotlin/Function2;", "Lkotlin/ParameterName;", HintConstants.AUTOFILL_HINT_NAME, "Lkotlin/ExtensionFunctionType;", "calculateIntrinsicWidth", "height", "maxIntrinsicHeight", "maxIntrinsicWidth", "measure", "Landroidx/compose/ui/layout/MeasureResult;", "Landroidx/compose/ui/layout/MeasureScope;", "Landroidx/compose/ui/layout/Measurable;", "constraints", "Landroidx/compose/ui/unit/Constraints;", "measure-3p2s80s", "(Landroidx/compose/ui/layout/MeasureScope;Ljava/util/List;J)Landroidx/compose/ui/layout/MeasureResult;", "minIntrinsicHeight", "minIntrinsicWidth", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
final class ListItemMeasurePolicy implements MultiContentMeasurePolicy {
    @Override
    public MeasureResult mo983measure3p2s80s(MeasureScope measureScope, List<? extends List<? extends Measurable>> list, long j) {
        List<? extends Measurable> list2 = list.get(0);
        List<? extends Measurable> list3 = list.get(1);
        List<? extends Measurable> list4 = list.get(2);
        List<? extends Measurable> list5 = list.get(3);
        List<? extends Measurable> list6 = list.get(4);
        long j2 = Constraints.copy-Zbe2FdA$default(j, 0, 0, 0, 0, 10, (Object) null);
        float listItemStartPadding = ListItemKt.getListItemStartPadding();
        float listItemEndPadding = ListItemKt.getListItemEndPadding();
        int i = measureScope.roundToPx-0680j_4(Dp.constructor-impl(listItemStartPadding + listItemEndPadding));
        Measurable measurable = (Measurable) CollectionsKt.firstOrNull(list5);
        int iMinIntrinsicWidth = measurable != null ? measurable.minIntrinsicWidth(Constraints.getMaxHeight-impl(j)) : 0;
        Measurable measurable2 = (Measurable) CollectionsKt.firstOrNull(list6);
        int iSubtractConstraintSafely = ListItemKt.subtractConstraintSafely(Constraints.getMaxWidth-impl(j2), iMinIntrinsicWidth + (measurable2 != null ? measurable2.minIntrinsicWidth(Constraints.getMaxHeight-impl(j)) : 0) + i);
        Measurable measurable3 = (Measurable) CollectionsKt.firstOrNull(list4);
        float f = 2;
        long j3 = ConstraintsKt.offset-NN6Ew-U(j2, -i, -measureScope.roundToPx-0680j_4(Dp.constructor-impl(ListItemKt.m2488verticalPaddingyh95HIg(ListItemType.INSTANCE.m2501invokeZLSjz4$material3_release(CollectionsKt.firstOrNull(list3) != null, CollectionsKt.firstOrNull(list4) != null, ListItemKt.isSupportingMultilineHeuristic(measureScope, measurable3 != null ? measurable3.minIntrinsicHeight(iSubtractConstraintSafely) : 0))) * f)));
        Measurable measurable4 = (Measurable) CollectionsKt.firstOrNull(list5);
        Placeable placeableMo6026measureBRTryo0 = measurable4 != null ? measurable4.mo6026measureBRTryo0(j3) : null;
        int iWidthOrZero = TextFieldImplKt.widthOrZero(placeableMo6026measureBRTryo0);
        Measurable measurable5 = (Measurable) CollectionsKt.firstOrNull(list6);
        Placeable placeableMo6026measureBRTryo1 = measurable5 != null ? measurable5.mo6026measureBRTryo0(ConstraintsKt.offset-NN6Ew-U$default(j3, -iWidthOrZero, 0, 2, (Object) null)) : null;
        int iWidthOrZero2 = iWidthOrZero + TextFieldImplKt.widthOrZero(placeableMo6026measureBRTryo1);
        Measurable measurable6 = (Measurable) CollectionsKt.firstOrNull(list2);
        Placeable placeableMo6026measureBRTryo2 = measurable6 != null ? measurable6.mo6026measureBRTryo0(ConstraintsKt.offset-NN6Ew-U$default(j3, -iWidthOrZero2, 0, 2, (Object) null)) : null;
        int iHeightOrZero = TextFieldImplKt.heightOrZero(placeableMo6026measureBRTryo2);
        Measurable measurable7 = (Measurable) CollectionsKt.firstOrNull(list4);
        Placeable placeableMo6026measureBRTryo3 = measurable7 != null ? measurable7.mo6026measureBRTryo0(ConstraintsKt.offset-NN6Ew-U(j3, -iWidthOrZero2, -iHeightOrZero)) : null;
        int iHeightOrZero2 = iHeightOrZero + TextFieldImplKt.heightOrZero(placeableMo6026measureBRTryo3);
        boolean z = (placeableMo6026measureBRTryo3 == null || placeableMo6026measureBRTryo3.get(AlignmentLineKt.getFirstBaseline()) == placeableMo6026measureBRTryo3.get(AlignmentLineKt.getLastBaseline())) ? false : true;
        Measurable measurable8 = (Measurable) CollectionsKt.firstOrNull(list3);
        Placeable placeableMo6026measureBRTryo4 = measurable8 != null ? measurable8.mo6026measureBRTryo0(ConstraintsKt.offset-NN6Ew-U(j3, -iWidthOrZero2, -iHeightOrZero2)) : null;
        int iM2501invokeZLSjz4$material3_release = ListItemType.INSTANCE.m2501invokeZLSjz4$material3_release(placeableMo6026measureBRTryo4 != null, placeableMo6026measureBRTryo3 != null, z);
        float fM2488verticalPaddingyh95HIg = ListItemKt.m2488verticalPaddingyh95HIg(iM2501invokeZLSjz4$material3_release);
        MeasureScope measureScope2 = measureScope;
        return ListItemKt.place(measureScope, ListItemKt.m2487calculateWidthyeHjK3Y(measureScope2, TextFieldImplKt.widthOrZero(placeableMo6026measureBRTryo0), TextFieldImplKt.widthOrZero(placeableMo6026measureBRTryo1), TextFieldImplKt.widthOrZero(placeableMo6026measureBRTryo2), TextFieldImplKt.widthOrZero(placeableMo6026measureBRTryo4), TextFieldImplKt.widthOrZero(placeableMo6026measureBRTryo3), i, j), ListItemKt.m2486calculateHeightN4Jib3Y(measureScope2, TextFieldImplKt.heightOrZero(placeableMo6026measureBRTryo0), TextFieldImplKt.heightOrZero(placeableMo6026measureBRTryo1), TextFieldImplKt.heightOrZero(placeableMo6026measureBRTryo2), TextFieldImplKt.heightOrZero(placeableMo6026measureBRTryo4), TextFieldImplKt.heightOrZero(placeableMo6026measureBRTryo3), iM2501invokeZLSjz4$material3_release, measureScope.roundToPx-0680j_4(Dp.constructor-impl(f * fM2488verticalPaddingyh95HIg)), j), placeableMo6026measureBRTryo0, placeableMo6026measureBRTryo1, placeableMo6026measureBRTryo2, placeableMo6026measureBRTryo4, placeableMo6026measureBRTryo3, ListItemType.m2493equalsimpl0(iM2501invokeZLSjz4$material3_release, ListItemType.INSTANCE.m2499getThreeLineAlXitO8()), measureScope.roundToPx-0680j_4(listItemStartPadding), measureScope.roundToPx-0680j_4(listItemEndPadding), measureScope.roundToPx-0680j_4(fM2488verticalPaddingyh95HIg));
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    class C12291 extends FunctionReferenceImpl implements Function2<IntrinsicMeasurable, Integer, Integer> {
        public static final C12291 INSTANCE = new C12291();

        C12291() {
            super(2, IntrinsicMeasurable.class, "maxIntrinsicHeight", "maxIntrinsicHeight(I)I", 0);
        }

        public final Integer invoke(IntrinsicMeasurable intrinsicMeasurable, int i) {
            return Integer.valueOf(intrinsicMeasurable.maxIntrinsicHeight(i));
        }

        public Object invoke(Object obj, Object obj2) {
            return invoke((IntrinsicMeasurable) obj, ((Number) obj2).intValue());
        }
    }

    @Override
    public int maxIntrinsicHeight(IntrinsicMeasureScope intrinsicMeasureScope, List<? extends List<? extends IntrinsicMeasurable>> list, int i) {
        return calculateIntrinsicHeight(intrinsicMeasureScope, list, i, C12291.INSTANCE);
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    class C12301 extends FunctionReferenceImpl implements Function2<IntrinsicMeasurable, Integer, Integer> {
        public static final C12301 INSTANCE = new C12301();

        C12301() {
            super(2, IntrinsicMeasurable.class, "maxIntrinsicWidth", "maxIntrinsicWidth(I)I", 0);
        }

        public final Integer invoke(IntrinsicMeasurable intrinsicMeasurable, int i) {
            return Integer.valueOf(intrinsicMeasurable.maxIntrinsicWidth(i));
        }

        public Object invoke(Object obj, Object obj2) {
            return invoke((IntrinsicMeasurable) obj, ((Number) obj2).intValue());
        }
    }

    @Override
    public int maxIntrinsicWidth(IntrinsicMeasureScope intrinsicMeasureScope, List<? extends List<? extends IntrinsicMeasurable>> list, int i) {
        return calculateIntrinsicWidth(intrinsicMeasureScope, list, i, C12301.INSTANCE);
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    class C12311 extends FunctionReferenceImpl implements Function2<IntrinsicMeasurable, Integer, Integer> {
        public static final C12311 INSTANCE = new C12311();

        C12311() {
            super(2, IntrinsicMeasurable.class, "minIntrinsicHeight", "minIntrinsicHeight(I)I", 0);
        }

        public final Integer invoke(IntrinsicMeasurable intrinsicMeasurable, int i) {
            return Integer.valueOf(intrinsicMeasurable.minIntrinsicHeight(i));
        }

        public Object invoke(Object obj, Object obj2) {
            return invoke((IntrinsicMeasurable) obj, ((Number) obj2).intValue());
        }
    }

    @Override
    public int minIntrinsicHeight(IntrinsicMeasureScope intrinsicMeasureScope, List<? extends List<? extends IntrinsicMeasurable>> list, int i) {
        return calculateIntrinsicHeight(intrinsicMeasureScope, list, i, C12311.INSTANCE);
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    class C12321 extends FunctionReferenceImpl implements Function2<IntrinsicMeasurable, Integer, Integer> {
        public static final C12321 INSTANCE = new C12321();

        C12321() {
            super(2, IntrinsicMeasurable.class, "minIntrinsicWidth", "minIntrinsicWidth(I)I", 0);
        }

        public final Integer invoke(IntrinsicMeasurable intrinsicMeasurable, int i) {
            return Integer.valueOf(intrinsicMeasurable.minIntrinsicWidth(i));
        }

        public Object invoke(Object obj, Object obj2) {
            return invoke((IntrinsicMeasurable) obj, ((Number) obj2).intValue());
        }
    }

    @Override
    public int minIntrinsicWidth(IntrinsicMeasureScope intrinsicMeasureScope, List<? extends List<? extends IntrinsicMeasurable>> list, int i) {
        return calculateIntrinsicWidth(intrinsicMeasureScope, list, i, C12321.INSTANCE);
    }

    private final int calculateIntrinsicWidth(IntrinsicMeasureScope intrinsicMeasureScope, List<? extends List<? extends IntrinsicMeasurable>> list, int i, Function2<? super IntrinsicMeasurable, ? super Integer, Integer> function2) {
        List<? extends IntrinsicMeasurable> list2 = list.get(0);
        List<? extends IntrinsicMeasurable> list3 = list.get(1);
        List<? extends IntrinsicMeasurable> list4 = list.get(2);
        List<? extends IntrinsicMeasurable> list5 = list.get(3);
        List<? extends IntrinsicMeasurable> list6 = list.get(4);
        IntrinsicMeasurable intrinsicMeasurable = (IntrinsicMeasurable) CollectionsKt.firstOrNull(list5);
        int iIntValue = intrinsicMeasurable != null ? ((Number) function2.invoke(intrinsicMeasurable, Integer.valueOf(i))).intValue() : 0;
        IntrinsicMeasurable intrinsicMeasurable2 = (IntrinsicMeasurable) CollectionsKt.firstOrNull(list6);
        int iIntValue2 = intrinsicMeasurable2 != null ? ((Number) function2.invoke(intrinsicMeasurable2, Integer.valueOf(i))).intValue() : 0;
        IntrinsicMeasurable intrinsicMeasurable3 = (IntrinsicMeasurable) CollectionsKt.firstOrNull(list2);
        int iIntValue3 = intrinsicMeasurable3 != null ? ((Number) function2.invoke(intrinsicMeasurable3, Integer.valueOf(i))).intValue() : 0;
        IntrinsicMeasurable intrinsicMeasurable4 = (IntrinsicMeasurable) CollectionsKt.firstOrNull(list3);
        int iIntValue4 = intrinsicMeasurable4 != null ? ((Number) function2.invoke(intrinsicMeasurable4, Integer.valueOf(i))).intValue() : 0;
        IntrinsicMeasurable intrinsicMeasurable5 = (IntrinsicMeasurable) CollectionsKt.firstOrNull(list4);
        return ListItemKt.m2487calculateWidthyeHjK3Y(intrinsicMeasureScope, iIntValue, iIntValue2, iIntValue3, iIntValue4, intrinsicMeasurable5 != null ? ((Number) function2.invoke(intrinsicMeasurable5, Integer.valueOf(i))).intValue() : 0, intrinsicMeasureScope.roundToPx-0680j_4(Dp.constructor-impl(ListItemKt.getListItemStartPadding() + ListItemKt.getListItemEndPadding())), ConstraintsKt.Constraints$default(0, 0, 0, 0, 15, (Object) null));
    }

    private final int calculateIntrinsicHeight(IntrinsicMeasureScope intrinsicMeasureScope, List<? extends List<? extends IntrinsicMeasurable>> list, int i, Function2<? super IntrinsicMeasurable, ? super Integer, Integer> function2) {
        int iIntValue;
        int iIntValue2;
        List<? extends IntrinsicMeasurable> list2 = list.get(0);
        List<? extends IntrinsicMeasurable> list3 = list.get(1);
        List<? extends IntrinsicMeasurable> list4 = list.get(2);
        List<? extends IntrinsicMeasurable> list5 = list.get(3);
        List<? extends IntrinsicMeasurable> list6 = list.get(4);
        int iSubtractConstraintSafely = ListItemKt.subtractConstraintSafely(i, intrinsicMeasureScope.roundToPx-0680j_4(Dp.constructor-impl(ListItemKt.getListItemStartPadding() + ListItemKt.getListItemEndPadding())));
        IntrinsicMeasurable intrinsicMeasurable = (IntrinsicMeasurable) CollectionsKt.firstOrNull(list5);
        if (intrinsicMeasurable != null) {
            iIntValue = ((Number) function2.invoke(intrinsicMeasurable, Integer.valueOf(iSubtractConstraintSafely))).intValue();
            iSubtractConstraintSafely = ListItemKt.subtractConstraintSafely(iSubtractConstraintSafely, intrinsicMeasurable.maxIntrinsicWidth(Integer.MAX_VALUE));
        } else {
            iIntValue = 0;
        }
        IntrinsicMeasurable intrinsicMeasurable2 = (IntrinsicMeasurable) CollectionsKt.firstOrNull(list6);
        if (intrinsicMeasurable2 != null) {
            iIntValue2 = ((Number) function2.invoke(intrinsicMeasurable2, Integer.valueOf(iSubtractConstraintSafely))).intValue();
            iSubtractConstraintSafely = ListItemKt.subtractConstraintSafely(iSubtractConstraintSafely, intrinsicMeasurable2.maxIntrinsicWidth(Integer.MAX_VALUE));
        } else {
            iIntValue2 = 0;
        }
        IntrinsicMeasurable intrinsicMeasurable3 = (IntrinsicMeasurable) CollectionsKt.firstOrNull(list3);
        int iIntValue3 = intrinsicMeasurable3 != null ? ((Number) function2.invoke(intrinsicMeasurable3, Integer.valueOf(iSubtractConstraintSafely))).intValue() : 0;
        IntrinsicMeasurable intrinsicMeasurable4 = (IntrinsicMeasurable) CollectionsKt.firstOrNull(list4);
        int iIntValue4 = intrinsicMeasurable4 != null ? ((Number) function2.invoke(intrinsicMeasurable4, Integer.valueOf(iSubtractConstraintSafely))).intValue() : 0;
        int iM2501invokeZLSjz4$material3_release = ListItemType.INSTANCE.m2501invokeZLSjz4$material3_release(iIntValue3 > 0, iIntValue4 > 0, ListItemKt.isSupportingMultilineHeuristic(intrinsicMeasureScope, iIntValue4));
        IntrinsicMeasurable intrinsicMeasurable5 = (IntrinsicMeasurable) CollectionsKt.firstOrNull(list2);
        return ListItemKt.m2486calculateHeightN4Jib3Y(intrinsicMeasureScope, iIntValue, iIntValue2, intrinsicMeasurable5 != null ? ((Number) function2.invoke(intrinsicMeasurable5, Integer.valueOf(i))).intValue() : 0, iIntValue3, iIntValue4, iM2501invokeZLSjz4$material3_release, intrinsicMeasureScope.roundToPx-0680j_4(Dp.constructor-impl(ListItemKt.m2488verticalPaddingyh95HIg(iM2501invokeZLSjz4$material3_release) * 2)), ConstraintsKt.Constraints$default(0, 0, 0, 0, 15, (Object) null));
    }
}
