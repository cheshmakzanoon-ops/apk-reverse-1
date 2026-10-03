package androidx.compose.foundation.text.selection;

import androidx.collection.LongObjectMap;
import androidx.collection.LongObjectMapKt;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;

@Metadata(d1 = {"\u0000L\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0016\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0002\b\u0002\b\u0002\u0018\u0000 .2\u00020\u0001:\u0001.B/\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0005\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\b\u0012\u0006\u0010\t\u001a\u00020\n¢\u0006\u0002\u0010\u000bJ\u0016\u0010#\u001a\b\u0012\u0004\u0012\u00020\b0$2\u0006\u0010%\u001a\u00020\bH\u0016J\u001c\u0010&\u001a\u00020'2\u0012\u0010(\u001a\u000e\u0012\u0004\u0012\u00020\n\u0012\u0004\u0012\u00020'0)H\u0016J\u0012\u0010*\u001a\u00020\u00032\b\u0010+\u001a\u0004\u0018\u00010\u0001H\u0016J\b\u0010,\u001a\u00020-H\u0016R\u0014\u0010\f\u001a\u00020\r8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u000e\u0010\u000fR\u0014\u0010\u0010\u001a\u00020\n8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u0011\u0010\u0012R\u0014\u0010\u0013\u001a\u00020\n8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u0014\u0010\u0012R\u0014\u0010\u0006\u001a\u00020\u0005X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0016R\u0014\u0010\u0017\u001a\u00020\n8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u0018\u0010\u0012R\u000e\u0010\t\u001a\u00020\nX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u0002\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0002\u0010\u0019R\u0014\u0010\u001a\u001a\u00020\n8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u001b\u0010\u0012R\u0016\u0010\u0007\u001a\u0004\u0018\u00010\bX\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001c\u0010\u001dR\u0014\u0010\u001e\u001a\u00020\u00058VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u001f\u0010\u0016R\u0014\u0010 \u001a\u00020\n8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b!\u0010\u0012R\u0014\u0010\u0004\u001a\u00020\u0005X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\"\u0010\u0016¨\u0006/"}, d2 = {"Landroidx/compose/foundation/text/selection/SingleSelectionLayout;", "Landroidx/compose/foundation/text/selection/SelectionLayout;", "isStartHandle", "", "startSlot", "", "endSlot", "previousSelection", "Landroidx/compose/foundation/text/selection/Selection;", "info", "Landroidx/compose/foundation/text/selection/SelectableInfo;", "(ZIILandroidx/compose/foundation/text/selection/Selection;Landroidx/compose/foundation/text/selection/SelectableInfo;)V", "crossStatus", "Landroidx/compose/foundation/text/selection/CrossStatus;", "getCrossStatus", "()Landroidx/compose/foundation/text/selection/CrossStatus;", "currentInfo", "getCurrentInfo", "()Landroidx/compose/foundation/text/selection/SelectableInfo;", "endInfo", "getEndInfo", "getEndSlot", "()I", "firstInfo", "getFirstInfo", "()Z", "lastInfo", "getLastInfo", "getPreviousSelection", "()Landroidx/compose/foundation/text/selection/Selection;", "size", "getSize", "startInfo", "getStartInfo", "getStartSlot", "createSubSelections", "Landroidx/collection/LongObjectMap;", "selection", "forEachMiddleInfo", "", "block", "Lkotlin/Function1;", "shouldRecomputeSelection", "other", "toString", "", "Companion", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
final class SingleSelectionLayout implements SelectionLayout {
    public static final long DEFAULT_SELECTABLE_ID = 1;
    public static final int DEFAULT_SLOT = 1;
    private final int endSlot;
    private final SelectableInfo info;
    private final boolean isStartHandle;
    private final Selection previousSelection;
    private final int startSlot;

    @Override
    public void forEachMiddleInfo(Function1<? super SelectableInfo, Unit> block) {
    }

    @Override
    public int getSize() {
        return 1;
    }

    public SingleSelectionLayout(boolean z, int i, int i2, Selection selection, SelectableInfo selectableInfo) {
        this.isStartHandle = z;
        this.startSlot = i;
        this.endSlot = i2;
        this.previousSelection = selection;
        this.info = selectableInfo;
    }

    @Override
    public boolean getIsStartHandle() {
        return this.isStartHandle;
    }

    @Override
    public int getStartSlot() {
        return this.startSlot;
    }

    @Override
    public int getEndSlot() {
        return this.endSlot;
    }

    @Override
    public Selection getPreviousSelection() {
        return this.previousSelection;
    }

    @Override
    public CrossStatus getCrossStatus() {
        if (getStartSlot() < getEndSlot()) {
            return CrossStatus.NOT_CROSSED;
        }
        return getStartSlot() > getEndSlot() ? CrossStatus.CROSSED : this.info.getRawCrossStatus();
    }

    @Override
    public SelectableInfo getStartInfo() {
        return this.info;
    }

    @Override
    public SelectableInfo getEndInfo() {
        return this.info;
    }

    @Override
    public SelectableInfo getInfo() {
        return this.info;
    }

    @Override
    public SelectableInfo getFirstInfo() {
        return this.info;
    }

    @Override
    public SelectableInfo getLastInfo() {
        return this.info;
    }

    @Override
    public boolean shouldRecomputeSelection(SelectionLayout other) {
        if (getPreviousSelection() != null && other != null && (other instanceof SingleSelectionLayout)) {
            SingleSelectionLayout singleSelectionLayout = (SingleSelectionLayout) other;
            if (getStartSlot() == singleSelectionLayout.getStartSlot() && getEndSlot() == singleSelectionLayout.getEndSlot() && getIsStartHandle() == singleSelectionLayout.getIsStartHandle() && !this.info.shouldRecomputeSelection(singleSelectionLayout.info)) {
                return false;
            }
        }
        return true;
    }

    @Override
    public LongObjectMap<Selection> createSubSelections(Selection selection) {
        if ((!selection.getHandlesCrossed() && selection.getStart().getOffset() > selection.getEnd().getOffset()) || (selection.getHandlesCrossed() && selection.getStart().getOffset() <= selection.getEnd().getOffset())) {
            selection = Selection.copy$default(selection, null, null, !selection.getHandlesCrossed(), 3, null);
        }
        return LongObjectMapKt.longObjectMapOf(this.info.getSelectableId(), selection);
    }

    public String toString() {
        return "SingleSelectionLayout(isStartHandle=" + getIsStartHandle() + ", crossed=" + getCrossStatus() + ", info=\n\t" + this.info + ')';
    }
}
