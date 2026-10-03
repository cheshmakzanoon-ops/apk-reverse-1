package net.aihelp.p007ui.adapter.faq;

import android.content.Context;
import android.graphics.Color;
import android.text.SpannableString;
import android.text.TextUtils;
import android.text.style.ForegroundColorSpan;
import android.view.View;
import android.widget.TextView;
import net.aihelp.common.CustomConfig;
import net.aihelp.core.p004ui.adapter.CommonAdapter;
import net.aihelp.core.p004ui.adapter.ViewHolder;
import net.aihelp.data.model.faq.FaqListEntity;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.Styles;

public class FaqAlertAdapter extends CommonAdapter<FaqListEntity> {
    private View.OnClickListener mListener;

    public FaqAlertAdapter(Context context, View.OnClickListener onClickListener) {
        super(context);
        this.mListener = onClickListener;
    }

    @Override
    protected int itemLayoutId() {
        return ResResolver.getLayoutId("aihelp_ada_faq_alert");
    }

    @Override
    public void convert(ViewHolder viewHolder, FaqListEntity faqListEntity, int i) {
        TextView textView = (TextView) viewHolder.getView(ResResolver.getViewId("aihelp_tv_faq_title"));
        textView.setBackgroundColor(Styles.getColorWithAlpha(CustomConfig.CommonSetting.upperBackgroundColor, Math.min(CustomConfig.CommonSetting.upperBackgroundAlpha + 0.6d, 0.8d)));
        textView.setTextColor(Styles.getColor(CustomConfig.CommonSetting.textColor));
        if (!TextUtils.isEmpty(faqListEntity.getQuery())) {
            String lowerCase = faqListEntity.getQuery().toLowerCase();
            String lowerCase2 = faqListEntity.getTitle().toLowerCase();
            int color = Color.parseColor(CustomConfig.CommonSetting.highlightedColor);
            SpannableString spannableString = new SpannableString(faqListEntity.getTitle());
            int length = 0;
            while (true) {
                int iIndexOf = TextUtils.indexOf(lowerCase2, lowerCase, length);
                if (iIndexOf < 0) {
                    break;
                }
                spannableString.setSpan(new ForegroundColorSpan(color), iIndexOf, lowerCase.length() + iIndexOf, 33);
                length = iIndexOf + lowerCase.length();
            }
            textView.setText(spannableString);
        } else {
            textView.setText(faqListEntity.getTitle());
        }
        textView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (FaqAlertAdapter.this.mListener != null) {
                    FaqAlertAdapter.this.mListener.onClick(view);
                }
            }
        });
    }
}
