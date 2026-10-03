package net.aihelp.p007ui.widget;

import android.content.Context;
import android.graphics.Color;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;
import net.aihelp.common.CustomConfig;
import net.aihelp.utils.Styles;

public class AIHelpButton extends RelativeLayout {
    public AIHelpButton(Context context) {
        this(context, null);
    }

    public AIHelpButton(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0);
    }

    public AIHelpButton(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        setBackground(Styles.getDrawable(Color.parseColor(CustomConfig.CommonSetting.interactElementTextColor), 8));
        TextView textView = new TextView(context);
        RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(-2, -2);
        layoutParams.addRule(13);
        layoutParams.addRule(9);
        layoutParams.addRule(20);
        textView.setLayoutParams(layoutParams);
        textView.setGravity(17);
        textView.setMinWidth(Styles.dpToPx(context, 84.0f));
        textView.setMinHeight(Styles.dpToPx(context, 28.0f));
        textView.setBackground(Styles.getClickableDrawableForButton());
        textView.setTextColor(-1);
        textView.setTextSize(2, 15.0f);
        textView.setMaxLines(1);
        textView.setSingleLine();
        textView.setEllipsize(TextUtils.TruncateAt.END);
        textView.setPadding(Styles.dpToPx(context, 12.0f), Styles.dpToPx(context, 7.0f), Styles.dpToPx(context, 12.0f), Styles.dpToPx(context, 7.0f));
        addView(textView);
    }

    public AIHelpButton setText(String str) {
        View childAt = getChildAt(0);
        if (childAt instanceof TextView) {
            ((TextView) childAt).setText(str);
        }
        return this;
    }

    public AIHelpButton setMaxWidth(int i) {
        View childAt = getChildAt(0);
        if (childAt instanceof TextView) {
            ((TextView) childAt).setMaxWidth(i);
        }
        return this;
    }

    public AIHelpButton setFullWidth() {
        View childAt = getChildAt(0);
        if (childAt instanceof TextView) {
            TextView textView = (TextView) childAt;
            ViewGroup.LayoutParams layoutParams = textView.getLayoutParams();
            layoutParams.width = -1;
            textView.setLayoutParams(layoutParams);
        }
        return this;
    }

    public String getText() {
        View childAt = getChildAt(0);
        if (childAt instanceof TextView) {
            return ((TextView) childAt).getText().toString();
        }
        return "";
    }
}
