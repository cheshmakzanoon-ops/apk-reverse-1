package net.aihelp.core.p004ui.glide.request.target;

import android.graphics.drawable.Drawable;
import net.aihelp.core.p004ui.glide.manager.LifecycleListener;
import net.aihelp.core.p004ui.glide.request.Request;
import net.aihelp.core.p004ui.glide.request.animation.GlideAnimation;

public interface Target<R> extends LifecycleListener {
    public static final int SIZE_ORIGINAL = Integer.MIN_VALUE;

    Request getRequest();

    void getSize(SizeReadyCallback sizeReadyCallback);

    void onLoadCleared(Drawable drawable);

    void onLoadFailed(Exception exc, Drawable drawable);

    void onLoadStarted(Drawable drawable);

    void onResourceReady(R r, GlideAnimation<? super R> glideAnimation);

    void setRequest(Request request);
}
