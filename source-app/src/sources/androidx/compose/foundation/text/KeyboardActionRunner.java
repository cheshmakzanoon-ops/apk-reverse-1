package androidx.compose.foundation.text;

import androidx.compose.p002ui.focus.FocusDirection;
import androidx.compose.p002ui.focus.FocusManager;
import androidx.compose.p002ui.platform.SoftwareKeyboardController;
import androidx.compose.ui.text.input.ImeAction;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u00000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0000\u0018\u00002\u00020\u0001B\u000f\u0012\b\u0010\u0002\u001a\u0004\u0018\u00010\u0003¢\u0006\u0002\u0010\u0004J\u001a\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0014H\u0016ø\u0001\u0000¢\u0006\u0004\b\u0015\u0010\u0016J\u0018\u0010\u0017\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0014ø\u0001\u0000¢\u0006\u0004\b\u0018\u0010\u0016R\u001a\u0010\u0005\u001a\u00020\u0006X\u0086.¢\u0006\u000e\n\u0000\u001a\u0004\b\u0007\u0010\b\"\u0004\b\t\u0010\nR\u001a\u0010\u000b\u001a\u00020\fX\u0086.¢\u0006\u000e\n\u0000\u001a\u0004\b\r\u0010\u000e\"\u0004\b\u000f\u0010\u0010R\u0010\u0010\u0002\u001a\u0004\u0018\u00010\u0003X\u0082\u0004¢\u0006\u0002\n\u0000\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\u0019"}, d2 = {"Landroidx/compose/foundation/text/KeyboardActionRunner;", "Landroidx/compose/foundation/text/KeyboardActionScope;", "keyboardController", "Landroidx/compose/ui/platform/SoftwareKeyboardController;", "(Landroidx/compose/ui/platform/SoftwareKeyboardController;)V", "focusManager", "Landroidx/compose/ui/focus/FocusManager;", "getFocusManager", "()Landroidx/compose/ui/focus/FocusManager;", "setFocusManager", "(Landroidx/compose/ui/focus/FocusManager;)V", "keyboardActions", "Landroidx/compose/foundation/text/KeyboardActions;", "getKeyboardActions", "()Landroidx/compose/foundation/text/KeyboardActions;", "setKeyboardActions", "(Landroidx/compose/foundation/text/KeyboardActions;)V", "defaultKeyboardAction", "", "imeAction", "Landroidx/compose/ui/text/input/ImeAction;", "defaultKeyboardAction-KlQnJC8", "(I)V", "runAction", "runAction-KlQnJC8", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class KeyboardActionRunner implements KeyboardActionScope {
    public static final int $stable = 8;
    public FocusManager focusManager;
    public KeyboardActions keyboardActions;
    private final SoftwareKeyboardController keyboardController;

    public KeyboardActionRunner(SoftwareKeyboardController softwareKeyboardController) {
        this.keyboardController = softwareKeyboardController;
    }

    public final KeyboardActions getKeyboardActions() {
        KeyboardActions keyboardActions = this.keyboardActions;
        if (keyboardActions != null) {
            return keyboardActions;
        }
        Intrinsics.throwUninitializedPropertyAccessException("keyboardActions");
        return null;
    }

    public final void setKeyboardActions(KeyboardActions keyboardActions) {
        this.keyboardActions = keyboardActions;
    }

    public final FocusManager getFocusManager() {
        FocusManager focusManager = this.focusManager;
        if (focusManager != null) {
            return focusManager;
        }
        Intrinsics.throwUninitializedPropertyAccessException("focusManager");
        return null;
    }

    public final void setFocusManager(FocusManager focusManager) {
        this.focusManager = focusManager;
    }

    public final void m1459runActionKlQnJC8(int imeAction) {
        Function1<KeyboardActionScope, Unit> onSend;
        Unit unit = null;
        if (ImeAction.equals-impl0(imeAction, ImeAction.Companion.getDone-eUduSuo())) {
            onSend = getKeyboardActions().getOnDone();
        } else if (ImeAction.equals-impl0(imeAction, ImeAction.Companion.getGo-eUduSuo())) {
            onSend = getKeyboardActions().getOnGo();
        } else if (ImeAction.equals-impl0(imeAction, ImeAction.Companion.getNext-eUduSuo())) {
            onSend = getKeyboardActions().getOnNext();
        } else if (ImeAction.equals-impl0(imeAction, ImeAction.Companion.getPrevious-eUduSuo())) {
            onSend = getKeyboardActions().getOnPrevious();
        } else if (ImeAction.equals-impl0(imeAction, ImeAction.Companion.getSearch-eUduSuo())) {
            onSend = getKeyboardActions().getOnSearch();
        } else if (ImeAction.equals-impl0(imeAction, ImeAction.Companion.getSend-eUduSuo())) {
            onSend = getKeyboardActions().getOnSend();
        } else {
            if (!(ImeAction.equals-impl0(imeAction, ImeAction.Companion.getDefault-eUduSuo()) ? true : ImeAction.equals-impl0(imeAction, ImeAction.Companion.getNone-eUduSuo()))) {
                throw new IllegalStateException("invalid ImeAction".toString());
            }
            onSend = null;
        }
        if (onSend != null) {
            onSend.invoke(this);
            unit = Unit.INSTANCE;
        }
        if (unit == null) {
            mo1458defaultKeyboardActionKlQnJC8(imeAction);
        }
    }

    @Override
    public void mo1458defaultKeyboardActionKlQnJC8(int imeAction) {
        if (ImeAction.equals-impl0(imeAction, ImeAction.Companion.getNext-eUduSuo())) {
            getFocusManager().mo4267moveFocus3ESFkO8(FocusDirection.INSTANCE.m4261getNextdhqQ8s());
            return;
        }
        if (ImeAction.equals-impl0(imeAction, ImeAction.Companion.getPrevious-eUduSuo())) {
            getFocusManager().mo4267moveFocus3ESFkO8(FocusDirection.INSTANCE.m4262getPreviousdhqQ8s());
            return;
        }
        if (!ImeAction.equals-impl0(imeAction, ImeAction.Companion.getDone-eUduSuo())) {
            if (ImeAction.equals-impl0(imeAction, ImeAction.Companion.getGo-eUduSuo()) ? true : ImeAction.equals-impl0(imeAction, ImeAction.Companion.getSearch-eUduSuo()) ? true : ImeAction.equals-impl0(imeAction, ImeAction.Companion.getSend-eUduSuo()) ? true : ImeAction.equals-impl0(imeAction, ImeAction.Companion.getDefault-eUduSuo())) {
                return;
            }
            ImeAction.equals-impl0(imeAction, ImeAction.Companion.getNone-eUduSuo());
        } else {
            SoftwareKeyboardController softwareKeyboardController = this.keyboardController;
            if (softwareKeyboardController != null) {
                softwareKeyboardController.hide();
            }
        }
    }
}
