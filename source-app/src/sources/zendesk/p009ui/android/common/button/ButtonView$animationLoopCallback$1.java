package zendesk.p009ui.android.common.button;

import android.graphics.drawable.Drawable;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.vectordrawable.graphics.drawable.Animatable2Compat;
import androidx.vectordrawable.graphics.drawable.AnimatedVectorDrawableCompat;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000\u0017\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000*\u0001\u0000\b\n\u0018\u00002\u00020\u0001J\u0010\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0005H\u0016¨\u0006\u0006"}, d2 = {"zendesk/ui/android/common/button/ButtonView$animationLoopCallback$1", "Landroidx/vectordrawable/graphics/drawable/Animatable2Compat$AnimationCallback;", "onAnimationEnd", "", "drawable", "Landroid/graphics/drawable/Drawable;", "zendesk.ui_ui-android"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class ButtonView$animationLoopCallback$1 extends Animatable2Compat.AnimationCallback {
    final ButtonView this$0;

    ButtonView$animationLoopCallback$1(ButtonView buttonView) {
        this.this$0 = buttonView;
    }

    public static final void onAnimationEnd$lambda$0(ButtonView buttonView) {
        Intrinsics.checkNotNullParameter(buttonView, "this$0");
        AnimatedVectorDrawableCompat animatedVectorDrawableCompat = buttonView.loadingAnimation;
        if (animatedVectorDrawableCompat != null) {
            animatedVectorDrawableCompat.start();
        }
    }

    @Override
    public void onAnimationEnd(Drawable drawable) {
        Intrinsics.checkNotNullParameter(drawable, "drawable");
        if (this.this$0.rendering.getState().isLoading$zendesk_ui_ui_android()) {
            final ButtonView buttonView = this.this$0;
            new Runnable() {
                @Override
                public final void run() {
                    ButtonView$animationLoopCallback$1.onAnimationEnd$lambda$0(buttonView);
                }
            }.run();
        }
    }
}
