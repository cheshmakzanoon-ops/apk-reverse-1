package com.google.android.material.navigationrail;

import android.content.Context;
import android.view.View;
import com.google.android.material.C0017R;
import com.google.android.material.navigation.NavigationBarItemView;

final class NavigationRailItemView extends NavigationBarItemView {
    public NavigationRailItemView(Context context) {
        super(context);
    }

    @Override
    protected void onMeasure(int i, int i2) {
        super.onMeasure(i, i2);
        if (View.MeasureSpec.getMode(i2) == 0) {
            setMeasuredDimension(getMeasuredWidthAndState(), Math.max(getMeasuredHeight(), View.MeasureSpec.getSize(i2)));
        }
    }

    @Override
    protected int getItemLayoutResId() {
        return C0017R.layout.mtrl_navigation_rail_item;
    }

    @Override
    protected int getItemDefaultMarginResId() {
        return C0017R.dimen.mtrl_navigation_rail_icon_margin;
    }
}
