package androidx.compose.p002ui.layout;

import androidx.compose.p002ui.node.LayoutNode;
import androidx.compose.ui.unit.Constraints;
import androidx.compose.ui.unit.ConstraintsKt;
import java.util.ArrayList;
import java.util.List;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;

@Metadata(d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\bÀ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J,\u0010\u0003\u001a\u00020\u0004*\u00020\u00052\f\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u00072\u0006\u0010\t\u001a\u00020\nH\u0016ø\u0001\u0000¢\u0006\u0004\b\u000b\u0010\f\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\r"}, d2 = {"Landroidx/compose/ui/layout/RootMeasurePolicy;", "Landroidx/compose/ui/node/LayoutNode$NoIntrinsicsMeasurePolicy;", "()V", "measure", "Landroidx/compose/ui/layout/MeasureResult;", "Landroidx/compose/ui/layout/MeasureScope;", "measurables", "", "Landroidx/compose/ui/layout/Measurable;", "constraints", "Landroidx/compose/ui/unit/Constraints;", "measure-3p2s80s", "(Landroidx/compose/ui/layout/MeasureScope;Ljava/util/List;J)Landroidx/compose/ui/layout/MeasureResult;", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class RootMeasurePolicy extends LayoutNode.NoIntrinsicsMeasurePolicy {
    public static final int $stable = 0;
    public static final RootMeasurePolicy INSTANCE = new RootMeasurePolicy();

    private RootMeasurePolicy() {
        super("Undefined intrinsics block and it is required");
    }

    @Override
    public MeasureResult mo296measure3p2s80s(MeasureScope measureScope, List<? extends Measurable> list, long j) {
        if (list.isEmpty()) {
            return MeasureScope.CC.layout$default(measureScope, Constraints.getMinWidth-impl(j), Constraints.getMinHeight-impl(j), null, new Function1<Placeable.PlacementScope, Unit>() {
                public final void invoke(Placeable.PlacementScope placementScope) {
                }

                public Object invoke(Object obj) {
                    invoke((Placeable.PlacementScope) obj);
                    return Unit.INSTANCE;
                }
            }, 4, null);
        }
        if (list.size() == 1) {
            final Placeable placeableMo6026measureBRTryo0 = list.get(0).mo6026measureBRTryo0(j);
            return MeasureScope.CC.layout$default(measureScope, ConstraintsKt.constrainWidth-K40F9xA(j, placeableMo6026measureBRTryo0.getWidth()), ConstraintsKt.constrainHeight-K40F9xA(j, placeableMo6026measureBRTryo0.getHeight()), null, new Function1<Placeable.PlacementScope, Unit>() {
                {
                    super(1);
                }

                public Object invoke(Object obj) {
                    invoke((Placeable.PlacementScope) obj);
                    return Unit.INSTANCE;
                }

                public final void invoke(Placeable.PlacementScope placementScope) {
                    Placeable.PlacementScope.placeRelativeWithLayer$default(placementScope, placeableMo6026measureBRTryo0, 0, 0, 0.0f, (Function1) null, 12, (Object) null);
                }
            }, 4, null);
        }
        ArrayList arrayList = new ArrayList(list.size());
        int size = list.size();
        for (int i = 0; i < size; i++) {
            arrayList.add(list.get(i).mo6026measureBRTryo0(j));
        }
        final ArrayList arrayList2 = arrayList;
        int size2 = arrayList2.size();
        int iMax = 0;
        int iMax2 = 0;
        for (int i2 = 0; i2 < size2; i2++) {
            Placeable placeable = (Placeable) arrayList2.get(i2);
            iMax = Math.max(placeable.getWidth(), iMax);
            iMax2 = Math.max(placeable.getHeight(), iMax2);
        }
        return MeasureScope.CC.layout$default(measureScope, ConstraintsKt.constrainWidth-K40F9xA(j, iMax), ConstraintsKt.constrainHeight-K40F9xA(j, iMax2), null, new Function1<Placeable.PlacementScope, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((Placeable.PlacementScope) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(Placeable.PlacementScope placementScope) {
                List<Placeable> list2 = arrayList2;
                int size3 = list2.size();
                for (int i3 = 0; i3 < size3; i3++) {
                    Placeable.PlacementScope.placeRelativeWithLayer$default(placementScope, list2.get(i3), 0, 0, 0.0f, (Function1) null, 12, (Object) null);
                }
            }
        }, 4, null);
    }
}
