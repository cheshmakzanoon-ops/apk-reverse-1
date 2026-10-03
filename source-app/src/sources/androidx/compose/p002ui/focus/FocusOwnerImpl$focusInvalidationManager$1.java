package androidx.compose.p002ui.focus;

import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.FunctionReferenceImpl;

@Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
class FocusOwnerImpl$focusInvalidationManager$1 extends FunctionReferenceImpl implements Function0<Unit> {
    FocusOwnerImpl$focusInvalidationManager$1(Object obj) {
        super(0, obj, FocusOwnerImpl.class, "invalidateOwnerFocusState", "invalidateOwnerFocusState()V", 0);
    }

    public Object invoke() {
        m4280invoke();
        return Unit.INSTANCE;
    }

    public final void m4280invoke() {
        ((FocusOwnerImpl) this.receiver).invalidateOwnerFocusState();
    }
}
