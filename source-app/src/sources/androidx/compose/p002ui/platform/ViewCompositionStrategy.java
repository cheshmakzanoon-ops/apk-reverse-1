package androidx.compose.p002ui.platform;

import android.view.View;
import androidx.compose.p002ui.internal.InlineClassHelperKt;
import androidx.customview.poolingcontainer.PoolingContainer;
import androidx.customview.poolingcontainer.PoolingContainerListener;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleOwner;
import androidx.lifecycle.ViewTreeLifecycleOwner;
import kotlin.KotlinNothingValueException;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.Ref;

@Metadata(d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\bf\u0018\u0000 \u00072\u00020\u0001:\u0005\u0007\b\t\n\u000bJ\u0016\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\u0006\u0010\u0005\u001a\u00020\u0006H&ø\u0001\u0000\u0082\u0002\u0006\n\u0004\b!0\u0001¨\u0006\fÀ\u0006\u0001"}, d2 = {"Landroidx/compose/ui/platform/ViewCompositionStrategy;", "", "installFor", "Lkotlin/Function0;", "", "view", "Landroidx/compose/ui/platform/AbstractComposeView;", "Companion", "DisposeOnDetachedFromWindow", "DisposeOnDetachedFromWindowOrReleasedFromPool", "DisposeOnLifecycleDestroyed", "DisposeOnViewTreeLifecycleDestroyed", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public interface ViewCompositionStrategy {

    public static final Companion INSTANCE = Companion.$$INSTANCE;

    Function0<Unit> installFor(AbstractComposeView view);

    @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u0011\u0010\u0003\u001a\u00020\u00048F¢\u0006\u0006\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0007"}, d2 = {"Landroidx/compose/ui/platform/ViewCompositionStrategy$Companion;", "", "()V", "Default", "Landroidx/compose/ui/platform/ViewCompositionStrategy;", "getDefault", "()Landroidx/compose/ui/platform/ViewCompositionStrategy;", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class Companion {
        static final Companion $$INSTANCE = new Companion();

        private Companion() {
        }

        public final ViewCompositionStrategy getDefault() {
            return DisposeOnDetachedFromWindowOrReleasedFromPool.INSTANCE;
        }
    }

    @Metadata(d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\bÇ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0016\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u00042\u0006\u0010\u0006\u001a\u00020\u0007H\u0016¨\u0006\b"}, d2 = {"Landroidx/compose/ui/platform/ViewCompositionStrategy$DisposeOnDetachedFromWindowOrReleasedFromPool;", "Landroidx/compose/ui/platform/ViewCompositionStrategy;", "()V", "installFor", "Lkotlin/Function0;", "", "view", "Landroidx/compose/ui/platform/AbstractComposeView;", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class DisposeOnDetachedFromWindowOrReleasedFromPool implements ViewCompositionStrategy {
        public static final int $stable = 0;
        public static final DisposeOnDetachedFromWindowOrReleasedFromPool INSTANCE = new DisposeOnDetachedFromWindowOrReleasedFromPool();

        private DisposeOnDetachedFromWindowOrReleasedFromPool() {
        }

        @Override
        public Function0<Unit> installFor(final AbstractComposeView view) {
            final ?? r0 = new View.OnAttachStateChangeListener() {
                @Override
                public void onViewAttachedToWindow(View v) {
                }

                @Override
                public void onViewDetachedFromWindow(View v) {
                    if (PoolingContainer.isWithinPoolingContainer(view)) {
                        return;
                    }
                    view.disposeComposition();
                }
            };
            view.addOnAttachStateChangeListener((View.OnAttachStateChangeListener) r0);
            final PoolingContainerListener poolingContainerListener = new PoolingContainerListener() {
                public final void onRelease() {
                    view.disposeComposition();
                }
            };
            PoolingContainer.addPoolingContainerListener(view, poolingContainerListener);
            return new Function0<Unit>() {
                {
                    super(0);
                }

                public Object invoke() {
                    m6578invoke();
                    return Unit.INSTANCE;
                }

                public final void m6578invoke() {
                    view.removeOnAttachStateChangeListener(r0);
                    PoolingContainer.removePoolingContainerListener(view, poolingContainerListener);
                }
            };
        }
    }

    @Metadata(d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\bÇ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0016\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u00042\u0006\u0010\u0006\u001a\u00020\u0007H\u0016¨\u0006\b"}, d2 = {"Landroidx/compose/ui/platform/ViewCompositionStrategy$DisposeOnDetachedFromWindow;", "Landroidx/compose/ui/platform/ViewCompositionStrategy;", "()V", "installFor", "Lkotlin/Function0;", "", "view", "Landroidx/compose/ui/platform/AbstractComposeView;", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class DisposeOnDetachedFromWindow implements ViewCompositionStrategy {
        public static final int $stable = 0;
        public static final DisposeOnDetachedFromWindow INSTANCE = new DisposeOnDetachedFromWindow();

        private DisposeOnDetachedFromWindow() {
        }

        @Override
        public Function0<Unit> installFor(final AbstractComposeView view) {
            final ?? r0 = new View.OnAttachStateChangeListener() {
                @Override
                public void onViewAttachedToWindow(View v) {
                }

                @Override
                public void onViewDetachedFromWindow(View v) {
                    view.disposeComposition();
                }
            };
            view.addOnAttachStateChangeListener((View.OnAttachStateChangeListener) r0);
            return new Function0<Unit>() {
                {
                    super(0);
                }

                public Object invoke() {
                    m6576invoke();
                    return Unit.INSTANCE;
                }

                public final void m6576invoke() {
                    view.removeOnAttachStateChangeListener(r0);
                }
            };
        }
    }

    @Metadata(d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0007\u0018\u00002\u00020\u0001B\u000f\b\u0016\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\r\u0012\u0006\u0010\u0005\u001a\u00020\u0006¢\u0006\u0002\u0010\u0007J\u0016\u0010\b\u001a\b\u0012\u0004\u0012\u00020\n0\t2\u0006\u0010\u000b\u001a\u00020\fH\u0016R\u000e\u0010\u0005\u001a\u00020\u0006X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\r"}, d2 = {"Landroidx/compose/ui/platform/ViewCompositionStrategy$DisposeOnLifecycleDestroyed;", "Landroidx/compose/ui/platform/ViewCompositionStrategy;", "lifecycleOwner", "Landroidx/lifecycle/LifecycleOwner;", "(Landroidx/lifecycle/LifecycleOwner;)V", "lifecycle", "Landroidx/lifecycle/Lifecycle;", "(Landroidx/lifecycle/Lifecycle;)V", "installFor", "Lkotlin/Function0;", "", "view", "Landroidx/compose/ui/platform/AbstractComposeView;", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class DisposeOnLifecycleDestroyed implements ViewCompositionStrategy {
        public static final int $stable = 8;
        private final Lifecycle lifecycle;

        public DisposeOnLifecycleDestroyed(Lifecycle lifecycle) {
            this.lifecycle = lifecycle;
        }

        public DisposeOnLifecycleDestroyed(LifecycleOwner lifecycleOwner) {
            this(lifecycleOwner.getLifecycle());
        }

        @Override
        public Function0<Unit> installFor(AbstractComposeView view) {
            return ViewCompositionStrategy_androidKt.installForLifecycle(view, this.lifecycle);
        }
    }

    @Metadata(d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\bÇ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0016\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u00042\u0006\u0010\u0006\u001a\u00020\u0007H\u0016¨\u0006\b"}, d2 = {"Landroidx/compose/ui/platform/ViewCompositionStrategy$DisposeOnViewTreeLifecycleDestroyed;", "Landroidx/compose/ui/platform/ViewCompositionStrategy;", "()V", "installFor", "Lkotlin/Function0;", "", "view", "Landroidx/compose/ui/platform/AbstractComposeView;", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class DisposeOnViewTreeLifecycleDestroyed implements ViewCompositionStrategy {
        public static final int $stable = 0;
        public static final DisposeOnViewTreeLifecycleDestroyed INSTANCE = new DisposeOnViewTreeLifecycleDestroyed();

        private DisposeOnViewTreeLifecycleDestroyed() {
        }

        @Override
        public Function0<Unit> installFor(final AbstractComposeView view) throws KotlinNothingValueException {
            if (view.isAttachedToWindow()) {
                LifecycleOwner lifecycleOwner = ViewTreeLifecycleOwner.get(view);
                if (lifecycleOwner != null) {
                    return ViewCompositionStrategy_androidKt.installForLifecycle(view, lifecycleOwner.getLifecycle());
                }
                InlineClassHelperKt.throwIllegalStateExceptionForNullCheck("View tree for " + view + " has no ViewTreeLifecycleOwner");
                throw new KotlinNothingValueException();
            }
            final Ref.ObjectRef objectRef = new Ref.ObjectRef();
            final ?? r1 = new View.OnAttachStateChangeListener() {
                @Override
                public void onViewDetachedFromWindow(View v) {
                }

                @Override
                public void onViewAttachedToWindow(View v) throws KotlinNothingValueException {
                    LifecycleOwner lifecycleOwner2 = ViewTreeLifecycleOwner.get(view);
                    AbstractComposeView abstractComposeView = view;
                    if (lifecycleOwner2 == null) {
                        InlineClassHelperKt.throwIllegalStateExceptionForNullCheck("View tree for " + abstractComposeView + " has no ViewTreeLifecycleOwner");
                        throw new KotlinNothingValueException();
                    }
                    objectRef.element = ViewCompositionStrategy_androidKt.installForLifecycle(abstractComposeView, lifecycleOwner2.getLifecycle());
                    view.removeOnAttachStateChangeListener(this);
                }
            };
            view.addOnAttachStateChangeListener((View.OnAttachStateChangeListener) r1);
            objectRef.element = new Function0<Unit>() {
                {
                    super(0);
                }

                public Object invoke() {
                    m6579invoke();
                    return Unit.INSTANCE;
                }

                public final void m6579invoke() {
                    view.removeOnAttachStateChangeListener(r1);
                }
            };
            return new Function0<Unit>() {
                {
                    super(0);
                }

                public Object invoke() {
                    m6580invoke();
                    return Unit.INSTANCE;
                }

                public final void m6580invoke() {
                    ((Function0) objectRef.element).invoke();
                }
            };
        }
    }
}
