package net.aihelp.p007ui.p009cs.middle.intent;

import android.content.Context;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.widget.HorizontalScrollView;
import net.aihelp.utils.Styles;

public class SmartIntentScrollView extends HorizontalScrollView {
    @Override
    public boolean onTouchEvent(MotionEvent motionEvent) {
        return false;
    }

    public SmartIntentScrollView(Context context) {
        this(context, null);
    }

    public SmartIntentScrollView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0);
    }

    public SmartIntentScrollView(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
    }

    public void scrollIntentTo(int i) {
        if (Styles.isLayoutRtl(this)) {
            if (i == 0) {
                fullScroll(66);
                return;
            } else if (i == Integer.MAX_VALUE) {
                fullScroll(17);
                return;
            } else {
                super.scrollTo(i, 0);
                return;
            }
        }
        if (i == 0) {
            fullScroll(17);
        } else if (i == Integer.MAX_VALUE) {
            fullScroll(66);
        } else {
            super.scrollTo(i, 0);
        }
    }

    @Override
    public void fling(int i) {
        super.fling(i / 40);
    }
}
