package net.aihelp.core.p004ui.glide.request.target;

import android.graphics.drawable.Drawable;
import net.aihelp.core.p004ui.glide.request.Request;

public abstract class BaseTarget<Z> implements Target<Z> {
    private Request request;

    @Override
    public void onDestroy() {
    }

    @Override
    public void onLoadCleared(Drawable drawable) {
    }

    @Override
    public void onLoadFailed(Exception exc, Drawable drawable) {
    }

    @Override
    public void onLoadStarted(Drawable drawable) {
    }

    @Override
    public void onStart() {
    }

    @Override
    public void onStop() {
    }

    @Override
    public void setRequest(Request request) {
        this.request = request;
    }

    @Override
    public Request getRequest() {
        return this.request;
    }
}
