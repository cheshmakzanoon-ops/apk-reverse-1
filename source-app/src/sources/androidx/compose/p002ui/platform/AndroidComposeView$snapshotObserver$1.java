package androidx.compose.p002ui.platform;

import android.os.Handler;
import android.os.Looper;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Lambda;

@Metadata(d1 = {"\u0000\u000e\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\u0010\u0000\u001a\u00020\u00012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00010\u0003H\n¢\u0006\u0002\b\u0004"}, d2 = {"<anonymous>", "", "command", "Lkotlin/Function0;", "invoke"}, k = 3, mv = {1, 8, 0}, xi = 48)
final class AndroidComposeView$snapshotObserver$1 extends Lambda implements Function1<Function0<? extends Unit>, Unit> {
    final AndroidComposeView this$0;

    AndroidComposeView$snapshotObserver$1(AndroidComposeView androidComposeView) {
        super(1);
        this.this$0 = androidComposeView;
    }

    public Object invoke(Object obj) {
        invoke((Function0<Unit>) obj);
        return Unit.INSTANCE;
    }

    public final void invoke(final Function0<Unit> function0) {
        Handler handler = this.this$0.getHandler();
        if ((handler != null ? handler.getLooper() : null) == Looper.myLooper()) {
            function0.invoke();
            return;
        }
        Handler handler2 = this.this$0.getHandler();
        if (handler2 != null) {
            handler2.post(new Runnable() {
                @Override
                public final void run() {
                    function0.invoke();
                }
            });
        }
    }
}
