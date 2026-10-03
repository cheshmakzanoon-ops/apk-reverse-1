package zendesk.p026ui.android.conversation.actionbutton;

import android.graphics.drawable.Drawable;
import androidx.vectordrawable.graphics.drawable.Animatable2Compat;
import androidx.vectordrawable.graphics.drawable.AnimatedVectorDrawableCompat;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\u0017\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000*\u0001\u0000\b\n\u0018\u00002\u00020\u0001J\u0010\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0005H\u0016¨\u0006\u0006"}, m18d2 = {"zendesk/ui/android/conversation/actionbutton/ActionButtonView$animationLoopCallback$1", "Landroidx/vectordrawable/graphics/drawable/Animatable2Compat$AnimationCallback;", "onAnimationEnd", "", "drawable", "Landroid/graphics/drawable/Drawable;", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ActionButtonView$animationLoopCallback$1 extends Animatable2Compat.AnimationCallback {
    final ActionButtonView this$0;

    ActionButtonView$animationLoopCallback$1(ActionButtonView actionButtonView) {
        this.this$0 = actionButtonView;
    }

    public static final void onAnimationEnd$lambda$0(ActionButtonView this$0) {
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        AnimatedVectorDrawableCompat animatedVectorDrawableCompat = this$0.loadingAnimation;
        if (animatedVectorDrawableCompat != null) {
            animatedVectorDrawableCompat.start();
        }
    }

    public void onAnimationEnd(Drawable drawable) {
        Intrinsics.checkNotNullParameter(drawable, "drawable");
        if (this.this$0.rendering.getState().isLoading$zendesk_ui_ui_android()) {
            final ActionButtonView actionButtonView = this.this$0;
            new Runnable() {
                @Override
                public final void run() {
                    ActionButtonView$animationLoopCallback$1.onAnimationEnd$lambda$0(actionButtonView);
                }
            }.run();
        }
    }
}
