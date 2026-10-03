package androidx.compose.p002ui.platform;

import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleEventObserver;
import androidx.lifecycle.LifecycleObserver;
import androidx.lifecycle.LifecycleOwner;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;

@Metadata(d1 = {"\u0000\u0018\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\u001a\u001e\u0010\u0000\u001a\b\u0012\u0004\u0012\u00020\u00020\u00012\u0006\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u0006H\u0002¨\u0006\u0007"}, d2 = {"installForLifecycle", "Lkotlin/Function0;", "", "view", "Landroidx/compose/ui/platform/AbstractComposeView;", "lifecycle", "Landroidx/lifecycle/Lifecycle;", "ui_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class ViewCompositionStrategy_androidKt {
    public static final Function0<Unit> installForLifecycle(final AbstractComposeView abstractComposeView, final Lifecycle lifecycle) {
        if (lifecycle.getCurrentState().compareTo(Lifecycle.State.DESTROYED) <= 0) {
            throw new IllegalStateException(("Cannot configure " + abstractComposeView + " to disposeComposition at Lifecycle ON_DESTROY: " + lifecycle + "is already destroyed").toString());
        }
        final LifecycleObserver lifecycleObserver = new LifecycleEventObserver() {
            public final void onStateChanged(LifecycleOwner lifecycleOwner, Lifecycle.Event event) {
                ViewCompositionStrategy_androidKt.installForLifecycle$lambda$1(abstractComposeView, lifecycleOwner, event);
            }
        };
        lifecycle.addObserver(lifecycleObserver);
        return new Function0<Unit>() {
            {
                super(0);
            }

            public Object invoke() {
                m6582invoke();
                return Unit.INSTANCE;
            }

            public final void m6582invoke() {
                lifecycle.removeObserver(lifecycleObserver);
            }
        };
    }

    public static final void installForLifecycle$lambda$1(AbstractComposeView abstractComposeView, LifecycleOwner lifecycleOwner, Lifecycle.Event event) {
        if (event == Lifecycle.Event.ON_DESTROY) {
            abstractComposeView.disposeComposition();
        }
    }
}
