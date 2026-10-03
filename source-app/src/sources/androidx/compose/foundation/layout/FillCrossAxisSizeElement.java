package androidx.compose.foundation.layout;

import androidx.compose.p002ui.node.ModifierNodeElement;
import androidx.compose.p002ui.platform.InspectorInfo;
import kotlin.Metadata;

@Metadata(d1 = {"\u00006\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0007\n\u0002\b\u0005\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\b\u0000\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\r\u0012\u0006\u0010\u0003\u001a\u00020\u0004¢\u0006\u0002\u0010\u0005J\b\u0010\b\u001a\u00020\u0002H\u0016J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fH\u0096\u0002J\b\u0010\r\u001a\u00020\u000eH\u0016J\u0010\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u0002H\u0016J\f\u0010\u0012\u001a\u00020\u0010*\u00020\u0013H\u0016R\u0011\u0010\u0003\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0014"}, d2 = {"Landroidx/compose/foundation/layout/FillCrossAxisSizeElement;", "Landroidx/compose/ui/node/ModifierNodeElement;", "Landroidx/compose/foundation/layout/FillCrossAxisSizeNode;", "fraction", "", "(F)V", "getFraction", "()F", "create", "equals", "", "other", "", "hashCode", "", "update", "", "node", "inspectableProperties", "Landroidx/compose/ui/platform/InspectorInfo;", "foundation-layout_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class FillCrossAxisSizeElement extends ModifierNodeElement<FillCrossAxisSizeNode> {
    public static final int $stable = 0;
    private final float fraction;

    public final float getFraction() {
        return this.fraction;
    }

    public FillCrossAxisSizeElement(float f) {
        this.fraction = f;
    }

    @Override
    public FillCrossAxisSizeNode getNode() {
        return new FillCrossAxisSizeNode(this.fraction);
    }

    @Override
    public void update(FillCrossAxisSizeNode node) {
        node.setFraction(this.fraction);
    }

    @Override
    public void inspectableProperties(InspectorInfo inspectorInfo) {
        inspectorInfo.setName("fraction");
        inspectorInfo.setValue(Float.valueOf(this.fraction));
        inspectorInfo.getProperties().set("fraction", Float.valueOf(this.fraction));
    }

    @Override
    public int hashCode() {
        return Float.floatToIntBits(this.fraction) * 31;
    }

    @Override
    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        FillCrossAxisSizeNode fillCrossAxisSizeNode = other instanceof FillCrossAxisSizeNode ? (FillCrossAxisSizeNode) other : null;
        return fillCrossAxisSizeNode != null && this.fraction == fillCrossAxisSizeNode.getFraction();
    }
}
