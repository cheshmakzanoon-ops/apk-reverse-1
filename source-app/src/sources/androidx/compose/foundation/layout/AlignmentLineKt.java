package androidx.compose.foundation.layout;

import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.layout.AlignmentLine;
import androidx.compose.p002ui.layout.HorizontalAlignmentLine;
import androidx.compose.p002ui.layout.Measurable;
import androidx.compose.p002ui.layout.MeasureResult;
import androidx.compose.p002ui.layout.MeasureScope;
import androidx.compose.p002ui.layout.Placeable;
import androidx.compose.p002ui.platform.InspectableValueKt;
import androidx.compose.p002ui.platform.InspectorInfo;
import androidx.compose.ui.unit.Constraints;
import androidx.compose.ui.unit.Dp;
import androidx.compose.ui.unit.TextUnit;
import androidx.compose.ui.unit.TextUnitKt;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.ranges.RangesKt;

@Metadata(d1 = {"\u0000@\n\u0000\n\u0002\u0010\u000b\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\n\u001a>\u0010\u0005\u001a\u00020\u0006*\u00020\u00072\u0006\u0010\b\u001a\u00020\u00022\u0006\u0010\t\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\n2\u0006\u0010\f\u001a\u00020\r2\u0006\u0010\u000e\u001a\u00020\u000fH\u0002ø\u0001\u0000¢\u0006\u0004\b\u0010\u0010\u0011\u001a2\u0010\u0012\u001a\u00020\u0013*\u00020\u00132\u0006\u0010\b\u001a\u00020\u00022\b\b\u0002\u0010\t\u001a\u00020\n2\b\b\u0002\u0010\u000b\u001a\u00020\nH\u0007ø\u0001\u0000¢\u0006\u0004\b\u0014\u0010\u0015\u001a2\u0010\u0012\u001a\u00020\u0013*\u00020\u00132\u0006\u0010\b\u001a\u00020\u00022\b\b\u0002\u0010\t\u001a\u00020\u00162\b\b\u0002\u0010\u000b\u001a\u00020\u0016H\u0007ø\u0001\u0000¢\u0006\u0004\b\u0017\u0010\u0018\u001a*\u0010\u0019\u001a\u00020\u0013*\u00020\u00132\b\b\u0002\u0010\u001a\u001a\u00020\n2\b\b\u0002\u0010\u001b\u001a\u00020\nH\u0007ø\u0001\u0000¢\u0006\u0004\b\u001c\u0010\u001d\u001a*\u0010\u0019\u001a\u00020\u0013*\u00020\u00132\b\b\u0002\u0010\u001a\u001a\u00020\u00162\b\b\u0002\u0010\u001b\u001a\u00020\u0016H\u0007ø\u0001\u0000¢\u0006\u0004\b\u001e\u0010\u001f\"\u0018\u0010\u0000\u001a\u00020\u0001*\u00020\u00028BX\u0082\u0004¢\u0006\u0006\u001a\u0004\b\u0003\u0010\u0004\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006 "}, d2 = {"horizontal", "", "Landroidx/compose/ui/layout/AlignmentLine;", "getHorizontal", "(Landroidx/compose/ui/layout/AlignmentLine;)Z", "alignmentLineOffsetMeasure", "Landroidx/compose/ui/layout/MeasureResult;", "Landroidx/compose/ui/layout/MeasureScope;", "alignmentLine", "before", "Landroidx/compose/ui/unit/Dp;", "after", "measurable", "Landroidx/compose/ui/layout/Measurable;", "constraints", "Landroidx/compose/ui/unit/Constraints;", "alignmentLineOffsetMeasure-tjqqzMA", "(Landroidx/compose/ui/layout/MeasureScope;Landroidx/compose/ui/layout/AlignmentLine;FFLandroidx/compose/ui/layout/Measurable;J)Landroidx/compose/ui/layout/MeasureResult;", "paddingFrom", "Landroidx/compose/ui/Modifier;", "paddingFrom-4j6BHR0", "(Landroidx/compose/ui/Modifier;Landroidx/compose/ui/layout/AlignmentLine;FF)Landroidx/compose/ui/Modifier;", "Landroidx/compose/ui/unit/TextUnit;", "paddingFrom-Y_r0B1c", "(Landroidx/compose/ui/Modifier;Landroidx/compose/ui/layout/AlignmentLine;JJ)Landroidx/compose/ui/Modifier;", "paddingFromBaseline", "top", "bottom", "paddingFromBaseline-VpY3zN4", "(Landroidx/compose/ui/Modifier;FF)Landroidx/compose/ui/Modifier;", "paddingFromBaseline-wCyjxdI", "(Landroidx/compose/ui/Modifier;JJ)Landroidx/compose/ui/Modifier;", "foundation-layout_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class AlignmentLineKt {
    public static Modifier m882paddingFrom4j6BHR0$default(Modifier modifier, AlignmentLine alignmentLine, float f, float f2, int i, Object obj) {
        if ((i & 2) != 0) {
            f = Dp.Companion.getUnspecified-D9Ej5fM();
        }
        if ((i & 4) != 0) {
            f2 = Dp.Companion.getUnspecified-D9Ej5fM();
        }
        return m881paddingFrom4j6BHR0(modifier, alignmentLine, f, f2);
    }

    public static final Modifier m881paddingFrom4j6BHR0(Modifier modifier, final AlignmentLine alignmentLine, final float f, final float f2) {
        return modifier.then(new AlignmentLineOffsetDpElement(alignmentLine, f, f2, InspectableValueKt.isDebugInspectorInfoEnabled() ? new Function1<InspectorInfo, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((InspectorInfo) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(InspectorInfo inspectorInfo) {
                inspectorInfo.setName("paddingFrom");
                inspectorInfo.getProperties().set("alignmentLine", alignmentLine);
                inspectorInfo.getProperties().set("before", Dp.box-impl(f));
                inspectorInfo.getProperties().set("after", Dp.box-impl(f2));
            }
        } : InspectableValueKt.getNoInspectorInfo(), null));
    }

    public static Modifier m884paddingFromY_r0B1c$default(Modifier modifier, AlignmentLine alignmentLine, long j, long j2, int i, Object obj) {
        if ((i & 2) != 0) {
            j = TextUnit.Companion.getUnspecified-XSAIIZE();
        }
        long j3 = j;
        if ((i & 4) != 0) {
            j2 = TextUnit.Companion.getUnspecified-XSAIIZE();
        }
        return m883paddingFromY_r0B1c(modifier, alignmentLine, j3, j2);
    }

    public static final Modifier m883paddingFromY_r0B1c(Modifier modifier, final AlignmentLine alignmentLine, final long j, final long j2) {
        return modifier.then(new AlignmentLineOffsetTextUnitElement(alignmentLine, j, j2, InspectableValueKt.isDebugInspectorInfoEnabled() ? new Function1<InspectorInfo, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((InspectorInfo) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(InspectorInfo inspectorInfo) {
                inspectorInfo.setName("paddingFrom");
                inspectorInfo.getProperties().set("alignmentLine", alignmentLine);
                inspectorInfo.getProperties().set("before", TextUnit.box-impl(j));
                inspectorInfo.getProperties().set("after", TextUnit.box-impl(j2));
            }
        } : InspectableValueKt.getNoInspectorInfo(), null));
    }

    public static Modifier m886paddingFromBaselineVpY3zN4$default(Modifier modifier, float f, float f2, int i, Object obj) {
        if ((i & 1) != 0) {
            f = Dp.Companion.getUnspecified-D9Ej5fM();
        }
        if ((i & 2) != 0) {
            f2 = Dp.Companion.getUnspecified-D9Ej5fM();
        }
        return m885paddingFromBaselineVpY3zN4(modifier, f, f2);
    }

    public static final Modifier m885paddingFromBaselineVpY3zN4(Modifier modifier, float f, float f2) {
        Modifier.Companion companionM882paddingFrom4j6BHR0$default;
        Modifier.Companion companionM882paddingFrom4j6BHR0$default2;
        if (!Dp.equals-impl0(f, Dp.Companion.getUnspecified-D9Ej5fM())) {
            companionM882paddingFrom4j6BHR0$default = m882paddingFrom4j6BHR0$default(Modifier.INSTANCE, androidx.compose.p002ui.layout.AlignmentLineKt.getFirstBaseline(), f, 0.0f, 4, null);
        } else {
            companionM882paddingFrom4j6BHR0$default = Modifier.INSTANCE;
        }
        Modifier modifierThen = modifier.then(companionM882paddingFrom4j6BHR0$default);
        if (!Dp.equals-impl0(f2, Dp.Companion.getUnspecified-D9Ej5fM())) {
            companionM882paddingFrom4j6BHR0$default2 = m882paddingFrom4j6BHR0$default(Modifier.INSTANCE, androidx.compose.p002ui.layout.AlignmentLineKt.getLastBaseline(), 0.0f, f2, 2, null);
        } else {
            companionM882paddingFrom4j6BHR0$default2 = Modifier.INSTANCE;
        }
        return modifierThen.then(companionM882paddingFrom4j6BHR0$default2);
    }

    public static Modifier m888paddingFromBaselinewCyjxdI$default(Modifier modifier, long j, long j2, int i, Object obj) {
        if ((i & 1) != 0) {
            j = TextUnit.Companion.getUnspecified-XSAIIZE();
        }
        if ((i & 2) != 0) {
            j2 = TextUnit.Companion.getUnspecified-XSAIIZE();
        }
        return m887paddingFromBaselinewCyjxdI(modifier, j, j2);
    }

    public static final Modifier m887paddingFromBaselinewCyjxdI(Modifier modifier, long j, long j2) {
        return modifier.then(!TextUnitKt.isUnspecified--R2X_6o(j) ? m884paddingFromY_r0B1c$default(Modifier.INSTANCE, androidx.compose.p002ui.layout.AlignmentLineKt.getFirstBaseline(), j, 0L, 4, null) : Modifier.INSTANCE).then(!TextUnitKt.isUnspecified--R2X_6o(j2) ? m884paddingFromY_r0B1c$default(Modifier.INSTANCE, androidx.compose.p002ui.layout.AlignmentLineKt.getLastBaseline(), 0L, j2, 2, null) : Modifier.INSTANCE);
    }

    public static final MeasureResult m880alignmentLineOffsetMeasuretjqqzMA(MeasureScope measureScope, final AlignmentLine alignmentLine, final float f, float f2, Measurable measurable, long j) {
        int iMax;
        int height;
        final Placeable placeableMo6026measureBRTryo0 = measurable.mo6026measureBRTryo0(getHorizontal(alignmentLine) ? Constraints.copy-Zbe2FdA$default(j, 0, 0, 0, 0, 11, (Object) null) : Constraints.copy-Zbe2FdA$default(j, 0, 0, 0, 0, 14, (Object) null));
        int i = placeableMo6026measureBRTryo0.get(alignmentLine);
        if (i == Integer.MIN_VALUE) {
            i = 0;
        }
        int height2 = getHorizontal(alignmentLine) ? placeableMo6026measureBRTryo0.getHeight() : placeableMo6026measureBRTryo0.getWidth();
        int i2 = (getHorizontal(alignmentLine) ? Constraints.getMaxHeight-impl(j) : Constraints.getMaxWidth-impl(j)) - height2;
        final int iCoerceIn = RangesKt.coerceIn((!Dp.equals-impl0(f, Dp.Companion.getUnspecified-D9Ej5fM()) ? measureScope.roundToPx-0680j_4(f) : 0) - i, 0, i2);
        final int iCoerceIn2 = RangesKt.coerceIn(((!Dp.equals-impl0(f2, Dp.Companion.getUnspecified-D9Ej5fM()) ? measureScope.roundToPx-0680j_4(f2) : 0) - height2) + i, 0, i2 - iCoerceIn);
        if (getHorizontal(alignmentLine)) {
            iMax = placeableMo6026measureBRTryo0.getWidth();
        } else {
            iMax = Math.max(placeableMo6026measureBRTryo0.getWidth() + iCoerceIn + iCoerceIn2, Constraints.getMinWidth-impl(j));
        }
        final int i3 = iMax;
        if (getHorizontal(alignmentLine)) {
            height = Math.max(placeableMo6026measureBRTryo0.getHeight() + iCoerceIn + iCoerceIn2, Constraints.getMinHeight-impl(j));
        } else {
            height = placeableMo6026measureBRTryo0.getHeight();
        }
        final int i4 = height;
        return MeasureScope.CC.layout$default(measureScope, i3, i4, null, new Function1<Placeable.PlacementScope, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((Placeable.PlacementScope) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(Placeable.PlacementScope placementScope) {
                int width;
                int height3 = 0;
                if (AlignmentLineKt.getHorizontal(alignmentLine)) {
                    width = 0;
                } else {
                    width = !Dp.equals-impl0(f, Dp.Companion.getUnspecified-D9Ej5fM()) ? iCoerceIn : (i3 - iCoerceIn2) - placeableMo6026measureBRTryo0.getWidth();
                }
                if (AlignmentLineKt.getHorizontal(alignmentLine)) {
                    height3 = !Dp.equals-impl0(f, Dp.Companion.getUnspecified-D9Ej5fM()) ? iCoerceIn : (i4 - iCoerceIn2) - placeableMo6026measureBRTryo0.getHeight();
                }
                Placeable.PlacementScope.placeRelative$default(placementScope, placeableMo6026measureBRTryo0, width, height3, 0.0f, 4, null);
            }
        }, 4, null);
    }

    public static final boolean getHorizontal(AlignmentLine alignmentLine) {
        return alignmentLine instanceof HorizontalAlignmentLine;
    }
}
