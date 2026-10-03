package net.aihelp.p007ui.widget;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.ViewFlipper;

public class AIHelpViewFlipper extends ViewFlipper {
    public AIHelpViewFlipper(Context context) {
        super(context);
    }

    public AIHelpViewFlipper(Context context, AttributeSet attributeSet) {
        super(context, attributeSet);
    }

    @Override
    protected void onDetachedFromWindow() {
        try {
            super.onDetachedFromWindow();
        } catch (IllegalArgumentException unused) {
            stopFlipping();
        }
    }
}
