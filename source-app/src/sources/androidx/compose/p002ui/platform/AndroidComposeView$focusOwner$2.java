package androidx.compose.p002ui.platform;

import androidx.compose.p002ui.focus.FocusDirection;
import androidx.compose.p002ui.geometry.Rect;
import kotlin.Metadata;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.FunctionReferenceImpl;

@Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
class AndroidComposeView$focusOwner$2 extends FunctionReferenceImpl implements Function2<FocusDirection, Rect, Boolean> {
    AndroidComposeView$focusOwner$2(Object obj) {
        super(2, obj, AndroidComposeView.class, "onRequestFocusForOwner", "onRequestFocusForOwner-7o62pno(Landroidx/compose/ui/focus/FocusDirection;Landroidx/compose/ui/geometry/Rect;)Z", 0);
    }

    public final Boolean invoke(FocusDirection focusDirection, Rect rect) {
        return Boolean.valueOf(((AndroidComposeView) this.receiver).m6453onRequestFocusForOwner7o62pno(focusDirection, rect));
    }
}
