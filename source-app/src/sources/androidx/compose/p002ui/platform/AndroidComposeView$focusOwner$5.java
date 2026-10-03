package androidx.compose.p002ui.platform;

import androidx.compose.p002ui.geometry.Rect;
import kotlin.Metadata;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.FunctionReferenceImpl;

@Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
class AndroidComposeView$focusOwner$5 extends FunctionReferenceImpl implements Function0<Rect> {
    AndroidComposeView$focusOwner$5(Object obj) {
        super(0, obj, AndroidComposeView.class, "onFetchFocusRect", "onFetchFocusRect()Landroidx/compose/ui/geometry/Rect;", 0);
    }

    public final Rect m6466invoke() {
        return ((AndroidComposeView) this.receiver).onFetchFocusRect();
    }
}
