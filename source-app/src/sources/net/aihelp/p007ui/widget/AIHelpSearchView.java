package net.aihelp.p007ui.widget;

import android.content.Context;
import android.text.TextWatcher;
import android.util.AttributeSet;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import net.aihelp.common.CustomConfig;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.SoftInputUtil;
import net.aihelp.utils.Styles;

public class AIHelpSearchView extends LinearLayout {
    private final EditText editText;
    private boolean isSearchSessionOpen;
    private OnAIHelpSearchViewListener mListener;
    private final TextView tvCancel;

    public interface OnAIHelpSearchViewListener {
        void onFocusChanged();

        void onInputCanceled();
    }

    public void setupSearchView(OnAIHelpSearchViewListener onAIHelpSearchViewListener, TextWatcher textWatcher) {
        this.mListener = onAIHelpSearchViewListener;
        EditText editText = this.editText;
        if (editText == null || textWatcher == null) {
            return;
        }
        editText.addTextChangedListener(textWatcher);
    }

    public AIHelpSearchView(Context context) {
        this(context, null);
    }

    public AIHelpSearchView(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0);
    }

    public AIHelpSearchView(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        View.inflate(context, ResResolver.getLayoutId("aihelp_layout_search_view"), this);
        findViewById(ResResolver.getViewId("aihelp_ll_search")).setBackground(Styles.getDrawable(Styles.getColorWithAlpha(CustomConfig.CommonSetting.textColor, 0.10000000149011612d), 999));
        Styles.reRenderImageView((ImageView) findViewById(ResResolver.getViewId("aihelp_iv_search")), "aihelp_svg_ic_search_grey", Styles.getColorWithAlpha(CustomConfig.CommonSetting.textColor, 0.5d));
        EditText editText = (EditText) findViewById(ResResolver.getViewId("aihelp_et_search"));
        this.editText = editText;
        Styles.reRenderTextView(editText, CustomConfig.HelpCenter.faqSearchHint);
        TextView textView = (TextView) findViewById(ResResolver.getViewId("aihelp_tv_cancel_search"));
        this.tvCancel = textView;
        Styles.reRenderTextView(textView, ResResolver.getString("aihelp_no"), Styles.getColor(CustomConfig.CommonSetting.interactElementTextColor));
        editText.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public void onFocusChange(View view, boolean z) {
                if (AIHelpSearchView.this.isSearchSessionOpen || !z) {
                    return;
                }
                AIHelpSearchView.this.tvCancel.setVisibility(0);
                AIHelpSearchView.this.isSearchSessionOpen = true;
                if (AIHelpSearchView.this.mListener != null) {
                    AIHelpSearchView.this.mListener.onFocusChanged();
                }
            }
        });
        textView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                AIHelpSearchView.this.clearInputFocus();
            }
        });
    }

    public void clearInputFocus() {
        this.tvCancel.setVisibility(8);
        this.editText.setText("");
        this.editText.clearFocus();
        if (getContext() != null) {
            SoftInputUtil.hideSoftInput(getContext(), this.editText);
        }
        OnAIHelpSearchViewListener onAIHelpSearchViewListener = this.mListener;
        if (onAIHelpSearchViewListener != null) {
            onAIHelpSearchViewListener.onInputCanceled();
        }
        this.isSearchSessionOpen = false;
    }

    public void autoFocus() {
        this.editText.setText("");
        this.editText.requestFocus();
        if (getContext() != null) {
            SoftInputUtil.showSoftInput(getContext(), this.editText);
        }
    }
}
