package androidx.compose.foundation.layout;

import androidx.autofill.HintConstants;
import androidx.compose.runtime.Composer;
import java.util.List;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000R\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010!\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b7\u0018\u00002\u00020\u0001:\u0001\u001aB\u0087\u0001\b\u0004\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0005\u0012\b\b\u0002\u0010\u0006\u001a\u00020\u0005\u00120\b\u0002\u0010\u0007\u001a*\u0012\u0013\u0012\u00110\t¢\u0006\f\b\n\u0012\b\b\u000b\u0012\u0004\b\b(\f\u0012\u000f\u0012\r\u0012\u0004\u0012\u00020\u000e0\r¢\u0006\u0002\b\u000f\u0018\u00010\b\u00120\b\u0002\u0010\u0010\u001a*\u0012\u0013\u0012\u00110\t¢\u0006\f\b\n\u0012\b\b\u000b\u0012\u0004\b\b(\f\u0012\u000f\u0012\r\u0012\u0004\u0012\u00020\u000e0\r¢\u0006\u0002\b\u000f\u0018\u00010\b¢\u0006\u0002\u0010\u0011J.\u0010\u0014\u001a\u00020\u000e2\u0006\u0010\f\u001a\u00020\t2\u0017\u0010\u0015\u001a\u0013\u0012\u000f\u0012\r\u0012\u0004\u0012\u00020\u000e0\r¢\u0006\u0002\b\u000f0\u0016H\u0000¢\u0006\u0002\b\u0017J\r\u0010\u0018\u001a\u00020\tH\u0000¢\u0006\u0002\b\u0019R6\u0010\u0010\u001a*\u0012\u0013\u0012\u00110\t¢\u0006\f\b\n\u0012\b\b\u000b\u0012\u0004\b\b(\f\u0012\u000f\u0012\r\u0012\u0004\u0012\u00020\u000e0\r¢\u0006\u0002\b\u000f\u0018\u00010\bX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R6\u0010\u0007\u001a*\u0012\u0013\u0012\u00110\t¢\u0006\f\b\n\u0012\b\b\u000b\u0012\u0004\b\b(\f\u0012\u000f\u0012\r\u0012\u0004\u0012\u00020\u000e0\r¢\u0006\u0002\b\u000f\u0018\u00010\bX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u0002\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0013\u0082\u0001\u0004\u001b\u001c\u001d\u001e¨\u0006\u001f"}, d2 = {"Landroidx/compose/foundation/layout/FlowLayoutOverflow;", "", "type", "Landroidx/compose/foundation/layout/FlowLayoutOverflow$OverflowType;", "minLinesToShowCollapse", "", "minCrossAxisSizeToShowCollapse", "seeMoreGetter", "Lkotlin/Function1;", "Landroidx/compose/foundation/layout/FlowLayoutOverflowState;", "Lkotlin/ParameterName;", HintConstants.AUTOFILL_HINT_NAME, "state", "Lkotlin/Function0;", "", "Landroidx/compose/runtime/Composable;", "collapseGetter", "(Landroidx/compose/foundation/layout/FlowLayoutOverflow$OverflowType;IILkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;)V", "getType$foundation_layout_release", "()Landroidx/compose/foundation/layout/FlowLayoutOverflow$OverflowType;", "addOverflowComposables", "list", "", "addOverflowComposables$foundation_layout_release", "createOverflowState", "createOverflowState$foundation_layout_release", "OverflowType", "Landroidx/compose/foundation/layout/ContextualFlowColumnOverflow;", "Landroidx/compose/foundation/layout/ContextualFlowRowOverflow;", "Landroidx/compose/foundation/layout/FlowColumnOverflow;", "Landroidx/compose/foundation/layout/FlowRowOverflow;", "foundation-layout_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public abstract class FlowLayoutOverflow {
    public static final int $stable = 0;
    private final Function1<FlowLayoutOverflowState, Function2<Composer, Integer, Unit>> collapseGetter;
    private final int minCrossAxisSizeToShowCollapse;
    private final int minLinesToShowCollapse;
    private final Function1<FlowLayoutOverflowState, Function2<Composer, Integer, Unit>> seeMoreGetter;
    private final OverflowType type;

    @Metadata(d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0002\b\u0006\b\u0080\u0001\u0018\u00002\b\u0012\u0004\u0012\u00020\u00000\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002j\u0002\b\u0003j\u0002\b\u0004j\u0002\b\u0005j\u0002\b\u0006¨\u0006\u0007"}, d2 = {"Landroidx/compose/foundation/layout/FlowLayoutOverflow$OverflowType;", "", "(Ljava/lang/String;I)V", "Visible", "Clip", "ExpandIndicator", "ExpandOrCollapseIndicator", "foundation-layout_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public enum OverflowType {
        Visible,
        Clip,
        ExpandIndicator,
        ExpandOrCollapseIndicator
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[OverflowType.values().length];
            try {
                iArr[OverflowType.ExpandIndicator.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[OverflowType.ExpandOrCollapseIndicator.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    public FlowLayoutOverflow(OverflowType overflowType, int i, int i2, Function1 function1, Function1 function2, DefaultConstructorMarker defaultConstructorMarker) {
        this(overflowType, i, i2, function1, function2);
    }

    private FlowLayoutOverflow(OverflowType overflowType, int i, int i2, Function1<? super FlowLayoutOverflowState, ? extends Function2<? super Composer, ? super Integer, Unit>> function1, Function1<? super FlowLayoutOverflowState, ? extends Function2<? super Composer, ? super Integer, Unit>> function2) {
        this.type = overflowType;
        this.minLinesToShowCollapse = i;
        this.minCrossAxisSizeToShowCollapse = i2;
        this.seeMoreGetter = function1;
        this.collapseGetter = function2;
    }

    public FlowLayoutOverflow(OverflowType overflowType, int i, int i2, Function1 function1, Function1 function2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this(overflowType, (i3 & 2) != 0 ? 0 : i, (i3 & 4) != 0 ? 0 : i2, (i3 & 8) != 0 ? null : function1, (i3 & 16) != 0 ? null : function2, null);
    }

    public final OverflowType getType() {
        return this.type;
    }

    public final FlowLayoutOverflowState createOverflowState$foundation_layout_release() {
        return new FlowLayoutOverflowState(this.type, this.minLinesToShowCollapse, this.minCrossAxisSizeToShowCollapse);
    }

    public final void addOverflowComposables$foundation_layout_release(FlowLayoutOverflowState state, List<Function2<Composer, Integer, Unit>> list) {
        Function1<FlowLayoutOverflowState, Function2<Composer, Integer, Unit>> function1 = this.seeMoreGetter;
        Function2<Composer, Integer, Unit> function2 = function1 != null ? (Function2) function1.invoke(state) : null;
        Function1<FlowLayoutOverflowState, Function2<Composer, Integer, Unit>> function3 = this.collapseGetter;
        Function2<Composer, Integer, Unit> function4 = function3 != null ? (Function2) function3.invoke(state) : null;
        int i = WhenMappings.$EnumSwitchMapping$0[this.type.ordinal()];
        if (i == 1) {
            if (function2 != null) {
                list.add(function2);
            }
        } else {
            if (i != 2) {
                return;
            }
            if (function2 != null) {
                list.add(function2);
            }
            if (function4 != null) {
                list.add(function4);
            }
        }
    }
}
