package androidx.compose.foundation.layout;

import androidx.compose.p002ui.Alignment;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.layout.Measured;
import androidx.compose.p002ui.layout.VerticalAlignmentLine;
import kotlin.Metadata;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000L\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0007\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\b\u0000\u0018\u00002\u00020\u00012\u00020\u0002B%\u0012\u0006\u0010\u0003\u001a\u00020\u0004\u0012\u0006\u0010\u0005\u001a\u00020\u0004\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\u0007¢\u0006\u0002\u0010\tJ\u0015\u0010\u0011\u001a\u00020\u0012*\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0014H\u0097\u0001J!\u0010\u0015\u001a\u00020\u0012*\u00020\u00122\u0012\u0010\u0016\u001a\u000e\u0012\u0004\u0012\u00020\u0018\u0012\u0004\u0012\u00020\u00040\u0017H\u0097\u0001J\u0015\u0010\u0015\u001a\u00020\u0012*\u00020\u00122\u0006\u0010\u0019\u001a\u00020\u001aH\u0097\u0001J\u0017\u0010\u001b\u001a\u00020\u0012*\u00020\u00122\b\b\u0003\u0010\u001c\u001a\u00020\u001dH\u0097\u0001J\u001f\u0010\u001e\u001a\u00020\u0012*\u00020\u00122\b\b\u0001\u0010\u001e\u001a\u00020\u001d2\u0006\u0010\u001f\u001a\u00020 H\u0097\u0001R\u0014\u0010\u0005\u001a\u00020\u0004X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR\u0014\u0010\u0003\u001a\u00020\u0004X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\u000bR\u001c\u0010\b\u001a\u00020\u0007X\u0096\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u000f\u001a\u0004\b\r\u0010\u000eR\u001c\u0010\u0006\u001a\u00020\u0007X\u0096\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u000f\u001a\u0004\b\u0010\u0010\u000e\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006!"}, d2 = {"Landroidx/compose/foundation/layout/ContextualFlowColumnScopeImpl;", "Landroidx/compose/foundation/layout/FlowColumnScope;", "Landroidx/compose/foundation/layout/ContextualFlowColumnScope;", "lineIndex", "", "indexInLine", "maxWidth", "Landroidx/compose/ui/unit/Dp;", "maxHeightInLine", "(IIFFLkotlin/jvm/internal/DefaultConstructorMarker;)V", "getIndexInLine", "()I", "getLineIndex", "getMaxHeightInLine-D9Ej5fM", "()F", "F", "getMaxWidth-D9Ej5fM", "align", "Landroidx/compose/ui/Modifier;", "alignment", "Landroidx/compose/ui/Alignment$Horizontal;", "alignBy", "alignmentLineBlock", "Lkotlin/Function1;", "Landroidx/compose/ui/layout/Measured;", "alignmentLine", "Landroidx/compose/ui/layout/VerticalAlignmentLine;", "fillMaxColumnWidth", "fraction", "", "weight", "fill", "", "foundation-layout_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class ContextualFlowColumnScopeImpl implements FlowColumnScope, ContextualFlowColumnScope {
    public static final int $stable = 0;
    private final FlowColumnScopeInstance $$delegate_0;
    private final int indexInLine;
    private final int lineIndex;
    private final float maxHeightInLine;
    private final float maxWidth;

    public ContextualFlowColumnScopeImpl(int i, int i2, float f, float f2, DefaultConstructorMarker defaultConstructorMarker) {
        this(i, i2, f, f2);
    }

    @Override
    public Modifier align(Modifier modifier, Alignment.Horizontal horizontal) {
        return this.$$delegate_0.align(modifier, horizontal);
    }

    @Override
    public Modifier alignBy(Modifier modifier, VerticalAlignmentLine verticalAlignmentLine) {
        return this.$$delegate_0.alignBy(modifier, verticalAlignmentLine);
    }

    @Override
    public Modifier alignBy(Modifier modifier, Function1<? super Measured, Integer> function1) {
        return this.$$delegate_0.alignBy(modifier, function1);
    }

    @Override
    public Modifier fillMaxColumnWidth(Modifier modifier, float f) {
        return this.$$delegate_0.fillMaxColumnWidth(modifier, f);
    }

    @Override
    public Modifier weight(Modifier modifier, float f, boolean z) {
        return this.$$delegate_0.weight(modifier, f, z);
    }

    private ContextualFlowColumnScopeImpl(int i, int i2, float f, float f2) {
        this.lineIndex = i;
        this.indexInLine = i2;
        this.maxWidth = f;
        this.maxHeightInLine = f2;
        this.$$delegate_0 = FlowColumnScopeInstance.INSTANCE;
    }

    @Override
    public int getLineIndex() {
        return this.lineIndex;
    }

    @Override
    public int getIndexInLine() {
        return this.indexInLine;
    }

    @Override
    public float getMaxWidth() {
        return this.maxWidth;
    }

    @Override
    public float getMaxHeightInLine() {
        return this.maxHeightInLine;
    }
}
