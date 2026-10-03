package androidx.compose.p002ui.platform;

import androidx.compose.p002ui.focus.FocusDirection;
import kotlin.Metadata;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.FunctionReferenceImpl;

@Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
class AndroidComposeView$focusOwner$3 extends FunctionReferenceImpl implements Function1<FocusDirection, Boolean> {
    AndroidComposeView$focusOwner$3(Object obj) {
        super(1, obj, AndroidComposeView.class, "onMoveFocusInChildren", "onMoveFocusInChildren-3ESFkO8(I)Z", 0);
    }

    public Object invoke(Object obj) {
        return m6464invoke3ESFkO8(((FocusDirection) obj).getValue());
    }

    public final Boolean m6464invoke3ESFkO8(int i) {
        return Boolean.valueOf(((AndroidComposeView) this.receiver).m6452onMoveFocusInChildren3ESFkO8(i));
    }
}
