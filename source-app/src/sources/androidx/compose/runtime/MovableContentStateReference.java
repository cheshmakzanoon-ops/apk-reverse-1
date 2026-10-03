package androidx.compose.runtime;

import java.util.List;
import kotlin.Metadata;
import kotlin.Pair;

@Metadata(d1 = {"\u0000:\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0012\b\u0007\u0018\u00002\u00020\u0001B]\b\u0000\u0012\u000e\u0010\u0002\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00010\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0001\u0012\u0006\u0010\u0005\u001a\u00020\u0006\u0012\u0006\u0010\u0007\u001a\u00020\b\u0012\u0006\u0010\t\u001a\u00020\n\u0012\u001a\u0010\u000b\u001a\u0016\u0012\u0012\u0012\u0010\u0012\u0004\u0012\u00020\u000e\u0012\u0006\u0012\u0004\u0018\u00010\u00010\r0\f\u0012\u0006\u0010\u000f\u001a\u00020\u0010¢\u0006\u0002\u0010\u0011R\u0014\u0010\t\u001a\u00020\nX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0013R\u0014\u0010\u0005\u001a\u00020\u0006X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u0015R\u001c\u0010\u0002\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00010\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u0017R.\u0010\u000b\u001a\u0016\u0012\u0012\u0012\u0010\u0012\u0004\u0012\u00020\u000e\u0012\u0006\u0012\u0004\u0018\u00010\u00010\r0\fX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0018\u0010\u0019\"\u0004\b\u001a\u0010\u001bR\u0014\u0010\u000f\u001a\u00020\u0010X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001c\u0010\u001dR\u0016\u0010\u0004\u001a\u0004\u0018\u00010\u0001X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001e\u0010\u001fR\u0014\u0010\u0007\u001a\u00020\bX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b \u0010!¨\u0006\""}, d2 = {"Landroidx/compose/runtime/MovableContentStateReference;", "", "content", "Landroidx/compose/runtime/MovableContent;", "parameter", "composition", "Landroidx/compose/runtime/ControlledComposition;", "slotTable", "Landroidx/compose/runtime/SlotTable;", "anchor", "Landroidx/compose/runtime/Anchor;", "invalidations", "", "Lkotlin/Pair;", "Landroidx/compose/runtime/RecomposeScopeImpl;", "locals", "Landroidx/compose/runtime/PersistentCompositionLocalMap;", "(Landroidx/compose/runtime/MovableContent;Ljava/lang/Object;Landroidx/compose/runtime/ControlledComposition;Landroidx/compose/runtime/SlotTable;Landroidx/compose/runtime/Anchor;Ljava/util/List;Landroidx/compose/runtime/PersistentCompositionLocalMap;)V", "getAnchor$runtime_release", "()Landroidx/compose/runtime/Anchor;", "getComposition$runtime_release", "()Landroidx/compose/runtime/ControlledComposition;", "getContent$runtime_release", "()Landroidx/compose/runtime/MovableContent;", "getInvalidations$runtime_release", "()Ljava/util/List;", "setInvalidations$runtime_release", "(Ljava/util/List;)V", "getLocals$runtime_release", "()Landroidx/compose/runtime/PersistentCompositionLocalMap;", "getParameter$runtime_release", "()Ljava/lang/Object;", "getSlotTable$runtime_release", "()Landroidx/compose/runtime/SlotTable;", "runtime_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class MovableContentStateReference {
    public static final int $stable = 8;
    private final Anchor anchor;
    private final ControlledComposition composition;
    private final MovableContent<Object> content;
    private List<? extends Pair<RecomposeScopeImpl, ? extends Object>> invalidations;
    private final PersistentCompositionLocalMap locals;
    private final Object parameter;
    private final SlotTable slotTable;

    public MovableContentStateReference(MovableContent<Object> movableContent, Object obj, ControlledComposition controlledComposition, SlotTable slotTable, Anchor anchor, List<? extends Pair<RecomposeScopeImpl, ? extends Object>> list, PersistentCompositionLocalMap persistentCompositionLocalMap) {
        this.content = movableContent;
        this.parameter = obj;
        this.composition = controlledComposition;
        this.slotTable = slotTable;
        this.anchor = anchor;
        this.invalidations = list;
        this.locals = persistentCompositionLocalMap;
    }

    public final MovableContent<Object> getContent$runtime_release() {
        return this.content;
    }

    public final Object getParameter() {
        return this.parameter;
    }

    public final ControlledComposition getComposition() {
        return this.composition;
    }

    public final SlotTable getSlotTable() {
        return this.slotTable;
    }

    public final Anchor getAnchor() {
        return this.anchor;
    }

    public final List<Pair<RecomposeScopeImpl, Object>> getInvalidations$runtime_release() {
        return this.invalidations;
    }

    public final void setInvalidations$runtime_release(List<? extends Pair<RecomposeScopeImpl, ? extends Object>> list) {
        this.invalidations = list;
    }

    public final PersistentCompositionLocalMap getLocals() {
        return this.locals;
    }
}
