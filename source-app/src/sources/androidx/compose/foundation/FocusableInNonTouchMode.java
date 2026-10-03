package androidx.compose.foundation;

import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.focus.FocusProperties;
import androidx.compose.p002ui.focus.FocusPropertiesModifierNode;
import androidx.compose.p002ui.input.InputMode;
import androidx.compose.p002ui.input.InputModeManager;
import androidx.compose.p002ui.node.CompositionLocalConsumerModifierNode;
import androidx.compose.p002ui.node.CompositionLocalConsumerModifierNodeKt;
import androidx.compose.p002ui.platform.CompositionLocalsKt;
import kotlin.Metadata;

@Metadata(d1 = {"\u00000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0000\u0018\u00002\u00020\u00012\u00020\u00022\u00020\u0003B\u0005¢\u0006\u0002\u0010\u0004J\u0010\u0010\r\u001a\u00020\u000e2\u0006\u0010\u000f\u001a\u00020\u0010H\u0016R\u0014\u0010\u0005\u001a\u00020\u00068BX\u0082\u0004¢\u0006\u0006\u001a\u0004\b\u0007\u0010\bR\u0014\u0010\t\u001a\u00020\nX\u0096D¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\f¨\u0006\u0011"}, d2 = {"Landroidx/compose/foundation/FocusableInNonTouchMode;", "Landroidx/compose/ui/Modifier$Node;", "Landroidx/compose/ui/node/CompositionLocalConsumerModifierNode;", "Landroidx/compose/ui/focus/FocusPropertiesModifierNode;", "()V", "inputModeManager", "Landroidx/compose/ui/input/InputModeManager;", "getInputModeManager", "()Landroidx/compose/ui/input/InputModeManager;", "shouldAutoInvalidate", "", "getShouldAutoInvalidate", "()Z", "applyFocusProperties", "", "focusProperties", "Landroidx/compose/ui/focus/FocusProperties;", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class FocusableInNonTouchMode extends Modifier.Node implements CompositionLocalConsumerModifierNode, FocusPropertiesModifierNode {
    public static final int $stable = 0;
    private final boolean shouldAutoInvalidate;

    @Override
    public boolean getShouldAutoInvalidate() {
        return this.shouldAutoInvalidate;
    }

    private final InputModeManager getInputModeManager() {
        return (InputModeManager) CompositionLocalConsumerModifierNodeKt.currentValueOf(this, CompositionLocalsKt.getLocalInputModeManager());
    }

    @Override
    public void applyFocusProperties(FocusProperties focusProperties) {
        focusProperties.setCanFocus(!InputMode.m5375equalsimpl0(getInputModeManager().mo5381getInputModeaOaMEAU(), InputMode.INSTANCE.m5380getTouchaOaMEAU()));
    }
}
