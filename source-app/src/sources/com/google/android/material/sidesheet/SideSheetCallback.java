package com.google.android.material.sidesheet;

import android.view.View;

public abstract class SideSheetCallback implements SheetCallback {
    void onLayout(View view) {
    }

    @Override
    public abstract void onSlide(View view, float f);

    @Override
    public abstract void onStateChanged(View view, int i);
}
