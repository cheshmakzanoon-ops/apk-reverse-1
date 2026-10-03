package androidx.compose.foundation.text;

import android.view.InputDevice;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.focus.FocusDirection;
import androidx.compose.p002ui.focus.FocusManager;
import androidx.compose.p002ui.input.key.KeyEvent;
import androidx.compose.p002ui.input.key.KeyEventType;
import androidx.compose.p002ui.input.key.KeyEvent_androidKt;
import androidx.compose.p002ui.input.key.KeyInputModifierKt;
import androidx.compose.p002ui.input.key.Key_androidKt;
import androidx.compose.p002ui.platform.SoftwareKeyboardController;
import kotlin.Metadata;
import kotlin.jvm.functions.Function1;

@Metadata(d1 = {"\u0000&\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\u001a\u001c\u0010\u0000\u001a\u00020\u0001*\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0005H\u0000\u001a\u001e\u0010\u0006\u001a\u00020\u0007*\u00020\b2\u0006\u0010\t\u001a\u00020\nH\u0002ø\u0001\u0000¢\u0006\u0004\b\u000b\u0010\f\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\r"}, d2 = {"interceptDPadAndMoveFocus", "Landroidx/compose/ui/Modifier;", "state", "Landroidx/compose/foundation/text/LegacyTextFieldState;", "focusManager", "Landroidx/compose/ui/focus/FocusManager;", "isKeyCode", "", "Landroidx/compose/ui/input/key/KeyEvent;", "keyCode", "", "isKeyCode-YhN2O0w", "(Landroid/view/KeyEvent;I)Z", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class TextFieldFocusModifier_androidKt {
    public static final Modifier interceptDPadAndMoveFocus(Modifier modifier, final LegacyTextFieldState legacyTextFieldState, final FocusManager focusManager) {
        return KeyInputModifierKt.onPreviewKeyEvent(modifier, new Function1<KeyEvent, Boolean>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                return m1538invokeZmokQxo(((KeyEvent) obj).m5686unboximpl());
            }

            public final Boolean m1538invokeZmokQxo(android.view.KeyEvent keyEvent) {
                InputDevice device = keyEvent.getDevice();
                boolean zMo4267moveFocus3ESFkO8 = false;
                if (device != null && device.supportsSource(513) && !device.isVirtual() && KeyEventType.m5690equalsimpl0(KeyEvent_androidKt.m5698getTypeZmokQxo(keyEvent), KeyEventType.INSTANCE.m5694getKeyDownCS__XNY()) && keyEvent.getSource() != 257) {
                    if (TextFieldFocusModifier_androidKt.m1537isKeyCodeYhN2O0w(keyEvent, 19)) {
                        zMo4267moveFocus3ESFkO8 = focusManager.mo4267moveFocus3ESFkO8(FocusDirection.INSTANCE.m4264getUpdhqQ8s());
                    } else if (TextFieldFocusModifier_androidKt.m1537isKeyCodeYhN2O0w(keyEvent, 20)) {
                        zMo4267moveFocus3ESFkO8 = focusManager.mo4267moveFocus3ESFkO8(FocusDirection.INSTANCE.m4257getDowndhqQ8s());
                    } else if (TextFieldFocusModifier_androidKt.m1537isKeyCodeYhN2O0w(keyEvent, 21)) {
                        zMo4267moveFocus3ESFkO8 = focusManager.mo4267moveFocus3ESFkO8(FocusDirection.INSTANCE.m4260getLeftdhqQ8s());
                    } else if (TextFieldFocusModifier_androidKt.m1537isKeyCodeYhN2O0w(keyEvent, 22)) {
                        zMo4267moveFocus3ESFkO8 = focusManager.mo4267moveFocus3ESFkO8(FocusDirection.INSTANCE.m4263getRightdhqQ8s());
                    } else if (TextFieldFocusModifier_androidKt.m1537isKeyCodeYhN2O0w(keyEvent, 23)) {
                        SoftwareKeyboardController keyboardController = legacyTextFieldState.getKeyboardController();
                        if (keyboardController != null) {
                            keyboardController.show();
                        }
                        zMo4267moveFocus3ESFkO8 = true;
                    }
                }
                return Boolean.valueOf(zMo4267moveFocus3ESFkO8);
            }
        });
    }

    public static final boolean m1537isKeyCodeYhN2O0w(android.view.KeyEvent keyEvent, int i) {
        return Key_androidKt.m5704getNativeKeyCodeYVgTNJs(KeyEvent_androidKt.m5697getKeyZmokQxo(keyEvent)) == i;
    }
}
