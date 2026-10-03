package androidx.compose.foundation.text.handwriting;

import androidx.compose.p002ui.node.ModifierNodeElement;
import androidx.compose.p002ui.platform.InspectorInfo;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;

@Metadata(d1 = {"\u00004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\b\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0013\u0012\f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004¢\u0006\u0002\u0010\u0006J\b\u0010\u0007\u001a\u00020\u0002H\u0016J\u0013\u0010\b\u001a\u00020\t2\b\u0010\n\u001a\u0004\u0018\u00010\u000bH\u0096\u0002J\b\u0010\f\u001a\u00020\rH\u0016J\u0010\u0010\u000e\u001a\u00020\u00052\u0006\u0010\u000f\u001a\u00020\u0002H\u0016J\f\u0010\u0010\u001a\u00020\u0005*\u00020\u0011H\u0016R\u0014\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0012"}, d2 = {"Landroidx/compose/foundation/text/handwriting/HandwritingDetectorElement;", "Landroidx/compose/ui/node/ModifierNodeElement;", "Landroidx/compose/foundation/text/handwriting/HandwritingDetectorNode;", "callback", "Lkotlin/Function0;", "", "(Lkotlin/jvm/functions/Function0;)V", "create", "equals", "", "other", "", "hashCode", "", "update", "node", "inspectableProperties", "Landroidx/compose/ui/platform/InspectorInfo;", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
final class HandwritingDetectorElement extends ModifierNodeElement<HandwritingDetectorNode> {
    private final Function0<Unit> callback;

    public HandwritingDetectorElement(Function0<Unit> function0) {
        this.callback = function0;
    }

    @Override
    public HandwritingDetectorNode getNode() {
        return new HandwritingDetectorNode(this.callback);
    }

    @Override
    public void update(HandwritingDetectorNode node) {
        node.setCallback(this.callback);
    }

    @Override
    public int hashCode() {
        return this.callback.hashCode() * 31;
    }

    @Override
    public boolean equals(Object other) {
        return (this == other) | ((other instanceof HandwritingDetectorElement) && this.callback == ((HandwritingDetectorElement) other).callback);
    }

    @Override
    public void inspectableProperties(InspectorInfo inspectorInfo) {
        inspectorInfo.setName("handwritingDetector");
        inspectorInfo.getProperties().set("callback", this.callback);
    }
}
