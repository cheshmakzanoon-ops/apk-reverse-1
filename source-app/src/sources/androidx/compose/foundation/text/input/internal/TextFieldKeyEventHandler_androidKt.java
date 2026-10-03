package androidx.compose.foundation.text.input.internal;

import android.view.KeyEvent;
import androidx.compose.p002ui.input.key.KeyEvent_androidKt;
import androidx.compose.p002ui.input.key.Key_androidKt;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000\u001e\n\u0000\n\u0002\u0010\u000b\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0003\u001a\b\u0010\u0005\u001a\u00020\u0006H\u0000\u001a\u001e\u0010\u0007\u001a\u00020\u0001*\u00020\u00022\u0006\u0010\b\u001a\u00020\tH\u0002ø\u0001\u0000¢\u0006\u0004\b\n\u0010\u000b\"\u0018\u0010\u0000\u001a\u00020\u0001*\u00020\u00028@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b\u0003\u0010\u0004\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\f"}, d2 = {"isFromSoftKeyboard", "", "Landroidx/compose/ui/input/key/KeyEvent;", "isFromSoftKeyboard-ZmokQxo", "(Landroid/view/KeyEvent;)Z", "createTextFieldKeyEventHandler", "Landroidx/compose/foundation/text/input/internal/TextFieldKeyEventHandler;", "isKeyCode", "keyCode", "", "isKeyCode-YhN2O0w", "(Landroid/view/KeyEvent;I)Z", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class TextFieldKeyEventHandler_androidKt {
    public static final TextFieldKeyEventHandler createTextFieldKeyEventHandler() {
        return new AndroidTextFieldKeyEventHandler();
    }

    public static final boolean m1697isFromSoftKeyboardZmokQxo(KeyEvent keyEvent) {
        return (keyEvent.getFlags() & 2) == 2;
    }

    public static final boolean m1698isKeyCodeYhN2O0w(KeyEvent keyEvent, int i) {
        return Key_androidKt.m5704getNativeKeyCodeYVgTNJs(KeyEvent_androidKt.m5697getKeyZmokQxo(keyEvent)) == i;
    }
}
