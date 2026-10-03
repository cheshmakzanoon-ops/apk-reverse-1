package net.aihelp.core.p004ui.glide.request.target;

import net.aihelp.core.p004ui.glide.Glide;
import net.aihelp.core.p004ui.glide.request.animation.GlideAnimation;

public final class PreloadTarget<Z> extends SimpleTarget<Z> {
    public static <Z> PreloadTarget<Z> obtain(int i, int i2) {
        return new PreloadTarget<>(i, i2);
    }

    private PreloadTarget(int i, int i2) {
        super(i, i2);
    }

    @Override
    public void onResourceReady(Z z, GlideAnimation<? super Z> glideAnimation) {
        Glide.clear(this);
    }
}
