package androidx.compose.p000ui.text.input;

import android.os.Handler;
import android.view.inputmethod.InputConnection;
import androidx.constraintlayout.widget.ConstraintLayout;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;

@Metadata(d1 = {"\u00004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\b\u0013\u0018\u00002\u00020\u0001B!\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0012\u0010\u0004\u001a\u000e\u0012\u0004\u0012\u00020\u0006\u0012\u0004\u0012\u00020\u00070\u0005¢\u0006\u0002\u0010\bJ\u0010\u0010\t\u001a\u00020\u00072\u0006\u0010\u0002\u001a\u00020\u0003H\u0004J\u0016\u0010\n\u001a\u00020\u000b2\u0006\u0010\f\u001a\u00020\r2\u0006\u0010\u000e\u001a\u00020\rJ\b\u0010\u000f\u001a\u0004\u0018\u00010\u0010¨\u0006\u0011"}, d2 = {"Landroidx/compose/ui/text/input/NullableInputConnectionWrapperApi24;", "Landroidx/compose/ui/text/input/NullableInputConnectionWrapperApi21;", "delegate", "Landroid/view/inputmethod/InputConnection;", "onConnectionClosed", "Lkotlin/Function1;", "Landroidx/compose/ui/text/input/NullableInputConnectionWrapper;", "", "(Landroid/view/inputmethod/InputConnection;Lkotlin/jvm/functions/Function1;)V", "closeDelegate", "deleteSurroundingTextInCodePoints", "", "p0", "", "p1", "getHandler", "Landroid/os/Handler;", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
class NullableInputConnectionWrapperApi24 extends NullableInputConnectionWrapperApi21 {
    public NullableInputConnectionWrapperApi24(InputConnection inputConnection, Function1<? super NullableInputConnectionWrapper, Unit> function1) {
        super(inputConnection, function1);
    }

    @Override
    public final boolean deleteSurroundingTextInCodePoints(int p0, int p1) {
        InputConnection delegate = getDelegate();
        if (delegate != null) {
            return delegate.deleteSurroundingTextInCodePoints(p0, p1);
        }
        return false;
    }

    @Override
    public final Handler getHandler() {
        InputConnection delegate = getDelegate();
        if (delegate != null) {
            return delegate.getHandler();
        }
        return null;
    }

    @Override
    protected final void closeDelegate(InputConnection delegate) {
        delegate.closeConnection();
    }
}
