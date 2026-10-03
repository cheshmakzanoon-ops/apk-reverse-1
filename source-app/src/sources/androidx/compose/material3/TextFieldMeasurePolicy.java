package androidx.compose.material3;

import androidx.compose.foundation.layout.PaddingValues;
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
import java.util.List;
import java.util.NoSuchElementException;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000T\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0007\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0002\u0018\u00002\u00020\u0001B\u001d\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\bJ8\u0010\t\u001a\u00020\n2\f\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\r0\f2\u0006\u0010\u000e\u001a\u00020\n2\u0018\u0010\u000f\u001a\u0014\u0012\u0004\u0012\u00020\r\u0012\u0004\u0012\u00020\n\u0012\u0004\u0012\u00020\n0\u0010H\u0002J<\u0010\u0011\u001a\u00020\n*\u00020\u00122\f\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\r0\f2\u0006\u0010\u0013\u001a\u00020\n2\u0018\u0010\u000f\u001a\u0014\u0012\u0004\u0012\u00020\r\u0012\u0004\u0012\u00020\n\u0012\u0004\u0012\u00020\n0\u0010H\u0002J\"\u0010\u0014\u001a\u00020\n*\u00020\u00122\f\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\r0\f2\u0006\u0010\u0013\u001a\u00020\nH\u0016J\"\u0010\u0015\u001a\u00020\n*\u00020\u00122\f\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\r0\f2\u0006\u0010\u000e\u001a\u00020\nH\u0016J,\u0010\u0016\u001a\u00020\u0017*\u00020\u00182\f\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\u00190\f2\u0006\u0010\u001a\u001a\u00020\u001bH\u0016ø\u0001\u0000¢\u0006\u0004\b\u001c\u0010\u001dJ\"\u0010\u001e\u001a\u00020\n*\u00020\u00122\f\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\r0\f2\u0006\u0010\u0013\u001a\u00020\nH\u0016J\"\u0010\u001f\u001a\u00020\n*\u00020\u00122\f\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\r0\f2\u0006\u0010\u000e\u001a\u00020\nH\u0016R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006 "}, d2 = {"Landroidx/compose/material3/TextFieldMeasurePolicy;", "Landroidx/compose/ui/layout/MeasurePolicy;", "singleLine", "", "animationProgress", "", "paddingValues", "Landroidx/compose/foundation/layout/PaddingValues;", "(ZFLandroidx/compose/foundation/layout/PaddingValues;)V", "intrinsicWidth", "", "measurables", "", "Landroidx/compose/ui/layout/IntrinsicMeasurable;", "height", "intrinsicMeasurer", "Lkotlin/Function2;", "intrinsicHeight", "Landroidx/compose/ui/layout/IntrinsicMeasureScope;", "width", "maxIntrinsicHeight", "maxIntrinsicWidth", "measure", "Landroidx/compose/ui/layout/MeasureResult;", "Landroidx/compose/ui/layout/MeasureScope;", "Landroidx/compose/ui/layout/Measurable;", "constraints", "Landroidx/compose/ui/unit/Constraints;", "measure-3p2s80s", "(Landroidx/compose/ui/layout/MeasureScope;Ljava/util/List;J)Landroidx/compose/ui/layout/MeasureResult;", "minIntrinsicHeight", "minIntrinsicWidth", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
final class TextFieldMeasurePolicy implements MeasurePolicy {
    private final float animationProgress;
    private final PaddingValues paddingValues;
    private final boolean singleLine;

    public TextFieldMeasurePolicy(boolean z, float f, PaddingValues paddingValues) {
        this.singleLine = z;
        this.animationProgress = f;
        this.paddingValues = paddingValues;
    }

    @Override
    public MeasureResult mo296measure3p2s80s(final MeasureScope measureScope, List<? extends Measurable> list, long j) {
        Measurable measurable;
        Measurable measurable2;
        Measurable measurable3;
        Measurable measurable4;
        Measurable measurable5;
        Measurable measurable6;
        Measurable measurable7;
        List<? extends Measurable> list2 = list;
        final int i = measureScope.roundToPx-0680j_4(this.paddingValues.getTop());
        int i2 = measureScope.roundToPx-0680j_4(this.paddingValues.getBottom());
        long j2 = Constraints.copy-Zbe2FdA$default(j, 0, 0, 0, 0, 10, (Object) null);
        int size = list.size();
        int i3 = 0;
        while (true) {
            if (i3 >= size) {
                measurable = null;
                break;
            }
            measurable = list2.get(i3);
            if (Intrinsics.areEqual(LayoutIdKt.getLayoutId(measurable), TextFieldImplKt.LeadingId)) {
                break;
            }
            i3++;
        }
        Measurable measurable8 = measurable;
        final Placeable placeableMo6026measureBRTryo0 = measurable8 != null ? measurable8.mo6026measureBRTryo0(j2) : null;
        int iWidthOrZero = TextFieldImplKt.widthOrZero(placeableMo6026measureBRTryo0);
        int iMax = Math.max(0, TextFieldImplKt.heightOrZero(placeableMo6026measureBRTryo0));
        int size2 = list.size();
        int i4 = 0;
        while (true) {
            if (i4 >= size2) {
                measurable2 = null;
                break;
            }
            measurable2 = list2.get(i4);
            if (Intrinsics.areEqual(LayoutIdKt.getLayoutId(measurable2), TextFieldImplKt.TrailingId)) {
                break;
            }
            i4++;
        }
        Measurable measurable9 = measurable2;
        Placeable placeableMo6026measureBRTryo1 = measurable9 != null ? measurable9.mo6026measureBRTryo0(ConstraintsKt.offset-NN6Ew-U$default(j2, -iWidthOrZero, 0, 2, (Object) null)) : null;
        int iWidthOrZero2 = iWidthOrZero + TextFieldImplKt.widthOrZero(placeableMo6026measureBRTryo1);
        int iMax2 = Math.max(iMax, TextFieldImplKt.heightOrZero(placeableMo6026measureBRTryo1));
        int size3 = list.size();
        int i5 = 0;
        while (true) {
            if (i5 >= size3) {
                measurable3 = null;
                break;
            }
            measurable3 = list2.get(i5);
            if (Intrinsics.areEqual(LayoutIdKt.getLayoutId(measurable3), TextFieldImplKt.PrefixId)) {
                break;
            }
            i5++;
        }
        Measurable measurable10 = measurable3;
        final Placeable placeableMo6026measureBRTryo2 = measurable10 != null ? measurable10.mo6026measureBRTryo0(ConstraintsKt.offset-NN6Ew-U$default(j2, -iWidthOrZero2, 0, 2, (Object) null)) : null;
        int iWidthOrZero3 = iWidthOrZero2 + TextFieldImplKt.widthOrZero(placeableMo6026measureBRTryo2);
        int iMax3 = Math.max(iMax2, TextFieldImplKt.heightOrZero(placeableMo6026measureBRTryo2));
        int size4 = list.size();
        int i6 = 0;
        while (true) {
            if (i6 >= size4) {
                measurable4 = null;
                break;
            }
            measurable4 = list2.get(i6);
            int i7 = size4;
            if (Intrinsics.areEqual(LayoutIdKt.getLayoutId(measurable4), TextFieldImplKt.SuffixId)) {
                break;
            }
            i6++;
            size4 = i7;
        }
        Measurable measurable11 = measurable4;
        Placeable placeableMo6026measureBRTryo3 = measurable11 != null ? measurable11.mo6026measureBRTryo0(ConstraintsKt.offset-NN6Ew-U$default(j2, -iWidthOrZero3, 0, 2, (Object) null)) : null;
        int iWidthOrZero4 = iWidthOrZero3 + TextFieldImplKt.widthOrZero(placeableMo6026measureBRTryo3);
        int iMax4 = Math.max(iMax3, TextFieldImplKt.heightOrZero(placeableMo6026measureBRTryo3));
        int i8 = -iWidthOrZero4;
        long j3 = ConstraintsKt.offset-NN6Ew-U(j2, i8, -i2);
        int size5 = list.size();
        int i9 = 0;
        while (true) {
            if (i9 >= size5) {
                measurable5 = null;
                break;
            }
            Measurable measurable12 = list2.get(i9);
            int i10 = size5;
            if (Intrinsics.areEqual(LayoutIdKt.getLayoutId(measurable12), TextFieldImplKt.LabelId)) {
                measurable5 = measurable12;
                break;
            }
            i9++;
            size5 = i10;
        }
        Measurable measurable13 = measurable5;
        Placeable placeableMo6026measureBRTryo4 = measurable13 != null ? measurable13.mo6026measureBRTryo0(j3) : null;
        int size6 = list.size();
        int i11 = 0;
        while (true) {
            if (i11 >= size6) {
                measurable6 = null;
                break;
            }
            measurable6 = list2.get(i11);
            int i12 = size6;
            if (Intrinsics.areEqual(LayoutIdKt.getLayoutId(measurable6), TextFieldImplKt.SupportingId)) {
                break;
            }
            i11++;
            size6 = i12;
        }
        Measurable measurable14 = measurable6;
        int iMinIntrinsicHeight = measurable14 != null ? measurable14.minIntrinsicHeight(Constraints.getMinWidth-impl(j)) : 0;
        int iHeightOrZero = TextFieldImplKt.heightOrZero(placeableMo6026measureBRTryo4) + i;
        long j4 = ConstraintsKt.offset-NN6Ew-U(Constraints.copy-Zbe2FdA$default(j, 0, 0, 0, 0, 11, (Object) null), i8, ((-iHeightOrZero) - i2) - iMinIntrinsicHeight);
        int size7 = list.size();
        int i13 = 0;
        while (i13 < size7) {
            int i14 = size7;
            Measurable measurable15 = list2.get(i13);
            int i15 = i13;
            if (Intrinsics.areEqual(LayoutIdKt.getLayoutId(measurable15), TextFieldImplKt.TextFieldId)) {
                final Placeable placeableMo6026measureBRTryo5 = measurable15.mo6026measureBRTryo0(j4);
                long j5 = Constraints.copy-Zbe2FdA$default(j4, 0, 0, 0, 0, 14, (Object) null);
                int size8 = list.size();
                int i16 = 0;
                while (true) {
                    if (i16 >= size8) {
                        measurable7 = null;
                        break;
                    }
                    measurable7 = list2.get(i16);
                    int i17 = size8;
                    if (Intrinsics.areEqual(LayoutIdKt.getLayoutId(measurable7), TextFieldImplKt.PlaceholderId)) {
                        break;
                    }
                    i16++;
                    list2 = list;
                    size8 = i17;
                }
                Measurable measurable16 = measurable7;
                Placeable placeableMo6026measureBRTryo6 = measurable16 != null ? measurable16.mo6026measureBRTryo0(j5) : null;
                int iMax5 = Math.max(iMax4, Math.max(TextFieldImplKt.heightOrZero(placeableMo6026measureBRTryo5), TextFieldImplKt.heightOrZero(placeableMo6026measureBRTryo6)) + iHeightOrZero + i2);
                final int iM3019calculateWidthyeHjK3Y = TextFieldKt.m3019calculateWidthyeHjK3Y(TextFieldImplKt.widthOrZero(placeableMo6026measureBRTryo0), TextFieldImplKt.widthOrZero(placeableMo6026measureBRTryo1), TextFieldImplKt.widthOrZero(placeableMo6026measureBRTryo2), TextFieldImplKt.widthOrZero(placeableMo6026measureBRTryo3), placeableMo6026measureBRTryo5.getWidth(), TextFieldImplKt.widthOrZero(placeableMo6026measureBRTryo4), TextFieldImplKt.widthOrZero(placeableMo6026measureBRTryo6), j);
                Placeable placeableMo6026measureBRTryo7 = measurable14 != null ? measurable14.mo6026measureBRTryo0(Constraints.copy-Zbe2FdA$default(ConstraintsKt.offset-NN6Ew-U$default(j2, 0, -iMax5, 1, (Object) null), 0, iM3019calculateWidthyeHjK3Y, 0, 0, 9, (Object) null)) : null;
                int iHeightOrZero2 = TextFieldImplKt.heightOrZero(placeableMo6026measureBRTryo7);
                final int iM3018calculateHeightmKXJcVc = TextFieldKt.m3018calculateHeightmKXJcVc(placeableMo6026measureBRTryo5.getHeight(), TextFieldImplKt.heightOrZero(placeableMo6026measureBRTryo4), TextFieldImplKt.heightOrZero(placeableMo6026measureBRTryo0), TextFieldImplKt.heightOrZero(placeableMo6026measureBRTryo1), TextFieldImplKt.heightOrZero(placeableMo6026measureBRTryo2), TextFieldImplKt.heightOrZero(placeableMo6026measureBRTryo3), TextFieldImplKt.heightOrZero(placeableMo6026measureBRTryo6), TextFieldImplKt.heightOrZero(placeableMo6026measureBRTryo7), this.animationProgress, j, measureScope.getDensity(), this.paddingValues);
                int i18 = iM3018calculateHeightmKXJcVc - iHeightOrZero2;
                int size9 = list.size();
                for (int i19 = 0; i19 < size9; i19++) {
                    Measurable measurable17 = list.get(i19);
                    if (Intrinsics.areEqual(LayoutIdKt.getLayoutId(measurable17), TextFieldImplKt.ContainerId)) {
                        final Placeable placeableMo6026measureBRTryo8 = measurable17.mo6026measureBRTryo0(ConstraintsKt.Constraints(iM3019calculateWidthyeHjK3Y != Integer.MAX_VALUE ? iM3019calculateWidthyeHjK3Y : 0, iM3019calculateWidthyeHjK3Y, i18 != Integer.MAX_VALUE ? i18 : 0, i18));
                        final Placeable placeable = placeableMo6026measureBRTryo4;
                        final Placeable placeable2 = placeableMo6026measureBRTryo6;
                        final Placeable placeable3 = placeableMo6026measureBRTryo1;
                        final Placeable placeable4 = placeableMo6026measureBRTryo3;
                        final Placeable placeable5 = placeableMo6026measureBRTryo7;
                        return MeasureScope.CC.layout$default(measureScope, iM3019calculateWidthyeHjK3Y, iM3018calculateHeightmKXJcVc, null, new Function1<Placeable.PlacementScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((Placeable.PlacementScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Placeable.PlacementScope placementScope) {
                                Placeable placeable6 = placeable;
                                if (placeable6 == null) {
                                    TextFieldKt.placeWithoutLabel(placementScope, iM3019calculateWidthyeHjK3Y, iM3018calculateHeightmKXJcVc, placeableMo6026measureBRTryo5, placeable2, placeableMo6026measureBRTryo0, placeable3, placeableMo6026measureBRTryo2, placeable4, placeableMo6026measureBRTryo8, placeable5, this.singleLine, measureScope.getDensity(), this.paddingValues);
                                    return;
                                }
                                int i20 = iM3019calculateWidthyeHjK3Y;
                                int i21 = iM3018calculateHeightmKXJcVc;
                                Placeable placeable7 = placeableMo6026measureBRTryo5;
                                Placeable placeable8 = placeable2;
                                Placeable placeable9 = placeableMo6026measureBRTryo0;
                                Placeable placeable10 = placeable3;
                                Placeable placeable11 = placeableMo6026measureBRTryo2;
                                Placeable placeable12 = placeable4;
                                Placeable placeable13 = placeableMo6026measureBRTryo8;
                                Placeable placeable14 = placeable5;
                                boolean z = this.singleLine;
                                int i22 = i;
                                TextFieldKt.placeWithLabel(placementScope, i20, i21, placeable7, placeable6, placeable8, placeable9, placeable10, placeable11, placeable12, placeable13, placeable14, z, i22, placeable.getHeight() + i22, this.animationProgress, measureScope.getDensity());
                            }
                        }, 4, null);
                    }
                }
                throw new NoSuchElementException("Collection contains no element matching the predicate.");
            }
            i13 = i15 + 1;
            size7 = i14;
            list2 = list;
        }
        throw new NoSuchElementException("Collection contains no element matching the predicate.");
    }

    @Override
    public int maxIntrinsicHeight(IntrinsicMeasureScope intrinsicMeasureScope, List<? extends IntrinsicMeasurable> list, int i) {
        return intrinsicHeight(intrinsicMeasureScope, list, i, new Function2<IntrinsicMeasurable, Integer, Integer>() {
            public Object invoke(Object obj, Object obj2) {
                return invoke((IntrinsicMeasurable) obj, ((Number) obj2).intValue());
            }

            public final Integer invoke(IntrinsicMeasurable intrinsicMeasurable, int i2) {
                return Integer.valueOf(intrinsicMeasurable.maxIntrinsicHeight(i2));
            }
        });
    }

    @Override
    public int minIntrinsicHeight(IntrinsicMeasureScope intrinsicMeasureScope, List<? extends IntrinsicMeasurable> list, int i) {
        return intrinsicHeight(intrinsicMeasureScope, list, i, new Function2<IntrinsicMeasurable, Integer, Integer>() {
            public Object invoke(Object obj, Object obj2) {
                return invoke((IntrinsicMeasurable) obj, ((Number) obj2).intValue());
            }

            public final Integer invoke(IntrinsicMeasurable intrinsicMeasurable, int i2) {
                return Integer.valueOf(intrinsicMeasurable.minIntrinsicHeight(i2));
            }
        });
    }

    @Override
    public int maxIntrinsicWidth(IntrinsicMeasureScope intrinsicMeasureScope, List<? extends IntrinsicMeasurable> list, int i) {
        return intrinsicWidth(list, i, new Function2<IntrinsicMeasurable, Integer, Integer>() {
            public Object invoke(Object obj, Object obj2) {
                return invoke((IntrinsicMeasurable) obj, ((Number) obj2).intValue());
            }

            public final Integer invoke(IntrinsicMeasurable intrinsicMeasurable, int i2) {
                return Integer.valueOf(intrinsicMeasurable.maxIntrinsicWidth(i2));
            }
        });
    }

    @Override
    public int minIntrinsicWidth(IntrinsicMeasureScope intrinsicMeasureScope, List<? extends IntrinsicMeasurable> list, int i) {
        return intrinsicWidth(list, i, new Function2<IntrinsicMeasurable, Integer, Integer>() {
            public Object invoke(Object obj, Object obj2) {
                return invoke((IntrinsicMeasurable) obj, ((Number) obj2).intValue());
            }

            public final Integer invoke(IntrinsicMeasurable intrinsicMeasurable, int i2) {
                return Integer.valueOf(intrinsicMeasurable.minIntrinsicWidth(i2));
            }
        });
    }

    private final int intrinsicWidth(List<? extends IntrinsicMeasurable> measurables, int height, Function2<? super IntrinsicMeasurable, ? super Integer, Integer> intrinsicMeasurer) {
        IntrinsicMeasurable intrinsicMeasurable;
        IntrinsicMeasurable intrinsicMeasurable2;
        IntrinsicMeasurable intrinsicMeasurable3;
        IntrinsicMeasurable intrinsicMeasurable4;
        IntrinsicMeasurable intrinsicMeasurable5;
        IntrinsicMeasurable intrinsicMeasurable6;
        int size = measurables.size();
        for (int i = 0; i < size; i++) {
            IntrinsicMeasurable intrinsicMeasurable7 = measurables.get(i);
            if (Intrinsics.areEqual(TextFieldImplKt.getLayoutId(intrinsicMeasurable7), TextFieldImplKt.TextFieldId)) {
                int iIntValue = ((Number) intrinsicMeasurer.invoke(intrinsicMeasurable7, Integer.valueOf(height))).intValue();
                int size2 = measurables.size();
                int i2 = 0;
                while (true) {
                    intrinsicMeasurable = null;
                    if (i2 >= size2) {
                        intrinsicMeasurable2 = null;
                        break;
                    }
                    intrinsicMeasurable2 = measurables.get(i2);
                    if (Intrinsics.areEqual(TextFieldImplKt.getLayoutId(intrinsicMeasurable2), TextFieldImplKt.LabelId)) {
                        break;
                    }
                    i2++;
                }
                IntrinsicMeasurable intrinsicMeasurable8 = intrinsicMeasurable2;
                int iIntValue2 = intrinsicMeasurable8 != null ? ((Number) intrinsicMeasurer.invoke(intrinsicMeasurable8, Integer.valueOf(height))).intValue() : 0;
                int size3 = measurables.size();
                int i3 = 0;
                while (true) {
                    if (i3 >= size3) {
                        intrinsicMeasurable3 = null;
                        break;
                    }
                    intrinsicMeasurable3 = measurables.get(i3);
                    if (Intrinsics.areEqual(TextFieldImplKt.getLayoutId(intrinsicMeasurable3), TextFieldImplKt.TrailingId)) {
                        break;
                    }
                    i3++;
                }
                IntrinsicMeasurable intrinsicMeasurable9 = intrinsicMeasurable3;
                int iIntValue3 = intrinsicMeasurable9 != null ? ((Number) intrinsicMeasurer.invoke(intrinsicMeasurable9, Integer.valueOf(height))).intValue() : 0;
                int size4 = measurables.size();
                int i4 = 0;
                while (true) {
                    if (i4 >= size4) {
                        intrinsicMeasurable4 = null;
                        break;
                    }
                    intrinsicMeasurable4 = measurables.get(i4);
                    if (Intrinsics.areEqual(TextFieldImplKt.getLayoutId(intrinsicMeasurable4), TextFieldImplKt.PrefixId)) {
                        break;
                    }
                    i4++;
                }
                IntrinsicMeasurable intrinsicMeasurable10 = intrinsicMeasurable4;
                int iIntValue4 = intrinsicMeasurable10 != null ? ((Number) intrinsicMeasurer.invoke(intrinsicMeasurable10, Integer.valueOf(height))).intValue() : 0;
                int size5 = measurables.size();
                int i5 = 0;
                while (true) {
                    if (i5 >= size5) {
                        intrinsicMeasurable5 = null;
                        break;
                    }
                    intrinsicMeasurable5 = measurables.get(i5);
                    if (Intrinsics.areEqual(TextFieldImplKt.getLayoutId(intrinsicMeasurable5), TextFieldImplKt.SuffixId)) {
                        break;
                    }
                    i5++;
                }
                IntrinsicMeasurable intrinsicMeasurable11 = intrinsicMeasurable5;
                int iIntValue5 = intrinsicMeasurable11 != null ? ((Number) intrinsicMeasurer.invoke(intrinsicMeasurable11, Integer.valueOf(height))).intValue() : 0;
                int size6 = measurables.size();
                int i6 = 0;
                while (true) {
                    if (i6 >= size6) {
                        intrinsicMeasurable6 = null;
                        break;
                    }
                    intrinsicMeasurable6 = measurables.get(i6);
                    if (Intrinsics.areEqual(TextFieldImplKt.getLayoutId(intrinsicMeasurable6), TextFieldImplKt.LeadingId)) {
                        break;
                    }
                    i6++;
                }
                IntrinsicMeasurable intrinsicMeasurable12 = intrinsicMeasurable6;
                int iIntValue6 = intrinsicMeasurable12 != null ? ((Number) intrinsicMeasurer.invoke(intrinsicMeasurable12, Integer.valueOf(height))).intValue() : 0;
                int size7 = measurables.size();
                for (int i7 = 0; i7 < size7; i7++) {
                    IntrinsicMeasurable intrinsicMeasurable13 = measurables.get(i7);
                    if (Intrinsics.areEqual(TextFieldImplKt.getLayoutId(intrinsicMeasurable13), TextFieldImplKt.PlaceholderId)) {
                        intrinsicMeasurable = intrinsicMeasurable13;
                        break;
                    }
                }
                IntrinsicMeasurable intrinsicMeasurable14 = intrinsicMeasurable;
                return TextFieldKt.m3019calculateWidthyeHjK3Y(iIntValue6, iIntValue3, iIntValue4, iIntValue5, iIntValue, iIntValue2, intrinsicMeasurable14 != null ? ((Number) intrinsicMeasurer.invoke(intrinsicMeasurable14, Integer.valueOf(height))).intValue() : 0, TextFieldImplKt.getZeroConstraints());
            }
        }
        throw new NoSuchElementException("Collection contains no element matching the predicate.");
    }

    private final int intrinsicHeight(IntrinsicMeasureScope intrinsicMeasureScope, List<? extends IntrinsicMeasurable> list, int i, Function2<? super IntrinsicMeasurable, ? super Integer, Integer> function2) {
        IntrinsicMeasurable intrinsicMeasurable;
        int iSubstractConstraintSafely;
        int iIntValue;
        IntrinsicMeasurable intrinsicMeasurable2;
        int iIntValue2;
        IntrinsicMeasurable intrinsicMeasurable3;
        IntrinsicMeasurable intrinsicMeasurable4;
        int i2;
        IntrinsicMeasurable intrinsicMeasurable5;
        int iIntValue3;
        IntrinsicMeasurable intrinsicMeasurable6;
        IntrinsicMeasurable intrinsicMeasurable7;
        int size = list.size();
        int i3 = 0;
        while (true) {
            if (i3 >= size) {
                intrinsicMeasurable = null;
                break;
            }
            intrinsicMeasurable = list.get(i3);
            if (Intrinsics.areEqual(TextFieldImplKt.getLayoutId(intrinsicMeasurable), TextFieldImplKt.LeadingId)) {
                break;
            }
            i3++;
        }
        IntrinsicMeasurable intrinsicMeasurable8 = intrinsicMeasurable;
        if (intrinsicMeasurable8 != null) {
            iSubstractConstraintSafely = TextFieldKt.substractConstraintSafely(i, intrinsicMeasurable8.maxIntrinsicWidth(Integer.MAX_VALUE));
            iIntValue = ((Number) function2.invoke(intrinsicMeasurable8, Integer.valueOf(i))).intValue();
        } else {
            iSubstractConstraintSafely = i;
            iIntValue = 0;
        }
        int size2 = list.size();
        int i4 = 0;
        while (true) {
            if (i4 >= size2) {
                intrinsicMeasurable2 = null;
                break;
            }
            intrinsicMeasurable2 = list.get(i4);
            if (Intrinsics.areEqual(TextFieldImplKt.getLayoutId(intrinsicMeasurable2), TextFieldImplKt.TrailingId)) {
                break;
            }
            i4++;
        }
        IntrinsicMeasurable intrinsicMeasurable9 = intrinsicMeasurable2;
        if (intrinsicMeasurable9 != null) {
            iSubstractConstraintSafely = TextFieldKt.substractConstraintSafely(iSubstractConstraintSafely, intrinsicMeasurable9.maxIntrinsicWidth(Integer.MAX_VALUE));
            iIntValue2 = ((Number) function2.invoke(intrinsicMeasurable9, Integer.valueOf(i))).intValue();
        } else {
            iIntValue2 = 0;
        }
        int size3 = list.size();
        int i5 = 0;
        while (true) {
            if (i5 >= size3) {
                intrinsicMeasurable3 = null;
                break;
            }
            intrinsicMeasurable3 = list.get(i5);
            if (Intrinsics.areEqual(TextFieldImplKt.getLayoutId(intrinsicMeasurable3), TextFieldImplKt.LabelId)) {
                break;
            }
            i5++;
        }
        IntrinsicMeasurable intrinsicMeasurable10 = intrinsicMeasurable3;
        int iIntValue4 = intrinsicMeasurable10 != null ? ((Number) function2.invoke(intrinsicMeasurable10, Integer.valueOf(iSubstractConstraintSafely))).intValue() : 0;
        int size4 = list.size();
        int i6 = 0;
        while (true) {
            if (i6 >= size4) {
                intrinsicMeasurable4 = null;
                break;
            }
            intrinsicMeasurable4 = list.get(i6);
            if (Intrinsics.areEqual(TextFieldImplKt.getLayoutId(intrinsicMeasurable4), TextFieldImplKt.PrefixId)) {
                break;
            }
            i6++;
        }
        IntrinsicMeasurable intrinsicMeasurable11 = intrinsicMeasurable4;
        if (intrinsicMeasurable11 != null) {
            int iIntValue5 = ((Number) function2.invoke(intrinsicMeasurable11, Integer.valueOf(iSubstractConstraintSafely))).intValue();
            iSubstractConstraintSafely = TextFieldKt.substractConstraintSafely(iSubstractConstraintSafely, intrinsicMeasurable11.maxIntrinsicWidth(Integer.MAX_VALUE));
            i2 = iIntValue5;
        } else {
            i2 = 0;
        }
        int size5 = list.size();
        int i7 = 0;
        while (true) {
            if (i7 >= size5) {
                intrinsicMeasurable5 = null;
                break;
            }
            intrinsicMeasurable5 = list.get(i7);
            if (Intrinsics.areEqual(TextFieldImplKt.getLayoutId(intrinsicMeasurable5), TextFieldImplKt.SuffixId)) {
                break;
            }
            i7++;
        }
        IntrinsicMeasurable intrinsicMeasurable12 = intrinsicMeasurable5;
        if (intrinsicMeasurable12 != null) {
            iIntValue3 = ((Number) function2.invoke(intrinsicMeasurable12, Integer.valueOf(iSubstractConstraintSafely))).intValue();
            iSubstractConstraintSafely = TextFieldKt.substractConstraintSafely(iSubstractConstraintSafely, intrinsicMeasurable12.maxIntrinsicWidth(Integer.MAX_VALUE));
        } else {
            iIntValue3 = 0;
        }
        int size6 = list.size();
        for (int i8 = 0; i8 < size6; i8++) {
            IntrinsicMeasurable intrinsicMeasurable13 = list.get(i8);
            if (Intrinsics.areEqual(TextFieldImplKt.getLayoutId(intrinsicMeasurable13), TextFieldImplKt.TextFieldId)) {
                int iIntValue6 = ((Number) function2.invoke(intrinsicMeasurable13, Integer.valueOf(iSubstractConstraintSafely))).intValue();
                int size7 = list.size();
                int i9 = 0;
                while (true) {
                    if (i9 >= size7) {
                        intrinsicMeasurable6 = null;
                        break;
                    }
                    intrinsicMeasurable6 = list.get(i9);
                    if (Intrinsics.areEqual(TextFieldImplKt.getLayoutId(intrinsicMeasurable6), TextFieldImplKt.PlaceholderId)) {
                        break;
                    }
                    i9++;
                }
                IntrinsicMeasurable intrinsicMeasurable14 = intrinsicMeasurable6;
                int iIntValue7 = intrinsicMeasurable14 != null ? ((Number) function2.invoke(intrinsicMeasurable14, Integer.valueOf(iSubstractConstraintSafely))).intValue() : 0;
                int size8 = list.size();
                int i10 = 0;
                while (true) {
                    if (i10 >= size8) {
                        intrinsicMeasurable7 = null;
                        break;
                    }
                    intrinsicMeasurable7 = list.get(i10);
                    if (Intrinsics.areEqual(TextFieldImplKt.getLayoutId(intrinsicMeasurable7), TextFieldImplKt.SupportingId)) {
                        break;
                    }
                    i10++;
                }
                IntrinsicMeasurable intrinsicMeasurable15 = intrinsicMeasurable7;
                return TextFieldKt.m3018calculateHeightmKXJcVc(iIntValue6, iIntValue4, iIntValue, iIntValue2, i2, iIntValue3, iIntValue7, intrinsicMeasurable15 != null ? ((Number) function2.invoke(intrinsicMeasurable15, Integer.valueOf(i))).intValue() : 0, this.animationProgress, TextFieldImplKt.getZeroConstraints(), intrinsicMeasureScope.getDensity(), this.paddingValues);
            }
        }
        throw new NoSuchElementException("Collection contains no element matching the predicate.");
    }
}
