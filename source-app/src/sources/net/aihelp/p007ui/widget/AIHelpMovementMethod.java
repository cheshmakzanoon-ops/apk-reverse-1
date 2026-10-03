package net.aihelp.p007ui.widget;

import android.text.Selection;
import android.text.Spannable;
import android.text.method.LinkMovementMethod;
import android.widget.TextView;

public class AIHelpMovementMethod extends LinkMovementMethod {
    @Override
    public boolean canSelectArbitrarily() {
        return true;
    }

    @Override
    public void initialize(TextView textView, Spannable spannable) {
        Selection.setSelection(spannable, spannable.length());
    }

    @Override
    public void onTakeFocus(TextView textView, Spannable spannable, int i) {
        if ((i & 130) != 0) {
            if (textView.getLayout() == null) {
                Selection.setSelection(spannable, spannable.length());
                return;
            }
            return;
        }
        Selection.setSelection(spannable, spannable.length());
    }
}
