package net.aihelp.p007ui.p009cs.middle.intent;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import androidx.recyclerview.widget.RecyclerView;
import net.aihelp.utils.Styles;

public class SmartIntentRecyclerView extends RecyclerView {
    public SmartIntentRecyclerView(Context context) {
        this(context, null);
    }

    public SmartIntentRecyclerView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0);
    }

    public SmartIntentRecyclerView(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
    }

    protected void onMeasure(int i, int i2) {
        super.onMeasure(View.MeasureSpec.makeMeasureSpec(Styles.getScreenWidth(getContext()), 1073741824), View.MeasureSpec.makeMeasureSpec(Math.min((int) ((Styles.isLandscape() ? 0.8f : 0.7f) * (Styles.getScreenHeight(getContext()) - Styles.dpToPx(getContext(), 150.0f))), Styles.dpToPx(getContext(), 140.0f)), Integer.MIN_VALUE));
    }
}
