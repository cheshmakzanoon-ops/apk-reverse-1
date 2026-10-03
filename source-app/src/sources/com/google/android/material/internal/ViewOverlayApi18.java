package com.google.android.material.internal;

import android.graphics.drawable.Drawable;
import android.view.View;
import android.view.ViewOverlay;

class ViewOverlayApi18 implements ViewOverlayImpl {
    private final ViewOverlay viewOverlay;

    ViewOverlayApi18(View view) {
        this.viewOverlay = view.getOverlay();
    }

    @Override
    public void add(Drawable drawable) {
        this.viewOverlay.add(drawable);
    }

    @Override
    public void remove(Drawable drawable) {
        this.viewOverlay.remove(drawable);
    }
}
