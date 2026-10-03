package zendesk.p026ui.android.internal;

import android.graphics.drawable.Drawable;
import android.widget.ImageView;
import androidx.vectordrawable.graphics.drawable.Animatable2Compat;
import androidx.vectordrawable.graphics.drawable.AnimatedVectorDrawableCompat;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\u0012\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\u001a\u0018\u0010\u0000\u001a\u0004\u0018\u00010\u0001*\u00020\u00022\b\b\u0001\u0010\u0003\u001a\u00020\u0004H\u0000¨\u0006\u0005"}, m18d2 = {"applyLoopingAnimatedVectorDrawable", "Landroidx/vectordrawable/graphics/drawable/AnimatedVectorDrawableCompat;", "Landroid/widget/ImageView;", "avdResId", "", "zendesk.ui_ui-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class ImageViewExtensionKt {

    @Metadata(m17d1 = {"\u0000\u0017\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000*\u0001\u0000\b\n\u0018\u00002\u00020\u0001J\u0012\u0010\u0002\u001a\u00020\u00032\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005H\u0016¨\u0006\u0006"}, m18d2 = {"zendesk/ui/android/internal/ImageViewExtensionKt$applyLoopingAnimatedVectorDrawable$1", "Landroidx/vectordrawable/graphics/drawable/Animatable2Compat$AnimationCallback;", "onAnimationEnd", "", "drawable", "Landroid/graphics/drawable/Drawable;", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class C16461 extends Animatable2Compat.AnimationCallback {
        final AnimatedVectorDrawableCompat $animated;
        final ImageView $this_applyLoopingAnimatedVectorDrawable;

        C16461(ImageView imageView, AnimatedVectorDrawableCompat animatedVectorDrawableCompat) {
            this.$this_applyLoopingAnimatedVectorDrawable = imageView;
            this.$animated = animatedVectorDrawableCompat;
        }

        public void onAnimationEnd(Drawable drawable) {
            ImageView imageView = this.$this_applyLoopingAnimatedVectorDrawable;
            final AnimatedVectorDrawableCompat animatedVectorDrawableCompat = this.$animated;
            imageView.post(new Runnable() {
                @Override
                public final void run() {
                    animatedVectorDrawableCompat.start();
                }
            });
        }
    }

    public static final AnimatedVectorDrawableCompat applyLoopingAnimatedVectorDrawable(ImageView imageView, int i) {
        Intrinsics.checkNotNullParameter(imageView, "<this>");
        AnimatedVectorDrawableCompat animatedVectorDrawableCompatCreate = AnimatedVectorDrawableCompat.create(imageView.getContext(), i);
        if (animatedVectorDrawableCompatCreate != null) {
            animatedVectorDrawableCompatCreate.registerAnimationCallback(new C16461(imageView, animatedVectorDrawableCompatCreate));
        }
        imageView.setImageDrawable((Drawable) animatedVectorDrawableCompatCreate);
        if (animatedVectorDrawableCompatCreate != null) {
            animatedVectorDrawableCompatCreate.start();
        }
        return animatedVectorDrawableCompatCreate;
    }
}
