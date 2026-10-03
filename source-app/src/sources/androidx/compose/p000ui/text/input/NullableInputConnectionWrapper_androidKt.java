package androidx.compose.p000ui.text.input;

import android.os.Build;
import android.view.inputmethod.InputConnection;
import androidx.constraintlayout.widget.ConstraintLayout;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;

@Metadata(d1 = {"\u0000\u0018\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0000\u001a$\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\u0012\u0010\u0004\u001a\u000e\u0012\u0004\u0012\u00020\u0001\u0012\u0004\u0012\u00020\u00060\u0005H\u0000¨\u0006\u0007"}, d2 = {"NullableInputConnectionWrapper", "Landroidx/compose/ui/text/input/NullableInputConnectionWrapper;", "delegate", "Landroid/view/inputmethod/InputConnection;", "onConnectionClosed", "Lkotlin/Function1;", "", "ui_release"}, k = 2, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class NullableInputConnectionWrapper_androidKt {
    public static final NullableInputConnectionWrapper NullableInputConnectionWrapper(InputConnection inputConnection, Function1<? super NullableInputConnectionWrapper, Unit> function1) {
        if (Build.VERSION.SDK_INT >= 34) {
            return new NullableInputConnectionWrapperApi34(inputConnection, function1);
        }
        if (Build.VERSION.SDK_INT >= 25) {
            return new NullableInputConnectionWrapperApi25(inputConnection, function1);
        }
        if (Build.VERSION.SDK_INT >= 24) {
            return new NullableInputConnectionWrapperApi24(inputConnection, function1);
        }
        return new NullableInputConnectionWrapperApi21(inputConnection, function1);
    }
}
