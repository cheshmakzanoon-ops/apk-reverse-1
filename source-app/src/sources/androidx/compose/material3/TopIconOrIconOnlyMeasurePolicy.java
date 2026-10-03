package androidx.compose.material3;

import androidx.compose.material3.internal.TextFieldImplKt;
import androidx.compose.p002ui.layout.IntrinsicMeasurable;
import androidx.compose.p002ui.layout.IntrinsicMeasureScope;
import androidx.compose.p002ui.layout.LayoutIdKt;
import androidx.compose.p002ui.layout.Measurable;
import androidx.compose.p002ui.layout.MeasurePolicy;
import androidx.compose.p002ui.layout.MeasureResult;
import androidx.compose.p002ui.layout.MeasureScope;
import androidx.compose.p002ui.layout.Placeable;
import androidx.compose.ui.unit.Constraints;
import androidx.compose.ui.unit.ConstraintsKt;
import androidx.compose.ui.unit.Dp;
import java.util.List;
import java.util.NoSuchElementException;
import kotlin.Metadata;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.math.MathKt;

@Metadata(d1 = {"\u0000N\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0007\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u000f\n\u0002\u0010\b\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0002\u0018\u00002\u00020\u0001B;\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\f\u0010\u0004\u001a\b\u0012\u0004\u0012\u00020\u00060\u0005\u0012\u0006\u0010\u0007\u001a\u00020\b\u0012\u0006\u0010\t\u001a\u00020\b\u0012\u0006\u0010\n\u001a\u00020\b\u0012\u0006\u0010\u000b\u001a\u00020\b¢\u0006\u0002\u0010\fJ\"\u0010\u0017\u001a\u00020\u0018*\u00020\u00192\f\u0010\u001a\u001a\b\u0012\u0004\u0012\u00020\u001c0\u001b2\u0006\u0010\u001d\u001a\u00020\u0018H\u0016J,\u0010\u001e\u001a\u00020\u001f*\u00020 2\f\u0010\u001a\u001a\b\u0012\u0004\u0012\u00020!0\u001b2\u0006\u0010\"\u001a\u00020#H\u0016ø\u0001\u0000¢\u0006\u0004\b$\u0010%R\u0017\u0010\u0004\u001a\b\u0012\u0004\u0012\u00020\u00060\u0005¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000eR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010R\u0019\u0010\u0007\u001a\u00020\bø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0013\u001a\u0004\b\u0011\u0010\u0012R\u0019\u0010\n\u001a\u00020\bø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0013\u001a\u0004\b\u0014\u0010\u0012R\u0019\u0010\t\u001a\u00020\bø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0013\u001a\u0004\b\u0015\u0010\u0012R\u0019\u0010\u000b\u001a\u00020\bø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0013\u001a\u0004\b\u0016\u0010\u0012\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006&"}, d2 = {"Landroidx/compose/material3/TopIconOrIconOnlyMeasurePolicy;", "Landroidx/compose/ui/layout/MeasurePolicy;", "hasLabel", "", "animationProgress", "Lkotlin/Function0;", "", "indicatorHorizontalPadding", "Landroidx/compose/ui/unit/Dp;", "indicatorVerticalPadding", "indicatorToLabelVerticalPadding", "topIconItemVerticalPadding", "(ZLkotlin/jvm/functions/Function0;FFFFLkotlin/jvm/internal/DefaultConstructorMarker;)V", "getAnimationProgress", "()Lkotlin/jvm/functions/Function0;", "getHasLabel", "()Z", "getIndicatorHorizontalPadding-D9Ej5fM", "()F", "F", "getIndicatorToLabelVerticalPadding-D9Ej5fM", "getIndicatorVerticalPadding-D9Ej5fM", "getTopIconItemVerticalPadding-D9Ej5fM", "maxIntrinsicHeight", "", "Landroidx/compose/ui/layout/IntrinsicMeasureScope;", "measurables", "", "Landroidx/compose/ui/layout/IntrinsicMeasurable;", "width", "measure", "Landroidx/compose/ui/layout/MeasureResult;", "Landroidx/compose/ui/layout/MeasureScope;", "Landroidx/compose/ui/layout/Measurable;", "constraints", "Landroidx/compose/ui/unit/Constraints;", "measure-3p2s80s", "(Landroidx/compose/ui/layout/MeasureScope;Ljava/util/List;J)Landroidx/compose/ui/layout/MeasureResult;", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
final class TopIconOrIconOnlyMeasurePolicy implements MeasurePolicy {
    private final Function0<Float> animationProgress;
    private final boolean hasLabel;
    private final float indicatorHorizontalPadding;
    private final float indicatorToLabelVerticalPadding;
    private final float indicatorVerticalPadding;
    private final float topIconItemVerticalPadding;

    public TopIconOrIconOnlyMeasurePolicy(boolean z, Function0 function0, float f, float f2, float f3, float f4, DefaultConstructorMarker defaultConstructorMarker) {
        this(z, function0, f, f2, f3, f4);
    }

    @Override
    public int maxIntrinsicWidth(IntrinsicMeasureScope intrinsicMeasureScope, List list, int i) {
        return MeasurePolicy.CC.$default$maxIntrinsicWidth(this, intrinsicMeasureScope, list, i);
    }

    @Override
    public int minIntrinsicHeight(IntrinsicMeasureScope intrinsicMeasureScope, List list, int i) {
        return MeasurePolicy.CC.$default$minIntrinsicHeight(this, intrinsicMeasureScope, list, i);
    }

    @Override
    public int minIntrinsicWidth(IntrinsicMeasureScope intrinsicMeasureScope, List list, int i) {
        return MeasurePolicy.CC.$default$minIntrinsicWidth(this, intrinsicMeasureScope, list, i);
    }

    private TopIconOrIconOnlyMeasurePolicy(boolean z, Function0<Float> function0, float f, float f2, float f3, float f4) {
        this.hasLabel = z;
        this.animationProgress = function0;
        this.indicatorHorizontalPadding = f;
        this.indicatorVerticalPadding = f2;
        this.indicatorToLabelVerticalPadding = f3;
        this.topIconItemVerticalPadding = f4;
    }

    public final boolean getHasLabel() {
        return this.hasLabel;
    }

    public final Function0<Float> getAnimationProgress() {
        return this.animationProgress;
    }

    public final float getIndicatorHorizontalPadding() {
        return this.indicatorHorizontalPadding;
    }

    public final float getIndicatorVerticalPadding() {
        return this.indicatorVerticalPadding;
    }

    public final float getIndicatorToLabelVerticalPadding() {
        return this.indicatorToLabelVerticalPadding;
    }

    public final float getTopIconItemVerticalPadding() {
        return this.topIconItemVerticalPadding;
    }

    @Override
    public MeasureResult mo296measure3p2s80s(MeasureScope measureScope, List<? extends Measurable> list, long j) {
        float fFloatValue = ((Number) this.animationProgress.invoke()).floatValue();
        long j2 = Constraints.copy-Zbe2FdA$default(j, 0, 0, 0, 0, 10, (Object) null);
        int size = list.size();
        for (int i = 0; i < size; i++) {
            Measurable measurable = list.get(i);
            if (Intrinsics.areEqual(LayoutIdKt.getLayoutId(measurable), "icon")) {
                float f = 2;
                Placeable placeableMo6026measureBRTryo0 = measurable.mo6026measureBRTryo0(ConstraintsKt.offset-NN6Ew-U(j2, -measureScope.roundToPx-0680j_4(Dp.constructor-impl(this.indicatorHorizontalPadding * f)), -measureScope.roundToPx-0680j_4(Dp.constructor-impl(this.indicatorVerticalPadding * f))));
                int width = placeableMo6026measureBRTryo0.getWidth() + measureScope.roundToPx-0680j_4(Dp.constructor-impl(this.indicatorHorizontalPadding * f));
                int height = placeableMo6026measureBRTryo0.getHeight() + measureScope.roundToPx-0680j_4(Dp.constructor-impl(this.indicatorVerticalPadding * f));
                int iRoundToInt = MathKt.roundToInt(width * fFloatValue);
                int size2 = list.size();
                for (int i2 = 0; i2 < size2; i2++) {
                    Measurable measurable2 = list.get(i2);
                    if (Intrinsics.areEqual(LayoutIdKt.getLayoutId(measurable2), "indicatorRipple")) {
                        Placeable placeableMo6026measureBRTryo1 = measurable2.mo6026measureBRTryo0(ConstraintsKt.constrain-N9IONVI(j2, Constraints.Companion.fixed-JhjzzOo(width, height)));
                        int size3 = list.size();
                        for (int i3 = 0; i3 < size3; i3++) {
                            Measurable measurable3 = list.get(i3);
                            if (Intrinsics.areEqual(LayoutIdKt.getLayoutId(measurable3), "indicator")) {
                                Placeable placeableMo6026measureBRTryo2 = measurable3.mo6026measureBRTryo0(ConstraintsKt.constrain-N9IONVI(j2, Constraints.Companion.fixed-JhjzzOo(iRoundToInt, height)));
                                if (!this.hasLabel) {
                                    return NavigationItemKt.m2620placeIconX9ElhV4(measureScope, placeableMo6026measureBRTryo0, placeableMo6026measureBRTryo1, placeableMo6026measureBRTryo2, j);
                                }
                                int size4 = list.size();
                                for (int i4 = 0; i4 < size4; i4++) {
                                    Measurable measurable4 = list.get(i4);
                                    if (Intrinsics.areEqual(LayoutIdKt.getLayoutId(measurable4), "label")) {
                                        return NavigationItemKt.m2622placeLabelAndTopIconqoqLrGI(measureScope, measurable4.mo6026measureBRTryo0(ConstraintsKt.offset-NN6Ew-U$default(j2, 0, -(placeableMo6026measureBRTryo2.getHeight() + measureScope.roundToPx-0680j_4(this.indicatorToLabelVerticalPadding)), 1, (Object) null)), placeableMo6026measureBRTryo0, placeableMo6026measureBRTryo1, placeableMo6026measureBRTryo2, j, this.indicatorToLabelVerticalPadding, this.indicatorVerticalPadding, this.topIconItemVerticalPadding);
                                    }
                                }
                                throw new NoSuchElementException("Collection contains no element matching the predicate.");
                            }
                        }
                        throw new NoSuchElementException("Collection contains no element matching the predicate.");
                    }
                }
                throw new NoSuchElementException("Collection contains no element matching the predicate.");
            }
        }
        throw new NoSuchElementException("Collection contains no element matching the predicate.");
    }

    @Override
    public int maxIntrinsicHeight(IntrinsicMeasureScope intrinsicMeasureScope, List<? extends IntrinsicMeasurable> list, int i) {
        IntrinsicMeasurable intrinsicMeasurable;
        int size = list.size();
        for (int i2 = 0; i2 < size; i2++) {
            IntrinsicMeasurable intrinsicMeasurable2 = list.get(i2);
            if (Intrinsics.areEqual(TextFieldImplKt.getLayoutId(intrinsicMeasurable2), "icon")) {
                int iMaxIntrinsicHeight = intrinsicMeasurable2.maxIntrinsicHeight(i);
                int size2 = list.size();
                int i3 = 0;
                while (true) {
                    if (i3 >= size2) {
                        intrinsicMeasurable = null;
                        break;
                    }
                    intrinsicMeasurable = list.get(i3);
                    if (Intrinsics.areEqual(TextFieldImplKt.getLayoutId(intrinsicMeasurable), "label")) {
                        break;
                    }
                    i3++;
                }
                IntrinsicMeasurable intrinsicMeasurable3 = intrinsicMeasurable;
                int iMaxIntrinsicHeight2 = intrinsicMeasurable3 != null ? intrinsicMeasurable3.maxIntrinsicHeight(i) : 0;
                float f = 2;
                return iMaxIntrinsicHeight + iMaxIntrinsicHeight2 + intrinsicMeasureScope.roundToPx-0680j_4(Dp.constructor-impl(Dp.constructor-impl(Dp.constructor-impl(this.topIconItemVerticalPadding * f) + Dp.constructor-impl(this.indicatorVerticalPadding * f)) + this.indicatorToLabelVerticalPadding));
            }
        }
        throw new NoSuchElementException("Collection contains no element matching the predicate.");
    }
}
