package androidx.compose.p002ui.platform;

import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.FunctionReferenceImpl;

@Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
class AndroidComposeView$focusOwner$1 extends FunctionReferenceImpl implements Function1<Function0<? extends Unit>, Unit> {
    AndroidComposeView$focusOwner$1(Object obj) {
        super(1, obj, AndroidComposeView.class, "registerOnEndApplyChangesListener", "registerOnEndApplyChangesListener(Lkotlin/jvm/functions/Function0;)V", 0);
    }

    public Object invoke(Object obj) {
        invoke((Function0<Unit>) obj);
        return Unit.INSTANCE;
    }

    public final void invoke(Function0<Unit> function0) {
        ((AndroidComposeView) this.receiver).registerOnEndApplyChangesListener(function0);
    }
}
