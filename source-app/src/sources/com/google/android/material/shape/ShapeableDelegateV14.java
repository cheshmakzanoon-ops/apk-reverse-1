package com.google.android.material.shape;

import android.view.View;

class ShapeableDelegateV14 extends ShapeableDelegate {
    @Override
    boolean shouldUseCompatClipping() {
        return true;
    }

    ShapeableDelegateV14() {
    }

    @Override
    void invalidateClippingMethod(View view) {
        if (this.shapeAppearanceModel == null || this.maskBounds.isEmpty() || !shouldUseCompatClipping()) {
            return;
        }
        view.invalidate();
    }
}
