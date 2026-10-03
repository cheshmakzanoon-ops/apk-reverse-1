package androidx.core.view;

import android.R;
import android.os.Build;
import android.view.View;
import android.view.WindowInsets;
import android.view.WindowInsetsController;
import android.view.inputmethod.InputMethodManager;
import androidx.activity.ComponentDialog$;
import java.util.concurrent.atomic.AtomicBoolean;

public final class SoftwareKeyboardControllerCompat {
    private final Impl mImpl;

    public SoftwareKeyboardControllerCompat(View view) {
        if (Build.VERSION.SDK_INT >= 30) {
            this.mImpl = new Impl30(view);
        } else {
            this.mImpl = new Impl20(view);
        }
    }

    @Deprecated
    SoftwareKeyboardControllerCompat(WindowInsetsController windowInsetsController) {
        this.mImpl = new Impl30(windowInsetsController);
    }

    public void show() {
        this.mImpl.show();
    }

    public void hide() {
        this.mImpl.hide();
    }

    private static class Impl {
        void hide() {
        }

        void show() {
        }

        Impl() {
        }
    }

    static class Impl20 extends Impl {
        private final View mView;

        Impl20(View view) {
            this.mView = view;
        }

        @Override
        void show() {
            final View viewFindViewById = this.mView;
            if (viewFindViewById == null) {
                return;
            }
            if (viewFindViewById.isInEditMode() || viewFindViewById.onCheckIsTextEditor()) {
                viewFindViewById.requestFocus();
            } else {
                viewFindViewById = viewFindViewById.getRootView().findFocus();
            }
            if (viewFindViewById == null) {
                viewFindViewById = this.mView.getRootView().findViewById(R.id.content);
            }
            if (viewFindViewById == null || !viewFindViewById.hasWindowFocus()) {
                return;
            }
            viewFindViewById.post(new Runnable() {
                @Override
                public final void run() {
                    View view = viewFindViewById;
                    ((InputMethodManager) view.getContext().getSystemService("input_method")).showSoftInput(view, 0);
                }
            });
        }

        @Override
        void hide() {
            View view = this.mView;
            if (view != null) {
                ((InputMethodManager) view.getContext().getSystemService("input_method")).hideSoftInputFromWindow(this.mView.getWindowToken(), 0);
            }
        }
    }

    static class Impl30 extends Impl20 {
        private View mView;
        private WindowInsetsController mWindowInsetsController;

        Impl30(View view) {
            super(view);
            this.mView = view;
        }

        Impl30(WindowInsetsController windowInsetsController) {
            super(null);
            this.mWindowInsetsController = windowInsetsController;
        }

        @Override
        void show() {
            if (this.mView != null && Build.VERSION.SDK_INT < 33) {
                ((InputMethodManager) this.mView.getContext().getSystemService("input_method")).isActive();
            }
            WindowInsetsController windowInsetsControllerM = this.mWindowInsetsController;
            if (windowInsetsControllerM == null) {
                View view = this.mView;
                windowInsetsControllerM = view != null ? ComponentDialog$.ExternalSyntheticApiModelOutline0.m(view) : null;
            }
            if (windowInsetsControllerM != null) {
                windowInsetsControllerM.show(WindowInsets.Type.ime());
            }
            super.show();
        }

        @Override
        void hide() {
            View view;
            WindowInsetsController windowInsetsControllerM = this.mWindowInsetsController;
            if (windowInsetsControllerM == null) {
                View view2 = this.mView;
                windowInsetsControllerM = view2 != null ? ComponentDialog$.ExternalSyntheticApiModelOutline0.m(view2) : null;
            }
            if (windowInsetsControllerM != null) {
                final AtomicBoolean atomicBoolean = new AtomicBoolean(false);
                WindowInsetsController.OnControllableInsetsChangedListener onControllableInsetsChangedListener = new WindowInsetsController.OnControllableInsetsChangedListener() {
                    @Override
                    public final void onControllableInsetsChanged(WindowInsetsController windowInsetsController, int i) {
                        atomicBoolean.set((i & 8) != 0);
                    }
                };
                windowInsetsControllerM.addOnControllableInsetsChangedListener(onControllableInsetsChangedListener);
                if (!atomicBoolean.get() && (view = this.mView) != null) {
                    ((InputMethodManager) view.getContext().getSystemService("input_method")).hideSoftInputFromWindow(this.mView.getWindowToken(), 0);
                }
                windowInsetsControllerM.removeOnControllableInsetsChangedListener(onControllableInsetsChangedListener);
                windowInsetsControllerM.hide(WindowInsets.Type.ime());
                return;
            }
            super.hide();
        }
    }
}
