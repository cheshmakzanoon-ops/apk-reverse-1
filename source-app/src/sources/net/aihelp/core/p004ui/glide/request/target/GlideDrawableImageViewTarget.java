package net.aihelp.core.p004ui.glide.request.target;

import android.widget.ImageView;
import net.aihelp.core.p004ui.glide.load.resource.drawable.GlideDrawable;
import net.aihelp.core.p004ui.glide.request.animation.GlideAnimation;

public class GlideDrawableImageViewTarget extends ImageViewTarget<GlideDrawable> {
    private static final float SQUARE_RATIO_MARGIN = 0.05f;
    private int maxLoopCount;
    private GlideDrawable resource;

    @Override
    public void onResourceReady(Object obj, GlideAnimation glideAnimation) {
        onResourceReady((GlideDrawable) obj, (GlideAnimation<? super GlideDrawable>) glideAnimation);
    }

    public GlideDrawableImageViewTarget(ImageView imageView) {
        this(imageView, -1);
    }

    public GlideDrawableImageViewTarget(ImageView imageView, int i) {
        super(imageView);
        this.maxLoopCount = i;
    }

    public void onResourceReady(GlideDrawable glideDrawable, GlideAnimation<? super GlideDrawable> glideAnimation) {
        if (!glideDrawable.isAnimated()) {
            float width = ((ImageView) this.view).getWidth() / ((ImageView) this.view).getHeight();
            float intrinsicWidth = glideDrawable.getIntrinsicWidth() / glideDrawable.getIntrinsicHeight();
            if (Math.abs(width - 1.0f) <= SQUARE_RATIO_MARGIN && Math.abs(intrinsicWidth - 1.0f) <= SQUARE_RATIO_MARGIN) {
                glideDrawable = new SquaringDrawable(glideDrawable, ((ImageView) this.view).getWidth());
            }
        }
        super.onResourceReady(glideDrawable, glideAnimation);
        this.resource = glideDrawable;
        glideDrawable.setLoopCount(this.maxLoopCount);
        glideDrawable.start();
    }

    @Override
    public void setResource(GlideDrawable glideDrawable) {
        ((ImageView) this.view).setImageDrawable(glideDrawable);
    }

    @Override
    public void onStart() {
        GlideDrawable glideDrawable = this.resource;
        if (glideDrawable != null) {
            glideDrawable.start();
        }
    }

    @Override
    public void onStop() {
        GlideDrawable glideDrawable = this.resource;
        if (glideDrawable != null) {
            glideDrawable.stop();
        }
    }
}
