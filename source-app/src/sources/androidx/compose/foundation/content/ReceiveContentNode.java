package androidx.compose.foundation.content;

import androidx.compose.foundation.content.internal.DragAndDropRequestPermission_androidKt;
import androidx.compose.foundation.content.internal.DynamicReceiveContentConfiguration;
import androidx.compose.foundation.content.internal.ReceiveContentConfiguration;
import androidx.compose.foundation.content.internal.ReceiveContentConfigurationKt;
import androidx.compose.foundation.content.internal.ReceiveContentDragAndDropNode_androidKt;
import androidx.compose.p002ui.draganddrop.DragAndDropEvent;
import androidx.compose.p002ui.modifier.ModifierLocal;
import androidx.compose.p002ui.modifier.ModifierLocalMap;
import androidx.compose.p002ui.modifier.ModifierLocalModifierNode;
import androidx.compose.p002ui.modifier.ModifierLocalModifierNodeKt;
import androidx.compose.p002ui.node.CompositionLocalConsumerModifierNode;
import androidx.compose.p002ui.node.DelegatingNode;
import kotlin.Metadata;
import kotlin.TuplesKt;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;

@Metadata(d1 = {"\u00000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0000\b\u0000\u0018\u00002\u00020\u00012\u00020\u00022\u00020\u0003B\r\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\u000e\u0010\u0010\u001a\u00020\u00112\u0006\u0010\u0004\u001a\u00020\u0005R\u0014\u0010\u0007\u001a\u00020\bX\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\nR\u000e\u0010\u000b\u001a\u00020\fX\u0082\u0004¢\u0006\u0002\n\u0000R\u001a\u0010\u0004\u001a\u00020\u0005X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\r\u0010\u000e\"\u0004\b\u000f\u0010\u0006¨\u0006\u0012"}, d2 = {"Landroidx/compose/foundation/content/ReceiveContentNode;", "Landroidx/compose/ui/node/DelegatingNode;", "Landroidx/compose/ui/modifier/ModifierLocalModifierNode;", "Landroidx/compose/ui/node/CompositionLocalConsumerModifierNode;", "receiveContentListener", "Landroidx/compose/foundation/content/ReceiveContentListener;", "(Landroidx/compose/foundation/content/ReceiveContentListener;)V", "providedValues", "Landroidx/compose/ui/modifier/ModifierLocalMap;", "getProvidedValues", "()Landroidx/compose/ui/modifier/ModifierLocalMap;", "receiveContentConfiguration", "Landroidx/compose/foundation/content/internal/ReceiveContentConfiguration;", "getReceiveContentListener", "()Landroidx/compose/foundation/content/ReceiveContentListener;", "setReceiveContentListener", "updateNode", "", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class ReceiveContentNode extends DelegatingNode implements ModifierLocalModifierNode, CompositionLocalConsumerModifierNode {
    public static final int $stable = 8;
    private final ModifierLocalMap providedValues;
    private final ReceiveContentConfiguration receiveContentConfiguration;
    private ReceiveContentListener receiveContentListener;

    @Override
    public Object getCurrent(ModifierLocal modifierLocal) {
        return ModifierLocalModifierNode.CC.$default$getCurrent(this, modifierLocal);
    }

    @Override
    public void provide(ModifierLocal modifierLocal, Object obj) {
        ModifierLocalModifierNode.CC.$default$provide(this, modifierLocal, obj);
    }

    public final ReceiveContentListener getReceiveContentListener() {
        return this.receiveContentListener;
    }

    public final void setReceiveContentListener(ReceiveContentListener receiveContentListener) {
        this.receiveContentListener = receiveContentListener;
    }

    public ReceiveContentNode(ReceiveContentListener receiveContentListener) {
        this.receiveContentListener = receiveContentListener;
        DynamicReceiveContentConfiguration dynamicReceiveContentConfiguration = new DynamicReceiveContentConfiguration(this);
        this.receiveContentConfiguration = dynamicReceiveContentConfiguration;
        this.providedValues = ModifierLocalModifierNodeKt.modifierLocalMapOf(TuplesKt.to(ReceiveContentConfigurationKt.getModifierLocalReceiveContent(), dynamicReceiveContentConfiguration));
        delegate(ReceiveContentDragAndDropNode_androidKt.ReceiveContentDragAndDropNode(dynamicReceiveContentConfiguration, new Function1<DragAndDropEvent, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((DragAndDropEvent) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(DragAndDropEvent dragAndDropEvent) {
                DragAndDropRequestPermission_androidKt.dragAndDropRequestPermission(ReceiveContentNode.this, dragAndDropEvent);
            }
        }));
    }

    @Override
    public ModifierLocalMap getProvidedValues() {
        return this.providedValues;
    }

    public final void updateNode(ReceiveContentListener receiveContentListener) {
        this.receiveContentListener = receiveContentListener;
    }
}
