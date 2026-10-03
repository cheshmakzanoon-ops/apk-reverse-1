package net.aihelp.core.p004ui.glide.util;

import android.view.View;
import java.util.Arrays;
import net.aihelp.core.p004ui.glide.ListPreloader;
import net.aihelp.core.p004ui.glide.request.animation.GlideAnimation;
import net.aihelp.core.p004ui.glide.request.target.SizeReadyCallback;
import net.aihelp.core.p004ui.glide.request.target.ViewTarget;

public class ViewPreloadSizeProvider<T> implements ListPreloader.PreloadSizeProvider<T>, SizeReadyCallback {
    private int[] size;
    private SizeViewTarget viewTarget;

    public ViewPreloadSizeProvider() {
    }

    public ViewPreloadSizeProvider(View view) {
        setView(view);
    }

    @Override
    public int[] getPreloadSize(T t, int i, int i2) {
        int[] iArr = this.size;
        if (iArr == null) {
            return null;
        }
        return Arrays.copyOf(iArr, iArr.length);
    }

    @Override
    public void onSizeReady(int i, int i2) {
        this.size = new int[]{i, i2};
        this.viewTarget = null;
    }

    public void setView(View view) {
        if (this.size == null && this.viewTarget == null) {
            this.viewTarget = new SizeViewTarget(view, this);
        }
    }

    private static final class SizeViewTarget extends ViewTarget<View, Object> {
        @Override
        public void onResourceReady(Object obj, GlideAnimation glideAnimation) {
        }

        public SizeViewTarget(View view, SizeReadyCallback sizeReadyCallback) {
            super(view);
            getSize(sizeReadyCallback);
        }
    }
}
