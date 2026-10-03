package net.aihelp.core.p004ui.glide.request.animation;

import android.view.View;
import android.view.animation.Animation;

public class ViewAnimation<R> implements GlideAnimation<R> {
    private final AnimationFactory animationFactory;

    interface AnimationFactory {
        Animation build();
    }

    ViewAnimation(AnimationFactory animationFactory) {
        this.animationFactory = animationFactory;
    }

    @Override
    public boolean animate(R r, GlideAnimation.ViewAdapter viewAdapter) {
        View view = viewAdapter.getView();
        if (view == null) {
            return false;
        }
        view.clearAnimation();
        view.startAnimation(this.animationFactory.build());
        return false;
    }
}
