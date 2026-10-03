package net.aihelp.p007ui.widget;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import androidx.appcompat.widget.AppCompatTextView;

public class AIHelpTextView extends AppCompatTextView {
    public AIHelpTextView(Context context) {
        super(context);
    }

    public AIHelpTextView(Context context, AttributeSet attributeSet) {
        super(context, attributeSet);
    }

    public AIHelpTextView(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
    }

    protected void onDraw(Canvas canvas) {
        Drawable[] compoundDrawables = getCompoundDrawables();
        if (compoundDrawables[0] != null) {
            canvas.translate((getWidth() - ((getPaint().measureText(getText().toString()) + compoundDrawables[0].getIntrinsicWidth()) + getCompoundDrawablePadding())) / 2.0f, 0.0f);
        } else if (compoundDrawables[2] != null) {
            canvas.translate((-(getWidth() - ((getPaint().measureText(getText().toString()) + compoundDrawables[2].getIntrinsicWidth()) + getCompoundDrawablePadding()))) / 2.0f, 0.0f);
        }
        super.onDraw(canvas);
    }
}
