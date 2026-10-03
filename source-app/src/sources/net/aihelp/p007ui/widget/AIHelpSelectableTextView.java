package net.aihelp.p007ui.widget;

import android.content.Context;
import android.text.Selection;
import android.text.Spannable;
import android.util.AttributeSet;
import android.view.MotionEvent;
import androidx.appcompat.widget.AppCompatTextView;

public class AIHelpSelectableTextView extends AppCompatTextView {
    public AIHelpSelectableTextView(Context context) {
        super(context);
        setTextIsSelectable(true);
    }

    public AIHelpSelectableTextView(Context context, AttributeSet attributeSet) {
        super(context, attributeSet);
        setTextIsSelectable(true);
    }

    public AIHelpSelectableTextView(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        setTextIsSelectable(true);
    }

    public boolean dispatchTouchEvent(MotionEvent motionEvent) {
        int selectionStart = getSelectionStart();
        int selectionEnd = getSelectionEnd();
        if (selectionStart < 0 || selectionEnd < 0) {
            Selection.setSelection((Spannable) getText(), getText().length());
        } else if (selectionStart != selectionEnd && motionEvent.getActionMasked() == 0) {
            CharSequence text = getText();
            setText(null);
            setText(text);
        }
        return super.dispatchTouchEvent(motionEvent);
    }
}
