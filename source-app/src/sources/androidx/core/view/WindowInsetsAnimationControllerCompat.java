package androidx.core.view;

import android.view.WindowInsetsAnimationController;
import androidx.activity.ComponentDialog$;
import androidx.core.graphics.Insets;

public final class WindowInsetsAnimationControllerCompat {
    private final Impl mImpl;

    WindowInsetsAnimationControllerCompat(WindowInsetsAnimationController windowInsetsAnimationController) {
        this.mImpl = new Impl30(windowInsetsAnimationController);
    }

    public Insets getHiddenStateInsets() {
        return this.mImpl.getHiddenStateInsets();
    }

    public Insets getShownStateInsets() {
        return this.mImpl.getShownStateInsets();
    }

    public Insets getCurrentInsets() {
        return this.mImpl.getCurrentInsets();
    }

    public float getCurrentFraction() {
        return this.mImpl.getCurrentFraction();
    }

    public float getCurrentAlpha() {
        return this.mImpl.getCurrentAlpha();
    }

    public int getTypes() {
        return this.mImpl.getTypes();
    }

    public void setInsetsAndAlpha(Insets insets, float f, float f2) {
        this.mImpl.setInsetsAndAlpha(insets, f, f2);
    }

    public void finish(boolean z) {
        this.mImpl.finish(z);
    }

    public boolean isReady() {
        return (isFinished() || isCancelled()) ? false : true;
    }

    public boolean isFinished() {
        return this.mImpl.isFinished();
    }

    public boolean isCancelled() {
        return this.mImpl.isCancelled();
    }

    private static class Impl {
        void finish(boolean z) {
        }

        public float getCurrentAlpha() {
            return 0.0f;
        }

        public float getCurrentFraction() {
            return 0.0f;
        }

        public int getTypes() {
            return 0;
        }

        boolean isCancelled() {
            return true;
        }

        boolean isFinished() {
            return false;
        }

        public void setInsetsAndAlpha(Insets insets, float f, float f2) {
        }

        Impl() {
        }

        public Insets getHiddenStateInsets() {
            return Insets.NONE;
        }

        public Insets getShownStateInsets() {
            return Insets.NONE;
        }

        public Insets getCurrentInsets() {
            return Insets.NONE;
        }
    }

    private static class Impl30 extends Impl {
        private final WindowInsetsAnimationController mController;

        Impl30(WindowInsetsAnimationController windowInsetsAnimationController) {
            this.mController = windowInsetsAnimationController;
        }

        @Override
        public Insets getHiddenStateInsets() {
            return Insets.toCompatInsets(ComponentDialog$.ExternalSyntheticApiModelOutline0.m$1(this.mController));
        }

        @Override
        public Insets getShownStateInsets() {
            return Insets.toCompatInsets(ComponentDialog$.ExternalSyntheticApiModelOutline0.m$2(this.mController));
        }

        @Override
        public Insets getCurrentInsets() {
            return Insets.toCompatInsets(ComponentDialog$.ExternalSyntheticApiModelOutline0.m(this.mController));
        }

        @Override
        public float getCurrentFraction() {
            return this.mController.getCurrentFraction();
        }

        @Override
        public float getCurrentAlpha() {
            return this.mController.getCurrentAlpha();
        }

        @Override
        public int getTypes() {
            return this.mController.getTypes();
        }

        @Override
        public void setInsetsAndAlpha(Insets insets, float f, float f2) {
            ComponentDialog$.ExternalSyntheticApiModelOutline0.m(this.mController, insets == null ? null : insets.toPlatformInsets(), f, f2);
        }

        @Override
        void finish(boolean z) {
            ComponentDialog$.ExternalSyntheticApiModelOutline0.m(this.mController, z);
        }

        @Override
        boolean isFinished() {
            return this.mController.isFinished();
        }

        @Override
        boolean isCancelled() {
            return this.mController.isCancelled();
        }
    }
}
