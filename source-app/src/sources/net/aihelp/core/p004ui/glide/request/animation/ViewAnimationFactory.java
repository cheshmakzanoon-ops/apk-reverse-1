package net.aihelp.core.p004ui.glide.request.animation;

import android.content.Context;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;

public class ViewAnimationFactory<R> implements GlideAnimationFactory<R> {
    private final ViewAnimation.AnimationFactory animationFactory;
    private GlideAnimation<R> glideAnimation;

    public ViewAnimationFactory(Animation animation) {
        this(new ConcreteAnimationFactory(animation));
    }

    public ViewAnimationFactory(Context context, int i) {
        this(new ResourceAnimationFactory(context, i));
    }

    ViewAnimationFactory(ViewAnimation.AnimationFactory animationFactory) {
        this.animationFactory = animationFactory;
    }

    @Override
    public GlideAnimation<R> build(boolean z, boolean z2) {
        if (z || !z2) {
            return NoAnimation.get();
        }
        if (this.glideAnimation == null) {
            this.glideAnimation = new ViewAnimation(this.animationFactory);
        }
        return this.glideAnimation;
    }

    private static class ConcreteAnimationFactory implements ViewAnimation.AnimationFactory {
        private final Animation animation;

        public ConcreteAnimationFactory(Animation animation) {
            this.animation = animation;
        }

        @Override
        public Animation build() {
            return this.animation;
        }
    }

    private static class ResourceAnimationFactory implements ViewAnimation.AnimationFactory {
        private final int animationId;
        private final Context context;

        public ResourceAnimationFactory(Context context, int i) {
            this.context = context.getApplicationContext();
            this.animationId = i;
        }

        @Override
        public Animation build() {
            return AnimationUtils.loadAnimation(this.context, this.animationId);
        }
    }
}
