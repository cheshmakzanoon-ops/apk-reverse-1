package net.aihelp.core.p004ui.glide.request.target;

import android.graphics.drawable.Drawable;
import android.widget.ImageView;
import net.aihelp.core.p004ui.glide.request.animation.GlideAnimation;

public abstract class ImageViewTarget<Z> extends ViewTarget<ImageView, Z> implements GlideAnimation.ViewAdapter {
    protected abstract void setResource(Z z);

    public ImageViewTarget(ImageView imageView) {
        super(imageView);
    }

    @Override
    public Drawable getCurrentDrawable() {
        return ((ImageView) this.view).getDrawable();
    }

    @Override
    public void setDrawable(Drawable drawable) {
        ((ImageView) this.view).setImageDrawable(drawable);
    }

    @Override
    public void onLoadStarted(Drawable drawable) {
        ((ImageView) this.view).setImageDrawable(drawable);
    }

    @Override
    public void onLoadFailed(Exception exc, Drawable drawable) {
        ((ImageView) this.view).setImageDrawable(drawable);
    }

    @Override
    public void onLoadCleared(Drawable drawable) {
        ((ImageView) this.view).setImageDrawable(drawable);
    }

    @Override
    public void onResourceReady(Z z, GlideAnimation<? super Z> glideAnimation) {
        if (glideAnimation == null || !glideAnimation.animate(z, this)) {
            setResource(z);
        }
    }
}
