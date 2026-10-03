package androidx.compose.material3.internal;

import androidx.compose.foundation.layout.PaddingKt;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.layout.LayoutModifierKt;
import androidx.compose.p002ui.layout.Measurable;
import androidx.compose.p002ui.layout.MeasureResult;
import androidx.compose.p002ui.layout.MeasureScope;
import androidx.compose.p002ui.layout.Placeable;
import androidx.compose.p002ui.semantics.SemanticsModifierKt;
import androidx.compose.p002ui.semantics.SemanticsPropertyReceiver;
import androidx.compose.ui.unit.Constraints;
import androidx.compose.ui.unit.ConstraintsKt;
import androidx.compose.ui.unit.Dp;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function3;

@Metadata(d1 = {"\u0000\u0012\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0003\"\u001e\u0010\u0000\u001a\u00020\u00018\u0000X\u0081\u0004¢\u0006\u0010\n\u0002\u0010\u0006\u0012\u0004\b\u0002\u0010\u0003\u001a\u0004\b\u0004\u0010\u0005\"\u0014\u0010\u0007\u001a\u00020\bX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\n¨\u0006\u000b"}, d2 = {"HorizontalSemanticsBoundsPadding", "Landroidx/compose/ui/unit/Dp;", "getHorizontalSemanticsBoundsPadding$annotations", "()V", "getHorizontalSemanticsBoundsPadding", "()F", "F", "IncreaseHorizontalSemanticsBounds", "Landroidx/compose/ui/Modifier;", "getIncreaseHorizontalSemanticsBounds", "()Landroidx/compose/ui/Modifier;", "material3_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class AccessibilityUtilKt {
    private static final float HorizontalSemanticsBoundsPadding;
    private static final Modifier IncreaseHorizontalSemanticsBounds;

    public static void getHorizontalSemanticsBoundsPadding$annotations() {
    }

    public static final float getHorizontalSemanticsBoundsPadding() {
        return HorizontalSemanticsBoundsPadding;
    }

    public static final Modifier getIncreaseHorizontalSemanticsBounds() {
        return IncreaseHorizontalSemanticsBounds;
    }

    static {
        float f = Dp.constructor-impl(10);
        HorizontalSemanticsBoundsPadding = f;
        IncreaseHorizontalSemanticsBounds = PaddingKt.m1037paddingVpY3zN4$default(SemanticsModifierKt.semantics(LayoutModifierKt.layout(Modifier.INSTANCE, new Function3<MeasureScope, Measurable, Constraints, MeasureResult>() {
            public Object invoke(Object obj, Object obj2, Object obj3) {
                return m3239invoke3p2s80s((MeasureScope) obj, (Measurable) obj2, ((Constraints) obj3).unbox-impl());
            }

            public final MeasureResult m3239invoke3p2s80s(MeasureScope measureScope, Measurable measurable, long j) {
                final int i = measureScope.roundToPx-0680j_4(AccessibilityUtilKt.getHorizontalSemanticsBoundsPadding());
                int i2 = i * 2;
                final Placeable placeableMo6026measureBRTryo0 = measurable.mo6026measureBRTryo0(ConstraintsKt.offset-NN6Ew-U(j, i2, 0));
                return MeasureScope.CC.layout$default(measureScope, placeableMo6026measureBRTryo0.getWidth() - i2, placeableMo6026measureBRTryo0.getHeight(), null, new Function1<Placeable.PlacementScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((Placeable.PlacementScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Placeable.PlacementScope placementScope) {
                        Placeable.PlacementScope.place$default(placementScope, placeableMo6026measureBRTryo0, -i, 0, 0.0f, 4, null);
                    }
                }, 4, null);
            }
        }), true, new Function1<SemanticsPropertyReceiver, Unit>() {
            public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
            }

            public Object invoke(Object obj) {
                invoke((SemanticsPropertyReceiver) obj);
                return Unit.INSTANCE;
            }
        }), f, 0.0f, 2, null);
    }
}
