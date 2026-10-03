package net.aihelp.p007ui.widget;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import net.aihelp.common.CustomConfig;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.Styles;

public class AIHelpFakeSearch extends LinearLayout {
    public AIHelpFakeSearch(Context context) {
        this(context, null);
    }

    public AIHelpFakeSearch(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0);
    }

    public AIHelpFakeSearch(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        View.inflate(context, ResResolver.getLayoutId("aihelp_layout_fake_search"), this);
        findViewById(ResResolver.getViewId("aihelp_ll_search")).setBackground(Styles.getDrawable(Styles.getColorWithAlpha(CustomConfig.CommonSetting.textColor, 0.1d), 999));
        Styles.reRenderImageView((ImageView) findViewById(ResResolver.getViewId("aihelp_iv_search")), "aihelp_svg_ic_search_grey", Styles.getColorWithAlpha(CustomConfig.CommonSetting.textColor, 0.5d));
        TextView textView = (TextView) findViewById(ResResolver.getViewId("aihelp_tv_search_hint"));
        textView.setText(CustomConfig.HelpCenter.faqSearchHint);
        textView.setTextColor(Styles.getColorWithAlpha(CustomConfig.CommonSetting.textColor, 0.3499999940395355d));
    }
}
