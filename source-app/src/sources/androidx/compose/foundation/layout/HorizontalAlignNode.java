package androidx.compose.foundation.layout;

import androidx.compose.p002ui.Alignment;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.node.ParentDataModifierNode;
import androidx.compose.ui.unit.Density;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0000\n\u0000\b\u0000\u0018\u00002\u00020\u00012\u00020\u0002B\r\u0012\u0006\u0010\u0003\u001a\u00020\u0004¢\u0006\u0002\u0010\u0005J\u0016\u0010\t\u001a\u00020\n*\u00020\u000b2\b\u0010\f\u001a\u0004\u0018\u00010\rH\u0016R\u001a\u0010\u0003\u001a\u00020\u0004X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0006\u0010\u0007\"\u0004\b\b\u0010\u0005¨\u0006\u000e"}, d2 = {"Landroidx/compose/foundation/layout/HorizontalAlignNode;", "Landroidx/compose/ui/node/ParentDataModifierNode;", "Landroidx/compose/ui/Modifier$Node;", "horizontal", "Landroidx/compose/ui/Alignment$Horizontal;", "(Landroidx/compose/ui/Alignment$Horizontal;)V", "getHorizontal", "()Landroidx/compose/ui/Alignment$Horizontal;", "setHorizontal", "modifyParentData", "Landroidx/compose/foundation/layout/RowColumnParentData;", "Landroidx/compose/ui/unit/Density;", "parentData", "", "foundation-layout_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class HorizontalAlignNode extends Modifier.Node implements ParentDataModifierNode {
    public static final int $stable = 8;
    private Alignment.Horizontal horizontal;

    public final Alignment.Horizontal getHorizontal() {
        return this.horizontal;
    }

    public final void setHorizontal(Alignment.Horizontal horizontal) {
        this.horizontal = horizontal;
    }

    public HorizontalAlignNode(Alignment.Horizontal horizontal) {
        this.horizontal = horizontal;
    }

    @Override
    public RowColumnParentData modifyParentData(Density density, Object obj) {
        RowColumnParentData rowColumnParentData = obj instanceof RowColumnParentData ? (RowColumnParentData) obj : null;
        if (rowColumnParentData == null) {
            rowColumnParentData = new RowColumnParentData(0.0f, false, null, null, 15, null);
        }
        rowColumnParentData.setCrossAxisAlignment(CrossAxisAlignment.INSTANCE.horizontal$foundation_layout_release(this.horizontal));
        return rowColumnParentData;
    }
}
