package net.aihelp.p007ui.widget;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.ScrollView;

public class AIHelpScrollView extends ScrollView {
    public AIHelpScrollView(Context context) {
        this(context, null);
    }

    public AIHelpScrollView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0);
    }

    public AIHelpScrollView(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
    }

    @Override
    protected void onMeasure(int i, int i2) {
        super.onMeasure(i, i2);
    }
}
