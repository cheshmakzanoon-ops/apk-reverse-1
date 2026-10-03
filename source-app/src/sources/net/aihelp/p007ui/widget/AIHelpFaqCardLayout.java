package net.aihelp.p007ui.widget;

import android.content.Context;
import android.graphics.Typeface;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import androidx.appcompat.widget.AppCompatImageView;
import androidx.appcompat.widget.AppCompatTextView;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import net.aihelp.common.CustomConfig;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.Styles;

public class AIHelpFaqCardLayout extends LinearLayout {
    private RecyclerView.Adapter adapter;
    private final AppCompatImageView ivTitle;
    private final RelativeLayout rlRoot;
    private final RecyclerView rvList;
    private final AppCompatTextView tvTitle;

    public AIHelpFaqCardLayout(Context context) {
        this(context, null);
    }

    public AIHelpFaqCardLayout(Context context, AttributeSet attributeSet) {
        this(context, attributeSet, 0);
    }

    public AIHelpFaqCardLayout(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        View.inflate(context, ResResolver.getLayoutId("aihelp_layout_faq_card_layout"), this);
        RelativeLayout relativeLayout = (RelativeLayout) findViewById(ResResolver.getViewId("aihelp_rl_list"));
        this.rlRoot = relativeLayout;
        relativeLayout.setBackground(Styles.getDrawable(Styles.getColorWithAlpha(CustomConfig.CommonSetting.upperBackgroundColor, CustomConfig.CommonSetting.upperBackgroundAlpha), 15));
        this.ivTitle = findViewById(ResResolver.getViewId("aihelp_iv_title"));
        AppCompatTextView appCompatTextViewFindViewById = findViewById(ResResolver.getViewId("aihelp_tv_title"));
        this.tvTitle = appCompatTextViewFindViewById;
        appCompatTextViewFindViewById.setTextColor(Styles.getColor(CustomConfig.CommonSetting.textColor));
        appCompatTextViewFindViewById.setTypeface((Typeface) null, 1);
        this.rvList = findViewById(ResResolver.getViewId("aihelp_rv_list"));
    }

    private RecyclerView.LayoutManager getLinearLayoutManager(Context context) {
        return new LinearLayoutManager(context) {
            public boolean canScrollVertically() {
                return Styles.isLandscape();
            }
        };
    }

    private RecyclerView.LayoutManager getGridLayoutManager(Context context) {
        final int i = (!Styles.isLandscape() || CustomConfig.HelpCenter.isFaqHotTopicVisible) ? 3 : 4;
        GridLayoutManager gridLayoutManager = new GridLayoutManager(context, i) {
            public boolean canScrollVertically() {
                return Styles.isLandscape();
            }
        };
        if (Styles.isLandscape()) {
            gridLayoutManager.setSpanSizeLookup(new GridLayoutManager.SpanSizeLookup() {
                public int getSpanSize(int i2) {
                    if (i2 == AIHelpFaqCardLayout.this.adapter.getItemCount() - 1) {
                        return i;
                    }
                    return 1;
                }
            });
        }
        return gridLayoutManager;
    }

    public void setup(RecyclerView.Adapter adapter) {
        setup(true, adapter);
    }

    public void setup(boolean z, RecyclerView.Adapter adapter) {
        this.adapter = adapter;
        if (z) {
            this.rvList.setLayoutManager(getLinearLayoutManager(getContext()));
        } else {
            this.rvList.setLayoutManager(getGridLayoutManager(getContext()));
        }
        int iDpToPx = z ? 0 : Styles.dpToPx(getContext(), 8.0f);
        RelativeLayout relativeLayout = this.rlRoot;
        relativeLayout.setPadding(iDpToPx, relativeLayout.getPaddingTop(), iDpToPx, this.rlRoot.getPaddingBottom());
        this.rvList.setAdapter(adapter);
    }

    public void updateTitleIcon(boolean z, String str) {
        if (!z || TextUtils.isEmpty(str)) {
            return;
        }
        this.ivTitle.setVisibility(0);
        Styles.loadIcon(this.ivTitle, str);
    }

    public void updateTitleText(boolean z, String str) {
        if (!z || TextUtils.isEmpty(str)) {
            return;
        }
        this.tvTitle.setVisibility(0);
        Styles.reRenderTextView(this.tvTitle, str);
    }
}
