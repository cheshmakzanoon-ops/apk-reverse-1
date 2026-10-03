package androidx.compose.p002ui.platform;

import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.FunctionReferenceImpl;

@Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
class AndroidComposeView$focusOwner$4 extends FunctionReferenceImpl implements Function0<Unit> {
    AndroidComposeView$focusOwner$4(Object obj) {
        super(0, obj, AndroidComposeView.class, "onClearFocusForOwner", "onClearFocusForOwner()V", 0);
    }

    public Object invoke() {
        m6465invoke();
        return Unit.INSTANCE;
    }

    public final void m6465invoke() {
        ((AndroidComposeView) this.receiver).onClearFocusForOwner();
    }
}
