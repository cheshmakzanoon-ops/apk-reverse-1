package androidx.compose.p002ui.input.key;

import android.view.KeyEvent;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000,\n\u0000\n\u0002\u0010\u000b\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\"\u0015\u0010\u0000\u001a\u00020\u0001*\u00020\u00028F¢\u0006\u0006\u001a\u0004\b\u0003\u0010\u0004\"\u0015\u0010\u0005\u001a\u00020\u0001*\u00020\u00028F¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0004\"\u0015\u0010\u0007\u001a\u00020\u0001*\u00020\u00028F¢\u0006\u0006\u001a\u0004\b\b\u0010\u0004\"\u0015\u0010\t\u001a\u00020\u0001*\u00020\u00028F¢\u0006\u0006\u001a\u0004\b\n\u0010\u0004\"\u0015\u0010\u000b\u001a\u00020\f*\u00020\u00028F¢\u0006\u0006\u001a\u0004\b\r\u0010\u000e\"\u0015\u0010\u000f\u001a\u00020\u0010*\u00020\u00028F¢\u0006\u0006\u001a\u0004\b\u0011\u0010\u0012\"\u0015\u0010\u0013\u001a\u00020\u0014*\u00020\u00028F¢\u0006\u0006\u001a\u0004\b\u0015\u0010\u0012*\n\u0010\u0016\"\u00020\u00172\u00020\u0017¨\u0006\u0018"}, d2 = {"isAltPressed", "", "Landroidx/compose/ui/input/key/KeyEvent;", "isAltPressed-ZmokQxo", "(Landroid/view/KeyEvent;)Z", "isCtrlPressed", "isCtrlPressed-ZmokQxo", "isMetaPressed", "isMetaPressed-ZmokQxo", "isShiftPressed", "isShiftPressed-ZmokQxo", "key", "Landroidx/compose/ui/input/key/Key;", "getKey-ZmokQxo", "(Landroid/view/KeyEvent;)J", "type", "Landroidx/compose/ui/input/key/KeyEventType;", "getType-ZmokQxo", "(Landroid/view/KeyEvent;)I", "utf16CodePoint", "", "getUtf16CodePoint-ZmokQxo", "NativeKeyEvent", "Landroid/view/KeyEvent;", "ui_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class KeyEvent_androidKt {
    public static final long m5697getKeyZmokQxo(KeyEvent keyEvent) {
        return Key_androidKt.Key(keyEvent.getKeyCode());
    }

    public static final int m5699getUtf16CodePointZmokQxo(KeyEvent keyEvent) {
        return keyEvent.getUnicodeChar();
    }

    public static final int m5698getTypeZmokQxo(KeyEvent keyEvent) {
        int action = keyEvent.getAction();
        if (action == 0) {
            return KeyEventType.INSTANCE.m5694getKeyDownCS__XNY();
        }
        if (action == 1) {
            return KeyEventType.INSTANCE.m5695getKeyUpCS__XNY();
        }
        return KeyEventType.INSTANCE.m5696getUnknownCS__XNY();
    }

    public static final boolean m5700isAltPressedZmokQxo(KeyEvent keyEvent) {
        return keyEvent.isAltPressed();
    }

    public static final boolean m5701isCtrlPressedZmokQxo(KeyEvent keyEvent) {
        return keyEvent.isCtrlPressed();
    }

    public static final boolean m5702isMetaPressedZmokQxo(KeyEvent keyEvent) {
        return keyEvent.isMetaPressed();
    }

    public static final boolean m5703isShiftPressedZmokQxo(KeyEvent keyEvent) {
        return keyEvent.isShiftPressed();
    }
}
