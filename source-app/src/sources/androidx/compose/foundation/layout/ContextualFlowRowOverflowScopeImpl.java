package androidx.compose.foundation.layout;

import androidx.compose.p002ui.Alignment;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.layout.HorizontalAlignmentLine;
import androidx.compose.p002ui.layout.Measured;
import kotlin.Metadata;
import kotlin.jvm.functions.Function1;

@Metadata(d1 = {"\u0000L\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0007\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\b\u0001\u0018\u00002\u00020\u00012\u00020\u0002B\r\u0012\u0006\u0010\u0003\u001a\u00020\u0004¢\u0006\u0002\u0010\u0005J\u0015\u0010\f\u001a\u00020\r*\u00020\r2\u0006\u0010\u000e\u001a\u00020\u000fH\u0097\u0001J!\u0010\u0010\u001a\u00020\r*\u00020\r2\u0012\u0010\u0011\u001a\u000e\u0012\u0004\u0012\u00020\u0013\u0012\u0004\u0012\u00020\u00070\u0012H\u0097\u0001J\u0015\u0010\u0010\u001a\u00020\r*\u00020\r2\u0006\u0010\u0014\u001a\u00020\u0015H\u0097\u0001J\r\u0010\u0016\u001a\u00020\r*\u00020\rH\u0097\u0001J\u0017\u0010\u0017\u001a\u00020\r*\u00020\r2\b\b\u0001\u0010\u0018\u001a\u00020\u0019H\u0097\u0001J\u001f\u0010\u001a\u001a\u00020\r*\u00020\r2\b\b\u0001\u0010\u001a\u001a\u00020\u00192\u0006\u0010\u001b\u001a\u00020\u001cH\u0097\u0001R\u0014\u0010\u0006\u001a\u00020\u00078\u0016X\u0097\u0005¢\u0006\u0006\u001a\u0004\b\b\u0010\tR\u000e\u0010\u0003\u001a\u00020\u0004X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\n\u001a\u00020\u00078\u0016X\u0097\u0005¢\u0006\u0006\u001a\u0004\b\u000b\u0010\t¨\u0006\u001d"}, d2 = {"Landroidx/compose/foundation/layout/ContextualFlowRowOverflowScopeImpl;", "Landroidx/compose/foundation/layout/FlowRowOverflowScope;", "Landroidx/compose/foundation/layout/ContextualFlowRowOverflowScope;", "state", "Landroidx/compose/foundation/layout/FlowLayoutOverflowState;", "(Landroidx/compose/foundation/layout/FlowLayoutOverflowState;)V", "shownItemCount", "", "getShownItemCount", "()I", "totalItemCount", "getTotalItemCount", "align", "Landroidx/compose/ui/Modifier;", "alignment", "Landroidx/compose/ui/Alignment$Vertical;", "alignBy", "alignmentLineBlock", "Lkotlin/Function1;", "Landroidx/compose/ui/layout/Measured;", "alignmentLine", "Landroidx/compose/ui/layout/HorizontalAlignmentLine;", "alignByBaseline", "fillMaxRowHeight", "fraction", "", "weight", "fill", "", "foundation-layout_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class ContextualFlowRowOverflowScopeImpl implements FlowRowOverflowScope, ContextualFlowRowOverflowScope {
    public static final int $stable = 0;
    private final FlowRowOverflowScopeImpl $$delegate_0;
    private final FlowLayoutOverflowState state;

    @Override
    public Modifier align(Modifier modifier, Alignment.Vertical vertical) {
        return this.$$delegate_0.align(modifier, vertical);
    }

    @Override
    public Modifier alignBy(Modifier modifier, HorizontalAlignmentLine horizontalAlignmentLine) {
        return this.$$delegate_0.alignBy(modifier, horizontalAlignmentLine);
    }

    @Override
    public Modifier alignBy(Modifier modifier, Function1<? super Measured, Integer> function1) {
        return this.$$delegate_0.alignBy(modifier, function1);
    }

    @Override
    public Modifier alignByBaseline(Modifier modifier) {
        return this.$$delegate_0.alignByBaseline(modifier);
    }

    @Override
    public Modifier fillMaxRowHeight(Modifier modifier, float f) {
        return this.$$delegate_0.fillMaxRowHeight(modifier, f);
    }

    @Override
    public int getShownItemCount() {
        return this.$$delegate_0.getShownItemCount();
    }

    @Override
    public int getTotalItemCount() {
        return this.$$delegate_0.getTotalItemCount();
    }

    @Override
    public Modifier weight(Modifier modifier, float f, boolean z) {
        return this.$$delegate_0.weight(modifier, f, z);
    }

    public ContextualFlowRowOverflowScopeImpl(FlowLayoutOverflowState flowLayoutOverflowState) {
        this.state = flowLayoutOverflowState;
        this.$$delegate_0 = new FlowRowOverflowScopeImpl(flowLayoutOverflowState);
    }
}
