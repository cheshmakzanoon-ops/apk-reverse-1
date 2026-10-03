package net.aihelp.core.p004ui.glide.request.animation;

public class NoAnimation<R> implements GlideAnimation<R> {
    private static final NoAnimation<?> NO_ANIMATION = new NoAnimation<>();
    private static final GlideAnimationFactory<?> NO_ANIMATION_FACTORY = new NoAnimationFactory();

    @Override
    public boolean animate(Object obj, GlideAnimation.ViewAdapter viewAdapter) {
        return false;
    }

    public static class NoAnimationFactory<R> implements GlideAnimationFactory<R> {
        @Override
        public GlideAnimation<R> build(boolean z, boolean z2) {
            return NoAnimation.NO_ANIMATION;
        }
    }

    public static <R> GlideAnimationFactory<R> getFactory() {
        return (GlideAnimationFactory<R>) NO_ANIMATION_FACTORY;
    }

    public static <R> GlideAnimation<R> get() {
        return NO_ANIMATION;
    }
}
